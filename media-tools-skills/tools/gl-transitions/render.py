"""Render a video join locally with an upstream GL Transitions WGSL shader."""
import argparse
import json
import math
from pathlib import Path
import re
import struct
from tempfile import TemporaryDirectory


CATALOG = Path(__file__).resolve().with_name("catalog")
VERTEX_SHADER = """
struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) uv: vec2<f32>,
}

@vertex
fn main(@builtin(vertex_index) index: u32) -> VertexOutput {
    let corners = array<vec2<f32>, 3>(
        vec2<f32>(-1.0, -1.0), vec2<f32>(3.0, -1.0), vec2<f32>(-1.0, 3.0));
    var out: VertexOutput;
    out.position = vec4<f32>(corners[index], 0.0, 1.0);
    out.uv = (corners[index] + 1.0) * 0.5;
    return out;
}
"""
UNIFORM_FORMAT = {"float": "f", "int": "i", "bool": "i",
                  "vec2": "2f", "vec3": "3f", "vec4": "4f",
                  "ivec2": "2i", "ivec3": "3i", "ivec4": "4i"}


def read_json(name):
    return json.loads((CATALOG / name).read_text(encoding="utf-8"))


def available():
    layouts = read_json("layouts.json")
    compatibility = read_json("compatibility.json")["transitions"]
    effects = {}
    for entry in read_json("gl-transitions.json"):
        name = entry["name"]
        layout = layouts.get(name)
        status = compatibility.get(name, {}).get("wgsl", {}).get("status")
        if (entry.get("license") != "MIT" or not layout or layout["textures"] or
                status != "match" or not re.fullmatch(r"[A-Za-z][A-Za-z0-9_-]*", name) or
                not (CATALOG / "wgsl" / f"{name}.wgsl").is_file()):
            continue
        if all(field["type"] in UNIFORM_FORMAT for field in layout["uniforms"]):
            effects[name] = entry, layout
    return effects


class Shader:
    def __init__(self, name, device, width, height, entry, layout):
        import numpy as np
        import wgpu

        self.np = np
        self.device, self.size = device, (width, height, 1)
        self.layout = layout
        self.uniform = bytearray(layout["size"])
        defaults = dict(entry.get("defaultParams", {}), ratio=width / height, progress=0.0)
        for field in layout["uniforms"]:
            value = defaults[field["name"]]
            components = value if isinstance(value, list) else [value]
            struct.pack_into("<" + UNIFORM_FORMAT[field["type"]], self.uniform,
                             field["offset"], *components)
        self.progress_offset = next(field["offset"] for field in layout["uniforms"]
                                    if field["name"] == "progress")
        self.buffer = device.create_buffer(size=max(16, layout["size"]),
                                           usage=wgpu.BufferUsage.UNIFORM | wgpu.BufferUsage.COPY_DST)
        self.textures = [
            device.create_texture(size=self.size, format="rgba8unorm",
                                  usage=wgpu.TextureUsage.TEXTURE_BINDING | wgpu.TextureUsage.COPY_DST)
            for _ in range(2)
        ]
        self.target = device.create_texture(
            size=self.size, format="rgba8unorm",
            usage=wgpu.TextureUsage.RENDER_ATTACHMENT | wgpu.TextureUsage.COPY_SRC,
        )
        self.target_view = self.target.create_view()
        self.image = np.empty((height, width, 4), dtype=np.uint8)
        self.image[:, :, 3] = 255
        visibility = wgpu.ShaderStage.FRAGMENT
        entries = [
            {"binding": 0, "visibility": visibility, "buffer": {"type": "uniform"}},
            {"binding": 1, "visibility": visibility, "sampler": {"type": "filtering"}},
            *({"binding": i, "visibility": visibility, "texture": {"sample_type": "float"}}
              for i in (2, 3)),
        ]
        group_layout = device.create_bind_group_layout(entries=entries)
        sampler = device.create_sampler(mag_filter="linear", min_filter="linear")
        self.group = device.create_bind_group(layout=group_layout, entries=[
            {"binding": 0, "resource": {"buffer": self.buffer, "size": max(16, layout["size"])}},
            {"binding": 1, "resource": sampler},
            *({"binding": i, "resource": tex.create_view()} for i, tex in enumerate(self.textures, 2)),
        ])
        vertex = device.create_shader_module(code=VERTEX_SHADER)
        fragment = device.create_shader_module(code=(CATALOG / "wgsl" / f"{name}.wgsl").read_text(encoding="utf-8"))
        self.pipeline = device.create_render_pipeline(
            layout=device.create_pipeline_layout(bind_group_layouts=[group_layout]),
            vertex={"module": vertex, "entry_point": "main", "buffers": []},
            fragment={"module": fragment, "entry_point": "main", "targets": [{"format": "rgba8unorm"}]},
            primitive={"topology": "triangle-list"},
        )

    def render(self, first, second, progress):
        width, height, _ = self.size
        queue = self.device.queue
        struct.pack_into("<f", self.uniform, self.progress_offset, progress)
        queue.write_buffer(self.buffer, 0, self.uniform)
        for texture, frame in zip(self.textures, (first, second)):
            self.image[:, :, :3] = frame
            queue.write_texture({"texture": texture}, self.image,
                                {"bytes_per_row": width * 4}, self.size)
        encoder = self.device.create_command_encoder()
        draw = encoder.begin_render_pass(color_attachments=[{
            "view": self.target_view, "resolve_target": None,
            "clear_value": (0, 0, 0, 1), "load_op": "clear", "store_op": "store",
        }])
        draw.set_pipeline(self.pipeline)
        draw.set_bind_group(0, self.group)
        draw.draw(3)
        draw.end()
        queue.submit([encoder.finish()])
        data = queue.read_texture({"texture": self.target}, {"bytes_per_row": width * 4}, self.size)
        return self.np.frombuffer(data, dtype=self.np.uint8).reshape(height, width, 4)[:, :, :3].copy()


