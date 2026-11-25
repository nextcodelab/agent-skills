// Slides — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Slides.glsl
// Author: Mark Craig
// License: MIT
// Description: The outgoing image slides out, or the incoming one slides in, toward an edge, a corner or the center
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int type;
    int In;
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

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 uv0_ = {};
    float rad = {};
    float local = {};
    float xc1_ = {};
    float yc1_ = {};
    metal::float2 uv2_ = {};
    metal::float4 local_1 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 local_2 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    bool phi_193_ = {};
    bool phi_200_ = {};
    bool phi_209_ = {};
    metal::float2 _e34 = uv_2;
    uv0_ = _e34;
    int _e36 = uniforms.In;
    if (_e36 != 0) {
        float _e39 = uniforms.progress;
        local = _e39;
    } else {
        float _e41 = uniforms.progress;
        local = 1.0 - _e41;
    }
    float _e43 = local;
    rad = _e43;
    int _e45 = uniforms.type;
    if (_e45 == 0) {
        float _e47 = rad;
        xc1_ = 0.5 - (_e47 / 2.0);
        yc1_ = 0.0;
    } else {
        int _e51 = uniforms.type;
        if (_e51 == 1) {
            float _e53 = rad;
            xc1_ = 1.0 - _e53;
            float _e55 = rad;
            yc1_ = 0.5 - (_e55 / 2.0);
        } else {
            int _e59 = uniforms.type;
            if (_e59 == 2) {
                float _e61 = rad;
                xc1_ = 0.5 - (_e61 / 2.0);
                float _e64 = rad;
                yc1_ = 1.0 - _e64;
            } else {
                int _e67 = uniforms.type;
                if (_e67 == 3) {
                    xc1_ = 0.0;
                    float _e69 = rad;
                    yc1_ = 0.5 - (_e69 / 2.0);
                } else {
                    int _e73 = uniforms.type;
                    if (_e73 == 4) {
                        float _e75 = rad;
                        xc1_ = 1.0 - _e75;
                        yc1_ = 0.0;
                    } else {
                        int _e78 = uniforms.type;
                        if (_e78 == 5) {
                            float _e80 = rad;
                            xc1_ = 1.0 - _e80;
                            float _e82 = rad;
                            yc1_ = 1.0 - _e82;
                        } else {
                            int _e85 = uniforms.type;
                            if (_e85 == 6) {
                                xc1_ = 0.0;
                                float _e87 = rad;
                                yc1_ = 1.0 - _e87;
                            } else {
                                int _e90 = uniforms.type;
                                if (_e90 == 7) {
                                    xc1_ = 0.0;
                                    yc1_ = 0.0;
                                } else {
                                    int _e93 = uniforms.type;
                                    if (_e93 == 8) {
                                        float _e95 = rad;
                                        xc1_ = 0.5 - (_e95 / 2.0);
                                        float _e98 = rad;
                                        yc1_ = 0.5 - (_e98 / 2.0);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    float _e102 = uv_2[1u];
    uv_2[1u] = 1.0 - _e102;
    float _e106 = uv_2[0u];
    float _e107 = xc1_;
    bool _e108 = _e106 >= _e107;
    phi_193_ = _e108;
    if (_e108) {
        float _e110 = uv_2[0u];
        float _e111 = xc1_;
        float _e112 = rad;
        phi_193_ = _e110 <= (_e111 + _e112);
    }
    bool _e116 = phi_193_;
    phi_200_ = _e116;
    if (_e116) {
        float _e118 = uv_2[1u];
        float _e119 = yc1_;
        phi_200_ = _e118 >= _e119;
    }
    bool _e122 = phi_200_;
    phi_209_ = _e122;
    if (_e122) {
        float _e124 = uv_2[1u];
        float _e125 = yc1_;
        float _e126 = rad;
        phi_209_ = _e124 <= (_e125 + _e126);
    }
    bool _e130 = phi_209_;
    if (_e130) {
        float _e132 = uv_2[0u];
        float _e133 = xc1_;
        float _e135 = rad;
        float _e138 = uv_2[1u];
        float _e139 = yc1_;
        float _e141 = rad;
        uv2_ = metal::float2((_e132 - _e133) / _e135, 1.0 - ((_e138 - _e139) / _e141));
        int _e146 = uniforms.In;
        if (_e146 != 0) {
            metal::float2 _e148 = uv2_;
            param = _e148;
            metal::float4 _e149 = getToColor(param, _sampler, _to);
            local_1 = _e149;
        } else {
            metal::float2 _e150 = uv2_;
            param_1 = _e150;
            metal::float4 _e151 = getFromColor(param_1, _from, _sampler);
            local_1 = _e151;
        }
        metal::float4 _e152 = local_1;
        return _e152;
    }
    int _e154 = uniforms.In;
    if (_e154 != 0) {
        metal::float2 _e156 = uv0_;
        param_2 = _e156;
        metal::float4 _e157 = getFromColor(param_2, _from, _sampler);
        local_2 = _e157;
    } else {
        metal::float2 _e158 = uv0_;
        param_3 = _e158;
        metal::float4 _e159 = getToColor(param_3, _sampler, _to);
        local_2 = _e159;
    }
    metal::float4 _e160 = local_2;
    return _e160;
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
