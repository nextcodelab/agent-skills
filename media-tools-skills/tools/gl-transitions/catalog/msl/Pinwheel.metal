// Pinwheel — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Pinwheel.glsl
// Author: Mr Speaker
// License: MIT
// Description: A spinning pinwheel reveals the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float speed;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e17 = uv[0u];
    float _e19 = uv[1u];
    metal::float4 _e22 = _from.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e17 = uv_1[0u];
    float _e19 = uv_1[1u];
    metal::float4 _e22 = _to.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p = {};
    float circPos = {};
    float modPos = {};
    float signed_ = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e22 = uv_2;
    p = _e22 / metal::float2(1.0, 1.0);
    float _e25 = p[1u];
    float _e28 = p[0u];
    float _e32 = uniforms.progress;
    float _e34 = uniforms.speed;
    circPos = metal::atan2(_e25 - 0.5, _e28 - 0.5) + (_e32 * _e34);
    float _e37 = circPos;
    modPos = _e37 - (metal::floor(_e37 / 0.785375) * 0.785375);
    float _e43 = uniforms.progress;
    float _e44 = modPos;
    signed_ = metal::sign(_e43 - _e44);
    metal::float2 _e47 = p;
    param = _e47;
    metal::float4 _e48 = getToColor(param, _sampler, _to);
    metal::float2 _e49 = p;
    param_1 = _e49;
    metal::float4 _e50 = getFromColor(param_1, _from, _sampler);
    float _e51 = signed_;
    return metal::mix(_e48, _e50, metal::float4(metal::step(_e51, 0.5)));
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
