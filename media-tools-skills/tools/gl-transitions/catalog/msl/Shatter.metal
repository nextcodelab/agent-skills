// Shatter — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Shatter.glsl
// Author: lbl
// License: MIT
// Description: The outgoing image cracks like a pane of glass from an impact point, then its shards break loose from the impact outward, tumbling in 3D and falling away with gravity to reveal the incoming image behind
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float shards;
    float gravity;
    float seed;
    char _pad6[4];
};

metal::float2 impact_u0028_(
    constant Uniforms& uniforms
) {
    metal::float2 _e94 = uniforms.center;
    float _e99 = uniforms.ratio;
    return metal::clamp(_e94, metal::float2(0.0), metal::float2(1.0)) * metal::float2(_e99, 1.0);
}

float flash(
    thread metal::float2& q,
    constant Uniforms& uniforms
) {
    float f = {};
    metal::float2 d = {};
    float _e97 = uniforms.progress;
    f = metal::sin(3.1415927 * metal::clamp(_e97 / 0.12, 0.0, 1.0));
    metal::float2 _e102 = q;
    metal::float2 _e103 = impact_u0028_(uniforms);
    d = _e102 - _e103;
    float _e105 = f;
    metal::float2 _e107 = d;
    metal::float2 _e108 = d;
    float _e112 = uniforms.progress;
    return (0.6 * _e105) * metal::exp(-(metal::dot(_e107, _e108)) / (0.004 + (0.02 * _e112)));
}

float side(
    thread metal::float2& q_1,
    thread metal::float2& a,
    thread metal::float2& b
) {
    metal::float2 d_1 = {};
    metal::float2 _e97 = b;
    metal::float2 _e98 = a;
    d_1 = _e97 - _e98;
    float _e101 = d_1[0u];
    float _e103 = q_1[1u];
    float _e105 = a[1u];
    float _e109 = d_1[1u];
    float _e111 = q_1[0u];
    float _e113 = a[0u];
    metal::float2 _e117 = d_1;
    return ((_e101 * (_e103 - _e105)) - (_e109 * (_e111 - _e113))) / metal::length(_e117);
}

float triangleDist(
    thread metal::float2& q_2,
    thread metal::float2& p0_,
    thread metal::float2& p1_,
    thread metal::float2& p2_
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 _e106 = q_2;
    param = _e106;
    metal::float2 _e107 = p0_;
    param_1 = _e107;
    metal::float2 _e108 = p1_;
    param_2 = _e108;
    float _e109 = side(param, param_1, param_2);
    metal::float2 _e110 = q_2;
    param_3 = _e110;
    metal::float2 _e111 = p1_;
    param_4 = _e111;
    metal::float2 _e112 = p2_;
    param_5 = _e112;
    float _e113 = side(param_3, param_4, param_5);
    metal::float2 _e115 = q_2;
    param_6 = _e115;
    metal::float2 _e116 = p2_;
    param_7 = _e116;
    metal::float2 _e117 = p0_;
    param_8 = _e117;
    float _e118 = side(param_6, param_7, param_8);
    return metal::min(metal::min(_e109, _e113), _e118);
}

metal::float3 rotate(
    thread metal::float3& v,
    thread metal::float3& k,
    thread float& angle
) {
    float c = {};
    float s = {};
    float _e98 = angle;
    c = metal::cos(_e98);
    float _e100 = angle;
    s = metal::sin(_e100);
    metal::float3 _e102 = v;
    float _e103 = c;
    metal::float3 _e105 = k;
    metal::float3 _e106 = v;
    float _e108 = s;
    metal::float3 _e111 = k;
    metal::float3 _e112 = k;
    metal::float3 _e113 = v;
    float _e116 = c;
    return ((_e102 * _e103) + (metal::cross(_e105, _e106) * _e108)) + ((_e111 * metal::dot(_e112, _e113)) * (1.0 - _e116));
}

float releaseTime(
    thread metal::float2& mid,
    thread float& dn,
    thread float& h,
    thread float& g,
    thread float& margin
) {
    float latest = {};
    float _e100 = mid[1u];
    float _e101 = margin;
    float _e104 = g;
    latest = metal::max(0.98 - metal::sqrt((2.0 * (_e100 + _e101)) / _e104), 0.04);
    float _e109 = latest;
    float _e111 = dn;
    float _e114 = h;
    return 0.04 + ((_e109 - 0.04) * ((0.8 * metal::pow(_e111, 0.8)) + (0.2 * _e114)));
}

