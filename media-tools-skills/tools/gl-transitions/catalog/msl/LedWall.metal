// LedWall — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LedWall.glsl
// Author: gre
// License: MIT
// Description: The picture zooms into a giant LED screen of round glowing diodes on a dark panel; a refresh wave sweeps across it, each diode flicking with a bright pop as it switches to the incoming image, then the diodes melt back into the plain picture
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float cells;
    float glow;
    float flash;
    float zoom;
    int triads;
    char _pad7[4];
    metal::float2 direction;
    char _pad8[8];
    metal::float4 panel;
};

float disc(
    thread float& d,
    thread float& r
) {
    float _e56 = r;
    float _e58 = r;
    float _e60 = d;
    return 1.0 - metal::smoothstep(_e56 - 0.05, _e58 + 0.05, _e60);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e56 = uv[0u];
    float _e58 = uv[1u];
    metal::float4 _e61 = _to.sample(_sampler, metal::float2(_e56, 1.0 - _e58), metal::level(0.0));
    return _e61;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e56 = uv_1[0u];
    float _e58 = uv_1[1u];
    metal::float4 _e61 = _from.sample(_sampler, metal::float2(_e56, 1.0 - _e58), metal::level(0.0));
    return _e61;
}

metal::float2 mirrored(
    thread metal::float2& v
) {
    metal::float2 m = {};
    metal::float2 _e56 = v;
    metal::float2 _e57 = metal::float2(2.0);
    m = _e56 - (metal::floor(_e56 / _e57) * _e57);
    metal::float2 _e62 = m;
    metal::float2 _e63 = m;
    metal::float2 _e66 = m;
    return metal::mix(_e62, metal::float2(2.0) - _e63, metal::step(metal::float2(1.0), _e66));
}

