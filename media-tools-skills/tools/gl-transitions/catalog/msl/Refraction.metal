// Refraction — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Refraction.glsl
// Author: gre
// License: MIT
// Description: The frame is seen through flowing liquid glass that bends the outgoing image more and more, with rainbow fringes, flares up as the incoming image takes over, then calms down and clears
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
    float scale;
    float dispersion;
    float brightness;
};

metal::float3 spectrum(
    thread float& w
) {
    metal::float3 c = {};
    float _e64 = w;
    float _e67 = w;
    float _e71 = w;
    float _e77 = w;
    c = metal::float3((1.0 - metal::smoothstep(0.0, 0.55, _e64)) + (0.35 * metal::smoothstep(0.75, 1.0, _e67)), 1.0 - (metal::abs((2.0 * _e71) - 1.0) * 1.2), metal::smoothstep(0.45, 1.0, _e77));
    metal::float3 _e80 = c;
    return metal::clamp(_e80, metal::float3(0.0), metal::float3(1.0));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e64 = uv[0u];
    float _e66 = uv[1u];
    metal::float4 _e69 = _to.sample(_sampler, metal::float2(_e64, 1.0 - _e66), metal::level(0.0));
    return _e69;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e64 = uv_1[0u];
    float _e66 = uv_1[1u];
    metal::float4 _e69 = _from.sample(_sampler, metal::float2(_e64, 1.0 - _e66), metal::level(0.0));
    return _e69;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e63 = v;
    metal::float2 _e64 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e63 - (metal::floor(_e63 / _e64) * _e64)));
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e64 = v_1;
    v3_ = metal::fract(_e64.xyx * 0.1031);
    metal::float3 _e68 = v3_;
    metal::float3 _e69 = v3_;
    metal::float3 _e74 = v3_;
    v3_ = _e74 + metal::float3(metal::dot(_e68, _e69.yzx + metal::float3(33.33)));
    float _e78 = v3_[0u];
    float _e80 = v3_[1u];
    float _e83 = v3_[2u];
    return metal::fract((_e78 + _e80) * _e83);
}

