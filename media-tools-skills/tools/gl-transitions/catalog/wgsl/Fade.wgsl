// Fade — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Fade.glsl
// Author: gre
// License: MIT
// Description: A linear crossfade between the two images
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e13 = (*uv)[0u];
    let _e15 = (*uv)[1u];
    let _e18 = textureSampleLevel(_to, _sampler, vec2<f32>(_e13, (1f - _e15)), 0f);
    return _e18;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e13 = (*uv_1)[0u];
    let _e15 = (*uv_1)[1u];
    let _e18 = textureSampleLevel(_from, _sampler, vec2<f32>(_e13, (1f - _e15)), 0f);
    return _e18;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e14 = (*uv_2);
    param = _e14;
    let _e15 = getFromColor((&param));
    let _e16 = (*uv_2);
    param_1 = _e16;
    let _e17 = getToColor((&param_1));
    let _e19 = uniforms.progress;
    return mix(_e15, _e17, vec4(_e19));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e12 = _uv_1;
    param_2 = _e12;
    let _e13 = transition((&param_2));
    _fragColor = _e13;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
