#!/usr/bin/env python3
"""Local speech captions for video-editors. Uses bundled FFmpeg and whisper.cpp only."""
from __future__ import annotations
import argparse, csv, json, os, re, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
FFMPEG = ROOT / 'tools' / 'ffmpeg' / 'bin' / 'ffmpeg.exe'
WHISPER = ROOT / 'tools' / 'captioning' / 'bin' / 'whisper-bin-x64-b5454' / 'Release' / 'whisper-cli.exe'
MODEL_EN = ROOT / 'tools' / 'captioning' / 'models' / 'ggml-small.en.bin'
MODEL_MULTI = ROOT / 'tools' / 'captioning' / 'models' / 'ggml-small.bin'
EMPHASIS = ROOT / 'tools' / 'opusclip-local' / 'presets' / 'emphasis.json'
STYLE_DEFAULT = ROOT / 'assets' / 'captions' / 'styles' / 'podcast-clean-highlight.json'


def run(cmd: list[str], *, cwd: Path | None = None) -> None:
    result = subprocess.run(cmd, cwd=str(cwd) if cwd else None, check=False, capture_output=True, text=True)
    if result.returncode:
        detail='\n'.join((result.stderr + '\n' + result.stdout).splitlines()[-35:])
        raise RuntimeError(f"Command failed ({result.returncode}): {cmd[0]}\n{detail}")


def parse_ts(value) -> float | None:
    if value is None:
        return None
    if isinstance(value, (int, float)):
        # whisper.cpp JSON offsets are centiseconds.
        return float(value) / 100.0
    s = str(value).strip()
    m = re.fullmatch(r"(?:(\d+):)?(\d{2}):(\d{2})[.,](\d+)", s)
    if not m:
        return None
    h = int(m.group(1) or 0); minute = int(m.group(2)); sec = int(m.group(3))
    frac = float('0.' + m.group(4))
    return h * 3600 + minute * 60 + sec + frac


def word_records(payload: dict) -> list[dict]:
    segs = payload.get('transcription') or payload.get('segments') or []
    words = []
    for seg in segs:
        stamps = seg.get('timestamps') or {}
        offsets = seg.get('offsets') or {}
        start = parse_ts(stamps.get('from'))
        end = parse_ts(stamps.get('to'))
        if start is None:
            start = parse_ts(seg.get('start'))
        if end is None:
            end = parse_ts(seg.get('end'))
        if start is None:
            start = parse_ts(offsets.get('from'))
        if end is None:
            end = parse_ts(offsets.get('to'))
        text = re.sub(r'\s+', ' ', str(seg.get('text', '')).strip())
        if not text or start is None or end is None or end < start:
            continue
        # Do not fabricate word timing if this Whisper build returns a phrase.
        tokens = text.split()
        if len(tokens) != 1:
            raise RuntimeError(f'Whisper returned {len(tokens)} words in one segment despite -ml 1: {text!r}. No word-synced render was made.')
        words.append({'start': start, 'end': end, 'text': tokens[0]})
    return words


def make_chunks(words: list[dict], max_words: int = 5, max_seconds: float = 2.8) -> list[list[dict]]:
    chunks, current = [], []
    for word in words:
        current.append(word)
        text = word['text']
        elapsed = current[-1]['end'] - current[0]['start']
        if len(current) >= max_words or elapsed >= max_seconds or re.search(r'[.!?]["\']?$', text):
            chunks.append(current); current = []
    if current:
        chunks.append(current)
    return chunks


def ass_time(seconds: float) -> str:
    cs = max(0, round(seconds * 100))
    h, cs = divmod(cs, 360000); m, cs = divmod(cs, 6000); s, cs = divmod(cs, 100)
    return f'{h}:{m:02d}:{s:02d}.{cs:02d}'


def safe_ass_text(s: str) -> str:
    return s.replace('\\', '').replace('{', '').replace('}', '').replace('\n', ' ')


def load_emphasis(path: Path, stem: str) -> set[str]:
    if not path.exists():
        return set()
    data = json.loads(path.read_text(encoding='utf-8-sig'))
    keys = []
    for prefix, terms in data.items():
        if stem.lower().startswith(prefix.lower()):
            keys.extend(terms)
    return {re.sub(r'[^\w$]+', '', str(x)).casefold() for x in keys if str(x).strip()}


