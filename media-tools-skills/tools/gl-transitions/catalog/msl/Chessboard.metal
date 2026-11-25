// Chessboard — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Chessboard.glsl
// Author: lql
// License: MIT
// Description: A chessboard pattern of squares reveals the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float grid_num;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e16 = uv[0u];
    float _e18 = uv[1u];
    metal::float4 _e21 = _to.sample(_sampler, metal::float2(_e16, 1.0 - _e18), metal::level(0.0));
    return _e21;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e16 = uv_1[0u];
    float _e18 = uv_1[1u];
    metal::float4 _e21 = _from.sample(_sampler, metal::float2(_e16, 1.0 - _e18), metal::level(0.0));
    return _e21;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 st = {};
    metal::float2 idx = {};
    metal::float2 grid = {};
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    float checker = {};
    float mixFactor = {};
    float local = {};
    float local_1 = {};
    metal::float2 _e26 = uv_2;
    float _e28 = uniforms.grid_num;
    st = _e26 * _e28;
    metal::float2 _e30 = st;
    idx = metal::floor(_e30);
    metal::float2 _e32 = st;
    grid = metal::fract(_e32);
    metal::float2 _e34 = uv_2;
    param = _e34;
    metal::float4 _e35 = getFromColor(param, _from, _sampler);
    a = _e35;
    metal::float2 _e36 = uv_2;
    param_1 = _e36;
    metal::float4 _e37 = getToColor(param_1, _sampler, _to);
    b = _e37;
    float _e39 = idx[0u];
    float _e41 = idx[1u];
    float _e42 = _e39 + _e41;
    checker = _e42 - (metal::floor(_e42 / 2.0) * 2.0);
    float _e48 = uniforms.progress;
    if (_e48 <= 0.5) {
        float _e50 = checker;
        if (_e50 > 0.5) {
            float _e53 = grid[0u];
            float _e55 = uniforms.progress;
            local = metal::step(_e53, _e55 * 2.0);
        } else {
            local = 0.0;
        }
        float _e58 = local;
        mixFactor = _e58;
    } else {
        float _e59 = checker;
        if (_e59 < 0.5) {
            float _e62 = grid[0u];
            float _e64 = uniforms.progress;
            local_1 = metal::step(_e62, (_e64 - 0.5) * 2.0);
        } else {
            local_1 = 1.0;
        }
        float _e68 = local_1;
        mixFactor = _e68;
    }
    metal::float4 _e69 = a;
    metal::float4 _e70 = b;
    float _e71 = mixFactor;
    return metal::mix(_e69, _e70, metal::float4(_e71));
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
    metal::float2 _e15 = _uv_1;
    param_2 = _e15;
    metal::float4 _e16 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e16;
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
