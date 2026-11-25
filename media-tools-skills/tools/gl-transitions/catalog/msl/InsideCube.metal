// InsideCube — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InsideCube.glsl
// Author: gre
// License: MIT
// Description: The camera stands inside a cube: the outgoing image covers the wall in front of it and the view turns toward the next inner wall, so the outgoing image swings away in perspective as the incoming one turns into view, the walls darkening into the shaded inner corner between them
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float fov;
    float shading;
    char _pad5[8];
    metal::float4 background;
};

metal::float4 premultiply(
    thread metal::float4& c
) {
    metal::float4 _e36 = c;
    float _e39 = c[3u];
    metal::float3 _e40 = _e36.xyz * _e39;
    float _e42 = c[3u];
    return metal::float4(_e40.x, _e40.y, _e40.z, _e42);
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e37 = uv[0u];
    float _e39 = uv[1u];
    metal::float4 _e42 = _from.sample(_sampler, metal::float2(_e37, 1.0 - _e39), metal::level(0.0));
    return _e42;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e37 = uv_1[0u];
    float _e39 = uv_1[1u];
    metal::float4 _e42 = _to.sample(_sampler, metal::float2(_e37, 1.0 - _e39), metal::level(0.0));
    return _e42;
}

metal::float4 wallColor(
    thread metal::float2& l,
    thread bool& incoming,
    thread bool& vertical,
    thread float& s,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 h = {};
    metal::float2 p = {};
    metal::float2 local = {};
    metal::float2 st = {};
    metal::float4 local_1 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 param_2 = {};
    float _e48 = l[0u];
    float _e49 = s;
    float _e52 = l[1u];
    h = metal::float2(_e48 * _e49, _e52);
    bool _e54 = vertical;
    if (_e54) {
        metal::float2 _e55 = h;
        local = _e55.yx;
    } else {
        metal::float2 _e57 = h;
        local = _e57;
    }
    metal::float2 _e58 = local;
    p = _e58;
    metal::float2 _e59 = p;
    float _e61 = uniforms.ratio;
    st = metal::clamp((_e59 / metal::float2(_e61, 1.0)) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
    bool _e69 = incoming;
    if (_e69) {
        metal::float2 _e70 = st;
        param = _e70;
        metal::float4 _e71 = getToColor(param, _sampler, _to);
        local_1 = _e71;
    } else {
        metal::float2 _e72 = st;
        param_1 = _e72;
        metal::float4 _e73 = getFromColor(param_1, _from, _sampler);
        local_1 = _e73;
    }
    metal::float4 _e74 = local_1;
    param_2 = _e74;
    metal::float4 _e75 = premultiply(param_2);
    return _e75;
}

float cornerShadow(
    thread float& dist,
    thread float& size
) {
    float k = {};
    float _e38 = size;
    float _e39 = dist;
    k = 1.0 - metal::smoothstep(0.0, _e38, _e39);
    float _e42 = k;
    float _e43 = k;
    return _e42 * _e43;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    bool vertical_1 = {};
    float s_1 = {};
    float local_2 = {};
    metal::float2 p_1 = {};
    metal::float2 q = {};
    metal::float2 local_3 = {};
    float A = {};
    float local_4 = {};
    float B = {};
    float local_5 = {};
    float F = {};
    float e = {};
    float th = {};
    float c_1 = {};
    float sn = {};
    float amount = {};
    float aa = {};
    float shadow = {};
    metal::float2 cam = {};
    metal::float2 d = {};
    metal::float2 P = {};
    float sc = {};
    float tf = {};
    float local_6 = {};
    float af = {};
    metal::float2 lf = {};
    float ti = {};
    float local_7 = {};
    float ai = {};
    metal::float2 li = {};
    float size_1 = {};
    float edgeF = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float edgeI = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float shadeF = {};
    float shadeI = {};
    float wF = {};
    float covF = {};
    float covI = {};
    metal::float4 colF = {};
    metal::float4 local_8 = {};
    metal::float2 param_11 = {};
    bool param_12 = {};
    bool param_13 = {};
    float param_14 = {};
    metal::float4 colI = {};
    metal::float4 local_9 = {};
    metal::float2 param_15 = {};
    bool param_16 = {};
    bool param_17 = {};
    float param_18 = {};
    metal::float4 bg = {};
    metal::float4 param_19 = {};
    float cov = {};
    float tb = {};
    metal::float2 fl = {};
    float edgeB = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    metal::float4 col = {};
    metal::float4 local_10 = {};
    float _e108 = uniforms.direction[1u];
    float _e112 = uniforms.direction[0u];
    vertical_1 = metal::abs(_e108) > metal::abs(_e112);
    bool _e115 = vertical_1;
    if (_e115) {
        float _e118 = uniforms.direction[1u];
        local_2 = _e118;
    } else {
        float _e121 = uniforms.direction[0u];
        local_2 = _e121;
    }
    float _e122 = local_2;
    s_1 = (_e122 < 0.0) ? -1.0 : 1.0;
    metal::float2 _e125 = uv_2;
    float _e129 = uniforms.ratio;
    p_1 = (_e125 - metal::float2(0.5)) * metal::float2(_e129, 1.0);
    bool _e132 = vertical_1;
    if (_e132) {
        metal::float2 _e133 = p_1;
        local_3 = _e133.yx;
    } else {
        metal::float2 _e135 = p_1;
        local_3 = _e135;
    }
    metal::float2 _e136 = local_3;
    q = _e136;
    float _e137 = s_1;
    float _e139 = q[0u];
    q[0u] = _e139 * _e137;
    bool _e142 = vertical_1;
    if (_e142) {
        local_4 = 0.5;
    } else {
        float _e144 = uniforms.ratio;
        local_4 = 0.5 * _e144;
    }
    float _e146 = local_4;
    A = _e146;
    bool _e147 = vertical_1;
    if (_e147) {
        float _e149 = uniforms.ratio;
        local_5 = 0.5 * _e149;
    } else {
        local_5 = 0.5;
    }
    float _e151 = local_5;
    B = _e151;
    float _e152 = A;
    float _e154 = uniforms.fov;
    F = _e152 / metal::tan(((metal::clamp(_e154, 55.0, 170.0)) * 0.017453292519943295474) * 0.5);
    float _e161 = uniforms.progress;
    e = metal::smoothstep(0.0, 1.0, _e161);
    float _e163 = e;
    th = 1.5707964 * _e163;
    float _e165 = th;
    c_1 = metal::cos(_e165);
    float _e167 = th;
    sn = metal::sin(_e167);
    float _e169 = e;
    amount = metal::max(metal::sin(3.1415927 * _e169), 0.0);
    float _e173 = amount;
    aa = (0.002 * metal::min(1.0, 40.0 * _e173)) + 0.000001;
    float _e179 = uniforms.shading;
    float _e180 = amount;
    shadow = _e179 * metal::min(1.0, 4.0 * _e180);
    float _e184 = A;
    float _e185 = F;
    float _e187 = e;
    cam = metal::float2(1.0, -1.0) * ((_e184 - _e185) * _e187);
    float _e191 = q[0u];
    float _e192 = c_1;
    float _e194 = F;
    float _e195 = sn;
    float _e198 = F;
    float _e199 = c_1;
    float _e202 = q[0u];
    float _e203 = sn;
    d = metal::float2((_e191 * _e192) + (_e194 * _e195), (_e198 * _e199) - (_e202 * _e203));
    float _e207 = A;
    float _e208 = F;
    metal::float2 _e210 = cam;
    P = metal::float2(_e207, _e208) - _e210;
    float _e212 = F;
    float _e214 = P[0u];
    float _e215 = c_1;
    float _e218 = P[1u];
    float _e219 = sn;
    float _e224 = P[0u];
    float _e225 = sn;
    float _e228 = P[1u];
    float _e229 = c_1;
    sc = (_e212 * ((_e214 * _e215) - (_e218 * _e219))) / metal::max((_e224 * _e225) + (_e228 * _e229), 0.000001);
    float _e235 = d[1u];
    if (_e235 > 0.000001) {
        float _e237 = F;
        float _e239 = cam[1u];
        float _e242 = d[1u];
        local_6 = (_e237 - _e239) / _e242;
    } else {
        local_6 = 1000000.0;
    }
    float _e244 = local_6;
    tf = _e244;
    float _e246 = cam[0u];
    float _e247 = tf;
    float _e249 = d[0u];
    af = _e246 + (_e247 * _e249);
    float _e252 = af;
    float _e254 = q[1u];
    float _e255 = tf;
    lf = metal::float2(_e252, _e254 * _e255);
    float _e259 = d[0u];
    if (_e259 > 0.000001) {
        float _e261 = A;
        float _e263 = cam[0u];
        float _e266 = d[0u];
        local_7 = (_e261 - _e263) / _e266;
    } else {
        local_7 = 1000000.0;
    }
    float _e268 = local_7;
    ti = _e268;
    float _e269 = F;
    float _e270 = A;
    float _e273 = cam[1u];
    float _e274 = ti;
    float _e276 = d[1u];
    ai = (_e269 - _e270) - (_e273 + (_e274 * _e276));
    float _e280 = ai;
    float _e282 = q[1u];
    float _e283 = ti;
    li = metal::float2(_e280, _e282 * _e283);
    float _e286 = A;
    float _e287 = B;
    size_1 = 0.8 * metal::min(_e286, _e287);
    float _e290 = A;
    float _e291 = af;
    param_3 = _e290 - _e291;
    float _e293 = size_1;
    param_4 = _e293;
    float _e294 = cornerShadow(param_3, param_4);
    float _e295 = B;
    float _e297 = lf[1u];
    param_5 = _e295 - metal::abs(_e297);
    float _e300 = size_1;
    param_6 = _e300;
    float _e301 = cornerShadow(param_5, param_6);
    edgeF = _e294 + (0.5 * _e301);
    float _e304 = ai;
    float _e305 = A;
    param_7 = _e304 + _e305;
    float _e307 = size_1;
    param_8 = _e307;
    float _e308 = cornerShadow(param_7, param_8);
    float _e309 = B;
    float _e311 = li[1u];
    param_9 = _e309 - metal::abs(_e311);
    float _e314 = size_1;
    param_10 = _e314;
    float _e315 = cornerShadow(param_9, param_10);
    edgeI = _e308 + (0.5 * _e315);
    float _e319 = uniforms.shading;
    float _e321 = c_1;
    float _e325 = shadow;
    float _e327 = edgeF;
    shadeF = (1.0 - ((_e319 * 0.8) * (1.0 - _e321))) * (1.0 - ((0.7 * _e325) * metal::min(_e327, 1.0)));
    float _e333 = uniforms.shading;
    float _e335 = sn;
    float _e339 = shadow;
    float _e341 = edgeI;
    shadeI = (1.0 - ((_e333 * 0.8) * (1.0 - _e335))) * (1.0 - ((0.7 * _e339) * metal::min(_e341, 1.0)));
    float _e346 = sc;
    float _e348 = q[0u];
    float _e350 = aa;
    wF = metal::clamp(0.5 + ((_e346 - _e348) / _e350), 0.0, 1.0);
    float _e354 = wF;
    float _e355 = B;
    float _e356 = tf;
    float _e359 = q[1u];
    float _e362 = aa;
    float _e367 = af;
    float _e368 = A;
    float _e371 = d[1u];
    float _e373 = tf;
    float _e374 = F;
    float _e376 = aa;
    covF = (_e354 * metal::clamp(0.5 + (((_e355 / _e356) - metal::abs(_e359)) / _e362), 0.0, 1.0)) * metal::clamp(0.5 + (((_e367 + _e368) * _e371) / ((_e373 * _e374) * _e376)), 0.0, 1.0);
    float _e382 = wF;
    float _e384 = B;
    float _e385 = ti;
    float _e388 = q[1u];
    float _e391 = aa;
    float _e396 = A;
    float _e397 = ai;
    float _e400 = d[0u];
    float _e402 = ti;
    float _e403 = F;
    float _e405 = aa;
    covI = ((1.0 - _e382) * metal::clamp(0.5 + (((_e384 / _e385) - metal::abs(_e388)) / _e391), 0.0, 1.0)) * metal::clamp(0.5 + (((_e396 - _e397) * _e400) / ((_e402 * _e403) * _e405)), 0.0, 1.0);
    float _e411 = covF;
    if (_e411 > 0.0) {
        metal::float2 _e413 = lf;
        param_11 = _e413;
        param_12 = false;
        bool _e414 = vertical_1;
        param_13 = _e414;
        float _e415 = s_1;
        param_14 = _e415;
        metal::float4 _e416 = wallColor(param_11, param_12, param_13, param_14, _from, _sampler, _to, uniforms);
        local_8 = _e416;
    } else {
        local_8 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e417 = local_8;
    colF = _e417;
    float _e418 = covI;
    if (_e418 > 0.0) {
        metal::float2 _e420 = li;
        param_15 = _e420;
        param_16 = true;
        bool _e421 = vertical_1;
        param_17 = _e421;
        float _e422 = s_1;
        param_18 = _e422;
        metal::float4 _e423 = wallColor(param_15, param_16, param_17, param_18, _from, _sampler, _to, uniforms);
        local_9 = _e423;
    } else {
        local_9 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e424 = local_9;
    colI = _e424;
    float _e425 = shadeF;
    metal::float4 _e426 = colF;
    metal::float3 _e428 = _e426.xyz * _e425;
    colF[0u] = _e428.x;
    colF[1u] = _e428.y;
    colF[2u] = _e428.z;
    float _e435 = shadeI;
    metal::float4 _e436 = colI;
    metal::float3 _e438 = _e436.xyz * _e435;
    colI[0u] = _e438.x;
    colI[1u] = _e438.y;
    colI[2u] = _e438.z;
    metal::float4 _e446 = uniforms.background;
    param_19 = _e446;
    metal::float4 _e447 = premultiply(param_19);
    bg = _e447;
    float _e448 = covF;
    float _e449 = covI;
    cov = _e448 + _e449;
    float _e451 = cov;
    if (_e451 < 1.0) {
        float _e453 = B;
        float _e455 = q[1u];
        float _e459 = tf;
        float _e460 = ti;
        tb = metal::min(_e453 / metal::max(metal::abs(_e455), 0.000001), metal::min(_e459, _e460));
        metal::float2 _e463 = cam;
        float _e464 = tb;
        metal::float2 _e465 = d;
        fl = _e463 + (_e465 * _e464);
        float _e468 = F;
        float _e470 = fl[1u];
        param_20 = _e468 - _e470;
        float _e472 = size_1;
        param_21 = _e472;
        float _e473 = cornerShadow(param_20, param_21);
        float _e474 = A;
        float _e476 = fl[0u];
        param_22 = _e474 - _e476;
        float _e478 = size_1;
        param_23 = _e478;
        float _e479 = cornerShadow(param_22, param_23);
        edgeB = _e473 + _e479;
        float _e481 = shadow;
        float _e483 = edgeB;
        metal::float4 _e487 = bg;
        metal::float3 _e489 = _e487.xyz * (1.0 - ((0.5 * _e481) * metal::min(_e483, 1.0)));
        bg[0u] = _e489.x;
        bg[1u] = _e489.y;
        bg[2u] = _e489.z;
    }
    metal::float4 _e496 = colF;
    float _e497 = covF;
    metal::float4 _e499 = colI;
    float _e500 = covI;
    metal::float4 _e503 = bg;
    float _e504 = cov;
    col = ((_e496 * _e497) + (_e499 * _e500)) + (_e503 * (1.0 - _e504));
    float _e509 = col[3u];
    if (_e509 > 0.0) {
        metal::float4 _e511 = col;
        float _e514 = col[3u];
        metal::float3 _e516 = _e511.xyz / metal::float3(_e514);
        float _e518 = col[3u];
        local_10 = metal::float4(_e516.x, _e516.y, _e516.z, _e518);
    } else {
        local_10 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e523 = local_10;
    return _e523;
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
    metal::float2 _e36 = _uv_1;
    param_24 = _e36;
    metal::float4 _e37 = transition(param_24, _from, _sampler, _to, uniforms);
    _fragColor = _e37;
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
