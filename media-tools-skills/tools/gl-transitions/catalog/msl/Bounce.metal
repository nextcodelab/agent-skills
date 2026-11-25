// Bounce — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Bounce.glsl
// Author: Adrian Purser
// License: MIT
// Description: The outgoing image drops out of the frame with a few bounces, revealing the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float4 shadow_colour;
    float shadow_height;
    float bounces;
    char _pad5[8];
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e20 = uv[0u];
    float _e22 = uv[1u];
    metal::float4 _e25 = _from.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e20 = uv_1[0u];
    float _e22 = uv_1[1u];
    metal::float4 _e25 = _to.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float time = {};
    float stime = {};
    float phase = {};
    float y = {};
    float d = {};
    metal::float4 to = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e28 = uniforms.progress;
    time = _e28;
    float _e29 = time;
    stime = metal::sin((_e29 * 3.1415927) / 2.0);
    float _e33 = time;
    float _e36 = uniforms.bounces;
    phase = (_e33 * 3.1415927) * _e36;
    float _e38 = phase;
    float _e41 = stime;
    y = metal::abs(metal::cos(_e38)) * (1.0 - _e41);
    float _e45 = uv_2[1u];
    float _e46 = y;
    d = _e45 - _e46;
    metal::float2 _e48 = uv_2;
    param = _e48;
    metal::float4 _e49 = getToColor(param, _sampler, _to);
    to = _e49;
    metal::float4 _e50 = to;
    metal::float4 _e52 = uniforms.shadow_colour;
    metal::float3 _e53 = _e52.xyz;
    float _e58 = d;
    float _e60 = uniforms.shadow_height;
    float _e62 = d;
    float _e64 = uniforms.shadow_height;
    float _e68 = uniforms.shadow_colour[3u];
    float _e72 = uniforms.shadow_colour[3u];
    float _e76 = uniforms.progress;
    float _e82 = to[3u];
    float _e87 = uv_2[0u];
    float _e89 = uv_2[1u];
    float _e90 = y;
    param_1 = metal::float2(_e87, _e89 + (1.0 - _e90));
    metal::float4 _e94 = getFromColor(param_1, _from, _sampler);
    float _e95 = d;
    return metal::mix(metal::mix(_e50, metal::float4(_e53.x, _e53.y, _e53.z, 1.0), metal::float4((metal::step(_e58, _e60) * (1.0 - metal::mix(((_e62 / _e64) * _e68) + (1.0 - _e72), 1.0, metal::smoothstep(0.95, 1.0, _e76)))) * _e82)), _e94, metal::float4(metal::step(_e95, 0.0)));
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
