// Revolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Revolve.glsl
// Author: bread
// License: MIT
// Description: The outgoing image swirls and zooms with motion blur into the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float direction;
    float maxRotation;
    float peakZoom;
    float swirl;
    float barrel;
    float motionBlur;
    float switchStart;
    float switchEnd;
    float shadow;
    char _pad12[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e48 = uv[0u];
    float _e50 = uv[1u];
    metal::float4 _e53 = _to.sample(_sampler, metal::float2(_e48, 1.0 - _e50), metal::level(0.0));
    return _e53;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e48 = uv_1[0u];
    float _e50 = uv_1[1u];
    metal::float4 _e53 = _from.sample(_sampler, metal::float2(_e48, 1.0 - _e50), metal::level(0.0));
    return _e53;
}

metal::float2 rotate2(
    thread metal::float2& p,
    thread float& a
) {
    float s = {};
    float c = {};
    float _e50 = a;
    s = metal::sin(_e50);
    float _e52 = a;
    c = metal::cos(_e52);
    float _e54 = c;
    float _e56 = p[0u];
    float _e58 = s;
    float _e60 = p[1u];
    float _e63 = s;
    float _e65 = p[0u];
    float _e67 = c;
    float _e69 = p[1u];
    return metal::float2((_e54 * _e56) - (_e58 * _e60), (_e63 * _e65) + (_e67 * _e69));
}

float sat(
    thread float& x
) {
    float _e47 = x;
    return metal::clamp(_e47, 0.0, 1.0);
}

float ease(
    thread float& x_1
) {
    float param = {};
    float _e48 = x_1;
    param = _e48;
    float _e49 = sat(param);
    x_1 = _e49;
    float _e50 = x_1;
    float _e51 = x_1;
    float _e53 = x_1;
    return (_e50 * _e51) * (3.0 - (2.0 * _e53));
}

float revolveEnvelope(
    thread float& t
) {
    float rise = {};
    float param_1 = {};
    float fall = {};
    float param_2 = {};
    float _e51 = t;
    param_1 = (_e51 - 0.1) / 0.33;
    float _e54 = ease(param_1);
    rise = _e54;
    float _e55 = t;
    param_2 = (_e55 - 0.43) / 0.29;
    float _e58 = ease(param_2);
    fall = 1.0 - _e58;
    float _e60 = rise;
    float _e61 = fall;
    return _e60 * _e61;
}

metal::float2 warpUv(
    thread metal::float2& uv_2,
    thread float& t_1,
    constant Uniforms& uniforms
) {
    float e = {};
    float param_3 = {};
    metal::float2 p_1 = {};
    float r = {};
    float edgeSpin = {};
    float coreSpin = {};
    float param_4 = {};
    float visibleAngle = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float sc = {};
    float rr = {};
    float _e60 = t_1;
    param_3 = _e60;
    float _e61 = revolveEnvelope(param_3);
    e = _e61;
    metal::float2 _e62 = uv_2;
    metal::float2 _e64 = uniforms.center;
    p_1 = _e62 - _e64;
    float _e67 = uniforms.ratio;
    float _e69 = p_1[0u];
    p_1[0u] = _e69 * _e67;
    metal::float2 _e72 = p_1;
    r = metal::length(_e72);
    float _e75 = uniforms.maxRotation;
    float _e76 = e;
    edgeSpin = _e75 * _e76;
    float _e79 = uniforms.swirl;
    float _e80 = e;
    float _e82 = r;
    param_4 = _e82 / 0.96;
    float _e84 = sat(param_4);
    coreSpin = (_e79 * _e80) * metal::pow(1.0 - _e84, 1.55);
    float _e89 = uniforms.direction;
    float _e90 = edgeSpin;
    float _e91 = coreSpin;
    visibleAngle = _e89 * (_e90 + _e91);
    float _e94 = visibleAngle;
    metal::float2 _e96 = p_1;
    param_5 = _e96;
    param_6 = -(_e94);
    metal::float2 _e97 = rotate2(param_5, param_6);
    p_1 = _e97;
    float _e99 = uniforms.peakZoom;
    float _e101 = e;
    sc = 1.0 + ((_e99 - 1.0) * metal::pow(_e101, 0.85));
    float _e105 = sc;
    metal::float2 _e106 = p_1;
    p_1 = _e106 / metal::float2(_e105);
    metal::float2 _e109 = p_1;
    rr = metal::length(_e109);
    float _e112 = uniforms.barrel;
    float _e113 = e;
    float _e115 = rr;
    float _e117 = rr;
    metal::float2 _e121 = p_1;
    p_1 = _e121 * (1.0 + ((((_e112 * _e113) * _e115) * _e117) * 2.8));
    float _e124 = uniforms.ratio;
    float _e126 = p_1[0u];
    p_1[0u] = _e126 / _e124;
    metal::float2 _e129 = p_1;
    metal::float2 _e131 = uniforms.center;
    return metal::clamp(_e129 + _e131, metal::float2(0.001, 0.001), metal::float2(0.999, 0.999));
}

