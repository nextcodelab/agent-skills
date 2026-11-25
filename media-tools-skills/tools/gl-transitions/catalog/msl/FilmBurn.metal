// FilmBurn — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmBurn.glsl
// Author: Anastasia Dunbar
// License: MIT
// Description: Glowing film-burn light leaks wash over the image and reveal the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float Seed;
};

float sigmoid(
    thread float& x,
    thread float& a
) {
    float b = {};
    float _e51 = x;
    float _e53 = a;
    b = metal::pow(_e51 * 2.0, _e53) / 2.0;
    float _e56 = x;
    if (_e56 > 0.5) {
        float _e58 = x;
        float _e61 = a;
        b = 1.0 - (metal::pow(2.0 - (_e58 * 2.0), _e61) / 2.0);
    }
    float _e65 = b;
    return _e65;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e50 = uv[0u];
    float _e52 = uv[1u];
    metal::float4 _e55 = _to.sample(_sampler, metal::float2(_e50, 1.0 - _e52), metal::level(0.0));
    return _e55;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e50 = uv_1[0u];
    float _e52 = uv_1[1u];
    metal::float4 _e55 = _from.sample(_sampler, metal::float2(_e50, 1.0 - _e52), metal::level(0.0));
    return _e55;
}

metal::float4 blendedColor(
    thread metal::float2& p,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float param_3 = {};
    metal::float2 _e53 = p;
    param = _e53;
    metal::float4 _e54 = getFromColor(param, _from, _sampler);
    metal::float2 _e55 = p;
    param_1 = _e55;
    metal::float4 _e56 = getToColor(param_1, _sampler, _to);
    float _e58 = uniforms.progress;
    param_2 = _e58;
    param_3 = 10.0;
    float _e59 = sigmoid(param_2, param_3);
    return metal::mix(_e54, _e56, metal::float4(_e59));
}

float rand_u0028_vf2_u003b(
    thread metal::float2& co
) {
    metal::float2 _e49 = co;
    return metal::fract(metal::sin(metal::dot(_e49, metal::float2(12.9898, 78.233))) * 43758.547);
}

float apow(
    thread float& a_1,
    thread float& b_1
) {
    float _e50 = a_1;
    float _e52 = b_1;
    float _e54 = b_1;
    return metal::pow(metal::abs(_e50), _e52) * metal::sign(_e54);
}

metal::float3 pow3(
    thread metal::float3& a_2,
    thread metal::float3& b_2
) {
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float _e57 = a_2[0u];
    param_4 = _e57;
    float _e59 = b_2[0u];
    param_5 = _e59;
    float _e60 = apow(param_4, param_5);
    float _e62 = a_2[1u];
    param_6 = _e62;
    float _e64 = b_2[1u];
    param_7 = _e64;
    float _e65 = apow(param_6, param_7);
    float _e67 = a_2[2u];
    param_8 = _e67;
    float _e69 = b_2[2u];
    param_9 = _e69;
    float _e70 = apow(param_8, param_9);
    return metal::float3(_e60, _e65, _e70);
}

float smooth_mix(
    thread float& a_3,
    thread float& b_3,
    thread float& c
) {
    float param_10 = {};
    float param_11 = {};
    float _e53 = a_3;
    float _e54 = b_3;
    float _e55 = c;
    param_10 = _e55;
    param_11 = 2.0;
    float _e56 = sigmoid(param_10, param_11);
    return metal::mix(_e53, _e54, _e56);
}

float random(
    thread metal::float2& co_1,
    thread float& shft,
    constant Uniforms& uniforms
) {
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    metal::float2 _e53 = co_1;
    co_1 = _e53 + metal::float2(10.0);
    metal::float2 _e56 = co_1;
    float _e57 = shft;
    float _e62 = uniforms.Seed;
    metal::float2 _e69 = co_1;
    float _e70 = shft;
    float _e76 = uniforms.Seed;
    float _e83 = shft;
    param_12 = metal::fract(metal::sin(metal::dot(_e56, metal::float2(12.9898 + (metal::floor(_e57) * 0.5), 78.233 + _e62))) * 43758.547);
    param_13 = metal::fract(metal::sin(metal::dot(_e69, metal::float2(12.9898 + (metal::floor(_e70 + 1.0) * 0.5), 78.233 + _e76))) * 43758.547);
    param_14 = metal::fract(_e83);
    float _e85 = smooth_mix(param_12, param_13, param_14);
    return _e85;
}

