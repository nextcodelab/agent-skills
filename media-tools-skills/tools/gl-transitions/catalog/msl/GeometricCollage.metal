// GeometricCollage — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GeometricCollage.glsl
// Author: gre
// License: MIT
// Description: The incoming image arrives cut into a geometric poster of quarter discs, half discs, triangles and their complements: piece after piece swings in around a corner of its cell, a flat plate of color just ahead of it, and lands flat with a soft paper shadow
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int cells;
    float stagger;
    int plates;
    char _pad5[12];
    metal::float4 color1_;
    metal::float4 color2_;
    metal::float4 color3_;
    float shadow;
    char _pad9[12];
};

float boxDist(
    thread metal::float2& l
) {
    float _e67 = l[0u];
    float _e69 = l[1u];
    float _e72 = l[0u];
    float _e75 = l[1u];
    return metal::min(metal::min(_e67, _e69), metal::min(1.0 - _e72, 1.0 - _e75));
}

float shapeDist(
    thread metal::float2& o,
    thread float& type_20
) {
    float _e67 = type_20;
    if (_e67 < 0.5) {
        metal::float2 _e69 = o;
        return metal::length(_e69) - 1.0;
    }
    float _e72 = type_20;
    if (_e72 < 1.5) {
        metal::float2 _e74 = o;
        return metal::length(_e74 - metal::float2(0.5, 0.0)) - 0.5;
    }
    float _e79 = o[0u];
    float _e81 = o[1u];
    return ((_e79 + _e81) - 1.0) * 0.70710677;
}

metal::float2 orient(
    thread metal::float2& l_1,
    thread float& k
) {
    metal::float2 c = {};
    metal::float2 _e68 = l_1;
    c = _e68 - metal::float2(0.5);
    float _e71 = k;
    if (_e71 < 0.5) {
        metal::float2 _e73 = l_1;
        return _e73;
    }
    float _e74 = k;
    if (_e74 < 1.5) {
        float _e77 = c[1u];
        float _e80 = c[0u];
        return metal::float2(-(_e77), _e80) + metal::float2(0.5);
    }
    float _e84 = k;
    if (_e84 < 2.5) {
        metal::float2 _e86 = c;
        return metal::float2(0.5) - _e86;
    }
    float _e90 = c[1u];
    float _e92 = c[0u];
    return metal::float2(_e90, -(_e92)) + metal::float2(0.5);
}

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e67 = v;
    v3_ = metal::fract(_e67.xyx * 0.1031);
    metal::float3 _e71 = v3_;
    metal::float3 _e72 = v3_;
    metal::float3 _e77 = v3_;
    v3_ = _e77 + metal::float3(metal::dot(_e71, _e72.yzx + metal::float3(33.33)));
    float _e81 = v3_[0u];
    float _e83 = v3_[1u];
    float _e86 = v3_[2u];
    return metal::fract((_e81 + _e83) * _e86);
}

float pieceDist(
    thread metal::float2& l_2,
    thread metal::float2& cell,
    thread float& piece
) {
    float k_1 = {};
    metal::float2 param = {};
    float sd = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float local = {};
    metal::float2 _e76 = cell;
    param = _e76 + metal::float2(1.7);
    float _e79 = hash12(param);
    k_1 = metal::floor(_e79 * 4.0);
    metal::float2 _e82 = l_2;
    param_1 = _e82;
    float _e83 = k_1;
    param_2 = _e83;
    metal::float2 _e84 = orient(param_1, param_2);
    float _e86 = cell[0u];
    float _e88 = cell[1u];
    float _e91 = (_e86 + (2.0 * _e88)) + 1.0;
    param_3 = _e84;
    param_4 = _e91 - (metal::floor(_e91 / 3.0) * 3.0);
    float _e96 = shapeDist(param_3, param_4);
    sd = _e96;
    float _e97 = piece;
    if (_e97 > 0.5) {
        float _e99 = sd;
        local = -(_e99);
    } else {
        float _e101 = sd;
        local = _e101;
    }
    float _e102 = local;
    return _e102;
}

float easeOutCubic(
    thread float& t
) {
    float u = {};
    float _e67 = t;
    u = 1.0 - metal::clamp(_e67, 0.0, 1.0);
    float _e70 = u;
    float _e71 = u;
    float _e73 = u;
    return 1.0 - ((_e70 * _e71) * _e73);
}

float lift(
    thread float& t_1
) {
    float _e66 = t_1;
    return 1.0 - metal::smoothstep(0.3, 1.0, _e66);
}

metal::float2 pivotCorner(
    thread float& k_2
) {
    float _e66 = k_2;
    if (_e66 < 0.5) {
        return metal::float2(0.0, 0.0);
    }
    float _e68 = k_2;
    if (_e68 < 1.5) {
        return metal::float2(0.0, 1.0);
    }
    float _e70 = k_2;
    if (_e70 < 2.5) {
        return metal::float2(1.0, 1.0);
    }
    return metal::float2(1.0, 0.0);
}

