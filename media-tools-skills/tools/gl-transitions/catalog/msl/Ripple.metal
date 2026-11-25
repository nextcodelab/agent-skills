// Ripple — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Ripple.glsl
// Author: gre
// License: MIT
// Description: Ripples spread from the center while crossfading
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float amplitude;
    float speed;
};

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
    metal::float2 dir = {};
    float dist = {};
    metal::float2 offset = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e23 = uv_2;
    dir = _e23 - metal::float2(0.5, 0.5);
    metal::float2 _e25 = dir;
    dist = metal::length(_e25);
    metal::float2 _e27 = dir;
    float _e29 = uniforms.progress;
    float _e30 = dist;
    float _e33 = uniforms.amplitude;
    float _e36 = uniforms.progress;
    float _e38 = uniforms.speed;
    float _e47 = uniforms.progress;
    offset = ((_e27 * (metal::sin(((_e29 * _e30) * _e33) - (_e36 * _e38)) + 0.5)) / metal::float2(30.0)) * _e47;
    metal::float2 _e49 = uv_2;
    metal::float2 _e50 = offset;
    param = _e49 + _e50;
    metal::float4 _e52 = getFromColor(param, _from, _sampler);
    metal::float2 _e53 = uv_2;
    param_1 = _e53;
    metal::float4 _e54 = getToColor(param_1, _sampler, _to);
    float _e56 = uniforms.progress;
    return metal::mix(_e52, _e54, metal::float4(metal::smoothstep(0.2, 1.0, _e56)));
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
    metal::float2 _e18 = _uv_1;
    param_2 = _e18;
    metal::float4 _e19 = transition(param_2, _from, _sampler, _to, uniforms);
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
