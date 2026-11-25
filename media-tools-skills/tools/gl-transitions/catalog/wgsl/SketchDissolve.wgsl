// SketchDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SketchDissolve.glsl
// Author: gre
// License: MIT
// Description: The outgoing image fades back to blank paper while the incoming one is drawn on it in pencil, outlines first and then hatching in the shadows, before its shading and colors fill in until the picture is complete
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    lineWidth: f32,
    edges: f32,
    hatching: f32,
    paper: vec4<f32>,
    ink: vec4<f32>,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e71 = (*uv)[0u];
    let _e73 = (*uv)[1u];
    let _e76 = textureSampleLevel(_from, _sampler, vec2<f32>(_e71, (1f - _e73)), 0f);
    return _e76;
}

fn sdHash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e71 = (*p);
    p3_ = fract((_e71.xyx * 0.1031f));
    let _e75 = p3_;
    let _e76 = p3_;
    let _e81 = p3_;
    p3_ = (_e81 + vec3(dot(_e75, (_e76.yzx + vec3(33.33f)))));
    let _e85 = p3_[0u];
    let _e87 = p3_[1u];
    let _e90 = p3_[2u];
    return fract(((_e85 + _e87) * _e90));
}

fn sdNoise(p_1: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e76 = (*p_1);
    i = floor(_e76);
    let _e78 = (*p_1);
    f = fract(_e78);
    let _e80 = f;
    let _e81 = f;
    let _e83 = f;
    f = ((_e80 * _e81) * (vec2(3f) - (_e83 * 2f)));
    let _e88 = i;
    param = _e88;
    let _e89 = sdHash((&param));
    let _e90 = i;
    param_1 = (_e90 + vec2<f32>(1f, 0f));
    let _e92 = sdHash((&param_1));
    let _e94 = f[0u];
    let _e96 = i;
    param_2 = (_e96 + vec2<f32>(0f, 1f));
    let _e98 = sdHash((&param_2));
    let _e99 = i;
    param_3 = (_e99 + vec2<f32>(1f, 1f));
    let _e101 = sdHash((&param_3));
    let _e103 = f[0u];
    let _e106 = f[1u];
    return mix(mix(_e89, _e92, _e94), mix(_e98, _e101, _e103), _e106);
}

fn sdHatch(q: ptr<function, vec2<f32>>, d: ptr<function, vec2<f32>>, dark: ptr<function, f32>) -> f32 {
    var s: f32;
    var param_4: vec2<f32>;
    var row: f32;
    var along: f32;
    var param_5: vec2<f32>;
    var cell: f32;
    var k: f32;
    var param_6: vec2<f32>;
    var gap: f32;
    var w: f32;

    let _e82 = (*q);
    let _e83 = (*d);
    let _e86 = (*q);
    let _e88 = (*d);
    param_4 = ((_e86 * 9f) + (_e88 * 13f));
    let _e91 = sdNoise((&param_4));
    s = ((dot(_e82, _e83) * 60f) + (0.5f * _e91));
    let _e94 = s;
    row = floor(_e94);
    let _e96 = (*q);
    let _e98 = (*d)[1u];
    let _e101 = (*d)[0u];
    let _e105 = row;
    let _e107 = (*d)[1u];
    param_5 = vec2<f32>(_e105, (_e107 * 7f));
    let _e110 = sdHash((&param_5));
    along = ((dot(_e96, vec2<f32>(-(_e98), _e101)) * 8f) + (_e110 * 5f));
    let _e113 = along;
    cell = floor(_e113);
    let _e115 = row;
    let _e116 = cell;
    let _e118 = (*d);
    param_6 = (vec2<f32>(_e115, _e116) + (_e118 * 31f));
    let _e121 = sdHash((&param_6));
    k = _e121;
    let _e122 = along;
    let _e125 = k;
    let _e128 = along;
    gap = (smoothstep(0f, 0.12f, fract(_e122)) * (1f - smoothstep((0.75f - (0.2f * _e125)), 1f, fract(_e128))));
    let _e133 = (*dark);
    let _e136 = k;
    w = ((0.5f * clamp(_e133, 0f, 1f)) * (0.7f + (0.3f * _e136)));
    let _e140 = w;
    let _e142 = w;
    let _e143 = s;
    let _e149 = gap;
    let _e151 = k;
    return (((1f - smoothstep((_e140 - 0.24f), _e142, abs((fract(_e143) - 0.5f)))) * _e149) * (0.6f + (0.4f * _e151)));
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e71 = (*uv_1)[0u];
    let _e73 = (*uv_1)[1u];
    let _e76 = textureSampleLevel(_to, _sampler, vec2<f32>(_e71, (1f - _e73)), 0f);
    return _e76;
}

