// Clothesline — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Clothesline.glsl
// Author: gre
// License: MIT
// Description: The camera pulls back to show the outgoing image as a print hung by two clothespins on a line in front of a wall, the line is pulled sideways and carries it away while the incoming print slides in, both prints swinging and tilting like hanging paper, then the camera moves back in on the incoming print until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float direction;
    float sway;
    float size;
    char _pad5[12];
    metal::float4 background;
    metal::float4 lineColor;
    metal::float4 pinColor;
};

metal::float4 premultiply(
    thread metal::float4& c
) {
    metal::float4 _e88 = c;
    float _e91 = c[3u];
    metal::float3 _e92 = _e88.xyz * _e91;
    float _e94 = c[3u];
    return metal::float4(_e92.x, _e92.y, _e92.z, _e94);
}

float roundedBox(
    thread metal::float2& q,
    thread metal::float2& b,
    thread float& r
) {
    metal::float2 d = {};
    metal::float2 _e91 = q;
    metal::float2 _e93 = b;
    float _e95 = r;
    d = (metal::abs(_e91) - _e93) + metal::float2(_e95);
    metal::float2 _e98 = d;
    float _e103 = d[0u];
    float _e105 = d[1u];
    float _e109 = r;
    return (metal::length(metal::max(_e98, metal::float2(0.0))) + metal::min(metal::max(_e103, _e105), 0.0)) - _e109;
}

float pinDist(
    thread metal::float2& uv,
    constant Uniforms& uniforms
) {
    metal::float2 q_1 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float _e93 = uv[0u];
    float _e96 = uniforms.ratio;
    float _e100 = uv[1u];
    q_1 = metal::float2(metal::abs(_e93) - (0.32 * _e96), _e100 - -0.01);
    metal::float2 _e103 = q_1;
    param = _e103;
    param_1 = metal::float2(0.021, 0.072);
    param_2 = 0.012;
    float _e104 = roundedBox(param, param_1, param_2);
    return _e104;
}

metal::float4 drawPins(
    thread metal::float4& col,
    thread metal::float3& h,
    thread float& aa,
    thread float& vis,
    constant Uniforms& uniforms
) {
    metal::float2 lp = {};
    float d_1 = {};
    metal::float2 param_3 = {};
    float cov = {};
    float k = {};
    metal::float3 c_1 = {};
    float y = {};
    float spring = {};
    metal::float4 pc = {};
    metal::float4 param_4 = {};
    metal::float3 _e101 = h;
    lp = _e101.xy;
    metal::float2 _e103 = lp;
    param_3 = _e103;
    float _e104 = pinDist(param_3, uniforms);
    d_1 = _e104;
    float _e105 = vis;
    float _e106 = d_1;
    float _e108 = h[2u];
    float _e109 = aa;
    cov = _e105 * metal::clamp(0.5 - (_e106 / (_e108 * _e109)), 0.0, 1.0);
    float _e115 = cov;
    if (_e115 > 0.0) {
        float _e118 = lp[0u];
        float _e121 = uniforms.ratio;
        k = metal::clamp((metal::abs(_e118) - (0.32 * _e121)) / 0.021, -1.0, 1.0);
        metal::float4 _e127 = uniforms.pinColor;
        float _e129 = k;
        float _e130 = k;
        c_1 = _e127.xyz * (0.62 + (0.45 * metal::sqrt(1.0 - (_e129 * _e130))));
        float _e138 = lp[1u];
        y = _e138 - -0.01;
        float _e140 = y;
        spring = 1.0 - metal::smoothstep(0.004, 0.007, metal::abs(_e140 + 0.02));
        metal::float3 _e145 = c_1;
        float _e146 = k;
        float _e147 = k;
        float _e154 = spring;
        c_1 = metal::mix(_e145, metal::float3(0.3, 0.31, 0.33) * (0.6 + (0.8 * metal::sqrt(1.0 - (_e146 * _e147)))), metal::float3(_e154));
        float _e157 = y;
        metal::float3 _e164 = c_1;
        c_1 = _e164 * (1.0 - (0.3 * (1.0 - metal::smoothstep(0.002, 0.005, metal::abs(_e157 - 0.012)))));
        metal::float3 _e166 = c_1;
        float _e169 = uniforms.pinColor[3u];
        param_4 = metal::float4(_e166.x, _e166.y, _e166.z, _e169);
        metal::float4 _e174 = premultiply(param_4);
        pc = _e174;
        metal::float4 _e175 = pc;
        float _e176 = cov;
        metal::float4 _e178 = col;
        float _e180 = pc[3u];
        float _e181 = cov;
        col = (_e175 * _e176) + (_e178 * (1.0 - (_e180 * _e181)));
    }
    metal::float4 _e186 = col;
    return _e186;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e89 = uv_1[0u];
    float _e91 = uv_1[1u];
    metal::float4 _e94 = _to.sample(_sampler, metal::float2(_e89, 1.0 - _e91), metal::level(0.0));
    return _e94;
}

