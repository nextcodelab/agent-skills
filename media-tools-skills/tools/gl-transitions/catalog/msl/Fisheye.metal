// Fisheye — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Fisheye.glsl
// Author: gre
// License: MIT
// Description: The outgoing image bulges toward the viewer through a strong fisheye lens, then the incoming one flattens back into place
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
    float h = {};
    float k = {};
    metal::float2 aspect = {};
    metal::float2 c = {};
    float r = {};
    metal::float2 q = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e28 = uniforms.progress;
    h = metal::smoothstep(0.0, 1.0, 1.0 - metal::abs((2.0 * _e28) - 1.0));
    float _e35 = uniforms.strength;
    float _e38 = h;
    k = 1.0 - metal::pow(metal::max(1.0 - _e35, 0.01), _e38);
    float _e42 = uniforms.ratio;
    aspect = metal::float2(_e42, 1.0);
    metal::float2 _e44 = uv_2;
    metal::float2 _e47 = aspect;
    c = (_e44 - metal::float2(0.5)) * _e47;
    metal::float2 _e49 = c;
    metal::float2 _e51 = aspect;
    r = metal::length(_e49) / metal::length(_e51 * 0.5);
    metal::float2 _e55 = uv_2;
    float _e58 = k;
    float _e60 = k;
    float _e61 = r;
    float _e63 = r;
    q = metal::float2(0.5) + ((_e55 - metal::float2(0.5)) * ((1.0 - _e58) + ((_e60 * _e61) * _e63)));
    metal::float2 _e69 = q;
    param = _e69;
    metal::float4 _e70 = getFromColor(param, _from, _sampler);
    metal::float2 _e71 = q;
    param_1 = _e71;
    metal::float4 _e72 = getToColor(param_1, _sampler, _to);
    float _e74 = uniforms.progress;
    return metal::mix(_e70, _e72, metal::float4(metal::smoothstep(0.38, 0.62, _e74)));
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
