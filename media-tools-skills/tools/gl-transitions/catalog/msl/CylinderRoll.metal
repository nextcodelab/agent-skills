// CylinderRoll — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CylinderRoll.glsl
// Author: gre
// License: MIT
// Description: The frame wraps around a drum that rolls up, the outgoing image turning away over its top in a motion blur and the incoming one coming around from below and unrolling flat
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float curvature;
    float blur;
    float shading;
    float chroma;
    int downward;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e45 = uv[0u];
    float _e47 = uv[1u];
    metal::float4 _e50 = _from.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e45 = uv_1[0u];
    float _e47 = uv_1[1u];
    metal::float4 _e50 = _to.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

float fold(
    thread float& v
) {
    float _e44 = v;
    return 1.0 - metal::abs(1.0 - (_e44 - (metal::floor(_e44 / 2.0) * 2.0)));
}

metal::float4 strip(
    thread float& x,
    thread float& v_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    bool local = {};
    float local_1 = {};
    float param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    metal::float2 param_3 = {};
    int _e52 = uniforms.downward;
    if (_e52 != 0) {
        float _e54 = v_1;
        local = _e54 > 1.0;
    } else {
        float _e56 = v_1;
        local = _e56 < 0.0;
    }
    bool _e58 = local;
    if (_e58) {
        float _e59 = x;
        int _e61 = uniforms.downward;
        if (_e61 != 0) {
            float _e63 = v_1;
            local_1 = _e63 - 1.0;
        } else {
            float _e65 = v_1;
            local_1 = _e65 + 1.0;
        }
        float _e67 = local_1;
        param = _e67;
        float _e68 = fold(param);
        param_1 = metal::float2(_e59, _e68);
        metal::float4 _e70 = getToColor(param_1, _sampler, _to);
        return _e70;
    }
    float _e71 = x;
    float _e72 = v_1;
    param_2 = _e72;
    float _e73 = fold(param_2);
    param_3 = metal::float2(_e71, _e73);
    metal::float4 _e75 = getFromColor(param_3, _from, _sampler);
    return _e75;
}

float hash(
    thread metal::float2& c
) {
    metal::float2 q = {};
    metal::float2 _e45 = c;
    q = metal::fract(_e45 * metal::float2(0.1031, 0.103));
    metal::float2 _e48 = q;
    metal::float2 _e49 = q;
    metal::float2 _e54 = q;
    q = _e54 + metal::float2(metal::dot(_e48, _e49.yx + metal::float2(33.33)));
    float _e58 = q[0u];
    float _e60 = q[1u];
    float _e63 = q[0u];
    return metal::fract((_e58 + _e60) * _e63);
}

