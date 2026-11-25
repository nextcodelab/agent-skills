// SimpleZoomOut — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SimpleZoomOut.glsl
// Author: Tianshuo
// License: MIT
// Description: The incoming image zooms out into place while fading in
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float zoom_quickness;
    int fade;
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

metal::float2 zoom(
    thread metal::float2& uv_1,
    thread float& amount
) {
    metal::float2 _e17 = uv_1;
    float _e20 = amount;
    return metal::float2(0.5) + ((_e17 - metal::float2(0.5)) * (1.0 - _e20));
}

metal::float4 getFromColor(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e17 = uv_2[0u];
    float _e19 = uv_2[1u];
    metal::float4 _e22 = _from.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float nQuick = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    metal::float2 param_3 = {};
    float local = {};
    float _e23 = uniforms.zoom_quickness;
    nQuick = metal::clamp(_e23, 0.2, 1.0);
    metal::float2 _e25 = uv_3;
    param = _e25;
    metal::float4 _e26 = getFromColor(param, _from, _sampler);
    float _e27 = nQuick;
    float _e30 = uniforms.progress;
    metal::float2 _e33 = uv_3;
    param_1 = _e33;
    param_2 = 1.0 - metal::smoothstep(1.0 - _e27, 1.0, _e30);
    metal::float2 _e34 = zoom(param_1, param_2);
    param_3 = _e34;
    metal::float4 _e35 = getToColor(param_3, _sampler, _to);
    int _e37 = uniforms.fade;
    if (_e37 != 0) {
        float _e39 = nQuick;
        float _e42 = uniforms.progress;
        local = metal::smoothstep(1.0 - _e39, 1.0, _e42);
    } else {
        float _e45 = uniforms.progress;
        float _e46 = nQuick;
        local = (_e45 < (1.0 - _e46)) ? 0.0 : 1.0;
    }
    float _e50 = local;
    return metal::mix(_e26, _e35, metal::float4(_e50));
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
    metal::float2 _e16 = _uv_1;
    param_4 = _e16;
    metal::float4 _e17 = transition(param_4, _from, _sampler, _to, uniforms);
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
