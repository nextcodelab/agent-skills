// FlyEye — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FlyEye.glsl
// Author: gre
// License: MIT
// Description: The image breaks into a fly's-eye grid of lenses with color separation
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    size: f32,
    zoom: f32,
    colorSeparation: f32,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e18 = (*uv)[0u];
    let _e20 = (*uv)[1u];
    let _e23 = textureSampleLevel(_from, _sampler, vec2<f32>(_e18, (1f - _e20)), 0f);
    return _e23;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e18 = (*uv_1)[0u];
    let _e20 = (*uv_1)[1u];
    let _e23 = textureSampleLevel(_to, _sampler, vec2<f32>(_e18, (1f - _e20)), 0f);
    return _e23;
}

fn transition(p: ptr<function, vec2<f32>>) -> vec4<f32> {
    var inv: f32;
    var disp: vec2<f32>;
    var texTo: vec4<f32>;
    var param: vec2<f32>;
    var fromCenter: vec4<f32>;
    var param_1: vec2<f32>;
    var texFrom: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e27 = uniforms.progress;
    inv = (1f - _e27);
    let _e30 = uniforms.size;
    let _e32 = uniforms.zoom;
    let _e34 = (*p)[0u];
    let _e38 = uniforms.zoom;
    let _e40 = (*p)[1u];
    disp = (vec2<f32>(cos((_e32 * _e34)), sin((_e38 * _e40))) * _e30);
    let _e45 = (*p);
    let _e46 = inv;
    let _e47 = disp;
    param = (_e45 + (_e47 * _e46));
    let _e50 = getToColor((&param));
    texTo = _e50;
    let _e51 = (*p);
    let _e53 = uniforms.progress;
    let _e54 = disp;
    param_1 = (_e51 + (_e54 * _e53));
    let _e57 = getFromColor((&param_1));
    fromCenter = _e57;
    let _e58 = (*p);
    let _e60 = uniforms.progress;
    let _e61 = disp;
    let _e64 = uniforms.colorSeparation;
    param_2 = (_e58 + ((_e61 * _e60) * (1f - _e64)));
    let _e68 = getFromColor((&param_2));
    let _e71 = fromCenter[1u];
    let _e72 = (*p);
    let _e74 = uniforms.progress;
    let _e75 = disp;
    let _e78 = uniforms.colorSeparation;
    param_3 = (_e72 + ((_e75 * _e74) * (1f + _e78)));
    let _e82 = getFromColor((&param_3));
    let _e85 = fromCenter[3u];
    texFrom = vec4<f32>(_e68.x, _e71, _e82.z, _e85);
    let _e87 = texTo;
    let _e89 = uniforms.progress;
    let _e91 = texFrom;
    let _e92 = inv;
    return ((_e87 * _e89) + (_e91 * _e92));
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e17 = _uv_1;
    param_4 = _e17;
    let _e18 = transition((&param_4));
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
