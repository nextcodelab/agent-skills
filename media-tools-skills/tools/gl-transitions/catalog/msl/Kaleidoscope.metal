// Kaleidoscope — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Kaleidoscope.glsl
// Author: nwoeanhinnogaehr
// License: MIT
// Description: A crossfade through a spinning kaleidoscope
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float speed;
    float angle;
    float power;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e21 = uv[0u];
    float _e23 = uv[1u];
    metal::float4 _e26 = _to.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e21 = uv_1[0u];
    float _e23 = uv_1[1u];
    metal::float4 _e26 = _from.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p = {};
    metal::float2 q = {};
    float t = {};
    int i = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e28 = uv_2;
    p = _e28 / metal::float2(1.0, 1.0);
    metal::float2 _e30 = p;
    q = _e30;
    float _e32 = uniforms.progress;
    float _e34 = uniforms.power;
    float _e37 = uniforms.speed;
    t = metal::pow(_e32, _e34) * _e37;
    metal::float2 _e39 = p;
    p = _e39 - metal::float2(0.5);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e80 = i;
            i = as_type<int>(as_type<uint>(_e80) + as_type<uint>(1));
        }
        loop_init = false;
        int _e42 = i;
        if (_e42 < 7) {
            float _e44 = t;
            float _e47 = p[0u];
            float _e49 = t;
            float _e52 = p[1u];
            float _e55 = t;
            float _e58 = p[1u];
            float _e60 = t;
            float _e63 = p[0u];
            p = metal::float2((metal::sin(_e44) * _e47) + (metal::cos(_e49) * _e52), (metal::sin(_e55) * _e58) - (metal::cos(_e60) * _e63));
            float _e68 = uniforms.angle;
            float _e69 = t;
            t = _e69 + _e68;
            metal::float2 _e71 = p;
            metal::float2 _e72 = metal::float2(2.0);
            p = metal::abs((_e71 - (metal::floor(_e71 / _e72) * _e72)) - metal::float2(1.0));
            continue;
        } else {
            break;
        }
    }
    metal::float2 _e82 = p;
    metal::float2 _e83 = metal::float2(1.0);
    metal::float2 _e89 = q;
    param = _e89;
    metal::float4 _e90 = getFromColor(param, _from, _sampler);
    metal::float2 _e91 = q;
    param_1 = _e91;
    metal::float4 _e92 = getToColor(param_1, _sampler, _to);
    float _e94 = uniforms.progress;
    metal::float2 _e97 = p;
    param_2 = _e97;
    metal::float4 _e98 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e99 = p;
    param_3 = _e99;
    metal::float4 _e100 = getToColor(param_3, _sampler, _to);
    float _e102 = uniforms.progress;
    float _e106 = uniforms.progress;
    return metal::mix(metal::mix(_e90, _e92, metal::float4(_e94)), metal::mix(_e98, _e100, metal::float4(_e102)), metal::float4(1.0 - (2.0 * metal::abs(_e106 - 0.5))));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_4 = {};
    metal::float2 _e20 = _uv_1;
    param_4 = _e20;
    metal::float4 _e21 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e21;
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
