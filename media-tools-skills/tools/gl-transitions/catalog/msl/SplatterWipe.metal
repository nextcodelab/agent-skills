// SplatterWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplatterWipe.glsl
// Author: gre
// License: MIT
// Description: Splats of paint land one after another, each popping in with a spiky outline, flung droplets and a few drips running down, revealing the incoming image until they cover the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float splats;
    float spikiness;
    float droplets;
    float drips;
    float rim;
    float seed;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e78 = uv[0u];
    float _e80 = uv[1u];
    metal::float4 _e83 = _to.sample(_sampler, metal::float2(_e78, 1.0 - _e80), metal::level(0.0));
    return _e83;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e78 = uv_1[0u];
    float _e80 = uv_1[1u];
    metal::float4 _e83 = _from.sample(_sampler, metal::float2(_e78, 1.0 - _e80), metal::level(0.0));
    return _e83;
}

float smax(
    thread float& a,
    thread float& b,
    thread float& k
) {
    float h = {};
    float _e80 = k;
    float _e81 = a;
    float _e82 = b;
    float _e87 = k;
    h = metal::max(_e80 - metal::abs(_e81 - _e82), 0.0) / _e87;
    float _e89 = a;
    float _e90 = b;
    float _e92 = h;
    float _e93 = h;
    float _e95 = k;
    return metal::max(_e89, _e90) + (((_e92 * _e93) * _e95) * 0.25);
}

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e78 = v;
    v3_ = metal::fract(_e78.xyx * 0.1031);
    metal::float3 _e82 = v3_;
    metal::float3 _e83 = v3_;
    metal::float3 _e88 = v3_;
    v3_ = _e88 + metal::float3(metal::dot(_e82, _e83.yzx + metal::float3(33.33)));
    float _e92 = v3_[0u];
    float _e94 = v3_[1u];
    float _e97 = v3_[2u];
    return metal::fract((_e92 + _e94) * _e97);
}

float turnNoise(
    thread float& t,
    thread float& n,
    thread metal::float2& key
) {
    float x = {};
    float i = {};
    float f = {};
    float a_1 = {};
    metal::float2 param = {};
    float b_1 = {};
    metal::float2 param_1 = {};
    float _e86 = t;
    float _e87 = n;
    x = _e86 * _e87;
    float _e89 = x;
    i = metal::floor(_e89);
    float _e91 = x;
    float _e92 = i;
    f = _e91 - _e92;
    metal::float2 _e94 = key;
    float _e95 = i;
    float _e96 = n;
    param = _e94 + metal::float2(_e95 - (metal::floor(_e95 / _e96) * _e96), 61.0);
    float _e103 = hash12(param);
    a_1 = _e103;
    metal::float2 _e104 = key;
    float _e105 = i;
    float _e106 = _e105 + 1.0;
    float _e107 = n;
    param_1 = _e104 + metal::float2(_e106 - (metal::floor(_e106 / _e107) * _e107), 61.0);
    float _e114 = hash12(param_1);
    b_1 = _e114;
    float _e115 = a_1;
    float _e116 = b_1;
    float _e117 = f;
    float _e118 = f;
    float _e120 = f;
    return metal::mix(_e115, _e116, (_e117 * _e118) * (3.0 - (2.0 * _e120)));
}