metal::float4 getFromColor(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e89 = uv_2[0u];
    float _e91 = uv_2[1u];
    metal::float4 _e94 = _from.sample(_sampler, metal::float2(_e89, 1.0 - _e91), metal::level(0.0));
    return _e94;
}

float bendShift(
    thread float& v,
    thread float& bend
) {
    float h_1 = {};
    float _e90 = v;
    h_1 = metal::clamp(_e90, 0.0, 1.0);
    float _e92 = bend;
    float _e93 = h_1;
    float _e95 = h_1;
    return (_e92 * _e93) * (0.6 + (0.4 * _e95));
}

float paperDist(
    thread metal::float2& uv_3,
    thread float& bend_1,
    constant Uniforms& uniforms
) {
    metal::float2 q_2 = {};
    float param_5 = {};
    float param_6 = {};
    float _e93 = uv_3[0u];
    float _e95 = uv_3[1u];
    param_5 = _e95;
    float _e96 = bend_1;
    param_6 = _e96;
    float _e97 = bendShift(param_5, param_6);
    float _e100 = uv_3[1u];
    float _e105 = uniforms.ratio;
    q_2 = metal::abs(metal::float2(_e93 - _e97, _e100 - 0.5)) - metal::float2(0.5 * _e105, 0.5);
    metal::float2 _e109 = q_2;
    float _e114 = q_2[0u];
    float _e116 = q_2[1u];
    return metal::length(metal::max(_e109, metal::float2(0.0))) + metal::min(metal::max(_e114, _e116), 0.0);
}

