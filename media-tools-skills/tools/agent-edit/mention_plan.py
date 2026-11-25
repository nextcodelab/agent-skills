"""Match editor-selected contextual visuals to a local word-timed transcript."""
import argparse
import json
import math
from pathlib import Path
import re
import unicodedata


def load(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def tokens(text):
    return re.findall(r"[^\W_]+", unicodedata.normalize("NFKC", text).casefold())


def timestamp(value):
    if isinstance(value, (float, int)):
        return float(value)
    hours, minutes, seconds = value.replace(",", ".").split(":")
    return int(hours) * 3600 + int(minutes) * 60 + float(seconds)


def timed_tokens(transcript):
    words = transcript.get("words")
    whisper = words is None
    if whisper:
        words = transcript["transcription"]
    rows = []
    previous = -1
    for row in words:
        stamps = row.get("timestamps") if whisper else row
        if not stamps:
            offsets = row["offsets"]
            start, end = offsets["from"] / 1000, offsets["to"] / 1000
        else:
            a, b = ("from", "to") if whisper else ("start", "end")
            start, end = timestamp(stamps[a]), timestamp(stamps[b])
        text = row["text"].strip()
        if not text:
            continue
        if len(text.split()) != 1:
            raise ValueError("The transcript must contain one timed word per record.")
        if not (math.isfinite(start) and math.isfinite(end) and 0 <= start <= end and start >= previous):
            raise ValueError("The transcript must have valid, ordered timestamps.")
        previous = start
        rows.extend((word, start, end) for word in tokens(text))
    return rows


def build_plan(rows, rules, duration, max_events, gap):
    words = [row[0] for row in rows]
    candidates = []
    ids = set()
    for rule in rules:
        key = rule["id"]
        if not key or key in ids:
            raise ValueError("Each rule must have a unique nonempty id.")
        ids.add(key)
        hold = float(rule.get("hold", 1.4))
        if not 0.3 <= hold <= 8:
            raise ValueError(f"{key}: hold must be between 0.3 and 8 seconds.")
        for phrase in rule["aliases"]:
            phrase_tokens = tokens(phrase)
            count = len(phrase_tokens)
            if not count:
                raise ValueError(f"{key}: an alias is empty.")
            for index in range(len(rows) - count + 1):
                if words[index:index + count] != phrase_tokens:
                    continue
                match = rows[index:index + count]
                if any(right[1] - left[2] > 0.7 for left, right in zip(match, match[1:])):
                    continue
                start = match[0][1]
                end = min(duration, start + hold)
                if end - start < 0.3:
                    continue
                event = {
                    "id": key, "matched_alias": phrase, "start": round(start, 3),
                    "end": round(end, 3), "asset": rule["asset"],
                    "placement": rule.get("placement", "review"),
                }
                candidates.append((-int(rule.get("priority", 0)), -count, start, key, event))
    selected = []
    used = set()
    for _, _, _, key, event in sorted(candidates, key=lambda item: item[:4]):
        if key in used or any(
            event["start"] < item["end"] + gap and item["start"] < event["end"] + gap
            for item in selected
        ):
            continue
        selected.append(event)
        used.add(key)
        if len(selected) == max_events:
            break
    return sorted(selected, key=lambda event: event["start"])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("transcript", type=Path)
    parser.add_argument("rules", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--duration", type=float, required=True, help="Duration in seconds of the final cut.")
    parser.add_argument("--max-events", type=int, default=5)
    parser.add_argument("--gap", type=float, default=0.65)
    args = parser.parse_args()
    if not (math.isfinite(args.duration) and args.duration > 0 and
            math.isfinite(args.gap) and args.gap >= 0 and args.max_events > 0):
        parser.error("Use a positive duration and event limit and a nonnegative gap.")
    try:
        rows = timed_tokens(load(args.transcript))
        events = build_plan(rows, load(args.rules)["rules"], args.duration, args.max_events, args.gap)
        plan = {"version": 1, "timebase": "final-cut-seconds", "events": events}
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open("x", encoding="utf-8") as output:
            output.write(json.dumps(plan, ensure_ascii=False, indent=2) + "\n")
    except (OSError, ValueError, KeyError, TypeError) as exc:
        parser.exit(1, f"Error: {exc}\n")
    print(f"{len(events)} planned overlays: {args.output}")


if __name__ == "__main__":
    main()
