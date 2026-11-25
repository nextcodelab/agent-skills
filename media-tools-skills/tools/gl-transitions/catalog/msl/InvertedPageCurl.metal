// InvertedPageCurl — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InvertedPageCurl.glsl
// Author: Hewlett-Packard
// License: BSD 3 Clause
// Description: The outgoing image curls away like a page, revealing the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

float distanceToEdge(
    thread metal::float3& point
) {
    float dx = {};
    float local = {};
    float dy = {};
    float local_1 = {};
    bool phi_222_ = {};
    bool phi_234_ = {};
    bool phi_235_ = {};
    float _e52 = point[0u];
    if (_e52 > 0.5) {
        float _e55 = point[0u];
        local = 1.0 - _e55;
    } else {
        float _e58 = point[0u];
        local = _e58;
    }
    float _e59 = local;
    dx = metal::abs(_e59);
    float _e62 = point[1u];
    if (_e62 > 0.5) {
        float _e65 = point[1u];
        local_1 = 1.0 - _e65;
    } else {
        float _e68 = point[1u];
        local_1 = _e68;
    }
    float _e69 = local_1;
    dy = metal::abs(_e69);
    float _e72 = point[0u];
    if (_e72 < 0.0) {
        float _e75 = point[0u];
        dx = -(_e75);
    }
    float _e78 = point[0u];
    if (_e78 > 1.0) {
        float _e81 = point[0u];
        dx = _e81 - 1.0;
    }
    float _e84 = point[1u];
    if (_e84 < 0.0) {
        float _e87 = point[1u];
        dy = -(_e87);
    }
    float _e90 = point[1u];
    if (_e90 > 1.0) {
        float _e93 = point[1u];
        dy = _e93 - 1.0;
    }
    float _e96 = point[0u];
    bool _e97 = _e96 < 0.0;
    phi_222_ = _e97;
    if (!(_e97)) {
        float _e100 = point[0u];
        phi_222_ = _e100 > 1.0;
    }
    bool _e103 = phi_222_;
    phi_235_ = _e103;
    if (_e103) {
        float _e105 = point[1u];
        bool _e106 = _e105 < 0.0;
        phi_234_ = _e106;
        if (!(_e106)) {
            float _e109 = point[1u];
            phi_234_ = _e109 > 1.0;
        }
        bool _e112 = phi_234_;
        phi_235_ = _e112;
    }
    bool _e114 = phi_235_;
    if (_e114) {
        float _e115 = dx;
        float _e116 = dx;
        float _e118 = dy;
        float _e119 = dy;
        return metal::sqrt((_e115 * _e116) + (_e118 * _e119));
    }
    float _e123 = dx;
    float _e124 = dy;
    return metal::min(_e123, _e124);
}

metal::float4 antiAlias(
    thread metal::float4& color1_,
    thread metal::float4& color2_,
    thread float& distanc
) {
    float dd = {};
    float _e50 = distanc;
    distanc = _e50 * 512.0;
    float _e52 = distanc;
    if (_e52 < 0.0) {
        metal::float4 _e54 = color2_;
        return _e54;
    }
    float _e55 = distanc;
    if (_e55 > 2.0) {
        metal::float4 _e57 = color1_;
        return _e57;
    }
    float _e58 = distanc;
    dd = metal::pow(1.0 - (_e58 / 2.0), 3.0);
    metal::float4 _e62 = color2_;
    metal::float4 _e63 = color1_;
    float _e65 = dd;
    metal::float4 _e67 = color1_;
    return ((_e62 - _e63) * _e65) + _e67;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e48 = uv[0u];
    float _e50 = uv[1u];
    metal::float4 _e53 = _to.sample(_sampler, metal::float2(_e48, 1.0 - _e50), metal::level(0.0));
    return _e53;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e48 = uv_1[0u];
    float _e50 = uv_1[1u];
    metal::float4 _e53 = _from.sample(_sampler, metal::float2(_e48, 1.0 - _e50), metal::level(0.0));
    return _e53;
}

