// BowTie — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BowTie.glsl
// Author: KMojek
// License: MIT
// Description: Two triangles grow from the top and bottom edges into a bow tie that reveals the incoming image, with an adjustable shape, and can run in reverse
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float adjust;
    int reverse;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

float check(
    thread metal::float2& p1_,
    thread metal::float2& p2_,
    thread metal::float2& p3_
) {
    float _e20 = p1_[0u];
    float _e22 = p3_[0u];
    float _e25 = p2_[1u];
    float _e27 = p3_[1u];
    float _e31 = p2_[0u];
    float _e33 = p3_[0u];
    float _e36 = p1_[1u];
    float _e38 = p3_[1u];
    return ((_e20 - _e22) * (_e25 - _e27)) - ((_e31 - _e33) * (_e36 - _e38));
}

bool pointInTriangle(
    thread metal::float2& pt,
    thread metal::float2& p1_1,
    thread metal::float2& p2_1,
    thread metal::float2& p3_1
) {
    bool b1_ = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    bool b2_ = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    bool b3_ = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 _e32 = pt;
    param = _e32;
    metal::float2 _e33 = p1_1;
    param_1 = _e33;
    metal::float2 _e34 = p2_1;
    param_2 = _e34;
    float _e35 = check(param, param_1, param_2);
    b1_ = _e35 < 0.0;
    metal::float2 _e37 = pt;
    param_3 = _e37;
    metal::float2 _e38 = p2_1;
    param_4 = _e38;
    metal::float2 _e39 = p3_1;
    param_5 = _e39;
    float _e40 = check(param_3, param_4, param_5);
    b2_ = _e40 < 0.0;
    metal::float2 _e42 = pt;
    param_6 = _e42;
    metal::float2 _e43 = p3_1;
    param_7 = _e43;
    metal::float2 _e44 = p1_1;
    param_8 = _e44;
    float _e45 = check(param_6, param_7, param_8);
    b3_ = _e45 < 0.0;
    bool _e47 = b1_;
    bool _e48 = b2_;
    bool _e50 = b2_;
    bool _e51 = b3_;
    return (_e47 == _e48) && (_e50 == _e51);
}

metal::float4 transition_firstHalf(
    thread metal::float2& uv_2,
    thread float& prog,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 botLeft = {};
    metal::float2 botRight = {};
    metal::float2 tip = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 topLeft = {};
    metal::float2 topRight = {};
    metal::float2 tip_1 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float2 param_19 = {};
    float _e36 = uv_2[1u];
    if (_e36 < 0.5) {
        float _e38 = prog;
        botLeft = metal::float2(-0.0, _e38 - 0.5);
        float _e41 = prog;
        botRight = metal::float2(1.0, _e41 - 0.5);
        float _e45 = uniforms.adjust;
        float _e46 = prog;
        tip = metal::float2(_e45, _e46);
        metal::float2 _e48 = uv_2;
        param_9 = _e48;
        metal::float2 _e49 = botLeft;
        param_10 = _e49;
        metal::float2 _e50 = botRight;
        param_11 = _e50;
        metal::float2 _e51 = tip;
        param_12 = _e51;
        bool _e52 = pointInTriangle(param_9, param_10, param_11, param_12);
        if (_e52) {
            metal::float2 _e53 = uv_2;
            param_13 = _e53;
            metal::float4 _e54 = getToColor(param_13, _sampler, _to);
            return _e54;
        }
    } else {
        float _e55 = prog;
        topLeft = metal::float2(-0.0, (1.0 - _e55) + 0.5);
        float _e59 = prog;
        topRight = metal::float2(1.0, (1.0 - _e59) + 0.5);
        float _e64 = uniforms.adjust;
        float _e65 = prog;
        tip_1 = metal::float2(_e64, 1.0 - _e65);
        metal::float2 _e68 = uv_2;
        param_14 = _e68;
        metal::float2 _e69 = topLeft;
        param_15 = _e69;
        metal::float2 _e70 = topRight;
        param_16 = _e70;
        metal::float2 _e71 = tip_1;
        param_17 = _e71;
        bool _e72 = pointInTriangle(param_14, param_15, param_16, param_17);
        if (_e72) {
            metal::float2 _e73 = uv_2;
            param_18 = _e73;
            metal::float4 _e74 = getToColor(param_18, _sampler, _to);
            return _e74;
        }
    }
    metal::float2 _e75 = uv_2;
    param_19 = _e75;
    metal::float4 _e76 = getFromColor(param_19, _from, _sampler);
    return _e76;
}

