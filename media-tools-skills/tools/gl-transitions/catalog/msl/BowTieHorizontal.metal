// BowTieHorizontal — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BowTieHorizontal.glsl
// Author: huynx
// License: MIT
// Description: Two triangles grow from the left and right edges into a bow tie that reveals the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

float check(
    thread metal::float2& p1_,
    thread metal::float2& p2_,
    thread metal::float2& p3_
) {
    float _e25 = p1_[0u];
    float _e27 = p3_[0u];
    float _e30 = p2_[1u];
    float _e32 = p3_[1u];
    float _e36 = p2_[0u];
    float _e38 = p3_[0u];
    float _e41 = p1_[1u];
    float _e43 = p3_[1u];
    return ((_e25 - _e27) * (_e30 - _e32)) - ((_e36 - _e38) * (_e41 - _e43));
}

bool PointInTriangle(
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
    metal::float2 _e37 = pt;
    param = _e37;
    metal::float2 _e38 = p1_1;
    param_1 = _e38;
    metal::float2 _e39 = p2_1;
    param_2 = _e39;
    float _e40 = check(param, param_1, param_2);
    b1_ = _e40 < 0.0;
    metal::float2 _e42 = pt;
    param_3 = _e42;
    metal::float2 _e43 = p2_1;
    param_4 = _e43;
    metal::float2 _e44 = p3_1;
    param_5 = _e44;
    float _e45 = check(param_3, param_4, param_5);
    b2_ = _e45 < 0.0;
    metal::float2 _e47 = pt;
    param_6 = _e47;
    metal::float2 _e48 = p3_1;
    param_7 = _e48;
    metal::float2 _e49 = p1_1;
    param_8 = _e49;
    float _e50 = check(param_6, param_7, param_8);
    b3_ = _e50 < 0.0;
    bool _e52 = b1_;
    bool _e53 = b2_;
    bool _e55 = b2_;
    bool _e56 = b3_;
    return (_e52 == _e53) && (_e55 == _e56);
}

bool in_right_triangle(
    thread metal::float2& p,
    constant Uniforms& uniforms
) {
    metal::float2 vertex1_ = {};
    metal::float2 vertex2_ = {};
    metal::float2 vertex3_ = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    float _e30 = uniforms.progress;
    vertex1_ = metal::float2(1.0 - _e30, 0.5);
    float _e34 = uniforms.progress;
    vertex2_ = metal::float2(1.0, 0.5 - _e34);
    float _e38 = uniforms.progress;
    vertex3_ = metal::float2(1.0, 0.5 + _e38);
    metal::float2 _e41 = p;
    param_9 = _e41;
    metal::float2 _e42 = vertex1_;
    param_10 = _e42;
    metal::float2 _e43 = vertex2_;
    param_11 = _e43;
    metal::float2 _e44 = vertex3_;
    param_12 = _e44;
    bool _e45 = PointInTriangle(param_9, param_10, param_11, param_12);
    if (_e45) {
        return true;
    }
    return false;
}