float hash12(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e56 = p;
    p3_ = metal::fract(_e56.xyx * 0.1031);
    metal::float3 _e60 = p3_;
    metal::float3 _e61 = p3_;
    metal::float3 _e66 = p3_;
    p3_ = _e66 + metal::float3(metal::dot(_e60, _e61.yzx + metal::float3(33.33)));
    float _e70 = p3_[0u];
    float _e72 = p3_[1u];
    float _e75 = p3_[2u];
    return metal::fract((_e70 + _e72) * _e75);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float led = {};
    float z = {};
    metal::float2 p_1 = {};
    metal::float2 aspect = {};
    metal::float2 toCells = {};
    metal::float2 q = {};
    metal::float2 id = {};
    metal::float2 local = {};
    metal::float2 side = {};
    metal::float2 dir = {};
    metal::float2 local_1 = {};
    float extent = {};
    metal::float4 own = {};
    float ownSwitch = {};
    metal::float4 halo = {};
    float haloWeight = {};
    int i = {};
    metal::float2 o = {};
    metal::float2 c = {};
    metal::float2 cuv = {};
    float s = {};
    float when = {};
    metal::float2 param = {};
    float sw = {};
    float x = {};
    float pop = {};
    metal::float2 suv = {};
    metal::float2 param_1 = {};
    metal::float4 col = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float d_1 = {};
    float w = {};
    metal::float4 plain = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float d_2 = {};
    float r_1 = {};
    metal::float4 gap = {};
    metal::float4 body = {};
    metal::float3 sub = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float m_1 = {};
    float k = {};
    float lit = {};
    metal::float4 color = {};
    float param_12 = {};
    float param_13 = {};
    bool phi_268_ = {};
    float _e109 = uniforms.progress;
    float _e112 = uniforms.progress;
    led = metal::smoothstep(0.0, 0.3, _e109) * (1.0 - metal::smoothstep(0.7, 1.0, _e112));
    float _e117 = uniforms.zoom;
    float _e120 = uniforms.progress;
    float _e124 = uniforms.progress;
    z = 1.0 + ((metal::max(_e117, 0.0) * metal::smoothstep(0.0, 0.45, _e120)) * (1.0 - metal::smoothstep(0.55, 1.0, _e124)));
    metal::float2 _e129 = uv_2;
    float _e132 = z;
    p_1 = metal::float2(0.5) + ((_e129 - metal::float2(0.5)) / metal::float2(_e132));
    float _e138 = uniforms.ratio;
    aspect = metal::float2(_e138, 1.0);
    metal::float2 _e140 = aspect;
    float _e142 = uniforms.cells;
    float _e146 = uniforms.ratio;
    toCells = (_e140 * metal::max(_e142, 1.0)) / metal::float2(metal::min(_e146, 1.0));
    metal::float2 _e150 = p_1;
    metal::float2 _e153 = toCells;
    q = (_e150 - metal::float2(0.5)) * _e153;
    metal::float2 _e155 = q;
    id = metal::floor(_e155 + metal::float2(0.5));
    metal::float2 _e159 = q;
    metal::float2 _e160 = id;
    local = _e159 - _e160;
    float _e163 = local[0u];
    float _e167 = local[1u];
    side = metal::float2((_e163 < 0.0) ? -1.0 : 1.0, (_e167 < 0.0) ? -1.0 : 1.0);
    metal::float2 _e172 = uniforms.direction;
    if (metal::length(_e172) > 0.0001) {
        metal::float2 _e176 = uniforms.direction;
        local_1 = metal::normalize(_e176);
    } else {
        local_1 = metal::float2(1.0, 0.0);
    }
    metal::float2 _e178 = local_1;
    dir = _e178;
    float _e180 = dir[0u];
    float _e183 = uniforms.ratio;
    float _e186 = dir[1u];
    extent = (metal::abs(_e180) * _e183) + metal::abs(_e186);
    own = metal::float4(0.0, 0.0, 0.0, 0.0);
    ownSwitch = 0.0;
    halo = metal::float4(0.0, 0.0, 0.0, 0.0);
    haloWeight = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e353 = i;
            i = as_type<int>(as_type<uint>(_e353) + as_type<uint>(1));
        }
        loop_init = false;
        int _e189 = i;
        if (_e189 < 4) {
            int _e191 = i;
            bool _e192 = _e191 > 0;
            phi_268_ = _e192;
            if (_e192) {
                float _e194 = uniforms.glow;
                float _e195 = led;
                phi_268_ = (_e194 * _e195) <= 0.0;
            }
            bool _e199 = phi_268_;
            if (_e199) {
                break;
            }
            int _e200 = i;
            float _e201 = static_cast<float>(_e200);
            int _e206 = i;
            metal::float2 _e211 = side;
            o = metal::float2(_e201 - (metal::floor(_e201 / 2.0) * 2.0), metal::floor(static_cast<float>(_e206) / 2.0)) * _e211;
            metal::float2 _e213 = id;
            metal::float2 _e214 = o;
            c = _e213 + _e214;
            metal::float2 _e216 = c;
            metal::float2 _e217 = toCells;
            cuv = (_e216 / _e217) + metal::float2(0.5);
            metal::float2 _e221 = cuv;
            float _e224 = z;
            metal::float2 _e226 = aspect;
            metal::float2 _e228 = dir;
            float _e230 = extent;
            s = metal::clamp((metal::dot(((_e221 - metal::float2(0.5)) * _e224) * _e226, _e228) / _e230) + 0.5, 0.0, 1.0);
            float _e234 = s;
            metal::float2 _e237 = c;
            param = _e237 + metal::float2(71.0);
            float _e240 = hash12(param);
            when = (0.2 + (0.52 * _e234)) + (0.05 * (_e240 - 0.5));
            float _e244 = when;
            float _e246 = when;
            float _e249 = uniforms.progress;
            sw = metal::smoothstep(_e244 - 0.012, _e246 + 0.012, _e249);
            float _e252 = uniforms.progress;
            float _e253 = when;
            x = (_e252 - _e253) / 0.018;
            float _e256 = x;
            float _e258 = x;
            float _e261 = x;
            float _e264 = x;
            pop = metal::exp(-(_e256) * _e258) - (0.5 * metal::exp(-((_e261 + 1.6)) * (_e264 + 1.6)));
            metal::float2 _e270 = cuv;
            param_1 = _e270;
            metal::float2 _e271 = mirrored(param_1);
            suv = _e271;
            metal::float2 _e272 = suv;
            param_2 = _e272;
            metal::float4 _e273 = getFromColor(param_2, _from, _sampler);
            metal::float2 _e274 = suv;
            param_3 = _e274;
            metal::float4 _e275 = getToColor(param_3, _sampler, _to);
            float _e276 = sw;
            col = metal::mix(_e273, _e275, metal::float4(_e276));
            metal::float4 _e279 = col;
            float _e282 = uniforms.flash;
            float _e284 = pop;
            float _e289 = uniforms.flash;
            float _e291 = pop;
            metal::float3 _e295 = (_e279.xyz * (1.0 + ((1.4 * _e282) * _e284))) + metal::float3((0.2 * _e289) * metal::max(_e291, 0.0));
            col[0u] = _e295.x;
            col[1u] = _e295.y;
            col[2u] = _e295.z;
            int _e302 = i;
            if (_e302 == 0) {
                metal::float4 _e304 = col;
                own = _e304;
                float _e305 = sw;
                ownSwitch = _e305;
            }
            metal::float2 _e306 = local;
            metal::float2 _e307 = o;
            d_1 = metal::length(_e306 - _e307);
            float _e311 = uniforms.glow;
            float _e313 = d_1;
            float _e320 = uniforms.flash;
            float _e322 = pop;
            w = ((0.9 * _e311) * metal::exp(-6.0 * metal::max(_e313 - 0.36, 0.0))) * (1.0 + ((0.8 * _e320) * metal::max(_e322, 0.0)));
            float _e328 = o[0u];
            if (_e328 != 0.0) {
                float _e331 = local[0u];
                float _e334 = w;
                w = _e334 * metal::smoothstep(0.0, 0.2, metal::abs(_e331));
            }
            float _e337 = o[1u];
            if (_e337 != 0.0) {
                float _e340 = local[1u];
                float _e343 = w;
                w = _e343 * metal::smoothstep(0.0, 0.2, metal::abs(_e340));
            }
            float _e345 = w;
            metal::float4 _e346 = col;
            metal::float4 _e348 = halo;
            halo = _e348 + (_e346 * _e345);
            float _e350 = w;
            float _e351 = haloWeight;
            haloWeight = _e351 + _e350;
            continue;
        } else {
            break;
        }
    }
    metal::float2 _e355 = p_1;
    param_4 = _e355;
    metal::float4 _e356 = getFromColor(param_4, _from, _sampler);
    metal::float2 _e357 = p_1;
    param_5 = _e357;
    metal::float4 _e358 = getToColor(param_5, _sampler, _to);
    float _e359 = ownSwitch;
    plain = metal::mix(_e356, _e358, metal::float4(_e359));
    metal::float2 _e362 = local;
    d_2 = metal::length(_e362);
    float _e364 = led;
    r_1 = metal::mix(0.8, 0.36, metal::smoothstep(0.0, 0.6, _e364));
    metal::float4 _e368 = uniforms.panel;
    metal::float3 _e369 = _e368.xyz;
    float _e372 = uniforms.panel[3u];
    float _e374 = own[3u];
    gap = metal::float4(_e369.x, _e369.y, _e369.z, _e372 * _e374);
    float _e380 = haloWeight;
    if (_e380 > 0.0) {
        metal::float4 _e382 = gap;
        metal::float4 _e383 = halo;
        float _e384 = haloWeight;
        float _e387 = haloWeight;
        float _e388 = led;
        gap = metal::mix(_e382, _e383 / metal::float4(_e384), metal::float4(metal::clamp(_e387 * _e388, 0.0, 1.0)));
    }
    metal::float4 _e393 = own;
    body = _e393;
    int _e395 = uniforms.triads;
    if (_e395 != 0) {
        metal::float2 _e397 = local;
        param_6 = metal::length(_e397 - metal::float2(0.0, 0.15));
        param_7 = 0.2;
        float _e400 = disc(param_6, param_7);
        metal::float2 _e401 = local;
        param_8 = metal::length(_e401 - metal::float2(-0.13, -0.075));
        param_9 = 0.2;
        float _e404 = disc(param_8, param_9);
        metal::float2 _e405 = local;
        param_10 = metal::length(_e405 - metal::float2(0.13, -0.075));
        param_11 = 0.2;
        float _e408 = disc(param_10, param_11);
        sub = metal::float3(_e400, _e404, _e408);
        float _e411 = sub[0u];
        float _e413 = sub[1u];
        float _e415 = sub[2u];
        m_1 = metal::max(_e411, metal::max(_e413, _e415));
        metal::float4 _e418 = gap;
        float _e420 = m_1;
        metal::float4 _e423 = own;
        metal::float3 _e426 = sub;
        metal::float3 _e428 = (_e418.xyz * (1.0 - _e420)) + ((_e423.xyz * 1.5) * _e426);
        float _e430 = gap[3u];
        float _e432 = own[3u];
        float _e433 = m_1;
        body = metal::float4(_e428.x, _e428.y, _e428.z, metal::mix(_e430, _e432, _e433));
        float _e439 = r_1;
        r_1 = metal::max(_e439, 0.45);
    } else {
        float _e441 = d_2;
        k = metal::clamp(_e441 / 0.36, 0.0, 1.0);
        float _e444 = k;
        float _e445 = k;
        metal::float4 _e450 = body;
        metal::float3 _e452 = _e450.xyz * (0.8 + (0.45 * (1.0 - (_e444 * _e445))));
        body[0u] = _e452.x;
        body[1u] = _e452.y;
        body[2u] = _e452.z;
    }
    float _e459 = led;
    lit = metal::smoothstep(0.0, 0.8, _e459);
    metal::float4 _e461 = plain;
    metal::float4 _e462 = body;
    float _e463 = lit;
    float _e464 = lit;
    float _e465 = d_2;
    body = metal::mix(_e461, _e462, metal::float4(_e463 * metal::mix(1.0, _e464, metal::smoothstep(0.0, 0.7, _e465))));
    metal::float4 _e471 = gap;
    metal::float4 _e472 = body;
    float _e473 = d_2;
    param_12 = _e473;
    float _e474 = r_1;
    param_13 = _e474;
    float _e475 = disc(param_12, param_13);
    color = metal::mix(_e471, _e472, metal::float4(_e475));
    metal::float4 _e478 = color;
    return metal::clamp(_e478, metal::float4(0.0), metal::float4(1.0));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_14 = {};
    metal::float2 _e55 = _uv_1;
    param_14 = _e55;
    metal::float4 _e56 = transition(param_14, _from, _sampler, _to, uniforms);
    _fragColor = _e56;
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