metal::float3 swingPoint(
    thread metal::float2& p,
    thread metal::float2& cell_1,
    thread metal::float2& cs,
    thread float& piece_1,
    thread float& t_2
) {
    metal::float2 pc = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    metal::float2 piv = {};
    metal::float2 local_1 = {};
    float sgn = {};
    metal::float2 param_7 = {};
    float s = {};
    float param_8 = {};
    float a = {};
    float param_9 = {};
    float ca = {};
    float sa = {};
    metal::float2 d = {};
    metal::float2 _e84 = cell_1;
    param_5 = _e84 + metal::float2(1.7);
    float _e87 = hash12(param_5);
    param_6 = metal::floor(_e87 * 4.0);
    metal::float2 _e90 = pivotCorner(param_6);
    pc = _e90;
    metal::float2 _e91 = cell_1;
    float _e92 = piece_1;
    if (_e92 < 0.5) {
        metal::float2 _e94 = pc;
        local_1 = _e94;
    } else {
        metal::float2 _e95 = pc;
        local_1 = metal::float2(1.0) - _e95;
    }
    metal::float2 _e98 = local_1;
    metal::float2 _e100 = cs;
    piv = (_e91 + _e98) * _e100;
    metal::float2 _e102 = cell_1;
    float _e103 = piece_1;
    param_7 = _e102 + metal::float2(_e103 * 3.3, 5.2);
    float _e107 = hash12(param_7);
    sgn = (_e107 < 0.5) ? -1.0 : 1.0;
    float _e110 = t_2;
    float _e112 = t_2;
    param_8 = _e112;
    float _e113 = lift(param_8);
    s = metal::smoothstep(0.0, 0.45, _e110) * (1.0 + (0.1 * _e113));
    float _e117 = sgn;
    float _e120 = t_2;
    param_9 = _e120 / 0.8;
    float _e122 = easeOutCubic(param_9);
    a = ((_e117 * 0.5) * 3.1415927) * (1.0 - _e122);
    float _e125 = a;
    ca = metal::cos(_e125);
    float _e127 = a;
    sa = metal::sin(_e127);
    metal::float2 _e129 = p;
    metal::float2 _e130 = piv;
    d = _e129 - _e130;
    float _e132 = ca;
    float _e134 = d[0u];
    float _e136 = sa;
    float _e138 = d[1u];
    float _e141 = sa;
    float _e144 = d[0u];
    float _e146 = ca;
    float _e148 = d[1u];
    float _e152 = s;
    d = metal::float2((_e132 * _e134) + (_e136 * _e138), (-(_e141) * _e144) + (_e146 * _e148)) / metal::float2(metal::max(_e152, 0.001));
    metal::float2 _e156 = piv;
    metal::float2 _e157 = d;
    metal::float2 _e159 = cs;
    metal::float2 _e161 = cell_1;
    metal::float2 _e162 = ((_e156 + _e157) / _e159) - _e161;
    float _e163 = s;
    return metal::float3(_e162.x, _e162.y, _e163);
}

float layerShadow(
    thread metal::float2& p_1,
    thread metal::float2& cell_2,
    thread metal::float2& cs_1,
    thread float& piece_2,
    thread float& t_3
) {
    float h = {};
    float param_10 = {};
    metal::float3 q = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float soft = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    float param_18 = {};
    metal::float2 param_19 = {};
    float _e83 = t_3;
    param_10 = _e83;
    float _e84 = lift(param_10);
    h = _e84;
    metal::float2 _e85 = p_1;
    float _e86 = h;
    float _e89 = cs_1[1u];
    param_11 = _e85 - ((metal::float2(0.07, -0.1) * _e86) * _e89);
    metal::float2 _e92 = cell_2;
    param_12 = _e92;
    metal::float2 _e93 = cs_1;
    param_13 = _e93;
    float _e94 = piece_2;
    param_14 = _e94;
    float _e95 = t_3;
    param_15 = _e95;
    metal::float3 _e96 = swingPoint(param_11, param_12, param_13, param_14, param_15);
    q = _e96;
    float _e98 = q[2u];
    if (_e98 < 0.01) {
        return 0.0;
    }
    float _e100 = h;
    soft = 0.02 + (0.05 * _e100);
    float _e103 = h;
    float _e104 = soft;
    float _e106 = soft;
    metal::float3 _e107 = q;
    param_16 = _e107.xy;
    metal::float2 _e109 = cell_2;
    param_17 = _e109;
    float _e110 = piece_2;
    param_18 = _e110;
    float _e111 = pieceDist(param_16, param_17, param_18);
    float _e115 = soft;
    float _e117 = soft;
    metal::float3 _e118 = q;
    param_19 = _e118.xy;
    float _e120 = boxDist(param_19);
    return (_e103 * (1.0 - metal::smoothstep(-(_e104), _e106, _e111))) * metal::smoothstep(-(_e115), _e117, _e120);
}

