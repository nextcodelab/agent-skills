#!/usr/bin/env python3
"""Apply reusable no-blur animated center-zoom moves with the bundled FFmpeg."""
from __future__ import annotations
import argparse,json,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[3]
FFMPEG=ROOT/'tools'/'ffmpeg'/'bin'/'ffmpeg.exe'
FFPROBE=ROOT/'tools'/'ffmpeg'/'bin'/'ffprobe.exe'
PRESETS=ROOT/'tools'/'opusclip-local'/'presets'/'zoom.json'

def probe(path:Path)->dict:
    p=subprocess.run([str(FFPROBE),'-v','error','-show_entries','format=duration:stream=width,height,r_frame_rate,codec_type','-of','json',str(path)],capture_output=True,text=True,check=True)
    j=json.loads(p.stdout); v=next(s for s in j['streams'] if s.get('codec_type')=='video')
    n,d=(v.get('r_frame_rate','24/1').split('/')+[1])[:2]
    return {'width':int(v['width']),'height':int(v['height']),'fps':float(n)/max(1,float(d)),'duration':float(j['format']['duration'])}

def main()->int:
    ap=argparse.ArgumentParser(description='Render a center zoom move on a vertical clip. Source audio is copied unchanged; no blurred canvas is used.')
    ap.add_argument('input',type=Path); ap.add_argument('output',type=Path)
    ap.add_argument('--effect',choices=['slow-in','slow-out','punch-in','punch-out','pulse'],default='slow-in')
    ap.add_argument('--amount',type=float,default=0.12,help='Maximum zoom amount; 0.12 means 12 percent.')
    ap.add_argument('--duration',type=float,default=0.4,help='Punch ramp time in seconds.')
    ap.add_argument('--center-x',type=float,default=0.5,help='Horizontal focus as a fraction from left to right.')
    ap.add_argument('--center-y',type=float,default=0.5,help='Vertical focus as a fraction from top to bottom.')
    ap.add_argument('--overwrite',action='store_true')
    a=ap.parse_args(); source=a.input.resolve(); dest=a.output.resolve()
    if not source.is_file(): raise FileNotFoundError(source)
    if not 0<=a.center_x<=1 or not 0<=a.center_y<=1: raise ValueError('center-x and center-y must be between 0 and 1')
    if a.amount<0 or a.amount>0.35: raise ValueError('amount must be between 0 and 0.35')
    if not FFMPEG.exists() or not FFPROBE.exists(): raise FileNotFoundError('Bundled FFmpeg/ffprobe missing from tools/ffmpeg/')
    meta=probe(source); w,h,fps,dur=meta['width'],meta['height'],meta['fps'],meta['duration']
    if h<=w: raise ValueError(f'Expected a portrait source; got {w}x{h}. Reframe it first.')
    frames=max(2,round(fps*dur)); ramp=max(1,round(fps*a.duration)); amt=a.amount
    curves={
      'slow-in':f"1+{amt}*min(on/{frames-1},1)",
      'slow-out':f"1+{amt}*(1-min(on/{frames-1},1))",
      'punch-in':f"1+{amt}*min(on/{ramp},1)",
      'punch-out':f"1+{amt}*(1-min(on/{ramp},1))",
      'pulse':f"1+{amt/4}*abs(sin(6.28318530718*on/{fps}*1.4))"
    }
    z=curves[a.effect]
    x=f"max(0,min(iw-iw/zoom,(iw-iw/zoom)*{a.center_x}))"
    y=f"max(0,min(ih-ih/zoom,(ih-ih/zoom)*{a.center_y}))"
    vf=f"zoompan=z='{z}':x='{x}':y='{y}':d=1:s={w}x{h}:fps={fps:.6f},format=yuv420p"
    dest.parent.mkdir(parents=True,exist_ok=True)
    cmd=[str(FFMPEG),'-hide_banner','-loglevel','error','-y' if a.overwrite else '-n','-i',str(source),'-vf',vf,'-map','0:v:0','-map','0:a?','-c:v','libx264','-preset','veryfast','-crf','18','-pix_fmt','yuv420p','-c:a','copy','-movflags','+faststart',str(dest)]
    r=subprocess.run(cmd,check=False)
    if r.returncode: return r.returncode
    print(f"Rendered {a.effect}: {dest}")
    return 0
if __name__=='__main__':
    try: raise SystemExit(main())
    except Exception as e:
        print(f'ERROR: {e}',file=sys.stderr); raise SystemExit(1)
