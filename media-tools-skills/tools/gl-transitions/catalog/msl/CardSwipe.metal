// CardSwipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CardSwipe.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is flicked off like the top card of a stack, swinging around a point below it as it flies out, while the incoming card behind it grows to fill the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float rotation;
    float depth;
    char _pad5[8];
    metal::float4 backColor;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e50 = uv[0u];
    float _e52 = uv[1u];
    metal::float4 _e55 = _from.sample(_sampler, metal::float2(_e50, 1.0 - _e52), metal::level(0.0));
    return _e55;
}

metal::float4 premultiply(
    thread metal::float4& c
) {
    metal::float4 _e49 = c;
    float _e52 = c[3u];
    metal::float3 _e53 = _e49.xyz * _e52;
    float _e55 = c[3u];
    return metal::float4(_e53.x, _e53.y, _e53.z, _e55);
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e50 = uv_1[0u];
    float _e52 = uv_1[1u];
    metal::float4 _e55 = _to.sample(_sampler, metal::float2(_e50, 1.0 - _e52), metal::level(0.0));
    return _e55;
}

float roundedBox(
    thread metal::float2& q,
    thread metal::float2& b,
    thread float& r
) {
    metal::float2 d = {};
    metal::float2 _e52 = q;
    metal::float2 _e54 = b;
    float _e56 = r;
    d = (metal::abs(_e52) - _e54) + metal::float2(_e56);
    metal::float2 _e59 = d;
    float _e64 = d[0u];
    float _e66 = d[1u];
    float _e70 = r;
    return (metal::length(metal::max(_e59, metal::float2(0.0))) + metal::min(metal::max(_e64, _e66), 0.0)) - _e70;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float dl = {};
    metal::float2 d_1 = {};
    metal::float2 local = {};
    metal::float2 q_1 = {};
    metal::float2 b_1 = {};
    float p = {};
    float h = {};
    float g = {};
    float k = {};
    float sc = {};
    float rb = {};
    float db = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float param_2 = {};
    float cb = {};
    metal::float4 tc = {};
    metal::float2 param_3 = {};
    metal::float4 col = {};
    metal::float4 param_4 = {};
    metal::float4 param_5 = {};
    float t = {};
    float lift = {};
    float u = {};
    float swing = {};
    float a = {};
    metal::float2 pivot = {};
    float ca = {};
    float sa = {};
    metal::float2 swung = {};
    float far = {};
    metal::float2 shift = {};
    metal::float2x2 unrotate = {};
    metal::float2 r_1 = {};
    float rf = {};
    float sh = {};
    metal::float2 rs = {};
    float ds = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float df = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    float cf = {};
    metal::float4 fc = {};
    metal::float2 param_12 = {};
    metal::float4 param_13 = {};
    metal::float4 local_1 = {};
    metal::float2 _e100 = uniforms.direction;
    dl = metal::length(_e100);
    float _e102 = dl;
    if (_e102 > 0.000001) {
        metal::float2 _e105 = uniforms.direction;
        float _e106 = dl;
        local = _e105 / metal::float2(_e106);
    } else {
        local = metal::float2(0.970143, 0.242536);
    }
    metal::float2 _e109 = local;
    d_1 = _e109;
    metal::float2 _e110 = uv_2;
    float _e114 = uniforms.ratio;
    q_1 = (_e110 - metal::float2(0.5)) * metal::float2(_e114, 1.0);
    float _e118 = uniforms.ratio;
    b_1 = metal::float2(0.5 * _e118, 0.5);
    float _e122 = uniforms.progress;
    p = _e122;
    float _e123 = p;
    h = metal::clamp((_e123 - 0.2) / 0.8, 0.0, 1.0);
    float _e127 = h;
    float _e128 = h;
    float _e130 = h;
    g = (_e127 * _e128) * (3.0 - (2.0 * _e130));
    float _e134 = g;
    k = 1.0 - _e134;
    float _e137 = uniforms.depth;
    float _e138 = k;
    sc = 1.0 - (_e137 * _e138);
    float _e141 = k;
    rb = 0.045 * metal::min(1.0, 12.0 * _e141);
    metal::float2 _e145 = b_1;
    float _e146 = sc;
    metal::float2 _e148 = q_1;
    param = _e148;
    param_1 = _e145 * _e146;
    float _e149 = rb;
    param_2 = _e149;
    float _e150 = roundedBox(param, param_1, param_2);
    db = _e150;
    float _e151 = db;
    float _e152 = k;
    cb = metal::clamp(0.5 - (_e151 / metal::max(0.002 * metal::min(1.0, 40.0 * _e152), 0.000001)), 0.0, 1.0);
    metal::float2 _e160 = uv_2;
    float _e163 = sc;
    param_3 = metal::clamp(metal::float2(0.5) + ((_e160 - metal::float2(0.5)) / metal::float2(_e163)), metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e171 = getToColor(param_3, _sampler, _to);
    tc = _e171;
    float _e172 = k;
    float _e174 = k;
    metal::float4 _e177 = tc;
    metal::float3 _e179 = _e177.xyz * (1.0 - ((0.35 * _e172) * _e174));
    tc[0u] = _e179.x;
    tc[1u] = _e179.y;
    tc[2u] = _e179.z;
    metal::float4 _e187 = uniforms.backColor;
    param_4 = _e187;
    metal::float4 _e188 = premultiply(param_4);
    metal::float4 _e189 = tc;
    param_5 = _e189;
    metal::float4 _e190 = premultiply(param_5);
    float _e191 = cb;
    col = metal::mix(_e188, _e190, metal::float4(_e191));
    float _e194 = p;
    t = metal::clamp(_e194 / 0.75, 0.0, 1.0);
    float _e197 = p;
    lift = metal::smoothstep(0.0, 0.15, _e197);
    float _e199 = t;
    u = metal::min(_e199 / 0.7, 1.0);
    float _e202 = u;
    float _e203 = u;
    float _e205 = u;
    swing = (_e202 * _e203) * (3.0 - (2.0 * _e205));
    float _e210 = d_1[0u];
    float _e214 = uniforms.rotation;
    float _e216 = swing;
    a = (((_e210 < 0.0) ? 1.3 : -1.3) * _e214) * _e216;
    pivot = metal::float2(0.0, -1.1);
    float _e218 = a;
    ca = metal::cos(_e218);
    float _e220 = a;
    sa = metal::sin(_e220);
    metal::float2 _e222 = pivot;
    float _e223 = ca;
    float _e224 = sa;
    float _e225 = sa;
    float _e227 = ca;
    metal::float2 _e231 = pivot;
    swung = _e222 + (metal::float2x2(metal::float2(_e223, _e224), metal::float2(-(_e225), _e227)) * -(_e231));
    metal::float2 _e235 = b_1;
    metal::float2 _e238 = swung;
    far = ((2.0 * metal::length(_e235)) + metal::length(_e238)) + 0.3;
    metal::float2 _e242 = d_1;
    float _e243 = far;
    float _e245 = t;
    float _e247 = t;
    float _e249 = t;
    shift = (((_e242 * _e243) * _e245) * _e247) * (0.4 + (0.6 * _e249));
    float _e253 = ca;
    float _e254 = sa;
    float _e256 = sa;
    float _e257 = ca;
    unrotate = metal::float2x2(metal::float2(_e253, -(_e254)), metal::float2(_e256, _e257));
    metal::float2x2 _e261 = unrotate;
    metal::float2 _e262 = q_1;
    metal::float2 _e263 = shift;
    metal::float2 _e265 = pivot;
    metal::float2 _e268 = pivot;
    r_1 = (_e261 * ((_e262 - _e263) - _e265)) + _e268;
    float _e270 = lift;
    rf = 0.045 * _e270;
    float _e272 = lift;
    float _e274 = t;
    sh = (0.6 * _e272) * (1.0 - _e274);
    float _e277 = sh;
    if (_e277 > 0.0) {
        metal::float2x2 _e279 = unrotate;
        metal::float2 _e280 = q_1;
        metal::float2 _e281 = d_1;
        float _e284 = lift;
        metal::float2 _e287 = shift;
        metal::float2 _e289 = pivot;
        metal::float2 _e292 = pivot;
        rs = (_e279 * (((_e280 - (((_e281 * 0.03) + metal::float2(0.0, -0.03)) * _e284)) - _e287) - _e289)) + _e292;
        metal::float2 _e294 = rs;
        param_6 = _e294;
        metal::float2 _e295 = b_1;
        param_7 = _e295;
        float _e296 = rf;
        param_8 = _e296;
        float _e297 = roundedBox(param_6, param_7, param_8);
        ds = _e297;
        float _e298 = sh;
        float _e299 = ds;
        metal::float4 _e304 = col;
        metal::float3 _e306 = _e304.xyz * (1.0 - (_e298 * (1.0 - metal::smoothstep(-0.05, 0.08, _e299))));
        col[0u] = _e306.x;
        col[1u] = _e306.y;
        col[2u] = _e306.z;
    }
    metal::float2 _e313 = r_1;
    param_9 = _e313;
    metal::float2 _e314 = b_1;
    param_10 = _e314;
    float _e315 = rf;
    param_11 = _e315;
    float _e316 = roundedBox(param_9, param_10, param_11);
    df = _e316;
    float _e317 = df;
    float _e318 = lift;
    cf = metal::clamp(0.5 - (_e317 / metal::max(0.002 * metal::min(1.0, 40.0 * _e318), 0.000001)), 0.0, 1.0);
    metal::float2 _e326 = r_1;
    float _e328 = uniforms.ratio;
    param_12 = metal::clamp((_e326 / metal::float2(_e328, 1.0)) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e336 = getFromColor(param_12, _from, _sampler);
    fc = _e336;
    metal::float4 _e337 = col;
    metal::float4 _e338 = fc;
    param_13 = _e338;
    metal::float4 _e339 = premultiply(param_13);
    float _e340 = cf;
    col = metal::mix(_e337, _e339, metal::float4(_e340));
    float _e344 = col[3u];
    if (_e344 > 0.0) {
        metal::float4 _e346 = col;
        float _e349 = col[3u];
        metal::float3 _e351 = _e346.xyz / metal::float3(_e349);
        float _e353 = col[3u];
        local_1 = metal::float4(_e351.x, _e351.y, _e351.z, _e353);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e358 = local_1;
    return _e358;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_14 = {};
    metal::float2 _e49 = _uv_1;
    param_14 = _e49;
    metal::float4 _e50 = transition(param_14, _from, _sampler, _to, uniforms);
    _fragColor = _e50;
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