metal::float4 transition_secondHalf(
    thread metal::float2& uv_3,
    thread float& prog_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 top = {};
    metal::float2 bot = {};
    metal::float2 tip_2 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    metal::float2 param_24 = {};
    metal::float2 top_1 = {};
    metal::float2 bot_1 = {};
    metal::float2 tip_3 = {};
    metal::float2 param_25 = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    metal::float2 param_28 = {};
    metal::float2 param_29 = {};
    metal::float2 param_30 = {};
    float _e36 = uv_3[0u];
    float _e38 = uniforms.adjust;
    if (_e36 > _e38) {
        float _e40 = prog_1;
        top = metal::float2(_e40 + 0.5, 1.0);
        float _e43 = prog_1;
        bot = metal::float2(_e43 + 0.5, -0.0);
        float _e47 = uniforms.adjust;
        float _e48 = prog_1;
        tip_2 = metal::float2(metal::mix(_e47, 1.0, 2.0 * (_e48 - 0.5)), 0.5);
        metal::float2 _e53 = uv_3;
        param_20 = _e53;
        metal::float2 _e54 = top;
        param_21 = _e54;
        metal::float2 _e55 = bot;
        param_22 = _e55;
        metal::float2 _e56 = tip_2;
        param_23 = _e56;
        bool _e57 = pointInTriangle(param_20, param_21, param_22, param_23);
        if (_e57) {
            metal::float2 _e58 = uv_3;
            param_24 = _e58;
            metal::float4 _e59 = getFromColor(param_24, _from, _sampler);
            return _e59;
        }
    } else {
        float _e60 = prog_1;
        top_1 = metal::float2((1.0 - _e60) - 0.5, 1.0);
        float _e64 = prog_1;
        bot_1 = metal::float2((1.0 - _e64) - 0.5, -0.0);
        float _e69 = uniforms.adjust;
        float _e70 = prog_1;
        tip_3 = metal::float2(metal::mix(_e69, 0.0, 2.0 * (_e70 - 0.5)), 0.5);
        metal::float2 _e75 = uv_3;
        param_25 = _e75;
        metal::float2 _e76 = top_1;
        param_26 = _e76;
        metal::float2 _e77 = bot_1;
        param_27 = _e77;
        metal::float2 _e78 = tip_3;
        param_28 = _e78;
        bool _e79 = pointInTriangle(param_25, param_26, param_27, param_28);
        if (_e79) {
            metal::float2 _e80 = uv_3;
            param_29 = _e80;
            metal::float4 _e81 = getFromColor(param_29, _from, _sampler);
            return _e81;
        }
    }
    metal::float2 _e82 = uv_3;
    param_30 = _e82;
    metal::float4 _e83 = getToColor(param_30, _sampler, _to);
    return _e83;
}

metal::float4 transition(
    thread metal::float2& uv_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 local = {};
    metal::float2 param_31 = {};
    float param_32 = {};
    metal::float2 param_33 = {};
    float param_34 = {};
    metal::float4 local_1 = {};
    metal::float2 param_35 = {};
    float param_36 = {};
    metal::float2 param_37 = {};
    float param_38 = {};
    int _e28 = uniforms.reverse;
    if (_e28 != 0) {
        float _e31 = uniforms.progress;
        if (_e31 < 0.5) {
            float _e34 = uniforms.progress;
            metal::float2 _e36 = uv_4;
            param_31 = _e36;
            param_32 = 1.0 - _e34;
            metal::float4 _e37 = transition_secondHalf(param_31, param_32, _from, _sampler, _to, uniforms);
            local = _e37;
        } else {
            float _e39 = uniforms.progress;
            metal::float2 _e41 = uv_4;
            param_33 = _e41;
            param_34 = 1.0 - _e39;
            metal::float4 _e42 = transition_firstHalf(param_33, param_34, _from, _sampler, _to, uniforms);
            local = _e42;
        }
        metal::float4 _e43 = local;
        return _e43;
    } else {
        float _e45 = uniforms.progress;
        if (_e45 < 0.5) {
            metal::float2 _e47 = uv_4;
            param_35 = _e47;
            float _e49 = uniforms.progress;
            param_36 = _e49;
            metal::float4 _e50 = transition_firstHalf(param_35, param_36, _from, _sampler, _to, uniforms);
            local_1 = _e50;
        } else {
            metal::float2 _e51 = uv_4;
            param_37 = _e51;
            float _e53 = uniforms.progress;
            param_38 = _e53;
            metal::float4 _e54 = transition_secondHalf(param_37, param_38, _from, _sampler, _to, uniforms);
            local_1 = _e54;
        }
        metal::float4 _e55 = local_1;
        return _e55;
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
    metal::float2 param_39 = {};
    metal::float2 _e17 = _uv_1;
    param_39 = _e17;
    metal::float4 _e18 = transition(param_39, _from, _sampler, _to, uniforms);
    _fragColor = _e18;
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
