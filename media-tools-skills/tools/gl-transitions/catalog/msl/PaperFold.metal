// PaperFold — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PaperFold.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is a sheet of paper that folds in half in 3D along a vertical crease, then in half again along a horizontal one, its lit and shaded faces turning to show the back of the paper, and the small folded packet flies off the frame, leaving its shadow on the incoming image underneath
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float tilt;
    float shading;
    char _pad5[8];
    metal::float4 paper;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e52 = uv[0u];
    float _e54 = uv[1u];
    metal::float4 _e57 = _from.sample(_sampler, metal::float2(_e52, 1.0 - _e54), metal::level(0.0));
    return _e57;
}

metal::float4 front(
    thread metal::float2& st,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 _e52 = st;
    float _e54 = uniforms.ratio;
    param = _e52 / metal::float2(_e54, 1.0);
    metal::float4 _e57 = getFromColor(param, _from, _sampler);
    return _e57;
}

metal::float4 back(
    thread metal::float2& st_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    metal::float4 c = {};
    metal::float2 param_1 = {};
    metal::float2 _e53 = st_1;
    param_1 = _e53;
    metal::float4 _e54 = front(param_1, _from, _sampler, uniforms);
    c = _e54;
    metal::float4 _e56 = uniforms.paper;
    metal::float4 _e58 = c;
    metal::float3 _e61 = metal::mix(_e56.xyz, _e58.xyz, metal::float3(0.1));
    float _e63 = c[3u];
    float _e66 = uniforms.paper[3u];
    return metal::float4(_e61.x, _e61.y, _e61.z, _e63 * _e66);
}

metal::float3 hitFlap(
    thread metal::float3& o,
    thread metal::float3& v,
    thread float& h,
    thread metal::float3& n,
    thread metal::float3& along
) {
    float den = {};
    metal::float3 hinge = {};
    float t = {};
    metal::float3 q = {};
    metal::float3 _e59 = n;
    metal::float3 _e60 = v;
    den = metal::dot(_e59, _e60);
    float _e62 = den;
    if (metal::abs(_e62) < 0.00001) {
        return metal::float3(-1.0, 0.0, 0.0);
    }
    float _e65 = h;
    hinge = metal::float3(_e65, 0.0, 0.0);
    metal::float3 _e67 = n;
    metal::float3 _e68 = hinge;
    metal::float3 _e69 = o;
    float _e72 = den;
    t = metal::dot(_e67, _e68 - _e69) / _e72;
    metal::float3 _e74 = o;
    float _e75 = t;
    metal::float3 _e76 = v;
    q = _e74 + (_e76 * _e75);
    float _e79 = t;
    metal::float3 _e80 = q;
    metal::float3 _e81 = hinge;
    metal::float3 _e83 = along;
    float _e86 = q[1u];
    return metal::float3(_e79, metal::dot(_e80 - _e81, _e83), _e86);
}

metal::float4 topFace(
    thread metal::float2& st_2,
    thread bool& second,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    metal::float4 local = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    bool _e55 = second;
    if (_e55) {
        float _e57 = uniforms.ratio;
        float _e59 = st_2[0u];
        float _e62 = st_2[1u];
        param_2 = metal::float2(_e57 - _e59, _e62);
        metal::float4 _e64 = back(param_2, _from, _sampler, uniforms);
        local = _e64;
    } else {
        metal::float2 _e65 = st_2;
        param_3 = _e65;
        metal::float4 _e66 = front(param_3, _from, _sampler, uniforms);
        local = _e66;
    }
    metal::float4 _e67 = local;
    return _e67;
}

float inside(
    thread metal::float2& p,
    thread float& h_1,
    thread float& k
) {
    float _e54 = p[0u];
    float _e55 = h_1;
    float _e57 = p[0u];
    float _e61 = p[1u];
    float _e62 = k;
    float _e64 = p[1u];
    return metal::min(metal::min(_e54, _e55 - _e57), metal::min(_e61, _e62 - _e64));
}

