// Mosaic — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Mosaic.glsl
// Author: Xaychru
// License: MIT
// Description: The view pans across a mosaic of rotated tiles from both images and settles on the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int endx;
    int endy;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e26 = uv[0u];
    float _e28 = uv[1u];
    metal::float4 _e31 = _from.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e26 = uv_1[0u];
    float _e28 = uv_1[1u];
    metal::float4 _e31 = _to.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float2 Rotate(
    thread metal::float2& v,
    thread float& a
) {
    metal::float2x2 rm = {};
    float _e27 = a;
    float _e29 = a;
    float _e32 = a;
    float _e34 = a;
    rm = metal::float2x2(metal::float2(metal::cos(_e27), -(metal::sin(_e29))), metal::float2(metal::sin(_e32), metal::cos(_e34)));
    metal::float2x2 _e39 = rm;
    metal::float2 _e40 = v;
    return _e39 * _e40;
}

float Rand(
    thread metal::float2& v_1
) {
    metal::float2 _e25 = v_1;
    return metal::fract(metal::sin(metal::dot(_e25, metal::float2(12.9898, 78.233))) * 43758.547);
}

float CosInterpolation(
    thread float& x
) {
    float _e25 = x;
    return (-(metal::cos(_e25 * 3.1415927)) / 2.0) + 0.5;
}

int naga_f2i32(float value) {
    return static_cast<int>(metal::clamp(value, -2147483600.0, 2147483500.0));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p = {};
    metal::float2 rp = {};
    float rpr = {};
    float z = {};
    float az = {};
    float param = {};
    float param_1 = {};
    metal::float2 mrp = {};
    metal::float2 crp = {};
    bool onEnd = {};
    float ang = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    bool phi_197_ = {};
    bool phi_229_ = {};
    metal::float2 _e42 = uv_2;
    p = (_e42 / metal::float2(1.0, 1.0)) - metal::float2(0.5);
    metal::float2 _e46 = p;
    rp = _e46;
    float _e48 = uniforms.progress;
    rpr = (_e48 * 2.0) - 1.0;
    float _e51 = rpr;
    float _e52 = rpr;
    z = -(((_e51 * _e52) * 2.0)) + 3.0;
    float _e57 = z;
    az = metal::abs(_e57);
    float _e59 = az;
    metal::float2 _e60 = rp;
    rp = _e60 * _e59;
    int _e63 = uniforms.endx;
    int _e67 = uniforms.endy;
    float _e72 = uniforms.progress;
    param = _e72;
    float _e73 = CosInterpolation(param);
    float _e75 = uniforms.progress;
    param_1 = _e75;
    float _e76 = CosInterpolation(param_1);
    metal::float2 _e80 = rp;
    rp = _e80 + metal::mix(metal::float2(0.5, 0.5), metal::float2(static_cast<float>(_e63) + 0.5, static_cast<float>(_e67) + 0.5), metal::float2(_e73 * _e76));
    metal::float2 _e82 = rp;
    metal::float2 _e83 = metal::float2(1.0);
    mrp = _e82 - (metal::floor(_e82 / _e83) * _e83);
    metal::float2 _e88 = rp;
    crp = _e88;
    float _e90 = crp[0u];
    int _e94 = uniforms.endx;
    bool _e95 = naga_f2i32(metal::floor(_e90)) == _e94;
    phi_197_ = _e95;
    if (_e95) {
        float _e97 = crp[1u];
        int _e101 = uniforms.endy;
        phi_197_ = naga_f2i32(metal::floor(_e97)) == _e101;
    }
    bool _e104 = phi_197_;
    onEnd = _e104;
    bool _e105 = onEnd;
    if (!(_e105)) {
        metal::float2 _e107 = crp;
        param_2 = metal::floor(_e107);
        float _e109 = Rand(param_2);
        ang = (static_cast<float>(naga_f2i32(_e109 * 4.0)) * 0.5) * 3.1415927;
        metal::float2 _e115 = mrp;
        param_3 = _e115 - metal::float2(0.5, 0.5);
        float _e117 = ang;
        param_4 = _e117;
        metal::float2 _e118 = Rotate(param_3, param_4);
        mrp = metal::float2(0.5, 0.5) + _e118;
    }
    bool _e120 = onEnd;
    phi_229_ = _e120;
    if (!(_e120)) {
        metal::float2 _e122 = crp;
        param_5 = metal::floor(_e122);
        float _e124 = Rand(param_5);
        phi_229_ = _e124 > 0.5;
    }
    bool _e127 = phi_229_;
    if (_e127) {
        metal::float2 _e128 = mrp;
        param_6 = _e128;
        metal::float4 _e129 = getToColor(param_6, _sampler, _to);
        return _e129;
    } else {
        metal::float2 _e130 = mrp;
        param_7 = _e130;
        metal::float4 _e131 = getFromColor(param_7, _from, _sampler);
        return _e131;
    }
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e25 = _uv_1;
    param_8 = _e25;
    metal::float4 _e26 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e26;
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
