// CrossWarp — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CrossWarp.glsl
// Author: Eke Péter <peterekepeter@gmail.com>
// License: MIT
// Description: The outgoing image zooms in while the incoming one zooms out into place, sweeping from right to left
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
    float x = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e18 = uniforms.progress;
    x = _e18;
    float _e19 = x;
    float _e22 = p[0u];
    x = metal::smoothstep(0.0, 1.0, ((_e19 * 2.0) + _e22) - 1.0);
    metal::float2 _e26 = p;
    float _e29 = x;
    param = ((_e26 - metal::float2(0.5)) * (1.0 - _e29)) + metal::float2(0.5);
    metal::float4 _e34 = getFromColor(param, _from, _sampler);
    metal::float2 _e35 = p;
    float _e38 = x;
    param_1 = ((_e35 - metal::float2(0.5)) * _e38) + metal::float2(0.5);
    metal::float4 _e42 = getToColor(param_1, _sampler, _to);
    float _e43 = x;
    return metal::mix(_e34, _e42, metal::float4(_e43));
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
