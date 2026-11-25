// BlockCover — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BlockCover.glsl
// Author: gre
// License: MIT
// Description: Blocks of a solid color pop in at random over the outgoing image until they cover the frame, then pop out in another random order to show the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int blocks;
    char _pad3[4];
    metal::float4 color;
    float pop;
    float smoothness;
    char _pad6[8];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e35 = p;
    p3_ = metal::fract(_e35.xyx * 0.1031);
    metal::float3 _e39 = p3_;
    metal::float3 _e40 = p3_;
    metal::float3 _e45 = p3_;
    p3_ = _e45 + metal::float3(metal::dot(_e39, _e40.yzx + metal::float3(33.33)));
    float _e49 = p3_[0u];
    float _e51 = p3_[1u];
    float _e54 = p3_[2u];
    return metal::fract((_e49 + _e51) * _e54);
}

metal::float2 timing(
    thread metal::float2& cell
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e36 = cell;
    param = _e36 + metal::float2(0.5);
    float _e39 = hash(param);
    metal::float2 _e41 = cell;
    param_1 = _e41 + metal::float2(71.7);
    float _e44 = hash(param_1);
    return metal::float2(0.29 * _e39, 0.47 + (0.39 * _e44));
}

float backOut(
    thread float& t,
    thread float& c
) {
    float u = {};
    float _e36 = t;
    u = _e36 - 1.0;
    float _e38 = c;
    float _e40 = u;
    float _e42 = u;
    float _e44 = u;
    float _e47 = c;
    float _e48 = u;
    float _e50 = u;
    return (1.0 + ((((_e38 + 1.0) * _e40) * _e42) * _e44)) + ((_e47 * _e48) * _e50);
}

float coverage(
    thread metal::float2& q,
    thread metal::float2& cell_1,
    thread float& s,
    thread float& sm
) {
    float h = {};
    metal::float2 d = {};
    float local = {};
    float _e40 = s;
    float _e41 = sm;
    h = _e40 * (0.5 + _e41);
    metal::float2 _e44 = q;
    metal::float2 _e45 = cell_1;
    d = metal::abs((_e44 - _e45) - metal::float2(0.5));
    float _e50 = s;
    if (_e50 > 0.0) {
        float _e52 = h;
        float _e53 = sm;
        float _e55 = h;
        float _e57 = d[0u];
        float _e59 = d[1u];
        local = 1.0 - metal::smoothstep(_e52 - _e53, _e55, metal::max(_e57, _e59));
    } else {
        local = 0.0;
    }
    float _e63 = local;
    return _e63;
}

