// RadialWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RadialWipe.glsl
// Author: Xaychru
// License: MIT
// Description: A radial wipe that sweeps around the center like a clock hand
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float smoothness;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 rp = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e20 = p;
    rp = (_e20 * 2.0) - metal::float2(1.0);
    metal::float2 _e24 = p;
    param = _e24;
    metal::float4 _e25 = getToColor(param, _sampler, _to);
    metal::float2 _e26 = p;
    param_1 = _e26;
    metal::float4 _e27 = getFromColor(param_1, _from, _sampler);
    float _e29 = uniforms.smoothness;
    float _e31 = rp[1u];
    float _e33 = rp[0u];
    float _e36 = uniforms.progress;
    return metal::mix(_e25, _e27, metal::float4(metal::smoothstep(0.0, _e29, metal::atan2(_e31, _e33) - (((_e36 - 0.5) * 3.1415927) * 2.5))));
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
    metal::float2 _e17 = _uv_1;
    param_2 = _e17;
    metal::float4 _e18 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e18;
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
