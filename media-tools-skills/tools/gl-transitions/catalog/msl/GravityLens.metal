// GravityLens — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GravityLens.glsl
// Author: gre
// License: MIT
// Description: A black disk appears and grows, bending the outgoing image around it like a heavy mass bends light: the image is stretched into a bright ring at the disk's edge and swallowed until the frame is black, then the disk shrinks back, unbending the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float strength;
    float glow;
    char _pad5[8];
    metal::float4 hole;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e44 = uv[0u];
    float _e46 = uv[1u];
    metal::float4 _e49 = _to.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e44 = uv_1[0u];
    float _e46 = uv_1[1u];
    metal::float4 _e49 = _from.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float2 mirrored(
    thread metal::float2& v
) {
    metal::float2 m = {};
    metal::float2 _e44 = v;
    metal::float2 _e45 = metal::float2(2.0);
    m = _e44 - (metal::floor(_e44 / _e45) * _e45);
    metal::float2 _e50 = m;
    metal::float2 _e51 = m;
    metal::float2 _e54 = m;
    return metal::mix(_e50, metal::float2(2.0) - _e51, metal::step(metal::float2(1.0), _e54));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    bool swallowing = {};
    float u = {};
    float local = {};
    float u2_ = {};
    float k = {};
    metal::float2 aspect = {};
    metal::float2 far = {};
    float rh = {};
    float re = {};
    metal::float2 d = {};
    float r = {};
    metal::float2 q = {};
    metal::float2 param = {};
    metal::float4 c = {};
    metal::float4 local_1 = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float amount = {};
    float inner = {};
    float g = {};
    float einstein = {};
    float photon = {};
    float light = {};
    float cov = {};
    float _e68 = uniforms.progress;
    swallowing = _e68 < 0.55;
    bool _e70 = swallowing;
    if (_e70) {
        float _e72 = uniforms.progress;
        local = _e72 / 0.55;
    } else {
        float _e75 = uniforms.progress;
        local = (1.0 - _e75) / 0.45;
    }
    float _e78 = local;
    u = _e78;
    float _e79 = u;
    float _e80 = u;
    u2_ = _e79 * _e80;
    float _e82 = u2_;
    float _e83 = u2_;
    k = _e82 * (0.6 + (0.4 * _e83));
    float _e88 = uniforms.ratio;
    aspect = metal::float2(_e88, 1.0);
    metal::float2 _e91 = uniforms.center;
    metal::float2 _e93 = uniforms.center;
    metal::float2 _e97 = aspect;
    far = metal::max(_e91, metal::float2(1.0) - _e93) * _e97;
    metal::float2 _e99 = far;
    float _e102 = k;
    rh = (metal::length(_e99) * 1.12) * _e102;
    float _e104 = rh;
    float _e106 = uniforms.strength;
    re = _e104 * (1.0 + metal::max(_e106, 0.0));
    metal::float2 _e110 = uv_2;
    metal::float2 _e112 = uniforms.center;
    metal::float2 _e114 = aspect;
    d = (_e110 - _e112) * _e114;
    metal::float2 _e116 = d;
    r = metal::max(metal::length(_e116), 0.00001);
    metal::float2 _e120 = uniforms.center;
    metal::float2 _e121 = d;
    float _e122 = re;
    float _e123 = re;
    float _e125 = r;
    float _e126 = r;
    metal::float2 _e131 = aspect;
    param = _e120 + ((_e121 * (1.0 - ((_e122 * _e123) / (_e125 * _e126)))) / _e131);
    metal::float2 _e134 = mirrored(param);
    q = _e134;
    bool _e135 = swallowing;
    if (_e135) {
        metal::float2 _e136 = q;
        param_1 = _e136;
        metal::float4 _e137 = getFromColor(param_1, _from, _sampler);
        local_1 = _e137;
    } else {
        metal::float2 _e138 = q;
        param_2 = _e138;
        metal::float4 _e139 = getToColor(param_2, _sampler, _to);
        local_1 = _e139;
    }
    metal::float4 _e140 = local_1;
    c = _e140;
    float _e141 = rh;
    amount = metal::smoothstep(0.0, 0.04, _e141);
    float _e143 = r;
    float _e144 = rh;
    float _e146 = re;
    float _e147 = rh;
    inner = metal::clamp((_e143 - _e144) / ((_e146 - _e147) + 0.0001), 0.0, 1.0);
    float _e152 = amount;
    float _e154 = inner;
    float _e155 = inner;
    float _e157 = inner;
    metal::float4 _e164 = c;
    metal::float3 _e166 = _e164.xyz * (1.0 - ((0.7 * _e152) * (1.0 - ((_e154 * _e155) * (3.0 - (2.0 * _e157))))));
    c[0u] = _e166.x;
    c[1u] = _e166.y;
    c[2u] = _e166.z;
    float _e174 = uniforms.glow;
    float _e176 = amount;
    g = metal::max(_e174, 0.0) * _e176;
    float _e178 = r;
    float _e179 = re;
    float _e181 = re;
    float _e182 = rh;
    einstein = (_e178 - _e179) / ((0.3 * (_e181 - _e182)) + 0.01);
    float _e187 = r;
    float _e188 = rh;
    float _e191 = rh;
    photon = metal::max(_e187 - _e188, 0.0) / (0.006 + (0.012 * _e191));
    float _e195 = g;
    float _e196 = einstein;
    float _e198 = einstein;
    float _e202 = photon;
    float _e204 = photon;
    light = _e195 * ((0.7 * metal::exp(-(_e196) * _e198)) + (1.6 * metal::exp(-(_e202) * _e204)));
    metal::float4 _e210 = c;
    float _e212 = light;
    float _e215 = light;
    float _e218 = c[3u];
    metal::float3 _e222 = metal::min((_e210.xyz * (1.0 + _e212)) + (metal::float3(1.0, 0.86, 0.68) * ((0.35 * _e215) * _e218)), metal::float3(1.0, 1.0, 1.0));
    c[0u] = _e222.x;
    c[1u] = _e222.y;
    c[2u] = _e222.z;
    float _e229 = rh;
    float _e230 = r;
    cov = metal::clamp((_e229 - _e230) / 0.004, 0.0, 1.0);
    metal::float4 _e234 = c;
    metal::float4 _e236 = uniforms.hole;
    float _e237 = cov;
    return metal::mix(_e234, _e236, metal::float4(_e237));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e43 = _uv_1;
    param_3 = _e43;
    metal::float4 _e44 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e44;
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
