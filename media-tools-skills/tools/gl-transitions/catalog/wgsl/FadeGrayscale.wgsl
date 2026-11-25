// FadeGrayscale — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FadeGrayscale.glsl
// Author: gre
// License: MIT
// Description: A crossfade through grayscale
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    intensity: f32,
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

fn grayscale(color: ptr<function, vec3<f32>>) -> vec3<f32> {
    let _e19 = (*color)[0u];
    let _e22 = (*color)[1u];
    let _e26 = (*color)[2u];
    return vec3((((0.2126f * _e19) + (0.7152f * _e22)) + (0.0722f * _e26)));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e19 = (*uv)[0u];
    let _e21 = (*uv)[1u];
    let _e24 = textureSampleLevel(_to, _sampler, vec2<f32>(_e19, (1f - _e21)), 0f);
    return _e24;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e19 = (*uv_1)[0u];
    let _e21 = (*uv_1)[1u];
    let _e24 = textureSampleLevel(_from, _sampler, vec2<f32>(_e19, (1f - _e21)), 0f);
    return _e24;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var fc: vec4<f32>;
    var param: vec2<f32>;
    var tc: vec4<f32>;
    var param_1: vec2<f32>;
    var param_2: vec3<f32>;
    var param_3: vec3<f32>;

    let _e24 = (*uv_2);
    param = _e24;
    let _e25 = getFromColor((&param));
    fc = _e25;
    let _e26 = (*uv_2);
    param_1 = _e26;
    let _e27 = getToColor((&param_1));
    tc = _e27;
    let _e28 = fc;
    param_2 = _e28.xyz;
    let _e30 = grayscale((&param_2));
    let _e32 = fc[3u];
    let _e37 = fc;
    let _e39 = uniforms.intensity;
    let _e42 = uniforms.progress;
    let _e46 = tc;
    param_3 = _e46.xyz;
    let _e48 = grayscale((&param_3));
    let _e50 = tc[3u];
    let _e55 = tc;
    let _e57 = uniforms.intensity;
    let _e59 = uniforms.progress;
    let _e64 = uniforms.progress;
    return mix(mix(vec4<f32>(_e30.x, _e30.y, _e30.z, _e32), _e37, vec4(smoothstep((1f - _e39), 0f, _e42))), mix(vec4<f32>(_e48.x, _e48.y, _e48.z, _e50), _e55, vec4(smoothstep(_e57, 1f, _e59))), vec4(_e64));
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e18 = _uv_1;
    param_4 = _e18;
    let _e19 = transition((&param_4));
    _fragColor = _e19;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
