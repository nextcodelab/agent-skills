// PuzzleCube — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PuzzleCube.glsl
// Author: gre
// License: MIT
// Description: The frame becomes the face of a twisty cube puzzle: dark gaps open between its cubies, then whole columns and rows of cubies turn a quarter turn around the cube one after another in 3D, each bringing the incoming image from the cube's side to the front, until the gaps close on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int size;
    float gap;
    float shading;
    char _pad5[12];
    metal::float4 background;
};

float faceMask(
    thread metal::float2& fp,
    thread float& n,
    thread float& g,
    constant Uniforms& uniforms
) {
    metal::float2 cell = {};
    metal::float2 c = {};
    metal::float2 r = {};
    metal::float2 d = {};
    float local = {};
    float local_1 = {};
    float e = {};
    bool phi_336_ = {};
    bool phi_356_ = {};
    float _e65 = g;
    if (_e65 <= 0.0) {
        return 1.0;
    }
    float _e68 = uniforms.ratio;
    float _e70 = n;
    cell = metal::float2(_e68, 1.0) / metal::float2(_e70);
    metal::float2 _e73 = fp;
    metal::float2 _e74 = cell;
    c = _e73 / _e74;
    metal::float2 _e76 = c;
    r = metal::floor(_e76 + metal::float2(0.5));
    metal::float2 _e80 = c;
    metal::float2 _e81 = r;
    metal::float2 _e84 = cell;
    d = metal::abs(_e80 - _e81) * _e84;
    float _e87 = r[0u];
    bool _e88 = _e87 < 0.5;
    phi_336_ = _e88;
    if (!(_e88)) {
        float _e91 = r[0u];
        float _e92 = n;
        phi_336_ = _e91 > (_e92 - 0.5);
    }
    bool _e96 = phi_336_;
    if (_e96) {
        local = 1.0;
    } else {
        float _e98 = d[0u];
        local = _e98;
    }
    float _e99 = local;
    d[0u] = _e99;
    float _e102 = r[1u];
    bool _e103 = _e102 < 0.5;
    phi_356_ = _e103;
    if (!(_e103)) {
        float _e106 = r[1u];
        float _e107 = n;
        phi_356_ = _e106 > (_e107 - 0.5);
    }
    bool _e111 = phi_356_;
    if (_e111) {
        local_1 = 1.0;
    } else {
        float _e113 = d[1u];
        local_1 = _e113;
    }
    float _e114 = local_1;
    d[1u] = _e114;
    float _e116 = g;
    e = metal::min(0.0012, 0.5 * _e116);
    float _e119 = g;
    float _e121 = e;
    float _e123 = g;
    float _e125 = e;
    float _e128 = d[0u];
    float _e130 = d[1u];
    return metal::smoothstep((0.5 * _e119) - _e121, (0.5 * _e123) + _e125, metal::min(_e128, _e130));
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e57 = uv[0u];
    float _e59 = uv[1u];
    metal::float4 _e62 = _from.sample(_sampler, metal::float2(_e57, 1.0 - _e59), metal::level(0.0));
    return _e62;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e57 = uv_1[0u];
    float _e59 = uv_1[1u];
    metal::float4 _e62 = _to.sample(_sampler, metal::float2(_e57, 1.0 - _e59), metal::level(0.0));
    return _e62;
}

metal::float4 sticker(
    thread metal::float2& fp_1,
    thread bool& incoming,
    thread float& light,
    thread float& n_1,
    thread float& g_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 uv_2 = {};
    metal::float4 img = {};
    metal::float4 local_2 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 body = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    float param_4 = {};
    metal::float2 _e69 = fp_1;
    float _e71 = uniforms.ratio;
    uv_2 = metal::clamp(_e69 / metal::float2(_e71, 1.0), metal::float2(0.0), metal::float2(1.0));
    bool _e77 = incoming;
    if (_e77) {
        metal::float2 _e78 = uv_2;
        param = _e78;
        metal::float4 _e79 = getToColor(param, _sampler, _to);
        local_2 = _e79;
    } else {
        metal::float2 _e80 = uv_2;
        param_1 = _e80;
        metal::float4 _e81 = getFromColor(param_1, _from, _sampler);
        local_2 = _e81;
    }
    metal::float4 _e82 = local_2;
    img = _e82;
    metal::float4 _e84 = uniforms.background;
    float _e86 = light;
    metal::float3 _e87 = _e84.xyz * _e86;
    float _e90 = uniforms.background[3u];
    body = metal::float4(_e87.x, _e87.y, _e87.z, _e90);
    metal::float4 _e95 = body;
    metal::float4 _e96 = img;
    float _e98 = light;
    metal::float3 _e99 = _e96.xyz * _e98;
    float _e101 = img[3u];
    metal::float2 _e106 = fp_1;
    param_2 = _e106;
    float _e107 = n_1;
    param_3 = _e107;
    float _e108 = g_1;
    param_4 = _e108;
    float _e109 = faceMask(param_2, param_3, param_4, uniforms);
    return metal::mix(_e95, metal::float4(_e99.x, _e99.y, _e99.z, _e101), metal::float4(_e109));
}

