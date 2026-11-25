// KeyholeWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/KeyholeWipe.glsl
// Author: gre
// License: MIT
// Description: A keyhole grows steadily from the center until the incoming image fills the frame, its bevelled rim and inner shadow making it read as a hole cut in a plate
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float rim;
    float smoothness;
};

float dot2(
    thread metal::float2& v
) {
    metal::float2 _e53 = v;
    metal::float2 _e54 = v;
    return metal::dot(_e53, _e54);
}

float sdSlot(
    thread metal::float2& p
) {
    float r1_ = {};
    float r2_ = {};
    float he = {};
    metal::float2 k1_ = {};
    metal::float2 k2_ = {};
    metal::float2 ca = {};
    metal::float2 cb = {};
    metal::float2 param = {};
    float s = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    bool phi_149_ = {};
    float _e65 = p[1u];
    p[1u] = _e65 - -0.17;
    r1_ = 0.14;
    r2_ = 0.06;
    he = 0.205;
    float _e68 = r2_;
    float _e69 = he;
    k1_ = metal::float2(_e68, _e69);
    float _e71 = r2_;
    float _e72 = r1_;
    float _e74 = he;
    k2_ = metal::float2(_e71 - _e72, 2.0 * _e74);
    float _e78 = p[0u];
    p[0u] = metal::abs(_e78);
    float _e82 = p[0u];
    float _e84 = p[0u];
    float _e86 = p[1u];
    float _e88 = r1_;
    float _e89 = r2_;
    float _e94 = p[1u];
    float _e96 = he;
    ca = metal::float2(_e82 - metal::min(_e84, (_e86 < 0.0) ? _e88 : _e89), metal::abs(_e94) - _e96);
    metal::float2 _e99 = p;
    metal::float2 _e100 = k1_;
    metal::float2 _e102 = k2_;
    metal::float2 _e103 = k1_;
    metal::float2 _e104 = p;
    metal::float2 _e106 = k2_;
    metal::float2 _e108 = k2_;
    param = _e108;
    float _e109 = dot2(param);
    cb = (_e99 - _e100) + (_e102 * metal::clamp(metal::dot(_e103 - _e104, _e106) / _e109, 0.0, 1.0));
    float _e115 = cb[0u];
    bool _e116 = _e115 < 0.0;
    phi_149_ = _e116;
    if (_e116) {
        float _e118 = ca[1u];
        phi_149_ = _e118 < 0.0;
    }
    bool _e121 = phi_149_;
    s = _e121 ? -1.0 : 1.0;
    float _e123 = s;
    metal::float2 _e124 = ca;
    param_1 = _e124;
    float _e125 = dot2(param_1);
    metal::float2 _e126 = cb;
    param_2 = _e126;
    float _e127 = dot2(param_2);
    return (_e123 * metal::sqrt(metal::min(_e125, _e127))) - 0.025;
}

float sdKeyhole(
    thread metal::float2& p_1
) {
    metal::float2 param_3 = {};
    metal::float2 _e54 = p_1;
    metal::float2 _e58 = p_1;
    param_3 = _e58;
    float _e59 = sdSlot(param_3);
    return metal::min(metal::length(_e54 - metal::float2(0.0, 0.2)) - 0.25, _e59);
}

