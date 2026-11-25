// CircleBurst — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CircleBurst.glsl
// Author: gre
// License: MIT
// Description: Discs of three solid colors burst out of a point one after another, each covering the last, then a hole bursts open from the same point in the last one to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    color1_: vec4<f32>,
    color2_: vec4<f32>,
    color3_: vec4<f32>,
    stagger: f32,
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
    let _e31 = (*uv)[0u];
    let _e33 = (*uv)[1u];
    let _e36 = textureSampleLevel(_to, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn layer(p: ptr<function, vec4<f32>>, c: ptr<function, vec4<f32>>, r: ptr<function, f32>, x: ptr<function, f32>) -> vec4<f32> {
    var k: f32;
    var s: f32;

    let _e35 = (*r);
    let _e37 = (*r);
    let _e39 = (*x);
    k = smoothstep((_e35 - 0.0015f), (_e37 + 0.0015f), _e39);
    let _e42 = (*c)[3u];
    let _e44 = k;
    let _e46 = (*x);
    let _e47 = (*r);
    s = (((0.32f * _e42) * _e44) * (1f - smoothstep(0f, 0.03f, (_e46 - _e47))));
    let _e52 = (*p);
    let _e53 = s;
    let _e56 = s;
    (*p) = ((_e52 * (1f - _e53)) + vec4<f32>(0f, 0f, 0f, _e56));
    let _e60 = (*c)[3u];
    let _e61 = k;
    k = (_e60 * (1f - _e61));
    let _e64 = (*p);
    let _e65 = k;
    let _e68 = (*c);
    let _e69 = _e68.xyz;
    let _e74 = k;
    return ((_e64 * (1f - _e65)) + (vec4<f32>(_e69.x, _e69.y, _e69.z, 1f) * _e74));
}

fn radius(t: ptr<function, f32>, R: ptr<function, f32>) -> f32 {
    var u: f32;

    let _e32 = (*t);
    u = (1f - _e32);
    let _e34 = (*R);
    let _e35 = (*t);
    let _e36 = u;
    let _e37 = u;
    let _e39 = u;
    return mix(-0.0315f, _e34, mix(_e35, (1f - ((_e36 * _e37) * _e39)), 0.8f));
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e31 = (*uv_1)[0u];
    let _e33 = (*uv_1)[1u];
    let _e36 = textureSampleLevel(_from, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e30 = (*v);
    let _e31 = abs(_e30);
    let _e32 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e31 - (floor((_e31 / _e32)) * _e32)))));
}

