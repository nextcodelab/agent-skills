// Tunnel — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Tunnel.glsl
// Author: gre
// License: MIT
// Description: The camera flies down a tunnel lined with the outgoing image toward the incoming one, which opens at its far end and grows to fill the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    speed: f32,
    twist: f32,
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
    let _e25 = (*uv)[0u];
    let _e27 = (*uv)[1u];
    let _e30 = textureSampleLevel(_to, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e25 = (*uv_1)[0u];
    let _e27 = (*uv_1)[1u];
    let _e30 = textureSampleLevel(_from, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn rotate(v: ptr<function, vec2<f32>>, a: ptr<function, f32>) -> vec2<f32> {
    var c: f32;
    var s: f32;

    let _e27 = (*a);
    c = cos(_e27);
    let _e29 = (*a);
    s = sin(_e29);
    let _e31 = c;
    let _e33 = (*v)[0u];
    let _e35 = s;
    let _e37 = (*v)[1u];
    let _e40 = s;
    let _e42 = (*v)[0u];
    let _e44 = c;
    let _e46 = (*v)[1u];
    return vec2<f32>(((_e31 * _e33) - (_e35 * _e37)), ((_e40 * _e42) + (_e44 * _e46)));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var aspect: vec2<f32>;
    var c_1: vec2<f32>;
    var r: f32;
    var R: f32;
    var far: f32;
    var e: f32;
    var d: f32;
    var t: f32;
    var k: f32;
    var local: f32;
    var a_1: f32;
    var walls: vec4<f32>;
    var param: vec2<f32>;
    var param_1: f32;
    var param_2: vec2<f32>;
    var open: f32;
    var q: vec2<f32>;
    var inside: vec2<f32>;
    var param_3: vec2<f32>;

    let _e44 = uniforms.ratio;
    aspect = vec2<f32>(_e44, 1f);
    let _e46 = (*uv_2);
    let _e49 = aspect;
    c_1 = ((_e46 - vec2(0.5f)) * _e49);
    let _e51 = c_1;
    r = length(_e51);
    let _e53 = aspect;
    R = length((_e53 * 0.5f));
    let _e57 = uniforms.speed;
    far = (1f + _e57);
    let _e60 = uniforms.progress;
    let _e62 = uniforms.progress;
    let _e64 = uniforms.progress;
    let _e67 = uniforms.progress;
    e = mix(_e60, ((_e62 * _e64) * (3f - (2f * _e67))), 0.7f);
    let _e72 = far;
    let _e73 = e;
    d = pow(_e72, (1f - _e73));
    let _e76 = far;
    let _e77 = d;
    t = (_e76 - _e77);
    let _e79 = r;
    let _e80 = d;
    let _e82 = R;
    if ((_e79 * _e80) < _e82) {
        let _e84 = d;
        let _e85 = far;
        local = (_e84 / _e85);
    } else {
        let _e87 = R;
        let _e88 = R;
        let _e89 = t;
        let _e90 = r;
        local = (_e87 / (_e88 + (_e89 * _e90)));
    }
    let _e94 = local;
    k = _e94;
    let _e96 = uniforms.twist;
    let _e97 = t;
    let _e98 = r;
    let _e100 = R;
    let _e102 = t;
    let _e103 = d;
    a_1 = (_e96 * min(((_e97 * _e98) / _e100), (_e102 / _e103)));
    let _e107 = c_1;
    let _e108 = k;
    param = (_e107 * _e108);
    let _e110 = a_1;
    param_1 = _e110;
    let _e111 = rotate((&param), (&param_1));
    let _e112 = aspect;
    param_2 = (vec2(0.5f) + (_e111 / _e112));
    let _e116 = getFromColor((&param_2));
    walls = _e116;
    let _e117 = k;
    let _e121 = walls;
    let _e123 = (_e121.xyz * (0.4f + (0.6f * sqrt(_e117))));
    walls[0u] = _e123.x;
    walls[1u] = _e123.y;
    walls[2u] = _e123.z;
    let _e131 = uniforms.progress;
    open = smoothstep(0f, 0.6f, _e131);
    let _e133 = (*uv_2);
    let _e136 = d;
    let _e138 = open;
    q = (vec2(0.5f) + (((_e133 - vec2(0.5f)) * _e136) / vec2(max(_e138, 0.0001f))));
    let _e144 = q;
    let _e147 = q;
    inside = (step(vec2(0f), _e144) * step(_e147, vec2<f32>(1f, 1f)));
    let _e150 = walls;
    let _e151 = q;
    param_3 = _e151;
    let _e152 = getToColor((&param_3));
    let _e154 = inside[0u];
    let _e156 = inside[1u];
    let _e158 = r;
    let _e159 = d;
    let _e161 = R;
    return mix(_e150, _e152, vec4(((_e154 * _e156) * step((_e158 * _e159), _e161))));
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e24 = _uv_1;
    param_4 = _e24;
    let _e25 = transition((&param_4));
    _fragColor = _e25;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
