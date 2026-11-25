// CircleBurst — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CircleBurst.glsl
// Author: gre
// License: MIT
// Description: Discs of three solid colors burst out of a point one after another, each covering the last, then a hole bursts open from the same point in the last one to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    metal::float4 color1_;
    metal::float4 color2_;
    metal::float4 color3_;
    float stagger;
    char _pad7[12];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e31 = uv[0u];
    float _e33 = uv[1u];
    metal::float4 _e36 = _to.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float4 layer(
    thread metal::float4& p,
    thread metal::float4& c,
    thread float& r,
    thread float& x
) {
    float k = {};
    float s = {};
    float _e35 = r;
    float _e37 = r;
    float _e39 = x;
    k = metal::smoothstep(_e35 - 0.0015, _e37 + 0.0015, _e39);
    float _e42 = c[3u];
    float _e44 = k;
    float _e46 = x;
    float _e47 = r;
    s = ((0.32 * _e42) * _e44) * (1.0 - metal::smoothstep(0.0, 0.03, _e46 - _e47));
    metal::float4 _e52 = p;
    float _e53 = s;
    float _e56 = s;
    p = (_e52 * (1.0 - _e53)) + metal::float4(0.0, 0.0, 0.0, _e56);
    float _e60 = c[3u];
    float _e61 = k;
    k = _e60 * (1.0 - _e61);
    metal::float4 _e64 = p;
    float _e65 = k;
    metal::float4 _e68 = c;
    metal::float3 _e69 = _e68.xyz;
    float _e74 = k;
    return (_e64 * (1.0 - _e65)) + (metal::float4(_e69.x, _e69.y, _e69.z, 1.0) * _e74);
}

float radius(
    thread float& t,
    thread float& R
) {
    float u = {};
    float _e32 = t;
    u = 1.0 - _e32;
    float _e34 = R;
    float _e35 = t;
    float _e36 = u;
    float _e37 = u;
    float _e39 = u;
    return metal::mix(-0.0315, _e34, metal::mix(_e35, 1.0 - ((_e36 * _e37) * _e39), 0.8));
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e31 = uv_1[0u];
    float _e33 = uv_1[1u];
    metal::float4 _e36 = _from.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e30 = v;
    metal::float2 _e31 = metal::abs(_e30);
    metal::float2 _e32 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e31 - (metal::floor(_e31 / _e32) * _e32)));
}