metal::float4 backside(
    thread float& yc,
    thread metal::float3& point_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    metal::float4 color = {};
    metal::float2 param = {};
    float gray = {};
    metal::float3 _e51 = point_1;
    param = _e51.xy;
    metal::float4 _e53 = getFromColor(param, _from, _sampler);
    color = _e53;
    float _e55 = color[0u];
    float _e57 = color[2u];
    float _e60 = color[1u];
    gray = ((_e55 + _e57) + _e60) / 15.0;
    float _e63 = yc;
    float _e72 = gray;
    gray = _e72 + (0.8 * ((metal::pow(metal::max(0.0, 1.0 - metal::abs(_e63 / 0.15915494)), 0.2) / 2.0) + 0.5));
    float _e74 = gray;
    metal::float3 _e75 = metal::float3(_e74);
    color[0u] = _e75.x;
    color[1u] = _e75.y;
    color[2u] = _e75.z;
    metal::float4 _e82 = color;
    return _e82;
}

metal::float3 hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b(
    thread float& hitAngle,
    thread float& yc_1,
    thread metal::float3& point_2,
    thread metal::float3x3& rrotation
) {
    float hitPoint = {};
    float _e51 = hitAngle;
    hitPoint = _e51 / 6.2831855;
    float _e53 = hitPoint;
    point_2[1u] = _e53;
    metal::float3x3 _e55 = rrotation;
    metal::float3 _e56 = point_2;
    return _e55 * _e56;
}

metal::float4 seeThrough(
    thread float& yc_2,
    thread metal::float2& p,
    thread metal::float3x3& rotation,
    thread metal::float3x3& rrotation_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    thread float& cylinderAngle
) {
    float hitAngle_1 = {};
    metal::float3 point_3 = {};
    float param_1 = {};
    float param_2 = {};
    metal::float3 param_3 = {};
    metal::float3x3 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float4 color_1 = {};
    metal::float2 param_7 = {};
    metal::float4 tcolor = {};
    metal::float3 param_8 = {};
    metal::float4 param_9 = {};
    metal::float4 param_10 = {};
    float param_11 = {};
    bool phi_293_ = {};
    bool phi_300_ = {};
    bool phi_307_ = {};
    bool phi_308_ = {};
    float _e65 = yc_2;
    float _e69 = cylinderAngle;
    hitAngle_1 = 3.1415927 - (metal::acos(metal::clamp(_e65 / 0.15915494, -1.0, 1.0)) - _e69);
    metal::float3x3 _e72 = rotation;
    metal::float2 _e73 = p;
    float _e78 = hitAngle_1;
    param_1 = _e78;
    float _e79 = yc_2;
    param_2 = _e79;
    param_3 = _e72 * metal::float3(_e73.x, _e73.y, 1.0);
    metal::float3x3 _e80 = rrotation_1;
    param_4 = _e80;
    metal::float3 _e81 = hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b(param_1, param_2, param_3, param_4);
    point_3 = _e81;
    float _e82 = yc_2;
    bool _e83 = _e82 <= 0.0;
    phi_308_ = _e83;
    if (_e83) {
        float _e85 = point_3[0u];
        bool _e86 = _e85 < 0.0;
        phi_293_ = _e86;
        if (!(_e86)) {
            float _e89 = point_3[1u];
            phi_293_ = _e89 < 0.0;
        }
        bool _e92 = phi_293_;
        phi_300_ = _e92;
        if (!(_e92)) {
            float _e95 = point_3[0u];
            phi_300_ = _e95 > 1.0;
        }
        bool _e98 = phi_300_;
        phi_307_ = _e98;
        if (!(_e98)) {
            float _e101 = point_3[1u];
            phi_307_ = _e101 > 1.0;
        }
        bool _e104 = phi_307_;
        phi_308_ = _e104;
    }
    bool _e106 = phi_308_;
    if (_e106) {
        metal::float2 _e107 = p;
        param_5 = _e107;
        metal::float4 _e108 = getToColor(param_5, _sampler, _to);
        return _e108;
    }
    float _e109 = yc_2;
    if (_e109 > 0.0) {
        metal::float2 _e111 = p;
        param_6 = _e111;
        metal::float4 _e112 = getFromColor(param_6, _from, _sampler);
        return _e112;
    }
    metal::float3 _e113 = point_3;
    param_7 = _e113.xy;
    metal::float4 _e115 = getFromColor(param_7, _from, _sampler);
    color_1 = _e115;
    tcolor = metal::float4(0.0, 0.0, 0.0, 0.0);
    metal::float3 _e116 = point_3;
    param_8 = _e116;
    float _e117 = distanceToEdge(param_8);
    metal::float4 _e118 = color_1;
    param_9 = _e118;
    metal::float4 _e119 = tcolor;
    param_10 = _e119;
    param_11 = _e117;
    metal::float4 _e120 = antiAlias(param_9, param_10, param_11);
    return _e120;
}