float turnTime(
    thread metal::float3& tl,
    thread bool& isCol,
    thread float& idx,
    thread float& n_2
) {
    float k = {};
    float local_3 = {};
    bool odd = {};
    float start = {};
    float local_4 = {};
    float local_5 = {};
    bool _e65 = isCol;
    if (_e65) {
        float _e66 = idx;
        local_3 = _e66;
    } else {
        float _e67 = n_2;
        float _e69 = idx;
        local_3 = (_e67 - 1.0) - _e69;
    }
    float _e71 = local_3;
    k = _e71;
    float _e72 = k;
    odd = (_e72 - (metal::floor(_e72 / 2.0) * 2.0)) > 0.5;
    bool _e78 = odd;
    bool _e79 = isCol;
    if (_e78 && !(_e79)) {
        return 0.0;
    }
    bool _e82 = odd;
    if (_e82) {
        float _e84 = tl[1u];
        local_4 = 2.0 * _e84;
    } else {
        bool _e86 = isCol;
        if (_e86) {
            local_5 = 0.0;
        } else {
            float _e88 = tl[1u];
            local_5 = _e88;
        }
        float _e89 = local_5;
        local_4 = _e89;
    }
    float _e90 = local_4;
    float _e91 = k;
    start = _e90 + (metal::floor(_e91 * 0.5) * 0.45);
    float _e97 = tl[0u];
    float _e98 = start;
    return metal::clamp(_e97 - _e98, 0.0, 1.0);
}

bool isDone(
    thread metal::float3& tl_1,
    thread metal::float2& fp_2,
    thread float& n_3,
    constant Uniforms& uniforms
) {
    metal::float2 cell_1 = {};
    metal::float3 param_5 = {};
    bool param_6 = {};
    float param_7 = {};
    float param_8 = {};
    metal::float3 param_9 = {};
    bool param_10 = {};
    float param_11 = {};
    float param_12 = {};
    bool phi_426_ = {};
    metal::float2 _e67 = fp_2;
    float _e69 = uniforms.ratio;
    float _e71 = n_3;
    float _e76 = n_3;
    cell_1 = metal::clamp(metal::floor(_e67 / (metal::float2(_e69, 1.0) / metal::float2(_e71))), metal::float2(0.0), metal::float2(_e76 - 1.0));
    metal::float3 _e81 = tl_1;
    param_5 = _e81;
    param_6 = true;
    float _e83 = cell_1[0u];
    param_7 = _e83;
    float _e84 = n_3;
    param_8 = _e84;
    float _e85 = turnTime(param_5, param_6, param_7, param_8);
    bool _e86 = _e85 >= 1.0;
    phi_426_ = _e86;
    if (!(_e86)) {
        metal::float3 _e88 = tl_1;
        param_9 = _e88;
        param_10 = false;
        float _e90 = cell_1[1u];
        param_11 = _e90;
        float _e91 = n_3;
        param_12 = _e91;
        float _e92 = turnTime(param_9, param_10, param_11, param_12);
        phi_426_ = _e92 >= 1.0;
    }
    bool _e95 = phi_426_;
    return _e95;
}

metal::float2 rot(
    thread metal::float2& v,
    thread float& a
) {
    float c_1 = {};
    float s = {};
    float _e59 = a;
    c_1 = metal::cos(_e59);
    float _e61 = a;
    s = metal::sin(_e61);
    float _e63 = c_1;
    float _e65 = v[0u];
    float _e67 = s;
    float _e69 = v[1u];
    float _e72 = s;
    float _e74 = v[0u];
    float _e76 = c_1;
    float _e78 = v[1u];
    return metal::float2((_e63 * _e65) - (_e67 * _e69), (_e72 * _e74) + (_e76 * _e78));
}

float lighting(
    thread metal::float3& nrm,
    thread bool& isCol_1,
    constant Uniforms& uniforms
) {
    metal::float3 l = {};
    l = metal::float3(-0.29319772, 0.46073928, 0.8377078);
    bool _e58 = isCol_1;
    if (_e58) {
        metal::float3 _e59 = l;
        l = _e59.yxz;
    }
    float _e62 = uniforms.shading;
    metal::float3 _e63 = nrm;
    metal::float3 _e64 = l;
    float _e67 = l[2u];
    return 1.0 - (_e62 * (1.0 - metal::clamp(metal::dot(_e63, _e64) / _e67, 0.0, 1.0)));
}

