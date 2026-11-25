// SplitSlideInVertical — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplitSlideInVertical.glsl
// Author: OllyOllyOlly
// License: MIT
// Description: The incoming image slides in as two halves moving vertically in opposite directions
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
    metal::float2 p_1 = {};
    metal::float2 local = {};
    metal::float2 param = {};
    metal::float4 local_1 = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    int _e25 = uniforms.reverse;
    modifier = (_e25 != 0) ? -1.0 : 1.0;
    float _e29 = uv_2[0u];
    if (_e29 > 0.5) {
        float _e32 = uv_2[0u];
        float _e34 = uv_2[1u];
        float _e36 = uniforms.progress;
        float _e37 = modifier;
        float _e40 = modifier;
        local = metal::float2(_e32, (_e34 - (_e36 * _e37)) + _e40);
    } else {
        float _e44 = uv_2[0u];
        float _e46 = uv_2[1u];
        float _e48 = uniforms.progress;
        float _e49 = modifier;
        float _e52 = modifier;
        local = metal::float2(_e44, (_e46 + (_e48 * _e49)) - _e52);
    }
    metal::float2 _e55 = local;
    p_1 = _e55;
    metal::float2 _e56 = p_1;
    param = _e56;
    bool _e57 = inBounds(param);
    if (_e57) {
        metal::float2 _e58 = p_1;
        param_1 = _e58;
        metal::float4 _e59 = getToColor(param_1, _sampler, _to);
        local_1 = _e59;
    } else {
        metal::float2 _e60 = uv_2;
        param_2 = _e60;
        metal::float4 _e61 = getFromColor(param_2, _from, _sampler);
        local_1 = _e61;
    }
    metal::float4 _e62 = local_1;
    return _e62;
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
