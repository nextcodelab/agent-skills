// Tumble — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Tumble.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is thrown away like a rigid card, tumbling end over end with a slight spin as it flies off into the distance in perspective, its darker back showing on every flip and its soft shadow shrinking on the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float flips;
    float spin;
    metal::float2 direction;
    float perspective;
    float shading;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e61 = uv[0u];
    float _e63 = uv[1u];
    metal::float4 _e66 = _from.sample(_sampler, metal::float2(_e61, 1.0 - _e63), metal::level(0.0));
    return _e66;
}

metal::float2 cardUv(
    thread metal::float2& q,
    constant Uniforms& uniforms
) {
    float _e61 = q[0u];
    float _e63 = uniforms.ratio;
    float _e66 = q[1u];
    return metal::clamp(metal::float2(_e61 / _e63, _e66) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
}

float cardDistance(
    thread metal::float2& q_1,
    constant Uniforms& uniforms
) {
    metal::float2 e = {};
    metal::float2 _e61 = q_1;
    float _e64 = uniforms.ratio;
    e = metal::abs(_e61) - metal::float2(0.5 * _e64, 0.5);
    float _e69 = e[0u];
    float _e71 = e[1u];
    return metal::max(_e69, _e71);
}

metal::float3 castOnCard(
    thread metal::float3& d,
    thread metal::float3& rel,
    thread metal::float3& U,
    thread metal::float3& V,
    thread metal::float3& N
) {
    float dn = {};
    float k = {};
    metal::float3 h = {};
    metal::float3 _e67 = d;
    metal::float3 _e68 = N;
    dn = metal::dot(_e67, _e68);
    float _e70 = dn;
    if (metal::abs(_e70) < 0.000001) {
        return metal::float3(0.0, 0.0, -1.0);
    }
    metal::float3 _e73 = rel;
    metal::float3 _e74 = N;
    float _e76 = dn;
    k = metal::dot(_e73, _e74) / _e76;
    float _e78 = k;
    metal::float3 _e79 = d;
    metal::float3 _e81 = rel;
    h = (_e79 * _e78) - _e81;
    metal::float3 _e83 = h;
    metal::float3 _e84 = U;
    metal::float3 _e86 = h;
    metal::float3 _e87 = V;
    float _e89 = k;
    return metal::float3(metal::dot(_e83, _e84), metal::dot(_e86, _e87), _e89);
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e61 = uv_1[0u];
    float _e63 = uv_1[1u];
    metal::float4 _e66 = _to.sample(_sampler, metal::float2(_e61, 1.0 - _e63), metal::level(0.0));
    return _e66;
}

metal::float3 roll(
    thread metal::float3& v,
    thread float& c,
    thread float& s
) {
    float _e62 = c;
    float _e64 = v[0u];
    float _e66 = s;
    float _e68 = v[1u];
    float _e71 = s;
    float _e73 = v[0u];
    float _e75 = c;
    float _e77 = v[1u];
    float _e81 = v[2u];
    return metal::float3((_e62 * _e64) - (_e66 * _e68), (_e71 * _e73) + (_e75 * _e77), _e81);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float t = {};
    float size = {};
    float away = {};
    float turn = {};
    float a = {};
    float r = {};
    float cr = {};
    float sr = {};
    metal::float3 U_1 = {};
    metal::float3 param = {};
    float param_1 = {};
    float param_2 = {};
    metal::float3 V_1 = {};
    metal::float3 param_3 = {};
    float param_4 = {};
    float param_5 = {};
    metal::float3 N_1 = {};
    metal::float3 param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float dist = {};
    metal::float2 seen = {};
    metal::float3 rel_1 = {};
    float fade = {};
    float shadowAmount = {};
    metal::float2 p = {};
    metal::float4 color = {};
    metal::float2 param_9 = {};
    metal::float3 ds = {};
    metal::float3 hs = {};
    metal::float3 param_10 = {};
    metal::float3 param_11 = {};
    metal::float3 param_12 = {};
    metal::float3 param_13 = {};
    metal::float3 param_14 = {};
    float blur = {};
    float sd = {};
    metal::float2 param_15 = {};
    float sh = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float3 d_1 = {};
    metal::float3 hit = {};
    metal::float3 param_18 = {};
    metal::float3 param_19 = {};
    metal::float3 param_20 = {};
    metal::float3 param_21 = {};
    metal::float3 param_22 = {};
    float dn_1 = {};
    float grazing = {};
    float e_1 = {};
    float m = {};
    metal::float2 param_23 = {};
    metal::float4 card = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    bool front = {};
    metal::float3 facing = {};
    metal::float3 local = {};
    float lit = {};
    float shade = {};
    float glint = {};
    metal::float4 mixed = {};
    metal::float4 local_1 = {};
    float _e125 = uniforms.progress;
    t = metal::clamp(_e125 / 0.95, 0.0, 1.0);
    float _e128 = t;
    float _e130 = t;
    float _e132 = t;
    size = metal::exp(((-2.8 * _e128) * _e130) * (0.4 + (0.6 * _e132)));
    float _e137 = size;
    away = 1.0 - _e137;
    float _e139 = t;
    float _e140 = t;
    float _e142 = t;
    turn = (_e139 * _e140) * (3.0 - (2.0 * _e142));
    float _e147 = uniforms.flips;
    float _e149 = turn;
    a = (6.2831855 * _e147) * _e149;
    float _e152 = uniforms.spin;
    float _e154 = turn;
    r = (6.2831855 * _e152) * _e154;
    float _e156 = r;
    cr = metal::cos(_e156);
    float _e158 = r;
    sr = metal::sin(_e158);
    param = metal::float3(1.0, 0.0, 0.0);
    float _e160 = cr;
    param_1 = _e160;
    float _e161 = sr;
    param_2 = _e161;
    metal::float3 _e162 = roll(param, param_1, param_2);
    U_1 = _e162;
    float _e163 = a;
    float _e165 = a;
    param_3 = metal::float3(0.0, metal::cos(_e163), metal::sin(_e165));
    float _e168 = cr;
    param_4 = _e168;
    float _e169 = sr;
    param_5 = _e169;
    metal::float3 _e170 = roll(param_3, param_4, param_5);
    V_1 = _e170;
    float _e171 = a;
    float _e174 = a;
    param_6 = metal::float3(0.0, -(metal::sin(_e171)), metal::cos(_e174));
    float _e177 = cr;
    param_7 = _e177;
    float _e178 = sr;
    param_8 = _e178;
    metal::float3 _e179 = roll(param_6, param_7, param_8);
    N_1 = _e179;
    float _e181 = uniforms.perspective;
    dist = 1.0 / metal::clamp(_e181, 0.1, 1.0);
    metal::float2 _e185 = uniforms.direction;
    float _e186 = away;
    float _e188 = t;
    float _e190 = t;
    seen = (_e185 * _e186) + metal::float2(0.0, (0.12 * _e188) * (1.0 - _e190));
    metal::float2 _e195 = seen;
    float _e196 = size;
    metal::float2 _e198 = _e195 / metal::float2(_e196);
    float _e199 = dist;
    float _e200 = size;
    rel_1 = metal::float3(_e198.x, _e198.y, _e199 / _e200);
    float _e205 = t;
    fade = 1.0 - metal::smoothstep(0.8, 1.0, _e205);
    float _e209 = uniforms.shading;
    float _e211 = size;
    float _e214 = fade;
    shadowAmount = ((0.6 * _e209) * metal::sqrt(_e211)) * _e214;
    float _e217 = uv_2[0u];
    float _e220 = uniforms.ratio;
    float _e223 = uv_2[1u];
    p = metal::float2((_e217 - 0.5) * _e220, _e223 - 0.5);
    metal::float2 _e226 = uv_2;
    param_9 = _e226;
    metal::float4 _e227 = getToColor(param_9, _sampler, _to);
    color = _e227;
    float _e228 = shadowAmount;
    if (_e228 > 0.0) {
        metal::float2 _e230 = p;
        float _e231 = t;
        float _e235 = size;
        metal::float2 _e237 = _e230 - ((metal::float2(-0.05, -0.08) * metal::min(4.0 * _e231, 1.0)) * _e235);
        float _e238 = dist;
        ds = metal::float3(_e237.x, _e237.y, _e238);
        metal::float3 _e242 = ds;
        param_10 = _e242;
        metal::float3 _e243 = rel_1;
        param_11 = _e243;
        metal::float3 _e244 = U_1;
        param_12 = _e244;
        metal::float3 _e245 = V_1;
        param_13 = _e245;
        metal::float3 _e246 = N_1;
        param_14 = _e246;
        metal::float3 _e247 = castOnCard(param_10, param_11, param_12, param_13, param_14);
        hs = _e247;
        float _e249 = hs[2u];
        if (_e249 > 0.0) {
            float _e251 = t;
            float _e255 = size;
            blur = 0.005 + ((0.06 * metal::min(3.0 * _e251, 1.0)) * _e255);
            metal::float3 _e258 = hs;
            param_15 = _e258.xy;
            float _e260 = cardDistance(param_15, uniforms);
            metal::float3 _e261 = ds;
            metal::float3 _e262 = N_1;
            metal::float3 _e265 = ds;
            float _e271 = hs[2u];
            sd = (_e260 * metal::max(metal::abs(metal::dot(_e261, _e262)) / metal::length(_e265), 0.05)) / _e271;
            float _e273 = blur;
            float _e275 = blur;
            float _e276 = sd;
            metal::float3 _e279 = hs;
            param_16 = _e279.xy;
            metal::float2 _e281 = cardUv(param_16, uniforms);
            param_17 = _e281;
            metal::float4 _e282 = getFromColor(param_17, _from, _sampler);
            sh = (1.0 - metal::smoothstep(-(_e273), _e275, _e276)) * _e282.w;
            float _e285 = shadowAmount;
            float _e286 = sh;
            metal::float4 _e289 = color;
            metal::float3 _e291 = _e289.xyz * (1.0 - (_e285 * _e286));
            color[0u] = _e291.x;
            color[1u] = _e291.y;
            color[2u] = _e291.z;
        }
    }
    metal::float2 _e298 = p;
    float _e299 = dist;
    d_1 = metal::float3(_e298.x, _e298.y, _e299);
    metal::float3 _e303 = d_1;
    param_18 = _e303;
    metal::float3 _e304 = rel_1;
    param_19 = _e304;
    metal::float3 _e305 = U_1;
    param_20 = _e305;
    metal::float3 _e306 = V_1;
    param_21 = _e306;
    metal::float3 _e307 = N_1;
    param_22 = _e307;
    metal::float3 _e308 = castOnCard(param_18, param_19, param_20, param_21, param_22);
    hit = _e308;
    float _e310 = hit[2u];
    if (_e310 <= 0.0) {
        metal::float4 _e312 = color;
        return _e312;
    }
    metal::float3 _e313 = d_1;
    metal::float3 _e314 = N_1;
    dn_1 = metal::dot(_e313, _e314);
    float _e316 = dn_1;
    metal::float3 _e318 = d_1;
    grazing = metal::max(metal::abs(_e316) / metal::length(_e318), 0.05);
    float _e322 = t;
    float _e327 = hit[2u];
    float _e329 = grazing;
    e_1 = ((0.0015 * metal::min(20.0 * _e322, 1.0)) * _e327) / _e329;
    metal::float3 _e331 = hit;
    param_23 = _e331.xy;
    float _e333 = cardDistance(param_23, uniforms);
    float _e334 = e_1;
    float _e339 = fade;
    m = metal::clamp(0.5 - (_e333 / metal::max(_e334, 0.000001)), 0.0, 1.0) * _e339;
    float _e341 = m;
    if (_e341 <= 0.0) {
        metal::float4 _e343 = color;
        return _e343;
    }
    metal::float3 _e344 = hit;
    param_24 = _e344.xy;
    metal::float2 _e346 = cardUv(param_24, uniforms);
    param_25 = _e346;
    metal::float4 _e347 = getFromColor(param_25, _from, _sampler);
    card = _e347;
    float _e348 = dn_1;
    front = _e348 > 0.0;
    bool _e350 = front;
    if (_e350) {
        metal::float3 _e351 = N_1;
        local = -(_e351);
    } else {
        metal::float3 _e353 = N_1;
        local = _e353;
    }
    metal::float3 _e354 = local;
    facing = _e354;
    metal::float3 _e355 = facing;
    lit = metal::min((0.35 + (0.65 * metal::max(metal::dot(_e355, metal::float3(0.348, 0.696, -0.628)), 0.0))) / 0.7582, 1.0);
    float _e362 = lit;
    bool _e363 = front;
    float _e367 = uniforms.shading;
    shade = metal::mix(1.0, _e362 * (_e363 ? 1.0 : 0.55), _e367);
    bool _e369 = front;
    if (!(_e369)) {
        metal::float4 _e371 = card;
        metal::float4 _e373 = card;
        float _e378 = uniforms.shading;
        metal::float3 _e381 = metal::mix(_e371.xyz, metal::float3(metal::dot(_e373.xyz, metal::float3(0.299, 0.587, 0.114))), metal::float3(0.4 * _e378));
        card[0u] = _e381.x;
        card[1u] = _e381.y;
        card[2u] = _e381.z;
    }
    metal::float3 _e388 = facing;
    metal::float3 _e389 = d_1;
    glint = metal::pow(metal::max(metal::dot(_e388, metal::normalize(metal::float3(0.348, 0.696, -0.628) - metal::normalize(_e389))), 0.0), 60.0);
    metal::float4 _e396 = card;
    float _e398 = shade;
    float _e401 = uniforms.shading;
    float _e403 = glint;
    float _e405 = t;
    metal::float3 _e409 = (_e396.xyz * _e398) + metal::float3(((0.35 * _e401) * _e403) * metal::smoothstep(0.0, 0.2, _e405));
    card[0u] = _e409.x;
    card[1u] = _e409.y;
    card[2u] = _e409.z;
    float _e416 = m;
    if (_e416 >= 1.0) {
        metal::float4 _e418 = card;
        return _e418;
    }
    metal::float4 _e419 = color;
    float _e422 = color[3u];
    metal::float3 _e423 = _e419.xyz * _e422;
    float _e425 = color[3u];
    metal::float4 _e430 = card;
    float _e433 = card[3u];
    metal::float3 _e434 = _e430.xyz * _e433;
    float _e436 = card[3u];
    float _e441 = m;
    mixed = metal::mix(metal::float4(_e423.x, _e423.y, _e423.z, _e425), metal::float4(_e434.x, _e434.y, _e434.z, _e436), metal::float4(_e441));
    float _e445 = mixed[3u];
    if (_e445 > 0.0) {
        metal::float4 _e447 = mixed;
        float _e450 = mixed[3u];
        metal::float3 _e452 = _e447.xyz / metal::float3(_e450);
        float _e454 = mixed[3u];
        local_1 = metal::float4(_e452.x, _e452.y, _e452.z, _e454);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e459 = local_1;
    return _e459;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_26 = {};
    metal::float2 _e60 = _uv_1;
    param_26 = _e60;
    metal::float4 _e61 = transition(param_26, _from, _sampler, _to, uniforms);
    _fragColor = _e61;
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
