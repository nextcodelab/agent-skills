// ColorPhase — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorPhase.glsl
// Author: gre
// License: MIT
// Description: A crossfade in which each color channel changes at a different time
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float4 fromStep;
    metal::float4 toStep;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e15 = uv[0u];
    float _e17 = uv[1u];
    metal::float4 _e20 = _to.sample(_sampler, metal::float2(_e15, 1.0 - _e17), metal::level(0.0));
    return _e20;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e15 = uv_1[0u];
    float _e17 = uv_1[1u];
    metal::float4 _e20 = _from.sample(_sampler, metal::float2(_e15, 1.0 - _e17), metal::level(0.0));
    return _e20;
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
    metal::float2 _e18 = uv_2;
    param = _e18;
    metal::float4 _e19 = getFromColor(param, _from, _sampler);
    a = _e19;
    metal::float2 _e20 = uv_2;
    param_1 = _e20;
    metal::float4 _e21 = getToColor(param_1, _sampler, _to);
    b = _e21;
    metal::float4 _e22 = a;
    metal::float4 _e23 = b;
    metal::float4 _e25 = uniforms.fromStep;
    metal::float4 _e27 = uniforms.toStep;
    float _e29 = uniforms.progress;
    return metal::mix(_e22, _e23, metal::smoothstep(_e25, _e27, metal::float4(_e29)));
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
    metal::float2 _e14 = _uv_1;
    param_2 = _e14;
    metal::float4 _e15 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e15;
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
