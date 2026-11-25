// Overexposure — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Overexposure.glsl
// Author: Ben Zhang
// License: MIT
// Description: A crossfade through a washed-out, overexposed white
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
    metal::float4 from = {};
    metal::float2 param = {};
    metal::float4 to = {};
    metal::float2 param_1 = {};
    float from_m = {};
    float to_m = {};
    metal::float2 _e22 = uv_2;
    param = _e22;
    metal::float4 _e23 = getFromColor(param, _from, _sampler);
    from = _e23;
    metal::float2 _e24 = uv_2;
    param_1 = _e24;
    metal::float4 _e25 = getToColor(param_1, _sampler, _to);
    to = _e25;
    float _e27 = uniforms.progress;
    float _e30 = uniforms.progress;
    float _e34 = uniforms.strength;
    from_m = (1.0 - _e27) + (metal::sin(3.1415927 * _e30) * _e34);
    float _e38 = uniforms.progress;
    float _e40 = uniforms.progress;
    float _e44 = uniforms.strength;
    to_m = _e38 + (metal::sin(3.1415927 * _e40) * _e44);
    float _e48 = from[0u];
    float _e50 = from[3u];
    float _e52 = from_m;
    float _e55 = to[0u];
    float _e57 = to[3u];
    float _e59 = to_m;
    float _e63 = from[1u];
    float _e65 = from[3u];
    float _e67 = from_m;
    float _e70 = to[1u];
    float _e72 = to[3u];
    float _e74 = to_m;
    float _e78 = from[2u];
    float _e80 = from[3u];
    float _e82 = from_m;
    float _e85 = to[2u];
    float _e87 = to[3u];
    float _e89 = to_m;
    float _e93 = from[3u];
    float _e95 = to[3u];
    float _e97 = uniforms.progress;
    return metal::float4(((_e48 * _e50) * _e52) + ((_e55 * _e57) * _e59), ((_e63 * _e65) * _e67) + ((_e70 * _e72) * _e74), ((_e78 * _e80) * _e82) + ((_e85 * _e87) * _e89), metal::mix(_e93, _e95, _e97));
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