metal::float4 plateColor(
    thread metal::float2& cell_3,
    thread float& piece_3,
    constant Uniforms& uniforms
) {
    float c_1 = {};
    metal::float2 param_20 = {};
    metal::float4 local_2 = {};
    metal::float4 local_3 = {};
    metal::float2 _e71 = cell_3;
    param_20 = (_e71 * 1.3) + metal::float2(0.7);
    float _e75 = hash12(param_20);
    float _e78 = piece_3;
    float _e79 = metal::floor(_e75 * 3.0) + _e78;
    c_1 = _e79 - (metal::floor(_e79 / 3.0) * 3.0);
    float _e84 = c_1;
    if (_e84 < 0.5) {
        metal::float4 _e87 = uniforms.color1_;
        local_2 = _e87;
    } else {
        float _e88 = c_1;
        if (_e88 < 1.5) {
            metal::float4 _e91 = uniforms.color2_;
            local_3 = _e91;
        } else {
            metal::float4 _e93 = uniforms.color3_;
            local_3 = _e93;
        }
        metal::float4 _e94 = local_3;
        local_2 = _e94;
    }
    metal::float4 _e95 = local_2;
    return _e95;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e67 = uv[0u];
    float _e69 = uv[1u];
    metal::float4 _e72 = _to.sample(_sampler, metal::float2(_e67, 1.0 - _e69), metal::level(0.0));
    return _e72;
}

metal::float4 premultiplied(
    thread metal::float4& c_2
) {
    metal::float4 _e66 = c_2;
    float _e69 = c_2[3u];
    metal::float3 _e70 = _e66.xyz * _e69;
    float _e72 = c_2[3u];
    return metal::float4(_e70.x, _e70.y, _e70.z, _e72);
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e67 = uv_1[0u];
    float _e69 = uv_1[1u];
    metal::float4 _e72 = _from.sample(_sampler, metal::float2(_e67, 1.0 - _e69), metal::level(0.0));
    return _e72;
}

metal::float3 layerCover(
    thread metal::float2& p_2,
    thread metal::float2& cell_4,
    thread metal::float2& cs_2,
    thread float& piece_4,
    thread float& t_4
) {
    metal::float3 q_1 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float e = {};
    float m = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    metal::float2 param_28 = {};
    float param_29 = {};
    metal::float2 _e82 = p_2;
    param_21 = _e82;
    metal::float2 _e83 = cell_4;
    param_22 = _e83;
    metal::float2 _e84 = cs_2;
    param_23 = _e84;
    float _e85 = piece_4;
    param_24 = _e85;
    float _e86 = t_4;
    param_25 = _e86;
    metal::float3 _e87 = swingPoint(param_21, param_22, param_23, param_24, param_25);
    q_1 = _e87;
    float _e89 = q_1[2u];
    if (_e89 < 0.01) {
        return metal::float3(0.0, 0.0, 0.0);
    }
    float _e92 = cs_2[0u];
    float _e94 = cs_2[1u];
    float _e97 = q_1[2u];
    e = 0.002 / (metal::min(_e92, _e94) * _e97);
    metal::float3 _e100 = q_1;
    param_26 = _e100.xy;
    float _e102 = boxDist(param_26);
    float _e103 = e;
    metal::float3 _e107 = q_1;
    param_27 = _e107.xy;
    metal::float2 _e109 = cell_4;
    param_28 = _e109;
    float _e110 = piece_4;
    param_29 = _e110;
    float _e111 = pieceDist(param_27, param_28, param_29);
    float _e113 = e;
    m = metal::clamp((_e102 / _e103) + 0.5, 0.0, 1.0) * metal::clamp((-(_e111) / _e113) + 0.5, 0.0, 1.0);
    float _e118 = m;
    metal::float3 _e119 = q_1;
    metal::float2 _e123 = metal::clamp(_e119.xy, metal::float2(0.0), metal::float2(1.0));
    return metal::float3(_e118, _e123.x, _e123.y);
}

float spread_u0028_(
    constant Uniforms& uniforms
) {
    float _e66 = uniforms.stagger;
    return 0.61 * metal::clamp(_e66, 0.0, 1.0);
}

float startTime(
    thread metal::float2& cell_5,
    thread metal::float2& n,
    constant Uniforms& uniforms
) {
    float order = {};
    metal::float2 param_30 = {};
    float _e70 = cell_5[0u];
    float _e72 = n[1u];
    float _e75 = cell_5[1u];
    float _e79 = n[0u];
    float _e81 = n[1u];
    order = (_e70 + ((_e72 - 1.0) - _e75)) / metal::max((_e79 + _e81) - 2.0, 1.0);
    float _e86 = order;
    metal::float2 _e88 = cell_5;
    param_30 = _e88 + metal::float2(4.4);
    float _e91 = hash12(param_30);
    order = metal::clamp((_e86 * 0.75) + (0.25 * _e91), 0.0, 1.0);
    float _e95 = spread_u0028_(uniforms);
    float _e96 = order;
    return 0.06 + (_e95 * _e96);
}

