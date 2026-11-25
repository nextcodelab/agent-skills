// MoireWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/MoireWipe.glsl
// Author: gre
// License: MIT
// Description: Two sets of fine concentric rings, centered on two points that drift toward each other, overlay the image and interfere into a shifting moire of wide bands; the bands open onto the incoming image and widen until it fills the frame, while the thin dark and light ring lines fade away
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float density;
    float bands;
    float drift;
    float lines;
};

float ringLines(
    thread float& r,
    thread float& f
) {
    float q = {};
    float aa = {};
    float c = {};
    float _e41 = r;
    float _e42 = f;
    q = metal::abs(metal::fract((_e41 * _e42) + 0.5) - 0.5);
    float _e48 = f;
    aa = 0.0012 * _e48;
    float _e50 = q;
    float _e52 = aa;
    c = metal::clamp(((0.1 - _e50) / (2.0 * _e52)) + 0.5, 0.0, 1.0);
    float _e57 = c;
    float _e58 = aa;
    return metal::mix(_e57, 0.2, metal::clamp((10.0 * _e58) - 0.5, 0.0, 1.0));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e38 = uv[0u];
    float _e40 = uv[1u];
    metal::float4 _e43 = _to.sample(_sampler, metal::float2(_e38, 1.0 - _e40), metal::level(0.0));
    return _e43;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e38 = uv_1[0u];
    float _e40 = uv_1[1u];
    metal::float4 _e43 = _from.sample(_sampler, metal::float2(_e38, 1.0 - _e40), metal::level(0.0));
    return _e43;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    float t = {};
    float f_1 = {};
    metal::float2 p = {};
    float ang = {};
    float k = {};
    metal::float2 axis = {};
    float r1_ = {};
    float r2_ = {};
    float f2_ = {};
    float beat = {};
    metal::float2 grad = {};
    float s = {};
    float w = {};
    float m = {};
    metal::float4 c_1 = {};
    float o = {};
    float l = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    metal::float4 local = {};
    metal::float2 _e63 = uv_2;
    param = _e63;
    metal::float4 _e64 = getFromColor(param, _from, _sampler);
    a = _e64;
    metal::float2 _e65 = uv_2;
    param_1 = _e65;
    metal::float4 _e66 = getToColor(param_1, _sampler, _to);
    b = _e66;
    float _e68 = uniforms.progress;
    if (_e68 <= 0.0) {
        metal::float4 _e70 = a;
        return _e70;
    }
    float _e72 = uniforms.progress;
    if (_e72 >= 1.0) {
        metal::float4 _e74 = b;
        return _e74;
    }
    float _e76 = uniforms.progress;
    float _e78 = uniforms.progress;
    float _e81 = uniforms.progress;
    t = (_e76 * _e78) * (3.0 - (2.0 * _e81));
    float _e86 = uniforms.density;
    f_1 = metal::max(_e86, 1.0);
    metal::float2 _e88 = uv_2;
    float _e92 = uniforms.ratio;
    p = (_e88 - metal::float2(0.5)) * metal::float2(_e92, 1.0);
    float _e96 = uniforms.drift;
    float _e98 = t;
    ang = ((6.2831855 * _e96) * _e98) + 0.35;
    float _e102 = uniforms.bands;
    float _e104 = t;
    k = metal::max(_e102, 1.0) * (1.0 - (0.75 * _e104));
    float _e108 = ang;
    float _e110 = ang;
    float _e114 = k;
    float _e116 = f_1;
    axis = ((metal::float2(metal::cos(_e108), metal::sin(_e110)) * 0.5) * _e114) / metal::float2(_e116);
    metal::float2 _e119 = p;
    metal::float2 _e120 = axis;
    r1_ = metal::length(_e119 - _e120);
    metal::float2 _e123 = p;
    metal::float2 _e124 = axis;
    r2_ = metal::length(_e123 + _e124);
    float _e127 = f_1;
    float _e128 = k;
    f2_ = _e127 + (1.2 * _e128);
    float _e131 = f2_;
    float _e132 = r2_;
    float _e134 = f_1;
    float _e135 = r1_;
    beat = metal::abs(metal::fract(((_e131 * _e132) - (_e134 * _e135)) + 0.5) - 0.5);
    float _e142 = f2_;
    metal::float2 _e143 = p;
    metal::float2 _e144 = axis;
    float _e147 = r2_;
    float _e151 = f_1;
    metal::float2 _e152 = p;
    metal::float2 _e153 = axis;
    float _e156 = r1_;
    grad = (((_e143 + _e144) * _e142) / metal::float2(metal::max(_e147, 0.0012))) - (((_e152 - _e153) * _e151) / metal::float2(metal::max(_e156, 0.0012)));
    metal::float2 _e161 = grad;
    s = metal::min((0.0012 * metal::length(_e161)) + 0.004, 0.05);
    float _e166 = t;
    w = metal::mix(-0.05, 0.55, _e166);
    float _e168 = w;
    float _e169 = s;
    float _e171 = w;
    float _e172 = s;
    float _e174 = beat;
    m = 1.0 - metal::smoothstep(_e168 - _e169, _e171 + _e172, _e174);
    metal::float4 _e177 = a;
    float _e180 = a[3u];
    metal::float3 _e181 = _e177.xyz * _e180;
    float _e183 = a[3u];
    metal::float4 _e188 = b;
    float _e191 = b[3u];
    metal::float3 _e192 = _e188.xyz * _e191;
    float _e194 = b[3u];
    float _e199 = m;
    c_1 = metal::mix(metal::float4(_e181.x, _e181.y, _e181.z, _e183), metal::float4(_e192.x, _e192.y, _e192.z, _e194), metal::float4(_e199));
    float _e203 = uniforms.lines;
    float _e206 = t;
    o = (0.7 * metal::clamp(_e203, 0.0, 1.0)) * metal::sin(3.1415927 * _e206);
    float _e210 = o;
    float _e211 = r1_;
    param_2 = _e211;
    float _e212 = f_1;
    param_3 = _e212;
    float _e213 = ringLines(param_2, param_3);
    float _e216 = o;
    float _e217 = r2_;
    param_4 = _e217;
    float _e218 = f2_;
    param_5 = _e218;
    float _e219 = ringLines(param_4, param_5);
    l = 1.0 - ((1.0 - (_e210 * _e213)) * (1.0 - (_e216 * _e219)));
    metal::float4 _e224 = c_1;
    float _e227 = c_1[3u];
    float _e228 = m;
    float _e231 = l;
    metal::float3 _e233 = metal::mix(_e224.xyz, metal::float3(_e227 * _e228), metal::float3(_e231));
    c_1[0u] = _e233.x;
    c_1[1u] = _e233.y;
    c_1[2u] = _e233.z;
    float _e241 = c_1[3u];
    if (_e241 > 0.0) {
        metal::float4 _e243 = c_1;
        float _e246 = c_1[3u];
        metal::float3 _e248 = _e243.xyz / metal::float3(_e246);
        float _e250 = c_1[3u];
        local = metal::float4(_e248.x, _e248.y, _e248.z, _e250);
    } else {
        local = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e255 = local;
    return _e255;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_6 = {};
    metal::float2 _e37 = _uv_1;
    param_6 = _e37;
    metal::float4 _e38 = transition(param_6, _from, _sampler, _to, uniforms);
    _fragColor = _e38;
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
