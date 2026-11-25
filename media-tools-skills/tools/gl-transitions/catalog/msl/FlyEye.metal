// FlyEye — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FlyEye.glsl
// Author: gre
// License: MIT
// Description: The image breaks into a fly's-eye grid of lenses with color separation
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float size;
    float zoom;
    float colorSeparation;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float inv = {};
    metal::float2 disp = {};
    metal::float4 texTo = {};
    metal::float2 param = {};
    metal::float4 fromCenter = {};
    metal::float2 param_1 = {};
    metal::float4 texFrom = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float _e27 = uniforms.progress;
    inv = 1.0 - _e27;
    float _e30 = uniforms.size;
    float _e32 = uniforms.zoom;
    float _e34 = p[0u];
    float _e38 = uniforms.zoom;
    float _e40 = p[1u];
    disp = metal::float2(metal::cos(_e32 * _e34), metal::sin(_e38 * _e40)) * _e30;
    metal::float2 _e45 = p;
    float _e46 = inv;
    metal::float2 _e47 = disp;
    param = _e45 + (_e47 * _e46);
    metal::float4 _e50 = getToColor(param, _sampler, _to);
    texTo = _e50;
    metal::float2 _e51 = p;
    float _e53 = uniforms.progress;
    metal::float2 _e54 = disp;
    param_1 = _e51 + (_e54 * _e53);
    metal::float4 _e57 = getFromColor(param_1, _from, _sampler);
    fromCenter = _e57;
    metal::float2 _e58 = p;
    float _e60 = uniforms.progress;
    metal::float2 _e61 = disp;
    float _e64 = uniforms.colorSeparation;
    param_2 = _e58 + ((_e61 * _e60) * (1.0 - _e64));
    metal::float4 _e68 = getFromColor(param_2, _from, _sampler);
    float _e71 = fromCenter[1u];
    metal::float2 _e72 = p;
    float _e74 = uniforms.progress;
    metal::float2 _e75 = disp;
    float _e78 = uniforms.colorSeparation;
    param_3 = _e72 + ((_e75 * _e74) * (1.0 + _e78));
    metal::float4 _e82 = getFromColor(param_3, _from, _sampler);
    float _e85 = fromCenter[3u];
    texFrom = metal::float4(_e68.x, _e71, _e82.z, _e85);
    metal::float4 _e87 = texTo;
    float _e89 = uniforms.progress;
    metal::float4 _e91 = texFrom;
    float _e92 = inv;
    return (_e87 * _e89) + (_e91 * _e92);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_4 = {};
    metal::float2 _e17 = _uv_1;
    param_4 = _e17;
    metal::float4 _e18 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e18;
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