float swing_u0028_(
    constant Uniforms& uniforms
) {
    float _e65 = spread_u0028_(uniforms);
    return 0.85 - _e65;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float kc = {};
    int local_4 = {};
    metal::float2 n_1 = {};
    metal::float2 local_5 = {};
    metal::float2 cs_3 = {};
    metal::float2 p_3 = {};
    metal::float2 cell0_ = {};
    float sw = {};
    metal::float2 l0_ = {};
    float t00_ = {};
    metal::float2 param_31 = {};
    metal::float2 param_32 = {};
    float sd0_ = {};
    metal::float2 param_33 = {};
    metal::float2 param_34 = {};
    float param_35 = {};
    float e0_ = {};
    float landed = {};
    float local_6 = {};
    float local_7 = {};
    metal::float4 top = {};
    metal::float4 topPos = {};
    metal::float4 und = {};
    metal::float4 undPos = {};
    int dy = {};
    int dx = {};
    metal::float2 cell_6 = {};
    float tc = {};
    metal::float2 param_36 = {};
    metal::float2 param_37 = {};
    int pc_1 = {};
    float piece_5 = {};
    float t0_ = {};
    float tp = {};
    int ly = {};
    float isPlate = {};
    float ts = {};
    float t_5 = {};
    metal::float3 L = {};
    metal::float2 param_38 = {};
    metal::float2 param_39 = {};
    metal::float2 param_40 = {};
    float param_41 = {};
    float param_42 = {};
    metal::float4 cur = {};
    metal::float4 curPos = {};
    float local_8 = {};
    metal::float4 c_3 = {};
    metal::float2 param_43 = {};
    metal::float4 param_44 = {};
    metal::float2 param_45 = {};
    metal::float4 param_46 = {};
    metal::float4 uc = {};
    metal::float4 local_9 = {};
    metal::float2 param_47 = {};
    float param_48 = {};
    metal::float2 param_49 = {};
    metal::float4 param_50 = {};
    metal::float4 tc_1 = {};
    metal::float4 local_10 = {};
    metal::float2 param_51 = {};
    float param_52 = {};
    metal::float2 param_53 = {};
    metal::float4 param_54 = {};
    float sh = {};
    int dy_1 = {};
    int dx_1 = {};
    metal::float2 cell_7 = {};
    float tc_2 = {};
    metal::float2 param_55 = {};
    metal::float2 param_56 = {};
    int pc_2 = {};
    float piece_6 = {};
    float t0_1 = {};
    float tp_1 = {};
    int ly_1 = {};
    float isPlate_1 = {};
    float ts_1 = {};
    float t_6 = {};
    metal::float2 param_57 = {};
    metal::float2 param_58 = {};
    metal::float2 param_59 = {};
    float param_60 = {};
    float param_61 = {};
    metal::float4 local_11 = {};
    bool phi_846_ = {};
    bool phi_855_ = {};
    bool phi_864_ = {};
    bool phi_918_ = {};
    bool phi_947_ = {};
    bool phi_1032_ = {};
    bool phi_1040_ = {};
    bool phi_1048_ = {};
    bool phi_1203_ = {};
    bool phi_1212_ = {};
    bool phi_1221_ = {};
    bool phi_1277_ = {};
    int _e152 = uniforms.cells;
    if (_e152 < 1) {
        local_4 = 1;
    } else {
        int _e155 = uniforms.cells;
        local_4 = _e155;
    }
    int _e156 = local_4;
    kc = static_cast<float>(_e156);
    float _e159 = uniforms.ratio;
    if (_e159 >= 1.0) {
        float _e162 = uniforms.ratio;
        float _e163 = kc;
        float _e168 = kc;
        local_5 = metal::float2(metal::max(1.0, metal::floor((_e162 * _e163) + 0.5)), _e168);
    } else {
        float _e170 = kc;
        float _e171 = kc;
        float _e173 = uniforms.ratio;
        local_5 = metal::float2(_e170, metal::max(1.0, metal::floor((_e171 / _e173) + 0.5)));
    }
    metal::float2 _e179 = local_5;
    n_1 = _e179;
    float _e181 = uniforms.ratio;
    metal::float2 _e183 = n_1;
    cs_3 = metal::float2(_e181, 1.0) / _e183;
    metal::float2 _e185 = uv_2;
    float _e187 = uniforms.ratio;
    p_3 = _e185 * metal::float2(_e187, 1.0);
    metal::float2 _e190 = p_3;
    metal::float2 _e191 = cs_3;
    cell0_ = metal::floor(_e190 / _e191);
    float _e194 = swing_u0028_(uniforms);
    sw = _e194;
    metal::float2 _e195 = p_3;
    metal::float2 _e196 = cs_3;
    metal::float2 _e198 = cell0_;
    l0_ = (_e195 / _e196) - _e198;
    metal::float2 _e200 = cell0_;
    param_31 = _e200;
    metal::float2 _e201 = n_1;
    param_32 = _e201;
    float _e202 = startTime(param_31, param_32, uniforms);
    t00_ = _e202;
    metal::float2 _e203 = l0_;
    param_33 = _e203;
    metal::float2 _e204 = cell0_;
    param_34 = _e204;
    param_35 = 0.0;
    float _e205 = pieceDist(param_33, param_34, param_35);
    sd0_ = _e205;
    float _e207 = cs_3[0u];
    float _e209 = cs_3[1u];
    e0_ = 0.002 / metal::min(_e207, _e209);
    float _e213 = uniforms.progress;
    float _e214 = t00_;
    float _e215 = sw;
    if (_e213 >= (_e214 + _e215)) {
        float _e218 = sd0_;
        float _e220 = e0_;
        local_6 = metal::clamp((-(_e218) / _e220) + 0.5, 0.0, 1.0);
    } else {
        local_6 = 0.0;
    }
    float _e224 = local_6;
    float _e226 = uniforms.progress;
    float _e227 = t00_;
    float _e229 = sw;
    if (_e226 >= ((_e227 + 0.07) + _e229)) {
        float _e232 = sd0_;
        float _e233 = e0_;
        local_7 = metal::clamp((_e232 / _e233) + 0.5, 0.0, 1.0);
    } else {
        local_7 = 0.0;
    }
    float _e237 = local_7;
    landed = _e224 + _e237;
    top = metal::float4(-1.0, 0.0, 0.0, 0.0);
    topPos = metal::float4(0.0, 0.0, 0.0, 0.0);
    und = metal::float4(-1.0, 0.0, 0.0, 0.0);
    undPos = metal::float4(0.0, 0.0, 0.0, 0.0);
    dy = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e381 = dy;
            dy = as_type<int>(as_type<uint>(_e381) + as_type<uint>(1));
        }
        loop_init = false;
        int _e239 = dy;
        if (_e239 <= 1) {
            dx = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e379 = dx;
                    dx = as_type<int>(as_type<uint>(_e379) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e241 = dx;
                if (_e241 <= 1) {
                    metal::float2 _e243 = cell0_;
                    int _e244 = dx;
                    int _e246 = dy;
                    cell_6 = _e243 + metal::float2(static_cast<float>(_e244), static_cast<float>(_e246));
                    float _e251 = cell_6[0u];
                    bool _e252 = _e251 < 0.0;
                    phi_846_ = _e252;
                    if (!(_e252)) {
                        float _e255 = cell_6[1u];
                        phi_846_ = _e255 < 0.0;
                    }
                    bool _e258 = phi_846_;
                    phi_855_ = _e258;
                    if (!(_e258)) {
                        float _e261 = cell_6[0u];
                        float _e263 = n_1[0u];
                        phi_855_ = _e261 >= _e263;
                    }
                    bool _e266 = phi_855_;
                    phi_864_ = _e266;
                    if (!(_e266)) {
                        float _e269 = cell_6[1u];
                        float _e271 = n_1[1u];
                        phi_864_ = _e269 >= _e271;
                    }
                    bool _e274 = phi_864_;
                    if (_e274) {
                        continue;
                    }
                    metal::float2 _e275 = cell_6;
                    param_36 = _e275;
                    metal::float2 _e276 = n_1;
                    param_37 = _e276;
                    float _e277 = startTime(param_36, param_37, uniforms);
                    tc = _e277;
                    pc_1 = 0;
                    uint2 loop_bound_2 = uint2(4294967295u);
                    bool loop_init_2 = true;
                    while(true) {
                        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
                        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
                        if (!loop_init_2) {
                            int _e377 = pc_1;
                            pc_1 = as_type<int>(as_type<uint>(_e377) + as_type<uint>(1));
                        }
                        loop_init_2 = false;
                        int _e278 = pc_1;
                        if (_e278 < 2) {
                            int _e280 = pc_1;
                            piece_5 = static_cast<float>(_e280);
                            float _e282 = tc;
                            float _e283 = piece_5;
                            t0_ = _e282 + (0.07 * _e283);
                            float _e287 = uniforms.progress;
                            float _e288 = t0_;
                            float _e290 = sw;
                            tp = (_e287 - _e288) / _e290;
                            ly = 0;
                            uint2 loop_bound_3 = uint2(4294967295u);
                            bool loop_init_3 = true;
                            while(true) {
                                if (metal::all(loop_bound_3 == uint2(0u))) { break; }
                                loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
                                if (!loop_init_3) {
                                    int _e375 = ly;
                                    ly = as_type<int>(as_type<uint>(_e375) + as_type<uint>(1));
                                }
                                loop_init_3 = false;
                                int _e292 = ly;
                                if (_e292 < 2) {
                                    int _e294 = ly;
                                    isPlate = (_e294 == 0) ? 1.0 : 0.0;
                                    float _e297 = isPlate;
                                    bool _e298 = _e297 > 0.5;
                                    phi_918_ = _e298;
                                    if (_e298) {
                                        int _e300 = uniforms.plates;
                                        phi_918_ = !((_e300 != 0));
                                    }
                                    bool _e304 = phi_918_;
                                    if (_e304) {
                                        continue;
                                    }
                                    float _e305 = t0_;
                                    float _e306 = isPlate;
                                    ts = _e305 - (0.06 * _e306);
                                    float _e310 = uniforms.progress;
                                    float _e311 = ts;
                                    float _e313 = sw;
                                    t_5 = (_e310 - _e311) / _e313;
                                    float _e315 = t_5;
                                    float _e317 = tp;
                                    bool _e319 = (_e315 <= 0.0) || (_e317 >= 1.0);
                                    phi_947_ = _e319;
                                    if (!(_e319)) {
                                        float _e321 = isPlate;
                                        float _e323 = tp;
                                        phi_947_ = (_e321 > 0.5) && (_e323 >= 0.8);
                                    }
                                    bool _e327 = phi_947_;
                                    if (_e327) {
                                        continue;
                                    }
                                    float _e328 = t_5;
                                    metal::float2 _e330 = p_3;
                                    param_38 = _e330;
                                    metal::float2 _e331 = cell_6;
                                    param_39 = _e331;
                                    metal::float2 _e332 = cs_3;
                                    param_40 = _e332;
                                    float _e333 = piece_5;
                                    param_41 = _e333;
                                    param_42 = metal::min(_e328, 1.0);
                                    metal::float3 _e334 = layerCover(param_38, param_39, param_40, param_41, param_42);
                                    L = _e334;
                                    float _e335 = isPlate;
                                    if (_e335 > 0.5) {
                                        float _e337 = tp;
                                        float _e341 = L[0u];
                                        L[0u] = _e341 * (1.0 - metal::smoothstep(0.7, 0.8, _e337));
                                    }
                                    float _e345 = L[0u];
                                    if (_e345 <= 0.0) {
                                        continue;
                                    }
                                    float _e347 = ts;
                                    float _e349 = L[0u];
                                    float _e350 = isPlate;
                                    float _e351 = piece_5;
                                    cur = metal::float4(_e347, _e349, _e350, _e351);
                                    metal::float2 _e353 = cell_6;
                                    metal::float3 _e354 = L;
                                    metal::float2 _e355 = _e354.yz;
                                    curPos = metal::float4(_e353.x, _e353.y, _e355.x, _e355.y);
                                    float _e361 = ts;
                                    float _e363 = top[0u];
                                    if (_e361 > _e363) {
                                        metal::float4 _e365 = top;
                                        und = _e365;
                                        metal::float4 _e366 = topPos;
                                        undPos = _e366;
                                        metal::float4 _e367 = cur;
                                        top = _e367;
                                        metal::float4 _e368 = curPos;
                                        topPos = _e368;
                                    } else {
                                        float _e369 = ts;
                                        float _e371 = und[0u];
                                        if (_e369 > _e371) {
                                            metal::float4 _e373 = cur;
                                            und = _e373;
                                            metal::float4 _e374 = curPos;
                                            undPos = _e374;
                                        }
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
    float _e384 = top[2u];
    bool _e385 = _e384 < 0.5;
    phi_1032_ = _e385;
    if (_e385) {
        float _e387 = und[0u];
        phi_1032_ = _e387 < 0.0;
    }
    bool _e390 = phi_1032_;
    phi_1040_ = _e390;
    if (_e390) {
        float _e392 = topPos[0u];
        float _e394 = cell0_[0u];
        phi_1040_ = _e392 == _e394;
    }
    bool _e397 = phi_1040_;
    phi_1048_ = _e397;
    if (_e397) {
        float _e399 = topPos[1u];
        float _e401 = cell0_[1u];
        phi_1048_ = _e399 == _e401;
    }
    bool _e404 = phi_1048_;
    if (_e404) {
        float _e406 = top[1u];
        if (_e406 < 1.0) {
            float _e408 = landed;
            float _e410 = top[1u];
            local_8 = _e408 / (1.0 - _e410);
        } else {
            local_8 = 1.0;
        }
        float _e413 = local_8;
        landed = _e413;
    }
    metal::float2 _e414 = uv_2;
    param_43 = _e414;
    metal::float4 _e415 = getFromColor(param_43, _from, _sampler);
    param_44 = _e415;
    metal::float4 _e416 = premultiplied(param_44);
    metal::float2 _e417 = uv_2;
    param_45 = _e417;
    metal::float4 _e418 = getToColor(param_45, _sampler, _to);
    param_46 = _e418;
    metal::float4 _e419 = premultiplied(param_46);
    float _e420 = landed;
    c_3 = metal::mix(_e416, _e419, metal::float4(metal::clamp(_e420, 0.0, 1.0)));
    float _e425 = und[0u];
    if (_e425 >= 0.0) {
        float _e428 = und[2u];
        if (_e428 > 0.5) {
            metal::float4 _e430 = undPos;
            param_47 = _e430.xy;
            float _e433 = und[3u];
            param_48 = _e433;
            metal::float4 _e434 = plateColor(param_47, param_48, uniforms);
            local_9 = _e434;
        } else {
            metal::float4 _e435 = undPos;
            metal::float4 _e437 = undPos;
            metal::float2 _e440 = cs_3;
            float _e443 = uniforms.ratio;
            param_49 = ((_e435.xy + _e437.zw) * _e440) / metal::float2(_e443, 1.0);
            metal::float4 _e446 = getToColor(param_49, _sampler, _to);
            local_9 = _e446;
        }
        metal::float4 _e447 = local_9;
        uc = _e447;
        metal::float4 _e448 = c_3;
        metal::float4 _e449 = uc;
        param_50 = _e449;
        metal::float4 _e450 = premultiplied(param_50);
        float _e452 = und[1u];
        c_3 = metal::mix(_e448, _e450, metal::float4(_e452));
    }
    float _e456 = top[0u];
    if (_e456 >= 0.0) {
        float _e459 = top[2u];
        if (_e459 > 0.5) {
            metal::float4 _e461 = topPos;
            param_51 = _e461.xy;
            float _e464 = top[3u];
            param_52 = _e464;
            metal::float4 _e465 = plateColor(param_51, param_52, uniforms);
            local_10 = _e465;
        } else {
            metal::float4 _e466 = topPos;
            metal::float4 _e468 = topPos;
            metal::float2 _e471 = cs_3;
            float _e474 = uniforms.ratio;
            param_53 = ((_e466.xy + _e468.zw) * _e471) / metal::float2(_e474, 1.0);
            metal::float4 _e477 = getToColor(param_53, _sampler, _to);
            local_10 = _e477;
        }
        metal::float4 _e478 = local_10;
        tc_1 = _e478;
        metal::float4 _e479 = c_3;
        metal::float4 _e480 = tc_1;
        param_54 = _e480;
        metal::float4 _e481 = premultiplied(param_54);
        float _e483 = top[1u];
        c_3 = metal::mix(_e479, _e481, metal::float4(_e483));
    }
    sh = 0.0;
    float _e487 = uniforms.shadow;
    if (_e487 > 0.0) {
        dy_1 = -1;
        uint2 loop_bound_4 = uint2(4294967295u);
        bool loop_init_4 = true;
        while(true) {
            if (metal::all(loop_bound_4 == uint2(0u))) { break; }
            loop_bound_4 -= uint2(loop_bound_4.y == 0u, 1u);
            if (!loop_init_4) {
                int _e592 = dy_1;
                dy_1 = as_type<int>(as_type<uint>(_e592) + as_type<uint>(1));
            }
            loop_init_4 = false;
            int _e489 = dy_1;
            if (_e489 <= 1) {
                dx_1 = -1;
                uint2 loop_bound_5 = uint2(4294967295u);
                bool loop_init_5 = true;
                while(true) {
                    if (metal::all(loop_bound_5 == uint2(0u))) { break; }
                    loop_bound_5 -= uint2(loop_bound_5.y == 0u, 1u);
                    if (!loop_init_5) {
                        int _e590 = dx_1;
                        dx_1 = as_type<int>(as_type<uint>(_e590) + as_type<uint>(1));
                    }
                    loop_init_5 = false;
                    int _e491 = dx_1;
                    if (_e491 <= 1) {
                        metal::float2 _e493 = cell0_;
                        int _e494 = dx_1;
                        int _e496 = dy_1;
                        cell_7 = _e493 + metal::float2(static_cast<float>(_e494), static_cast<float>(_e496));
                        float _e501 = cell_7[0u];
                        bool _e502 = _e501 < 0.0;
                        phi_1203_ = _e502;
                        if (!(_e502)) {
                            float _e505 = cell_7[1u];
                            phi_1203_ = _e505 < 0.0;
                        }
                        bool _e508 = phi_1203_;
                        phi_1212_ = _e508;
                        if (!(_e508)) {
                            float _e511 = cell_7[0u];
                            float _e513 = n_1[0u];
                            phi_1212_ = _e511 >= _e513;
                        }
                        bool _e516 = phi_1212_;
                        phi_1221_ = _e516;
                        if (!(_e516)) {
                            float _e519 = cell_7[1u];
                            float _e521 = n_1[1u];
                            phi_1221_ = _e519 >= _e521;
                        }
                        bool _e524 = phi_1221_;
                        if (_e524) {
                            continue;
                        }
                        metal::float2 _e525 = cell_7;
                        param_55 = _e525;
                        metal::float2 _e526 = n_1;
                        param_56 = _e526;
                        float _e527 = startTime(param_55, param_56, uniforms);
                        tc_2 = _e527;
                        pc_2 = 0;
                        uint2 loop_bound_6 = uint2(4294967295u);
                        bool loop_init_6 = true;
                        while(true) {
                            if (metal::all(loop_bound_6 == uint2(0u))) { break; }
                            loop_bound_6 -= uint2(loop_bound_6.y == 0u, 1u);
                            if (!loop_init_6) {
                                int _e588 = pc_2;
                                pc_2 = as_type<int>(as_type<uint>(_e588) + as_type<uint>(1));
                            }
                            loop_init_6 = false;
                            int _e528 = pc_2;
                            if (_e528 < 2) {
                                int _e530 = pc_2;
                                piece_6 = static_cast<float>(_e530);
                                float _e532 = tc_2;
                                float _e533 = piece_6;
                                t0_1 = _e532 + (0.07 * _e533);
                                float _e537 = uniforms.progress;
                                float _e538 = t0_1;
                                float _e540 = sw;
                                tp_1 = (_e537 - _e538) / _e540;
                                ly_1 = 0;
                                uint2 loop_bound_7 = uint2(4294967295u);
                                bool loop_init_7 = true;
                                while(true) {
                                    if (metal::all(loop_bound_7 == uint2(0u))) { break; }
                                    loop_bound_7 -= uint2(loop_bound_7.y == 0u, 1u);
                                    if (!loop_init_7) {
                                        int _e586 = ly_1;
                                        ly_1 = as_type<int>(as_type<uint>(_e586) + as_type<uint>(1));
                                    }
                                    loop_init_7 = false;
                                    int _e542 = ly_1;
                                    if (_e542 < 2) {
                                        int _e544 = ly_1;
                                        isPlate_1 = (_e544 == 0) ? 1.0 : 0.0;
                                        float _e547 = isPlate_1;
                                        bool _e548 = _e547 > 0.5;
                                        phi_1277_ = _e548;
                                        if (_e548) {
                                            int _e550 = uniforms.plates;
                                            float _e553 = tp_1;
                                            phi_1277_ = !((_e550 != 0)) || (_e553 >= 0.8);
                                        }
                                        bool _e557 = phi_1277_;
                                        if (_e557) {
                                            continue;
                                        }
                                        float _e558 = t0_1;
                                        float _e559 = isPlate_1;
                                        ts_1 = _e558 - (0.06 * _e559);
                                        float _e563 = uniforms.progress;
                                        float _e564 = ts_1;
                                        float _e566 = sw;
                                        t_6 = (_e563 - _e564) / _e566;
                                        float _e568 = ts_1;
                                        float _e570 = top[0u];
                                        float _e572 = t_6;
                                        float _e575 = t_6;
                                        if (((_e568 <= _e570) || (_e572 <= 0.0)) || (_e575 >= 1.0)) {
                                            continue;
                                        }
                                        float _e578 = sh;
                                        metal::float2 _e579 = p_3;
                                        param_57 = _e579;
                                        metal::float2 _e580 = cell_7;
                                        param_58 = _e580;
                                        metal::float2 _e581 = cs_3;
                                        param_59 = _e581;
                                        float _e582 = piece_6;
                                        param_60 = _e582;
                                        float _e583 = t_6;
                                        param_61 = _e583;
                                        float _e584 = layerShadow(param_57, param_58, param_59, param_60, param_61);
                                        sh = metal::max(_e578, _e584);
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
    float _e595 = uniforms.shadow;
    float _e598 = sh;
    metal::float4 _e601 = c_3;
    metal::float3 _e603 = _e601.xyz * (1.0 - ((0.7 * metal::clamp(_e595, 0.0, 1.0)) * _e598));
    c_3[0u] = _e603.x;
    c_3[1u] = _e603.y;
    c_3[2u] = _e603.z;
    float _e611 = c_3[3u];
    if (_e611 > 0.0) {
        metal::float4 _e613 = c_3;
        float _e616 = c_3[3u];
        metal::float3 _e618 = _e613.xyz / metal::float3(_e616);
        float _e620 = c_3[3u];
        local_11 = metal::float4(_e618.x, _e618.y, _e618.z, _e620);
    } else {
        local_11 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e625 = local_11;
    return _e625;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_62 = {};
    metal::float2 _e66 = _uv_1;
    param_62 = _e66;
    metal::float4 _e67 = transition(param_62, _from, _sampler, _to, uniforms);
    _fragColor = _e67;
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
