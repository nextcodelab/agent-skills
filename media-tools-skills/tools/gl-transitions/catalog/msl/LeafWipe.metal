// LeafWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LeafWipe.glsl
// Author: @Flexi23
// License: MIT
// Description: A leaf shape grows from the center to reveal the incoming image
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
    float _e25 = uv[0u];
    float _e27 = uv[1u];
    metal::float4 _e30 = _to.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e25 = uv_1[0u];
    float _e27 = uv_1[1u];
    metal::float4 _e30 = _from.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 leaf_uv = {};
    float r = {};
    float o = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float _e31 = uniforms.progress;
    if (_e31 == 0.0) {
        metal::float2 _e33 = uv_2;
        param = _e33;
        metal::float4 _e34 = getFromColor(param, _from, _sampler);
        return _e34;
    }
    metal::float2 _e35 = uv_2;
    float _e40 = uniforms.progress;
    leaf_uv = ((_e35 - metal::float2(0.5, 0.5)) / metal::float2(10.0)) / metal::float2(metal::pow(_e40, 3.5));
    float _e45 = leaf_uv[1u];
    leaf_uv[1u] = _e45 + 0.35;
    r = 0.18;
    float _e49 = leaf_uv[1u];
    float _e51 = leaf_uv[0u];
    o = metal::atan2(_e49, _e51);
    metal::float2 _e53 = uv_2;
    param_1 = _e53;
    metal::float4 _e54 = getFromColor(param_1, _from, _sampler);
    metal::float2 _e55 = uv_2;
    param_2 = _e55;
    metal::float4 _e56 = getToColor(param_2, _sampler, _to);
    metal::float2 _e57 = leaf_uv;
    float _e60 = r;
    float _e61 = o;
    float _e65 = o;
    float _e71 = o;
    float _e77 = o;
    return metal::mix(_e54, _e56, metal::float4(1.0 - metal::step((1.0 - metal::length(_e57)) + ((((_e60 * (1.0 + metal::sin(_e61))) * (1.0 + (0.9 * metal::cos(8.0 * _e65)))) * (1.0 + (0.1 * metal::cos(24.0 * _e71)))) * (0.9 + (0.05 * metal::cos(200.0 * _e77)))), 1.0)));
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
    metal::float2 _e24 = _uv_1;
    param_3 = _e24;
    metal::float4 _e25 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e25;
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
