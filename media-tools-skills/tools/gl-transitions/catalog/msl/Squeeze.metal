// Squeeze — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Squeeze.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is squeezed into a line with color separation, revealing the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float colorSeparation;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e17 = uv[0u];
    float _e19 = uv[1u];
    metal::float4 _e22 = _from.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e17 = uv_1[0u];
    float _e19 = uv_1[1u];
    metal::float4 _e22 = _to.sample(_sampler, metal::float2(_e17, 1.0 - _e19), metal::level(0.0));
    return _e22;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float y = {};
    metal::float2 param = {};
    metal::float2 fp = {};
    metal::float2 off = {};
    metal::float4 c = {};
    metal::float2 param_1 = {};
    metal::float4 cn = {};
    metal::float2 param_2 = {};
    metal::float4 cp = {};
    metal::float2 param_3 = {};
    float _e27 = uv_2[1u];
    float _e30 = uniforms.progress;
    y = 0.5 + ((_e27 - 0.5) / (1.0 - _e30));
    float _e34 = y;
    float _e36 = y;
    if ((_e34 < 0.0) || (_e36 > 1.0)) {
        metal::float2 _e39 = uv_2;
        param = _e39;
        metal::float4 _e40 = getToColor(param, _sampler, _to);
        return _e40;
    } else {
        float _e42 = uv_2[0u];
        float _e43 = y;
        fp = metal::float2(_e42, _e43);
        float _e46 = uniforms.progress;
        float _e48 = uniforms.colorSeparation;
        off = metal::float2(0.0, _e48) * _e46;
        metal::float2 _e51 = fp;
        param_1 = _e51;
        metal::float4 _e52 = getFromColor(param_1, _from, _sampler);
        c = _e52;
        metal::float2 _e53 = fp;
        metal::float2 _e54 = off;
        param_2 = _e53 - _e54;
        metal::float4 _e56 = getFromColor(param_2, _from, _sampler);
        cn = _e56;
        metal::float2 _e57 = fp;
        metal::float2 _e58 = off;
        param_3 = _e57 + _e58;
        metal::float4 _e60 = getFromColor(param_3, _from, _sampler);
        cp = _e60;
        float _e62 = cn[0u];
        float _e64 = c[1u];
        float _e66 = cp[2u];
        float _e68 = c[3u];
        return metal::float4(_e62, _e64, _e66, _e68);
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
