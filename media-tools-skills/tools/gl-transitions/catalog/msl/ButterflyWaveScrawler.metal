// ButterflyWaveScrawler — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ButterflyWaveScrawler.glsl
// Author: mandubian
// License: MIT
// Description: Wavy, color-separated ripples scramble the outgoing image into the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float amplitude;
    float waves;
    float colorSeparation;
};

float compute(
    thread metal::float2& p,
    thread float& progress,
    thread metal::float2& center,
    constant Uniforms& uniforms
) {
    metal::float2 o = {};
    metal::float2 h = {};
    float theta = {};
    float s = {};
    float s2_ = {};
    metal::float2 _e32 = p;
    float _e33 = progress;
    float _e35 = uniforms.amplitude;
    metal::float2 _e39 = center;
    o = (_e32 * metal::sin(_e33 * _e35)) - _e39;
    h = metal::float2(1.0, 0.0);
    metal::float2 _e41 = o;
    metal::float2 _e42 = h;
    float _e46 = uniforms.waves;
    theta = metal::acos(metal::dot(_e41, _e42)) * _e46;
    float _e48 = theta;
    s = metal::sin(((2.0 * _e48) - 3.1415927) / 24.0);
    float _e53 = s;
    float _e54 = s;
    s2_ = _e53 * _e54;
    float _e56 = theta;
    float _e59 = theta;
    float _e64 = s2_;
    float _e65 = s2_;
    float _e67 = s;
    return ((metal::exp(metal::cos(_e56)) - (2.0 * metal::cos(4.0 * _e59))) + ((_e64 * _e65) * _e67)) / 10.0;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e26 = uv[0u];
    float _e28 = uv[1u];
    metal::float4 _e31 = _to.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e26 = uv_1[0u];
    float _e28 = uv_1[1u];
    metal::float4 _e31 = _from.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 p_1 = {};
    float inv = {};
    float disp = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    metal::float2 param_4 = {};
    metal::float4 texTo = {};
    metal::float2 param_5 = {};
    metal::float4 fromCenter = {};
    metal::float2 param_6 = {};
    metal::float4 texFrom = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float _e41 = uniforms.progress;
    if (_e41 <= 0.0) {
        metal::float2 _e43 = uv_2;
        param = _e43;
        metal::float4 _e44 = getFromColor(param, _from, _sampler);
        return _e44;
    }
    float _e46 = uniforms.progress;
    if (_e46 >= 1.0) {
        metal::float2 _e48 = uv_2;
        param_1 = _e48;
        metal::float4 _e49 = getToColor(param_1, _sampler, _to);
        return _e49;
    }
    metal::float2 _e50 = uv_2;
    p_1 = _e50;
    float _e52 = uniforms.progress;
    inv = 1.0 - _e52;
    metal::float2 _e54 = p_1;
    param_2 = _e54;
    float _e56 = uniforms.progress;
    param_3 = _e56;
    param_4 = metal::float2(0.5, 0.5);
    float _e57 = compute(param_2, param_3, param_4, uniforms);
    disp = _e57;
    metal::float2 _e58 = p_1;
    float _e59 = inv;
    float _e60 = disp;
    param_5 = _e58 + metal::float2(_e59 * _e60);
    metal::float4 _e64 = getToColor(param_5, _sampler, _to);
    texTo = _e64;
    metal::float2 _e65 = p_1;
    float _e67 = uniforms.progress;
    float _e68 = disp;
    param_6 = _e65 + metal::float2(_e67 * _e68);
    metal::float4 _e72 = getFromColor(param_6, _from, _sampler);
    fromCenter = _e72;
    metal::float2 _e73 = p_1;
    float _e75 = uniforms.progress;
    float _e76 = disp;
    float _e79 = uniforms.colorSeparation;
    param_7 = _e73 + metal::float2((_e75 * _e76) * (1.0 - _e79));
    metal::float4 _e84 = getFromColor(param_7, _from, _sampler);
    float _e87 = fromCenter[1u];
    metal::float2 _e88 = p_1;
    float _e90 = uniforms.progress;
    float _e91 = disp;
    float _e94 = uniforms.colorSeparation;
    param_8 = _e88 + metal::float2((_e90 * _e91) * (1.0 + _e94));
    metal::float4 _e99 = getFromColor(param_8, _from, _sampler);
    float _e102 = fromCenter[3u];
    texFrom = metal::float4(_e84.x, _e87, _e99.z, _e102);
    metal::float4 _e104 = texTo;
    float _e106 = uniforms.progress;
    metal::float4 _e108 = texFrom;
    float _e109 = inv;
    return (_e104 * _e106) + (_e108 * _e109);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_9 = {};
    metal::float2 _e25 = _uv_1;
    param_9 = _e25;
    metal::float4 _e26 = transition(param_9, _from, _sampler, _to, uniforms);
    _fragColor = _e26;
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
