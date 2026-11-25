// RandomSquares — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RandomSquares.glsl
// Author: gre
// License: MIT
// Description: The incoming image appears in random squares
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 size;
    float smoothness;
    char _pad4[4];
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

float rand(
    thread metal::float2& co
) {
    metal::float2 _e18 = co;
    return metal::fract(metal::sin(metal::dot(_e18, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float r = {};
    metal::float2 param = {};
    float m = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::int2 _e24 = uniforms.size;
    metal::float2 _e26 = p;
    param = metal::floor(static_cast<metal::float2>(_e24) * _e26);
    float _e29 = rand(param);
    r = _e29;
    float _e31 = uniforms.smoothness;
    float _e33 = r;
    float _e35 = uniforms.progress;
    float _e37 = uniforms.smoothness;
    m = metal::smoothstep(0.0, -(_e31), _e33 - (_e35 * (1.0 + _e37)));
    metal::float2 _e42 = p;
    param_1 = _e42;
    metal::float4 _e43 = getFromColor(param_1, _from, _sampler);
    metal::float2 _e44 = p;
    param_2 = _e44;
    metal::float4 _e45 = getToColor(param_2, _sampler, _to);
    float _e46 = m;
    return metal::mix(_e43, _e45, metal::float4(_e46));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e18 = _uv_1;
    param_3 = _e18;
    metal::float4 _e19 = transition(param_3, _from, _sampler, _to, uniforms);
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
