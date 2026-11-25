// PowerKaleido — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PowerKaleido.glsl
// Author: Boundless
// License: MIT
// Description: The image folds into an animated kaleidoscope before revealing the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float scale;
    float z;
    float speed;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e28 = uv[0u];
    float _e30 = uv[1u];
    metal::float4 _e33 = _to.sample(_sampler, metal::float2(_e28, 1.0 - _e30), metal::level(0.0));
    return _e33;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e28 = uv_1[0u];
    float _e30 = uv_1[1u];
    metal::float4 _e33 = _from.sample(_sampler, metal::float2(_e28, 1.0 - _e30), metal::level(0.0));
    return _e33;
}

metal::float2 refl(
    thread metal::float2& p,
    thread metal::float2& o,
    thread metal::float2& n
) {
    metal::float2 _e29 = o;
    metal::float2 _e31 = n;
    metal::float2 _e33 = p;
    metal::float2 _e34 = o;
    metal::float2 _e36 = n;
    metal::float2 _e40 = p;
    return ((_e29 * 2.0) + ((_e31 * 2.0) * metal::dot(_e33 - _e34, _e36))) - _e40;
}

metal::float2 rot(
    thread metal::float2& p_1,
    thread metal::float2& o_1,
    thread float& a
) {
    float s = {};
    float c = {};
    float _e31 = a;
    s = metal::sin(_e31);
    float _e33 = a;
    c = metal::cos(_e33);
    metal::float2 _e35 = o_1;
    float _e36 = c;
    float _e37 = s;
    float _e39 = s;
    float _e40 = c;
    metal::float2 _e44 = p_1;
    metal::float2 _e45 = o_1;
    return _e35 + (metal::float2x2(metal::float2(_e36, -(_e37)), metal::float2(_e39, _e40)) * (_e44 - _e45));
}

