// CameraShake — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CameraShake.glsl
// Author: gre
// License: MIT
// Description: The camera jolts violently in random directions, with motion blur and color fringes along each jolt; the cut happens at the peak of the shake, which then settles on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
    float jolts;
    float blur;
    float split;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e43 = uv[0u];
    float _e45 = uv[1u];
    metal::float4 _e48 = _from.sample(_sampler, metal::float2(_e43, 1.0 - _e45), metal::level(0.0));
    return _e48;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e43 = uv_1[0u];
    float _e45 = uv_1[1u];
    metal::float4 _e48 = _to.sample(_sampler, metal::float2(_e43, 1.0 - _e45), metal::level(0.0));
    return _e48;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e42 = v;
    metal::float2 _e43 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e42 - (metal::floor(_e42 / _e43) * _e43)));
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e43 = v_1;
    v3_ = metal::fract(_e43.xyx * 0.1031);
    metal::float3 _e47 = v3_;
    metal::float3 _e48 = v3_;
    metal::float3 _e53 = v3_;
    v3_ = _e53 + metal::float3(metal::dot(_e47, _e48.yzx + metal::float3(33.33)));
    float _e57 = v3_[0u];
    float _e59 = v3_[1u];
    float _e62 = v3_[2u];
    return metal::fract((_e57 + _e59) * _e62);
}

metal::float3 jolt(
    thread float& k
) {
    float a = {};
    metal::float2 param = {};
    float m = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float _e47 = k;
    float _e49 = k;
    param = metal::float2(_e49, 11.0);
    float _e51 = hash12(param);
    a = (2.4 * _e47) + (1.2 * _e51);
    float _e54 = k;
    param_1 = metal::float2(_e54, 23.0);
    float _e56 = hash12(param_1);
    m = 0.55 + (0.45 * _e56);
    float _e59 = m;
    float _e60 = a;
    float _e63 = m;
    float _e64 = a;
    float _e67 = k;
    param_2 = metal::float2(_e67, 37.0);
    float _e69 = hash12(param_2);
    return metal::float3(_e59 * metal::cos(_e60), _e63 * metal::sin(_e64), (2.0 * _e69) - 1.0);
}

float envelope(
    thread float& t
) {
    float h = {};
    float _e43 = t;
    h = metal::clamp(1.6 * (1.0 - metal::abs((2.0 * _e43) - 1.0)), 0.0, 1.0);
    float _e50 = h;
    float _e51 = h;
    float _e53 = h;
    return (_e50 * _e51) * (3.0 - (2.0 * _e53));
}

