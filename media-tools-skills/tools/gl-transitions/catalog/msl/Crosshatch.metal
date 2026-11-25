// Crosshatch — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Crosshatch.glsl
// Author: pthrasher
// License: MIT
// Description: The incoming image appears through a crosshatch of lines spreading from the center
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float threshold;
    float fadeEdge;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e20 = uv[0u];
    float _e22 = uv[1u];
    metal::float4 _e25 = _to.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e20 = uv_1[0u];
    float _e22 = uv_1[1u];
    metal::float4 _e25 = _from.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

float rand(
    thread metal::float2& co
) {
    metal::float2 _e19 = co;
    return metal::fract(metal::sin(metal::dot(_e19, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dist = {};
    float r = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e26 = uniforms.center;
    metal::float2 _e27 = p;
    float _e30 = uniforms.threshold;
    dist = metal::distance(_e26, _e27) / _e30;
    float _e33 = uniforms.progress;
    float _e35 = p[1u];
    param = metal::float2(_e35, 0.0);
    float _e37 = rand(param);
    float _e39 = p[0u];
    param_1 = metal::float2(0.0, _e39);
    float _e41 = rand(param_1);
    r = _e33 - metal::min(_e37, _e41);
    metal::float2 _e44 = p;
    param_2 = _e44;
    metal::float4 _e45 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e46 = p;
    param_3 = _e46;
    metal::float4 _e47 = getToColor(param_3, _sampler, _to);
    float _e48 = dist;
    float _e49 = r;
    float _e52 = uniforms.fadeEdge;
    float _e55 = uniforms.progress;
    float _e59 = uniforms.fadeEdge;
    float _e61 = uniforms.progress;
    return metal::mix(_e45, _e47, metal::float4(metal::mix(0.0, metal::mix(metal::step(_e48, _e49), 1.0, metal::smoothstep(1.0 - _e52, 1.0, _e55)), metal::smoothstep(0.0, _e59, _e61))));
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
    metal::float2 _e19 = _uv_1;
    param_4 = _e19;
    metal::float4 _e20 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e20;
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
