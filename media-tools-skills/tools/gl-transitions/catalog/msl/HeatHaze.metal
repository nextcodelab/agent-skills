// HeatHaze — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HeatHaze.glsl
// Author: gre
// License: MIT
// Description: Shimmering heat waves rise through the frame, strongest at the bottom, making the outgoing image wobble like the air over hot asphalt; the incoming image shows through the haze and settles as it calms
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
    float speed;
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e45 = v;
    metal::float2 _e46 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e45 - (metal::floor(_e45 / _e46) * _e46)));
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e46 = v_1;
    v3_ = metal::fract(_e46.xyx * 0.1031);
    metal::float3 _e50 = v3_;
    metal::float3 _e51 = v3_;
    metal::float3 _e56 = v3_;
    v3_ = _e56 + metal::float3(metal::dot(_e50, _e51.yzx + metal::float3(33.33)));
    float _e60 = v3_[0u];
    float _e62 = v3_[1u];
    float _e65 = v3_[2u];
    return metal::fract((_e60 + _e62) * _e65);
}

float vnoise(
    thread metal::float2& v_2
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e51 = v_2;
    i = metal::floor(_e51);
    metal::float2 _e53 = v_2;
    f = metal::fract(_e53);
    metal::float2 _e55 = f;
    metal::float2 _e56 = f;
    metal::float2 _e58 = f;
    f = (_e55 * _e56) * (metal::float2(3.0) - (_e58 * 2.0));
    metal::float2 _e63 = i;
    param = _e63;
    float _e64 = hash12(param);
    metal::float2 _e65 = i;
    param_1 = _e65 + metal::float2(1.0, 0.0);
    float _e67 = hash12(param_1);
    float _e69 = f[0u];
    metal::float2 _e71 = i;
    param_2 = _e71 + metal::float2(0.0, 1.0);
    float _e73 = hash12(param_2);
    metal::float2 _e74 = i;
    param_3 = _e74 + metal::float2(1.0, 1.0);
    float _e76 = hash12(param_3);
    float _e78 = f[0u];
    float _e81 = f[1u];
    return metal::mix(metal::mix(_e64, _e67, _e69), metal::mix(_e73, _e76, _e78), _e81);
}

