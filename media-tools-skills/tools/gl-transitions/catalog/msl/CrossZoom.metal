// CrossZoom — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CrossZoom.glsl
// Author: rectalogic
// License: MIT
// Description: A crossfade through a strong zoom blur
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e28 = uv[0u];
    float _e30 = uv[1u];
    metal::float4 _e33 = _to.sample(_sampler, metal::float2(_e28, 1.0 - _e30), metal::level(0.0));
    return _e33;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e28 = uv_1[0u];
    float _e30 = uv_1[1u];
    metal::float4 _e33 = _from.sample(_sampler, metal::float2(_e28, 1.0 - _e30), metal::level(0.0));
    return _e33;
}

metal::float4 crossFade(
    thread metal::float2& uv_2,
    thread float& dissolve,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e30 = uv_2;
    param = _e30;
    metal::float4 _e31 = getFromColor(param, _from, _sampler);
    metal::float2 _e32 = uv_2;
    param_1 = _e32;
    metal::float4 _e33 = getToColor(param_1, _sampler, _to);
    float _e34 = dissolve;
    return metal::mix(_e31, _e33, metal::float4(_e34));
}

float rand(
    thread metal::float2& co
) {
    metal::float2 _e27 = co;
    return metal::fract(metal::sin(metal::dot(_e27, metal::float2(12.9898, 78.233))) * 43758.547);
}

float Sinusoidal_easeInOut(
    thread float& begin,
    thread float& change,
    thread float& duration,
    thread float& time
) {
    float _e30 = change;
    float _e33 = time;
    float _e35 = duration;
    float _e40 = begin;
    return ((-(_e30) / 2.0) * (metal::cos((3.1415927 * _e33) / _e35) - 1.0)) + _e40;
}

float Exponential_easeInOut(
    thread float& begin_1,
    thread float& change_1,
    thread float& duration_1,
    thread float& time_1
) {
    float _e30 = time_1;
    if (_e30 == 0.0) {
        float _e32 = begin_1;
        return _e32;
    } else {
        float _e33 = time_1;
        float _e34 = duration_1;
        if (_e33 == _e34) {
            float _e36 = begin_1;
            float _e37 = change_1;
            return _e36 + _e37;
        }
    }
    float _e39 = time_1;
    float _e40 = duration_1;
    time_1 = _e39 / (_e40 / 2.0);
    float _e43 = time_1;
    if (_e43 < 1.0) {
        float _e45 = change_1;
        float _e47 = time_1;
        float _e52 = begin_1;
        return ((_e45 / 2.0) * metal::pow(2.0, 10.0 * (_e47 - 1.0))) + _e52;
    }
    float _e54 = change_1;
    float _e56 = time_1;
    float _e63 = begin_1;
    return ((_e54 / 2.0) * (-(metal::pow(2.0, -10.0 * (_e56 - 1.0))) + 2.0)) + _e63;
}

float Linear_ease(
    thread float& begin_2,
    thread float& change_2,
    thread float& duration_2,
    thread float& time_2
) {
    float _e30 = change_2;
    float _e31 = time_2;
    float _e33 = duration_2;
    float _e35 = begin_2;
    return ((_e30 * _e31) / _e33) + _e35;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 texCoord = {};
    metal::float2 center = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float dissolve_1 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float strength = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    metal::float4 color = {};
    float total = {};
    metal::float2 toCenter = {};
    float offset = {};
    metal::float2 param_14 = {};
    float t = {};
    float percent = {};
    float weight = {};
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float2 _e53 = uv_3;
    texCoord = _e53 / metal::float2(1.0, 1.0);
    param_2 = 0.25;
    param_3 = 0.5;
    param_4 = 1.0;
    float _e56 = uniforms.progress;
    param_5 = _e56;
    float _e57 = Linear_ease(param_2, param_3, param_4, param_5);
    center = metal::float2(_e57, 0.5);
    param_6 = 0.0;
    param_7 = 1.0;
    param_8 = 1.0;
    float _e60 = uniforms.progress;
    param_9 = _e60;
    float _e61 = Exponential_easeInOut(param_6, param_7, param_8, param_9);
    dissolve_1 = _e61;
    param_10 = 0.0;
    float _e63 = uniforms.strength;
    param_11 = _e63;
    param_12 = 0.5;
    float _e65 = uniforms.progress;
    param_13 = _e65;
    float _e66 = Sinusoidal_easeInOut(param_10, param_11, param_12, param_13);
    strength = _e66;
    color = metal::float4(0.0, 0.0, 0.0, 0.0);
    total = 0.0;
    metal::float2 _e67 = center;
    metal::float2 _e68 = texCoord;
    toCenter = _e67 - _e68;
    metal::float2 _e70 = uv_3;
    param_14 = _e70;
    float _e71 = rand(param_14);
    offset = _e71;
    t = 0.0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            float _e100 = t;
            t = _e100 + 1.0;
        }
        loop_init = false;
        float _e72 = t;
        if (_e72 <= 40.0) {
            float _e74 = t;
            float _e75 = offset;
            percent = (_e74 + _e75) / 40.0;
            float _e78 = percent;
            float _e79 = percent;
            float _e80 = percent;
            weight = 4.0 * (_e78 - (_e79 * _e80));
            metal::float2 _e84 = texCoord;
            metal::float2 _e85 = toCenter;
            float _e86 = percent;
            float _e88 = strength;
            param_15 = _e84 + ((_e85 * _e86) * _e88);
            float _e91 = dissolve_1;
            param_16 = _e91;
            metal::float4 _e92 = crossFade(param_15, param_16, _from, _sampler, _to);
            float _e93 = weight;
            metal::float4 _e95 = color;
            color = _e95 + (_e92 * _e93);
            float _e97 = weight;
            float _e98 = total;
            total = _e98 + _e97;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e102 = color;
    float _e103 = total;
    return _e102 / metal::float4(_e103);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_17 = {};
    metal::float2 _e27 = _uv_1;
    param_17 = _e27;
    metal::float4 _e28 = transition(param_17, _from, _sampler, _to, uniforms);
    _fragColor = _e28;
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
