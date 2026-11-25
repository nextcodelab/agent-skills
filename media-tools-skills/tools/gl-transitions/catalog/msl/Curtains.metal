// Curtains — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Curtains.glsl
// Author: gre
// License: MIT
// Description: The outgoing image parts in the middle like stage curtains, gathering into shaded folds as it is pulled to the sides
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float folds;
    float shading;
    float bunch;
    float sway;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e32 = uv[0u];
    float _e34 = uv[1u];
    metal::float4 _e37 = _from.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e32 = uv_1[0u];
    float _e34 = uv_1[1u];
    metal::float4 _e37 = _to.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float lag = {};
    float p = {};
    float open = {};
    float edge = {};
    float w = {};
    float x = {};
    metal::float4 to = {};
    metal::float2 param = {};
    float shadow = {};
    float t = {};
    float n = {};
    float a = {};
    float f = {};
    float gather = {};
    float s = {};
    metal::float4 c = {};
    float local = {};
    metal::float2 param_1 = {};
    float slope = {};
    float diffuse = {};
    float crease = {};
    float light = {};
    float _e54 = uniforms.sway;
    float _e56 = uv_2[1u];
    lag = _e54 * (1.0 - _e56);
    float _e60 = uniforms.progress;
    float _e61 = lag;
    float _e63 = uniforms.progress;
    p = _e60 * (1.0 - (_e61 * (1.0 - _e63)));
    float _e68 = p;
    float _e69 = p;
    float _e70 = p;
    float _e72 = p;
    open = metal::mix(_e68, (_e69 * _e70) * (3.0 - (2.0 * _e72)), 0.75);
    float _e78 = uniforms.bunch;
    float _e80 = open;
    float _e82 = open;
    edge = (-(_e78) * _e80) * _e82;
    float _e85 = uniforms.bunch;
    float _e86 = open;
    w = metal::mix(0.5, _e85, _e86);
    float _e89 = uv_2[0u];
    float _e91 = uv_2[0u];
    float _e94 = edge;
    x = metal::min(_e89, 1.0 - _e91) - _e94;
    float _e96 = x;
    float _e97 = w;
    if (_e96 >= _e97) {
        metal::float2 _e99 = uv_2;
        param = _e99;
        metal::float4 _e100 = getToColor(param, _sampler, _to);
        to = _e100;
        float _e101 = w;
        float _e102 = x;
        float _e107 = edge;
        float _e108 = w;
        shadow = (0.4 * metal::exp((_e101 - _e102) * 25.0)) * metal::clamp((_e107 + _e108) * 20.0, 0.0, 1.0);
        metal::float4 _e113 = to;
        float _e115 = shadow;
        float _e116 = open;
        metal::float3 _e119 = _e113.xyz * (1.0 - (_e115 * _e116));
        float _e121 = to[3u];
        return metal::float4(_e119.x, _e119.y, _e119.z, _e121);
    }
    float _e126 = x;
    float _e127 = w;
    t = _e126 / _e127;
    float _e130 = uniforms.folds;
    float _e132 = uniforms.ratio;
    n = metal::max(1.0, metal::floor((_e130 * metal::min(_e132, 1.0)) + 0.5));
    float _e138 = n;
    float _e140 = t;
    a = (6.2831855 * _e138) * _e140;
    float _e142 = open;
    float _e144 = open;
    float _e147 = open;
    f = 1.0 - (((1.0 - _e142) * (1.0 - _e144)) * (1.0 - _e147));
    float _e151 = f;
    gather = 0.92 * _e151;
    float _e153 = t;
    float _e154 = gather;
    float _e155 = a;
    float _e158 = n;
    s = 0.5 * (_e153 + ((_e154 * metal::sin(_e155)) / (6.2831855 * _e158)));
    float _e164 = uv_2[0u];
    if (_e164 < 0.5) {
        float _e166 = s;
        local = _e166;
    } else {
        float _e167 = s;
        local = 1.0 - _e167;
    }
    float _e169 = local;
    float _e171 = uv_2[1u];
    param_1 = metal::float2(_e169, _e171);
    metal::float4 _e173 = getFromColor(param_1, _from, _sampler);
    c = _e173;
    float _e174 = gather;
    float _e176 = a;
    float _e180 = uv_2[0u];
    slope = ((3.0 * _e174) * metal::cos(_e176)) * ((_e180 < 0.5) ? 1.0 : -1.0);
    float _e184 = slope;
    float _e187 = slope;
    float _e188 = slope;
    diffuse = (1.0 + (0.5 * _e184)) / metal::sqrt(1.25 * (1.0 + (_e187 * _e188)));
    float _e194 = a;
    crease = 0.5 + (0.5 * metal::sin(_e194));
    float _e198 = diffuse;
    float _e199 = crease;
    float _e201 = crease;
    float _e206 = uniforms.shading;
    float _e207 = f;
    light = metal::mix(1.0, _e198 * (1.0 - ((0.6 * _e199) * _e201)), _e206 * _e207);
    metal::float4 _e210 = c;
    float _e212 = light;
    metal::float3 _e213 = _e210.xyz * _e212;
    float _e215 = c[3u];
    return metal::float4(_e213.x, _e213.y, _e213.z, _e215);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_2 = {};
    metal::float2 _e31 = _uv_1;
    param_2 = _e31;
    metal::float4 _e32 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e32;
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