metal::float3 hash32(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e95 = p;
    p3_ = metal::fract(_e95.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e99 = p3_;
    metal::float3 _e100 = p3_;
    metal::float3 _e105 = p3_;
    p3_ = _e105 + metal::float3(metal::dot(_e99, _e100.yxz + metal::float3(33.33)));
    metal::float3 _e108 = p3_;
    metal::float3 _e110 = p3_;
    metal::float3 _e113 = p3_;
    return metal::fract((_e108.xxy + _e110.yzz) * _e113.zyx);
}

metal::float2 seedOffset_u0028_(
    constant Uniforms& uniforms
) {
    float _e94 = uniforms.seed;
    return metal::float2(37.0, 17.0) * metal::floor(_e94);
}

bool diagonalUp(
    thread metal::float2& c_1,
    constant Uniforms& uniforms
) {
    metal::float2 param_9 = {};
    metal::float2 _e95 = c_1;
    metal::float2 _e96 = seedOffset_u0028_(uniforms);
    param_9 = (_e95 + _e96) + metal::float2(0.5);
    metal::float3 _e100 = hash32(param_9);
    return _e100.z > 0.5;
}

float cellSize_u0028_(
    constant Uniforms& uniforms
) {
    float _e94 = uniforms.shards;
    return 1.0 / metal::clamp(_e94, 3.0, 8.0);
}

metal::float2 corner(
    thread metal::float2& p_1,
    constant Uniforms& uniforms
) {
    metal::float2 param_10 = {};
    metal::float2 _e95 = p_1;
    metal::float2 _e96 = p_1;
    metal::float2 _e97 = seedOffset_u0028_(uniforms);
    param_10 = _e96 + _e97;
    metal::float3 _e99 = hash32(param_10);
    float _e106 = cellSize_u0028_(uniforms);
    return (_e95 + (((_e99.xy * 2.0) - metal::float2(1.0)) * 0.32)) * _e106;
}

metal::float4 locate(
    thread metal::float2& q_3,
    constant Uniforms& uniforms
) {
    metal::float2 c_2 = {};
    int i = {};
    metal::float2 a_1 = {};
    metal::float2 param_11 = {};
    metal::float2 b_1 = {};
    metal::float2 param_12 = {};
    metal::float2 cc = {};
    metal::float2 param_13 = {};
    metal::float2 d_2 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    float local = {};
    metal::float2 param_18 = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    float local_1 = {};
    metal::float2 param_28 = {};
    metal::float2 param_29 = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    metal::float2 param_32 = {};
    metal::float2 param_33 = {};
    metal::float2 param_34 = {};
    bool up = {};
    metal::float2 param_35 = {};
    float d0_ = {};
    float local_2 = {};
    metal::float2 param_36 = {};
    metal::float2 param_37 = {};
    metal::float2 param_38 = {};
    metal::float2 param_39 = {};
    metal::float2 param_40 = {};
    metal::float2 param_41 = {};
    metal::float2 param_42 = {};
    metal::float2 param_43 = {};
    float d1_ = {};
    float local_3 = {};
    metal::float2 param_44 = {};
    metal::float2 param_45 = {};
    metal::float2 param_46 = {};
    metal::float2 param_47 = {};
    metal::float2 param_48 = {};
    metal::float2 param_49 = {};
    metal::float2 param_50 = {};
    metal::float2 param_51 = {};
    metal::float2 _e148 = q_3;
    float _e149 = cellSize_u0028_(uniforms);
    c_2 = metal::floor(_e148 / metal::float2(_e149));
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e211 = i;
            i = as_type<int>(as_type<uint>(_e211) + as_type<uint>(1));
        }
        loop_init = false;
        int _e153 = i;
        if (_e153 < 2) {
            metal::float2 _e155 = c_2;
            param_11 = _e155;
            metal::float2 _e156 = corner(param_11, uniforms);
            a_1 = _e156;
            metal::float2 _e157 = c_2;
            param_12 = _e157 + metal::float2(1.0, 0.0);
            metal::float2 _e159 = corner(param_12, uniforms);
            b_1 = _e159;
            metal::float2 _e160 = c_2;
            param_13 = _e160 + metal::float2(1.0);
            metal::float2 _e163 = corner(param_13, uniforms);
            cc = _e163;
            metal::float2 _e164 = c_2;
            param_14 = _e164 + metal::float2(0.0, 1.0);
            metal::float2 _e166 = corner(param_14, uniforms);
            d_2 = _e166;
            metal::float2 _e167 = q_3;
            param_15 = _e167;
            metal::float2 _e168 = d_2;
            param_16 = _e168;
            metal::float2 _e169 = a_1;
            param_17 = _e169;
            float _e170 = side(param_15, param_16, param_17);
            if (_e170 < 0.0) {
                local = -1.0;
            } else {
                metal::float2 _e172 = q_3;
                param_18 = _e172;
                metal::float2 _e173 = b_1;
                param_19 = _e173;
                metal::float2 _e174 = cc;
                param_20 = _e174;
                float _e175 = side(param_18, param_19, param_20);
                local = (_e175 < 0.0) ? 1.0 : 0.0;
            }
            float _e178 = local;
            float _e180 = c_2[0u];
            c_2[0u] = _e180 + _e178;
            metal::float2 _e183 = c_2;
            param_21 = _e183;
            metal::float2 _e184 = corner(param_21, uniforms);
            a_1 = _e184;
            metal::float2 _e185 = c_2;
            param_22 = _e185 + metal::float2(1.0, 0.0);
            metal::float2 _e187 = corner(param_22, uniforms);
            b_1 = _e187;
            metal::float2 _e188 = c_2;
            param_23 = _e188 + metal::float2(1.0);
            metal::float2 _e191 = corner(param_23, uniforms);
            cc = _e191;
            metal::float2 _e192 = c_2;
            param_24 = _e192 + metal::float2(0.0, 1.0);
            metal::float2 _e194 = corner(param_24, uniforms);
            d_2 = _e194;
            metal::float2 _e195 = q_3;
            param_25 = _e195;
            metal::float2 _e196 = a_1;
            param_26 = _e196;
            metal::float2 _e197 = b_1;
            param_27 = _e197;
            float _e198 = side(param_25, param_26, param_27);
            if (_e198 < 0.0) {
                local_1 = -1.0;
            } else {
                metal::float2 _e200 = q_3;
                param_28 = _e200;
                metal::float2 _e201 = cc;
                param_29 = _e201;
                metal::float2 _e202 = d_2;
                param_30 = _e202;
                float _e203 = side(param_28, param_29, param_30);
                local_1 = (_e203 < 0.0) ? 1.0 : 0.0;
            }
            float _e206 = local_1;
            float _e208 = c_2[1u];
            c_2[1u] = _e208 + _e206;
            continue;
        } else {
            break;
        }
    }
    metal::float2 _e213 = c_2;
    param_31 = _e213;
    metal::float2 _e214 = corner(param_31, uniforms);
    a_1 = _e214;
    metal::float2 _e215 = c_2;
    param_32 = _e215 + metal::float2(1.0, 0.0);
    metal::float2 _e217 = corner(param_32, uniforms);
    b_1 = _e217;
    metal::float2 _e218 = c_2;
    param_33 = _e218 + metal::float2(1.0);
    metal::float2 _e221 = corner(param_33, uniforms);
    cc = _e221;
    metal::float2 _e222 = c_2;
    param_34 = _e222 + metal::float2(0.0, 1.0);
    metal::float2 _e224 = corner(param_34, uniforms);
    d_2 = _e224;
    metal::float2 _e225 = c_2;
    param_35 = _e225;
    bool _e226 = diagonalUp(param_35, uniforms);
    up = _e226;
    bool _e227 = up;
    if (_e227) {
        metal::float2 _e228 = q_3;
        param_36 = _e228;
        metal::float2 _e229 = a_1;
        param_37 = _e229;
        metal::float2 _e230 = b_1;
        param_38 = _e230;
        metal::float2 _e231 = cc;
        param_39 = _e231;
        float _e232 = triangleDist(param_36, param_37, param_38, param_39);
        local_2 = _e232;
    } else {
        metal::float2 _e233 = q_3;
        param_40 = _e233;
        metal::float2 _e234 = a_1;
        param_41 = _e234;
        metal::float2 _e235 = b_1;
        param_42 = _e235;
        metal::float2 _e236 = d_2;
        param_43 = _e236;
        float _e237 = triangleDist(param_40, param_41, param_42, param_43);
        local_2 = _e237;
    }
    float _e238 = local_2;
    d0_ = _e238;
    bool _e239 = up;
    if (_e239) {
        metal::float2 _e240 = q_3;
        param_44 = _e240;
        metal::float2 _e241 = a_1;
        param_45 = _e241;
        metal::float2 _e242 = cc;
        param_46 = _e242;
        metal::float2 _e243 = d_2;
        param_47 = _e243;
        float _e244 = triangleDist(param_44, param_45, param_46, param_47);
        local_3 = _e244;
    } else {
        metal::float2 _e245 = q_3;
        param_48 = _e245;
        metal::float2 _e246 = b_1;
        param_49 = _e246;
        metal::float2 _e247 = cc;
        param_50 = _e247;
        metal::float2 _e248 = d_2;
        param_51 = _e248;
        float _e249 = triangleDist(param_48, param_49, param_50, param_51);
        local_3 = _e249;
    }
    float _e250 = local_3;
    d1_ = _e250;
    metal::float2 _e251 = c_2;
    float _e252 = d1_;
    float _e253 = d0_;
    float _e256 = d0_;
    float _e257 = d1_;
    return metal::float4(_e251.x, _e251.y, (_e252 > _e253) ? 1.0 : 0.0, metal::abs(metal::max(_e256, _e257)));
}

