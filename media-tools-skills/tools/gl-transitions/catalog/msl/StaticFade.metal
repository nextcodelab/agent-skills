// StaticFade — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StaticFade.glsl
// Author: Ben Lucas
// License: MIT
// Description: Cuts to the incoming image halfway, hidden behind a burst of TV static
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float n_noise_pixels;
    float static_luminosity;
};

float rnd(
    thread metal::float2& st
) {
    metal::float2 _e26 = st;
    return metal::fract(metal::sin(metal::dot(_e26, metal::float2(10.530234, 70.23493))) * 12345.545);
}

float staticIntensity(
    thread float& t
) {
    float transitionProgress = {};
    float transformedThreshold = {};
    float _e28 = t;
    transitionProgress = metal::abs(2.0 * (_e28 - 0.5));
    float _e32 = transitionProgress;
    transformedThreshold = (1.2 * (1.0 - _e32)) - 0.1;
    float _e36 = transformedThreshold;
    return metal::min(1.0, _e36);
}

metal::float4 staticNoise(
    thread metal::float2& st_1,
    thread float& offset,
    thread float& luminosity,
    thread float& alpha
) {
    float staticR = {};
    metal::float2 param = {};
    float staticG = {};
    metal::float2 param_1 = {};
    float staticB = {};
    metal::float2 param_2 = {};
    float _e35 = luminosity;
    metal::float2 _e36 = st_1;
    float _e37 = offset;
    float _e39 = offset;
    param = _e36 * metal::float2(_e37 * 2.0, _e39 * 3.0);
    float _e43 = rnd(param);
    staticR = _e35 * _e43;
    float _e45 = luminosity;
    metal::float2 _e46 = st_1;
    float _e47 = offset;
    float _e49 = offset;
    param_1 = _e46 * metal::float2(_e47 * 3.0, _e49 * 5.0);
    float _e53 = rnd(param_1);
    staticG = _e45 * _e53;
    float _e55 = luminosity;
    metal::float2 _e56 = st_1;
    float _e57 = offset;
    float _e59 = offset;
    param_2 = _e56 * metal::float2(_e57 * 5.0, _e59 * 7.0);
    float _e63 = rnd(param_2);
    staticB = _e55 * _e63;
    float _e65 = staticR;
    float _e66 = staticG;
    float _e67 = staticB;
    float _e68 = alpha;
    return metal::float4(_e65, _e66, _e67, _e68);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e27 = uv[0u];
    float _e29 = uv[1u];
    metal::float4 _e32 = _to.sample(_sampler, metal::float2(_e27, 1.0 - _e29), metal::level(0.0));
    return _e32;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e27 = uv_1[0u];
    float _e29 = uv_1[1u];
    metal::float4 _e32 = _from.sample(_sampler, metal::float2(_e27, 1.0 - _e29), metal::level(0.0));
    return _e32;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float baseMix = {};
    metal::float4 transitionMix = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 uvStatic = {};
    metal::float4 staticColor = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float staticThresh = {};
    float param_9 = {};
    float staticMix = {};
    metal::float2 param_10 = {};
    float _e41 = uniforms.progress;
    baseMix = metal::step(0.5, _e41);
    metal::float2 _e43 = uv_2;
    param_3 = _e43;
    metal::float4 _e44 = getFromColor(param_3, _from, _sampler);
    metal::float2 _e45 = uv_2;
    param_4 = _e45;
    metal::float4 _e46 = getToColor(param_4, _sampler, _to);
    float _e47 = baseMix;
    transitionMix = metal::mix(_e44, _e46, metal::float4(_e47));
    metal::float2 _e50 = uv_2;
    float _e52 = uniforms.n_noise_pixels;
    float _e56 = uniforms.n_noise_pixels;
    uvStatic = metal::floor(_e50 * _e52) / metal::float2(_e56);
    metal::float2 _e59 = uvStatic;
    param_5 = _e59;
    float _e61 = uniforms.progress;
    param_6 = _e61;
    float _e63 = uniforms.static_luminosity;
    param_7 = _e63;
    float _e65 = transitionMix[3u];
    param_8 = _e65;
    metal::float4 _e66 = staticNoise(param_5, param_6, param_7, param_8);
    staticColor = _e66;
    float _e68 = uniforms.progress;
    param_9 = _e68;
    float _e69 = staticIntensity(param_9);
    staticThresh = _e69;
    metal::float2 _e70 = uvStatic;
    param_10 = _e70;
    float _e71 = rnd(param_10);
    float _e72 = staticThresh;
    staticMix = metal::step(_e71, _e72);
    metal::float4 _e74 = transitionMix;
    metal::float4 _e75 = staticColor;
    float _e76 = staticMix;
    return metal::mix(_e74, _e75, metal::float4(_e76));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_11 = {};
    metal::float2 _e26 = _uv_1;
    param_11 = _e26;
    metal::float4 _e27 = transition(param_11, _from, _sampler, _to, uniforms);
    _fragColor = _e27;
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
