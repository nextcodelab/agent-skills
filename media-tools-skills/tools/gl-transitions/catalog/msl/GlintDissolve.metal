// GlintDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlintDissolve.glsl
// Author: gre
// License: MIT
// Description: The bright points of the outgoing image sparkle into crisp four-point star glints that swell and twinkle up to the cut, then shrink back into the highlights of the incoming image, which stays sharp
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float size;
    float threshold;
    float intensity;
    int diagonals;
    float rotation;
    float rainbow;
    metal::float3 tint;
};

metal::float3 spectrum(
    thread float& a
) {
    float _e75 = a;
    return metal::float3(0.5) + (metal::cos((metal::float3(_e75) + metal::float3(0.0, 0.33, 0.67)) * 6.2831855) * 0.5);
}

float ray(
    thread metal::float2& d,
    thread float& len,
    thread float& width
) {
    float a_1 = {};
    float fall = {};
    float w = {};
    float _e81 = d[0u];
    float _e83 = len;
    a_1 = metal::abs(_e81) / _e83;
    float _e85 = a_1;
    if (_e85 >= 1.0) {
        return 0.0;
    }
    float _e87 = a_1;
    float _e89 = a_1;
    fall = (1.0 - _e87) * (1.0 - _e89);
    float _e92 = width;
    float _e93 = a_1;
    w = _e92 * (1.0 - (0.7 * _e93));
    float _e97 = fall;
    float _e99 = d[1u];
    float _e102 = d[1u];
    float _e104 = w;
    float _e105 = w;
    return _e97 * metal::exp((-(_e99) * _e102) / (_e104 * _e105));
}

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e76 = v;
    v3_ = metal::fract(_e76.xyx * 0.1031);
    metal::float3 _e80 = v3_;
    metal::float3 _e81 = v3_;
    metal::float3 _e86 = v3_;
    v3_ = _e86 + metal::float3(metal::dot(_e80, _e81.yzx + metal::float3(33.33)));
    float _e90 = v3_[0u];
    float _e92 = v3_[1u];
    float _e95 = v3_[2u];
    return metal::fract((_e90 + _e92) * _e95);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e76 = uv[0u];
    float _e78 = uv[1u];
    metal::float4 _e81 = _to.sample(_sampler, metal::float2(_e76, 1.0 - _e78), metal::level(0.0));
    return _e81;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e76 = uv_1[0u];
    float _e78 = uv_1[1u];
    metal::float4 _e81 = _from.sample(_sampler, metal::float2(_e76, 1.0 - _e78), metal::level(0.0));
    return _e81;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float t = {};
    float amount = {};
    float m = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 fromColor = {};
    metal::float2 param_2 = {};
    metal::float4 toColor = {};
    metal::float2 param_3 = {};
    metal::float4 c = {};
    metal::float3 base = {};
    float cell = {};
    float ang = {};
    metal::float2 cs = {};
    metal::float2 aspect = {};
    metal::float2 o = {};
    metal::float2 q = {};
    metal::float2 home = {};
    float width_1 = {};
    metal::float3 light = {};
    int k = {};
    float fk = {};
    metal::float2 off = {};
    float local_1 = {};
    float local_2 = {};
    metal::float2 id = {};
    metal::float2 param_4 = {};
    float h0_ = {};
    metal::float2 param_5 = {};
    float h1_ = {};
    metal::float2 param_6 = {};
    float h2_ = {};
    metal::float2 param_7 = {};
    float h3_ = {};
    metal::float2 param_8 = {};
    metal::float2 center = {};
    metal::float2 cw = {};
    metal::float2 st = {};
    float turn = {};
    metal::float4 src = {};
    metal::float4 local_3 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float lum = {};
    float knee = {};
    float b = {};
    float twinkle = {};
    float len_1 = {};
    metal::float2 d_1 = {};
    float r = {};
    float star = {};
    metal::float2 param_11 = {};
    float param_12 = {};
    float param_13 = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    float param_16 = {};
    metal::float2 e = {};
    metal::float2 param_17 = {};
    float param_18 = {};
    float param_19 = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float cr = {};
    float along = {};
    metal::float3 hue = {};
    float param_23 = {};
    metal::float3 col = {};
    bool phi_502_ = {};
    bool phi_509_ = {};
    bool phi_516_ = {};
    float _e147 = uniforms.progress;
    p = _e147;
    float _e148 = p;
    t = 1.0 - metal::abs((2.0 * _e148) - 1.0);
    float _e153 = t;
    float _e154 = t;
    amount = _e153 * (2.0 - _e154);
    float _e157 = p;
    m = metal::smoothstep(0.42, 0.58, _e157);
    float _e159 = amount;
    if (_e159 <= 0.0) {
        float _e161 = m;
        if (_e161 < 0.5) {
            metal::float2 _e163 = uv_2;
            param = _e163;
            metal::float4 _e164 = getFromColor(param, _from, _sampler);
            local = _e164;
        } else {
            metal::float2 _e165 = uv_2;
            param_1 = _e165;
            metal::float4 _e166 = getToColor(param_1, _sampler, _to);
            local = _e166;
        }
        metal::float4 _e167 = local;
        return _e167;
    }
    metal::float2 _e168 = uv_2;
    param_2 = _e168;
    metal::float4 _e169 = getFromColor(param_2, _from, _sampler);
    fromColor = _e169;
    metal::float2 _e170 = uv_2;
    param_3 = _e170;
    metal::float4 _e171 = getToColor(param_3, _sampler, _to);
    toColor = _e171;
    metal::float4 _e172 = fromColor;
    float _e175 = fromColor[3u];
    metal::float3 _e176 = _e172.xyz * _e175;
    float _e178 = fromColor[3u];
    metal::float4 _e183 = toColor;
    float _e186 = toColor[3u];
    metal::float3 _e187 = _e183.xyz * _e186;
    float _e189 = toColor[3u];
    float _e194 = m;
    c = metal::mix(metal::float4(_e176.x, _e176.y, _e176.z, _e178), metal::float4(_e187.x, _e187.y, _e187.z, _e189), metal::float4(_e194));
    float _e198 = c[3u];
    if (_e198 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e200 = c;
    float _e203 = c[3u];
    base = _e200.xyz / metal::float3(_e203);
    float _e207 = uniforms.size;
    cell = _e207 / 6.0;
    float _e210 = uniforms.rotation;
    ang = ((_e210) * 0.017453292519943295474);
    float _e212 = ang;
    float _e214 = ang;
    cs = metal::float2(metal::cos(_e212), metal::sin(_e214));
    float _e218 = uniforms.ratio;
    aspect = metal::float2(_e218, 1.0);
    metal::float2 _e220 = uv_2;
    metal::float2 _e223 = aspect;
    o = (_e220 - metal::float2(0.5)) * _e223;
    float _e226 = o[0u];
    float _e228 = cs[0u];
    float _e231 = o[1u];
    float _e233 = cs[1u];
    float _e237 = o[1u];
    float _e239 = cs[0u];
    float _e242 = o[0u];
    float _e244 = cs[1u];
    float _e248 = cell;
    q = metal::float2((_e226 * _e228) + (_e231 * _e233), (_e237 * _e239) - (_e242 * _e244)) / metal::float2(_e248);
    metal::float2 _e251 = q;
    home = metal::floor(_e251);
    float _e253 = cell;
    width_1 = metal::min(0.0022 / _e253, 0.07);
    light = metal::float3(0.0, 0.0, 0.0);
    k = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e568 = k;
            k = as_type<int>(as_type<uint>(_e568) + as_type<uint>(1));
        }
        loop_init = false;
        int _e256 = k;
        if (_e256 < 29) {
            int _e258 = k;
            fk = static_cast<float>(_e258);
            off = metal::float2(0.0, 0.0);
            int _e260 = k;
            int _e262 = k;
            if ((_e260 >= 1) && (_e262 <= 12)) {
                float _e265 = fk;
                if (_e265 < 7.0) {
                    float _e267 = fk;
                    local_1 = _e267 - 7.0;
                } else {
                    float _e269 = fk;
                    local_1 = _e269 - 6.0;
                }
                float _e271 = local_1;
                off = metal::float2(_e271, 0.0);
            } else {
                int _e273 = k;
                int _e275 = k;
                if ((_e273 >= 13) && (_e275 <= 24)) {
                    float _e278 = fk;
                    if (_e278 < 19.0) {
                        float _e280 = fk;
                        local_2 = _e280 - 19.0;
                    } else {
                        float _e282 = fk;
                        local_2 = _e282 - 18.0;
                    }
                    float _e284 = local_2;
                    off = metal::float2(0.0, _e284);
                } else {
                    int _e286 = k;
                    if (_e286 >= 25) {
                        float _e288 = fk;
                        float _e295 = fk;
                        off = metal::float2(((_e288 - (metal::floor(_e288 / 2.0) * 2.0)) * 2.0) - 1.0, (_e295 < 27.0) ? -1.0 : 1.0);
                    }
                }
            }
            float _e300 = off[0u];
            float _e303 = off[1u];
            float _e306 = amount;
            if (metal::max(metal::abs(_e300), metal::abs(_e303)) > ((6.0 * _e306) + 1.0)) {
                continue;
            }
            metal::float2 _e310 = home;
            metal::float2 _e311 = off;
            id = _e310 + _e311;
            metal::float2 _e313 = id;
            param_4 = _e313 + metal::float2(89.5);
            float _e316 = hash12(param_4);
            if (_e316 > 0.55) {
                continue;
            }
            metal::float2 _e318 = id;
            param_5 = _e318 + metal::float2(0.5);
            float _e321 = hash12(param_5);
            h0_ = _e321;
            metal::float2 _e322 = id;
            param_6 = _e322 + metal::float2(19.5);
            float _e325 = hash12(param_6);
            h1_ = _e325;
            metal::float2 _e326 = id;
            param_7 = _e326 + metal::float2(41.5);
            float _e329 = hash12(param_7);
            h2_ = _e329;
            metal::float2 _e330 = id;
            param_8 = _e330 + metal::float2(67.5);
            float _e333 = hash12(param_8);
            h3_ = _e333;
            metal::float2 _e334 = id;
            float _e337 = h0_;
            float _e338 = h1_;
            center = (_e334 + metal::float2(0.5)) + ((metal::float2(_e337, _e338) - metal::float2(0.5)) * 0.6);
            metal::float2 _e344 = center;
            float _e345 = cell;
            cw = _e344 * _e345;
            float _e348 = cw[0u];
            float _e350 = cs[0u];
            float _e353 = cw[1u];
            float _e355 = cs[1u];
            float _e359 = cw[0u];
            float _e361 = cs[1u];
            float _e364 = cw[1u];
            float _e366 = cs[0u];
            metal::float2 _e370 = aspect;
            st = (metal::float2((_e348 * _e350) - (_e353 * _e355), (_e359 * _e361) + (_e364 * _e366)) / _e370) + metal::float2(0.5);
            float _e375 = st[0u];
            bool _e376 = _e375 < 0.0;
            phi_502_ = _e376;
            if (!(_e376)) {
                float _e379 = st[0u];
                phi_502_ = _e379 > 1.0;
            }
            bool _e382 = phi_502_;
            phi_509_ = _e382;
            if (!(_e382)) {
                float _e385 = st[1u];
                phi_509_ = _e385 < 0.0;
            }
            bool _e388 = phi_509_;
            phi_516_ = _e388;
            if (!(_e388)) {
                float _e391 = st[1u];
                phi_516_ = _e391 > 1.0;
            }
            bool _e394 = phi_516_;
            if (_e394) {
                continue;
            }
            float _e395 = h3_;
            turn = 0.15 + (0.7 * _e395);
            float _e398 = m;
            float _e399 = turn;
            if (_e398 < _e399) {
                metal::float2 _e401 = st;
                param_9 = _e401;
                metal::float4 _e402 = getFromColor(param_9, _from, _sampler);
                local_3 = _e402;
            } else {
                metal::float2 _e403 = st;
                param_10 = _e403;
                metal::float4 _e404 = getToColor(param_10, _sampler, _to);
                local_3 = _e404;
            }
            metal::float4 _e405 = local_3;
            src = _e405;
            metal::float4 _e406 = src;
            float _e410 = src[3u];
            lum = metal::dot(_e406.xyz, metal::float3(0.2126, 0.7152, 0.0722)) * _e410;
            float _e413 = uniforms.threshold;
            float _e415 = uniforms.threshold;
            float _e418 = h2_;
            knee = _e413 + ((0.8 * (1.0 - _e415)) * _e418);
            float _e421 = knee;
            float _e422 = knee;
            float _e424 = uniforms.threshold;
            float _e429 = lum;
            b = metal::smoothstep(_e421, (_e422 + (0.2 * (1.0 - _e424))) + 0.001, _e429);
            float _e431 = b;
            if (_e431 <= 0.0) {
                continue;
            }
            float _e433 = h2_;
            float _e434 = h0_;
            float _e436 = p;
            float _e443 = m;
            float _e444 = turn;
            twinkle = (0.6 + (0.4 * metal::sin(6.2831855 * (_e433 + ((1.5 + _e434) * _e436))))) * metal::smoothstep(0.0, 0.12, metal::abs(_e443 - _e444));
            float _e449 = amount;
            float _e451 = b;
            float _e455 = h1_;
            float _e457 = h1_;
            float _e461 = twinkle;
            len_1 = (((6.0 * _e449) * (0.45 + (0.55 * _e451))) * (0.3 + ((0.7 * _e455) * _e457))) * (0.85 + (0.15 * _e461));
            metal::float2 _e465 = q;
            metal::float2 _e466 = center;
            d_1 = _e465 - _e466;
            metal::float2 _e468 = d_1;
            r = metal::length(_e468);
            metal::float2 _e470 = d_1;
            param_11 = _e470;
            float _e471 = len_1;
            param_12 = _e471;
            float _e472 = width_1;
            param_13 = _e472;
            float _e473 = ray(param_11, param_12, param_13);
            metal::float2 _e474 = d_1;
            param_14 = _e474.yx;
            float _e476 = len_1;
            param_15 = _e476;
            float _e477 = width_1;
            param_16 = _e477;
            float _e478 = ray(param_14, param_15, param_16);
            star = _e473 + _e478;
            int _e481 = uniforms.diagonals;
            if (_e481 != 0) {
                float _e484 = d_1[0u];
                float _e486 = d_1[1u];
                float _e489 = d_1[0u];
                float _e491 = d_1[1u];
                e = metal::float2(_e484 + _e486, _e489 - _e491) * 0.70710677;
                float _e495 = len_1;
                metal::float2 _e497 = e;
                param_17 = _e497;
                param_18 = 0.25 * _e495;
                float _e498 = width_1;
                param_19 = _e498;
                float _e499 = ray(param_17, param_18, param_19);
                float _e500 = len_1;
                metal::float2 _e502 = e;
                param_20 = _e502.yx;
                param_21 = 0.25 * _e500;
                float _e504 = width_1;
                param_22 = _e504;
                float _e505 = ray(param_20, param_21, param_22);
                float _e508 = star;
                star = _e508 + (0.5 * (_e499 + _e505));
            }
            float _e510 = r;
            float _e511 = len_1;
            cr = _e510 / (0.08 * _e511);
            float _e514 = cr;
            float _e516 = cr;
            float _e519 = r;
            float _e525 = star;
            star = _e525 + (metal::exp(-(_e514) * _e516) + (0.3 * metal::exp(-(_e519) / 0.2)));
            float _e527 = r;
            float _e528 = len_1;
            along = _e527 / _e528;
            float _e530 = along;
            float _e532 = h0_;
            param_23 = (1.3 * _e530) + _e532;
            metal::float3 _e534 = spectrum(param_23);
            float _e536 = uniforms.rainbow;
            float _e537 = along;
            hue = metal::mix(metal::float3(1.0, 1.0, 1.0), _e534, metal::float3(_e536 * metal::smoothstep(0.05, 0.4, _e537)));
            metal::float4 _e542 = src;
            float _e545 = src[0u];
            float _e547 = src[1u];
            float _e549 = src[2u];
            col = metal::mix(_e542.xyz / metal::float3(metal::max(metal::max(_e545, metal::max(_e547, _e549)), 0.001)), metal::float3(1.0, 1.0, 1.0), metal::float3(0.6));
            float _e557 = b;
            float _e558 = twinkle;
            float _e560 = star;
            metal::float3 _e562 = hue;
            metal::float3 _e564 = col;
            metal::float3 _e566 = light;
            light = _e566 + ((_e562 * ((_e557 * _e558) * _e560)) * _e564);
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e571 = uniforms.tint;
    float _e573 = uniforms.intensity;
    float _e575 = amount;
    float _e577 = amount;
    metal::float3 _e579 = light;
    light = _e579 * (((_e571 * _e573) * _e575) * _e577);
    metal::float3 _e581 = light;
    light = metal::float3(1.0) - metal::exp(-(_e581));
    metal::float3 _e586 = base;
    metal::float3 _e587 = light;
    metal::float3 _e589 = base;
    metal::float3 _e590 = light;
    metal::float3 _e595 = metal::clamp((_e586 + _e587) - (_e589 * _e590), metal::float3(0.0), metal::float3(1.0));
    float _e597 = c[3u];
    return metal::float4(_e595.x, _e595.y, _e595.z, _e597);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_24 = {};
    metal::float2 _e75 = _uv_1;
    param_24 = _e75;
    metal::float4 _e76 = transition(param_24, _from, _sampler, _to, uniforms);
    _fragColor = _e76;
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
