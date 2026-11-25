// SketchDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SketchDissolve.glsl
// Author: gre
// License: MIT
// Description: The outgoing image fades back to blank paper while the incoming one is drawn on it in pencil, outlines first and then hatching in the shadows, before its shading and colors fill in until the picture is complete
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float lineWidth;
    float edges;
    float hatching;
    char _pad5[12];
    metal::float4 paper;
    metal::float4 ink;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e71 = uv[0u];
    float _e73 = uv[1u];
    metal::float4 _e76 = _from.sample(_sampler, metal::float2(_e71, 1.0 - _e73), metal::level(0.0));
    return _e76;
}

float sdHash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e71 = p;
    p3_ = metal::fract(_e71.xyx * 0.1031);
    metal::float3 _e75 = p3_;
    metal::float3 _e76 = p3_;
    metal::float3 _e81 = p3_;
    p3_ = _e81 + metal::float3(metal::dot(_e75, _e76.yzx + metal::float3(33.33)));
    float _e85 = p3_[0u];
    float _e87 = p3_[1u];
    float _e90 = p3_[2u];
    return metal::fract((_e85 + _e87) * _e90);
}

float sdNoise(
    thread metal::float2& p_1
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e76 = p_1;
    i = metal::floor(_e76);
    metal::float2 _e78 = p_1;
    f = metal::fract(_e78);
    metal::float2 _e80 = f;
    metal::float2 _e81 = f;
    metal::float2 _e83 = f;
    f = (_e80 * _e81) * (metal::float2(3.0) - (_e83 * 2.0));
    metal::float2 _e88 = i;
    param = _e88;
    float _e89 = sdHash(param);
    metal::float2 _e90 = i;
    param_1 = _e90 + metal::float2(1.0, 0.0);
    float _e92 = sdHash(param_1);
    float _e94 = f[0u];
    metal::float2 _e96 = i;
    param_2 = _e96 + metal::float2(0.0, 1.0);
    float _e98 = sdHash(param_2);
    metal::float2 _e99 = i;
    param_3 = _e99 + metal::float2(1.0, 1.0);
    float _e101 = sdHash(param_3);
    float _e103 = f[0u];
    float _e106 = f[1u];
    return metal::mix(metal::mix(_e89, _e92, _e94), metal::mix(_e98, _e101, _e103), _e106);
}

float sdHatch(
    thread metal::float2& q,
    thread metal::float2& d,
    thread float& dark
) {
    float s = {};
    metal::float2 param_4 = {};
    float row = {};
    float along = {};
    metal::float2 param_5 = {};
    float cell = {};
    float k = {};
    metal::float2 param_6 = {};
    float gap = {};
    float w = {};
    metal::float2 _e82 = q;
    metal::float2 _e83 = d;
    metal::float2 _e86 = q;
    metal::float2 _e88 = d;
    param_4 = (_e86 * 9.0) + (_e88 * 13.0);
    float _e91 = sdNoise(param_4);
    s = (metal::dot(_e82, _e83) * 60.0) + (0.5 * _e91);
    float _e94 = s;
    row = metal::floor(_e94);
    metal::float2 _e96 = q;
    float _e98 = d[1u];
    float _e101 = d[0u];
    float _e105 = row;
    float _e107 = d[1u];
    param_5 = metal::float2(_e105, _e107 * 7.0);
    float _e110 = sdHash(param_5);
    along = (metal::dot(_e96, metal::float2(-(_e98), _e101)) * 8.0) + (_e110 * 5.0);
    float _e113 = along;
    cell = metal::floor(_e113);
    float _e115 = row;
    float _e116 = cell;
    metal::float2 _e118 = d;
    param_6 = metal::float2(_e115, _e116) + (_e118 * 31.0);
    float _e121 = sdHash(param_6);
    k = _e121;
    float _e122 = along;
    float _e125 = k;
    float _e128 = along;
    gap = metal::smoothstep(0.0, 0.12, metal::fract(_e122)) * (1.0 - metal::smoothstep(0.75 - (0.2 * _e125), 1.0, metal::fract(_e128)));
    float _e133 = dark;
    float _e136 = k;
    w = (0.5 * metal::clamp(_e133, 0.0, 1.0)) * (0.7 + (0.3 * _e136));
    float _e140 = w;
    float _e142 = w;
    float _e143 = s;
    float _e149 = gap;
    float _e151 = k;
    return ((1.0 - metal::smoothstep(_e140 - 0.24, _e142, metal::abs(metal::fract(_e143) - 0.5))) * _e149) * (0.6 + (0.4 * _e151));
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e71 = uv_1[0u];
    float _e73 = uv_1[1u];
    metal::float4 _e76 = _to.sample(_sampler, metal::float2(_e71, 1.0 - _e73), metal::level(0.0));
    return _e76;
}

