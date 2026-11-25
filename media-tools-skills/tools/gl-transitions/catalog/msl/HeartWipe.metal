// HeartWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HeartWipe.glsl
// Author: gre
// License: MIT
// Description: A heart grows from the center with a little heartbeat to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float smoothness;
    float pulse;
    char _pad5[8];
    metal::packed_float3 glowColor;
    float glow;
};

float dot2(
    thread metal::float2& v
) {
    metal::float2 _e41 = v;
    metal::float2 _e42 = v;
    return metal::dot(_e41, _e42);
}

float sdHeart(
    thread metal::float2& p
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float _e45 = p[0u];
    p[0u] = metal::abs(_e45);
    float _e49 = p[0u];
    float _e51 = p[1u];
    if ((_e49 + _e51) > 1.0) {
        metal::float2 _e54 = p;
        param = _e54 - metal::float2(0.25, 0.75);
        float _e56 = dot2(param);
        return metal::sqrt(_e56) - 0.35355338;
    }
    metal::float2 _e59 = p;
    param_1 = _e59 - metal::float2(0.0, 1.0);
    float _e61 = dot2(param_1);
    metal::float2 _e62 = p;
    float _e64 = p[0u];
    float _e66 = p[1u];
    param_2 = _e62 - metal::float2(0.5 * metal::max(_e64 + _e66, 0.0));
    float _e72 = dot2(param_2);
    float _e76 = p[0u];
    float _e78 = p[1u];
    return metal::sqrt(metal::min(_e61, _e72)) * metal::sign(_e76 - _e78);
}