float fallMargin_u0028_(
    constant Uniforms& uniforms
) {
    float _e93 = cellSize_u0028_(uniforms);
    return 0.1 + (1.5 * _e93);
}

float reach_u0028_(
    constant Uniforms& uniforms
) {
    metal::float2 c_3 = {};
    metal::float2 _e94 = impact_u0028_(uniforms);
    c_3 = _e94;
    metal::float2 _e95 = c_3;
    float _e97 = uniforms.ratio;
    metal::float2 _e99 = c_3;
    return metal::length(metal::max(_e95, metal::float2(_e97, 1.0) - _e99));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e95 = uv[0u];
    float _e97 = uv[1u];
    metal::float4 _e100 = _to.sample(_sampler, metal::float2(_e95, 1.0 - _e97), metal::level(0.0));
    return _e100;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e95 = uv_1[0u];
    float _e97 = uv_1[1u];
    metal::float4 _e100 = _from.sample(_sampler, metal::float2(_e95, 1.0 - _e97), metal::level(0.0));
    return _e100;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_52 = {};
    metal::float2 param_53 = {};
    float s_1 = {};
    metal::float2 a_2 = {};
    metal::float3 eye = {};
    metal::float3 ray = {};
    metal::float3 light = {};
    metal::float3 halfway = {};
    float g_1 = {};
    metal::float2 imp = {};
    float rch = {};
    float margin_1 = {};
    float crackTime = {};
    metal::float4 pane = {};
    float paneDepth = {};
    metal::float4 here = {};
    metal::float2 param_54 = {};
    metal::float2 hc = {};
    metal::float2 ha = {};
    metal::float2 param_55 = {};
    metal::float2 hb = {};
    metal::float2 param_56 = {};
    metal::float2 hcc = {};
    metal::float2 param_57 = {};
    metal::float2 hd = {};
    metal::float2 param_58 = {};
    bool hup = {};
    metal::float2 param_59 = {};
    metal::float2 hcenter = {};
    metal::float2 local_4 = {};
    metal::float2 local_5 = {};
    metal::float2 local_6 = {};
    metal::float3 hh = {};
    metal::float2 param_60 = {};
    metal::float2 param_61 = {};
    float param_62 = {};
    float param_63 = {};
    float param_64 = {};
    float param_65 = {};
    metal::float4 col = {};
    metal::float2 param_66 = {};
    float crack = {};
    metal::float3 n = {};
    metal::float3 param_67 = {};
    metal::float3 param_68 = {};
    float param_69 = {};
    float line = {};
    float t1_ = {};
    float t2_ = {};
    metal::float4 c1_ = {};
    metal::float4 c2_ = {};
    float a1_ = {};
    float a2_ = {};
    float shadow = {};
    metal::float2 look = {};
    metal::float2 g0_ = {};
    float rows = {};
    int ri = {};
    float j = {};
    int ci = {};
    metal::float2 c_4 = {};
    metal::float2 ca = {};
    metal::float2 param_70 = {};
    metal::float2 cb = {};
    metal::float2 param_71 = {};
    metal::float2 ccc = {};
    metal::float2 param_72 = {};
    metal::float2 cd = {};
    metal::float2 param_73 = {};
    bool up_1 = {};
    metal::float2 param_74 = {};
    int k_1 = {};
    metal::float2 p0_1 = {};
    metal::float2 p1_1 = {};
    metal::float2 p2_1 = {};
    metal::float2 mid_1 = {};
    metal::float3 h1_ = {};
    metal::float2 param_75 = {};
    metal::float2 away = {};
    float dist = {};
    float dn_1 = {};
    float e = {};
    metal::float2 param_76 = {};
    float param_77 = {};
    float param_78 = {};
    float param_79 = {};
    float param_80 = {};
    metal::float3 h2_ = {};
    metal::float2 param_81 = {};
    float near = {};
    metal::float3 vel = {};
    metal::float3 pos = {};
    metal::float3 axis = {};
    float angle_1 = {};
    metal::float3 n_1 = {};
    metal::float3 param_82 = {};
    metal::float3 param_83 = {};
    float param_84 = {};
    float rel = {};
    float den = {};
    float t = {};
    metal::float2 q_4 = {};
    metal::float3 param_85 = {};
    metal::float3 param_86 = {};
    float param_87 = {};
    float border = {};
    float inside = {};
    metal::float2 param_88 = {};
    metal::float2 param_89 = {};
    metal::float2 param_90 = {};
    metal::float2 param_91 = {};
    float ed = {};
    metal::float3 nf = {};
    metal::float3 local_7 = {};
    metal::float4 col_1 = {};
    metal::float2 param_92 = {};
    float glint = {};
    float line_1 = {};
    float bevel = {};
    float cover = {};
    float lden = {};
    float ts = {};
    metal::float2 qs = {};
    metal::float3 param_93 = {};
    metal::float3 param_94 = {};
    float param_95 = {};
    float eds = {};
    metal::float2 param_96 = {};
    metal::float2 param_97 = {};
    metal::float2 param_98 = {};
    metal::float2 param_99 = {};
    metal::float4 back = {};
    metal::float2 param_100 = {};
    metal::float4 color = {};
    metal::float2 param_101 = {};
    float _e230 = uniforms.progress;
    if (_e230 <= 0.0) {
        metal::float2 _e232 = uv_2;
        param_52 = _e232;
        metal::float4 _e233 = getFromColor(param_52, _from, _sampler);
        return _e233;
    }
    float _e235 = uniforms.progress;
    if (_e235 >= 1.0) {
        metal::float2 _e237 = uv_2;
        param_53 = _e237;
        metal::float4 _e238 = getToColor(param_53, _sampler, _to);
        return _e238;
    }
    float _e239 = cellSize_u0028_(uniforms);
    s_1 = _e239;
    float _e241 = uv_2[0u];
    float _e243 = uniforms.ratio;
    float _e246 = uv_2[1u];
    a_2 = metal::float2(_e241 * _e243, _e246);
    float _e249 = uniforms.ratio;
    eye = metal::float3(0.5 * _e249, 0.5, -2.5);
    metal::float2 _e252 = a_2;
    metal::float3 _e256 = eye;
    ray = metal::float3(_e252.x, _e252.y, 0.0) - _e256;
    light = metal::float3(-0.29319772, 0.46073928, -0.8377078);
    metal::float3 _e258 = light;
    metal::float3 _e259 = ray;
    halfway = metal::normalize(_e258 - metal::normalize(_e259));
    float _e264 = uniforms.gravity;
    g_1 = 12.0 * metal::clamp(_e264, 0.5, 3.0);
    metal::float2 _e267 = impact_u0028_(uniforms);
    imp = _e267;
    float _e268 = reach_u0028_(uniforms);
    rch = _e268;
    float _e269 = fallMargin_u0028_(uniforms);
    margin_1 = _e269;
    float _e270 = margin_1;
    float _e273 = g_1;
    crackTime = metal::clamp(0.6 * (0.94 - metal::sqrt((2.0 * (1.0 + _e270)) / _e273)), 0.05, 0.22);
    pane = metal::float4(0.0, 0.0, 0.0, 0.0);
    paneDepth = 1000000000.0;
    metal::float2 _e279 = a_2;
    param_54 = _e279;
    metal::float4 _e280 = locate(param_54, uniforms);
    here = _e280;
    metal::float4 _e281 = here;
    hc = _e281.xy;
    metal::float2 _e283 = hc;
    param_55 = _e283;
    metal::float2 _e284 = corner(param_55, uniforms);
    ha = _e284;
    metal::float2 _e285 = hc;
    param_56 = _e285 + metal::float2(1.0, 0.0);
    metal::float2 _e287 = corner(param_56, uniforms);
    hb = _e287;
    metal::float2 _e288 = hc;
    param_57 = _e288 + metal::float2(1.0);
    metal::float2 _e291 = corner(param_57, uniforms);
    hcc = _e291;
    metal::float2 _e292 = hc;
    param_58 = _e292 + metal::float2(0.0, 1.0);
    metal::float2 _e294 = corner(param_58, uniforms);
    hd = _e294;
    metal::float2 _e295 = hc;
    param_59 = _e295;
    bool _e296 = diagonalUp(param_59, uniforms);
    hup = _e296;
    float _e298 = here[2u];
    if (_e298 < 0.5) {
        bool _e300 = hup;
        if (_e300) {
            metal::float2 _e301 = ha;
            metal::float2 _e302 = hb;
            metal::float2 _e304 = hcc;
            local_5 = (_e301 + _e302) + _e304;
        } else {
            metal::float2 _e306 = ha;
            metal::float2 _e307 = hb;
            metal::float2 _e309 = hd;
            local_5 = (_e306 + _e307) + _e309;
        }
        metal::float2 _e311 = local_5;
        local_4 = _e311;
    } else {
        bool _e312 = hup;
        if (_e312) {
            metal::float2 _e313 = ha;
            metal::float2 _e314 = hcc;
            metal::float2 _e316 = hd;
            local_6 = (_e313 + _e314) + _e316;
        } else {
            metal::float2 _e318 = hb;
            metal::float2 _e319 = hcc;
            metal::float2 _e321 = hd;
            local_6 = (_e318 + _e319) + _e321;
        }
        metal::float2 _e323 = local_6;
        local_4 = _e323;
    }
    metal::float2 _e324 = local_4;
    hcenter = _e324;
    metal::float2 _e325 = hc;
    float _e327 = here[2u];
    metal::float2 _e331 = seedOffset_u0028_(uniforms);
    param_60 = (_e325 + (metal::float2(0.31, 0.57) * (_e327 + 1.0))) + _e331;
    metal::float3 _e333 = hash32(param_60);
    hh = _e333;
    metal::float2 _e334 = hcenter;
    hcenter = _e334 / metal::float2(3.0);
    float _e338 = uniforms.progress;
    metal::float2 _e339 = hcenter;
    metal::float2 _e340 = imp;
    float _e343 = rch;
    metal::float2 _e346 = hcenter;
    param_61 = _e346;
    param_62 = metal::clamp(metal::length(_e339 - _e340) / _e343, 0.0, 1.0);
    float _e348 = hh[0u];
    param_63 = _e348;
    float _e349 = g_1;
    param_64 = _e349;
    float _e350 = margin_1;
    param_65 = _e350;
    float _e351 = releaseTime(param_61, param_62, param_63, param_64, param_65);
    if (_e338 < _e351) {
        metal::float2 _e353 = uv_2;
        param_66 = _e353;
        metal::float4 _e354 = getFromColor(param_66, _from, _sampler);
        col = _e354;
        float _e356 = uniforms.progress;
        float _e357 = crackTime;
        metal::float2 _e358 = a_2;
        metal::float2 _e359 = imp;
        float _e363 = rch;
        crack = metal::clamp((_e356 - ((_e357 * metal::length(_e358 - _e359)) / _e363)) / 0.03, 0.0, 1.0);
        metal::float3 _e368 = hh;
        metal::float2 _e371 = _e368.yz - metal::float2(0.5);
        float _e378 = crack;
        float _e381 = hh[0u];
        param_67 = metal::float3(0.0, 0.0, -1.0);
        param_68 = metal::normalize(metal::float3(_e371.x, _e371.y, 0.0) + metal::float3(0.0001));
        param_69 = (0.06 * _e378) * (_e381 - 0.5);
        metal::float3 _e384 = rotate(param_67, param_68, param_69);
        n = _e384;
        metal::float3 _e385 = n;
        metal::float3 _e386 = light;
        float _e389 = light[2u];
        metal::float4 _e393 = col;
        metal::float3 _e395 = _e393.xyz * (1.0 + (1.2 * (metal::dot(_e385, _e386) + _e389)));
        col[0u] = _e395.x;
        col[1u] = _e395.y;
        col[2u] = _e395.z;
        float _e402 = crack;
        metal::float3 _e404 = n;
        metal::float3 _e405 = halfway;
        float _e411 = col[3u];
        metal::float4 _e413 = col;
        metal::float3 _e416 = _e413.xyz + metal::float3(((_e402 * 0.35) * metal::pow(metal::max(metal::dot(_e404, _e405), 0.0), 400.0)) * _e411);
        col[0u] = _e416.x;
        col[1u] = _e416.y;
        col[2u] = _e416.z;
        float _e423 = crack;
        float _e425 = here[3u];
        line = _e423 * (1.0 - metal::smoothstep(0.0, 0.0025, _e425));
        metal::float4 _e429 = col;
        float _e432 = col[3u];
        float _e434 = line;
        metal::float3 _e437 = metal::mix(_e429.xyz, metal::float3(0.95, 0.98, 1.0) * _e432, metal::float3(0.85 * _e434));
        col[0u] = _e437.x;
        col[1u] = _e437.y;
        col[2u] = _e437.z;
        metal::float4 _e444 = col;
        pane = _e444;
        paneDepth = 1.0;
    }
    t1_ = 1000000000.0;
    t2_ = 1000000000.0;
    c1_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    c2_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    a1_ = 0.0;
    a2_ = 0.0;
    shadow = 0.0;
    metal::float2 _e445 = a_2;
    float _e447 = uniforms.progress;
    metal::float2 _e449 = a_2;
    metal::float2 _e450 = imp;
    float _e453 = rch;
    metal::float2 _e457 = a_2;
    metal::float3 _e458 = eye;
    float _e463 = uniforms.progress;
    look = (_e445 - (((_e449 - _e450) * (0.06 * _e447)) / metal::float2(_e453))) - (((_e457 - _e458.xy) * 0.06) * _e463);
    metal::float2 _e466 = look;
    float _e467 = s_1;
    g0_ = metal::floor(_e466 / metal::float2(_e467)) - metal::float2(1.0);
    float _e473 = s_1;
    rows = metal::ceil(1.0 / _e473);
    ri = 0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e907 = ri;
            ri = as_type<int>(as_type<uint>(_e907) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e476 = ri;
        if (_e476 < 11) {
            float _e479 = g0_[1u];
            int _e480 = ri;
            j = _e479 + static_cast<float>(_e480);
            float _e483 = j;
            float _e484 = rows;
            if (_e483 > _e484) {
                break;
            }
            float _e486 = j;
            if (_e486 < -1.0) {
                continue;
            }
            ci = 0;
            uint2 loop_bound_2 = uint2(4294967295u);
            bool loop_init_2 = true;
            while(true) {
                if (metal::all(loop_bound_2 == uint2(0u))) { break; }
                loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
                if (!loop_init_2) {
                    int _e905 = ci;
                    ci = as_type<int>(as_type<uint>(_e905) + as_type<uint>(1));
                }
                loop_init_2 = false;
                int _e488 = ci;
                if (_e488 < 3) {
                    float _e491 = g0_[0u];
                    int _e492 = ci;
                    float _e495 = j;
                    c_4 = metal::float2(_e491 + static_cast<float>(_e492), _e495);
                    metal::float2 _e497 = c_4;
                    param_70 = _e497;
                    metal::float2 _e498 = corner(param_70, uniforms);
                    ca = _e498;
                    metal::float2 _e499 = c_4;
                    param_71 = _e499 + metal::float2(1.0, 0.0);
                    metal::float2 _e501 = corner(param_71, uniforms);
                    cb = _e501;
                    metal::float2 _e502 = c_4;
                    param_72 = _e502 + metal::float2(1.0);
                    metal::float2 _e505 = corner(param_72, uniforms);
                    ccc = _e505;
                    metal::float2 _e506 = c_4;
                    param_73 = _e506 + metal::float2(0.0, 1.0);
                    metal::float2 _e508 = corner(param_73, uniforms);
                    cd = _e508;
                    metal::float2 _e509 = c_4;
                    param_74 = _e509;
                    bool _e510 = diagonalUp(param_74, uniforms);
                    up_1 = _e510;
                    k_1 = 0;
                    uint2 loop_bound_3 = uint2(4294967295u);
                    bool loop_init_3 = true;
                    while(true) {
                        if (metal::all(loop_bound_3 == uint2(0u))) { break; }
                        loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
                        if (!loop_init_3) {
                            int _e903 = k_1;
                            k_1 = as_type<int>(as_type<uint>(_e903) + as_type<uint>(1));
                        }
                        loop_init_3 = false;
                        int _e511 = k_1;
                        if (_e511 < 2) {
                            int _e513 = k_1;
                            bool _e515 = up_1;
                            metal::float2 _e518 = cb;
                            metal::float2 _e519 = ca;
                            p0_1 = metal::select(_e519, _e518, metal::bool2((_e513 == 1) && !(_e515)));
                            int _e522 = k_1;
                            metal::float2 _e524 = cb;
                            metal::float2 _e525 = ccc;
                            p1_1 = metal::select(_e525, _e524, metal::bool2(_e522 == 0));
                            int _e528 = k_1;
                            bool _e530 = up_1;
                            metal::float2 _e532 = ccc;
                            metal::float2 _e533 = cd;
                            p2_1 = metal::select(_e533, _e532, metal::bool2((_e528 == 0) && _e530));
                            metal::float2 _e536 = p0_1;
                            metal::float2 _e537 = p1_1;
                            metal::float2 _e539 = p2_1;
                            mid_1 = ((_e536 + _e537) + _e539) / metal::float2(3.0);
                            metal::float2 _e543 = c_4;
                            int _e544 = k_1;
                            metal::float2 _e549 = seedOffset_u0028_(uniforms);
                            param_75 = (_e543 + (metal::float2(0.31, 0.57) * static_cast<float>(as_type<int>(as_type<uint>(_e544) + as_type<uint>(1))))) + _e549;
                            metal::float3 _e551 = hash32(param_75);
                            h1_ = _e551;
                            metal::float2 _e552 = mid_1;
                            metal::float2 _e553 = imp;
                            away = _e552 - _e553;
                            metal::float2 _e555 = away;
                            dist = metal::length(_e555);
                            float _e557 = dist;
                            float _e558 = rch;
                            dn_1 = metal::clamp(_e557 / _e558, 0.0, 1.0);
                            float _e562 = uniforms.progress;
                            metal::float2 _e563 = mid_1;
                            param_76 = _e563;
                            float _e564 = dn_1;
                            param_77 = _e564;
                            float _e566 = h1_[0u];
                            param_78 = _e566;
                            float _e567 = g_1;
                            param_79 = _e567;
                            float _e568 = margin_1;
                            param_80 = _e568;
                            float _e569 = releaseTime(param_76, param_77, param_78, param_79, param_80);
                            e = _e562 - _e569;
                            float _e571 = e;
                            if (_e571 <= 0.0) {
                                continue;
                            }
                            metal::float2 _e573 = c_4;
                            int _e574 = k_1;
                            metal::float2 _e579 = seedOffset_u0028_(uniforms);
                            param_81 = (_e573 + (metal::float2(0.73, 0.19) * static_cast<float>(as_type<int>(as_type<uint>(_e574) + as_type<uint>(1))))) + _e579;
                            metal::float3 _e581 = hash32(param_81);
                            h2_ = _e581;
                            float _e582 = dn_1;
                            near = 1.0 - _e582;
                            metal::float2 _e584 = away;
                            float _e585 = dist;
                            float _e590 = h1_[1u];
                            float _e594 = near;
                            metal::float2 _e596 = ((_e584 / metal::float2(metal::max(_e585, 0.001))) * (0.03 + (0.08 * _e590))) * (0.4 + _e594);
                            float _e597 = near;
                            float _e600 = h1_[2u];
                            vel = metal::float3(_e596.x, _e596.y, -((0.05 + ((0.2 * _e597) * _e600))));
                            metal::float2 _e607 = mid_1;
                            metal::float3 _e611 = vel;
                            float _e612 = e;
                            float _e615 = g_1;
                            float _e617 = e;
                            float _e619 = e;
                            pos = (metal::float3(_e607.x, _e607.y, 0.0) + (_e611 * _e612)) - metal::float3(0.0, ((0.5 * _e615) * _e617) * _e619, 0.0);
                            float _e624 = pos[1u];
                            float _e625 = s_1;
                            if ((_e624 + (1.5 * _e625)) < -0.05) {
                                continue;
                            }
                            float _e630 = h2_[0u];
                            float _e633 = h2_[1u];
                            float _e636 = h2_[2u];
                            axis = metal::normalize(metal::float3(_e630 - 0.5, _e633 - 0.5, 0.3 * (_e636 - 0.5)) + metal::float3(0.0001));
                            float _e644 = h2_[2u];
                            float _e648 = h2_[0u];
                            float _e652 = e;
                            angle_1 = ((3.0 + (5.0 * _e644)) * ((_e648 < 0.5) ? -1.0 : 1.0)) * _e652;
                            param_82 = metal::float3(0.0, 0.0, -1.0);
                            metal::float3 _e654 = axis;
                            param_83 = _e654;
                            float _e655 = angle_1;
                            param_84 = _e655;
                            metal::float3 _e656 = rotate(param_82, param_83, param_84);
                            n_1 = _e656;
                            float _e657 = e;
                            rel = metal::smoothstep(0.0, 0.04, _e657);
                            metal::float3 _e659 = ray;
                            metal::float3 _e660 = n_1;
                            den = metal::dot(_e659, _e660);
                            metal::float3 _e662 = pos;
                            metal::float3 _e663 = eye;
                            metal::float3 _e665 = n_1;
                            float _e667 = den;
                            float _e670 = den;
                            t = metal::dot(_e662 - _e663, _e665) / ((metal::abs(_e667) > 0.0001) ? _e670 : 0.0001);
                            metal::float2 _e673 = mid_1;
                            metal::float3 _e674 = eye;
                            float _e675 = t;
                            metal::float3 _e676 = ray;
                            metal::float3 _e679 = pos;
                            float _e681 = angle_1;
                            param_85 = (_e674 + (_e676 * _e675)) - _e679;
                            metal::float3 _e683 = axis;
                            param_86 = _e683;
                            param_87 = -(_e681);
                            metal::float3 _e684 = rotate(param_85, param_86, param_87);
                            q_4 = _e673 + _e684.xy;
                            float _e688 = q_4[0u];
                            float _e690 = uniforms.ratio;
                            float _e692 = q_4[0u];
                            float _e696 = q_4[1u];
                            float _e698 = q_4[1u];
                            border = metal::min(metal::min(_e688, _e690 - _e692), metal::min(_e696, 1.0 - _e698));
                            metal::float2 _e702 = q_4;
                            param_88 = _e702;
                            metal::float2 _e703 = p0_1;
                            param_89 = _e703;
                            metal::float2 _e704 = p1_1;
                            param_90 = _e704;
                            metal::float2 _e705 = p2_1;
                            param_91 = _e705;
                            float _e706 = triangleDist(param_88, param_89, param_90, param_91);
                            inside = _e706;
                            float _e707 = inside;
                            float _e708 = border;
                            ed = metal::min(_e707, _e708);
                            float _e710 = t;
                            float _e712 = t;
                            float _e713 = t2_;
                            float _e716 = t;
                            float _e717 = paneDepth;
                            float _e720 = ed;
                            if ((((_e710 > 0.0) && (_e712 < _e713)) && (_e716 < _e717)) && (_e720 > 0.0)) {
                                float _e723 = den;
                                if (_e723 > 0.0) {
                                    metal::float3 _e725 = n_1;
                                    local_7 = -(_e725);
                                } else {
                                    metal::float3 _e727 = n_1;
                                    local_7 = _e727;
                                }
                                metal::float3 _e728 = local_7;
                                nf = _e728;
                                float _e730 = q_4[0u];
                                float _e732 = uniforms.ratio;
                                float _e735 = q_4[1u];
                                param_92 = metal::float2(_e730 / _e732, _e735);
                                metal::float4 _e737 = getFromColor(param_92, _from, _sampler);
                                col_1 = _e737;
                                metal::float3 _e738 = nf;
                                metal::float3 _e739 = light;
                                float _e742 = light[2u];
                                float _e746 = rel;
                                metal::float4 _e748 = col_1;
                                metal::float3 _e750 = _e748.xyz * metal::mix(1.0, metal::clamp(metal::dot(_e738, _e739) / -(_e742), 0.45, 1.1), _e746);
                                col_1[0u] = _e750.x;
                                col_1[1u] = _e750.y;
                                col_1[2u] = _e750.z;
                                metal::float3 _e757 = nf;
                                metal::float3 _e758 = halfway;
                                glint = metal::max(metal::dot(_e757, _e758), 0.0);
                                float _e761 = rel;
                                float _e763 = glint;
                                float _e767 = col_1[3u];
                                metal::float4 _e769 = col_1;
                                metal::float3 _e772 = _e769.xyz + metal::float3(((_e761 * 0.3) * metal::pow(_e763, 60.0)) * _e767);
                                col_1[0u] = _e772.x;
                                col_1[1u] = _e772.y;
                                col_1[2u] = _e772.z;
                                float _e779 = inside;
                                float _e783 = rel;
                                line_1 = (0.85 * (1.0 - metal::smoothstep(0.0, 0.0025, _e779))) * (1.0 - _e783);
                                float _e786 = rel;
                                float _e788 = ed;
                                float _e792 = glint;
                                bevel = ((0.8 * _e786) * (1.0 - metal::smoothstep(0.0, 0.006, _e788))) * (0.3 + (0.7 * metal::pow(_e792, 6.0)));
                                metal::float4 _e797 = col_1;
                                float _e800 = col_1[3u];
                                float _e802 = line_1;
                                float _e803 = bevel;
                                metal::float3 _e806 = metal::mix(_e797.xyz, metal::float3(0.92, 0.97, 0.97) * _e800, metal::float3(metal::max(_e802, _e803)));
                                col_1[0u] = _e806.x;
                                col_1[1u] = _e806.y;
                                col_1[2u] = _e806.z;
                                float _e813 = ed;
                                float _e815 = rel;
                                cover = metal::mix(1.0, metal::smoothstep(0.0, 0.0024, _e813), _e815);
                                float _e817 = t;
                                float _e818 = t1_;
                                if (_e817 < _e818) {
                                    float _e820 = t1_;
                                    t2_ = _e820;
                                    metal::float4 _e821 = c1_;
                                    c2_ = _e821;
                                    float _e822 = a1_;
                                    a2_ = _e822;
                                    float _e823 = t;
                                    t1_ = _e823;
                                    metal::float4 _e824 = col_1;
                                    c1_ = _e824;
                                    float _e825 = cover;
                                    a1_ = _e825;
                                } else {
                                    float _e826 = t;
                                    t2_ = _e826;
                                    metal::float4 _e827 = col_1;
                                    c2_ = _e827;
                                    float _e828 = cover;
                                    a2_ = _e828;
                                }
                            }
                            metal::float3 _e829 = light;
                            metal::float3 _e830 = n_1;
                            lden = metal::dot(_e829, _e830);
                            metal::float3 _e832 = pos;
                            metal::float2 _e833 = a_2;
                            metal::float3 _e838 = n_1;
                            float _e840 = lden;
                            float _e843 = lden;
                            ts = metal::dot(_e832 - metal::float3(_e833.x, _e833.y, 0.0), _e838) / ((metal::abs(_e840) > 0.0001) ? _e843 : 0.0001);
                            metal::float2 _e846 = mid_1;
                            metal::float2 _e847 = a_2;
                            float _e851 = ts;
                            metal::float3 _e852 = light;
                            metal::float3 _e855 = pos;
                            float _e857 = angle_1;
                            param_93 = (metal::float3(_e847.x, _e847.y, 0.0) + (_e852 * _e851)) - _e855;
                            metal::float3 _e859 = axis;
                            param_94 = _e859;
                            param_95 = -(_e857);
                            metal::float3 _e860 = rotate(param_93, param_94, param_95);
                            qs = _e846 + _e860.xy;
                            metal::float2 _e863 = qs;
                            param_96 = _e863;
                            metal::float2 _e864 = p0_1;
                            param_97 = _e864;
                            metal::float2 _e865 = p1_1;
                            param_98 = _e865;
                            metal::float2 _e866 = p2_1;
                            param_99 = _e866;
                            float _e867 = triangleDist(param_96, param_97, param_98, param_99);
                            float _e869 = qs[0u];
                            float _e871 = uniforms.ratio;
                            float _e873 = qs[0u];
                            float _e877 = qs[1u];
                            float _e879 = qs[1u];
                            eds = metal::min(_e867, metal::min(metal::min(_e869, _e871 - _e873), metal::min(_e877, 1.0 - _e879)));
                            float _e884 = ts;
                            float _e886 = eds;
                            if ((_e884 > 0.0) && (_e886 > 0.0)) {
                                float _e889 = shadow;
                                float _e890 = rel;
                                float _e891 = ts;
                                float _e894 = eds;
                                float _e898 = ts;
                                shadow = metal::max(_e889, ((_e890 * metal::smoothstep(0.0, 0.004 + (0.08 * _e891), _e894)) * 0.45) * (1.0 - metal::smoothstep(0.1, 0.9, _e898)));
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
    metal::float2 _e909 = uv_2;
    param_100 = _e909;
    metal::float4 _e910 = getToColor(param_100, _sampler, _to);
    back = _e910;
    float _e911 = shadow;
    metal::float4 _e913 = back;
    metal::float3 _e915 = _e913.xyz * (1.0 - _e911);
    back[0u] = _e915.x;
    back[1u] = _e915.y;
    back[2u] = _e915.z;
    float _e922 = shadow;
    metal::float4 _e924 = pane;
    metal::float3 _e926 = _e924.xyz * (1.0 - _e922);
    pane[0u] = _e926.x;
    pane[1u] = _e926.y;
    pane[2u] = _e926.z;
    float _e933 = paneDepth;
    if (_e933 == 1.0) {
        metal::float4 _e935 = pane;
        back = _e935;
    }
    metal::float4 _e936 = c1_;
    float _e937 = a1_;
    metal::float4 _e939 = c2_;
    float _e940 = a2_;
    float _e941 = a1_;
    metal::float4 _e946 = back;
    float _e947 = a1_;
    float _e949 = a2_;
    color = ((_e936 * _e937) + (_e939 * metal::min(_e940, 1.0 - _e941))) + (_e946 * metal::max((1.0 - _e947) - _e949, 0.0));
    metal::float2 _e954 = a_2;
    param_101 = _e954;
    float _e955 = flash(param_101, uniforms);
    float _e957 = color[3u];
    metal::float4 _e959 = color;
    metal::float3 _e962 = _e959.xyz + metal::float3(_e955 * _e957);
    color[0u] = _e962.x;
    color[1u] = _e962.y;
    color[2u] = _e962.z;
    metal::float4 _e969 = color;
    return _e969;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_102 = {};
    metal::float2 _e94 = _uv_1;
    param_102 = _e94;
    metal::float4 _e95 = transition(param_102, _from, _sampler, _to, uniforms);
    _fragColor = _e95;
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
