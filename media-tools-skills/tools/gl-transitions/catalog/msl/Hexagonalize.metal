// Hexagonalize — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Hexagonalize.glsl
// Author: Fernando Kuteken
// License: MIT
// Description: Both images turn into hexagons, crossfade, then sharpen again
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Hexagon {
    float q;
    float r;
    float s;
};
struct Uniforms {
    float progress;
    float ratio;
    int steps;
    float horizontalHexagons;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e24 = uv[0u];
    float _e26 = uv[1u];
    metal::float4 _e29 = _to.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e24 = uv_1[0u];
    float _e26 = uv_1[1u];
    metal::float4 _e29 = _from.sample(_sampler, metal::float2(_e24, 1.0 - _e26), metal::level(0.0));
    return _e29;
}

metal::float2 pointFromHexagon(
    thread Hexagon& hex,
    thread float& size,
    constant Uniforms& uniforms
) {
    float x = {};
    float y = {};
    float _e27 = hex.q;
    float _e30 = hex.r;
    float _e33 = size;
    x = (((1.7320508 * _e27) + (0.8660254 * _e30)) * _e33) + 0.5;
    float _e37 = hex.q;
    float _e40 = hex.r;
    float _e43 = size;
    y = (((0.0 * _e37) + (1.5 * _e40)) * _e43) + 0.5;
    float _e46 = x;
    float _e47 = y;
    float _e49 = uniforms.ratio;
    return metal::float2(_e46, _e47 * _e49);
}

Hexagon createHexagon(
    thread float& q,
    thread float& r
) {
    Hexagon hex_1 = {};
    float _e25 = q;
    hex_1.q = _e25;
    float _e27 = r;
    hex_1.r = _e27;
    float _e29 = q;
    float _e31 = r;
    hex_1.s = -(_e29) - _e31;
    Hexagon _e34 = hex_1;
    return _e34;
}

Hexagon roundHexagon(
    thread Hexagon& hex_2
) {
    float q_1 = {};
    float r_1 = {};
    float s = {};
    float deltaQ = {};
    float deltaR = {};
    float deltaS = {};
    float param = {};
    float param_1 = {};
    float _e32 = hex_2.q;
    q_1 = metal::floor(_e32 + 0.5);
    float _e36 = hex_2.r;
    r_1 = metal::floor(_e36 + 0.5);
    float _e40 = hex_2.s;
    s = metal::floor(_e40 + 0.5);
    float _e43 = q_1;
    float _e45 = hex_2.q;
    deltaQ = metal::abs(_e43 - _e45);
    float _e48 = r_1;
    float _e50 = hex_2.r;
    deltaR = metal::abs(_e48 - _e50);
    float _e53 = s;
    float _e55 = hex_2.s;
    deltaS = metal::abs(_e53 - _e55);
    float _e58 = deltaQ;
    float _e59 = deltaR;
    float _e61 = deltaQ;
    float _e62 = deltaS;
    if ((_e58 > _e59) && (_e61 > _e62)) {
        float _e65 = r_1;
        float _e67 = s;
        q_1 = -(_e65) - _e67;
    } else {
        float _e69 = deltaR;
        float _e70 = deltaS;
        if (_e69 > _e70) {
            float _e72 = q_1;
            float _e74 = s;
            r_1 = -(_e72) - _e74;
        } else {
            float _e76 = q_1;
            float _e78 = r_1;
            s = -(_e76) - _e78;
        }
    }
    float _e80 = q_1;
    param = _e80;
    float _e81 = r_1;
    param_1 = _e81;
    Hexagon _e82 = createHexagon(param, param_1);
    return _e82;
}

Hexagon hexagonFromPoint(
    thread metal::float2& point,
    thread float& size_1,
    constant Uniforms& uniforms
) {
    float q_2 = {};
    float r_2 = {};
    Hexagon hex_3 = {};
    float param_2 = {};
    float param_3 = {};
    Hexagon param_4 = {};
    float _e31 = uniforms.ratio;
    float _e33 = point[1u];
    point[1u] = _e33 / _e31;
    metal::float2 _e36 = point;
    float _e39 = size_1;
    point = (_e36 - metal::float2(0.5)) / metal::float2(_e39);
    float _e43 = point[0u];
    float _e46 = point[1u];
    q_2 = (0.57735026 * _e43) + (-0.33333334 * _e46);
    float _e50 = point[0u];
    float _e53 = point[1u];
    r_2 = (0.0 * _e50) + (0.6666667 * _e53);
    float _e56 = q_2;
    param_2 = _e56;
    float _e57 = r_2;
    param_3 = _e57;
    Hexagon _e58 = createHexagon(param_2, param_3);
    hex_3 = _e58;
    Hexagon _e59 = hex_3;
    param_4 = _e59;
    Hexagon _e60 = roundHexagon(param_4);
    return _e60;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dist = {};
    float local = {};
    float size_2 = {};
    metal::float2 point_1 = {};
    metal::float2 local_1 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    Hexagon param_7 = {};
    float param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float _e35 = uniforms.progress;
    float _e37 = uniforms.progress;
    dist = 2.0 * metal::min(_e35, 1.0 - _e37);
    int _e42 = uniforms.steps;
    if (_e42 > 0) {
        float _e44 = dist;
        int _e46 = uniforms.steps;
        int _e51 = uniforms.steps;
        local = metal::ceil(_e44 * static_cast<float>(_e46)) / static_cast<float>(_e51);
    } else {
        float _e54 = dist;
        local = _e54;
    }
    float _e55 = local;
    dist = _e55;
    float _e56 = dist;
    float _e59 = uniforms.horizontalHexagons;
    size_2 = (0.57735026 * _e56) / _e59;
    float _e61 = dist;
    if (_e61 > 0.0) {
        metal::float2 _e63 = uv_2;
        param_5 = _e63;
        float _e64 = size_2;
        param_6 = _e64;
        Hexagon _e65 = hexagonFromPoint(param_5, param_6, uniforms);
        param_7 = _e65;
        float _e66 = size_2;
        param_8 = _e66;
        metal::float2 _e67 = pointFromHexagon(param_7, param_8, uniforms);
        local_1 = _e67;
    } else {
        metal::float2 _e68 = uv_2;
        local_1 = _e68;
    }
    metal::float2 _e69 = local_1;
    point_1 = _e69;
    metal::float2 _e70 = point_1;
    param_9 = _e70;
    metal::float4 _e71 = getFromColor(param_9, _from, _sampler);
    metal::float2 _e72 = point_1;
    param_10 = _e72;
    metal::float4 _e73 = getToColor(param_10, _sampler, _to);
    float _e75 = uniforms.progress;
    return metal::mix(_e71, _e73, metal::float4(_e75));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_11 = {};
    metal::float2 _e23 = _uv_1;
    param_11 = _e23;
    metal::float4 _e24 = transition(param_11, _from, _sampler, _to, uniforms);
    _fragColor = _e24;
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
