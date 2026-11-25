// Dreamy — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Dreamy.glsl
// Author: mikolalysenko
// License: MIT
// Description: A crossfade with a gentle wavy distortion
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
    float _e16 = uv[0u];
    float _e18 = uv[1u];
    metal::float4 _e21 = _to.sample(_sampler, metal::float2(_e16, 1.0 - _e18), metal::level(0.0));
    return _e21;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e16 = uv_1[0u];
    float _e18 = uv_1[1u];
    metal::float4 _e21 = _from.sample(_sampler, metal::float2(_e16, 1.0 - _e18), metal::level(0.0));
    return _e21;
}

metal::float2 offset(
    thread float& progress,
    thread float& x,
    thread float& theta
) {
    float phase = {};
    float shifty = {};
    float _e19 = progress;
    float _e20 = progress;
    float _e22 = progress;
    float _e24 = theta;
    phase = ((_e19 * _e20) + _e22) + _e24;
    float _e26 = progress;
    float _e28 = progress;
    float _e29 = x;
    shifty = (0.03 * _e26) * metal::cos(10.0 * (_e28 + _e29));
    float _e34 = shifty;
    return metal::float2(0.0, _e34);
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float param = {};
    float param_1 = {};
    float param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 _e23 = p;
    float _e25 = uniforms.progress;
    param = _e25;
    float _e27 = p[0u];
    param_1 = _e27;
    param_2 = 0.0;
    metal::float2 _e28 = offset(param, param_1, param_2);
    param_3 = _e23 + _e28;
    metal::float4 _e30 = getFromColor(param_3, _from, _sampler);
    metal::float2 _e31 = p;
    float _e33 = uniforms.progress;
    param_4 = 1.0 - _e33;
    float _e36 = p[0u];
    param_5 = _e36;
    param_6 = 3.14;
    metal::float2 _e37 = offset(param_4, param_5, param_6);
    param_7 = _e31 + _e37;
    metal::float4 _e39 = getToColor(param_7, _sampler, _to);
    float _e41 = uniforms.progress;
    return metal::mix(_e30, _e39, metal::float4(_e41));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e15 = _uv_1;
    param_8 = _e15;
    metal::float4 _e16 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e16;
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