float smooth_random(
    thread metal::float2& co_2,
    thread float& shft_1,
    constant Uniforms& uniforms
) {
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float2 param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    metal::float2 param_22 = {};
    float param_23 = {};
    metal::float2 param_24 = {};
    float param_25 = {};
    float param_26 = {};
    float param_27 = {};
    float param_28 = {};
    float param_29 = {};
    float param_30 = {};
    float param_31 = {};
    metal::float2 _e67 = co_2;
    param_15 = metal::floor(_e67);
    float _e69 = shft_1;
    param_16 = _e69;
    float _e70 = random(param_15, param_16, uniforms);
    metal::float2 _e71 = co_2;
    param_17 = metal::floor(_e71 + metal::float2(1.0, 0.0));
    float _e74 = shft_1;
    param_18 = _e74;
    float _e75 = random(param_17, param_18, uniforms);
    float _e77 = co_2[0u];
    param_19 = _e70;
    param_20 = _e75;
    param_21 = metal::fract(_e77);
    float _e79 = smooth_mix(param_19, param_20, param_21);
    metal::float2 _e80 = co_2;
    param_22 = metal::floor(_e80 + metal::float2(0.0, 1.0));
    float _e83 = shft_1;
    param_23 = _e83;
    float _e84 = random(param_22, param_23, uniforms);
    metal::float2 _e85 = co_2;
    param_24 = metal::floor(_e85 + metal::float2(1.0, 1.0));
    float _e88 = shft_1;
    param_25 = _e88;
    float _e89 = random(param_24, param_25, uniforms);
    float _e91 = co_2[0u];
    param_26 = _e84;
    param_27 = _e89;
    param_28 = metal::fract(_e91);
    float _e93 = smooth_mix(param_26, param_27, param_28);
    float _e95 = co_2[1u];
    param_29 = _e79;
    param_30 = _e93;
    param_31 = metal::fract(_e95);
    float _e97 = smooth_mix(param_29, param_30, param_31);
    return _e97;
}

float rand_u0028_f1_u003b(
    thread float& co_3,
    constant Uniforms& uniforms
) {
    float _e49 = co_3;
    float _e52 = uniforms.Seed;
    return metal::fract(metal::sin((_e49 * 24.9898) + _e52) * 43758.547);
}

