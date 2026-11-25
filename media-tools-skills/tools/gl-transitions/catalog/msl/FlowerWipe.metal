// FlowerWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FlowerWipe.glsl
// Author: Fernando Kuteken
// License: MIT
// Description: A flower shape with several petals grows to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int segments;
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
    float angle = {};
    float normalized = {};
    float radius = {};
    float difference = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e26 = uv_2[1u];
    float _e29 = uv_2[0u];
    angle = metal::atan2(_e26 - 0.5, _e29 - 0.5) - 1.5707964;
    float _e33 = angle;
    normalized = (_e33 + 4.712389) * 6.2831855;
    int _e37 = uniforms.segments;
    float _e39 = angle;
    radius = (metal::cos(static_cast<float>(_e37) * _e39) + 4.0) / 4.0;
    metal::float2 _e44 = uv_2;
    difference = metal::length(_e44 - metal::float2(0.5, 0.5));
    float _e47 = difference;
    float _e48 = radius;
    float _e50 = uniforms.progress;
    if (_e47 > (_e48 * _e50)) {
        metal::float2 _e53 = uv_2;
        param = _e53;
        metal::float4 _e54 = getFromColor(param, _from, _sampler);
        return _e54;
    } else {
        metal::float2 _e55 = uv_2;
        param_1 = _e55;
        metal::float4 _e56 = getToColor(param_1, _sampler, _to);
        return _e56;
    }
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
