// ColorWrap — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorWrap.glsl
// Author: Yoni Maltsman @friendlyspinach
// License: MIT
// Description: Each color channel of the outgoing image is shifted and wraps around into psychedelic bands, while crossfading to the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float r_strength;
    float g_strength;
    float b_strength;
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
    metal::float4 from = {};
    metal::float2 param = {};
    metal::float4 to = {};
    metal::float2 param_1 = {};
    metal::float3 c = {};
    metal::float2 _e22 = uv_2;
    param = _e22;
    metal::float4 _e23 = getFromColor(param, _from, _sampler);
    from = _e23;
    metal::float2 _e24 = uv_2;
    param_1 = _e24;
    metal::float4 _e25 = getToColor(param_1, _sampler, _to);
    to = _e25;
    metal::float4 _e26 = from;
    float _e29 = uniforms.r_strength;
    float _e31 = uniforms.g_strength;
    float _e33 = uniforms.b_strength;
    float _e36 = uniforms.progress;
    c = _e26.xyz + (metal::float3(_e29, _e31, _e33) * _e36);
    metal::float4 _e39 = from;
    metal::float3 _e41 = c;
    metal::float3 _e42 = metal::float3(1.0);
    float _e48 = uniforms.progress;
    metal::float3 _e51 = metal::mix(_e39.xyz, _e41 - (metal::floor(_e41 / _e42) * _e42), metal::float3(metal::smoothstep(0.0, 0.1, _e48)));
    from[0u] = _e51.x;
    from[1u] = _e51.y;
    from[2u] = _e51.z;
    metal::float4 _e58 = from;
    metal::float4 _e59 = to;
    float _e61 = uniforms.progress;
    return metal::mix(_e58, _e59, metal::float4(_e61));
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