metal::float4 transition(
    thread metal::float2& p_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float3 f = {};
    float i = {};
    float param_32 = {};
    float param_33 = {};
    float param_34 = {};
    float param_35 = {};
    metal::float2 param_36 = {};
    float param_37 = {};
    metal::float2 param_38 = {};
    float param_39 = {};
    float param_40 = {};
    metal::float3 param_41 = {};
    metal::float3 param_42 = {};
    metal::float2 param_43 = {};
    float param_44 = {};
    metal::float4 blurred_image = {};
    float bluramount = {};
    float i_1 = {};
    metal::float2 q = {};
    metal::float2 param_45 = {};
    metal::float2 uv2_ = {};
    metal::float2 param_46 = {};
    f = metal::float3(0.0, 0.0, 0.0);
    i = 0.0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            float _e135 = i;
            i = _e135 + 1.0;
        }
        loop_init = false;
        float _e71 = i;
        if (_e71 < 13.0) {
            float _e74 = p_1[0u];
            float _e75 = i;
            param_32 = _e75;
            float _e76 = rand_u0028_f1_u003b(param_32, uniforms);
            float _e80 = uniforms.progress;
            float _e83 = i;
            param_33 = _e83 + 1.43;
            float _e85 = rand_u0028_f1_u003b(param_33, uniforms);
            float _e89 = p_1[1u];
            float _e90 = i;
            param_34 = _e90 + 4.4;
            float _e92 = rand_u0028_f1_u003b(param_34, uniforms);
            float _e96 = uniforms.progress;
            float _e99 = i;
            param_35 = _e99 + 2.4;
            float _e101 = rand_u0028_f1_u003b(param_35, uniforms);
            metal::float3 _e105 = f;
            f = _e105 + metal::float3(metal::sin((((_e74 * _e76) * 6.0) + (_e80 * 8.0)) + _e85) * metal::sin((((_e89 * _e92) * 6.0) + (_e96 * 6.0)) + _e101));
            metal::float2 _e108 = p_1;
            float _e110 = uniforms.progress;
            float _e113 = i;
            param_36 = metal::float2(_e110 * 1.3);
            param_37 = _e113 + 1.0;
            float _e115 = smooth_random(param_36, param_37, uniforms);
            float _e117 = uniforms.progress;
            float _e120 = i;
            param_38 = metal::float2(_e117 * 0.5);
            param_39 = _e120 + 6.25;
            float _e122 = smooth_random(param_38, param_39, uniforms);
            float _e126 = i;
            param_40 = _e126;
            float _e127 = rand_u0028_f1_u003b(param_40, uniforms);
            metal::float3 _e132 = f;
            f = _e132 + metal::float3(1.0 - metal::clamp(metal::length(_e108 - metal::float2(_e115, _e122)) * metal::mix(20.0, 70.0, _e127), 0.0, 1.0));
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e137 = f;
    f = _e137 + metal::float3(4.0);
    metal::float3 _e140 = f;
    f = _e140 / metal::float3(11.0);
    metal::float3 _e143 = f;
    float _e146 = uniforms.progress;
    param_41 = _e143 * metal::float3(1.0, 0.7, 0.6);
    param_42 = metal::float3(1.0, 2.0 - metal::sin(_e146 * 3.1415927), 1.3);
    metal::float3 _e151 = pow3(param_41, param_42);
    f = _e151;
    float _e153 = uniforms.progress;
    metal::float3 _e156 = f;
    f = _e156 * metal::sin(_e153 * 3.1415927);
    metal::float2 _e158 = p_1;
    p_1 = _e158 - metal::float2(0.5);
    float _e162 = uniforms.progress;
    param_43 = metal::float2(_e162 * 5.0);
    param_44 = 6.3;
    float _e165 = smooth_random(param_43, param_44, uniforms);
    float _e167 = uniforms.progress;
    metal::float2 _e173 = p_1;
    p_1 = _e173 * (1.0 + ((_e165 * metal::sin(_e167 * 3.1415927)) * 0.05));
    metal::float2 _e175 = p_1;
    p_1 = _e175 + metal::float2(0.5);
    blurred_image = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e179 = uniforms.progress;
    bluramount = metal::sin(_e179 * 3.1415927) * 0.03;
    i_1 = 0.0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            float _e216 = i_1;
            i_1 = _e216 + 1.0;
        }
        loop_init_1 = false;
        float _e183 = i_1;
        if (_e183 < 50.0) {
            float _e185 = i_1;
            float _e190 = i_1;
            float _e196 = i_1;
            float _e198 = p_1[0u];
            float _e200 = p_1[1u];
            param_45 = metal::float2(_e196, _e198 + _e200);
            float _e203 = rand_u0028_vf2_u003b(param_45);
            float _e204 = bluramount;
            q = metal::float2(metal::cos(((((_e185 / 50.0) * 360.0)) * 57.295779513082322865)), metal::sin(((((_e190 / 50.0) * 360.0)) * 57.295779513082322865))) * (_e203 + _e204);
            metal::float2 _e207 = p_1;
            metal::float2 _e208 = q;
            float _e209 = bluramount;
            uv2_ = _e207 + (_e208 * _e209);
            metal::float2 _e212 = uv2_;
            param_46 = _e212;
            metal::float4 _e213 = blendedColor(param_46, _from, _sampler, _to, uniforms);
            metal::float4 _e214 = blurred_image;
            blurred_image = _e214 + _e213;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e218 = blurred_image;
    blurred_image = _e218 / metal::float4(50.0);
    metal::float4 _e221 = blurred_image;
    metal::float3 _e222 = f;
    return _e221 + metal::float4(_e222.x, _e222.y, _e222.z, 0.0);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_47 = {};
    metal::float2 _e49 = _uv_1;
    param_47 = _e49;
    metal::float4 _e50 = transition(param_47, _from, _sampler, _to, uniforms);
    _fragColor = _e50;
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
