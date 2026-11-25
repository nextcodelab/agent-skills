// VhsTracking — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/VhsTracking.glsl
// Author: gre
// License: MIT
// Description: Tape-tracking bands of white snow roll down the frame, tearing the lines around them, with smeared color, wobbling lines, a jittering strip at the bottom and a dropout flash, as the incoming image is recorded over the outgoing one under the densest band
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int bands;
    float noise;
    float bleed;
    float wobble;
};

float luma(
    thread metal::float3& c
) {
    metal::float3 _e73 = c;
    return metal::dot(_e73, metal::float3(0.299, 0.587, 0.114));
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e74 = uv[0u];
    float _e76 = uv[1u];
    metal::float4 _e79 = _from.sample(_sampler, metal::float2(_e74, 1.0 - _e76), metal::level(0.0));
    return _e79;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e74 = uv_1[0u];
    float _e76 = uv_1[1u];
    metal::float4 _e79 = _to.sample(_sampler, metal::float2(_e74, 1.0 - _e76), metal::level(0.0));
    return _e79;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e73 = v;
    metal::float2 _e74 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e73 - (metal::floor(_e73 / _e74) * _e74)));
}

metal::float4 tape(
    thread metal::float2& p,
    thread bool& fresh,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param = {};
    metal::float4 c_1 = {};
    metal::float4 local = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 _e79 = p;
    param = _e79;
    metal::float2 _e80 = mirror(param);
    p = _e80;
    bool _e81 = fresh;
    if (_e81) {
        metal::float2 _e82 = p;
        param_1 = _e82;
        metal::float4 _e83 = getToColor(param_1, _sampler, _to);
        local = _e83;
    } else {
        metal::float2 _e84 = p;
        param_2 = _e84;
        metal::float4 _e85 = getFromColor(param_2, _from, _sampler);
        local = _e85;
    }
    metal::float4 _e86 = local;
    c_1 = _e86;
    metal::float4 _e87 = c_1;
    float _e90 = c_1[3u];
    metal::float3 _e91 = _e87.xyz * _e90;
    float _e93 = c_1[3u];
    return metal::float4(_e91.x, _e91.y, _e91.z, _e93);
}

