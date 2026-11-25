// CurtainRise — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CurtainRise.glsl
// Author: gre
// License: MIT
// Description: The outgoing image rises like a theater festoon curtain: cords lift its hem into scalloped swags while the fabric gathers into shaded ruffles, and it is drawn up out of the frame over the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float swags;
    float sag;
    float ruffles;
    float shading;
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

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float f = {};
    float e = {};
    float s = {};
    float lift = {};
    float n = {};
    float u = {};
    float bump = {};
    float hem = {};
    float aa = {};
    float inside = {};
    metal::float4 c = {};
    float h = {};
    float q = {};
    float m = {};
    float a = {};
    float g = {};
    float v = {};
    float pull = {};
    metal::float2 param = {};
    float slope = {};
    float diffuse = {};
    float crease = {};
    float light = {};
    float depth = {};
    metal::float4 to = {};
    metal::float2 param_1 = {};
    float below = {};
    float shadow = {};
    float _e77 = uniforms.progress;
    p = _e77;
    float _e78 = p;
    float _e80 = p;
    float _e83 = p;
    f = 1.0 - (((1.0 - _e78) * (1.0 - _e80)) * (1.0 - _e83));
    float _e87 = p;
    float _e88 = p;
    float _e89 = p;
    float _e91 = p;
    e = metal::mix(_e87, (_e88 * _e89) * (3.0 - (2.0 * _e91)), 0.4);
    float _e97 = uniforms.sag;
    float _e98 = f;
    s = _e97 * _e98;
    float _e101 = uniforms.sag;
    float _e104 = e;
    lift = metal::mix(-0.01, (1.0 + _e101) + 0.08, _e104);
    float _e107 = uniforms.swags;
    float _e109 = uniforms.ratio;
    n = metal::max(1.0, metal::floor((_e107 * metal::sqrt(_e109 / 1.78)) + 0.5));
    float _e117 = uv_2[0u];
    float _e118 = n;
    u = (metal::fract(_e117 * _e118) * 2.0) - 1.0;
    float _e123 = u;
    float _e124 = u;
    bump = 1.0 - (_e123 * _e124);
    float _e127 = lift;
    float _e128 = s;
    float _e129 = bump;
    hem = _e127 - (_e128 * _e129);
    float _e132 = f;
    aa = 0.002 + (0.004 * _e132);
    float _e135 = hem;
    float _e136 = aa;
    float _e138 = hem;
    float _e139 = aa;
    float _e142 = uv_2[1u];
    inside = metal::smoothstep(_e135 - _e136, _e138 + _e139, _e142);
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e144 = inside;
    if (_e144 > 0.0) {
        float _e146 = hem;
        h = metal::max(1.0 - metal::max(_e146, 0.0), 0.0001);
        float _e151 = uv_2[1u];
        float _e153 = h;
        q = metal::clamp((1.0 - _e151) / _e153, 0.0, 1.0);
        float _e157 = uniforms.ruffles;
        float _e161 = h;
        m = metal::min(metal::max(1.0, metal::floor(_e157 + 0.5)), _e161 / 0.02);
        float _e164 = m;
        float _e166 = q;
        a = (6.2831855 * _e164) * _e166;
        float _e168 = f;
        float _e170 = h;
        float _e176 = bump;
        g = ((0.85 * _e168) * metal::min(1.0, 0.3 + (5.0 * (1.0 - _e170)))) * (0.6 + (0.4 * _e176));
        float _e180 = q;
        float _e181 = g;
        float _e182 = a;
        float _e185 = m;
        v = metal::clamp(_e180 + ((_e181 * metal::sin(_e182)) / (6.2831855 * _e185)), 0.0, 1.0);
        float _e190 = f;
        float _e192 = q;
        float _e194 = q;
        float _e196 = u;
        float _e200 = n;
        pull = ((((0.25 * _e190) * _e192) * _e194) * metal::sin(3.1415927 * _e196)) / (3.1415927 * _e200);
        float _e204 = uv_2[0u];
        float _e205 = pull;
        float _e207 = v;
        param = metal::float2(_e204 - _e205, 1.0 - _e207);
        metal::float4 _e210 = getFromColor(param, _from, _sampler);
        c = _e210;
        float _e211 = g;
        float _e213 = a;
        slope = (2.5 * _e211) * metal::cos(_e213);
        float _e216 = slope;
        float _e219 = slope;
        float _e220 = slope;
        diffuse = (1.0 - (0.35 * _e216)) / metal::sqrt(1.0 + (_e219 * _e220));
        float _e225 = a;
        crease = 0.5 + (0.5 * metal::sin(_e225));
        float _e229 = diffuse;
        float _e230 = crease;
        float _e232 = crease;
        float _e237 = uniforms.shading;
        float _e238 = g;
        light = metal::mix(1.0, _e229 * (1.0 - ((0.45 * _e230) * _e232)), _e237 * _e238);
        float _e242 = uniforms.shading;
        float _e244 = g;
        float _e246 = a;
        float _e251 = light;
        light = _e251 + (((0.18 * _e242) * _e244) * metal::smoothstep(0.4, 1.0, -(metal::cos(_e246))));
        float _e253 = f;
        float _e254 = q;
        float _e256 = q;
        depth = (_e253 * _e254) * (0.3 + (0.7 * _e256));
        float _e261 = uniforms.shading;
        float _e262 = depth;
        float _e264 = u;
        float _e266 = u;
        float _e268 = u;
        float _e278 = light;
        light = _e278 * (1.0 - ((_e261 * _e262) * (((0.35 * _e264) * _e266) + (0.5 * metal::exp(-((1.0 - metal::abs(_e268))) * 14.0)))));
        float _e281 = uniforms.shading;
        float _e283 = f;
        float _e286 = uv_2[1u];
        float _e287 = hem;
        float _e294 = light;
        light = _e294 * (1.0 - (((0.35 * _e281) * _e283) * metal::exp(-((_e286 - _e287)) * 120.0)));
        float _e296 = light;
        metal::float4 _e297 = c;
        metal::float3 _e299 = _e297.xyz * _e296;
        c[0u] = _e299.x;
        c[1u] = _e299.y;
        c[2u] = _e299.z;
        float _e306 = inside;
        if (_e306 >= 1.0) {
            metal::float4 _e308 = c;
            return _e308;
        }
    }
    metal::float2 _e309 = uv_2;
    param_1 = _e309;
    metal::float4 _e310 = getToColor(param_1, _sampler, _to);
    to = _e310;
    float _e311 = hem;
    float _e313 = uv_2[1u];
    below = metal::max(_e311 - _e313, 0.0);
    float _e317 = uniforms.shading;
    float _e319 = below;
    float _e324 = lift;
    float _e327 = lift;
    float _e328 = s;
    shadow = (((0.6 * _e317) * metal::exp(-(_e319) * 22.0)) * metal::smoothstep(0.0, 0.05, _e324)) * (1.0 - metal::smoothstep(1.0, 1.06, _e327 - _e328));
    float _e333 = shadow;
    metal::float4 _e335 = to;
    metal::float3 _e337 = _e335.xyz * (1.0 - _e333);
    to[0u] = _e337.x;
    to[1u] = _e337.y;
    to[2u] = _e337.z;
    metal::float4 _e344 = to;
    metal::float4 _e345 = c;
    float _e346 = inside;
    return metal::mix(_e344, _e345, metal::float4(_e346));
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
    metal::float2 _e47 = _uv_1;
    param_2 = _e47;
    metal::float4 _e48 = transition(param_2, _from, _sampler, _to, uniforms);
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
