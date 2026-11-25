// BurnThrough — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BurnThrough.glsl
// Author: liubailin2020@gmail.com
// License: MIT
// Description: The outgoing image burns away in noisy, glowing patches
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float3 burnColor;
};

float random(
    thread metal::float2& st
) {
    metal::float2 _e28 = st;
    return metal::fract(metal::sin(metal::dot(_e28, metal::float2(12.9898, 78.233))) * 43758.547);
}

float noise(
    thread metal::float2& st_1
) {
    metal::float2 i = {};
    metal::float2 f = {};
    float a = {};
    metal::float2 param = {};
    float b = {};
    metal::float2 param_1 = {};
    float c = {};
    metal::float2 param_2 = {};
    float d = {};
    metal::float2 param_3 = {};
    metal::float2 u = {};
    metal::float2 _e39 = st_1;
    i = metal::floor(_e39);
    metal::float2 _e41 = st_1;
    f = metal::fract(_e41);
    metal::float2 _e43 = i;
    param = _e43;
    float _e44 = random(param);
    a = _e44;
    metal::float2 _e45 = i;
    param_1 = _e45 + metal::float2(1.0, 0.0);
    float _e47 = random(param_1);
    b = _e47;
    metal::float2 _e48 = i;
    param_2 = _e48 + metal::float2(0.0, 1.0);
    float _e50 = random(param_2);
    c = _e50;
    metal::float2 _e51 = i;
    param_3 = _e51 + metal::float2(1.0, 1.0);
    float _e53 = random(param_3);
    d = _e53;
    metal::float2 _e54 = f;
    metal::float2 _e55 = f;
    metal::float2 _e57 = f;
    u = (_e54 * _e55) * (metal::float2(3.0) - (_e57 * 2.0));
    float _e62 = a;
    float _e63 = b;
    float _e65 = u[0u];
    float _e67 = c;
    float _e68 = a;
    float _e71 = u[1u];
    float _e74 = u[0u];
    float _e78 = d;
    float _e79 = b;
    float _e82 = u[0u];
    float _e85 = u[1u];
    return (metal::mix(_e62, _e63, _e65) + (((_e67 - _e68) * _e71) * (1.0 - _e74))) + (((_e78 - _e79) * _e82) * _e85);
}

float fbm(
    thread metal::float2& st_2
) {
    float value = {};
    float amplitude = {};
    int i_1 = {};
    metal::float2 param_4 = {};
    value = 0.0;
    amplitude = 0.5;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e44 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e44) + as_type<uint>(1));
        }
        loop_init = false;
        int _e32 = i_1;
        if (_e32 < 4) {
            float _e34 = amplitude;
            metal::float2 _e35 = st_2;
            param_4 = _e35;
            float _e36 = noise(param_4);
            float _e38 = value;
            value = _e38 + (_e34 * _e36);
            metal::float2 _e40 = st_2;
            st_2 = _e40 * 2.0;
            float _e42 = amplitude;
            amplitude = _e42 * 0.5;
            continue;
        } else {
            break;
        }
    }
    float _e46 = value;
    return _e46;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e29 = uv[0u];
    float _e31 = uv[1u];
    metal::float4 _e34 = _to.sample(_sampler, metal::float2(_e29, 1.0 - _e31), metal::level(0.0));
    return _e34;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e29 = uv_1[0u];
    float _e31 = uv_1[1u];
    metal::float4 _e34 = _from.sample(_sampler, metal::float2(_e29, 1.0 - _e31), metal::level(0.0));
    return _e34;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float4 from = {};
    metal::float2 param_7 = {};
    metal::float4 to = {};
    metal::float2 param_8 = {};
    float n = {};
    metal::float2 param_9 = {};
    float l = {};
    float edge = {};
    float _e39 = uniforms.progress;
    if (_e39 <= 0.0) {
        metal::float2 _e41 = uv_2;
        param_5 = _e41;
        metal::float4 _e42 = getFromColor(param_5, _from, _sampler);
        return _e42;
    }
    float _e44 = uniforms.progress;
    if (_e44 >= 1.0) {
        metal::float2 _e46 = uv_2;
        param_6 = _e46;
        metal::float4 _e47 = getToColor(param_6, _sampler, _to);
        return _e47;
    }
    metal::float2 _e48 = uv_2;
    param_7 = _e48;
    metal::float4 _e49 = getFromColor(param_7, _from, _sampler);
    from = _e49;
    metal::float2 _e50 = uv_2;
    param_8 = _e50;
    metal::float4 _e51 = getToColor(param_8, _sampler, _to);
    to = _e51;
    metal::float2 _e52 = uv_2;
    param_9 = _e52 * 4.0;
    float _e54 = fbm(param_9);
    n = _e54;
    float _e56 = uniforms.progress;
    float _e58 = uniforms.progress;
    float _e60 = n;
    l = metal::smoothstep(_e56, _e58 + 0.05, _e60);
    float _e62 = l;
    float _e64 = l;
    edge = ((1.0 - _e62) * _e64) * 5.0;
    metal::float4 _e67 = to;
    metal::float4 _e68 = from;
    float _e69 = l;
    metal::float3 _e73 = uniforms.burnColor;
    float _e78 = edge;
    return metal::mix(_e67, _e68, metal::float4(_e69)) + (metal::float4(_e73.x, _e73.y, _e73.z, 0.0) * _e78);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_10 = {};
    metal::float2 _e28 = _uv_1;
    param_10 = _e28;
    metal::float4 _e29 = transition(param_10, _from, _sampler, _to, uniforms);
    _fragColor = _e29;
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
