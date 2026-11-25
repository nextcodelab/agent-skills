// Drape — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Drape.glsl
// Author: gre
// License: MIT
// Description: The outgoing image hangs like a sheet of fabric that is let go at the top: it collapses into soft, uneven folds that hide one another as the cloth bunches up and slides down out of the frame, revealing the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float folds;
    float depth;
    float sway;
    float shadow;
};

float sidePull(
    thread float& sy,
    thread float& gT
) {
    float _e72 = gT;
    float _e74 = sy;
    return (0.035 * _e72) * (0.3 + (0.7 * metal::clamp(_e74, 0.0, 1.0)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e72 = uv[0u];
    float _e74 = uv[1u];
    metal::float4 _e77 = _to.sample(_sampler, metal::float2(_e72, 1.0 - _e74), metal::level(0.0));
    return _e77;
}

float topEdge(
    thread float& x,
    thread metal::float4& m
) {
    float c = {};
    float _e73 = x;
    c = (2.0 * _e73) - 1.0;
    float _e77 = m[1u];
    float _e79 = m[0u];
    float _e81 = c;
    float _e82 = c;
    return _e77 - ((0.08 * _e79) * (1.0 - (_e81 * _e82)));
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e72 = uv_1[0u];
    float _e74 = uv_1[1u];
    metal::float4 _e77 = _from.sample(_sampler, metal::float2(_e72, 1.0 - _e74), metal::level(0.0));
    return _e77;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e71 = v;
    metal::float2 _e72 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e71 - (metal::floor(_e71 / _e72) * _e72)));
}

float hash11(
    thread float& p
) {
    float _e71 = p;
    p = metal::fract(_e71 * 0.1031);
    float _e74 = p;
    float _e76 = p;
    p = _e76 * (_e74 + 33.33);
    float _e78 = p;
    float _e79 = p;
    float _e81 = p;
    p = _e81 * (_e78 + _e79);
    float _e83 = p;
    return metal::fract(_e83);
}

float noise1(
    thread float& x_1
) {
    float i = {};
    float f = {};
    float param = {};
    float param_1 = {};
    float _e75 = x_1;
    i = metal::floor(_e75);
    float _e77 = x_1;
    float _e78 = i;
    f = _e77 - _e78;
    float _e80 = i;
    param = _e80;
    float _e81 = hash11(param);
    float _e82 = i;
    param_1 = _e82 + 1.0;
    float _e84 = hash11(param_1);
    float _e85 = f;
    float _e86 = f;
    float _e88 = f;
    return metal::mix(_e81, _e84, (_e85 * _e86) * (3.0 - (2.0 * _e88)));
}

