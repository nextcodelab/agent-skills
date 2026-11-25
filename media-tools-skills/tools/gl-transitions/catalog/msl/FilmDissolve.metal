// FilmDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmDissolve.glsl
// Author: gre
// License: MIT
// Description: A cross-dissolve blended in linear light, as light adds up on film: the frame keeps its brightness all the way through and the highlights of each image shine through the other
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float overlap;
    float smoothness;
};

metal::float3 toSrgb(
    thread metal::float3& c
) {
    metal::float3 lo = {};
    metal::float3 hi = {};
    metal::float3 _e33 = c;
    lo = _e33 * 12.92;
    metal::float3 _e35 = c;
    hi = (metal::pow(_e35, metal::float3(0.41666666, 0.41666666, 0.41666666)) * 1.055) - metal::float3(0.055);
    metal::float3 _e40 = lo;
    metal::float3 _e41 = hi;
    metal::float3 _e42 = c;
    return metal::mix(_e40, _e41, metal::select(metal::float3(0.0, 0.0, 0.0), metal::float3(1.0, 1.0, 1.0), _e42 > metal::float3(0.0031308, 0.0031308, 0.0031308)));
}

metal::float3 toLinear(
    thread metal::float3& c_1
) {
    metal::float3 lo_1 = {};
    metal::float3 hi_1 = {};
    metal::float3 _e33 = c_1;
    lo_1 = _e33 / metal::float3(12.92);
    metal::float3 _e36 = c_1;
    hi_1 = metal::pow((_e36 + metal::float3(0.055)) / metal::float3(1.055), metal::float3(2.4, 2.4, 2.4));
    metal::float3 _e42 = lo_1;
    metal::float3 _e43 = hi_1;
    metal::float3 _e44 = c_1;
    return metal::mix(_e42, _e43, metal::select(metal::float3(0.0, 0.0, 0.0), metal::float3(1.0, 1.0, 1.0), _e44 > metal::float3(0.04045, 0.04045, 0.04045)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e32 = uv[0u];
    float _e34 = uv[1u];
    metal::float4 _e37 = _to.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e32 = uv_1[0u];
    float _e34 = uv_1[1u];
    metal::float4 _e37 = _from.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
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
    float t = {};
    metal::float3 la = {};
    metal::float3 param_2 = {};
    metal::float3 lb = {};
    metal::float3 param_3 = {};
    metal::float3 base = {};
    float alpha = {};
    float extra = {};
    metal::float3 excess = {};
    metal::float3 room = {};
    metal::float3 color = {};
    metal::float3 param_4 = {};
    metal::float2 _e47 = uv_2;
    param = _e47;
    metal::float4 _e48 = getFromColor(param, _from, _sampler);
    a = _e48;
    metal::float2 _e49 = uv_2;
    param_1 = _e49;
    metal::float4 _e50 = getToColor(param_1, _sampler, _to);
    b = _e50;
    float _e52 = uniforms.progress;
    if (_e52 <= 0.0) {
        metal::float4 _e54 = a;
        return _e54;
    }
    float _e56 = uniforms.progress;
    if (_e56 >= 1.0) {
        metal::float4 _e58 = b;
        return _e58;
    }
    float _e60 = uniforms.progress;
    float _e62 = uniforms.progress;
    float _e65 = uniforms.smoothness;
    t = metal::mix(_e60, metal::smoothstep(0.0, 1.0, _e62), _e65);
    metal::float4 _e67 = a;
    param_2 = metal::clamp(_e67.xyz, metal::float3(0.0), metal::float3(1.0));
    metal::float3 _e72 = toLinear(param_2);
    float _e74 = a[3u];
    la = _e72 * _e74;
    metal::float4 _e76 = b;
    param_3 = metal::clamp(_e76.xyz, metal::float3(0.0), metal::float3(1.0));
    metal::float3 _e81 = toLinear(param_3);
    float _e83 = b[3u];
    lb = _e81 * _e83;
    metal::float3 _e85 = la;
    metal::float3 _e86 = lb;
    float _e87 = t;
    base = metal::mix(_e85, _e86, metal::float3(_e87));
    float _e91 = a[3u];
    float _e93 = b[3u];
    float _e94 = t;
    alpha = metal::mix(_e91, _e93, _e94);
    float _e97 = uniforms.overlap;
    float _e98 = t;
    float _e99 = t;
    extra = _e97 * metal::min(_e98, 1.0 - _e99);
    float _e103 = extra;
    metal::float3 _e104 = la;
    metal::float3 _e105 = lb;
    excess = (_e104 + _e105) * _e103;
    float _e108 = alpha;
    metal::float3 _e110 = base;
    room = metal::max(metal::float3(_e108) - _e110, metal::float3(0.00001, 0.00001, 0.00001));
    metal::float3 _e113 = base;
    metal::float3 _e114 = room;
    metal::float3 _e115 = excess;
    metal::float3 _e117 = room;
    color = _e113 + (_e114 * (metal::float3(1.0) - metal::exp(-(_e115) / _e117)));
    float _e124 = alpha;
    if (_e124 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float3 _e126 = color;
    float _e127 = alpha;
    param_4 = metal::clamp(_e126 / metal::float3(_e127), metal::float3(0.0), metal::float3(1.0));
    metal::float3 _e133 = toSrgb(param_4);
    float _e134 = alpha;
    return metal::float4(_e133.x, _e133.y, _e133.z, _e134);
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
    metal::float2 _e31 = _uv_1;
    param_5 = _e31;
    metal::float4 _e32 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e32;
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
