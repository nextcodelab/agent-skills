// GravityLens — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GravityLens.glsl
// Author: gre
// License: MIT
// Description: A black disk appears and grows, bending the outgoing image around it like a heavy mass bends light: the image is stretched into a bright ring at the disk's edge and swallowed until the frame is black, then the disk shrinks back, unbending the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    strength: f32,
    glow: f32,
    hole: vec4<f32>,
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
    let _e44 = (*uv)[0u];
    let _e46 = (*uv)[1u];
    let _e49 = textureSampleLevel(_to, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv_1)[0u];
    let _e46 = (*uv_1)[1u];
    let _e49 = textureSampleLevel(_from, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn mirrored(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    var m: vec2<f32>;

    let _e44 = (*v);
    let _e45 = vec2(2f);
    m = (_e44 - (floor((_e44 / _e45)) * _e45));
    let _e50 = m;
    let _e51 = m;
    let _e54 = m;
    return mix(_e50, (vec2(2f) - _e51), step(vec2(1f), _e54));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var swallowing: bool;
    var u: f32;
    var local: f32;
    var u2_: f32;
    var k: f32;
    var aspect: vec2<f32>;
    var far: vec2<f32>;
    var rh: f32;
    var re: f32;
    var d: vec2<f32>;
    var r: f32;
    var q: vec2<f32>;
    var param: vec2<f32>;
    var c: vec4<f32>;
    var local_1: vec4<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var amount: f32;
    var inner: f32;
    var g: f32;
    var einstein: f32;
    var photon: f32;
    var light: f32;
    var cov: f32;

    let _e68 = uniforms.progress;
    swallowing = (_e68 < 0.55f);
    let _e70 = swallowing;
    if _e70 {
        let _e72 = uniforms.progress;
        local = (_e72 / 0.55f);
    } else {
        let _e75 = uniforms.progress;
        local = ((1f - _e75) / 0.45f);
    }
    let _e78 = local;
    u = _e78;
    let _e79 = u;
    let _e80 = u;
    u2_ = (_e79 * _e80);
    let _e82 = u2_;
    let _e83 = u2_;
    k = (_e82 * (0.6f + (0.4f * _e83)));
    let _e88 = uniforms.ratio;
    aspect = vec2<f32>(_e88, 1f);
    let _e91 = uniforms.center;
    let _e93 = uniforms.center;
    let _e97 = aspect;
    far = (max(_e91, (vec2(1f) - _e93)) * _e97);
    let _e99 = far;
    let _e102 = k;
    rh = ((length(_e99) * 1.12f) * _e102);
    let _e104 = rh;
    let _e106 = uniforms.strength;
    re = (_e104 * (1f + max(_e106, 0f)));
    let _e110 = (*uv_2);
    let _e112 = uniforms.center;
    let _e114 = aspect;
    d = ((_e110 - _e112) * _e114);
    let _e116 = d;
    r = max(length(_e116), 0.00001f);
    let _e120 = uniforms.center;
    let _e121 = d;
    let _e122 = re;
    let _e123 = re;
    let _e125 = r;
    let _e126 = r;
    let _e131 = aspect;
    param = (_e120 + ((_e121 * (1f - ((_e122 * _e123) / (_e125 * _e126)))) / _e131));
    let _e134 = mirrored((&param));
    q = _e134;
    let _e135 = swallowing;
    if _e135 {
        let _e136 = q;
        param_1 = _e136;
        let _e137 = getFromColor((&param_1));
        local_1 = _e137;
    } else {
        let _e138 = q;
        param_2 = _e138;
        let _e139 = getToColor((&param_2));
        local_1 = _e139;
    }
    let _e140 = local_1;
    c = _e140;
    let _e141 = rh;
    amount = smoothstep(0f, 0.04f, _e141);
    let _e143 = r;
    let _e144 = rh;
    let _e146 = re;
    let _e147 = rh;
    inner = clamp(((_e143 - _e144) / ((_e146 - _e147) + 0.0001f)), 0f, 1f);
    let _e152 = amount;
    let _e154 = inner;
    let _e155 = inner;
    let _e157 = inner;
    let _e164 = c;
    let _e166 = (_e164.xyz * (1f - ((0.7f * _e152) * (1f - ((_e154 * _e155) * (3f - (2f * _e157)))))));
    c[0u] = _e166.x;
    c[1u] = _e166.y;
    c[2u] = _e166.z;
    let _e174 = uniforms.glow;
    let _e176 = amount;
    g = (max(_e174, 0f) * _e176);
    let _e178 = r;
    let _e179 = re;
    let _e181 = re;
    let _e182 = rh;
    einstein = ((_e178 - _e179) / ((0.3f * (_e181 - _e182)) + 0.01f));
    let _e187 = r;
    let _e188 = rh;
    let _e191 = rh;
    photon = (max((_e187 - _e188), 0f) / (0.006f + (0.012f * _e191)));
    let _e195 = g;
    let _e196 = einstein;
    let _e198 = einstein;
    let _e202 = photon;
    let _e204 = photon;
    light = (_e195 * ((0.7f * exp((-(_e196) * _e198))) + (1.6f * exp((-(_e202) * _e204)))));
    let _e210 = c;
    let _e212 = light;
    let _e215 = light;
    let _e218 = c[3u];
    let _e222 = min(((_e210.xyz * (1f + _e212)) + (vec3<f32>(1f, 0.86f, 0.68f) * ((0.35f * _e215) * _e218))), vec3<f32>(1f, 1f, 1f));
    c[0u] = _e222.x;
    c[1u] = _e222.y;
    c[2u] = _e222.z;
    let _e229 = rh;
    let _e230 = r;
    cov = clamp(((_e229 - _e230) / 0.004f), 0f, 1f);
    let _e234 = c;
    let _e236 = uniforms.hole;
    let _e237 = cov;
    return mix(_e234, _e236, vec4(_e237));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e43 = _uv_1;
    param_3 = _e43;
    let _e44 = transition((&param_3));
    _fragColor = _e44;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
