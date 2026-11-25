// InsetWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InsetWipe.glsl
// Author: gre
// License: MIT
// Description: A rectangle anchored in a corner, on an edge or in the center grows until the incoming image fills the frame, revealing it in place without scaling it; in reverse, the outgoing image shrinks into the rectangle
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 anchor;
    float smoothness;
    float borderWidth;
    char _pad5[8];
    metal::float4 borderColor;
    int reverse;
    char _pad7[12];
};

metal::float4 premultiplied(
    thread metal::float4& c
) {
    metal::float4 _e24 = c;
    float _e27 = c[3u];
    metal::float3 _e28 = _e24.xyz * _e27;
    float _e30 = c[3u];
    return metal::float4(_e28.x, _e28.y, _e28.z, _e30);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e25 = uv[0u];
    float _e27 = uv[1u];
    metal::float4 _e30 = _to.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e25 = uv_1[0u];
    float _e27 = uv_1[1u];
    metal::float4 _e30 = _from.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
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
    metal::float2 an = {};
    metal::float2 sq = {};
    metal::float2 ext = {};
    metal::float2 d = {};
    float s = {};
    float bw = {};
    float t = {};
    float local = {};
    float p = {};
    metal::float2 size = {};
    float e = {};
    metal::float4 inside = {};
    metal::float4 c_1 = {};
    metal::float4 param_2 = {};
    float m = {};
    metal::float4 param_3 = {};
    metal::float4 param_4 = {};
    metal::float4 local_1 = {};
    metal::float2 _e46 = uv_2;
    param = _e46;
    metal::float4 _e47 = getFromColor(param, _from, _sampler);
    a = _e47;
    metal::float2 _e48 = uv_2;
    param_1 = _e48;
    metal::float4 _e49 = getToColor(param_1, _sampler, _to);
    b = _e49;
    float _e51 = uniforms.progress;
    if (_e51 <= 0.0) {
        metal::float4 _e53 = a;
        return _e53;
    }
    float _e55 = uniforms.progress;
    if (_e55 >= 1.0) {
        metal::float4 _e57 = b;
        return _e57;
    }
    metal::float2 _e59 = uniforms.anchor;
    an = metal::clamp(_e59, metal::float2(0.0), metal::float2(1.0));
    float _e64 = uniforms.ratio;
    sq = metal::float2(_e64, 1.0);
    metal::float2 _e66 = an;
    metal::float2 _e67 = an;
    metal::float2 _e71 = sq;
    ext = metal::max(_e66, metal::float2(1.0) - _e67) * _e71;
    metal::float2 _e73 = uv_2;
    metal::float2 _e74 = an;
    metal::float2 _e77 = sq;
    d = metal::abs(_e73 - _e74) * _e77;
    float _e80 = uniforms.smoothness;
    s = metal::max(_e80, 0.001);
    float _e83 = uniforms.borderWidth;
    bw = metal::max(_e83, 0.0);
    int _e86 = uniforms.reverse;
    if (_e86 != 0) {
        float _e89 = uniforms.progress;
        local = 1.0 - _e89;
    } else {
        float _e92 = uniforms.progress;
        local = _e92;
    }
    float _e93 = local;
    t = _e93;
    float _e94 = t;
    float _e95 = t;
    float _e96 = t;
    float _e98 = t;
    p = metal::mix(_e94, (_e95 * _e96) * (3.0 - (2.0 * _e98)), 0.3);
    float _e103 = p;
    metal::float2 _e104 = ext;
    float _e106 = bw;
    float _e107 = s;
    float _e110 = s;
    float _e111 = p;
    size = (_e104 * _e103) + metal::float2(metal::mix(-((_e106 + _e107)), _e110, _e111));
    float _e116 = d[0u];
    float _e118 = size[0u];
    float _e121 = d[1u];
    float _e123 = size[1u];
    e = metal::max(_e116 - _e118, _e121 - _e123);
    int _e127 = uniforms.reverse;
    metal::float4 _e129 = a;
    metal::float4 _e130 = b;
    inside = metal::select(_e130, _e129, metal::bool4(_e127 != 0));
    int _e134 = uniforms.reverse;
    metal::float4 _e136 = b;
    metal::float4 _e137 = a;
    param_2 = metal::select(_e137, _e136, metal::bool4(_e134 != 0));
    metal::float4 _e140 = premultiplied(param_2);
    c_1 = _e140;
    float _e141 = bw;
    if (_e141 > 0.0) {
        float _e143 = bw;
        float _e144 = s;
        float _e146 = bw;
        float _e147 = s;
        float _e149 = e;
        m = 1.0 - metal::smoothstep(_e143 - _e144, _e146 + _e147, _e149);
        metal::float4 _e153 = uniforms.borderColor;
        param_3 = _e153;
        metal::float4 _e154 = premultiplied(param_3);
        float _e155 = m;
        metal::float4 _e157 = c_1;
        float _e160 = uniforms.borderColor[3u];
        float _e161 = m;
        c_1 = (_e154 * _e155) + (_e157 * (1.0 - (_e160 * _e161)));
    }
    metal::float4 _e166 = c_1;
    metal::float4 _e167 = inside;
    param_4 = _e167;
    metal::float4 _e168 = premultiplied(param_4);
    float _e169 = s;
    float _e171 = s;
    float _e172 = e;
    c_1 = metal::mix(_e166, _e168, metal::float4(1.0 - metal::smoothstep(-(_e169), _e171, _e172)));
    float _e178 = c_1[3u];
    if (_e178 > 0.0) {
        metal::float4 _e180 = c_1;
        float _e183 = c_1[3u];
        metal::float3 _e185 = _e180.xyz / metal::float3(_e183);
        float _e187 = c_1[3u];
        local_1 = metal::float4(_e185.x, _e185.y, _e185.z, _e187);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e192 = local_1;
    return _e192;
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
    metal::float2 _e24 = _uv_1;
    param_5 = _e24;
    metal::float4 _e25 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e25;
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
