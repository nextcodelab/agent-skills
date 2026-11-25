// Gallery — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Gallery.glsl
// Author: gre
// License: MIT
// Description: The camera pulls back from the outgoing image to show it as a slide hanging in a row on a wall in perspective, the row glides along as each slide turns away from the center, and the camera moves back in on the incoming slide until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float direction;
    float tilt;
    float gap;
    float zoom;
    float reflection;
    char _pad7[4];
    metal::float4 background;
};

float offset(
    thread float& k,
    thread float& camQ,
    thread float& spacing
) {
    float _e46 = k;
    float _e47 = spacing;
    float _e49 = camQ;
    float _e51 = spacing;
    return metal::clamp(((_e46 * _e47) - _e49) / _e51, -1.0, 1.0);
}

metal::float4 slideHit(
    thread metal::float3& o,
    thread metal::float3& d,
    thread float& k_1,
    thread float& s,
    thread float& camQ_1,
    thread float& spacing_1,
    thread float& aa,
    constant Uniforms& uniforms
) {
    float a = {};
    float param = {};
    float param_1 = {};
    float param_2 = {};
    metal::float3 c = {};
    metal::float3 tg = {};
    metal::float3 n = {};
    float dn = {};
    float t = {};
    metal::float3 q = {};
    float lx = {};
    float ly = {};
    float jx = {};
    float ex = {};
    float ey = {};
    float cov = {};
    float local = {};
    float _e67 = s;
    float _e71 = uniforms.tilt;
    float _e73 = k_1;
    param = _e73;
    float _e74 = camQ_1;
    param_1 = _e74;
    float _e75 = spacing_1;
    param_2 = _e75;
    float _e76 = offset(param, param_1, param_2);
    a = ((-(_e67) * 1.4) * _e71) * _e76;
    float _e78 = s;
    float _e79 = k_1;
    float _e81 = spacing_1;
    c = metal::float3((_e78 * _e79) * _e81, 0.0, 0.0);
    float _e84 = a;
    float _e86 = a;
    tg = metal::float3(metal::cos(_e84), 0.0, metal::sin(_e86));
    float _e90 = tg[2u];
    float _e93 = tg[0u];
    n = metal::float3(-(_e90), 0.0, _e93);
    metal::float3 _e95 = d;
    metal::float3 _e96 = n;
    dn = metal::dot(_e95, _e96);
    float _e98 = dn;
    if (metal::abs(_e98) < 0.00001) {
        return metal::float4(0.0, 0.0, -1.0, 0.0);
    }
    metal::float3 _e101 = c;
    metal::float3 _e102 = o;
    metal::float3 _e104 = n;
    float _e106 = dn;
    t = metal::dot(_e101 - _e102, _e104) / _e106;
    metal::float3 _e108 = o;
    metal::float3 _e109 = d;
    float _e110 = t;
    metal::float3 _e113 = c;
    q = (_e108 + (_e109 * _e110)) - _e113;
    metal::float3 _e115 = q;
    metal::float3 _e116 = tg;
    float _e119 = uniforms.ratio;
    lx = metal::dot(_e115, _e116) + (0.5 * _e119);
    float _e123 = q[1u];
    ly = _e123 + 0.5;
    float _e125 = t;
    float _e127 = tg[0u];
    metal::float3 _e128 = d;
    metal::float3 _e129 = tg;
    float _e132 = n[0u];
    float _e134 = dn;
    jx = metal::abs(_e125 * (_e127 - ((metal::dot(_e128, _e129) * _e132) / _e134)));
    float _e139 = lx;
    float _e141 = uniforms.ratio;
    float _e142 = lx;
    float _e145 = jx;
    ex = metal::min(_e139, _e141 - _e142) / metal::max(_e145, 0.000001);
    float _e148 = ly;
    float _e149 = ly;
    float _e152 = t;
    ey = metal::min(_e148, 1.0 - _e149) / metal::max(_e152, 0.000001);
    float _e155 = t;
    if (_e155 > 0.0) {
        float _e157 = ex;
        float _e158 = ey;
        float _e160 = aa;
        local = metal::clamp(0.5 + (metal::min(_e157, _e158) / _e160), 0.0, 1.0);
    } else {
        local = 0.0;
    }
    float _e164 = local;
    cov = _e164;
    float _e165 = lx;
    float _e167 = uniforms.ratio;
    float _e169 = ly;
    float _e170 = t;
    float _e171 = cov;
    return metal::float4(_e165 / _e167, _e169, _e170, _e171);
}

