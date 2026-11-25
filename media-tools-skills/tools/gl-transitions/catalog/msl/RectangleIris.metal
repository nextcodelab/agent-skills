// RectangleIris — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RectangleIris.glsl
// Author: martiniti
// License: MIT
// Description: The outgoing image shrinks into a small rectangle over a background color, then the incoming one grows from it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float4 bgcolor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e20 = uv[0u];
    float _e22 = uv[1u];
    metal::float4 _e25 = _to.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e20 = uv_1[0u];
    float _e22 = uv_1[1u];
    metal::float4 _e25 = _from.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float s = {};
    metal::float2 q = {};
    metal::float2 bl = {};
    metal::float2 tr = {};
    float dist = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e28 = uniforms.progress;
    s = metal::pow(2.0 * metal::abs(_e28 - 0.5), 3.0);
    metal::float2 _e33 = uv_2;
    q = _e33 / metal::float2(1.0, 1.0);
    float _e36 = uniforms.progress;
    metal::float2 _e42 = q;
    bl = metal::step(metal::float2(1.0 - (2.0 * metal::abs(_e36 - 0.5))), _e42 + metal::float2(0.25));
    float _e47 = uniforms.progress;
    metal::float2 _e53 = q;
    tr = metal::step(metal::float2(1.0 - (2.0 * metal::abs(_e47 - 0.5))), metal::float2(1.25) - _e53);
    float _e58 = bl[0u];
    float _e60 = bl[1u];
    float _e63 = tr[0u];
    float _e66 = tr[1u];
    dist = metal::abs(1.0 - (((_e58 * _e60) * _e63) * _e66));
    float _e71 = uniforms.progress;
    if (_e71 < 0.5) {
        metal::float2 _e73 = uv_2;
        param = _e73;
        metal::float4 _e74 = getFromColor(param, _from, _sampler);
        local = _e74;
    } else {
        metal::float2 _e75 = uv_2;
        param_1 = _e75;
        metal::float4 _e76 = getToColor(param_1, _sampler, _to);
        local = _e76;
    }
    metal::float4 _e77 = local;
    metal::float4 _e79 = uniforms.bgcolor;
    float _e80 = s;
    float _e81 = dist;
    return metal::mix(_e77, _e79, metal::float4(metal::step(_e80, _e81)));
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
    metal::float2 _e19 = _uv_1;
    param_2 = _e19;
    metal::float4 _e20 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e20;
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
