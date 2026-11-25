// PaperTear — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PaperTear.glsl
// Author: gre
// License: MIT
// Description: The outgoing image tears in two along a ragged line, and the halves are pulled apart to reveal the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float roughness;
    float tilt;
    float rim;
    char _pad5[12];
    metal::float4 paper;
    metal::float4 shadow;
};

metal::float4 torn(
    thread metal::float4& bg,
    thread metal::float4& col,
    thread float& e,
    thread float& limit,
    thread float& aa,
    constant Uniforms& uniforms
) {
    metal::float4 c = {};
    metal::float4 _e53 = col;
    metal::float4 _e56 = uniforms.paper;
    float _e58 = e;
    float _e59 = aa;
    float _e65 = uniforms.paper[3u];
    metal::float3 _e68 = metal::mix(_e53.xyz, _e56.xyz, metal::float3(metal::clamp(0.5 + (_e58 / _e59), 0.0, 1.0) * _e65));
    float _e70 = col[3u];
    c = metal::float4(_e68.x, _e68.y, _e68.z, _e70);
    metal::float4 _e75 = bg;
    metal::float4 _e76 = c;
    float _e77 = e;
    float _e78 = limit;
    float _e80 = aa;
    return metal::mix(_e75, _e76, metal::float4(metal::clamp(0.5 - ((_e77 - _e78) / _e80), 0.0, 1.0)));
}

float tri(
    thread float& x
) {
    float _e48 = x;
    return metal::abs(metal::fract(_e48) - 0.5) - 0.25;
}

float fibers(
    thread float& y,
    thread float& seed,
    constant Uniforms& uniforms
) {
    float param = {};
    float _e51 = uniforms.rim;
    float _e52 = y;
    float _e54 = seed;
    float _e59 = y;
    float _e61 = seed;
    param = (_e59 * 83.0) + _e61;
    float _e63 = tri(param);
    return _e51 * ((0.7 + (0.3 * metal::sin((_e52 * 37.0) + _e54))) + (0.4 * _e63));
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e49 = uv[0u];
    float _e51 = uv[1u];
    metal::float4 _e54 = _from.sample(_sampler, metal::float2(_e49, 1.0 - _e51), metal::level(0.0));
    return _e54;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e49 = uv_1[0u];
    float _e51 = uv_1[1u];
    metal::float4 _e54 = _to.sample(_sampler, metal::float2(_e49, 1.0 - _e51), metal::level(0.0));
    return _e54;
}

float meander(
    thread float& y_1,
    constant Uniforms& uniforms
) {
    float _e49 = uniforms.ratio;
    float _e52 = uniforms.roughness;
    float _e53 = y_1;
    float _e58 = y_1;
    return (0.5 * _e49) + (_e52 * ((0.5 * metal::sin((_e53 * 4.7) + 1.3)) + (0.25 * metal::sin((_e58 * 11.3) + 4.1))));
}

float tear(
    thread float& y_2,
    constant Uniforms& uniforms
) {
    float param_1 = {};
    float param_2 = {};
    float param_3 = {};
    float _e51 = y_2;
    param_1 = _e51;
    float _e52 = meander(param_1, uniforms);
    float _e54 = uniforms.roughness;
    float _e55 = y_2;
    float _e60 = y_2;
    float _e62 = y_2;
    param_2 = (_e60 * 19.0) + metal::sin(_e62 * 7.0);
    float _e66 = tri(param_2);
    float _e69 = y_2;
    float _e71 = y_2;
    param_3 = (_e69 * 47.0) + (0.6 * metal::sin(_e71 * 13.0));
    float _e76 = tri(param_3);
    return _e52 + (_e54 * (((0.1 * metal::sin((_e55 * 29.0) + 0.7)) + (0.35 * _e66)) + (0.12 * _e76)));
}

