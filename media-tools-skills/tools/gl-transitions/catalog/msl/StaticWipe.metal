// StaticWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StaticWipe.glsl
// Author: Ben Lucas
// License: MIT
// Description: A wipe from top to bottom with a band of TV static at its edge
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int u_transitionUpToDown;
    float u_max_static_span;
};

float rnd(
    thread metal::float2& st
) {
    metal::float2 _e21 = st;
    return metal::fract(metal::sin(metal::dot(_e21, metal::float2(10.0, 70.0))) * 12345.545);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e22 = uv[0u];
    float _e24 = uv[1u];
    metal::float4 _e27 = _to.sample(_sampler, metal::float2(_e22, 1.0 - _e24), metal::level(0.0));
    return _e27;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e22 = uv_1[0u];
    float _e24 = uv_1[1u];
    metal::float4 _e27 = _from.sample(_sampler, metal::float2(_e22, 1.0 - _e24), metal::level(0.0));
    return _e27;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float span = {};
    float transitionEdge = {};
    float local = {};
    float mixRatio = {};
    metal::float4 transitionMix = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float noiseEnvelope = {};
    metal::float4 noise = {};
    metal::float2 param_2 = {};
    float _e32 = uniforms.u_max_static_span;
    float _e34 = uniforms.progress;
    span = _e32 * metal::pow(metal::sin(3.1415927 * _e34), 0.5);
    int _e40 = uniforms.u_transitionUpToDown;
    if (_e40 != 0) {
        float _e43 = uv_2[1u];
        local = 1.0 - _e43;
    } else {
        float _e46 = uv_2[1u];
        local = _e46;
    }
    float _e47 = local;
    transitionEdge = _e47;
    float _e49 = uniforms.progress;
    float _e50 = transitionEdge;
    mixRatio = 1.0 - metal::step(_e49, _e50);
    metal::float2 _e53 = uv_2;
    param = _e53;
    metal::float4 _e54 = getFromColor(param, _from, _sampler);
    metal::float2 _e55 = uv_2;
    param_1 = _e55;
    metal::float4 _e56 = getToColor(param_1, _sampler, _to);
    float _e57 = mixRatio;
    transitionMix = metal::mix(_e54, _e56, metal::float4(_e57));
    float _e61 = uniforms.progress;
    float _e62 = span;
    float _e65 = uniforms.progress;
    float _e66 = transitionEdge;
    float _e69 = uniforms.progress;
    float _e71 = uniforms.progress;
    float _e72 = span;
    float _e74 = transitionEdge;
    noiseEnvelope = metal::smoothstep(_e61 - _e62, _e65, _e66) * (1.0 - metal::smoothstep(_e69, _e71 + _e72, _e74));
    metal::float2 _e78 = uv_2;
    float _e80 = uniforms.progress;
    param_2 = _e78 * (1.0 + _e80);
    float _e83 = rnd(param_2);
    metal::float3 _e84 = metal::float3(_e83);
    float _e86 = transitionMix[3u];
    noise = metal::float4(_e84.x, _e84.y, _e84.z, _e86);
    metal::float4 _e91 = transitionMix;
    metal::float4 _e92 = noise;
    float _e93 = noiseEnvelope;
    return metal::mix(_e91, _e92, metal::float4(_e93));
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
    metal::float2 _e21 = _uv_1;
    param_3 = _e21;
    metal::float4 _e22 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e22;
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