metal::float4 drawPrint(
    thread metal::float4& col_1,
    thread metal::float3& h_2,
    thread bool& isFrom,
    thread float& bend_2,
    thread float& psi,
    thread float& aa_1,
    thread float& vis_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 lp_1 = {};
    float d_2 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float cov_1 = {};
    metal::float2 st = {};
    float param_9 = {};
    float param_10 = {};
    metal::float4 c_2 = {};
    metal::float4 local = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float4 param_13 = {};
    float shade = {};
    float ps = {};
    metal::float2 param_14 = {};
    metal::float3 _e110 = h_2;
    lp_1 = _e110.xy;
    metal::float2 _e112 = lp_1;
    param_7 = _e112;
    float _e113 = bend_2;
    param_8 = _e113;
    float _e114 = paperDist(param_7, param_8, uniforms);
    d_2 = _e114;
    float _e115 = d_2;
    float _e117 = h_2[2u];
    float _e118 = aa_1;
    cov_1 = metal::clamp(0.5 - (_e115 / (_e117 * _e118)), 0.0, 1.0);
    float _e123 = cov_1;
    if (_e123 > 0.0) {
        float _e126 = lp_1[0u];
        float _e128 = lp_1[1u];
        param_9 = _e128;
        float _e129 = bend_2;
        param_10 = _e129;
        float _e130 = bendShift(param_9, param_10);
        float _e133 = uniforms.ratio;
        float _e137 = lp_1[1u];
        st = metal::clamp(metal::float2(((_e126 - _e130) / _e133) + 0.5, 1.0 - _e137), metal::float2(0.0), metal::float2(1.0));
        bool _e143 = isFrom;
        if (_e143) {
            metal::float2 _e144 = st;
            param_11 = _e144;
            metal::float4 _e145 = getFromColor(param_11, _from, _sampler);
            local = _e145;
        } else {
            metal::float2 _e146 = st;
            param_12 = _e146;
            metal::float4 _e147 = getToColor(param_12, _sampler, _to);
            local = _e147;
        }
        metal::float4 _e148 = local;
        param_13 = _e148;
        metal::float4 _e149 = premultiply(param_13);
        c_2 = _e149;
        float _e150 = psi;
        float _e155 = lp_1[1u];
        float _e158 = bend_2;
        float _e162 = lp_1[1u];
        shade = (1.0 - ((1.2 * metal::abs(metal::sin(_e150))) * _e155)) - ((0.35 * metal::abs(_e158)) * _e162);
        metal::float2 _e165 = lp_1;
        param_14 = _e165 - metal::float2(0.006, 0.01);
        float _e167 = pinDist(param_14, uniforms);
        ps = _e167;
        float _e168 = vis_1;
        float _e170 = ps;
        float _e174 = shade;
        shade = _e174 - ((0.35 * _e168) * (1.0 - metal::smoothstep(-0.004, 0.012, _e170)));
        float _e176 = shade;
        metal::float4 _e178 = c_2;
        metal::float3 _e180 = _e178.xyz * metal::clamp(_e176, 0.0, 1.0);
        c_2[0u] = _e180.x;
        c_2[1u] = _e180.y;
        c_2[2u] = _e180.z;
        metal::float4 _e187 = c_2;
        float _e188 = cov_1;
        metal::float4 _e190 = col_1;
        float _e192 = c_2[3u];
        float _e193 = cov_1;
        col_1 = (_e187 * _e188) + (_e190 * (1.0 - (_e192 * _e193)));
    }
    metal::float4 _e198 = col_1;
    return _e198;
}

metal::float3 printHit(
    thread metal::float3& o,
    thread metal::float3& d_3,
    thread float& cx,
    thread float& psi_1
) {
    metal::float3 dn = {};
    metal::float3 n = {};
    metal::float3 p0_ = {};
    float t = {};
    metal::float3 q_3 = {};
    float _e96 = psi_1;
    float _e99 = psi_1;
    dn = metal::float3(0.0, -(metal::cos(_e96)), -(metal::sin(_e99)));
    float _e103 = psi_1;
    float _e105 = psi_1;
    n = metal::float3(0.0, metal::sin(_e103), -(metal::cos(_e105)));
    float _e109 = cx;
    p0_ = metal::float3(_e109, 0.5, 0.0);
    metal::float3 _e111 = p0_;
    metal::float3 _e112 = o;
    metal::float3 _e114 = n;
    metal::float3 _e116 = d_3;
    metal::float3 _e117 = n;
    t = metal::dot(_e111 - _e112, _e114) / metal::dot(_e116, _e117);
    metal::float3 _e120 = o;
    metal::float3 _e121 = d_3;
    float _e122 = t;
    metal::float3 _e125 = p0_;
    q_3 = (_e120 + (_e121 * _e122)) - _e125;
    float _e128 = q_3[0u];
    metal::float3 _e129 = q_3;
    metal::float3 _e130 = dn;
    float _e132 = t;
    return metal::float3(_e128, metal::dot(_e129, _e130), _e132);
}

float slideTime(
    thread float& p
) {
    float _e88 = p;
    return metal::clamp((_e88 - 0.1) / 0.76, 0.0, 1.0);
}

float slideAccel(
    thread float& p_1
) {
    float u = {};
    float param_15 = {};
    float dur = {};
    float _e91 = p_1;
    param_15 = _e91;
    float _e92 = slideTime(param_15);
    u = _e92;
    dur = 0.76;
    float _e93 = u;
    float _e95 = u;
    float _e98 = u;
    float _e102 = dur;
    float _e103 = dur;
    return (((60.0 * _e93) * (1.0 - _e95)) * (1.0 - (2.0 * _e98))) / (_e102 * _e103);
}

