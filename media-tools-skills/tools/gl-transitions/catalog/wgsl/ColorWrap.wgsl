// ColorWrap — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorWrap.glsl
// Author: Yoni Maltsman @friendlyspinach
// License: MIT
// Description: Each color channel of the outgoing image is shifted and wraps around into psychedelic bands, while crossfading to the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    r_strength: f32,
    g_strength: f32,
    b_strength: f32,
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

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var from_: vec4<f32>;
    var param: vec2<f32>;
    var to: vec4<f32>;
    var param_1: vec2<f32>;
    var c: vec3<f32>;

    let _e22 = (*uv_2);
    param = _e22;
    let _e23 = getFromColor((&param));
    from_ = _e23;
    let _e24 = (*uv_2);
    param_1 = _e24;
    let _e25 = getToColor((&param_1));
    to = _e25;
    let _e26 = from_;
    let _e29 = uniforms.r_strength;
    let _e31 = uniforms.g_strength;
    let _e33 = uniforms.b_strength;
    let _e36 = uniforms.progress;
    c = (_e26.xyz + (vec3<f32>(_e29, _e31, _e33) * _e36));
    let _e39 = from_;
    let _e41 = c;
    let _e42 = vec3(1f);
    let _e48 = uniforms.progress;
    let _e51 = mix(_e39.xyz, (_e41 - (floor((_e41 / _e42)) * _e42)), vec3(smoothstep(0f, 0.1f, _e48)));
    from_[0u] = _e51.x;
    from_[1u] = _e51.y;
    from_[2u] = _e51.z;
    let _e58 = from_;
    let _e59 = to;
    let _e61 = uniforms.progress;
    return mix(_e58, _e59, vec4(_e61));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e17 = _uv_1;
    param_2 = _e17;
    let _e18 = transition((&param_2));
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
