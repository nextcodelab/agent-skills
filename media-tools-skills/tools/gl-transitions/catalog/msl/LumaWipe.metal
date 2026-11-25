// LumaWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LumaWipe.glsl
// Author: gre
// License: MIT
// Description: A wipe that follows the brightness of a grayscale mask (the luma texture)
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 _texture_luma(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> luma
) {
    float _e14 = uv[0u];
    float _e16 = uv[1u];
    metal::float4 _e19 = luma.sample(_sampler, metal::float2(_e14, 1.0 - _e16), metal::level(0.0));
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

metal::float4 getToColor(
    thread metal::float2& uv_2,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e14 = uv_2[0u];
    float _e16 = uv_2[1u];
    metal::float4 _e19 = _to.sample(_sampler, metal::float2(_e14, 1.0 - _e16), metal::level(0.0));
    return _e19;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    metal::texture2d<float, metal::access::sample> luma,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 _e16 = uv_3;
    param = _e16;
    metal::float4 _e17 = getToColor(param, _sampler, _to);
    metal::float2 _e18 = uv_3;
    param_1 = _e18;
    metal::float4 _e19 = getFromColor(param_1, _from, _sampler);
    float _e21 = uniforms.progress;
    metal::float2 _e22 = uv_3;
    param_2 = _e22;
    metal::float4 _e23 = _texture_luma(param_2, _sampler, luma);
    return metal::mix(_e17, _e19, metal::float4(metal::step(_e21, _e23.x)));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    metal::texture2d<float, metal::access::sample> luma,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e13 = _uv_1;
    param_3 = _e13;
    metal::float4 _e14 = transition(param_3, _from, _sampler, _to, luma, uniforms);
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
, metal::texture2d<float, metal::access::sample> luma [[texture(2)]]
, constant Uniforms& uniforms [[buffer(0)]]
) {
    metal::float4 _fragColor = {};
    metal::float2 _uv_1 = {};
    const auto _uv = varyings._uv;
    _uv_1 = _uv;
    main_1(_from, _sampler, _to, luma, uniforms, _fragColor, _uv_1);
    metal::float4 _e3 = _fragColor;
    return main_Output { _e3 };
}
