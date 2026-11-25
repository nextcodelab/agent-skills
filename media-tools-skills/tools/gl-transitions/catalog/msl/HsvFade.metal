// HsvFade — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HsvFade.glsl
// Author: nwoeanhinnogaehr
// License: MIT
// Description: A crossfade through the HSV color space that cycles through hues
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float3 hsv2rgb(
    thread metal::float3& c
) {
    metal::float3 p = {};
    metal::float3 _e27 = c;
    p = metal::abs((metal::fract(_e27.xxx + metal::float3(1.0, 0.6666667, 0.33333334)) * 6.0) - metal::float3(3.0, 3.0, 3.0));
    float _e35 = c[2u];
    metal::float3 _e36 = p;
    float _e42 = c[1u];
    return metal::mix(metal::float3(1.0, 1.0, 1.0), metal::clamp(_e36 - metal::float3(1.0, 1.0, 1.0), metal::float3(0.0), metal::float3(1.0)), metal::float3(_e42)) * _e35;
}

metal::float3 rgb2hsv(
    thread metal::float3& c_1
) {
    metal::float4 p_1 = {};
    metal::float4 q = {};
    float d = {};
    metal::float3 _e29 = c_1;
    metal::float2 _e30 = _e29.zy;
    metal::float3 _e36 = c_1;
    metal::float2 _e37 = _e36.yz;
    float _e44 = c_1[2u];
    float _e46 = c_1[1u];
    p_1 = metal::mix(metal::float4(_e30.x, _e30.y, metal::float2(-1.0, 0.6666667).x, metal::float2(-1.0, 0.6666667).y), metal::float4(_e37.x, _e37.y, metal::float2(0.0, -0.33333334).x, metal::float2(0.0, -0.33333334).y), metal::float4(metal::step(_e44, _e46)));
    metal::float4 _e50 = p_1;
    metal::float3 _e51 = _e50.xyw;
    float _e53 = c_1[0u];
    float _e59 = c_1[0u];
    metal::float4 _e60 = p_1;
    metal::float3 _e61 = _e60.yzx;
    float _e67 = p_1[0u];
    float _e69 = c_1[0u];
    q = metal::mix(metal::float4(_e51.x, _e51.y, _e51.z, _e53), metal::float4(_e59, _e61.x, _e61.y, _e61.z), metal::float4(metal::step(_e67, _e69)));
    float _e74 = q[0u];
    float _e76 = q[3u];
    float _e78 = q[1u];
    d = _e74 - metal::min(_e76, _e78);
    float _e82 = q[2u];
    float _e84 = q[3u];
    float _e86 = q[1u];
    float _e88 = d;
    float _e94 = d;
    float _e96 = q[0u];
    float _e100 = q[0u];
    return metal::float3(metal::abs(_e82 + ((_e84 - _e86) / ((6.0 * _e88) + 0.001))), _e94 / (_e96 + 0.001), _e100);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e27 = uv[0u];
    float _e29 = uv[1u];
    metal::float4 _e32 = _to.sample(_sampler, metal::float2(_e27, 1.0 - _e29), metal::level(0.0));
    return _e32;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e27 = uv_1[0u];
    float _e29 = uv_1[1u];
    metal::float4 _e32 = _from.sample(_sampler, metal::float2(_e27, 1.0 - _e29), metal::level(0.0));
    return _e32;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 from = {};
    metal::float2 param = {};
    metal::float4 to = {};
    metal::float2 param_1 = {};
    metal::float3 m = {};
    metal::float3 param_2 = {};
    metal::float3 param_3 = {};
    metal::float3 param_4 = {};
    metal::float2 _e34 = uv_2;
    param = _e34;
    metal::float4 _e35 = getFromColor(param, _from, _sampler);
    from = _e35;
    metal::float2 _e36 = uv_2;
    param_1 = _e36;
    metal::float4 _e37 = getToColor(param_1, _sampler, _to);
    to = _e37;
    metal::float4 _e38 = from;
    param_2 = _e38.xyz;
    metal::float3 _e40 = rgb2hsv(param_2);
    metal::float4 _e41 = to;
    param_3 = _e41.xyz;
    metal::float3 _e43 = rgb2hsv(param_3);
    float _e45 = uniforms.progress;
    m = metal::mix(_e40, _e43, metal::float3(_e45));
    metal::float3 _e48 = m;
    param_4 = _e48;
    metal::float3 _e49 = hsv2rgb(param_4);
    float _e51 = from[3u];
    float _e53 = to[3u];
    float _e55 = uniforms.progress;
    return metal::float4(_e49.x, _e49.y, _e49.z, metal::mix(_e51, _e53, _e55));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_5 = {};
    metal::float2 _e26 = _uv_1;
    param_5 = _e26;
    metal::float4 _e27 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e27;
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
