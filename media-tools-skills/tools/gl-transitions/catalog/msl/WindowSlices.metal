// WindowSlices — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WindowSlices.glsl
// Author: gre
// License: MIT
// Description: The incoming image appears through vertical slices that widen
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float count;
    float smoothness;
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

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float pr = {};
    float s = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e19 = uniforms.smoothness;
    float _e22 = p[0u];
    float _e24 = uniforms.progress;
    float _e26 = uniforms.smoothness;
    pr = metal::smoothstep(-(_e19), 0.0, _e22 - (_e24 * (1.0 + _e26)));
    float _e31 = pr;
    float _e33 = uniforms.count;
    float _e35 = p[0u];
    s = metal::step(_e31, metal::fract(_e33 * _e35));
    metal::float2 _e39 = p;
    param = _e39;
    metal::float4 _e40 = getFromColor(param, _from, _sampler);
    metal::float2 _e41 = p;
    param_1 = _e41;
    metal::float4 _e42 = getToColor(param_1, _sampler, _to);
    float _e43 = s;
    return metal::mix(_e40, _e42, metal::float4(_e43));
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