metal::float4 seeThroughWithShadow(
    thread float& yc_3,
    thread metal::float2& p_1,
    thread metal::float3& point_4,
    thread metal::float3x3& rotation_1,
    thread metal::float3x3& rrotation_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    thread float& cylinderAngle,
    thread float& amount
) {
    float shadow = {};
    metal::float3 param_12 = {};
    metal::float4 shadowColor = {};
    float param_13 = {};
    metal::float2 param_14 = {};
    metal::float3x3 param_15 = {};
    metal::float3x3 param_16 = {};
    metal::float3 _e58 = point_4;
    param_12 = _e58;
    float _e59 = distanceToEdge(param_12);
    shadow = _e59 * 30.0;
    float _e61 = shadow;
    shadow = (1.0 - _e61) / 3.0;
    float _e64 = shadow;
    if (_e64 < 0.0) {
        shadow = 0.0;
    } else {
        float _e66 = amount;
        float _e67 = shadow;
        shadow = _e67 * _e66;
    }
    float _e69 = yc_3;
    param_13 = _e69;
    metal::float2 _e70 = p_1;
    param_14 = _e70;
    metal::float3x3 _e71 = rotation_1;
    param_15 = _e71;
    metal::float3x3 _e72 = rrotation_2;
    param_16 = _e72;
    metal::float4 _e73 = seeThrough(param_13, param_14, param_15, param_16, _from, _sampler, _to, cylinderAngle);
    shadowColor = _e73;
    float _e74 = shadow;
    float _e76 = shadowColor[0u];
    shadowColor[0u] = _e76 - _e74;
    float _e79 = shadow;
    float _e81 = shadowColor[1u];
    shadowColor[1u] = _e81 - _e79;
    float _e84 = shadow;
    float _e86 = shadowColor[2u];
    shadowColor[2u] = _e86 - _e84;
    metal::float4 _e89 = shadowColor;
    return _e89;
}

