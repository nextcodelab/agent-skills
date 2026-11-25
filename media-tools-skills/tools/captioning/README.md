# Offline transcription tools

This folder contains the Windows x64 CPU whisper.cpp runtime and the local `small.en` model. It creates English transcripts and word-level timestamps without a hosted transcription endpoint. Keep the runtime and model together when backing up.

- CLI wrapper: `whisper-cli.cmd`
- Expected model: `models\ggml-small.en.bin`
- Runtime: `bin\whisper-bin-x64-b5454\Release\whisper-cli.exe` and adjacent DLLs
- Model source: `https://huggingface.co/ggerganov/whisper.cpp`
- Runtime source: `https://github.com/ggml-org/whisper.cpp`, nightly build `b5454`

Whisper is a draft transcription, not a guaranteed verbatim record. Review names and numbers before posting.
