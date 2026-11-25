// CircleOpen — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CircleOpen.glsl
// Author: gre
// License: MIT
// Description: A soft-edged circle opens from the center to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float smoothness;
    int opening;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float x = {};
    float local = {};
    float m = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float local_1 = {};
    int _e24 = uniforms.opening;
    if (_e24 != 0) {
        float _e27 = uniforms.progress;
        local = _e27;
    } else {
        float _e29 = uniforms.progress;
        local = 1.0 - _e29;
    }
    float _e31 = local;
    x = _e31;
    float _e33 = uniforms.smoothness;
    metal::float2 _e35 = uv_2;
    float _e38 = x;
    float _e40 = uniforms.smoothness;
    m = metal::smoothstep(-(_e33), 0.0, (1.4142135 * metal::distance(metal::float2(0.5, 0.5), _e35)) - (_e38 * (1.0 + _e40)));
    metal::float2 _e45 = uv_2;
    param = _e45;
    metal::float4 _e46 = getFromColor(param, _from, _sampler);
    metal::float2 _e47 = uv_2;
    param_1 = _e47;
    metal::float4 _e48 = getToColor(param_1, _sampler, _to);
    int _e50 = uniforms.opening;
    if (_e50 != 0) {
        float _e52 = m;
        local_1 = 1.0 - _e52;
    } else {
        float _e54 = m;
        local_1 = _e54;
    }
    float _e55 = local_1;
    return metal::mix(_e46, _e48, metal::float4(_e55));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_2 = {};
    metal::float2 _e17 = _uv_1;
    param_2 = _e17;
    metal::float4 _e18 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e18;
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
