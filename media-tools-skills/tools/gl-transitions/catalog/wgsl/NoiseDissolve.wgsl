// NoiseDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/NoiseDissolve.glsl
// Author: towrabbit
// License: MIT
// Description: The incoming image appears pixel by pixel in random noise
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
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

fn random(st: ptr<function, vec2<f32>>) -> f32 {
    let _e16 = (*st);
    return fract((sin(dot(_e16, vec2<f32>(12.9898f, 78.233f))) * 43758.547f));
}

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
    var leftSide: vec4<f32>;
    var param: vec2<f32>;
    var rightSide: vec4<f32>;
    var param_1: vec2<f32>;
    var uvz: f32;
    var param_2: vec2<f32>;

    let _e22 = (*uv_2);
    param = _e22;
    let _e23 = getFromColor((&param));
    leftSide = _e23;
    let _e24 = (*uv_2);
    param_1 = _e24;
    let _e25 = getToColor((&param_1));
    rightSide = _e25;
    let _e26 = (*uv_2);
    param_2 = _e26;
    let _e27 = random((&param_2));
    let _e29 = uniforms.progress;
    uvz = floor((_e27 + _e29));
    let _e32 = leftSide;
    let _e33 = rightSide;
    let _e34 = uvz;
    return mix(_e32, _e33, vec4(_e34));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e16 = _uv_1;
    param_3 = _e16;
    let _e17 = transition((&param_3));
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
