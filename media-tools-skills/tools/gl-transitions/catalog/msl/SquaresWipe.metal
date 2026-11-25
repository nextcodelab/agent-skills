// SquaresWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SquaresWipe.glsl
// Author: gre
// License: MIT
// Description: Squares grow along a diagonal sweep to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 squares;
    metal::float2 direction;
    float smoothness;
    char _pad5[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e19 = uv[0u];
    float _e21 = uv[1u];
    metal::float4 _e24 = _to.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e19 = uv_1[0u];
    float _e21 = uv_1[1u];
    metal::float4 _e24 = _from.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 v = {};
    float d = {};
    float offset = {};
    float pr = {};
    metal::float2 squarep = {};
    metal::float2 squaremin = {};
    metal::float2 squaremax = {};
    float a = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e29 = uniforms.direction;
    v = metal::normalize(_e29);
    float _e32 = v[0u];
    float _e35 = v[1u];
    metal::float2 _e38 = v;
    v = _e38 / metal::float2(metal::abs(_e32) + metal::abs(_e35));
    float _e42 = v[0u];
    float _e45 = v[1u];
    d = (_e42 * 0.5) + (_e45 * 0.5);
    float _e49 = uniforms.smoothness;
    offset = _e49;
    float _e50 = offset;
    float _e53 = v[0u];
    float _e55 = p[0u];
    float _e58 = v[1u];
    float _e60 = p[1u];
    float _e63 = d;
    float _e66 = uniforms.progress;
    float _e67 = offset;
    pr = metal::smoothstep(-(_e50), 0.0, ((_e53 * _e55) + (_e58 * _e60)) - ((_e63 - 0.5) + (_e66 * (1.0 + _e67))));
    metal::float2 _e73 = p;
    metal::int2 _e75 = uniforms.squares;
    squarep = metal::fract(_e73 * static_cast<metal::float2>(_e75));
    float _e79 = pr;
    squaremin = metal::float2(_e79 / 2.0);
    float _e82 = pr;
    squaremax = metal::float2(1.0 - (_e82 / 2.0));
    float _e87 = uniforms.progress;
    float _e91 = squaremin[0u];
    float _e93 = squarep[0u];
    float _e97 = squaremin[1u];
    float _e99 = squarep[1u];
    float _e103 = squarep[0u];
    float _e105 = squaremax[0u];
    float _e109 = squarep[1u];
    float _e111 = squaremax[1u];
    a = ((((1.0 - metal::step(_e87, 0.0)) * metal::step(_e91, _e93)) * metal::step(_e97, _e99)) * metal::step(_e103, _e105)) * metal::step(_e109, _e111);
    metal::float2 _e114 = p;
    param = _e114;
    metal::float4 _e115 = getFromColor(param, _from, _sampler);
    metal::float2 _e116 = p;
    param_1 = _e116;
    metal::float4 _e117 = getToColor(param_1, _sampler, _to);
    float _e118 = a;
    return metal::mix(_e115, _e117, metal::float4(_e118));
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
    metal::float2 _e18 = _uv_1;
    param_2 = _e18;
    metal::float4 _e19 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e19;
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
