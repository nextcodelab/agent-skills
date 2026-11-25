// Swirl — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Swirl.glsl
// Author: Sergey Kosarevsky
// License: MIT
// Description: The image twists into a round swirl around the center that peaks mid-way, where the outgoing image dissolves into the incoming one, then untwists
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
    radius: f32,
    center: vec2<f32>,
}

@group(0) @binding(2) 
var _from: texture_2d<f32>;
@group(0) @binding(1) 
var _sampler: sampler;
@group(0) @binding(3) 
var _to: texture_2d<f32>;
@group(0) @binding(0) 
var<uniform> uniforms: Uniforms;
var<private> _fragColor: vec4<f32>;
var<private> _uv_1: vec2<f32>;

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e31 = (*uv)[0u];
    let _e33 = (*uv)[1u];
    let _e36 = textureSampleLevel(_to, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e31 = (*uv_1)[0u];
    let _e33 = (*uv_1)[1u];
    let _e36 = textureSampleLevel(_from, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn mirrored(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    var m: vec2<f32>;

    let _e31 = (*v);
    let _e32 = vec2(2f);
    m = (_e31 - (floor((_e31 / _e32)) * _e32));
    let _e37 = m;
    let _e38 = m;
    let _e41 = m;
    return mix(_e37, (vec2(2f) - _e38), step(vec2(1f), _e41));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var s: f32;
    var amount: f32;
    var speed: f32;
    var reveal: f32;
    var aspect: vec2<f32>;
    var d: vec2<f32>;
    var x: f32;
    var falloff: f32;
    var twist: f32;
    var angle: f32;
    var spread: f32;
    var col: vec4<f32>;
    var total: f32;
    var i: i32;
    var k: f32;
    var w: f32;
    var a: f32;
    var c: f32;
    var sn: f32;
    var q: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e54 = uniforms.progress;
    s = sin((3.1415927f * _e54));
    let _e57 = s;
    let _e58 = s;
    amount = (_e57 * _e58);
    let _e61 = uniforms.progress;
    speed = (3.1415927f * sin((6.2831855f * _e61)));
    let _e66 = uniforms.progress;
    reveal = smoothstep(0.3f, 0.7f, _e66);
    let _e69 = uniforms.ratio;
    aspect = vec2<f32>(_e69, 1f);
    let _e71 = (*uv_2);
    let _e73 = uniforms.center;
    let _e75 = aspect;
    d = ((_e71 - _e73) * _e75);
    let _e77 = d;
    let _e80 = uniforms.radius;
    x = clamp((length(_e77) / max(_e80, 0.001f)), 0f, 1f);
    let _e84 = x;
    let _e86 = x;
    falloff = ((1f - _e84) * (1f - _e86));
    let _e90 = uniforms.strength;
    let _e92 = falloff;
    twist = ((_e90 * 6.2831855f) * _e92);
    let _e94 = twist;
    let _e95 = amount;
    angle = (_e94 * _e95);
    let _e97 = twist;
    let _e98 = speed;
    spread = clamp(((_e97 * _e98) * 0.05f), -1.2f, 1.2f);
    let _e102 = amount;
    let _e104 = falloff;
    let _e107 = d;
    d = (_e107 * (1f - ((0.12f * _e102) * _e104)));
    col = vec4<f32>(0f, 0f, 0f, 0f);
    total = 0f;
    i = 0i;
    loop {
        let _e109 = i;
        if (_e109 < 12i) {
            let _e111 = i;
            k = ((f32(_e111) / 11f) - 0.5f);
            let _e115 = k;
            w = (1f - abs(_e115));
            let _e118 = angle;
            let _e119 = spread;
            let _e120 = k;
            a = (_e118 + (_e119 * _e120));
            let _e123 = a;
            c = cos(_e123);
            let _e125 = a;
            sn = sin(_e125);
            let _e128 = uniforms.center;
            let _e129 = c;
            let _e131 = d[0u];
            let _e133 = sn;
            let _e135 = d[1u];
            let _e138 = sn;
            let _e140 = d[0u];
            let _e142 = c;
            let _e144 = d[1u];
            let _e148 = aspect;
            param = (_e128 + (vec2<f32>(((_e129 * _e131) - (_e133 * _e135)), ((_e138 * _e140) + (_e142 * _e144))) / _e148));
            let _e151 = mirrored((&param));
            q = _e151;
            let _e152 = q;
            param_1 = _e152;
            let _e153 = getFromColor((&param_1));
            let _e154 = q;
            param_2 = _e154;
            let _e155 = getToColor((&param_2));
            let _e156 = reveal;
            let _e159 = w;
            let _e161 = col;
            col = (_e161 + (mix(_e153, _e155, vec4(_e156)) * _e159));
            let _e163 = w;
            let _e164 = total;
            total = (_e164 + _e163);
            continue;
        } else {
            break;
        }
        continuing {
            let _e166 = i;
            i = (_e166 + 1i);
        }
    }
    let _e168 = col;
    let _e169 = total;
    return (_e168 / vec4(_e169));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e30 = _uv_1;
    param_3 = _e30;
    let _e31 = transition((&param_3));
    _fragColor = _e31;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