float splat(
    thread metal::float2& q,
    thread metal::float2& cell,
    thread metal::float2& key_1,
    constant Uniforms& uniforms
) {
    float t0_ = {};
    metal::float2 param_2 = {};
    metal::float2 c = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 d = {};
    float l = {};
    float pop = {};
    float x_1 = {};
    float grow = {};
    float r0_ = {};
    metal::float2 param_5 = {};
    float rc = {};
    float a_2 = {};
    float local = {};
    float lumps = {};
    float param_6 = {};
    float param_7 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    metal::float2 param_11 = {};
    float f_1 = {};
    float s = {};
    float spike = {};
    int k_1 = {};
    float sl = {};
    metal::float2 sk = {};
    float h_1 = {};
    metal::float2 param_12 = {};
    float w0_ = {};
    metal::float2 param_13 = {};
    float len = {};
    float w = {};
    float ang = {};
    metal::float2 param_14 = {};
    metal::float2 dir = {};
    float along = {};
    float across = {};
    float u = {};
    float ray = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    int j = {};
    metal::float2 dk = {};
    float hr = {};
    metal::float2 param_18 = {};
    float rad = {};
    float da = {};
    metal::float2 param_19 = {};
    float dist = {};
    metal::float2 param_20 = {};
    float run = {};
    int j_1 = {};
    metal::float2 dk_1 = {};
    float xo = {};
    metal::float2 param_21 = {};
    float dw = {};
    metal::float2 param_22 = {};
    float top = {};
    float bottom = {};
    metal::float2 param_23 = {};
    float dx = {};
    float drip = {};
    float tip = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    metal::float2 _e148 = key_1;
    param_2 = _e148 + metal::float2(3.0, 0.0);
    float _e150 = hash12(param_2);
    t0_ = 0.01 + (0.6 * _e150);
    float _e154 = uniforms.progress;
    float _e155 = t0_;
    if (_e154 <= _e155) {
        return -1.0;
    }
    metal::float2 _e157 = cell;
    metal::float2 _e160 = key_1;
    param_3 = _e160 + metal::float2(5.0, 1.0);
    float _e162 = hash12(param_3);
    metal::float2 _e163 = key_1;
    param_4 = _e163 + metal::float2(9.0, 2.0);
    float _e165 = hash12(param_4);
    c = (_e157 + metal::float2(0.5)) + ((metal::float2(_e162, _e165) - metal::float2(0.5)) * 0.3);
    metal::float2 _e171 = q;
    metal::float2 _e172 = c;
    d = _e171 - _e172;
    metal::float2 _e174 = d;
    l = metal::length(_e174);
    float _e176 = l;
    if (_e176 > 1.35) {
        return -1.0;
    }
    float _e179 = uniforms.progress;
    float _e180 = t0_;
    pop = metal::clamp((_e179 - _e180) / 0.08, 0.0, 1.0);
    float _e184 = pop;
    float _e186 = pop;
    float _e189 = pop;
    pop = 1.0 - (((1.0 - _e184) * (1.0 - _e186)) * (1.0 - _e189));
    float _e194 = uniforms.progress;
    float _e195 = t0_;
    float _e197 = t0_;
    x_1 = metal::clamp((_e194 - _e195) / (0.96 - _e197), 0.0, 1.0);
    float _e201 = x_1;
    float _e202 = x_1;
    float _e204 = x_1;
    grow = (_e201 * _e202) * _e204;
    metal::float2 _e206 = key_1;
    param_5 = _e206 + metal::float2(11.0, 3.0);
    float _e208 = hash12(param_5);
    r0_ = 0.42 + (0.2 * _e208);
    float _e211 = r0_;
    float _e212 = pop;
    float _e214 = grow;
    rc = metal::mix(_e211 * _e212, 1.03, _e214);
    float _e216 = l;
    if (_e216 > 0.00001) {
        float _e219 = d[1u];
        float _e221 = d[0u];
        local = (metal::atan2(_e219, _e221) / 6.2831855) + 0.5;
    } else {
        local = 0.0;
    }
    float _e225 = local;
    a_2 = _e225;
    float _e226 = grow;
    float _e228 = a_2;
    param_6 = _e228;
    param_7 = 5.0;
    metal::float2 _e229 = key_1;
    param_8 = _e229;
    float _e230 = turnNoise(param_6, param_7, param_8);
    float _e233 = grow;
    metal::float2 _e235 = key_1;
    float _e238 = a_2;
    param_9 = _e238;
    param_10 = 19.0;
    param_11 = _e235 + metal::float2(3.0);
    float _e239 = turnNoise(param_9, param_10, param_11);
    lumps = (metal::mix(0.3, 0.06, _e226) * (_e230 - 0.5)) + (metal::mix(0.18, 0.06, _e233) * (_e239 - 0.5));
    float _e243 = rc;
    float _e244 = lumps;
    float _e247 = l;
    f_1 = (_e243 * (1.0 + _e244)) - _e247;
    float _e249 = a_2;
    s = metal::floor(_e249 * 14.0);
    spike = -1.0;
    k_1 = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e370 = k_1;
            k_1 = as_type<int>(as_type<uint>(_e370) + as_type<uint>(1));
        }
        loop_init = false;
        int _e252 = k_1;
        if (_e252 <= 1) {
            float _e254 = s;
            int _e255 = k_1;
            sl = _e254 + static_cast<float>(_e255);
            metal::float2 _e258 = key_1;
            float _e259 = sl;
            sk = _e258 + metal::float2(_e259 - (metal::floor(_e259 / 14.0) * 14.0), 17.0);
            metal::float2 _e266 = sk;
            param_12 = _e266;
            float _e267 = hash12(param_12);
            h_1 = _e267;
            metal::float2 _e268 = sk;
            param_13 = _e268 + metal::float2(1.5);
            float _e271 = hash12(param_13);
            float _e274 = pop;
            w0_ = (0.022 + (0.03 * _e271)) * _e274;
            float _e277 = uniforms.spikiness;
            float _e278 = h_1;
            float _e280 = h_1;
            float _e284 = pop;
            float _e286 = w0_;
            float _e289 = rc;
            len = metal::max(metal::min((_e277 * (0.06 + ((0.6 * _e278) * _e280))) * _e284, (1.25 - (1.2 * _e286)) - _e289), 0.0);
            float _e293 = len;
            if (_e293 > 0.0) {
                float _e295 = w0_;
                float _e296 = len;
                w = _e295 * metal::min(_e296 / 0.06, 1.0);
                float _e300 = sl;
                metal::float2 _e302 = sk;
                param_14 = _e302 + metal::float2(0.5);
                float _e305 = hash12(param_14);
                ang = (((((_e300 + 0.5) + (0.4 * (_e305 - 0.5))) / 14.0) * 2.0) * 3.1415927) - 3.1415927;
                float _e313 = ang;
                float _e315 = ang;
                dir = metal::float2(metal::cos(_e313), metal::sin(_e315));
                metal::float2 _e318 = d;
                metal::float2 _e319 = dir;
                along = metal::dot(_e318, _e319);
                float _e322 = d[0u];
                float _e324 = dir[1u];
                float _e327 = d[1u];
                float _e329 = dir[0u];
                across = metal::abs((_e322 * _e324) - (_e327 * _e329));
                float _e333 = along;
                float _e334 = rc;
                float _e336 = len;
                u = metal::clamp((_e333 - _e334) / _e336, 0.0, 1.0);
                float _e339 = w;
                float _e340 = u;
                float _e344 = across;
                float _e346 = rc;
                float _e347 = len;
                float _e349 = along;
                ray = metal::min((_e339 * (1.0 - (0.7 * _e340))) - _e344, (_e346 + _e347) - _e349);
                float _e352 = h_1;
                if (_e352 > 0.5) {
                    float _e354 = ray;
                    float _e355 = w;
                    metal::float2 _e357 = d;
                    metal::float2 _e358 = dir;
                    float _e359 = rc;
                    float _e360 = len;
                    ray = metal::max(_e354, (_e355 * 1.2) - metal::length(_e357 - (_e358 * (_e359 + _e360))));
                }
                float _e367 = spike;
                float _e368 = ray;
                spike = metal::max(_e367, _e368);
            }
            continue;
        } else {
            break;
        }
    }
    float _e372 = f_1;
    param_15 = _e372;
    float _e373 = spike;
    param_16 = _e373;
    param_17 = 0.08;
    float _e374 = smax(param_15, param_16, param_17);
    f_1 = _e374;
    j = 0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e434 = j;
            j = as_type<int>(as_type<uint>(_e434) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e375 = j;
        if (_e375 < 5) {
            metal::float2 _e377 = key_1;
            int _e378 = j;
            dk = _e377 + metal::float2(static_cast<float>(_e378), 29.0);
            metal::float2 _e382 = dk;
            param_18 = _e382 + metal::float2(0.5);
            float _e385 = hash12(param_18);
            hr = _e385;
            float _e386 = hr;
            float _e388 = hr;
            float _e392 = uniforms.droplets;
            int _e394 = j;
            float _e399 = pop;
            rad = ((0.015 + ((0.05 * _e386) * _e388)) * metal::clamp((_e392 * 5.0) - static_cast<float>(_e394), 0.0, 1.0)) * _e399;
            float _e401 = rad;
            if (_e401 > 0.0) {
                metal::float2 _e403 = dk;
                param_19 = _e403;
                float _e404 = hash12(param_19);
                da = 6.2831855 * _e404;
                float _e406 = r0_;
                metal::float2 _e408 = dk;
                param_20 = _e408 + metal::float2(1.5);
                float _e411 = hash12(param_20);
                float _e414 = rad;
                float _e417 = pop;
                dist = metal::min((_e406 + 0.08) + (0.5 * _e411), 1.25 - _e414) * metal::mix(0.5, 1.0, _e417);
                float _e420 = f_1;
                float _e421 = rad;
                metal::float2 _e422 = d;
                float _e423 = dist;
                float _e424 = da;
                float _e426 = da;
                f_1 = metal::max(_e420, _e421 - metal::length(_e422 - (metal::float2(metal::cos(_e424), metal::sin(_e426)) * _e423)));
            }
            continue;
        } else {
            break;
        }
    }
    float _e437 = uniforms.drips;
    if (_e437 > 0.0) {
        float _e440 = uniforms.progress;
        float _e441 = t0_;
        run = metal::clamp(((_e440 - _e441) - 0.03) / 0.45, 0.0, 1.0);
        float _e446 = run;
        float _e447 = run;
        run = _e446 * (2.0 - _e447);
        j_1 = 0;
        uint2 loop_bound_2 = uint2(4294967295u);
        bool loop_init_2 = true;
        while(true) {
            if (metal::all(loop_bound_2 == uint2(0u))) { break; }
            loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
            if (!loop_init_2) {
                int _e537 = j_1;
                j_1 = as_type<int>(as_type<uint>(_e537) + as_type<uint>(1));
            }
            loop_init_2 = false;
            int _e450 = j_1;
            if (_e450 < 2) {
                metal::float2 _e452 = key_1;
                int _e453 = j_1;
                dk_1 = _e452 + metal::float2(static_cast<float>(_e453), 43.0);
                metal::float2 _e457 = dk_1;
                param_21 = _e457;
                float _e458 = hash12(param_21);
                float _e460 = r0_;
                xo = (_e458 - 0.5) * _e460;
                metal::float2 _e462 = dk_1;
                param_22 = _e462 + metal::float2(0.5);
                float _e465 = hash12(param_22);
                float _e468 = pop;
                dw = (0.03 + (0.02 * _e465)) * _e468;
                float _e470 = r0_;
                float _e471 = r0_;
                float _e473 = xo;
                float _e474 = xo;
                float _e478 = pop;
                top = metal::sqrt((_e470 * _e471) - (_e473 * _e474)) * _e478;
                float _e480 = top;
                float _e482 = uniforms.drips;
                metal::float2 _e483 = dk_1;
                param_23 = _e483 + metal::float2(1.5);
                float _e486 = hash12(param_23);
                float _e490 = run;
                float _e493 = xo;
                float _e494 = xo;
                float _e498 = dw;
                bottom = metal::min(_e480 + ((_e482 * (0.25 + (0.75 * _e486))) * _e490), metal::sqrt(1.5625 - (_e493 * _e494)) - (1.6 * _e498));
                float _e503 = d[0u];
                float _e504 = xo;
                dx = metal::abs(_e503 - _e504);
                float _e507 = dw;
                float _e508 = dx;
                float _e511 = d[1u];
                float _e512 = bottom;
                float _e515 = d[1u];
                drip = metal::min(_e507 - _e508, metal::min(_e511 + _e512, -(_e515)));
                float _e519 = dw;
                float _e521 = dx;
                float _e523 = d[1u];
                float _e524 = bottom;
                float _e526 = dw;
                tip = (_e519 * 1.4) - metal::length(metal::float2(_e521, (_e523 + _e524) + (0.2 * _e526)));
                float _e532 = drip;
                float _e533 = tip;
                float _e535 = f_1;
                param_24 = _e535;
                param_25 = metal::max(_e532, _e533);
                param_26 = 0.05;
                float _e536 = smax(param_24, param_25, param_26);
                f_1 = _e536;
                continue;
            } else {
                break;
            }
        }
    }
    float _e539 = f_1;
    return _e539;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n_1 = {};
    float cellSize = {};
    metal::float2 q_1 = {};
    metal::float2 base = {};
    metal::float2 sd = {};
    float f_2 = {};
    int j_2 = {};
    int i_1 = {};
    metal::float2 cell_1 = {};
    metal::float2 param_27 = {};
    metal::float2 param_28 = {};
    metal::float2 param_29 = {};
    float aa = {};
    float inside = {};
    metal::float4 from = {};
    metal::float2 param_30 = {};
    metal::float4 to = {};
    metal::float2 param_31 = {};
    float e = {};
    float amount = {};
    float dark = {};
    float gloss = {};
    float _e100 = uniforms.splats;
    n_1 = metal::max(1.0, metal::floor(_e100 + 0.5));
    float _e105 = uniforms.ratio;
    float _e107 = n_1;
    cellSize = metal::max(_e105, 1.0) / _e107;
    float _e110 = uv_2[0u];
    float _e112 = uniforms.ratio;
    float _e115 = uv_2[1u];
    float _e117 = cellSize;
    q_1 = metal::float2(_e110 * _e112, _e115) / metal::float2(_e117);
    metal::float2 _e120 = q_1;
    base = metal::floor(_e120);
    float _e123 = uniforms.seed;
    sd = metal::float2(7.0, 13.0) * _e123;
    f_2 = -1.0;
    j_2 = -1;
    uint2 loop_bound_3 = uint2(4294967295u);
    bool loop_init_3 = true;
    while(true) {
        if (metal::all(loop_bound_3 == uint2(0u))) { break; }
        loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
        if (!loop_init_3) {
            int _e146 = j_2;
            j_2 = as_type<int>(as_type<uint>(_e146) + as_type<uint>(1));
        }
        loop_init_3 = false;
        int _e125 = j_2;
        if (_e125 <= 1) {
            i_1 = -1;
            uint2 loop_bound_4 = uint2(4294967295u);
            bool loop_init_4 = true;
            while(true) {
                if (metal::all(loop_bound_4 == uint2(0u))) { break; }
                loop_bound_4 -= uint2(loop_bound_4.y == 0u, 1u);
                if (!loop_init_4) {
                    int _e144 = i_1;
                    i_1 = as_type<int>(as_type<uint>(_e144) + as_type<uint>(1));
                }
                loop_init_4 = false;
                int _e127 = i_1;
                if (_e127 <= 1) {
                    metal::float2 _e129 = base;
                    int _e130 = i_1;
                    int _e132 = j_2;
                    cell_1 = _e129 + metal::float2(static_cast<float>(_e130), static_cast<float>(_e132));
                    float _e136 = f_2;
                    metal::float2 _e137 = cell_1;
                    metal::float2 _e138 = sd;
                    metal::float2 _e140 = q_1;
                    param_27 = _e140;
                    metal::float2 _e141 = cell_1;
                    param_28 = _e141;
                    param_29 = _e137 + _e138;
                    float _e142 = splat(param_27, param_28, param_29, uniforms);
                    f_2 = metal::max(_e136, _e142);
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
    float _e148 = cellSize;
    aa = 0.0025 / _e148;
    float _e150 = aa;
    float _e152 = aa;
    float _e153 = f_2;
    inside = metal::smoothstep(-(_e150), _e152, _e153);
    metal::float2 _e155 = uv_2;
    param_30 = _e155;
    metal::float4 _e156 = getFromColor(param_30, _from, _sampler);
    from = _e156;
    metal::float2 _e157 = uv_2;
    param_31 = _e157;
    metal::float4 _e158 = getToColor(param_31, _sampler, _to);
    to = _e158;
    float _e159 = f_2;
    e = metal::clamp(_e159 / 0.045, 0.0, 1.0);
    float _e163 = uniforms.rim;
    float _e165 = uniforms.progress;
    amount = _e163 * (1.0 - metal::smoothstep(0.75, 1.0, _e165));
    float _e169 = e;
    float _e171 = e;
    dark = ((1.0 - _e169) * (1.0 - _e171)) * 0.6;
    float _e175 = e;
    float _e177 = e;
    gloss = (metal::smoothstep(0.2, 0.4, _e175) * (1.0 - metal::smoothstep(0.4, 0.7, _e177))) * 0.3;
    metal::float4 _e182 = to;
    float _e184 = dark;
    float _e185 = amount;
    float _e189 = gloss;
    float _e190 = amount;
    float _e193 = to[3u];
    metal::float3 _e196 = metal::mix(_e182.xyz * (1.0 - (_e184 * _e185)), metal::float3(1.0, 1.0, 1.0), metal::float3((_e189 * _e190) * _e193));
    to[0u] = _e196.x;
    to[1u] = _e196.y;
    to[2u] = _e196.z;
    metal::float4 _e203 = from;
    metal::float4 _e204 = to;
    float _e205 = inside;
    return metal::mix(_e203, _e204, metal::float4(_e205));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_32 = {};
    metal::float2 _e77 = _uv_1;
    param_32 = _e77;
    metal::float4 _e78 = transition(param_32, _from, _sampler, _to, uniforms);
    _fragColor = _e78;
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
