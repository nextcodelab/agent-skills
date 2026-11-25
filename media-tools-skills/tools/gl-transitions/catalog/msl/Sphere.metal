// Sphere — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Sphere.glsl
// Author: gre
// License: MIT
// Description: The outgoing image wraps itself onto a shaded ball that shrinks and rolls away, revealing the incoming image under its shadow
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float size;
    float shading;
    float shadow;
    char _pad6[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e51 = uv[0u];
    float _e53 = uv[1u];
    metal::float4 _e56 = _to.sample(_sampler, metal::float2(_e51, 1.0 - _e53), metal::level(0.0));
    return _e56;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e51 = uv_1[0u];
    float _e53 = uv_1[1u];
    metal::float4 _e56 = _from.sample(_sampler, metal::float2(_e51, 1.0 - _e53), metal::level(0.0));
    return _e56;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 side = {};
    metal::float2 p = {};
    float shorter = {};
    float r0_ = {};
    float w = {};
    float away = {};
    float wrapped = {};
    float radius = {};
    float tight = {};
    float paper = {};
    float e = {};
    float full = {};
    float travel = {};
    metal::float2 center = {};
    float angle = {};
    metal::float2 d = {};
    float r = {};
    metal::float2 sd = {};
    float sh = {};
    metal::float4 bg = {};
    metal::float4 ball = {};
    float cover = {};
    metal::float2 nd = {};
    metal::float3 n = {};
    float u = {};
    float s = {};
    float cu = {};
    float su = {};
    metal::float3 q = {};
    float lq = {};
    float arc = {};
    metal::float2 img = {};
    metal::float2 local_1 = {};
    metal::float2 iuv = {};
    metal::float2 edge = {};
    float inside = {};
    metal::float4 c = {};
    metal::float2 param_2 = {};
    float diff = {};
    float spec = {};
    float k = {};
    metal::float3 lit = {};
    metal::float4 c_1 = {};
    metal::float4 local_2 = {};
    float _e100 = uniforms.progress;
    if (_e100 <= 0.0) {
        metal::float2 _e102 = uv_2;
        param = _e102;
        metal::float4 _e103 = getFromColor(param, _from, _sampler);
        return _e103;
    }
    metal::float2 _e104 = uv_2;
    param_1 = _e104;
    metal::float4 _e105 = getToColor(param_1, _sampler, _to);
    b = _e105;
    float _e107 = uniforms.progress;
    if (_e107 >= 1.0) {
        metal::float4 _e109 = b;
        return _e109;
    }
    metal::float2 _e111 = uniforms.direction;
    if (metal::length(_e111) > 0.0) {
        metal::float2 _e115 = uniforms.direction;
        local = metal::normalize(_e115);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e117 = local;
    dir = _e117;
    float _e119 = dir[1u];
    float _e122 = dir[0u];
    side = metal::float2(-(_e119), _e122);
    metal::float2 _e124 = uv_2;
    float _e128 = uniforms.ratio;
    p = (_e124 - metal::float2(0.5)) * metal::float2(_e128, 1.0);
    float _e132 = uniforms.ratio;
    shorter = metal::min(_e132, 1.0);
    float _e135 = uniforms.size;
    float _e137 = shorter;
    r0_ = metal::clamp(_e135, 0.1, 0.5) * _e137;
    float _e140 = uniforms.progress;
    w = metal::clamp(_e140 / 0.45, 0.0, 1.0);
    float _e143 = w;
    float _e145 = w;
    w = 1.0 - ((1.0 - _e143) * (1.0 - _e145));
    float _e150 = uniforms.progress;
    away = metal::smoothstep(0.3, 1.0, _e150);
    float _e152 = away;
    float _e153 = away;
    away = _e153 * _e152;
    float _e155 = r0_;
    float _e156 = w;
    wrapped = _e155 / metal::max(_e156, 0.0001);
    float _e159 = wrapped;
    float _e160 = away;
    radius = _e159 * metal::mix(1.0, 0.5, _e160);
    float _e163 = shorter;
    float _e165 = r0_;
    float _e169 = w;
    float _e170 = w;
    tight = metal::mix(1.0, metal::min(1.0, (0.48 * _e163) / (3.1415927 * _e165)), _e169 * _e170);
    float _e173 = radius;
    float _e174 = tight;
    paper = _e173 * _e174;
    float _e177 = dir[0u];
    float _e180 = uniforms.ratio;
    float _e183 = dir[1u];
    e = 0.5 * ((metal::abs(_e177) * _e180) + metal::abs(_e183));
    float _e187 = e;
    float _e188 = r0_;
    full = (_e187 + (1.1 * _e188)) + 0.003;
    float _e192 = away;
    float _e193 = full;
    travel = _e192 * _e193;
    metal::float2 _e195 = dir;
    float _e196 = travel;
    center = _e195 * _e196;
    float _e198 = full;
    float _e200 = away;
    float _e205 = wrapped;
    angle = ((-2.0 * _e198) * metal::log(1.0 - (0.5 * _e200))) / _e205;
    metal::float2 _e207 = p;
    metal::float2 _e208 = center;
    d = _e207 - _e208;
    metal::float2 _e210 = d;
    r = metal::length(_e210);
    metal::float2 _e212 = d;
    float _e213 = radius;
    float _e215 = w;
    sd = _e212 - ((metal::float2(0.25, -0.3) * _e213) * _e215);
    float _e219 = uniforms.shadow;
    float _e220 = w;
    float _e222 = radius;
    float _e224 = radius;
    metal::float2 _e226 = sd;
    sh = (_e219 * _e220) * (1.0 - metal::smoothstep(0.6 * _e222, 1.4 * _e224, metal::length(_e226)));
    metal::float4 _e231 = b;
    float _e234 = b[3u];
    float _e236 = sh;
    metal::float3 _e238 = (_e231.xyz * _e234) * (1.0 - _e236);
    float _e240 = b[3u];
    bg = metal::float4(_e238.x, _e238.y, _e238.z, _e240);
    ball = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e245 = radius;
    float _e247 = radius;
    float _e249 = r;
    cover = 1.0 - metal::smoothstep(_e245 - 0.0015, _e247 + 0.0015, _e249);
    float _e252 = cover;
    if (_e252 > 0.0) {
        metal::float2 _e254 = d;
        float _e255 = radius;
        nd = _e254 / metal::float2(_e255);
        metal::float2 _e258 = nd;
        metal::float2 _e259 = nd;
        metal::float2 _e260 = nd;
        n = metal::float3(_e258.x, _e258.y, metal::sqrt(metal::max(1.0 - metal::dot(_e259, _e260), 0.0)));
        metal::float3 _e268 = n;
        metal::float2 _e270 = dir;
        u = metal::dot(_e268.xy, _e270);
        metal::float3 _e272 = n;
        metal::float2 _e274 = side;
        s = metal::dot(_e272.xy, _e274);
        float _e276 = angle;
        cu = metal::cos(_e276);
        float _e278 = angle;
        su = metal::sin(_e278);
        float _e280 = u;
        float _e281 = cu;
        float _e284 = n[2u];
        float _e285 = su;
        float _e288 = s;
        float _e289 = u;
        float _e290 = su;
        float _e293 = n[2u];
        float _e294 = cu;
        q = metal::float3((_e280 * _e281) - (_e284 * _e285), _e288, (_e289 * _e290) + (_e293 * _e294));
        metal::float3 _e298 = q;
        lq = metal::length(_e298.xy);
        float _e301 = lq;
        float _e303 = q[2u];
        float _e305 = paper;
        arc = metal::atan2(_e301, _e303) * _e305;
        float _e307 = lq;
        if (_e307 > 0.0) {
            float _e310 = q[0u];
            metal::float2 _e311 = dir;
            float _e314 = q[1u];
            metal::float2 _e315 = side;
            float _e318 = lq;
            float _e321 = arc;
            local_1 = (((_e311 * _e310) + (_e315 * _e314)) / metal::float2(_e318)) * _e321;
        } else {
            local_1 = metal::float2(0.0, 0.0);
        }
        metal::float2 _e323 = local_1;
        img = _e323;
        metal::float2 _e324 = img;
        float _e326 = uniforms.ratio;
        iuv = (_e324 / metal::float2(_e326, 1.0)) + metal::float2(0.5);
        metal::float2 _e331 = iuv;
        metal::float2 _e332 = iuv;
        float _e337 = uniforms.ratio;
        edge = metal::min(_e331, metal::float2(1.0) - _e332) * metal::float2(_e337, 1.0);
        float _e340 = cover;
        float _e342 = edge[0u];
        float _e344 = edge[1u];
        inside = _e340 * metal::smoothstep(-0.0015, 0.0015, metal::min(_e342, _e344));
        float _e348 = inside;
        if (_e348 > 0.0) {
            metal::float2 _e350 = iuv;
            param_2 = metal::clamp(_e350, metal::float2(0.0), metal::float2(1.0));
            metal::float4 _e354 = getFromColor(param_2, _from, _sampler);
            c = _e354;
            metal::float3 _e355 = n;
            diff = metal::max(metal::dot(_e355, metal::float3(-0.39404207, 0.4728505, 0.78808415)), 0.0);
            metal::float3 _e358 = n;
            spec = metal::pow(metal::max(metal::reflect(metal::float3(0.39404207, -0.4728505, -0.78808415), _e358).z, 0.0), 24.0);
            float _e364 = uniforms.shading;
            float _e365 = w;
            k = _e364 * _e365;
            metal::float4 _e367 = c;
            float _e369 = diff;
            float _e372 = k;
            float _e375 = k;
            float _e377 = spec;
            lit = (_e367.xyz * metal::mix(1.0, 0.25 + (0.85 * _e369), _e372)) + metal::float3((0.35 * _e375) * _e377);
            metal::float3 _e381 = lit;
            float _e386 = c[3u];
            metal::float3 _e387 = metal::clamp(_e381, metal::float3(0.0), metal::float3(1.0)) * _e386;
            float _e389 = c[3u];
            float _e394 = inside;
            ball = metal::float4(_e387.x, _e387.y, _e387.z, _e389) * _e394;
        }
    }
    metal::float4 _e396 = ball;
    metal::float4 _e397 = bg;
    float _e399 = ball[3u];
    c_1 = _e396 + (_e397 * (1.0 - _e399));
    float _e404 = c_1[3u];
    if (_e404 > 0.0) {
        metal::float4 _e406 = c_1;
        float _e409 = c_1[3u];
        metal::float3 _e411 = _e406.xyz / metal::float3(_e409);
        float _e413 = c_1[3u];
        local_2 = metal::float4(_e411.x, _e411.y, _e411.z, _e413);
    } else {
        local_2 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e418 = local_2;
    return _e418;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e50 = _uv_1;
    param_3 = _e50;
    metal::float4 _e51 = transition(param_3, _from, _sampler, _to, uniforms);
    _fragColor = _e51;
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
