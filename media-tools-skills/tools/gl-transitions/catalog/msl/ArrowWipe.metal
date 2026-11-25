// ArrowWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ArrowWipe.glsl
// Author: gre
// License: MIT
// Description: A notched arrowhead window onto the incoming image flies in from the edge behind it (or appears at the center), then swells until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float notch;
    float width;
    int count;
    int origin;
    float smoothness;
    char _pad8[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e37 = uv[0u];
    float _e39 = uv[1u];
    metal::float4 _e42 = _to.sample(_sampler, metal::float2(_e37, 1.0 - _e39), metal::level(0.0));
    return _e42;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e37 = uv_1[0u];
    float _e39 = uv_1[1u];
    metal::float4 _e42 = _from.sample(_sampler, metal::float2(_e37, 1.0 - _e39), metal::level(0.0));
    return _e42;
}

float arrow(
    thread metal::float2& q,
    thread float& tip,
    thread float& back,
    thread metal::float2& tipN,
    thread metal::float2& notchN
) {
    float front = {};
    float rear = {};
    float _e43 = q[0u];
    float _e44 = tip;
    float _e47 = q[1u];
    metal::float2 _e49 = tipN;
    front = metal::dot(metal::float2(_e43 - _e44, _e47), _e49);
    float _e51 = back;
    float _e53 = q[0u];
    float _e56 = q[1u];
    metal::float2 _e59 = notchN;
    rear = metal::dot(metal::float2(_e51 - _e53, -(_e56)), _e59);
    float _e61 = front;
    float _e62 = rear;
    return metal::max(_e61, _e62);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 across = {};
    metal::float2 p = {};
    metal::float2 q_1 = {};
    float s = {};
    float n = {};
    float h = {};
    float cot = {};
    metal::float2 tipN_1 = {};
    float notchLen = {};
    metal::float2 notchN_1 = {};
    float tipPad = {};
    metal::float2 c1_ = {};
    metal::float2 c2_ = {};
    metal::float2 k1_ = {};
    metal::float2 k2_ = {};
    float e = {};
    float r = {};
    float tipMin = {};
    float notchMax = {};
    float body = {};
    float cover = {};
    float t = {};
    float o = {};
    float l = {};
    float l0_ = {};
    float o0_ = {};
    float u = {};
    float fly = {};
    float grow = {};
    float gap = {};
    float d = {};
    metal::float2 param = {};
    float param_1 = {};
    float param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    int i = {};
    float back_1 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float m = {};
    metal::float4 a = {};
    metal::float2 param_10 = {};
    metal::float4 b = {};
    metal::float2 param_11 = {};
    metal::float4 c = {};
    metal::float4 local_1 = {};
    metal::float2 _e89 = uniforms.direction;
    if (metal::length(_e89) > 0.0) {
        metal::float2 _e93 = uniforms.direction;
        local = metal::normalize(_e93);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e95 = local;
    dir = _e95;
    float _e97 = dir[1u];
    float _e100 = dir[0u];
    across = metal::float2(-(_e97), _e100);
    metal::float2 _e102 = uv_2;
    float _e106 = uniforms.ratio;
    p = (_e102 - metal::float2(0.5)) * metal::float2(_e106, 1.0);
    metal::float2 _e109 = p;
    metal::float2 _e110 = dir;
    metal::float2 _e112 = p;
    metal::float2 _e113 = across;
    q_1 = metal::float2(metal::dot(_e109, _e110), metal::abs(metal::dot(_e112, _e113)));
    float _e118 = uniforms.smoothness;
    s = metal::max(_e118, 0.001);
    float _e121 = uniforms.notch;
    n = metal::clamp(_e121, 0.0, 0.9);
    float _e124 = uniforms.width;
    h = (((0.5 * metal::clamp(_e124, 20.0, 160.0))) * 0.017453292519943295474);
    float _e128 = h;
    float _e130 = h;
    cot = metal::cos(_e128) / metal::sin(_e130);
    float _e133 = h;
    float _e135 = h;
    tipN_1 = metal::float2(metal::sin(_e133), metal::cos(_e135));
    float _e138 = n;
    float _e139 = cot;
    notchLen = metal::length(metal::float2(1.0, _e138 * _e139));
    float _e143 = n;
    float _e144 = cot;
    float _e147 = notchLen;
    notchN_1 = metal::float2(1.0, _e143 * _e144) / metal::float2(_e147);
    float _e150 = s;
    float _e151 = h;
    tipPad = _e150 / metal::sin(_e151);
    float _e155 = uniforms.ratio;
    c1_ = metal::float2(0.5 * _e155, 0.5);
    float _e159 = uniforms.ratio;
    c2_ = metal::float2(0.5 * _e159, -0.5);
    metal::float2 _e162 = c1_;
    metal::float2 _e163 = dir;
    metal::float2 _e166 = c1_;
    metal::float2 _e167 = across;
    k1_ = metal::float2(metal::abs(metal::dot(_e162, _e163)), metal::abs(metal::dot(_e166, _e167)));
    metal::float2 _e171 = c2_;
    metal::float2 _e172 = dir;
    metal::float2 _e175 = c2_;
    metal::float2 _e176 = across;
    k2_ = metal::float2(metal::abs(metal::dot(_e171, _e172)), metal::abs(metal::dot(_e175, _e176)));
    float _e181 = k1_[0u];
    float _e183 = k2_[0u];
    e = metal::max(_e181, _e183);
    float _e186 = dir[0u];
    float _e189 = uniforms.ratio;
    float _e192 = dir[1u];
    r = 0.5 / metal::max(metal::abs(_e186) / _e189, metal::abs(_e192));
    float _e197 = k1_[0u];
    float _e199 = k1_[1u];
    float _e200 = cot;
    float _e204 = k2_[0u];
    float _e206 = k2_[1u];
    float _e207 = cot;
    float _e211 = tipPad;
    tipMin = metal::max(_e197 + (_e199 * _e200), _e204 + (_e206 * _e207)) + _e211;
    float _e213 = n;
    float _e214 = cot;
    float _e217 = k1_[1u];
    float _e220 = k1_[0u];
    float _e222 = n;
    float _e223 = cot;
    float _e226 = k2_[1u];
    float _e229 = k2_[0u];
    float _e232 = r;
    float _e235 = s;
    float _e236 = notchLen;
    notchMax = metal::min(metal::min(((_e213 * _e214) * _e217) - _e220, ((_e222 * _e223) * _e226) - _e229), -(_e232)) - (_e235 * _e236);
    float _e239 = n;
    body = 0.5 * (1.0 - _e239);
    float _e242 = tipMin;
    float _e243 = notchMax;
    float _e246 = body;
    cover = metal::max(_e242, -(_e243)) / _e246;
    float _e249 = uniforms.progress;
    t = _e249;
    int _e251 = uniforms.origin;
    if (_e251 != 0) {
        o = 0.0;
        float _e253 = cover;
        float _e254 = t;
        float _e256 = t;
        l = (_e253 * _e254) * (0.4 + (0.6 * _e256));
    } else {
        float _e261 = uniforms.ratio;
        float _e264 = h;
        l0_ = (0.92 * metal::min(1.0, _e261)) / metal::max(1.0, 2.0 * metal::tan(_e264));
        float _e269 = e;
        float _e271 = tipPad;
        float _e274 = body;
        float _e275 = l0_;
        o0_ = (-(_e269) - (2.0 * _e271)) - (_e274 * _e275);
        float _e278 = t;
        u = 1.0 - metal::clamp(_e278 / 0.65, 0.0, 1.0);
        float _e282 = u;
        float _e283 = u;
        float _e285 = u;
        fly = 1.0 - ((_e282 * _e283) * _e285);
        float _e288 = t;
        grow = metal::clamp((_e288 - 0.3) / 0.7, 0.0, 1.0);
        float _e292 = o0_;
        float _e293 = fly;
        o = metal::mix(_e292, 0.0, _e293);
        float _e295 = l0_;
        float _e296 = cover;
        float _e297 = grow;
        float _e298 = grow;
        float _e300 = grow;
        l = metal::mix(_e295, _e296, (_e297 * _e298) * (2.0 - _e300));
    }
    float _e304 = n;
    gap = (1.0 - _e304) * 1.35;
    float _e307 = o;
    float _e308 = body;
    float _e309 = l;
    float _e312 = o;
    float _e313 = body;
    float _e314 = l;
    metal::float2 _e317 = q_1;
    param = _e317;
    param_1 = _e307 + (_e308 * _e309);
    param_2 = _e312 - (_e313 * _e314);
    metal::float2 _e318 = tipN_1;
    param_3 = _e318;
    metal::float2 _e319 = notchN_1;
    param_4 = _e319;
    float _e320 = arrow(param, param_1, param_2, param_3, param_4);
    d = _e320;
    i = 1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e351 = i;
            i = as_type<int>(as_type<uint>(_e351) + as_type<uint>(1));
        }
        loop_init = false;
        int _e321 = i;
        if (_e321 < 3) {
            int _e323 = i;
            int _e325 = uniforms.count;
            if (_e323 < _e325) {
                float _e327 = o;
                int _e328 = i;
                float _e330 = gap;
                float _e332 = l;
                back_1 = _e327 - ((static_cast<float>(_e328) * _e330) * _e332);
                float _e335 = d;
                float _e336 = back_1;
                float _e337 = body;
                float _e338 = l;
                float _e341 = back_1;
                float _e342 = body;
                float _e343 = l;
                metal::float2 _e346 = q_1;
                param_5 = _e346;
                param_6 = _e336 + (_e337 * _e338);
                param_7 = _e341 - (_e342 * _e343);
                metal::float2 _e347 = tipN_1;
                param_8 = _e347;
                metal::float2 _e348 = notchN_1;
                param_9 = _e348;
                float _e349 = arrow(param_5, param_6, param_7, param_8, param_9);
                d = metal::min(_e335, _e349);
            }
            continue;
        } else {
            break;
        }
    }
    float _e353 = s;
    float _e355 = s;
    float _e356 = d;
    float _e357 = s;
    float _e359 = t;
    m = 1.0 - metal::smoothstep(-(_e353), _e355, _e356 + ((2.0 * _e357) * (1.0 - _e359)));
    metal::float2 _e365 = uv_2;
    param_10 = _e365;
    metal::float4 _e366 = getFromColor(param_10, _from, _sampler);
    a = _e366;
    metal::float2 _e367 = uv_2;
    param_11 = _e367;
    metal::float4 _e368 = getToColor(param_11, _sampler, _to);
    b = _e368;
    metal::float4 _e369 = a;
    float _e372 = a[3u];
    metal::float3 _e373 = _e369.xyz * _e372;
    float _e375 = a[3u];
    metal::float4 _e380 = b;
    float _e383 = b[3u];
    metal::float3 _e384 = _e380.xyz * _e383;
    float _e386 = b[3u];
    float _e391 = m;
    c = metal::mix(metal::float4(_e373.x, _e373.y, _e373.z, _e375), metal::float4(_e384.x, _e384.y, _e384.z, _e386), metal::float4(_e391));
    float _e395 = c[3u];
    if (_e395 > 0.0) {
        metal::float4 _e397 = c;
        float _e400 = c[3u];
        metal::float3 _e402 = _e397.xyz / metal::float3(_e400);
        float _e404 = c[3u];
        local_1 = metal::float4(_e402.x, _e402.y, _e402.z, _e404);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e409 = local_1;
    return _e409;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_12 = {};
    metal::float2 _e36 = _uv_1;
    param_12 = _e36;
    metal::float4 _e37 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e37;
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
