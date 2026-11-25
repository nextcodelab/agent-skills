// RotateScaleVanish — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RotateScaleVanish.glsl
// Author: Mark Craig
// License: MIT
// Description: The outgoing image spins and shrinks away over the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int FadeInSecond;
    int ReverseEffect;
    int ReverseRotation;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e23 = uv[0u];
    float _e25 = uv[1u];
    metal::float4 _e28 = _to.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e23 = uv_1[0u];
    float _e25 = uv_1[1u];
    metal::float4 _e28 = _from.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 iResolution = {};
    float t = {};
    float local = {};
    float theta = {};
    float local_1 = {};
    float c1_ = {};
    float s1_ = {};
    float rad = {};
    float xc1_ = {};
    float yc1_ = {};
    float xc2_ = {};
    float yc2_ = {};
    metal::float2 uv2_ = {};
    metal::float4 ColorTo = {};
    metal::float4 local_2 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 col3_ = {};
    metal::float4 local_3 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    bool phi_187_ = {};
    bool phi_193_ = {};
    bool phi_201_ = {};
    float _e44 = uniforms.ratio;
    iResolution = metal::float2(_e44, 1.0);
    int _e47 = uniforms.ReverseEffect;
    if (_e47 != 0) {
        float _e50 = uniforms.progress;
        local = 1.0 - _e50;
    } else {
        float _e53 = uniforms.progress;
        local = _e53;
    }
    float _e54 = local;
    t = _e54;
    int _e56 = uniforms.ReverseRotation;
    if (_e56 != 0) {
        float _e58 = t;
        local_1 = 6.2831855 * _e58;
    } else {
        float _e60 = t;
        local_1 = -6.2831855 * _e60;
    }
    float _e62 = local_1;
    theta = _e62;
    float _e63 = theta;
    c1_ = metal::cos(_e63);
    float _e65 = theta;
    s1_ = metal::sin(_e65);
    float _e67 = t;
    rad = metal::max(0.00001, 1.0 - _e67);
    float _e71 = uv_2[0u];
    float _e74 = iResolution[0u];
    xc1_ = (_e71 - 0.5) * _e74;
    float _e77 = uv_2[1u];
    float _e80 = iResolution[1u];
    yc1_ = (_e77 - 0.5) * _e80;
    float _e82 = xc1_;
    float _e83 = c1_;
    float _e85 = yc1_;
    float _e86 = s1_;
    float _e89 = rad;
    xc2_ = ((_e82 * _e83) - (_e85 * _e86)) / _e89;
    float _e91 = xc1_;
    float _e92 = s1_;
    float _e94 = yc1_;
    float _e95 = c1_;
    float _e98 = rad;
    yc2_ = ((_e91 * _e92) + (_e94 * _e95)) / _e98;
    float _e100 = xc2_;
    float _e102 = iResolution[0u];
    float _e105 = yc2_;
    float _e107 = iResolution[1u];
    uv2_ = metal::float2(_e100 + (_e102 / 2.0), _e105 + (_e107 / 2.0));
    int _e112 = uniforms.ReverseEffect;
    if (_e112 != 0) {
        metal::float2 _e114 = uv_2;
        param = _e114;
        metal::float4 _e115 = getFromColor(param, _from, _sampler);
        local_2 = _e115;
    } else {
        metal::float2 _e116 = uv_2;
        param_1 = _e116;
        metal::float4 _e117 = getToColor(param_1, _sampler, _to);
        local_2 = _e117;
    }
    metal::float4 _e118 = local_2;
    ColorTo = _e118;
    float _e120 = uv2_[0u];
    bool _e121 = _e120 >= 0.0;
    phi_187_ = _e121;
    if (_e121) {
        float _e123 = uv2_[0u];
        float _e125 = iResolution[0u];
        phi_187_ = _e123 <= _e125;
    }
    bool _e128 = phi_187_;
    phi_193_ = _e128;
    if (_e128) {
        float _e130 = uv2_[1u];
        phi_193_ = _e130 >= 0.0;
    }
    bool _e133 = phi_193_;
    phi_201_ = _e133;
    if (_e133) {
        float _e135 = uv2_[1u];
        float _e137 = iResolution[1u];
        phi_201_ = _e135 <= _e137;
    }
    bool _e140 = phi_201_;
    if (_e140) {
        metal::float2 _e141 = iResolution;
        metal::float2 _e142 = uv2_;
        uv2_ = _e142 / _e141;
        int _e145 = uniforms.ReverseEffect;
        if (_e145 != 0) {
            metal::float2 _e147 = uv2_;
            param_2 = _e147;
            metal::float4 _e148 = getToColor(param_2, _sampler, _to);
            local_3 = _e148;
        } else {
            metal::float2 _e149 = uv2_;
            param_3 = _e149;
            metal::float4 _e150 = getFromColor(param_3, _from, _sampler);
            local_3 = _e150;
        }
        metal::float4 _e151 = local_3;
        col3_ = _e151;
    } else {
        int _e153 = uniforms.FadeInSecond;
        metal::float4 _e155 = ColorTo;
        col3_ = metal::select(_e155, metal::float4(0.0, 0.0, 0.0, 0.0), metal::bool4(_e153 != 0));
    }
    float _e158 = t;
    metal::float4 _e160 = col3_;
    float _e162 = t;
    metal::float4 _e163 = ColorTo;
    return (_e160 * (1.0 - _e158)) + (_e163 * _e162);
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
    metal::float2 _e22 = _uv_1;
    param_4 = _e22;
    metal::float4 _e23 = transition(param_4, _from, _sampler, _to, uniforms);
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
