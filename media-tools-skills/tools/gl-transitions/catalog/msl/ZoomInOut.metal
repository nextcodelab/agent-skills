// ZoomInOut — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ZoomInOut.glsl
// Author: OllyOllyOlly
// License: MIT
// Description: Zooms into the outgoing image until it blurs into a flat color, then out to the incoming one
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

metal::float2 zoom(
    thread metal::float2& uv_2,
    thread float& amount
) {
    metal::float2 _e17 = uv_2;
    float _e20 = amount;
    return metal::float2(0.5) + ((_e17 - metal::float2(0.5)) * (1.0 - _e20));
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float zoomFrom = {};
    float zoomTo = {};
    float crossfade = {};
    metal::float2 param = {};
    float param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    metal::float2 param_5 = {};
    float _e26 = uniforms.progress;
    zoomFrom = metal::smoothstep(0.0, 1.0, _e26 * 2.0);
    float _e30 = uniforms.progress;
    zoomTo = metal::smoothstep(0.0, 1.0, (1.0 - _e30) * 2.0);
    float _e35 = uniforms.progress;
    crossfade = metal::smoothstep(0.4, 0.6, _e35);
    metal::float2 _e37 = uv_3;
    param = _e37;
    float _e38 = zoomFrom;
    param_1 = _e38;
    metal::float2 _e39 = zoom(param, param_1);
    param_2 = _e39;
    metal::float4 _e40 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e41 = uv_3;
    param_3 = _e41;
    float _e42 = zoomTo;
    param_4 = _e42;
    metal::float2 _e43 = zoom(param_3, param_4);
    param_5 = _e43;
    metal::float4 _e44 = getToColor(param_5, _sampler, _to);
    float _e45 = crossfade;
    return metal::mix(_e40, _e44, metal::float4(_e45));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_6 = {};
    metal::float2 _e16 = _uv_1;
    param_6 = _e16;
    metal::float4 _e17 = transition(param_6, _from, _sampler, _to, uniforms);
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
