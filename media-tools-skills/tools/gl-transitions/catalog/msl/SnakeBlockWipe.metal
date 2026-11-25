// SnakeBlockWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SnakeBlockWipe.glsl
// Author: gre
// License: MIT
// Description: Blocks switch to the incoming image one at a time, row after row from the top (or column after column from the left), each line running the opposite way to the one before, like a snake winding across the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 grid;
    int vertical;
    float smoothness;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e21 = uv[0u];
    float _e23 = uv[1u];
    metal::float4 _e26 = _to.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e21 = uv_1[0u];
    float _e23 = uv_1[1u];
    metal::float4 _e26 = _from.sample(_sampler, metal::float2(_e21, 1.0 - _e23), metal::level(0.0));
    return _e26;
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
    metal::float2 g = {};
    metal::float2 cell = {};
    float lines = {};
    float local = {};
    float len = {};
    float local_1 = {};
    float line = {};
    float local_2 = {};
    float pos = {};
    float local_3 = {};
    float order = {};
    float n = {};
    float w = {};
    float m = {};
    metal::float4 c = {};
    metal::float4 local_4 = {};
    metal::float2 _e40 = uv_2;
    param = _e40;
    metal::float4 _e41 = getFromColor(param, _from, _sampler);
    a = _e41;
    metal::float2 _e42 = uv_2;
    param_1 = _e42;
    metal::float4 _e43 = getToColor(param_1, _sampler, _to);
    b = _e43;
    float _e45 = uniforms.progress;
    if (_e45 <= 0.0) {
        metal::float4 _e47 = a;
        return _e47;
    }
    float _e49 = uniforms.progress;
    if (_e49 >= 1.0) {
        metal::float4 _e51 = b;
        return _e51;
    }
    metal::int2 _e53 = uniforms.grid;
    g = metal::max(static_cast<metal::float2>(_e53), metal::float2(1.0));
    float _e58 = uv_2[0u];
    float _e60 = uv_2[1u];
    metal::float2 _e63 = g;
    metal::float2 _e66 = g;
    cell = metal::min(metal::floor(metal::float2(_e58, 1.0 - _e60) * _e63), _e66 - metal::float2(1.0));
    int _e71 = uniforms.vertical;
    if (_e71 != 0) {
        float _e74 = g[0u];
        local = _e74;
    } else {
        float _e76 = g[1u];
        local = _e76;
    }
    float _e77 = local;
    lines = _e77;
    int _e79 = uniforms.vertical;
    if (_e79 != 0) {
        float _e82 = g[1u];
        local_1 = _e82;
    } else {
        float _e84 = g[0u];
        local_1 = _e84;
    }
    float _e85 = local_1;
    len = _e85;
    int _e87 = uniforms.vertical;
    if (_e87 != 0) {
        float _e90 = cell[0u];
        local_2 = _e90;
    } else {
        float _e92 = cell[1u];
        local_2 = _e92;
    }
    float _e93 = local_2;
    line = _e93;
    int _e95 = uniforms.vertical;
    if (_e95 != 0) {
        float _e98 = cell[1u];
        local_3 = _e98;
    } else {
        float _e100 = cell[0u];
        local_3 = _e100;
    }
    float _e101 = local_3;
    pos = _e101;
    float _e102 = line;
    if ((_e102 - (metal::floor(_e102 / 2.0) * 2.0)) > 0.5) {
        float _e108 = len;
        float _e110 = pos;
        pos = (_e108 - 1.0) - _e110;
    }
    float _e112 = line;
    float _e113 = len;
    float _e115 = pos;
    order = (_e112 * _e113) + _e115;
    float _e117 = lines;
    float _e118 = len;
    n = _e117 * _e118;
    float _e121 = uniforms.smoothness;
    w = metal::max(_e121, 0.001);
    float _e124 = uniforms.progress;
    float _e125 = n;
    float _e127 = w;
    float _e130 = order;
    float _e132 = w;
    m = metal::clamp(((_e124 * ((_e125 - 1.0) + _e127)) - _e130) / _e132, 0.0, 1.0);
    metal::float4 _e135 = a;
    float _e138 = a[3u];
    metal::float3 _e139 = _e135.xyz * _e138;
    float _e141 = a[3u];
    metal::float4 _e146 = b;
    float _e149 = b[3u];
    metal::float3 _e150 = _e146.xyz * _e149;
    float _e152 = b[3u];
    float _e157 = m;
    c = metal::mix(metal::float4(_e139.x, _e139.y, _e139.z, _e141), metal::float4(_e150.x, _e150.y, _e150.z, _e152), metal::float4(_e157));
    float _e161 = c[3u];
    if (_e161 > 0.0) {
        metal::float4 _e163 = c;
        float _e166 = c[3u];
        metal::float3 _e168 = _e163.xyz / metal::float3(_e166);
        float _e170 = c[3u];
        local_4 = metal::float4(_e168.x, _e168.y, _e168.z, _e170);
    } else {
        local_4 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e175 = local_4;
    return _e175;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_2 = {};
    metal::float2 _e20 = _uv_1;
    param_2 = _e20;
    metal::float4 _e21 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e21;
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
