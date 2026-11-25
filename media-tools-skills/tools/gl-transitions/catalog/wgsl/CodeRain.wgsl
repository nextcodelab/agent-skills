// CodeRain — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CodeRain.glsl
// Author: gre
// License: MIT
// Description: The outgoing image darkens into a grid of flickering code characters tinted by its colors, then glowing streams of characters fall down the columns at their own speeds, each with a bright head and a fading tail, leaving the incoming image behind
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cellSize: f32,
    trail: f32,
    tint: f32,
    glow: vec4<f32>,
}

@group(0) @binding(2) 
var _from: texture_2d<f32>;
@group(0) @binding(1) 
var _sampler: sampler;
@group(0) @binding(3) 
var _to: texture_2d<f32>;
@group(0) @binding(0) 
var<uniform> uniforms: Uniforms;
var<private> _fragColor: vec4<f32>;
var<private> _uv_1: vec2<f32>;

fn hash42(p: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p4_: vec4<f32>;

    let _e79 = (*p);
    p4_ = fract((_e79.xyxy * vec4<f32>(0.1031f, 0.103f, 0.0973f, 0.1099f)));
    let _e83 = p4_;
    let _e84 = p4_;
    let _e89 = p4_;
    p4_ = (_e89 + vec4(dot(_e83, (_e84.wzxy + vec4(33.33f)))));
    let _e92 = p4_;
    let _e94 = p4_;
    let _e97 = p4_;
    return fract(((_e92.xxyz + _e94.yzzw) * _e97.zywx));
}

fn band(d: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e78 = (*d);
    return (vec4(1f) - smoothstep(vec4(0.3f), vec4(0.6f), _e78));
}

