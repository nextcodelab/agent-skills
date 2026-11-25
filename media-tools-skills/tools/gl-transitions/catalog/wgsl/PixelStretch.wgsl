// PixelStretch — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PixelStretch.glsl
// Author: gre
// License: MIT
// Description: A line sweeps across the frame and drags the outgoing image's pixels behind it as long streaks, which shorten as it goes and reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    stretch: f32,
    chroma: f32,
    softness: f32,
    jitter: f32,
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
    let _e41 = (*uv)[0u];
    let _e43 = (*uv)[1u];
    let _e46 = textureSampleLevel(_to, _sampler, vec2<f32>(_e41, (1f - _e43)), 0f);
    return _e46;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e41 = (*uv_1)[0u];
    let _e43 = (*uv_1)[1u];
    let _e46 = textureSampleLevel(_from, _sampler, vec2<f32>(_e41, (1f - _e43)), 0f);
    return _e46;
}

fn at(uv_2: ptr<function, vec2<f32>>, s0_: ptr<function, f32>, s: ptr<function, f32>, d: ptr<function, vec2<f32>>, ext: ptr<function, f32>) -> vec2<f32> {
    let _e44 = (*uv_2);
    let _e45 = (*d);
    let _e46 = (*s);
    let _e47 = (*s0_);
    let _e50 = (*ext);
    return clamp((_e44 + ((_e45 * (_e46 - _e47)) * _e50)), vec2(0f), vec2(1f));
}

fn smax(x: ptr<function, f32>, y: ptr<function, f32>, k: ptr<function, f32>) -> f32 {
    var h: f32;

    let _e43 = (*k);
    let _e44 = (*x);
    let _e45 = (*y);
    let _e50 = (*k);
    h = (max((_e43 - abs((_e44 - _e45))), 0f) / _e50);
    let _e52 = (*x);
    let _e53 = (*y);
    let _e55 = h;
    let _e56 = h;
    let _e58 = (*k);
    return (max(_e52, _e53) + (((_e55 * _e56) * _e58) * 0.25f));
}

