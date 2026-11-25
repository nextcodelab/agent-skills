// LightningFlash — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightningFlash.glsl
// Author: gre
// License: MIT
// Description: Forked lightning bolts crack down from the top of the frame, the screen flashes white in a few stuttering strobes, and the incoming image appears lit by the last flickers as they fade out
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int bolts;
    float strike;
    float seed;
    char _pad5[12];
    metal::packed_float3 color;
    float glow;
    int flashes;
    char _pad8[12];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e85 = uv[0u];
    float _e87 = uv[1u];
    metal::float4 _e90 = _to.sample(_sampler, metal::float2(_e85, 1.0 - _e87), metal::level(0.0));
    return _e90;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e85 = uv_1[0u];
    float _e87 = uv_1[1u];
    metal::float4 _e90 = _from.sample(_sampler, metal::float2(_e85, 1.0 - _e87), metal::level(0.0));
    return _e90;
}

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e85 = p;
    p3_ = metal::fract(_e85.xyx * 0.1031);
    metal::float3 _e89 = p3_;
    metal::float3 _e90 = p3_;
    metal::float3 _e95 = p3_;
    p3_ = _e95 + metal::float3(metal::dot(_e89, _e90.yzx + metal::float3(33.33)));
    float _e99 = p3_[0u];
    float _e101 = p3_[1u];
    float _e104 = p3_[2u];
    return metal::fract((_e99 + _e101) * _e104);
}

float jag(
    thread float& s,
    thread float& k
) {
    float i = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e88 = s;
    i = metal::floor(_e88);
    float _e90 = i;
    float _e91 = k;
    param = metal::float2(_e90, _e91);
    float _e93 = hash(param);
    float _e94 = i;
    float _e96 = k;
    param_1 = metal::float2(_e94 + 1.0, _e96);
    float _e98 = hash(param_1);
    float _e99 = s;
    return metal::mix(_e93, _e98, metal::fract(_e99)) - 0.5;
}

float zigzag(
    thread float& y,
    thread float& k_1,
    constant Uniforms& uniforms
) {
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float _e94 = uniforms.ratio;
    float _e96 = y;
    param_2 = _e96 * 5.0;
    float _e98 = k_1;
    param_3 = _e98;
    float _e99 = jag(param_2, param_3);
    float _e101 = y;
    float _e103 = k_1;
    param_4 = _e101 * 13.0;
    param_5 = _e103 + 1.0;
    float _e105 = jag(param_4, param_5);
    float _e108 = y;
    float _e110 = k_1;
    param_6 = _e108 * 31.0;
    param_7 = _e110 + 2.0;
    float _e112 = jag(param_6, param_7);
    float _e115 = y;
    float _e117 = k_1;
    param_8 = _e115 * 67.0;
    param_9 = _e117 + 3.0;
    float _e119 = jag(param_8, param_9);
    return metal::min(_e94, 1.0) * ((((0.15 * _e99) + (0.06 * _e105)) + (0.03 * _e112)) + (0.012 * _e119));
}

float branchX(
    thread float& y_1,
    thread float& xb,
    thread float& yb,
    thread float& zb,
    thread float& dir,
    thread float& k_2,
    constant Uniforms& uniforms
) {
    float param_10 = {};
    float param_11 = {};
    float _e91 = xb;
    float _e92 = dir;
    float _e93 = yb;
    float _e94 = y_1;
    float _e98 = y_1;
    param_10 = _e98;
    float _e99 = k_2;
    param_11 = _e99;
    float _e100 = zigzag(param_10, param_11, uniforms);
    float _e101 = zb;
    return (_e91 + (_e92 * (_e93 - _e94))) + (0.6 * (_e100 - _e101));
}

float curveDist(
    thread metal::float2& q,
    thread float& x,
    thread float& slope,
    thread float& outside
) {
    float dx = {};
    float d = {};
    float _e90 = q[0u];
    float _e91 = x;
    dx = metal::abs(_e90 - _e91);
    float _e94 = dx;
    float _e95 = slope;
    float _e96 = slope;
    float _e100 = dx;
    d = _e94 * metal::mix(metal::rsqrt(1.0 + (_e95 * _e96)), 1.0, metal::smoothstep(0.0, 0.08, _e100));
    float _e104 = d;
    float _e105 = outside;
    return metal::length(metal::float2(_e104, metal::max(_e105, 0.0)));
}