float angleAt(
    thread float& c_1
) {
    float _e44 = c_1;
    c_1 = metal::clamp(_e44, -0.40833333, 0.40833333);
    float _e46 = c_1;
    float _e48 = c_1;
    float _e49 = c_1;
    float _e55 = c_1;
    return metal::asin((_e46 * 2.6) / metal::sqrt(1.0 + (_e48 * _e49))) - metal::atan(_e55);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float h = {};
    float e = {};
    float roll = {};
    float local_2 = {};
    float h3_ = {};
    float peak = {};
    float bend = {};
    float local_3 = {};
    float phi = {};
    float arcK = {};
    float edgeY = {};
    metal::float2 n = {};
    float xr = {};
    float yn = {};
    float theta = {};
    float param_4 = {};
    float thetaCorner = {};
    float param_5 = {};
    float width = {};
    float zoom = {};
    float x_1 = {};
    float facing = {};
    float light = {};
    float v_2 = {};
    float local_4 = {};
    float len = {};
    float split = {};
    float jitter = {};
    metal::float2 param_6 = {};
    metal::float3 color = {};
    metal::float3 weight = {};
    float alpha = {};
    int i = {};
    float t = {};
    metal::float4 img = {};
    float param_7 = {};
    float param_8 = {};
    metal::float3 w = {};
    float _e84 = uniforms.progress;
    p = _e84;
    float _e85 = p;
    h = 1.0 - metal::abs((2.0 * _e85) - 1.0);
    float _e90 = h;
    float _e92 = h;
    float _e94 = h;
    e = (0.5 * _e90) * (0.1 + ((0.9 * _e92) * _e94));
    float _e98 = p;
    if (_e98 < 0.5) {
        float _e100 = e;
        local_2 = _e100;
    } else {
        float _e101 = e;
        local_2 = 1.0 - _e101;
    }
    float _e103 = local_2;
    roll = _e103;
    float _e104 = h;
    float _e105 = h;
    float _e107 = h;
    h3_ = (_e104 * _e105) * _e107;
    float _e109 = h3_;
    float _e110 = h3_;
    peak = _e109 * _e110;
    float _e113 = uniforms.curvature;
    float _e114 = p;
    if (_e114 < 0.5) {
        float _e116 = h;
        float _e117 = h;
        local_3 = _e116 * (2.0 - _e117);
    } else {
        float _e120 = h;
        float _e121 = h;
        float _e123 = h;
        local_3 = (_e120 * _e121) * (3.0 - (2.0 * _e123));
    }
    float _e127 = local_3;
    bend = _e113 * _e127;
    float _e129 = bend;
    phi = (1.1 * _e129) + 0.0001;
    float _e132 = bend;
    arcK = 0.12 * _e132;
    float _e134 = phi;
    float _e136 = phi;
    edgeY = metal::sin(_e134) / (2.6 - metal::cos(_e136));
    metal::float2 _e140 = uv_2;
    n = (_e140 * 2.0) - metal::float2(1.0);
    float _e145 = n[0u];
    float _e147 = uniforms.ratio;
    xr = _e145 * _e147;
    float _e150 = n[1u];
    float _e151 = arcK;
    float _e152 = xr;
    float _e154 = xr;
    yn = _e150 * (1.0 + ((_e151 * _e152) * _e154));
    float _e158 = yn;
    float _e159 = edgeY;
    param_4 = _e158 * _e159;
    float _e161 = angleAt(param_4);
    theta = _e161;
    float _e162 = arcK;
    float _e164 = uniforms.ratio;
    float _e167 = uniforms.ratio;
    float _e170 = edgeY;
    param_5 = (1.0 + ((_e162 * _e164) * _e167)) * _e170;
    float _e172 = angleAt(param_5);
    thetaCorner = _e172;
    float _e173 = theta;
    width = 1.6 / (2.6 - metal::cos(_e173));
    float _e177 = thetaCorner;
    zoom = (2.6 - metal::cos(_e177)) / 1.6;
    float _e182 = n[0u];
    float _e184 = zoom;
    float _e185 = width;
    x_1 = 0.5 + ((0.5 * _e182) / (_e184 * _e185));
    float _e189 = theta;
    float _e193 = theta;
    facing = ((2.6 * metal::cos(_e189)) - 1.0) / metal::sqrt(7.76 - (5.2 * metal::cos(_e193)));
    float _e199 = facing;
    float _e202 = uniforms.shading;
    light = metal::mix(1.0, metal::clamp(_e199, 0.0, 1.0), _e202);
    float _e204 = theta;
    float _e205 = phi;
    int _e210 = uniforms.downward;
    if (_e210 != 0) {
        float _e212 = roll;
        local_4 = _e212;
    } else {
        float _e213 = roll;
        local_4 = -(_e213);
    }
    float _e215 = local_4;
    v_2 = (0.5 * ((_e204 / _e205) + 1.0)) + _e215;
    float _e218 = uniforms.blur;
    float _e220 = peak;
    len = (0.5 * _e218) * _e220;
    float _e223 = uniforms.chroma;
    float _e224 = peak;
    split = _e223 * _e224;
    metal::float2 _e226 = uv_2;
    param_6 = _e226 * 1000.0;
    float _e228 = hash(param_6);
    jitter = _e228;
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
            int _e276 = i;
            i = as_type<int>(as_type<uint>(_e276) + as_type<uint>(1));
        }
        loop_init = false;
        int _e229 = i;
        if (_e229 < 24) {
            int _e231 = i;
            float _e233 = jitter;
            t = ((static_cast<float>(_e231) + _e233) / 24.0) - 0.5;
            float _e237 = v_2;
            float _e238 = t;
            float _e239 = len;
            float _e242 = x_1;
            param_7 = _e242;
            param_8 = _e237 + (_e238 * _e239);
            metal::float4 _e243 = strip(param_7, param_8, _from, _sampler, _to, uniforms);
            img = _e243;
            float _e244 = split;
            float _e246 = t;
            float _e250 = split;
            float _e252 = t;
            w = metal::float3(metal::max(1.0 - ((4.0 * _e244) * _e246), 0.0), 1.0, metal::max(1.0 + ((4.0 * _e250) * _e252), 0.0));
            metal::float4 _e257 = img;
            float _e260 = img[3u];
            metal::float3 _e262 = w;
            metal::float3 _e264 = color;
            color = _e264 + ((_e257.xyz * _e260) * _e262);
            float _e267 = img[3u];
            metal::float3 _e268 = w;
            metal::float3 _e270 = weight;
            weight = _e270 + (_e268 * _e267);
            float _e273 = img[3u];
            float _e274 = alpha;
            alpha = _e274 + _e273;
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e278 = color;
    metal::float3 _e279 = weight;
    color = _e278 / metal::max(_e279, metal::float3(0.00001, 0.00001, 0.00001));
    metal::float3 _e282 = color;
    float _e283 = light;
    metal::float3 _e284 = _e282 * _e283;
    float _e285 = alpha;
    return metal::float4(_e284.x, _e284.y, _e284.z, _e285 / 24.0);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_9 = {};
    metal::float2 _e44 = _uv_1;
    param_9 = _e44;
    metal::float4 _e45 = transition(param_9, _from, _sampler, _to, uniforms);
    _fragColor = _e45;
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
