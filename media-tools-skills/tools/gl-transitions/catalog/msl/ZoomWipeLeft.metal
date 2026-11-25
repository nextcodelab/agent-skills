// ZoomWipeLeft — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ZoomWipeLeft.glsl
// Author: Handk
// License: MIT
// Description: Zooms into the outgoing image, then the incoming one wipes in from right to left
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float zoom_quickness;
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

metal::float2 zoom(
    thread metal::float2& uv_2,
    thread float& amount
) {
    float _e17 = amount;
    if (_e17 < 0.5) {
        metal::float2 _e19 = uv_2;
        float _e22 = amount;
        return metal::float2(0.5) + ((_e19 - metal::float2(0.5)) * (1.0 - _e22));
    } else {
        metal::float2 _e27 = uv_2;
        float _e30 = amount;
        return metal::float2(0.5) + ((_e27 - metal::float2(0.5)) * _e30);
    }
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float nQuick = {};
    metal::float4 c = {};
    metal::float2 param = {};
    float param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 p = {};
    metal::float4 d = {};
    metal::float2 param_4 = {};
    metal::float4 e = {};
    metal::float2 param_5 = {};
    metal::float4 f = {};
    float _e29 = uniforms.zoom_quickness;
    nQuick = metal::clamp(_e29, 0.0, 0.5);
    float _e32 = uniforms.progress;
    if (_e32 < 0.5) {
        float _e34 = nQuick;
        float _e36 = uniforms.progress;
        metal::float2 _e38 = uv_3;
        param = _e38;
        param_1 = metal::smoothstep(0.0, _e34, _e36);
        metal::float2 _e39 = zoom(param, param_1);
        param_2 = _e39;
        metal::float4 _e40 = getFromColor(param_2, _from, _sampler);
        metal::float2 _e41 = uv_3;
        param_3 = _e41;
        metal::float4 _e42 = getToColor(param_3, _sampler, _to);
        float _e44 = uniforms.progress;
        c = metal::mix(_e40, _e42, metal::float4(metal::step(0.5, _e44)));
        metal::float4 _e48 = c;
        return _e48;
    } else {
        metal::float2 _e49 = uv_3;
        p = _e49 / metal::float2(1.0, 1.0);
        metal::float2 _e51 = p;
        param_4 = _e51;
        metal::float4 _e52 = getFromColor(param_4, _from, _sampler);
        d = _e52;
        metal::float2 _e53 = p;
        param_5 = _e53;
        metal::float4 _e54 = getToColor(param_5, _sampler, _to);
        e = _e54;
        metal::float4 _e55 = d;
        metal::float4 _e56 = e;
        float _e58 = p[0u];
        float _e61 = uniforms.progress;
        f = metal::mix(_e55, _e56, metal::float4(metal::step(1.0 - _e58, (_e61 - 0.5) * 2.0)));
        metal::float4 _e67 = f;
        return _e67;
    }
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_6 = {};
    metal::float2 _e16 = _uv_1;
    param_6 = _e16;
    metal::float4 _e17 = transition(param_6, _from, _sampler, _to, uniforms);
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
