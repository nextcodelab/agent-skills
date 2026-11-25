// Curtains — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Curtains.glsl
// Author: gre
// License: MIT
// Description: The outgoing image parts in the middle like stage curtains, gathering into shaded folds as it is pulled to the sides
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    folds: f32,
    shading: f32,
    bunch: f32,
    sway: f32,
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
    let _e32 = (*uv)[0u];
    let _e34 = (*uv)[1u];
    let _e37 = textureSampleLevel(_from, _sampler, vec2<f32>(_e32, (1f - _e34)), 0f);
    return _e37;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e32 = (*uv_1)[0u];
    let _e34 = (*uv_1)[1u];
    let _e37 = textureSampleLevel(_to, _sampler, vec2<f32>(_e32, (1f - _e34)), 0f);
    return _e37;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var lag: f32;
    var p: f32;
    var open: f32;
    var edge: f32;
    var w: f32;
    var x: f32;
    var to: vec4<f32>;
    var param: vec2<f32>;
    var shadow: f32;
    var t: f32;
    var n: f32;
    var a: f32;
    var f: f32;
    var gather: f32;
    var s: f32;
    var c: vec4<f32>;
    var local: f32;
    var param_1: vec2<f32>;
    var slope: f32;
    var diffuse: f32;
    var crease: f32;
    var light: f32;

    let _e54 = uniforms.sway;
    let _e56 = (*uv_2)[1u];
    lag = (_e54 * (1f - _e56));
    let _e60 = uniforms.progress;
    let _e61 = lag;
    let _e63 = uniforms.progress;
    p = (_e60 * (1f - (_e61 * (1f - _e63))));
    let _e68 = p;
    let _e69 = p;
    let _e70 = p;
    let _e72 = p;
    open = mix(_e68, ((_e69 * _e70) * (3f - (2f * _e72))), 0.75f);
    let _e78 = uniforms.bunch;
    let _e80 = open;
    let _e82 = open;
    edge = ((-(_e78) * _e80) * _e82);
    let _e85 = uniforms.bunch;
    let _e86 = open;
    w = mix(0.5f, _e85, _e86);
    let _e89 = (*uv_2)[0u];
    let _e91 = (*uv_2)[0u];
    let _e94 = edge;
    x = (min(_e89, (1f - _e91)) - _e94);
    let _e96 = x;
    let _e97 = w;
    if (_e96 >= _e97) {
        let _e99 = (*uv_2);
        param = _e99;
        let _e100 = getToColor((&param));
        to = _e100;
        let _e101 = w;
        let _e102 = x;
        let _e107 = edge;
        let _e108 = w;
        shadow = ((0.4f * exp(((_e101 - _e102) * 25f))) * clamp(((_e107 + _e108) * 20f), 0f, 1f));
        let _e113 = to;
        let _e115 = shadow;
        let _e116 = open;
        let _e119 = (_e113.xyz * (1f - (_e115 * _e116)));
        let _e121 = to[3u];
        return vec4<f32>(_e119.x, _e119.y, _e119.z, _e121);
    }
    let _e126 = x;
    let _e127 = w;
    t = (_e126 / _e127);
    let _e130 = uniforms.folds;
    let _e132 = uniforms.ratio;
    n = max(1f, floor(((_e130 * min(_e132, 1f)) + 0.5f)));
    let _e138 = n;
    let _e140 = t;
    a = ((6.2831855f * _e138) * _e140);
    let _e142 = open;
    let _e144 = open;
    let _e147 = open;
    f = (1f - (((1f - _e142) * (1f - _e144)) * (1f - _e147)));
    let _e151 = f;
    gather = (0.92f * _e151);
    let _e153 = t;
    let _e154 = gather;
    let _e155 = a;
    let _e158 = n;
    s = (0.5f * (_e153 + ((_e154 * sin(_e155)) / (6.2831855f * _e158))));
    let _e164 = (*uv_2)[0u];
    if (_e164 < 0.5f) {
        let _e166 = s;
        local = _e166;
    } else {
        let _e167 = s;
        local = (1f - _e167);
    }
    let _e169 = local;
    let _e171 = (*uv_2)[1u];
    param_1 = vec2<f32>(_e169, _e171);
    let _e173 = getFromColor((&param_1));
    c = _e173;
    let _e174 = gather;
    let _e176 = a;
    let _e180 = (*uv_2)[0u];
    slope = (((3f * _e174) * cos(_e176)) * select(-1f, 1f, (_e180 < 0.5f)));
    let _e184 = slope;
    let _e187 = slope;
    let _e188 = slope;
    diffuse = ((1f + (0.5f * _e184)) / sqrt((1.25f * (1f + (_e187 * _e188)))));
    let _e194 = a;
    crease = (0.5f + (0.5f * sin(_e194)));
    let _e198 = diffuse;
    let _e199 = crease;
    let _e201 = crease;
    let _e206 = uniforms.shading;
    let _e207 = f;
    light = mix(1f, (_e198 * (1f - ((0.6f * _e199) * _e201))), (_e206 * _e207));
    let _e210 = c;
    let _e212 = light;
    let _e213 = (_e210.xyz * _e212);
    let _e215 = c[3u];
    return vec4<f32>(_e213.x, _e213.y, _e213.z, _e215);
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e31 = _uv_1;
    param_2 = _e31;
    let _e32 = transition((&param_2));
    _fragColor = _e32;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
