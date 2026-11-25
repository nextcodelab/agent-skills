// SplitSlideInOutVertical — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplitSlideInOutVertical.glsl
// Author: OllyOllyOlly
// License: MIT
// Description: The halves of both images slide vertically in opposite directions, out and in at once
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int reverse;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

bool inBounds(
    thread metal::float2& p
) {
    bool phi_74_ = {};
    metal::float2 _e17 = p;
    bool _e19 = metal::all(metal::float2(0.0, 0.0) < _e17);
    phi_74_ = _e19;
    if (_e19) {
        metal::float2 _e20 = p;
        phi_74_ = metal::all(_e20 < metal::float2(1.0, 1.0));
    }
    bool _e24 = phi_74_;
    return _e24;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float modifier = {};
    metal::float2 fromP = {};
    metal::float2 toP = {};
    metal::float2 param = {};
    metal::float4 local = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float _e25 = uv_2[0u];
    int _e29 = uniforms.reverse;
    modifier = ((_e25 > 0.5) ? 1.0 : -1.0) * ((_e29 != 0) ? -1.0 : 1.0);
    float _e34 = uv_2[0u];
    float _e36 = uv_2[1u];
    float _e38 = uniforms.progress;
    float _e39 = modifier;
    fromP = metal::float2(_e34, _e36 + (_e38 * _e39));
    float _e44 = uv_2[0u];
    float _e46 = uv_2[1u];
    float _e48 = uniforms.progress;
    float _e49 = modifier;
    float _e52 = modifier;
    toP = metal::float2(_e44, (_e46 + (_e48 * _e49)) - _e52);
    metal::float2 _e55 = fromP;
    param = _e55;
    bool _e56 = inBounds(param);
    if (_e56) {
        metal::float2 _e57 = fromP;
        param_1 = _e57;
        metal::float4 _e58 = getFromColor(param_1, _from, _sampler);
        local = _e58;
    } else {
        metal::float2 _e59 = toP;
        param_2 = _e59;
        metal::float4 _e60 = getToColor(param_2, _sampler, _to);
        local = _e60;
    }
    metal::float4 _e61 = local;
    return _e61;
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
    metal::float2 _e17 = _uv_1;
    param_3 = _e17;
    metal::float4 _e18 = transition(param_3, _from, _sampler, _to, uniforms);
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
