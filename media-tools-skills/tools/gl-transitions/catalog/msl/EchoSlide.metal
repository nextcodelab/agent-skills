// EchoSlide — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/EchoSlide.glsl
// Author: gre
// License: MIT
// Description: The outgoing image slides away leaving a trail of discrete fading copies of itself, a stroboscopic echo, and the incoming image's echoes converge into place
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    int echoes;
    float trail;
    float decay;
    char _pad6[4];
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e32 = uv[0u];
    float _e34 = uv[1u];
    metal::float4 _e37 = _from.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e32 = uv_1[0u];
    float _e34 = uv_1[1u];
    metal::float4 _e37 = _to.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e31 = v;
    metal::float2 _e32 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e31 - (metal::floor(_e31 / _e32) * _e32)));
}

float easeInOut(
    thread float& t
) {
    float _e31 = t;
    float _e32 = t;
    float _e34 = t;
    return (_e31 * _e32) * (3.0 - (2.0 * _e34));
}

float edgeAt(
    thread float& t_1
) {
    float param = {};
    float _e32 = t_1;
    param = metal::clamp(_e32, 0.0, 1.0);
    float _e34 = easeInOut(param);
    return _e34;
}

metal::float4 echoStep(
    thread metal::float2& uv_2,
    thread float& s,
    thread metal::float2& shift,
    thread float& j,
    thread float& t0_,
    thread float& lag,
    thread float& n,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float e0_ = {};
    float param_1 = {};
    float e1_ = {};
    float param_2 = {};
    metal::float4 a = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float4 b = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float4 c = {};
    float _e48 = t0_;
    float _e49 = j;
    float _e50 = lag;
    param_1 = _e48 + (_e49 * _e50);
    float _e53 = edgeAt(param_1);
    e0_ = _e53;
    float _e54 = t0_;
    float _e55 = j;
    float _e57 = lag;
    param_2 = _e54 + ((_e55 + 1.0) * _e57);
    float _e60 = edgeAt(param_2);
    e1_ = _e60;
    metal::float2 _e61 = uv_2;
    metal::float2 _e62 = shift;
    float _e63 = e0_;
    param_3 = _e61 - (_e62 * _e63);
    metal::float2 _e66 = mirror(param_3);
    param_4 = _e66;
    metal::float4 _e67 = getFromColor(param_4, _from, _sampler);
    a = _e67;
    metal::float2 _e68 = uv_2;
    metal::float2 _e69 = shift;
    float _e70 = e1_;
    param_5 = _e68 - (_e69 * (_e70 - 1.0));
    metal::float2 _e74 = mirror(param_5);
    param_6 = _e74;
    metal::float4 _e75 = getToColor(param_6, _sampler, _to);
    b = _e75;
    metal::float4 _e76 = b;
    metal::float4 _e77 = a;
    float _e78 = j;
    float _e80 = n;
    float _e83 = uniforms.decay;
    c = metal::mix(_e76, _e77, metal::float4(metal::pow((_e78 + 0.5) / _e80, 0.5 + (2.0 * metal::clamp(_e83, 0.0, 1.0)))));
    float _e90 = e1_;
    float _e91 = s;
    float _e98 = e1_;
    float _e99 = e0_;
    metal::float4 _e105 = c;
    metal::float3 _e107 = _e105.xyz * (1.0 - ((0.25 * metal::exp(-(metal::max(_e90 - _e91, 0.0)) / 0.02)) * metal::min((_e98 - _e99) / 0.02, 1.0)));
    c[0u] = _e107.x;
    c[1u] = _e107.y;
    c[2u] = _e107.z;
    metal::float4 _e114 = c;
    return _e114;
}