metal::float4 sliceColor(
    thread metal::float4& hit,
    thread metal::float3& tl_2,
    thread bool& isCol_2,
    thread float& a_1,
    thread float& dir,
    thread float& S,
    thread float& n_4,
    thread float& g_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float f = {};
    metal::float3 param_13 = {};
    bool param_14 = {};
    metal::float2 nl = {};
    metal::float2 local_6 = {};
    metal::float2 local_7 = {};
    float light_1 = {};
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float3 param_17 = {};
    bool param_18 = {};
    bool front = {};
    bool coming = {};
    float r_1 = {};
    float local_8 = {};
    metal::float2 fp_3 = {};
    metal::float2 local_9 = {};
    metal::float3 param_19 = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    metal::float2 param_22 = {};
    bool param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    bool phi_878_ = {};
    float _e89 = hit[1u];
    f = _e89;
    float _e90 = f;
    if (_e90 > 3.5) {
        metal::float4 _e93 = uniforms.background;
        float _e96 = hit[3u];
        param_13 = metal::float3(_e96, 0.0, 0.0);
        bool _e98 = isCol_2;
        param_14 = _e98;
        float _e99 = lighting(param_13, param_14, uniforms);
        metal::float3 _e100 = _e93.xyz * _e99;
        float _e103 = uniforms.background[3u];
        return metal::float4(_e100.x, _e100.y, _e100.z, _e103);
    }
    float _e108 = f;
    if (_e108 < 0.5) {
        local_6 = metal::float2(0.0, 1.0);
    } else {
        float _e110 = f;
        if (_e110 < 1.5) {
            local_7 = metal::float2(0.0, -1.0);
        } else {
            float _e112 = f;
            local_7 = metal::select(metal::float2(-1.0, 0.0), metal::float2(1.0, 0.0), metal::bool2(_e112 < 2.5));
        }
        metal::float2 _e116 = local_7;
        local_6 = _e116;
    }
    metal::float2 _e117 = local_6;
    nl = _e117;
    metal::float2 _e118 = nl;
    param_15 = _e118;
    float _e119 = a_1;
    param_16 = _e119;
    metal::float2 _e120 = rot(param_15, param_16);
    param_17 = metal::float3(0.0, _e120.x, _e120.y);
    bool _e124 = isCol_2;
    param_18 = _e124;
    float _e125 = lighting(param_17, param_18, uniforms);
    light_1 = _e125;
    float _e126 = f;
    front = _e126 < 0.5;
    float _e129 = nl[0u];
    float _e130 = dir;
    coming = (_e129 * _e130) > 0.5;
    bool _e133 = front;
    bool _e135 = coming;
    if (!(_e133) && !(_e135)) {
        metal::float4 _e139 = uniforms.background;
        float _e141 = light_1;
        metal::float3 _e142 = _e139.xyz * _e141;
        float _e145 = uniforms.background[3u];
        return metal::float4(_e142.x, _e142.y, _e142.z, _e145);
    }
    float _e150 = S;
    bool _e152 = front;
    if (_e152) {
        float _e154 = hit[3u];
        local_8 = _e154;
    } else {
        float _e155 = dir;
        float _e158 = hit[3u];
        local_8 = -(_e155) * _e158;
    }
    float _e160 = local_8;
    r_1 = (0.5 * _e150) * (1.0 + _e160);
    bool _e163 = isCol_2;
    if (_e163) {
        float _e165 = hit[2u];
        float _e166 = r_1;
        local_9 = metal::float2(_e165, _e166);
    } else {
        float _e168 = r_1;
        float _e170 = hit[2u];
        local_9 = metal::float2(_e168, _e170);
    }
    metal::float2 _e172 = local_9;
    fp_3 = _e172;
    bool _e173 = coming;
    phi_878_ = _e173;
    if (!(_e173)) {
        metal::float3 _e175 = tl_2;
        param_19 = _e175;
        metal::float2 _e176 = fp_3;
        param_20 = _e176;
        float _e177 = n_4;
        param_21 = _e177;
        bool _e178 = isDone(param_19, param_20, param_21, uniforms);
        phi_878_ = _e178;
    }
    bool _e180 = phi_878_;
    metal::float2 _e181 = fp_3;
    param_22 = _e181;
    param_23 = _e180;
    float _e182 = light_1;
    param_24 = _e182;
    float _e183 = n_4;
    param_25 = _e183;
    float _e184 = g_2;
    param_26 = _e184;
    metal::float4 _e185 = sticker(param_22, param_23, param_24, param_25, param_26, _from, _sampler, _to, uniforms);
    return _e185;
}

