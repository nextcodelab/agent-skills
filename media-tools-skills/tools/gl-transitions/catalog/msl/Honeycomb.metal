// Honeycomb — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Honeycomb.glsl
// Author: gre
// License: MIT
// Description: The image splits into hexagons that spin and shrink away in a wave from the center, uncovering the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float size;
};

float hexDist(
    thread metal::float2& p
) {
    metal::float2 _e33 = p;
    p = metal::abs(_e33);
    float _e36 = p[0u];
    metal::float2 _e37 = p;
    return metal::max(_e36, metal::dot(_e37, metal::float2(0.5, 0.8660254)));
}

metal::float2x2 rotation(
    thread float& a
) {
    float _e33 = a;
    float _e35 = a;
    float _e37 = a;
    float _e40 = a;
    return metal::float2x2(metal::float2(metal::cos(_e33), metal::sin(_e35)), metal::float2(-(metal::sin(_e37)), metal::cos(_e40)));
}

float hexMask(
    thread metal::float2& local,
    thread float& s,
    thread float& a_1,
    thread float& e
) {
    float r = {};
    float param = {};
    metal::float2 param_1 = {};
    float _e39 = e;
    float _e41 = s;
    r = (0.52 + _e39) * _e41;
    float _e43 = r;
    float _e44 = e;
    float _e46 = r;
    float _e47 = a_1;
    param = -(_e47);
    metal::float2x2 _e49 = rotation(param);
    metal::float2 _e50 = local;
    param_1 = _e49 * _e50;
    float _e52 = hexDist(param_1);
    return 1.0 - metal::smoothstep(_e43 - _e44, _e46, _e52);
}

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

metal::float2 hexUv(
    thread metal::float2& uv_2,
    thread metal::float2& local_1,
    thread metal::float2& cellToUv,
    thread float& s_1,
    thread float& a_2
) {
    float param_2 = {};
    metal::float2 _e38 = uv_2;
    metal::float2 _e39 = cellToUv;
    float _e40 = a_2;
    param_2 = -(_e40);
    metal::float2x2 _e42 = rotation(param_2);
    metal::float2 _e43 = local_1;
    float _e45 = s_1;
    metal::float2 _e49 = local_1;
    return _e38 + (_e39 * (((_e42 * _e43) / metal::float2(metal::max(_e45, 0.001))) - _e49));
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 toCells = {};
    metal::float2 p_1 = {};
    metal::float2 a_3 = {};
    metal::float2 b = {};
    metal::float2 center = {};
    metal::float2 local_2 = {};
    float d = {};
    float t = {};
    float s_2 = {};
    float turn = {};
    metal::float4 fromTile = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float param_7 = {};
    metal::float2 param_8 = {};
    metal::float4 below = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float _e61 = uniforms.ratio;
    float _e64 = uniforms.size;
    float _e67 = uniforms.ratio;
    toCells = (metal::float2(_e61, 1.0) * _e64) / metal::float2(metal::min(_e67, 1.0));
    metal::float2 _e71 = uv_3;
    metal::float2 _e74 = toCells;
    p_1 = (_e71 - metal::float2(0.5)) * _e74;
    metal::float2 _e76 = p_1;
    a_3 = (metal::floor(_e76 / metal::float2(1.0, 1.7320508)) + metal::float2(0.5)) * metal::float2(1.0, 1.7320508);
    metal::float2 _e82 = p_1;
    b = (metal::floor((_e82 - metal::float2(0.5, 0.8660254)) / metal::float2(1.0, 1.7320508)) + metal::float2(1.0)) * metal::float2(1.0, 1.7320508);
    metal::float2 _e89 = p_1;
    metal::float2 _e90 = a_3;
    metal::float2 _e92 = p_1;
    metal::float2 _e93 = a_3;
    metal::float2 _e96 = p_1;
    metal::float2 _e97 = b;
    metal::float2 _e99 = p_1;
    metal::float2 _e100 = b;
    metal::float2 _e104 = a_3;
    metal::float2 _e105 = b;
    center = metal::select(_e105, _e104, metal::bool2(metal::dot(_e89 - _e90, _e92 - _e93) < metal::dot(_e96 - _e97, _e99 - _e100)));
    metal::float2 _e108 = p_1;
    metal::float2 _e109 = center;
    local_2 = _e108 - _e109;
    metal::float2 _e111 = center;
    metal::float2 _e112 = toCells;
    float _e115 = uniforms.ratio;
    float _e120 = uniforms.ratio;
    d = metal::min(metal::length((_e111 / _e112) * metal::float2(_e115, 1.0)) / (0.5 * metal::length(metal::float2(_e120, 1.0))), 1.0);
    float _e127 = uniforms.progress;
    float _e128 = d;
    t = metal::clamp((_e127 - (0.6 * _e128)) / 0.4, 0.0, 1.0);
    float _e133 = t;
    s_2 = 1.0 - metal::smoothstep(0.1, 1.0, _e133);
    float _e136 = t;
    float _e138 = t;
    turn = (1.8 * _e136) * (2.0 - _e138);
    metal::float2 _e141 = toCells;
    metal::float2 _e144 = uv_3;
    param_3 = _e144;
    metal::float2 _e145 = local_2;
    param_4 = _e145;
    param_5 = metal::float2(1.0) / _e141;
    float _e146 = s_2;
    param_6 = _e146;
    float _e147 = turn;
    param_7 = _e147;
    metal::float2 _e148 = hexUv(param_3, param_4, param_5, param_6, param_7);
    param_8 = _e148;
    metal::float4 _e149 = getFromColor(param_8, _from, _sampler);
    fromTile = _e149;
    float _e150 = t;
    metal::float4 _e153 = fromTile;
    metal::float3 _e155 = _e153.xyz * (1.0 - (0.3 * _e150));
    fromTile[0u] = _e155.x;
    fromTile[1u] = _e155.y;
    fromTile[2u] = _e155.z;
    metal::float2 _e162 = uv_3;
    param_9 = _e162;
    metal::float4 _e163 = getToColor(param_9, _sampler, _to);
    below = _e163;
    metal::float2 _e164 = local_2;
    float _e165 = s_2;
    param_10 = _e164 - (metal::float2(0.06, -0.08) * _e165);
    float _e168 = s_2;
    param_11 = _e168;
    float _e169 = turn;
    param_12 = _e169;
    param_13 = 0.2;
    float _e170 = hexMask(param_10, param_11, param_12, param_13);
    metal::float4 _e173 = below;
    metal::float3 _e175 = _e173.xyz * (1.0 - (0.5 * _e170));
    below[0u] = _e175.x;
    below[1u] = _e175.y;
    below[2u] = _e175.z;
    metal::float4 _e182 = below;
    metal::float4 _e183 = fromTile;
    metal::float2 _e184 = local_2;
    param_14 = _e184;
    float _e185 = s_2;
    param_15 = _e185;
    float _e186 = turn;
    param_16 = _e186;
    param_17 = 0.03;
    float _e187 = hexMask(param_14, param_15, param_16, param_17);
    return metal::mix(_e182, _e183, metal::float4(_e187));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_18 = {};
    metal::float2 _e33 = _uv_1;
    param_18 = _e33;
    metal::float4 _e34 = transition(param_18, _from, _sampler, _to, uniforms);
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
