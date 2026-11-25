// MultiplyBlend — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/MultiplyBlend.glsl
// Author: Fernando Kuteken
// License: MIT
// Description: A crossfade through the multiplied blend of both images
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 blend(
    thread metal::float4& a,
    thread metal::float4& b
) {
    metal::float4 _e15 = a;
    metal::float4 _e16 = b;
    return _e15 * _e16;
}

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
    metal::float4 blended = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 param_2 = {};
    metal::float4 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 _e21 = uv_2;
    param = _e21;
    metal::float4 _e22 = getFromColor(param, _from, _sampler);
    metal::float2 _e23 = uv_2;
    param_1 = _e23;
    metal::float4 _e24 = getToColor(param_1, _sampler, _to);
    param_2 = _e22;
    param_3 = _e24;
    metal::float4 _e25 = blend(param_2, param_3);
    blended = _e25;
    float _e27 = uniforms.progress;
    if (_e27 < 0.5) {
        metal::float2 _e29 = uv_2;
        param_4 = _e29;
        metal::float4 _e30 = getFromColor(param_4, _from, _sampler);
        metal::float4 _e31 = blended;
        float _e33 = uniforms.progress;
        return metal::mix(_e30, _e31, metal::float4(2.0 * _e33));
    } else {
        metal::float4 _e37 = blended;
        metal::float2 _e38 = uv_2;
        param_5 = _e38;
        metal::float4 _e39 = getToColor(param_5, _sampler, _to);
        float _e41 = uniforms.progress;
        return metal::mix(_e37, _e39, metal::float4((2.0 * _e41) - 1.0));
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
    metal::float2 param_6 = {};
    metal::float2 _e14 = _uv_1;
    param_6 = _e14;
    metal::float4 _e15 = transition(param_6, _from, _sampler, _to, uniforms);
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
