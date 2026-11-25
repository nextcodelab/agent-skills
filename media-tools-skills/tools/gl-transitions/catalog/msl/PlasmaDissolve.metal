// PlasmaDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PlasmaDissolve.glsl
// Author: gre
// License: MIT
// Description: A flowing plasma of sine waves, as in the old demos, draws moving bands through which the incoming image spreads like tendrils, with a glowing edge
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
    float flow;
    char _pad5[12];
    metal::packed_float3 edgeColor;
    float edgeStrength;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    metal::float2 p = {};
    float t = {};
    float v = {};
    float s = {};
    float threshold = {};
    float m = {};
    metal::float4 col = {};
    float glow = {};
    metal::float2 _e46 = uv_2;
    param = _e46;
    metal::float4 _e47 = getFromColor(param, _from, _sampler);
    a = _e47;
    metal::float2 _e48 = uv_2;
    param_1 = _e48;
    metal::float4 _e49 = getToColor(param_1, _sampler, _to);
    b = _e49;
    float _e51 = uniforms.progress;
    if (_e51 <= 0.0) {
        metal::float4 _e53 = a;
        return _e53;
    }
    float _e55 = uniforms.progress;
    if (_e55 >= 1.0) {
        metal::float4 _e57 = b;
        return _e57;
    }
    metal::float2 _e58 = uv_2;
    float _e62 = uniforms.ratio;
    float _e66 = uniforms.scale;
    p = ((((_e58 - metal::float2(0.5)) * metal::float2(_e62, 1.0)) * metal::max(_e66, 0.0)) * 2.0) * 3.1415927;
    float _e72 = uniforms.flow;
    float _e75 = uniforms.progress;
    t = (metal::clamp(_e72, 0.0, 1.0) * _e75) * 0.5;
    float _e79 = p[0u];
    float _e81 = t;
    float _e85 = p[1u];
    float _e87 = t;
    float _e93 = p[0u];
    float _e96 = p[1u];
    float _e100 = t;
    metal::float2 _e105 = p;
    float _e107 = uniforms.scale;
    float _e115 = t;
    v = ((metal::sin((_e79 * 0.6) + _e81) + metal::sin((_e85 * 0.8) - (_e87 * 0.8))) + metal::sin((((_e93 * 0.5) + (_e96 * 0.7)) * 0.7) + (_e100 * 0.6))) + metal::sin((metal::length(_e105 - (((metal::float2(0.15, -0.1) * metal::max(_e107, 0.0)) * 2.0) * 3.1415927)) * 0.9) - (_e115 * 1.2));
    float _e120 = v;
    v = metal::abs((metal::fract((_e120 * 0.25) + 0.5) * 2.0) - 1.0);
    float _e128 = uniforms.smoothness;
    s = metal::max(_e128, 0.001);
    float _e130 = s;
    float _e132 = s;
    float _e135 = uniforms.progress;
    threshold = metal::mix(-(_e130), 1.0 + _e132, _e135);
    float _e137 = threshold;
    float _e138 = s;
    float _e140 = threshold;
    float _e141 = s;
    float _e143 = v;
    m = 1.0 - metal::smoothstep(_e137 - _e138, _e140 + _e141, _e143);
    metal::float4 _e146 = a;
    float _e149 = a[3u];
    metal::float3 _e150 = _e146.xyz * _e149;
    float _e152 = a[3u];
    metal::float4 _e157 = b;
    float _e160 = b[3u];
    metal::float3 _e161 = _e157.xyz * _e160;
    float _e163 = b[3u];
    float _e168 = m;
    col = metal::mix(metal::float4(_e150.x, _e150.y, _e150.z, _e152), metal::float4(_e161.x, _e161.y, _e161.z, _e163), metal::float4(_e168));
    float _e172 = col[3u];
    if (_e172 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    float _e174 = m;
    float _e176 = m;
    float _e180 = uniforms.edgeStrength;
    glow = ((4.0 * _e174) * (1.0 - _e176)) * metal::max(_e180, 0.0);
    metal::float4 _e183 = col;
    float _e186 = col[3u];
    metal::float3 _e190 = uniforms.edgeColor;
    float _e191 = glow;
    metal::float3 _e193 = (_e183.xyz / metal::float3(_e186)) + (_e190 * _e191);
    float _e195 = col[3u];
    return metal::float4(_e193.x, _e193.y, _e193.z, _e195);
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
    metal::float2 _e34 = _uv_1;
    param_2 = _e34;
    metal::float4 _e35 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e35;
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