metal::float4 mainImage(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dist = {};
    metal::float2 uv0_ = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float theta = {};
    int iter = {};
    float i = {};
    float ts = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    metal::float2 uvMix = {};
    metal::float4 color = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    bool phi_209_ = {};
    bool phi_235_ = {};
    bool phi_236_ = {};
    float _e47 = uniforms.scale;
    dist = _e47 / 10.0;
    metal::float2 _e49 = uv_2;
    uv0_ = _e49;
    metal::float2 _e50 = uv_2;
    uv_2 = _e50 - metal::float2(0.5);
    float _e54 = uniforms.ratio;
    float _e56 = uv_2[0u];
    uv_2[0u] = _e56 * _e54;
    float _e60 = uniforms.z;
    metal::float2 _e61 = uv_2;
    uv_2 = _e61 * _e60;
    float _e64 = uniforms.progress;
    float _e66 = uniforms.speed;
    metal::float2 _e68 = uv_2;
    param = _e68;
    param_1 = metal::float2(0.0, 0.0);
    param_2 = _e64 * _e66;
    metal::float2 _e69 = rot(param, param_1, param_2);
    uv_2 = _e69;
    float _e71 = uniforms.progress;
    theta = (_e71 * 6.0) + 6.2831855;
    iter = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e156 = iter;
            iter = as_type<int>(as_type<uint>(_e156) + as_type<uint>(1));
        }
        loop_init = false;
        int _e74 = iter;
        if (_e74 < 10) {
            i = 0.0;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    float _e154 = i;
                    i = _e154 + 2.0943952;
                }
                loop_init_1 = false;
                float _e76 = i;
                if (_e76 < 6.2831855) {
                    float _e78 = i;
                    ts = (metal::sign(metal::asin(metal::cos(_e78))) == 1.0) ? 1.0 : 0.0;
                    float _e84 = ts;
                    bool _e85 = _e84 == 1.0;
                    phi_209_ = _e85;
                    if (_e85) {
                        float _e87 = uv_2[1u];
                        float _e88 = dist;
                        float _e89 = i;
                        float _e93 = i;
                        float _e96 = uv_2[0u];
                        float _e97 = dist;
                        float _e98 = i;
                        phi_209_ = (_e87 - (_e88 * metal::cos(_e89))) > (metal::tan(_e93) * (_e96 + (_e97 * metal::sin(_e98))));
                    }
                    bool _e105 = phi_209_;
                    phi_236_ = _e105;
                    if (!(_e105)) {
                        float _e107 = ts;
                        bool _e108 = _e107 == 0.0;
                        phi_235_ = _e108;
                        if (_e108) {
                            float _e110 = uv_2[1u];
                            float _e111 = dist;
                            float _e112 = i;
                            float _e116 = i;
                            float _e119 = uv_2[0u];
                            float _e120 = dist;
                            float _e121 = i;
                            phi_235_ = (_e110 - (_e111 * metal::cos(_e112))) < (metal::tan(_e116) * (_e119 + (_e120 * metal::sin(_e121))));
                        }
                        bool _e128 = phi_235_;
                        phi_236_ = _e128;
                    }
                    bool _e130 = phi_236_;
                    if (_e130) {
                        float _e132 = uv_2[0u];
                        float _e133 = i;
                        float _e135 = dist;
                        float _e140 = uv_2[1u];
                        float _e141 = i;
                        float _e143 = dist;
                        float _e148 = i;
                        float _e150 = i;
                        param_3 = metal::float2(_e132 + ((metal::sin(_e133) * _e135) * 2.0), _e140 - ((metal::cos(_e141) * _e143) * 2.0));
                        param_4 = metal::float2(0.0, 0.0);
                        param_5 = metal::float2(metal::cos(_e148), metal::sin(_e150));
                        metal::float2 _e153 = refl(param_3, param_4, param_5);
                        uv_2 = _e153;
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
    metal::float2 _e158 = uv_2;
    uv_2 = _e158 + metal::float2(0.5);
    float _e162 = uniforms.progress;
    float _e164 = uniforms.speed;
    metal::float2 _e167 = uv_2;
    param_6 = _e167;
    param_7 = metal::float2(0.5, 0.5);
    param_8 = _e162 * -(_e164);
    metal::float2 _e168 = rot(param_6, param_7, param_8);
    uv_2 = _e168;
    metal::float2 _e169 = uv_2;
    uv_2 = _e169 - metal::float2(0.5);
    float _e173 = uniforms.ratio;
    float _e175 = uv_2[0u];
    uv_2[0u] = _e175 / _e173;
    metal::float2 _e178 = uv_2;
    uv_2 = _e178 + metal::float2(0.5);
    metal::float2 _e181 = uv_2;
    metal::float2 _e184 = uv_2;
    uv_2 = metal::abs((_e181 / metal::float2(2.0)) - metal::floor((_e184 / metal::float2(2.0)) + metal::float2(0.5))) * 2.0;
    metal::float2 _e193 = uv_2;
    metal::float2 _e194 = uv0_;
    float _e196 = uniforms.progress;
    uvMix = metal::mix(_e193, _e194, metal::float2((metal::cos((_e196 * 3.1415927) * 2.0) / 2.0) + 0.5));
    metal::float2 _e204 = uvMix;
    param_9 = _e204;
    metal::float4 _e205 = getFromColor(param_9, _from, _sampler);
    metal::float2 _e206 = uvMix;
    param_10 = _e206;
    metal::float4 _e207 = getToColor(param_10, _sampler, _to);
    float _e209 = uniforms.progress;
    color = metal::mix(_e205, _e207, metal::float4((metal::cos((_e209 - 1.0) * 3.1415927) / 2.0) + 0.5));
    metal::float4 _e217 = color;
    return _e217;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 color_1 = {};
    metal::float2 param_11 = {};
    metal::float2 _e29 = uv_3;
    param_11 = _e29;
    metal::float4 _e30 = mainImage(param_11, _from, _sampler, _to, uniforms);
    color_1 = _e30;
    metal::float4 _e31 = color_1;
    return _e31;
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
    metal::float2 _e27 = _uv_1;
    param_12 = _e27;
    metal::float4 _e28 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e28;
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
