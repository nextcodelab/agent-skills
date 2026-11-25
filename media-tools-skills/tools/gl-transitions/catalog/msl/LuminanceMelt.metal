// LuminanceMelt — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LuminanceMelt.glsl
// Author: 0gust1
// License: MIT
// Description: The outgoing image melts away in noisy vertical streaks, depending on its brightness
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int direction;
    float l_threshold;
    int above;
};

float luminance(
    thread metal::float4& color
) {
    float _e44 = color[0u];
    float _e47 = color[1u];
    float _e51 = color[2u];
    return ((_e44 * 0.299) + (_e47 * 0.587)) + (_e51 * 0.114);
}

float rand(
    thread metal::float2& co
) {
    metal::float2 _e43 = co;
    return metal::fract(metal::sin(metal::dot(_e43, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float3 mod289_u0028_vf3_u003b(
    thread metal::float3& x
) {
    metal::float3 _e43 = x;
    metal::float3 _e44 = x;
    return _e43 - (metal::floor(_e44 * 0.0034602077) * 289.0);
}

metal::float3 permute(
    thread metal::float3& x_1
) {
    metal::float3 param = {};
    metal::float3 _e44 = x_1;
    metal::float3 _e48 = x_1;
    param = ((_e44 * 34.0) + metal::float3(1.0)) * _e48;
    metal::float3 _e50 = mod289_u0028_vf3_u003b(param);
    return _e50;
}

metal::float2 mod289_u0028_vf2_u003b(
    thread metal::float2& x_2
) {
    metal::float2 _e43 = x_2;
    metal::float2 _e44 = x_2;
    return _e43 - (metal::floor(_e44 * 0.0034602077) * 289.0);
}

float snoise(
    thread metal::float2& v
) {
    metal::float2 i = {};
    metal::float2 x0_ = {};
    metal::float2 i1_ = {};
    metal::float4 x12_ = {};
    metal::float2 param_1 = {};
    metal::float3 p = {};
    metal::float3 param_2 = {};
    metal::float3 param_3 = {};
    metal::float3 m = {};
    metal::float3 x_3 = {};
    metal::float3 h = {};
    metal::float3 ox = {};
    metal::float3 a0_ = {};
    metal::float3 g = {};
    metal::float2 _e57 = v;
    metal::float2 _e58 = v;
    i = metal::floor(_e57 + metal::float2(metal::dot(_e58, metal::float2(0.36602542, 0.36602542))));
    metal::float2 _e63 = v;
    metal::float2 _e64 = i;
    metal::float2 _e66 = i;
    x0_ = (_e63 - _e64) + metal::float2(metal::dot(_e66, metal::float2(0.21132487, 0.21132487)));
    float _e71 = x0_[0u];
    float _e73 = x0_[1u];
    i1_ = metal::select(metal::float2(0.0, 1.0), metal::float2(1.0, 0.0), metal::bool2(_e71 > _e73));
    metal::float2 _e77 = x0_;
    x12_ = _e77.xyxy + metal::float4(0.21132487, 0.21132487, -0.57735026, -0.57735026);
    metal::float2 _e80 = i1_;
    metal::float4 _e81 = x12_;
    metal::float2 _e83 = _e81.xy - _e80;
    x12_[0u] = _e83.x;
    x12_[1u] = _e83.y;
    metal::float2 _e88 = i;
    param_1 = _e88;
    metal::float2 _e89 = mod289_u0028_vf2_u003b(param_1);
    i = _e89;
    float _e91 = i[1u];
    float _e93 = i1_[1u];
    param_2 = metal::float3(_e91) + metal::float3(0.0, _e93, 1.0);
    metal::float3 _e97 = permute(param_2);
    float _e99 = i[0u];
    float _e103 = i1_[0u];
    param_3 = (_e97 + metal::float3(_e99)) + metal::float3(0.0, _e103, 1.0);
    metal::float3 _e106 = permute(param_3);
    p = _e106;
    metal::float2 _e107 = x0_;
    metal::float2 _e108 = x0_;
    metal::float4 _e110 = x12_;
    metal::float4 _e112 = x12_;
    metal::float4 _e115 = x12_;
    metal::float4 _e117 = x12_;
    m = metal::max(metal::float3(0.5) - metal::float3(metal::dot(_e107, _e108), metal::dot(_e110.xy, _e112.xy), metal::dot(_e115.zw, _e117.zw)), metal::float3(0.0));
    metal::float3 _e125 = m;
    metal::float3 _e126 = m;
    m = _e125 * _e126;
    metal::float3 _e128 = m;
    metal::float3 _e129 = m;
    m = _e128 * _e129;
    metal::float3 _e131 = p;
    x_3 = (metal::fract(_e131 * metal::float3(0.024390243, 0.024390243, 0.024390243)) * 2.0) - metal::float3(1.0);
    metal::float3 _e137 = x_3;
    h = metal::abs(_e137) - metal::float3(0.5);
    metal::float3 _e141 = x_3;
    ox = metal::floor(_e141 + metal::float3(0.5));
    metal::float3 _e145 = x_3;
    metal::float3 _e146 = ox;
    a0_ = _e145 - _e146;
    metal::float3 _e148 = a0_;
    metal::float3 _e149 = a0_;
    metal::float3 _e151 = h;
    metal::float3 _e152 = h;
    metal::float3 _e158 = m;
    m = _e158 * (metal::float3(1.7928429) - (((_e148 * _e149) + (_e151 * _e152)) * 0.85373473));
    float _e161 = a0_[0u];
    float _e163 = x0_[0u];
    float _e166 = h[0u];
    float _e168 = x0_[1u];
    g[0u] = (_e161 * _e163) + (_e166 * _e168);
    metal::float3 _e172 = a0_;
    metal::float4 _e174 = x12_;
    metal::float3 _e177 = h;
    metal::float4 _e179 = x12_;
    metal::float2 _e182 = (_e172.yz * _e174.xz) + (_e177.yz * _e179.yw);
    g[1u] = _e182.x;
    g[2u] = _e182.y;
    metal::float3 _e187 = m;
    metal::float3 _e188 = g;
    return 130.0 * metal::dot(_e187, _e188);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e44 = uv[0u];
    float _e46 = uv[1u];
    metal::float4 _e49 = _to.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e44 = uv_1[0u];
    float _e46 = uv_1[1u];
    metal::float4 _e49 = _from.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 center = {};
    metal::float2 p_1 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float x_4 = {};
    float dist = {};
    metal::float2 param_6 = {};
    float r = {};
    metal::float2 param_7 = {};
    float m_1 = {};
    metal::float2 param_8 = {};
    metal::float4 param_9 = {};
    float local = {};
    metal::float2 param_10 = {};
    metal::float4 param_11 = {};
    float local_1 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    bool phi_392_ = {};
    bool phi_420_ = {};
    int _e62 = uniforms.direction;
    center = metal::float2(1.0, (_e62 != 0) ? 1.0 : 0.0);
    metal::float2 _e66 = uv_2;
    p_1 = _e66 / metal::float2(1.0, 1.0);
    float _e69 = uniforms.progress;
    if (_e69 == 0.0) {
        metal::float2 _e71 = p_1;
        param_4 = _e71;
        metal::float4 _e72 = getFromColor(param_4, _from, _sampler);
        return _e72;
    } else {
        float _e74 = uniforms.progress;
        if (_e74 == 1.0) {
            metal::float2 _e76 = p_1;
            param_5 = _e76;
            metal::float4 _e77 = getToColor(param_5, _sampler, _to);
            return _e77;
        } else {
            float _e79 = uniforms.progress;
            x_4 = _e79;
            metal::float2 _e80 = center;
            metal::float2 _e81 = p_1;
            float _e84 = uniforms.progress;
            float _e86 = p_1[0u];
            param_6 = metal::float2(_e86, 0.0);
            float _e88 = snoise(param_6);
            dist = metal::distance(_e80, _e81) - (_e84 * metal::exp(_e88));
            float _e92 = x_4;
            float _e94 = p_1[0u];
            param_7 = metal::float2(_e94, 0.1);
            float _e96 = rand(param_7);
            r = _e92 - _e96;
            int _e99 = uniforms.above;
            if (_e99 != 0) {
                float _e101 = dist;
                float _e102 = r;
                bool _e103 = _e101 <= _e102;
                phi_392_ = _e103;
                if (_e103) {
                    metal::float2 _e104 = p_1;
                    param_8 = _e104;
                    metal::float4 _e105 = getFromColor(param_8, _from, _sampler);
                    param_9 = _e105;
                    float _e106 = luminance(param_9);
                    float _e108 = uniforms.l_threshold;
                    phi_392_ = _e106 > _e108;
                }
                bool _e111 = phi_392_;
                if (_e111) {
                    local = 1.0;
                } else {
                    float _e113 = uniforms.progress;
                    float _e115 = uniforms.progress;
                    float _e118 = uniforms.progress;
                    local = (_e113 * _e115) * _e118;
                }
                float _e120 = local;
                m_1 = _e120;
            } else {
                float _e121 = dist;
                float _e122 = r;
                bool _e123 = _e121 <= _e122;
                phi_420_ = _e123;
                if (_e123) {
                    metal::float2 _e124 = p_1;
                    param_10 = _e124;
                    metal::float4 _e125 = getFromColor(param_10, _from, _sampler);
                    param_11 = _e125;
                    float _e126 = luminance(param_11);
                    float _e128 = uniforms.l_threshold;
                    phi_420_ = _e126 < _e128;
                }
                bool _e131 = phi_420_;
                if (_e131) {
                    local_1 = 1.0;
                } else {
                    float _e133 = uniforms.progress;
                    float _e135 = uniforms.progress;
                    float _e138 = uniforms.progress;
                    local_1 = (_e133 * _e135) * _e138;
                }
                float _e140 = local_1;
                m_1 = _e140;
            }
            metal::float2 _e141 = p_1;
            param_12 = _e141;
            metal::float4 _e142 = getFromColor(param_12, _from, _sampler);
            metal::float2 _e143 = p_1;
            param_13 = _e143;
            metal::float4 _e144 = getToColor(param_13, _sampler, _to);
            float _e145 = m_1;
            return metal::mix(_e142, _e144, metal::float4(_e145));
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
    metal::float2 param_14 = {};
    metal::float2 _e43 = _uv_1;
    param_14 = _e43;
    metal::float4 _e44 = transition(param_14, _from, _sampler, _to, uniforms);
    _fragColor = _e44;
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
