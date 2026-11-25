// Crosshatch — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Crosshatch.glsl
// Author: pthrasher
// License: MIT
// Description: The incoming image appears through a crosshatch of lines spreading from the center
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    threshold: f32,
    fadeEdge: f32,
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

fn rand(co: ptr<function, vec2<f32>>) -> f32 {
    let _e19 = (*co);
    return fract((sin(dot(_e19, vec2<f32>(12.9898f, 78.233f))) * 43758.547f));
}

fn transition(p: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dist: f32;
    var r: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e26 = uniforms.center;
    let _e27 = (*p);
    let _e30 = uniforms.threshold;
    dist = (distance(_e26, _e27) / _e30);
    let _e33 = uniforms.progress;
    let _e35 = (*p)[1u];
    param = vec2<f32>(_e35, 0f);
    let _e37 = rand((&param));
    let _e39 = (*p)[0u];
    param_1 = vec2<f32>(0f, _e39);
    let _e41 = rand((&param_1));
    r = (_e33 - min(_e37, _e41));
    let _e44 = (*p);
    param_2 = _e44;
    let _e45 = getFromColor((&param_2));
    let _e46 = (*p);
    param_3 = _e46;
    let _e47 = getToColor((&param_3));
    let _e48 = dist;
    let _e49 = r;
    let _e52 = uniforms.fadeEdge;
    let _e55 = uniforms.progress;
    let _e59 = uniforms.fadeEdge;
    let _e61 = uniforms.progress;
    return mix(_e45, _e47, vec4(mix(0f, mix(step(_e48, _e49), 1f, smoothstep((1f - _e52), 1f, _e55)), smoothstep(0f, _e59, _e61))));
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e19 = _uv_1;
    param_4 = _e19;
    let _e20 = transition((&param_4));
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