metal::float2 sdTone(
    thread metal::float2& uv_2,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float4 c = {};
    metal::float2 param_7 = {};
    metal::float2 _e72 = uv_2;
    param_7 = _e72;
    metal::float4 _e73 = getToColor(param_7, _sampler, _to);
    c = _e73;
    metal::float4 _e74 = c;
    float _e78 = c[3u];
    return metal::float2(metal::dot(_e74.xyz, metal::float3(0.299, 0.587, 0.114)), _e78);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 q_1 = {};
    metal::float2 wob = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 su = {};
    metal::float2 dx = {};
    metal::float2 dy = {};
    metal::float2 tl = {};
    metal::float2 param_10 = {};
    metal::float2 tm = {};
    metal::float2 param_11 = {};
    metal::float2 tr = {};
    metal::float2 param_12 = {};
    metal::float2 ml = {};
    metal::float2 param_13 = {};
    metal::float2 mr = {};
    metal::float2 param_14 = {};
    metal::float2 bl = {};
    metal::float2 param_15 = {};
    metal::float2 bm = {};
    metal::float2 param_16 = {};
    metal::float2 br = {};
    metal::float2 param_17 = {};
    metal::float2 gx = {};
    metal::float2 gy = {};
    float g = {};
    float outline = {};
    metal::float4 toC = {};
    metal::float2 param_18 = {};
    float l = {};
    float grain = {};
    metal::float2 param_19 = {};
    float order = {};
    metal::float2 param_20 = {};
    float fine = {};
    metal::float2 param_21 = {};
    float drawOutline = {};
    float drawHatch = {};
    float fill = {};
    float dark_1 = {};
    float h1_ = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    float param_24 = {};
    float h2_ = {};
    metal::float2 param_25 = {};
    metal::float2 param_26 = {};
    float param_27 = {};
    float hatch = {};
    float pencil = {};
    metal::float4 base = {};
    metal::float2 param_28 = {};
    float sat = {};
    metal::float4 tone = {};
    metal::float4 col = {};
    float _e126 = uv_3[0u];
    float _e128 = uniforms.ratio;
    float _e131 = uv_3[1u];
    q_1 = metal::float2(_e126 * _e128, _e131);
    metal::float2 _e133 = q_1;
    param_8 = _e133 * 6.0;
    float _e135 = sdNoise(param_8);
    metal::float2 _e136 = q_1;
    param_9 = (_e136 * 6.0) + metal::float2(17.0);
    float _e140 = sdNoise(param_9);
    wob = (metal::float2(_e135, _e140) - metal::float2(0.5)) * 0.004;
    metal::float2 _e145 = uv_3;
    metal::float2 _e146 = wob;
    float _e148 = uniforms.progress;
    su = _e145 + (_e146 * (1.0 - _e148));
    float _e153 = uniforms.lineWidth;
    float _e156 = uniforms.ratio;
    dx = metal::float2((0.001 * _e153) / _e156, 0.0);
    float _e160 = uniforms.lineWidth;
    dy = metal::float2(0.0, 0.001 * _e160);
    metal::float2 _e163 = su;
    metal::float2 _e164 = dx;
    metal::float2 _e166 = dy;
    param_10 = (_e163 - _e164) + _e166;
    metal::float2 _e168 = sdTone(param_10, _sampler, _to);
    tl = _e168;
    metal::float2 _e169 = su;
    metal::float2 _e170 = dy;
    param_11 = _e169 + _e170;
    metal::float2 _e172 = sdTone(param_11, _sampler, _to);
    tm = _e172;
    metal::float2 _e173 = su;
    metal::float2 _e174 = dx;
    metal::float2 _e176 = dy;
    param_12 = (_e173 + _e174) + _e176;
    metal::float2 _e178 = sdTone(param_12, _sampler, _to);
    tr = _e178;
    metal::float2 _e179 = su;
    metal::float2 _e180 = dx;
    param_13 = _e179 - _e180;
    metal::float2 _e182 = sdTone(param_13, _sampler, _to);
    ml = _e182;
    metal::float2 _e183 = su;
    metal::float2 _e184 = dx;
    param_14 = _e183 + _e184;
    metal::float2 _e186 = sdTone(param_14, _sampler, _to);
    mr = _e186;
    metal::float2 _e187 = su;
    metal::float2 _e188 = dx;
    metal::float2 _e190 = dy;
    param_15 = (_e187 - _e188) - _e190;
    metal::float2 _e192 = sdTone(param_15, _sampler, _to);
    bl = _e192;
    metal::float2 _e193 = su;
    metal::float2 _e194 = dy;
    param_16 = _e193 - _e194;
    metal::float2 _e196 = sdTone(param_16, _sampler, _to);
    bm = _e196;
    metal::float2 _e197 = su;
    metal::float2 _e198 = dx;
    metal::float2 _e200 = dy;
    param_17 = (_e197 + _e198) - _e200;
    metal::float2 _e202 = sdTone(param_17, _sampler, _to);
    br = _e202;
    metal::float2 _e203 = tr;
    metal::float2 _e204 = mr;
    metal::float2 _e207 = br;
    metal::float2 _e209 = tl;
    metal::float2 _e210 = ml;
    metal::float2 _e213 = bl;
    gx = ((_e203 + (_e204 * 2.0)) + _e207) - ((_e209 + (_e210 * 2.0)) + _e213);
    metal::float2 _e216 = tl;
    metal::float2 _e217 = tm;
    metal::float2 _e220 = tr;
    metal::float2 _e222 = bl;
    metal::float2 _e223 = bm;
    metal::float2 _e226 = br;
    gy = ((_e216 + (_e217 * 2.0)) + _e220) - ((_e222 + (_e223 * 2.0)) + _e226);
    float _e230 = gx[0u];
    float _e232 = gy[0u];
    float _e236 = gx[1u];
    float _e238 = gy[1u];
    float _e243 = uniforms.edges;
    g = metal::max(metal::length(metal::float2(_e230, _e232)), metal::length(metal::float2(_e236, _e238))) * metal::max(_e243, 0.0);
    float _e246 = g;
    outline = metal::smoothstep(0.12, 0.5, _e246);
    metal::float2 _e248 = uv_3;
    param_18 = _e248;
    metal::float4 _e249 = getToColor(param_18, _sampler, _to);
    toC = _e249;
    float _e251 = tm[0u];
    float _e253 = bm[0u];
    float _e256 = ml[0u];
    float _e259 = mr[0u];
    l = metal::clamp((((_e251 + _e253) + _e256) + _e259) * 0.25, 0.0, 1.0);
    metal::float2 _e263 = q_1;
    param_19 = _e263 * metal::float2(180.0, 60.0);
    float _e265 = sdNoise(param_19);
    grain = 0.65 + (0.35 * _e265);
    metal::float2 _e268 = q_1;
    param_20 = (_e268 * 3.0) + metal::float2(4.0);
    float _e272 = sdNoise(param_20);
    order = _e272;
    metal::float2 _e273 = q_1;
    param_21 = _e273 * 24.0;
    float _e275 = sdNoise(param_21);
    fine = _e275;
    float _e277 = uniforms.progress;
    float _e278 = order;
    float _e280 = fine;
    drawOutline = metal::smoothstep(0.0, 0.1, _e277 - ((0.22 * _e278) + (0.05 * _e280)));
    float _e286 = uniforms.progress;
    float _e287 = order;
    float _e290 = fine;
    drawHatch = metal::smoothstep(0.0, 0.12, _e286 - ((0.2 + (0.2 * _e287)) + (0.05 * _e290)));
    float _e296 = uniforms.progress;
    float _e297 = l;
    float _e300 = order;
    fill = metal::smoothstep(0.0, 0.22, _e296 - ((0.4 + (0.25 * _e297)) + (0.1 * _e300)));
    float _e305 = l;
    dark_1 = 1.0 - _e305;
    float _e307 = dark_1;
    metal::float2 _e309 = q_1;
    param_22 = _e309;
    param_23 = metal::float2(0.7071, 0.7071);
    param_24 = metal::smoothstep(0.35, 0.9, _e307);
    float _e310 = sdHatch(param_22, param_23, param_24);
    h1_ = _e310;
    float _e311 = dark_1;
    metal::float2 _e313 = q_1;
    param_25 = _e313;
    param_26 = metal::float2(0.7071, -0.7071);
    param_27 = metal::smoothstep(0.65, 1.0, _e311);
    float _e314 = sdHatch(param_25, param_26, param_27);
    h2_ = _e314;
    float _e316 = uniforms.hatching;
    float _e318 = h1_;
    float _e319 = h2_;
    float _e324 = toC[3u];
    hatch = ((_e316 * 0.8) * metal::max(_e318, 0.8 * _e319)) * _e324;
    float _e326 = drawHatch;
    float _e327 = fill;
    float _e331 = hatch;
    hatch = _e331 * (_e326 * (1.0 - (0.6 * _e327)));
    float _e333 = outline;
    float _e334 = drawOutline;
    float _e336 = hatch;
    float _e338 = grain;
    pencil = metal::max(_e333 * _e334, _e336) * _e338;
    float _e341 = uniforms.progress;
    float _e344 = pencil;
    pencil = _e344 * (1.0 - metal::smoothstep(0.7, 1.0, _e341));
    metal::float2 _e346 = uv_3;
    param_28 = _e346;
    metal::float4 _e347 = getFromColor(param_28, _from, _sampler);
    metal::float4 _e349 = uniforms.paper;
    float _e351 = uniforms.progress;
    base = metal::mix(_e347, _e349, metal::float4(metal::smoothstep(0.02, 0.38, _e351)));
    float _e356 = uniforms.progress;
    sat = metal::smoothstep(0.55, 1.0, _e356);
    metal::float4 _e359 = uniforms.paper;
    float _e361 = l;
    metal::float3 _e363 = _e359.xyz * metal::mix(0.3, 1.0, _e361);
    float _e366 = uniforms.paper[3u];
    float _e368 = toC[3u];
    tone = metal::float4(_e363.x, _e363.y, _e363.z, _e366 * _e368);
    metal::float4 _e374 = tone;
    metal::float4 _e375 = toC;
    float _e376 = sat;
    col = metal::mix(_e374, _e375, metal::float4(_e376));
    metal::float4 _e379 = base;
    metal::float4 _e380 = col;
    float _e381 = fill;
    base = metal::mix(_e379, _e380, metal::float4(_e381));
    metal::float4 _e384 = base;
    metal::float4 _e386 = uniforms.ink;
    float _e387 = pencil;
    return metal::mix(_e384, _e386, metal::float4(_e387));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_29 = {};
    metal::float2 _e70 = _uv_1;
    param_29 = _e70;
    metal::float4 _e71 = transition(param_29, _from, _sampler, _to, uniforms);
    _fragColor = _e71;
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
