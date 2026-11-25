// Swap — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Swap.glsl
// Author: gre
// License: MIT
// Description: The two images swap places in 3D, with a floor reflection
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float reflection;
    float perspective;
    float depth;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e32 = uv[0u];
    float _e34 = uv[1u];
    metal::float4 _e37 = _to.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e32 = uv_1[0u];
    float _e34 = uv_1[1u];
    metal::float4 _e37 = _from.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

bool inBounds(
    thread metal::float2& p
) {
    bool phi_84_ = {};
    metal::float2 _e31 = p;
    bool _e33 = metal::all(metal::float2(0.0, 0.0) < _e31);
    phi_84_ = _e33;
    if (_e33) {
        metal::float2 _e34 = p;
        phi_84_ = metal::all(_e34 < metal::float2(1.0, 1.0));
    }
    bool _e38 = phi_84_;
    return _e38;
}

metal::float2 project(
    thread metal::float2& p_1
) {
    metal::float2 _e31 = p_1;
    return (_e31 * metal::float2(1.0, -1.2)) + metal::float2(0.0, -0.02);
}

metal::float4 bgColor(
    thread metal::float2& p_2,
    thread metal::float2& pfr,
    thread metal::float2& pto,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 c = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    metal::float2 _e40 = pfr;
    param = _e40;
    metal::float2 _e41 = project(param);
    pfr = _e41;
    metal::float2 _e42 = pfr;
    param_1 = _e42;
    bool _e43 = inBounds(param_1);
    if (_e43) {
        metal::float2 _e44 = pfr;
        param_2 = _e44;
        metal::float4 _e45 = getFromColor(param_2, _from, _sampler);
        float _e47 = uniforms.reflection;
        float _e49 = pfr[1u];
        metal::float4 _e54 = c;
        c = _e54 + metal::mix(metal::float4(0.0, 0.0, 0.0, 0.0), _e45, metal::float4(_e47 * metal::mix(1.0, 0.0, _e49)));
    }
    metal::float2 _e56 = pto;
    param_3 = _e56;
    metal::float2 _e57 = project(param_3);
    pto = _e57;
    metal::float2 _e58 = pto;
    param_4 = _e58;
    bool _e59 = inBounds(param_4);
    if (_e59) {
        metal::float2 _e60 = pto;
        param_5 = _e60;
        metal::float4 _e61 = getToColor(param_5, _sampler, _to);
        float _e63 = uniforms.reflection;
        float _e65 = pto[1u];
        metal::float4 _e70 = c;
        c = _e70 + metal::mix(metal::float4(0.0, 0.0, 0.0, 0.0), _e61, metal::float4(_e63 * metal::mix(1.0, 0.0, _e65)));
    }
    metal::float4 _e72 = c;
    return _e72;
}

metal::float4 transition(
    thread metal::float2& p_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 pto_1 = {};
    float size = {};
    float persp = {};
    metal::float2 pfr_1 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    pto_1 = metal::float2(-1.0, -1.0);
    float _e47 = uniforms.depth;
    float _e49 = uniforms.progress;
    size = metal::mix(1.0, _e47, _e49);
    float _e52 = uniforms.perspective;
    float _e54 = uniforms.progress;
    persp = _e52 * _e54;
    metal::float2 _e56 = p_3;
    float _e58 = size;
    float _e60 = uniforms.perspective;
    float _e62 = uniforms.progress;
    float _e66 = size;
    float _e67 = size;
    float _e68 = persp;
    float _e71 = p_3[0u];
    pfr_1 = ((_e56 + metal::float2(-0.0, -0.5)) * metal::float2(_e58 / (1.0 - (_e60 * _e62)), _e66 / (1.0 - ((_e67 * _e68) * _e71)))) + metal::float2(0.0, 0.5);
    float _e79 = uniforms.depth;
    float _e81 = uniforms.progress;
    size = metal::mix(1.0, _e79, 1.0 - _e81);
    float _e85 = uniforms.perspective;
    float _e87 = uniforms.progress;
    persp = _e85 * (1.0 - _e87);
    metal::float2 _e90 = p_3;
    float _e92 = size;
    float _e94 = uniforms.perspective;
    float _e96 = uniforms.progress;
    float _e101 = size;
    float _e102 = size;
    float _e103 = persp;
    float _e106 = p_3[0u];
    pto_1 = ((_e90 + metal::float2(-1.0, -0.5)) * metal::float2(_e92 / (1.0 - (_e94 * (1.0 - _e96))), _e101 / (1.0 - ((_e102 * _e103) * (0.5 - _e106))))) + metal::float2(1.0, 0.5);
    float _e115 = uniforms.progress;
    if (_e115 < 0.5) {
        metal::float2 _e117 = pfr_1;
        param_6 = _e117;
        bool _e118 = inBounds(param_6);
        if (_e118) {
            metal::float2 _e119 = pfr_1;
            param_7 = _e119;
            metal::float4 _e120 = getFromColor(param_7, _from, _sampler);
            return _e120;
        }
        metal::float2 _e121 = pto_1;
        param_8 = _e121;
        bool _e122 = inBounds(param_8);
        if (_e122) {
            metal::float2 _e123 = pto_1;
            param_9 = _e123;
            metal::float4 _e124 = getToColor(param_9, _sampler, _to);
            return _e124;
        }
    }
    metal::float2 _e125 = pto_1;
    param_10 = _e125;
    bool _e126 = inBounds(param_10);
    if (_e126) {
        metal::float2 _e127 = pto_1;
        param_11 = _e127;
        metal::float4 _e128 = getToColor(param_11, _sampler, _to);
        return _e128;
    }
    metal::float2 _e129 = pfr_1;
    param_12 = _e129;
    bool _e130 = inBounds(param_12);
    if (_e130) {
        metal::float2 _e131 = pfr_1;
        param_13 = _e131;
        metal::float4 _e132 = getFromColor(param_13, _from, _sampler);
        return _e132;
    }
    metal::float2 _e133 = p_3;
    param_14 = _e133;
    metal::float2 _e134 = pfr_1;
    param_15 = _e134;
    metal::float2 _e135 = pto_1;
    param_16 = _e135;
    metal::float4 _e136 = bgColor(param_14, param_15, param_16, _from, _sampler, _to, uniforms);
    return _e136;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_17 = {};
    metal::float2 _e31 = _uv_1;
    param_17 = _e31;
    metal::float4 _e32 = transition(param_17, _from, _sampler, _to, uniforms);
    _fragColor = _e32;
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