float blockScale(
    thread metal::float2& cell_2,
    thread float& c_1,
    constant Uniforms& uniforms
) {
    metal::float2 t_1 = {};
    metal::float2 param_2 = {};
    float a = {};
    float b = {};
    float local_1 = {};
    float param_3 = {};
    float param_4 = {};
    metal::float2 _e42 = cell_2;
    param_2 = _e42;
    metal::float2 _e43 = timing(param_2);
    t_1 = _e43;
    float _e45 = uniforms.progress;
    float _e47 = t_1[0u];
    a = metal::clamp((_e45 - _e47) / 0.14, 0.0, 1.0);
    float _e52 = uniforms.progress;
    float _e54 = t_1[1u];
    b = metal::clamp((_e52 - _e54) / 0.14, 0.0, 1.0);
    float _e58 = b;
    if (_e58 > 0.0) {
        float _e60 = b;
        float _e62 = b;
        local_1 = (1.0 - _e60) * (1.0 - _e62);
    } else {
        float _e65 = a;
        param_3 = _e65;
        float _e66 = c_1;
        param_4 = _e66;
        float _e67 = backOut(param_3, param_4);
        local_1 = _e67;
    }
    float _e68 = local_1;
    return _e68;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float nLong = {};
    metal::float2 n = {};
    metal::float2 local_2 = {};
    metal::float2 q_1 = {};
    metal::float2 cell_3 = {};
    float sm_1 = {};
    float c_2 = {};
    float s_1 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float cover = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float u_1 = {};
    float reach = {};
    float param_11 = {};
    float param_12 = {};
    metal::float2 o = {};
    int j = {};
    int i = {};
    metal::float2 nb = {};
    metal::float2 inside = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    float param_18 = {};
    metal::float2 t_2 = {};
    metal::float2 param_19 = {};
    metal::float4 under = {};
    metal::float4 local_3 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    bool phi_398_ = {};
    int _e71 = uniforms.blocks;
    nLong = metal::max(static_cast<float>(_e71), 1.0);
    float _e75 = uniforms.ratio;
    if (_e75 >= 1.0) {
        float _e77 = nLong;
        float _e78 = nLong;
        float _e80 = uniforms.ratio;
        local_2 = metal::float2(_e77, metal::max(1.0, metal::floor((_e78 / _e80) + 0.5)));
    } else {
        float _e86 = nLong;
        float _e88 = uniforms.ratio;
        float _e93 = nLong;
        local_2 = metal::float2(metal::max(1.0, metal::floor((_e86 * _e88) + 0.5)), _e93);
    }
    metal::float2 _e95 = local_2;
    n = _e95;
    metal::float2 _e96 = uv_2;
    metal::float2 _e97 = n;
    q_1 = _e96 * _e97;
    metal::float2 _e99 = q_1;
    cell_3 = metal::floor(_e99);
    float _e102 = uniforms.smoothness;
    sm_1 = metal::max(_e102, 0.001);
    float _e105 = uniforms.pop;
    c_2 = 2.0 * metal::clamp(_e105, 0.0, 1.0);
    metal::float2 _e108 = cell_3;
    param_5 = _e108;
    float _e109 = c_2;
    param_6 = _e109;
    float _e110 = blockScale(param_5, param_6, uniforms);
    s_1 = _e110;
    float _e111 = s_1;
    if (_e111 >= 1.0) {
        metal::float4 _e114 = uniforms.color;
        return _e114;
    }
    metal::float2 _e115 = q_1;
    param_7 = _e115;
    metal::float2 _e116 = cell_3;
    param_8 = _e116;
    float _e117 = s_1;
    param_9 = _e117;
    float _e118 = sm_1;
    param_10 = _e118;
    float _e119 = coverage(param_7, param_8, param_9, param_10);
    cover = _e119;
    float _e120 = c_2;
    float _e122 = c_2;
    u_1 = (-2.0 * _e120) / (3.0 * (_e122 + 1.0));
    float _e126 = u_1;
    param_11 = 1.0 + _e126;
    float _e128 = c_2;
    param_12 = _e128;
    float _e129 = backOut(param_11, param_12);
    float _e130 = sm_1;
    reach = _e129 * (0.5 + _e130);
    metal::float2 _e133 = q_1;
    metal::float2 _e134 = cell_3;
    o = metal::abs((_e133 - _e134) - metal::float2(0.5));
    float _e140 = o[0u];
    float _e142 = o[1u];
    float _e144 = reach;
    if (metal::max(_e140, _e142) > (1.0 - _e144)) {
        j = -1;
        uint2 loop_bound = uint2(4294967295u);
        bool loop_init = true;
        while(true) {
            if (metal::all(loop_bound == uint2(0u))) { break; }
            loop_bound -= uint2(loop_bound.y == 0u, 1u);
            if (!loop_init) {
                int _e190 = j;
                j = as_type<int>(as_type<uint>(_e190) + as_type<uint>(1));
            }
            loop_init = false;
            int _e147 = j;
            if (_e147 <= 1) {
                i = -1;
                uint2 loop_bound_1 = uint2(4294967295u);
                bool loop_init_1 = true;
                while(true) {
                    if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                    loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                    if (!loop_init_1) {
                        int _e188 = i;
                        i = as_type<int>(as_type<uint>(_e188) + as_type<uint>(1));
                    }
                    loop_init_1 = false;
                    int _e149 = i;
                    if (_e149 <= 1) {
                        metal::float2 _e151 = cell_3;
                        int _e152 = i;
                        int _e154 = j;
                        nb = _e151 + metal::float2(static_cast<float>(_e152), static_cast<float>(_e154));
                        metal::float2 _e158 = nb;
                        metal::float2 _e160 = nb;
                        metal::float2 _e161 = n;
                        inside = metal::step(metal::float2(0.0, 0.0), _e158) * metal::step(_e160, _e161 - metal::float2(1.0));
                        float _e167 = inside[0u];
                        float _e169 = inside[1u];
                        bool _e171 = (_e167 * _e169) > 0.0;
                        phi_398_ = _e171;
                        if (_e171) {
                            int _e172 = i;
                            int _e174 = j;
                            phi_398_ = (_e172 != 0) || (_e174 != 0);
                        }
                        bool _e178 = phi_398_;
                        if (_e178) {
                            float _e179 = cover;
                            metal::float2 _e180 = nb;
                            param_13 = _e180;
                            float _e181 = c_2;
                            param_14 = _e181;
                            float _e182 = blockScale(param_13, param_14, uniforms);
                            metal::float2 _e183 = q_1;
                            param_15 = _e183;
                            metal::float2 _e184 = nb;
                            param_16 = _e184;
                            param_17 = _e182;
                            float _e185 = sm_1;
                            param_18 = _e185;
                            float _e186 = coverage(param_15, param_16, param_17, param_18);
                            cover = metal::max(_e179, _e186);
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
    }
    metal::float2 _e192 = cell_3;
    param_19 = _e192;
    metal::float2 _e193 = timing(param_19);
    t_2 = _e193;
    float _e195 = uniforms.progress;
    float _e197 = t_2[0u];
    float _e200 = t_2[1u];
    if (_e195 < (0.5 * ((_e197 + 0.14) + _e200))) {
        metal::float2 _e204 = uv_2;
        param_20 = _e204;
        metal::float4 _e205 = getFromColor(param_20, _from, _sampler);
        local_3 = _e205;
    } else {
        metal::float2 _e206 = uv_2;
        param_21 = _e206;
        metal::float4 _e207 = getToColor(param_21, _sampler, _to);
        local_3 = _e207;
    }
    metal::float4 _e208 = local_3;
    under = _e208;
    metal::float4 _e209 = under;
    metal::float4 _e211 = uniforms.color;
    float _e212 = cover;
    return metal::mix(_e209, _e211, metal::float4(_e212));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_22 = {};
    metal::float2 _e34 = _uv_1;
    param_22 = _e34;
    metal::float4 _e35 = transition(param_22, _from, _sampler, _to, uniforms);
    _fragColor = _e35;
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