float bandDensity(
    thread float& y,
    thread float& c_2,
    thread float& w,
    thread float& jitter
) {
    float d = {};
    float _e77 = y;
    float _e78 = c_2;
    float _e81 = w;
    float _e83 = jitter;
    d = (metal::abs(_e77 - _e78) / _e81) + (0.35 * _e83);
    float _e86 = d;
    return 1.0 - metal::smoothstep(0.0, 1.0, _e86);
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e74 = v_1;
    v3_ = metal::fract(_e74.xyx * 0.1031);
    metal::float3 _e78 = v3_;
    metal::float3 _e79 = v3_;
    metal::float3 _e84 = v3_;
    v3_ = _e84 + metal::float3(metal::dot(_e78, _e79.yzx + metal::float3(33.33)));
    float _e88 = v3_[0u];
    float _e90 = v3_[1u];
    float _e93 = v3_[2u];
    return metal::fract((_e88 + _e90) * _e93);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float h = {};
    float env = {};
    float f = {};
    float flash = {};
    float frame = {};
    float line = {};
    float jitter_1 = {};
    metal::float2 param_3 = {};
    float c0_ = {};
    bool fresh_1 = {};
    float dens = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float tear = {};
    int i = {};
    float k = {};
    float w_1 = {};
    metal::float2 param_8 = {};
    float speed = {};
    float cy = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float rowTear = {};
    metal::float2 param_14 = {};
    float dx = {};
    float strip = {};
    metal::float2 param_15 = {};
    metal::float2 q = {};
    metal::float4 c_3 = {};
    metal::float2 param_16 = {};
    bool param_17 = {};
    float len = {};
    metal::float4 avg = {};
    int i_1 = {};
    float u = {};
    metal::float2 param_18 = {};
    bool param_19 = {};
    metal::float3 chroma = {};
    metal::float3 param_20 = {};
    metal::float3 rgb = {};
    metal::float3 param_21 = {};
    metal::float3 param_22 = {};
    metal::float2 cell = {};
    float n = {};
    metal::float2 param_23 = {};
    float amount = {};
    float snow = {};
    float local_1 = {};
    metal::float2 param_24 = {};
    float g = {};
    metal::float2 param_25 = {};
    float local_2 = {};
    float dark = {};
    float group = {};
    float drop = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    float _e136 = uniforms.progress;
    h = metal::clamp(2.5 * (1.0 - metal::abs((2.0 * _e136) - 1.0)), 0.0, 1.0);
    float _e143 = h;
    float _e144 = h;
    float _e146 = h;
    env = (_e143 * _e144) * (3.0 - (2.0 * _e146));
    float _e151 = uniforms.progress;
    f = metal::clamp(1.0 - (metal::abs(_e151 - 0.5) / 0.04), 0.0, 1.0);
    float _e157 = f;
    float _e158 = f;
    float _e160 = f;
    flash = (_e157 * _e158) * (3.0 - (2.0 * _e160));
    float _e165 = uniforms.progress;
    frame = metal::floor(_e165 * 40.0);
    float _e169 = uv_2[1u];
    line = metal::floor(_e169 * 220.0);
    float _e172 = line;
    float _e173 = frame;
    param_3 = metal::float2(_e172, _e173 + 7.0);
    float _e176 = hash12(param_3);
    jitter_1 = _e176 - 0.5;
    float _e179 = uniforms.progress;
    c0_ = metal::mix(1.132, -0.132, _e179);
    float _e182 = uv_2[1u];
    float _e183 = c0_;
    float _e184 = jitter_1;
    fresh_1 = _e182 > (_e183 + (0.088 * _e184));
    float _e189 = uv_2[1u];
    param_4 = _e189;
    float _e190 = c0_;
    param_5 = _e190;
    param_6 = 0.11;
    float _e191 = jitter_1;
    param_7 = _e191;
    float _e192 = bandDensity(param_4, param_5, param_6, param_7);
    dens = _e192;
    float _e194 = uv_2[1u];
    float _e195 = c0_;
    tear = 1.0 - metal::smoothstep(0.0, 1.0, metal::abs(_e194 - _e195) / 0.275);
    i = 1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e256 = i;
            i = as_type<int>(as_type<uint>(_e256) + as_type<uint>(1));
        }
        loop_init = false;
        int _e201 = i;
        if (_e201 < 4) {
            int _e203 = i;
            int _e205 = uniforms.bands;
            if (_e203 < _e205) {
                int _e207 = i;
                k = static_cast<float>(_e207);
                float _e209 = k;
                param_8 = metal::float2(_e209, 3.0);
                float _e211 = hash12(param_8);
                w_1 = 0.11 * (0.35 + (0.2 * _e211));
                float _e215 = k;
                speed = 1.3 + (0.9 * _e215);
                float _e218 = w_1;
                float _e220 = w_1;
                float _e223 = k;
                param_9 = metal::float2(_e223, 5.0);
                float _e225 = hash12(param_9);
                float _e226 = speed;
                float _e228 = uniforms.progress;
                cy = -(_e218) + ((1.0 + (2.0 * _e220)) * metal::fract(_e225 - (_e226 * _e228)));
                float _e234 = dens;
                float _e236 = uv_2[1u];
                param_10 = _e236;
                float _e237 = cy;
                param_11 = _e237;
                float _e238 = w_1;
                param_12 = _e238;
                float _e239 = jitter_1;
                param_13 = _e239;
                float _e240 = bandDensity(param_10, param_11, param_12, param_13);
                dens = metal::max(_e234, 0.6 * _e240);
                float _e243 = tear;
                float _e245 = uv_2[1u];
                float _e246 = cy;
                float _e249 = w_1;
                tear = metal::max(_e243, 0.5 * (1.0 - metal::smoothstep(0.0, 1.0, metal::abs(_e245 - _e246) / (2.5 * _e249))));
            }
            continue;
        } else {
            break;
        }
    }
    float _e258 = env;
    float _e259 = dens;
    dens = _e259 * _e258;
    float _e261 = env;
    float _e262 = tear;
    tear = _e262 * _e261;
    float _e265 = uv_2[1u];
    float _e269 = frame;
    param_14 = metal::float2(metal::floor((_e265 * 220.0) * 0.5), _e269 + 31.0);
    float _e272 = hash12(param_14);
    rowTear = _e272 - 0.5;
    float _e275 = uniforms.wobble;
    float _e276 = env;
    float _e279 = uv_2[1u];
    float _e282 = uniforms.progress;
    float _e287 = jitter_1;
    dx = (_e275 * _e276) * ((0.006 * metal::sin((_e279 * 7.0) + (_e282 * 23.0))) + (0.004 * _e287));
    float _e292 = uniforms.noise;
    float _e295 = tear;
    float _e298 = rowTear;
    float _e300 = dx;
    dx = _e300 + ((((0.3 + (0.7 * _e292)) * _e295) * 0.18) * _e298);
    float _e302 = env;
    float _e304 = uv_2[1u];
    strip = _e302 * (1.0 - metal::smoothstep(0.0, 0.06, _e304));
    float _e308 = strip;
    float _e310 = uv_2[1u];
    float _e316 = frame;
    param_15 = metal::float2(_e316, 41.0);
    float _e318 = hash12(param_15);
    float _e322 = dx;
    dx = _e322 + ((_e308 * (0.03 + (0.06 * (1.0 - (_e310 / 0.06))))) * (0.6 + (0.8 * _e318)));
    float _e325 = uv_2[0u];
    float _e326 = dx;
    float _e329 = uv_2[1u];
    q = metal::float2(_e325 + _e326, _e329);
    metal::float2 _e331 = q;
    param_16 = _e331;
    bool _e332 = fresh_1;
    param_17 = _e332;
    metal::float4 _e333 = tape(param_16, param_17, _from, _sampler, _to);
    c_3 = _e333;
    float _e335 = c_3[3u];
    if (_e335 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    float _e338 = uniforms.bleed;
    float _e339 = dens;
    float _e343 = env;
    len = (_e338 * (0.02 + (0.05 * _e339))) * _e343;
    metal::float4 _e345 = c_3;
    avg = _e345;
    float _e346 = len;
    if (_e346 > 0.0) {
        avg = metal::float4(0.0, 0.0, 0.0, 0.0);
        i_1 = 0;
        uint2 loop_bound_1 = uint2(4294967295u);
        bool loop_init_1 = true;
        while(true) {
            if (metal::all(loop_bound_1 == uint2(0u))) { break; }
            loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
            if (!loop_init_1) {
                int _e365 = i_1;
                i_1 = as_type<int>(as_type<uint>(_e365) + as_type<uint>(1));
            }
            loop_init_1 = false;
            int _e348 = i_1;
            if (_e348 < 6) {
                int _e350 = i_1;
                u = (static_cast<float>(_e350) + 0.5) / 6.0;
                metal::float2 _e354 = q;
                float _e355 = len;
                float _e356 = u;
                param_18 = _e354 - metal::float2(_e355 * (0.4 + _e356), 0.0);
                bool _e361 = fresh_1;
                param_19 = _e361;
                metal::float4 _e362 = tape(param_18, param_19, _from, _sampler, _to);
                metal::float4 _e363 = avg;
                avg = _e363 + _e362;
                continue;
            } else {
                break;
            }
        }
        metal::float4 _e367 = avg;
        avg = _e367 / metal::float4(6.0);
    }
    metal::float4 _e370 = avg;
    metal::float4 _e372 = avg;
    param_20 = _e372.xyz;
    float _e374 = luma(param_20);
    float _e378 = avg[3u];
    chroma = (_e370.xyz - metal::float3(_e374)) / metal::float3(metal::max(_e378, 0.00001));
    metal::float4 _e382 = c_3;
    param_21 = _e382.xyz;
    float _e384 = luma(param_21);
    metal::float3 _e385 = chroma;
    float _e387 = c_3[3u];
    rgb = metal::float3(_e384) + (_e385 * _e387);
    metal::float3 _e391 = rgb;
    metal::float3 _e392 = rgb;
    param_22 = _e392;
    float _e393 = luma(param_22);
    float _e395 = dens;
    rgb = metal::mix(_e391, metal::float3(_e393), metal::float3(0.6 * _e395));
    float _e400 = uv_2[0u];
    float _e404 = uniforms.ratio;
    float _e406 = jitter_1;
    float _e410 = line;
    cell = metal::float2(metal::floor((((_e400 * 220.0) * 0.3) * _e404) + (40.0 * _e406)), _e410);
    metal::float2 _e412 = cell;
    float _e413 = frame;
    param_23 = _e412 + (metal::float2(37.0, 17.0) * _e413);
    float _e416 = hash12(param_23);
    n = _e416;
    float _e418 = uniforms.noise;
    float _e419 = dens;
    float _e421 = strip;
    float _e425 = flash;
    amount = metal::clamp((_e418 * metal::max(1.3 * _e419, 0.8 * _e421)) + (0.35 * _e425), 0.0, 1.0);
    float _e429 = amount;
    if (_e429 > 0.0) {
        float _e431 = amount;
        float _e433 = amount;
        float _e436 = n;
        local_1 = metal::smoothstep(1.0 - _e431, 1.0 - (0.6 * _e433), _e436);
    } else {
        local_1 = 0.0;
    }
    float _e438 = local_1;
    snow = _e438;
    metal::float2 _e439 = cell;
    float _e441 = frame;
    param_24 = _e439.yx + metal::float2(_e441);
    float _e444 = hash12(param_24);
    float _e447 = snow;
    snow = _e447 * (0.55 + (0.45 * _e444));
    float _e450 = uv_2[0u];
    float _e453 = uniforms.ratio;
    float _e456 = line;
    float _e458 = frame;
    param_25 = metal::float2(metal::floor((_e450 * 220.0) * _e453), _e456) + (metal::float2(13.0, 29.0) * _e458);
    float _e461 = hash12(param_25);
    g = _e461;
    float _e462 = snow;
    float _e463 = amount;
    if (_e463 > 0.0) {
        float _e465 = amount;
        float _e468 = g;
        local_2 = 0.7 * metal::smoothstep(1.0 - (0.4 * _e465), 1.0, _e468);
    } else {
        local_2 = 0.0;
    }
    float _e471 = local_2;
    snow = metal::max(_e462, _e471);
    float _e473 = g;
    float _e474 = amount;
    dark = (_e473 < (0.1 * _e474)) ? 1.0 : 0.0;
    float _e479 = uv_2[1u];
    group = metal::floor((_e479 * 220.0) / 3.0);
    float _e483 = flash;
    float _e486 = group;
    float _e488 = uv_2[0u];
    float _e490 = group;
    float _e491 = frame;
    param_26 = metal::float2(_e490, _e491);
    float _e493 = hash12(param_26);
    float _e497 = frame;
    param_27 = metal::float2(_e486, metal::floor((_e488 * 6.0) + (5.0 * _e493)) + (_e497 * 7.0));
    float _e501 = hash12(param_27);
    drop = metal::step(1.0 - (0.15 * _e483), _e501);
    float _e503 = dark;
    metal::float3 _e506 = rgb;
    rgb = _e506 * (1.0 - (0.5 * _e503));
    float _e508 = snow;
    float _e509 = drop;
    float _e511 = flash;
    float _e516 = c_3[3u];
    metal::float3 _e517 = rgb;
    metal::float3 _e521 = rgb;
    rgb = _e521 + ((metal::float3(_e516) - _e517) * metal::clamp((_e508 + _e509) + (0.12 * _e511), 0.0, 1.0));
    metal::float3 _e523 = rgb;
    float _e525 = c_3[3u];
    metal::float3 _e530 = metal::clamp(_e523 / metal::float3(_e525), metal::float3(0.0), metal::float3(1.0));
    float _e532 = c_3[3u];
    return metal::float4(_e530.x, _e530.y, _e530.z, _e532);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_28 = {};
    metal::float2 _e73 = _uv_1;
    param_28 = _e73;
    metal::float4 _e74 = transition(param_28, _from, _sampler, _to, uniforms);
    _fragColor = _e74;
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