float boltX(
    thread float& y_2,
    thread float& x0_,
    thread float& x1_,
    thread float& y1_,
    thread float& z0_,
    thread float& z1_,
    thread float& k_3,
    constant Uniforms& uniforms
) {
    float t = {};
    float param_12 = {};
    float param_13 = {};
    float _e93 = y_2;
    float _e95 = y1_;
    t = (1.0 - _e93) / (1.0 - _e95);
    float _e98 = x0_;
    float _e99 = z0_;
    float _e101 = x1_;
    float _e102 = z1_;
    float _e104 = t;
    float _e106 = y_2;
    param_12 = _e106;
    float _e107 = k_3;
    param_13 = _e107;
    float _e108 = zigzag(param_12, param_13, uniforms);
    return metal::mix(_e98 - _e99, _e101 - _e102, _e104) + _e108;
}

float pulse(
    thread float& p_1,
    thread float& t0_,
    thread float& hold,
    thread float& decay
) {
    float x_1 = {};
    float _e88 = p_1;
    float _e89 = t0_;
    x_1 = _e88 - _e89;
    float _e91 = x_1;
    if (_e91 < 0.0) {
        float _e93 = x_1;
        return metal::smoothstep(-0.012, 0.0, _e93);
    }
    float _e95 = x_1;
    float _e96 = hold;
    float _e100 = decay;
    return metal::exp(-(metal::max(_e95 - _e96, 0.0)) / _e100);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_2 = {};
    metal::float2 q_1 = {};
    float k0_ = {};
    int nb = {};
    int local = {};
    int local_1 = {};
    int nf = {};
    int local_2 = {};
    int local_3 = {};
    int cut = {};
    float flash = {};
    float lit = {};
    float tCut = {};
    float tLast = {};
    float t_1 = {};
    int i_1 = {};
    bool isCut = {};
    float amp = {};
    float local_4 = {};
    float local_5 = {};
    float s_1 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    metal::float2 param_22 = {};
    float stutter = {};
    metal::float2 param_23 = {};
    float whiteout = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    float param_27 = {};
    float tail = {};
    float local_6 = {};
    metal::float2 param_28 = {};
    float grow = {};
    float faint = {};
    metal::float2 param_29 = {};
    float boltLight = {};
    float local_7 = {};
    float core = {};
    float halo = {};
    float near = {};
    bool lightsOn = {};
    int b = {};
    float fb = {};
    float kb = {};
    float x1_1 = {};
    float y1_1 = {};
    float bright = {};
    float roomy = {};
    bool cramped = {};
    float side = {};
    float local_8 = {};
    float dist = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    float x0_1 = {};
    metal::float2 param_32 = {};
    float tip = {};
    float e = {};
    float z0_1 = {};
    float param_33 = {};
    float param_34 = {};
    float z1_1 = {};
    float param_35 = {};
    float param_36 = {};
    float x_2 = {};
    float param_37 = {};
    float param_38 = {};
    float param_39 = {};
    float param_40 = {};
    float param_41 = {};
    float param_42 = {};
    float param_43 = {};
    float slope_1 = {};
    float param_44 = {};
    float param_45 = {};
    float param_46 = {};
    float param_47 = {};
    float param_48 = {};
    float param_49 = {};
    float param_50 = {};
    float param_51 = {};
    float param_52 = {};
    float param_53 = {};
    float param_54 = {};
    float param_55 = {};
    float param_56 = {};
    float param_57 = {};
    float d_1 = {};
    metal::float2 param_58 = {};
    float param_59 = {};
    float param_60 = {};
    float param_61 = {};
    float w = {};
    int j = {};
    float fj = {};
    float kj = {};
    float tb = {};
    metal::float2 param_62 = {};
    float yb_1 = {};
    float len = {};
    metal::float2 param_63 = {};
    float dir_1 = {};
    metal::float2 param_64 = {};
    float xb_1 = {};
    float param_65 = {};
    float param_66 = {};
    float param_67 = {};
    float param_68 = {};
    float param_69 = {};
    float param_70 = {};
    float param_71 = {};
    float zb_1 = {};
    float param_72 = {};
    float param_73 = {};
    float bx = {};
    float param_74 = {};
    float param_75 = {};
    float param_76 = {};
    float param_77 = {};
    float param_78 = {};
    float param_79 = {};
    float bs = {};
    float param_80 = {};
    float param_81 = {};
    float param_82 = {};
    float param_83 = {};
    float param_84 = {};
    float param_85 = {};
    float param_86 = {};
    float param_87 = {};
    float param_88 = {};
    float param_89 = {};
    float param_90 = {};
    float param_91 = {};
    float bd = {};
    metal::float2 param_92 = {};
    float param_93 = {};
    float param_94 = {};
    float param_95 = {};
    float along = {};
    float fade = {};
    float bw = {};
    float m = {};
    metal::float4 c = {};
    metal::float4 a = {};
    metal::float2 param_96 = {};
    metal::float4 a_1 = {};
    metal::float2 param_97 = {};
    metal::float3 col = {};
    float live = {};
    float dim = {};
    float f = {};
    float g = {};
    metal::float3 light = {};
    float _e247 = uniforms.progress;
    p_2 = _e247;
    float _e249 = uv_2[0u];
    float _e251 = uniforms.ratio;
    float _e254 = uv_2[1u];
    q_1 = metal::float2(_e249 * _e251, _e254);
    float _e257 = uniforms.seed;
    k0_ = metal::floor(_e257) * 61.0;
    int _e261 = uniforms.bolts;
    if (_e261 < 1) {
        local = 1;
    } else {
        int _e264 = uniforms.bolts;
        if (_e264 > 3) {
            local_1 = 3;
        } else {
            int _e267 = uniforms.bolts;
            local_1 = _e267;
        }
        int _e268 = local_1;
        local = _e268;
    }
    int _e269 = local;
    nb = _e269;
    int _e271 = uniforms.flashes;
    if (_e271 < 1) {
        local_2 = 1;
    } else {
        int _e274 = uniforms.flashes;
        if (_e274 > 4) {
            local_3 = 4;
        } else {
            int _e277 = uniforms.flashes;
            local_3 = _e277;
        }
        int _e278 = local_3;
        local_2 = _e278;
    }
    int _e279 = local_2;
    nf = _e279;
    int _e280 = nf;
    cut = (_e280 > 1) ? 1 : 0;
    flash = 0.0;
    lit = 0.0;
    tCut = 0.3;
    tLast = 0.3;
    t_1 = 0.3;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e336 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e336) + as_type<uint>(1));
        }
        loop_init = false;
        int _e283 = i_1;
        if (_e283 < 4) {
            int _e285 = i_1;
            int _e286 = nf;
            if (_e285 < _e286) {
                int _e288 = i_1;
                int _e289 = cut;
                isCut = _e288 == _e289;
                bool _e291 = isCut;
                if (_e291) {
                    local_4 = 1.0;
                } else {
                    int _e292 = i_1;
                    int _e293 = cut;
                    if (_e292 < _e293) {
                        local_5 = 0.55;
                    } else {
                        int _e295 = i_1;
                        int _e296 = cut;
                        local_5 = 0.7 * metal::pow(0.75, static_cast<float>(as_type<int>(as_type<uint>(as_type<int>(as_type<uint>(_e295) - as_type<uint>(_e296))) - as_type<uint>(1))));
                    }
                    float _e302 = local_5;
                    local_4 = _e302;
                }
                float _e303 = local_4;
                amp = _e303;
                float _e304 = amp;
                bool _e305 = isCut;
                bool _e307 = isCut;
                float _e309 = p_2;
                param_14 = _e309;
                float _e310 = t_1;
                param_15 = _e310;
                param_16 = _e305 ? 0.025 : 0.004;
                param_17 = _e307 ? 0.03 : 0.022;
                float _e311 = pulse(param_14, param_15, param_16, param_17);
                s_1 = _e304 * _e311;
                float _e313 = flash;
                float _e314 = s_1;
                flash = metal::max(_e313, _e314);
                float _e316 = lit;
                float _e317 = p_2;
                param_18 = _e317;
                float _e318 = t_1;
                param_19 = _e318;
                param_20 = 0.01;
                param_21 = 0.045;
                float _e319 = pulse(param_18, param_19, param_20, param_21);
                lit = metal::max(_e316, _e319);
                bool _e321 = isCut;
                if (_e321) {
                    float _e322 = t_1;
                    tCut = _e322;
                }
                float _e323 = t_1;
                tLast = _e323;
                bool _e324 = isCut;
                int _e326 = i_1;
                float _e328 = k0_;
                param_22 = metal::float2(static_cast<float>(_e326), _e328 + 5.0);
                float _e331 = hash(param_22);
                float _e334 = t_1;
                t_1 = _e334 + ((_e324 ? 0.12 : 0.08) + (0.04 * _e331));
            }
            continue;
        } else {
            break;
        }
    }
    float _e338 = p_2;
    float _e341 = k0_;
    param_23 = metal::float2(metal::floor(_e338 * 70.0), _e341 + 9.0);
    float _e344 = hash(param_23);
    stutter = metal::mix(0.7, 1.0, _e344);
    float _e346 = stutter;
    float _e347 = flash;
    flash = _e347 * _e346;
    float _e349 = p_2;
    param_24 = _e349;
    float _e350 = tCut;
    param_25 = _e350;
    param_26 = 0.025;
    param_27 = 0.02;
    float _e351 = pulse(param_24, param_25, param_26, param_27);
    whiteout = _e351;
    float _e352 = p_2;
    float _e353 = tLast;
    if (_e352 > _e353) {
        float _e355 = p_2;
        float _e356 = tLast;
        float _e361 = p_2;
        float _e362 = tLast;
        local_6 = metal::exp(-((_e355 - _e356)) / 0.1) * metal::smoothstep(0.03, 0.06, _e361 - _e362);
    } else {
        local_6 = 0.0;
    }
    float _e366 = local_6;
    tail = _e366;
    float _e367 = flash;
    float _e368 = tail;
    float _e370 = p_2;
    float _e373 = k0_;
    param_28 = metal::float2(metal::floor(_e370 * 40.0), _e373 + 13.0);
    float _e376 = hash(param_28);
    flash = metal::max(_e367, (0.35 * _e368) * metal::step(0.45, _e376));
    float _e380 = p_2;
    grow = metal::clamp(_e380 / 0.3, 0.0, 1.0);
    float _e383 = grow;
    float _e386 = grow;
    grow = (metal::floor(_e383 * 7.0) + metal::smoothstep(0.0, 1.0, metal::fract(_e386 * 7.0))) / 7.0;
    float _e392 = p_2;
    float _e395 = k0_;
    param_29 = metal::float2(metal::floor(_e392 * 50.0), _e395 + 11.0);
    float _e398 = hash(param_29);
    faint = 0.5 * metal::mix(0.6, 1.0, _e398);
    float _e401 = p_2;
    if (_e401 < 0.3) {
        float _e403 = faint;
        float _e404 = p_2;
        local_7 = _e403 * metal::smoothstep(0.0, 0.06, _e404);
    } else {
        float _e407 = lit;
        float _e408 = stutter;
        float _e410 = faint;
        float _e411 = p_2;
        local_7 = metal::max(_e407 * _e408, _e410 * metal::exp(-((_e411 - 0.3)) / 0.12));
    }
    float _e418 = local_7;
    boltLight = _e418;
    float _e419 = boltLight;
    float _e420 = flash;
    float _e422 = tail;
    boltLight = metal::max(_e419, (0.6 * _e420) * _e422);
    float _e425 = tLast;
    float _e427 = tLast;
    float _e429 = p_2;
    float _e432 = boltLight;
    boltLight = _e432 * (1.0 - metal::smoothstep(_e425 + 0.1, _e427 + 0.3, _e429));
    core = 0.0;
    halo = 0.0;
    near = 10.0;
    float _e434 = boltLight;
    float _e436 = flash;
    lightsOn = (_e434 > 0.0) || (_e436 > 0.0);
    b = 0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e782 = b;
            b = as_type<int>(as_type<uint>(_e782) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e439 = b;
        if (_e439 < 3) {
            int _e441 = b;
            int _e442 = nb;
            bool _e444 = lightsOn;
            if ((_e441 < _e442) && _e444) {
                int _e446 = b;
                fb = static_cast<float>(_e446);
                float _e448 = k0_;
                float _e449 = fb;
                kb = _e448 + (_e449 * 17.0);
                float _e453 = uniforms.strike;
                float _e455 = uniforms.ratio;
                x1_1 = _e453 * _e455;
                y1_1 = -0.05;
                bright = 1.0;
                int _e457 = b;
                if (_e457 > 0) {
                    float _e460 = uniforms.strike;
                    roomy = (_e460 < 0.5) ? 1.0 : -1.0;
                    float _e464 = uniforms.strike;
                    float _e466 = uniforms.strike;
                    cramped = metal::min(_e464, 1.0 - _e466) < 0.25;
                    int _e470 = b;
                    bool _e472 = cramped;
                    if ((_e470 == 1) || _e472) {
                        float _e474 = roomy;
                        local_8 = _e474;
                    } else {
                        float _e475 = roomy;
                        local_8 = -(_e475);
                    }
                    float _e477 = local_8;
                    side = _e477;
                    int _e478 = b;
                    bool _e480 = cramped;
                    dist = ((_e478 == 2) && _e480) ? 0.5 : 0.22;
                    float _e483 = x1_1;
                    float _e484 = side;
                    float _e486 = uniforms.ratio;
                    float _e488 = dist;
                    float _e489 = fb;
                    float _e490 = kb;
                    param_30 = metal::float2(_e489, _e490);
                    float _e492 = hash(param_30);
                    float _e498 = uniforms.ratio;
                    float _e501 = uniforms.ratio;
                    x1_1 = metal::clamp(_e483 + ((_e484 * _e486) * (_e488 + (0.12 * _e492))), 0.08 * _e498, 0.92 * _e501);
                    float _e504 = fb;
                    float _e505 = kb;
                    param_31 = metal::float2(_e504, _e505 + 1.0);
                    float _e508 = hash(param_31);
                    y1_1 = 0.25 + (0.25 * _e508);
                    bright = 0.7;
                }
                float _e511 = x1_1;
                float _e512 = fb;
                float _e513 = kb;
                param_32 = metal::float2(_e512, _e513 + 2.0);
                float _e516 = hash(param_32);
                float _e520 = uniforms.ratio;
                float _e525 = uniforms.ratio;
                float _e528 = uniforms.ratio;
                x0_1 = metal::clamp(_e511 + (((_e516 - 0.5) * 0.5) * metal::min(_e520, 1.0)), 0.1 * _e525, 0.9 * _e528);
                float _e531 = y1_1;
                float _e532 = grow;
                tip = metal::mix(1.02, _e531, _e532);
                e = 0.01;
                param_33 = 1.0;
                float _e534 = kb;
                param_34 = _e534;
                float _e535 = zigzag(param_33, param_34, uniforms);
                z0_1 = _e535;
                float _e536 = y1_1;
                param_35 = _e536;
                float _e537 = kb;
                param_36 = _e537;
                float _e538 = zigzag(param_35, param_36, uniforms);
                z1_1 = _e538;
                float _e540 = q_1[1u];
                param_37 = _e540;
                float _e541 = x0_1;
                param_38 = _e541;
                float _e542 = x1_1;
                param_39 = _e542;
                float _e543 = y1_1;
                param_40 = _e543;
                float _e544 = z0_1;
                param_41 = _e544;
                float _e545 = z1_1;
                param_42 = _e545;
                float _e546 = kb;
                param_43 = _e546;
                float _e547 = boltX(param_37, param_38, param_39, param_40, param_41, param_42, param_43, uniforms);
                x_2 = _e547;
                float _e549 = q_1[1u];
                float _e550 = e;
                param_44 = _e549 + _e550;
                float _e552 = x0_1;
                param_45 = _e552;
                float _e553 = x1_1;
                param_46 = _e553;
                float _e554 = y1_1;
                param_47 = _e554;
                float _e555 = z0_1;
                param_48 = _e555;
                float _e556 = z1_1;
                param_49 = _e556;
                float _e557 = kb;
                param_50 = _e557;
                float _e558 = boltX(param_44, param_45, param_46, param_47, param_48, param_49, param_50, uniforms);
                float _e560 = q_1[1u];
                float _e561 = e;
                param_51 = _e560 - _e561;
                float _e563 = x0_1;
                param_52 = _e563;
                float _e564 = x1_1;
                param_53 = _e564;
                float _e565 = y1_1;
                param_54 = _e565;
                float _e566 = z0_1;
                param_55 = _e566;
                float _e567 = z1_1;
                param_56 = _e567;
                float _e568 = kb;
                param_57 = _e568;
                float _e569 = boltX(param_51, param_52, param_53, param_54, param_55, param_56, param_57, uniforms);
                float _e571 = e;
                slope_1 = (_e558 - _e569) / (2.0 * _e571);
                float _e574 = y1_1;
                float _e575 = tip;
                float _e578 = q_1[1u];
                float _e581 = q_1[1u];
                metal::float2 _e584 = q_1;
                param_58 = _e584;
                float _e585 = x_2;
                param_59 = _e585;
                float _e586 = slope_1;
                param_60 = _e586;
                param_61 = metal::max(metal::max(_e574, _e575) - _e578, _e581 - 1.05);
                float _e587 = curveDist(param_58, param_59, param_60, param_61);
                d_1 = _e587;
                float _e588 = near;
                float _e589 = d_1;
                near = metal::min(_e588, _e589);
                float _e591 = fb;
                w = 0.003 * metal::mix(1.0, 0.7, _e591 / 2.0);
                float _e595 = bright;
                float _e596 = d_1;
                float _e598 = d_1;
                float _e600 = w;
                float _e601 = w;
                float _e606 = core;
                core = _e606 + (_e595 * metal::exp((-(_e596) * _e598) / (_e600 * _e601)));
                float _e608 = bright;
                float _e609 = d_1;
                float _e614 = d_1;
                float _e621 = halo;
                halo = _e621 + (_e608 * ((0.7 * metal::exp(-(_e609) * 24.0)) + (0.25 * metal::exp(-(_e614) * 6.0))));
                j = 0;
                uint2 loop_bound_2 = uint2(4294967295u);
                bool loop_init_2 = true;
                while(true) {
                    if (metal::all(loop_bound_2 == uint2(0u))) { break; }
                    loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
                    if (!loop_init_2) {
                        int _e780 = j;
                        j = as_type<int>(as_type<uint>(_e780) + as_type<uint>(1));
                    }
                    loop_init_2 = false;
                    int _e623 = j;
                    if (_e623 < 3) {
                        int _e625 = j;
                        fj = static_cast<float>(_e625);
                        float _e627 = kb;
                        float _e629 = fj;
                        kj = (_e627 + 3.0) + (_e629 * 5.0);
                        float _e632 = fj;
                        float _e635 = fj;
                        float _e636 = kj;
                        param_62 = metal::float2(_e635, _e636);
                        float _e638 = hash(param_62);
                        tb = (0.12 + (0.2 * _e632)) + (0.15 * _e638);
                        float _e641 = y1_1;
                        float _e642 = tb;
                        yb_1 = metal::mix(1.0, _e641, _e642);
                        float _e644 = fj;
                        float _e645 = kj;
                        param_63 = metal::float2(_e644, _e645 + 1.0);
                        float _e648 = hash(param_63);
                        float _e651 = tb;
                        float _e654 = y1_1;
                        len = ((0.3 + (0.25 * _e648)) * (1.0 - _e651)) * (1.0 - _e654);
                        int _e657 = j;
                        float _e660 = fj;
                        float _e661 = kj;
                        param_64 = metal::float2(_e660, _e661 + 2.0);
                        float _e664 = hash(param_64);
                        float _e669 = uniforms.ratio;
                        dir_1 = (((_e657 == 1) ? -1.0 : 1.0) * (0.2 + (0.45 * _e664))) * metal::min(_e669, 1.0);
                        float _e672 = yb_1;
                        param_65 = _e672;
                        float _e673 = x0_1;
                        param_66 = _e673;
                        float _e674 = x1_1;
                        param_67 = _e674;
                        float _e675 = y1_1;
                        param_68 = _e675;
                        float _e676 = z0_1;
                        param_69 = _e676;
                        float _e677 = z1_1;
                        param_70 = _e677;
                        float _e678 = kb;
                        param_71 = _e678;
                        float _e679 = boltX(param_65, param_66, param_67, param_68, param_69, param_70, param_71, uniforms);
                        xb_1 = _e679;
                        float _e680 = yb_1;
                        param_72 = _e680;
                        float _e681 = kj;
                        param_73 = _e681;
                        float _e682 = zigzag(param_72, param_73, uniforms);
                        zb_1 = _e682;
                        float _e684 = q_1[1u];
                        param_74 = _e684;
                        float _e685 = xb_1;
                        param_75 = _e685;
                        float _e686 = yb_1;
                        param_76 = _e686;
                        float _e687 = zb_1;
                        param_77 = _e687;
                        float _e688 = dir_1;
                        param_78 = _e688;
                        float _e689 = kj;
                        param_79 = _e689;
                        float _e690 = branchX(param_74, param_75, param_76, param_77, param_78, param_79, uniforms);
                        bx = _e690;
                        float _e692 = q_1[1u];
                        float _e693 = e;
                        param_80 = _e692 + _e693;
                        float _e695 = xb_1;
                        param_81 = _e695;
                        float _e696 = yb_1;
                        param_82 = _e696;
                        float _e697 = zb_1;
                        param_83 = _e697;
                        float _e698 = dir_1;
                        param_84 = _e698;
                        float _e699 = kj;
                        param_85 = _e699;
                        float _e700 = branchX(param_80, param_81, param_82, param_83, param_84, param_85, uniforms);
                        float _e702 = q_1[1u];
                        float _e703 = e;
                        param_86 = _e702 - _e703;
                        float _e705 = xb_1;
                        param_87 = _e705;
                        float _e706 = yb_1;
                        param_88 = _e706;
                        float _e707 = zb_1;
                        param_89 = _e707;
                        float _e708 = dir_1;
                        param_90 = _e708;
                        float _e709 = kj;
                        param_91 = _e709;
                        float _e710 = branchX(param_86, param_87, param_88, param_89, param_90, param_91, uniforms);
                        float _e712 = e;
                        bs = (_e700 - _e710) / (2.0 * _e712);
                        float _e715 = yb_1;
                        float _e716 = len;
                        float _e718 = tip;
                        float _e721 = q_1[1u];
                        float _e724 = q_1[1u];
                        float _e725 = yb_1;
                        metal::float2 _e728 = q_1;
                        param_92 = _e728;
                        float _e729 = bx;
                        param_93 = _e729;
                        float _e730 = bs;
                        param_94 = _e730;
                        param_95 = metal::max(metal::max(_e715 - _e716, _e718) - _e721, _e724 - _e725);
                        float _e731 = curveDist(param_92, param_93, param_94, param_95);
                        bd = _e731;
                        float _e732 = near;
                        float _e733 = bd;
                        near = metal::min(_e732, _e733);
                        float _e735 = yb_1;
                        float _e737 = q_1[1u];
                        float _e739 = len;
                        along = metal::clamp((_e735 - _e737) / _e739, 0.0, 1.0);
                        float _e742 = bright;
                        float _e743 = along;
                        fade = _e742 * (1.0 - (0.8 * _e743));
                        float _e747 = w;
                        float _e748 = along;
                        bw = _e747 * metal::mix(0.8, 0.4, _e748);
                        float _e751 = fade;
                        float _e752 = bd;
                        float _e754 = bd;
                        float _e756 = bw;
                        float _e757 = bw;
                        float _e762 = core;
                        core = _e762 + (_e751 * metal::exp((-(_e752) * _e754) / (_e756 * _e757)));
                        float _e764 = fade;
                        float _e766 = bd;
                        float _e771 = bd;
                        float _e778 = halo;
                        halo = _e778 + ((_e764 * 0.6) * ((0.7 * metal::exp(-(_e766) * 24.0)) + (0.25 * metal::exp(-(_e771) * 6.0))));
                        continue;
                    } else {
                        break;
                    }
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e784 = tCut;
    float _e785 = tCut;
    float _e787 = p_2;
    m = metal::smoothstep(_e784, _e785 + 0.025, _e787);
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e789 = m;
    if (_e789 < 1.0) {
        metal::float2 _e791 = uv_2;
        param_96 = _e791;
        metal::float4 _e792 = getFromColor(param_96, _from, _sampler);
        a = _e792;
        float _e793 = m;
        metal::float4 _e795 = a;
        float _e798 = a[3u];
        metal::float3 _e799 = _e795.xyz * _e798;
        float _e801 = a[3u];
        metal::float4 _e807 = c;
        c = _e807 + (metal::float4(_e799.x, _e799.y, _e799.z, _e801) * (1.0 - _e793));
    }
    float _e809 = m;
    if (_e809 > 0.0) {
        metal::float2 _e811 = uv_2;
        param_97 = _e811;
        metal::float4 _e812 = getToColor(param_97, _sampler, _to);
        a_1 = _e812;
        float _e813 = m;
        metal::float4 _e814 = a_1;
        float _e817 = a_1[3u];
        metal::float3 _e818 = _e814.xyz * _e817;
        float _e820 = a_1[3u];
        metal::float4 _e826 = c;
        c = _e826 + (metal::float4(_e818.x, _e818.y, _e818.z, _e820) * _e813);
    }
    float _e829 = c[3u];
    if (_e829 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e831 = c;
    float _e834 = c[3u];
    col = _e831.xyz / metal::float3(_e834);
    float _e837 = p_2;
    float _e839 = p_2;
    live = metal::smoothstep(0.0, 0.03, _e837) * (1.0 - metal::smoothstep(0.85, 1.0, _e839));
    float _e843 = p_2;
    float _e846 = tCut;
    float _e847 = tLast;
    float _e849 = p_2;
    dim = (0.4 * metal::smoothstep(0.0, 0.3, _e843)) * (1.0 - metal::smoothstep(_e846, _e847 + 0.15, _e849));
    float _e853 = flash;
    float _e854 = near;
    float _e860 = flash;
    f = _e853 * metal::mix(0.6 + (0.4 * metal::exp(-(_e854) * 4.0)), 1.0, metal::smoothstep(0.6, 1.0, _e860));
    float _e864 = dim;
    float _e865 = live;
    metal::float3 _e868 = col;
    col = _e868 * (1.0 - (_e864 * _e865));
    metal::float3 _e870 = col;
    float _e871 = f;
    float _e873 = live;
    metal::float3 _e878 = uniforms.color;
    float _e879 = f;
    float _e881 = live;
    col = (_e870 * (1.0 + ((2.5 * _e871) * _e873))) + (_e878 * ((1.1 * _e879) * _e881));
    float _e886 = uniforms.glow;
    g = 0.4 + (1.2 * _e886);
    metal::float3 _e890 = uniforms.color;
    float _e893 = core;
    metal::float3 _e898 = uniforms.color;
    float _e899 = g;
    float _e901 = halo;
    light = ((metal::mix(_e890, metal::float3(1.0, 1.0, 1.0), metal::float3(0.75)) * metal::min(_e893, 1.5)) * 1.6) + ((_e898 * _e899) * _e901);
    metal::float3 _e904 = light;
    float _e905 = boltLight;
    float _e907 = live;
    metal::float3 _e909 = col;
    col = _e909 + ((_e904 * _e905) * _e907);
    metal::float3 _e911 = col;
    float _e912 = whiteout;
    float _e914 = live;
    col = metal::mix(_e911, metal::float3(1.0, 1.0, 1.0), metal::float3((0.92 * _e912) * _e914));
    metal::float3 _e918 = col;
    metal::float3 _e921 = metal::clamp(_e918, metal::float3(0.0), metal::float3(1.0));
    float _e923 = c[3u];
    return metal::float4(_e921.x, _e921.y, _e921.z, _e923);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_98 = {};
    metal::float2 _e84 = _uv_1;
    param_98 = _e84;
    metal::float4 _e85 = transition(param_98, _from, _sampler, _to, uniforms);
    _fragColor = _e85;
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
