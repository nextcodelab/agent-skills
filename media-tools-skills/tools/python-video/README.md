# Portable MoviePy

MoviePy 2.2.1 and its Windows x64 Python 3.12 dependencies live under `vendor/`. The launcher uses the toolkit's embedded Python and FFmpeg. It adds only this module's private dependencies to the import path. Run from the toolkit root:

```powershell
.\tools\python-video\python-video.cmd "D:\project\my_edit.py"
.\tools\python-video\moviepy-overlays.cmd "D:\project\cut.mp4" "D:\project\overlay-plan.json" "D:\project\with-overlays.mp4"
```

The overlay command draws the images in list order. PNG alpha is preserved when compositing. Times are seconds on the input cut, and x/y are pixels from the top left. The source audio is retained and encoded as AAC. Use even video dimensions for standard H.264 delivery.

```json
{
  "layers": [
    {"file": "assets/folder.png", "start": 2.1, "end": 3.6, "x": 80, "y": 420, "width": 260}
  ]
}
```

Paths in the JSON are relative to that file unless absolute. Keep project media and exports outside the toolkit. Package versions and license notices are preserved in each directory ending in `.dist-info`. See the [MoviePy composition guide](https://zulko.github.io/moviepy/user_guide/compositing.html).
