// DreamyZoom — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DreamyZoom.glsl
// Author: Zeh Fernando
// License: MIT
// Description: Zooms and rotates into a bright flash, then out to the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float rotation;
    float scale;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e22 = uv[0u];
    float _e24 = uv[1u];
    metal::float4 _e27 = _to.sample(_sampler, metal::float2(_e22, 1.0 - _e24), metal::level(0.0));
    return _e27;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e22 = uv_1[0u];
    float _e24 = uv_1[1u];
    metal::float4 _e27 = _from.sample(_sampler, metal::float2(_e22, 1.0 - _e24), metal::level(0.0));
    return _e27;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float phase = {};
    float local = {};
    float angleOffset = {};
    float local_1 = {};
    float newScale = {};
    float local_2 = {};
    metal::float2 center = {};
    metal::float2 assumedCenter = {};
    metal::float2 p = {};
    float angle = {};
    float dist = {};
    metal::float4 c = {};
    metal::float4 local_3 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float local_4 = {};
    float _e38 = uniforms.progress;
    if (_e38 < 0.5) {
        float _e41 = uniforms.progress;
        local = _e41 * 2.0;
    } else {
        float _e44 = uniforms.progress;
        local = (_e44 - 0.5) * 2.0;
    }
    float _e47 = local;
    phase = _e47;
    float _e49 = uniforms.progress;
    if (_e49 < 0.5) {
        float _e52 = uniforms.rotation;
        float _e54 = phase;
        local_1 = metal::mix(0.0, _e52 * 0.03926991, _e54);
    } else {
        float _e57 = uniforms.rotation;
        float _e60 = phase;
        local_1 = metal::mix(-(_e57) * 0.03926991, 0.0, _e60);
    }
    float _e62 = local_1;
    angleOffset = _e62;
    float _e64 = uniforms.progress;
    if (_e64 < 0.5) {
        float _e67 = uniforms.scale;
        float _e68 = phase;
        local_2 = metal::mix(1.0, _e67, _e68);
    } else {
        float _e71 = uniforms.scale;
        float _e72 = phase;
        local_2 = metal::mix(_e71, 1.0, _e72);
    }
    float _e74 = local_2;
    newScale = _e74;
    center = metal::float2(0.0, 0.0);
    assumedCenter = metal::float2(0.5, 0.5);
    metal::float2 _e75 = uv_2;
    float _e77 = newScale;
    float _e81 = uniforms.ratio;
    p = ((_e75 - metal::float2(0.5, 0.5)) / metal::float2(_e77)) * metal::float2(_e81, 1.0);
    float _e85 = p[1u];
    float _e87 = p[0u];
    float _e89 = angleOffset;
    angle = metal::atan2(_e85, _e87) + _e89;
    metal::float2 _e91 = center;
    metal::float2 _e92 = p;
    dist = metal::distance(_e91, _e92);
    float _e94 = angle;
    float _e96 = dist;
    float _e99 = uniforms.ratio;
    p[0u] = ((metal::cos(_e94) * _e96) / _e99) + 0.5;
    float _e103 = angle;
    float _e105 = dist;
    p[1u] = (metal::sin(_e103) * _e105) + 0.5;
    float _e110 = uniforms.progress;
    if (_e110 < 0.5) {
        metal::float2 _e112 = p;
        param = _e112;
        metal::float4 _e113 = getFromColor(param, _from, _sampler);
        local_3 = _e113;
    } else {
        metal::float2 _e114 = p;
        param_1 = _e114;
        metal::float4 _e115 = getToColor(param_1, _sampler, _to);
        local_3 = _e115;
    }
    metal::float4 _e116 = local_3;
    c = _e116;
    metal::float4 _e117 = c;
    float _e120 = uniforms.progress;
    if (_e120 < 0.5) {
        float _e122 = phase;
        local_4 = metal::mix(0.0, 1.0, _e122);
    } else {
        float _e124 = phase;
        local_4 = metal::mix(1.0, 0.0, _e124);
    }
    float _e126 = local_4;
    metal::float3 _e128 = _e117.xyz + metal::float3(_e126);
    float _e130 = c[3u];
    return metal::float4(_e128.x, _e128.y, _e128.z, _e130);
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
    metal::float2 _e21 = _uv_1;
    param_2 = _e21;
    metal::float4 _e22 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e22;
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
