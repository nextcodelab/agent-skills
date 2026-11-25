// DuotoneFade — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DuotoneFade.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is printed in two inks, shadows first, as a bold high-contrast duotone; the incoming image is printed over it in the same two inks, its dark tones landing before its highlights, then its own colors come back, highlights first
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    shadowInk: vec4<f32>,
    highlightInk: vec4<f32>,
    contrast: f32,
    grain: f32,
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

fn dfHash(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e44 = (*v);
    v3_ = fract((_e44.xyx * 0.1031f));
    let _e48 = v3_;
    let _e49 = v3_;
    let _e54 = v3_;
    v3_ = (_e54 + vec3(dot(_e48, (_e49.yzx + vec3(33.33f)))));
    let _e58 = v3_[0u];
    let _e60 = v3_[1u];
    let _e63 = v3_[2u];
    return fract(((_e58 + _e60) * _e63));
}

fn dfLuma(c: ptr<function, vec4<f32>>) -> f32 {
    let _e43 = (*c);
    return clamp(dot(_e43.xyz, vec3<f32>(0.299f, 0.587f, 0.114f)), 0f, 1f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv)[0u];
    let _e46 = (*uv)[1u];
    let _e49 = textureSampleLevel(_to, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv_1)[0u];
    let _e46 = (*uv_1)[1u];
    let _e49 = textureSampleLevel(_from, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var la: f32;
    var param_2: vec4<f32>;
    var lb: f32;
    var param_3: vec4<f32>;
    var q: vec2<f32>;
    var g: f32;
    var param_4: vec2<f32>;
    var inks: f32;
    var lift: f32;
    var amount: f32;
    var x: f32;
    var t: f32;
    var s: f32;
    var c_1: f32;
    var tone: f32;
    var ink: vec4<f32>;
    var base: vec4<f32>;

    let _e64 = (*uv_2);
    param = _e64;
    let _e65 = getFromColor((&param));
    a = _e65;
    let _e66 = (*uv_2);
    param_1 = _e66;
    let _e67 = getToColor((&param_1));
    b = _e67;
    let _e68 = a;
    param_2 = _e68;
    let _e69 = dfLuma((&param_2));
    la = _e69;
    let _e70 = b;
    param_3 = _e70;
    let _e71 = dfLuma((&param_3));
    lb = _e71;
    let _e72 = (*uv_2);
    let _e75 = uniforms.ratio;
    let _e78 = uniforms.ratio;
    q = ((_e72 * 360f) * vec2<f32>(max(_e75, 1f), max((1f / _e78), 1f)));
    let _e83 = q;
    param_4 = floor(_e83);
    let _e85 = dfHash((&param_4));
    g = (_e85 - 0.5f);
    let _e88 = uniforms.progress;
    inks = smoothstep(0f, 0.35f, _e88);
    let _e91 = uniforms.progress;
    lift = smoothstep(0.65f, 1f, _e91);
    let _e93 = inks;
    let _e95 = la;
    let _e99 = lift;
    let _e102 = lb;
    amount = min(clamp(((_e93 * 1.35f) - (0.35f * _e95)), 0f, 1f), clamp((((1f - _e99) * 1.35f) - (0.35f * _e102)), 0f, 1f));
    let _e107 = amount;
    let _e108 = amount;
    let _e110 = amount;
    amount = ((_e107 * _e108) * (3f - (2f * _e110)));
    let _e115 = uniforms.progress;
    x = ((smoothstep(0.25f, 0.75f, _e115) * 1.6f) - 0.3f);
    let _e119 = lb;
    let _e121 = uniforms.grain;
    let _e123 = g;
    t = (_e119 + ((0.2f * _e121) * _e123));
    let _e126 = t;
    let _e128 = t;
    let _e130 = x;
    s = smoothstep((_e126 - 0.15f), (_e128 + 0.15f), _e130);
    let _e133 = uniforms.contrast;
    c_1 = (0.4f * _e133);
    let _e135 = c_1;
    let _e137 = c_1;
    let _e139 = la;
    let _e140 = lb;
    let _e141 = s;
    let _e144 = uniforms.grain;
    let _e146 = g;
    tone = smoothstep((_e135 + 0.03f), (1.03f - _e137), (mix(_e139, _e140, _e141) + ((0.08f * _e144) * _e146)));
    let _e151 = uniforms.shadowInk;
    let _e153 = uniforms.highlightInk;
    let _e154 = tone;
    ink = mix(_e151, _e153, vec4(_e154));
    let _e157 = a;
    let _e160 = a[3u];
    let _e161 = (_e157.xyz * _e160);
    let _e163 = a[3u];
    let _e168 = b;
    let _e171 = b[3u];
    let _e172 = (_e168.xyz * _e171);
    let _e174 = b[3u];
    let _e179 = s;
    base = mix(vec4<f32>(_e161.x, _e161.y, _e161.z, _e163), vec4<f32>(_e172.x, _e172.y, _e172.z, _e174), vec4(_e179));
    let _e183 = base[3u];
    if (_e183 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e185 = base;
    let _e188 = base[3u];
    let _e191 = ink;
    let _e193 = amount;
    let _e195 = ink[3u];
    let _e198 = mix((_e185.xyz / vec3(_e188)), _e191.xyz, vec3((_e193 * _e195)));
    let _e200 = base[3u];
    return vec4<f32>(_e198.x, _e198.y, _e198.z, _e200);
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e43 = _uv_1;
    param_5 = _e43;
    let _e44 = transition((&param_5));
    _fragColor = _e44;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
