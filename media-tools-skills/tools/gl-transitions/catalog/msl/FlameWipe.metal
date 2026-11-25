// FlameWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FlameWipe.glsl
// Author: gre
// License: MIT
// Description: A wall of flames sweeps across the frame, scorching the outgoing image ahead of it and leaving the incoming image under a fading warm glow
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float height;
    float scorch;
    float glow;
    char _pad6[4];
    metal::float3 color;
};

metal::float3 fire(
    thread float& h,
    constant Uniforms& uniforms
) {
    metal::float3 c = {};
    metal::float3 _e96 = uniforms.color;
    metal::float3 _e98 = uniforms.color;
    float _e101 = h;
    c = metal::mix(metal::float3(0.22, 0.01, 0.0), (_e96 * _e98) * metal::float3(1.0, 0.6, 0.4), metal::float3(metal::smoothstep(0.0, 0.3, _e101)));
    metal::float3 _e105 = c;
    metal::float3 _e107 = uniforms.color;
    float _e108 = h;
    c = metal::mix(_e105, _e107, metal::float3(metal::smoothstep(0.25, 0.55, _e108)));
    metal::float3 _e112 = c;
    float _e113 = h;
    c = metal::mix(_e112, metal::float3(1.0, 0.8, 0.35), metal::float3(metal::smoothstep(0.55, 0.8, _e113)));
    metal::float3 _e117 = c;
    float _e118 = h;
    return metal::mix(_e117, metal::float3(1.0, 0.96, 0.82), metal::float3(metal::smoothstep(0.8, 1.0, _e118)));
}

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e95 = v;
    v3_ = metal::fract(_e95.xyx * 0.1031);
    metal::float3 _e99 = v3_;
    metal::float3 _e100 = v3_;
    metal::float3 _e105 = v3_;
    v3_ = _e105 + metal::float3(metal::dot(_e99, _e100.yzx + metal::float3(33.33)));
    float _e109 = v3_[0u];
    float _e111 = v3_[1u];
    float _e114 = v3_[2u];
    return metal::fract((_e109 + _e111) * _e114);
}

float noise(
    thread metal::float2& v_1
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e100 = v_1;
    i = metal::floor(_e100);
    metal::float2 _e102 = v_1;
    metal::float2 _e103 = i;
    f = _e102 - _e103;
    metal::float2 _e105 = f;
    metal::float2 _e106 = f;
    metal::float2 _e108 = f;
    f = (_e105 * _e106) * (metal::float2(3.0) - (_e108 * 2.0));
    metal::float2 _e113 = i;
    param = _e113;
    float _e114 = hash12(param);
    metal::float2 _e115 = i;
    param_1 = _e115 + metal::float2(1.0, 0.0);
    float _e117 = hash12(param_1);
    float _e119 = f[0u];
    metal::float2 _e121 = i;
    param_2 = _e121 + metal::float2(0.0, 1.0);
    float _e123 = hash12(param_2);
    metal::float2 _e124 = i;
    param_3 = _e124 + metal::float2(1.0, 1.0);
    float _e126 = hash12(param_3);
    float _e128 = f[0u];
    float _e131 = f[1u];
    return metal::mix(metal::mix(_e114, _e117, _e119), metal::mix(_e123, _e126, _e128), _e131);
}

float fbm(
    thread metal::float2& v_2
) {
    float sum = {};
    float amp = {};
    int i_1 = {};
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
            int _e111 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e111) + as_type<uint>(1));
        }
        loop_init = false;
        int _e98 = i_1;
        if (_e98 < 4) {
            float _e100 = amp;
            metal::float2 _e101 = v_2;
            param_4 = _e101;
            float _e102 = noise(param_4);
            float _e104 = sum;
            sum = _e104 + (_e100 * _e102);
            metal::float2 _e106 = v_2;
            v_2 = (_e106 * 2.03) + metal::float2(17.3, 9.1);
            float _e109 = amp;
            amp = _e109 * 0.5;
            continue;
        } else {
            break;
        }
    }
    float _e113 = sum;
    return _e113 / 0.9375;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e95 = uv[0u];
    float _e97 = uv[1u];
    metal::float4 _e100 = _to.sample(_sampler, metal::float2(_e95, 1.0 - _e97), metal::level(0.0));
    return _e100;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e95 = uv_1[0u];
    float _e97 = uv_1[1u];
    metal::float4 _e100 = _from.sample(_sampler, metal::float2(_e95, 1.0 - _e97), metal::level(0.0));
    return _e100;
}