fn sdTone(uv_2: ptr<function, vec2<f32>>) -> vec2<f32> {
    var c: vec4<f32>;
    var param_7: vec2<f32>;

    let _e72 = (*uv_2);
    param_7 = _e72;
    let _e73 = getToColor((&param_7));
    c = _e73;
    let _e74 = c;
    let _e78 = c[3u];
    return vec2<f32>(dot(_e74.xyz, vec3<f32>(0.299f, 0.587f, 0.114f)), _e78);
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var q_1: vec2<f32>;
    var wob: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var su: vec2<f32>;
    var dx: vec2<f32>;
    var dy: vec2<f32>;
    var tl: vec2<f32>;
    var param_10: vec2<f32>;
    var tm: vec2<f32>;
    var param_11: vec2<f32>;
    var tr: vec2<f32>;
    var param_12: vec2<f32>;
    var ml: vec2<f32>;
    var param_13: vec2<f32>;
    var mr: vec2<f32>;
    var param_14: vec2<f32>;
    var bl: vec2<f32>;
    var param_15: vec2<f32>;
    var bm: vec2<f32>;
    var param_16: vec2<f32>;
    var br: vec2<f32>;
    var param_17: vec2<f32>;
    var gx: vec2<f32>;
    var gy: vec2<f32>;
    var g: f32;
    var outline: f32;
    var toC: vec4<f32>;
    var param_18: vec2<f32>;
    var l: f32;
    var grain: f32;
    var param_19: vec2<f32>;
    var order: f32;
    var param_20: vec2<f32>;
    var fine: f32;
    var param_21: vec2<f32>;
    var drawOutline: f32;
    var drawHatch: f32;
    var fill: f32;
    var dark_1: f32;
    var h1_: f32;
    var param_22: vec2<f32>;
    var param_23: vec2<f32>;
    var param_24: f32;
    var h2_: f32;
    var param_25: vec2<f32>;
    var param_26: vec2<f32>;
    var param_27: f32;
    var hatch: f32;
    var pencil: f32;
    var base: vec4<f32>;
    var param_28: vec2<f32>;
    var sat: f32;
    var tone: vec4<f32>;
    var col: vec4<f32>;

    let _e126 = (*uv_3)[0u];
    let _e128 = uniforms.ratio;
    let _e131 = (*uv_3)[1u];
    q_1 = vec2<f32>((_e126 * _e128), _e131);
    let _e133 = q_1;
    param_8 = (_e133 * 6f);
    let _e135 = sdNoise((&param_8));
    let _e136 = q_1;
    param_9 = ((_e136 * 6f) + vec2(17f));
    let _e140 = sdNoise((&param_9));
    wob = ((vec2<f32>(_e135, _e140) - vec2(0.5f)) * 0.004f);
    let _e145 = (*uv_3);
    let _e146 = wob;
    let _e148 = uniforms.progress;
    su = (_e145 + (_e146 * (1f - _e148)));
    let _e153 = uniforms.lineWidth;
    let _e156 = uniforms.ratio;
    dx = vec2<f32>(((0.001f * _e153) / _e156), 0f);
    let _e160 = uniforms.lineWidth;
    dy = vec2<f32>(0f, (0.001f * _e160));
    let _e163 = su;
    let _e164 = dx;
    let _e166 = dy;
    param_10 = ((_e163 - _e164) + _e166);
    let _e168 = sdTone((&param_10));
    tl = _e168;
    let _e169 = su;
    let _e170 = dy;
    param_11 = (_e169 + _e170);
    let _e172 = sdTone((&param_11));
    tm = _e172;
    let _e173 = su;
    let _e174 = dx;
    let _e176 = dy;
    param_12 = ((_e173 + _e174) + _e176);
    let _e178 = sdTone((&param_12));
    tr = _e178;
    let _e179 = su;
    let _e180 = dx;
    param_13 = (_e179 - _e180);
    let _e182 = sdTone((&param_13));
    ml = _e182;
    let _e183 = su;
    let _e184 = dx;
    param_14 = (_e183 + _e184);
    let _e186 = sdTone((&param_14));
    mr = _e186;
    let _e187 = su;
    let _e188 = dx;
    let _e190 = dy;
    param_15 = ((_e187 - _e188) - _e190);
    let _e192 = sdTone((&param_15));
    bl = _e192;
    let _e193 = su;
    let _e194 = dy;
    param_16 = (_e193 - _e194);
    let _e196 = sdTone((&param_16));
    bm = _e196;
    let _e197 = su;
    let _e198 = dx;
    let _e200 = dy;
    param_17 = ((_e197 + _e198) - _e200);
    let _e202 = sdTone((&param_17));
    br = _e202;
    let _e203 = tr;
    let _e204 = mr;
    let _e207 = br;
    let _e209 = tl;
    let _e210 = ml;
    let _e213 = bl;
    gx = (((_e203 + (_e204 * 2f)) + _e207) - ((_e209 + (_e210 * 2f)) + _e213));
    let _e216 = tl;
    let _e217 = tm;
    let _e220 = tr;
    let _e222 = bl;
    let _e223 = bm;
    let _e226 = br;
    gy = (((_e216 + (_e217 * 2f)) + _e220) - ((_e222 + (_e223 * 2f)) + _e226));
    let _e230 = gx[0u];
    let _e232 = gy[0u];
    let _e236 = gx[1u];
    let _e238 = gy[1u];
    let _e243 = uniforms.edges;
    g = (max(length(vec2<f32>(_e230, _e232)), length(vec2<f32>(_e236, _e238))) * max(_e243, 0f));
    let _e246 = g;
    outline = smoothstep(0.12f, 0.5f, _e246);
    let _e248 = (*uv_3);
    param_18 = _e248;
    let _e249 = getToColor((&param_18));
    toC = _e249;
    let _e251 = tm[0u];
    let _e253 = bm[0u];
    let _e256 = ml[0u];
    let _e259 = mr[0u];
    l = clamp(((((_e251 + _e253) + _e256) + _e259) * 0.25f), 0f, 1f);
    let _e263 = q_1;
    param_19 = (_e263 * vec2<f32>(180f, 60f));
    let _e265 = sdNoise((&param_19));
    grain = (0.65f + (0.35f * _e265));
    let _e268 = q_1;
    param_20 = ((_e268 * 3f) + vec2(4f));
    let _e272 = sdNoise((&param_20));
    order = _e272;
    let _e273 = q_1;
    param_21 = (_e273 * 24f);
    let _e275 = sdNoise((&param_21));
    fine = _e275;
    let _e277 = uniforms.progress;
    let _e278 = order;
    let _e280 = fine;
    drawOutline = smoothstep(0f, 0.1f, (_e277 - ((0.22f * _e278) + (0.05f * _e280))));
    let _e286 = uniforms.progress;
    let _e287 = order;
    let _e290 = fine;
    drawHatch = smoothstep(0f, 0.12f, (_e286 - ((0.2f + (0.2f * _e287)) + (0.05f * _e290))));
    let _e296 = uniforms.progress;
    let _e297 = l;
    let _e300 = order;
    fill = smoothstep(0f, 0.22f, (_e296 - ((0.4f + (0.25f * _e297)) + (0.1f * _e300))));
    let _e305 = l;
    dark_1 = (1f - _e305);
    let _e307 = dark_1;
    let _e309 = q_1;
    param_22 = _e309;
    param_23 = vec2<f32>(0.7071f, 0.7071f);
    param_24 = smoothstep(0.35f, 0.9f, _e307);
    let _e310 = sdHatch((&param_22), (&param_23), (&param_24));
    h1_ = _e310;
    let _e311 = dark_1;
    let _e313 = q_1;
    param_25 = _e313;
    param_26 = vec2<f32>(0.7071f, -0.7071f);
    param_27 = smoothstep(0.65f, 1f, _e311);
    let _e314 = sdHatch((&param_25), (&param_26), (&param_27));
    h2_ = _e314;
    let _e316 = uniforms.hatching;
    let _e318 = h1_;
    let _e319 = h2_;
    let _e324 = toC[3u];
    hatch = (((_e316 * 0.8f) * max(_e318, (0.8f * _e319))) * _e324);
    let _e326 = drawHatch;
    let _e327 = fill;
    let _e331 = hatch;
    hatch = (_e331 * (_e326 * (1f - (0.6f * _e327))));
    let _e333 = outline;
    let _e334 = drawOutline;
    let _e336 = hatch;
    let _e338 = grain;
    pencil = (max((_e333 * _e334), _e336) * _e338);
    let _e341 = uniforms.progress;
    let _e344 = pencil;
    pencil = (_e344 * (1f - smoothstep(0.7f, 1f, _e341)));
    let _e346 = (*uv_3);
    param_28 = _e346;
    let _e347 = getFromColor((&param_28));
    let _e349 = uniforms.paper;
    let _e351 = uniforms.progress;
    base = mix(_e347, _e349, vec4(smoothstep(0.02f, 0.38f, _e351)));
    let _e356 = uniforms.progress;
    sat = smoothstep(0.55f, 1f, _e356);
    let _e359 = uniforms.paper;
    let _e361 = l;
    let _e363 = (_e359.xyz * mix(0.3f, 1f, _e361));
    let _e366 = uniforms.paper[3u];
    let _e368 = toC[3u];
    tone = vec4<f32>(_e363.x, _e363.y, _e363.z, (_e366 * _e368));
    let _e374 = tone;
    let _e375 = toC;
    let _e376 = sat;
    col = mix(_e374, _e375, vec4(_e376));
    let _e379 = base;
    let _e380 = col;
    let _e381 = fill;
    base = mix(_e379, _e380, vec4(_e381));
    let _e384 = base;
    let _e386 = uniforms.ink;
    let _e387 = pencil;
    return mix(_e384, _e386, vec4(_e387));
}

fn main_1() {
    var param_29: vec2<f32>;

    let _e70 = _uv_1;
    param_29 = _e70;
    let _e71 = transition((&param_29));
    _fragColor = _e71;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
