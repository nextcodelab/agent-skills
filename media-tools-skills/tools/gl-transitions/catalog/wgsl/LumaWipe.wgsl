// LumaWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LumaWipe.glsl
// Author: gre
// License: MIT
// Description: A wipe that follows the brightness of a grayscale mask (the luma texture)
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
@group(0) @binding(4) 
var luma: texture_2d<f32>;
@group(0) @binding(0) 
var<uniform> uniforms: Uniforms;
var<private> _fragColor: vec4<f32>;
var<private> _uv_1: vec2<f32>;

fn _texture_luma(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e14 = (*uv)[0u];
    let _e16 = (*uv)[1u];
    let _e19 = textureSampleLevel(luma, _sampler, vec2<f32>(_e14, (1f - _e16)), 0f);
    return _e19;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e14 = (*uv_1)[0u];
    let _e16 = (*uv_1)[1u];
    let _e19 = textureSampleLevel(_from, _sampler, vec2<f32>(_e14, (1f - _e16)), 0f);
    return _e19;
}

fn getToColor(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e14 = (*uv_2)[0u];
    let _e16 = (*uv_2)[1u];
    let _e19 = textureSampleLevel(_to, _sampler, vec2<f32>(_e14, (1f - _e16)), 0f);
    return _e19;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e16 = (*uv_3);
    param = _e16;
    let _e17 = getToColor((&param));
    let _e18 = (*uv_3);
    param_1 = _e18;
    let _e19 = getFromColor((&param_1));
    let _e21 = uniforms.progress;
    let _e22 = (*uv_3);
    param_2 = _e22;
    let _e23 = _texture_luma((&param_2));
    return mix(_e17, _e19, vec4(step(_e21, _e23.x)));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e13 = _uv_1;
    param_3 = _e13;
    let _e14 = transition((&param_3));
    _fragColor = _e14;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