def render_ass(chunks: list[list[dict]], ass_path: Path, emphasis: set[str], style: dict, karaoke: bool=False) -> None:
    primary = style['highlight_color_ass'] if karaoke else style['base_color_ass']
    secondary = style['base_color_ass'] if karaoke else style['highlight_color_ass']
    bold = -1 if style.get('bold', True) else 0
    style_line = (
        f"Style: Default,{style.get('font_name','Arial')},{int(style.get('font_size',62))},{primary},{secondary},"
        f"{style.get('outline_color_ass','&H002F2114&')},{style.get('back_color_ass','&H64000000&')},{bold},0,0,0,"
        f"100,100,0,0,1,{int(style.get('outline',5))},{int(style.get('shadow',2))},{int(style.get('alignment',2))},"
        f"{int(style.get('margin_left',72))},{int(style.get('margin_right',72))},{int(style.get('margin_vertical',510))},1"
    )
    lines = [
        '[Script Info]', f"Title: {style.get('id','local-caption-style')}", 'ScriptType: v4.00+',
        'WrapStyle: 2', 'ScaledBorderAndShadow: yes', 'PlayResX: 1080', 'PlayResY: 1920', '',
        '[V4+ Styles]',
        'Format: Name,Fontname,Fontsize,PrimaryColour,SecondaryColour,OutlineColour,BackColour,Bold,Italic,Underline,StrikeOut,ScaleX,ScaleY,Spacing,Angle,BorderStyle,Outline,Shadow,Alignment,MarginL,MarginR,MarginV,Encoding',
        style_line, '', '[Events]', 'Format: Layer,Start,End,Style,Name,MarginL,MarginR,MarginV,Effect,Text'
    ]
    previous_end = 0.0
    for chunk in chunks:
        if not chunk:
            continue
        # Break at the most even 2-line point while keeping lines short.
        texts = [safe_ass_text(w['text']) for w in chunk]
        if style.get('uppercase'):
            texts = [text.upper() for text in texts]
        split_at = max(1, min(len(chunk)-1, (len(chunk)+1)//2)) if len(chunk) > 2 else len(chunk)
        out = []
        for i, (word, token) in enumerate(zip(chunk, texts)):
            if i == split_at:
                out.append(r'\N')
            norm = re.sub(r'[^\w$]+', '', token).casefold()
            if karaoke:
                duration = max(1, round((word['end']-word['start'])*100))
                out.append(f'{{\\k{duration}}}{token}')
            elif norm in emphasis:
                out.append(r'{\c' + style.get('highlight_override_ass','&H46BEF7&') + r'\b1}' + token + r'{\c' + style.get('base_override_ass','&HFFFFFF&') + r'\b1}')
            else:
                out.append(token)
            if i < len(chunk)-1 and i+1 != split_at:
                out.append(' ')
        start = max(0, chunk[0]['start'], previous_end)
        end = max(start + 0.6, chunk[-1]['end'] + 0.12)
        previous_end = end
        entrance=style.get('entrance','fade')
        if entrance=='fade': prefix=rf'{{\fad({int(style.get("fade_in_ms",70))},{int(style.get("fade_out_ms",70))})}}'
        elif entrance=='pop': prefix=r'{\fscx90\fscy90\t(0,120,\fscx100\fscy100)}'
        else: prefix=''
        text = prefix + ''.join(out)
        lines.append(f'Dialogue: 0,{ass_time(start)},{ass_time(end)},Default,,0,0,0,,{text}')
    ass_path.write_text('\n'.join(lines)+'\n', encoding='utf-8-sig')


def load_style(path: Path) -> dict:
    style=json.loads(path.read_text(encoding='utf-8-sig'))
    if style.get('entrance','fade') not in {'fade','pop','none'}:
        raise ValueError(f"Unsupported caption entrance in {path}: {style.get('entrance')}")
    return style


def make_srt(chunks: list[list[dict]], path: Path) -> None:
    def srt_ts(t):
        ms=max(0,round(t*1000)); h,ms=divmod(ms,3600000); m,ms=divmod(ms,60000); s,ms=divmod(ms,1000)
        return f'{h:02}:{m:02}:{s:02},{ms:03}'
    rows=[]
    previous_end = 0.0
    for i, c in enumerate(chunks,1):
        words=[safe_ass_text(w['text']) for w in c]
        split=max(1,min(len(words)-1,(len(words)+1)//2)) if len(words)>2 else len(words)
        text=' '.join(words[:split]) + ('\n'+' '.join(words[split:]) if split<len(words) else '')
        start=max(c[0]['start'],previous_end); end=max(start+0.6,c[-1]['end']+0.12); previous_end=end
        rows.append(f'{i}\n{srt_ts(start)} --> {srt_ts(end)}\n{text}')
    path.write_text('\n\n'.join(rows)+'\n',encoding='utf-8-sig')


def main() -> int:
    ap=argparse.ArgumentParser(description='Transcribe locally, create timed ASS/SRT captions, highlight topic keywords, and render captioned MP4 copies.')
    ap.add_argument('--input-dir', required=True, type=Path)
    ap.add_argument('--output-dir', type=Path)
    ap.add_argument('--transcript-dir', type=Path)
    ap.add_argument('--threads', type=int, default=max(1,min(8,(os.cpu_count() or 4)-1)))
    ap.add_argument('--language', choices=['en','tl','auto'], default='en', help='Use en for English, tl for Tagalog, or auto for code-switched/mixed speech.')
    ap.add_argument('--model', type=Path, help='Optional local Whisper model path; default follows --language.')
    ap.add_argument('--prompt', default='', help='Optional topic names/terms to help local Whisper; leave empty for general content.')
    ap.add_argument('--style', type=Path, default=STYLE_DEFAULT, help='Reusable JSON caption style from assets/captions/styles/.')
    ap.add_argument('--karaoke', action='store_true', help='Highlight the active word in each caption instead of only topic keywords.')
    args=ap.parse_args()
    input_dir=args.input_dir.resolve(); output_dir=(args.output_dir or input_dir).resolve()
    transcript_dir=(args.transcript_dir or (ROOT/'industries'/'hip-hop-clipping'/'transcripts'/'ep5')).resolve()
    model_path=(args.model or (MODEL_EN if args.language=='en' else MODEL_MULTI)).resolve()
    style_path=args.style.resolve(); style=load_style(style_path)
    for path in (input_dir, output_dir, transcript_dir): path.mkdir(parents=True,exist_ok=True)
    for required in (FFMPEG,WHISPER,model_path):
        if not required.exists(): raise FileNotFoundError(f'Missing bundled tool/model: {required}')
    videos=sorted(p for p in input_dir.glob('*.mp4') if not p.stem.lower().endswith('_captioned'))
    if not videos: raise FileNotFoundError(f'No MP4 files in {input_dir}')
    manifest=[]
    for video in videos:
        stem=video.stem.removesuffix('_enhanced')
        json_path=transcript_dir/f'{stem}.json'; txt_path=transcript_dir/f'{stem}.txt'
        ass_path=transcript_dir/f'{stem}.ass'; srt_path=transcript_dir/f'{stem}.srt'
        with tempfile.TemporaryDirectory(prefix='opusclip-local-') as temp:
            wav=Path(temp)/'audio.wav'
            run([str(FFMPEG),'-hide_banner','-loglevel','error','-y','-i',str(video),'-map','0:a:0','-vn','-ac','1','-ar','16000','-c:a','pcm_s16le',str(wav)])
            if not json_path.exists():
                print(f'Transcribing {video.name}',flush=True)
                base=json_path.with_suffix('')
                cmd=[str(WHISPER),'-m',str(model_path),'-f',str(wav),'-l',args.language,'-t',str(max(1,args.threads)),'-ml','1','-sow','-oj','-of',str(base)]
                if args.prompt.strip(): cmd += ['--prompt',args.prompt.strip()]
                run(cmd,cwd=ROOT/'tools'/'captioning')
        if not json_path.exists(): raise RuntimeError(f'Whisper did not create {json_path}')
        payload=json.loads(json_path.read_text(encoding='utf-8-sig'))
        words=word_records(payload)
        if not words: raise RuntimeError(f'No timed words found in {json_path}; inspect the Whisper JSON before rendering.')
        chunks=make_chunks(words,int(style.get('max_words',5)),float(style.get('max_caption_seconds',2.8)))
        txt_path.write_text(' '.join(w['text'] for w in words)+'\n',encoding='utf-8-sig')
        make_srt(chunks,srt_path)
        emphasis=load_emphasis(EMPHASIS,stem)
        use_karaoke=args.karaoke or style.get('highlight_mode')=='karaoke'
        render_ass(chunks,ass_path,emphasis,style,use_karaoke)
        dest=output_dir/f'{stem}_captioned.mp4'
        ass_arg=ass_path.name
        run([str(FFMPEG),'-hide_banner','-loglevel','error','-y','-i',str(video),'-vf',f'ass=filename={ass_arg}','-map','0:v:0','-map','0:a?','-c:v','libx264','-preset','veryfast','-crf','18','-pix_fmt','yuv420p','-c:a','copy','-movflags','+faststart',str(dest)],cwd=transcript_dir)
        manifest.append({'input':str(video),'captioned_output':str(dest),'transcript_json':str(json_path),'transcript_txt':str(txt_path),'captions_ass':str(ass_path),'captions_srt':str(srt_path),'word_count':len(words),'language':args.language,'model':str(model_path),'style':style.get('id',style_path.stem),'keyword_highlights':';'.join(sorted(emphasis)),'karaoke_active_word':args.karaoke})
        print(f'Captioned {video.name} -> {dest.name}',flush=True)
    mpath=output_dir/'caption_manifest.csv'
    with mpath.open('w',newline='',encoding='utf-8-sig') as f:
        w=csv.DictWriter(f,fieldnames=list(manifest[0]));w.writeheader();w.writerows(manifest)
    print(f'Complete: {len(manifest)} videos; transcript sidecars: {transcript_dir}',flush=True)
    return 0

if __name__=='__main__':
    try: raise SystemExit(main())
    except Exception as e:
        print(f'ERROR: {e}',file=sys.stderr); raise SystemExit(1)



