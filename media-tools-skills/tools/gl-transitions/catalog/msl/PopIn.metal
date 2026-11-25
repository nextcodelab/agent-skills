// PopIn — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PopIn.glsl
// Author: gre
// License: MIT
// Description: The incoming image pops in as a rounded card over the outgoing one, with an elastic overshoot: too big, a bit small, then it settles into the full frame as its corners square off
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float bounce;
    float corner;
    float shadow;
    char _pad6[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e31 = uv[0u];
    float _e33 = uv[1u];
    metal::float4 _e36 = _to.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e31 = uv_1[0u];
    float _e33 = uv_1[1u];
    metal::float4 _e36 = _from.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

float roundedBox(
    thread metal::float2& p,
    thread metal::float2& b,
    thread float& r
) {
    metal::float2 q = {};
    metal::float2 _e33 = p;
    metal::float2 _e35 = b;
    float _e37 = r;
    q = (metal::abs(_e33) - _e35) + metal::float2(_e37);
    metal::float2 _e40 = q;
    float _e45 = q[0u];
    float _e47 = q[1u];
    float _e51 = r;
    return (metal::length(metal::max(_e40, metal::float2(0.0))) + metal::min(metal::max(_e45, _e47), 0.0)) - _e51;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float t = {};
    float easeOut = {};
    float spring = {};
    float s = {};
    metal::float2 asp = {};
    float side = {};
    metal::float2 cardCenter = {};
    metal::float2 halfSize = {};
    float r_1 = {};
    float aa = {};
    float d = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float cover = {};
    float k = {};
    float blur = {};
    metal::float2 offset = {};
    float ds = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    float param_5 = {};
    float shade = {};
    metal::float4 a = {};
    metal::float2 param_6 = {};
    metal::float4 b_1 = {};
    metal::float2 param_7 = {};
    metal::float4 c = {};
    metal::float4 local = {};
    float _e60 = uniforms.progress;
    t = _e60;
    float _e61 = t;
    float _e63 = t;
    float _e66 = t;
    easeOut = 1.0 - (((1.0 - _e61) * (1.0 - _e63)) * (1.0 - _e66));
    float _e70 = t;
    float _e73 = t;
    float _e77 = t;
    spring = 1.0 - ((metal::exp(-1.5 * _e70) * metal::cos(7.8539815 * _e73)) * (1.0 - _e77));
    float _e81 = easeOut;
    float _e82 = spring;
    float _e84 = uniforms.bounce;
    s = metal::mix(_e81, _e82, _e84);
    float _e87 = uniforms.ratio;
    asp = metal::float2(_e87, 1.0);
    float _e90 = uniforms.ratio;
    side = metal::min(_e90, 1.0);
    metal::float2 _e93 = uniforms.center;
    metal::float2 _e95 = uniforms.center;
    float _e98 = s;
    cardCenter = _e93 + ((metal::float2(0.5) - _e95) * _e98);
    float _e101 = s;
    metal::float2 _e103 = asp;
    halfSize = _e103 * (0.5 * _e101);
    float _e106 = uniforms.corner;
    float _e107 = s;
    float _e109 = side;
    float _e111 = t;
    r_1 = ((_e106 * _e107) * _e109) * (1.0 - _e111);
    aa = 0.002;
    metal::float2 _e114 = uv_2;
    metal::float2 _e115 = cardCenter;
    metal::float2 _e117 = asp;
    param = (_e114 - _e115) * _e117;
    metal::float2 _e119 = halfSize;
    param_1 = _e119;
    float _e120 = r_1;
    param_2 = _e120;
    float _e121 = roundedBox(param, param_1, param_2);
    float _e122 = aa;
    d = _e121 - _e122;
    float _e124 = d;
    float _e125 = aa;
    float _e129 = t;
    cover = metal::clamp(0.5 - (_e124 / _e125), 0.0, 1.0) * metal::smoothstep(0.0, 0.08, _e129);
    float _e132 = s;
    float _e134 = side;
    k = metal::min(_e132, 1.0) * _e134;
    float _e136 = k;
    blur = (0.05 * _e136) + 0.0001;
    float _e139 = k;
    offset = metal::float2(0.0, -0.03 * _e139);
    metal::float2 _e142 = uv_2;
    metal::float2 _e143 = cardCenter;
    metal::float2 _e145 = offset;
    metal::float2 _e147 = asp;
    param_3 = ((_e142 - _e143) - _e145) * _e147;
    metal::float2 _e149 = halfSize;
    param_4 = _e149;
    float _e150 = r_1;
    param_5 = _e150;
    float _e151 = roundedBox(param_3, param_4, param_5);
    ds = _e151;
    float _e153 = uniforms.shadow;
    float _e154 = blur;
    float _e156 = blur;
    float _e157 = ds;
    float _e161 = t;
    shade = (_e153 * (1.0 - metal::smoothstep(-(_e154), _e156, _e157))) * metal::smoothstep(0.0, 0.15, _e161);
    metal::float2 _e164 = uv_2;
    param_6 = _e164;
    metal::float4 _e165 = getFromColor(param_6, _from, _sampler);
    a = _e165;
    float _e166 = shade;
    metal::float4 _e168 = a;
    metal::float3 _e170 = _e168.xyz * (1.0 - _e166);
    a[0u] = _e170.x;
    a[1u] = _e170.y;
    a[2u] = _e170.z;
    metal::float2 _e177 = uv_2;
    metal::float2 _e179 = uniforms.center;
    float _e181 = s;
    metal::float2 _e186 = uniforms.center;
    param_7 = metal::clamp(((_e177 - _e179) / metal::float2(metal::max(_e181, 0.0001))) + _e186, metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e191 = getToColor(param_7, _sampler, _to);
    b_1 = _e191;
    metal::float4 _e192 = a;
    float _e195 = a[3u];
    metal::float3 _e196 = _e192.xyz * _e195;
    float _e198 = a[3u];
    metal::float4 _e203 = b_1;
    float _e206 = b_1[3u];
    metal::float3 _e207 = _e203.xyz * _e206;
    float _e209 = b_1[3u];
    float _e214 = cover;
    c = metal::mix(metal::float4(_e196.x, _e196.y, _e196.z, _e198), metal::float4(_e207.x, _e207.y, _e207.z, _e209), metal::float4(_e214));
    float _e218 = c[3u];
    if (_e218 > 0.0) {
        metal::float4 _e220 = c;
        float _e223 = c[3u];
        metal::float3 _e225 = _e220.xyz / metal::float3(_e223);
        float _e227 = c[3u];
        local = metal::float4(_e225.x, _e225.y, _e225.z, _e227);
    } else {
        local = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e232 = local;
    return _e232;
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
    metal::float2 _e30 = _uv_1;
    param_8 = _e30;
    metal::float4 _e31 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e31;
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
