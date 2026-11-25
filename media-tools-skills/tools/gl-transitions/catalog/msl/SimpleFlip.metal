// SimpleFlip — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SimpleFlip.glsl
// Author: nwoeanhinnogaehr
// License: MIT
// Description: The outgoing image flips around the vertical axis into the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e14 = uv[0u];
    float _e16 = uv[1u];
    metal::float4 _e19 = _to.sample(_sampler, metal::float2(_e14, 1.0 - _e16), metal::level(0.0));
    return _e19;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e14 = uv_1[0u];
    float _e16 = uv_1[1u];
    metal::float4 _e19 = _from.sample(_sampler, metal::float2(_e14, 1.0 - _e16), metal::level(0.0));
    return _e19;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 q = {};
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    metal::float2 _e18 = uv_2;
    q = _e18;
    float _e20 = uv_2[0u];
    float _e23 = uniforms.progress;
    uv_2[0u] = (((_e20 - 0.5) / metal::abs(_e23 - 0.5)) * 0.5) + 0.5;
    metal::float2 _e30 = uv_2;
    param = _e30;
    metal::float4 _e31 = getFromColor(param, _from, _sampler);
    a = _e31;
    metal::float2 _e32 = uv_2;
    param_1 = _e32;
    metal::float4 _e33 = getToColor(param_1, _sampler, _to);
    b = _e33;
    metal::float4 _e34 = a;
    metal::float4 _e35 = b;
    float _e37 = uniforms.progress;
    float _e42 = q[0u];
    float _e46 = uniforms.progress;
    return metal::mix(_e34, _e35, metal::float4(metal::step(0.5, _e37))) * metal::step(metal::abs(_e42 - 0.5), metal::abs(_e46 - 0.5));
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
    metal::float2 _e13 = _uv_1;
    param_2 = _e13;
    metal::float4 _e14 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e14;
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
