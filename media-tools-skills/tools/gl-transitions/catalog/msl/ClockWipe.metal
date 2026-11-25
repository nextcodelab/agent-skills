// ClockWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ClockWipe.glsl
// Author: Fernando Kuteken
// License: MIT
// Description: A wipe that sweeps around the center from a starting angle
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float startingAngle;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float offset = {};
    float angle = {};
    float normalizedAngle = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e23 = uniforms.startingAngle;
    offset = (_e23 * 3.1415927) / 180.0;
    float _e27 = uv_2[1u];
    float _e30 = uv_2[0u];
    float _e33 = offset;
    angle = metal::atan2(_e27 - 0.5, _e30 - 0.5) + _e33;
    float _e35 = angle;
    normalizedAngle = (_e35 + 3.1415927) / 6.2831855;
    float _e38 = normalizedAngle;
    float _e39 = normalizedAngle;
    normalizedAngle = _e38 - metal::floor(_e39);
    metal::float2 _e42 = uv_2;
    param = _e42;
    metal::float4 _e43 = getFromColor(param, _from, _sampler);
    metal::float2 _e44 = uv_2;
    param_1 = _e44;
    metal::float4 _e45 = getToColor(param_1, _sampler, _to);
    float _e46 = normalizedAngle;
    float _e48 = uniforms.progress;
    return metal::mix(_e43, _e45, metal::float4(metal::step(_e46, _e48)));
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
    metal::float2 _e17 = _uv_1;
    param_2 = _e17;
    metal::float4 _e18 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e18;
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