float swing(
    thread float& p_2
) {
    float x = {};
    float v_1 = {};
    int i = {};
    float t0_ = {};
    float dt = {};
    float a = {};
    float param_16 = {};
    x = 0.0;
    v_1 = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e125 = i;
            i = as_type<int>(as_type<uint>(_e125) + as_type<uint>(1));
        }
        loop_init = false;
        int _e95 = i;
        if (_e95 < 32) {
            int _e97 = i;
            t0_ = static_cast<float>(_e97) * 0.03125;
            float _e100 = p_2;
            float _e101 = t0_;
            dt = metal::clamp(_e100 - _e101, 0.0, 0.03125);
            float _e104 = t0_;
            float _e105 = dt;
            param_16 = _e104 + (0.5 * _e105);
            float _e108 = slideAccel(param_16);
            float _e109 = x;
            float _e112 = v_1;
            a = (_e108 - (100.0 * _e109)) - (5.6 * _e112);
            float _e115 = a;
            float _e116 = dt;
            float _e118 = v_1;
            v_1 = _e118 + (_e115 * _e116);
            float _e120 = v_1;
            float _e121 = dt;
            float _e123 = x;
            x = _e123 + (_e120 * _e121);
            continue;
        } else {
            break;
        }
    }
    float _e127 = x;
    float _e128 = p_2;
    return _e127 * (1.0 - metal::smoothstep(0.7, 1.0, _e128));
}

float slideAmount(
    thread float& u_1
) {
    float _e88 = u_1;
    float _e89 = u_1;
    float _e91 = u_1;
    float _e93 = u_1;
    float _e94 = u_1;
    return ((_e88 * _e89) * _e91) * ((_e93 * ((_e94 * 6.0) - 15.0)) + 10.0);
}