metal::float4 sliceHit(
    thread metal::float3& o,
    thread metal::float3& d_1,
    thread float& a0_,
    thread float& w,
    thread float& S_1,
    thread float& a_2
) {
    metal::float2 lo = {};
    metal::float2 param_27 = {};
    float param_28 = {};
    metal::float2 ld = {};
    metal::float2 param_29 = {};
    float param_30 = {};
    float local_10 = {};
    float local_11 = {};
    float dx = {};
    float local_12 = {};
    metal::float3 t1_ = {};
    metal::float3 t2_ = {};
    metal::float3 tn = {};
    metal::float3 tf = {};
    float tNear = {};
    float tFar = {};
    metal::float2 q = {};
    float across = {};
    bool phi_702_ = {};
    metal::float3 _e79 = o;
    float _e81 = S_1;
    float _e83 = S_1;
    float _e87 = a_2;
    param_27 = _e79.yz - metal::float2(0.5 * _e81, -0.5 * _e83);
    param_28 = -(_e87);
    metal::float2 _e89 = rot(param_27, param_28);
    lo = _e89;
    float _e90 = a_2;
    metal::float3 _e92 = d_1;
    param_29 = _e92.yz;
    param_30 = -(_e90);
    metal::float2 _e94 = rot(param_29, param_30);
    ld = _e94;
    float _e96 = ld[0u];
    if (metal::abs(_e96) < 0.000001) {
        local_10 = 0.000001;
    } else {
        float _e100 = ld[0u];
        local_10 = _e100;
    }
    float _e101 = local_10;
    float _e103 = ld[1u];
    if (metal::abs(_e103) < 0.000001) {
        local_11 = 0.000001;
    } else {
        float _e107 = ld[1u];
        local_11 = _e107;
    }
    float _e108 = local_11;
    ld = metal::float2(_e101, _e108);
    float _e111 = d_1[0u];
    if (metal::abs(_e111) < 0.000001) {
        local_12 = 0.000001;
    } else {
        float _e115 = d_1[0u];
        local_12 = _e115;
    }
    float _e116 = local_12;
    dx = _e116;
    float _e117 = a0_;
    float _e119 = o[0u];
    float _e121 = dx;
    float _e123 = S_1;
    metal::float2 _e125 = lo;
    metal::float2 _e128 = ld;
    metal::float2 _e129 = (metal::float2(-0.5 * _e123) - _e125) / _e128;
    t1_ = metal::float3((_e117 - _e119) / _e121, _e129.x, _e129.y);
    float _e133 = a0_;
    float _e134 = w;
    float _e137 = o[0u];
    float _e139 = dx;
    float _e141 = S_1;
    metal::float2 _e143 = lo;
    metal::float2 _e146 = ld;
    metal::float2 _e147 = (metal::float2(0.5 * _e141) - _e143) / _e146;
    t2_ = metal::float3(((_e133 + _e134) - _e137) / _e139, _e147.x, _e147.y);
    metal::float3 _e151 = t1_;
    metal::float3 _e152 = t2_;
    tn = metal::min(_e151, _e152);
    metal::float3 _e154 = t1_;
    metal::float3 _e155 = t2_;
    tf = metal::max(_e154, _e155);
    float _e158 = tn[0u];
    float _e160 = tn[1u];
    float _e162 = tn[2u];
    tNear = metal::max(_e158, metal::max(_e160, _e162));
    float _e166 = tf[0u];
    float _e168 = tf[1u];
    float _e170 = tf[2u];
    tFar = metal::min(_e166, metal::min(_e168, _e170));
    float _e173 = tNear;
    float _e174 = tFar;
    float _e176 = tNear;
    if ((_e173 > _e174) || (_e176 <= 0.0)) {
        return metal::float4(-1.0, -1.0, -1.0, -1.0);
    }
    metal::float2 _e179 = lo;
    float _e180 = tNear;
    metal::float2 _e181 = ld;
    float _e184 = S_1;
    q = (_e179 + (_e181 * _e180)) / metal::float2(0.5 * _e184);
    float _e189 = o[0u];
    float _e190 = tNear;
    float _e192 = d_1[0u];
    across = _e189 + (_e190 * _e192);
    float _e196 = tn[0u];
    float _e198 = tn[1u];
    bool _e199 = _e196 >= _e198;
    phi_702_ = _e199;
    if (_e199) {
        float _e201 = tn[0u];
        float _e203 = tn[2u];
        phi_702_ = _e201 >= _e203;
    }
    bool _e206 = phi_702_;
    if (_e206) {
        float _e207 = tNear;
        float _e208 = across;
        float _e209 = dx;
        return metal::float4(_e207, 4.0, _e208, metal::sign(-(_e209)));
    }
    float _e214 = tn[1u];
    float _e216 = tn[2u];
    if (_e214 > _e216) {
        float _e218 = tNear;
        float _e220 = ld[0u];
        float _e223 = across;
        float _e225 = q[1u];
        return metal::float4(_e218, (_e220 < 0.0) ? 2.0 : 3.0, _e223, _e225);
    }
    float _e227 = tNear;
    float _e229 = ld[1u];
    float _e232 = across;
    float _e234 = q[0u];
    return metal::float4(_e227, (_e229 < 0.0) ? 0.0 : 1.0, _e232, _e234);
}

