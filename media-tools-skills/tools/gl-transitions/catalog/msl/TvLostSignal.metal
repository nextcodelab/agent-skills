// TvLostSignal — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvLostSignal.glsl
// Author: mernking (gitlab.com/Godswork)
// License: MIT
// Description: A crossfade with drifting tracking lines and tearing, like a TV losing its signal
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

float hash(
    thread metal::float2& p
) {
    metal::float2 _e26 = p;
    return metal::fract(metal::sin(metal::dot(_e26, metal::float2(127.1, 311.7))) * 43758.547);
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
    float p_1 = {};
    float strength = {};
    metal::float2 tv = {};
    metal::float4 fromColor = {};
    metal::float2 param = {};
    metal::float4 toColor = {};
    metal::float2 param_1 = {};
    metal::float4 color = {};
    float lineY = {};
    float noise = {};
    metal::float2 param_2 = {};
    float line = {};
    float drift = {};
    metal::float4 shiftedFrom = {};
    metal::float2 param_3 = {};
    metal::float4 shiftedTo = {};
    metal::float2 param_4 = {};
    metal::float4 lineColor = {};
    float scan = {};
    float _e46 = uniforms.progress;
    p_1 = _e46;
    float _e47 = p_1;
    strength = metal::sin(_e47 * 3.1415927);
    metal::float2 _e50 = uv_2;
    tv = _e50;
    metal::float2 _e51 = tv;
    param = _e51;
    metal::float4 _e52 = getFromColor(param, _from, _sampler);
    fromColor = _e52;
    metal::float2 _e53 = tv;
    param_1 = _e53;
    metal::float4 _e54 = getToColor(param_1, _sampler, _to);
    toColor = _e54;
    metal::float4 _e55 = fromColor;
    metal::float4 _e56 = toColor;
    float _e57 = p_1;
    color = metal::mix(_e55, _e56, metal::float4(_e57));
    float _e61 = tv[1u];
    lineY = metal::floor(_e61 * 120.0);
    float _e64 = lineY;
    float _e65 = p_1;
    param_2 = metal::float2(_e64, _e65 * 20.0);
    float _e68 = hash(param_2);
    noise = _e68;
    float _e69 = noise;
    line = metal::step(0.92, _e69);
    float _e72 = tv[1u];
    float _e74 = p_1;
    float _e79 = strength;
    drift = (metal::sin((_e72 * 30.0) + (_e74 * 10.0)) * 0.02) * _e79;
    metal::float2 _e81 = tv;
    float _e82 = drift;
    param_3 = _e81 + metal::float2(_e82, 0.0);
    metal::float4 _e85 = getFromColor(param_3, _from, _sampler);
    shiftedFrom = _e85;
    metal::float2 _e86 = tv;
    float _e87 = drift;
    param_4 = _e86 + metal::float2(_e87, 0.0);
    metal::float4 _e90 = getToColor(param_4, _sampler, _to);
    shiftedTo = _e90;
    metal::float4 _e91 = shiftedFrom;
    metal::float4 _e92 = shiftedTo;
    float _e93 = p_1;
    lineColor = metal::mix(_e91, _e92, metal::float4(_e93));
    metal::float4 _e96 = color;
    metal::float4 _e97 = lineColor;
    float _e98 = line;
    float _e99 = strength;
    color = metal::mix(_e96, _e97, metal::float4(_e98 * _e99));
    float _e104 = tv[1u];
    scan = metal::sin(_e104 * 900.0) * 0.03;
    float _e108 = scan;
    float _e109 = strength;
    metal::float4 _e111 = color;
    metal::float3 _e114 = _e111.xyz - metal::float3(_e108 * _e109);
    color[0u] = _e114.x;
    color[1u] = _e114.y;
    color[2u] = _e114.z;
    metal::float4 _e121 = color;
    return _e121;
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
    metal::float2 _e26 = _uv_1;
    param_5 = _e26;
    metal::float4 _e27 = transition(param_5, _from, _sampler, _to, uniforms);
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
