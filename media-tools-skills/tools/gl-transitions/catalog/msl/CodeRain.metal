// CodeRain — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CodeRain.glsl
// Author: gre
// License: MIT
// Description: The outgoing image darkens into a grid of flickering code characters tinted by its colors, then glowing streams of characters fall down the columns at their own speeds, each with a bright head and a fading tail, leaving the incoming image behind
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float cellSize;
    float trail;
    float tint;
    char _pad5[12];
    metal::float4 glow;
};

metal::float4 hash42(
    thread metal::float2& p
) {
    metal::float4 p4_ = {};
    metal::float2 _e79 = p;
    p4_ = metal::fract(_e79.xyxy * metal::float4(0.1031, 0.103, 0.0973, 0.1099));
    metal::float4 _e83 = p4_;
    metal::float4 _e84 = p4_;
    metal::float4 _e89 = p4_;
    p4_ = _e89 + metal::float4(metal::dot(_e83, _e84.wzxy + metal::float4(33.33)));
    metal::float4 _e92 = p4_;
    metal::float4 _e94 = p4_;
    metal::float4 _e97 = p4_;
    return metal::fract((_e92.xxyz + _e94.yzzw) * _e97.zywx);
}

metal::float4 band(
    thread metal::float4& d
) {
    metal::float4 _e78 = d;
    return metal::float4(1.0) - metal::smoothstep(metal::float4(0.3), metal::float4(0.6), _e78);
}

float glyph(
    thread metal::float2& cell,
    thread float& t,
    thread metal::float2& local
) {
    metal::float2 b = {};
    float x = {};
    float y = {};
    float d_1 = {};
    float x04_ = {};
    float y06_ = {};
    float y03_ = {};
    float y36_ = {};
    metal::float2 seed = {};
    metal::float4 sa = {};
    metal::float4 param = {};
    metal::float4 param_1 = {};
    metal::float4 sb = {};
    metal::float4 param_2 = {};
    metal::float4 param_3 = {};
    metal::float4 sc = {};
    metal::float4 param_4 = {};
    metal::float4 param_5 = {};
    float on = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 _e102 = local;
    b = (_e102 * metal::float2(6.0, 8.0)) - metal::float2(0.5);
    float _e107 = b[0u];
    x = _e107;
    float _e109 = b[1u];
    y = _e109;
    float _e110 = y;
    d_1 = 0.667 * _e110;
    float _e112 = x;
    x04_ = metal::abs(_e112 - 2.0) - 2.0;
    float _e116 = y;
    y06_ = metal::abs(_e116 - 3.0) - 3.0;
    float _e120 = y;
    y03_ = metal::abs(_e120 - 1.5) - 1.5;
    float _e124 = y;
    y36_ = metal::abs(_e124 - 4.5) - 1.5;
    metal::float2 _e128 = cell;
    float _e129 = t;
    seed = _e128 + (metal::float2(37.0, 61.0) * _e129);
    float _e132 = y;
    float _e133 = y;
    float _e135 = y;
    float _e137 = x;
    float _e138 = d_1;
    param = metal::abs(metal::float4(_e132, _e133 - 3.0, _e135 - 6.0, _e137 - _e138));
    metal::float4 _e142 = band(param);
    float _e143 = x04_;
    float _e144 = y06_;
    param_1 = metal::float4(_e143, _e143, _e143, _e144);
    metal::float4 _e146 = band(param_1);
    sa = _e142 * _e146;
    float _e148 = x;
    float _e149 = x;
    float _e151 = x;
    param_2 = metal::abs(metal::float4(_e148, _e148, _e149 - 4.0, _e151 - 4.0));
    metal::float4 _e155 = band(param_2);
    float _e156 = y03_;
    float _e157 = y36_;
    float _e158 = y03_;
    float _e159 = y36_;
    param_3 = metal::float4(_e156, _e157, _e158, _e159);
    metal::float4 _e161 = band(param_3);
    sb = _e155 * _e161;
    float _e163 = x;
    float _e165 = x;
    float _e167 = x;
    float _e168 = d_1;
    float _e171 = y;
    param_4 = metal::abs(metal::float4(_e163 - 2.0, _e165 - 2.0, (_e167 + _e168) - 4.0, _e171 - 1.0));
    metal::float4 _e175 = band(param_4);
    float _e176 = y03_;
    float _e177 = y36_;
    float _e178 = y06_;
    float _e179 = x;
    param_5 = metal::float4(_e176, _e177, _e178, metal::abs(_e179 - 2.0) - 1.0);
    metal::float4 _e184 = band(param_5);
    sc = _e175 * _e184;
    metal::float2 _e186 = seed;
    param_6 = _e186;
    metal::float4 _e187 = hash42(param_6);
    metal::float4 _e190 = sa;
    on = metal::dot(metal::step(metal::float4(0.68), _e187), _e190);
    metal::float2 _e192 = seed;
    param_7 = _e192 + metal::float2(41.0);
    metal::float4 _e195 = hash42(param_7);
    metal::float4 _e198 = sb;
    float _e200 = on;
    on = _e200 + metal::dot(metal::step(metal::float4(0.68), _e195), _e198);
    metal::float2 _e202 = seed;
    param_8 = _e202 + metal::float2(83.0);
    metal::float4 _e205 = hash42(param_8);
    metal::float4 _e208 = sc;
    float _e210 = on;
    on = _e210 + metal::dot(metal::step(metal::float4(0.68), _e205), _e208);
    float _e212 = on;
    return metal::min(_e212, 1.0);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e79 = uv[0u];
    float _e81 = uv[1u];
    metal::float4 _e84 = _to.sample(_sampler, metal::float2(_e79, 1.0 - _e81), metal::level(0.0));
    return _e84;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e79 = uv_1[0u];
    float _e81 = uv_1[1u];
    metal::float4 _e84 = _from.sample(_sampler, metal::float2(_e79, 1.0 - _e81), metal::level(0.0));
    return _e84;
}

