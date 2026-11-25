// SpiralWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SpiralWipe.glsl
// Author: gre
// License: MIT
// Description: A spiral arm winds out from the center and widens to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float turns;
    float smoothness;
    int clockwise;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e25 = uv[0u];
    float _e27 = uv[1u];
    metal::float4 _e30 = _to.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e25 = uv_1[0u];
    float _e27 = uv_1[1u];
    metal::float4 _e30 = _from.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

float arm(
    thread float& s,
    thread float& d,
    constant Uniforms& uniforms
) {
    float end = {};
    float tip = {};
    float width = {};
    float e = {};
    float _e30 = uniforms.turns;
    end = -0.5 + ((_e30 + 0.5) / 0.6);
    float _e34 = end;
    float _e36 = uniforms.progress;
    tip = metal::mix(-0.5, _e34, _e36);
    float _e38 = s;
    s = metal::max(_e38, -0.5);
    float _e40 = tip;
    float _e41 = s;
    float _e43 = end;
    float _e44 = s;
    width = metal::sqrt(metal::clamp((_e40 - _e41) / metal::max(_e43 - _e44, 0.001), 0.0, 1.0));
    float _e51 = uniforms.smoothness;
    float _e53 = uniforms.turns;
    e = _e51 + (0.005 * _e53);
    float _e56 = e;
    float _e57 = width;
    float _e58 = e;
    float _e61 = d;
    return metal::smoothstep(0.0, _e56, (_e57 * (0.5 + _e58)) - _e61);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 q = {};
    float a = {};
    float local = {};
    float local_1 = {};
    float w = {};
    float n = {};
    float f = {};
    float m = {};
    float param = {};
    float param_1 = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 _e40 = uv_2;
    float _e44 = uniforms.ratio;
    float _e48 = uniforms.ratio;
    q = ((_e40 - metal::float2(0.5)) * metal::float2(_e44, 1.0)) / metal::float2(0.5 * metal::length(metal::float2(_e48, 1.0)));
    metal::float2 _e54 = q;
    metal::float2 _e55 = q;
    if (metal::dot(_e54, _e55) < 0.000000000001) {
        local = 0.0;
    } else {
        float _e59 = q[0u];
        float _e61 = q[1u];
        local = metal::atan2(_e59, _e61) / 6.2831855;
    }
    float _e64 = local;
    a = _e64;
    int _e66 = uniforms.clockwise;
    if (_e66 != 0) {
        float _e68 = a;
        local_1 = _e68;
    } else {
        float _e69 = a;
        local_1 = -(_e69);
    }
    float _e71 = local_1;
    a = metal::fract(_e71);
    metal::float2 _e73 = q;
    float _e76 = uniforms.turns;
    float _e78 = a;
    w = (metal::length(_e73) * _e76) - _e78;
    float _e80 = w;
    n = metal::floor(_e80);
    float _e82 = w;
    float _e83 = n;
    f = _e82 - _e83;
    float _e85 = n;
    float _e86 = a;
    float _e88 = f;
    param = _e85 + _e86;
    param_1 = metal::abs(_e88 - 0.5);
    float _e91 = arm(param, param_1, uniforms);
    float _e92 = n;
    float _e94 = a;
    float _e96 = f;
    param_2 = (_e92 + 1.0) + _e94;
    param_3 = 1.5 - _e96;
    float _e98 = arm(param_2, param_3, uniforms);
    float _e99 = n;
    float _e101 = a;
    float _e103 = f;
    param_4 = (_e99 - 1.0) + _e101;
    param_5 = _e103 + 0.5;
    float _e105 = arm(param_4, param_5, uniforms);
    m = metal::max(_e91, metal::max(_e98, _e105));
    metal::float2 _e108 = uv_2;
    param_6 = _e108;
    metal::float4 _e109 = getFromColor(param_6, _from, _sampler);
    metal::float2 _e110 = uv_2;
    param_7 = _e110;
    metal::float4 _e111 = getToColor(param_7, _sampler, _to);
    float _e112 = m;
    return metal::mix(_e109, _e111, metal::float4(_e112));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e24 = _uv_1;
    param_8 = _e24;
    metal::float4 _e25 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e25;
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
