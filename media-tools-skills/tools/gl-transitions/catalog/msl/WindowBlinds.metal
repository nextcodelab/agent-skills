// WindowBlinds — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WindowBlinds.glsl
// Author: Fabien Benetou
// License: MIT
// Description: A crossfade through horizontal window blinds
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
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
    float t = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e20 = uniforms.progress;
    t = _e20;
    float _e22 = uv_2[1u];
    float _e25 = uniforms.progress;
    float _e27 = metal::floor((_e22 * 100.0) * _e25);
    if ((_e27 - (metal::floor(_e27 / 2.0) * 2.0)) == 0.0) {
        float _e33 = t;
        t = _e33 * 1.5;
    }
    metal::float2 _e35 = uv_2;
    param = _e35;
    metal::float4 _e36 = getFromColor(param, _from, _sampler);
    metal::float2 _e37 = uv_2;
    param_1 = _e37;
    metal::float4 _e38 = getToColor(param_1, _sampler, _to);
    float _e39 = t;
    float _e41 = uniforms.progress;
    float _e43 = uniforms.progress;
    return metal::mix(_e36, _e38, metal::float4(metal::mix(_e39, _e41, metal::smoothstep(0.8, 1.0, _e43))));
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