metal::float4 sampleRevolve(
    thread metal::float2& uv_3,
    thread float& t_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p_2 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float reveal = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 _e54 = uv_3;
    param_7 = _e54;
    float _e55 = t_2;
    param_8 = _e55;
    metal::float2 _e56 = warpUv(param_7, param_8, uniforms);
    p_2 = _e56;
    float _e58 = uniforms.switchStart;
    float _e60 = uniforms.switchEnd;
    float _e61 = t_2;
    reveal = metal::smoothstep(_e58, _e60, _e61);
    metal::float2 _e63 = p_2;
    param_9 = _e63;
    metal::float4 _e64 = getFromColor(param_9, _from, _sampler);
    metal::float2 _e65 = p_2;
    param_10 = _e65;
    metal::float4 _e66 = getToColor(param_10, _sampler, _to);
    float _e67 = reveal;
    return metal::mix(_e64, _e66, metal::float4(_e67));
}

metal::float4 transition(
    thread metal::float2& uv_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    float e_1 = {};
    float param_13 = {};
    float span = {};
    metal::float4 color = {};
    float total = {};
    int i = {};
    float x_2 = {};
    float w = {};
    float t_3 = {};
    float param_14 = {};
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float2 q = {};
    float vignette = {};
    float _e64 = uniforms.progress;
    if (_e64 <= 0.0) {
        metal::float2 _e66 = uv_4;
        param_11 = _e66;
        metal::float4 _e67 = getFromColor(param_11, _from, _sampler);
        return _e67;
    }
    float _e69 = uniforms.progress;
    if (_e69 >= 1.0) {
        metal::float2 _e71 = uv_4;
        param_12 = _e71;
        metal::float4 _e72 = getToColor(param_12, _sampler, _to);
        return _e72;
    }
    float _e74 = uniforms.progress;
    param_13 = _e74;
    float _e75 = revolveEnvelope(param_13);
    e_1 = _e75;
    float _e77 = uniforms.motionBlur;
    float _e79 = e_1;
    span = (0.06 * _e77) * _e79;
    color = metal::float4(0.0, 0.0, 0.0, 0.0);
    total = 0.0;
    i = -8;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e110 = i;
            i = as_type<int>(as_type<uint>(_e110) + as_type<uint>(1));
        }
        loop_init = false;
        int _e81 = i;
        if (_e81 <= 8) {
            int _e83 = i;
            x_2 = static_cast<float>(_e83) / 8.0;
            float _e86 = x_2;
            w = 1.0 - metal::abs(_e86);
            float _e89 = w;
            float _e90 = w;
            w = (_e89 * _e90) + 0.01;
            float _e94 = uniforms.progress;
            float _e95 = x_2;
            float _e96 = span;
            param_14 = _e94 + (_e95 * _e96);
            float _e99 = sat(param_14);
            t_3 = _e99;
            metal::float2 _e100 = uv_4;
            param_15 = _e100;
            float _e101 = t_3;
            param_16 = _e101;
            metal::float4 _e102 = sampleRevolve(param_15, param_16, _from, _sampler, _to, uniforms);
            float _e103 = w;
            metal::float4 _e105 = color;
            color = _e105 + (_e102 * _e103);
            float _e107 = w;
            float _e108 = total;
            total = _e108 + _e107;
            continue;
        } else {
            break;
        }
    }
    float _e112 = total;
    metal::float4 _e113 = color;
    color = _e113 / metal::float4(_e112);
    metal::float2 _e116 = uv_4;
    q = _e116 - metal::float2(0.5, 0.5);
    float _e119 = uniforms.ratio;
    float _e121 = q[0u];
    q[0u] = _e121 * _e119;
    float _e125 = uniforms.shadow;
    float _e126 = e_1;
    metal::float2 _e128 = q;
    vignette = 1.0 - ((_e125 * _e126) * metal::smoothstep(0.35, 0.95, metal::length(_e128)));
    float _e133 = vignette;
    metal::float4 _e134 = color;
    metal::float3 _e136 = _e134.xyz * _e133;
    color[0u] = _e136.x;
    color[1u] = _e136.y;
    color[2u] = _e136.z;
    metal::float4 _e143 = color;
    return _e143;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_17 = {};
    metal::float2 _e47 = _uv_1;
    param_17 = _e47;
    metal::float4 _e48 = transition(param_17, _from, _sampler, _to, uniforms);
    _fragColor = _e48;
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
