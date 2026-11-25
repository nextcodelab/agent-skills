// WedgeWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WedgeWipe.glsl
// Author: gre
// License: MIT
// Description: Two hands sweep away from each other around the center, opening a widening wedge that reveals the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float angle;
    float smoothness;
    metal::float2 center;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e19 = uv[0u];
    float _e21 = uv[1u];
    metal::float4 _e24 = _from.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e19 = uv_1[0u];
    float _e21 = uv_1[1u];
    metal::float4 _e24 = _to.sample(_sampler, metal::float2(_e19, 1.0 - _e21), metal::level(0.0));
    return _e24;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 q = {};
    float a = {};
    metal::float2 p = {};
    float spread = {};
    metal::float2 hand = {};
    float l = {};
    float d = {};
    float s = {};
    float m = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float _e31 = uniforms.progress;
    if (_e31 >= 1.0) {
        metal::float2 _e33 = uv_2;
        param = _e33;
        metal::float4 _e34 = getToColor(param, _sampler, _to);
        return _e34;
    }
    metal::float2 _e35 = uv_2;
    metal::float2 _e37 = uniforms.center;
    float _e40 = uniforms.ratio;
    q = (_e35 - _e37) * metal::float2(_e40, 1.0);
    float _e44 = uniforms.angle;
    a = ((_e44) * 0.017453292519943295474);
    float _e47 = q[0u];
    float _e48 = a;
    float _e52 = q[1u];
    float _e53 = a;
    float _e59 = q[0u];
    float _e60 = a;
    float _e64 = q[1u];
    float _e65 = a;
    p = metal::float2(metal::abs((_e47 * metal::cos(_e48)) - (_e52 * metal::sin(_e53))), (_e59 * metal::sin(_e60)) + (_e64 * metal::cos(_e65)));
    float _e71 = uniforms.progress;
    spread = 3.1415927 * _e71;
    float _e73 = spread;
    float _e75 = spread;
    hand = metal::float2(metal::sin(_e73), metal::cos(_e75));
    metal::float2 _e78 = p;
    l = metal::length(_e78);
    metal::float2 _e80 = p;
    metal::float2 _e81 = hand;
    metal::float2 _e82 = p;
    metal::float2 _e83 = hand;
    float _e85 = l;
    float _e91 = hand[1u];
    float _e93 = p[0u];
    float _e96 = hand[0u];
    float _e98 = p[1u];
    d = metal::length(_e80 - (_e81 * metal::clamp(metal::dot(_e82, _e83), 0.0, _e85))) * metal::sign((_e91 * _e93) - (_e96 * _e98));
    float _e104 = uniforms.smoothness;
    s = metal::max(_e104, 0.001);
    float _e106 = s;
    float _e107 = d;
    float _e108 = s;
    float _e110 = uniforms.progress;
    m = 1.0 - metal::smoothstep(0.0, _e106, _e107 + (_e108 * (1.0 - _e110)));
    metal::float2 _e116 = uv_2;
    param_1 = _e116;
    metal::float4 _e117 = getFromColor(param_1, _from, _sampler);
    metal::float2 _e118 = uv_2;
    param_2 = _e118;
    metal::float4 _e119 = getToColor(param_2, _sampler, _to);
    float _e120 = m;
    return metal::mix(_e117, _e119, metal::float4(_e120));
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
    metal::float2 _e18 = _uv_1;
    param_3 = _e18;
    metal::float4 _e19 = transition(param_3, _from, _sampler, _to, uniforms);
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