float phase(
    thread float& s_1,
    thread float& d,
    constant Uniforms& uniforms
) {
    float _e32 = uniforms.progress;
    float _e33 = s_1;
    float _e35 = d;
    return metal::clamp((_e32 - _e33) / _e35, 0.0, 1.0);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 asp = {};
    float x_1 = {};
    float R_1 = {};
    float k_1 = {};
    float d_1 = {};
    float t_1 = {};
    float param = {};
    float param_1 = {};
    metal::float4 a = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float4 p_1 = {};
    float param_4 = {};
    float param_5 = {};
    metal::float4 param_6 = {};
    metal::float4 param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    metal::float4 param_14 = {};
    metal::float4 param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float r_1 = {};
    float param_18 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    metal::float4 param_22 = {};
    metal::float4 param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    float param_27 = {};
    float h = {};
    float param_28 = {};
    float param_29 = {};
    float u_1 = {};
    metal::float4 b = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    float s_2 = {};
    metal::float4 q = {};
    metal::float4 local = {};
    float _e78 = uniforms.ratio;
    asp = metal::float2(_e78, 1.0);
    metal::float2 _e80 = uv_2;
    metal::float2 _e82 = uniforms.center;
    metal::float2 _e84 = asp;
    x_1 = metal::length((_e80 - _e82) * _e84);
    metal::float2 _e88 = uniforms.center;
    metal::float2 _e90 = uniforms.center;
    metal::float2 _e94 = asp;
    R_1 = (metal::length(metal::max(_e88, metal::float2(1.0) - _e90) * _e94) + 0.03) + 0.0015;
    float _e100 = uniforms.stagger;
    k_1 = metal::clamp(_e100, 0.0, 1.0);
    float _e102 = k_1;
    d_1 = 1.0 / (1.0 + (3.0 * _e102));
    param = 0.0;
    float _e106 = d_1;
    param_1 = _e106;
    float _e107 = phase(param, param_1, uniforms);
    t_1 = _e107;
    metal::float2 _e109 = uniforms.center;
    metal::float2 _e110 = uv_2;
    metal::float2 _e112 = uniforms.center;
    float _e114 = t_1;
    float _e116 = t_1;
    param_2 = _e109 + ((_e110 - _e112) / metal::float2(1.0 + ((0.06 * _e114) * (2.0 - _e116))));
    metal::float2 _e123 = mirror(param_2);
    param_3 = _e123;
    metal::float4 _e124 = getFromColor(param_3, _from, _sampler);
    a = _e124;
    metal::float4 _e125 = a;
    float _e128 = a[3u];
    metal::float3 _e129 = _e125.xyz * _e128;
    float _e131 = a[3u];
    p_1 = metal::float4(_e129.x, _e129.y, _e129.z, _e131);
    float _e136 = t_1;
    param_4 = _e136;
    float _e137 = R_1;
    param_5 = _e137;
    float _e138 = radius(param_4, param_5);
    metal::float4 _e139 = p_1;
    param_6 = _e139;
    metal::float4 _e141 = uniforms.color1_;
    param_7 = _e141;
    param_8 = _e138;
    float _e142 = x_1;
    param_9 = _e142;
    metal::float4 _e143 = layer(param_6, param_7, param_8, param_9);
    p_1 = _e143;
    float _e144 = k_1;
    float _e145 = d_1;
    param_10 = _e144 * _e145;
    float _e147 = d_1;
    param_11 = _e147;
    float _e148 = phase(param_10, param_11, uniforms);
    param_12 = _e148;
    float _e149 = R_1;
    param_13 = _e149;
    float _e150 = radius(param_12, param_13);
    metal::float4 _e151 = p_1;
    param_14 = _e151;
    metal::float4 _e153 = uniforms.color2_;
    param_15 = _e153;
    param_16 = _e150;
    float _e154 = x_1;
    param_17 = _e154;
    metal::float4 _e155 = layer(param_14, param_15, param_16, param_17);
    p_1 = _e155;
    float _e156 = k_1;
    float _e158 = d_1;
    param_18 = (2.0 * _e156) * _e158;
    float _e160 = d_1;
    param_19 = _e160;
    float _e161 = phase(param_18, param_19, uniforms);
    param_20 = _e161;
    float _e162 = R_1;
    param_21 = _e162;
    float _e163 = radius(param_20, param_21);
    r_1 = _e163;
    metal::float4 _e164 = p_1;
    param_22 = _e164;
    metal::float4 _e166 = uniforms.color3_;
    param_23 = _e166;
    float _e167 = r_1;
    param_24 = _e167;
    float _e168 = x_1;
    param_25 = _e168;
    metal::float4 _e169 = layer(param_22, param_23, param_24, param_25);
    p_1 = _e169;
    float _e170 = k_1;
    float _e172 = d_1;
    param_26 = (3.0 * _e170) * _e172;
    float _e174 = d_1;
    param_27 = _e174;
    float _e175 = phase(param_26, param_27, uniforms);
    t_1 = _e175;
    float _e176 = t_1;
    param_28 = _e176;
    float _e177 = R_1;
    param_29 = _e177;
    float _e178 = radius(param_28, param_29);
    h = _e178;
    float _e179 = t_1;
    u_1 = 1.0 - _e179;
    metal::float2 _e182 = uniforms.center;
    metal::float2 _e183 = uv_2;
    metal::float2 _e185 = uniforms.center;
    float _e187 = u_1;
    float _e189 = u_1;
    float _e191 = t_1;
    param_30 = _e182 + ((_e183 - _e185) / metal::float2(1.0 + (((0.14 * _e187) * _e189) * (1.0 - (2.4 * _e191)))));
    metal::float2 _e199 = mirror(param_30);
    param_31 = _e199;
    metal::float4 _e200 = getToColor(param_31, _sampler, _to);
    b = _e200;
    float _e203 = uniforms.color3_[3u];
    float _e205 = r_1;
    float _e206 = h;
    float _e211 = h;
    float _e212 = x_1;
    s_2 = ((0.32 * _e203) * metal::clamp((_e205 - _e206) / 0.03, 0.0, 1.0)) * (1.0 - metal::smoothstep(0.0, 0.03, _e211 - _e212));
    metal::float4 _e217 = b;
    float _e220 = b[3u];
    float _e222 = s_2;
    metal::float3 _e224 = (_e217.xyz * _e220) * (1.0 - _e222);
    float _e226 = b[3u];
    float _e227 = s_2;
    float _e230 = s_2;
    q = metal::float4(_e224.x, _e224.y, _e224.z, (_e226 * (1.0 - _e227)) + _e230);
    metal::float4 _e236 = p_1;
    metal::float4 _e237 = q;
    float _e238 = h;
    float _e240 = h;
    float _e242 = x_1;
    p_1 = metal::mix(_e236, _e237, metal::float4(1.0 - metal::smoothstep(_e238 - 0.0015, _e240 + 0.0015, _e242)));
    float _e248 = p_1[3u];
    if (_e248 > 0.0) {
        metal::float4 _e250 = p_1;
        float _e253 = p_1[3u];
        metal::float3 _e255 = _e250.xyz / metal::float3(_e253);
        float _e257 = p_1[3u];
        local = metal::float4(_e255.x, _e255.y, _e255.z, _e257);
    } else {
        local = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e262 = local;
    return _e262;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_32 = {};
    metal::float2 _e30 = _uv_1;
    param_32 = _e30;
    metal::float4 _e31 = transition(param_32, _from, _sampler, _to, uniforms);
    _fragColor = _e31;
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
