// Pixelize — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Pixelize.glsl
// Author: gre
// License: MIT
// Description: Both images pixelate, crossfade, then sharpen again
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 squaresMin;
    int steps;
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
    float d = {};
    float dist = {};
    float local = {};
    metal::float2 squareSize = {};
    metal::float2 p = {};
    metal::float2 local_1 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e25 = uniforms.progress;
    float _e27 = uniforms.progress;
    d = metal::min(_e25, 1.0 - _e27);
    int _e31 = uniforms.steps;
    if (_e31 > 0) {
        float _e33 = d;
        int _e35 = uniforms.steps;
        int _e40 = uniforms.steps;
        local = metal::ceil(_e33 * static_cast<float>(_e35)) / static_cast<float>(_e40);
    } else {
        float _e43 = d;
        local = _e43;
    }
    float _e44 = local;
    dist = _e44;
    float _e45 = dist;
    metal::int2 _e48 = uniforms.squaresMin;
    squareSize = metal::float2(2.0 * _e45) / static_cast<metal::float2>(_e48);
    float _e52 = dist;
    if (_e52 > 0.0) {
        metal::float2 _e54 = uv_2;
        metal::float2 _e55 = squareSize;
        metal::float2 _e60 = squareSize;
        local_1 = (metal::floor(_e54 / _e55) + metal::float2(0.5)) * _e60;
    } else {
        metal::float2 _e62 = uv_2;
        local_1 = _e62;
    }
    metal::float2 _e63 = local_1;
    p = _e63;
    metal::float2 _e64 = p;
    param = _e64;
    metal::float4 _e65 = getFromColor(param, _from, _sampler);
    metal::float2 _e66 = p;
    param_1 = _e66;
    metal::float4 _e67 = getToColor(param_1, _sampler, _to);
    float _e69 = uniforms.progress;
    return metal::mix(_e65, _e67, metal::float4(_e69));
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
