"""Split one local audio mix into vocals and accompaniment using the bundled CPU model."""
import argparse
from pathlib import Path
import shutil
import subprocess
from tempfile import TemporaryDirectory

HERE = Path(__file__).resolve().parent
FFMPEG = HERE.parent / "ffmpeg" / "bin" / "ffmpeg.exe"
MODEL = HERE / "model" / "UVR_MDXNET_9482.onnx"


def separate(source: Path, vocals: Path, backing: Path, threads: int = 2) -> None:
    """Create two new 44.1 kHz WAV files. Keep the input file intact."""
    source, vocals, backing = (Path(path).resolve() for path in (source, vocals, backing))
    if not source.is_file():
        raise ValueError(f"Input does not exist: {source}")
    if not 1 <= threads <= 4:
        raise ValueError("Choose one to four CPU threads.")
    if len({source, vocals, backing}) != 3 or any(
        path.suffix.lower() != ".wav" or path.exists() for path in (vocals, backing)
    ):
        raise ValueError("Choose two different new .wav outputs.")
    executables = sorted((HERE / "runtime").rglob("sherpa-onnx-offline-source-separation.exe"))
    if len(executables) != 1 or not MODEL.is_file():
        raise RuntimeError("The bundled CPU separator or model is missing.")
    executable = executables[0]
    for path in (vocals, backing):
        path.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(prefix="ve-vocal-separation-") as work:
        workspace = Path(work)
        mix = workspace / "input.wav"
        voice = workspace / "vocals.wav"
        music = workspace / "accompaniment.wav"
        subprocess.run([
            str(FFMPEG), "-nostdin", "-v", "error", "-n", "-i", str(source),
            "-map", "0:a:0", "-vn", "-ac", "2", "-ar", "44100", "-c:a", "pcm_s16le", str(mix),
        ], check=True)
        subprocess.run([
            str(executable), "--provider=cpu", f"--num-threads={threads}", f"--uvr-model={MODEL}",
            f"--input-wav={mix}", f"--output-vocals-wav={voice}", f"--output-accompaniment-wav={music}",
        ], cwd=executable.parent, check=True)
        if any(not path.is_file() or path.stat().st_size <= 44 for path in (voice, music)):
            raise RuntimeError("The separator failed to write both stems.")
        for staged, output in ((voice, vocals), (music, backing)):
            with staged.open("rb") as input_stream, output.open("xb") as output_stream:
                shutil.copyfileobj(input_stream, output_stream)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("vocals", type=Path)
    parser.add_argument("backing", type=Path)
    parser.add_argument("--threads", type=int, default=2)
    args = parser.parse_args()
    try:
        separate(args.source, args.vocals, args.backing, args.threads)
    except (OSError, RuntimeError, ValueError, subprocess.CalledProcessError) as exc:
        parser.exit(1, f"Error: {exc}\n")
    print(args.vocals.resolve())
    print(args.backing.resolve())


if __name__ == "__main__":
    main()
