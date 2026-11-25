// CircleIris — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CircleIris.glsl
// Author: Fernando Kuteken
// License: MIT
// Description: The outgoing image closes into a circle over a background color, then the incoming one opens from it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    metal::float4 backColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e17 = uv[0u];
    float _e19 = uv[1u];
    metal::float4 _e22 = _to.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e17 = uv_1[0u];
    float _e19 = uv_1[1u];
    metal::float4 _e22 = _from.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float distance = {};
    float radius = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e20 = uv_2;
    metal::float2 _e22 = uniforms.center;
    distance = metal::length(_e20 - _e22);
    float _e26 = uniforms.progress;
    radius = 2.828427 * metal::abs(_e26 - 0.5);
    float _e30 = distance;
    float _e31 = radius;
    if (_e30 > _e31) {
        metal::float4 _e34 = uniforms.backColor;
        return _e34;
    } else {
        float _e36 = uniforms.progress;
        if (_e36 < 0.5) {
            metal::float2 _e38 = uv_2;
            param = _e38;
            metal::float4 _e39 = getFromColor(param, _from, _sampler);
            return _e39;
        } else {
            metal::float2 _e40 = uv_2;
            param_1 = _e40;
            metal::float4 _e41 = getToColor(param_1, _sampler, _to);
            return _e41;
        }
    }
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
    metal::float2 _e16 = _uv_1;
    param_2 = _e16;
    metal::float4 _e17 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e17;
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
