// Bounce — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Bounce.glsl
// Author: Adrian Purser
// License: MIT
// Description: The outgoing image drops out of the frame with a few bounces, revealing the incoming one
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    shadow_colour: vec4<f32>,
    shadow_height: f32,
    bounces: f32,
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
    let _e20 = (*uv)[0u];
    let _e22 = (*uv)[1u];
    let _e25 = textureSampleLevel(_from, _sampler, vec2<f32>(_e20, (1f - _e22)), 0f);
    return _e25;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e20 = (*uv_1)[0u];
    let _e22 = (*uv_1)[1u];
    let _e25 = textureSampleLevel(_to, _sampler, vec2<f32>(_e20, (1f - _e22)), 0f);
    return _e25;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var time: f32;
    var stime: f32;
    var phase: f32;
    var y: f32;
    var d: f32;
    var to: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e28 = uniforms.progress;
    time = _e28;
    let _e29 = time;
    stime = sin(((_e29 * 3.1415927f) / 2f));
    let _e33 = time;
    let _e36 = uniforms.bounces;
    phase = ((_e33 * 3.1415927f) * _e36);
    let _e38 = phase;
    let _e41 = stime;
    y = (abs(cos(_e38)) * (1f - _e41));
    let _e45 = (*uv_2)[1u];
    let _e46 = y;
    d = (_e45 - _e46);
    let _e48 = (*uv_2);
    param = _e48;
    let _e49 = getToColor((&param));
    to = _e49;
    let _e50 = to;
    let _e52 = uniforms.shadow_colour;
    let _e53 = _e52.xyz;
    let _e58 = d;
    let _e60 = uniforms.shadow_height;
    let _e62 = d;
    let _e64 = uniforms.shadow_height;
    let _e68 = uniforms.shadow_colour[3u];
    let _e72 = uniforms.shadow_colour[3u];
    let _e76 = uniforms.progress;
    let _e82 = to[3u];
    let _e87 = (*uv_2)[0u];
    let _e89 = (*uv_2)[1u];
    let _e90 = y;
    param_1 = vec2<f32>(_e87, (_e89 + (1f - _e90)));
    let _e94 = getFromColor((&param_1));
    let _e95 = d;
    return mix(mix(_e50, vec4<f32>(_e53.x, _e53.y, _e53.z, 1f), vec4(((step(_e58, _e60) * (1f - mix((((_e62 / _e64) * _e68) + (1f - _e72)), 1f, smoothstep(0.95f, 1f, _e76)))) * _e82))), _e94, vec4(step(_e95, 0f)));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e19 = _uv_1;
    param_2 = _e19;
    let _e20 = transition((&param_2));
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
