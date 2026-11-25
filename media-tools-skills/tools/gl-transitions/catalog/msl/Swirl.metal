// Swirl — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Swirl.glsl
// Author: Sergey Kosarevsky
// License: MIT
// Description: The image twists into a round swirl around the center that peaks mid-way, where the outgoing image dissolves into the incoming one, then untwists
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
    float radius;
    metal::float2 center;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e31 = uv[0u];
    float _e33 = uv[1u];
    metal::float4 _e36 = _to.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e31 = uv_1[0u];
    float _e33 = uv_1[1u];
    metal::float4 _e36 = _from.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float2 mirrored(
    thread metal::float2& v
) {
    metal::float2 m = {};
    metal::float2 _e31 = v;
    metal::float2 _e32 = metal::float2(2.0);
    m = _e31 - (metal::floor(_e31 / _e32) * _e32);
    metal::float2 _e37 = m;
    metal::float2 _e38 = m;
    metal::float2 _e41 = m;
    return metal::mix(_e37, metal::float2(2.0) - _e38, metal::step(metal::float2(1.0), _e41));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float s = {};
    float amount = {};
    float speed = {};
    float reveal = {};
    metal::float2 aspect = {};
    metal::float2 d = {};
    float x = {};
    float falloff = {};
    float twist = {};
    float angle = {};
    float spread = {};
    metal::float4 col = {};
    float total = {};
    int i = {};
    float k = {};
    float w = {};
    float a = {};
    float c = {};
    float sn = {};
    metal::float2 q = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float _e54 = uniforms.progress;
    s = metal::sin(3.1415927 * _e54);
    float _e57 = s;
    float _e58 = s;
    amount = _e57 * _e58;
    float _e61 = uniforms.progress;
    speed = 3.1415927 * metal::sin(6.2831855 * _e61);
    float _e66 = uniforms.progress;
    reveal = metal::smoothstep(0.3, 0.7, _e66);
    float _e69 = uniforms.ratio;
    aspect = metal::float2(_e69, 1.0);
    metal::float2 _e71 = uv_2;
    metal::float2 _e73 = uniforms.center;
    metal::float2 _e75 = aspect;
    d = (_e71 - _e73) * _e75;
    metal::float2 _e77 = d;
    float _e80 = uniforms.radius;
    x = metal::clamp(metal::length(_e77) / metal::max(_e80, 0.001), 0.0, 1.0);
    float _e84 = x;
    float _e86 = x;
    falloff = (1.0 - _e84) * (1.0 - _e86);
    float _e90 = uniforms.strength;
    float _e92 = falloff;
    twist = (_e90 * 6.2831855) * _e92;
    float _e94 = twist;
    float _e95 = amount;
    angle = _e94 * _e95;
    float _e97 = twist;
    float _e98 = speed;
    spread = metal::clamp((_e97 * _e98) * 0.05, -1.2, 1.2);
    float _e102 = amount;
    float _e104 = falloff;
    metal::float2 _e107 = d;
    d = _e107 * (1.0 - ((0.12 * _e102) * _e104));
    col = metal::float4(0.0, 0.0, 0.0, 0.0);
    total = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e166 = i;
            i = as_type<int>(as_type<uint>(_e166) + as_type<uint>(1));
        }
        loop_init = false;
        int _e109 = i;
        if (_e109 < 12) {
            int _e111 = i;
            k = (static_cast<float>(_e111) / 11.0) - 0.5;
            float _e115 = k;
            w = 1.0 - metal::abs(_e115);
            float _e118 = angle;
            float _e119 = spread;
            float _e120 = k;
            a = _e118 + (_e119 * _e120);
            float _e123 = a;
            c = metal::cos(_e123);
            float _e125 = a;
            sn = metal::sin(_e125);
            metal::float2 _e128 = uniforms.center;
            float _e129 = c;
            float _e131 = d[0u];
            float _e133 = sn;
            float _e135 = d[1u];
            float _e138 = sn;
            float _e140 = d[0u];
            float _e142 = c;
            float _e144 = d[1u];
            metal::float2 _e148 = aspect;
            param = _e128 + (metal::float2((_e129 * _e131) - (_e133 * _e135), (_e138 * _e140) + (_e142 * _e144)) / _e148);
            metal::float2 _e151 = mirrored(param);
            q = _e151;
            metal::float2 _e152 = q;
            param_1 = _e152;
            metal::float4 _e153 = getFromColor(param_1, _from, _sampler);
            metal::float2 _e154 = q;
            param_2 = _e154;
            metal::float4 _e155 = getToColor(param_2, _sampler, _to);
            float _e156 = reveal;
            float _e159 = w;
            metal::float4 _e161 = col;
            col = _e161 + (metal::mix(_e153, _e155, metal::float4(_e156)) * _e159);
            float _e163 = w;
            float _e164 = total;
            total = _e164 + _e163;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e168 = col;
    float _e169 = total;
    return _e168 / metal::float4(_e169);
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
    metal::float2 _e30 = _uv_1;
    param_3 = _e30;
    metal::float4 _e31 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e31;
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
