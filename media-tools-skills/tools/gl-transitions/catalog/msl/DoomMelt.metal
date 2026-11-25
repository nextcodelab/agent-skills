// DoomMelt — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DoomMelt.glsl
// Author: Zeh Fernando
// License: MIT
// Description: The outgoing image melts down in uneven columns, like the Doom screen wipe
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int bars;
    float amplitude;
    float noise;
    float frequency;
    float dripScale;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e30 = uv[0u];
    float _e32 = uv[1u];
    metal::float4 _e35 = _to.sample(_sampler, metal::float2(_e30, 1.0 - _e32), metal::level(0.0));
    return _e35;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e30 = uv_1[0u];
    float _e32 = uv_1[1u];
    metal::float4 _e35 = _from.sample(_sampler, metal::float2(_e30, 1.0 - _e32), metal::level(0.0));
    return _e35;
}

float drip(
    thread int& num,
    constant Uniforms& uniforms
) {
    int _e29 = num;
    int _e32 = uniforms.bars;
    float _e39 = uniforms.dripScale;
    return metal::sin((static_cast<float>(_e29) / static_cast<float>(as_type<int>(as_type<uint>(_e32) - as_type<uint>(1)))) * 3.141592) * _e39;
}

float rand(
    thread int& num_1
) {
    int _e29 = num_1;
    float _e31 = static_cast<float>(_e29) * 67123.31;
    int _e36 = num_1;
    int _e41 = num_1;
    return metal::fract(((_e31 - (metal::floor(_e31 / 12.0) * 12.0)) * metal::sin(static_cast<float>(_e36) * 10.3)) * metal::cos(static_cast<float>(_e41)));
}

float wave(
    thread int& num_2,
    constant Uniforms& uniforms
) {
    float fn = {};
    int _e30 = num_2;
    float _e33 = uniforms.frequency;
    int _e37 = uniforms.bars;
    fn = ((static_cast<float>(_e30) * _e33) * 0.1) * static_cast<float>(_e37);
    float _e40 = fn;
    float _e43 = fn;
    float _e47 = fn;
    return (((metal::cos(_e40 * 0.5) * metal::cos(_e43 * 0.13)) * metal::sin((_e47 + 10.0) * 0.3)) / 2.0) + 0.5;
}

float pos(
    thread int& num_3,
    constant Uniforms& uniforms
) {
    float local = {};
    int param = {};
    int param_1 = {};
    int param_2 = {};
    float local_1 = {};
    int param_3 = {};
    float _e36 = uniforms.noise;
    if (_e36 == 0.0) {
        int _e38 = num_3;
        param = _e38;
        float _e39 = wave(param, uniforms);
        local = _e39;
    } else {
        int _e40 = num_3;
        param_1 = _e40;
        float _e41 = wave(param_1, uniforms);
        int _e42 = num_3;
        param_2 = _e42;
        float _e43 = rand(param_2);
        float _e45 = uniforms.noise;
        local = metal::mix(_e41, _e43, _e45);
    }
    float _e47 = local;
    float _e49 = uniforms.dripScale;
    if (_e49 == 0.0) {
        local_1 = 0.0;
    } else {
        int _e51 = num_3;
        param_3 = _e51;
        float _e52 = drip(param_3, uniforms);
        local_1 = _e52;
    }
    float _e53 = local_1;
    return _e47 + _e53;
}

int naga_f2i32(float value) {
    return static_cast<int>(metal::clamp(value, -2147483600.0, 2147483500.0));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    int bar = {};
    float scale = {};
    int param_4 = {};
    float phase = {};
    float posY = {};
    metal::float2 p = {};
    metal::float4 c = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float _e39 = uv_2[0u];
    int _e41 = uniforms.bars;
    bar = naga_f2i32(_e39 * static_cast<float>(_e41));
    int _e45 = bar;
    param_4 = _e45;
    float _e46 = pos(param_4, uniforms);
    float _e48 = uniforms.amplitude;
    scale = 1.0 + (_e46 * _e48);
    float _e52 = uniforms.progress;
    float _e53 = scale;
    phase = _e52 * _e53;
    float _e56 = uv_2[1u];
    posY = _e56 / 1.0;
    float _e58 = phase;
    float _e59 = posY;
    if ((_e58 + _e59) < 1.0) {
        float _e63 = uv_2[0u];
        float _e65 = uv_2[1u];
        float _e66 = phase;
        p = metal::float2(_e63, _e65 + metal::mix(0.0, 1.0, _e66)) / metal::float2(1.0, 1.0);
        metal::float2 _e71 = p;
        param_5 = _e71;
        metal::float4 _e72 = getFromColor(param_5, _from, _sampler);
        c = _e72;
    } else {
        metal::float2 _e73 = uv_2;
        p = _e73 / metal::float2(1.0, 1.0);
        metal::float2 _e75 = p;
        param_6 = _e75;
        metal::float4 _e76 = getToColor(param_6, _sampler, _to);
        c = _e76;
    }
    metal::float4 _e77 = c;
    return _e77;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_7 = {};
    metal::float2 _e29 = _uv_1;
    param_7 = _e29;
    metal::float4 _e30 = transition(param_7, _from, _sampler, _to, uniforms);
    _fragColor = _e30;
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