metal::float4 cloth(
    thread metal::float2& p_1,
    thread metal::float4& m_1,
    thread float& foldN,
    constant Uniforms& uniforms
) {
    float gT_1 = {};
    float botY = {};
    float x_2 = {};
    float top = {};
    float param_2 = {};
    metal::float4 param_3 = {};
    float sy_1 = {};
    float pull = {};
    float param_4 = {};
    float param_5 = {};
    float xc = {};
    float wander = {};
    float param_6 = {};
    float ph = {};
    float param_7 = {};
    float d = {};
    float param_8 = {};
    float amp = {};
    float w = {};
    float prof = {};
    float dt = {};
    float crease = {};
    bool on = {};
    metal::float4 local = {};
    float _e98 = m_1[0u];
    gT_1 = _e98;
    float _e100 = m_1[2u];
    botY = _e100;
    float _e102 = p_1[0u];
    float _e104 = m_1[3u];
    x_2 = _e102 - _e104;
    float _e106 = x_2;
    param_2 = _e106;
    metal::float4 _e107 = m_1;
    param_3 = _e107;
    float _e108 = topEdge(param_2, param_3);
    top = _e108;
    float _e110 = p_1[1u];
    float _e111 = botY;
    float _e113 = top;
    float _e114 = botY;
    sy_1 = (_e110 - _e111) / metal::max(_e113 - _e114, 0.0001);
    float _e118 = sy_1;
    param_4 = _e118;
    float _e119 = gT_1;
    param_5 = _e119;
    float _e120 = sidePull(param_4, param_5);
    pull = _e120;
    float _e121 = x_2;
    float _e122 = pull;
    float _e124 = pull;
    xc = (_e121 - _e122) / (1.0 - (2.0 * _e124));
    float _e128 = foldN;
    float _e130 = xc;
    float _e132 = sy_1;
    param_6 = (((0.5 * _e128) * _e130) + (2.5 * _e132)) + 5.3;
    float _e136 = noise1(param_6);
    float _e139 = sy_1;
    wander = ((_e136 - 0.5) * 2.4) * (1.0 - _e139);
    float _e142 = foldN;
    float _e143 = xc;
    float _e145 = foldN;
    float _e147 = xc;
    param_7 = ((0.7 * _e145) * _e147) + 1.7;
    float _e150 = noise1(param_7);
    float _e154 = wander;
    ph = (6.2831855 * ((_e142 * _e143) + (0.6 * _e150))) + _e154;
    float _e156 = foldN;
    float _e158 = xc;
    float _e160 = sy_1;
    param_8 = (((1.1 * _e156) * _e158) + (1.4 * _e160)) + 7.0;
    float _e164 = noise1(param_8);
    d = 0.15 + (0.85 * _e164);
    float _e168 = uniforms.depth;
    float _e170 = gT_1;
    float _e172 = sy_1;
    float _e174 = sy_1;
    float _e180 = foldN;
    amp = (((0.8 * _e168) * _e170) * (0.3 + ((0.7 * _e172) * metal::sqrt(metal::max(_e174, 0.0))))) / metal::max(_e180, 2.0);
    float _e183 = foldN;
    w = 0.6 / _e183;
    float _e185 = w;
    float _e186 = xc;
    float _e188 = w;
    float _e189 = xc;
    float _e193 = amp;
    amp = _e193 * (metal::smoothstep(0.0, _e185, _e186) * metal::smoothstep(0.0, _e188, 1.0 - _e189));
    float _e195 = ph;
    prof = 0.5 - (0.5 * metal::cos(_e195));
    float _e199 = sy_1;
    float _e201 = top;
    float _e202 = botY;
    dt = (1.0 - _e199) * (_e201 - _e202);
    float _e205 = dt;
    float _e208 = dt;
    float _e210 = ph;
    crease = metal::exp(-30.0 * _e205) * (0.5 + (0.5 * metal::sin((80.0 * _e208) + (0.7 * _e210))));
    float _e217 = sy_1;
    float _e219 = sy_1;
    float _e222 = xc;
    float _e225 = xc;
    on = (((_e217 >= 0.0) && (_e219 <= 1.0)) && (_e222 >= 0.0)) && (_e225 <= 1.0);
    bool _e228 = on;
    if (_e228) {
        float _e229 = amp;
        float _e230 = d;
        float _e231 = prof;
        float _e233 = crease;
        float _e237 = xc;
        float _e238 = sy_1;
        float _e239 = ph;
        local = metal::float4(_e229 * ((_e230 * _e231) + (0.15 * _e233)), _e237, _e238, _e239);
    } else {
        local = metal::float4(-1.0, -1.0, -1.0, -1.0);
    }
    metal::float4 _e241 = local;
    return _e241;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float t = {};
    float topY = {};
    float botY_1 = {};
    float f_1 = {};
    float foldN_1 = {};
    float shiftX = {};
    metal::float2 view = {};
    float zMax = {};
    metal::float4 m_2 = {};
    float zA = {};
    float zB = {};
    bool found = {};
    float dA = {};
    float dB = {};
    bool onA = {};
    int i_1 = {};
    float z = {};
    metal::float4 s = {};
    metal::float2 param_9 = {};
    metal::float4 param_10 = {};
    float param_11 = {};
    float dz = {};
    float zHit = {};
    float za = {};
    int j = {};
    float zm = {};
    metal::float2 param_12 = {};
    metal::float4 param_13 = {};
    float param_14 = {};
    metal::float2 hp = {};
    metal::float4 hit = {};
    metal::float4 local_1 = {};
    metal::float2 param_15 = {};
    metal::float4 param_16 = {};
    float param_17 = {};
    metal::float2 param_18 = {};
    metal::float4 param_19 = {};
    float param_20 = {};
    metal::float4 col = {};
    float cover = {};
    float xc_1 = {};
    float sy_2 = {};
    float ph_1 = {};
    float slope = {};
    float mu = {};
    float u = {};
    float h = {};
    float comp = {};
    float v_1 = {};
    metal::float4 tex = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    float span = {};
    float param_23 = {};
    metal::float4 param_24 = {};
    float e = {};
    float hx = {};
    metal::float2 param_25 = {};
    metal::float4 param_26 = {};
    float param_27 = {};
    float hy = {};
    metal::float2 param_28 = {};
    metal::float4 param_29 = {};
    float param_30 = {};
    float hx0_ = {};
    float local_2 = {};
    float hy0_ = {};
    float local_3 = {};
    metal::float3 nrm = {};
    metal::float3 light = {};
    float diffuse = {};
    float valley = {};
    float ao = {};
    float rim = {};
    float under = {};
    float back = {};
    float aa = {};
    float inside = {};
    float local_4 = {};
    metal::float4 to = {};
    metal::float2 param_31 = {};
    float x_3 = {};
    float pull_1 = {};
    float param_32 = {};
    metal::float4 param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float outside = {};
    float param_36 = {};
    metal::float4 param_37 = {};
    float sh = {};
    bool phi_610_ = {};
    float _e163 = uniforms.progress;
    t = _e163;
    float _e164 = t;
    float _e166 = t;
    topY = 1.0 - ((1.06 * _e164) * (0.35 + (0.65 * _e166)));
    float _e171 = t;
    float _e173 = t;
    float _e175 = t;
    botY_1 = ((-0.75 * _e171) * _e173) * _e175;
    float _e177 = t;
    float _e179 = t;
    float _e182 = t;
    f_1 = 1.0 - (((1.0 - _e177) * (1.0 - _e179)) * (1.0 - _e182));
    float _e187 = uniforms.folds;
    float _e189 = uniforms.ratio;
    foldN_1 = metal::max(1.0, metal::floor((_e187 * metal::min(_e189, 1.0)) + 0.5));
    float _e196 = uniforms.sway;
    float _e198 = t;
    float _e202 = f_1;
    shiftX = ((_e196 * 0.035) * metal::sin(6.2831855 * _e198)) * _e202;
    float _e205 = uniforms.sway;
    float _e207 = t;
    float _e211 = f_1;
    view = metal::float2(0.75 + (((0.5 * _e205) * metal::sin(3.1415927 * _e207)) * _e211), -0.35);
    float _e216 = uniforms.depth;
    float _e218 = f_1;
    float _e220 = foldN_1;
    zMax = ((0.92 * _e216) * _e218) / metal::max(_e220, 2.0);
    float _e223 = f_1;
    float _e224 = topY;
    float _e225 = botY_1;
    float _e226 = shiftX;
    m_2 = metal::float4(_e223, _e224, _e225, _e226);
    float _e228 = zMax;
    zA = _e228;
    zB = 0.0;
    found = false;
    dA = 0.0;
    dB = 0.0;
    onA = false;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e265 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e265) + as_type<uint>(1));
        }
        loop_init = false;
        int _e229 = i_1;
        if (_e229 < 24) {
            bool _e231 = found;
            if (!(_e231)) {
                float _e233 = zMax;
                int _e234 = i_1;
                z = metal::max(_e233 * (1.0 - (static_cast<float>(_e234) / 23.0)), 0.0);
                metal::float2 _e240 = uv_2;
                metal::float2 _e241 = view;
                float _e242 = z;
                param_9 = _e240 - (_e241 * _e242);
                metal::float4 _e245 = m_2;
                param_10 = _e245;
                float _e246 = foldN_1;
                param_11 = _e246;
                metal::float4 _e247 = cloth(param_9, param_10, param_11, uniforms);
                s = _e247;
                float _e249 = s[0u];
                float _e250 = z;
                dz = _e249 - _e250;
                float _e253 = s[0u];
                float _e255 = dz;
                if ((_e253 >= 0.0) && (_e255 >= 0.0)) {
                    found = true;
                    float _e258 = z;
                    zB = _e258;
                    float _e259 = dz;
                    dB = _e259;
                } else {
                    float _e260 = z;
                    zA = _e260;
                    float _e261 = dz;
                    dA = _e261;
                    float _e263 = s[0u];
                    onA = _e263 >= 0.0;
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e267 = zB;
    zHit = _e267;
    bool _e268 = found;
    float _e269 = zA;
    float _e270 = zB;
    if (_e268 && (_e269 > _e270)) {
        bool _e273 = onA;
        if (_e273) {
            float _e274 = zA;
            float _e275 = zB;
            float _e276 = dA;
            float _e277 = dA;
            float _e278 = dB;
            zHit = metal::mix(_e274, _e275, _e276 / (_e277 - _e278));
        } else {
            float _e282 = zA;
            za = _e282;
            j = 0;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e302 = j;
                    j = as_type<int>(as_type<uint>(_e302) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e283 = j;
                if (_e283 < 5) {
                    float _e285 = za;
                    float _e286 = zHit;
                    zm = 0.5 * (_e285 + _e286);
                    metal::float2 _e289 = uv_2;
                    metal::float2 _e290 = view;
                    float _e291 = zm;
                    param_12 = _e289 - (_e290 * _e291);
                    metal::float4 _e294 = m_2;
                    param_13 = _e294;
                    float _e295 = foldN_1;
                    param_14 = _e295;
                    metal::float4 _e296 = cloth(param_12, param_13, param_14, uniforms);
                    float _e298 = zm;
                    if (_e296.x >= _e298) {
                        float _e300 = zm;
                        zHit = _e300;
                    } else {
                        float _e301 = zm;
                        za = _e301;
                    }
                    continue;
                } else {
                    break;
                }
            }
        }
    }
    metal::float2 _e304 = uv_2;
    metal::float2 _e305 = view;
    float _e306 = zHit;
    hp = _e304 - (_e305 * _e306);
    bool _e309 = found;
    if (_e309) {
        metal::float2 _e310 = hp;
        param_15 = _e310;
        metal::float4 _e311 = m_2;
        param_16 = _e311;
        float _e312 = foldN_1;
        param_17 = _e312;
        metal::float4 _e313 = cloth(param_15, param_16, param_17, uniforms);
        local_1 = _e313;
    } else {
        local_1 = metal::float4(-1.0, -1.0, -1.0, -1.0);
    }
    metal::float4 _e314 = local_1;
    hit = _e314;
    bool _e315 = found;
    phi_610_ = _e315;
    if (_e315) {
        float _e317 = hit[0u];
        phi_610_ = _e317 < 0.0;
    }
    bool _e320 = phi_610_;
    if (_e320) {
        float _e321 = zB;
        zHit = _e321;
        metal::float2 _e322 = uv_2;
        metal::float2 _e323 = view;
        float _e324 = zB;
        hp = _e322 - (_e323 * _e324);
        metal::float2 _e327 = hp;
        param_18 = _e327;
        metal::float4 _e328 = m_2;
        param_19 = _e328;
        float _e329 = foldN_1;
        param_20 = _e329;
        metal::float4 _e330 = cloth(param_18, param_19, param_20, uniforms);
        hit = _e330;
    }
    col = metal::float4(0.0, 0.0, 0.0, 0.0);
    cover = 0.0;
    float _e332 = hit[0u];
    if (_e332 >= 0.0) {
        float _e335 = hit[1u];
        xc_1 = _e335;
        float _e337 = hit[2u];
        sy_2 = _e337;
        float _e339 = hit[3u];
        ph_1 = _e339;
        float _e340 = zMax;
        float _e342 = foldN_1;
        slope = (3.1415927 * _e340) * _e342;
        float _e344 = slope;
        float _e346 = slope;
        float _e348 = slope;
        float _e350 = slope;
        mu = metal::min(((0.25 * _e344) * _e346) / (1.0 + ((0.25 * _e348) * _e350)), 0.5);
        float _e355 = xc_1;
        float _e356 = mu;
        float _e357 = ph_1;
        float _e361 = foldN_1;
        u = _e355 - ((_e356 * metal::sin(2.0 * _e357)) / (12.566371 * _e361));
        float _e365 = topY;
        float _e366 = botY_1;
        h = metal::max(_e365 - _e366, 0.0001);
        float _e369 = h;
        comp = metal::max(1.0 - _e369, 0.0);
        float _e372 = sy_2;
        float _e373 = comp;
        float _e376 = comp;
        float _e377 = sy_2;
        float _e379 = sy_2;
        float _e381 = sy_2;
        v_1 = (_e372 * (1.0 - _e373)) + (((_e376 * _e377) * _e379) * _e381);
        float _e384 = u;
        float _e385 = v_1;
        param_21 = metal::float2(_e384, _e385);
        metal::float2 _e387 = mirror(param_21);
        param_22 = _e387;
        metal::float4 _e388 = getFromColor(param_22, _from, _sampler);
        tex = _e388;
        float _e390 = hp[0u];
        float _e391 = shiftX;
        param_23 = _e390 - _e391;
        metal::float4 _e393 = m_2;
        param_24 = _e393;
        float _e394 = topEdge(param_23, param_24);
        float _e395 = botY_1;
        span = _e394 - _e395;
        e = 0.002;
        metal::float2 _e397 = hp;
        float _e398 = e;
        param_25 = _e397 + metal::float2(_e398, 0.0);
        metal::float4 _e401 = m_2;
        param_26 = _e401;
        float _e402 = foldN_1;
        param_27 = _e402;
        metal::float4 _e403 = cloth(param_25, param_26, param_27, uniforms);
        hx = _e403.x;
        metal::float2 _e405 = hp;
        float _e406 = e;
        param_28 = _e405 + metal::float2(0.0, _e406);
        metal::float4 _e409 = m_2;
        param_29 = _e409;
        float _e410 = foldN_1;
        param_30 = _e410;
        metal::float4 _e411 = cloth(param_28, param_29, param_30, uniforms);
        hy = _e411.x;
        float _e413 = hx;
        if (_e413 >= 0.0) {
            float _e415 = hx;
            local_2 = _e415;
        } else {
            float _e417 = hit[0u];
            local_2 = _e417;
        }
        float _e418 = local_2;
        hx0_ = _e418;
        float _e419 = hy;
        if (_e419 >= 0.0) {
            float _e421 = hy;
            local_3 = _e421;
        } else {
            float _e423 = hit[0u];
            local_3 = _e423;
        }
        float _e424 = local_3;
        hy0_ = _e424;
        float _e425 = hx0_;
        float _e427 = hit[0u];
        float _e430 = e;
        float _e432 = hy0_;
        float _e434 = hit[0u];
        float _e437 = e;
        nrm = metal::normalize(metal::float3(-((_e425 - _e427)) / _e430, -((_e432 - _e434)) / _e437, 1.0));
        light = metal::float3(-0.390935, 0.30406058, 0.8687445);
        metal::float3 _e441 = nrm;
        metal::float3 _e442 = light;
        float _e446 = light[2u];
        float _e448 = f_1;
        diffuse = metal::mix(1.0, metal::max(metal::dot(_e441, _e442), 0.0) / _e446, metal::min(1.0, 3.0 * _e448));
        float _e452 = ph_1;
        valley = 1.0 - (0.5 - (0.5 * metal::cos(_e452)));
        float _e458 = uniforms.depth;
        float _e460 = f_1;
        float _e462 = valley;
        float _e464 = valley;
        float _e466 = sy_2;
        ao = 1.0 - (((((0.6 * _e458) * _e460) * _e462) * _e464) * (0.35 + (0.65 * _e466)));
        float _e471 = sy_2;
        float _e474 = span;
        float _e479 = f_1;
        rim = (metal::exp((-((1.0 - _e471)) * _e474) * 70.0) * 0.35) * _e479;
        float _e482 = hit[0u];
        float _e483 = zHit;
        under = metal::max(_e482 - _e483, 0.0);
        float _e486 = under;
        float _e487 = zMax;
        back = metal::min(1.0, _e486 / metal::max(0.1 * _e487, 0.000001));
        float _e492 = diffuse;
        float _e493 = ao;
        float _e495 = rim;
        float _e498 = back;
        metal::float4 _e502 = tex;
        metal::float3 _e504 = _e502.xyz * (((_e492 * _e493) * (1.0 - _e495)) * (1.0 - (0.6 * _e498)));
        tex[0u] = _e504.x;
        tex[1u] = _e504.y;
        tex[2u] = _e504.z;
        metal::float4 _e511 = tex;
        col = _e511;
        float _e512 = f_1;
        aa = 0.003 * _e512;
        float _e514 = sy_2;
        float _e516 = span;
        float _e519 = view[1u];
        float _e520 = under;
        float _e523 = xc_1;
        float _e524 = xc_1;
        inside = metal::min(((1.0 - _e514) * _e516) - (_e519 * _e520), metal::min(_e523, 1.0 - _e524));
        float _e528 = aa;
        if (_e528 > 0.0) {
            float _e530 = inside;
            float _e531 = aa;
            local_4 = metal::clamp(_e530 / _e531, 0.0, 1.0);
        } else {
            local_4 = 1.0;
        }
        float _e534 = local_4;
        cover = _e534;
        float _e535 = cover;
        if (_e535 >= 1.0) {
            metal::float4 _e537 = col;
            return _e537;
        }
    }
    metal::float2 _e538 = uv_2;
    param_31 = _e538;
    metal::float4 _e539 = getToColor(param_31, _sampler, _to);
    to = _e539;
    float _e541 = uv_2[0u];
    float _e542 = shiftX;
    x_3 = _e541 - _e542;
    float _e545 = uv_2[1u];
    float _e546 = botY_1;
    float _e548 = x_3;
    param_32 = _e548;
    metal::float4 _e549 = m_2;
    param_33 = _e549;
    float _e550 = topEdge(param_32, param_33);
    float _e551 = botY_1;
    param_34 = (_e545 - _e546) / metal::max(_e550 - _e551, 0.0001);
    float _e555 = f_1;
    param_35 = _e555;
    float _e556 = sidePull(param_34, param_35);
    pull_1 = _e556;
    float _e558 = uv_2[1u];
    float _e559 = x_3;
    param_36 = _e559;
    metal::float4 _e560 = m_2;
    param_37 = _e560;
    float _e561 = topEdge(param_36, param_37);
    float _e563 = x_3;
    float _e565 = x_3;
    float _e568 = pull_1;
    outside = metal::max(_e558 - _e561, metal::max(-(_e563), _e565 - 1.0) - _e568);
    float _e572 = uniforms.shadow;
    float _e573 = outside;
    float _e579 = f_1;
    float _e581 = t;
    sh = ((_e572 * metal::exp(-(metal::max(_e573, 0.0)) * 16.0)) * _e579) * metal::clamp(8.0 * (1.0 - _e581), 0.0, 1.0);
    metal::float4 _e586 = to;
    float _e588 = sh;
    metal::float3 _e591 = _e586.xyz * (1.0 - (0.8 * _e588));
    float _e593 = to[3u];
    metal::float4 _e598 = col;
    float _e599 = cover;
    return metal::mix(metal::float4(_e591.x, _e591.y, _e591.z, _e593), _e598, metal::float4(_e599));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_38 = {};
    metal::float2 _e71 = _uv_1;
    param_38 = _e71;
    metal::float4 _e72 = transition(param_38, _from, _sampler, _to, uniforms);
    _fragColor = _e72;
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
