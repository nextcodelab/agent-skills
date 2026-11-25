// DirectionalWarp — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DirectionalWarp.glsl
// Author: pschroen
// License: MIT
// Description: A diagonal wipe with a warped, smeared edge
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float smoothness;
    char _pad3[4];
    metal::float2 direction;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e17 = uv[0u];
    float _e19 = uv[1u];
    metal::float4 _e22 = _to.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e17 = uv_1[0u];
    float _e19 = uv_1[1u];
    metal::float4 _e22 = _from.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 v = {};
    float d = {};
    float m = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e22 = uniforms.direction;
    v = metal::normalize(_e22);
    float _e25 = v[0u];
    float _e28 = v[1u];
    metal::float2 _e31 = v;
    v = _e31 / metal::float2(metal::abs(_e25) + metal::abs(_e28));
    float _e35 = v[0u];
    float _e38 = v[1u];
    d = (_e35 * 0.5) + (_e38 * 0.5);
    float _e42 = uniforms.smoothness;
    float _e45 = v[0u];
    float _e47 = uv_2[0u];
    float _e50 = v[1u];
    float _e52 = uv_2[1u];
    float _e55 = d;
    float _e58 = uniforms.progress;
    float _e60 = uniforms.smoothness;
    m = 1.0 - metal::smoothstep(-(_e42), 0.0, ((_e45 * _e47) + (_e50 * _e52)) - ((_e55 - 0.5) + (_e58 * (1.0 + _e60))));
    metal::float2 _e67 = uv_2;
    float _e70 = m;
    param = ((_e67 - metal::float2(0.5)) * (1.0 - _e70)) + metal::float2(0.5);
    metal::float4 _e75 = getFromColor(param, _from, _sampler);
    metal::float2 _e76 = uv_2;
    float _e79 = m;
    param_1 = ((_e76 - metal::float2(0.5)) * _e79) + metal::float2(0.5);
    metal::float4 _e83 = getToColor(param_1, _sampler, _to);
    float _e84 = m;
    return metal::mix(_e75, _e83, metal::float4(_e84));
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
    metal::float2 _e16 = _uv_1;
    param_2 = _e16;
    metal::float4 _e17 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e17;
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
