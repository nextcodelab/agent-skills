// FallOver — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FallOver.glsl
// Author: gre
// License: MIT
// Description: The outgoing image falls over backward, hinged on its bottom edge, revealing the incoming one behind it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float perspective;
    float shading;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e24 = uv[0u];
    float _e26 = uv[1u];
    metal::float4 _e29 = _to.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e24 = uv_1[0u];
    float _e26 = uv_1[1u];
    metal::float4 _e29 = _from.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float fall = {};
    float angle = {};
    float c = {};
    float s = {};
    float dist = {};
    metal::float3 eye = {};
    metal::float3 dir = {};
    float den = {};
    float t = {};
    metal::float3 hit = {};
    metal::float2 puv = {};
    metal::float4 col = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool phi_172_ = {};
    bool phi_178_ = {};
    bool phi_184_ = {};
    bool phi_190_ = {};
    float _e38 = uniforms.progress;
    float _e40 = uniforms.progress;
    fall = _e38 * (0.25 + (0.75 * _e40));
    float _e44 = fall;
    angle = 1.5707964 * _e44;
    float _e46 = angle;
    c = metal::cos(_e46);
    float _e48 = angle;
    s = metal::sin(_e48);
    float _e51 = uniforms.perspective;
    dist = 1.0 / metal::max(_e51, 0.01);
    float _e55 = uniforms.ratio;
    float _e57 = c;
    float _e59 = dist;
    eye = metal::float3(0.5 * _e55, 0.5 * _e57, -(_e59));
    float _e63 = uv_2[0u];
    float _e65 = uniforms.ratio;
    float _e68 = uv_2[1u];
    metal::float3 _e70 = eye;
    dir = metal::float3(_e63 * _e65, _e68, 0.0) - _e70;
    float _e73 = dir[2u];
    float _e74 = c;
    float _e77 = dir[1u];
    float _e78 = s;
    den = (_e73 * _e74) - (_e77 * _e78);
    float _e81 = den;
    if (_e81 > 0.0) {
        float _e84 = eye[1u];
        float _e85 = s;
        float _e88 = eye[2u];
        float _e89 = c;
        float _e92 = den;
        t = ((_e84 * _e85) - (_e88 * _e89)) / _e92;
        metal::float3 _e94 = eye;
        float _e95 = t;
        metal::float3 _e96 = dir;
        hit = _e94 + (_e96 * _e95);
        float _e100 = hit[0u];
        float _e102 = uniforms.ratio;
        float _e105 = hit[1u];
        float _e106 = c;
        float _e109 = hit[2u];
        float _e110 = s;
        puv = metal::float2(_e100 / _e102, (_e105 * _e106) + (_e109 * _e110));
        float _e114 = t;
        bool _e115 = _e114 > 0.0;
        phi_172_ = _e115;
        if (_e115) {
            float _e117 = puv[1u];
            phi_172_ = _e117 > 0.0;
        }
        bool _e120 = phi_172_;
        phi_178_ = _e120;
        if (_e120) {
            float _e122 = puv[1u];
            phi_178_ = _e122 <= 1.0;
        }
        bool _e125 = phi_178_;
        phi_184_ = _e125;
        if (_e125) {
            float _e127 = puv[0u];
            phi_184_ = _e127 >= 0.0;
        }
        bool _e130 = phi_184_;
        phi_190_ = _e130;
        if (_e130) {
            float _e132 = puv[0u];
            phi_190_ = _e132 <= 1.0;
        }
        bool _e135 = phi_190_;
        if (_e135) {
            metal::float2 _e136 = puv;
            param = _e136;
            metal::float4 _e137 = getFromColor(param, _from, _sampler);
            col = _e137;
            metal::float4 _e138 = col;
            float _e141 = uniforms.shading;
            float _e142 = s;
            metal::float3 _e145 = _e138.xyz * (1.0 - (_e141 * _e142));
            float _e147 = col[3u];
            return metal::float4(_e145.x, _e145.y, _e145.z, _e147);
        }
    }
    metal::float2 _e152 = uv_2;
    param_1 = _e152;
    metal::float4 _e153 = getToColor(param_1, _sampler, _to);
    return _e153;
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
    metal::float2 _e23 = _uv_1;
    param_2 = _e23;
    metal::float4 _e24 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e24;
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
