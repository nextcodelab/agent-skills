// FrostWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FrostWipe.glsl
// Author: gre
// License: MIT
// Description: Ice crystals grow in from the edges of the frame with feathery, branching fronts, frosting the outgoing image white and blurry until it is covered, then thaw back out to the edges on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float spread;
    float scale;
    float blur;
    char _pad5[12];
    metal::float4 color;
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e86 = v;
    metal::float2 _e87 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e86 - (metal::floor(_e86 / _e87) * _e87)));
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e87 = v_1;
    v3_ = metal::fract(_e87.xyx * 0.1031);
    metal::float3 _e91 = v3_;
    metal::float3 _e92 = v3_;
    metal::float3 _e97 = v3_;
    v3_ = _e97 + metal::float3(metal::dot(_e91, _e92.yzx + metal::float3(33.33)));
    float _e101 = v3_[0u];
    float _e103 = v3_[1u];
    float _e106 = v3_[2u];
    return metal::fract((_e101 + _e103) * _e106);
}

float vnoise(
    thread metal::float2& v_2
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e92 = v_2;
    i = metal::floor(_e92);
    metal::float2 _e94 = v_2;
    f = metal::fract(_e94);
    metal::float2 _e96 = f;
    metal::float2 _e97 = f;
    metal::float2 _e99 = f;
    f = (_e96 * _e97) * (metal::float2(3.0) - (_e99 * 2.0));
    metal::float2 _e104 = i;
    param = _e104;
    float _e105 = hash12(param);
    metal::float2 _e106 = i;
    param_1 = _e106 + metal::float2(1.0, 0.0);
    float _e108 = hash12(param_1);
    float _e110 = f[0u];
    metal::float2 _e112 = i;
    param_2 = _e112 + metal::float2(0.0, 1.0);
    float _e114 = hash12(param_2);
    metal::float2 _e115 = i;
    param_3 = _e115 + metal::float2(1.0, 1.0);
    float _e117 = hash12(param_3);
    float _e119 = f[0u];
    float _e122 = f[1u];
    return metal::mix(metal::mix(_e105, _e108, _e110), metal::mix(_e114, _e117, _e119), _e122);
}

float ridged(
    thread metal::float2& v_3
) {
    float sum = {};
    float amp = {};
    int i_1 = {};
    float n = {};
    metal::float2 param_4 = {};
    sum = 0.0;
    amp = 0.5;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e112 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e112) + as_type<uint>(1));
        }
        loop_init = false;
        int _e91 = i_1;
        if (_e91 < 4) {
            metal::float2 _e93 = v_3;
            param_4 = _e93;
            float _e94 = vnoise(param_4);
            n = 1.0 - metal::abs((2.0 * _e94) - 1.0);
            float _e99 = amp;
            float _e100 = n;
            float _e102 = n;
            float _e104 = sum;
            sum = _e104 + ((_e99 * _e100) * _e102);
            metal::float2 _e106 = v_3;
            v_3 = (metal::float2x2(metal::float2(1.6, 1.2), metal::float2(-1.2, 1.6)) * _e106) + metal::float2(4.7);
            float _e110 = amp;
            amp = _e110 * 0.5;
            continue;
        } else {
            break;
        }
    }
    float _e114 = sum;
    return _e114 / 0.9375;
}

