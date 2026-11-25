// PolkaDotsCurtain — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PolkaDotsCurtain.glsl
// Author: bobylito
// License: MIT
// Description: The incoming image appears through growing polka dots
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float dots;
    char _pad3[4];
    metal::float2 center;
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
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    bool nextImage = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e21 = uv_2;
    float _e23 = uniforms.dots;
    float _e28 = uniforms.progress;
    metal::float2 _e29 = uv_2;
    metal::float2 _e31 = uniforms.center;
    nextImage = metal::distance(metal::fract(_e21 * _e23), metal::float2(0.5, 0.5)) < (_e28 / metal::distance(_e29, _e31));
    bool _e35 = nextImage;
    if (_e35) {
        metal::float2 _e36 = uv_2;
        param = _e36;
        metal::float4 _e37 = getToColor(param, _sampler, _to);
        local = _e37;
    } else {
        metal::float2 _e38 = uv_2;
        param_1 = _e38;
        metal::float4 _e39 = getFromColor(param_1, _from, _sampler);
        local = _e39;
    }
    metal::float4 _e40 = local;
    return _e40;
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
    metal::float2 _e17 = _uv_1;
    param_2 = _e17;
    metal::float4 _e18 = transition(param_2, _from, _sampler, _to, uniforms);
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