metal::float2 unfold(
    thread metal::float2& q,
    thread float& away,
    thread float& lean
) {
    float _e51 = q[0u];
    float _e52 = away;
    float _e54 = lean;
    float _e56 = q[1u];
    float _e60 = q[1u];
    return metal::float2((_e51 + _e52) + (_e54 * _e56), _e60);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float away_1 = {};
    float lean_1 = {};
    float fiber = {};
    float aa_1 = {};
    metal::float2 q_1 = {};
    metal::float2 l = {};
    metal::float2 param_4 = {};
    float param_5 = {};
    float param_6 = {};
    metal::float2 r = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float el = {};
    float param_10 = {};
    float er = {};
    float param_11 = {};
    metal::float2 sq = {};
    float dl = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float dr = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    metal::float4 to = {};
    metal::float2 param_20 = {};
    float sh = {};
    metal::float4 c_1 = {};
    metal::float2 param_21 = {};
    float param_22 = {};
    float param_23 = {};
    metal::float4 param_24 = {};
    metal::float4 param_25 = {};
    float param_26 = {};
    float param_27 = {};
    float param_28 = {};
    metal::float2 param_29 = {};
    float param_30 = {};
    float param_31 = {};
    metal::float4 param_32 = {};
    metal::float4 param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float param_36 = {};
    float _e98 = uniforms.progress;
    p = _e98;
    float _e99 = p;
    float _e100 = p;
    float _e103 = uniforms.ratio;
    float _e107 = uniforms.roughness;
    float _e110 = uniforms.rim;
    away_1 = (_e99 * _e100) * ((((0.5 * _e103) + 0.1) + _e107) + (2.0 * _e110));
    float _e115 = uniforms.tilt;
    float _e116 = p;
    float _e118 = p;
    lean_1 = (_e115 * _e116) * (2.0 - _e118);
    float _e121 = p;
    fiber = metal::smoothstep(0.0, 0.15, _e121);
    float _e123 = fiber;
    aa_1 = (0.002 * _e123) + 0.000001;
    float _e127 = uv_2[0u];
    float _e129 = uniforms.ratio;
    float _e132 = uv_2[1u];
    q_1 = metal::float2(_e127 * _e129, _e132);
    metal::float2 _e134 = q_1;
    param_4 = _e134;
    float _e135 = away_1;
    param_5 = _e135;
    float _e136 = lean_1;
    param_6 = _e136;
    metal::float2 _e137 = unfold(param_4, param_5, param_6);
    l = _e137;
    float _e139 = uniforms.ratio;
    float _e141 = q_1[0u];
    float _e144 = q_1[1u];
    param_7 = metal::float2(_e139 - _e141, _e144);
    float _e146 = away_1;
    param_8 = _e146;
    float _e147 = lean_1;
    param_9 = _e147;
    metal::float2 _e148 = unfold(param_7, param_8, param_9);
    r = _e148;
    float _e150 = l[0u];
    float _e152 = l[1u];
    param_10 = _e152;
    float _e153 = tear(param_10, uniforms);
    el = _e150 - _e153;
    float _e156 = r[0u];
    float _e158 = uniforms.ratio;
    float _e160 = r[1u];
    param_11 = _e160;
    float _e161 = tear(param_11, uniforms);
    er = _e156 - (_e158 - _e161);
    metal::float2 _e164 = q_1;
    sq = _e164 - metal::float2(0.01, 0.0);
    metal::float2 _e166 = sq;
    param_12 = _e166;
    float _e167 = away_1;
    param_13 = _e167;
    float _e168 = lean_1;
    param_14 = _e168;
    metal::float2 _e169 = unfold(param_12, param_13, param_14);
    float _e172 = sq[1u];
    param_15 = _e172;
    float _e173 = meander(param_15, uniforms);
    dl = _e169.x - _e173;
    float _e176 = uniforms.ratio;
    float _e178 = sq[0u];
    float _e181 = sq[1u];
    param_16 = metal::float2(_e176 - _e178, _e181);
    float _e183 = away_1;
    param_17 = _e183;
    float _e184 = lean_1;
    param_18 = _e184;
    metal::float2 _e185 = unfold(param_16, param_17, param_18);
    float _e188 = uniforms.ratio;
    float _e190 = sq[1u];
    param_19 = _e190;
    float _e191 = meander(param_19, uniforms);
    dr = _e185.x - (_e188 - _e191);
    metal::float2 _e194 = uv_2;
    param_20 = _e194;
    metal::float4 _e195 = getToColor(param_20, _sampler, _to);
    to = _e195;
    float _e198 = uniforms.shadow[3u];
    float _e199 = dl;
    float _e200 = dr;
    sh = _e198 * (1.0 - metal::smoothstep(-0.02, 0.08, metal::min(_e199, _e200)));
    metal::float4 _e205 = to;
    metal::float4 _e208 = uniforms.shadow;
    float _e210 = sh;
    metal::float3 _e212 = metal::mix(_e205.xyz, _e208.xyz, metal::float3(_e210));
    float _e214 = to[3u];
    c_1 = metal::float4(_e212.x, _e212.y, _e212.z, _e214);
    float _e220 = r[0u];
    if (_e220 >= 0.0) {
        float _e223 = r[0u];
        float _e225 = uniforms.ratio;
        float _e229 = r[1u];
        param_21 = metal::float2(1.0 - (_e223 / _e225), _e229);
        metal::float4 _e231 = getFromColor(param_21, _from, _sampler);
        float _e233 = r[1u];
        param_22 = _e233;
        param_23 = 2.0;
        float _e234 = fibers(param_22, param_23, uniforms);
        float _e236 = fiber;
        metal::float4 _e238 = c_1;
        param_24 = _e238;
        param_25 = _e231;
        float _e239 = er;
        param_26 = _e239;
        param_27 = (_e234 * 1.5) * _e236;
        float _e240 = aa_1;
        param_28 = _e240;
        metal::float4 _e241 = torn(param_24, param_25, param_26, param_27, param_28, uniforms);
        c_1 = _e241;
    }
    float _e243 = l[0u];
    if (_e243 >= 0.0) {
        float _e246 = l[0u];
        float _e248 = uniforms.ratio;
        float _e251 = l[1u];
        param_29 = metal::float2(_e246 / _e248, _e251);
        metal::float4 _e253 = getFromColor(param_29, _from, _sampler);
        float _e255 = l[1u];
        param_30 = _e255;
        param_31 = 0.0;
        float _e256 = fibers(param_30, param_31, uniforms);
        float _e257 = fiber;
        metal::float4 _e259 = c_1;
        param_32 = _e259;
        param_33 = _e253;
        float _e260 = el;
        param_34 = _e260;
        param_35 = _e256 * _e257;
        float _e261 = aa_1;
        param_36 = _e261;
        metal::float4 _e262 = torn(param_32, param_33, param_34, param_35, param_36, uniforms);
        c_1 = _e262;
    }
    metal::float4 _e263 = c_1;
    return _e263;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_37 = {};
    metal::float2 _e48 = _uv_1;
    param_37 = _e48;
    metal::float4 _e49 = transition(param_37, _from, _sampler, _to, uniforms);
    _fragColor = _e49;
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
