// LiquidFill — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LiquidFill.glsl
// Author: gre
// License: MIT
// Description: The incoming image rises over the outgoing one like liquid filling a glass, its surface sloshing in waves, lit by a bright meniscus line, bending the image just below it, with a few bubbles rising through it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float amplitude;
    float waves;
    char _pad5[8];
    metal::float4 highlight;
    float refraction;
    float bubbles;
    char _pad8[8];
};

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e68 = p;
    p3_ = metal::fract(_e68.xyx * 0.1031);
    metal::float3 _e72 = p3_;
    metal::float3 _e73 = p3_;
    metal::float3 _e78 = p3_;
    p3_ = _e78 + metal::float3(metal::dot(_e72, _e73.yzx + metal::float3(33.33)));
    float _e82 = p3_[0u];
    float _e84 = p3_[1u];
    float _e87 = p3_[2u];
    return metal::fract((_e82 + _e84) * _e87);
}

float surface(
    thread float& x,
    thread float& t,
    constant Uniforms& uniforms
) {
    float k = {};
    float _e70 = uniforms.waves;
    k = 3.1415927 * metal::max(_e70, 0.01);
    float _e73 = k;
    float _e74 = x;
    float _e79 = t;
    float _e83 = k;
    float _e85 = x;
    float _e87 = t;
    return ((0.6 * metal::sin((_e73 * _e74) + 1.5707964)) * metal::cos(8.168141 * _e79)) + (0.4 * metal::sin((((1.7 * _e83) * _e85) - (9.0 * _e87)) + 1.3));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e68 = uv[0u];
    float _e70 = uv[1u];
    metal::float4 _e73 = _to.sample(_sampler, metal::float2(_e68, 1.0 - _e70), metal::level(0.0));
    return _e73;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e68 = uv_1[0u];
    float _e70 = uv_1[1u];
    metal::float4 _e73 = _from.sample(_sampler, metal::float2(_e68, 1.0 - _e70), metal::level(0.0));
    return _e73;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 across = {};
    metal::float2 p_1 = {};
    float e = {};
    float w = {};
    float d = {};
    float x_1 = {};
    float t_1 = {};
    float stir = {};
    float amp = {};
    float margin = {};
    float mean = {};
    float level = {};
    float param_2 = {};
    float param_3 = {};
    float depth = {};
    float m = {};
    float bend = {};
    metal::float2 offset = {};
    metal::float4 b = {};
    metal::float2 param_4 = {};
    float glow = {};
    float rise = {};
    metal::float2 bq = {};
    metal::float2 cell = {};
    float hs = {};
    metal::float2 param_5 = {};
    float r = {};
    metal::float2 param_6 = {};
    float px = {};
    metal::float2 c = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float dist = {};
    float rim = {};
    float glint = {};
    float line = {};
    float light = {};
    metal::float4 c_1 = {};
    metal::float4 local_1 = {};
    metal::float2 _e111 = uv_2;
    param = _e111;
    metal::float4 _e112 = getFromColor(param, _from, _sampler);
    a = _e112;
    float _e114 = uniforms.progress;
    if (_e114 <= 0.0) {
        metal::float4 _e116 = a;
        return _e116;
    }
    float _e118 = uniforms.progress;
    if (_e118 >= 1.0) {
        metal::float2 _e120 = uv_2;
        param_1 = _e120;
        metal::float4 _e121 = getToColor(param_1, _sampler, _to);
        return _e121;
    }
    metal::float2 _e123 = uniforms.direction;
    if (metal::length(_e123) > 0.0) {
        metal::float2 _e127 = uniforms.direction;
        local = metal::normalize(_e127);
    } else {
        local = metal::float2(0.0, 1.0);
    }
    metal::float2 _e129 = local;
    dir = _e129;
    float _e131 = dir[1u];
    float _e134 = dir[0u];
    across = metal::float2(-(_e131), _e134);
    metal::float2 _e136 = uv_2;
    float _e140 = uniforms.ratio;
    p_1 = (_e136 - metal::float2(0.5)) * metal::float2(_e140, 1.0);
    float _e144 = dir[0u];
    float _e147 = uniforms.ratio;
    float _e150 = dir[1u];
    e = 0.5 * ((metal::abs(_e144) * _e147) + metal::abs(_e150));
    float _e155 = dir[1u];
    float _e158 = uniforms.ratio;
    float _e161 = dir[0u];
    w = 0.5 * ((metal::abs(_e155) * _e158) + metal::abs(_e161));
    metal::float2 _e165 = p_1;
    metal::float2 _e166 = dir;
    d = metal::dot(_e165, _e166);
    metal::float2 _e168 = p_1;
    metal::float2 _e169 = across;
    x_1 = metal::dot(_e168, _e169);
    float _e172 = uniforms.progress;
    t_1 = _e172;
    float _e173 = t_1;
    stir = metal::sin(3.1415927 * _e173);
    float _e177 = uniforms.amplitude;
    float _e179 = stir;
    amp = metal::max(_e177, 0.0) * (0.35 + (0.65 * _e179));
    float _e184 = uniforms.amplitude;
    margin = (metal::max(_e184, 0.0) + 0.012) + 0.0015;
    float _e188 = e;
    float _e190 = margin;
    float _e192 = e;
    float _e193 = margin;
    float _e195 = t_1;
    float _e196 = t_1;
    float _e197 = t_1;
    float _e199 = t_1;
    mean = metal::mix(-(_e188) - _e190, _e192 + _e193, metal::mix(_e195, (_e196 * _e197) * (3.0 - (2.0 * _e199)), 0.5));
    float _e205 = mean;
    float _e206 = amp;
    float _e207 = x_1;
    float _e208 = w;
    param_2 = _e207 / _e208;
    float _e210 = t_1;
    param_3 = _e210;
    float _e211 = surface(param_2, param_3, uniforms);
    level = _e205 + (_e206 * _e211);
    float _e214 = level;
    float _e215 = d;
    depth = _e214 - _e215;
    float _e217 = depth;
    m = metal::smoothstep(-0.0015, 0.0015, _e217);
    float _e220 = uniforms.refraction;
    float _e221 = stir;
    float _e223 = depth;
    bend = (_e220 * _e221) * metal::exp(-(metal::max(_e223, 0.0)) / 0.06);
    float _e229 = bend;
    metal::float2 _e230 = dir;
    float _e231 = x_1;
    float _e233 = t_1;
    metal::float2 _e238 = across;
    float _e239 = x_1;
    float _e241 = t_1;
    offset = ((_e230 * metal::sin((18.0 * _e231) - (7.0 * _e233))) + (_e238 * metal::cos((13.0 * _e239) + (5.0 * _e241)))) * _e229;
    metal::float2 _e248 = uv_2;
    metal::float2 _e249 = offset;
    float _e251 = uniforms.ratio;
    param_4 = metal::clamp(_e248 + (_e249 / metal::float2(_e251, 1.0)), metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e258 = getToColor(param_4, _sampler, _to);
    b = _e258;
    glow = 0.0;
    float _e259 = mean;
    float _e260 = t_1;
    rise = _e259 + (0.5 * _e260);
    float _e263 = x_1;
    float _e264 = d;
    float _e265 = rise;
    bq = metal::float2(_e263, _e264 - _e265) / metal::float2(0.08);
    metal::float2 _e270 = bq;
    cell = metal::floor(_e270);
    metal::float2 _e272 = cell;
    param_5 = _e272 + metal::float2(7.1);
    float _e275 = hash(param_5);
    hs = _e275;
    metal::float2 _e276 = cell;
    param_6 = _e276 + metal::float2(3.7);
    float _e279 = hash(param_6);
    float _e282 = stir;
    r = (0.12 + (0.18 * _e279)) * _e282;
    px = 0.01875;
    float _e284 = hs;
    float _e286 = uniforms.bubbles;
    float _e289 = r;
    float _e290 = px;
    if ((_e284 < (_e286 * 0.6)) && (_e289 > _e290)) {
        metal::float2 _e293 = cell;
        float _e296 = r;
        float _e298 = px;
        metal::float2 _e300 = cell;
        param_7 = _e300 + metal::float2(1.3);
        float _e303 = hash(param_7);
        metal::float2 _e304 = cell;
        param_8 = _e304 + metal::float2(9.4);
        float _e307 = hash(param_8);
        c = (_e293 + metal::float2(0.5)) + (((metal::float2(_e303, _e307) * 2.0) - metal::float2(1.0)) * ((0.42 - _e296) - _e298));
        float _e314 = t_1;
        float _e316 = hs;
        float _e322 = c[0u];
        c[0u] = _e322 + (0.08 * metal::sin((6.0 * _e314) + (6.28 * _e316)));
        metal::float2 _e325 = bq;
        metal::float2 _e326 = c;
        dist = metal::length(_e325 - _e326);
        float _e329 = r;
        float _e331 = px;
        float _e333 = r;
        float _e335 = px;
        float _e337 = dist;
        float _e339 = r;
        float _e340 = px;
        float _e342 = r;
        float _e343 = px;
        float _e345 = dist;
        rim = metal::smoothstep((0.7 * _e329) - _e331, (0.7 * _e333) + _e335, _e337) * (1.0 - metal::smoothstep(_e339 - _e340, _e342 + _e343, _e345));
        float _e349 = r;
        float _e351 = px;
        float _e353 = r;
        float _e355 = px;
        metal::float2 _e357 = bq;
        metal::float2 _e358 = c;
        float _e360 = r;
        glint = 1.0 - metal::smoothstep((0.25 * _e349) - _e351, (0.25 * _e353) + _e355, metal::length((_e357 - _e358) - (metal::float2(-0.7, 0.7) * (0.45 * _e360))));
        float _e367 = rim;
        float _e369 = glint;
        float _e371 = depth;
        float _e374 = stir;
        glow = (metal::max(_e367 * 0.6, _e369) * metal::smoothstep(0.0, 0.05, _e371)) * _e374;
    }
    float _e376 = depth;
    line = 1.0 - metal::smoothstep(0.0045, 0.0075, metal::abs(_e376 - 0.006));
    float _e381 = stir;
    float _e383 = depth;
    float _e389 = m;
    float _e391 = line;
    line = _e391 + (((0.35 * _e381) * metal::exp(-(metal::max(_e383, 0.0)) / 0.03)) * _e389);
    float _e395 = uniforms.highlight[3u];
    float _e396 = line;
    float _e397 = glow;
    float _e401 = stir;
    light = (_e395 * metal::clamp(metal::max(_e396, _e397), 0.0, 1.0)) * (0.4 + (0.6 * _e401));
    metal::float4 _e405 = b;
    metal::float4 _e408 = uniforms.highlight;
    float _e410 = light;
    metal::float3 _e412 = metal::mix(_e405.xyz, _e408.xyz, metal::float3(_e410));
    b[0u] = _e412.x;
    b[1u] = _e412.y;
    b[2u] = _e412.z;
    metal::float4 _e419 = a;
    float _e422 = a[3u];
    metal::float3 _e423 = _e419.xyz * _e422;
    float _e425 = a[3u];
    metal::float4 _e430 = b;
    float _e433 = b[3u];
    metal::float3 _e434 = _e430.xyz * _e433;
    float _e436 = b[3u];
    float _e441 = m;
    c_1 = metal::mix(metal::float4(_e423.x, _e423.y, _e423.z, _e425), metal::float4(_e434.x, _e434.y, _e434.z, _e436), metal::float4(_e441));
    float _e445 = c_1[3u];
    if (_e445 > 0.0) {
        metal::float4 _e447 = c_1;
        float _e450 = c_1[3u];
        metal::float3 _e452 = _e447.xyz / metal::float3(_e450);
        float _e454 = c_1[3u];
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
    metal::float2 param_9 = {};
    metal::float2 _e67 = _uv_1;
    param_9 = _e67;
    metal::float4 _e68 = transition(param_9, _from, _sampler, _to, uniforms);
    _fragColor = _e68;
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
