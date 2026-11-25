// Reassemble — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Reassemble.glsl
// Author: gre
// License: MIT
// Description: The outgoing image cracks into irregular shards that burst apart toward the viewer, each one turning over in 3D at its own moment, then fly back together and lock into place as the incoming image carried on their backs
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int rows;
    float depth;
    float spread;
    char _pad5[12];
    metal::float4 backColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e68 = uv[0u];
    float _e70 = uv[1u];
    metal::float4 _e73 = _to.sample(_sampler, metal::float2(_e68, 1.0 - _e70), metal::level(0.0));
    return _e73;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e68 = uv_1[0u];
    float _e70 = uv_1[1u];
    metal::float4 _e73 = _from.sample(_sampler, metal::float2(_e68, 1.0 - _e70), metal::level(0.0));
    return _e73;
}

metal::float3 hash3(
    thread metal::float2& p
) {
    metal::float3 q = {};
    metal::float2 _e68 = p;
    q = metal::fract(_e68.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e72 = q;
    metal::float3 _e73 = q;
    metal::float3 _e78 = q;
    q = _e78 + metal::float3(metal::dot(_e72, _e73.yxz + metal::float3(33.33)));
    metal::float3 _e81 = q;
    metal::float3 _e83 = q;
    metal::float3 _e86 = q;
    return metal::fract((_e81.xxy + _e83.yzz) * _e86.zyx);
}

metal::float2 seed(
    thread metal::float2& g,
    thread float& size
) {
    metal::float2 param = {};
    metal::float2 _e69 = g;
    metal::float2 _e72 = g;
    param = _e72;
    metal::float3 _e73 = hash3(param);
    float _e79 = size;
    return ((_e69 + metal::float2(0.5)) + ((_e73.xy - metal::float2(0.5)) * 0.7)) * _e79;
}

float shardDist(
    thread metal::float2& q_1,
    thread metal::float2& g_1,
    thread float& size_1
) {
    metal::float2 sj = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float d = {};
    int y = {};
    int x = {};
    metal::float2 sk = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    metal::float2 dir = {};
    metal::float2 _e79 = g_1;
    param_1 = _e79;
    float _e80 = size_1;
    param_2 = _e80;
    metal::float2 _e81 = seed(param_1, param_2);
    sj = _e81;
    d = 1000000000.0;
    y = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e118 = y;
            y = as_type<int>(as_type<uint>(_e118) + as_type<uint>(1));
        }
        loop_init = false;
        int _e82 = y;
        if (_e82 <= 1) {
            x = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e116 = x;
                    x = as_type<int>(as_type<uint>(_e116) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e84 = x;
                if (_e84 <= 1) {
                    int _e86 = x;
                    int _e88 = y;
                    if ((_e86 == 0) && (_e88 == 0)) {
                        continue;
                    }
                    metal::float2 _e91 = g_1;
                    int _e92 = x;
                    int _e94 = y;
                    param_3 = _e91 + metal::float2(static_cast<float>(_e92), static_cast<float>(_e94));
                    float _e98 = size_1;
                    param_4 = _e98;
                    metal::float2 _e99 = seed(param_3, param_4);
                    sk = _e99;
                    metal::float2 _e100 = sk;
                    metal::float2 _e101 = sj;
                    dir = _e100 - _e101;
                    float _e103 = d;
                    metal::float2 _e104 = sj;
                    metal::float2 _e105 = sk;
                    metal::float2 _e108 = q_1;
                    metal::float2 _e110 = dir;
                    metal::float2 _e112 = dir;
                    d = metal::min(_e103, metal::dot(((_e104 + _e105) * 0.5) - _e108, _e110) / metal::length(_e112));
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
    float _e120 = d;
    return _e120;
}

float ease(
    thread float& t
) {
    float _e67 = t;
    float _e68 = t;
    float _e70 = t;
    return (_e67 * _e68) * (3.0 - (2.0 * _e70));
}

float burst(
    thread float& t_1
) {
    float u = {};
    float v = {};
    float local = {};
    float param_5 = {};
    float _e71 = t_1;
    u = metal::clamp(_e71 / 0.4, 0.0, 1.0);
    float _e74 = t_1;
    v = metal::clamp((_e74 - 0.4) / 0.6, 0.0, 1.0);
    float _e78 = t_1;
    if (_e78 < 0.4) {
        float _e80 = u;
        float _e82 = u;
        local = 1.0 - ((1.0 - _e80) * (1.0 - _e82));
    } else {
        float _e86 = v;
        param_5 = _e86;
        float _e87 = ease(param_5);
        local = 1.0 - _e87;
    }
    float _e89 = local;
    return _e89;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 aspect = {};
    metal::float2 x_1 = {};
    float size_2 = {};
    float E = {};
    float Z = {};
    float p_1 = {};
    metal::float3 L = {};
    metal::float3 H = {};
    metal::float3 eye = {};
    metal::float3 dir_1 = {};
    float act = {};
    float b0_ = {};
    float param_6 = {};
    metal::float2 x0_ = {};
    metal::float2 cell0_ = {};
    float z1_ = {};
    float z2_ = {};
    metal::float2 q1_ = {};
    metal::float2 q2_ = {};
    float f1_ = {};
    float f2_ = {};
    float m1_ = {};
    float m2_ = {};
    float s1_ = {};
    float s2_ = {};
    float r1_ = {};
    float r2_ = {};
    int j = {};
    int i = {};
    metal::float2 g_2 = {};
    metal::float3 h = {};
    metal::float2 param_7 = {};
    float t_2 = {};
    float b = {};
    float param_8 = {};
    float th = {};
    float param_9 = {};
    float ct = {};
    float st = {};
    float phi = {};
    float rz = {};
    metal::float2 a0_ = {};
    metal::float2 p0_ = {};
    metal::float3 a = {};
    metal::float3 w = {};
    metal::float2 c = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    metal::float3 center = {};
    metal::float3 nrm = {};
    float den = {};
    float lam = {};
    metal::float3 hit = {};
    float u_1 = {};
    float v_1 = {};
    float front = {};
    metal::float2 q_2 = {};
    float k = {};
    float e = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    metal::float2 box = {};
    float m = {};
    float zk = {};
    metal::float3 n = {};
    float lit = {};
    float glint = {};
    float lock = {};
    float rim = {};
    metal::float4 col = {};
    metal::float2 src = {};
    metal::float4 img = {};
    metal::float4 local_1 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 src_1 = {};
    metal::float4 img_1 = {};
    metal::float4 local_2 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    float _e149 = uniforms.ratio;
    aspect = metal::float2(_e149, 1.0);
    metal::float2 _e151 = uv_2;
    metal::float2 _e154 = aspect;
    x_1 = (_e151 - metal::float2(0.5)) * _e154;
    int _e157 = uniforms.rows;
    size_2 = 1.0 / metal::clamp(static_cast<float>(_e157), 1.0, 8.0);
    float _e162 = uniforms.spread;
    E = metal::clamp(_e162, 0.0, 0.5);
    float _e165 = uniforms.depth;
    Z = metal::clamp(_e165, 0.0, 1.0);
    float _e168 = uniforms.progress;
    p_1 = metal::clamp(_e168, 0.0, 1.0);
    L = metal::float3(-0.36681262, 0.44832653, 0.8151392);
    metal::float3 _e170 = L;
    H = metal::normalize(_e170 + metal::float3(0.0, 0.0, 1.0));
    eye = metal::float3(0.0, 0.0, 2.5);
    metal::float2 _e173 = x_1;
    dir_1 = metal::float3(_e173.x, _e173.y, -2.5);
    float _e177 = p_1;
    float _e179 = p_1;
    act = metal::smoothstep(0.0, 0.11, _e177) * (1.0 - metal::smoothstep(0.89, 1.0, _e179));
    float _e183 = p_1;
    param_6 = metal::clamp(((_e183 - 0.03) - 0.04) / 0.86, 0.0, 1.0);
    float _e188 = burst(param_6);
    b0_ = _e188;
    metal::float2 _e189 = x_1;
    float _e190 = Z;
    float _e192 = b0_;
    float _e198 = E;
    float _e199 = b0_;
    x0_ = ((_e189 * (2.5 - ((0.75 * _e190) * _e192))) / metal::float2(2.5)) / metal::float2(1.0 + (_e198 * _e199));
    metal::float2 _e204 = x0_;
    float _e205 = size_2;
    cell0_ = metal::floor(_e204 / metal::float2(_e205));
    z1_ = 1000000000.0;
    z2_ = 1000000000.0;
    metal::float2 _e209 = x_1;
    q1_ = _e209;
    metal::float2 _e210 = x_1;
    q2_ = _e210;
    f1_ = 1.0;
    f2_ = 1.0;
    m1_ = 0.0;
    m2_ = 0.0;
    s1_ = 1.0;
    s2_ = 1.0;
    r1_ = 0.0;
    r2_ = 0.0;
    j = -1;
    uint2 loop_bound_2 = uint2(4294967295u);
    bool loop_init_2 = true;
    while(true) {
        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
        if (!loop_init_2) {
            int _e473 = j;
            j = as_type<int>(as_type<uint>(_e473) + as_type<uint>(1));
        }
        loop_init_2 = false;
        int _e211 = j;
        if (_e211 <= 1) {
            i = -1;
            uint2 loop_bound_3 = uint2(4294967295u);
            bool loop_init_3 = true;
            while(true) {
                if (metal::all(loop_bound_3 == uint2(0u))) { break; }
                loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
                if (!loop_init_3) {
                    int _e471 = i;
                    i = as_type<int>(as_type<uint>(_e471) + as_type<uint>(1));
                }
                loop_init_3 = false;
                int _e213 = i;
                if (_e213 <= 1) {
                    metal::float2 _e215 = cell0_;
                    int _e216 = i;
                    int _e218 = j;
                    g_2 = _e215 + metal::float2(static_cast<float>(_e216), static_cast<float>(_e218));
                    metal::float2 _e222 = g_2;
                    param_7 = _e222 + metal::float2(17.0);
                    metal::float3 _e225 = hash3(param_7);
                    h = _e225;
                    float _e226 = p_1;
                    float _e229 = h[0u];
                    t_2 = metal::clamp(((_e226 - 0.03) - (0.08 * _e229)) / 0.86, 0.0, 1.0);
                    float _e234 = t_2;
                    param_8 = _e234;
                    float _e235 = burst(param_8);
                    b = _e235;
                    float _e236 = t_2;
                    float _e239 = h[2u];
                    param_9 = metal::clamp(((_e236 - 0.1) - (0.48 * _e239)) / 0.24, 0.0, 1.0);
                    float _e244 = ease(param_9);
                    th = 3.1415927 * _e244;
                    float _e246 = th;
                    ct = metal::cos(_e246);
                    float _e248 = th;
                    st = metal::sin(_e248);
                    float _e251 = h[1u];
                    phi = 3.1415927 * _e251;
                    float _e254 = h[2u];
                    float _e257 = b;
                    rz = (0.5 * (_e254 - 0.5)) * _e257;
                    float _e259 = phi;
                    float _e261 = phi;
                    a0_ = metal::float2(metal::cos(_e259), metal::sin(_e261));
                    float _e265 = a0_[1u];
                    float _e268 = a0_[0u];
                    p0_ = metal::float2(-(_e265), _e268);
                    float _e270 = phi;
                    float _e271 = rz;
                    float _e274 = phi;
                    float _e275 = rz;
                    a = metal::float3(metal::cos(_e270 + _e271), metal::sin(_e274 + _e275), 0.0);
                    float _e280 = a[1u];
                    float _e283 = a[0u];
                    float _e285 = ct;
                    float _e287 = st;
                    w = (metal::float3(-(_e280), _e283, 0.0) * _e285) + metal::float3(0.0, 0.0, _e287);
                    metal::float2 _e290 = g_2;
                    param_10 = _e290;
                    float _e291 = size_2;
                    param_11 = _e291;
                    metal::float2 _e292 = seed(param_10, param_11);
                    c = _e292;
                    metal::float2 _e293 = c;
                    float _e294 = E;
                    float _e295 = b;
                    metal::float2 _e298 = _e293 * (1.0 + (_e294 * _e295));
                    float _e299 = Z;
                    float _e300 = b;
                    float _e303 = h[0u];
                    center = metal::float3(_e298.x, _e298.y, (_e299 * _e300) * (0.5 + (0.5 * _e303)));
                    metal::float3 _e310 = a;
                    metal::float3 _e311 = w;
                    nrm = metal::cross(_e310, _e311);
                    metal::float3 _e313 = dir_1;
                    metal::float3 _e314 = nrm;
                    den = metal::dot(_e313, _e314);
                    float _e316 = den;
                    if (metal::abs(_e316) < 0.000001) {
                        continue;
                    }
                    metal::float3 _e319 = center;
                    metal::float3 _e320 = eye;
                    metal::float3 _e322 = nrm;
                    float _e324 = den;
                    lam = metal::dot(_e319 - _e320, _e322) / _e324;
                    float _e326 = lam;
                    if (_e326 <= 0.0) {
                        continue;
                    }
                    metal::float3 _e328 = eye;
                    float _e329 = lam;
                    metal::float3 _e330 = dir_1;
                    metal::float3 _e333 = center;
                    hit = (_e328 + (_e330 * _e329)) - _e333;
                    metal::float3 _e335 = hit;
                    metal::float3 _e336 = a;
                    u_1 = metal::dot(_e335, _e336);
                    metal::float3 _e338 = hit;
                    metal::float3 _e339 = w;
                    v_1 = metal::dot(_e338, _e339);
                    float _e341 = den;
                    front = (_e341 < 0.0) ? 1.0 : -1.0;
                    metal::float2 _e344 = c;
                    float _e345 = u_1;
                    metal::float2 _e346 = a0_;
                    float _e349 = front;
                    float _e350 = v_1;
                    metal::float2 _e352 = p0_;
                    q_2 = (_e344 + (_e346 * _e345)) + (_e352 * (_e349 * _e350));
                    float _e356 = center[2u];
                    k = 2.5 / (2.5 - _e356);
                    metal::float2 _e359 = q_2;
                    param_12 = _e359;
                    metal::float2 _e360 = g_2;
                    param_13 = _e360;
                    float _e361 = size_2;
                    param_14 = _e361;
                    float _e362 = shardDist(param_12, param_13, param_14);
                    float _e363 = act;
                    e = _e362 - (0.005 * _e363);
                    metal::float2 _e366 = aspect;
                    metal::float2 _e368 = q_2;
                    box = (_e366 * 0.5) - metal::abs(_e368);
                    float _e371 = e;
                    float _e373 = box[0u];
                    float _e375 = box[1u];
                    float _e378 = k;
                    float _e380 = ct;
                    float _e383 = b;
                    float _e388 = act;
                    e = ((metal::min(_e371, metal::min(_e373, _e375)) * _e378) * metal::mix(1.0, metal::max(metal::abs(_e380), 0.2), metal::min(_e383 * 8.0, 1.0))) + (0.006 * (1.0 - _e388));
                    float _e392 = e;
                    m = metal::clamp((_e392 / 0.003) + 0.5, 0.0, 1.0);
                    float _e396 = lam;
                    float _e397 = m;
                    zk = _e396 - (0.001 * _e397);
                    float _e400 = m;
                    float _e402 = zk;
                    float _e403 = z2_;
                    if ((_e400 <= 0.0) || (_e402 >= _e403)) {
                        continue;
                    }
                    metal::float3 _e406 = nrm;
                    float _e407 = front;
                    n = _e406 * _e407;
                    metal::float3 _e409 = n;
                    metal::float3 _e410 = L;
                    float _e413 = L[2u];
                    lit = metal::mix(0.45, 1.0, metal::clamp(metal::dot(_e409, _e410) / _e413, 0.0, 1.0));
                    float _e417 = b;
                    metal::float3 _e421 = n;
                    metal::float3 _e422 = H;
                    glint = (0.2 * metal::min(_e417 * 4.0, 1.0)) * metal::pow(metal::max(metal::dot(_e421, _e422), 0.0), 24.0);
                    float _e427 = t_2;
                    lock = metal::sin(3.1415927 * metal::clamp((_e427 - 0.86) / 0.14, 0.0, 1.0));
                    float _e433 = act;
                    float _e435 = b;
                    float _e439 = lock;
                    float _e442 = e;
                    rim = (((0.3 * _e433) * metal::min(_e435 * 4.0, 1.0)) + (0.35 * _e439)) * (1.0 - metal::smoothstep(0.0, 0.006, _e442));
                    float _e446 = zk;
                    float _e447 = z1_;
                    if (_e446 < _e447) {
                        float _e449 = z1_;
                        z2_ = _e449;
                        metal::float2 _e450 = q1_;
                        q2_ = _e450;
                        float _e451 = f1_;
                        f2_ = _e451;
                        float _e452 = m1_;
                        m2_ = _e452;
                        float _e453 = s1_;
                        s2_ = _e453;
                        float _e454 = r1_;
                        r2_ = _e454;
                        float _e455 = zk;
                        z1_ = _e455;
                        metal::float2 _e456 = q_2;
                        q1_ = _e456;
                        float _e457 = front;
                        f1_ = _e457;
                        float _e458 = m;
                        m1_ = _e458;
                        float _e459 = lit;
                        float _e460 = glint;
                        s1_ = _e459 + _e460;
                        float _e462 = rim;
                        r1_ = _e462;
                    } else {
                        float _e463 = zk;
                        z2_ = _e463;
                        metal::float2 _e464 = q_2;
                        q2_ = _e464;
                        float _e465 = front;
                        f2_ = _e465;
                        float _e466 = m;
                        m2_ = _e466;
                        float _e467 = lit;
                        float _e468 = glint;
                        s2_ = _e467 + _e468;
                        float _e470 = rim;
                        r2_ = _e470;
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
    metal::float4 _e476 = uniforms.backColor;
    col = _e476;
    float _e477 = m2_;
    if (_e477 > 0.0) {
        metal::float2 _e479 = q2_;
        metal::float2 _e480 = aspect;
        src = (_e479 / _e480) + metal::float2(0.5);
        float _e484 = f2_;
        if (_e484 > 0.0) {
            metal::float2 _e486 = src;
            param_15 = _e486;
            metal::float4 _e487 = getFromColor(param_15, _from, _sampler);
            local_1 = _e487;
        } else {
            metal::float2 _e488 = src;
            param_16 = _e488;
            metal::float4 _e489 = getToColor(param_16, _sampler, _to);
            local_1 = _e489;
        }
        metal::float4 _e490 = local_1;
        img = _e490;
        metal::float4 _e491 = img;
        float _e493 = s2_;
        float _e496 = img[3u];
        float _e500 = img[3u];
        float _e502 = r2_;
        metal::float3 _e504 = metal::mix(metal::min(_e491.xyz * _e493, metal::float3(_e496)), metal::float3(_e500), metal::float3(_e502));
        img[0u] = _e504.x;
        img[1u] = _e504.y;
        img[2u] = _e504.z;
        metal::float4 _e511 = col;
        metal::float4 _e512 = img;
        float _e513 = m2_;
        col = metal::mix(_e511, _e512, metal::float4(_e513));
    }
    float _e516 = m1_;
    if (_e516 > 0.0) {
        metal::float2 _e518 = q1_;
        metal::float2 _e519 = aspect;
        src_1 = (_e518 / _e519) + metal::float2(0.5);
        float _e523 = f1_;
        if (_e523 > 0.0) {
            metal::float2 _e525 = src_1;
            param_17 = _e525;
            metal::float4 _e526 = getFromColor(param_17, _from, _sampler);
            local_2 = _e526;
        } else {
            metal::float2 _e527 = src_1;
            param_18 = _e527;
            metal::float4 _e528 = getToColor(param_18, _sampler, _to);
            local_2 = _e528;
        }
        metal::float4 _e529 = local_2;
        img_1 = _e529;
        metal::float4 _e530 = img_1;
        float _e532 = s1_;
        float _e535 = img_1[3u];
        float _e539 = img_1[3u];
        float _e541 = r1_;
        metal::float3 _e543 = metal::mix(metal::min(_e530.xyz * _e532, metal::float3(_e535)), metal::float3(_e539), metal::float3(_e541));
        img_1[0u] = _e543.x;
        img_1[1u] = _e543.y;
        img_1[2u] = _e543.z;
        metal::float4 _e550 = col;
        metal::float4 _e551 = img_1;
        float _e552 = m1_;
        col = metal::mix(_e550, _e551, metal::float4(_e552));
    }
    metal::float4 _e555 = col;
    return _e555;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_19 = {};
    metal::float2 _e67 = _uv_1;
    param_19 = _e67;
    metal::float4 _e68 = transition(param_19, _from, _sampler, _to, uniforms);
    _fragColor = _e68;
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
