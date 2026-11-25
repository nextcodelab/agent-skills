// SplitSlideOutHorizontal — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplitSlideOutHorizontal.glsl
// Author: OllyOllyOlly
// License: MIT
// Description: The outgoing image slides out as two halves moving horizontally in opposite directions
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    reverse: i32,
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
    let _e18 = (*uv)[0u];
    let _e20 = (*uv)[1u];
    let _e23 = textureSampleLevel(_to, _sampler, vec2<f32>(_e18, (1f - _e20)), 0f);
    return _e23;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e18 = (*uv_1)[0u];
    let _e20 = (*uv_1)[1u];
    let _e23 = textureSampleLevel(_from, _sampler, vec2<f32>(_e18, (1f - _e20)), 0f);
    return _e23;
}

fn inBounds(p: ptr<function, vec2<f32>>) -> bool {
    var phi_74_: bool;

    let _e17 = (*p);
    let _e19 = all((vec2<f32>(0f, 0f) < _e17));
    phi_74_ = _e19;
    if _e19 {
        let _e20 = (*p);
        phi_74_ = all((_e20 < vec2<f32>(1f, 1f)));
    }
    let _e24 = phi_74_;
    return _e24;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var modifier: f32;
    var p_1: vec2<f32>;
    var param: vec2<f32>;
    var local: vec4<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e24 = (*uv_2)[1u];
    let _e28 = uniforms.reverse;
    modifier = (select(-1f, 1f, (_e24 > 0.5f)) * select(1f, -1f, (_e28 != 0i)));
    let _e33 = (*uv_2)[0u];
    let _e35 = uniforms.progress;
    let _e36 = modifier;
    let _e40 = (*uv_2)[1u];
    p_1 = vec2<f32>((_e33 + (_e35 * _e36)), _e40);
    let _e42 = p_1;
    param = _e42;
    let _e43 = inBounds((&param));
    if _e43 {
        let _e44 = p_1;
        param_1 = _e44;
        let _e45 = getFromColor((&param_1));
        local = _e45;
    } else {
        let _e46 = (*uv_2);
        param_2 = _e46;
        let _e47 = getToColor((&param_2));
        local = _e47;
    }
    let _e48 = local;
    return _e48;
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e17 = _uv_1;
    param_3 = _e17;
    let _e18 = transition((&param_3));
    _fragColor = _e18;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
