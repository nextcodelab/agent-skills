// TvStatic — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvStatic.glsl
// Author: Brandon Anzaldi
// License: MIT
// Description: Cuts to full-screen TV static, then to the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float offset;
};

float noise(
    thread metal::float2& co,
    constant Uniforms& uniforms
) {
    float a = {};
    float b = {};
    float c = {};
    float dt = {};
    float sn = {};
    a = 12.9898;
    b = 78.233;
    c = 43758.547;
    metal::float2 _e23 = co;
    float _e25 = uniforms.progress;
    float _e27 = a;
    float _e28 = b;
    dt = metal::dot(_e23 * _e25, metal::float2(_e27, _e28));
    float _e31 = dt;
    sn = _e31 - (metal::floor(_e31 / 3.14) * 3.14);
    float _e36 = sn;
    float _e38 = c;
    return metal::fract(metal::sin(_e36) * _e38);
}

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
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    float _e24 = uniforms.progress;
    float _e26 = uniforms.offset;
    if (_e24 < _e26) {
        metal::float2 _e28 = p;
        param = _e28;
        metal::float4 _e29 = getFromColor(param, _from, _sampler);
        return _e29;
    } else {
        float _e31 = uniforms.progress;
        float _e33 = uniforms.offset;
        if (_e31 > (1.0 - _e33)) {
            metal::float2 _e36 = p;
            param_1 = _e36;
            metal::float4 _e37 = getToColor(param_1, _sampler, _to);
            return _e37;
        } else {
            metal::float2 _e38 = p;
            param_2 = _e38;
            float _e39 = noise(param_2, uniforms);
            metal::float3 _e40 = metal::float3(_e39);
            metal::float2 _e41 = p;
            param_3 = _e41;
            metal::float4 _e42 = getFromColor(param_3, _from, _sampler);
            metal::float2 _e44 = p;
            param_4 = _e44;
            metal::float4 _e45 = getToColor(param_4, _sampler, _to);
            return metal::float4(_e40.x, _e40.y, _e40.z, metal::max(_e42.w, _e45.w));
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
    metal::float2 param_5 = {};
    metal::float2 _e18 = _uv_1;
    param_5 = _e18;
    metal::float4 _e19 = transition(param_5, _from, _sampler, _to, uniforms);
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
