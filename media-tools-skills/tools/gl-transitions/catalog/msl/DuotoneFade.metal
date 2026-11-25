// DuotoneFade — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DuotoneFade.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is printed in two inks, shadows first, as a bold high-contrast duotone; the incoming image is printed over it in the same two inks, its dark tones landing before its highlights, then its own colors come back, highlights first
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float4 shadowInk;
    metal::float4 highlightInk;
    float contrast;
    float grain;
    char _pad6[8];
};

float dfHash(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e44 = v;
    v3_ = metal::fract(_e44.xyx * 0.1031);
    metal::float3 _e48 = v3_;
    metal::float3 _e49 = v3_;
    metal::float3 _e54 = v3_;
    v3_ = _e54 + metal::float3(metal::dot(_e48, _e49.yzx + metal::float3(33.33)));
    float _e58 = v3_[0u];
    float _e60 = v3_[1u];
    float _e63 = v3_[2u];
    return metal::fract((_e58 + _e60) * _e63);
}

float dfLuma(
    thread metal::float4& c
) {
    metal::float4 _e43 = c;
    return metal::clamp(metal::dot(_e43.xyz, metal::float3(0.299, 0.587, 0.114)), 0.0, 1.0);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e44 = uv[0u];
    float _e46 = uv[1u];
    metal::float4 _e49 = _to.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e44 = uv_1[0u];
    float _e46 = uv_1[1u];
    metal::float4 _e49 = _from.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    float la = {};
    metal::float4 param_2 = {};
    float lb = {};
    metal::float4 param_3 = {};
    metal::float2 q = {};
    float g = {};
    metal::float2 param_4 = {};
    float inks = {};
    float lift = {};
    float amount = {};
    float x = {};
    float t = {};
    float s = {};
    float c_1 = {};
    float tone = {};
    metal::float4 ink = {};
    metal::float4 base = {};
    metal::float2 _e64 = uv_2;
    param = _e64;
    metal::float4 _e65 = getFromColor(param, _from, _sampler);
    a = _e65;
    metal::float2 _e66 = uv_2;
    param_1 = _e66;
    metal::float4 _e67 = getToColor(param_1, _sampler, _to);
    b = _e67;
    metal::float4 _e68 = a;
    param_2 = _e68;
    float _e69 = dfLuma(param_2);
    la = _e69;
    metal::float4 _e70 = b;
    param_3 = _e70;
    float _e71 = dfLuma(param_3);
    lb = _e71;
    metal::float2 _e72 = uv_2;
    float _e75 = uniforms.ratio;
    float _e78 = uniforms.ratio;
    q = (_e72 * 360.0) * metal::float2(metal::max(_e75, 1.0), metal::max(1.0 / _e78, 1.0));
    metal::float2 _e83 = q;
    param_4 = metal::floor(_e83);
    float _e85 = dfHash(param_4);
    g = _e85 - 0.5;
    float _e88 = uniforms.progress;
    inks = metal::smoothstep(0.0, 0.35, _e88);
    float _e91 = uniforms.progress;
    lift = metal::smoothstep(0.65, 1.0, _e91);
    float _e93 = inks;
    float _e95 = la;
    float _e99 = lift;
    float _e102 = lb;
    amount = metal::min(metal::clamp((_e93 * 1.35) - (0.35 * _e95), 0.0, 1.0), metal::clamp(((1.0 - _e99) * 1.35) - (0.35 * _e102), 0.0, 1.0));
    float _e107 = amount;
    float _e108 = amount;
    float _e110 = amount;
    amount = (_e107 * _e108) * (3.0 - (2.0 * _e110));
    float _e115 = uniforms.progress;
    x = (metal::smoothstep(0.25, 0.75, _e115) * 1.6) - 0.3;
    float _e119 = lb;
    float _e121 = uniforms.grain;
    float _e123 = g;
    t = _e119 + ((0.2 * _e121) * _e123);
    float _e126 = t;
    float _e128 = t;
    float _e130 = x;
    s = metal::smoothstep(_e126 - 0.15, _e128 + 0.15, _e130);
    float _e133 = uniforms.contrast;
    c_1 = 0.4 * _e133;
    float _e135 = c_1;
    float _e137 = c_1;
    float _e139 = la;
    float _e140 = lb;
    float _e141 = s;
    float _e144 = uniforms.grain;
    float _e146 = g;
    tone = metal::smoothstep(_e135 + 0.03, 1.03 - _e137, metal::mix(_e139, _e140, _e141) + ((0.08 * _e144) * _e146));
    metal::float4 _e151 = uniforms.shadowInk;
    metal::float4 _e153 = uniforms.highlightInk;
    float _e154 = tone;
    ink = metal::mix(_e151, _e153, metal::float4(_e154));
    metal::float4 _e157 = a;
    float _e160 = a[3u];
    metal::float3 _e161 = _e157.xyz * _e160;
    float _e163 = a[3u];
    metal::float4 _e168 = b;
    float _e171 = b[3u];
    metal::float3 _e172 = _e168.xyz * _e171;
    float _e174 = b[3u];
    float _e179 = s;
    base = metal::mix(metal::float4(_e161.x, _e161.y, _e161.z, _e163), metal::float4(_e172.x, _e172.y, _e172.z, _e174), metal::float4(_e179));
    float _e183 = base[3u];
    if (_e183 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e185 = base;
    float _e188 = base[3u];
    metal::float4 _e191 = ink;
    float _e193 = amount;
    float _e195 = ink[3u];
    metal::float3 _e198 = metal::mix(_e185.xyz / metal::float3(_e188), _e191.xyz, metal::float3(_e193 * _e195));
    float _e200 = base[3u];
    return metal::float4(_e198.x, _e198.y, _e198.z, _e200);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_5 = {};
    metal::float2 _e43 = _uv_1;
    param_5 = _e43;
    metal::float4 _e44 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e44;
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
