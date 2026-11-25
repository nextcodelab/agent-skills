// Hologram — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Hologram.glsl
// Author: gre
// License: MIT
// Description: The outgoing image turns into a flickering hologram (blue by default) with scanlines and jittering rows, breaks up, and the hologram resolves into the incoming image in full color
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float3 tint;
    metal::float4 background;
    float scanlines;
    float jitter;
    float flicker;
    char _pad7[4];
};

metal::float4 premultiplied(
    thread metal::float4& c
) {
    metal::float4 _e60 = c;
    float _e63 = c[3u];
    metal::float3 _e64 = _e60.xyz * _e63;
    float _e66 = c[3u];
    return metal::float4(_e64.x, _e64.y, _e64.z, _e66);
}

float luma(
    thread metal::float3& c_1
) {
    metal::float3 _e60 = c_1;
    return metal::dot(_e60, metal::float3(0.299, 0.587, 0.114));
}

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

metal::float4 source(
    thread metal::float2& uv_2,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e64 = m;
    if (_e64 > 0.5) {
        metal::float2 _e66 = uv_2;
        param = _e66;
        metal::float4 _e67 = getToColor(param, _sampler, _to);
        local = _e67;
    } else {
        metal::float2 _e68 = uv_2;
        param_1 = _e68;
        metal::float4 _e69 = getFromColor(param_1, _from, _sampler);
        local = _e69;
    }
    metal::float4 _e70 = local;
    return _e70;
}

