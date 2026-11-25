// SpotlightWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SpotlightWipe.glsl
// Author: gre
// License: MIT
// Description: The stage lights go down on the outgoing image and a soft oval spotlight searches across it along a curved path, comes to rest and lights the incoming image inside it, then widens until the stage lights come back up on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float size;
    float darkness;
    char _pad5[8];
    metal::float3 warmth;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e45 = uv[0u];
    float _e47 = uv[1u];
    metal::float4 _e50 = _to.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e45 = uv_1[0u];
    float _e47 = uv_1[1u];
    metal::float4 _e50 = _from.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float2 path(
    thread float& t,
    thread metal::float2& c
) {
    metal::float2 a = {};
    metal::float2 b = {};
    metal::float2 d = {};
    float s = {};
    a = metal::float2(0.08, 0.3);
    b = metal::float2(0.35, 1.15);
    d = metal::float2(1.05, 0.95);
    float _e49 = t;
    s = 1.0 - _e49;
    float _e51 = s;
    float _e52 = s;
    float _e54 = s;
    metal::float2 _e56 = a;
    float _e58 = s;
    float _e60 = s;
    float _e62 = t;
    metal::float2 _e64 = b;
    float _e67 = s;
    float _e69 = t;
    float _e71 = t;
    metal::float2 _e73 = d;
    float _e76 = t;
    float _e77 = t;
    float _e79 = t;
    metal::float2 _e81 = c;
    return (((_e56 * ((_e51 * _e52) * _e54)) + (_e64 * (((3.0 * _e58) * _e60) * _e62))) + (_e73 * (((3.0 * _e67) * _e69) * _e71))) + (_e81 * ((_e76 * _e77) * _e79));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 asp = {};
    float p = {};
    float t_1 = {};
    metal::float2 c_1 = {};
    float param = {};
    metal::float2 param_1 = {};
    metal::float2 far = {};
    float full = {};
    float g = {};
    float radius = {};
    metal::float2 q = {};
    float r = {};
    float core = {};
    float ring = {};
    float spot = {};
    float s_1 = {};
    metal::float3 light = {};
    float lit = {};
    metal::float4 col = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float _e66 = uniforms.ratio;
    asp = metal::float2(_e66, 1.0);
    float _e69 = uniforms.progress;
    p = _e69;
    float _e70 = p;
    t_1 = metal::clamp(_e70 / 0.5, 0.0, 1.0);
    float _e73 = t_1;
    float _e74 = t_1;
    float _e76 = t_1;
    t_1 = (_e73 * _e74) * (3.0 - (2.0 * _e76));
    float _e80 = t_1;
    param = _e80;
    metal::float2 _e82 = uniforms.center;
    param_1 = _e82;
    metal::float2 _e83 = path(param, param_1);
    c_1 = _e83;
    metal::float2 _e85 = uniforms.center;
    metal::float2 _e87 = uniforms.center;
    metal::float2 _e91 = asp;
    far = metal::max(_e85, metal::float2(1.0) - _e87) * _e91;
    float _e94 = far[0u];
    float _e96 = far[1u];
    full = metal::length(metal::float2(_e94, _e96 / 0.72)) / 0.74;
    float _e101 = p;
    g = metal::smoothstep(0.44, 1.0, _e101);
    float _e104 = uniforms.size;
    float _e106 = full;
    float _e107 = g;
    float _e108 = g;
    radius = metal::mix(0.5 * _e104, _e106, _e107 * (0.3 + (0.7 * _e108)));
    metal::float2 _e113 = uv_2;
    metal::float2 _e114 = c_1;
    metal::float2 _e116 = asp;
    q = (_e113 - _e114) * _e116;
    float _e119 = q[0u];
    float _e121 = q[1u];
    float _e125 = radius;
    r = metal::length(metal::float2(_e119, _e121 / 0.72)) / _e125;
    float _e127 = r;
    core = 1.0 - metal::smoothstep(0.72, 1.08, _e127);
    float _e130 = r;
    ring = (_e130 - 0.9) / 0.09;
    float _e133 = core;
    float _e134 = r;
    float _e136 = r;
    float _e140 = r;
    float _e145 = ring;
    float _e147 = ring;
    spot = metal::max(_e133 * (1.0 - ((0.1 * _e134) * _e136)), 0.12 * (1.0 - metal::smoothstep(0.9, 2.4, _e140))) + (0.16 * metal::exp(-(_e145) * _e147));
    float _e153 = uniforms.darkness;
    float _e154 = p;
    float _e157 = p;
    s_1 = (_e153 * metal::smoothstep(0.0, 0.18, _e154)) * (1.0 - metal::smoothstep(0.72, 1.0, _e157));
    float _e161 = s_1;
    float _e163 = s_1;
    float _e164 = spot;
    metal::float3 _e167 = uniforms.warmth;
    light = metal::float3(1.0 - _e161) + (_e167 * (_e163 * _e164));
    float _e171 = p;
    float _e173 = r;
    lit = metal::smoothstep(0.42, 0.58, _e171) * (1.0 - metal::smoothstep(0.74, 1.0, _e173));
    metal::float2 _e177 = uv_2;
    param_2 = _e177;
    metal::float4 _e178 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e179 = uv_2;
    param_3 = _e179;
    metal::float4 _e180 = getToColor(param_3, _sampler, _to);
    float _e181 = lit;
    col = metal::mix(_e178, _e180, metal::float4(_e181));
    metal::float4 _e184 = col;
    metal::float3 _e186 = light;
    metal::float3 _e187 = _e184.xyz * _e186;
    float _e189 = col[3u];
    return metal::float4(_e187.x, _e187.y, _e187.z, _e189);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_4 = {};
    metal::float2 _e44 = _uv_1;
    param_4 = _e44;
    metal::float4 _e45 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e45;
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