float shadowAt(
    thread metal::float3& q_1,
    thread metal::float3& l,
    thread float& h_2,
    thread float& k_1,
    thread metal::float3& n_1,
    thread metal::float3& along_1
) {
    float sh = {};
    float soft = {};
    metal::float2 param_4 = {};
    float param_5 = {};
    float param_6 = {};
    metal::float3 hit = {};
    metal::float3 param_7 = {};
    metal::float3 param_8 = {};
    float param_9 = {};
    metal::float3 param_10 = {};
    metal::float3 param_11 = {};
    float height = {};
    float soft_1 = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    float param_14 = {};
    sh = 0.0;
    float _e73 = q_1[2u];
    if (_e73 < -0.0001) {
        float _e76 = q_1[2u];
        soft = 0.004 - (0.4 * _e76);
        float _e79 = soft;
        float _e81 = soft;
        metal::float3 _e82 = q_1;
        float _e85 = q_1[2u];
        float _e87 = l[2u];
        metal::float3 _e89 = l;
        param_4 = _e82.xy - (_e89.xy * (_e85 / _e87));
        float _e93 = h_2;
        param_5 = _e93;
        float _e94 = k_1;
        param_6 = _e94;
        float _e95 = inside(param_4, param_5, param_6);
        sh = metal::smoothstep(-(_e79), _e81, _e95);
    }
    metal::float3 _e97 = q_1;
    param_7 = _e97;
    metal::float3 _e98 = l;
    param_8 = _e98;
    float _e99 = h_2;
    param_9 = _e99;
    metal::float3 _e100 = n_1;
    param_10 = _e100;
    metal::float3 _e101 = along_1;
    param_11 = _e101;
    metal::float3 _e102 = hitFlap(param_7, param_8, param_9, param_10, param_11);
    hit = _e102;
    float _e104 = hit[0u];
    if (_e104 > 0.0) {
        float _e107 = hit[0u];
        float _e109 = l[2u];
        height = _e107 * _e109;
        float _e111 = height;
        soft_1 = 0.004 + (0.3 * _e111);
        float _e114 = sh;
        float _e116 = n_1[0u];
        float _e119 = n_1[0u];
        float _e122 = soft_1;
        float _e124 = soft_1;
        metal::float3 _e125 = hit;
        param_12 = _e125.yz;
        float _e127 = h_2;
        param_13 = _e127;
        float _e128 = k_1;
        param_14 = _e128;
        float _e129 = inside(param_12, param_13, param_14);
        float _e132 = height;
        sh = metal::max(_e114, (metal::min((4.0 * _e116) * _e119, 1.0) * metal::smoothstep(-(_e122), _e124, _e129)) / (1.0 + (3.0 * _e132)));
    }
    float _e137 = sh;
    return _e137;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e52 = uv_1[0u];
    float _e54 = uv_1[1u];
    metal::float4 _e57 = _to.sample(_sampler, metal::float2(_e52, 1.0 - _e54), metal::level(0.0));
    return _e57;
}