metal::float2 mirror(
    thread metal::float2& v_3
) {
    metal::float2 _e94 = v_3;
    metal::float2 _e95 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e94 - (metal::floor(_e94 / _e95) * _e95)));
}

float climbing(
    thread float& s,
    thread float& size
) {
    float _e95 = size;
    float _e99 = s;
    float _e101 = s;
    float _e104 = s;
    return ((((0.42 + (0.56 * _e95)) * 6.75) * _e99) * (1.0 - _e101)) * (1.0 - _e104);
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
    float rise = {};
    float w = {};
    float reach = {};
    float extent = {};
    float e = {};
    float burn = {};
    float scorchAmount = {};
    float glowAmount = {};
    float t = {};
    float side = {};
    float front = {};
    metal::float2 param_5 = {};
    float k = {};
    float billow = {};
    metal::float2 param_6 = {};
    float y = {};
    float y2_ = {};
    float climb = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float param_9 = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float lineWidth = {};
    float line = {};
    float tongue = {};
    float s_1 = {};
    float heat = {};
    float near = {};
    metal::float2 h_1 = {};
    metal::float2 shimmer = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float4 a = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float4 b = {};
    metal::float2 param_17 = {};
    float brown = {};
    float local_1 = {};
    float lum = {};
    float g = {};
    float local_2 = {};
    float m = {};
    metal::float4 c_1 = {};
    metal::float3 col = {};
    metal::float2 f_1 = {};
    float sway = {};
    metal::float2 param_18 = {};
    float n = {};
    metal::float2 param_19 = {};
    float core = {};
    float root = {};
    float local_3 = {};
    float local_4 = {};
    float flame = {};
    float body = {};
    float param_20 = {};
    metal::float2 _e157 = uniforms.direction;
    if (metal::length(_e157) > 0.00001) {
        metal::float2 _e161 = uniforms.direction;
        local = metal::normalize(_e161);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e163 = local;
    dir = _e163;
    metal::float2 _e164 = uv_2;
    float _e168 = uniforms.ratio;
    q = (_e164 - metal::float2(0.5)) * metal::float2(_e168, 1.0);
    float _e172 = uniforms.height;
    float _e174 = dir[1u];
    rise = _e172 * _e174;
    float _e177 = uniforms.height;
    w = 0.05 + (0.35 * _e177);
    float _e180 = w;
    float _e182 = dir[0u];
    reach = _e180 * (1.75 + (0.6 * metal::abs(_e182)));
    float _e188 = dir[0u];
    float _e191 = uniforms.ratio;
    float _e194 = dir[1u];
    extent = (0.5 * ((metal::abs(_e188) * _e191) + metal::abs(_e194))) + 0.3;
    float _e200 = uniforms.progress;
    float _e202 = uniforms.progress;
    float _e204 = uniforms.progress;
    float _e207 = uniforms.progress;
    e = metal::mix(_e200, (_e202 * _e204) * (3.0 - (2.0 * _e207)), 0.3);
    float _e213 = uniforms.progress;
    float _e216 = uniforms.progress;
    burn = metal::smoothstep(0.0, 0.12, _e213) * (1.0 - metal::smoothstep(0.88, 1.0, _e216));
    float _e221 = uniforms.scorch;
    float _e223 = uniforms.progress;
    scorchAmount = _e221 * metal::smoothstep(0.0, 0.2, _e223);
    float _e227 = uniforms.glow;
    float _e229 = uniforms.progress;
    glowAmount = _e227 * (1.0 - metal::smoothstep(0.75, 1.0, _e229));
    float _e234 = uniforms.progress;
    t = _e234 * 5.0;
    metal::float2 _e236 = q;
    float _e238 = dir[1u];
    float _e241 = dir[0u];
    side = metal::dot(_e236, metal::float2(-(_e238), _e241));
    float _e244 = extent;
    float _e246 = extent;
    float _e247 = e;
    float _e249 = side;
    float _e251 = t;
    param_5 = metal::float2(_e249 * 4.0, _e251 * 0.4);
    float _e254 = noise(param_5);
    front = metal::mix(-(_e244), _e246, _e247) + (0.05 * ((2.0 * _e254) - 1.0));
    metal::float2 _e259 = q;
    metal::float2 _e260 = dir;
    float _e262 = front;
    k = metal::dot(_e259, _e260) - _e262;
    float _e265 = q[0u];
    float _e269 = q[1u];
    float _e271 = t;
    param_6 = metal::float2((_e265 * 3.0) + 5.0, (_e269 * 2.5) - (_e271 * 1.6));
    float _e275 = noise(param_6);
    billow = _e275;
    float _e277 = q[1u];
    float _e279 = t;
    y = (_e277 * 3.0) - (_e279 * 1.4);
    float _e282 = y;
    y2_ = _e282 + 0.5;
    float _e284 = y;
    float _e286 = y;
    param_7 = metal::float2(metal::floor(_e286), 3.0);
    float _e289 = hash12(param_7);
    param_8 = metal::fract(_e284);
    param_9 = _e289;
    float _e290 = climbing(param_8, param_9);
    float _e291 = y2_;
    float _e293 = y2_;
    param_10 = metal::float2(metal::floor(_e293), 7.0);
    float _e296 = hash12(param_10);
    param_11 = metal::fract(_e291);
    param_12 = _e296;
    float _e297 = climbing(param_11, param_12);
    climb = metal::max(_e290, _e297);
    float _e299 = billow;
    float _e300 = billow;
    float _e302 = climb;
    float _e305 = dir[0u];
    billow = metal::mix(_e299, (0.4 * _e300) + _e302, metal::abs(_e305));
    float _e308 = w;
    float _e309 = billow;
    lineWidth = _e308 * (0.25 + (1.5 * _e309));
    float _e313 = lineWidth;
    float _e314 = k;
    line = 1.0 - metal::smoothstep(0.0, _e313, metal::abs(_e314));
    tongue = 0.0;
    float _e318 = rise;
    if (metal::abs(_e318) > 0.0001) {
        float _e321 = k;
        float _e322 = rise;
        s_1 = _e321 / _e322;
        float _e324 = s_1;
        if (_e324 >= 0.0) {
            float _e326 = s_1;
            tongue = metal::clamp(1.0 - _e326, 0.0, 1.0);
        }
    }
    float _e329 = line;
    float _e330 = tongue;
    float _e332 = burn;
    heat = metal::max(_e329, _e330) * _e332;
    float _e334 = k;
    near = 1.0 - metal::smoothstep(0.0, 0.45, metal::abs(_e334));
    metal::float2 _e338 = q;
    float _e340 = t;
    h_1 = (_e338 * metal::float2(9.0, 5.0)) + metal::float2(0.0, -(_e340) * 3.0);
    metal::float2 _e345 = h_1;
    param_13 = _e345;
    float _e346 = noise(param_13);
    metal::float2 _e347 = h_1;
    param_14 = _e347 + metal::float2(31.7);
    float _e350 = noise(param_14);
    float _e355 = near;
    float _e356 = heat;
    float _e360 = burn;
    shimmer = (((metal::float2(_e346, _e350) - metal::float2(0.5)) * 0.012) * metal::min(_e355 + _e356, 1.0)) * _e360;
    metal::float2 _e362 = uv_2;
    metal::float2 _e363 = shimmer;
    param_15 = _e362 + _e363;
    metal::float2 _e365 = mirror(param_15);
    param_16 = _e365;
    metal::float4 _e366 = getFromColor(param_16, _from, _sampler);
    a = _e366;
    metal::float2 _e367 = uv_2;
    param_17 = _e367;
    metal::float4 _e368 = getToColor(param_17, _sampler, _to);
    b = _e368;
    float _e369 = k;
    if (_e369 > 0.0) {
        float _e371 = scorchAmount;
        float _e372 = near;
        local_1 = _e371 * _e372;
    } else {
        local_1 = 0.0;
    }
    float _e374 = local_1;
    brown = _e374;
    metal::float4 _e375 = a;
    lum = metal::dot(_e375.xyz, metal::float3(0.299, 0.587, 0.114));
    metal::float4 _e378 = a;
    float _e380 = lum;
    float _e382 = brown;
    float _e385 = brown;
    float _e389 = brown;
    float _e391 = near;
    float _e393 = near;
    metal::float3 _e396 = (metal::mix(_e378.xyz, metal::float3(0.9, 0.55, 0.28) * _e380, metal::float3(_e382)) * (1.0 - (0.35 * _e385))) * (1.0 - (((0.9 * _e389) * _e391) * _e393));
    a[0u] = _e396.x;
    a[1u] = _e396.y;
    a[2u] = _e396.z;
    float _e403 = k;
    if (_e403 < 0.0) {
        float _e405 = glowAmount;
        float _e406 = near;
        local_2 = _e405 * _e406;
    } else {
        local_2 = 0.0;
    }
    float _e408 = local_2;
    g = _e408;
    metal::float4 _e409 = b;
    float _e411 = g;
    metal::float3 _e417 = uniforms.color;
    float _e419 = g;
    float _e421 = g;
    metal::float3 _e423 = (_e409.xyz * metal::mix(metal::float3(1.0, 1.0, 1.0), metal::float3(1.0, 0.6, 0.35), metal::float3(0.7 * _e411))) + (((_e417 * 0.4) * _e419) * _e421);
    b[0u] = _e423.x;
    b[1u] = _e423.y;
    b[2u] = _e423.z;
    float _e430 = k;
    float _e431 = rise;
    float _e432 = reach;
    if (_e430 >= metal::max(0.45, metal::max(_e431, _e432))) {
        float _e437 = a[3u];
        metal::float4 _e439 = a;
        return metal::select(metal::float4(0.0, 0.0, 0.0, 0.0), _e439, metal::bool4(_e437 > 0.0));
    }
    float _e442 = k;
    float _e444 = rise;
    float _e446 = reach;
    if (-(_e442) >= metal::max(0.45, metal::max(-(_e444), _e446))) {
        float _e451 = b[3u];
        metal::float4 _e453 = b;
        return metal::select(metal::float4(0.0, 0.0, 0.0, 0.0), _e453, metal::bool4(_e451 > 0.0));
    }
    float _e456 = w;
    float _e458 = w;
    float _e460 = k;
    m = metal::smoothstep(-0.5 * _e456, 0.5 * _e458, _e460);
    metal::float4 _e462 = b;
    float _e465 = b[3u];
    metal::float3 _e466 = _e462.xyz * _e465;
    float _e468 = b[3u];
    metal::float4 _e473 = a;
    float _e476 = a[3u];
    metal::float3 _e477 = _e473.xyz * _e476;
    float _e479 = a[3u];
    float _e484 = m;
    c_1 = metal::mix(metal::float4(_e466.x, _e466.y, _e466.z, _e468), metal::float4(_e477.x, _e477.y, _e477.z, _e479), metal::float4(_e484));
    float _e488 = c_1[3u];
    if (_e488 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e490 = c_1;
    float _e493 = c_1[3u];
    col = _e490.xyz / metal::float3(_e493);
    float _e497 = q[0u];
    float _e499 = dir[0u];
    float _e504 = q[1u];
    float _e506 = dir[0u];
    float _e510 = t;
    f_1 = metal::float2(_e497 * metal::mix(10.0, 6.0, metal::abs(_e499)), (_e504 * metal::mix(1.8, 3.2, metal::abs(_e506))) - (_e510 * 2.4));
    float _e515 = q[0u];
    float _e518 = q[1u];
    float _e520 = t;
    param_18 = metal::float2(_e515 * 2.5, (_e518 * 1.5) - (_e520 * 1.2));
    float _e524 = fbm(param_18);
    sway = _e524;
    metal::float2 _e525 = f_1;
    float _e526 = sway;
    param_19 = _e525 + metal::float2((1.5 * _e526) - 0.75, 0.0);
    float _e531 = fbm(param_19);
    n = _e531;
    float _e532 = n;
    n = metal::clamp((1.7 * _e532) - 0.35, 0.0, 1.0);
    float _e536 = lineWidth;
    float _e538 = k;
    float _e539 = w;
    float _e541 = sway;
    float _e548 = burn;
    float _e551 = dir[0u];
    core = ((1.0 - metal::smoothstep(0.0, 0.35 * _e536, metal::abs(_e538 + ((0.4 * _e539) * (_e541 - 0.5))))) * _e548) * (1.0 - (0.5 * metal::abs(_e551)));
    float _e556 = rise;
    if (_e556 > 0.0) {
        float _e558 = k;
        float _e560 = w;
        local_3 = metal::clamp(-(_e558) / _e560, 0.0, 1.0);
    } else {
        float _e563 = rise;
        if (_e563 < 0.0) {
            float _e565 = k;
            float _e566 = w;
            local_4 = metal::clamp(_e565 / _e566, 0.0, 1.0);
        } else {
            local_4 = 0.0;
        }
        float _e569 = local_4;
        local_3 = _e569;
    }
    float _e570 = local_3;
    root = _e570;
    float _e572 = dir[1u];
    float _e574 = root;
    root = _e574 * metal::abs(_e572);
    float _e576 = heat;
    float _e578 = core;
    float _e580 = n;
    float _e585 = n;
    float _e588 = root;
    flame = metal::clamp(((_e576 * 0.95) + ((0.45 * _e578) * (0.75 + (0.25 * _e580)))) - (((1.0 - _e585) * 1.1) * (1.0 - (0.8 * _e588))), 0.0, 1.0);
    float _e594 = root;
    float _e597 = flame;
    body = metal::smoothstep(0.0, 0.08 + (0.5 * _e594), _e597);
    metal::float3 _e599 = col;
    float _e600 = body;
    float _e604 = flame;
    param_20 = _e604;
    metal::float3 _e605 = fire(param_20, uniforms);
    float _e606 = flame;
    float _e610 = body;
    col = (_e599 * (1.0 - (0.7 * _e600))) + ((_e605 * (0.45 + (0.65 * _e606))) * _e610);
    metal::float3 _e614 = uniforms.color;
    float _e616 = heat;
    float _e618 = heat;
    float _e620 = body;
    metal::float3 _e623 = col;
    col = _e623 + ((((_e614 * 0.25) * _e616) * _e618) * (1.0 - _e620));
    metal::float3 _e625 = col;
    metal::float3 _e628 = metal::clamp(_e625, metal::float3(0.0), metal::float3(1.0));
    float _e630 = c_1[3u];
    return metal::float4(_e628.x, _e628.y, _e628.z, _e630);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_21 = {};
    metal::float2 _e94 = _uv_1;
    param_21 = _e94;
    metal::float4 _e95 = transition(param_21, _from, _sampler, _to, uniforms);
    _fragColor = _e95;
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
