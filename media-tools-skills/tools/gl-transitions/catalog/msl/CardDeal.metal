// CardDeal — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CardDeal.glsl
// Author: gre
// License: MIT
// Description: The incoming image is dealt onto the frame like a hand of cards: tile after tile is flicked from below the frame, spinning through the air with a lifting shadow, and slides to a stop in its place until the picture is complete
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 grid;
    metal::float2 deck;
    float spin;
    float shadow;
};

float cardDist(
    thread metal::float2& q,
    thread metal::float2& size
) {
    metal::float2 e = {};
    metal::float2 _e60 = q;
    metal::float2 _e61 = q;
    metal::float2 _e65 = size;
    e = metal::min(_e60, metal::float2(1.0) - _e61) * _e65;
    float _e68 = e[0u];
    float _e70 = e[1u];
    return metal::min(_e68, _e70);
}

float hash(
    thread float& n
) {
    metal::float2 p = {};
    float _e59 = n;
    p = metal::fract(metal::float2(_e59) * metal::float2(0.1031, 0.103));
    metal::float2 _e63 = p;
    metal::float2 _e64 = p;
    metal::float2 _e69 = p;
    p = _e69 + metal::float2(metal::dot(_e63, _e64.yx + metal::float2(33.33)));
    float _e73 = p[0u];
    float _e75 = p[1u];
    float _e78 = p[0u];
    return metal::fract((_e73 + _e75) * _e78);
}

metal::float2 cardCell(
    thread float& j,
    thread metal::float2& g
) {
    float row = {};
    float _e60 = j;
    float _e62 = g[0u];
    row = metal::floor(_e60 / _e62);
    float _e65 = j;
    float _e66 = row;
    float _e68 = g[0u];
    float _e72 = g[1u];
    float _e74 = row;
    return metal::float2(_e65 - (_e66 * _e68), (_e72 - 1.0) - _e74);
}

float cardTime(
    thread float& j_1,
    thread float& n_1,
    constant Uniforms& uniforms
) {
    float flight = {};
    float _e60 = n_1;
    flight = 1.0 / (1.0 + ((_e60 - 1.0) * 0.16));
    float _e66 = uniforms.progress;
    float _e67 = j_1;
    float _e69 = flight;
    float _e72 = flight;
    return metal::clamp((_e66 - ((_e67 * 0.16) * _e69)) / _e72, 0.0, 1.0);
}