metal::float3 toSheet(
    thread metal::float3& v_1,
    thread metal::float2& yaw,
    thread metal::float2& pitch,
    thread metal::float2& spin
) {
    float _e55 = yaw[0u];
    float _e57 = v_1[0u];
    float _e60 = yaw[1u];
    float _e62 = v_1[2u];
    float _e66 = v_1[1u];
    float _e68 = yaw[0u];
    float _e70 = v_1[2u];
    float _e73 = yaw[1u];
    float _e75 = v_1[0u];
    v_1 = metal::float3((_e55 * _e57) + (_e60 * _e62), _e66, (_e68 * _e70) - (_e73 * _e75));
    float _e80 = v_1[0u];
    float _e82 = pitch[0u];
    float _e84 = v_1[1u];
    float _e87 = pitch[1u];
    float _e89 = v_1[2u];
    float _e93 = pitch[0u];
    float _e95 = v_1[2u];
    float _e98 = pitch[1u];
    float _e100 = v_1[1u];
    v_1 = metal::float3(_e80, (_e82 * _e84) + (_e87 * _e89), (_e93 * _e95) - (_e98 * _e100));
    float _e105 = spin[0u];
    float _e107 = v_1[0u];
    float _e110 = spin[1u];
    float _e112 = v_1[1u];
    float _e116 = spin[0u];
    float _e118 = v_1[1u];
    float _e121 = spin[1u];
    float _e123 = v_1[0u];
    float _e127 = v_1[2u];
    return metal::float3((_e105 * _e107) + (_e110 * _e112), (_e116 * _e118) - (_e121 * _e123), _e127);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float w = {};
    float shade = {};
    float s = {};
    bool second_1 = {};
    float x = {};
    float local_1 = {};
    float a = {};
    float f = {};
    float turn = {};
    metal::float2 yaw_1 = {};
    metal::float2 pitch_1 = {};
    float dist = {};
    float recede = {};
    metal::float2 dir = {};
    metal::float2 local_2 = {};
    metal::float2 c_1 = {};
    float reach = {};
    float lift = {};
    float turned = {};
    metal::float2 spin_1 = {};
    metal::float3 center = {};
    metal::float3 eye = {};
    metal::float3 e = {};
    metal::float3 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float3 d = {};
    metal::float3 param_19 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float3 l_1 = {};
    metal::float3 param_23 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    metal::float2 param_26 = {};
    float h_3 = {};
    float local_3 = {};
    float k_2 = {};
    float local_4 = {};
    float creased = {};
    metal::float3 n_2 = {};
    metal::float3 along_2 = {};
    metal::float4 col = {};
    metal::float2 param_27 = {};
    metal::float3 g = {};
    metal::float3 param_28 = {};
    metal::float3 param_29 = {};
    float param_30 = {};
    float param_31 = {};
    metal::float3 param_32 = {};
    metal::float3 param_33 = {};
    float t_1 = {};
    float local_5 = {};
    metal::float3 p_1 = {};
    float m = {};
    metal::float2 param_34 = {};
    float param_35 = {};
    float param_36 = {};
    metal::float4 img = {};
    metal::float2 local_6 = {};
    metal::float2 param_37 = {};
    bool param_38 = {};
    float sh_1 = {};
    metal::float3 param_39 = {};
    metal::float3 param_40 = {};
    float param_41 = {};
    float param_42 = {};
    metal::float3 param_43 = {};
    metal::float3 param_44 = {};
    metal::float3 hit_1 = {};
    metal::float3 param_45 = {};
    metal::float3 param_46 = {};
    float param_47 = {};
    metal::float3 param_48 = {};
    metal::float3 param_49 = {};
    float r = {};
    float dr = {};
    float fore = {};
    float mf = {};
    bool up = {};
    metal::float2 st_3 = {};
    metal::float4 img_1 = {};
    metal::float4 local_7 = {};
    metal::float2 param_50 = {};
    bool param_51 = {};
    metal::float2 param_52 = {};
    float lit = {};
    metal::float3 local_8 = {};
    float _e142 = uniforms.ratio;
    w = _e142;
    float _e144 = uniforms.shading;
    shade = metal::clamp(_e144, 0.0, 1.0);
    float _e147 = uniforms.progress;
    s = 2.0 * metal::smoothstep(0.0, 0.62, _e147);
    float _e150 = s;
    second_1 = _e150 > 1.0;
    bool _e152 = second_1;
    if (_e152) {
        float _e153 = s;
        local_1 = _e153 - 1.0;
    } else {
        float _e155 = s;
        local_1 = _e155;
    }
    float _e156 = local_1;
    x = _e156;
    float _e157 = x;
    float _e158 = x;
    float _e159 = x;
    float _e161 = x;
    a = 3.1415927 * metal::mix(_e157, (_e158 * _e159) * (3.0 - (2.0 * _e161)), 0.6);
    float _e168 = uniforms.progress;
    f = metal::clamp((_e168 - 0.5) / 0.47, 0.0, 1.0);
    float _e173 = uniforms.tilt;
    float _e176 = uniforms.progress;
    float _e179 = uniforms.progress;
    turn = metal::clamp(_e173, 0.0, 1.0) * (metal::smoothstep(0.0, 0.25, _e176) - metal::smoothstep(0.4, 0.8, _e179));
    float _e183 = turn;
    float _e186 = turn;
    yaw_1 = metal::float2(metal::cos(0.45 * _e183), metal::sin(0.45 * _e186));
    float _e190 = turn;
    float _e193 = turn;
    pitch_1 = metal::float2(metal::cos(0.55 * _e190), -(metal::sin(0.55 * _e193)));
    float _e198 = w;
    dist = 2.5 * metal::max(_e198, 1.0);
    float _e201 = dist;
    float _e203 = turn;
    recede = (_e201 * 0.35) * _e203;
    metal::float2 _e206 = uniforms.direction;
    if (metal::length(_e206) > 0.0) {
        metal::float2 _e210 = uniforms.direction;
        local_2 = metal::normalize(_e210);
    } else {
        local_2 = metal::float2(1.0, 0.0);
    }
    metal::float2 _e212 = local_2;
    dir = _e212;
    float _e213 = w;
    float _e215 = w;
    float _e217 = s;
    float _e221 = s;
    c_1 = metal::float2((0.5 * _e213) - ((0.25 * _e215) * metal::min(_e217, 1.0)), 0.5 - (0.25 * metal::max(_e221 - 1.0, 0.0)));
    float _e228 = dir[0u];
    float _e230 = w;
    float _e233 = dir[1u];
    float _e237 = w;
    reach = ((0.5 * ((metal::abs(_e228) * _e230) + metal::abs(_e233))) + metal::length(metal::float2(0.25 * _e237, 0.25))) + 0.4;
    float _e243 = f;
    lift = 0.3 * metal::smoothstep(0.0, 0.5, _e243);
    float _e247 = dir[0u];
    float _e250 = f;
    float _e252 = f;
    turned = (((_e247 < 0.0) ? 0.7 : -0.7) * _e250) * _e252;
    float _e254 = turned;
    float _e256 = turned;
    spin_1 = metal::float2(metal::cos(_e254), metal::sin(_e256));
    float _e259 = w;
    metal::float2 _e262 = dir;
    float _e263 = reach;
    float _e265 = f;
    float _e267 = f;
    metal::float2 _e269 = metal::float2(0.5 * _e259, 0.5) + (((_e262 * _e263) * _e265) * _e267);
    float _e270 = recede;
    center = metal::float3(_e269.x, _e269.y, -(_e270));
    float _e275 = w;
    float _e277 = dist;
    eye = metal::float3(0.5 * _e275, 0.5, _e277);
    metal::float3 _e279 = eye;
    metal::float3 _e280 = center;
    param_15 = _e279 - _e280;
    metal::float2 _e282 = yaw_1;
    param_16 = _e282;
    metal::float2 _e283 = pitch_1;
    param_17 = _e283;
    metal::float2 _e284 = spin_1;
    param_18 = _e284;
    metal::float3 _e285 = toSheet(param_15, param_16, param_17, param_18);
    metal::float2 _e286 = c_1;
    e = _e285 + metal::float3(_e286.x, _e286.y, 0.0);
    float _e292 = uv_2[0u];
    float _e293 = w;
    float _e296 = uv_2[1u];
    metal::float3 _e298 = eye;
    param_19 = metal::float3(_e292 * _e293, _e296, 0.0) - _e298;
    metal::float2 _e300 = yaw_1;
    param_20 = _e300;
    metal::float2 _e301 = pitch_1;
    param_21 = _e301;
    metal::float2 _e302 = spin_1;
    param_22 = _e302;
    metal::float3 _e303 = toSheet(param_19, param_20, param_21, param_22);
    d = _e303;
    param_23 = metal::float3(-0.3995, 0.4494, 0.799);
    metal::float2 _e304 = yaw_1;
    param_24 = _e304;
    metal::float2 _e305 = pitch_1;
    param_25 = _e305;
    metal::float2 _e306 = spin_1;
    param_26 = _e306;
    metal::float3 _e307 = toSheet(param_23, param_24, param_25, param_26);
    l_1 = _e307;
    bool _e308 = second_1;
    if (_e308) {
        metal::float3 _e309 = e;
        metal::float2 _e310 = _e309.yx;
        e[0u] = _e310.x;
        e[1u] = _e310.y;
        metal::float3 _e315 = d;
        metal::float2 _e316 = _e315.yx;
        d[0u] = _e316.x;
        d[1u] = _e316.y;
        metal::float3 _e321 = l_1;
        metal::float2 _e322 = _e321.yx;
        l_1[0u] = _e322.x;
        l_1[1u] = _e322.y;
    }
    bool _e327 = second_1;
    if (_e327) {
        local_3 = 0.5;
    } else {
        float _e328 = w;
        local_3 = 0.5 * _e328;
    }
    float _e330 = local_3;
    h_3 = _e330;
    bool _e331 = second_1;
    if (_e331) {
        float _e332 = w;
        local_4 = 0.5 * _e332;
    } else {
        local_4 = 1.0;
    }
    float _e334 = local_4;
    k_2 = _e334;
    float _e335 = a;
    creased = metal::sin(_e335);
    float _e337 = creased;
    float _e339 = a;
    n_2 = metal::float3(-(_e337), 0.0, metal::cos(_e339));
    float _e342 = a;
    float _e344 = creased;
    along_2 = metal::float3(metal::cos(_e342), 0.0, _e344);
    metal::float2 _e346 = uv_2;
    param_27 = _e346;
    metal::float4 _e347 = getToColor(param_27, _sampler, _to);
    col = _e347;
    float _e349 = d[2u];
    if (_e349 < 0.0) {
        metal::float3 _e351 = e;
        metal::float3 _e352 = d;
        float _e354 = e[2u];
        float _e355 = lift;
        float _e359 = d[2u];
        g = _e351 + ((_e352 * (_e354 + _e355)) / metal::float3(-(_e359)));
        float _e364 = shade;
        float _e366 = f;
        float _e367 = f;
        metal::float3 _e371 = g;
        param_28 = _e371;
        metal::float3 _e372 = l_1;
        param_29 = _e372;
        float _e373 = h_3;
        param_30 = _e373;
        float _e374 = k_2;
        param_31 = _e374;
        metal::float3 _e375 = n_2;
        param_32 = _e375;
        metal::float3 _e376 = along_2;
        param_33 = _e376;
        float _e377 = shadowAt(param_28, param_29, param_30, param_31, param_32, param_33);
        metal::float4 _e380 = col;
        metal::float3 _e382 = _e380.xyz * (1.0 - (((0.7 * _e364) * (1.0 - (_e366 * _e367))) * _e377));
        col[0u] = _e382.x;
        col[1u] = _e382.y;
        col[2u] = _e382.z;
    }
    float _e390 = d[2u];
    if (_e390 < 0.0) {
        float _e393 = e[2u];
        float _e395 = d[2u];
        local_5 = _e393 / -(_e395);
    } else {
        local_5 = -1.0;
    }
    float _e398 = local_5;
    t_1 = _e398;
    metal::float3 _e399 = e;
    float _e400 = t_1;
    metal::float3 _e401 = d;
    p_1 = _e399 + (_e401 * _e400);
    metal::float3 _e404 = p_1;
    param_34 = _e404.xy;
    float _e406 = h_3;
    param_35 = _e406;
    float _e407 = k_2;
    param_36 = _e407;
    float _e408 = inside(param_34, param_35, param_36);
    float _e409 = t_1;
    m = metal::clamp((_e408 / (0.0015 * _e409)) + 1.0, 0.0, 1.0);
    float _e414 = t_1;
    float _e416 = m;
    if ((_e414 > 0.0) && (_e416 > 0.0)) {
        bool _e419 = second_1;
        if (_e419) {
            metal::float3 _e420 = p_1;
            local_6 = _e420.yx;
        } else {
            metal::float3 _e422 = p_1;
            local_6 = _e422.xy;
        }
        metal::float2 _e424 = local_6;
        param_37 = _e424;
        bool _e425 = second_1;
        param_38 = _e425;
        metal::float4 _e426 = topFace(param_37, param_38, _from, _sampler, uniforms);
        img = _e426;
        metal::float3 _e427 = p_1;
        param_39 = _e427;
        metal::float3 _e428 = l_1;
        param_40 = _e428;
        float _e429 = h_3;
        param_41 = _e429;
        float _e430 = k_2;
        param_42 = _e430;
        metal::float3 _e431 = n_2;
        param_43 = _e431;
        metal::float3 _e432 = along_2;
        param_44 = _e432;
        float _e433 = shadowAt(param_39, param_40, param_41, param_42, param_43, param_44);
        sh_1 = _e433;
        float _e434 = shade;
        float _e436 = sh_1;
        float _e439 = shade;
        float _e441 = creased;
        float _e443 = h_3;
        float _e445 = p_1[0u];
        metal::float4 _e454 = img;
        metal::float3 _e456 = _e454.xyz * ((1.0 - ((0.7 * _e434) * _e436)) * (1.0 - (((0.5 * _e439) * _e441) * metal::exp(-(metal::abs(_e443 - _e445)) / 0.02))));
        img[0u] = _e456.x;
        img[1u] = _e456.y;
        img[2u] = _e456.z;
        metal::float4 _e463 = col;
        metal::float4 _e464 = img;
        float _e465 = m;
        col = metal::mix(_e463, _e464, metal::float4(_e465));
    }
    metal::float3 _e468 = e;
    param_45 = _e468;
    metal::float3 _e469 = d;
    param_46 = _e469;
    float _e470 = h_3;
    param_47 = _e470;
    metal::float3 _e471 = n_2;
    param_48 = _e471;
    metal::float3 _e472 = along_2;
    param_49 = _e472;
    metal::float3 _e473 = hitFlap(param_45, param_46, param_47, param_48, param_49);
    hit_1 = _e473;
    float _e475 = hit_1[0u];
    if (_e475 > 0.0) {
        float _e478 = hit_1[1u];
        r = _e478;
        metal::float3 _e479 = along_2;
        metal::float3 _e480 = d;
        dr = metal::dot(_e479, metal::normalize(_e480));
        float _e483 = dr;
        float _e484 = dr;
        fore = metal::sqrt(metal::max(1.0 - (_e483 * _e484), 0.0025));
        float _e489 = r;
        float _e490 = h_3;
        float _e491 = r;
        float _e494 = fore;
        float _e497 = hit_1[2u];
        float _e498 = k_2;
        float _e500 = hit_1[2u];
        float _e505 = hit_1[0u];
        mf = metal::clamp((metal::min(metal::min(_e489, _e490 - _e491) * _e494, metal::min(_e497, _e498 - _e500)) / (0.0015 * _e505)) + 1.0, 0.0, 1.0);
        float _e510 = mf;
        if (_e510 > 0.0) {
            metal::float3 _e512 = n_2;
            metal::float3 _e513 = e;
            float _e514 = h_3;
            up = metal::dot(_e512, _e513 - metal::float3(_e514, 0.0, 0.0)) > 0.0;
            float _e519 = h_3;
            float _e520 = r;
            float _e523 = hit_1[2u];
            st_3 = metal::float2(_e519 + _e520, _e523);
            bool _e525 = second_1;
            if (_e525) {
                metal::float2 _e526 = st_3;
                st_3 = _e526.yx;
            }
            bool _e528 = up;
            if (_e528) {
                metal::float2 _e529 = st_3;
                param_50 = _e529;
                bool _e530 = second_1;
                param_51 = _e530;
                metal::float4 _e531 = topFace(param_50, param_51, _from, _sampler, uniforms);
                local_7 = _e531;
            } else {
                metal::float2 _e532 = st_3;
                param_52 = _e532;
                metal::float4 _e533 = back(param_52, _from, _sampler, uniforms);
                local_7 = _e533;
            }
            metal::float4 _e534 = local_7;
            img_1 = _e534;
            bool _e535 = up;
            if (_e535) {
                metal::float3 _e536 = n_2;
                local_8 = _e536;
            } else {
                metal::float3 _e537 = n_2;
                local_8 = -(_e537);
            }
            metal::float3 _e539 = local_8;
            metal::float3 _e540 = l_1;
            float _e543 = l_1[2u];
            lit = metal::dot(_e539, _e540) - _e543;
            float _e545 = shade;
            float _e547 = lit;
            float _e551 = shade;
            float _e553 = creased;
            float _e555 = r;
            metal::float4 _e563 = img_1;
            metal::float3 _e565 = _e563.xyz * (metal::max(1.0 + ((0.6 * _e545) * _e547), 0.0) * (1.0 - (((0.5 * _e551) * _e553) * metal::exp(-(metal::abs(_e555)) / 0.02))));
            img_1[0u] = _e565.x;
            img_1[1u] = _e565.y;
            img_1[2u] = _e565.z;
            metal::float4 _e572 = col;
            metal::float4 _e573 = img_1;
            float _e574 = mf;
            col = metal::mix(_e572, _e573, metal::float4(_e574));
        }
    }
    metal::float4 _e577 = col;
    return _e577;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_53 = {};
    metal::float2 _e51 = _uv_1;
    param_53 = _e51;
    metal::float4 _e52 = transition(param_53, _from, _sampler, _to, uniforms);
    _fragColor = _e52;
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