float hash12(
    thread metal::float2& p_1
) {
    metal::float3 p3_ = {};
    metal::float2 _e79 = p_1;
    p3_ = metal::fract(_e79.xyx * 0.1031);
    metal::float3 _e83 = p3_;
    metal::float3 _e84 = p3_;
    metal::float3 _e89 = p3_;
    p3_ = _e89 + metal::float3(metal::dot(_e83, _e84.yzx + metal::float3(33.33)));
    float _e93 = p3_[0u];
    float _e95 = p3_[1u];
    float _e98 = p3_[2u];
    return metal::fract((_e93 + _e95) * _e98);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float h = {};
    metal::float2 dims = {};
    metal::float2 fp = {};
    metal::float2 grid = {};
    metal::float2 cell_1 = {};
    metal::float2 local_1 = {};
    float rc = {};
    metal::float2 param_9 = {};
    float r1_ = {};
    metal::float2 param_10 = {};
    float r2_ = {};
    metal::float2 param_11 = {};
    float r3_ = {};
    metal::float2 param_12 = {};
    float T = {};
    float len = {};
    float u = {};
    float head = {};
    float dy = {};
    metal::float4 a = {};
    metal::float2 param_13 = {};
    metal::float4 b_1 = {};
    metal::float2 param_14 = {};
    metal::float2 cuv = {};
    metal::float4 ca = {};
    metal::float2 param_15 = {};
    float lum = {};
    metal::float3 hue = {};
    metal::float3 ink = {};
    float near = {};
    float dim = {};
    float g = {};
    float passed = {};
    float slow = {};
    float fast = {};
    float chr = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    metal::float2 param_18 = {};
    metal::float3 code = {};
    float fade = {};
    float shade = {};
    float hot = {};
    metal::float3 col = {};
    metal::float3 stream = {};
    float yy = {};
    float halo = {};
    metal::float3 rgb = {};
    float _e127 = uniforms.cellSize;
    h = metal::max(_e127, 0.005);
    float _e129 = h;
    float _e131 = h;
    dims = metal::float2(0.75 * _e129, _e131);
    float _e134 = uv_2[0u];
    float _e136 = uniforms.ratio;
    float _e139 = uv_2[1u];
    fp = metal::float2(_e134 * _e136, 1.0 - _e139);
    metal::float2 _e142 = fp;
    metal::float2 _e143 = dims;
    grid = (_e142 / _e143) + metal::float2(0.389, 0.278);
    metal::float2 _e146 = grid;
    cell_1 = metal::floor(_e146);
    metal::float2 _e148 = grid;
    metal::float2 _e149 = cell_1;
    local_1 = _e148 - _e149;
    metal::float2 _e151 = cell_1;
    param_9 = _e151 + metal::float2(97.0, 131.0);
    float _e153 = hash12(param_9);
    rc = _e153;
    float _e155 = cell_1[0u];
    param_10 = metal::float2(_e155, 11.0);
    float _e157 = hash12(param_10);
    r1_ = _e157;
    float _e159 = cell_1[0u];
    param_11 = metal::float2(_e159, 23.0);
    float _e161 = hash12(param_11);
    r2_ = _e161;
    float _e163 = cell_1[0u];
    param_12 = metal::float2(_e163, 37.0);
    float _e165 = hash12(param_12);
    r3_ = _e165;
    float _e167 = uniforms.progress;
    float _e169 = uniforms.progress;
    float _e171 = uniforms.progress;
    float _e174 = uniforms.progress;
    T = metal::mix(_e167, (_e169 * _e171) * (3.0 - (2.0 * _e174)), 0.5);
    float _e180 = uniforms.trail;
    float _e182 = r3_;
    len = metal::max(_e180, 0.01) * (0.5 + _e182);
    float _e185 = T;
    float _e187 = r1_;
    float _e190 = r2_;
    u = metal::clamp(((_e185 - 0.03) - (0.5 * _e187)) / (0.3 + (0.12 * _e190)), 0.0, 1.0);
    float _e195 = h;
    float _e197 = len;
    float _e199 = u;
    float _e200 = u;
    head = metal::mix(-0.2, (1.0 + _e195) + _e197, _e199 * (0.7 + (0.3 * _e200)));
    float _e205 = head;
    float _e207 = cell_1[1u];
    float _e209 = h;
    dy = _e205 - ((_e207 - 0.278) * _e209);
    metal::float2 _e212 = uv_2;
    param_13 = _e212;
    metal::float4 _e213 = getFromColor(param_13, _from, _sampler);
    a = _e213;
    metal::float2 _e214 = uv_2;
    param_14 = _e214;
    metal::float4 _e215 = getToColor(param_14, _sampler, _to);
    b_1 = _e215;
    float _e217 = cell_1[0u];
    float _e220 = dims[0u];
    float _e223 = uniforms.ratio;
    float _e226 = cell_1[1u];
    float _e228 = h;
    cuv = metal::clamp(metal::float2(((_e217 + 0.111) * _e220) / _e223, 1.0 - ((_e226 + 0.222) * _e228)), metal::float2(0.0), metal::float2(1.0));
    metal::float2 _e235 = cuv;
    param_15 = _e235;
    metal::float4 _e236 = getFromColor(param_15, _from, _sampler);
    ca = _e236;
    metal::float4 _e237 = ca;
    lum = metal::dot(_e237.xyz, metal::float3(0.299, 0.587, 0.114));
    metal::float4 _e240 = ca;
    float _e243 = ca[0u];
    float _e245 = ca[1u];
    float _e247 = ca[2u];
    hue = _e240.xyz / metal::float3(metal::max(metal::max(_e243, metal::max(_e245, _e247)), 0.05));
    metal::float4 _e254 = uniforms.glow;
    float _e258 = uniforms.glow[3u];
    metal::float3 _e260 = hue;
    float _e262 = uniforms.tint;
    float _e265 = lum;
    ink = metal::mix(_e254.xyz * _e258, _e260, metal::float3(_e262)) * (0.1 + (0.6 * _e265));
    float _e269 = dy;
    near = metal::smoothstep(-0.15, 0.0, _e269);
    float _e271 = T;
    float _e273 = near;
    dim = metal::max(metal::smoothstep(0.0, 0.3, _e271), _e273);
    float _e275 = T;
    float _e276 = rc;
    float _e280 = near;
    g = metal::max(metal::smoothstep(0.0, 0.2, _e275 - (0.12 * _e276)), _e280);
    float _e282 = dy;
    passed = metal::step(0.0, _e282);
    float _e284 = T;
    float _e286 = rc;
    float _e289 = metal::floor((_e284 * 12.0) + (_e286 * 7.0));
    slow = _e289 - (metal::floor(_e289 / 32.0) * 32.0);
    float _e294 = T;
    float _e296 = rc;
    float _e299 = metal::floor((_e294 * 40.0) + (_e296 * 13.0));
    fast = 32.0 + (_e299 - (metal::floor(_e299 / 32.0) * 32.0));
    float _e305 = slow;
    float _e306 = fast;
    float _e307 = passed;
    metal::float2 _e309 = cell_1;
    param_16 = _e309;
    param_17 = metal::mix(_e305, _e306, _e307);
    metal::float2 _e310 = local_1;
    param_18 = _e310;
    float _e311 = glyph(param_16, param_17, param_18);
    chr = _e311;
    metal::float4 _e312 = a;
    float _e314 = dim;
    metal::float3 _e318 = ink;
    float _e319 = chr;
    float _e321 = g;
    code = (_e312.xyz * (1.0 - (0.8 * _e314))) + ((_e318 * _e319) * _e321);
    float _e324 = dy;
    float _e325 = len;
    fade = metal::clamp(1.0 - (_e324 / _e325), 0.0, 1.0);
    float _e329 = len;
    float _e331 = len;
    float _e332 = dy;
    shade = 1.0 - metal::smoothstep(0.3 * _e329, _e331, _e332);
    float _e335 = h;
    float _e336 = h;
    float _e338 = dy;
    hot = 1.0 - metal::smoothstep(_e335, 3.0 * _e336, _e338);
    metal::float4 _e342 = uniforms.glow;
    float _e345 = hot;
    float _e351 = uniforms.glow[3u];
    col = metal::mix(_e342.xyz * 1.2, metal::float3(1.0, 1.0, 1.0), metal::float3(0.8 * _e345)) * _e351;
    metal::float4 _e353 = b_1;
    float _e355 = shade;
    metal::float3 _e359 = col;
    float _e360 = chr;
    float _e362 = fade;
    float _e363 = fade;
    float _e366 = hot;
    float _e367 = fade;
    stream = (_e353.xyz * (1.0 - (0.8 * _e355))) + ((_e359 * _e360) * ((_e362 * (2.0 - _e363)) + (_e366 * _e367)));
    float _e372 = head;
    float _e374 = fp[1u];
    float _e376 = h;
    yy = (_e372 - _e374) / (1.5 * _e376);
    float _e379 = u;
    float _e381 = u;
    float _e384 = yy;
    float _e386 = yy;
    float _e391 = local_1[0u];
    halo = (((1.6 * _e379) * (1.0 - _e381)) * metal::exp(-(_e384) * _e386)) * (1.0 - metal::smoothstep(0.25, 0.5, metal::abs(_e391 - 0.5)));
    metal::float3 _e397 = code;
    metal::float3 _e398 = stream;
    float _e399 = passed;
    metal::float4 _e403 = uniforms.glow;
    float _e407 = uniforms.glow[3u];
    float _e409 = halo;
    rgb = metal::mix(_e397, _e398, metal::float3(_e399)) + ((_e403.xyz * _e407) * _e409);
    metal::float3 _e412 = rgb;
    metal::float3 _e415 = metal::clamp(_e412, metal::float3(0.0), metal::float3(1.0));
    float _e417 = a[3u];
    float _e419 = b_1[3u];
    float _e421 = a[3u];
    float _e422 = shade;
    float _e424 = passed;
    return metal::float4(_e415.x, _e415.y, _e415.z, metal::mix(_e417, metal::mix(_e419, _e421, _e422), _e424));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_19 = {};
    metal::float2 _e78 = _uv_1;
    param_19 = _e78;
    metal::float4 _e79 = transition(param_19, _from, _sampler, _to, uniforms);
    _fragColor = _e79;
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
