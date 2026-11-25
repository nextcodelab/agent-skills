// StretchSlide — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StretchSlide.glsl
// Author: gre
// License: MIT
// Description: The outgoing image stretches out long as it shoots away to one side, pulling in the incoming one squashed behind it, which overshoots and springs back to its shape
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float stretch;
    float bounce;
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

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e28 = v;
    metal::float2 _e29 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e28 - (metal::floor(_e28 / _e29) * _e29)));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dl = {};
    metal::float2 d = {};
    metal::float2 local = {};
    metal::float2 n = {};
    float ext = {};
    metal::float2 q = {};
    float s = {};
    float t = {};
    float land = {};
    float m = {};
    float x = {};
    float e = {};
    float w = {};
    float u = {};
    float osc = {};
    float len = {};
    float bulge = {};
    float g = {};
    metal::float2 pt = {};
    metal::float4 b = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float l = {};
    float k = {};
    float y = {};
    float v_1 = {};
    metal::float4 a = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e58 = uniforms.direction;
    dl = metal::length(_e58);
    float _e60 = dl;
    if (_e60 > 0.000001) {
        metal::float2 _e63 = uniforms.direction;
        float _e64 = dl;
        local = _e63 / metal::float2(_e64);
    } else {
        local = metal::float2(-1.0, 0.0);
    }
    metal::float2 _e67 = local;
    d = _e67;
    float _e69 = d[1u];
    float _e72 = d[0u];
    n = metal::float2(-(_e69), _e72);
    float _e75 = d[0u];
    float _e78 = d[1u];
    ext = metal::abs(_e75) + metal::abs(_e78);
    metal::float2 _e81 = uv_2;
    q = _e81 - metal::float2(0.5);
    metal::float2 _e84 = q;
    metal::float2 _e85 = d;
    float _e87 = ext;
    s = 0.5 + (metal::dot(_e84, _e85) / _e87);
    float _e91 = uniforms.progress;
    t = _e91;
    float _e93 = uniforms.bounce;
    land = metal::mix(1.0, 0.5, _e93);
    float _e96 = uniforms.bounce;
    m = 3.0 * _e96;
    float _e98 = t;
    float _e99 = land;
    x = metal::clamp(_e98 / _e99, 0.0, 1.0);
    float _e102 = x;
    float _e103 = x;
    float _e105 = x;
    float _e109 = m;
    float _e110 = x;
    float _e112 = x;
    float _e114 = x;
    e = ((_e102 * _e103) * (3.0 - (2.0 * _e105))) + (((_e109 * _e110) * _e112) * (_e114 - 1.0));
    w = 7.8539815;
    float _e118 = t;
    float _e119 = land;
    float _e121 = land;
    u = metal::clamp((_e118 - _e119) / metal::max(1.0 - _e121, 0.0001), 0.0, 1.0);
    float _e126 = m;
    float _e127 = land;
    float _e130 = land;
    float _e131 = w;
    float _e134 = u;
    float _e138 = w;
    float _e139 = u;
    float _e143 = u;
    float _e146 = u;
    osc = (((((_e126 * (1.0 - _e127)) / (_e130 * _e131)) * metal::exp(-(_e134))) * metal::sin(_e138 * _e139)) * (1.0 - _e143)) * (1.0 - _e146);
    float _e149 = e;
    float _e150 = osc;
    len = _e149 + metal::max(_e150, 0.0);
    float _e153 = e;
    float _e155 = osc;
    bulge = (1.0 - _e153) + (3.0 * metal::max(-(_e155), 0.0));
    float _e161 = uniforms.stretch;
    float _e163 = bulge;
    g = 1.0 + ((0.6 * _e161) * _e163);
    metal::float2 _e166 = q;
    metal::float2 _e167 = d;
    float _e168 = s;
    float _e169 = len;
    float _e172 = s;
    float _e175 = ext;
    pt = _e166 + ((_e167 * ((_e168 / metal::max(_e169, 0.0001)) - _e172)) * _e175);
    metal::float2 _e178 = n;
    metal::float2 _e179 = pt;
    metal::float2 _e180 = n;
    float _e183 = g;
    metal::float2 _e187 = pt;
    pt = _e187 - ((_e178 * metal::dot(_e179, _e180)) * (1.0 - (1.0 / _e183)));
    metal::float2 _e189 = pt;
    param = _e189 + metal::float2(0.5);
    metal::float2 _e192 = mirror(param);
    param_1 = _e192;
    metal::float4 _e193 = getToColor(param_1, _sampler, _to);
    b = _e193;
    float _e195 = uniforms.stretch;
    float _e197 = e;
    l = 1.0 + ((4.0 * _e195) * _e197);
    float _e201 = uniforms.stretch;
    float _e203 = e;
    k = metal::clamp((1.6 * _e201) * _e203, 0.0, 0.8);
    float _e206 = s;
    float _e207 = e;
    float _e210 = l;
    y = metal::max(_e206 - _e207, 0.0) / _e210;
    float _e212 = y;
    float _e214 = k;
    float _e216 = k;
    float _e218 = k;
    float _e221 = k;
    float _e223 = y;
    v_1 = (2.0 * _e212) / ((1.0 + _e214) + metal::sqrt(((1.0 + _e216) * (1.0 + _e218)) - ((4.0 * _e221) * _e223)));
    metal::float2 _e229 = q;
    metal::float2 _e230 = d;
    float _e231 = v_1;
    float _e232 = s;
    float _e235 = ext;
    param_2 = (_e229 + ((_e230 * (_e231 - _e232)) * _e235)) + metal::float2(0.5);
    metal::float2 _e240 = mirror(param_2);
    param_3 = _e240;
    metal::float4 _e241 = getFromColor(param_3, _from, _sampler);
    a = _e241;
    float _e242 = s;
    float _e243 = len;
    float _e245 = t;
    float _e246 = land;
    metal::float4 _e249 = b;
    metal::float4 _e250 = a;
    return metal::select(_e250, _e249, metal::bool4((_e242 < _e243) || (_e245 >= _e246)));
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
    metal::float2 _e28 = _uv_1;
    param_4 = _e28;
    metal::float4 _e29 = transition(param_4, _from, _sampler, _to, uniforms);
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
