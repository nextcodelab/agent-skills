// PixelStretch — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PixelStretch.glsl
// Author: gre
// License: MIT
// Description: A line sweeps across the frame and drags the outgoing image's pixels behind it as long streaks, which shorten as it goes and reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float stretch;
    float chroma;
    float softness;
    float jitter;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e41 = uv[0u];
    float _e43 = uv[1u];
    metal::float4 _e46 = _to.sample(_sampler, metal::float2(_e41, 1.0 - _e43), metal::level(0.0));
    return _e46;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e41 = uv_1[0u];
    float _e43 = uv_1[1u];
    metal::float4 _e46 = _from.sample(_sampler, metal::float2(_e41, 1.0 - _e43), metal::level(0.0));
    return _e46;
}

metal::float2 at(
    thread metal::float2& uv_2,
    thread float& s0_,
    thread float& s,
    thread metal::float2& d,
    thread float& ext
) {
    metal::float2 _e44 = uv_2;
    metal::float2 _e45 = d;
    float _e46 = s;
    float _e47 = s0_;
    float _e50 = ext;
    return metal::clamp(_e44 + ((_e45 * (_e46 - _e47)) * _e50), metal::float2(0.0), metal::float2(1.0));
}

float smax(
    thread float& x,
    thread float& y,
    thread float& k
) {
    float h = {};
    float _e43 = k;
    float _e44 = x;
    float _e45 = y;
    float _e50 = k;
    h = metal::max(_e43 - metal::abs(_e44 - _e45), 0.0) / _e50;
    float _e52 = x;
    float _e53 = y;
    float _e55 = h;
    float _e56 = h;
    float _e58 = k;
    return metal::max(_e52, _e53) + (((_e55 * _e56) * _e58) * 0.25);
}