float turnDir(
    thread bool& isCol_3,
    thread float& idx_1
) {
    float _e57 = idx_1;
    bool _e58 = isCol_3;
    float _e60 = _e57 + (_e58 ? 0.0 : 1.0);
    return ((_e60 - (metal::floor(_e60 / 2.0) * 2.0)) < 0.5) ? 1.0 : -1.0;
}

float turnAngle(
    thread float& t
) {
    float _e56 = t;
    float _e57 = t;
    float _e58 = t;
    float _e60 = t;
    return 1.5707964 * metal::mix(_e56, (_e57 * _e58) * (3.0 - (2.0 * _e60)), 0.8);
}

float groupLength(
    thread float& m
) {
    float local_13 = {};
    float _e57 = m;
    if (_e57 > 0.0) {
        float _e59 = m;
        local_13 = 1.0 + ((_e59 - 1.0) * 0.45);
    } else {
        local_13 = 0.0;
    }
    float _e63 = local_13;
    return _e63;
}

metal::float3 timeline(
    thread float& n_5,
    constant Uniforms& uniforms
) {
    float lenEven = {};
    float param_31 = {};
    float lenOdd = {};
    float param_32 = {};
    float u = {};
    float _e61 = n_5;
    param_31 = metal::floor((_e61 + 1.0) * 0.5);
    float _e65 = groupLength(param_31);
    lenEven = _e65;
    float _e66 = n_5;
    param_32 = metal::floor(_e66 * 0.5);
    float _e69 = groupLength(param_32);
    lenOdd = _e69;
    float _e71 = uniforms.progress;
    float _e75 = lenEven;
    float _e77 = lenOdd;
    u = metal::clamp((_e71 - 0.05) / 0.85, 0.0, 1.0) * ((2.0 * _e75) + _e77);
    float _e80 = u;
    float _e81 = lenEven;
    float _e82 = lenOdd;
    return metal::float3(_e80, _e81, _e82);
}

