// PlusWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PlusWipe.glsl
// Author: gre
// License: MIT
// Description: A plus-shaped cross grows from the center and widens its arms until the incoming image fills the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float smoothness;
    int reverse;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e19 = uv[0u];
    float _e21 = uv[1u];
    metal::float4 _e24 = _to.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e19 = uv_1[0u];
    float _e21 = uv_1[1u];
    metal::float4 _e24 = _from.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

float boxDist(
    thread metal::float2& p,
    thread metal::float2& halfSize
) {
    metal::float2 d = {};
    metal::float2 _e20 = p;
    metal::float2 _e22 = halfSize;
    d = metal::abs(_e20) - _e22;
    metal::float2 _e24 = d;
    float _e29 = d[0u];
    float _e31 = d[1u];
    return metal::length(metal::max(_e24, metal::float2(0.0))) + metal::min(metal::max(_e29, _e31), 0.0);
}

float plus(
    thread metal::float2& q,
    thread float& t,
    thread float& s,
    constant Uniforms& uniforms
) {
    metal::float2 frame = {};
    float k = {};
    metal::float2 halfWidth = {};
    float halfLength = {};
    float d_1 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float _e30 = uniforms.ratio;
    frame = metal::float2(0.5 * _e30, 0.5);
    float _e34 = frame[0u];
    float _e36 = frame[1u];
    k = metal::min(_e34, _e36);
    float _e38 = k;
    float _e39 = t;
    metal::float2 _e41 = frame;
    float _e42 = k;
    float _e45 = t;
    float _e47 = t;
    halfWidth = metal::float2(_e38 * _e39) + (((_e41 - metal::float2(_e42)) * _e45) * _e47);
    float _e52 = frame[0u];
    float _e54 = frame[1u];
    float _e57 = t;
    halfLength = (3.0 * metal::max(_e52, _e54)) * _e57;
    float _e59 = halfLength;
    float _e61 = halfWidth[1u];
    metal::float2 _e63 = q;
    param = _e63;
    param_1 = metal::float2(_e59, _e61);
    float _e64 = boxDist(param, param_1);
    float _e66 = halfWidth[0u];
    float _e67 = halfLength;
    metal::float2 _e69 = q;
    param_2 = _e69;
    param_3 = metal::float2(_e66, _e67);
    float _e70 = boxDist(param_2, param_3);
    d_1 = metal::min(_e64, _e70);
    float _e72 = s;
    float _e73 = d_1;
    float _e74 = s;
    float _e75 = t;
    return 1.0 - metal::smoothstep(0.0, _e72, _e73 + (_e74 * (1.0 - _e75)));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 q_1 = {};
    float s_1 = {};
    float m = {};
    float local = {};
    metal::float2 param_4 = {};
    float param_5 = {};
    float param_6 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 _e30 = uv_2;
    float _e34 = uniforms.ratio;
    q_1 = (_e30 - metal::float2(0.5)) * metal::float2(_e34, 1.0);
    float _e38 = uniforms.smoothness;
    s_1 = metal::max(_e38, 0.001);
    int _e41 = uniforms.reverse;
    if (_e41 != 0) {
        float _e44 = uniforms.progress;
        metal::float2 _e46 = q_1;
        param_4 = _e46;
        param_5 = 1.0 - _e44;
        float _e47 = s_1;
        param_6 = _e47;
        float _e48 = plus(param_4, param_5, param_6, uniforms);
        local = 1.0 - _e48;
    } else {
        metal::float2 _e50 = q_1;
        param_7 = _e50;
        float _e52 = uniforms.progress;
        param_8 = _e52;
        float _e53 = s_1;
        param_9 = _e53;
        float _e54 = plus(param_7, param_8, param_9, uniforms);
        local = _e54;
    }
    float _e55 = local;
    m = _e55;
    metal::float2 _e56 = uv_2;
    param_10 = _e56;
    metal::float4 _e57 = getFromColor(param_10, _from, _sampler);
    metal::float2 _e58 = uv_2;
    param_11 = _e58;
    metal::float4 _e59 = getToColor(param_11, _sampler, _to);
    float _e60 = m;
    return metal::mix(_e57, _e59, metal::float4(_e60));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_12 = {};
    metal::float2 _e18 = _uv_1;
    param_12 = _e18;
    metal::float4 _e19 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e19;
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