float past(
    thread float& s_1,
    thread float& x
) {
    float local = {};
    float local_1 = {};
    float _e34 = x;
    if (_e34 <= 0.0) {
        local = 1.0;
    } else {
        float _e36 = x;
        if (_e36 >= 1.0) {
            local_1 = 0.0;
        } else {
            float _e38 = s_1;
            float _e39 = x;
            local_1 = metal::clamp(((_e38 - _e39) / 0.002) + 0.5, 0.0, 1.0);
        }
        float _e44 = local_1;
        local = _e44;
    }
    float _e45 = local;
    return _e45;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dl = {};
    metal::float2 d = {};
    metal::float2 local_2 = {};
    float ext = {};
    metal::float2 shift_1 = {};
    float s_2 = {};
    float n_1 = {};
    float tr = {};
    float lag_1 = {};
    float t0_1 = {};
    float local_3 = {};
    float eIn = {};
    float param_7 = {};
    float eOut = {};
    float param_8 = {};
    float wIn = {};
    float param_9 = {};
    float param_10 = {};
    float wOut = {};
    float param_11 = {};
    float param_12 = {};
    float wGap = {};
    metal::float4 c_1 = {};
    float jf = {};
    int k = {};
    float m = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float j_1 = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    metal::float2 param_18 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    metal::float2 param_23 = {};
    float param_24 = {};
    metal::float2 param_25 = {};
    float param_26 = {};
    float param_27 = {};
    float param_28 = {};
    float param_29 = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    metal::float2 param_32 = {};
    metal::float2 param_33 = {};
    metal::float2 _e80 = uniforms.direction;
    dl = metal::length(_e80);
    float _e82 = dl;
    if (_e82 > 0.000001) {
        metal::float2 _e85 = uniforms.direction;
        float _e86 = dl;
        local_2 = _e85 / metal::float2(_e86);
    } else {
        local_2 = metal::float2(1.0, 0.0);
    }
    metal::float2 _e89 = local_2;
    d = _e89;
    float _e91 = d[0u];
    float _e94 = d[1u];
    ext = metal::abs(_e91) + metal::abs(_e94);
    metal::float2 _e97 = d;
    float _e98 = ext;
    shift_1 = _e97 * _e98;
    metal::float2 _e100 = uv_3;
    metal::float2 _e103 = d;
    float _e105 = ext;
    s_2 = 0.5 + (metal::dot(_e100 - metal::float2(0.5), _e103) / _e105);
    int _e109 = uniforms.echoes;
    n_1 = metal::clamp(static_cast<float>(_e109), 1.0, 7.0);
    float _e113 = uniforms.trail;
    tr = metal::clamp(_e113, 0.05, 0.6);
    float _e115 = tr;
    float _e116 = n_1;
    lag_1 = _e115 / _e116;
    float _e119 = uniforms.progress;
    if (_e119 >= 1.0) {
        local_3 = 1.0;
    } else {
        float _e122 = uniforms.progress;
        float _e123 = tr;
        float _e126 = tr;
        local_3 = (_e122 * (1.0 + _e123)) - _e126;
    }
    float _e128 = local_3;
    t0_1 = _e128;
    float _e129 = t0_1;
    param_7 = _e129;
    float _e130 = edgeAt(param_7);
    eIn = _e130;
    float _e131 = t0_1;
    float _e132 = tr;
    param_8 = _e131 + _e132;
    float _e134 = edgeAt(param_8);
    eOut = _e134;
    float _e135 = s_2;
    param_9 = _e135;
    float _e136 = eIn;
    param_10 = _e136;
    float _e137 = past(param_9, param_10);
    wIn = 1.0 - _e137;
    float _e139 = s_2;
    param_11 = _e139;
    float _e140 = eOut;
    param_12 = _e140;
    float _e141 = past(param_11, param_12);
    wOut = _e141;
    float _e142 = wIn;
    float _e144 = wOut;
    wGap = metal::max((1.0 - _e142) - _e144, 0.0);
    c_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e147 = wGap;
    if (_e147 > 0.0) {
        jf = 0.0;
        k = 1;
        uint2 loop_bound = uint2(4294967295u);
        bool loop_init = true;
        while(true) {
            if (metal::all(loop_bound == uint2(0u))) { break; }
            loop_bound -= uint2(loop_bound.y == 0u, 1u);
            if (!loop_init) {
                int _e166 = k;
                k = as_type<int>(as_type<uint>(_e166) + as_type<uint>(1));
            }
            loop_init = false;
            int _e149 = k;
            if (_e149 < 7) {
                int _e151 = k;
                m = static_cast<float>(_e151);
                float _e153 = m;
                float _e154 = n_1;
                if (_e153 >= _e154) {
                    break;
                }
                float _e156 = t0_1;
                float _e157 = m;
                float _e158 = lag_1;
                param_13 = _e156 + (_e157 * _e158);
                float _e161 = edgeAt(param_13);
                float _e162 = s_2;
                param_14 = _e162;
                param_15 = _e161;
                float _e163 = past(param_14, param_15);
                float _e164 = jf;
                jf = _e164 + _e163;
                continue;
            } else {
                break;
            }
        }
        float _e168 = jf;
        j_1 = metal::floor(_e168);
        metal::float2 _e170 = uv_3;
        param_16 = _e170;
        float _e171 = s_2;
        param_17 = _e171;
        metal::float2 _e172 = shift_1;
        param_18 = _e172;
        float _e173 = j_1;
        param_19 = _e173;
        float _e174 = t0_1;
        param_20 = _e174;
        float _e175 = lag_1;
        param_21 = _e175;
        float _e176 = n_1;
        param_22 = _e176;
        metal::float4 _e177 = echoStep(param_16, param_17, param_18, param_19, param_20, param_21, param_22, _from, _sampler, _to, uniforms);
        c_1 = _e177;
        float _e178 = jf;
        float _e179 = j_1;
        if (_e178 > _e179) {
            metal::float4 _e181 = c_1;
            float _e182 = j_1;
            metal::float2 _e184 = uv_3;
            param_23 = _e184;
            float _e185 = s_2;
            param_24 = _e185;
            metal::float2 _e186 = shift_1;
            param_25 = _e186;
            param_26 = _e182 + 1.0;
            float _e187 = t0_1;
            param_27 = _e187;
            float _e188 = lag_1;
            param_28 = _e188;
            float _e189 = n_1;
            param_29 = _e189;
            metal::float4 _e190 = echoStep(param_23, param_24, param_25, param_26, param_27, param_28, param_29, _from, _sampler, _to, uniforms);
            float _e191 = jf;
            float _e192 = j_1;
            c_1 = metal::mix(_e181, _e190, metal::float4(_e191 - _e192));
        }
        float _e196 = wGap;
        metal::float4 _e197 = c_1;
        c_1 = _e197 * _e196;
    }
    float _e199 = wIn;
    if (_e199 > 0.0) {
        float _e201 = wIn;
        metal::float2 _e202 = uv_3;
        metal::float2 _e203 = shift_1;
        float _e204 = eIn;
        param_30 = _e202 - (_e203 * (_e204 - 1.0));
        metal::float2 _e208 = mirror(param_30);
        param_31 = _e208;
        metal::float4 _e209 = getToColor(param_31, _sampler, _to);
        metal::float4 _e211 = c_1;
        c_1 = _e211 + (_e209 * _e201);
    }
    float _e213 = wOut;
    if (_e213 > 0.0) {
        float _e215 = wOut;
        metal::float2 _e216 = uv_3;
        metal::float2 _e217 = shift_1;
        float _e218 = eOut;
        param_32 = _e216 - (_e217 * _e218);
        metal::float2 _e221 = mirror(param_32);
        param_33 = _e221;
        metal::float4 _e222 = getFromColor(param_33, _from, _sampler);
        metal::float4 _e224 = c_1;
        c_1 = _e224 + (_e222 * _e215);
    }
    metal::float4 _e226 = c_1;
    return _e226;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_34 = {};
    metal::float2 _e31 = _uv_1;
    param_34 = _e31;
    metal::float4 _e32 = transition(param_34, _from, _sampler, _to, uniforms);
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
