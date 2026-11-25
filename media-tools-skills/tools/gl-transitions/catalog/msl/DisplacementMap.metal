// DisplacementMap — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DisplacementMap.glsl
// Author: Travis Fischer
// License: MIT
// Description: A crossfade in which a displacement map (an extra grayscale texture) warps both images
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
};

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

metal::float4 _texture_displacementMap(
    thread metal::float2& uv_2,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> displacementMap
) {
    float _e15 = uv_2[0u];
    float _e17 = uv_2[1u];
    metal::float4 _e20 = displacementMap.sample(_sampler, metal::float2(_e15, 1.0 - _e17), metal::level(0.0));
    return _e20;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    metal::texture2d<float, metal::access::sample> displacementMap,
    constant Uniforms& uniforms
) {
    float displacement = {};
    metal::float2 param = {};
    metal::float2 uvFrom = {};
    metal::float2 uvTo = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 _e20 = uv_3;
    param = _e20;
    metal::float4 _e21 = _texture_displacementMap(param, _sampler, displacementMap);
    float _e24 = uniforms.strength;
    displacement = _e21.x * _e24;
    float _e27 = uv_3[0u];
    float _e29 = uniforms.progress;
    float _e30 = displacement;
    float _e34 = uv_3[1u];
    uvFrom = metal::float2(_e27 + (_e29 * _e30), _e34);
    float _e37 = uv_3[0u];
    float _e39 = uniforms.progress;
    float _e41 = displacement;
    float _e45 = uv_3[1u];
    uvTo = metal::float2(_e37 - ((1.0 - _e39) * _e41), _e45);
    metal::float2 _e47 = uvFrom;
    param_1 = _e47;
    metal::float4 _e48 = getFromColor(param_1, _from, _sampler);
    metal::float2 _e49 = uvTo;
    param_2 = _e49;
    metal::float4 _e50 = getToColor(param_2, _sampler, _to);
    float _e52 = uniforms.progress;
    return metal::mix(_e48, _e50, metal::float4(_e52));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    metal::texture2d<float, metal::access::sample> displacementMap,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e14 = _uv_1;
    param_3 = _e14;
    metal::float4 _e15 = transition(param_3, _from, _sampler, _to, displacementMap, uniforms);
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
, metal::texture2d<float, metal::access::sample> displacementMap [[texture(2)]]
, constant Uniforms& uniforms [[buffer(0)]]
) {
    metal::float4 _fragColor = {};
    metal::float2 _uv_1 = {};
    const auto _uv = varyings._uv;
    _uv_1 = _uv;
    main_1(_from, _sampler, _to, displacementMap, uniforms, _fragColor, _uv_1);
    metal::float4 _e3 = _fragColor;
    return main_Output { _e3 };
}