metal::float4 transition(
    thread metal::float2& uv_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_3 = {};
    float s = {};
    float sw = {};
    float back = {};
    float zoom = {};
    float vis_2 = {};
    metal::float3 o_1 = {};
    metal::float3 d_4 = {};
    float aa_2 = {};
    float u_2 = {};
    float param_17 = {};
    float m = {};
    float param_18 = {};
    float speed = {};
    float spacing = {};
    float cFrom = {};
    float cTo = {};
    float bend_3 = {};
    float param_19 = {};
    float psi_2 = {};
    metal::float3 hf = {};
    metal::float3 param_20 = {};
    metal::float3 param_21 = {};
    float param_22 = {};
    float param_23 = {};
    metal::float3 ht = {};
    metal::float3 param_24 = {};
    metal::float3 param_25 = {};
    float param_26 = {};
    float param_27 = {};
    metal::float4 col_2 = {};
    metal::float4 param_28 = {};
    float cover = {};
    metal::float2 param_29 = {};
    float param_30 = {};
    metal::float2 param_31 = {};
    float param_32 = {};
    metal::float3 w = {};
    metal::float3 sf = {};
    metal::float3 param_33 = {};
    metal::float3 param_34 = {};
    float param_35 = {};
    float param_36 = {};
    metal::float3 st_1 = {};
    metal::float3 param_37 = {};
    metal::float3 param_38 = {};
    float param_39 = {};
    float param_40 = {};
    float blur = {};
    float sh = {};
    metal::float2 param_41 = {};
    float param_42 = {};
    metal::float2 param_43 = {};
    float param_44 = {};
    metal::float2 param_45 = {};
    metal::float2 param_46 = {};
    float ry = {};
    float fall = {};
    metal::float4 param_47 = {};
    metal::float3 param_48 = {};
    bool param_49 = {};
    float param_50 = {};
    float param_51 = {};
    float param_52 = {};
    float param_53 = {};
    metal::float4 param_54 = {};
    metal::float3 param_55 = {};
    bool param_56 = {};
    float param_57 = {};
    float param_58 = {};
    float param_59 = {};
    float param_60 = {};
    float tl = {};
    float ly = {};
    float lc = {};
    float k_1 = {};
    float lx = {};
    float strand = {};
    metal::float3 c_3 = {};
    metal::float4 lcp = {};
    metal::float4 param_61 = {};
    metal::float4 param_62 = {};
    metal::float3 param_63 = {};
    float param_64 = {};
    float param_65 = {};
    metal::float4 param_66 = {};
    metal::float3 param_67 = {};
    float param_68 = {};
    float param_69 = {};
    metal::float4 local_1 = {};
    float _e179 = uniforms.progress;
    p_3 = _e179;
    float _e181 = uniforms.direction;
    s = (_e181 < 0.0) ? -1.0 : 1.0;
    float _e185 = uniforms.sway;
    sw = metal::clamp(_e185, 0.0, 1.0);
    float _e187 = p_3;
    float _e189 = p_3;
    back = metal::smoothstep(0.0, 0.3, _e187) * (1.0 - metal::smoothstep(0.6, 1.0, _e189));
    float _e194 = uniforms.size;
    float _e196 = back;
    zoom = metal::mix(1.0, metal::clamp(_e194, 0.1, 1.0), _e196);
    float _e198 = back;
    vis_2 = metal::smoothstep(0.0, 0.35, _e198);
    float _e200 = back;
    float _e202 = zoom;
    o_1 = metal::float3(0.0, 0.05 * _e200, 2.0 / _e202);
    metal::float2 _e205 = uv_4;
    float _e209 = uniforms.ratio;
    metal::float2 _e211 = (_e205 - metal::float2(0.5)) * metal::float2(_e209, 1.0);
    d_4 = metal::float3(_e211.x, _e211.y, -2.0);
    float _e215 = back;
    aa_2 = metal::max(0.0015 * metal::min(1.0, 40.0 * _e215), 0.000001);
    float _e220 = p_3;
    param_17 = _e220;
    float _e221 = slideTime(param_17);
    u_2 = _e221;
    float _e222 = u_2;
    param_18 = _e222;
    float _e223 = slideAmount(param_18);
    m = _e223;
    float _e224 = u_2;
    float _e226 = u_2;
    float _e228 = u_2;
    float _e231 = u_2;
    speed = (((16.0 * _e224) * _e226) * (1.0 - _e228)) * (1.0 - _e231);
    float _e235 = uniforms.ratio;
    spacing = _e235 + 0.35;
    float _e237 = s;
    float _e239 = spacing;
    float _e241 = m;
    cFrom = (-(_e237) * _e239) * _e241;
    float _e243 = s;
    float _e244 = spacing;
    float _e246 = m;
    cTo = (_e243 * _e244) * (1.0 - _e246);
    float _e249 = s;
    float _e251 = sw;
    float _e253 = p_3;
    param_19 = _e253;
    float _e254 = swing(param_19);
    bend_3 = ((_e249 * 0.65) * _e251) * _e254;
    float _e256 = sw;
    float _e258 = speed;
    psi_2 = (0.45 * _e256) * _e258;
    metal::float3 _e260 = o_1;
    param_20 = _e260;
    metal::float3 _e261 = d_4;
    param_21 = _e261;
    float _e262 = cFrom;
    param_22 = _e262;
    float _e263 = psi_2;
    param_23 = _e263;
    metal::float3 _e264 = printHit(param_20, param_21, param_22, param_23);
    hf = _e264;
    metal::float3 _e265 = o_1;
    param_24 = _e265;
    metal::float3 _e266 = d_4;
    param_25 = _e266;
    float _e267 = cTo;
    param_26 = _e267;
    float _e268 = psi_2;
    param_27 = _e268;
    metal::float3 _e269 = printHit(param_24, param_25, param_26, param_27);
    ht = _e269;
    metal::float4 _e271 = uniforms.background;
    param_28 = _e271;
    metal::float4 _e272 = premultiply(param_28);
    col_2 = _e272;
    metal::float3 _e273 = hf;
    param_29 = _e273.xy;
    float _e275 = bend_3;
    param_30 = _e275;
    float _e276 = paperDist(param_29, param_30, uniforms);
    float _e278 = hf[2u];
    float _e279 = aa_2;
    metal::float3 _e284 = ht;
    param_31 = _e284.xy;
    float _e286 = bend_3;
    param_32 = _e286;
    float _e287 = paperDist(param_31, param_32, uniforms);
    float _e289 = ht[2u];
    float _e290 = aa_2;
    cover = metal::max(metal::clamp(0.5 - (_e276 / (_e278 * _e279)), 0.0, 1.0), metal::clamp(0.5 - (_e287 / (_e289 * _e290)), 0.0, 1.0));
    float _e296 = back;
    float _e297 = cover;
    metal::float4 _e299 = col_2;
    col_2 = _e299 * metal::mix(1.0, _e296, _e297);
    float _e301 = back;
    if (_e301 > 0.0) {
        metal::float3 _e303 = o_1;
        metal::float3 _e304 = d_4;
        float _e306 = o_1[2u];
        w = _e303 + (_e304 * ((_e306 + 0.14) / 2.0));
        metal::float3 _e311 = w;
        param_33 = _e311;
        param_34 = metal::float3(-0.28, 0.48, 0.83);
        float _e312 = cFrom;
        param_35 = _e312;
        float _e313 = psi_2;
        param_36 = _e313;
        metal::float3 _e314 = printHit(param_33, param_34, param_35, param_36);
        sf = _e314;
        metal::float3 _e315 = w;
        param_37 = _e315;
        param_38 = metal::float3(-0.28, 0.48, 0.83);
        float _e316 = cTo;
        param_39 = _e316;
        float _e317 = psi_2;
        param_40 = _e317;
        metal::float3 _e318 = printHit(param_37, param_38, param_39, param_40);
        st_1 = _e318;
        blur = 0.025;
        float _e319 = blur;
        float _e321 = blur;
        metal::float3 _e322 = sf;
        param_41 = _e322.xy;
        float _e324 = bend_3;
        param_42 = _e324;
        float _e325 = paperDist(param_41, param_42, uniforms);
        metal::float3 _e326 = st_1;
        param_43 = _e326.xy;
        float _e328 = bend_3;
        param_44 = _e328;
        float _e329 = paperDist(param_43, param_44, uniforms);
        sh = 1.0 - metal::smoothstep(-(_e319), _e321, metal::min(_e325, _e329));
        float _e333 = sh;
        metal::float3 _e334 = sf;
        param_45 = _e334.xy;
        float _e336 = pinDist(param_45, uniforms);
        metal::float3 _e337 = st_1;
        param_46 = _e337.xy;
        float _e339 = pinDist(param_46, uniforms);
        sh = metal::max(_e333, 1.0 - metal::smoothstep(-0.012, 0.02, metal::min(_e336, _e339)));
        float _e345 = w[1u];
        ry = (_e345 + 0.08096386) - 0.488;
        float _e348 = sh;
        float _e349 = ry;
        sh = metal::max(_e348, 0.8 * (1.0 - metal::smoothstep(0.0, 0.012, metal::abs(_e349))));
        metal::float3 _e355 = w;
        float _e358 = uniforms.ratio;
        float _e364 = uniforms.ratio;
        fall = 0.1 * metal::clamp(metal::length(_e355.xy - metal::float2(-0.4 * _e358, 0.6)) / ((1.2 * _e364) + 0.6), 0.0, 1.0);
        float _e370 = vis_2;
        float _e372 = sh;
        float _e375 = fall;
        float _e376 = vis_2;
        metal::float4 _e380 = col_2;
        metal::float3 _e382 = _e380.xyz * ((1.0 - ((0.42 * _e370) * _e372)) * (1.0 - (_e375 * _e376)));
        col_2[0u] = _e382.x;
        col_2[1u] = _e382.y;
        col_2[2u] = _e382.z;
    }
    metal::float4 _e389 = col_2;
    param_47 = _e389;
    metal::float3 _e390 = hf;
    param_48 = _e390;
    param_49 = true;
    float _e391 = bend_3;
    param_50 = _e391;
    float _e392 = psi_2;
    param_51 = _e392;
    float _e393 = aa_2;
    param_52 = _e393;
    float _e394 = vis_2;
    param_53 = _e394;
    metal::float4 _e395 = drawPrint(param_47, param_48, param_49, param_50, param_51, param_52, param_53, _from, _sampler, _to, uniforms);
    col_2 = _e395;
    metal::float4 _e396 = col_2;
    param_54 = _e396;
    metal::float3 _e397 = ht;
    param_55 = _e397;
    param_56 = false;
    float _e398 = bend_3;
    param_57 = _e398;
    float _e399 = psi_2;
    param_58 = _e399;
    float _e400 = aa_2;
    param_59 = _e400;
    float _e401 = vis_2;
    param_60 = _e401;
    metal::float4 _e402 = drawPrint(param_54, param_55, param_56, param_57, param_58, param_59, param_60, _from, _sampler, _to, uniforms);
    col_2 = _e402;
    float _e403 = vis_2;
    if (_e403 > 0.0) {
        float _e406 = o_1[2u];
        tl = (_e406 - 0.004) / 2.0;
        float _e410 = o_1[1u];
        float _e412 = d_4[1u];
        float _e413 = tl;
        ly = (_e410 + (_e412 * _e413)) - 0.488;
        float _e417 = vis_2;
        float _e418 = ly;
        float _e421 = tl;
        float _e422 = aa_2;
        lc = _e417 * metal::clamp(0.5 - ((metal::abs(_e418) - 0.0055) / (_e421 * _e422)), 0.0, 1.0);
        float _e428 = lc;
        if (_e428 > 0.0) {
            float _e430 = ly;
            k_1 = metal::clamp(_e430 / 0.0055, -1.0, 1.0);
            float _e434 = o_1[0u];
            float _e436 = d_4[0u];
            float _e437 = tl;
            float _e440 = s;
            float _e441 = spacing;
            float _e443 = m;
            lx = (_e434 + (_e436 * _e437)) + ((_e440 * _e441) * _e443);
            float _e446 = lx;
            float _e447 = ly;
            strand = 0.88 + (0.12 * metal::sin((_e446 + (_e447 * 0.6)) * 360.0));
            metal::float4 _e455 = uniforms.lineColor;
            float _e457 = k_1;
            float _e458 = k_1;
            float _e464 = k_1;
            float _e468 = strand;
            c_3 = (_e455.xyz * ((0.7 + (0.45 * metal::sqrt(1.0 - (_e457 * _e458)))) + (0.15 * _e464))) * _e468;
            metal::float3 _e470 = c_3;
            float _e473 = uniforms.lineColor[3u];
            param_61 = metal::float4(_e470.x, _e470.y, _e470.z, _e473);
            metal::float4 _e478 = premultiply(param_61);
            lcp = _e478;
            metal::float4 _e479 = lcp;
            float _e480 = lc;
            metal::float4 _e482 = col_2;
            float _e484 = lcp[3u];
            float _e485 = lc;
            col_2 = (_e479 * _e480) + (_e482 * (1.0 - (_e484 * _e485)));
        }
        metal::float4 _e490 = col_2;
        param_62 = _e490;
        metal::float3 _e491 = hf;
        param_63 = _e491;
        float _e492 = aa_2;
        param_64 = _e492;
        float _e493 = vis_2;
        param_65 = _e493;
        metal::float4 _e494 = drawPins(param_62, param_63, param_64, param_65, uniforms);
        col_2 = _e494;
        metal::float4 _e495 = col_2;
        param_66 = _e495;
        metal::float3 _e496 = ht;
        param_67 = _e496;
        float _e497 = aa_2;
        param_68 = _e497;
        float _e498 = vis_2;
        param_69 = _e498;
        metal::float4 _e499 = drawPins(param_66, param_67, param_68, param_69, uniforms);
        col_2 = _e499;
    }
    float _e501 = col_2[3u];
    if (_e501 > 0.0) {
        metal::float4 _e503 = col_2;
        float _e506 = col_2[3u];
        metal::float3 _e508 = _e503.xyz / metal::float3(_e506);
        float _e510 = col_2[3u];
        local_1 = metal::float4(_e508.x, _e508.y, _e508.z, _e510);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e515 = local_1;
    return _e515;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_70 = {};
    metal::float2 _e88 = _uv_1;
    param_70 = _e88;
    metal::float4 _e89 = transition(param_70, _from, _sampler, _to, uniforms);
    _fragColor = _e89;
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
