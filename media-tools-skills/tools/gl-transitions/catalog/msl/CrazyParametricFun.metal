// CrazyParametricFun — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CrazyParametricFun.glsl
// Author: mandubian
// License: MIT
// Description: The outgoing image is pulled along a parametric curve into a psychedelic swirl
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float a;
    float b;
    float amplitude;
    float smoothness;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e21 = uv[0u];
    float _e23 = uv[1u];
    metal::float4 _e26 = _to.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e21 = uv_1[0u];
    float _e23 = uv_1[1u];
    metal::float4 _e26 = _from.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p = {};
    metal::float2 dir = {};
    float dist = {};
    float x = {};
    float y = {};
    metal::float2 offset = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e28 = uv_2;
    p = _e28 / metal::float2(1.0, 1.0);
    metal::float2 _e30 = p;
    dir = _e30 - metal::float2(0.5, 0.5);
    metal::float2 _e32 = dir;
    dist = metal::length(_e32);
    float _e35 = uniforms.a;
    float _e37 = uniforms.b;
    float _e40 = uniforms.progress;
    float _e44 = uniforms.b;
    float _e46 = uniforms.progress;
    float _e48 = uniforms.a;
    float _e50 = uniforms.b;
    x = ((_e35 - _e37) * metal::cos(_e40)) + (_e44 * metal::cos(_e46 * ((_e48 / _e50) - 1.0)));
    float _e58 = uniforms.a;
    float _e60 = uniforms.b;
    float _e63 = uniforms.progress;
    float _e67 = uniforms.b;
    float _e69 = uniforms.progress;
    float _e71 = uniforms.a;
    float _e73 = uniforms.b;
    y = ((_e58 - _e60) * metal::sin(_e63)) - (_e67 * metal::sin(_e69 * ((_e71 / _e73) - 1.0)));
    metal::float2 _e80 = dir;
    float _e82 = uniforms.progress;
    float _e83 = dist;
    float _e86 = uniforms.amplitude;
    float _e88 = x;
    float _e92 = uniforms.progress;
    float _e93 = dist;
    float _e96 = uniforms.amplitude;
    float _e98 = y;
    float _e104 = uniforms.smoothness;
    offset = (_e80 * metal::float2(metal::sin(((_e82 * _e83) * _e86) * _e88), metal::sin(((_e92 * _e93) * _e96) * _e98))) / metal::float2(_e104);
    metal::float2 _e107 = p;
    metal::float2 _e108 = offset;
    param = _e107 + _e108;
    metal::float4 _e110 = getFromColor(param, _from, _sampler);
    metal::float2 _e111 = p;
    param_1 = _e111;
    metal::float4 _e112 = getToColor(param_1, _sampler, _to);
    float _e114 = uniforms.progress;
    return metal::mix(_e110, _e112, metal::float4(metal::smoothstep(0.2, 1.0, _e114)));
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
    metal::float2 _e20 = _uv_1;
    param_2 = _e20;
    metal::float4 _e21 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e21;
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
