// FlashFade — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FlashFade.glsl
// Author: gre
// License: MIT
// Description: A crossfade that brightens toward a color in the middle
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float3 color;
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
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e15 = uv_2;
    param = _e15;
    metal::float4 _e16 = getFromColor(param, _from, _sampler);
    float _e18 = uniforms.progress;
    metal::float3 _e20 = uniforms.color;
    metal::float3 _e21 = _e20 * _e18;
    metal::float2 _e27 = uv_2;
    param_1 = _e27;
    metal::float4 _e28 = getToColor(param_1, _sampler, _to);
    float _e30 = uniforms.progress;
    metal::float3 _e33 = uniforms.color;
    metal::float3 _e34 = _e33 * (1.0 - _e30);
    float _e41 = uniforms.progress;
    return metal::mix(_e16 + metal::float4(_e21.x, _e21.y, _e21.z, 0.0), _e28 + metal::float4(_e34.x, _e34.y, _e34.z, 0.0), metal::float4(_e41));
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
