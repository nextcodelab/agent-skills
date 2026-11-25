// WedgeWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WedgeWipe.glsl
// Author: gre
// License: MIT
// Description: Two hands sweep away from each other around the center, opening a widening wedge that reveals the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    angle: f32,
    smoothness: f32,
    center: vec2<f32>,
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
    let _e19 = (*uv)[0u];
    let _e21 = (*uv)[1u];
    let _e24 = textureSampleLevel(_from, _sampler, vec2<f32>(_e19, (1f - _e21)), 0f);
    return _e24;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e19 = (*uv_1)[0u];
    let _e21 = (*uv_1)[1u];
    let _e24 = textureSampleLevel(_to, _sampler, vec2<f32>(_e19, (1f - _e21)), 0f);
    return _e24;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var q: vec2<f32>;
    var a: f32;
    var p: vec2<f32>;
    var spread: f32;
    var hand: vec2<f32>;
    var l: f32;
    var d: f32;
    var s: f32;
    var m: f32;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e31 = uniforms.progress;
    if (_e31 >= 1f) {
        let _e33 = (*uv_2);
        param = _e33;
        let _e34 = getToColor((&param));
        return _e34;
    }
    let _e35 = (*uv_2);
    let _e37 = uniforms.center;
    let _e40 = uniforms.ratio;
    q = ((_e35 - _e37) * vec2<f32>(_e40, 1f));
    let _e44 = uniforms.angle;
    a = radians(_e44);
    let _e47 = q[0u];
    let _e48 = a;
    let _e52 = q[1u];
    let _e53 = a;
    let _e59 = q[0u];
    let _e60 = a;
    let _e64 = q[1u];
    let _e65 = a;
    p = vec2<f32>(abs(((_e47 * cos(_e48)) - (_e52 * sin(_e53)))), ((_e59 * sin(_e60)) + (_e64 * cos(_e65))));
    let _e71 = uniforms.progress;
    spread = (3.1415927f * _e71);
    let _e73 = spread;
    let _e75 = spread;
    hand = vec2<f32>(sin(_e73), cos(_e75));
    let _e78 = p;
    l = length(_e78);
    let _e80 = p;
    let _e81 = hand;
    let _e82 = p;
    let _e83 = hand;
    let _e85 = l;
    let _e91 = hand[1u];
    let _e93 = p[0u];
    let _e96 = hand[0u];
    let _e98 = p[1u];
    d = (length((_e80 - (_e81 * clamp(dot(_e82, _e83), 0f, _e85)))) * sign(((_e91 * _e93) - (_e96 * _e98))));
    let _e104 = uniforms.smoothness;
    s = max(_e104, 0.001f);
    let _e106 = s;
    let _e107 = d;
    let _e108 = s;
    let _e110 = uniforms.progress;
    m = (1f - smoothstep(0f, _e106, (_e107 + (_e108 * (1f - _e110)))));
    let _e116 = (*uv_2);
    param_1 = _e116;
    let _e117 = getFromColor((&param_1));
    let _e118 = (*uv_2);
    param_2 = _e118;
    let _e119 = getToColor((&param_2));
    let _e120 = m;
    return mix(_e117, _e119, vec4(_e120));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e18 = _uv_1;
    param_3 = _e18;
    let _e19 = transition((&param_3));
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