float reach(
    thread metal::float2& p_2
) {
    metal::float2 h = {};
    float k = {};
    metal::float2 param_4 = {};
    float b = {};
    metal::float2 param_5 = {};
    h = metal::float2(0.0, 0.1);
    metal::float2 _e58 = h;
    param_4 = _e58;
    float _e59 = dot2(param_4);
    k = 0.0625 - _e59;
    metal::float2 _e61 = p_2;
    metal::float2 _e62 = h;
    b = metal::dot(_e61, _e62);
    float _e64 = b;
    float _e65 = b;
    float _e67 = k;
    metal::float2 _e68 = p_2;
    param_5 = _e68;
    float _e69 = dot2(param_5);
    float _e73 = b;
    float _e75 = k;
    return (metal::sqrt((_e64 * _e65) + (_e67 * _e69)) - _e73) / _e75;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e54 = uv[0u];
    float _e56 = uv[1u];
    metal::float4 _e59 = _to.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e54 = uv_1[0u];
    float _e56 = uv_1[1u];
    metal::float4 _e59 = _from.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param_6 = {};
    metal::float4 b_1 = {};
    metal::float2 param_7 = {};
    metal::float2 asp = {};
    metal::float2 c = {};
    float sm = {};
    metal::float2 o = {};
    metal::float2 lo = {};
    metal::float2 hi = {};
    float full = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    float p_3 = {};
    float s_1 = {};
    metal::float2 q = {};
    float d = {};
    metal::float2 param_12 = {};
    float hole = {};
    float fade = {};
    float rimA = {};
    metal::float2 e = {};
    metal::float2 n = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    float lit = {};
    float bevel = {};
    float shade = {};
    float wall = {};
    metal::float2 param_17 = {};
    float vign = {};
    metal::float2 _e88 = uv_2;
    param_6 = _e88;
    metal::float4 _e89 = getFromColor(param_6, _from, _sampler);
    a = _e89;
    metal::float2 _e90 = uv_2;
    param_7 = _e90;
    metal::float4 _e91 = getToColor(param_7, _sampler, _to);
    b_1 = _e91;
    float _e93 = uniforms.ratio;
    asp = metal::float2(_e93, 1.0);
    metal::float2 _e96 = uniforms.center;
    metal::float2 _e97 = asp;
    c = _e96 * _e97;
    float _e100 = uniforms.smoothness;
    sm = metal::max(_e100, 0.0005);
    metal::float2 _e102 = c;
    o = _e102;
    metal::float2 _e103 = o;
    float _e105 = sm;
    lo = -(_e103) - metal::float2(2.5 * _e105);
    metal::float2 _e109 = asp;
    metal::float2 _e110 = o;
    float _e112 = sm;
    hi = (_e109 - _e110) + metal::float2(2.5 * _e112);
    metal::float2 _e116 = lo;
    param_8 = _e116;
    float _e117 = reach(param_8);
    metal::float2 _e118 = hi;
    param_9 = _e118;
    float _e119 = reach(param_9);
    float _e122 = lo[0u];
    float _e124 = hi[1u];
    param_10 = metal::float2(_e122, _e124);
    float _e126 = reach(param_10);
    float _e128 = hi[0u];
    float _e130 = lo[1u];
    param_11 = metal::float2(_e128, _e130);
    float _e132 = reach(param_11);
    full = metal::max(metal::max(_e117, _e119), metal::max(_e126, _e132));
    float _e136 = uniforms.progress;
    p_3 = _e136;
    float _e137 = full;
    float _e138 = p_3;
    s_1 = _e137 * _e138;
    float _e140 = s_1;
    if (_e140 <= 0.0) {
        metal::float4 _e142 = a;
        return _e142;
    }
    metal::float2 _e143 = uv_2;
    metal::float2 _e144 = asp;
    metal::float2 _e146 = o;
    float _e148 = s_1;
    q = (((_e143 * _e144) - _e146) / metal::float2(_e148)) + metal::float2(0.0, 0.1);
    metal::float2 _e152 = q;
    param_12 = _e152;
    float _e153 = sdKeyhole(param_12);
    d = _e153;
    float _e154 = sm;
    float _e156 = sm;
    float _e157 = d;
    float _e158 = s_1;
    float _e160 = sm;
    hole = 1.0 - metal::smoothstep(-(_e154), _e156, (_e157 * _e158) + _e160);
    float _e164 = p_3;
    float _e166 = p_3;
    fade = metal::smoothstep(0.0, 0.08, _e164) * (1.0 - metal::smoothstep(0.7, 1.0, _e166));
    float _e171 = uniforms.rim;
    float _e172 = fade;
    rimA = _e171 * _e172;
    float _e174 = rimA;
    if (_e174 > 0.0) {
        e = metal::float2(0.002, 0.0);
        metal::float2 _e176 = q;
        metal::float2 _e177 = e;
        param_13 = _e176 + _e177;
        float _e179 = sdKeyhole(param_13);
        metal::float2 _e180 = q;
        metal::float2 _e181 = e;
        param_14 = _e180 - _e181;
        float _e183 = sdKeyhole(param_14);
        metal::float2 _e185 = q;
        metal::float2 _e186 = e;
        param_15 = _e185 + _e186.yx;
        float _e189 = sdKeyhole(param_15);
        metal::float2 _e190 = q;
        metal::float2 _e191 = e;
        param_16 = _e190 - _e191.yx;
        float _e194 = sdKeyhole(param_16);
        n = metal::float2(_e179 - _e183, _e189 - _e194);
        metal::float2 _e197 = n;
        metal::float2 _e198 = n;
        lit = -(metal::dot(_e197 / metal::float2(metal::max(metal::length(_e198), 0.000001)), metal::float2(-0.35, 0.94)));
        float _e205 = d;
        bevel = 1.0 - metal::smoothstep(0.0, 0.028, _e205);
        float _e208 = d;
        shade = metal::exp(-(metal::max(_e208, 0.0)) / 0.05);
        float _e213 = rimA;
        float _e214 = shade;
        float _e216 = bevel;
        float _e218 = lit;
        metal::float4 _e225 = a;
        metal::float3 _e227 = _e225.xyz * (1.0 - (_e213 * ((0.35 * _e214) + ((_e216 * 0.4) * metal::max(-(_e218), 0.0)))));
        a[0u] = _e227.x;
        a[1u] = _e227.y;
        a[2u] = _e227.z;
        float _e234 = rimA;
        float _e235 = bevel;
        float _e237 = bevel;
        float _e240 = lit;
        float _e244 = a[3u];
        metal::float4 _e246 = a;
        metal::float3 _e249 = _e246.xyz + metal::float3(((((_e234 * _e235) * _e237) * 0.3) * metal::max(_e240, 0.0)) * _e244);
        a[0u] = _e249.x;
        a[1u] = _e249.y;
        a[2u] = _e249.z;
        metal::float2 _e256 = q;
        param_17 = _e256 + metal::float2(0.0, 0.05);
        float _e258 = sdKeyhole(param_17);
        wall = metal::smoothstep(-0.03, 0.03, _e258);
        float _e260 = d;
        vign = metal::exp(metal::min(_e260, 0.0) / 0.05);
        float _e264 = rimA;
        float _e265 = wall;
        float _e267 = vign;
        metal::float4 _e272 = b_1;
        metal::float3 _e274 = _e272.xyz * (1.0 - (_e264 * ((0.5 * _e265) + (0.3 * _e267))));
        b_1[0u] = _e274.x;
        b_1[1u] = _e274.y;
        b_1[2u] = _e274.z;
    }
    metal::float4 _e281 = a;
    metal::float4 _e282 = b_1;
    float _e283 = hole;
    return metal::mix(_e281, _e282, metal::float4(_e283));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_18 = {};
    metal::float2 _e53 = _uv_1;
    param_18 = _e53;
    metal::float4 _e54 = transition(param_18, _from, _sampler, _to, uniforms);
    _fragColor = _e54;
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
