// DirectionalEased — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DirectionalEased.glsl
// Author: Max Plotnikov
// License: MIT
// Description: Like Directional, with an eased movement
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e15 = uv[0u];
    float _e17 = uv[1u];
    metal::float4 _e20 = _from.sample(_sampler, metal::float2(_e15, 1.0 - _e17), metal::level(0.0));
    return _e20;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e15 = uv_1[0u];
    float _e17 = uv_1[1u];
    metal::float4 _e20 = _to.sample(_sampler, metal::float2(_e15, 1.0 - _e17), metal::level(0.0));
    return _e20;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float easing = {};
    metal::float2 p = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e20 = uniforms.progress;
    float _e23 = uniforms.progress;
    easing = metal::sqrt((2.0 - _e20) * _e23);
    metal::float2 _e26 = uv_2;
    float _e27 = easing;
    metal::float2 _e29 = uniforms.direction;
    p = _e26 + (metal::sign(_e29) * _e27);
    metal::float2 _e33 = p;
    f = metal::fract(_e33);
    metal::float2 _e35 = f;
    param = _e35;
    metal::float4 _e36 = getToColor(param, _sampler, _to);
    metal::float2 _e37 = f;
    param_1 = _e37;
    metal::float4 _e38 = getFromColor(param_1, _from, _sampler);
    float _e40 = p[1u];
    float _e43 = p[1u];
    float _e47 = p[0u];
    float _e51 = p[0u];
    return metal::mix(_e36, _e38, metal::float4(((metal::step(0.0, _e40) * metal::step(_e43, 1.0)) * metal::step(0.0, _e47)) * metal::step(_e51, 1.0)));
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
