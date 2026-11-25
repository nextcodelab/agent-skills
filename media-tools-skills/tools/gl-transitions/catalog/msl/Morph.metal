// Morph — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Morph.glsl
// Author: paniq
// License: MIT
// Description: A crossfade in which each image is displaced by the other's colors, like a morph
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
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
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 ca = {};
    metal::float2 param = {};
    metal::float4 cb = {};
    metal::float2 param_1 = {};
    metal::float2 oa = {};
    metal::float2 ob = {};
    metal::float2 oc = {};
    float w0_ = {};
    float w1_ = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e27 = p;
    param = _e27;
    metal::float4 _e28 = getFromColor(param, _from, _sampler);
    ca = _e28;
    metal::float2 _e29 = p;
    param_1 = _e29;
    metal::float4 _e30 = getToColor(param_1, _sampler, _to);
    cb = _e30;
    metal::float4 _e31 = ca;
    float _e34 = ca[2u];
    oa = (((_e31.xy + metal::float2(_e34)) * 0.5) * 2.0) - metal::float2(1.0);
    metal::float4 _e41 = cb;
    float _e44 = cb[2u];
    ob = (((_e41.xy + metal::float2(_e44)) * 0.5) * 2.0) - metal::float2(1.0);
    metal::float2 _e51 = oa;
    metal::float2 _e52 = ob;
    float _e56 = uniforms.strength;
    oc = metal::mix(_e51, _e52, metal::float2(0.5)) * _e56;
    float _e59 = uniforms.progress;
    w0_ = _e59;
    float _e60 = w0_;
    w1_ = 1.0 - _e60;
    metal::float2 _e62 = p;
    metal::float2 _e63 = oc;
    float _e64 = w0_;
    param_2 = _e62 + (_e63 * _e64);
    metal::float4 _e67 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e68 = p;
    metal::float2 _e69 = oc;
    float _e70 = w1_;
    param_3 = _e68 - (_e69 * _e70);
    metal::float4 _e73 = getToColor(param_3, _sampler, _to);
    float _e75 = uniforms.progress;
    return metal::mix(_e67, _e73, metal::float4(_e75));
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
    metal::float2 _e16 = _uv_1;
    param_4 = _e16;
    metal::float4 _e17 = transition(param_4, _from, _sampler, _to, uniforms);
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
