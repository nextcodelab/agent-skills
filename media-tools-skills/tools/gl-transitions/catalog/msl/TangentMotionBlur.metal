// TangentMotionBlur — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TangentMotionBlur.glsl
// Author: chenkai
// License: MIT
// Description: The outgoing image is flung away along a curve with motion blur
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e38 = uv[0u];
    float _e40 = uv[1u];
    metal::float4 _e43 = _to.sample(_sampler, metal::float2(_e38, 1.0 - _e40), metal::level(0.0));
    return _e43;
}

float rand(
    thread metal::float2& co
) {
    metal::float2 _e37 = co;
    return metal::fract(metal::sin(metal::dot(_e37, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float4 motionBlurTo(
    thread metal::float2& _st,
    thread metal::float2& speed,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 texCoord = {};
    metal::float3 color = {};
    float alpha = {};
    float total = {};
    float offset = {};
    metal::float2 param = {};
    float t = {};
    float percent = {};
    float weight = {};
    metal::float2 newuv = {};
    metal::float4 c = {};
    metal::float2 param_1 = {};
    metal::float2 _e50 = _st;
    texCoord = _e50 / metal::float2(1.0, 1.0);
    color = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    total = 0.0;
    metal::float2 _e52 = _st;
    param = _e52;
    float _e53 = rand(param);
    offset = _e53;
    t = 0.0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            float _e93 = t;
            t = _e93 + 1.0;
        }
        loop_init = false;
        float _e54 = t;
        if (_e54 <= 20.0) {
            float _e56 = t;
            float _e57 = offset;
            percent = (_e56 + _e57) / 20.0;
            float _e60 = percent;
            float _e61 = percent;
            float _e62 = percent;
            weight = 4.0 * (_e60 - (_e61 * _e62));
            metal::float2 _e66 = texCoord;
            metal::float2 _e67 = speed;
            float _e68 = percent;
            newuv = _e66 + (_e67 * _e68);
            metal::float2 _e71 = newuv;
            newuv = metal::fract(_e71);
            metal::float2 _e73 = newuv;
            param_1 = _e73;
            metal::float4 _e74 = getToColor(param_1, _sampler, _to);
            c = _e74;
            metal::float4 _e75 = c;
            float _e78 = c[3u];
            float _e80 = weight;
            metal::float3 _e82 = color;
            color = _e82 + ((_e75.xyz * _e78) * _e80);
            float _e85 = c[3u];
            float _e86 = weight;
            float _e88 = alpha;
            alpha = _e88 + (_e85 * _e86);
            float _e90 = weight;
            float _e91 = total;
            total = _e91 + _e90;
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e95 = color;
    float _e96 = alpha;
    metal::float3 _e99 = _e95 / metal::float3(metal::max(_e96, 0.00001));
    float _e100 = alpha;
    float _e101 = total;
    return metal::float4(_e99.x, _e99.y, _e99.z, _e100 / _e101);
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e38 = uv_1[0u];
    float _e40 = uv_1[1u];
    metal::float4 _e43 = _from.sample(_sampler, metal::float2(_e38, 1.0 - _e40), metal::level(0.0));
    return _e43;
}

metal::float4 motionBlurFrom(
    thread metal::float2& _st_1,
    thread metal::float2& speed_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    metal::float2 texCoord_1 = {};
    metal::float3 color_1 = {};
    float alpha_1 = {};
    float total_1 = {};
    float offset_1 = {};
    metal::float2 param_2 = {};
    float t_1 = {};
    float percent_1 = {};
    float weight_1 = {};
    metal::float2 newuv_1 = {};
    metal::float4 c_1 = {};
    metal::float2 param_3 = {};
    metal::float2 _e50 = _st_1;
    texCoord_1 = _e50 / metal::float2(1.0, 1.0);
    color_1 = metal::float3(0.0, 0.0, 0.0);
    alpha_1 = 0.0;
    total_1 = 0.0;
    metal::float2 _e52 = _st_1;
    param_2 = _e52;
    float _e53 = rand(param_2);
    offset_1 = _e53;
    t_1 = 0.0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            float _e93 = t_1;
            t_1 = _e93 + 1.0;
        }
        loop_init_1 = false;
        float _e54 = t_1;
        if (_e54 <= 20.0) {
            float _e56 = t_1;
            float _e57 = offset_1;
            percent_1 = (_e56 + _e57) / 20.0;
            float _e60 = percent_1;
            float _e61 = percent_1;
            float _e62 = percent_1;
            weight_1 = 4.0 * (_e60 - (_e61 * _e62));
            metal::float2 _e66 = texCoord_1;
            metal::float2 _e67 = speed_1;
            float _e68 = percent_1;
            newuv_1 = _e66 + (_e67 * _e68);
            metal::float2 _e71 = newuv_1;
            newuv_1 = metal::fract(_e71);
            metal::float2 _e73 = newuv_1;
            param_3 = _e73;
            metal::float4 _e74 = getFromColor(param_3, _from, _sampler);
            c_1 = _e74;
            metal::float4 _e75 = c_1;
            float _e78 = c_1[3u];
            float _e80 = weight_1;
            metal::float3 _e82 = color_1;
            color_1 = _e82 + ((_e75.xyz * _e78) * _e80);
            float _e85 = c_1[3u];
            float _e86 = weight_1;
            float _e88 = alpha_1;
            alpha_1 = _e88 + (_e85 * _e86);
            float _e90 = weight_1;
            float _e91 = total_1;
            total_1 = _e91 + _e90;
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e95 = color_1;
    float _e96 = alpha_1;
    metal::float3 _e99 = _e95 / metal::float3(metal::max(_e96, 0.00001));
    float _e100 = alpha_1;
    float _e101 = total_1;
    return metal::float4(_e99.x, _e99.y, _e99.z, _e100 / _e101);
}

metal::float2 rotateUv(
    thread metal::float2& uv_2,
    thread float& angle,
    thread metal::float2& anchor,
    thread float& zDirection
) {
    float s = {};
    float c_2 = {};
    metal::float2x2 m = {};
    metal::float2 _e43 = uv_2;
    metal::float2 _e44 = anchor;
    uv_2 = _e43 - _e44;
    float _e46 = angle;
    s = metal::sin(_e46);
    float _e48 = angle;
    c_2 = metal::cos(_e48);
    float _e50 = c_2;
    float _e51 = s;
    float _e53 = s;
    float _e54 = c_2;
    m = metal::float2x2(metal::float2(_e50, -(_e51)), metal::float2(_e53, _e54));
    metal::float2x2 _e58 = m;
    metal::float2 _e59 = uv_2;
    uv_2 = _e58 * _e59;
    metal::float2 _e61 = anchor;
    metal::float2 _e62 = uv_2;
    uv_2 = _e62 + _e61;
    metal::float2 _e64 = uv_2;
    return _e64;
}

float normpdf(
    thread float& x
) {
    float d = {};
    float _e38 = x;
    d = _e38 - 0.5;
    float _e40 = d;
    float _e42 = d;
    return metal::exp((-20.0 * _e40) * _e42);
}

float C(
    thread float& aA1_
) {
    float _e37 = aA1_;
    return 3.0 * _e37;
}

float B(
    thread float& aA1_1,
    thread float& aA2_
) {
    float _e38 = aA2_;
    float _e40 = aA1_1;
    return (3.0 * _e38) - (6.0 * _e40);
}

float A(
    thread float& aA1_2,
    thread float& aA2_1
) {
    float _e38 = aA2_1;
    float _e41 = aA1_2;
    return (1.0 - (3.0 * _e38)) + (3.0 * _e41);
}

float CalcBezier(
    thread float& aT,
    thread float& aA1_3,
    thread float& aA2_2
) {
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float _e44 = aA1_3;
    param_4 = _e44;
    float _e45 = aA2_2;
    param_5 = _e45;
    float _e46 = A(param_4, param_5);
    float _e47 = aT;
    float _e49 = aA1_3;
    param_6 = _e49;
    float _e50 = aA2_2;
    param_7 = _e50;
    float _e51 = B(param_6, param_7);
    float _e53 = aT;
    float _e55 = aA1_3;
    param_8 = _e55;
    float _e56 = C(param_8);
    float _e58 = aT;
    return ((((_e46 * _e47) + _e51) * _e53) + _e56) * _e58;
}

float GetSlope(
    thread float& aT_1,
    thread float& aA1_4,
    thread float& aA2_3
) {
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float _e44 = aA1_4;
    param_9 = _e44;
    float _e45 = aA2_3;
    param_10 = _e45;
    float _e46 = A(param_9, param_10);
    float _e48 = aT_1;
    float _e50 = aT_1;
    float _e52 = aA1_4;
    param_11 = _e52;
    float _e53 = aA2_3;
    param_12 = _e53;
    float _e54 = B(param_11, param_12);
    float _e56 = aT_1;
    float _e59 = aA1_4;
    param_13 = _e59;
    float _e60 = C(param_13);
    return ((((3.0 * _e46) * _e48) * _e50) + ((2.0 * _e54) * _e56)) + _e60;
}

float GetTForX(
    thread float& aX,
    thread float& mX1_,
    thread float& mX2_
) {
    float aGuessT = {};
    int i = {};
    float currentSlope = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float currentX = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float _e49 = aX;
    aGuessT = _e49;
    i = 0;
    uint2 loop_bound_2 = uint2(4294967295u);
    bool loop_init_2 = true;
    while(true) {
        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
        if (!loop_init_2) {
            int _e70 = i;
            i = as_type<int>(as_type<uint>(_e70) + as_type<uint>(1));
        }
        loop_init_2 = false;
        int _e50 = i;
        if (_e50 < 4) {
            float _e52 = aGuessT;
            param_14 = _e52;
            float _e53 = mX1_;
            param_15 = _e53;
            float _e54 = mX2_;
            param_16 = _e54;
            float _e55 = GetSlope(param_14, param_15, param_16);
            currentSlope = _e55;
            float _e56 = currentSlope;
            if (_e56 == 0.0) {
                float _e58 = aGuessT;
                return _e58;
            }
            float _e59 = aGuessT;
            param_17 = _e59;
            float _e60 = mX1_;
            param_18 = _e60;
            float _e61 = mX2_;
            param_19 = _e61;
            float _e62 = CalcBezier(param_17, param_18, param_19);
            float _e63 = aX;
            currentX = _e62 - _e63;
            float _e65 = currentX;
            float _e66 = currentSlope;
            float _e68 = aGuessT;
            aGuessT = _e68 - (_e65 / _e66);
            continue;
        } else {
            break;
        }
    }
    float _e72 = aGuessT;
    return _e72;
}

float KeySpline(
    thread float& aX_1,
    thread float& mX1_1,
    thread float& mY1_,
    thread float& mX2_1,
    thread float& mY2_
) {
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float _e47 = mX1_1;
    float _e48 = mY1_;
    float _e50 = mX2_1;
    float _e51 = mY2_;
    if ((_e47 == _e48) && (_e50 == _e51)) {
        float _e54 = aX_1;
        return _e54;
    }
    float _e55 = aX_1;
    param_20 = _e55;
    float _e56 = mX1_1;
    param_21 = _e56;
    float _e57 = mX2_1;
    param_22 = _e57;
    float _e58 = GetTForX(param_20, param_21, param_22);
    param_23 = _e58;
    float _e59 = mY1_;
    param_24 = _e59;
    float _e60 = mY2_;
    param_25 = _e60;
    float _e61 = CalcBezier(param_23, param_24, param_25);
    return _e61;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 myst = {};
    float animationTime = {};
    float easingTime = {};
    float param_26 = {};
    float param_27 = {};
    float param_28 = {};
    float param_29 = {};
    float param_30 = {};
    float blur = {};
    float param_31 = {};
    float r = {};
    float rotation = {};
    metal::float2 mystCurrent = {};
    metal::float2 param_32 = {};
    float param_33 = {};
    metal::float2 param_34 = {};
    float param_35 = {};
    float timeInterval = {};
    metal::float2 mystNext = {};
    metal::float2 param_36 = {};
    float param_37 = {};
    metal::float2 param_38 = {};
    float param_39 = {};
    metal::float2 speed_2 = {};
    metal::float2 param_40 = {};
    metal::float2 param_41 = {};
    metal::float2 param_42 = {};
    metal::float2 param_43 = {};
    metal::float2 _e65 = uv_3;
    myst = _e65;
    float _e67 = uniforms.progress;
    animationTime = _e67;
    float _e68 = animationTime;
    param_26 = _e68;
    param_27 = 0.68;
    param_28 = 0.01;
    param_29 = 0.17;
    param_30 = 0.98;
    float _e69 = KeySpline(param_26, param_27, param_28, param_29, param_30);
    easingTime = _e69;
    float _e70 = easingTime;
    param_31 = _e70;
    float _e71 = normpdf(param_31);
    blur = _e71;
    r = 0.0;
    rotation = 3.14159;
    float _e72 = easingTime;
    if (_e72 <= 0.5) {
        float _e74 = rotation;
        float _e75 = easingTime;
        r = _e74 * _e75;
    } else {
        float _e77 = rotation;
        float _e79 = rotation;
        float _e80 = easingTime;
        r = -(_e77) + (_e79 * _e80);
    }
    metal::float2 _e83 = myst;
    mystCurrent = _e83;
    float _e85 = uniforms.ratio;
    float _e88 = mystCurrent[1u];
    mystCurrent[1u] = _e88 * (1.0 / _e85);
    metal::float2 _e91 = mystCurrent;
    param_32 = _e91;
    float _e92 = r;
    param_33 = _e92;
    param_34 = metal::float2(1.0, 0.0);
    param_35 = -1.0;
    metal::float2 _e93 = rotateUv(param_32, param_33, param_34, param_35);
    mystCurrent = _e93;
    float _e95 = uniforms.ratio;
    float _e97 = mystCurrent[1u];
    mystCurrent[1u] = _e97 * _e95;
    timeInterval = 0.0334;
    float _e100 = easingTime;
    if (_e100 <= 0.5) {
        float _e102 = rotation;
        float _e103 = easingTime;
        float _e104 = timeInterval;
        r = _e102 * (_e103 + _e104);
    } else {
        float _e107 = rotation;
        float _e109 = rotation;
        float _e110 = easingTime;
        float _e111 = timeInterval;
        r = -(_e107) + (_e109 * (_e110 + _e111));
    }
    metal::float2 _e115 = myst;
    mystNext = _e115;
    float _e117 = uniforms.ratio;
    float _e120 = mystNext[1u];
    mystNext[1u] = _e120 * (1.0 / _e117);
    metal::float2 _e123 = mystNext;
    param_36 = _e123;
    float _e124 = r;
    param_37 = _e124;
    param_38 = metal::float2(1.0, 0.0);
    param_39 = -1.0;
    metal::float2 _e125 = rotateUv(param_36, param_37, param_38, param_39);
    mystNext = _e125;
    float _e127 = uniforms.ratio;
    float _e129 = mystNext[1u];
    mystNext[1u] = _e129 * _e127;
    metal::float2 _e132 = mystNext;
    metal::float2 _e133 = mystCurrent;
    float _e135 = timeInterval;
    float _e138 = blur;
    speed_2 = (((_e132 - _e133) / metal::float2(_e135)) * _e138) * 0.5;
    float _e141 = easingTime;
    if (_e141 <= 0.5) {
        metal::float2 _e143 = mystCurrent;
        param_40 = _e143;
        metal::float2 _e144 = speed_2;
        param_41 = _e144;
        metal::float4 _e145 = motionBlurFrom(param_40, param_41, _from, _sampler);
        return _e145;
    } else {
        metal::float2 _e146 = mystCurrent;
        param_42 = _e146;
        metal::float2 _e147 = speed_2;
        param_43 = _e147;
        metal::float4 _e148 = motionBlurTo(param_42, param_43, _sampler, _to);
        return _e148;
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
    metal::float2 param_44 = {};
    metal::float2 _e37 = _uv_1;
    param_44 = _e37;
    metal::float4 _e38 = transition(param_44, _from, _sampler, _to, uniforms);
    _fragColor = _e38;
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
