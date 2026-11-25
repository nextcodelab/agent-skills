// PhotoDevelop — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PhotoDevelop.glsl
// Author: gre
// License: MIT
// Description: The outgoing image washes out to a blank cream card, then the incoming image develops on it like an instant photo: shadows first, faint and tinted, then its contrast and colors come up and it settles
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float4 card;
    float wash;
    float tint;
    char _pad5[8];
};

metal::float3 saturation(
    thread metal::float3& c,
    thread float& s
) {
    float lum = {};
    metal::float3 _e45 = c;
    lum = metal::dot(_e45, metal::float3(0.2126, 0.7152, 0.0722));
    float _e47 = lum;
    metal::float3 _e49 = c;
    float _e50 = s;
    return metal::mix(metal::float3(_e47), _e49, metal::float3(_e50));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e44 = uv[0u];
    float _e46 = uv[1u];
    metal::float4 _e49 = _to.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e44 = uv_1[0u];
    float _e46 = uv_1[1u];
    metal::float4 _e49 = _from.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
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
    float p = {};
    float split = {};
    float cardAlpha = {};
    metal::float3 cardColor = {};
    float w = {};
    float fromLum = {};
    float wl = {};
    metal::float3 washed = {};
    metal::float3 outgoing = {};
    float outAlpha = {};
    float x = {};
    float d = {};
    float lum_1 = {};
    float dev = {};
    float early = {};
    metal::float3 tinted = {};
    metal::float3 param_2 = {};
    float param_3 = {};
    metal::float3 tone = {};
    metal::float3 incoming = {};
    float inAlpha = {};
    metal::float3 color = {};
    float alpha = {};
    metal::float2 _e70 = uv_2;
    param = _e70;
    metal::float4 _e71 = getFromColor(param, _from, _sampler);
    a = _e71;
    metal::float2 _e72 = uv_2;
    param_1 = _e72;
    metal::float4 _e73 = getToColor(param_1, _sampler, _to);
    b = _e73;
    float _e75 = uniforms.progress;
    p = _e75;
    float _e76 = p;
    if (_e76 <= 0.0) {
        metal::float4 _e78 = a;
        return _e78;
    }
    float _e79 = p;
    if (_e79 >= 1.0) {
        metal::float4 _e81 = b;
        return _e81;
    }
    float _e83 = uniforms.wash;
    split = metal::mix(0.1, 0.7, metal::clamp(_e83, 0.0, 1.0));
    float _e88 = uniforms.card[3u];
    float _e90 = a[3u];
    float _e92 = b[3u];
    float _e93 = split;
    float _e95 = split;
    float _e97 = p;
    cardAlpha = _e88 * metal::mix(_e90, _e92, metal::smoothstep(0.6 * _e93, _e95 + 0.1, _e97));
    metal::float4 _e102 = uniforms.card;
    float _e104 = cardAlpha;
    cardColor = _e102.xyz * _e104;
    float _e106 = split;
    float _e107 = p;
    w = metal::smoothstep(0.0, _e106, _e107);
    metal::float4 _e109 = a;
    fromLum = metal::dot(_e109.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    float _e112 = w;
    float _e113 = fromLum;
    wl = metal::clamp(_e112 * (1.0 + (0.5 * _e113)), 0.0, 1.0);
    metal::float4 _e118 = a;
    float _e120 = fromLum;
    metal::float4 _e122 = a;
    float _e126 = w;
    float _e130 = a[3u];
    washed = metal::mix(_e118.xyz, metal::mix(metal::float3(_e120), _e122.xyz, metal::float3(0.4)), metal::float3(_e126)) * _e130;
    metal::float3 _e132 = washed;
    metal::float3 _e133 = cardColor;
    float _e134 = wl;
    outgoing = metal::mix(_e132, _e133, metal::float3(_e134));
    float _e138 = a[3u];
    float _e139 = cardAlpha;
    float _e140 = wl;
    outAlpha = metal::mix(_e138, _e139, _e140);
    float _e142 = p;
    float _e143 = split;
    float _e145 = split;
    x = metal::clamp((_e142 - _e143) / metal::max(1.0 - _e145, 0.001), 0.0, 1.0);
    float _e150 = x;
    d = 1.0 - metal::pow(1.0 - _e150, 1.5);
    metal::float4 _e154 = b;
    lum_1 = metal::dot(_e154.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    float _e157 = d;
    float _e158 = lum_1;
    dev = metal::clamp((_e157 - (0.45 * _e158)) / 0.55, 0.0, 1.0);
    float _e163 = dev;
    float _e164 = dev;
    float _e166 = dev;
    dev = (_e163 * _e164) * (3.0 - (2.0 * _e166));
    float _e170 = d;
    early = 1.0 - metal::smoothstep(0.2, 0.95, _e170);
    float _e173 = d;
    metal::float4 _e175 = b;
    param_2 = _e175.xyz;
    param_3 = metal::smoothstep(0.3, 1.0, _e173);
    metal::float3 _e177 = saturation(param_2, param_3);
    tinted = _e177;
    metal::float3 _e178 = tinted;
    float _e179 = d;
    tinted = metal::mix(metal::float3(0.6, 0.6, 0.6), _e178, metal::float3(metal::mix(0.55, 1.0, _e179)));
    float _e183 = lum_1;
    tone = metal::mix(metal::float3(-0.2, 0.06, 0.1), metal::float3(0.12, -0.1, 0.06), metal::float3(metal::smoothstep(0.15, 0.6, _e183)));
    metal::float3 _e187 = tone;
    float _e189 = uniforms.tint;
    float _e191 = early;
    metal::float3 _e193 = tinted;
    tinted = _e193 + ((_e187 * _e189) * _e191);
    metal::float3 _e195 = cardColor;
    metal::float3 _e196 = tinted;
    float _e201 = b[3u];
    float _e203 = dev;
    incoming = metal::mix(_e195, metal::clamp(_e196, metal::float3(0.0), metal::float3(1.0)) * _e201, metal::float3(_e203));
    float _e206 = cardAlpha;
    float _e208 = b[3u];
    float _e209 = dev;
    inAlpha = metal::mix(_e206, _e208, _e209);
    float _e211 = p;
    float _e212 = split;
    metal::float3 _e214 = outgoing;
    metal::float3 _e215 = incoming;
    color = metal::select(_e215, _e214, metal::bool3(_e211 < _e212));
    float _e218 = p;
    float _e219 = split;
    float _e221 = outAlpha;
    float _e222 = inAlpha;
    alpha = (_e218 < _e219) ? _e221 : _e222;
    float _e224 = alpha;
    if (_e224 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float3 _e226 = color;
    float _e227 = alpha;
    metal::float3 _e232 = metal::clamp(_e226 / metal::float3(_e227), metal::float3(0.0), metal::float3(1.0));
    float _e233 = alpha;
    return metal::float4(_e232.x, _e232.y, _e232.z, _e233);
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
    metal::float2 _e43 = _uv_1;
    param_4 = _e43;
    metal::float4 _e44 = transition(param_4, _from, _sampler, _to, uniforms);
    _fragColor = _e44;
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
