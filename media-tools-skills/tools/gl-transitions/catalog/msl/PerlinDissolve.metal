// PerlinDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PerlinDissolve.glsl
// Author: Rich Harris
// License: MIT
// Description: The incoming image appears through blobs of Perlin noise
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float scale;
    float smoothness;
    float seed;
};

float random(
    thread metal::float2& co,
    constant Uniforms& uniforms
) {
    float a = {};
    float b = {};
    float c = {};
    float dt = {};
    float sn = {};
    float _e29 = uniforms.seed;
    a = _e29;
    b = 78.233;
    c = 43758.547;
    metal::float2 _e30 = co;
    float _e31 = a;
    float _e32 = b;
    dt = metal::dot(_e30, metal::float2(_e31, _e32));
    float _e35 = dt;
    sn = _e35 - (metal::floor(_e35 / 3.14) * 3.14);
    float _e40 = sn;
    float _e42 = c;
    return metal::fract(metal::sin(_e40) * _e42);
}

float noise(
    thread metal::float2& st,
    constant Uniforms& uniforms
) {
    metal::float2 i = {};
    metal::float2 f = {};
    float a_1 = {};
    metal::float2 param = {};
    float b_1 = {};
    metal::float2 param_1 = {};
    float c_1 = {};
    metal::float2 param_2 = {};
    float d = {};
    metal::float2 param_3 = {};
    metal::float2 u = {};
    metal::float2 _e34 = st;
    i = metal::floor(_e34);
    metal::float2 _e36 = st;
    f = metal::fract(_e36);
    metal::float2 _e38 = i;
    param = _e38;
    float _e39 = random(param, uniforms);
    a_1 = _e39;
    metal::float2 _e40 = i;
    param_1 = _e40 + metal::float2(1.0, 0.0);
    float _e42 = random(param_1, uniforms);
    b_1 = _e42;
    metal::float2 _e43 = i;
    param_2 = _e43 + metal::float2(0.0, 1.0);
    float _e45 = random(param_2, uniforms);
    c_1 = _e45;
    metal::float2 _e46 = i;
    param_3 = _e46 + metal::float2(1.0, 1.0);
    float _e48 = random(param_3, uniforms);
    d = _e48;
    metal::float2 _e49 = f;
    metal::float2 _e50 = f;
    metal::float2 _e52 = f;
    u = (_e49 * _e50) * (metal::float2(3.0) - (_e52 * 2.0));
    float _e57 = a_1;
    float _e58 = b_1;
    float _e60 = u[0u];
    float _e62 = c_1;
    float _e63 = a_1;
    float _e66 = u[1u];
    float _e69 = u[0u];
    float _e73 = d;
    float _e74 = b_1;
    float _e77 = u[0u];
    float _e80 = u[1u];
    return (metal::mix(_e57, _e58, _e60) + (((_e62 - _e63) * _e66) * (1.0 - _e69))) + (((_e73 - _e74) * _e77) * _e80);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e24 = uv[0u];
    float _e26 = uv[1u];
    metal::float4 _e29 = _to.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e24 = uv_1[0u];
    float _e26 = uv_1[1u];
    metal::float4 _e29 = _from.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 from = {};
    metal::float2 param_4 = {};
    metal::float4 to = {};
    metal::float2 param_5 = {};
    float n = {};
    metal::float2 param_6 = {};
    float p = {};
    float lower = {};
    float higher = {};
    float q = {};
    metal::float2 _e33 = uv_2;
    param_4 = _e33;
    metal::float4 _e34 = getFromColor(param_4, _from, _sampler);
    from = _e34;
    metal::float2 _e35 = uv_2;
    param_5 = _e35;
    metal::float4 _e36 = getToColor(param_5, _sampler, _to);
    to = _e36;
    metal::float2 _e37 = uv_2;
    float _e39 = uniforms.scale;
    param_6 = _e37 * _e39;
    float _e41 = noise(param_6, uniforms);
    n = _e41;
    float _e43 = uniforms.smoothness;
    float _e46 = uniforms.smoothness;
    float _e49 = uniforms.progress;
    p = metal::mix(-(_e43), 1.0 + _e46, _e49);
    float _e51 = p;
    float _e53 = uniforms.smoothness;
    lower = _e51 - _e53;
    float _e55 = p;
    float _e57 = uniforms.smoothness;
    higher = _e55 + _e57;
    float _e59 = lower;
    float _e60 = higher;
    float _e61 = n;
    q = metal::smoothstep(_e59, _e60, _e61);
    metal::float4 _e63 = from;
    metal::float4 _e64 = to;
    float _e65 = q;
    return metal::mix(_e63, _e64, metal::float4(1.0 - _e65));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_7 = {};
    metal::float2 _e23 = _uv_1;
    param_7 = _e23;
    metal::float4 _e24 = transition(param_7, _from, _sampler, _to, uniforms);
    _fragColor = _e24;
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
