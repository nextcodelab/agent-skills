// WaveWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WaveWipe.glsl
// Author: gre
// License: MIT
// Description: A breaking wave crashes across the frame, its lip curling over in front of its face and throwing foam and spray ahead, its shadow darkening the outgoing image; the incoming image is left behind it, tinted and bent by the water, clearing as the wave passes
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float curl;
    float foam;
    float refraction;
    char _pad6[4];
    metal::float4 water;
    metal::float4 foamColor;
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e88 = v;
    metal::float2 _e89 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e88 - (metal::floor(_e88 / _e89) * _e89)));
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e89 = v_1;
    v3_ = metal::fract(_e89.xyx * 0.1031);
    metal::float3 _e93 = v3_;
    metal::float3 _e94 = v3_;
    metal::float3 _e99 = v3_;
    v3_ = _e99 + metal::float3(metal::dot(_e93, _e94.yzx + metal::float3(33.33)));
    float _e103 = v3_[0u];
    float _e105 = v3_[1u];
    float _e108 = v3_[2u];
    return metal::fract((_e103 + _e105) * _e108);
}

float droplets(
    thread metal::float2& q,
    thread float& cell,
    thread float& density,
    thread float& seed
) {
    metal::float2 g = {};
    metal::float2 id = {};
    metal::float2 param = {};
    float r = {};
    metal::float2 param_1 = {};
    metal::float2 c = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float px = {};
    metal::float2 _e100 = q;
    float _e101 = cell;
    g = _e100 / metal::float2(_e101);
    metal::float2 _e104 = g;
    id = metal::floor(_e104);
    metal::float2 _e106 = id;
    float _e107 = seed;
    param = _e106 + metal::float2(_e107);
    float _e110 = hash12(param);
    float _e111 = density;
    if (_e110 >= _e111) {
        return 0.0;
    }
    metal::float2 _e113 = id;
    float _e114 = seed;
    param_1 = (_e113 + metal::float2(_e114)) + metal::float2(4.7);
    float _e119 = hash12(param_1);
    r = 0.1 + (0.2 * _e119);
    metal::float2 _e122 = id;
    float _e125 = r;
    metal::float2 _e127 = id;
    float _e128 = seed;
    param_2 = (_e127 + metal::float2(_e128)) + metal::float2(1.3);
    float _e133 = hash12(param_2);
    metal::float2 _e134 = id;
    float _e135 = seed;
    param_3 = (_e134 + metal::float2(_e135)) + metal::float2(8.1);
    float _e140 = hash12(param_3);
    c = (_e122 + metal::float2(0.5)) + (((metal::float2(_e133, _e140) * 2.0) - metal::float2(1.0)) * (0.45 - _e125));
    float _e147 = cell;
    px = 0.002 / _e147;
    float _e149 = r;
    float _e150 = px;
    float _e152 = r;
    float _e153 = px;
    metal::float2 _e155 = g;
    metal::float2 _e156 = c;
    return 1.0 - metal::smoothstep(_e149 - _e150, _e152 + _e153, metal::length(_e155 - _e156));
}