float surface(
    thread metal::float2& q,
    thread float& t
) {
    float h = {};
    float _e66 = q[1u];
    float _e68 = t;
    float _e73 = q[0u];
    float _e75 = t;
    metal::float2 _e81 = q;
    q = _e81 + (metal::float2(metal::sin((1.3 * _e66) + (0.9 * _e68)), metal::sin((1.1 * _e73) - (1.2 * _e75))) * 0.45);
    float _e84 = q[0u];
    float _e85 = t;
    float _e90 = q[1u];
    float _e92 = t;
    h = metal::sin(_e84 + (0.6 * _e85)) * metal::sin((1.2 * _e90) - (0.8 * _e92));
    metal::float2 _e97 = q;
    float _e99 = t;
    float _e104 = h;
    h = _e104 + (0.5 * metal::sin(metal::dot(_e97, metal::float2(1.6, -1.2)) + (1.4 * _e99)));
    metal::float2 _e106 = q;
    float _e108 = t;
    float _e112 = q[0u];
    float _e119 = h;
    h = _e119 + (0.3 * metal::sin((metal::dot(_e106, metal::float2(-1.1, 2.9)) - (1.9 * _e108)) + (1.7 * metal::sin(0.9 * _e112))));
    metal::float2 _e121 = q;
    float _e123 = t;
    float _e128 = h;
    h = _e128 + (0.15 * metal::sin(metal::dot(_e121, metal::float2(4.3, 3.1)) + (2.6 * _e123)));
    float _e130 = h;
    return _e130;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float h_1 = {};
    float amount = {};
    metal::float2 q_1 = {};
    float t_1 = {};
    float e = {};
    metal::float2 slope = {};
    metal::float2 param = {};
    float param_1 = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    metal::float2 param_4 = {};
    float param_5 = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    metal::float2 offset = {};
    float wave = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float m = {};
    metal::float3 color = {};
    metal::float3 weights = {};
    float alpha = {};
    float jitter = {};
    metal::float2 param_10 = {};
    int i = {};
    float w_1 = {};
    float wj = {};
    metal::float2 st = {};
    metal::float2 param_11 = {};
    metal::float4 c_1 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float3 s = {};
    float param_14 = {};
    float flare = {};
    float _e100 = uniforms.progress;
    p = _e100;
    float _e101 = p;
    h_1 = 1.0 - metal::abs((2.0 * _e101) - 1.0);
    float _e106 = h_1;
    float _e107 = h_1;
    float _e109 = h_1;
    amount = (_e106 * _e107) * (2.0 - _e109);
    metal::float2 _e112 = uv_2;
    float _e116 = uniforms.ratio;
    float _e120 = uniforms.scale;
    q_1 = ((_e112 - metal::float2(0.5)) * metal::float2(_e116, 1.0)) * _e120;
    float _e122 = p;
    t_1 = 3.0 * _e122;
    e = 0.01;
    metal::float2 _e124 = q_1;
    float _e125 = e;
    param = _e124 + metal::float2(_e125, 0.0);
    float _e128 = t_1;
    param_1 = _e128;
    float _e129 = surface(param, param_1);
    metal::float2 _e130 = q_1;
    float _e131 = e;
    param_2 = _e130 - metal::float2(_e131, 0.0);
    float _e134 = t_1;
    param_3 = _e134;
    float _e135 = surface(param_2, param_3);
    metal::float2 _e137 = q_1;
    float _e138 = e;
    param_4 = _e137 + metal::float2(0.0, _e138);
    float _e141 = t_1;
    param_5 = _e141;
    float _e142 = surface(param_4, param_5);
    metal::float2 _e143 = q_1;
    float _e144 = e;
    param_6 = _e143 - metal::float2(0.0, _e144);
    float _e147 = t_1;
    param_7 = _e147;
    float _e148 = surface(param_6, param_7);
    float _e151 = e;
    slope = metal::float2(_e129 - _e135, _e142 - _e148) / metal::float2(2.0 * _e151);
    metal::float2 _e155 = slope;
    float _e157 = uniforms.strength;
    float _e159 = amount;
    float _e162 = uniforms.scale;
    offset = ((_e155 * _e157) * _e159) / metal::float2(_e162);
    metal::float2 _e165 = q_1;
    param_8 = _e165;
    float _e166 = t_1;
    param_9 = _e166;
    float _e167 = surface(param_8, param_9);
    wave = metal::clamp(0.5 * _e167, -1.0, 1.0);
    float _e170 = p;
    float _e172 = wave;
    m = metal::smoothstep(-0.015, 0.015, (_e170 - 0.5) + (0.1 * _e172));
    color = metal::float3(0.0, 0.0, 0.0);
    weights = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    metal::float2 _e176 = uv_2;
    float _e178 = uniforms.ratio;
    param_10 = (_e176 * metal::float2(_e178, 1.0)) * 1000.0;
    float _e182 = hash12(param_10);
    jitter = _e182 - 0.5;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e231 = i;
            i = as_type<int>(as_type<uint>(_e231) + as_type<uint>(1));
        }
        loop_init = false;
        int _e184 = i;
        if (_e184 < 7) {
            int _e186 = i;
            w_1 = static_cast<float>(_e186) / 6.0;
            int _e189 = i;
            float _e191 = jitter;
            wj = (static_cast<float>(_e189) + _e191) / 6.0;
            metal::float2 _e194 = uv_2;
            metal::float2 _e195 = offset;
            float _e197 = uniforms.dispersion;
            float _e198 = wj;
            param_11 = _e194 + (_e195 * (1.0 + ((_e197 * (_e198 - 0.5)) * 1.6)));
            metal::float2 _e205 = mirror(param_11);
            st = _e205;
            metal::float2 _e206 = st;
            param_12 = _e206;
            metal::float4 _e207 = getFromColor(param_12, _from, _sampler);
            metal::float2 _e208 = st;
            param_13 = _e208;
            metal::float4 _e209 = getToColor(param_13, _sampler, _to);
            float _e210 = m;
            c_1 = metal::mix(_e207, _e209, metal::float4(_e210));
            float _e213 = w_1;
            param_14 = _e213;
            metal::float3 _e214 = spectrum(param_14);
            s = _e214;
            metal::float3 _e215 = s;
            metal::float4 _e216 = c_1;
            float _e220 = c_1[3u];
            metal::float3 _e222 = color;
            color = _e222 + ((_e215 * _e216.xyz) * _e220);
            metal::float3 _e224 = s;
            metal::float3 _e225 = weights;
            weights = _e225 + _e224;
            float _e228 = c_1[3u];
            float _e229 = alpha;
            alpha = _e229 + _e228;
            continue;
        } else {
            break;
        }
    }
    float _e233 = alpha;
    alpha = _e233 / 7.0;
    metal::float3 _e235 = color;
    metal::float3 _e236 = weights;
    float _e238 = alpha;
    color = (_e235 / _e236) / metal::float3(metal::max(_e238, 0.00001));
    float _e243 = uniforms.brightness;
    float _e245 = h_1;
    flare = (2.0 * _e243) * metal::pow(_e245, 8.0);
    metal::float3 _e248 = color;
    float _e249 = flare;
    float _e252 = flare;
    metal::float3 _e253 = color;
    color = (_e248 * (1.0 + _e249)) / (metal::float3(1.0) + (_e253 * _e252));
    float _e258 = flare;
    metal::float3 _e260 = color;
    metal::float3 _e263 = color;
    color = _e263 + metal::float3((0.1 * _e258) * metal::dot(_e260, metal::float3(0.3333, 0.3333, 0.3333)));
    metal::float3 _e266 = color;
    metal::float3 _e269 = metal::clamp(_e266, metal::float3(0.0), metal::float3(1.0));
    float _e270 = alpha;
    return metal::float4(_e269.x, _e269.y, _e269.z, _e270);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_15 = {};
    metal::float2 _e63 = _uv_1;
    param_15 = _e63;
    metal::float4 _e64 = transition(param_15, _from, _sampler, _to, uniforms);
    _fragColor = _e64;
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
