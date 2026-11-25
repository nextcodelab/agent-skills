// GlowDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlowDissolve.glsl
// Author: hjm1fb
// License: MIT
// Description: The incoming image spreads over the outgoing one with a hot, glowing edge
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float uLineWidth;
    char _pad3[4];
    metal::float3 uSpreadClr;
    metal::packed_float3 uHotClr;
    float uPow;
    float uIntensity;
    char _pad7[12];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e26 = uv[0u];
    float _e28 = uv[1u];
    metal::float4 _e31 = _to.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e26 = uv_1[0u];
    float _e28 = uv_1[1u];
    metal::float4 _e31 = _from.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
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
    float burn = {};
    float show = {};
    metal::float4 outColor = {};
    float factor = {};
    metal::float3 burnColor = {};
    metal::float3 finalRGB = {};
    metal::float2 _e35 = uv_2;
    param = _e35;
    metal::float4 _e36 = getFromColor(param, _from, _sampler);
    from = _e36;
    metal::float2 _e37 = uv_2;
    param_1 = _e37;
    metal::float4 _e38 = getToColor(param_1, _sampler, _to);
    to = _e38;
    float _e40 = from[0u];
    float _e43 = from[1u];
    float _e47 = from[2u];
    burn = 0.5 + (0.5 * (((0.299 * _e40) + (0.587 * _e43)) + (0.114 * _e47)));
    float _e52 = burn;
    float _e54 = uniforms.progress;
    show = _e52 - _e54;
    float _e56 = show;
    if (_e56 < 0.001) {
        metal::float4 _e58 = to;
        outColor = _e58;
    } else {
        float _e60 = uniforms.uLineWidth;
        float _e61 = show;
        factor = 1.0 - metal::smoothstep(0.0, _e60, _e61);
        metal::float3 _e65 = uniforms.uSpreadClr;
        metal::float3 _e67 = uniforms.uHotClr;
        float _e68 = factor;
        burnColor = metal::mix(_e65, _e67, metal::float3(_e68));
        metal::float3 _e71 = burnColor;
        float _e73 = uniforms.uPow;
        float _e77 = uniforms.uIntensity;
        burnColor = metal::pow(_e71, metal::float3(_e73)) * _e77;
        metal::float4 _e79 = from;
        metal::float3 _e81 = burnColor;
        float _e82 = factor;
        float _e84 = uniforms.progress;
        finalRGB = metal::mix(_e79.xyz, _e81, metal::float3(_e82 * metal::step(0.0001, _e84)));
        metal::float3 _e89 = finalRGB;
        float _e91 = from[3u];
        outColor = metal::float4(_e89.x, _e89.y, _e89.z, _e91);
    }
    metal::float4 _e96 = outColor;
    return _e96;
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
    metal::float2 _e25 = _uv_1;
    param_2 = _e25;
    metal::float4 _e26 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e26;
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
