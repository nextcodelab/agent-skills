// ColorCoords — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorCoords.glsl
// Author: haiyoucuv
// License: MIT
// Description: A crossfade in which the colors of one image displace the other
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e13 = uv[0u];
    float _e15 = uv[1u];
    metal::float4 _e18 = _from.sample(_sampler, metal::float2(_e13, 1.0 - _e15), metal::level(0.0));
    return _e18;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e13 = uv_1[0u];
    float _e15 = uv_1[1u];
    metal::float4 _e18 = _to.sample(_sampler, metal::float2(_e13, 1.0 - _e15), metal::level(0.0));
    return _e18;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 coordTo = {};
    metal::float2 param = {};
    metal::float4 coordFrom = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e18 = uv_2;
    param = _e18;
    metal::float4 _e19 = getToColor(param, _sampler, _to);
    coordTo = _e19;
    metal::float2 _e20 = uv_2;
    param_1 = _e20;
    metal::float4 _e21 = getFromColor(param_1, _from, _sampler);
    coordFrom = _e21;
    metal::float2 _e22 = uv_2;
    metal::float4 _e23 = coordTo;
    float _e26 = uniforms.progress;
    param_2 = metal::mix(_e22, _e23.xy, metal::float2(_e26));
    metal::float4 _e29 = getFromColor(param_2, _from, _sampler);
    metal::float4 _e30 = coordFrom;
    metal::float2 _e32 = uv_2;
    float _e34 = uniforms.progress;
    param_3 = metal::mix(_e30.xy, _e32, metal::float2(_e34));
    metal::float4 _e37 = getToColor(param_3, _sampler, _to);
    float _e39 = uniforms.progress;
    return metal::mix(_e29, _e37, metal::float4(_e39));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_4 = {};
    metal::float2 _e12 = _uv_1;
    param_4 = _e12;
    metal::float4 _e13 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e13;
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