float gridSize_u0028_(
    constant Uniforms& uniforms
) {
    int local_14 = {};
    int local_15 = {};
    int _e58 = uniforms.size;
    if (_e58 < 2) {
        local_14 = 2;
    } else {
        int _e61 = uniforms.size;
        if (_e61 > 8) {
            local_15 = 8;
        } else {
            int _e64 = uniforms.size;
            local_15 = _e64;
        }
        int _e65 = local_15;
        local_14 = _e65;
    }
    int _e66 = local_14;
    return static_cast<float>(_e66);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n_6 = {};
    metal::float3 tl_3 = {};
    float param_33 = {};
    float g_3 = {};
    metal::float2 P = {};
    bool isCol_4 = {};
    float w_1 = {};
    float local_16 = {};
    float S_2 = {};
    float local_17 = {};
    metal::float2 pp = {};
    metal::float2 local_18 = {};
    metal::float3 o_1 = {};
    metal::float2 local_19 = {};
    metal::float3 d_2 = {};
    float k0_ = {};
    float t0_ = {};
    metal::float3 param_34 = {};
    bool param_35 = {};
    float param_36 = {};
    float param_37 = {};
    float nearest = {};
    metal::float4 color = {};
    metal::float3 param_38 = {};
    metal::float2 param_39 = {};
    float param_40 = {};
    metal::float4 local_20 = {};
    metal::float2 param_41 = {};
    metal::float2 param_42 = {};
    metal::float2 param_43 = {};
    float param_44 = {};
    float param_45 = {};
    int j = {};
    float k_1 = {};
    float tk = {};
    metal::float3 param_46 = {};
    bool param_47 = {};
    float param_48 = {};
    float param_49 = {};
    float dist = {};
    float param_50 = {};
    float tw = {};
    float local_21 = {};
    float local_22 = {};
    float tb = {};
    float along = {};
    float depth = {};
    float light_2 = {};
    float local_23 = {};
    metal::float3 param_51 = {};
    bool param_52 = {};
    metal::float4 local_24 = {};
    int j_1 = {};
    float k_2 = {};
    float tk_1 = {};
    metal::float3 param_53 = {};
    bool param_54 = {};
    float param_55 = {};
    float param_56 = {};
    float dir_1 = {};
    bool param_57 = {};
    float param_58 = {};
    float a_3 = {};
    float param_59 = {};
    metal::float4 hit_1 = {};
    metal::float3 param_60 = {};
    metal::float3 param_61 = {};
    float param_62 = {};
    float param_63 = {};
    float param_64 = {};
    float param_65 = {};
    metal::float4 param_66 = {};
    metal::float3 param_67 = {};
    bool param_68 = {};
    float param_69 = {};
    float param_70 = {};
    float param_71 = {};
    float param_72 = {};
    float param_73 = {};
    bool phi_936_ = {};
    bool phi_1080_ = {};
    bool phi_1285_ = {};
    bool phi_1344_ = {};
    float _e135 = gridSize_u0028_(uniforms);
    n_6 = _e135;
    float _e136 = n_6;
    param_33 = _e136;
    metal::float3 _e137 = timeline(param_33, uniforms);
    tl_3 = _e137;
    float _e139 = uniforms.gap;
    float _e141 = uniforms.progress;
    float _e145 = uniforms.progress;
    g_3 = (_e139 * metal::smoothstep(0.0, 0.1, _e141)) * (1.0 - metal::smoothstep(0.9, 1.0, _e145));
    float _e150 = uv_3[0u];
    float _e152 = uniforms.ratio;
    float _e155 = uv_3[1u];
    P = metal::float2(_e150 * _e152, _e155);
    float _e158 = tl_3[0u];
    float _e160 = tl_3[1u];
    bool _e161 = _e158 < _e160;
    phi_936_ = _e161;
    if (!(_e161)) {
        float _e164 = tl_3[0u];
        float _e166 = tl_3[1u];
        phi_936_ = _e164 >= (2.0 * _e166);
    }
    bool _e170 = phi_936_;
    isCol_4 = _e170;
    bool _e171 = isCol_4;
    if (_e171) {
        float _e173 = uniforms.ratio;
        local_16 = _e173;
    } else {
        local_16 = 1.0;
    }
    float _e174 = local_16;
    float _e175 = n_6;
    w_1 = _e174 / _e175;
    bool _e177 = isCol_4;
    if (_e177) {
        local_17 = 1.0;
    } else {
        float _e179 = uniforms.ratio;
        local_17 = _e179;
    }
    float _e180 = local_17;
    S_2 = _e180;
    bool _e181 = isCol_4;
    if (_e181) {
        metal::float2 _e182 = P;
        local_18 = _e182;
    } else {
        metal::float2 _e183 = P;
        local_18 = _e183.yx;
    }
    metal::float2 _e185 = local_18;
    pp = _e185;
    bool _e186 = isCol_4;
    if (_e186) {
        float _e188 = uniforms.ratio;
        local_19 = metal::float2(0.5 * _e188, 0.5);
    } else {
        float _e192 = uniforms.ratio;
        local_19 = metal::float2(0.5, 0.5 * _e192);
    }
    metal::float2 _e195 = local_19;
    float _e197 = uniforms.ratio;
    o_1 = metal::float3(_e195.x, _e195.y, 1.2 + (0.6 * metal::max(_e197, 1.0)));
    metal::float2 _e204 = pp;
    metal::float3 _e208 = o_1;
    d_2 = metal::float3(_e204.x, _e204.y, 0.0) - _e208;
    float _e211 = pp[0u];
    float _e212 = w_1;
    float _e215 = n_6;
    k0_ = metal::clamp(metal::floor(_e211 / _e212), 0.0, _e215 - 1.0);
    metal::float3 _e218 = tl_3;
    param_34 = _e218;
    bool _e219 = isCol_4;
    param_35 = _e219;
    float _e220 = k0_;
    param_36 = _e220;
    float _e221 = n_6;
    param_37 = _e221;
    float _e222 = turnTime(param_34, param_35, param_36, param_37);
    t0_ = _e222;
    nearest = 1.0;
    float _e223 = t0_;
    float _e225 = t0_;
    if ((_e223 <= 0.0) || (_e225 >= 1.0)) {
        metal::float3 _e228 = tl_3;
        param_38 = _e228;
        metal::float2 _e229 = P;
        param_39 = _e229;
        float _e230 = n_6;
        param_40 = _e230;
        bool _e231 = isDone(param_38, param_39, param_40, uniforms);
        if (_e231) {
            metal::float2 _e232 = uv_3;
            param_41 = _e232;
            metal::float4 _e233 = getToColor(param_41, _sampler, _to);
            local_20 = _e233;
        } else {
            metal::float2 _e234 = uv_3;
            param_42 = _e234;
            metal::float4 _e235 = getFromColor(param_42, _from, _sampler);
            local_20 = _e235;
        }
        metal::float4 _e236 = local_20;
        color = _e236;
        metal::float4 _e238 = uniforms.background;
        metal::float4 _e239 = color;
        metal::float2 _e240 = P;
        param_43 = _e240;
        float _e241 = n_6;
        param_44 = _e241;
        float _e242 = g_3;
        param_45 = _e242;
        float _e243 = faceMask(param_43, param_44, param_45, uniforms);
        color = metal::mix(_e238, _e239, metal::float4(_e243));
        j = -1;
        uint2 loop_bound = uint2(4294967295u);
        bool loop_init = true;
        while(true) {
            if (metal::all(loop_bound == uint2(0u))) { break; }
            loop_bound -= uint2(loop_bound.y == 0u, 1u);
            if (!loop_init) {
                int _e307 = j;
                j = as_type<int>(as_type<uint>(_e307) + as_type<uint>(2));
            }
            loop_init = false;
            int _e246 = j;
            if (_e246 <= 1) {
                float _e248 = k0_;
                int _e249 = j;
                k_1 = _e248 + static_cast<float>(_e249);
                float _e252 = k_1;
                bool _e253 = _e252 < 0.0;
                phi_1080_ = _e253;
                if (!(_e253)) {
                    float _e255 = k_1;
                    float _e256 = n_6;
                    phi_1080_ = _e255 > (_e256 - 1.0);
                }
                bool _e260 = phi_1080_;
                if (_e260) {
                    continue;
                }
                metal::float3 _e261 = tl_3;
                param_46 = _e261;
                bool _e262 = isCol_4;
                param_47 = _e262;
                float _e263 = k_1;
                param_48 = _e263;
                float _e264 = n_6;
                param_49 = _e264;
                float _e265 = turnTime(param_46, param_47, param_48, param_49);
                tk = _e265;
                float _e266 = tk;
                float _e268 = tk;
                if ((_e266 <= 0.0) || (_e268 >= 1.0)) {
                    continue;
                }
                float _e272 = pp[0u];
                float _e273 = k_1;
                float _e275 = w_1;
                float _e279 = w_1;
                dist = metal::abs(_e272 - ((_e273 + 0.5) * _e275)) - (0.5 * _e279);
                float _e283 = uniforms.shading;
                float _e285 = tk;
                param_50 = _e285;
                float _e286 = turnAngle(param_50);
                float _e290 = dist;
                float _e292 = w_1;
                metal::float4 _e298 = color;
                metal::float3 _e300 = _e298.xyz * (1.0 - (((0.5 * _e283) * metal::sin(2.0 * _e286)) * metal::exp(-(_e290) / (0.2 * _e292))));
                color[0u] = _e300.x;
                color[1u] = _e300.y;
                color[2u] = _e300.z;
                continue;
            } else {
                break;
            }
        }
    } else {
        float _e310 = d_2[0u];
        if (metal::abs(_e310) < 0.000001) {
            local_21 = 1000000.0;
        } else {
            float _e314 = d_2[0u];
            if (_e314 < 0.0) {
                float _e316 = k0_;
                float _e317 = w_1;
                float _e320 = o_1[0u];
                local_22 = (_e316 * _e317) - _e320;
            } else {
                float _e322 = k0_;
                float _e324 = w_1;
                float _e327 = o_1[0u];
                local_22 = ((_e322 + 1.0) * _e324) - _e327;
            }
            float _e329 = local_22;
            float _e331 = d_2[0u];
            local_21 = _e329 / _e331;
        }
        float _e333 = local_21;
        tw = _e333;
        float _e335 = o_1[2u];
        float _e336 = S_2;
        float _e339 = d_2[2u];
        tb = (_e335 + _e336) / -(_e339);
        float _e342 = tw;
        float _e343 = tb;
        nearest = metal::min(_e342, _e343);
        float _e346 = o_1[1u];
        float _e347 = nearest;
        float _e349 = d_2[1u];
        along = _e346 + (_e347 * _e349);
        float _e353 = o_1[2u];
        float _e354 = nearest;
        float _e356 = d_2[2u];
        float _e359 = S_2;
        depth = (_e353 + (_e354 * _e356)) / -(_e359);
        float _e362 = tw;
        float _e363 = tb;
        if (_e362 < _e363) {
            float _e366 = d_2[0u];
            param_51 = metal::float3(-(metal::sign(_e366)), 0.0, 0.0);
            bool _e370 = isCol_4;
            param_52 = _e370;
            float _e371 = lighting(param_51, param_52, uniforms);
            local_23 = _e371;
        } else {
            local_23 = 1.0;
        }
        float _e372 = local_23;
        light_2 = _e372;
        float _e374 = uniforms.shading;
        float _e375 = depth;
        float _e381 = light_2;
        light_2 = _e381 * (1.0 - (_e374 * (0.5 + (0.4 * metal::clamp(_e375, 0.0, 1.0)))));
        float _e383 = along;
        float _e385 = along;
        float _e386 = S_2;
        if ((_e383 < 0.0) || (_e385 > _e386)) {
            metal::float4 _e390 = uniforms.background;
            local_24 = _e390;
        } else {
            metal::float4 _e392 = uniforms.background;
            float _e394 = light_2;
            metal::float3 _e395 = _e392.xyz * _e394;
            float _e398 = uniforms.background[3u];
            local_24 = metal::float4(_e395.x, _e395.y, _e395.z, _e398);
        }
        metal::float4 _e403 = local_24;
        color = _e403;
    }
    j_1 = -1;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e465 = j_1;
            j_1 = as_type<int>(as_type<uint>(_e465) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e404 = j_1;
        if (_e404 <= 1) {
            float _e406 = k0_;
            int _e407 = j_1;
            k_2 = _e406 + static_cast<float>(_e407);
            float _e410 = k_2;
            bool _e411 = _e410 < 0.0;
            phi_1285_ = _e411;
            if (!(_e411)) {
                float _e413 = k_2;
                float _e414 = n_6;
                phi_1285_ = _e413 > (_e414 - 1.0);
            }
            bool _e418 = phi_1285_;
            if (_e418) {
                continue;
            }
            metal::float3 _e419 = tl_3;
            param_53 = _e419;
            bool _e420 = isCol_4;
            param_54 = _e420;
            float _e421 = k_2;
            param_55 = _e421;
            float _e422 = n_6;
            param_56 = _e422;
            float _e423 = turnTime(param_53, param_54, param_55, param_56);
            tk_1 = _e423;
            float _e424 = tk_1;
            float _e426 = tk_1;
            if ((_e424 <= 0.0) || (_e426 >= 1.0)) {
                continue;
            }
            bool _e429 = isCol_4;
            param_57 = _e429;
            float _e430 = k_2;
            param_58 = _e430;
            float _e431 = turnDir(param_57, param_58);
            dir_1 = _e431;
            float _e432 = dir_1;
            float _e433 = tk_1;
            param_59 = _e433;
            float _e434 = turnAngle(param_59);
            a_3 = _e432 * _e434;
            float _e436 = k_2;
            float _e437 = w_1;
            metal::float3 _e439 = o_1;
            param_60 = _e439;
            metal::float3 _e440 = d_2;
            param_61 = _e440;
            param_62 = _e436 * _e437;
            float _e441 = w_1;
            param_63 = _e441;
            float _e442 = S_2;
            param_64 = _e442;
            float _e443 = a_3;
            param_65 = _e443;
            metal::float4 _e444 = sliceHit(param_60, param_61, param_62, param_63, param_64, param_65);
            hit_1 = _e444;
            float _e446 = hit_1[0u];
            bool _e447 = _e446 > 0.0;
            phi_1344_ = _e447;
            if (_e447) {
                float _e449 = hit_1[0u];
                float _e450 = nearest;
                phi_1344_ = _e449 < _e450;
            }
            bool _e453 = phi_1344_;
            if (_e453) {
                float _e455 = hit_1[0u];
                nearest = _e455;
                metal::float4 _e456 = hit_1;
                param_66 = _e456;
                metal::float3 _e457 = tl_3;
                param_67 = _e457;
                bool _e458 = isCol_4;
                param_68 = _e458;
                float _e459 = a_3;
                param_69 = _e459;
                float _e460 = dir_1;
                param_70 = _e460;
                float _e461 = S_2;
                param_71 = _e461;
                float _e462 = n_6;
                param_72 = _e462;
                float _e463 = g_3;
                param_73 = _e463;
                metal::float4 _e464 = sliceColor(param_66, param_67, param_68, param_69, param_70, param_71, param_72, param_73, _from, _sampler, _to, uniforms);
                color = _e464;
            }
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e467 = color;
    return _e467;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_74 = {};
    metal::float2 _e56 = _uv_1;
    param_74 = _e56;
    metal::float4 _e57 = transition(param_74, _from, _sampler, _to, uniforms);
    _fragColor = _e57;
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