float sceneCover(
    thread metal::float3& o_1,
    thread metal::float3& d_1,
    thread float& s_1,
    thread float& camQ_2,
    thread float& spacing_2,
    thread float& aa_1,
    constant Uniforms& uniforms
) {
    float kc = {};
    float w0_ = {};
    metal::float3 param_3 = {};
    metal::float3 param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float w1_ = {};
    metal::float3 param_10 = {};
    metal::float3 param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float w2_ = {};
    metal::float3 param_17 = {};
    metal::float3 param_18 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float _e74 = s_1;
    float _e76 = o_1[0u];
    float _e78 = d_1[0u];
    float _e80 = o_1[2u];
    float _e83 = d_1[2u];
    float _e88 = spacing_2;
    kc = metal::floor(((_e74 * (_e76 + ((_e78 * _e80) / -(_e83)))) / _e88) + 0.5);
    float _e92 = kc;
    metal::float3 _e94 = o_1;
    param_3 = _e94;
    metal::float3 _e95 = d_1;
    param_4 = _e95;
    param_5 = _e92 - 1.0;
    float _e96 = s_1;
    param_6 = _e96;
    float _e97 = camQ_2;
    param_7 = _e97;
    float _e98 = spacing_2;
    param_8 = _e98;
    float _e99 = aa_1;
    param_9 = _e99;
    metal::float4 _e100 = slideHit(param_3, param_4, param_5, param_6, param_7, param_8, param_9, uniforms);
    w0_ = _e100.w;
    metal::float3 _e102 = o_1;
    param_10 = _e102;
    metal::float3 _e103 = d_1;
    param_11 = _e103;
    float _e104 = kc;
    param_12 = _e104;
    float _e105 = s_1;
    param_13 = _e105;
    float _e106 = camQ_2;
    param_14 = _e106;
    float _e107 = spacing_2;
    param_15 = _e107;
    float _e108 = aa_1;
    param_16 = _e108;
    metal::float4 _e109 = slideHit(param_10, param_11, param_12, param_13, param_14, param_15, param_16, uniforms);
    w1_ = _e109.w;
    float _e111 = kc;
    metal::float3 _e113 = o_1;
    param_17 = _e113;
    metal::float3 _e114 = d_1;
    param_18 = _e114;
    param_19 = _e111 + 1.0;
    float _e115 = s_1;
    param_20 = _e115;
    float _e116 = camQ_2;
    param_21 = _e116;
    float _e117 = spacing_2;
    param_22 = _e117;
    float _e118 = aa_1;
    param_23 = _e118;
    metal::float4 _e119 = slideHit(param_17, param_18, param_19, param_20, param_21, param_22, param_23, uniforms);
    w2_ = _e119.w;
    float _e121 = w0_;
    float _e123 = w1_;
    float _e126 = w2_;
    return 1.0 - (((1.0 - _e121) * (1.0 - _e123)) * (1.0 - _e126));
}