float vnoise(
    thread metal::float2& v_2
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 _e94 = v_2;
    i = metal::floor(_e94);
    metal::float2 _e96 = v_2;
    f = metal::fract(_e96);
    metal::float2 _e98 = f;
    metal::float2 _e99 = f;
    metal::float2 _e101 = f;
    f = (_e98 * _e99) * (metal::float2(3.0) - (_e101 * 2.0));
    metal::float2 _e106 = i;
    param_4 = _e106;
    float _e107 = hash12(param_4);
    metal::float2 _e108 = i;
    param_5 = _e108 + metal::float2(1.0, 0.0);
    float _e110 = hash12(param_5);
    float _e112 = f[0u];
    metal::float2 _e114 = i;
    param_6 = _e114 + metal::float2(0.0, 1.0);
    float _e116 = hash12(param_6);
    metal::float2 _e117 = i;
    param_7 = _e117 + metal::float2(1.0, 1.0);
    float _e119 = hash12(param_7);
    float _e121 = f[0u];
    float _e124 = f[1u];
    return metal::mix(metal::mix(_e107, _e110, _e112), metal::mix(_e116, _e119, _e121), _e124);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e89 = uv[0u];
    float _e91 = uv[1u];
    metal::float4 _e94 = _to.sample(_sampler, metal::float2(_e89, 1.0 - _e91), metal::level(0.0));
    return _e94;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e89 = uv_1[0u];
    float _e91 = uv_1[1u];
    metal::float4 _e94 = _from.sample(_sampler, metal::float2(_e89, 1.0 - _e91), metal::level(0.0));
    return _e94;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float t = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 up = {};
    float e = {};
    float w = {};
    metal::float2 p = {};
    metal::float2 q_1 = {};
    float E = {};
    float R = {};
    float Rb = {};
    float tipAngle = {};
    float travel = {};
    metal::float2 C = {};
    metal::float2 d = {};
    float r_1 = {};
    float ang = {};
    float k = {};
    float rIn = {};
    bool curled = {};
    float s = {};
    float face = {};
    float behind = {};
    float wet = {};
    float local_1 = {};
    float lip = {};
    float local_2 = {};
    float n = {};
    metal::float2 param_10 = {};
    metal::float4 a = {};
    metal::float2 param_11 = {};
    float gap = {};
    float shade = {};
    float fwd = {};
    float zone = {};
    metal::float2 sq = {};
    float thin = {};
    float spray = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float mist = {};
    float band = {};
    float bend = {};
    metal::float2 off = {};
    metal::float4 b = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    float luma = {};
    metal::float3 tinted = {};
    float local_3 = {};
    float crest = {};
    float local_4 = {};
    float churn = {};
    metal::float4 c_1 = {};
    metal::float4 local_5 = {};
    bool phi_308_ = {};
    bool phi_309_ = {};
    float _e152 = uniforms.progress;
    if (_e152 <= 0.0) {
        metal::float2 _e154 = uv_2;
        param_8 = _e154;
        metal::float4 _e155 = getFromColor(param_8, _from, _sampler);
        return _e155;
    }
    float _e157 = uniforms.progress;
    if (_e157 >= 1.0) {
        metal::float2 _e159 = uv_2;
        param_9 = _e159;
        metal::float4 _e160 = getToColor(param_9, _sampler, _to);
        return _e160;
    }
    float _e162 = uniforms.progress;
    t = _e162;
    metal::float2 _e164 = uniforms.direction;
    if (metal::length(_e164) > 0.0) {
        metal::float2 _e168 = uniforms.direction;
        local = metal::normalize(_e168);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e170 = local;
    dir = _e170;
    float _e172 = dir[1u];
    float _e175 = dir[0u];
    up = metal::float2(-(_e172), _e175);
    float _e178 = up[1u];
    bool _e179 = _e178 < 0.0;
    phi_309_ = _e179;
    if (!(_e179)) {
        float _e182 = up[1u];
        bool _e183 = _e182 == 0.0;
        phi_308_ = _e183;
        if (_e183) {
            float _e185 = up[0u];
            phi_308_ = _e185 > 0.0;
        }
        bool _e188 = phi_308_;
        phi_309_ = _e188;
    }
    bool _e190 = phi_309_;
    if (_e190) {
        metal::float2 _e191 = up;
        up = -(_e191);
    }
    float _e194 = dir[0u];
    float _e197 = uniforms.ratio;
    float _e200 = dir[1u];
    e = 0.5 * ((metal::abs(_e194) * _e197) + metal::abs(_e200));
    float _e205 = up[0u];
    float _e208 = uniforms.ratio;
    float _e211 = up[1u];
    w = 0.5 * ((metal::abs(_e205) * _e208) + metal::abs(_e211));
    metal::float2 _e215 = uv_2;
    float _e219 = uniforms.ratio;
    float _e222 = w;
    p = ((_e215 - metal::float2(0.5)) * metal::float2(_e219, 1.0)) / metal::float2(2.0 * _e222);
    metal::float2 _e226 = p;
    metal::float2 _e227 = dir;
    metal::float2 _e229 = p;
    metal::float2 _e230 = up;
    q_1 = metal::float2(metal::dot(_e226, _e227), metal::dot(_e229, _e230) + 0.5);
    float _e234 = e;
    float _e235 = w;
    E = _e234 / (2.0 * _e235);
    float _e239 = uniforms.curl;
    R = metal::max(_e239, 0.01);
    float _e241 = R;
    Rb = 0.5 * _e241;
    float _e243 = t;
    tipAngle = 3.1415927 * (0.08 - (0.5 * metal::smoothstep(0.0, 0.85, _e243)));
    float _e248 = t;
    float _e249 = t;
    float _e250 = t;
    float _e252 = t;
    travel = metal::mix(_e248, (_e249 * _e250) * (3.0 - (2.0 * _e252)), 0.25);
    float _e257 = E;
    float _e259 = R;
    float _e262 = E;
    float _e263 = Rb;
    float _e267 = travel;
    float _e269 = R;
    C = metal::float2(metal::mix((-(_e257) - _e259) - 0.25, ((_e262 + _e263) + 0.35) + 0.4, _e267), 1.02 - _e269);
    metal::float2 _e272 = q_1;
    metal::float2 _e273 = C;
    d = _e272 - _e273;
    float _e276 = d[0u];
    if (_e276 == 0.0) {
        d[0u] = 0.000001;
    }
    metal::float2 _e279 = d;
    r_1 = metal::length(_e279);
    float _e282 = d[1u];
    float _e284 = d[0u];
    ang = metal::atan2(_e282, _e284);
    float _e286 = ang;
    float _e287 = tipAngle;
    float _e289 = tipAngle;
    k = metal::clamp((_e286 - _e287) / (3.1415927 - _e289), 0.0, 1.0);
    float _e293 = R;
    float _e294 = R;
    float _e295 = Rb;
    float _e297 = k;
    float _e299 = k;
    rIn = _e293 - ((_e294 - _e295) * (1.0 - ((1.0 - _e297) * (1.0 - _e299))));
    float _e305 = ang;
    float _e306 = tipAngle;
    curled = _e305 >= _e306;
    float _e309 = q_1[1u];
    float _e311 = C[1u];
    s = 1.0 - metal::clamp(_e309 / _e311, 0.0, 1.0);
    float _e316 = C[0u];
    float _e317 = Rb;
    float _e319 = s;
    float _e321 = s;
    face = (_e316 - _e317) - ((0.35 * _e319) * _e321);
    float _e324 = face;
    float _e326 = q_1[0u];
    behind = _e324 - _e326;
    bool _e328 = curled;
    if (_e328) {
        float _e329 = r_1;
        float _e330 = rIn;
        float _e333 = ang;
        if (_e333 > 1.5707964) {
            local_1 = 1.0;
        } else {
            float _e335 = r_1;
            float _e336 = R;
            local_1 = 1.0 - metal::smoothstep(-0.002, 0.002, _e335 - _e336);
        }
        float _e340 = local_1;
        wet = metal::smoothstep(-0.002, 0.002, _e329 - _e330) * _e340;
    } else {
        float _e342 = behind;
        wet = metal::smoothstep(-0.002, 0.002, _e342);
    }
    bool _e344 = curled;
    if (_e344) {
        float _e345 = ang;
        local_2 = 1.0 - metal::smoothstep(1.2707963, 2.0707963, _e345);
    } else {
        local_2 = 0.0;
    }
    float _e348 = local_2;
    lip = _e348;
    metal::float2 _e349 = q_1;
    float _e351 = t;
    float _e353 = t;
    param_10 = (_e349 * metal::float2(14.0, 10.0)) + metal::float2(-9.0 * _e351, 3.0 * _e353);
    float _e357 = vnoise(param_10);
    n = _e357;
    metal::float2 _e358 = uv_2;
    param_11 = _e358;
    metal::float4 _e359 = getFromColor(param_11, _from, _sampler);
    a = _e359;
    float _e360 = r_1;
    float _e361 = R;
    float _e363 = behind;
    gap = metal::max(metal::min(_e360 - _e361, -(_e363)), 0.0);
    float _e367 = gap;
    float _e372 = gap;
    float _e377 = q_1[1u];
    float _e381 = C[1u];
    float _e382 = R;
    float _e386 = C[1u];
    float _e387 = R;
    float _e391 = q_1[1u];
    shade = (((0.55 * metal::exp(-(_e367) / 0.1)) * (1.0 - metal::smoothstep(0.0, 0.25, _e372))) * metal::smoothstep(0.0, 0.6, _e377)) * (1.0 - metal::smoothstep(_e381 + (0.2 * _e382), _e386 + (1.1 * _e387), _e391));
    float _e395 = R;
    float _e396 = r_1;
    float _e400 = shade;
    shade = _e400 + (0.25 * (1.0 - metal::smoothstep(0.0, _e395, _e396)));
    float _e402 = shade;
    metal::float4 _e404 = a;
    metal::float3 _e406 = _e404.xyz * (1.0 - _e402);
    a[0u] = _e406.x;
    a[1u] = _e406.y;
    a[2u] = _e406.z;
    float _e413 = r_1;
    float _e414 = R;
    fwd = metal::max(_e413 - _e414, 0.0);
    float _e417 = tipAngle;
    float _e419 = tipAngle;
    float _e421 = ang;
    float _e423 = fwd;
    float _e427 = r_1;
    float _e428 = R;
    zone = (metal::smoothstep(_e417 - 0.4, _e419 + 0.2, _e421) * (1.0 - metal::smoothstep(0.0, 0.25, _e423))) * metal::step(0.0, _e427 - _e428);
    metal::float2 _e432 = d;
    float _e433 = t;
    sq = (_e432 - (metal::float2(0.5, -0.25) * _e433)) * metal::float2(0.55, 1.0);
    float _e437 = fwd;
    thin = metal::exp(-(_e437) / 0.12);
    float _e442 = uniforms.foam;
    float _e443 = thin;
    metal::float2 _e445 = sq;
    param_12 = _e445;
    param_13 = 0.02;
    param_14 = _e442 * _e443;
    param_15 = 1.0;
    float _e446 = droplets(param_12, param_13, param_14, param_15);
    metal::float2 _e447 = sq;
    float _e452 = uniforms.foam;
    float _e453 = thin;
    param_16 = (_e447 * 1.6) + metal::float2(3.1);
    param_17 = 0.02;
    param_18 = _e452 * _e453;
    param_19 = 7.0;
    float _e455 = droplets(param_16, param_17, param_18, param_19);
    spray = _e446 + (0.6 * _e455);
    float _e459 = uniforms.foam;
    float _e460 = n;
    float _e462 = n;
    float _e464 = fwd;
    float _e469 = fwd;
    float _e473 = r_1;
    float _e474 = R;
    float _e478 = tipAngle;
    float _e479 = tipAngle;
    float _e481 = ang;
    mist = (((((_e459 * _e460) * _e462) * metal::exp(-(_e464) / 0.06)) * (1.0 - metal::smoothstep(0.0, 0.25, _e469))) * metal::smoothstep(-0.002, 0.002, _e473 - _e474)) * metal::smoothstep(_e478, _e479 + 0.3, _e481);
    metal::float4 _e484 = a;
    metal::float4 _e487 = uniforms.foamColor;
    float _e491 = uniforms.foamColor[3u];
    float _e492 = spray;
    float _e493 = zone;
    float _e495 = mist;
    metal::float3 _e500 = metal::mix(_e484.xyz, _e487.xyz, metal::float3(_e491 * metal::clamp((_e492 * _e493) + _e495, 0.0, 1.0)));
    a[0u] = _e500.x;
    a[1u] = _e500.y;
    a[2u] = _e500.z;
    float _e507 = behind;
    float _e510 = lip;
    band = metal::max(1.0 - metal::smoothstep(0.05, 0.4, _e507), _e510);
    float _e513 = uniforms.refraction;
    float _e514 = band;
    float _e516 = band;
    bend = (_e513 * _e514) * _e516;
    float _e518 = bend;
    metal::float2 _e519 = dir;
    float _e521 = q_1[1u];
    float _e524 = q_1[0u];
    float _e529 = t;
    metal::float2 _e534 = up;
    float _e536 = q_1[0u];
    float _e538 = t;
    off = ((_e519 * metal::sin(((17.0 * _e521) + (2.0 * metal::sin(9.0 * _e524))) - (6.0 * _e529))) + (_e534 * metal::cos((13.0 * _e536) - (5.0 * _e538)))) * _e518;
    metal::float2 _e545 = uv_2;
    metal::float2 _e546 = off;
    float _e548 = w;
    float _e551 = uniforms.ratio;
    param_20 = _e545 + (((_e546 * 2.0) * _e548) / metal::float2(_e551, 1.0));
    metal::float2 _e555 = mirror(param_20);
    param_21 = _e555;
    metal::float4 _e556 = getToColor(param_21, _sampler, _to);
    b = _e556;
    metal::float4 _e557 = b;
    luma = metal::dot(_e557.xyz, metal::float3(0.299, 0.587, 0.114));
    metal::float4 _e561 = uniforms.water;
    float _e563 = luma;
    float _e568 = q_1[1u];
    tinted = (_e561.xyz * (0.4 + (0.9 * _e563))) * (1.0 + (0.6 * _e568));
    float _e572 = lip;
    float _e574 = k;
    metal::float3 _e578 = tinted;
    tinted = _e578 + (metal::float3(0.5, 1.0, 0.9) * ((0.18 * _e572) * (1.0 - _e574)));
    float _e580 = lip;
    float _e582 = r_1;
    float _e583 = rIn;
    metal::float3 _e589 = tinted;
    tinted = _e589 * (1.0 - ((0.35 * _e580) * (1.0 - metal::smoothstep(0.0, 0.06, _e582 - _e583))));
    bool _e591 = curled;
    if (_e591) {
        float _e592 = k;
        float _e593 = r_1;
        float _e594 = rIn;
        local_3 = _e592 * (1.0 - metal::smoothstep(0.0, 0.015, _e593 - _e594));
    } else {
        float _e599 = behind;
        local_3 = 1.0 - metal::smoothstep(0.0, 0.015, _e599);
    }
    float _e602 = local_3;
    metal::float3 _e605 = tinted;
    tinted = _e605 + (metal::float3(0.7, 0.95, 1.0) * (0.35 * _e602));
    metal::float4 _e607 = b;
    metal::float3 _e609 = tinted;
    float _e612 = uniforms.water[3u];
    float _e613 = band;
    metal::float3 _e616 = metal::mix(_e607.xyz, _e609, metal::float3(_e612 * _e613));
    b[0u] = _e616.x;
    b[1u] = _e616.y;
    b[2u] = _e616.z;
    bool _e623 = curled;
    if (_e623) {
        float _e624 = n;
        float _e627 = R;
        float _e628 = r_1;
        float _e633 = tipAngle;
        float _e634 = tipAngle;
        float _e636 = ang;
        float _e639 = ang;
        local_4 = ((1.0 - metal::smoothstep(0.01, 0.02 + (0.12 * _e624), metal::abs(_e627 - _e628))) * metal::smoothstep(_e633, _e634 + 0.4, _e636)) * (1.0 - metal::smoothstep(1.7707963, 2.3707964, _e639));
    } else {
        local_4 = 0.0;
    }
    float _e643 = local_4;
    crest = _e643;
    float _e644 = n;
    float _e648 = q_1[1u];
    float _e651 = behind;
    float _e656 = n;
    churn = ((1.0 - metal::smoothstep(0.0, 0.15 + (0.1 * _e644), _e648)) * (1.0 - metal::smoothstep(0.0, 0.3, metal::abs(_e651)))) * metal::smoothstep(0.3, 0.7, _e656);
    metal::float4 _e659 = b;
    metal::float4 _e662 = uniforms.foamColor;
    float _e666 = uniforms.foamColor[3u];
    float _e668 = uniforms.foam;
    float _e670 = crest;
    float _e671 = churn;
    metal::float3 _e677 = metal::mix(_e659.xyz, _e662.xyz, metal::float3(_e666 * metal::clamp((_e668 * 1.5) * (_e670 + _e671), 0.0, 1.0)));
    b[0u] = _e677.x;
    b[1u] = _e677.y;
    b[2u] = _e677.z;
    metal::float4 _e684 = a;
    float _e687 = a[3u];
    metal::float3 _e688 = _e684.xyz * _e687;
    float _e690 = a[3u];
    metal::float4 _e695 = b;
    float _e698 = b[3u];
    metal::float3 _e699 = _e695.xyz * _e698;
    float _e701 = b[3u];
    float _e706 = wet;
    c_1 = metal::mix(metal::float4(_e688.x, _e688.y, _e688.z, _e690), metal::float4(_e699.x, _e699.y, _e699.z, _e701), metal::float4(_e706));
    float _e710 = c_1[3u];
    if (_e710 > 0.0) {
        metal::float4 _e712 = c_1;
        float _e715 = c_1[3u];
        metal::float3 _e717 = _e712.xyz / metal::float3(_e715);
        float _e719 = c_1[3u];
        local_5 = metal::float4(_e717.x, _e717.y, _e717.z, _e719);
    } else {
        local_5 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e724 = local_5;
    return _e724;
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
    metal::float2 _e88 = _uv_1;
    param_22 = _e88;
    metal::float4 _e89 = transition(param_22, _from, _sampler, _to, uniforms);
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
