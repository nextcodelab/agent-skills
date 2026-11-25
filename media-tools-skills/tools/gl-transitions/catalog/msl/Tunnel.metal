// Tunnel — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Tunnel.glsl
// Author: gre
// License: MIT
// Description: The camera flies down a tunnel lined with the outgoing image toward the incoming one, which opens at its far end and grows to fill the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float speed;
    float twist;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e25 = uv[0u];
    float _e27 = uv[1u];
    metal::float4 _e30 = _to.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e25 = uv_1[0u];
    float _e27 = uv_1[1u];
    metal::float4 _e30 = _from.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float2 rotate(
    thread metal::float2& v,
    thread float& a
) {
    float c = {};
    float s = {};
    float _e27 = a;
    c = metal::cos(_e27);
    float _e29 = a;
    s = metal::sin(_e29);
    float _e31 = c;
    float _e33 = v[0u];
    float _e35 = s;
    float _e37 = v[1u];
    float _e40 = s;
    float _e42 = v[0u];
    float _e44 = c;
    float _e46 = v[1u];
    return metal::float2((_e31 * _e33) - (_e35 * _e37), (_e40 * _e42) + (_e44 * _e46));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 aspect = {};
    metal::float2 c_1 = {};
    float r = {};
    float R = {};
    float far = {};
    float e = {};
    float d = {};
    float t = {};
    float k = {};
    float local = {};
    float a_1 = {};
    metal::float4 walls = {};
    metal::float2 param = {};
    float param_1 = {};
    metal::float2 param_2 = {};
    float open = {};
    metal::float2 q = {};
    metal::float2 inside = {};
    metal::float2 param_3 = {};
    float _e44 = uniforms.ratio;
    aspect = metal::float2(_e44, 1.0);
    metal::float2 _e46 = uv_2;
    metal::float2 _e49 = aspect;
    c_1 = (_e46 - metal::float2(0.5)) * _e49;
    metal::float2 _e51 = c_1;
    r = metal::length(_e51);
    metal::float2 _e53 = aspect;
    R = metal::length(_e53 * 0.5);
    float _e57 = uniforms.speed;
    far = 1.0 + _e57;
    float _e60 = uniforms.progress;
    float _e62 = uniforms.progress;
    float _e64 = uniforms.progress;
    float _e67 = uniforms.progress;
    e = metal::mix(_e60, (_e62 * _e64) * (3.0 - (2.0 * _e67)), 0.7);
    float _e72 = far;
    float _e73 = e;
    d = metal::pow(_e72, 1.0 - _e73);
    float _e76 = far;
    float _e77 = d;
    t = _e76 - _e77;
    float _e79 = r;
    float _e80 = d;
    float _e82 = R;
    if ((_e79 * _e80) < _e82) {
        float _e84 = d;
        float _e85 = far;
        local = _e84 / _e85;
    } else {
        float _e87 = R;
        float _e88 = R;
        float _e89 = t;
        float _e90 = r;
        local = _e87 / (_e88 + (_e89 * _e90));
    }
    float _e94 = local;
    k = _e94;
    float _e96 = uniforms.twist;
    float _e97 = t;
    float _e98 = r;
    float _e100 = R;
    float _e102 = t;
    float _e103 = d;
    a_1 = _e96 * metal::min((_e97 * _e98) / _e100, _e102 / _e103);
    metal::float2 _e107 = c_1;
    float _e108 = k;
    param = _e107 * _e108;
    float _e110 = a_1;
    param_1 = _e110;
    metal::float2 _e111 = rotate(param, param_1);
    metal::float2 _e112 = aspect;
    param_2 = metal::float2(0.5) + (_e111 / _e112);
    metal::float4 _e116 = getFromColor(param_2, _from, _sampler);
    walls = _e116;
    float _e117 = k;
    metal::float4 _e121 = walls;
    metal::float3 _e123 = _e121.xyz * (0.4 + (0.6 * metal::sqrt(_e117)));
    walls[0u] = _e123.x;
    walls[1u] = _e123.y;
    walls[2u] = _e123.z;
    float _e131 = uniforms.progress;
    open = metal::smoothstep(0.0, 0.6, _e131);
    metal::float2 _e133 = uv_2;
    float _e136 = d;
    float _e138 = open;
    q = metal::float2(0.5) + (((_e133 - metal::float2(0.5)) * _e136) / metal::float2(metal::max(_e138, 0.0001)));
    metal::float2 _e144 = q;
    metal::float2 _e147 = q;
    inside = metal::step(metal::float2(0.0), _e144) * metal::step(_e147, metal::float2(1.0, 1.0));
    metal::float4 _e150 = walls;
    metal::float2 _e151 = q;
    param_3 = _e151;
    metal::float4 _e152 = getToColor(param_3, _sampler, _to);
    float _e154 = inside[0u];
    float _e156 = inside[1u];
    float _e158 = r;
    float _e159 = d;
    float _e161 = R;
    return metal::mix(_e150, _e152, metal::float4((_e154 * _e156) * metal::step(_e158 * _e159, _e161)));
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
    metal::float2 _e24 = _uv_1;
    param_4 = _e24;
    metal::float4 _e25 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e25;
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