fn phase(s_1: ptr<function, f32>, d: ptr<function, f32>) -> f32 {
    let _e32 = uniforms.progress;
    let _e33 = (*s_1);
    let _e35 = (*d);
    return clamp(((_e32 - _e33) / _e35), 0f, 1f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var asp: vec2<f32>;
    var x_1: f32;
    var R_1: f32;
    var k_1: f32;
    var d_1: f32;
    var t_1: f32;
    var param: f32;
    var param_1: f32;
    var a: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var p_1: vec4<f32>;
    var param_4: f32;
    var param_5: f32;
    var param_6: vec4<f32>;
    var param_7: vec4<f32>;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: vec4<f32>;
    var param_15: vec4<f32>;
    var param_16: f32;
    var param_17: f32;
    var r_1: f32;
    var param_18: f32;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: vec4<f32>;
    var param_23: vec4<f32>;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;
    var param_27: f32;
    var h: f32;
    var param_28: f32;
    var param_29: f32;
    var u_1: f32;
    var b: vec4<f32>;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;
    var s_2: f32;
    var q: vec4<f32>;
    var local: vec4<f32>;

    let _e78 = uniforms.ratio;
    asp = vec2<f32>(_e78, 1f);
    let _e80 = (*uv_2);
    let _e82 = uniforms.center;
    let _e84 = asp;
    x_1 = length(((_e80 - _e82) * _e84));
    let _e88 = uniforms.center;
    let _e90 = uniforms.center;
    let _e94 = asp;
    R_1 = ((length((max(_e88, (vec2(1f) - _e90)) * _e94)) + 0.03f) + 0.0015f);
    let _e100 = uniforms.stagger;
    k_1 = clamp(_e100, 0f, 1f);
    let _e102 = k_1;
    d_1 = (1f / (1f + (3f * _e102)));
    param = 0f;
    let _e106 = d_1;
    param_1 = _e106;
    let _e107 = phase((&param), (&param_1));
    t_1 = _e107;
    let _e109 = uniforms.center;
    let _e110 = (*uv_2);
    let _e112 = uniforms.center;
    let _e114 = t_1;
    let _e116 = t_1;
    param_2 = (_e109 + ((_e110 - _e112) / vec2((1f + ((0.06f * _e114) * (2f - _e116))))));
    let _e123 = mirror((&param_2));
    param_3 = _e123;
    let _e124 = getFromColor((&param_3));
    a = _e124;
    let _e125 = a;
    let _e128 = a[3u];
    let _e129 = (_e125.xyz * _e128);
    let _e131 = a[3u];
    p_1 = vec4<f32>(_e129.x, _e129.y, _e129.z, _e131);
    let _e136 = t_1;
    param_4 = _e136;
    let _e137 = R_1;
    param_5 = _e137;
    let _e138 = radius((&param_4), (&param_5));
    let _e139 = p_1;
    param_6 = _e139;
    let _e141 = uniforms.color1_;
    param_7 = _e141;
    param_8 = _e138;
    let _e142 = x_1;
    param_9 = _e142;
    let _e143 = layer((&param_6), (&param_7), (&param_8), (&param_9));
    p_1 = _e143;
    let _e144 = k_1;
    let _e145 = d_1;
    param_10 = (_e144 * _e145);
    let _e147 = d_1;
    param_11 = _e147;
    let _e148 = phase((&param_10), (&param_11));
    param_12 = _e148;
    let _e149 = R_1;
    param_13 = _e149;
    let _e150 = radius((&param_12), (&param_13));
    let _e151 = p_1;
    param_14 = _e151;
    let _e153 = uniforms.color2_;
    param_15 = _e153;
    param_16 = _e150;
    let _e154 = x_1;
    param_17 = _e154;
    let _e155 = layer((&param_14), (&param_15), (&param_16), (&param_17));
    p_1 = _e155;
    let _e156 = k_1;
    let _e158 = d_1;
    param_18 = ((2f * _e156) * _e158);
    let _e160 = d_1;
    param_19 = _e160;
    let _e161 = phase((&param_18), (&param_19));
    param_20 = _e161;
    let _e162 = R_1;
    param_21 = _e162;
    let _e163 = radius((&param_20), (&param_21));
    r_1 = _e163;
    let _e164 = p_1;
    param_22 = _e164;
    let _e166 = uniforms.color3_;
    param_23 = _e166;
    let _e167 = r_1;
    param_24 = _e167;
    let _e168 = x_1;
    param_25 = _e168;
    let _e169 = layer((&param_22), (&param_23), (&param_24), (&param_25));
    p_1 = _e169;
    let _e170 = k_1;
    let _e172 = d_1;
    param_26 = ((3f * _e170) * _e172);
    let _e174 = d_1;
    param_27 = _e174;
    let _e175 = phase((&param_26), (&param_27));
    t_1 = _e175;
    let _e176 = t_1;
    param_28 = _e176;
    let _e177 = R_1;
    param_29 = _e177;
    let _e178 = radius((&param_28), (&param_29));
    h = _e178;
    let _e179 = t_1;
    u_1 = (1f - _e179);
    let _e182 = uniforms.center;
    let _e183 = (*uv_2);
    let _e185 = uniforms.center;
    let _e187 = u_1;
    let _e189 = u_1;
    let _e191 = t_1;
    param_30 = (_e182 + ((_e183 - _e185) / vec2((1f + (((0.14f * _e187) * _e189) * (1f - (2.4f * _e191)))))));
    let _e199 = mirror((&param_30));
    param_31 = _e199;
    let _e200 = getToColor((&param_31));
    b = _e200;
    let _e203 = uniforms.color3_[3u];
    let _e205 = r_1;
    let _e206 = h;
    let _e211 = h;
    let _e212 = x_1;
    s_2 = (((0.32f * _e203) * clamp(((_e205 - _e206) / 0.03f), 0f, 1f)) * (1f - smoothstep(0f, 0.03f, (_e211 - _e212))));
    let _e217 = b;
    let _e220 = b[3u];
    let _e222 = s_2;
    let _e224 = ((_e217.xyz * _e220) * (1f - _e222));
    let _e226 = b[3u];
    let _e227 = s_2;
    let _e230 = s_2;
    q = vec4<f32>(_e224.x, _e224.y, _e224.z, ((_e226 * (1f - _e227)) + _e230));
    let _e236 = p_1;
    let _e237 = q;
    let _e238 = h;
    let _e240 = h;
    let _e242 = x_1;
    p_1 = mix(_e236, _e237, vec4((1f - smoothstep((_e238 - 0.0015f), (_e240 + 0.0015f), _e242))));
    let _e248 = p_1[3u];
    if (_e248 > 0f) {
        let _e250 = p_1;
        let _e253 = p_1[3u];
        let _e255 = (_e250.xyz / vec3(_e253));
        let _e257 = p_1[3u];
        local = vec4<f32>(_e255.x, _e255.y, _e255.z, _e257);
    } else {
        local = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e262 = local;
    return _e262;
}

fn main_1() {
    var param_32: vec2<f32>;

    let _e30 = _uv_1;
    param_32 = _e30;
    let _e31 = transition((&param_32));
    _fragColor = _e31;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
