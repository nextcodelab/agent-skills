// NoiseDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/NoiseDissolve.glsl
// Author: towrabbit
// License: MIT
// Description: The incoming image appears pixel by pixel in random noise
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

float random(
    thread metal::float2& st
) {
    metal::float2 _e16 = st;
    return metal::fract(metal::sin(metal::dot(_e16, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e17 = uv[0u];
    float _e19 = uv[1u];
    metal::float4 _e22 = _to.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e17 = uv_1[0u];
    float _e19 = uv_1[1u];
    metal::float4 _e22 = _from.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 leftSide = {};
    metal::float2 param = {};
    metal::float4 rightSide = {};
    metal::float2 param_1 = {};
    float uvz = {};
    metal::float2 param_2 = {};
    metal::float2 _e22 = uv_2;
    param = _e22;
    metal::float4 _e23 = getFromColor(param, _from, _sampler);
    leftSide = _e23;
    metal::float2 _e24 = uv_2;
    param_1 = _e24;
    metal::float4 _e25 = getToColor(param_1, _sampler, _to);
    rightSide = _e25;
    metal::float2 _e26 = uv_2;
    param_2 = _e26;
    float _e27 = random(param_2);
    float _e29 = uniforms.progress;
    uvz = metal::floor(_e27 + _e29);
    metal::float4 _e32 = leftSide;
    metal::float4 _e33 = rightSide;
    float _e34 = uvz;
    return metal::mix(_e32, _e33, metal::float4(_e34));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e16 = _uv_1;
    param_3 = _e16;
    metal::float4 _e17 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e17;
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
