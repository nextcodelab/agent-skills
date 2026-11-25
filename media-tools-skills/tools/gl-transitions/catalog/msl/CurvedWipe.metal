// CurvedWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CurvedWipe.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is pulled away by its middle: the wipe edge bulges into a smooth curve that leads the way, then flattens as it reaches the far side
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float curvature;
    float smoothness;
    char _pad5[8];
    metal::float4 shadow;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e29 = uv[0u];
    float _e31 = uv[1u];
    metal::float4 _e34 = _from.sample(_sampler, metal::float2(_e29, 1.0 - _e31), metal::level(0.0));
    return _e34;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e29 = uv_1[0u];
    float _e31 = uv_1[1u];
    metal::float4 _e34 = _to.sample(_sampler, metal::float2(_e29, 1.0 - _e31), metal::level(0.0));
    return _e34;
}

float ease(
    thread float& t
) {
    float _e28 = t;
    float _e29 = t;
    float _e30 = t;
    float _e32 = t;
    return 0.5 * (_e28 + ((_e29 * _e30) * (3.0 - (2.0 * _e32))));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 p = {};
    float e = {};
    float w = {};
    metal::float2 across = {};
    float d = {};
    float x = {};
    float s = {};
    float k = {};
    float t_1 = {};
    float travel = {};
    float edge = {};
    float param = {};
    float side = {};
    float param_1 = {};
    float m = {};
    float lift = {};
    float spread = {};
    metal::float4 to = {};
    metal::float2 param_2 = {};
    metal::float2 caster = {};
    float sh = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 _e54 = uniforms.direction;
    if (metal::length(_e54) > 0.0) {
        metal::float2 _e58 = uniforms.direction;
        local = metal::normalize(_e58);
    } else {
        local = metal::float2(0.0, 1.0);
    }
    metal::float2 _e60 = local;
    dir = _e60;
    metal::float2 _e61 = uv_2;
    float _e65 = uniforms.ratio;
    p = (_e61 - metal::float2(0.5)) * metal::float2(_e65, 1.0);
    float _e69 = dir[0u];
    float _e72 = uniforms.ratio;
    float _e75 = dir[1u];
    e = 0.5 * ((metal::abs(_e69) * _e72) + metal::abs(_e75));
    float _e80 = dir[1u];
    float _e83 = uniforms.ratio;
    float _e86 = dir[0u];
    w = 0.5 * ((metal::abs(_e80) * _e83) + metal::abs(_e86));
    float _e91 = dir[1u];
    float _e94 = dir[0u];
    across = metal::float2(-(_e91), _e94);
    metal::float2 _e96 = p;
    metal::float2 _e97 = dir;
    d = metal::dot(_e96, _e97);
    metal::float2 _e99 = p;
    metal::float2 _e100 = across;
    float _e102 = w;
    x = metal::clamp(metal::dot(_e99, _e100) / _e102, -1.0, 1.0);
    float _e106 = uniforms.smoothness;
    s = metal::max(_e106, 0.001);
    float _e109 = uniforms.curvature;
    float _e111 = w;
    float _e112 = e;
    float _e116 = x;
    float _e117 = x;
    k = (metal::clamp(_e109, 0.0, 1.0) * metal::min(1.0, _e111 / _e112)) * (1.0 - (_e116 * _e117));
    float _e122 = uniforms.progress;
    float _e123 = k;
    float _e125 = uniforms.progress;
    float _e128 = uniforms.progress;
    t_1 = _e122 + ((_e123 * _e125) * (1.0 - _e128));
    float _e132 = e;
    float _e133 = s;
    travel = 2.0 * (_e132 + _e133);
    float _e136 = e;
    float _e138 = s;
    float _e140 = travel;
    float _e141 = t_1;
    param = _e141;
    float _e142 = ease(param);
    edge = (-(_e136) - _e138) + (_e140 * _e142);
    float _e145 = e;
    float _e147 = s;
    float _e149 = travel;
    float _e151 = uniforms.progress;
    param_1 = _e151;
    float _e152 = ease(param_1);
    side = (-(_e145) - _e147) + (_e149 * _e152);
    float _e155 = s;
    float _e157 = s;
    float _e158 = d;
    float _e159 = edge;
    m = 1.0 - metal::smoothstep(-(_e155), _e157, _e158 - _e159);
    float _e163 = edge;
    float _e164 = side;
    lift = _e163 - _e164;
    float _e166 = lift;
    spread = 0.012 + (0.25 * _e166);
    metal::float2 _e169 = uv_2;
    param_2 = _e169;
    metal::float4 _e170 = getToColor(param_2, _sampler, _to);
    to = _e170;
    metal::float2 _e171 = p;
    float _e172 = edge;
    float _e173 = d;
    metal::float2 _e175 = dir;
    float _e179 = uniforms.ratio;
    caster = metal::clamp(((_e171 + (_e175 * (_e172 - _e173))) / metal::float2(_e179, 1.0)) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
    float _e189 = uniforms.shadow[3u];
    float _e191 = uniforms.progress;
    float _e195 = edge;
    float _e196 = d;
    float _e200 = spread;
    float _e204 = m;
    metal::float2 _e206 = caster;
    param_3 = _e206;
    metal::float4 _e207 = getFromColor(param_3, _from, _sampler);
    float _e211 = to[3u];
    sh = ((((_e189 * metal::sin(3.1415927 * _e191)) * metal::exp(-(metal::max(_e195 - _e196, 0.0)) / _e200)) * _e204) * _e207.w) * _e211;
    metal::float4 _e213 = to;
    metal::float4 _e216 = uniforms.shadow;
    float _e218 = sh;
    metal::float3 _e220 = metal::mix(_e213.xyz, _e216.xyz, metal::float3(_e218));
    to[0u] = _e220.x;
    to[1u] = _e220.y;
    to[2u] = _e220.z;
    metal::float2 _e227 = uv_2;
    param_4 = _e227;
    metal::float4 _e228 = getFromColor(param_4, _from, _sampler);
    metal::float4 _e229 = to;
    float _e230 = m;
    return metal::mix(_e228, _e229, metal::float4(_e230));
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
    metal::float2 _e28 = _uv_1;
    param_5 = _e28;
    metal::float4 _e29 = transition(param_5, _from, _sampler, _to, uniforms);
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
