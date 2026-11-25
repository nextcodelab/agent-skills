// DitherDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DitherDissolve.glsl
// Author: gre
// License: MIT
// Description: The incoming image appears through a regular 8x8 ordered dither pattern, like a retro computer screen
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float dotSize;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e21 = uv[0u];
    float _e23 = uv[1u];
    metal::float4 _e26 = _to.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e21 = uv_1[0u];
    float _e23 = uv_1[1u];
    metal::float4 _e26 = _from.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

float bayer(
    thread metal::float2& c
) {
    float v = {};
    float scale = {};
    int i = {};
    metal::float2 bit = {};
    v = 0.0;
    scale = 16.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e51 = i;
            i = as_type<int>(as_type<uint>(_e51) + as_type<uint>(1));
        }
        loop_init = false;
        int _e24 = i;
        if (_e24 < 3) {
            metal::float2 _e26 = c;
            metal::float2 _e27 = metal::floor(_e26);
            metal::float2 _e28 = metal::float2(2.0);
            bit = _e27 - (metal::floor(_e27 / _e28) * _e28);
            float _e33 = scale;
            float _e35 = bit[0u];
            float _e37 = bit[1u];
            float _e42 = bit[1u];
            float _e45 = v;
            v = _e45 + (_e33 * ((2.0 * metal::abs(_e35 - _e37)) + _e42));
            metal::float2 _e47 = c;
            c = _e47 * 0.5;
            float _e49 = scale;
            scale = _e49 * 0.25;
            continue;
        } else {
            break;
        }
    }
    float _e53 = v;
    return (_e53 + 0.5) / 64.0;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 cell = {};
    metal::float2 param = {};
    metal::float4 local = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 _e25 = uv_2;
    float _e27 = uniforms.ratio;
    float _e31 = uniforms.dotSize;
    cell = metal::floor((_e25 * metal::float2(_e27, 1.0)) / metal::float2(_e31));
    float _e36 = uniforms.progress;
    metal::float2 _e37 = cell;
    param = _e37;
    float _e38 = bayer(param);
    if (_e36 < _e38) {
        metal::float2 _e40 = uv_2;
        param_1 = _e40;
        metal::float4 _e41 = getFromColor(param_1, _from, _sampler);
        local = _e41;
    } else {
        metal::float2 _e42 = uv_2;
        param_2 = _e42;
        metal::float4 _e43 = getToColor(param_2, _sampler, _to);
        local = _e43;
    }
    metal::float4 _e44 = local;
    return _e44;
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
    metal::float2 _e20 = _uv_1;
    param_3 = _e20;
    metal::float4 _e21 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e21;
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
