// SplitSlideInHorizontal — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplitSlideInHorizontal.glsl
// Author: OllyOllyOlly
// License: MIT
// Description: The incoming image slides in as two halves moving horizontally in opposite directions
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
    metal::float2 toP = {};
    metal::float2 local = {};
    metal::float2 fromP = {};
    metal::float2 param = {};
    metal::float4 local_1 = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    int _e26 = uniforms.reverse;
    modifier = (_e26 != 0) ? -1.0 : 1.0;
    float _e30 = uv_2[1u];
    if (_e30 > 0.5) {
        float _e33 = uv_2[0u];
        float _e35 = uniforms.progress;
        float _e36 = modifier;
        float _e39 = modifier;
        float _e42 = uv_2[1u];
        local = metal::float2((_e33 - (_e35 * _e36)) + _e39, _e42);
    } else {
        float _e45 = uv_2[0u];
        float _e47 = uniforms.progress;
        float _e48 = modifier;
        float _e51 = modifier;
        float _e54 = uv_2[1u];
        local = metal::float2((_e45 + (_e47 * _e48)) - _e51, _e54);
    }
    metal::float2 _e56 = local;
    toP = _e56;
    metal::float2 _e57 = uv_2;
    fromP = _e57;
    metal::float2 _e58 = toP;
    param = _e58;
    bool _e59 = inBounds(param);
    if (_e59) {
        metal::float2 _e60 = toP;
        param_1 = _e60;
        metal::float4 _e61 = getToColor(param_1, _sampler, _to);
        local_1 = _e61;
    } else {
        metal::float2 _e62 = fromP;
        param_2 = _e62;
        metal::float4 _e63 = getFromColor(param_2, _from, _sampler);
        local_1 = _e63;
    }
    metal::float4 _e64 = local_1;
    return _e64;
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