metal::float4 behindSurface(
    thread metal::float2& p_2,
    thread float& yc_4,
    thread metal::float3& point_5,
    thread metal::float3x3& rrotation_3,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    thread float& cylinderAngle,
    thread float& amount
) {
    float safeAmount = {};
    float local_2 = {};
    float shado = {};
    float hitAngle_2 = {};
    float param_17 = {};
    float param_18 = {};
    metal::float3 param_19 = {};
    metal::float3x3 param_20 = {};
    float dx_1 = {};
    float dy_1 = {};
    float nyc = {};
    metal::float4 to = {};
    metal::float2 param_21 = {};
    bool phi_487_ = {};
    bool phi_493_ = {};
    bool phi_499_ = {};
    bool phi_505_ = {};
    bool phi_513_ = {};
    float _e63 = amount;
    if (_e63 >= 0.0) {
        float _e65 = amount;
        local_2 = metal::max(_e65, 0.0001);
    } else {
        float _e67 = amount;
        local_2 = metal::min(_e67, -0.0001);
    }
    float _e69 = local_2;
    safeAmount = _e69;
    float _e70 = yc_4;
    float _e72 = safeAmount;
    shado = (1.0 - (((-0.15915494 - _e70) / _e72) * 7.0)) / 6.0;
    float _e78 = point_5[0u];
    float _e82 = shado;
    shado = _e82 * (1.0 - metal::abs(_e78 - 0.5));
    float _e84 = yc_4;
    yc_4 = -0.31830987 - _e84;
    float _e86 = yc_4;
    float _e90 = cylinderAngle;
    hitAngle_2 = (metal::acos(metal::clamp(_e86 / 0.15915494, -1.0, 1.0)) + _e90) - 3.1415927;
    float _e93 = hitAngle_2;
    param_17 = _e93;
    float _e94 = yc_4;
    param_18 = _e94;
    metal::float3 _e95 = point_5;
    param_19 = _e95;
    metal::float3x3 _e96 = rrotation_3;
    param_20 = _e96;
    metal::float3 _e97 = hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b(param_17, param_18, param_19, param_20);
    point_5 = _e97;
    float _e98 = yc_4;
    bool _e99 = _e98 < 0.0;
    phi_487_ = _e99;
    if (_e99) {
        float _e101 = point_5[0u];
        phi_487_ = _e101 >= 0.0;
    }
    bool _e104 = phi_487_;
    phi_493_ = _e104;
    if (_e104) {
        float _e106 = point_5[1u];
        phi_493_ = _e106 >= 0.0;
    }
    bool _e109 = phi_493_;
    phi_499_ = _e109;
    if (_e109) {
        float _e111 = point_5[0u];
        phi_499_ = _e111 <= 1.0;
    }
    bool _e114 = phi_499_;
    phi_505_ = _e114;
    if (_e114) {
        float _e116 = point_5[1u];
        phi_505_ = _e116 <= 1.0;
    }
    bool _e119 = phi_505_;
    phi_513_ = _e119;
    if (_e119) {
        float _e120 = hitAngle_2;
        float _e122 = amount;
        phi_513_ = (_e120 < 3.1415927) || (_e122 > 0.5);
    }
    bool _e126 = phi_513_;
    if (_e126) {
        float _e128 = point_5[0u];
        dx_1 = _e128 - 0.5;
        float _e131 = point_5[1u];
        dy_1 = _e131 - 0.5;
        float _e133 = dx_1;
        float _e134 = dx_1;
        float _e136 = dy_1;
        float _e137 = dy_1;
        shado = 1.0 - (metal::sqrt((_e133 * _e134) + (_e136 * _e137)) / 0.71);
        float _e143 = yc_4;
        nyc = -(_e143) / 0.15915494;
        float _e146 = nyc;
        float _e147 = nyc;
        float _e149 = nyc;
        float _e151 = shado;
        shado = _e151 * ((_e146 * _e147) * _e149);
        float _e153 = shado;
        shado = _e153 * 0.5;
    } else {
        shado = 0.0;
    }
    metal::float2 _e155 = p_2;
    param_21 = _e155;
    metal::float4 _e156 = getToColor(param_21, _sampler, _to);
    to = _e156;
    metal::float4 _e157 = to;
    float _e159 = shado;
    metal::float3 _e161 = _e157.xyz - metal::float3(_e159);
    float _e163 = to[3u];
    return metal::float4(_e161.x, _e161.y, _e161.z, _e163);
}

