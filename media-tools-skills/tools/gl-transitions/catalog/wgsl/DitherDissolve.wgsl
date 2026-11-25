// DitherDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DitherDissolve.glsl
// Author: gre
// License: MIT
// Description: The incoming image appears through a regular 8x8 ordered dither pattern, like a retro computer screen
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    dotSize: f32,
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
    let _e21 = (*uv)[0u];
    let _e23 = (*uv)[1u];
    let _e26 = textureSampleLevel(_to, _sampler, vec2<f32>(_e21, (1f - _e23)), 0f);
    return _e26;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e21 = (*uv_1)[0u];
    let _e23 = (*uv_1)[1u];
    let _e26 = textureSampleLevel(_from, _sampler, vec2<f32>(_e21, (1f - _e23)), 0f);
    return _e26;
}

fn bayer(c: ptr<function, vec2<f32>>) -> f32 {
    var v: f32;
    var scale: f32;
    var i: i32;
    var bit: vec2<f32>;

    v = 0f;
    scale = 16f;
    i = 0i;
    loop {
        let _e24 = i;
        if (_e24 < 3i) {
            let _e26 = (*c);
            let _e27 = floor(_e26);
            let _e28 = vec2(2f);
            bit = (_e27 - (floor((_e27 / _e28)) * _e28));
            let _e33 = scale;
            let _e35 = bit[0u];
            let _e37 = bit[1u];
            let _e42 = bit[1u];
            let _e45 = v;
            v = (_e45 + (_e33 * ((2f * abs((_e35 - _e37))) + _e42)));
            let _e47 = (*c);
            (*c) = (_e47 * 0.5f);
            let _e49 = scale;
            scale = (_e49 * 0.25f);
            continue;
        } else {
            break;
        }
        continuing {
            let _e51 = i;
            i = (_e51 + 1i);
        }
    }
    let _e53 = v;
    return ((_e53 + 0.5f) / 64f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var cell: vec2<f32>;
    var param: vec2<f32>;
    var local: vec4<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e25 = (*uv_2);
    let _e27 = uniforms.ratio;
    let _e31 = uniforms.dotSize;
    cell = floor(((_e25 * vec2<f32>(_e27, 1f)) / vec2(_e31)));
    let _e36 = uniforms.progress;
    let _e37 = cell;
    param = _e37;
    let _e38 = bayer((&param));
    if (_e36 < _e38) {
        let _e40 = (*uv_2);
        param_1 = _e40;
        let _e41 = getFromColor((&param_1));
        local = _e41;
    } else {
        let _e42 = (*uv_2);
        param_2 = _e42;
        let _e43 = getToColor((&param_2));
        local = _e43;
    }
    let _e44 = local;
    return _e44;
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e20 = _uv_1;
    param_3 = _e20;
    let _e21 = transition((&param_3));
    _fragColor = _e21;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
