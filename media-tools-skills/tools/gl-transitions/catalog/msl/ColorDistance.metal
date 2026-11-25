// ColorDistance — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorDistance.glsl
// Author: P-Seebauer
// License: MIT
// Description: Pixels switch to the incoming image in order of how close their colors are
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float power;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e14 = uv[0u];
    float _e16 = uv[1u];
    metal::float4 _e19 = _to.sample(_sampler, metal::float2(_e14, 1.0 - _e16), metal::level(0.0));
    return _e19;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e14 = uv_1[0u];
    float _e16 = uv_1[1u];
    metal::float4 _e19 = _from.sample(_sampler, metal::float2(_e14, 1.0 - _e16), metal::level(0.0));
    return _e19;
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 fTex = {};
    metal::float2 param = {};
    metal::float4 tTex = {};
    metal::float2 param_1 = {};
    float m = {};
    metal::float2 _e18 = p;
    param = _e18;
    metal::float4 _e19 = getFromColor(param, _from, _sampler);
    fTex = _e19;
    metal::float2 _e20 = p;
    param_1 = _e20;
    metal::float4 _e21 = getToColor(param_1, _sampler, _to);
    tTex = _e21;
    metal::float4 _e22 = fTex;
    metal::float4 _e23 = tTex;
    float _e26 = uniforms.progress;
    m = metal::step(metal::distance(_e22, _e23), _e26);
    metal::float4 _e28 = fTex;
    metal::float4 _e29 = tTex;
    float _e30 = m;
    metal::float4 _e33 = tTex;
    float _e35 = uniforms.progress;
    float _e37 = uniforms.power;
    return metal::mix(metal::mix(_e28, _e29, metal::float4(_e30)), _e33, metal::float4(metal::pow(_e35, _e37)));
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
    metal::float2 _e13 = _uv_1;
    param_2 = _e13;
    metal::float4 _e14 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e14;
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
