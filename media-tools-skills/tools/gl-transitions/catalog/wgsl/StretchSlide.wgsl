// StretchSlide — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StretchSlide.glsl
// Author: gre
// License: MIT
// Description: The outgoing image stretches out long as it shoots away to one side, pulling in the incoming one squashed behind it, which overshoots and springs back to its shape
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    stretch: f32,
    bounce: f32,
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
    let _e29 = (*uv)[0u];
    let _e31 = (*uv)[1u];
    let _e34 = textureSampleLevel(_from, _sampler, vec2<f32>(_e29, (1f - _e31)), 0f);
    return _e34;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e29 = (*uv_1)[0u];
    let _e31 = (*uv_1)[1u];
    let _e34 = textureSampleLevel(_to, _sampler, vec2<f32>(_e29, (1f - _e31)), 0f);
    return _e34;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e28 = (*v);
    let _e29 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e28 - (floor((_e28 / _e29)) * _e29)))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dl: f32;
    var d: vec2<f32>;
    var local: vec2<f32>;
    var n: vec2<f32>;
    var ext: f32;
    var q: vec2<f32>;
    var s: f32;
    var t: f32;
    var land: f32;
    var m: f32;
    var x: f32;
    var e: f32;
    var w: f32;
    var u: f32;
    var osc: f32;
    var len: f32;
    var bulge: f32;
    var g: f32;
    var pt: vec2<f32>;
    var b: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var l: f32;
    var k: f32;
    var y: f32;
    var v_1: f32;
    var a: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e58 = uniforms.direction;
    dl = length(_e58);
    let _e60 = dl;
    if (_e60 > 0.000001f) {
        let _e63 = uniforms.direction;
        let _e64 = dl;
        local = (_e63 / vec2(_e64));
    } else {
        local = vec2<f32>(-1f, 0f);
    }
    let _e67 = local;
    d = _e67;
    let _e69 = d[1u];
    let _e72 = d[0u];
    n = vec2<f32>(-(_e69), _e72);
    let _e75 = d[0u];
    let _e78 = d[1u];
    ext = (abs(_e75) + abs(_e78));
    let _e81 = (*uv_2);
    q = (_e81 - vec2(0.5f));
    let _e84 = q;
    let _e85 = d;
    let _e87 = ext;
    s = (0.5f + (dot(_e84, _e85) / _e87));
    let _e91 = uniforms.progress;
    t = _e91;
    let _e93 = uniforms.bounce;
    land = mix(1f, 0.5f, _e93);
    let _e96 = uniforms.bounce;
    m = (3f * _e96);
    let _e98 = t;
    let _e99 = land;
    x = clamp((_e98 / _e99), 0f, 1f);
    let _e102 = x;
    let _e103 = x;
    let _e105 = x;
    let _e109 = m;
    let _e110 = x;
    let _e112 = x;
    let _e114 = x;
    e = (((_e102 * _e103) * (3f - (2f * _e105))) + (((_e109 * _e110) * _e112) * (_e114 - 1f)));
    w = 7.8539815f;
    let _e118 = t;
    let _e119 = land;
    let _e121 = land;
    u = clamp(((_e118 - _e119) / max((1f - _e121), 0.0001f)), 0f, 1f);
    let _e126 = m;
    let _e127 = land;
    let _e130 = land;
    let _e131 = w;
    let _e134 = u;
    let _e138 = w;
    let _e139 = u;
    let _e143 = u;
    let _e146 = u;
    osc = ((((((_e126 * (1f - _e127)) / (_e130 * _e131)) * exp(-(_e134))) * sin((_e138 * _e139))) * (1f - _e143)) * (1f - _e146));
    let _e149 = e;
    let _e150 = osc;
    len = (_e149 + max(_e150, 0f));
    let _e153 = e;
    let _e155 = osc;
    bulge = ((1f - _e153) + (3f * max(-(_e155), 0f)));
    let _e161 = uniforms.stretch;
    let _e163 = bulge;
    g = (1f + ((0.6f * _e161) * _e163));
    let _e166 = q;
    let _e167 = d;
    let _e168 = s;
    let _e169 = len;
    let _e172 = s;
    let _e175 = ext;
    pt = (_e166 + ((_e167 * ((_e168 / max(_e169, 0.0001f)) - _e172)) * _e175));
    let _e178 = n;
    let _e179 = pt;
    let _e180 = n;
    let _e183 = g;
    let _e187 = pt;
    pt = (_e187 - ((_e178 * dot(_e179, _e180)) * (1f - (1f / _e183))));
    let _e189 = pt;
    param = (_e189 + vec2(0.5f));
    let _e192 = mirror((&param));
    param_1 = _e192;
    let _e193 = getToColor((&param_1));
    b = _e193;
    let _e195 = uniforms.stretch;
    let _e197 = e;
    l = (1f + ((4f * _e195) * _e197));
    let _e201 = uniforms.stretch;
    let _e203 = e;
    k = clamp(((1.6f * _e201) * _e203), 0f, 0.8f);
    let _e206 = s;
    let _e207 = e;
    let _e210 = l;
    y = (max((_e206 - _e207), 0f) / _e210);
    let _e212 = y;
    let _e214 = k;
    let _e216 = k;
    let _e218 = k;
    let _e221 = k;
    let _e223 = y;
    v_1 = ((2f * _e212) / ((1f + _e214) + sqrt((((1f + _e216) * (1f + _e218)) - ((4f * _e221) * _e223)))));
    let _e229 = q;
    let _e230 = d;
    let _e231 = v_1;
    let _e232 = s;
    let _e235 = ext;
    param_2 = ((_e229 + ((_e230 * (_e231 - _e232)) * _e235)) + vec2(0.5f));
    let _e240 = mirror((&param_2));
    param_3 = _e240;
    let _e241 = getFromColor((&param_3));
    a = _e241;
    let _e242 = s;
    let _e243 = len;
    let _e245 = t;
    let _e246 = land;
    let _e249 = b;
    let _e250 = a;
    return select(_e250, _e249, vec4(((_e242 < _e243) || (_e245 >= _e246))));
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e28 = _uv_1;
    param_4 = _e28;
    let _e29 = transition((&param_4));
    _fragColor = _e29;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
