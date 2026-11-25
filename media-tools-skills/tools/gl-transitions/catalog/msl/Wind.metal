// Wind — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Wind.glsl
// Author: gre
// License: MIT
// Description: A ragged left-to-right wipe, as if the image was blown away by the wind
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float size;
    int reversed;
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
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float x = {};
    float local = {};
    float r = {};
    metal::float2 param = {};
    float m = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    int _e26 = uniforms.reversed;
    if (_e26 != 0) {
        float _e29 = uv_2[0u];
        local = 1.0 - _e29;
    } else {
        float _e32 = uv_2[0u];
        local = _e32;
    }
    float _e33 = local;
    x = _e33;
    float _e35 = uv_2[1u];
    param = metal::float2(0.0, _e35);
    float _e37 = rand(param);
    r = _e37;
    float _e39 = uniforms.size;
    float _e41 = x;
    float _e43 = uniforms.size;
    float _e47 = uniforms.size;
    float _e48 = r;
    float _e52 = uniforms.progress;
    float _e54 = uniforms.size;
    m = metal::smoothstep(0.0, -(_e39), ((_e41 * (1.0 - _e43)) + (_e47 * _e48)) - (_e52 * (1.0 + _e54)));
    metal::float2 _e59 = uv_2;
    param_1 = _e59;
    metal::float4 _e60 = getFromColor(param_1, _from, _sampler);
    metal::float2 _e61 = uv_2;
    param_2 = _e61;
    metal::float4 _e62 = getToColor(param_2, _sampler, _to);
    float _e63 = m;
    return metal::mix(_e60, _e62, metal::float4(_e63));
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
