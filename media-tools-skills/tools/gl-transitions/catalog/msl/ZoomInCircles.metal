// ZoomInCircles — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ZoomInCircles.glsl
// Author: dycm8009
// License: MIT
// Description: Concentric rings of the outgoing image zoom at different speeds before revealing the incoming one
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
    float _e25 = uv[0u];
    float _e27 = uv[1u];
    metal::float4 _e30 = _to.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e25 = uv_1[0u];
    float _e27 = uv_1[1u];
    metal::float4 _e30 = _from.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float2 zoom(
    thread metal::float2& uv_2,
    thread float& amount
) {
    metal::float2 _e25 = uv_2;
    float _e28 = amount;
    return metal::float2(0.5) + ((_e25 - metal::float2(0.5)) * _e28);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 ratio2_ = {};
    metal::float2 r = {};
    float pro = {};
    float z = {};
    float t = {};
    metal::float2 param = {};
    float param_1 = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    metal::float2 param_4 = {};
    float param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float _e38 = uniforms.ratio;
    ratio2_ = metal::float2(1.0, 1.0 / _e38);
    metal::float2 _e41 = uv_3;
    metal::float2 _e44 = ratio2_;
    r = ((_e41 - metal::float2(0.5)) * _e44) * 2.0;
    float _e48 = uniforms.progress;
    pro = _e48 / 0.8;
    float _e50 = pro;
    z = _e50 * 0.2;
    t = 0.0;
    float _e52 = pro;
    if (_e52 > 1.0) {
        float _e54 = pro;
        z = 0.2 + ((_e54 - 1.0) * 5.0);
        float _e59 = uniforms.progress;
        t = metal::clamp((_e59 - 0.8) / 0.07, 0.0, 1.0);
    }
    metal::float2 _e63 = r;
    float _e65 = z;
    if (metal::length(_e63) < (0.5 + _e65)) {
    } else {
        metal::float2 _e68 = r;
        float _e70 = z;
        if (metal::length(_e68) < (0.8 + (_e70 * 1.5))) {
            float _e74 = pro;
            metal::float2 _e77 = uv_3;
            param = _e77;
            param_1 = 1.0 - (0.15 * _e74);
            metal::float2 _e78 = zoom(param, param_1);
            uv_3 = _e78;
            float _e79 = t;
            t = _e79 * 0.5;
        } else {
            metal::float2 _e81 = r;
            float _e83 = z;
            if (metal::length(_e81) < (1.2 + (_e83 * 2.5))) {
                float _e87 = pro;
                metal::float2 _e90 = uv_3;
                param_2 = _e90;
                param_3 = 1.0 - (0.2 * _e87);
                metal::float2 _e91 = zoom(param_2, param_3);
                uv_3 = _e91;
                float _e92 = t;
                t = _e92 * 0.2;
            } else {
                float _e94 = pro;
                metal::float2 _e97 = uv_3;
                param_4 = _e97;
                param_5 = 1.0 - (0.25 * _e94);
                metal::float2 _e98 = zoom(param_4, param_5);
                uv_3 = _e98;
            }
        }
    }
    metal::float2 _e99 = uv_3;
    param_6 = _e99;
    metal::float4 _e100 = getFromColor(param_6, _from, _sampler);
    metal::float2 _e101 = uv_3;
    param_7 = _e101;
    metal::float4 _e102 = getToColor(param_7, _sampler, _to);
    float _e103 = t;
    return metal::mix(_e100, _e102, metal::float4(_e103));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e24 = _uv_1;
    param_8 = _e24;
    metal::float4 _e25 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e25;
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
