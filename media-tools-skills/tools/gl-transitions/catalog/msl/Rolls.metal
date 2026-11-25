// Rolls — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Rolls.glsl
// Author: Mark Craig
// License: MIT
// Description: The outgoing image rolls away around a corner, revealing the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int type;
    int RotDown;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e19 = uv[0u];
    float _e21 = uv[1u];
    metal::float4 _e24 = _to.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e19 = uv_1[0u];
    float _e21 = uv_1[1u];
    metal::float4 _e24 = _from.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 iResolution = {};
    float theta = {};
    metal::float2 uvi = {};
    float c1_ = {};
    float s1_ = {};
    metal::float2 uv2_ = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool phi_200_ = {};
    bool phi_206_ = {};
    bool phi_214_ = {};
    float _e27 = uniforms.ratio;
    iResolution = metal::float2(_e27, 1.0);
    int _e30 = uniforms.type;
    if (_e30 == 0) {
        int _e33 = uniforms.RotDown;
        float _e38 = uniforms.progress;
        theta = (((_e33 != 0) ? 3.1415927 : -3.1415927) / 2.0) * _e38;
        float _e41 = uv_2[0u];
        uvi[0u] = 1.0 - _e41;
        float _e45 = uv_2[1u];
        uvi[1u] = _e45;
    } else {
        int _e48 = uniforms.type;
        if (_e48 == 1) {
            int _e51 = uniforms.RotDown;
            float _e56 = uniforms.progress;
            theta = (((_e51 != 0) ? 3.1415927 : -3.1415927) / 2.0) * _e56;
            metal::float2 _e58 = uv_2;
            uvi = _e58;
        } else {
            int _e60 = uniforms.type;
            if (_e60 == 2) {
                int _e63 = uniforms.RotDown;
                float _e68 = uniforms.progress;
                theta = (((_e63 != 0) ? -3.1415927 : 3.1415927) / 2.0) * _e68;
                float _e71 = uv_2[0u];
                uvi[0u] = _e71;
                float _e74 = uv_2[1u];
                uvi[1u] = 1.0 - _e74;
            } else {
                int _e78 = uniforms.type;
                if (_e78 == 3) {
                    int _e81 = uniforms.RotDown;
                    float _e86 = uniforms.progress;
                    theta = (((_e81 != 0) ? -3.1415927 : 3.1415927) / 2.0) * _e86;
                    metal::float2 _e88 = uv_2;
                    uvi = metal::float2(1.0) - _e88;
                }
            }
        }
    }
    float _e91 = theta;
    c1_ = metal::cos(_e91);
    float _e93 = theta;
    s1_ = metal::sin(_e93);
    float _e96 = uvi[0u];
    float _e98 = iResolution[0u];
    float _e100 = c1_;
    float _e103 = uvi[1u];
    float _e105 = iResolution[1u];
    float _e107 = s1_;
    uv2_[0u] = ((_e96 * _e98) * _e100) - ((_e103 * _e105) * _e107);
    float _e112 = uvi[0u];
    float _e114 = iResolution[0u];
    float _e116 = s1_;
    float _e119 = uvi[1u];
    float _e121 = iResolution[1u];
    float _e123 = c1_;
    uv2_[1u] = ((_e112 * _e114) * _e116) + ((_e119 * _e121) * _e123);
    float _e128 = uv2_[0u];
    bool _e129 = _e128 >= 0.0;
    phi_200_ = _e129;
    if (_e129) {
        float _e131 = uv2_[0u];
        float _e133 = iResolution[0u];
        phi_200_ = _e131 <= _e133;
    }
    bool _e136 = phi_200_;
    phi_206_ = _e136;
    if (_e136) {
        float _e138 = uv2_[1u];
        phi_206_ = _e138 >= 0.0;
    }
    bool _e141 = phi_206_;
    phi_214_ = _e141;
    if (_e141) {
        float _e143 = uv2_[1u];
        float _e145 = iResolution[1u];
        phi_214_ = _e143 <= _e145;
    }
    bool _e148 = phi_214_;
    if (_e148) {
        metal::float2 _e149 = iResolution;
        metal::float2 _e150 = uv2_;
        uv2_ = _e150 / _e149;
        int _e153 = uniforms.type;
        if (_e153 == 0) {
            float _e156 = uv2_[0u];
            uv2_[0u] = 1.0 - _e156;
        } else {
            int _e160 = uniforms.type;
            if (_e160 == 2) {
                float _e163 = uv2_[1u];
                uv2_[1u] = 1.0 - _e163;
            } else {
                int _e167 = uniforms.type;
                if (_e167 == 3) {
                    metal::float2 _e169 = uv2_;
                    uv2_ = metal::float2(1.0) - _e169;
                }
            }
        }
        metal::float2 _e172 = uv2_;
        param = _e172;
        metal::float4 _e173 = getFromColor(param, _from, _sampler);
        return _e173;
    }
    metal::float2 _e174 = uv_2;
    param_1 = _e174;
    metal::float4 _e175 = getToColor(param_1, _sampler, _to);
    return _e175;
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
    metal::float2 _e18 = _uv_1;
    param_2 = _e18;
    metal::float4 _e19 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e19;
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