metal::float4 shot(
    thread metal::float2& uv_2,
    thread float& t_1,
    thread bool& incoming,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float env = {};
    float param_3 = {};
    float s = {};
    float k_1 = {};
    float g = {};
    float e = {};
    metal::float3 j = {};
    float param_4 = {};
    float param_5 = {};
    float omax = {};
    float rmax = {};
    metal::float2 off = {};
    float roll = {};
    float zoom = {};
    metal::float2 q = {};
    metal::float2 p = {};
    metal::float2 param_6 = {};
    metal::float4 c = {};
    metal::float4 local = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float _e65 = t_1;
    param_3 = _e65;
    float _e66 = envelope(param_3);
    env = _e66;
    float _e67 = t_1;
    float _e70 = uniforms.jolts;
    s = (_e67 - 0.5) * _e70;
    float _e72 = s;
    k_1 = metal::floor(_e72);
    float _e74 = s;
    float _e75 = k_1;
    g = 1.0 - (_e74 - _e75);
    float _e78 = g;
    float _e79 = g;
    float _e81 = g;
    e = 1.0 - ((_e78 * _e79) * _e81);
    float _e84 = k_1;
    param_4 = _e84;
    metal::float3 _e85 = jolt(param_4);
    float _e86 = k_1;
    param_5 = _e86 + 1.0;
    metal::float3 _e88 = jolt(param_5);
    float _e89 = e;
    float _e92 = env;
    j = metal::mix(_e85, _e88, metal::float3(_e89)) * _e92;
    float _e95 = uniforms.strength;
    float _e97 = env;
    omax = (0.14 * _e95) * _e97;
    float _e100 = uniforms.strength;
    float _e102 = env;
    rmax = (0.07 * _e100) * _e102;
    metal::float3 _e104 = j;
    float _e106 = omax;
    off = _e104.xy * _e106;
    float _e109 = j[2u];
    float _e110 = rmax;
    roll = _e109 * _e110;
    float _e112 = rmax;
    float _e114 = rmax;
    float _e117 = uniforms.ratio;
    float _e119 = uniforms.ratio;
    float _e124 = omax;
    zoom = (metal::cos(_e112) + (metal::sin(_e114) * metal::max(_e117, 1.0 / _e119))) / (1.0 - (2.0 * _e124));
    metal::float2 _e128 = uv_2;
    float _e132 = uniforms.ratio;
    q = (_e128 - metal::float2(0.5)) * metal::float2(_e132, 1.0);
    float _e135 = roll;
    float _e137 = roll;
    float _e139 = roll;
    float _e142 = roll;
    metal::float2 _e147 = q;
    float _e149 = zoom;
    q = (metal::float2x2(metal::float2(metal::cos(_e135), metal::sin(_e137)), metal::float2(-(metal::sin(_e139)), metal::cos(_e142))) * _e147) / metal::float2(_e149);
    metal::float2 _e152 = q;
    float _e154 = uniforms.ratio;
    metal::float2 _e159 = off;
    param_6 = ((_e152 / metal::float2(_e154, 1.0)) + metal::float2(0.5)) + _e159;
    metal::float2 _e161 = mirror(param_6);
    p = _e161;
    bool _e162 = incoming;
    if (_e162) {
        metal::float2 _e163 = p;
        param_7 = _e163;
        metal::float4 _e164 = getToColor(param_7, _sampler, _to);
        local = _e164;
    } else {
        metal::float2 _e165 = p;
        param_8 = _e165;
        metal::float4 _e166 = getFromColor(param_8, _from, _sampler);
        local = _e166;
    }
    metal::float4 _e167 = local;
    c = _e167;
    metal::float4 _e168 = c;
    float _e171 = c[3u];
    metal::float3 _e172 = _e168.xyz * _e171;
    float _e174 = c[3u];
    return metal::float4(_e172.x, _e172.y, _e172.z, _e174);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float open = {};
    float param_9 = {};
    float shutter = {};
    float lag = {};
    metal::float2 sumR = {};
    metal::float2 sumG = {};
    metal::float2 sumB = {};
    float wsum = {};
    int i = {};
    float u = {};
    float t_2 = {};
    float w = {};
    bool incoming_1 = {};
    metal::float4 r = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    bool param_12 = {};
    metal::float4 c_1 = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    bool param_15 = {};
    metal::float4 b = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    bool param_18 = {};
    float alpha = {};
    metal::float3 color = {};
    float _e70 = uniforms.progress;
    param_9 = _e70;
    float _e71 = envelope(param_9);
    open = _e71;
    float _e73 = uniforms.blur;
    float _e76 = uniforms.jolts;
    float _e78 = open;
    shutter = ((0.8 * _e73) / _e76) * _e78;
    float _e81 = uniforms.split;
    float _e84 = uniforms.jolts;
    float _e86 = open;
    lag = ((0.2 * _e81) / _e84) * _e86;
    sumR = metal::float2(0.0, 0.0);
    sumG = metal::float2(0.0, 0.0);
    sumB = metal::float2(0.0, 0.0);
    wsum = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e144 = i;
            i = as_type<int>(as_type<uint>(_e144) + as_type<uint>(1));
        }
        loop_init = false;
        int _e88 = i;
        if (_e88 < 10) {
            int _e90 = i;
            u = ((static_cast<float>(_e90) + 0.5) / 10.0) - 0.5;
            float _e96 = uniforms.progress;
            float _e97 = u;
            float _e98 = shutter;
            t_2 = _e96 + (_e97 * _e98);
            float _e101 = u;
            w = 1.0 - (1.4 * metal::abs(_e101));
            float _e105 = t_2;
            incoming_1 = _e105 >= 0.5;
            float _e107 = t_2;
            float _e108 = lag;
            metal::float2 _e110 = uv_3;
            param_10 = _e110;
            param_11 = _e107 + _e108;
            bool _e111 = incoming_1;
            param_12 = _e111;
            metal::float4 _e112 = shot(param_10, param_11, param_12, _from, _sampler, _to, uniforms);
            r = _e112;
            metal::float2 _e113 = uv_3;
            param_13 = _e113;
            float _e114 = t_2;
            param_14 = _e114;
            bool _e115 = incoming_1;
            param_15 = _e115;
            metal::float4 _e116 = shot(param_13, param_14, param_15, _from, _sampler, _to, uniforms);
            c_1 = _e116;
            float _e117 = t_2;
            float _e118 = lag;
            metal::float2 _e120 = uv_3;
            param_16 = _e120;
            param_17 = _e117 - _e118;
            bool _e121 = incoming_1;
            param_18 = _e121;
            metal::float4 _e122 = shot(param_16, param_17, param_18, _from, _sampler, _to, uniforms);
            b = _e122;
            float _e123 = w;
            metal::float4 _e124 = r;
            metal::float2 _e127 = sumR;
            sumR = _e127 + (_e124.xw * _e123);
            float _e129 = w;
            metal::float4 _e130 = c_1;
            metal::float2 _e133 = sumG;
            sumG = _e133 + (_e130.yw * _e129);
            float _e135 = w;
            metal::float4 _e136 = b;
            metal::float2 _e139 = sumB;
            sumB = _e139 + (_e136.zw * _e135);
            float _e141 = w;
            float _e142 = wsum;
            wsum = _e142 + _e141;
            continue;
        } else {
            break;
        }
    }
    float _e147 = sumR[1u];
    float _e149 = sumG[1u];
    float _e152 = sumB[1u];
    float _e154 = wsum;
    alpha = ((_e147 + _e149) + _e152) / (3.0 * _e154);
    float _e157 = alpha;
    if (_e157 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    float _e160 = sumR[0u];
    float _e162 = sumR[1u];
    float _e166 = sumG[0u];
    float _e168 = sumG[1u];
    float _e172 = sumB[0u];
    float _e174 = sumB[1u];
    color = metal::float3(_e160 / metal::max(_e162, 0.00001), _e166 / metal::max(_e168, 0.00001), _e172 / metal::max(_e174, 0.00001));
    metal::float3 _e178 = color;
    float _e179 = alpha;
    return metal::float4(_e178.x, _e178.y, _e178.z, _e179);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_19 = {};
    metal::float2 _e42 = _uv_1;
    param_19 = _e42;
    metal::float4 _e43 = transition(param_19, _from, _sampler, _to, uniforms);
    _fragColor = _e43;
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
