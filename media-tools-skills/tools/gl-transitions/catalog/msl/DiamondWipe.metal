// DiamondWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DiamondWipe.glsl
// Author: gre
// License: MIT
// Description: A soft-edged diamond grows from the center to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float smoothness;
    char _pad4[4];
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
    metal::float2 d = {};
    metal::float2 far = {};
    float dist = {};
    float s = {};
    float m = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e23 = uv_2;
    metal::float2 _e25 = uniforms.center;
    float _e29 = uniforms.ratio;
    d = metal::abs(_e23 - _e25) * metal::float2(_e29, 1.0);
    metal::float2 _e33 = uniforms.center;
    metal::float2 _e35 = uniforms.center;
    float _e40 = uniforms.ratio;
    far = metal::max(_e33, metal::float2(1.0) - _e35) * metal::float2(_e40, 1.0);
    float _e44 = d[0u];
    float _e46 = d[1u];
    float _e49 = far[0u];
    float _e51 = far[1u];
    dist = (_e44 + _e46) / (_e49 + _e51);
    float _e55 = uniforms.smoothness;
    s = metal::max(_e55, 0.001);
    float _e57 = s;
    float _e59 = uniforms.progress;
    float _e60 = s;
    float _e63 = dist;
    m = metal::smoothstep(0.0, _e57, (_e59 * (1.0 + _e60)) - _e63);
    metal::float2 _e66 = uv_2;
    param = _e66;
    metal::float4 _e67 = getFromColor(param, _from, _sampler);
    metal::float2 _e68 = uv_2;
    param_1 = _e68;
    metal::float4 _e69 = getToColor(param_1, _sampler, _to);
    float _e70 = m;
    return metal::mix(_e67, _e69, metal::float4(_e70));
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
