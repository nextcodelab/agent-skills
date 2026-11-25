// TvRoll — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvRoll.glsl
// Author: gre
// License: MIT
// Description: The outgoing image rolls faster and faster, like an old TV losing its vertical hold, then the roll slows down and locks on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int rolls;
    float barHeight;
    metal::float4 barColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e34 = uv[0u];
    float _e36 = uv[1u];
    metal::float4 _e39 = _to.sample(_sampler, metal::float2(_e34, 1.0 - _e36), metal::level(0.0));
    return _e39;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e34 = uv_1[0u];
    float _e36 = uv_1[1u];
    metal::float4 _e39 = _from.sample(_sampler, metal::float2(_e34, 1.0 - _e36), metal::level(0.0));
    return _e39;
}

metal::float4 picture(
    thread metal::float2& uv_2,
    thread float& y,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float period = {};
    metal::float2 q = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e40 = uniforms.barHeight;
    period = 1.0 + _e40;
    float _e42 = y;
    float _e43 = period;
    y = _e42 - (metal::floor(_e42 / _e43) * _e43);
    float _e48 = y;
    if (_e48 > 1.0) {
        metal::float4 _e51 = uniforms.barColor;
        return _e51;
    }
    float _e53 = uv_2[0u];
    float _e54 = y;
    q = metal::float2(_e53, _e54);
    metal::float2 _e56 = q;
    param = _e56;
    metal::float4 _e57 = getFromColor(param, _from, _sampler);
    metal::float2 _e58 = q;
    param_1 = _e58;
    metal::float4 _e59 = getToColor(param_1, _sampler, _to);
    float _e60 = m;
    return metal::mix(_e57, _e59, metal::float4(_e60));
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float period_1 = {};
    float s = {};
    float offset = {};
    float speed = {};
    float m_1 = {};
    metal::float2 p = {};
    metal::float4 c = {};
    int i = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float scan = {};
    float flicker = {};
    float _e47 = uniforms.barHeight;
    period_1 = 1.0 + _e47;
    float _e50 = uniforms.progress;
    float _e52 = uniforms.progress;
    float _e55 = uniforms.progress;
    s = (_e50 * _e52) * (3.0 - (2.0 * _e55));
    float _e59 = period_1;
    int _e61 = uniforms.rolls;
    float _e63 = s;
    offset = _e59 * metal::fract(static_cast<float>(_e61) * _e63);
    float _e68 = uniforms.progress;
    float _e71 = uniforms.progress;
    speed = (4.0 * _e68) * (1.0 - _e71);
    float _e75 = uniforms.progress;
    m_1 = metal::smoothstep(0.42, 0.58, _e75);
    metal::float2 _e77 = uv_3;
    float _e78 = speed;
    float _e81 = uv_3[1u];
    float _e84 = uniforms.progress;
    p = _e77 + metal::float2((0.004 * _e78) * metal::sin((_e81 * 9.0) + (_e84 * 30.0)), 0.0);
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e112 = i;
            i = as_type<int>(as_type<uint>(_e112) + as_type<uint>(1));
        }
        loop_init = false;
        int _e91 = i;
        if (_e91 < 5) {
            float _e94 = p[1u];
            float _e95 = offset;
            int _e98 = uniforms.rolls;
            float _e101 = speed;
            int _e103 = i;
            metal::float2 _e107 = p;
            param_2 = _e107;
            param_3 = (_e94 + _e95) - (((0.0015 * static_cast<float>(_e98)) * _e101) * static_cast<float>(_e103));
            float _e108 = m_1;
            param_4 = _e108;
            metal::float4 _e109 = picture(param_2, param_3, param_4, _from, _sampler, _to, uniforms);
            metal::float4 _e110 = c;
            c = _e110 + _e109;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e114 = c;
    c = _e114 / metal::float4(5.0);
    float _e118 = uv_3[1u];
    scan = 0.5 + (0.5 * metal::sin(_e118 * 400.0));
    float _e124 = uniforms.progress;
    flicker = 0.08 * (0.5 + (0.5 * metal::sin(_e124 * 97.0)));
    float _e130 = speed;
    float _e131 = scan;
    float _e133 = flicker;
    metal::float4 _e137 = c;
    metal::float3 _e139 = _e137.xyz * (1.0 - (_e130 * ((0.08 * _e131) + _e133)));
    c[0u] = _e139.x;
    c[1u] = _e139.y;
    c[2u] = _e139.z;
    metal::float4 _e146 = c;
    return _e146;
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
    metal::float2 _e33 = _uv_1;
    param_5 = _e33;
    metal::float4 _e34 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e34;
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
