// TvTurnOff — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvTurnOff.glsl
// Author: gre
// License: MIT
// Description: The outgoing image collapses into a glowing line and a dot, like an old TV turned off, then the incoming image powers on from the dot
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    char _pad2[8];
    metal::float4 color;
    float glow;
    char _pad4[12];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e36 = uv[0u];
    float _e38 = uv[1u];
    metal::float4 _e41 = _to.sample(_sampler, metal::float2(_e36, 1.0 - _e38), metal::level(0.0));
    return _e41;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e36 = uv_1[0u];
    float _e38 = uv_1[1u];
    metal::float4 _e41 = _from.sample(_sampler, metal::float2(_e36, 1.0 - _e38), metal::level(0.0));
    return _e41;
}

metal::float4 getColor(
    thread metal::float2& uv_2,
    thread bool& isFrom,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool _e39 = isFrom;
    if (_e39) {
        metal::float2 _e40 = uv_2;
        param = _e40;
        metal::float4 _e41 = getFromColor(param, _from, _sampler);
        local = _e41;
    } else {
        metal::float2 _e42 = uv_2;
        param_1 = _e42;
        metal::float4 _e43 = getToColor(param_1, _sampler, _to);
        local = _e43;
    }
    metal::float4 _e44 = local;
    return _e44;
}

metal::float4 screen(
    thread metal::float2& uv_3,
    thread float& t,
    thread bool& isFrom_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float collapse = {};
    float shrink = {};
    float fade = {};
    float radius = {};
    metal::float2 size = {};
    metal::float2 p = {};
    metal::float2 q = {};
    metal::float4 c = {};
    metal::float2 param_2 = {};
    bool param_3 = {};
    float white = {};
    metal::float4 light = {};
    metal::float2 d = {};
    float dist = {};
    float inside = {};
    metal::float4 mid = {};
    metal::float2 param_4 = {};
    bool param_5 = {};
    metal::float4 halo = {};
    float h = {};
    metal::float4 col = {};
    float _e58 = t;
    collapse = metal::smoothstep(0.0, 0.4, _e58);
    float _e60 = t;
    shrink = metal::smoothstep(0.3, 0.65, _e60);
    float _e62 = t;
    fade = 0.4 * metal::smoothstep(0.75, 1.0, _e62);
    float _e65 = fade;
    radius = 0.01 * (1.0 - _e65);
    float _e69 = uniforms.ratio;
    float _e71 = radius;
    float _e72 = shrink;
    float _e74 = radius;
    float _e75 = collapse;
    size = metal::float2(metal::mix(0.5 * _e69, _e71, _e72), metal::mix(0.5, _e74, _e75));
    metal::float2 _e78 = uv_3;
    float _e82 = uniforms.ratio;
    p = (_e78 - metal::float2(0.5)) * metal::float2(_e82, 1.0);
    metal::float2 _e85 = p;
    metal::float2 _e87 = size;
    q = metal::clamp(metal::float2(0.5) + ((_e85 * 0.5) / _e87), metal::float2(0.0), metal::float2(1.0));
    metal::float2 _e94 = q;
    param_2 = _e94;
    bool _e95 = isFrom_1;
    param_3 = _e95;
    metal::float4 _e96 = getColor(param_2, param_3, _from, _sampler, _to);
    c = _e96;
    float _e97 = collapse;
    white = metal::smoothstep(0.4, 1.0, _e97);
    metal::float4 _e99 = c;
    float _e101 = collapse;
    float _e107 = white;
    metal::float3 _e109 = metal::mix(metal::min(_e99.xyz * (1.0 + (2.0 * _e101)), metal::float3(1.0)), metal::float3(1.0, 1.0, 1.0), metal::float3(_e107));
    float _e111 = c[3u];
    light = metal::float4(_e109.x, _e109.y, _e109.z, _e111);
    metal::float2 _e116 = p;
    metal::float2 _e118 = size;
    d = metal::abs(_e116) - _e118;
    metal::float2 _e120 = d;
    float _e125 = d[0u];
    float _e127 = d[1u];
    dist = metal::length(metal::max(_e120, metal::float2(0.0))) + metal::min(metal::max(_e125, _e127), 0.0);
    float _e131 = dist;
    inside = metal::clamp(1.0 - (_e131 / 0.004), 0.0, 1.0);
    param_4 = metal::float2(0.5, 0.5);
    bool _e135 = isFrom_1;
    param_5 = _e135;
    metal::float4 _e136 = getColor(param_4, param_5, _from, _sampler, _to);
    mid = _e136;
    metal::float4 _e137 = mid;
    float _e141 = shrink;
    metal::float3 _e143 = metal::mix(metal::mix(_e137.xyz, metal::float3(1.0, 1.0, 1.0), metal::float3(0.7)), metal::float3(1.0, 0.92, 0.8), metal::float3(_e141));
    float _e145 = mid[3u];
    halo = metal::float4(_e143.x, _e143.y, _e143.z, _e145);
    float _e151 = uniforms.glow;
    float _e153 = white;
    float _e155 = dist;
    float _e158 = shrink;
    h = 1.0 - metal::exp(((-2.0 * _e151) * _e153) * metal::exp(-(metal::max(_e155, 0.0)) / (0.02 + (0.04 * _e158))));
    metal::float4 _e167 = uniforms.color;
    metal::float4 _e168 = halo;
    float _e169 = h;
    float _e170 = fade;
    col = metal::mix(_e167, _e168, metal::float4(_e169 * (1.0 - _e170)));
    metal::float4 _e175 = col;
    metal::float4 _e176 = light;
    float _e177 = inside;
    float _e178 = fade;
    return metal::mix(_e175, _e176, metal::float4(_e177 * (1.0 - _e178)));
}

metal::float4 transition(
    thread metal::float2& uv_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_6 = {};
    float param_7 = {};
    bool param_8 = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    bool param_11 = {};
    float _e42 = uniforms.progress;
    if (_e42 < 0.5) {
        float _e45 = uniforms.progress;
        metal::float2 _e47 = uv_4;
        param_6 = _e47;
        param_7 = 2.0 * _e45;
        param_8 = true;
        metal::float4 _e48 = screen(param_6, param_7, param_8, _from, _sampler, _to, uniforms);
        return _e48;
    }
    float _e50 = uniforms.progress;
    metal::float2 _e53 = uv_4;
    param_9 = _e53;
    param_10 = 2.0 - (2.0 * _e50);
    param_11 = false;
    metal::float4 _e54 = screen(param_9, param_10, param_11, _from, _sampler, _to, uniforms);
    return _e54;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_12 = {};
    metal::float2 _e35 = _uv_1;
    param_12 = _e35;
    metal::float4 _e36 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e36;
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
