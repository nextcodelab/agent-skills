// Fisheye — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Fisheye.glsl
// Author: gre
// License: MIT
// Description: The outgoing image bulges toward the viewer through a strong fisheye lens, then the incoming one flattens back into place
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
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
    let _e20 = (*uv)[0u];
    let _e22 = (*uv)[1u];
    let _e25 = textureSampleLevel(_to, _sampler, vec2<f32>(_e20, (1f - _e22)), 0f);
    return _e25;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e20 = (*uv_1)[0u];
    let _e22 = (*uv_1)[1u];
    let _e25 = textureSampleLevel(_from, _sampler, vec2<f32>(_e20, (1f - _e22)), 0f);
    return _e25;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var h: f32;
    var k: f32;
    var aspect: vec2<f32>;
    var c: vec2<f32>;
    var r: f32;
    var q: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e28 = uniforms.progress;
    h = smoothstep(0f, 1f, (1f - abs(((2f * _e28) - 1f))));
    let _e35 = uniforms.strength;
    let _e38 = h;
    k = (1f - pow(max((1f - _e35), 0.01f), _e38));
    let _e42 = uniforms.ratio;
    aspect = vec2<f32>(_e42, 1f);
    let _e44 = (*uv_2);
    let _e47 = aspect;
    c = ((_e44 - vec2(0.5f)) * _e47);
    let _e49 = c;
    let _e51 = aspect;
    r = (length(_e49) / length((_e51 * 0.5f)));
    let _e55 = (*uv_2);
    let _e58 = k;
    let _e60 = k;
    let _e61 = r;
    let _e63 = r;
    q = (vec2(0.5f) + ((_e55 - vec2(0.5f)) * ((1f - _e58) + ((_e60 * _e61) * _e63))));
    let _e69 = q;
    param = _e69;
    let _e70 = getFromColor((&param));
    let _e71 = q;
    param_1 = _e71;
    let _e72 = getToColor((&param_1));
    let _e74 = uniforms.progress;
    return mix(_e70, _e72, vec4(smoothstep(0.38f, 0.62f, _e74)));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e19 = _uv_1;
    param_2 = _e19;
    let _e20 = transition((&param_2));
    _fragColor = _e20;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