metal::float4 premultiply(
    thread metal::float4& c_1
) {
    metal::float4 _e44 = c_1;
    float _e47 = c_1[3u];
    metal::float3 _e48 = _e44.xyz * _e47;
    float _e50 = c_1[3u];
    return metal::float4(_e48.x, _e48.y, _e48.z, _e50);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e45 = uv[0u];
    float _e47 = uv[1u];
    metal::float4 _e50 = _to.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e45 = uv_1[0u];
    float _e47 = uv_1[1u];
    metal::float4 _e50 = _from.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float4 slideColor(
    thread metal::float4& h,
    thread float& k_2,
    thread float& camQ_3,
    thread float& spacing_3,
    thread float& refl,
    thread metal::float4& bg,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 st = {};
    metal::float4 c_2 = {};
    metal::float4 local_1 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    metal::float4 param_26 = {};
    float param_27 = {};
    float param_28 = {};
    float param_29 = {};
    float f = {};
    float local_2 = {};
    float _e61 = h[3u];
    if (_e61 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e63 = h;
    st = metal::clamp(_e63.xy, metal::float2(0.0), metal::float2(1.0));
    float _e68 = k_2;
    if (_e68 < 0.5) {
        metal::float2 _e70 = st;
        param_24 = _e70;
        metal::float4 _e71 = getFromColor(param_24, _from, _sampler);
        local_1 = _e71;
    } else {
        metal::float2 _e72 = st;
        param_25 = _e72;
        metal::float4 _e73 = getToColor(param_25, _sampler, _to);
        local_1 = _e73;
    }
    metal::float4 _e74 = local_1;
    param_26 = _e74;
    metal::float4 _e75 = premultiply(param_26);
    c_2 = _e75;
    float _e77 = uniforms.tilt;
    float _e79 = k_2;
    param_27 = _e79;
    float _e80 = camQ_3;
    param_28 = _e80;
    float _e81 = spacing_3;
    param_29 = _e81;
    float _e82 = offset(param_27, param_28, param_29);
    metal::float4 _e86 = c_2;
    metal::float3 _e88 = _e86.xyz * (1.0 - ((0.3 * _e77) * metal::abs(_e82)));
    c_2[0u] = _e88.x;
    c_2[1u] = _e88.y;
    c_2[2u] = _e88.z;
    float _e95 = k_2;
    float _e97 = k_2;
    if ((_e95 < -0.5) || (_e97 > 1.5)) {
        metal::float4 _e100 = bg;
        metal::float4 _e101 = c_2;
        c_2 = metal::mix(_e100, _e101, metal::float4(0.3));
    }
    float _e104 = refl;
    if (_e104 > 0.0) {
        float _e106 = refl;
        float _e108 = st[1u];
        local_2 = _e106 * (1.0 - metal::smoothstep(0.0, 0.6, _e108));
    } else {
        local_2 = 1.0;
    }
    float _e112 = local_2;
    f = _e112;
    metal::float4 _e113 = c_2;
    float _e115 = h[3u];
    float _e116 = f;
    return _e113 * (_e115 * _e116);
}

metal::float4 scene(
    thread metal::float3& o_2,
    thread metal::float3& d_2,
    thread float& s_2,
    thread float& camQ_4,
    thread float& spacing_4,
    thread float& aa_2,
    thread float& refl_1,
    thread metal::float4& bg_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float wallQ = {};
    float kc_1 = {};
    metal::float4 h0_ = {};
    metal::float3 param_30 = {};
    metal::float3 param_31 = {};
    float param_32 = {};
    float param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float param_36 = {};
    metal::float4 h1_ = {};
    metal::float3 param_37 = {};
    metal::float3 param_38 = {};
    float param_39 = {};
    float param_40 = {};
    float param_41 = {};
    float param_42 = {};
    float param_43 = {};
    metal::float4 h2_ = {};
    metal::float3 param_44 = {};
    metal::float3 param_45 = {};
    float param_46 = {};
    float param_47 = {};
    float param_48 = {};
    float param_49 = {};
    float param_50 = {};
    metal::float4 c0_ = {};
    metal::float4 param_51 = {};
    float param_52 = {};
    float param_53 = {};
    float param_54 = {};
    float param_55 = {};
    metal::float4 param_56 = {};
    metal::float4 c1_ = {};
    metal::float4 param_57 = {};
    float param_58 = {};
    float param_59 = {};
    float param_60 = {};
    float param_61 = {};
    metal::float4 param_62 = {};
    metal::float4 c2_ = {};
    metal::float4 param_63 = {};
    float param_64 = {};
    float param_65 = {};
    float param_66 = {};
    float param_67 = {};
    metal::float4 param_68 = {};
    float t0_ = {};
    float local_3 = {};
    float t1_ = {};
    float local_4 = {};
    float t2_ = {};
    float local_5 = {};
    metal::float4 tc = {};
    float tt = {};
    metal::float4 col = {};
    float _e107 = s_2;
    float _e109 = o_2[0u];
    float _e111 = d_2[0u];
    float _e113 = o_2[2u];
    float _e116 = d_2[2u];
    wallQ = _e107 * (_e109 + ((_e111 * _e113) / -(_e116)));
    float _e121 = wallQ;
    float _e122 = spacing_4;
    kc_1 = metal::floor((_e121 / _e122) + 0.5);
    float _e126 = kc_1;
    metal::float3 _e128 = o_2;
    param_30 = _e128;
    metal::float3 _e129 = d_2;
    param_31 = _e129;
    param_32 = _e126 - 1.0;
    float _e130 = s_2;
    param_33 = _e130;
    float _e131 = camQ_4;
    param_34 = _e131;
    float _e132 = spacing_4;
    param_35 = _e132;
    float _e133 = aa_2;
    param_36 = _e133;
    metal::float4 _e134 = slideHit(param_30, param_31, param_32, param_33, param_34, param_35, param_36, uniforms);
    h0_ = _e134;
    metal::float3 _e135 = o_2;
    param_37 = _e135;
    metal::float3 _e136 = d_2;
    param_38 = _e136;
    float _e137 = kc_1;
    param_39 = _e137;
    float _e138 = s_2;
    param_40 = _e138;
    float _e139 = camQ_4;
    param_41 = _e139;
    float _e140 = spacing_4;
    param_42 = _e140;
    float _e141 = aa_2;
    param_43 = _e141;
    metal::float4 _e142 = slideHit(param_37, param_38, param_39, param_40, param_41, param_42, param_43, uniforms);
    h1_ = _e142;
    float _e143 = kc_1;
    metal::float3 _e145 = o_2;
    param_44 = _e145;
    metal::float3 _e146 = d_2;
    param_45 = _e146;
    param_46 = _e143 + 1.0;
    float _e147 = s_2;
    param_47 = _e147;
    float _e148 = camQ_4;
    param_48 = _e148;
    float _e149 = spacing_4;
    param_49 = _e149;
    float _e150 = aa_2;
    param_50 = _e150;
    metal::float4 _e151 = slideHit(param_44, param_45, param_46, param_47, param_48, param_49, param_50, uniforms);
    h2_ = _e151;
    float _e152 = kc_1;
    metal::float4 _e154 = h0_;
    param_51 = _e154;
    param_52 = _e152 - 1.0;
    float _e155 = camQ_4;
    param_53 = _e155;
    float _e156 = spacing_4;
    param_54 = _e156;
    float _e157 = refl_1;
    param_55 = _e157;
    metal::float4 _e158 = bg_1;
    param_56 = _e158;
    metal::float4 _e159 = slideColor(param_51, param_52, param_53, param_54, param_55, param_56, _from, _sampler, _to, uniforms);
    c0_ = _e159;
    metal::float4 _e160 = h1_;
    param_57 = _e160;
    float _e161 = kc_1;
    param_58 = _e161;
    float _e162 = camQ_4;
    param_59 = _e162;
    float _e163 = spacing_4;
    param_60 = _e163;
    float _e164 = refl_1;
    param_61 = _e164;
    metal::float4 _e165 = bg_1;
    param_62 = _e165;
    metal::float4 _e166 = slideColor(param_57, param_58, param_59, param_60, param_61, param_62, _from, _sampler, _to, uniforms);
    c1_ = _e166;
    float _e167 = kc_1;
    metal::float4 _e169 = h2_;
    param_63 = _e169;
    param_64 = _e167 + 1.0;
    float _e170 = camQ_4;
    param_65 = _e170;
    float _e171 = spacing_4;
    param_66 = _e171;
    float _e172 = refl_1;
    param_67 = _e172;
    metal::float4 _e173 = bg_1;
    param_68 = _e173;
    metal::float4 _e174 = slideColor(param_63, param_64, param_65, param_66, param_67, param_68, _from, _sampler, _to, uniforms);
    c2_ = _e174;
    float _e176 = h0_[3u];
    if (_e176 > 0.0) {
        float _e179 = h0_[2u];
        local_3 = _e179;
    } else {
        local_3 = 1000000.0;
    }
    float _e180 = local_3;
    t0_ = _e180;
    float _e182 = h1_[3u];
    if (_e182 > 0.0) {
        float _e185 = h1_[2u];
        local_4 = _e185;
    } else {
        local_4 = 1000000.0;
    }
    float _e186 = local_4;
    t1_ = _e186;
    float _e188 = h2_[3u];
    if (_e188 > 0.0) {
        float _e191 = h2_[2u];
        local_5 = _e191;
    } else {
        local_5 = 1000000.0;
    }
    float _e192 = local_5;
    t2_ = _e192;
    float _e193 = t0_;
    float _e194 = t1_;
    if (_e193 < _e194) {
        metal::float4 _e196 = c0_;
        tc = _e196;
        metal::float4 _e197 = c1_;
        c0_ = _e197;
        metal::float4 _e198 = tc;
        c1_ = _e198;
        float _e199 = t0_;
        tt = _e199;
        float _e200 = t1_;
        t0_ = _e200;
        float _e201 = tt;
        t1_ = _e201;
    }
    float _e202 = t1_;
    float _e203 = t2_;
    if (_e202 < _e203) {
        metal::float4 _e205 = c1_;
        tc = _e205;
        metal::float4 _e206 = c2_;
        c1_ = _e206;
        metal::float4 _e207 = tc;
        c2_ = _e207;
        float _e208 = t1_;
        tt = _e208;
        float _e209 = t2_;
        t1_ = _e209;
        float _e210 = tt;
        t2_ = _e210;
    }
    float _e211 = t0_;
    float _e212 = t1_;
    if (_e211 < _e212) {
        metal::float4 _e214 = c0_;
        tc = _e214;
        metal::float4 _e215 = c1_;
        c0_ = _e215;
        metal::float4 _e216 = tc;
        c1_ = _e216;
    }
    metal::float4 _e217 = c0_;
    col = _e217;
    metal::float4 _e218 = c1_;
    metal::float4 _e219 = col;
    float _e221 = c1_[3u];
    col = _e218 + (_e219 * (1.0 - _e221));
    metal::float4 _e225 = c2_;
    metal::float4 _e226 = col;
    float _e228 = c2_[3u];
    col = _e225 + (_e226 * (1.0 - _e228));
    metal::float4 _e232 = col;
    return _e232;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float s_3 = {};
    float spacing_5 = {};
    float back = {};
    float m = {};
    float glide = {};
    float camQ_5 = {};
    metal::float3 o_3 = {};
    metal::float3 d_3 = {};
    float amount = {};
    float aa_3 = {};
    metal::float4 bg_2 = {};
    metal::float4 param_69 = {};
    metal::float4 col_1 = {};
    metal::float3 param_70 = {};
    metal::float3 param_71 = {};
    float param_72 = {};
    float param_73 = {};
    float param_74 = {};
    float param_75 = {};
    float param_76 = {};
    metal::float4 param_77 = {};
    metal::float4 under = {};
    metal::float4 r = {};
    metal::float3 param_78 = {};
    metal::float3 param_79 = {};
    float param_80 = {};
    float param_81 = {};
    float param_82 = {};
    float param_83 = {};
    float param_84 = {};
    metal::float4 param_85 = {};
    metal::float3 param_86 = {};
    metal::float3 param_87 = {};
    float param_88 = {};
    float param_89 = {};
    float param_90 = {};
    float param_91 = {};
    metal::float4 local_6 = {};
    bool phi_780_ = {};
    float _e84 = uniforms.progress;
    p = _e84;
    float _e86 = uniforms.direction;
    s_3 = (_e86 < 0.0) ? -1.0 : 1.0;
    float _e90 = uniforms.ratio;
    float _e92 = uniforms.gap;
    spacing_5 = _e90 * (1.0 + _e92);
    float _e95 = p;
    float _e97 = p;
    back = metal::smoothstep(0.0, 0.42, _e95) * (1.0 - metal::smoothstep(0.58, 1.0, _e97));
    float _e101 = p;
    m = metal::clamp((_e101 - 0.18) / 0.64, 0.0, 1.0);
    float _e105 = m;
    float _e106 = m;
    float _e108 = m;
    float _e110 = m;
    float _e111 = m;
    glide = ((_e105 * _e106) * _e108) * ((_e110 * ((_e111 * 6.0) - 15.0)) + 10.0);
    float _e117 = spacing_5;
    float _e118 = glide;
    camQ_5 = _e117 * _e118;
    float _e120 = s_3;
    float _e121 = camQ_5;
    float _e124 = uniforms.zoom;
    float _e125 = back;
    o_3 = metal::float3(_e120 * _e121, 0.0, 1.6 * (1.0 + (_e124 * _e125)));
    metal::float2 _e130 = uv_2;
    float _e134 = uniforms.ratio;
    metal::float2 _e136 = (_e130 - metal::float2(0.5)) * metal::float2(_e134, 1.0);
    d_3 = metal::float3(_e136.x, _e136.y, -1.6);
    float _e140 = back;
    amount = metal::min(1.0, 40.0 * _e140);
    float _e143 = amount;
    aa_3 = metal::max(0.002 * _e143, 0.000001);
    metal::float4 _e147 = uniforms.background;
    param_69 = _e147;
    metal::float4 _e148 = premultiply(param_69);
    bg_2 = _e148;
    metal::float3 _e149 = o_3;
    param_70 = _e149;
    metal::float3 _e150 = d_3;
    param_71 = _e150;
    float _e151 = s_3;
    param_72 = _e151;
    float _e152 = camQ_5;
    param_73 = _e152;
    float _e153 = spacing_5;
    param_74 = _e153;
    float _e154 = aa_3;
    param_75 = _e154;
    param_76 = 0.0;
    metal::float4 _e155 = bg_2;
    param_77 = _e155;
    metal::float4 _e156 = scene(param_70, param_71, param_72, param_73, param_74, param_75, param_76, param_77, _from, _sampler, _to, uniforms);
    col_1 = _e156;
    float _e158 = col_1[3u];
    if (_e158 < 1.0) {
        metal::float4 _e160 = bg_2;
        under = _e160;
        float _e162 = d_3[1u];
        bool _e163 = _e162 < 0.0;
        phi_780_ = _e163;
        if (_e163) {
            float _e165 = uniforms.reflection;
            phi_780_ = _e165 > 0.0;
        }
        bool _e168 = phi_780_;
        if (_e168) {
            float _e170 = o_3[0u];
            float _e172 = o_3[1u];
            float _e175 = o_3[2u];
            float _e178 = d_3[0u];
            float _e180 = d_3[1u];
            float _e183 = d_3[2u];
            param_78 = metal::float3(_e170, -1.0 - _e172, _e175);
            param_79 = metal::float3(_e178, -(_e180), _e183);
            float _e185 = s_3;
            param_80 = _e185;
            float _e186 = camQ_5;
            param_81 = _e186;
            float _e187 = spacing_5;
            param_82 = _e187;
            float _e188 = aa_3;
            param_83 = _e188;
            float _e190 = uniforms.reflection;
            param_84 = _e190;
            metal::float4 _e191 = bg_2;
            param_85 = _e191;
            metal::float4 _e192 = scene(param_78, param_79, param_80, param_81, param_82, param_83, param_84, param_85, _from, _sampler, _to, uniforms);
            r = _e192;
            metal::float4 _e193 = r;
            metal::float4 _e194 = bg_2;
            float _e196 = r[3u];
            under = _e193 + (_e194 * (1.0 - _e196));
        }
        metal::float4 _e200 = under;
        float _e201 = amount;
        metal::float3 _e202 = o_3;
        param_86 = _e202;
        metal::float3 _e203 = d_3;
        param_87 = _e203;
        float _e204 = s_3;
        param_88 = _e204;
        float _e205 = camQ_5;
        param_89 = _e205;
        float _e206 = spacing_5;
        param_90 = _e206;
        float _e207 = aa_3;
        param_91 = _e207;
        float _e208 = sceneCover(param_86, param_87, param_88, param_89, param_90, param_91, uniforms);
        float _e211 = col_1[3u];
        metal::float4 _e215 = col_1;
        col_1 = _e215 + (_e200 * (metal::mix(1.0, _e201, _e208) * (1.0 - _e211)));
    }
    float _e218 = col_1[3u];
    if (_e218 > 0.0) {
        metal::float4 _e220 = col_1;
        float _e223 = col_1[3u];
        metal::float3 _e225 = _e220.xyz / metal::float3(_e223);
        float _e227 = col_1[3u];
        local_6 = metal::float4(_e225.x, _e225.y, _e225.z, _e227);
    } else {
        local_6 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e232 = local_6;
    return _e232;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_92 = {};
    metal::float2 _e44 = _uv_1;
    param_92 = _e44;
    metal::float4 _e45 = transition(param_92, _from, _sampler, _to, uniforms);
    _fragColor = _e45;
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