metal::float4 grains(
    thread metal::float2& v_4
) {
    metal::float2 i_2 = {};
    metal::float2 f_1 = {};
    float d1_ = {};
    float d2_ = {};
    metal::float3 seed = {};
    int y = {};
    int x = {};
    metal::float2 c = {};
    metal::float2 o = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float d = {};
    metal::float2 param_7 = {};
    metal::float2 _e99 = v_4;
    i_2 = metal::floor(_e99);
    metal::float2 _e101 = v_4;
    f_1 = metal::fract(_e101);
    d1_ = 8.0;
    d2_ = 8.0;
    seed = metal::float3(0.0, 0.0, 0.0);
    y = -1;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e152 = y;
            y = as_type<int>(as_type<uint>(_e152) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e103 = y;
        if (_e103 <= 1) {
            x = -1;
            uint2 loop_bound_2 = uint2(4294967295u);
            bool loop_init_2 = true;
            while(true) {
                if (metal::all(loop_bound_2 == uint2(0u))) { break; }
                loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
                if (!loop_init_2) {
                    int _e150 = x;
                    x = as_type<int>(as_type<uint>(_e150) + as_type<uint>(1));
                }
                loop_init_2 = false;
                int _e105 = x;
                if (_e105 <= 1) {
                    int _e107 = x;
                    int _e109 = y;
                    c = metal::float2(static_cast<float>(_e107), static_cast<float>(_e109));
                    metal::float2 _e112 = c;
                    metal::float2 _e113 = i_2;
                    metal::float2 _e114 = c;
                    param_5 = _e113 + _e114;
                    float _e116 = hash12(param_5);
                    metal::float2 _e117 = i_2;
                    metal::float2 _e118 = c;
                    param_6 = (_e117 + _e118) + metal::float2(17.3);
                    float _e122 = hash12(param_6);
                    metal::float2 _e125 = f_1;
                    o = (_e112 + metal::float2(_e116, _e122)) - _e125;
                    metal::float2 _e127 = o;
                    metal::float2 _e128 = o;
                    d = metal::dot(_e127, _e128);
                    float _e130 = d;
                    float _e131 = d1_;
                    if (_e130 < _e131) {
                        float _e133 = d1_;
                        d2_ = _e133;
                        float _e134 = d;
                        d1_ = _e134;
                        metal::float2 _e135 = i_2;
                        metal::float2 _e136 = c;
                        param_7 = (_e135 + _e136) + metal::float2(41.9);
                        float _e140 = hash12(param_7);
                        metal::float2 _e141 = o;
                        metal::float2 _e142 = -(_e141);
                        seed = metal::float3(_e140, _e142.x, _e142.y);
                    } else {
                        float _e146 = d;
                        float _e147 = d2_;
                        if (_e146 < _e147) {
                            float _e149 = d;
                            d2_ = _e149;
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
    float _e154 = d2_;
    float _e156 = d1_;
    metal::float3 _e159 = seed;
    return metal::float4(metal::sqrt(_e154) - metal::sqrt(_e156), _e159.x, _e159.y, _e159.z);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e87 = uv[0u];
    float _e89 = uv[1u];
    metal::float4 _e92 = _to.sample(_sampler, metal::float2(_e87, 1.0 - _e89), metal::level(0.0));
    return _e92;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e87 = uv_1[0u];
    float _e89 = uv_1[1u];
    metal::float4 _e92 = _from.sample(_sampler, metal::float2(_e87, 1.0 - _e89), metal::level(0.0));
    return _e92;
}

metal::float4 image(
    thread metal::float2& uv_2,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    float _e91 = m;
    if (_e91 <= 0.0) {
        metal::float2 _e93 = uv_2;
        param_8 = _e93;
        metal::float4 _e94 = getFromColor(param_8, _from, _sampler);
        return _e94;
    }
    float _e95 = m;
    if (_e95 >= 1.0) {
        metal::float2 _e97 = uv_2;
        param_9 = _e97;
        metal::float4 _e98 = getToColor(param_9, _sampler, _to);
        return _e98;
    }
    metal::float2 _e99 = uv_2;
    param_10 = _e99;
    metal::float4 _e100 = getFromColor(param_10, _from, _sampler);
    metal::float2 _e101 = uv_2;
    param_11 = _e101;
    metal::float4 _e102 = getToColor(param_11, _sampler, _to);
    float _e103 = m;
    return metal::mix(_e100, _e102, metal::float4(_e103));
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float h = {};
    float a = {};
    float m_1 = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    metal::float2 q = {};
    metal::float2 dEdge = {};
    float depth = {};
    float reach = {};
    float front = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    metal::float2 gv = {};
    metal::float4 gr = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    float u = {};
    metal::float2 dir = {};
    float t = {};
    float needle = {};
    float nh = {};
    float len = {};
    float r = {};
    metal::float2 param_19 = {};
    float rf = {};
    metal::float2 param_20 = {};
    float grow = {};
    float field = {};
    float inside = {};
    float f_2 = {};
    float haze = {};
    float frost = {};
    metal::float2 param_21 = {};
    float param_22 = {};
    float thick = {};
    float full = {};
    float radius = {};
    float rot = {};
    metal::float2 param_23 = {};
    metal::float3 rgb = {};
    float alpha = {};
    int i_3 = {};
    float k = {};
    float th = {};
    metal::float2 off = {};
    metal::float4 c_1 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    float param_26 = {};
    metal::float3 local = {};
    float stem = {};
    float needles = {};
    float glint = {};
    float veins = {};
    float rim = {};
    metal::float3 ice = {};
    float cover = {};
    metal::float4 under = {};
    metal::float4 res = {};
    metal::float2 sq = {};
    metal::float2 cell = {};
    metal::float2 d_1 = {};
    metal::float2 param_27 = {};
    metal::float2 param_28 = {};
    float star = {};
    float tw = {};
    metal::float2 param_29 = {};
    float sparkle = {};
    metal::float2 param_30 = {};
    float light = {};
    float _e159 = uniforms.progress;
    p = _e159;
    float _e160 = p;
    h = 1.0 - metal::abs((2.0 * _e160) - 1.0);
    float _e165 = h;
    a = metal::clamp(_e165 / 0.85, 0.0, 1.0);
    float _e168 = a;
    float _e169 = a;
    a = _e168 * (1.6 - (0.6 * _e169));
    float _e173 = p;
    m_1 = metal::smoothstep(0.47, 0.53, _e173);
    float _e175 = a;
    if (_e175 <= 0.0) {
        metal::float2 _e177 = uv_3;
        param_12 = _e177;
        float _e178 = m_1;
        param_13 = _e178;
        metal::float4 _e179 = image(param_12, param_13, _from, _sampler, _to);
        return _e179;
    }
    metal::float2 _e180 = uv_3;
    float _e182 = uniforms.ratio;
    q = _e180 * metal::float2(_e182, 1.0);
    metal::float2 _e185 = uv_3;
    metal::float2 _e186 = uv_3;
    float _e191 = uniforms.ratio;
    dEdge = metal::min(_e185, metal::float2(1.0) - _e186) * metal::float2(_e191, 1.0);
    float _e195 = dEdge[0u];
    float _e197 = dEdge[1u];
    float _e200 = uniforms.ratio;
    depth = metal::min(_e195, _e197) / (0.5 * metal::min(_e200, 1.0));
    float _e204 = depth;
    float _e206 = depth;
    depth = 1.0 - ((1.0 - _e204) * (1.0 - _e206));
    float _e211 = uniforms.spread;
    reach = 0.2 + (0.6 * metal::clamp(_e211, 0.0, 1.0));
    float _e215 = reach;
    float _e218 = a;
    front = metal::mix(-0.1, (1.0 + _e215) + 0.2, _e218);
    float _e220 = depth;
    float _e221 = front;
    if (_e220 > (_e221 + 0.08)) {
        metal::float2 _e224 = uv_3;
        param_14 = _e224;
        float _e225 = m_1;
        param_15 = _e225;
        metal::float4 _e226 = image(param_14, param_15, _from, _sampler, _to);
        return _e226;
    }
    metal::float2 _e227 = q;
    float _e229 = uniforms.scale;
    gv = _e227 * _e229;
    metal::float2 _e231 = gv;
    metal::float2 _e232 = gv;
    param_16 = _e232 * 1.7;
    float _e234 = vnoise(param_16);
    metal::float2 _e235 = gv;
    param_17 = (_e235 * 1.7) + metal::float2(23.1);
    float _e239 = vnoise(param_17);
    param_18 = _e231 + (metal::float2(_e234, _e239) * 0.35);
    metal::float4 _e243 = grains(param_18);
    gr = _e243;
    float _e245 = gr[1u];
    u = (2.0 * _e245) - 1.0;
    float _e248 = u;
    float _e249 = u;
    float _e252 = u;
    float _e255 = u;
    float _e256 = u;
    dir = metal::float2(1.0 - (_e248 * _e249), 2.0 * _e252) / metal::float2(1.0 + (_e255 * _e256));
    metal::float4 _e261 = gr;
    metal::float2 _e263 = dir;
    t = metal::dot(_e261.zw, _e263) * 7.0;
    float _e266 = t;
    needle = 1.0 - metal::abs((2.0 * metal::fract(_e266)) - 1.0);
    float _e273 = gr[1u];
    float _e274 = t;
    nh = metal::fract(_e273 + (0.618034 * metal::floor(_e274)));
    float _e279 = nh;
    len = metal::mix(0.15, 0.6, _e279);
    metal::float2 _e281 = gv;
    param_19 = _e281 * 1.3;
    float _e283 = ridged(param_19);
    r = _e283;
    metal::float2 _e284 = gv;
    param_20 = (_e284 * 4.0) + metal::float2(11.0);
    float _e288 = ridged(param_20);
    rf = _e288;
    float _e290 = gr[0u];
    float _e293 = gr[0u];
    float _e294 = len;
    float _e297 = needle;
    float _e301 = nh;
    grow = metal::min(_e290 * 3.5, (((_e293 / _e294) * 0.5) + ((1.0 - _e297) * 1.2)) + (0.2 * metal::fract(_e301 * 13.7)));
    float _e307 = depth;
    float _e308 = reach;
    float _e309 = grow;
    float _e312 = r;
    float _e318 = rf;
    field = (_e307 + (_e308 * ((0.8 * metal::min(_e309, 1.0)) + (0.2 * (1.0 - _e312))))) + (0.1 * (1.0 - _e318));
    float _e322 = front;
    float _e323 = field;
    inside = _e322 - _e323;
    float _e325 = inside;
    f_2 = metal::smoothstep(0.0, 0.03, _e325);
    float _e327 = rf;
    float _e330 = inside;
    haze = (0.4 * metal::smoothstep(0.9, 1.0, _e327)) * metal::smoothstep(-0.08, 0.0, _e330);
    float _e333 = f_2;
    float _e334 = haze;
    frost = metal::max(_e333, _e334);
    float _e336 = frost;
    if (_e336 <= 0.0) {
        metal::float2 _e338 = uv_3;
        param_21 = _e338;
        float _e339 = m_1;
        param_22 = _e339;
        metal::float4 _e340 = image(param_21, param_22, _from, _sampler, _to);
        return _e340;
    }
    float _e341 = inside;
    thick = metal::smoothstep(0.0, 0.5, _e341);
    float _e343 = h;
    full = metal::smoothstep(0.75, 0.95, _e343);
    float _e346 = uniforms.blur;
    float _e349 = frost;
    float _e351 = thick;
    radius = ((0.004 + (0.03 * _e346)) * _e349) * (0.5 + (0.5 * _e351));
    metal::float2 _e355 = q;
    param_23 = metal::floor(_e355 * 90.0);
    float _e358 = hash12(param_23);
    rot = 6.2831855 * _e358;
    rgb = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    i_3 = 0;
    uint2 loop_bound_3 = uint2(4294967295u);
    bool loop_init_3 = true;
    while(true) {
        if (metal::all(loop_bound_3 == uint2(0u))) { break; }
        loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
        if (!loop_init_3) {
            int _e402 = i_3;
            i_3 = as_type<int>(as_type<uint>(_e402) + as_type<uint>(1));
        }
        loop_init_3 = false;
        int _e360 = i_3;
        if (_e360 < 12) {
            int _e362 = i_3;
            k = (static_cast<float>(_e362) + 0.5) / 12.0;
            float _e366 = rot;
            int _e367 = i_3;
            th = _e366 + (static_cast<float>(_e367) * 2.3999631);
            float _e371 = k;
            float _e373 = th;
            float _e375 = th;
            float _e379 = radius;
            off = (metal::float2(metal::cos(_e373), metal::sin(_e375)) * metal::sqrt(_e371)) * _e379;
            metal::float2 _e381 = uv_3;
            metal::float2 _e382 = off;
            float _e384 = uniforms.ratio;
            param_24 = _e381 + (_e382 / metal::float2(_e384, 1.0));
            metal::float2 _e388 = mirror(param_24);
            param_25 = _e388;
            float _e389 = m_1;
            param_26 = _e389;
            metal::float4 _e390 = image(param_25, param_26, _from, _sampler, _to);
            c_1 = _e390;
            metal::float4 _e391 = c_1;
            float _e394 = c_1[3u];
            metal::float3 _e396 = rgb;
            rgb = _e396 + (_e391.xyz * _e394);
            float _e399 = c_1[3u];
            float _e400 = alpha;
            alpha = _e400 + _e399;
            continue;
        } else {
            break;
        }
    }
    float _e404 = alpha;
    alpha = _e404 / 12.0;
    float _e406 = alpha;
    if (_e406 > 0.0) {
        metal::float3 _e408 = rgb;
        float _e409 = alpha;
        local = _e408 / metal::float3(_e409 * 12.0);
    } else {
        local = metal::float3(0.0, 0.0, 0.0);
    }
    metal::float3 _e413 = local;
    rgb = _e413;
    float _e415 = gr[0u];
    stem = 1.0 - metal::smoothstep(0.0, 0.03, _e415);
    float _e418 = needle;
    float _e420 = len;
    float _e422 = gr[0u];
    needles = metal::smoothstep(0.7, 1.0, _e418) * (1.0 - metal::smoothstep(0.0, _e420, _e422));
    float _e426 = rf;
    glint = 0.4 + (0.6 * _e426);
    float _e429 = glint;
    float _e430 = stem;
    float _e432 = needles;
    float _e436 = r;
    veins = metal::clamp((_e429 * metal::max(0.35 * _e430, 0.55 * _e432)) + (0.3 * metal::smoothstep(0.6, 0.95, _e436)), 0.0, 1.0);
    float _e441 = inside;
    float _e443 = inside;
    rim = metal::smoothstep(0.0, 0.02, _e441) * (1.0 - metal::smoothstep(0.02, 0.07, _e443));
    metal::float4 _e448 = uniforms.color;
    float _e450 = veins;
    ice = metal::clamp(_e448.xyz * (0.82 + (0.25 * _e450)), metal::float3(0.0), metal::float3(1.0));
    float _e457 = frost;
    float _e458 = thick;
    float _e461 = veins;
    cover = _e457 * ((0.35 + (0.3 * _e458)) + (0.25 * _e461));
    float _e465 = cover;
    float _e466 = frost;
    float _e467 = full;
    cover = metal::clamp(metal::mix(_e465, _e466, _e467), 0.0, 1.0);
    metal::float3 _e470 = rgb;
    metal::float4 _e472 = uniforms.color;
    float _e474 = frost;
    metal::float3 _e478 = _e470 * metal::mix(metal::float3(1.0, 1.0, 1.0), _e472.xyz, metal::float3(0.5 * _e474));
    float _e479 = alpha;
    under = metal::float4(_e478.x, _e478.y, _e478.z, _e479);
    metal::float4 _e484 = under;
    metal::float3 _e485 = ice;
    float _e488 = uniforms.color[3u];
    float _e493 = cover;
    res = metal::mix(_e484, metal::float4(_e485.x, _e485.y, _e485.z, _e488), metal::float4(_e493));
    metal::float2 _e496 = q;
    sq = _e496 * 36.0;
    metal::float2 _e498 = sq;
    cell = metal::floor(_e498);
    metal::float2 _e500 = sq;
    metal::float2 _e501 = cell;
    metal::float2 _e505 = cell;
    param_27 = _e505 + metal::float2(1.3);
    float _e508 = hash12(param_27);
    metal::float2 _e509 = cell;
    param_28 = _e509 + metal::float2(5.9);
    float _e512 = hash12(param_28);
    d_1 = metal::abs(((_e500 - _e501) - metal::float2(0.25)) - (metal::float2(_e508, _e512) * 0.5));
    metal::float2 _e517 = d_1;
    float _e523 = d_1[0u];
    float _e525 = d_1[1u];
    float _e530 = d_1[0u];
    float _e532 = d_1[1u];
    star = metal::max(0.0, 1.0 - (9.0 * metal::length(_e517))) + metal::max(0.0, (1.0 - (4.0 * (_e523 + _e525))) - (30.0 * metal::min(_e530, _e532)));
    metal::float2 _e538 = cell;
    param_29 = _e538 + metal::float2(9.1);
    float _e541 = hash12(param_29);
    float _e542 = p;
    tw = 0.5 + (0.5 * metal::sin(6.2831855 * (_e541 + (2.0 * _e542))));
    metal::float2 _e549 = cell;
    param_30 = _e549 + metal::float2(3.7);
    float _e552 = hash12(param_30);
    float _e554 = star;
    float _e557 = tw;
    float _e559 = f_2;
    float _e561 = veins;
    sparkle = (((metal::step(0.82, _e552) * metal::min(_e554, 1.0)) * _e557) * _e559) * (0.4 + (0.6 * _e561));
    float _e565 = rim;
    float _e567 = sparkle;
    light = metal::clamp((0.4 * _e565) + (0.8 * _e567), 0.0, 1.0);
    metal::float4 _e571 = res;
    metal::float4 _e573 = uniforms.color;
    metal::float3 _e576 = metal::mix(_e573.xyz, metal::float3(1.0, 1.0, 1.0), metal::float3(0.6));
    float _e579 = uniforms.color[3u];
    float _e584 = light;
    res = metal::mix(_e571, metal::float4(_e576.x, _e576.y, _e576.z, _e579), metal::float4(_e584));
    metal::float4 _e587 = res;
    return metal::clamp(_e587, metal::float4(0.0), metal::float4(1.0));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_31 = {};
    metal::float2 _e86 = _uv_1;
    param_31 = _e86;
    metal::float4 _e87 = transition(param_31, _from, _sampler, _to, uniforms);
    _fragColor = _e87;
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
