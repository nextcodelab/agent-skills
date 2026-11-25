// FadeGrayscale — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FadeGrayscale.glsl
// Author: gre
// License: MIT
// Description: A crossfade through grayscale
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float intensity;
};

metal::float3 grayscale(
    thread metal::float3& color
) {
    float _e19 = color[0u];
    float _e22 = color[1u];
    float _e26 = color[2u];
    return metal::float3(((0.2126 * _e19) + (0.7152 * _e22)) + (0.0722 * _e26));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e19 = uv[0u];
    float _e21 = uv[1u];
    metal::float4 _e24 = _to.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e19 = uv_1[0u];
    float _e21 = uv_1[1u];
    metal::float4 _e24 = _from.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 fc = {};
    metal::float2 param = {};
    metal::float4 tc = {};
    metal::float2 param_1 = {};
    metal::float3 param_2 = {};
    metal::float3 param_3 = {};
    metal::float2 _e24 = uv_2;
    param = _e24;
    metal::float4 _e25 = getFromColor(param, _from, _sampler);
    fc = _e25;
    metal::float2 _e26 = uv_2;
    param_1 = _e26;
    metal::float4 _e27 = getToColor(param_1, _sampler, _to);
    tc = _e27;
    metal::float4 _e28 = fc;
    param_2 = _e28.xyz;
    metal::float3 _e30 = grayscale(param_2);
    float _e32 = fc[3u];
    metal::float4 _e37 = fc;
    float _e39 = uniforms.intensity;
    float _e42 = uniforms.progress;
    metal::float4 _e46 = tc;
    param_3 = _e46.xyz;
    metal::float3 _e48 = grayscale(param_3);
    float _e50 = tc[3u];
    metal::float4 _e55 = tc;
    float _e57 = uniforms.intensity;
    float _e59 = uniforms.progress;
    float _e64 = uniforms.progress;
    return metal::mix(metal::mix(metal::float4(_e30.x, _e30.y, _e30.z, _e32), _e37, metal::float4(metal::smoothstep(1.0 - _e39, 0.0, _e42))), metal::mix(metal::float4(_e48.x, _e48.y, _e48.z, _e50), _e55, metal::float4(metal::smoothstep(_e57, 1.0, _e59))), metal::float4(_e64));
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
    metal::float2 _e18 = _uv_1;
    param_4 = _e18;
    metal::float4 _e19 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e19;
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
