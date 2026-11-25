// RotateScaleFade — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RotateScaleFade.glsl
// Author: Fernando Kuteken
// License: MIT
// Description: The outgoing image spins and zooms while fading to the incoming one, over a background color
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float rotations;
    float scale;
    char _pad5[8];
    metal::float4 backColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e20 = uv[0u];
    float _e22 = uv[1u];
    metal::float4 _e25 = _to.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e20 = uv_1[0u];
    float _e22 = uv_1[1u];
    metal::float4 _e25 = _from.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 difference = {};
    metal::float2 dir = {};
    float dist = {};
    float angle = {};
    float c = {};
    float s = {};
    float currentScale = {};
    metal::float2 rotatedDir = {};
    metal::float2 rotatedUv = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool phi_144_ = {};
    bool phi_151_ = {};
    bool phi_158_ = {};
    metal::float2 _e30 = uv_2;
    metal::float2 _e32 = uniforms.center;
    difference = _e30 - _e32;
    metal::float2 _e34 = difference;
    dir = metal::normalize(_e34);
    metal::float2 _e36 = difference;
    dist = metal::length(_e36);
    float _e39 = uniforms.rotations;
    float _e42 = uniforms.progress;
    angle = (6.2831855 * _e39) * _e42;
    float _e44 = angle;
    c = metal::cos(_e44);
    float _e46 = angle;
    s = metal::sin(_e46);
    float _e49 = uniforms.scale;
    float _e51 = uniforms.progress;
    currentScale = metal::mix(_e49, 1.0, 2.0 * metal::abs(_e51 - 0.5));
    float _e57 = dir[0u];
    float _e58 = c;
    float _e61 = dir[1u];
    float _e62 = s;
    float _e66 = dir[0u];
    float _e67 = s;
    float _e70 = dir[1u];
    float _e71 = c;
    rotatedDir = metal::float2((_e57 * _e58) - (_e61 * _e62), (_e66 * _e67) + (_e70 * _e71));
    metal::float2 _e76 = uniforms.center;
    metal::float2 _e77 = rotatedDir;
    float _e78 = dist;
    float _e80 = currentScale;
    rotatedUv = _e76 + ((_e77 * _e78) / metal::float2(_e80));
    float _e85 = rotatedUv[0u];
    bool _e86 = _e85 < 0.0;
    phi_144_ = _e86;
    if (!(_e86)) {
        float _e89 = rotatedUv[0u];
        phi_144_ = _e89 > 1.0;
    }
    bool _e92 = phi_144_;
    phi_151_ = _e92;
    if (!(_e92)) {
        float _e95 = rotatedUv[1u];
        phi_151_ = _e95 < 0.0;
    }
    bool _e98 = phi_151_;
    phi_158_ = _e98;
    if (!(_e98)) {
        float _e101 = rotatedUv[1u];
        phi_158_ = _e101 > 1.0;
    }
    bool _e104 = phi_158_;
    if (_e104) {
        metal::float4 _e106 = uniforms.backColor;
        return _e106;
    }
    metal::float2 _e107 = rotatedUv;
    param = _e107;
    metal::float4 _e108 = getFromColor(param, _from, _sampler);
    metal::float2 _e109 = rotatedUv;
    param_1 = _e109;
    metal::float4 _e110 = getToColor(param_1, _sampler, _to);
    float _e112 = uniforms.progress;
    return metal::mix(_e108, _e110, metal::float4(_e112));
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
    metal::float2 _e19 = _uv_1;
    param_2 = _e19;
    metal::float4 _e20 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e20;
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