float hash(
    thread metal::float2& p
) {
    metal::float2 _e60 = p;
    p = metal::fract(_e60 * metal::float2(443.897, 441.423));
    metal::float2 _e63 = p;
    metal::float2 _e64 = p;
    metal::float2 _e69 = p;
    p = _e69 + metal::float2(metal::dot(_e63, _e64.yx + metal::float2(19.19)));
    float _e73 = p[0u];
    float _e75 = p[1u];
    float _e78 = p[0u];
    return metal::fract((_e73 + _e75) * _e78);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float p_1 = {};
    float h = {};
    float b = {};
    float f = {};
    float band = {};
    float jump = {};
    metal::float2 param_4 = {};
    float offset = {};
    metal::float2 param_5 = {};
    metal::float2 q = {};
    float m_1 = {};
    metal::float2 param_6 = {};
    metal::float4 c_2 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    metal::float2 dx = {};
    float l = {};
    metal::float3 param_9 = {};
    metal::float4 cr = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    metal::float4 cb = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    float lr = {};
    metal::float3 param_14 = {};
    float lb = {};
    metal::float3 param_15 = {};
    metal::float3 g = {};
    metal::float3 holo = {};
    float roll = {};
    float inside = {};
    float lines = {};
    float vis = {};
    metal::float2 param_16 = {};
    float gap = {};
    metal::float2 param_17 = {};
    metal::float4 layer = {};
    metal::float4 plain = {};
    metal::float2 param_18 = {};
    float param_19 = {};
    metal::float4 param_20 = {};
    metal::float4 back = {};
    metal::float4 param_21 = {};
    metal::float4 holoColor = {};
    metal::float4 param_22 = {};
    metal::float4 o = {};
    metal::float4 local_1 = {};
    float _e111 = uniforms.progress;
    if (_e111 <= 0.0) {
        metal::float2 _e113 = uv_3;
        param_2 = _e113;
        metal::float4 _e114 = getFromColor(param_2, _from, _sampler);
        return _e114;
    }
    float _e116 = uniforms.progress;
    if (_e116 >= 1.0) {
        metal::float2 _e118 = uv_3;
        param_3 = _e118;
        metal::float4 _e119 = getToColor(param_3, _sampler, _to);
        return _e119;
    }
    float _e121 = uniforms.progress;
    p_1 = _e121;
    float _e122 = p_1;
    float _e124 = p_1;
    h = metal::smoothstep(0.0, 0.3, _e122) * (1.0 - metal::smoothstep(0.7, 1.0, _e124));
    float _e128 = p_1;
    b = metal::smoothstep(0.0, 1.0, 1.0 - (metal::abs(_e128 - 0.5) / 0.22));
    float _e134 = p_1;
    f = metal::floor(_e134 * 32.0);
    float _e138 = uv_3[1u];
    band = metal::floor(_e138 * 36.0);
    float _e141 = b;
    float _e144 = h;
    float _e147 = band;
    float _e148 = f;
    param_4 = metal::float2(_e147, _e148);
    float _e150 = hash(param_4);
    jump = metal::step(1.0 - ((0.2 + (0.6 * _e141)) * _e144), _e150);
    float _e152 = band;
    float _e153 = f;
    param_5 = metal::float2(_e152, _e153 + 0.37);
    float _e156 = hash(param_5);
    float _e160 = uniforms.jitter;
    float _e162 = jump;
    float _e164 = b;
    offset = ((((_e156 - 0.5) * 2.0) * _e160) * _e162) * (0.3 + (0.7 * _e164));
    float _e169 = uv_3[1u];
    float _e171 = f;
    float _e176 = h;
    float _e178 = offset;
    offset = _e178 + ((metal::sin((_e169 * 23.0) + (_e171 * 1.7)) * 0.0015) * _e176);
    metal::float2 _e180 = uv_3;
    float _e181 = offset;
    q = _e180 + metal::float2(_e181, 0.0);
    float _e185 = uv_3[1u];
    param_6 = metal::float2(metal::floor(_e185 * 24.0), 7.0);
    float _e189 = hash(param_6);
    float _e190 = p_1;
    m_1 = metal::step(_e189, (_e190 - 0.35) / 0.3);
    metal::float2 _e194 = q;
    param_7 = metal::clamp(_e194, metal::float2(0.0), metal::float2(1.0));
    float _e198 = m_1;
    param_8 = _e198;
    metal::float4 _e199 = source(param_7, param_8, _from, _sampler, _to);
    c_2 = _e199;
    float _e200 = b;
    dx = metal::float2(0.003 + (0.01 * _e200), 0.0);
    metal::float4 _e204 = c_2;
    param_9 = _e204.xyz;
    float _e206 = luma(param_9);
    l = _e206;
    metal::float2 _e207 = q;
    metal::float2 _e208 = dx;
    param_10 = metal::clamp(_e207 + _e208, metal::float2(0.0), metal::float2(1.0));
    float _e213 = m_1;
    param_11 = _e213;
    metal::float4 _e214 = source(param_10, param_11, _from, _sampler, _to);
    cr = _e214;
    metal::float2 _e215 = q;
    metal::float2 _e216 = dx;
    param_12 = metal::clamp(_e215 - _e216, metal::float2(0.0), metal::float2(1.0));
    float _e221 = m_1;
    param_13 = _e221;
    metal::float4 _e222 = source(param_12, param_13, _from, _sampler, _to);
    cb = _e222;
    metal::float4 _e223 = cr;
    param_14 = _e223.xyz;
    float _e225 = luma(param_14);
    float _e227 = cr[3u];
    lr = _e225 * _e227;
    metal::float4 _e229 = cb;
    param_15 = _e229.xyz;
    float _e231 = luma(param_15);
    float _e233 = cb[3u];
    lb = _e231 * _e233;
    float _e235 = lr;
    float _e236 = l;
    float _e237 = lb;
    g = metal::smoothstep(metal::float3(0.05), metal::float3(0.9), metal::float3(_e235, _e236, _e237));
    metal::float3 _e243 = uniforms.tint;
    metal::float3 _e244 = g;
    metal::float3 _e249 = g;
    metal::float3 _e251 = g;
    metal::float3 _e253 = g;
    holo = (_e243 * (metal::float3(0.06) + (_e244 * 1.25))) + (((_e249 * 0.45) * _e251) * _e253);
    float _e257 = uv_3[1u];
    float _e258 = p_1;
    roll = metal::fract(_e257 + (2.0 * _e258));
    metal::float3 _e263 = uniforms.tint;
    float _e265 = roll;
    float _e268 = roll;
    metal::float3 _e272 = holo;
    holo = _e272 + (((_e263 * 0.35) * metal::smoothstep(0.85, 1.0, _e265)) * (1.0 - metal::smoothstep(0.98, 1.0, _e268)));
    metal::float3 _e274 = holo;
    holo = metal::clamp(_e274, metal::float3(0.0), metal::float3(1.0));
    float _e279 = q[0u];
    float _e282 = q[0u];
    inside = metal::step(0.0, _e279) * metal::step(_e282, 1.0);
    float _e286 = uv_3[1u];
    float _e288 = uniforms.scanlines;
    float _e290 = p_1;
    lines = 0.5 + (0.5 * metal::sin((((_e286 * _e288) - (_e290 * 6.0)) * 2.0) * 3.1415927));
    float _e298 = lines;
    float _e301 = h;
    vis = metal::mix(1.0, 0.15 + (0.85 * _e298), _e301);
    float _e304 = uniforms.flicker;
    float _e305 = b;
    float _e309 = f;
    param_16 = metal::float2(_e309, 3.1);
    float _e311 = hash(param_16);
    float _e313 = h;
    float _e316 = vis;
    vis = _e316 * (1.0 - (((_e304 * (0.25 + (0.75 * _e305))) * _e311) * _e313));
    float _e319 = uv_3[1u];
    float _e322 = f;
    param_17 = metal::float2(metal::floor(_e319 * 90.0), _e322 + 0.71);
    float _e325 = hash(param_17);
    float _e327 = uniforms.flicker;
    float _e329 = b;
    gap = metal::step(_e325, (_e327 * 0.45) * _e329);
    float _e332 = gap;
    float _e334 = vis;
    vis = _e334 * (1.0 - _e332);
    metal::float3 _e336 = holo;
    float _e338 = c_2[3u];
    float _e339 = vis;
    float _e341 = inside;
    layer = metal::float4(_e336.x, _e336.y, _e336.z, (_e338 * _e339) * _e341);
    metal::float2 _e347 = uv_3;
    param_18 = _e347;
    float _e348 = m_1;
    param_19 = _e348;
    metal::float4 _e349 = source(param_18, param_19, _from, _sampler, _to);
    param_20 = _e349;
    metal::float4 _e350 = premultiplied(param_20);
    plain = _e350;
    metal::float4 _e352 = uniforms.background;
    metal::float3 _e353 = _e352.xyz;
    float _e356 = uniforms.background[3u];
    float _e358 = plain[3u];
    float _e360 = layer[3u];
    param_21 = metal::float4(_e353.x, _e353.y, _e353.z, _e356 * metal::max(_e358, _e360));
    metal::float4 _e367 = premultiplied(param_21);
    back = _e367;
    metal::float4 _e368 = layer;
    param_22 = _e368;
    metal::float4 _e369 = premultiplied(param_22);
    metal::float4 _e370 = back;
    float _e372 = layer[3u];
    holoColor = _e369 + (_e370 * (1.0 - _e372));
    metal::float4 _e376 = plain;
    metal::float4 _e377 = holoColor;
    float _e378 = h;
    o = metal::mix(_e376, _e377, metal::float4(_e378));
    float _e382 = o[3u];
    if (_e382 > 0.0) {
        metal::float4 _e384 = o;
        float _e387 = o[3u];
        metal::float3 _e389 = _e384.xyz / metal::float3(_e387);
        float _e391 = o[3u];
        local_1 = metal::float4(_e389.x, _e389.y, _e389.z, _e391);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e396 = local_1;
    return _e396;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_23 = {};
    metal::float2 _e60 = _uv_1;
    param_23 = _e60;
    metal::float4 _e61 = transition(param_23, _from, _sampler, _to, uniforms);
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
