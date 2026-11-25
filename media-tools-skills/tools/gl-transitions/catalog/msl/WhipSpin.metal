// WhipSpin — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WhipSpin.glsl
// Author: gre
// License: MIT
// Description: The camera rolls faster and faster around the center of the frame, streaking the outgoing image in a spin blur, then the incoming one takes over mid-spin and slows to a stop
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float turns;
    float blur;
    float chroma;
    float zoom;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e36 = uv[0u];
    float _e38 = uv[1u];
    metal::float4 _e41 = _to.sample(_sampler, metal::float2(_e36, 1.0 - _e38), metal::level(0.0));
    return _e41;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e36 = uv_1[0u];
    float _e38 = uv_1[1u];
    metal::float4 _e41 = _from.sample(_sampler, metal::float2(_e36, 1.0 - _e38), metal::level(0.0));
    return _e41;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 m = {};
    metal::float2 _e36 = v;
    metal::float2 _e37 = metal::float2(2.0);
    m = _e36 - (metal::floor(_e36 / _e37) * _e37);
    metal::float2 _e42 = m;
    metal::float2 _e43 = m;
    metal::float2 _e46 = m;
    return metal::mix(_e42, metal::float2(2.0) - _e43, metal::step(metal::float2(1.0), _e46));
}

float rollAngle(
    thread float& t,
    constant Uniforms& uniforms
) {
    float halfTurn = {};
    float x = {};
    float x_1 = {};
    float _e39 = uniforms.turns;
    halfTurn = 3.1415927 * _e39;
    float _e41 = t;
    if (_e41 < 0.5) {
        float _e43 = t;
        x = 2.0 * _e43;
        float _e45 = halfTurn;
        float _e46 = x;
        float _e48 = x;
        float _e50 = x;
        return ((_e45 * _e46) * _e48) * _e50;
    }
    float _e52 = t;
    x_1 = 2.0 - (2.0 * _e52);
    float _e55 = halfTurn;
    float _e57 = x_1;
    float _e59 = x_1;
    float _e61 = x_1;
    return ((-(_e55) * _e57) * _e59) * _e61;
}

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e36 = p;
    p3_ = metal::fract(_e36.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e40 = p3_;
    metal::float3 _e41 = p3_;
    metal::float3 _e46 = p3_;
    p3_ = _e46 + metal::float3(metal::dot(_e40, _e41.yzx + metal::float3(33.33)));
    float _e50 = p3_[0u];
    float _e52 = p3_[1u];
    float _e55 = p3_[2u];
    return metal::fract((_e50 + _e52) * _e55);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_1 = {};
    float h = {};
    float shutter = {};
    float scale = {};
    metal::float2 q = {};
    float jitter = {};
    metal::float2 param = {};
    metal::float3 color = {};
    metal::float3 weight = {};
    float alpha = {};
    int i = {};
    float s = {};
    float t_1 = {};
    float a = {};
    float param_1 = {};
    float c = {};
    float sn = {};
    metal::float2 r = {};
    metal::float2 suv = {};
    metal::float2 param_2 = {};
    metal::float4 col = {};
    metal::float4 local = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float3 w = {};
    float _e61 = uniforms.progress;
    p_1 = _e61;
    float _e62 = p_1;
    h = 1.0 - metal::abs((2.0 * _e62) - 1.0);
    float _e68 = uniforms.blur;
    float _e70 = h;
    shutter = (_e68 * 0.1) * _e70;
    float _e73 = uniforms.zoom;
    float _e74 = h;
    float _e76 = h;
    float _e78 = h;
    scale = 1.0 + (((_e73 * _e74) * _e76) * _e78);
    metal::float2 _e81 = uv_2;
    float _e85 = uniforms.ratio;
    q = (_e81 - metal::float2(0.5)) * metal::float2(_e85, 1.0);
    metal::float2 _e88 = uv_2;
    float _e90 = uniforms.ratio;
    param = (_e88 * metal::float2(_e90, 1.0)) * 731.0;
    float _e94 = hash(param);
    jitter = _e94;
    color = metal::float3(0.0, 0.0, 0.0);
    weight = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e187 = i;
            i = as_type<int>(as_type<uint>(_e187) + as_type<uint>(1));
        }
        loop_init = false;
        int _e95 = i;
        if (_e95 < 24) {
            int _e97 = i;
            float _e99 = jitter;
            s = ((static_cast<float>(_e97) + _e99) / 24.0) - 0.5;
            float _e103 = p_1;
            float _e104 = s;
            float _e105 = shutter;
            t_1 = metal::clamp(_e103 + (_e104 * _e105), 0.0, 1.0);
            float _e109 = t_1;
            param_1 = _e109;
            float _e110 = rollAngle(param_1, uniforms);
            a = _e110;
            float _e111 = a;
            c = metal::cos(_e111);
            float _e113 = a;
            sn = metal::sin(_e113);
            float _e115 = c;
            float _e117 = q[0u];
            float _e119 = sn;
            float _e121 = q[1u];
            float _e124 = sn;
            float _e127 = q[0u];
            float _e129 = c;
            float _e131 = q[1u];
            float _e135 = scale;
            r = metal::float2((_e115 * _e117) + (_e119 * _e121), (-(_e124) * _e127) + (_e129 * _e131)) / metal::float2(_e135);
            metal::float2 _e138 = r;
            float _e140 = uniforms.ratio;
            param_2 = (_e138 / metal::float2(_e140, 1.0)) + metal::float2(0.5);
            metal::float2 _e145 = mirror(param_2);
            suv = _e145;
            float _e146 = t_1;
            if (_e146 < 0.5) {
                metal::float2 _e148 = suv;
                param_3 = _e148;
                metal::float4 _e149 = getFromColor(param_3, _from, _sampler);
                local = _e149;
            } else {
                metal::float2 _e150 = suv;
                param_4 = _e150;
                metal::float4 _e151 = getToColor(param_4, _sampler, _to);
                local = _e151;
            }
            metal::float4 _e152 = local;
            col = _e152;
            float _e154 = uniforms.chroma;
            float _e156 = s;
            float _e160 = uniforms.chroma;
            float _e162 = s;
            w = metal::max(metal::float3(1.0 - ((4.0 * _e154) * _e156), 1.0, 1.0 + ((4.0 * _e160) * _e162)), metal::float3(0.0));
            metal::float4 _e168 = col;
            float _e171 = col[3u];
            metal::float3 _e173 = w;
            metal::float3 _e175 = color;
            color = _e175 + ((_e168.xyz * _e171) * _e173);
            float _e178 = col[3u];
            metal::float3 _e179 = w;
            metal::float3 _e181 = weight;
            weight = _e181 + (_e179 * _e178);
            float _e184 = col[3u];
            float _e185 = alpha;
            alpha = _e185 + _e184;
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e189 = color;
    metal::float3 _e190 = weight;
    metal::float3 _e192 = _e189 / metal::max(_e190, metal::float3(0.00001, 0.00001, 0.00001));
    float _e193 = alpha;
    return metal::float4(_e192.x, _e192.y, _e192.z, _e193 / 24.0);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_5 = {};
    metal::float2 _e35 = _uv_1;
    param_5 = _e35;
    metal::float4 _e36 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e36;
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
