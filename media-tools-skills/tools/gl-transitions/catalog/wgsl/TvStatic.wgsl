// TvStatic — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvStatic.glsl
// Author: Brandon Anzaldi
// License: MIT
// Description: Cuts to full-screen TV static, then to the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    offset: f32,
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

fn noise(co: ptr<function, vec2<f32>>) -> f32 {
    var a: f32;
    var b: f32;
    var c: f32;
    var dt: f32;
    var sn: f32;

    a = 12.9898f;
    b = 78.233f;
    c = 43758.547f;
    let _e23 = (*co);
    let _e25 = uniforms.progress;
    let _e27 = a;
    let _e28 = b;
    dt = dot((_e23 * _e25), vec2<f32>(_e27, _e28));
    let _e31 = dt;
    sn = (_e31 - (floor((_e31 / 3.14f)) * 3.14f));
    let _e36 = sn;
    let _e38 = c;
    return fract((sin(_e36) * _e38));
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

fn transition(p: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;

    let _e24 = uniforms.progress;
    let _e26 = uniforms.offset;
    if (_e24 < _e26) {
        let _e28 = (*p);
        param = _e28;
        let _e29 = getFromColor((&param));
        return _e29;
    } else {
        let _e31 = uniforms.progress;
        let _e33 = uniforms.offset;
        if (_e31 > (1f - _e33)) {
            let _e36 = (*p);
            param_1 = _e36;
            let _e37 = getToColor((&param_1));
            return _e37;
        } else {
            let _e38 = (*p);
            param_2 = _e38;
            let _e39 = noise((&param_2));
            let _e40 = vec3(_e39);
            let _e41 = (*p);
            param_3 = _e41;
            let _e42 = getFromColor((&param_3));
            let _e44 = (*p);
            param_4 = _e44;
            let _e45 = getToColor((&param_4));
            return vec4<f32>(_e40.x, _e40.y, _e40.z, max(_e42.w, _e45.w));
        }
    }
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e18 = _uv_1;
    param_5 = _e18;
    let _e19 = transition((&param_5));
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