float hash(
    thread float& n
) {
    float _e40 = n;
    n = metal::fract(_e40 * 0.1031);
    float _e43 = n;
    float _e45 = n;
    n = _e45 * (_e43 + 33.33);
    float _e47 = n;
    float _e48 = n;
    float _e50 = n;
    n = _e50 * (_e47 + _e48);
    float _e52 = n;
    return metal::fract(_e52);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 d_1 = {};
    float ext_1 = {};
    float s_1 = {};
    metal::float2 n_1 = {};
    float t = {};
    float row = {};
    float clump = {};
    float rnd = {};
    float param = {};
    float param_1 = {};
    float p = {};
    float k_1 = {};
    float margin = {};
    float a = {};
    float h_1 = {};
    float len = {};
    float split = {};
    metal::float4 fr = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float param_7 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    metal::float2 param_10 = {};
    metal::float4 fg = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    float param_16 = {};
    metal::float2 param_17 = {};
    float param_18 = {};
    metal::float2 param_19 = {};
    metal::float4 fb = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    metal::float2 param_23 = {};
    float param_24 = {};
    float param_25 = {};
    metal::float2 param_26 = {};
    float param_27 = {};
    metal::float2 param_28 = {};
    metal::float4 streak = {};
    float behind = {};
    float param_29 = {};
    float w = {};
    metal::float2 param_30 = {};
    metal::float2 _e93 = uniforms.direction;
    d_1 = metal::normalize(_e93 + metal::float2(0.000001, 0.0));
    float _e97 = d_1[0u];
    float _e100 = d_1[1u];
    ext_1 = metal::abs(_e97) + metal::abs(_e100);
    metal::float2 _e103 = uv_3;
    metal::float2 _e106 = d_1;
    float _e108 = ext_1;
    s_1 = 0.5 + (metal::dot(_e103 - metal::float2(0.5), _e106) / _e108);
    float _e112 = d_1[1u];
    float _e115 = d_1[0u];
    n_1 = metal::float2(-(_e112), _e115);
    metal::float2 _e117 = uv_3;
    float _e121 = uniforms.ratio;
    metal::float2 _e124 = n_1;
    t = metal::dot((_e117 - metal::float2(0.5)) * metal::float2(_e121, 1.0), _e124);
    float _e126 = t;
    row = metal::floor(_e126 * 540.0);
    float _e129 = t;
    clump = metal::floor(_e129 * 60.0);
    float _e132 = row;
    param = _e132 + 17.0;
    float _e134 = hash(param);
    float _e136 = clump;
    param_1 = _e136 + 311.0;
    float _e138 = hash(param_1);
    rnd = (0.6 * _e134) + (0.4 * _e138);
    float _e142 = uniforms.progress;
    p = _e142;
    float _e144 = uniforms.softness;
    k_1 = _e144 + 0.0001;
    float _e146 = k_1;
    margin = _e146 + 0.002;
    float _e148 = margin;
    float _e150 = margin;
    float _e152 = p;
    float _e153 = p;
    float _e154 = p;
    float _e156 = p;
    a = metal::mix(-(_e148), 1.0 + _e150, metal::mix(_e152, (_e153 * _e154) * (3.0 - (2.0 * _e156)), 0.5));
    float _e162 = a;
    float _e164 = a;
    h_1 = metal::clamp((4.0 * _e162) * (1.0 - _e164), 0.0, 1.0);
    float _e169 = uniforms.stretch;
    float _e170 = h_1;
    float _e173 = uniforms.jitter;
    float _e175 = rnd;
    len = (_e169 * _e170) * (1.0 - ((0.6 * _e173) * _e175));
    float _e180 = uniforms.chroma;
    float _e182 = h_1;
    split = (0.02 * _e180) * _e182;
    float _e184 = a;
    float _e185 = split;
    float _e187 = s_1;
    param_2 = _e187;
    param_3 = _e184 + _e185;
    float _e188 = k_1;
    param_4 = _e188;
    float _e189 = smax(param_2, param_3, param_4);
    metal::float2 _e190 = uv_3;
    param_5 = _e190;
    float _e191 = s_1;
    param_6 = _e191;
    param_7 = _e189;
    metal::float2 _e192 = d_1;
    param_8 = _e192;
    float _e193 = ext_1;
    param_9 = _e193;
    metal::float2 _e194 = at(param_5, param_6, param_7, param_8, param_9);
    param_10 = _e194;
    metal::float4 _e195 = getFromColor(param_10, _from, _sampler);
    fr = _e195;
    float _e196 = s_1;
    param_11 = _e196;
    float _e197 = a;
    param_12 = _e197;
    float _e198 = k_1;
    param_13 = _e198;
    float _e199 = smax(param_11, param_12, param_13);
    metal::float2 _e200 = uv_3;
    param_14 = _e200;
    float _e201 = s_1;
    param_15 = _e201;
    param_16 = _e199;
    metal::float2 _e202 = d_1;
    param_17 = _e202;
    float _e203 = ext_1;
    param_18 = _e203;
    metal::float2 _e204 = at(param_14, param_15, param_16, param_17, param_18);
    param_19 = _e204;
    metal::float4 _e205 = getFromColor(param_19, _from, _sampler);
    fg = _e205;
    float _e206 = a;
    float _e207 = split;
    float _e209 = s_1;
    param_20 = _e209;
    param_21 = _e206 - _e207;
    float _e210 = k_1;
    param_22 = _e210;
    float _e211 = smax(param_20, param_21, param_22);
    metal::float2 _e212 = uv_3;
    param_23 = _e212;
    float _e213 = s_1;
    param_24 = _e213;
    param_25 = _e211;
    metal::float2 _e214 = d_1;
    param_26 = _e214;
    float _e215 = ext_1;
    param_27 = _e215;
    metal::float2 _e216 = at(param_23, param_24, param_25, param_26, param_27);
    param_28 = _e216;
    metal::float4 _e217 = getFromColor(param_28, _from, _sampler);
    fb = _e217;
    float _e219 = fr[0u];
    float _e221 = fg[1u];
    float _e223 = fb[2u];
    float _e225 = fg[3u];
    streak = metal::float4(_e219, _e221, _e223, _e225);
    float _e227 = s_1;
    float _e228 = a;
    behind = metal::step(_e227, _e228);
    float _e231 = uniforms.jitter;
    float _e233 = h_1;
    float _e235 = row;
    param_29 = (_e235 * 3.0) + 5.0;
    float _e238 = hash(param_29);
    float _e241 = behind;
    metal::float4 _e244 = streak;
    metal::float3 _e246 = _e244.xyz * (1.0 + ((((0.06 * _e231) * _e233) * (_e238 - 0.5)) * _e241));
    streak[0u] = _e246.x;
    streak[1u] = _e246.y;
    streak[2u] = _e246.z;
    float _e253 = len;
    float _e254 = k_1;
    float _e256 = len;
    float _e257 = k_1;
    float _e259 = a;
    float _e260 = s_1;
    w = metal::smoothstep(_e253 - _e254, _e256 + _e257, _e259 - _e260);
    metal::float4 _e263 = streak;
    metal::float2 _e264 = uv_3;
    param_30 = _e264;
    metal::float4 _e265 = getToColor(param_30, _sampler, _to);
    float _e266 = w;
    return metal::mix(_e263, _e265, metal::float4(_e266));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_31 = {};
    metal::float2 _e40 = _uv_1;
    param_31 = _e40;
    metal::float4 _e41 = transition(param_31, _from, _sampler, _to, uniforms);
    _fragColor = _e41;
    return;
}

struct main_Input {
    metal::float2 _uv [[user(loc0), center_perspective]];
};
struct main_Output {
    metal::float4 member [[color(0)]];
};
fragment main_Output main_(
  main_Input varyings [[stage_in]]
, metal::texture2d<float, metal::access::sample> _from [[texture(0)]]
, metal::sampler _sampler [[sampler(0)]]
, metal::texture2d<float, metal::access::sample> _to [[texture(1)]]
, constant Uniforms& uniforms [[buffer(0)]]
) {
    metal::float4 _fragColor = {};
    metal::float2 _uv_1 = {};
    const auto _uv = varyings._uv;
    _uv_1 = _uv;
    main_1(_from, _sampler, _to, uniforms, _fragColor, _uv_1);
    metal::float4 _e3 = _fragColor;
    return main_Output { _e3 };
}
