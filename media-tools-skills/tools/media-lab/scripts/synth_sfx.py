#!/usr/bin/env python3
"""Create original tiny UI/transition cues with the Python standard library only."""
import argparse
import math
import struct
import wave
from pathlib import Path

CHORDS = {"soft-piano": (261.63, 329.63, 392.00), "bright-piano": (392.00, 493.88, 587.33), "warm-piano": (220.00, 261.63, 329.63)}

def sample(t: float, duration: float, kind: str, notes: tuple[float, ...]) -> float:
    fade = min(1.0, t / 0.012, (duration - t) / 0.045)
    if kind in CHORDS:
        value = 0.0
        for i, hz in enumerate(notes):
            env = math.exp(-t * (2.3 + i * 0.22))
            partials = math.sin(2 * math.pi * hz * t) + 0.24 * math.sin(2 * math.pi * hz * 2.01 * t) + 0.09 * math.sin(2 * math.pi * hz * 3.97 * t)
            value += env * partials / (1 + i * 0.35)
        return value * (0.78 + 0.22 * math.exp(-t * 55)) * fade / 2.5
    if kind == "soft-impact":
        return (math.sin(2 * math.pi * (95 - 48 * t / duration) * t) * math.exp(-t * 12) + 0.16 * math.sin(2 * math.pi * 880 * t) * math.exp(-t * 65)) * fade
    if kind == "sparkle":
        return sum(math.sin(2 * math.pi * hz * t) * math.exp(-t * 2.5) for hz in (880, 1320, 1760)) / 3 * fade
    if kind == "whoosh":
        carrier = sum(math.sin(2 * math.pi * (120 + k * 71) * t) for k in range(1, 14)) / 13
        return carrier * math.sin(math.pi * min(1, t / duration)) ** 1.7 * fade * 0.45
    raise ValueError(kind)

def main() -> None:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("kind", choices=[*CHORDS, "soft-impact", "sparkle", "whoosh"])
    p.add_argument("output", type=Path)
    p.add_argument("--duration", type=float, default=1.4)
    p.add_argument("--sample-rate", type=int, default=48000)
    a = p.parse_args()
    if not 0.15 <= a.duration <= 12: p.error("duration must be between 0.15 and 12 seconds")
    dst = a.output.resolve(); dst.parent.mkdir(parents=True, exist_ok=True)
    notes = CHORDS.get(a.kind, ()); frames = int(a.duration * a.sample_rate)
    with wave.open(str(dst), "wb") as wav:
        wav.setnchannels(2); wav.setsampwidth(2); wav.setframerate(a.sample_rate)
        for start in range(0, frames, 4096):
            buf = bytearray()
            for n in range(start, min(start + 4096, frames)):
                t = n / a.sample_rate; value = sample(t, a.duration, a.kind, notes)
                buf.extend(struct.pack("<hh", int(max(-1, min(1, value * 0.92)) * 32767), int(max(-1, min(1, value * 0.88)) * 32767)))
            wav.writeframesraw(buf)
    print(f"Created synthetic {a.kind} WAV: {dst}")

if __name__ == "__main__": main()