float fbm(
    thread metal::float2& v_3
) {
    float sum = {};
    float amp = {};
    int i_1 = {};
    metal::float2 param_4 = {};
    sum = 0.0;
    amp = 0.5;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e63 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e63) + as_type<uint>(1));
        }
        loop_init = false;
        int _e49 = i_1;
        if (_e49 < 4) {
            float _e51 = amp;
            metal::float2 _e52 = v_3;
            param_4 = _e52;
            float _e53 = vnoise(param_4);
            float _e55 = sum;
            sum = _e55 + (_e51 * _e53);
            metal::float2 _e57 = v_3;
            v_3 = (metal::float2x2(metal::float2(1.6, 1.2), metal::float2(-1.2, 1.6)) * _e57) + metal::float2(5.3);
            float _e61 = amp;
            amp = _e61 * 0.5;
            continue;
        } else {
            break;
        }
    }
    float _e65 = sum;
    return ((_e65 / 0.9375) - 0.5) * 3.0;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e46 = uv[0u];
    float _e48 = uv[1u];
    metal::float4 _e51 = _to.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e46 = uv_1[0u];
    float _e48 = uv_1[1u];
    metal::float4 _e51 = _from.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float p = {};
    float amount = {};
    float t = {};
    metal::float2 q = {};
    metal::float2 w = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 offset = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float ground = {};
    metal::float2 d = {};
    metal::float2 param_11 = {};
    float m = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float4 a = {};
    metal::float2 param_14 = {};
    metal::float4 b = {};
    metal::float2 param_15 = {};
    metal::float4 c = {};
    metal::float4 local = {};
    float _e70 = uniforms.progress;
    if (_e70 <= 0.0) {
        metal::float2 _e72 = uv_2;
        param_5 = _e72;
        metal::float4 _e73 = getFromColor(param_5, _from, _sampler);
        return _e73;
    }
    float _e75 = uniforms.progress;
    if (_e75 >= 1.0) {
        metal::float2 _e77 = uv_2;
        param_6 = _e77;
        metal::float4 _e78 = getToColor(param_6, _sampler, _to);
        return _e78;
    }
    float _e80 = uniforms.progress;
    p = _e80;
    float _e81 = p;
    amount = metal::sin(3.1415927 * _e81);
    float _e84 = p;
    float _e86 = uniforms.speed;
    t = _e84 * _e86;
    float _e89 = uv_2[0u];
    float _e91 = uniforms.ratio;
    float _e94 = uv_2[1u];
    float _e98 = uniforms.scale;
    q = metal::float2(_e89 * _e91, _e94 * 2.5) * _e98;
    float _e100 = t;
    float _e102 = uniforms.scale;
    float _e105 = q[1u];
    q[1u] = _e105 - (_e100 * _e102);
    metal::float2 _e108 = q;
    float _e110 = t;
    param_7 = (_e108 * 0.35) + metal::float2(0.0, _e110);
    float _e113 = fbm(param_7);
    metal::float2 _e114 = q;
    float _e116 = t;
    param_8 = (_e114 * 0.35) + metal::float2(7.1, -(_e116));
    float _e120 = fbm(param_8);
    w = metal::float2(_e113, _e120);
    metal::float2 _e122 = w;
    metal::float2 _e124 = q;
    q = _e124 + (_e122 * 1.5);
    metal::float2 _e126 = q;
    param_9 = _e126;
    float _e127 = fbm(param_9);
    metal::float2 _e128 = q;
    param_10 = _e128 + metal::float2(3.7, 1.9);
    float _e130 = fbm(param_10);
    offset = metal::float2(_e127, 0.5 * _e130);
    float _e134 = uv_2[1u];
    ground = metal::mix(1.0, 0.3, _e134);
    float _e137 = uniforms.strength;
    float _e138 = amount;
    float _e140 = ground;
    float _e143 = uniforms.ratio;
    metal::float2 _e147 = offset;
    offset = _e147 * (metal::float2(1.0 / _e143, 1.0) * ((_e137 * _e138) * _e140));
    metal::float2 _e149 = uv_2;
    metal::float2 _e150 = offset;
    param_11 = _e149 + _e150;
    metal::float2 _e152 = mirror(param_11);
    d = _e152;
    float _e153 = p;
    m = metal::smoothstep(0.3, 0.7, _e153);
    float _e155 = m;
    if (_e155 <= 0.0) {
        metal::float2 _e157 = d;
        param_12 = _e157;
        metal::float4 _e158 = getFromColor(param_12, _from, _sampler);
        return _e158;
    }
    float _e159 = m;
    if (_e159 >= 1.0) {
        metal::float2 _e161 = d;
        param_13 = _e161;
        metal::float4 _e162 = getToColor(param_13, _sampler, _to);
        return _e162;
    }
    metal::float2 _e163 = d;
    param_14 = _e163;
    metal::float4 _e164 = getFromColor(param_14, _from, _sampler);
    a = _e164;
    metal::float2 _e165 = d;
    param_15 = _e165;
    metal::float4 _e166 = getToColor(param_15, _sampler, _to);
    b = _e166;
    metal::float4 _e167 = a;
    float _e170 = a[3u];
    metal::float3 _e171 = _e167.xyz * _e170;
    float _e173 = a[3u];
    metal::float4 _e178 = b;
    float _e181 = b[3u];
    metal::float3 _e182 = _e178.xyz * _e181;
    float _e184 = b[3u];
    float _e189 = m;
    c = metal::mix(metal::float4(_e171.x, _e171.y, _e171.z, _e173), metal::float4(_e182.x, _e182.y, _e182.z, _e184), metal::float4(_e189));
    float _e193 = c[3u];
    if (_e193 > 0.0) {
        metal::float4 _e195 = c;
        float _e198 = c[3u];
        metal::float3 _e200 = _e195.xyz / metal::float3(_e198);
        float _e202 = c[3u];
        local = metal::float4(_e200.x, _e200.y, _e200.z, _e202);
    } else {
        local = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e207 = local;
    return _e207;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_16 = {};
    metal::float2 _e45 = _uv_1;
    param_16 = _e45;
    metal::float4 _e46 = transition(param_16, _from, _sampler, _to, uniforms);
    _fragColor = _e46;
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
