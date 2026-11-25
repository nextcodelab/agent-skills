// LeftRight — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LeftRight.glsl
// Author: zhmy
// License: MIT
// Description: The outgoing image shrinks away to the left while the incoming one slides in from the right
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e24 = uv[0u];
    float _e26 = uv[1u];
    metal::float4 _e29 = _from.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e24 = uv_1[0u];
    float _e26 = uv_1[1u];
    metal::float4 _e29 = _to.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

bool inBounds(
    thread metal::float2& p
) {
    bool phi_74_ = {};
    metal::float2 _e23 = p;
    bool _e25 = metal::all(metal::float2(0.0, 0.0) < _e23);
    phi_74_ = _e25;
    if (_e25) {
        metal::float2 _e26 = p;
        phi_74_ = metal::all(_e26 < metal::float2(1.0, 1.0));
    }
    bool _e30 = phi_74_;
    return _e30;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 spto = {};
    float size = {};
    metal::float2 spfr = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    spto = metal::float2(-1.0, -1.0);
    float _e31 = uniforms.progress;
    size = metal::mix(1.0, 3.0, _e31 * 0.2);
    metal::float2 _e34 = uv_2;
    float _e36 = size;
    spto = ((_e34 + metal::float2(-0.5, -0.5)) * metal::float2(_e36)) + metal::float2(0.5, 0.5);
    metal::float2 _e40 = uv_2;
    float _e42 = uniforms.progress;
    spfr = _e40 - metal::float2(1.0 - _e42, 0.0);
    metal::float2 _e46 = spfr;
    param = _e46;
    bool _e47 = inBounds(param);
    if (_e47) {
        metal::float2 _e48 = spfr;
        param_1 = _e48;
        metal::float4 _e49 = getToColor(param_1, _sampler, _to);
        return _e49;
    } else {
        metal::float2 _e50 = spto;
        param_2 = _e50;
        bool _e51 = inBounds(param_2);
        if (_e51) {
            metal::float2 _e52 = spto;
            param_3 = _e52;
            metal::float4 _e53 = getFromColor(param_3, _from, _sampler);
            float _e55 = uniforms.progress;
            return _e53 * (1.0 - _e55);
        } else {
            return metal::float4(0.0, 0.0, 0.0, 0.0);
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
    metal::float2 param_4 = {};
    metal::float2 _e23 = _uv_1;
    param_4 = _e23;
    metal::float4 _e24 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e24;
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
