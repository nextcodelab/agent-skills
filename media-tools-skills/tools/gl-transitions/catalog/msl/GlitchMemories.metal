// GlitchMemories — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchMemories.glsl
// Author: Gunnar Roth
// License: MIT
// Description: A crossfade with glitchy, color-shifted blocks
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e26 = uv[0u];
    float _e28 = uv[1u];
    metal::float4 _e31 = _to.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e26 = uv_1[0u];
    float _e28 = uv_1[1u];
    metal::float4 _e31 = _from.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 transition(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 block = {};
    metal::float2 uv_noise = {};
    metal::float2 dist = {};
    metal::float2 local = {};
    metal::float2 red = {};
    metal::float2 green = {};
    metal::float2 blue = {};
    metal::float4 center = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 _e39 = p;
    block = metal::floor(_e39 / metal::float2(16.0, 16.0));
    metal::float2 _e42 = block;
    uv_noise = _e42 / metal::float2(64.0, 64.0);
    float _e45 = uniforms.progress;
    metal::float2 _e50 = uv_noise;
    uv_noise = _e50 + (metal::floor(metal::float2(_e45) * metal::float2(1200.0, 3500.0)) / metal::float2(64.0, 64.0));
    float _e53 = uniforms.progress;
    if (_e53 > 0.0) {
        metal::float2 _e55 = uv_noise;
        float _e61 = uniforms.progress;
        local = ((metal::fract(_e55) - metal::float2(0.5)) * 0.3) * (1.0 - _e61);
    } else {
        local = metal::float2(0.0, 0.0);
    }
    metal::float2 _e64 = local;
    dist = _e64;
    metal::float2 _e65 = p;
    metal::float2 _e66 = dist;
    red = _e65 + (_e66 * 0.2);
    metal::float2 _e69 = p;
    metal::float2 _e70 = dist;
    green = _e69 + (_e70 * 0.3);
    metal::float2 _e73 = p;
    metal::float2 _e74 = dist;
    blue = _e73 + (_e74 * 0.5);
    metal::float2 _e77 = green;
    param = _e77;
    metal::float4 _e78 = getFromColor(param, _from, _sampler);
    metal::float2 _e79 = green;
    param_1 = _e79;
    metal::float4 _e80 = getToColor(param_1, _sampler, _to);
    float _e82 = uniforms.progress;
    center = metal::mix(_e78, _e80, metal::float4(_e82));
    metal::float2 _e85 = red;
    param_2 = _e85;
    metal::float4 _e86 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e87 = red;
    param_3 = _e87;
    metal::float4 _e88 = getToColor(param_3, _sampler, _to);
    float _e90 = uniforms.progress;
    float _e95 = center[1u];
    metal::float2 _e96 = blue;
    param_4 = _e96;
    metal::float4 _e97 = getFromColor(param_4, _from, _sampler);
    metal::float2 _e98 = blue;
    param_5 = _e98;
    metal::float4 _e99 = getToColor(param_5, _sampler, _to);
    float _e101 = uniforms.progress;
    float _e106 = center[3u];
    return metal::float4(metal::mix(_e86, _e88, metal::float4(_e90)).x, _e95, metal::mix(_e97, _e99, metal::float4(_e101)).z, _e106);
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
    metal::float2 _e25 = _uv_1;
    param_6 = _e25;
    metal::float4 _e26 = transition(param_6, _from, _sampler, _to, uniforms);
    _fragColor = _e26;
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
