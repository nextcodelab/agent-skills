// SpiralBlockWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SpiralBlockWipe.glsl
// Author: gre
// License: MIT
// Description: Square blocks switch to the incoming image one after another along a rectangular spiral, from the border inward or from the center outward
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 grid;
    int inward;
    int clockwise;
    float smoothness;
    char _pad6[4];
};

float spiralIndex(
    thread metal::float2& c,
    thread metal::float2& n
) {
    float k = {};
    metal::float2 s = {};
    metal::float2 l = {};
    float before = {};
    float along = {};
    float _e29 = c[0u];
    float _e31 = c[1u];
    float _e34 = n[0u];
    float _e37 = c[0u];
    float _e40 = n[1u];
    float _e43 = c[1u];
    k = metal::min(metal::min(_e29, _e31), metal::min((_e34 - 1.0) - _e37, (_e40 - 1.0) - _e43));
    metal::float2 _e47 = n;
    float _e48 = k;
    s = _e47 - metal::float2(2.0 * _e48);
    metal::float2 _e52 = c;
    float _e53 = k;
    l = _e52 - metal::float2(_e53);
    float _e57 = n[0u];
    float _e59 = n[1u];
    float _e62 = s[0u];
    float _e64 = s[1u];
    before = (_e57 * _e59) - (_e62 * _e64);
    float _e68 = l[1u];
    if (_e68 == 0.0) {
        float _e71 = l[0u];
        along = _e71;
    } else {
        float _e73 = l[0u];
        float _e75 = s[0u];
        if (_e73 == (_e75 - 1.0)) {
            float _e79 = s[0u];
            float _e82 = l[1u];
            along = (_e79 - 1.0) + _e82;
        } else {
            float _e85 = l[1u];
            float _e87 = s[1u];
            if (_e85 == (_e87 - 1.0)) {
                float _e91 = s[0u];
                float _e94 = s[1u];
                float _e98 = l[0u];
                along = (((2.0 * _e91) + _e94) - 3.0) - _e98;
            } else {
                float _e101 = s[0u];
                float _e105 = s[1u];
                float _e110 = l[1u];
                along = ((2.0 * (_e101 - 1.0)) + (2.0 * (_e105 - 1.0))) - _e110;
            }
        }
    }
    float _e112 = before;
    float _e113 = along;
    return _e112 + _e113;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e23 = uv[0u];
    float _e25 = uv[1u];
    metal::float4 _e28 = _to.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e23 = uv_1[0u];
    float _e25 = uv_1[1u];
    metal::float4 _e28 = _from.sample(_sampler, metal::float2(_e23, 1.0 - _e25), metal::level(0.0));
    return _e28;
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
    metal::float2 n_1 = {};
    metal::float2 c_1 = {};
    float count = {};
    float i = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float w = {};
    float o = {};
    float x = {};
    float m = {};
    float local = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float4 a = {};
    metal::float2 param_6 = {};
    metal::float4 b = {};
    metal::float2 param_7 = {};
    metal::float4 col = {};
    metal::float4 local_1 = {};
    float _e44 = uniforms.progress;
    if (_e44 <= 0.0) {
        metal::float2 _e46 = uv_2;
        param = _e46;
        metal::float4 _e47 = getFromColor(param, _from, _sampler);
        return _e47;
    }
    float _e49 = uniforms.progress;
    if (_e49 >= 1.0) {
        metal::float2 _e51 = uv_2;
        param_1 = _e51;
        metal::float4 _e52 = getToColor(param_1, _sampler, _to);
        return _e52;
    }
    metal::int2 _e54 = uniforms.grid;
    n_1 = metal::max(static_cast<metal::float2>(_e54), metal::float2(1.0, 1.0));
    float _e58 = uv_2[0u];
    float _e60 = uv_2[1u];
    metal::float2 _e63 = n_1;
    metal::float2 _e66 = n_1;
    c_1 = metal::min(metal::floor(metal::float2(_e58, 1.0 - _e60) * _e63), _e66 - metal::float2(1.0));
    int _e71 = uniforms.clockwise;
    int _e74 = uniforms.inward;
    if ((_e71 != 0) != (_e74 != 0)) {
        metal::float2 _e77 = c_1;
        c_1 = _e77.yx;
        metal::float2 _e79 = n_1;
        n_1 = _e79.yx;
    }
    float _e82 = n_1[0u];
    float _e84 = n_1[1u];
    count = _e82 * _e84;
    metal::float2 _e86 = c_1;
    param_2 = _e86;
    metal::float2 _e87 = n_1;
    param_3 = _e87;
    float _e88 = spiralIndex(param_2, param_3);
    i = _e88;
    int _e90 = uniforms.inward;
    if (!((_e90 != 0))) {
        float _e93 = count;
        float _e95 = i;
        i = (_e93 - 1.0) - _e95;
    }
    float _e98 = uniforms.smoothness;
    float _e100 = count;
    w = metal::max(_e98, 0.0) * _e100;
    float _e102 = w;
    o = metal::max(0.5 * (1.0 - _e102), 0.0);
    float _e107 = uniforms.progress;
    float _e108 = count;
    float _e110 = o;
    float _e113 = w;
    float _e116 = i;
    float _e118 = o;
    x = ((_e107 * (((_e108 - 1.0) + (2.0 * _e110)) + _e113)) - _e116) - _e118;
    float _e120 = w;
    if (_e120 > 0.0) {
        float _e122 = w;
        float _e123 = x;
        local = metal::smoothstep(0.0, _e122, _e123);
    } else {
        float _e125 = x;
        local = metal::step(0.0, _e125);
    }
    float _e127 = local;
    m = _e127;
    float _e128 = m;
    if (_e128 <= 0.0) {
        metal::float2 _e130 = uv_2;
        param_4 = _e130;
        metal::float4 _e131 = getFromColor(param_4, _from, _sampler);
        return _e131;
    }
    float _e132 = m;
    if (_e132 >= 1.0) {
        metal::float2 _e134 = uv_2;
        param_5 = _e134;
        metal::float4 _e135 = getToColor(param_5, _sampler, _to);
        return _e135;
    }
    metal::float2 _e136 = uv_2;
    param_6 = _e136;
    metal::float4 _e137 = getFromColor(param_6, _from, _sampler);
    a = _e137;
    metal::float2 _e138 = uv_2;
    param_7 = _e138;
    metal::float4 _e139 = getToColor(param_7, _sampler, _to);
    b = _e139;
    metal::float4 _e140 = a;
    float _e143 = a[3u];
    metal::float3 _e144 = _e140.xyz * _e143;
    float _e146 = a[3u];
    metal::float4 _e151 = b;
    float _e154 = b[3u];
    metal::float3 _e155 = _e151.xyz * _e154;
    float _e157 = b[3u];
    float _e162 = m;
    col = metal::mix(metal::float4(_e144.x, _e144.y, _e144.z, _e146), metal::float4(_e155.x, _e155.y, _e155.z, _e157), metal::float4(_e162));
    float _e166 = col[3u];
    if (_e166 > 0.0) {
        metal::float4 _e168 = col;
        float _e171 = col[3u];
        metal::float3 _e173 = _e168.xyz / metal::float3(_e171);
        float _e175 = col[3u];
        local_1 = metal::float4(_e173.x, _e173.y, _e173.z, _e175);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e180 = local_1;
    return _e180;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e22 = _uv_1;
    param_8 = _e22;
    metal::float4 _e23 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e23;
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
