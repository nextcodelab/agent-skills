// DiamondWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DiamondWipe.glsl
// Author: gre
// License: MIT
// Description: A soft-edged diamond grows from the center to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    smoothness: f32,
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
    let _e17 = (*uv)[0u];
    let _e19 = (*uv)[1u];
    let _e22 = textureSampleLevel(_to, _sampler, vec2<f32>(_e17, (1f - _e19)), 0f);
    return _e22;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e17 = (*uv_1)[0u];
    let _e19 = (*uv_1)[1u];
    let _e22 = textureSampleLevel(_from, _sampler, vec2<f32>(_e17, (1f - _e19)), 0f);
    return _e22;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var d: vec2<f32>;
    var far: vec2<f32>;
    var dist: f32;
    var s: f32;
    var m: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e23 = (*uv_2);
    let _e25 = uniforms.center;
    let _e29 = uniforms.ratio;
    d = (abs((_e23 - _e25)) * vec2<f32>(_e29, 1f));
    let _e33 = uniforms.center;
    let _e35 = uniforms.center;
    let _e40 = uniforms.ratio;
    far = (max(_e33, (vec2(1f) - _e35)) * vec2<f32>(_e40, 1f));
    let _e44 = d[0u];
    let _e46 = d[1u];
    let _e49 = far[0u];
    let _e51 = far[1u];
    dist = ((_e44 + _e46) / (_e49 + _e51));
    let _e55 = uniforms.smoothness;
    s = max(_e55, 0.001f);
    let _e57 = s;
    let _e59 = uniforms.progress;
    let _e60 = s;
    let _e63 = dist;
    m = smoothstep(0f, _e57, ((_e59 * (1f + _e60)) - _e63));
    let _e66 = (*uv_2);
    param = _e66;
    let _e67 = getFromColor((&param));
    let _e68 = (*uv_2);
    param_1 = _e68;
    let _e69 = getToColor((&param_1));
    let _e70 = m;
    return mix(_e67, _e69, vec4(_e70));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e16 = _uv_1;
    param_2 = _e16;
    let _e17 = transition((&param_2));
    _fragColor = _e17;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