float heartScale(
    thread metal::float2& p_1
) {
    float l = {};
    metal::float2 d = {};
    metal::float2 m = {};
    float b = {};
    float tDisk = {};
    metal::float2 param_3 = {};
    float tSide = {};
    float local = {};
    float tTop = {};
    float local_1 = {};
    metal::float2 _e51 = p_1;
    l = metal::length(_e51);
    float _e53 = l;
    if (_e53 < 0.000001) {
        return 0.0;
    }
    float _e56 = p_1[0u];
    float _e59 = p_1[1u];
    float _e61 = l;
    d = metal::float2(metal::abs(_e56), _e59) / metal::float2(_e61);
    m = metal::float2(-0.25, -0.2);
    metal::float2 _e64 = m;
    metal::float2 _e65 = d;
    b = metal::dot(_e64, _e65);
    float _e67 = b;
    float _e69 = b;
    float _e70 = b;
    metal::float2 _e72 = m;
    param_3 = _e72;
    float _e73 = dot2(param_3);
    tDisk = -(_e67) + metal::sqrt(((_e69 * _e70) - _e73) + 0.125);
    float _e79 = d[0u];
    float _e81 = d[1u];
    if (_e79 > _e81) {
        float _e84 = d[0u];
        float _e86 = d[1u];
        local = 0.55 / (_e84 - _e86);
    } else {
        local = 1000000.0;
    }
    float _e89 = local;
    tSide = _e89;
    float _e91 = d[0u];
    float _e93 = d[1u];
    if ((_e91 + _e93) > 0.0) {
        float _e97 = d[0u];
        float _e99 = d[1u];
        local_1 = 0.45 / (_e97 + _e99);
    } else {
        local_1 = 1000000.0;
    }
    float _e102 = local_1;
    tTop = _e102;
    float _e103 = l;
    float _e104 = tDisk;
    float _e105 = tSide;
    float _e106 = tTop;
    return _e103 / metal::max(_e104, metal::min(_e105, _e106));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e42 = uv[0u];
    float _e44 = uv[1u];
    metal::float4 _e47 = _to.sample(_sampler, metal::float2(_e42, 1.0 - _e44), metal::level(0.0));
    return _e47;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e42 = uv_1[0u];
    float _e44 = uv_1[1u];
    metal::float4 _e47 = _from.sample(_sampler, metal::float2(_e42, 1.0 - _e44), metal::level(0.0));
    return _e47;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param_4 = {};
    metal::float4 b_1 = {};
    metal::float2 param_5 = {};
    metal::float2 asp = {};
    metal::float2 c = {};
    float cx = {};
    float full = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float sm = {};
    float p_2 = {};
    float e = {};
    float env = {};
    float beat = {};
    float s = {};
    metal::float2 q = {};
    float d_1 = {};
    metal::float2 param_11 = {};
    float m_1 = {};
    metal::float4 col = {};
    float light = {};
    metal::float2 _e66 = uv_2;
    param_4 = _e66;
    metal::float4 _e67 = getFromColor(param_4, _from, _sampler);
    a = _e67;
    metal::float2 _e68 = uv_2;
    param_5 = _e68;
    metal::float4 _e69 = getToColor(param_5, _sampler, _to);
    b_1 = _e69;
    float _e71 = uniforms.ratio;
    asp = metal::float2(_e71, 1.0);
    metal::float2 _e74 = uniforms.center;
    metal::float2 _e75 = asp;
    c = _e74 * _e75;
    float _e79 = uniforms.center[0u];
    float _e82 = uniforms.ratio;
    cx = metal::clamp(_e79, 0.0, 1.0) * _e82;
    metal::float2 _e84 = c;
    param_6 = metal::float2(0.0, 0.0) - _e84;
    float _e86 = heartScale(param_6);
    float _e88 = uniforms.ratio;
    metal::float2 _e90 = c;
    param_7 = metal::float2(_e88, 0.0) - _e90;
    float _e92 = heartScale(param_7);
    metal::float2 _e94 = c;
    param_8 = metal::float2(0.0, 1.0) - _e94;
    float _e96 = heartScale(param_8);
    float _e98 = uniforms.ratio;
    metal::float2 _e100 = c;
    param_9 = metal::float2(_e98, 1.0) - _e100;
    float _e102 = heartScale(param_9);
    float _e105 = cx;
    metal::float2 _e107 = c;
    param_10 = metal::float2(_e105, 1.0) - _e107;
    float _e109 = heartScale(param_10);
    full = metal::max(metal::max(metal::max(_e86, _e92), metal::max(_e96, _e102)), _e109);
    float _e112 = uniforms.smoothness;
    sm = metal::max(_e112, 0.001);
    float _e114 = sm;
    float _e116 = full;
    full = _e116 + (4.0 * _e114);
    float _e119 = uniforms.progress;
    p_2 = _e119;
    float _e120 = p_2;
    float _e121 = p_2;
    float _e123 = p_2;
    e = (_e120 * _e121) * (2.0 - _e123);
    float _e126 = p_2;
    env = metal::max(metal::sin(3.1415927 * _e126), 0.0);
    float _e130 = p_2;
    float _e133 = env;
    float _e135 = env;
    beat = (metal::sin(12.566371 * _e130) * _e133) * _e135;
    float _e137 = full;
    float _e138 = e;
    float _e140 = uniforms.pulse;
    float _e142 = beat;
    s = _e137 * metal::clamp(_e138 + ((0.09 * _e140) * _e142), 0.0, 1.0);
    float _e147 = s;
    if (_e147 <= 0.0) {
        metal::float4 _e149 = a;
        return _e149;
    }
    metal::float2 _e150 = uv_2;
    metal::float2 _e151 = asp;
    metal::float2 _e153 = c;
    q = (_e150 * _e151) - _e153;
    float _e155 = s;
    metal::float2 _e156 = q;
    float _e157 = s;
    param_11 = (_e156 / metal::float2(_e157)) + metal::float2(0.0, 0.55);
    float _e161 = sdHeart(param_11);
    d_1 = _e155 * _e161;
    float _e163 = sm;
    float _e164 = d_1;
    m_1 = metal::smoothstep(0.0, _e163, -(_e164));
    metal::float4 _e167 = a;
    metal::float4 _e168 = b_1;
    float _e169 = m_1;
    col = metal::mix(_e167, _e168, metal::float4(_e169));
    float _e172 = d_1;
    float _e175 = sm;
    float _e179 = m_1;
    float _e183 = uniforms.glow;
    float _e185 = env;
    light = ((metal::exp(-(metal::max(_e172, 0.0)) / (0.008 + _e175)) * (1.0 - _e179)) * _e183) * metal::min(1.0, 4.0 * _e185);
    metal::float4 _e189 = col;
    metal::float3 _e191 = uniforms.glowColor;
    float _e192 = light;
    metal::float3 _e193 = _e191 * _e192;
    return _e189 + metal::float4(_e193.x, _e193.y, _e193.z, 0.0);
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
    metal::float2 _e41 = _uv_1;
    param_12 = _e41;
    metal::float4 _e42 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e42;
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
