// SimpleZoom — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SimpleZoom.glsl
// Author: 0gust1
// License: MIT
// Description: Zooms into the outgoing image, then fades to the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float zoom_quickness;
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

metal::float2 zoom(
    thread metal::float2& uv_2,
    thread float& amount
) {
    metal::float2 _e16 = uv_2;
    float _e19 = amount;
    return metal::float2(0.5) + ((_e16 - metal::float2(0.5)) * (1.0 - _e19));
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float nQuick = {};
    metal::float2 param = {};
    float param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float _e21 = uniforms.zoom_quickness;
    nQuick = metal::clamp(_e21, 0.2, 1.0);
    float _e23 = nQuick;
    float _e25 = uniforms.progress;
    metal::float2 _e27 = uv_3;
    param = _e27;
    param_1 = metal::smoothstep(0.0, _e23, _e25);
    metal::float2 _e28 = zoom(param, param_1);
    param_2 = _e28;
    metal::float4 _e29 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e30 = uv_3;
    param_3 = _e30;
    metal::float4 _e31 = getToColor(param_3, _sampler, _to);
    float _e32 = nQuick;
    float _e35 = uniforms.progress;
    return metal::mix(_e29, _e31, metal::float4(metal::smoothstep(_e32 - 0.2, 1.0, _e35)));
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
    metal::float2 _e15 = _uv_1;
    param_4 = _e15;
    metal::float4 _e16 = transition(param_4, _from, _sampler, _to, uniforms);
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