def device_for_render(backend):
    import os
    if backend:
        os.environ["WGPU_BACKEND_TYPE"] = backend
    import wgpu
    adapter = wgpu.gpu.request_adapter_sync(power_preference="high-performance")
    if adapter is None:
        raise ValueError("No compatible graphics adapter was found. Try --backend D3D12 or Vulkan.")
    return adapter, adapter.request_device_sync()


def join(args, entry, layout):
    from moviepy import AudioClip, CompositeAudioClip, VideoClip, VideoFileClip, afx

    if args.output.exists() or args.output.suffix.lower() != ".mp4":
        raise ValueError("Choose a new .mp4 output path.")
    if not args.first.is_file() or not args.second.is_file():
        raise ValueError("Provide two existing local video files.")
    size = args.width, args.height
    fps = args.fps
    n = max(2, round(args.seconds * fps))
    overlap = n / fps
    _, device = device_for_render(args.backend)
    shader = Shader(args.effect, device, *size, entry, layout)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with VideoFileClip(str(args.first)) as source_a, VideoFileClip(str(args.second)) as source_b:
        a = source_a.resized(min(size[0]/source_a.w, size[1]/source_a.h))
        b = source_b.resized(min(size[0]/source_b.w, size[1]/source_b.h))
        frames_a, frames_b = (math.floor(c.duration * fps + 1e-6) for c in (a, b))
        if min(frames_a, frames_b) <= n:
            raise ValueError("Both clips must be longer than the transition.")
        seam = (frames_a - n) / fps
        total = (frames_a + frames_b - n) / fps

        def padded(clip, t):
            frame = clip.get_frame(t)
            height, width = frame.shape[:2]
            if (width, height) == size:
                return frame
            image = shader.np.zeros((size[1], size[0], 3), dtype=shader.np.uint8)
            x, y = (size[0] - width) // 2, (size[1] - height) // 2
            image[y:y+height, x:x+width] = frame
            return image

        def render_frame(t):
            frame = round(t * fps)
            relative = frame - (frames_a - n)
            if relative <= 0:
                return padded(a, frame / fps)
            if relative >= n - 1:
                return padded(b, relative / fps)
            return shader.render(padded(a, frame / fps), padded(b, relative / fps),
                                 relative / (n - 1))

        audio = []
        if a.audio:
            duration = min(a.audio.duration, frames_a / fps)
            # Apply the fade at the clip's actual audio endpoint.
            audio.append(a.audio.subclipped(0, duration).with_effects([afx.AudioFadeOut(overlap)]))
        if b.audio:
            duration = min(b.audio.duration, frames_b / fps)
            audio.append(b.audio.subclipped(0, duration).with_effects(
                [afx.AudioFadeIn(overlap)]).with_start(seam))
        result = VideoClip(render_frame, duration=total)
        if audio:
            # Start with two channels of silence so audio covers the entire output.
            def silence(t):
                shape = (len(t), 2) if isinstance(t, shader.np.ndarray) else (2,)
                return shader.np.zeros(shape)
            mix = CompositeAudioClip([AudioClip(silence, duration=total, fps=48000), *audio])
            result = result.with_audio(mix.with_duration(total))
        with TemporaryDirectory(prefix=".gl-render-", dir=args.output.parent) as tmp:
            staged = Path(tmp) / "render.mp4"
            result.write_videofile(str(staged), fps=fps, codec="libx264", audio_codec="aac",
                                   audio_fps=48000, temp_audiofile=str(Path(tmp) / "audio.m4a"),
                                   preset="fast", ffmpeg_params=["-crf", "18", "-movflags", "+faststart"],
                                   pixel_format="yuv420p", logger=None)
            staged.rename(args.output)


def main():
    effects = available()
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    sub.add_parser("list", help="List supported MIT shaders.")
    doctor = sub.add_parser("doctor", help="Check the local graphics adapter.")
    render = sub.add_parser("render", help="Join two video clips.")
    for command in (doctor, render):
        command.add_argument("--backend", choices=["D3D12", "Vulkan", "OpenGL"])
    for name in ("first", "second", "output"):
        render.add_argument(name, type=lambda value: Path(value).resolve())
    render.add_argument("--effect", default="CrossZoom", help="Name from the list command.")
    render.add_argument("--seconds", type=float, default=0.4)
    render.add_argument("--width", type=int, default=1080)
    render.add_argument("--height", type=int, default=1920)
    render.add_argument("--fps", type=int, default=30)
    args = parser.parse_args()
    if args.command == "list":
        print("\n".join(sorted(effects, key=str.casefold)))
        return
    try:
        if args.command == "doctor":
            adapter, _ = device_for_render(args.backend)
            print(adapter.info)
            return
        if args.effect not in effects:
            raise ValueError("Unsupported effect. Use the list command for the local catalog.")
        if not (0.05 <= args.seconds <= 8 and 1 <= args.fps <= 120 and
                all(16 <= n <= 4096 and n % 2 == 0 for n in (args.width, args.height))):
            raise ValueError("Use 0.05–8 seconds, 1–120 fps, and even dimensions from 16 to 4096.")
        join(args, *effects[args.effect])
    except (OSError, ValueError, RuntimeError, ImportError) as exc:
        parser.exit(1, f"Error: {exc}\n")
    print(args.output)


if __name__ == "__main__":
    main()
