// GlitchBands — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchBands.glsl
// Author: Yoni Maltsman @friendlyspinach
// License: MIT
// Description: A crossfade with glitchy horizontal bands and color shifts
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float ampx;
    float ampy;
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
    float r = {};
    float g = {};
    float b = {};
    float sphere = {};
    float spiralX = {};
    float spiralY = {};
    metal::float2 st = {};
    metal::float2 diff = {};
    metal::float2 param_2 = {};
    metal::float2 _e29 = uv_2;
    param = _e29;
    metal::float4 _e30 = getFromColor(param, _from, _sampler);
    from = _e30;
    metal::float2 _e31 = uv_2;
    param_1 = _e31;
    metal::float4 _e32 = getToColor(param_1, _sampler, _to);
    to = _e32;
    float _e34 = from[0u];
    r = _e34;
    float _e36 = from[1u];
    g = _e36;
    float _e38 = from[2u];
    b = _e38;
    float _e39 = r;
    float _e40 = r;
    float _e42 = g;
    float _e43 = g;
    float _e46 = b;
    float _e47 = b;
    sphere = (((_e39 * _e40) + (_e42 * _e43)) + (_e46 * _e47)) - 1.0;
    float _e51 = sphere;
    float _e53 = uv_2[0u];
    float _e55 = uniforms.progress;
    spiralX = metal::cos(_e51 - (_e53 / (_e55 + 0.01)));
    float _e60 = sphere;
    float _e62 = uv_2[1u];
    float _e64 = uniforms.progress;
    spiralY = metal::sin(_e60 - (_e62 / (_e64 + 0.01)));
    metal::float2 _e69 = uv_2;
    st = _e69;
    float _e71 = uniforms.ampx;
    float _e73 = st[0u];
    float _e75 = spiralX;
    st[0u] = metal::fract((_e71 * _e73) * _e75);
    float _e80 = uniforms.ampy;
    float _e82 = st[1u];
    float _e84 = spiralY;
    st[1u] = metal::fract((_e80 * _e82) * _e84);
    metal::float2 _e88 = uv_2;
    metal::float2 _e89 = st;
    diff = _e88 - _e89;
    metal::float2 _e91 = uv_2;
    float _e93 = uniforms.progress;
    metal::float2 _e94 = diff;
    param_2 = _e91 + (_e94 * _e93);
    metal::float4 _e97 = getFromColor(param_2, _from, _sampler);
    from = _e97;
    metal::float4 _e98 = from;
    metal::float4 _e99 = to;
    float _e101 = uniforms.progress;
    return metal::mix(_e98, _e99, metal::float4(_e101));
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
    metal::float2 _e16 = _uv_1;
    param_3 = _e16;
    metal::float4 _e17 = transition(param_3, _from, _sampler, _to, uniforms);
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