metal::float4 transition(
    thread metal::float2& p_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    thread float& cylinderAngle,
    thread float& amount,
    constant Uniforms& uniforms,
    thread float& cylinderCenter
) {
    float c = {};
    float s = {};
    metal::float3x3 rotation_2 = {};
    metal::float3x3 rrotation_4 = {};
    metal::float3 point_6 = {};
    float yc_5 = {};
    metal::float2 param_22 = {};
    float param_23 = {};
    metal::float3 param_24 = {};
    metal::float3x3 param_25 = {};
    metal::float2 param_26 = {};
    float hitAngle_3 = {};
    float hitAngleMod = {};
    float param_27 = {};
    metal::float2 param_28 = {};
    metal::float3x3 param_29 = {};
    metal::float3x3 param_30 = {};
    float param_31 = {};
    float param_32 = {};
    metal::float3 param_33 = {};
    metal::float3x3 param_34 = {};
    float param_35 = {};
    metal::float2 param_36 = {};
    metal::float3 param_37 = {};
    metal::float3x3 param_38 = {};
    metal::float3x3 param_39 = {};
    metal::float4 color_2 = {};
    float param_40 = {};
    metal::float3 param_41 = {};
    float dx2_ = {};
    float dy2_ = {};
    float shado_1 = {};
    float nyc2_ = {};
    metal::float4 otherColor = {};
    metal::float2 param_42 = {};
    metal::float2 param_43 = {};
    metal::float4 param_44 = {};
    metal::float4 param_45 = {};
    float param_46 = {};
    metal::float4 cl = {};
    float param_47 = {};
    metal::float2 param_48 = {};
    metal::float3 param_49 = {};
    metal::float3x3 param_50 = {};
    metal::float3x3 param_51 = {};
    float dist = {};
    metal::float3 param_52 = {};
    metal::float4 param_53 = {};
    metal::float4 param_54 = {};
    float param_55 = {};
    bool phi_670_ = {};
    bool phi_701_ = {};
    bool phi_708_ = {};
    bool phi_715_ = {};
    float _e98 = uniforms.progress;
    amount = (_e98 * 1.66) + -0.16;
    float _e101 = amount;
    cylinderCenter = _e101;
    float _e102 = amount;
    cylinderAngle = 6.2831855 * _e102;
    c = -0.17364818;
    s = -0.9848077;
    float _e104 = c;
    float _e105 = s;
    float _e106 = s;
    float _e108 = c;
    rotation_2 = metal::float3x3(metal::float3(_e104, _e105, 0.0), metal::float3(-(_e106), _e108, 0.0), metal::float3(-0.801, 0.89, 1.0));
    c = -0.17364818;
    s = 0.9848077;
    float _e113 = c;
    float _e114 = s;
    float _e115 = s;
    float _e117 = c;
    rrotation_4 = metal::float3x3(metal::float3(_e113, _e114, 0.0), metal::float3(-(_e115), _e117, 0.0), metal::float3(0.985, 0.985, 1.0));
    metal::float3x3 _e122 = rotation_2;
    metal::float2 _e123 = p_3;
    point_6 = _e122 * metal::float3(_e123.x, _e123.y, 1.0);
    float _e129 = point_6[1u];
    float _e130 = cylinderCenter;
    yc_5 = _e129 - _e130;
    float _e132 = yc_5;
    if (_e132 < -0.15915494) {
        metal::float2 _e134 = p_3;
        param_22 = _e134;
        float _e135 = yc_5;
        param_23 = _e135;
        metal::float3 _e136 = point_6;
        param_24 = _e136;
        metal::float3x3 _e137 = rrotation_4;
        param_25 = _e137;
        metal::float4 _e138 = behindSurface(param_22, param_23, param_24, param_25, _sampler, _to, cylinderAngle, amount);
        return _e138;
    }
    float _e139 = yc_5;
    if (_e139 > 0.15915494) {
        metal::float2 _e141 = p_3;
        param_26 = _e141;
        metal::float4 _e142 = getFromColor(param_26, _from, _sampler);
        return _e142;
    }
    float _e143 = yc_5;
    float _e147 = cylinderAngle;
    hitAngle_3 = (metal::acos(metal::clamp(_e143 / 0.15915494, -1.0, 1.0)) + _e147) - 3.1415927;
    float _e150 = hitAngle_3;
    hitAngleMod = _e150 - (metal::floor(_e150 / 6.2831855) * 6.2831855);
    float _e155 = hitAngleMod;
    float _e157 = amount;
    bool _e159 = (_e155 > 3.1415927) && (_e157 < 0.5);
    phi_670_ = _e159;
    if (!(_e159)) {
        float _e161 = hitAngleMod;
        float _e163 = amount;
        phi_670_ = (_e161 > 1.5707964) && (_e163 < 0.0);
    }
    bool _e167 = phi_670_;
    if (_e167) {
        float _e168 = yc_5;
        param_27 = _e168;
        metal::float2 _e169 = p_3;
        param_28 = _e169;
        metal::float3x3 _e170 = rotation_2;
        param_29 = _e170;
        metal::float3x3 _e171 = rrotation_4;
        param_30 = _e171;
        metal::float4 _e172 = seeThrough(param_27, param_28, param_29, param_30, _from, _sampler, _to, cylinderAngle);
        return _e172;
    }
    float _e173 = hitAngle_3;
    param_31 = _e173;
    float _e174 = yc_5;
    param_32 = _e174;
    metal::float3 _e175 = point_6;
    param_33 = _e175;
    metal::float3x3 _e176 = rrotation_4;
    param_34 = _e176;
    metal::float3 _e177 = hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b(param_31, param_32, param_33, param_34);
    point_6 = _e177;
    float _e179 = point_6[0u];
    bool _e180 = _e179 < 0.0;
    phi_701_ = _e180;
    if (!(_e180)) {
        float _e183 = point_6[1u];
        phi_701_ = _e183 < 0.0;
    }
    bool _e186 = phi_701_;
    phi_708_ = _e186;
    if (!(_e186)) {
        float _e189 = point_6[0u];
        phi_708_ = _e189 > 1.0;
    }
    bool _e192 = phi_708_;
    phi_715_ = _e192;
    if (!(_e192)) {
        float _e195 = point_6[1u];
        phi_715_ = _e195 > 1.0;
    }
    bool _e198 = phi_715_;
    if (_e198) {
        float _e199 = yc_5;
        param_35 = _e199;
        metal::float2 _e200 = p_3;
        param_36 = _e200;
        metal::float3 _e201 = point_6;
        param_37 = _e201;
        metal::float3x3 _e202 = rotation_2;
        param_38 = _e202;
        metal::float3x3 _e203 = rrotation_4;
        param_39 = _e203;
        metal::float4 _e204 = seeThroughWithShadow(param_35, param_36, param_37, param_38, param_39, _from, _sampler, _to, cylinderAngle, amount);
        return _e204;
    }
    float _e205 = yc_5;
    param_40 = _e205;
    metal::float3 _e206 = point_6;
    param_41 = _e206;
    metal::float4 _e207 = backside(param_40, param_41, _from, _sampler);
    color_2 = _e207;
    float _e208 = yc_5;
    if (_e208 < 0.0) {
        float _e211 = point_6[0u];
        dx2_ = _e211 - 0.5;
        float _e214 = point_6[1u];
        dy2_ = _e214 - 0.5;
        float _e216 = dx2_;
        float _e217 = dx2_;
        float _e219 = dy2_;
        float _e220 = dy2_;
        shado_1 = 1.0 - (metal::sqrt((_e216 * _e217) + (_e219 * _e220)) / 0.71);
        float _e226 = yc_5;
        nyc2_ = -(_e226) / 0.15915494;
        float _e229 = nyc2_;
        float _e230 = nyc2_;
        float _e232 = nyc2_;
        float _e234 = shado_1;
        shado_1 = _e234 * ((_e229 * _e230) * _e232);
        float _e236 = shado_1;
        shado_1 = _e236 * 0.5;
        float _e238 = shado_1;
        metal::float2 _e239 = p_3;
        param_42 = _e239;
        metal::float4 _e240 = getToColor(param_42, _sampler, _to);
        otherColor = metal::float4(0.0, 0.0, 0.0, _e238 * _e240.w);
    } else {
        metal::float2 _e244 = p_3;
        param_43 = _e244;
        metal::float4 _e245 = getFromColor(param_43, _from, _sampler);
        otherColor = _e245;
    }
    float _e246 = yc_5;
    metal::float4 _e249 = color_2;
    param_44 = _e249;
    metal::float4 _e250 = otherColor;
    param_45 = _e250;
    param_46 = 0.15915494 - metal::abs(_e246);
    metal::float4 _e251 = antiAlias(param_44, param_45, param_46);
    color_2 = _e251;
    float _e252 = yc_5;
    param_47 = _e252;
    metal::float2 _e253 = p_3;
    param_48 = _e253;
    metal::float3 _e254 = point_6;
    param_49 = _e254;
    metal::float3x3 _e255 = rotation_2;
    param_50 = _e255;
    metal::float3x3 _e256 = rrotation_4;
    param_51 = _e256;
    metal::float4 _e257 = seeThroughWithShadow(param_47, param_48, param_49, param_50, param_51, _from, _sampler, _to, cylinderAngle, amount);
    cl = _e257;
    metal::float3 _e258 = point_6;
    param_52 = _e258;
    float _e259 = distanceToEdge(param_52);
    dist = _e259;
    metal::float4 _e260 = color_2;
    param_53 = _e260;
    metal::float4 _e261 = cl;
    param_54 = _e261;
    float _e262 = dist;
    param_55 = _e262;
    metal::float4 _e263 = antiAlias(param_53, param_54, param_55);
    return _e263;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    thread float& cylinderAngle,
    thread float& amount,
    constant Uniforms& uniforms,
    thread float& cylinderCenter,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_56 = {};
    metal::float2 _e47 = _uv_1;
    param_56 = _e47;
    metal::float4 _e48 = transition(param_56, _from, _sampler, _to, cylinderAngle, amount, uniforms, cylinderCenter);
    _fragColor = _e48;
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
    float cylinderAngle = {};
    float amount = {};
    float cylinderCenter = {};
    metal::float4 _fragColor = {};
    metal::float2 _uv_1 = {};
    const auto _uv = varyings._uv;
    _uv_1 = _uv;
    main_1(_from, _sampler, _to, cylinderAngle, amount, uniforms, cylinderCenter, _fragColor, _uv_1);
    metal::float4 _e3 = _fragColor;
    return main_Output { _e3 };
}
