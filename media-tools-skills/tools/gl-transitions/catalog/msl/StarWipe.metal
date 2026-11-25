// StarWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StarWipe.glsl
// Author: Ben Lucas
// License: MIT
// Description: A growing star reveals the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float border_thickness;
    float star_rotation;
    metal::float4 border_color;
    metal::float2 star_center;
    char _pad6[8];
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e23 = uv[0u];
    float _e25 = uv[1u];
    metal::float4 _e28 = _from.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e23 = uv_1[0u];
    float _e25 = uv_1[1u];
    metal::float4 _e28 = _to.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

metal::float2 rotate(
    thread metal::float2& v,
    thread float& theta
) {
    float cosTheta = {};
    float sinTheta = {};
    float _e25 = theta;
    cosTheta = metal::cos(_e25);
    float _e27 = theta;
    sinTheta = metal::sin(_e27);
    float _e29 = cosTheta;
    float _e31 = v[0u];
    float _e33 = sinTheta;
    float _e35 = v[1u];
    float _e38 = sinTheta;
    float _e40 = v[0u];
    float _e42 = cosTheta;
    float _e44 = v[1u];
    return metal::float2((_e29 * _e31) - (_e33 * _e35), (_e38 * _e40) + (_e42 * _e44));
}

bool inStar(
    thread metal::float2& uv_2,
    thread metal::float2& center,
    thread float& radius,
    constant Uniforms& uniforms
) {
    metal::float2 uv_centered = {};
    metal::float2 param = {};
    float param_1 = {};
    float theta_1 = {};
    metal::float2 uv_rotated = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    float slope = {};
    metal::float2 _e32 = uv_2;
    metal::float2 _e33 = center;
    uv_centered = _e32 - _e33;
    float _e36 = uniforms.star_rotation;
    metal::float2 _e38 = uv_centered;
    param = _e38;
    param_1 = _e36 * 1.2566371;
    metal::float2 _e39 = rotate(param, param_1);
    uv_centered = _e39;
    float _e41 = uv_centered[1u];
    float _e43 = uv_centered[0u];
    theta_1 = metal::atan2(_e41, _e43) + 3.1415927;
    float _e46 = theta_1;
    metal::float2 _e51 = uv_centered;
    param_2 = _e51;
    param_3 = -1.2566371 * (metal::floor(_e46 / 1.2566371) + 0.5);
    metal::float2 _e52 = rotate(param_2, param_3);
    uv_rotated = _e52;
    slope = 0.3;
    float _e54 = uv_rotated[1u];
    if (_e54 > 0.0) {
        float _e56 = radius;
        float _e58 = uv_rotated[0u];
        float _e59 = slope;
        float _e63 = uv_rotated[1u];
        return (_e56 + (_e58 * _e59)) > _e63;
    } else {
        float _e65 = radius;
        float _e68 = uv_rotated[0u];
        float _e69 = slope;
        float _e73 = uv_rotated[1u];
        return (-(_e65) - (_e68 * _e69)) < _e73;
    }
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float progressScaled = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    metal::float2 param_11 = {};
    float _e32 = uniforms.border_thickness;
    float _e36 = uniforms.progress;
    float _e39 = uniforms.border_thickness;
    progressScaled = (((2.0 * _e32) + 1.0) * _e36) - _e39;
    metal::float2 _e41 = uv_3;
    param_4 = _e41;
    metal::float2 _e43 = uniforms.star_center;
    param_5 = _e43;
    float _e44 = progressScaled;
    param_6 = _e44;
    bool _e45 = inStar(param_4, param_5, param_6, uniforms);
    if (_e45) {
        metal::float2 _e46 = uv_3;
        param_7 = _e46;
        metal::float4 _e47 = getToColor(param_7, _sampler, _to);
        return _e47;
    } else {
        float _e48 = progressScaled;
        float _e50 = uniforms.border_thickness;
        metal::float2 _e52 = uv_3;
        param_8 = _e52;
        metal::float2 _e54 = uniforms.star_center;
        param_9 = _e54;
        param_10 = _e48 + _e50;
        bool _e55 = inStar(param_8, param_9, param_10, uniforms);
        if (_e55) {
            metal::float4 _e57 = uniforms.border_color;
            return _e57;
        } else {
            metal::float2 _e58 = uv_3;
            param_11 = _e58;
            metal::float4 _e59 = getFromColor(param_11, _from, _sampler);
            return _e59;
        }
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
    metal::float2 param_12 = {};
    metal::float2 _e22 = _uv_1;
    param_12 = _e22;
    metal::float4 _e23 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e23;
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