fn glyph(cell: ptr<function, vec2<f32>>, t: ptr<function, f32>, local: ptr<function, vec2<f32>>) -> f32 {
    var b: vec2<f32>;
    var x: f32;
    var y: f32;
    var d_1: f32;
    var x04_: f32;
    var y06_: f32;
    var y03_: f32;
    var y36_: f32;
    var seed: vec2<f32>;
    var sa: vec4<f32>;
    var param: vec4<f32>;
    var param_1: vec4<f32>;
    var sb: vec4<f32>;
    var param_2: vec4<f32>;
    var param_3: vec4<f32>;
    var sc: vec4<f32>;
    var param_4: vec4<f32>;
    var param_5: vec4<f32>;
    var on: f32;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;

    let _e102 = (*local);
    b = ((_e102 * vec2<f32>(6f, 8f)) - vec2(0.5f));
    let _e107 = b[0u];
    x = _e107;
    let _e109 = b[1u];
    y = _e109;
    let _e110 = y;
    d_1 = (0.667f * _e110);
    let _e112 = x;
    x04_ = (abs((_e112 - 2f)) - 2f);
    let _e116 = y;
    y06_ = (abs((_e116 - 3f)) - 3f);
    let _e120 = y;
    y03_ = (abs((_e120 - 1.5f)) - 1.5f);
    let _e124 = y;
    y36_ = (abs((_e124 - 4.5f)) - 1.5f);
    let _e128 = (*cell);
    let _e129 = (*t);
    seed = (_e128 + (vec2<f32>(37f, 61f) * _e129));
    let _e132 = y;
    let _e133 = y;
    let _e135 = y;
    let _e137 = x;
    let _e138 = d_1;
    param = abs(vec4<f32>(_e132, (_e133 - 3f), (_e135 - 6f), (_e137 - _e138)));
    let _e142 = band((&param));
    let _e143 = x04_;
    let _e144 = y06_;
    param_1 = vec4<f32>(_e143, _e143, _e143, _e144);
    let _e146 = band((&param_1));
    sa = (_e142 * _e146);
    let _e148 = x;
    let _e149 = x;
    let _e151 = x;
    param_2 = abs(vec4<f32>(_e148, _e148, (_e149 - 4f), (_e151 - 4f)));
    let _e155 = band((&param_2));
    let _e156 = y03_;
    let _e157 = y36_;
    let _e158 = y03_;
    let _e159 = y36_;
    param_3 = vec4<f32>(_e156, _e157, _e158, _e159);
    let _e161 = band((&param_3));
    sb = (_e155 * _e161);
    let _e163 = x;
    let _e165 = x;
    let _e167 = x;
    let _e168 = d_1;
    let _e171 = y;
    param_4 = abs(vec4<f32>((_e163 - 2f), (_e165 - 2f), ((_e167 + _e168) - 4f), (_e171 - 1f)));
    let _e175 = band((&param_4));
    let _e176 = y03_;
    let _e177 = y36_;
    let _e178 = y06_;
    let _e179 = x;
    param_5 = vec4<f32>(_e176, _e177, _e178, (abs((_e179 - 2f)) - 1f));
    let _e184 = band((&param_5));
    sc = (_e175 * _e184);
    let _e186 = seed;
    param_6 = _e186;
    let _e187 = hash42((&param_6));
    let _e190 = sa;
    on = dot(step(vec4(0.68f), _e187), _e190);
    let _e192 = seed;
    param_7 = (_e192 + vec2(41f));
    let _e195 = hash42((&param_7));
    let _e198 = sb;
    let _e200 = on;
    on = (_e200 + dot(step(vec4(0.68f), _e195), _e198));
    let _e202 = seed;
    param_8 = (_e202 + vec2(83f));
    let _e205 = hash42((&param_8));
    let _e208 = sc;
    let _e210 = on;
    on = (_e210 + dot(step(vec4(0.68f), _e205), _e208));
    let _e212 = on;
    return min(_e212, 1f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e79 = (*uv)[0u];
    let _e81 = (*uv)[1u];
    let _e84 = textureSampleLevel(_to, _sampler, vec2<f32>(_e79, (1f - _e81)), 0f);
    return _e84;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e79 = (*uv_1)[0u];
    let _e81 = (*uv_1)[1u];
    let _e84 = textureSampleLevel(_from, _sampler, vec2<f32>(_e79, (1f - _e81)), 0f);
    return _e84;
}

fn hash12(p_1: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e79 = (*p_1);
    p3_ = fract((_e79.xyx * 0.1031f));
    let _e83 = p3_;
    let _e84 = p3_;
    let _e89 = p3_;
    p3_ = (_e89 + vec3(dot(_e83, (_e84.yzx + vec3(33.33f)))));
    let _e93 = p3_[0u];
    let _e95 = p3_[1u];
    let _e98 = p3_[2u];
    return fract(((_e93 + _e95) * _e98));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var h: f32;
    var dims: vec2<f32>;
    var fp: vec2<f32>;
    var grid: vec2<f32>;
    var cell_1: vec2<f32>;
    var local_1: vec2<f32>;
    var rc: f32;
    var param_9: vec2<f32>;
    var r1_: f32;
    var param_10: vec2<f32>;
    var r2_: f32;
    var param_11: vec2<f32>;
    var r3_: f32;
    var param_12: vec2<f32>;
    var T: f32;
    var len: f32;
    var u: f32;
    var head: f32;
    var dy: f32;
    var a: vec4<f32>;
    var param_13: vec2<f32>;
    var b_1: vec4<f32>;
    var param_14: vec2<f32>;
    var cuv: vec2<f32>;
    var ca: vec4<f32>;
    var param_15: vec2<f32>;
    var lum: f32;
    var hue: vec3<f32>;
    var ink: vec3<f32>;
    var near: f32;
    var dim: f32;
    var g: f32;
    var passed: f32;
    var slow: f32;
    var fast: f32;
    var chr: f32;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: vec2<f32>;
    var code: vec3<f32>;
    var fade: f32;
    var shade: f32;
    var hot: f32;
    var col: vec3<f32>;
    var stream: vec3<f32>;
    var yy: f32;
    var halo: f32;
    var rgb: vec3<f32>;

    let _e127 = uniforms.cellSize;
    h = max(_e127, 0.005f);
    let _e129 = h;
    let _e131 = h;
    dims = vec2<f32>((0.75f * _e129), _e131);
    let _e134 = (*uv_2)[0u];
    let _e136 = uniforms.ratio;
    let _e139 = (*uv_2)[1u];
    fp = vec2<f32>((_e134 * _e136), (1f - _e139));
    let _e142 = fp;
    let _e143 = dims;
    grid = ((_e142 / _e143) + vec2<f32>(0.389f, 0.278f));
    let _e146 = grid;
    cell_1 = floor(_e146);
    let _e148 = grid;
    let _e149 = cell_1;
    local_1 = (_e148 - _e149);
    let _e151 = cell_1;
    param_9 = (_e151 + vec2<f32>(97f, 131f));
    let _e153 = hash12((&param_9));
    rc = _e153;
    let _e155 = cell_1[0u];
    param_10 = vec2<f32>(_e155, 11f);
    let _e157 = hash12((&param_10));
    r1_ = _e157;
    let _e159 = cell_1[0u];
    param_11 = vec2<f32>(_e159, 23f);
    let _e161 = hash12((&param_11));
    r2_ = _e161;
    let _e163 = cell_1[0u];
    param_12 = vec2<f32>(_e163, 37f);
    let _e165 = hash12((&param_12));
    r3_ = _e165;
    let _e167 = uniforms.progress;
    let _e169 = uniforms.progress;
    let _e171 = uniforms.progress;
    let _e174 = uniforms.progress;
    T = mix(_e167, ((_e169 * _e171) * (3f - (2f * _e174))), 0.5f);
    let _e180 = uniforms.trail;
    let _e182 = r3_;
    len = (max(_e180, 0.01f) * (0.5f + _e182));
    let _e185 = T;
    let _e187 = r1_;
    let _e190 = r2_;
    u = clamp((((_e185 - 0.03f) - (0.5f * _e187)) / (0.3f + (0.12f * _e190))), 0f, 1f);
    let _e195 = h;
    let _e197 = len;
    let _e199 = u;
    let _e200 = u;
    head = mix(-0.2f, ((1f + _e195) + _e197), (_e199 * (0.7f + (0.3f * _e200))));
    let _e205 = head;
    let _e207 = cell_1[1u];
    let _e209 = h;
    dy = (_e205 - ((_e207 - 0.278f) * _e209));
    let _e212 = (*uv_2);
    param_13 = _e212;
    let _e213 = getFromColor((&param_13));
    a = _e213;
    let _e214 = (*uv_2);
    param_14 = _e214;
    let _e215 = getToColor((&param_14));
    b_1 = _e215;
    let _e217 = cell_1[0u];
    let _e220 = dims[0u];
    let _e223 = uniforms.ratio;
    let _e226 = cell_1[1u];
    let _e228 = h;
    cuv = clamp(vec2<f32>((((_e217 + 0.111f) * _e220) / _e223), (1f - ((_e226 + 0.222f) * _e228))), vec2(0f), vec2(1f));
    let _e235 = cuv;
    param_15 = _e235;
    let _e236 = getFromColor((&param_15));
    ca = _e236;
    let _e237 = ca;
    lum = dot(_e237.xyz, vec3<f32>(0.299f, 0.587f, 0.114f));
    let _e240 = ca;
    let _e243 = ca[0u];
    let _e245 = ca[1u];
    let _e247 = ca[2u];
    hue = (_e240.xyz / vec3(max(max(_e243, max(_e245, _e247)), 0.05f)));
    let _e254 = uniforms.glow;
    let _e258 = uniforms.glow[3u];
    let _e260 = hue;
    let _e262 = uniforms.tint;
    let _e265 = lum;
    ink = (mix((_e254.xyz * _e258), _e260, vec3(_e262)) * (0.1f + (0.6f * _e265)));
    let _e269 = dy;
    near = smoothstep(-0.15f, 0f, _e269);
    let _e271 = T;
    let _e273 = near;
    dim = max(smoothstep(0f, 0.3f, _e271), _e273);
    let _e275 = T;
    let _e276 = rc;
    let _e280 = near;
    g = max(smoothstep(0f, 0.2f, (_e275 - (0.12f * _e276))), _e280);
    let _e282 = dy;
    passed = step(0f, _e282);
    let _e284 = T;
    let _e286 = rc;
    let _e289 = floor(((_e284 * 12f) + (_e286 * 7f)));
    slow = (_e289 - (floor((_e289 / 32f)) * 32f));
    let _e294 = T;
    let _e296 = rc;
    let _e299 = floor(((_e294 * 40f) + (_e296 * 13f)));
    fast = (32f + (_e299 - (floor((_e299 / 32f)) * 32f)));
    let _e305 = slow;
    let _e306 = fast;
    let _e307 = passed;
    let _e309 = cell_1;
    param_16 = _e309;
    param_17 = mix(_e305, _e306, _e307);
    let _e310 = local_1;
    param_18 = _e310;
    let _e311 = glyph((&param_16), (&param_17), (&param_18));
    chr = _e311;
    let _e312 = a;
    let _e314 = dim;
    let _e318 = ink;
    let _e319 = chr;
    let _e321 = g;
    code = ((_e312.xyz * (1f - (0.8f * _e314))) + ((_e318 * _e319) * _e321));
    let _e324 = dy;
    let _e325 = len;
    fade = clamp((1f - (_e324 / _e325)), 0f, 1f);
    let _e329 = len;
    let _e331 = len;
    let _e332 = dy;
    shade = (1f - smoothstep((0.3f * _e329), _e331, _e332));
    let _e335 = h;
    let _e336 = h;
    let _e338 = dy;
    hot = (1f - smoothstep(_e335, (3f * _e336), _e338));
    let _e342 = uniforms.glow;
    let _e345 = hot;
    let _e351 = uniforms.glow[3u];
    col = (mix((_e342.xyz * 1.2f), vec3<f32>(1f, 1f, 1f), vec3((0.8f * _e345))) * _e351);
    let _e353 = b_1;
    let _e355 = shade;
    let _e359 = col;
    let _e360 = chr;
    let _e362 = fade;
    let _e363 = fade;
    let _e366 = hot;
    let _e367 = fade;
    stream = ((_e353.xyz * (1f - (0.8f * _e355))) + ((_e359 * _e360) * ((_e362 * (2f - _e363)) + (_e366 * _e367))));
    let _e372 = head;
    let _e374 = fp[1u];
    let _e376 = h;
    yy = ((_e372 - _e374) / (1.5f * _e376));
    let _e379 = u;
    let _e381 = u;
    let _e384 = yy;
    let _e386 = yy;
    let _e391 = local_1[0u];
    halo = ((((1.6f * _e379) * (1f - _e381)) * exp((-(_e384) * _e386))) * (1f - smoothstep(0.25f, 0.5f, abs((_e391 - 0.5f)))));
    let _e397 = code;
    let _e398 = stream;
    let _e399 = passed;
    let _e403 = uniforms.glow;
    let _e407 = uniforms.glow[3u];
    let _e409 = halo;
    rgb = (mix(_e397, _e398, vec3(_e399)) + ((_e403.xyz * _e407) * _e409));
    let _e412 = rgb;
    let _e415 = clamp(_e412, vec3(0f), vec3(1f));
    let _e417 = a[3u];
    let _e419 = b_1[3u];
    let _e421 = a[3u];
    let _e422 = shade;
    let _e424 = passed;
    return vec4<f32>(_e415.x, _e415.y, _e415.z, mix(_e417, mix(_e419, _e421, _e422), _e424));
}

fn main_1() {
    var param_19: vec2<f32>;

    let _e78 = _uv_1;
    param_19 = _e78;
    let _e79 = transition((&param_19));
    _fragColor = _e79;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
