// RibbonTwist — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RibbonTwist.glsl
// Author: gre
// License: MIT
// Description: The image twists like a ribbon around its horizontal center line, the twist travelling smoothly across its width, the outgoing image on its front and the incoming one on its back
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float spread;
    float perspective;
    float shading;
    int vertical;
    char _pad6[8];
    metal::float4 backColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e27 = uv[0u];
    float _e29 = uv[1u];
    metal::float4 _e32 = _to.sample(_sampler, metal::float2(_e27, 1.0 - _e29), metal::level(0.0));
    return _e32;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e27 = uv_1[0u];
    float _e29 = uv_1[1u];
    metal::float4 _e32 = _from.sample(_sampler, metal::float2(_e27, 1.0 - _e29), metal::level(0.0));
    return _e32;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 q = {};
    metal::float2 local = {};
    float halfSize = {};
    float local_1 = {};
    float t = {};
    bool front = {};
    float angle = {};
    float local_2 = {};
    float c = {};
    float s = {};
    float w = {};
    float den = {};
    float v = {};
    float edge = {};
    float top = {};
    float bottom = {};
    float cover = {};
    metal::float2 p = {};
    metal::float2 local_3 = {};
    metal::float4 img = {};
    metal::float4 local_4 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float lambert = {};
    metal::float4 color = {};
    int _e52 = uniforms.vertical;
    if (_e52 != 0) {
        float _e55 = uv_2[1u];
        float _e58 = uv_2[0u];
        local = metal::float2(1.0 - _e55, _e58);
    } else {
        metal::float2 _e60 = uv_2;
        local = _e60;
    }
    metal::float2 _e61 = local;
    q = _e61;
    int _e63 = uniforms.vertical;
    if (_e63 != 0) {
        float _e66 = uniforms.ratio;
        local_1 = 0.5 * _e66;
    } else {
        local_1 = 0.5;
    }
    float _e68 = local_1;
    halfSize = _e68;
    float _e70 = uniforms.progress;
    float _e72 = uniforms.spread;
    float _e76 = q[0u];
    float _e79 = uniforms.spread;
    t = metal::smoothstep(0.0, 1.0, ((_e70 * (1.0 + _e72)) - _e76) / _e79);
    float _e82 = t;
    front = _e82 < 0.5;
    bool _e84 = front;
    if (_e84) {
        float _e85 = t;
        local_2 = _e85;
    } else {
        float _e86 = t;
        local_2 = _e86 - 1.0;
    }
    float _e88 = local_2;
    angle = 3.1415927 * _e88;
    float _e90 = angle;
    c = metal::cos(_e90);
    float _e92 = angle;
    s = metal::sin(_e92);
    float _e95 = q[1u];
    w = (2.0 * _e95) - 1.0;
    float _e98 = c;
    float _e100 = uniforms.perspective;
    float _e101 = w;
    float _e103 = s;
    den = _e98 + ((_e100 * _e101) * _e103);
    float _e106 = den;
    if (_e106 <= 0.0) {
        metal::float4 _e109 = uniforms.backColor;
        return _e109;
    }
    float _e110 = w;
    float _e111 = den;
    v = _e110 / _e111;
    float _e113 = v;
    if (metal::abs(_e113) >= 1.0) {
        metal::float4 _e117 = uniforms.backColor;
        return _e117;
    }
    float _e118 = s;
    edge = metal::max(0.002 * metal::min(1.0, 20.0 * metal::abs(_e118)), 0.0001);
    float _e124 = c;
    float _e126 = uniforms.perspective;
    float _e127 = s;
    top = _e124 / (1.0 - (_e126 * _e127));
    float _e131 = c;
    float _e134 = uniforms.perspective;
    float _e135 = s;
    bottom = -(_e131) / (1.0 + (_e134 * _e135));
    float _e139 = top;
    float _e140 = w;
    float _e142 = w;
    float _e143 = bottom;
    float _e146 = halfSize;
    float _e148 = edge;
    cover = metal::clamp((metal::min(_e139 - _e140, _e142 - _e143) * _e146) / _e148, 0.0, 1.0);
    float _e152 = q[0u];
    float _e153 = v;
    p = metal::float2(_e152, 0.5 + (0.5 * _e153));
    int _e158 = uniforms.vertical;
    if (_e158 != 0) {
        float _e161 = p[1u];
        float _e163 = p[0u];
        local_3 = metal::float2(_e161, 1.0 - _e163);
    } else {
        metal::float2 _e166 = p;
        local_3 = _e166;
    }
    metal::float2 _e167 = local_3;
    p = _e167;
    bool _e168 = front;
    if (_e168) {
        metal::float2 _e169 = p;
        param = _e169;
        metal::float4 _e170 = getFromColor(param, _from, _sampler);
        local_4 = _e170;
    } else {
        metal::float2 _e171 = p;
        param_1 = _e171;
        metal::float4 _e172 = getToColor(param_1, _sampler, _to);
        local_4 = _e172;
    }
    metal::float4 _e173 = local_4;
    img = _e173;
    float _e174 = c;
    float _e175 = s;
    lambert = metal::clamp(_e174 - (0.25 * _e175), 0.0, 1.0);
    metal::float4 _e179 = img;
    float _e182 = uniforms.shading;
    float _e184 = lambert;
    metal::float3 _e186 = _e179.xyz * metal::mix(1.0 - _e182, 1.0, _e184);
    float _e188 = img[3u];
    color = metal::float4(_e186.x, _e186.y, _e186.z, _e188);
    metal::float4 _e194 = uniforms.backColor;
    metal::float4 _e195 = color;
    float _e196 = cover;
    return metal::mix(_e194, _e195, metal::float4(_e196));
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
    metal::float2 _e26 = _uv_1;
    param_2 = _e26;
    metal::float4 _e27 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e27;
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
