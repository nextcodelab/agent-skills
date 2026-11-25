// WaterDrop — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WaterDrop.glsl
// Author: Paweł Płóciennik
// License: MIT
// Description: A drop falls into the image like into still water: round ripples spread out from where it hits, bending the image with glints on their slopes, the incoming image shows up inside the leading ripple, and the water calms down
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float amplitude;
    float speed;
    metal::float2 center;
    float refraction;
    float highlight;
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e39 = v;
    metal::float2 _e40 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e39 - (metal::floor(_e39 / _e40) * _e40)));
}

float wave(
    thread float& s,
    thread float& k,
    thread float& lambda,
    thread float& t,
    constant Uniforms& uniforms
) {
    float env = {};
    float _e43 = lambda;
    float _e45 = lambda;
    float _e47 = s;
    float _e49 = s;
    float _e51 = lambda;
    env = metal::smoothstep(-0.3 * _e43, 0.6 * _e45, _e47) * metal::exp(-(_e49) / (3.5 * _e51));
    float _e56 = env;
    float _e57 = k;
    float _e58 = s;
    float _e61 = uniforms.speed;
    float _e62 = t;
    return _e56 * metal::sin((_e57 * _e58) + (_e61 * _e62));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e40 = uv[0u];
    float _e42 = uv[1u];
    metal::float4 _e45 = _to.sample(_sampler, metal::float2(_e40, 1.0 - _e42), metal::level(0.0));
    return _e45;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e40 = uv_1[0u];
    float _e42 = uv_1[1u];
    metal::float4 _e45 = _from.sample(_sampler, metal::float2(_e40, 1.0 - _e42), metal::level(0.0));
    return _e45;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float k_1 = {};
    float lambda_1 = {};
    metal::float2 q = {};
    float r = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 far = {};
    float R = {};
    float edge = {};
    float soft = {};
    float t_1 = {};
    float e = {};
    float front = {};
    float s_1 = {};
    float calm = {};
    float d = {};
    float r0_ = {};
    float slope = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    metal::float2 offset = {};
    metal::float4 ca = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float4 cb = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float m = {};
    metal::float4 c = {};
    float h = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float lit = {};
    float glint = {};
    metal::float4 local_1 = {};
    float _e85 = uniforms.progress;
    if (_e85 <= 0.0) {
        metal::float2 _e87 = uv_2;
        param = _e87;
        metal::float4 _e88 = getFromColor(param, _from, _sampler);
        return _e88;
    }
    float _e90 = uniforms.progress;
    if (_e90 >= 1.0) {
        metal::float2 _e92 = uv_2;
        param_1 = _e92;
        metal::float4 _e93 = getToColor(param_1, _sampler, _to);
        return _e93;
    }
    float _e95 = uniforms.amplitude;
    k_1 = 2.0 * metal::max(_e95, 1.0);
    float _e98 = k_1;
    lambda_1 = 6.2831855 / _e98;
    metal::float2 _e100 = uv_2;
    metal::float2 _e102 = uniforms.center;
    float _e105 = uniforms.ratio;
    q = (_e100 - _e102) * metal::float2(_e105, 1.0);
    metal::float2 _e108 = q;
    r = metal::length(_e108);
    float _e110 = r;
    if (_e110 > 0.0) {
        metal::float2 _e112 = q;
        float _e113 = r;
        local = _e112 / metal::float2(_e113);
    } else {
        local = metal::float2(0.0, 0.0);
    }
    metal::float2 _e116 = local;
    dir = _e116;
    metal::float2 _e118 = uniforms.center;
    metal::float2 _e120 = uniforms.center;
    float _e125 = uniforms.ratio;
    far = metal::max(_e118, metal::float2(1.0) - _e120) * metal::float2(_e125, 1.0);
    metal::float2 _e128 = far;
    R = metal::length(_e128);
    float _e130 = lambda_1;
    edge = 0.35 * _e130;
    float _e132 = lambda_1;
    soft = 0.1 * _e132;
    float _e135 = uniforms.progress;
    t_1 = _e135;
    float _e136 = t_1;
    float _e137 = t_1;
    float _e139 = t_1;
    e = metal::mix(_e136, 1.0 - ((1.0 - _e137) * (1.0 - _e139)), 0.4);
    float _e144 = lambda_1;
    float _e146 = R;
    float _e147 = edge;
    float _e149 = soft;
    float _e152 = e;
    front = metal::mix(-0.3 * _e144, ((_e146 + _e147) + _e149) + 0.01, _e152);
    float _e154 = front;
    float _e155 = r;
    s_1 = _e154 - _e155;
    float _e157 = t_1;
    calm = 1.0 - metal::smoothstep(0.55, 1.0, _e157);
    float _e160 = calm;
    float _e161 = calm;
    calm = _e161 * _e160;
    float _e163 = lambda_1;
    d = 0.02 * _e163;
    float _e165 = r;
    float _e166 = d;
    r0_ = metal::max(_e165 - _e166, 0.0);
    float _e169 = calm;
    float _e170 = front;
    float _e171 = r;
    float _e173 = d;
    param_2 = (_e170 - _e171) - _e173;
    float _e175 = k_1;
    param_3 = _e175;
    float _e176 = lambda_1;
    param_4 = _e176;
    float _e177 = t_1;
    param_5 = _e177;
    float _e178 = wave(param_2, param_3, param_4, param_5, uniforms);
    float _e179 = front;
    float _e180 = r0_;
    param_6 = _e179 - _e180;
    float _e182 = k_1;
    param_7 = _e182;
    float _e183 = lambda_1;
    param_8 = _e183;
    float _e184 = t_1;
    param_9 = _e184;
    float _e185 = wave(param_6, param_7, param_8, param_9, uniforms);
    float _e188 = r;
    float _e189 = d;
    float _e191 = r0_;
    float _e193 = k_1;
    slope = (_e169 * (_e178 - _e185)) / (((_e188 + _e189) - _e191) * _e193);
    metal::float2 _e196 = dir;
    float _e197 = slope;
    float _e200 = uniforms.refraction;
    float _e203 = uniforms.ratio;
    offset = ((_e196 * _e197) * _e200) / metal::float2(_e203, 1.0);
    metal::float2 _e206 = uv_2;
    metal::float2 _e207 = offset;
    param_10 = _e206 - _e207;
    metal::float2 _e209 = mirror(param_10);
    param_11 = _e209;
    metal::float4 _e210 = getFromColor(param_11, _from, _sampler);
    ca = _e210;
    metal::float2 _e211 = uv_2;
    metal::float2 _e212 = offset;
    param_12 = _e211 - _e212;
    metal::float2 _e214 = mirror(param_12);
    param_13 = _e214;
    metal::float4 _e215 = getToColor(param_13, _sampler, _to);
    cb = _e215;
    float _e216 = edge;
    float _e217 = soft;
    float _e219 = edge;
    float _e220 = soft;
    float _e222 = s_1;
    m = metal::smoothstep(_e216 - _e217, _e219 + _e220, _e222);
    metal::float4 _e224 = ca;
    float _e227 = ca[3u];
    metal::float3 _e228 = _e224.xyz * _e227;
    float _e230 = ca[3u];
    metal::float4 _e235 = cb;
    float _e238 = cb[3u];
    metal::float3 _e239 = _e235.xyz * _e238;
    float _e241 = cb[3u];
    float _e246 = m;
    c = metal::mix(metal::float4(_e228.x, _e228.y, _e228.z, _e230), metal::float4(_e239.x, _e239.y, _e239.z, _e241), metal::float4(_e246));
    float _e249 = calm;
    float _e250 = s_1;
    param_14 = _e250;
    float _e251 = k_1;
    param_15 = _e251;
    float _e252 = lambda_1;
    param_16 = _e252;
    float _e253 = t_1;
    param_17 = _e253;
    float _e254 = wave(param_14, param_15, param_16, param_17, uniforms);
    h = _e249 * _e254;
    metal::float2 _e256 = dir;
    float _e259 = slope;
    lit = -(metal::dot(_e256, metal::float2(-0.6, 0.8))) * _e259;
    float _e262 = uniforms.highlight;
    float _e263 = h;
    float _e265 = lit;
    float _e269 = lit;
    glint = _e262 * (((0.2 * _e263) + (0.6 * metal::smoothstep(0.2, 0.9, _e265))) - (0.3 * metal::smoothstep(0.2, 0.9, -(_e269))));
    metal::float4 _e275 = c;
    float _e277 = glint;
    float _e279 = c[3u];
    float _e284 = c[3u];
    metal::float3 _e287 = metal::clamp(_e275.xyz + metal::float3(_e277 * _e279), metal::float3(0.0), metal::float3(_e284));
    c[0u] = _e287.x;
    c[1u] = _e287.y;
    c[2u] = _e287.z;
    float _e295 = c[3u];
    if (_e295 > 0.0) {
        metal::float4 _e297 = c;
        float _e300 = c[3u];
        metal::float3 _e302 = _e297.xyz / metal::float3(_e300);
        float _e304 = c[3u];
        local_1 = metal::float4(_e302.x, _e302.y, _e302.z, _e304);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e309 = local_1;
    return _e309;
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
    metal::float2 _e39 = _uv_1;
    param_18 = _e39;
    metal::float4 _e40 = transition(param_18, _from, _sampler, _to, uniforms);
    _fragColor = _e40;
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