fn hash(n: ptr<function, f32>) -> f32 {
    let _e40 = (*n);
    (*n) = fract((_e40 * 0.1031f));
    let _e43 = (*n);
    let _e45 = (*n);
    (*n) = (_e45 * (_e43 + 33.33f));
    let _e47 = (*n);
    let _e48 = (*n);
    let _e50 = (*n);
    (*n) = (_e50 * (_e47 + _e48));
    let _e52 = (*n);
    return fract(_e52);
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var d_1: vec2<f32>;
    var ext_1: f32;
    var s_1: f32;
    var n_1: vec2<f32>;
    var t: f32;
    var row: f32;
    var clump: f32;
    var rnd: f32;
    var param: f32;
    var param_1: f32;
    var p: f32;
    var k_1: f32;
    var margin: f32;
    var a: f32;
    var h_1: f32;
    var len: f32;
    var split: f32;
    var fr: vec4<f32>;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: f32;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: vec2<f32>;
    var fg: vec4<f32>;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: vec2<f32>;
    var param_15: f32;
    var param_16: f32;
    var param_17: vec2<f32>;
    var param_18: f32;
    var param_19: vec2<f32>;
    var fb: vec4<f32>;
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: vec2<f32>;
    var param_24: f32;
    var param_25: f32;
    var param_26: vec2<f32>;
    var param_27: f32;
    var param_28: vec2<f32>;
    var streak: vec4<f32>;
    var behind: f32;
    var param_29: f32;
    var w: f32;
    var param_30: vec2<f32>;

    let _e93 = uniforms.direction;
    d_1 = normalize((_e93 + vec2<f32>(0.000001f, 0f)));
    let _e97 = d_1[0u];
    let _e100 = d_1[1u];
    ext_1 = (abs(_e97) + abs(_e100));
    let _e103 = (*uv_3);
    let _e106 = d_1;
    let _e108 = ext_1;
    s_1 = (0.5f + (dot((_e103 - vec2(0.5f)), _e106) / _e108));
    let _e112 = d_1[1u];
    let _e115 = d_1[0u];
    n_1 = vec2<f32>(-(_e112), _e115);
    let _e117 = (*uv_3);
    let _e121 = uniforms.ratio;
    let _e124 = n_1;
    t = dot(((_e117 - vec2(0.5f)) * vec2<f32>(_e121, 1f)), _e124);
    let _e126 = t;
    row = floor((_e126 * 540f));
    let _e129 = t;
    clump = floor((_e129 * 60f));
    let _e132 = row;
    param = (_e132 + 17f);
    let _e134 = hash((&param));
    let _e136 = clump;
    param_1 = (_e136 + 311f);
    let _e138 = hash((&param_1));
    rnd = ((0.6f * _e134) + (0.4f * _e138));
    let _e142 = uniforms.progress;
    p = _e142;
    let _e144 = uniforms.softness;
    k_1 = (_e144 + 0.0001f);
    let _e146 = k_1;
    margin = (_e146 + 0.002f);
    let _e148 = margin;
    let _e150 = margin;
    let _e152 = p;
    let _e153 = p;
    let _e154 = p;
    let _e156 = p;
    a = mix(-(_e148), (1f + _e150), mix(_e152, ((_e153 * _e154) * (3f - (2f * _e156))), 0.5f));
    let _e162 = a;
    let _e164 = a;
    h_1 = clamp(((4f * _e162) * (1f - _e164)), 0f, 1f);
    let _e169 = uniforms.stretch;
    let _e170 = h_1;
    let _e173 = uniforms.jitter;
    let _e175 = rnd;
    len = ((_e169 * _e170) * (1f - ((0.6f * _e173) * _e175)));
    let _e180 = uniforms.chroma;
    let _e182 = h_1;
    split = ((0.02f * _e180) * _e182);
    let _e184 = a;
    let _e185 = split;
    let _e187 = s_1;
    param_2 = _e187;
    param_3 = (_e184 + _e185);
    let _e188 = k_1;
    param_4 = _e188;
    let _e189 = smax((&param_2), (&param_3), (&param_4));
    let _e190 = (*uv_3);
    param_5 = _e190;
    let _e191 = s_1;
    param_6 = _e191;
    param_7 = _e189;
    let _e192 = d_1;
    param_8 = _e192;
    let _e193 = ext_1;
    param_9 = _e193;
    let _e194 = at((&param_5), (&param_6), (&param_7), (&param_8), (&param_9));
    param_10 = _e194;
    let _e195 = getFromColor((&param_10));
    fr = _e195;
    let _e196 = s_1;
    param_11 = _e196;
    let _e197 = a;
    param_12 = _e197;
    let _e198 = k_1;
    param_13 = _e198;
    let _e199 = smax((&param_11), (&param_12), (&param_13));
    let _e200 = (*uv_3);
    param_14 = _e200;
    let _e201 = s_1;
    param_15 = _e201;
    param_16 = _e199;
    let _e202 = d_1;
    param_17 = _e202;
    let _e203 = ext_1;
    param_18 = _e203;
    let _e204 = at((&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    param_19 = _e204;
    let _e205 = getFromColor((&param_19));
    fg = _e205;
    let _e206 = a;
    let _e207 = split;
    let _e209 = s_1;
    param_20 = _e209;
    param_21 = (_e206 - _e207);
    let _e210 = k_1;
    param_22 = _e210;
    let _e211 = smax((&param_20), (&param_21), (&param_22));
    let _e212 = (*uv_3);
    param_23 = _e212;
    let _e213 = s_1;
    param_24 = _e213;
    param_25 = _e211;
    let _e214 = d_1;
    param_26 = _e214;
    let _e215 = ext_1;
    param_27 = _e215;
    let _e216 = at((&param_23), (&param_24), (&param_25), (&param_26), (&param_27));
    param_28 = _e216;
    let _e217 = getFromColor((&param_28));
    fb = _e217;
    let _e219 = fr[0u];
    let _e221 = fg[1u];
    let _e223 = fb[2u];
    let _e225 = fg[3u];
    streak = vec4<f32>(_e219, _e221, _e223, _e225);
    let _e227 = s_1;
    let _e228 = a;
    behind = step(_e227, _e228);
    let _e231 = uniforms.jitter;
    let _e233 = h_1;
    let _e235 = row;
    param_29 = ((_e235 * 3f) + 5f);
    let _e238 = hash((&param_29));
    let _e241 = behind;
    let _e244 = streak;
    let _e246 = (_e244.xyz * (1f + ((((0.06f * _e231) * _e233) * (_e238 - 0.5f)) * _e241)));
    streak[0u] = _e246.x;
    streak[1u] = _e246.y;
    streak[2u] = _e246.z;
    let _e253 = len;
    let _e254 = k_1;
    let _e256 = len;
    let _e257 = k_1;
    let _e259 = a;
    let _e260 = s_1;
    w = smoothstep((_e253 - _e254), (_e256 + _e257), (_e259 - _e260));
    let _e263 = streak;
    let _e264 = (*uv_3);
    param_30 = _e264;
    let _e265 = getToColor((&param_30));
    let _e266 = w;
    return mix(_e263, _e265, vec4(_e266));
}

fn main_1() {
    var param_31: vec2<f32>;

    let _e40 = _uv_1;
    param_31 = _e40;
    let _e41 = transition((&param_31));
    _fragColor = _e41;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
