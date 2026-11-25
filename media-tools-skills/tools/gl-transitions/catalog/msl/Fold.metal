// Fold — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Fold.glsl
// Author: nwoeanhinnogaehr
// License: MIT
// Description: The incoming image unfolds from the left while the outgoing one folds away to the right
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
    float _e13 = uv[0u];
    float _e15 = uv[1u];
    metal::float4 _e18 = _to.sample(_sampler, metal::float2(_e13, 1.0 - _e15), metal::level(0.0));
    return _e18;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e13 = uv_1[0u];
    float _e15 = uv_1[1u];
    metal::float4 _e18 = _from.sample(_sampler, metal::float2(_e13, 1.0 - _e15), metal::level(0.0));
    return _e18;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool phi_76_ = {};
    float _e15 = uniforms.progress;
    bool _e16 = _e15 == 0.0;
    phi_76_ = _e16;
    if (!(_e16)) {
        float _e19 = uv_2[0u];
        float _e21 = uniforms.progress;
        phi_76_ = _e19 > _e21;
    }
    bool _e24 = phi_76_;
    if (_e24) {
        metal::float2 _e25 = uv_2;
        float _e27 = uniforms.progress;
        float _e31 = uniforms.progress;
        param = (_e25 - metal::float2(_e27, 0.0)) / metal::float2(1.0 - _e31, 1.0);
        metal::float4 _e35 = getFromColor(param, _from, _sampler);
        return _e35;
    }
    metal::float2 _e36 = uv_2;
    float _e38 = uniforms.progress;
    param_1 = _e36 / metal::float2(_e38, 1.0);
    metal::float4 _e41 = getToColor(param_1, _sampler, _to);
    return _e41;
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
    metal::float2 _e12 = _uv_1;
    param_2 = _e12;
    metal::float4 _e13 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e13;
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