metal::float2 gridSize_u0028_(
    constant Uniforms& uniforms
) {
    metal::int2 _e58 = uniforms.grid;
    return metal::clamp(static_cast<metal::float2>(_e58), metal::float2(1.0), metal::float2(6.0));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e59 = uv[0u];
    float _e61 = uv[1u];
    metal::float4 _e64 = _to.sample(_sampler, metal::float2(_e59, 1.0 - _e61), metal::level(0.0));
    return _e64;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e59 = uv_1[0u];
    float _e61 = uv_1[1u];
    metal::float4 _e64 = _from.sample(_sampler, metal::float2(_e59, 1.0 - _e61), metal::level(0.0));
    return _e64;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 g_1 = {};
    float n_2 = {};
    metal::float2 asp = {};
    metal::float2 size_1 = {};
    metal::float2 p_1 = {};
    metal::float2 origin = {};
    float darkness = {};
    metal::float2 own = {};
    float ownIndex = {};
    metal::float4 col = {};
    float param_2 = {};
    float param_3 = {};
    metal::float4 local = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    int i = {};
    float j_2 = {};
    float u = {};
    float param_6 = {};
    float param_7 = {};
    metal::float2 cell = {};
    float param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 target = {};
    metal::float2 way = {};
    float len = {};
    metal::float2 side = {};
    float r1_ = {};
    float param_10 = {};
    float r2_ = {};
    float param_11 = {};
    float turn = {};
    float slide = {};
    float a = {};
    float s = {};
    float v1_ = {};
    float f = {};
    float e_1 = {};
    float local_1 = {};
    metal::float2 c = {};
    float h = {};
    float angle = {};
    float tilt = {};
    float air = {};
    float fade = {};
    metal::float2 sp = {};
    float ca = {};
    float sa = {};
    metal::float2x2 rot = {};
    metal::float2 sq = {};
    float soft = {};
    float sh = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float dark = {};
    metal::float2 d = {};
    float ct = {};
    float st = {};
    float den = {};
    float k = {};
    float local_2 = {};
    metal::float2 q_1 = {};
    float edge = {};
    float m = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float4 face = {};
    metal::float2 param_16 = {};
    float light = {};
    float rim = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    float _e133 = uniforms.progress;
    if (_e133 <= 0.0) {
        metal::float2 _e135 = uv_2;
        param = _e135;
        metal::float4 _e136 = getFromColor(param, _from, _sampler);
        return _e136;
    }
    float _e138 = uniforms.progress;
    if (_e138 >= 1.0) {
        metal::float2 _e140 = uv_2;
        param_1 = _e140;
        metal::float4 _e141 = getToColor(param_1, _sampler, _to);
        return _e141;
    }
    metal::float2 _e142 = gridSize_u0028_(uniforms);
    g_1 = _e142;
    float _e144 = g_1[0u];
    float _e146 = g_1[1u];
    n_2 = _e144 * _e146;
    float _e149 = uniforms.ratio;
    asp = metal::float2(_e149, 1.0);
    metal::float2 _e151 = asp;
    metal::float2 _e152 = g_1;
    size_1 = _e151 / _e152;
    metal::float2 _e154 = uv_2;
    metal::float2 _e155 = asp;
    p_1 = _e154 * _e155;
    metal::float2 _e158 = uniforms.deck;
    metal::float2 _e159 = asp;
    origin = _e158 * _e159;
    float _e162 = uniforms.shadow;
    darkness = metal::clamp(_e162, 0.0, 1.0);
    metal::float2 _e164 = uv_2;
    metal::float2 _e165 = g_1;
    metal::float2 _e168 = g_1;
    own = metal::min(metal::floor(_e164 * _e165), _e168 - metal::float2(1.0));
    float _e173 = g_1[1u];
    float _e176 = own[1u];
    float _e179 = g_1[0u];
    float _e182 = own[0u];
    ownIndex = (((_e173 - 1.0) - _e176) * _e179) + _e182;
    float _e184 = ownIndex;
    param_2 = _e184;
    float _e185 = n_2;
    param_3 = _e185;
    float _e186 = cardTime(param_2, param_3, uniforms);
    if (_e186 >= 1.0) {
        metal::float2 _e188 = uv_2;
        param_4 = _e188;
        metal::float4 _e189 = getToColor(param_4, _sampler, _to);
        local = _e189;
    } else {
        metal::float2 _e190 = uv_2;
        param_5 = _e190;
        metal::float4 _e191 = getFromColor(param_5, _from, _sampler);
        local = _e191;
    }
    metal::float4 _e192 = local;
    col = _e192;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e547 = i;
            i = as_type<int>(as_type<uint>(_e547) + as_type<uint>(1));
        }
        loop_init = false;
        int _e193 = i;
        if (_e193 < 36) {
            int _e195 = i;
            j_2 = static_cast<float>(_e195);
            float _e197 = j_2;
            float _e198 = n_2;
            if (_e197 >= _e198) {
                break;
            }
            float _e200 = j_2;
            param_6 = _e200;
            float _e201 = n_2;
            param_7 = _e201;
            float _e202 = cardTime(param_6, param_7, uniforms);
            u = _e202;
            float _e203 = u;
            if (_e203 <= 0.0) {
                break;
            }
            float _e205 = u;
            if (_e205 >= 1.0) {
                continue;
            }
            float _e207 = j_2;
            param_8 = _e207;
            metal::float2 _e208 = g_1;
            param_9 = _e208;
            metal::float2 _e209 = cardCell(param_8, param_9);
            cell = _e209;
            metal::float2 _e210 = cell;
            metal::float2 _e213 = size_1;
            target = (_e210 + metal::float2(0.5)) * _e213;
            metal::float2 _e215 = target;
            metal::float2 _e216 = origin;
            way = _e215 - _e216;
            metal::float2 _e218 = way;
            len = metal::max(metal::length(_e218), 0.001);
            float _e222 = way[1u];
            float _e225 = way[0u];
            side = metal::float2(-(_e222), _e225);
            float _e227 = j_2;
            param_10 = _e227 + 1.0;
            float _e229 = hash(param_10);
            r1_ = _e229;
            float _e230 = j_2;
            param_11 = _e230 + 60.0;
            float _e232 = hash(param_11);
            r2_ = _e232;
            float _e233 = r2_;
            turn = (_e233 < 0.5) ? -1.0 : 1.0;
            float _e237 = size_1[1u];
            float _e239 = len;
            slide = metal::min((0.35 * _e237) / _e239, 0.5);
            float _e242 = u;
            a = metal::min(_e242 / 0.55, 1.0);
            float _e245 = u;
            s = metal::clamp((_e245 - 0.55) / 0.45, 0.0, 1.0);
            float _e249 = slide;
            float _e252 = slide;
            v1_ = ((2.0 * _e249) * 0.55) / (0.45 * (1.0 - _e252));
            float _e256 = a;
            float _e259 = a;
            float _e261 = a;
            float _e263 = a;
            float _e264 = a;
            float _e266 = a;
            float _e268 = a;
            float _e270 = a;
            float _e273 = a;
            float _e277 = v1_;
            float _e278 = a;
            float _e279 = a;
            float _e281 = a;
            float _e283 = a;
            float _e284 = a;
            f = ((((3.0 - (2.0 * _e256)) * _e259) * _e261) + (2.2 * ((((_e263 * _e264) * _e266) - ((2.0 * _e268) * _e270)) + _e273))) + (_e277 * (((_e278 * _e279) * _e281) - (_e283 * _e284)));
            float _e289 = u;
            if (_e289 < 0.55) {
                float _e291 = slide;
                float _e293 = f;
                local_1 = (1.0 - _e291) * _e293;
            } else {
                float _e295 = slide;
                float _e296 = s;
                float _e299 = s;
                local_1 = 1.0 - ((_e295 * (1.0 - _e296)) * (1.0 - _e299));
            }
            float _e303 = local_1;
            e_1 = _e303;
            metal::float2 _e304 = origin;
            metal::float2 _e305 = way;
            float _e306 = e_1;
            metal::float2 _e309 = side;
            float _e310 = turn;
            float _e312 = r1_;
            float _e316 = e_1;
            c = (_e304 + (_e305 * _e306)) + (((_e309 * _e310) * (0.05 + (0.05 * _e312))) * metal::sin(3.1415927 * _e316));
            float _e321 = r1_;
            float _e325 = a;
            float _e329 = a;
            h = ((0.45 * (0.7 + (0.3 * _e321))) * metal::sin(3.1415927 * _e325)) * (1.0 - (0.35 * _e329));
            float _e333 = turn;
            float _e335 = uniforms.spin;
            float _e337 = r2_;
            float _e343 = e_1;
            angle = ((((_e333 * _e335) * (0.8 + (0.4 * _e337))) * 2.0) * 3.1415927) * (1.0 - _e343);
            float _e346 = a;
            float _e350 = angle;
            float _e352 = r1_;
            tilt = (0.45 * metal::sin(3.1415927 * _e346)) * metal::cos((_e350 * 0.5) + (6.0 * _e352));
            float _e357 = a;
            float _e358 = a;
            air = 1.0 - (_e357 * _e358);
            float _e361 = u;
            fade = metal::smoothstep(0.0, 0.05, _e361);
            metal::float2 _e363 = p_1;
            metal::float2 _e364 = c;
            float _e366 = h;
            sp = ((_e363 - _e364) - (metal::float2(0.18, -0.3) * _e366)) - metal::float2(0.002, -0.003);
            float _e370 = angle;
            ca = metal::cos(_e370);
            float _e372 = angle;
            sa = metal::sin(_e372);
            float _e374 = ca;
            float _e375 = sa;
            float _e377 = sa;
            float _e378 = ca;
            rot = metal::float2x2(metal::float2(_e374, -(_e375)), metal::float2(_e377, _e378));
            metal::float2x2 _e382 = rot;
            metal::float2 _e383 = sp;
            metal::float2 _e385 = size_1;
            sq = ((_e382 * _e383) / _e385) + metal::float2(0.5);
            float _e389 = h;
            soft = 0.006 + (0.08 * _e389);
            float _e392 = soft;
            float _e394 = soft;
            metal::float2 _e395 = sq;
            param_12 = _e395;
            metal::float2 _e396 = size_1;
            param_13 = _e396;
            float _e397 = cardDist(param_12, param_13);
            sh = metal::smoothstep(-(_e392), _e394, _e397);
            float _e399 = s;
            float _e402 = h;
            float _e406 = air;
            dark = metal::mix(0.8 * (1.0 - _e399), 0.65 - ((0.3 * _e402) / 0.45), _e406);
            float _e408 = fade;
            float _e409 = darkness;
            float _e411 = dark;
            float _e413 = sh;
            metal::float4 _e416 = col;
            metal::float3 _e418 = _e416.xyz * (1.0 - (((_e408 * _e409) * _e411) * _e413));
            col[0u] = _e418.x;
            col[1u] = _e418.y;
            col[2u] = _e418.z;
            metal::float2x2 _e425 = rot;
            metal::float2 _e426 = p_1;
            metal::float2 _e427 = c;
            float _e430 = h;
            d = ((_e425 * (_e426 - _e427)) * (2.4 - _e430)) / metal::float2(2.4);
            float _e435 = tilt;
            ct = metal::cos(_e435);
            float _e437 = tilt;
            st = metal::sin(_e437);
            float _e439 = ct;
            float _e442 = d[1u];
            float _e443 = st;
            den = (2.4 * _e439) + (_e442 * _e443);
            float _e446 = den;
            if (_e446 > 0.001) {
                float _e448 = ct;
                float _e450 = den;
                local_2 = (2.4 * _e448) / _e450;
            } else {
                local_2 = 1000.0;
            }
            float _e452 = local_2;
            k = _e452;
            float _e453 = k;
            float _e455 = d[0u];
            float _e457 = k;
            float _e459 = d[1u];
            float _e461 = ct;
            float _e463 = k;
            float _e466 = st;
            metal::float2 _e470 = size_1;
            q_1 = (metal::float2(_e453 * _e455, ((_e457 * _e459) * _e461) + ((2.4 * (1.0 - _e463)) * _e466)) / _e470) + metal::float2(0.5);
            float _e474 = air;
            float _e478 = s;
            edge = (0.0015 * (1.0 + (2.0 * _e474))) * metal::min(10.0 * (1.0 - _e478), 1.0);
            float _e483 = fade;
            metal::float2 _e484 = q_1;
            param_14 = _e484;
            metal::float2 _e485 = size_1;
            param_15 = _e485;
            float _e486 = cardDist(param_14, param_15);
            float _e487 = edge;
            m = _e483 * metal::clamp((_e486 / metal::max(_e487, 0.000001)) + 0.5, 0.0, 1.0);
            float _e493 = m;
            if (_e493 > 0.0) {
                metal::float2 _e495 = cell;
                metal::float2 _e496 = q_1;
                metal::float2 _e501 = g_1;
                param_16 = (_e495 + metal::clamp(_e496, metal::float2(0.0), metal::float2(1.0))) / _e501;
                metal::float4 _e503 = getToColor(param_16, _sampler, _to);
                face = _e503;
                float _e504 = st;
                float _e506 = turn;
                float _e508 = angle;
                light = 1.0 + ((0.6 * _e504) * (0.6 - ((0.4 * _e506) * metal::sin(_e508))));
                metal::float2 _e514 = q_1;
                param_17 = _e514;
                metal::float2 _e515 = size_1;
                param_18 = _e515;
                float _e516 = cardDist(param_17, param_18);
                rim = 1.0 - metal::smoothstep(0.0, 0.008, _e516);
                metal::float4 _e519 = face;
                float _e521 = light;
                float _e524 = face[3u];
                float _e528 = face[3u];
                float _e530 = air;
                float _e532 = rim;
                metal::float3 _e535 = metal::mix(metal::min(_e519.xyz * _e521, metal::float3(_e524)), metal::float3(_e528), metal::float3((0.45 * _e530) * _e532));
                face[0u] = _e535.x;
                face[1u] = _e535.y;
                face[2u] = _e535.z;
                metal::float4 _e542 = col;
                metal::float4 _e543 = face;
                float _e544 = m;
                col = metal::mix(_e542, _e543, metal::float4(_e544));
            }
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e549 = col;
    return _e549;
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
    metal::float2 _e58 = _uv_1;
    param_19 = _e58;
    metal::float4 _e59 = transition(param_19, _from, _sampler, _to, uniforms);
    _fragColor = _e59;
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
