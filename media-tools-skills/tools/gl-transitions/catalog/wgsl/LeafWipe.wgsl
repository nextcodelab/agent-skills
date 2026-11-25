// LeafWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LeafWipe.glsl
// Author: @Flexi23
// License: MIT
// Description: A leaf shape grows from the center to reveal the incoming image
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
    let _e25 = (*uv)[0u];
    let _e27 = (*uv)[1u];
    let _e30 = textureSampleLevel(_to, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e25 = (*uv_1)[0u];
    let _e27 = (*uv_1)[1u];
    let _e30 = textureSampleLevel(_from, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var leaf_uv: vec2<f32>;
    var r: f32;
    var o: f32;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e31 = uniforms.progress;
    if (_e31 == 0f) {
        let _e33 = (*uv_2);
        param = _e33;
        let _e34 = getFromColor((&param));
        return _e34;
    }
    let _e35 = (*uv_2);
    let _e40 = uniforms.progress;
    leaf_uv = (((_e35 - vec2<f32>(0.5f, 0.5f)) / vec2(10f)) / vec2(pow(_e40, 3.5f)));
    let _e45 = leaf_uv[1u];
    leaf_uv[1u] = (_e45 + 0.35f);
    r = 0.18f;
    let _e49 = leaf_uv[1u];
    let _e51 = leaf_uv[0u];
    o = atan2(_e49, _e51);
    let _e53 = (*uv_2);
    param_1 = _e53;
    let _e54 = getFromColor((&param_1));
    let _e55 = (*uv_2);
    param_2 = _e55;
    let _e56 = getToColor((&param_2));
    let _e57 = leaf_uv;
    let _e60 = r;
    let _e61 = o;
    let _e65 = o;
    let _e71 = o;
    let _e77 = o;
    return mix(_e54, _e56, vec4((1f - step(((1f - length(_e57)) + ((((_e60 * (1f + sin(_e61))) * (1f + (0.9f * cos((8f * _e65))))) * (1f + (0.1f * cos((24f * _e71))))) * (0.9f + (0.05f * cos((200f * _e77)))))), 1f))));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e24 = _uv_1;
    param_3 = _e24;
    let _e25 = transition((&param_3));
    _fragColor = _e25;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
