// DirectionalScaled — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DirectionalScaled.glsl
// Author: Thibaut Foussard
// License: MIT
// Description: Like Directional, with both images scaled down while they slide
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float scale;
    char _pad4[4];
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e19 = uv[0u];
    float _e21 = uv[1u];
    metal::float4 _e24 = _from.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e19 = uv_1[0u];
    float _e21 = uv_1[1u];
    metal::float4 _e24 = _to.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

float parabola(
    thread float& x
) {
    float y = {};
    float _e19 = x;
    y = metal::pow(metal::sin(_e19 * 3.1415927), 1.0);
    float _e23 = y;
    return _e23;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float easedProgress = {};
    metal::float2 p = {};
    metal::float2 f = {};
    float s = {};
    float param = {};
    float mixer = {};
    metal::float4 col = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float border = {};
    float _e29 = uniforms.progress;
    easedProgress = metal::pow(metal::sin((_e29 * 3.1415927) / 2.0), 3.0);
    metal::float2 _e34 = uv_2;
    float _e35 = easedProgress;
    metal::float2 _e37 = uniforms.direction;
    p = _e34 + (metal::sign(_e37) * _e35);
    metal::float2 _e41 = p;
    f = metal::fract(_e41);
    float _e44 = uniforms.scale;
    float _e48 = uniforms.progress;
    param = _e48;
    float _e49 = parabola(param);
    s = 1.0 - ((1.0 - (1.0 / _e44)) * _e49);
    metal::float2 _e52 = f;
    float _e55 = s;
    f = ((_e52 - metal::float2(0.5)) * _e55) + metal::float2(0.5);
    float _e60 = p[1u];
    float _e63 = p[1u];
    float _e67 = p[0u];
    float _e71 = p[0u];
    mixer = ((metal::step(0.0, _e60) * metal::step(_e63, 1.0)) * metal::step(0.0, _e67)) * metal::step(_e71, 1.0);
    metal::float2 _e74 = f;
    param_1 = _e74;
    metal::float4 _e75 = getToColor(param_1, _sampler, _to);
    metal::float2 _e76 = f;
    param_2 = _e76;
    metal::float4 _e77 = getFromColor(param_2, _from, _sampler);
    float _e78 = mixer;
    col = metal::mix(_e75, _e77, metal::float4(_e78));
    float _e82 = f[0u];
    float _e85 = f[0u];
    float _e90 = f[1u];
    float _e94 = f[1u];
    border = ((metal::step(0.0, _e82) * metal::step(0.0, 1.0 - _e85)) * metal::step(0.0, _e90)) * metal::step(0.0, 1.0 - _e94);
    float _e98 = border;
    metal::float4 _e99 = col;
    col = _e99 * _e98;
    metal::float4 _e101 = col;
    return _e101;
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
    metal::float2 _e18 = _uv_1;
    param_3 = _e18;
    metal::float4 _e19 = transition(param_3, _from, _sampler, _to, uniforms);
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
