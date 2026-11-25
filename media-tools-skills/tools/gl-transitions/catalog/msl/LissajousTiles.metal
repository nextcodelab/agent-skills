// LissajousTiles — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LissajousTiles.glsl
// Author: Boundless <info@boundless-beta.com>
// License: MIT
// Description: The image breaks into a grid of tiles that swirl along Lissajous curves, in a Scanimate style, and flip one by one to the incoming image before settling back
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float speed;
    char _pad3[4];
    metal::float2 freq;
    float offset;
    float zoom;
    float fade;
    char _pad7[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e30 = uv[0u];
    float _e32 = uv[1u];
    metal::float4 _e35 = _to.sample(_sampler, metal::float2(_e30, 1.0 - _e32), metal::level(0.0));
    return _e35;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e30 = uv_1[0u];
    float _e32 = uv_1[1u];
    metal::float4 _e35 = _from.sample(_sampler, metal::float2(_e30, 1.0 - _e32), metal::level(0.0));
    return _e35;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float jBig = {};
    float iBig = {};
    float i = {};
    float j = {};
    float k = {};
    metal::float2 uv0_ = {};
    float tileMix = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool phi_179_ = {};
    bool phi_186_ = {};
    bool phi_194_ = {};
    float _e40 = uniforms.progress;
    p = 1.0 - metal::pow(1.0 - metal::smoothstep(0.0, 1.0, 1.0 - metal::abs(1.0 - (2.0 * _e40))), 3.0);
    jBig = 9.0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            float _e165 = jBig;
            jBig = _e165 - 1.0;
        }
        loop_init = false;
        float _e49 = jBig;
        if (_e49 >= 0.0) {
            iBig = 9.0;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    float _e163 = iBig;
                    iBig = _e163 - 1.0;
                }
                loop_init_1 = false;
                float _e51 = iBig;
                if (_e51 >= 0.0) {
                    float _e53 = iBig;
                    i = _e53 / 10.0;
                    float _e55 = jBig;
                    j = _e55 / 10.0;
                    float _e57 = i;
                    float _e59 = j;
                    k = (_e57 / 10.0) + _e59;
                    metal::float2 _e61 = uv_2;
                    float _e62 = i;
                    float _e63 = j;
                    float _e69 = k;
                    float _e73 = uniforms.freq[0u];
                    float _e76 = uniforms.progress;
                    float _e79 = uniforms.speed;
                    float _e83 = k;
                    float _e87 = uniforms.freq[1u];
                    float _e90 = uniforms.progress;
                    float _e93 = uniforms.offset;
                    float _e97 = uniforms.speed;
                    float _e103 = uniforms.zoom;
                    uv0_ = (((_e61 + metal::float2(_e62, _e63)) - metal::float2(0.5)) + metal::float2(0.05, 0.05)) + ((metal::float2(metal::cos(((_e69 * 6.2831855) * _e73) + ((_e76 * 6.0) * _e79)), metal::sin(((_e83 * 6.2831855) * _e87) + (((_e90 * 6.0) * (1.0 + _e93)) * _e97))) * _e103) / metal::float2(2.0));
                    metal::float2 _e108 = uv_2;
                    metal::float2 _e109 = uv0_;
                    float _e110 = p;
                    uv0_ = metal::mix(_e108, _e109, metal::float2(_e110));
                    float _e114 = uv0_[0u];
                    float _e115 = i;
                    bool _e116 = _e114 >= _e115;
                    phi_179_ = _e116;
                    if (_e116) {
                        float _e118 = uv0_[0u];
                        float _e119 = i;
                        phi_179_ = _e118 < (_e119 + 0.1);
                    }
                    bool _e123 = phi_179_;
                    phi_186_ = _e123;
                    if (_e123) {
                        float _e125 = uv0_[1u];
                        float _e126 = j;
                        phi_186_ = _e125 >= _e126;
                    }
                    bool _e129 = phi_186_;
                    phi_194_ = _e129;
                    if (_e129) {
                        float _e131 = uv0_[1u];
                        float _e132 = j;
                        phi_194_ = _e131 < (_e132 + 0.1);
                    }
                    bool _e136 = phi_194_;
                    if (_e136) {
                        float _e138 = uniforms.progress;
                        float _e140 = uniforms.fade;
                        float _e144 = uniforms.progress;
                        float _e148 = uniforms.fade;
                        float _e150 = k;
                        float _e152 = uniforms.fade;
                        tileMix = metal::clamp(((_e138 * (((1.0 + _e140) * 2.0) * _e144)) - _e148) + (_e150 * _e152), 0.0, 1.0);
                        metal::float2 _e156 = uv0_;
                        param = _e156;
                        metal::float4 _e157 = getFromColor(param, _from, _sampler);
                        metal::float2 _e158 = uv0_;
                        param_1 = _e158;
                        metal::float4 _e159 = getToColor(param_1, _sampler, _to);
                        float _e160 = tileMix;
                        return metal::mix(_e157, _e159, metal::float4(_e160));
                    }
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    return metal::float4(0.0, 0.0, 0.0, 0.0);
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
    metal::float2 _e29 = _uv_1;
    param_2 = _e29;
    metal::float4 _e30 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e30;
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
