// ShoreWash — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ShoreWash.glsl
// Author: gre
// License: MIT
// Description: A thin sheet of water runs up over the outgoing image like the last of a wave on a beach, its lobed front edged with bubbly foam; it slows, stops just past the far edge and drains back, leaving the incoming image wet and glossy as it dries
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float foam;
    float refraction;
    char _pad5[8];
    metal::float4 water;
};

metal::float2 hash22(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e85 = p;
    p3_ = metal::fract(_e85.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e89 = p3_;
    metal::float3 _e90 = p3_;
    metal::float3 _e95 = p3_;
    p3_ = _e95 + metal::float3(metal::dot(_e89, _e90.yzx + metal::float3(33.33)));
    metal::float3 _e98 = p3_;
    metal::float3 _e100 = p3_;
    metal::float3 _e103 = p3_;
    return metal::fract((_e98.xx + _e100.yz) * _e103.zy);
}

float bubbles(
    thread metal::float2& p_1,
    thread float& density
) {
    metal::float2 i = {};
    metal::float2 f = {};
    float d1_ = {};
    float d2_ = {};
    int y = {};
    int x = {};
    metal::float2 o = {};
    metal::float2 c = {};
    metal::float2 param = {};
    float d = {};
    float e = {};
    float w = {};
    metal::float2 _e97 = p_1;
    i = metal::floor(_e97);
    metal::float2 _e99 = p_1;
    f = metal::fract(_e99);
    d1_ = 8.0;
    d2_ = 8.0;
    y = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e135 = y;
            y = as_type<int>(as_type<uint>(_e135) + as_type<uint>(1));
        }
        loop_init = false;
        int _e101 = y;
        if (_e101 <= 1) {
            x = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e133 = x;
                    x = as_type<int>(as_type<uint>(_e133) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e103 = x;
                if (_e103 <= 1) {
                    int _e105 = x;
                    int _e107 = y;
                    o = metal::float2(static_cast<float>(_e105), static_cast<float>(_e107));
                    metal::float2 _e110 = o;
                    metal::float2 _e113 = i;
                    metal::float2 _e114 = o;
                    param = _e113 + _e114;
                    metal::float2 _e116 = hash22(param);
                    metal::float2 _e119 = f;
                    c = ((_e110 + metal::float2(0.15)) + (_e116 * 0.7)) - _e119;
                    metal::float2 _e121 = c;
                    metal::float2 _e122 = c;
                    d = metal::dot(_e121, _e122);
                    float _e124 = d;
                    float _e125 = d1_;
                    if (_e124 < _e125) {
                        float _e127 = d1_;
                        d2_ = _e127;
                        float _e128 = d;
                        d1_ = _e128;
                    } else {
                        float _e129 = d;
                        float _e130 = d2_;
                        if (_e129 < _e130) {
                            float _e132 = d;
                            d2_ = _e132;
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
    float _e137 = d2_;
    float _e139 = d1_;
    e = metal::sqrt(_e137) - metal::sqrt(_e139);
    float _e142 = density;
    w = 0.12 + (0.6 * _e142);
    float _e145 = w;
    float _e147 = w;
    float _e149 = e;
    float _e152 = density;
    return (1.0 - metal::smoothstep(_e145 - 0.12, _e147 + 0.12, _e149)) * metal::smoothstep(0.0, 0.35, _e152);
}

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

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e84 = v;
    metal::float2 _e85 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e84 - (metal::floor(_e84 / _e85) * _e85)));
}

float hash12(
    thread metal::float2& p_2
) {
    metal::float3 p3_1 = {};
    metal::float2 _e85 = p_2;
    p3_1 = metal::fract(_e85.xyx * 0.1031);
    metal::float3 _e89 = p3_1;
    metal::float3 _e90 = p3_1;
    metal::float3 _e95 = p3_1;
    p3_1 = _e95 + metal::float3(metal::dot(_e89, _e90.yzx + metal::float3(33.33)));
    float _e99 = p3_1[0u];
    float _e101 = p3_1[1u];
    float _e104 = p3_1[2u];
    return metal::fract((_e99 + _e101) * _e104);
}

float vnoise(
    thread metal::float2& p_3
) {
    metal::float2 i_1 = {};
    metal::float2 f_1 = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 _e90 = p_3;
    i_1 = metal::floor(_e90);
    metal::float2 _e92 = p_3;
    f_1 = metal::fract(_e92);
    metal::float2 _e94 = f_1;
    metal::float2 _e95 = f_1;
    metal::float2 _e97 = f_1;
    f_1 = (_e94 * _e95) * (metal::float2(3.0) - (_e97 * 2.0));
    metal::float2 _e102 = i_1;
    param_1 = _e102;
    float _e103 = hash12(param_1);
    metal::float2 _e104 = i_1;
    param_2 = _e104 + metal::float2(1.0, 0.0);
    float _e106 = hash12(param_2);
    float _e108 = f_1[0u];
    metal::float2 _e110 = i_1;
    param_3 = _e110 + metal::float2(0.0, 1.0);
    float _e112 = hash12(param_3);
    metal::float2 _e113 = i_1;
    param_4 = _e113 + metal::float2(1.0, 1.0);
    float _e115 = hash12(param_4);
    float _e117 = f_1[0u];
    float _e120 = f_1[1u];
    return metal::mix(metal::mix(_e103, _e106, _e108), metal::mix(_e112, _e115, _e117), _e120);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 q = {};
    float a = {};
    float b = {};
    float extent = {};
    float start = {};
    float stop = {};
    float up = {};
    float back = {};
    float front = {};
    float lobes = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float behind = {};
    float sheet = {};
    float swapped = {};
    metal::float2 rp = {};
    metal::float2 param_7 = {};
    float n0_ = {};
    metal::float2 param_8 = {};
    metal::float2 g = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float thick = {};
    metal::float2 off = {};
    metal::float4 c_1 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    float glint = {};
    float wet = {};
    metal::float2 param_15 = {};
    metal::float2 lp = {};
    float patches = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    float bandW = {};
    metal::float2 param_18 = {};
    float density_1 = {};
    metal::float2 param_19 = {};
    float f_2 = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    metal::float2 param_22 = {};
    float param_23 = {};
    float sh = {};
    metal::float2 _e133 = uniforms.direction;
    if (metal::length(_e133) > 0.0) {
        metal::float2 _e137 = uniforms.direction;
        local = metal::normalize(_e137);
    } else {
        local = metal::float2(0.0, 1.0);
    }
    metal::float2 _e139 = local;
    dir = _e139;
    metal::float2 _e140 = uv_2;
    float _e144 = uniforms.ratio;
    q = (_e140 - metal::float2(0.5)) * metal::float2(_e144, 1.0);
    metal::float2 _e147 = q;
    metal::float2 _e148 = dir;
    a = metal::dot(_e147, _e148);
    metal::float2 _e150 = q;
    float _e152 = dir[1u];
    float _e155 = dir[0u];
    b = metal::dot(_e150, metal::float2(-(_e152), _e155));
    float _e159 = dir[0u];
    float _e162 = uniforms.ratio;
    float _e165 = dir[1u];
    extent = 0.5 * ((metal::abs(_e159) * _e162) + metal::abs(_e165));
    float _e169 = extent;
    start = (-(_e169) - 0.06) - 0.1;
    float _e173 = extent;
    stop = (_e173 + 0.06) + 0.01;
    float _e177 = uniforms.progress;
    up = metal::clamp(_e177 / 0.4, 0.0, 1.0);
    float _e181 = uniforms.progress;
    back = metal::clamp((_e181 - 0.4) / 0.6, 0.0, 1.0);
    float _e185 = start;
    float _e186 = stop;
    float _e187 = up;
    float _e192 = stop;
    float _e193 = start;
    float _e195 = back;
    front = metal::mix(_e185, _e186, 1.0 - metal::pow(1.0 - _e187, 1.6)) - ((_e192 - _e193) * metal::pow(_e195, 1.5));
    float _e199 = b;
    float _e203 = uniforms.progress;
    param_5 = metal::float2((_e199 * 7.0) + 3.1, _e203 * 2.0);
    float _e206 = vnoise(param_5);
    float _e208 = b;
    float _e211 = uniforms.progress;
    param_6 = metal::float2(_e208 * 17.0, 5.0 + (_e211 * 3.0));
    float _e215 = vnoise(param_6);
    lobes = (_e206 * 0.7) + (_e215 * 0.3);
    float _e218 = front;
    float _e219 = lobes;
    float _e224 = a;
    behind = (_e218 + ((0.06 * (_e219 - 0.5)) * 2.0)) - _e224;
    float _e226 = behind;
    sheet = metal::smoothstep(-0.002, 0.002, _e226);
    float _e228 = behind;
    float _e231 = uniforms.progress;
    float _e233 = sheet;
    float _e236 = uniforms.progress;
    swapped = metal::max(metal::smoothstep(0.01, 0.08, _e228), ((_e231 < 0.4) ? _e233 : 1.0) * metal::smoothstep(0.32, 0.4, _e236));
    float _e240 = a;
    float _e242 = b;
    metal::float2 _e244 = q;
    param_7 = _e244 * 4.0;
    float _e246 = vnoise(param_7);
    float _e251 = uniforms.progress;
    float _e254 = back;
    rp = metal::float2(_e240 * 20.0, (_e242 * 5.0) + (3.0 * _e246)) - metal::float2((7.0 * metal::min(_e251, 0.4)) - (5.0 * _e254), 0.0);
    metal::float2 _e259 = rp;
    param_8 = _e259;
    float _e260 = vnoise(param_8);
    n0_ = _e260;
    metal::float2 _e261 = rp;
    param_9 = _e261 + metal::float2(0.15, 0.0);
    float _e263 = vnoise(param_9);
    float _e264 = n0_;
    metal::float2 _e267 = dir;
    metal::float2 _e269 = rp;
    param_10 = _e269 + metal::float2(0.0, 0.15);
    float _e271 = vnoise(param_10);
    float _e272 = n0_;
    float _e276 = dir[1u];
    float _e279 = dir[0u];
    g = (_e267 * ((_e263 - _e264) / 0.15)) + (metal::float2(-(_e276), _e279) * ((_e271 - _e272) / 0.15));
    float _e283 = sheet;
    float _e284 = behind;
    thick = _e283 * metal::smoothstep(0.0, 0.12, _e284);
    metal::float2 _e287 = g;
    float _e289 = uniforms.refraction;
    float _e291 = thick;
    float _e294 = uniforms.ratio;
    off = ((_e287 * _e289) * _e291) * metal::float2(1.0 / _e294, 1.0);
    metal::float2 _e298 = uv_2;
    metal::float2 _e299 = off;
    param_11 = _e298 + _e299;
    metal::float2 _e301 = mirror(param_11);
    param_12 = _e301;
    metal::float4 _e302 = getFromColor(param_12, _from, _sampler);
    metal::float2 _e303 = uv_2;
    metal::float2 _e304 = off;
    param_13 = _e303 + _e304;
    metal::float2 _e306 = mirror(param_13);
    param_14 = _e306;
    metal::float4 _e307 = getToColor(param_14, _sampler, _to);
    float _e308 = swapped;
    c_1 = metal::mix(_e302, _e307, metal::float4(_e308));
    metal::float4 _e311 = c_1;
    metal::float4 _e314 = uniforms.water;
    float _e318 = uniforms.water[3u];
    float _e319 = sheet;
    float _e321 = behind;
    metal::float3 _e327 = metal::mix(_e311.xyz, _e314.xyz, metal::float3((_e318 * _e319) * (0.3 + (0.7 * metal::smoothstep(0.0, 0.35, _e321)))));
    c_1[0u] = _e327.x;
    c_1[1u] = _e327.y;
    c_1[2u] = _e327.z;
    metal::float2 _e334 = g;
    metal::float2 _e335 = -(_e334);
    glint = metal::pow(metal::max(metal::dot(metal::normalize(metal::float3(_e335.x, _e335.y, 3.0)), metal::float3(-0.24913643, 0.49827287, 0.8304548)), 0.0), 14.0);
    float _e343 = glint;
    float _e345 = thick;
    metal::float4 _e347 = c_1;
    metal::float3 _e350 = _e347.xyz + metal::float3((_e343 * 0.4) * _e345);
    c_1[0u] = _e350.x;
    c_1[1u] = _e350.y;
    c_1[2u] = _e350.z;
    float _e357 = sheet;
    float _e359 = behind;
    float _e365 = uniforms.progress;
    float _e369 = uniforms.progress;
    wet = (((1.0 - _e357) * metal::exp(metal::min(_e359, 0.0) * 2.5)) * metal::smoothstep(0.4, 0.45, _e365)) * (1.0 - metal::smoothstep(0.7, 1.0, _e369));
    metal::float4 _e373 = c_1;
    float _e375 = wet;
    metal::float4 _e379 = c_1;
    metal::float3 _e381 = _e379.xyz * metal::mix(metal::float3(1.0, 1.0, 1.0), _e373.xyz, metal::float3(0.55 * _e375));
    c_1[0u] = _e381.x;
    c_1[1u] = _e381.y;
    c_1[2u] = _e381.z;
    float _e388 = wet;
    float _e390 = a;
    float _e392 = b;
    param_15 = metal::float2(_e390 * 30.0, _e392 * 6.0);
    float _e395 = vnoise(param_15);
    metal::float4 _e398 = c_1;
    metal::float3 _e401 = _e398.xyz + metal::float3((0.1 * _e388) * metal::smoothstep(0.4, 0.9, _e395));
    c_1[0u] = _e401.x;
    c_1[1u] = _e401.y;
    c_1[2u] = _e401.z;
    float _e408 = a;
    float _e410 = uniforms.progress;
    float _e412 = front;
    float _e413 = stop;
    float _e417 = b;
    lp = metal::float2(_e408 - (0.4 * ((_e410 < 0.4) ? _e412 : _e413)), _e417) / metal::float2(0.045);
    metal::float2 _e421 = lp;
    param_16 = (_e421 * metal::float2(0.4, 0.1)) + metal::float2(4.0);
    float _e425 = vnoise(param_16);
    metal::float2 _e427 = lp;
    param_17 = (_e427 * 0.3) + metal::float2(9.0);
    float _e431 = vnoise(param_17);
    patches = metal::smoothstep(0.45, 0.8, (0.6 * _e425) + (0.4 * _e431));
    float _e435 = b;
    param_18 = metal::float2(_e435 * 25.0, 2.0);
    float _e438 = vnoise(param_18);
    bandW = 0.1 * (0.5 + _e438);
    float _e441 = bandW;
    float _e442 = behind;
    float _e446 = uniforms.progress;
    density_1 = (1.0 - metal::smoothstep(0.0, _e441, _e442)) * (1.0 - metal::smoothstep(0.35, 0.52, _e446));
    float _e450 = density_1;
    float _e451 = patches;
    float _e453 = behind;
    float _e457 = back;
    density_1 = metal::max(_e450, ((0.55 * _e451) * (1.0 - metal::smoothstep(0.0, 0.3, _e453))) * (1.0 - (0.5 * _e457)));
    float _e462 = density_1;
    float _e463 = b;
    param_19 = metal::float2(_e463 * 40.0, 1.0);
    float _e466 = vnoise(param_19);
    float _e469 = behind;
    density_1 = metal::max(_e462, 0.9 * (1.0 - metal::smoothstep(0.0, 0.012 + (0.02 * _e466), _e469)));
    float _e474 = sheet;
    float _e475 = density_1;
    density_1 = _e475 * _e474;
    f_2 = 0.0;
    float _e477 = density_1;
    if (_e477 > 0.0) {
        metal::float2 _e479 = lp;
        param_20 = _e479;
        float _e480 = density_1;
        param_21 = _e480;
        float _e481 = bubbles(param_20, param_21);
        metal::float2 _e482 = lp;
        float _e486 = density_1;
        param_22 = (_e482 * 1.7) + metal::float2(7.0);
        param_23 = _e486 * 0.9;
        float _e488 = bubbles(param_22, param_23);
        f_2 = metal::max(_e481, 0.85 * _e488);
        float _e491 = f_2;
        float _e492 = density_1;
        float _e497 = uniforms.foam;
        f_2 = metal::max(_e491, 0.45 * metal::smoothstep(0.15, 0.7, _e492)) * _e497;
    }
    float _e499 = sheet;
    float _e502 = uniforms.foam;
    float _e504 = f_2;
    float _e507 = density_1;
    metal::float4 _e511 = c_1;
    metal::float3 _e513 = _e511.xyz * (1.0 - ((((0.25 * _e499) * _e502) * (1.0 - _e504)) * metal::smoothstep(0.0, 0.6, _e507)));
    c_1[0u] = _e513.x;
    c_1[1u] = _e513.y;
    c_1[2u] = _e513.z;
    metal::float4 _e520 = c_1;
    float _e522 = f_2;
    metal::float3 _e525 = metal::mix(_e520.xyz, metal::float3(0.97, 0.98, 0.97), metal::float3(metal::clamp(_e522, 0.0, 1.0)));
    c_1[0u] = _e525.x;
    c_1[1u] = _e525.y;
    c_1[2u] = _e525.z;
    float _e532 = behind;
    sh = metal::smoothstep(-0.03, 0.0, _e532);
    float _e534 = sheet;
    float _e537 = sh;
    float _e539 = sh;
    float _e542 = uniforms.progress;
    metal::float4 _e547 = c_1;
    metal::float3 _e549 = _e547.xyz * (1.0 - ((((0.35 * (1.0 - _e534)) * _e537) * _e539) * (1.0 - metal::smoothstep(0.35, 0.4, _e542))));
    c_1[0u] = _e549.x;
    c_1[1u] = _e549.y;
    c_1[2u] = _e549.z;
    metal::float4 _e556 = c_1;
    return _e556;
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
    metal::float2 _e84 = _uv_1;
    param_24 = _e84;
    metal::float4 _e85 = transition(param_24, _from, _sampler, _to, uniforms);
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