float blur_edge(
    thread metal::float2& bot1_,
    thread metal::float2& bot2_,
    thread metal::float2& top,
    thread metal::float2& testPt
) {
    metal::float2 lineDir = {};
    metal::float2 perpDir = {};
    metal::float2 dirToPt1_ = {};
    float dist1_ = {};
    float min_dist = {};
    metal::float2 _e30 = bot1_;
    metal::float2 _e31 = top;
    lineDir = _e30 - _e31;
    float _e34 = lineDir[1u];
    float _e36 = lineDir[0u];
    perpDir = metal::float2(_e34, -(_e36));
    metal::float2 _e39 = bot1_;
    metal::float2 _e40 = testPt;
    dirToPt1_ = _e39 - _e40;
    metal::float2 _e42 = perpDir;
    metal::float2 _e44 = dirToPt1_;
    dist1_ = metal::abs(metal::dot(metal::normalize(_e42), _e44));
    metal::float2 _e47 = bot2_;
    metal::float2 _e48 = top;
    lineDir = _e47 - _e48;
    float _e51 = lineDir[1u];
    float _e53 = lineDir[0u];
    perpDir = metal::float2(_e51, -(_e53));
    metal::float2 _e56 = bot2_;
    metal::float2 _e57 = testPt;
    dirToPt1_ = _e56 - _e57;
    metal::float2 _e59 = perpDir;
    metal::float2 _e61 = dirToPt1_;
    float _e64 = dist1_;
    min_dist = metal::min(metal::abs(metal::dot(metal::normalize(_e59), _e61)), _e64);
    float _e66 = min_dist;
    if (_e66 < 0.005) {
        float _e68 = min_dist;
        return _e68 / 0.005;
    } else {
        return 1.0;
    }
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e23 = uv[0u];
    float _e25 = uv[1u];
    metal::float4 _e28 = _to.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e23 = uv_1[0u];
    float _e25 = uv_1[1u];
    metal::float4 _e28 = _from.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

bool in_left_triangle(
    thread metal::float2& p_1,
    constant Uniforms& uniforms
) {
    metal::float2 vertex1_1 = {};
    metal::float2 vertex2_1 = {};
    metal::float2 vertex3_1 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    float _e30 = uniforms.progress;
    vertex1_1 = metal::float2(_e30, 0.5);
    float _e33 = uniforms.progress;
    vertex2_1 = metal::float2(0.0, 0.5 - _e33);
    float _e37 = uniforms.progress;
    vertex3_1 = metal::float2(0.0, 0.5 + _e37);
    metal::float2 _e40 = p_1;
    param_13 = _e40;
    metal::float2 _e41 = vertex1_1;
    param_14 = _e41;
    metal::float2 _e42 = vertex2_1;
    param_15 = _e42;
    metal::float2 _e43 = vertex3_1;
    param_16 = _e43;
    bool _e44 = PointInTriangle(param_13, param_14, param_15, param_16);
    if (_e44) {
        return true;
    }
    return false;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float2 vertex1_2 = {};
    metal::float2 vertex2_2 = {};
    metal::float2 vertex3_2 = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    metal::float2 vertex1_3 = {};
    metal::float2 vertex2_3 = {};
    metal::float2 vertex3_3 = {};
    metal::float2 param_28 = {};
    metal::float2 param_29 = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    metal::float2 param_32 = {};
    metal::float2 param_33 = {};
    metal::float2 param_34 = {};
    metal::float2 param_35 = {};
    metal::float2 _e47 = uv_2;
    param_17 = _e47;
    bool _e48 = in_left_triangle(param_17, uniforms);
    if (_e48) {
        float _e50 = uniforms.progress;
        if (_e50 < 0.1) {
            metal::float2 _e52 = uv_2;
            param_18 = _e52;
            metal::float4 _e53 = getFromColor(param_18, _from, _sampler);
            return _e53;
        }
        float _e55 = uv_2[0u];
        if (_e55 < 0.5) {
            float _e58 = uniforms.progress;
            vertex1_2 = metal::float2(_e58, 0.5);
            float _e61 = uniforms.progress;
            vertex2_2 = metal::float2(0.0, 0.5 - _e61);
            float _e65 = uniforms.progress;
            vertex3_2 = metal::float2(0.0, 0.5 + _e65);
            metal::float2 _e68 = uv_2;
            param_19 = _e68;
            metal::float4 _e69 = getFromColor(param_19, _from, _sampler);
            metal::float2 _e70 = uv_2;
            param_20 = _e70;
            metal::float4 _e71 = getToColor(param_20, _sampler, _to);
            metal::float2 _e72 = vertex2_2;
            param_21 = _e72;
            metal::float2 _e73 = vertex3_2;
            param_22 = _e73;
            metal::float2 _e74 = vertex1_2;
            param_23 = _e74;
            metal::float2 _e75 = uv_2;
            param_24 = _e75;
            float _e76 = blur_edge(param_21, param_22, param_23, param_24);
            return metal::mix(_e69, _e71, metal::float4(_e76));
        } else {
            float _e80 = uniforms.progress;
            if (_e80 > 0.0) {
                metal::float2 _e82 = uv_2;
                param_25 = _e82;
                metal::float4 _e83 = getToColor(param_25, _sampler, _to);
                return _e83;
            } else {
                metal::float2 _e84 = uv_2;
                param_26 = _e84;
                metal::float4 _e85 = getFromColor(param_26, _from, _sampler);
                return _e85;
            }
        }
    } else {
        metal::float2 _e86 = uv_2;
        param_27 = _e86;
        bool _e87 = in_right_triangle(param_27, uniforms);
        if (_e87) {
            float _e89 = uv_2[0u];
            if (_e89 >= 0.5) {
                float _e92 = uniforms.progress;
                vertex1_3 = metal::float2(1.0 - _e92, 0.5);
                float _e96 = uniforms.progress;
                vertex2_3 = metal::float2(1.0, 0.5 - _e96);
                float _e100 = uniforms.progress;
                vertex3_3 = metal::float2(1.0, 0.5 + _e100);
                metal::float2 _e103 = uv_2;
                param_28 = _e103;
                metal::float4 _e104 = getFromColor(param_28, _from, _sampler);
                metal::float2 _e105 = uv_2;
                param_29 = _e105;
                metal::float4 _e106 = getToColor(param_29, _sampler, _to);
                metal::float2 _e107 = vertex2_3;
                param_30 = _e107;
                metal::float2 _e108 = vertex3_3;
                param_31 = _e108;
                metal::float2 _e109 = vertex1_3;
                param_32 = _e109;
                metal::float2 _e110 = uv_2;
                param_33 = _e110;
                float _e111 = blur_edge(param_30, param_31, param_32, param_33);
                return metal::mix(_e104, _e106, metal::float4(_e111));
            } else {
                metal::float2 _e114 = uv_2;
                param_34 = _e114;
                metal::float4 _e115 = getFromColor(param_34, _from, _sampler);
                return _e115;
            }
        } else {
            metal::float2 _e116 = uv_2;
            param_35 = _e116;
            metal::float4 _e117 = getFromColor(param_35, _from, _sampler);
            return _e117;
        }
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
    metal::float2 param_36 = {};
    metal::float2 _e22 = _uv_1;
    param_36 = _e22;
    metal::float4 _e23 = transition(param_36, _from, _sampler, _to, uniforms);
    _fragColor = _e23;
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
