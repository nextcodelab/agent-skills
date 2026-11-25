// UndulatingBurnOut — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/UndulatingBurnOut.glsl
// Author: pthrasher
// License: MIT
// Description: A circle with a wavy edge burns out from the center to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float smoothness;
    char _pad3[4];
    metal::float2 center;
    char _pad4[8];
    metal::float4 color;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e37 = uv[0u];
    float _e39 = uv[1u];
    metal::float4 _e42 = _to.sample(_sampler, metal::float2(_e37, 1.0 - _e39), metal::level(0.0));
    return _e42;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e37 = uv_1[0u];
    float _e39 = uv_1[1u];
    metal::float4 _e42 = _from.sample(_sampler, metal::float2(_e37, 1.0 - _e39), metal::level(0.0));
    return _e42;
}

float getGradient(
    thread float& r,
    thread float& dist,
    constant Uniforms& uniforms
) {
    float d = {};
    float _e38 = r;
    float _e39 = dist;
    d = _e38 - _e39;
    float _e42 = uniforms.smoothness;
    float _e44 = r;
    float _e45 = dist;
    float _e47 = uniforms.smoothness;
    float _e52 = d;
    float _e55 = d;
    float _e57 = d;
    return metal::mix(metal::smoothstep(-(_e42), 0.0, _e44 - (_e45 * (1.0 + _e47))), -1.0 - metal::step(0.005, _e52), metal::step(-0.005, _e55) * metal::step(_e57, 0.01));
}

float quadraticInOut(
    thread float& t
) {
    float p = {};
    float local = {};
    float _e38 = t;
    float _e40 = t;
    p = (2.0 * _e38) * _e40;
    float _e42 = t;
    if (_e42 < 0.5) {
        float _e44 = p;
        local = _e44;
    } else {
        float _e45 = p;
        float _e47 = t;
        local = (-(_e45) + (4.0 * _e47)) - 1.0;
    }
    float _e51 = local;
    return _e51;
}

float getWave(
    thread metal::float2& p_1,
    constant Uniforms& uniforms
) {
    metal::float2 _p = {};
    float rads = {};
    float degs = {};
    metal::float2 range = {};
    metal::float2 domain = {};
    float ratio = {};
    float x = {};
    float magnitude = {};
    float offset = {};
    float ease_degs = {};
    float param = {};
    float deg_wave_pos = {};
    metal::float2 _e48 = p_1;
    metal::float2 _e50 = uniforms.center;
    _p = _e48 - _e50;
    float _e53 = _p[1u];
    float _e55 = _p[0u];
    rads = metal::atan2(_e53, _e55);
    float _e57 = rads;
    degs = ((_e57) * 57.295779513082322865) + 180.0;
    range = metal::float2(0.0, 94.24778);
    domain = metal::float2(0.0, 360.0);
    ratio = 0.2617994;
    float _e60 = degs;
    float _e61 = ratio;
    degs = _e60 * _e61;
    float _e64 = uniforms.progress;
    x = _e64;
    float _e65 = x;
    magnitude = metal::mix(0.02, 0.09, metal::smoothstep(0.0, 1.0, _e65));
    float _e68 = x;
    offset = metal::mix(40.0, 30.0, metal::smoothstep(0.0, 1.0, _e68));
    float _e71 = degs;
    param = metal::sin(_e71);
    float _e73 = quadraticInOut(param);
    ease_degs = _e73;
    float _e74 = ease_degs;
    float _e75 = magnitude;
    float _e77 = x;
    float _e78 = offset;
    deg_wave_pos = (_e74 * _e75) * metal::sin(_e77 * _e78);
    float _e82 = x;
    float _e84 = uniforms.smoothness;
    float _e86 = x;
    float _e91 = deg_wave_pos;
    return (_e82 - (metal::max(_e84, 0.01) * (1.0 - metal::smoothstep(0.0, 0.1, _e86)))) + _e91;
}

metal::float4 transition(
    thread metal::float2& p_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dist_1 = {};
    float m = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float param_3 = {};
    metal::float4 cfrom = {};
    metal::float2 param_4 = {};
    metal::float4 cto = {};
    metal::float2 param_5 = {};
    metal::float2 _e46 = uniforms.center;
    metal::float2 _e47 = p_2;
    dist_1 = metal::distance(_e46, _e47);
    metal::float2 _e49 = p_2;
    param_1 = _e49;
    float _e50 = getWave(param_1, uniforms);
    param_2 = _e50;
    float _e51 = dist_1;
    param_3 = _e51;
    float _e52 = getGradient(param_2, param_3, uniforms);
    m = _e52;
    metal::float2 _e53 = p_2;
    param_4 = _e53;
    metal::float4 _e54 = getFromColor(param_4, _from, _sampler);
    cfrom = _e54;
    metal::float2 _e55 = p_2;
    param_5 = _e55;
    metal::float4 _e56 = getToColor(param_5, _sampler, _to);
    cto = _e56;
    metal::float4 _e57 = cfrom;
    metal::float4 _e58 = cto;
    float _e59 = m;
    metal::float4 _e62 = cfrom;
    metal::float4 _e64 = uniforms.color;
    float _e67 = m;
    return metal::mix(metal::mix(_e57, _e58, metal::float4(_e59)), metal::mix(_e62, _e64, metal::float4(0.75)), metal::float4(metal::step(_e67, -2.0)));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_6 = {};
    metal::float2 _e36 = _uv_1;
    param_6 = _e36;
    metal::float4 _e37 = transition(param_6, _from, _sampler, _to, uniforms);
    _fragColor = _e37;
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
