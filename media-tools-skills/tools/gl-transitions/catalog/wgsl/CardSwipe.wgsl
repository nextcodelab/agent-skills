// CardSwipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CardSwipe.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is flicked off like the top card of a stack, swinging around a point below it as it flies out, while the incoming card behind it grows to fill the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    rotation: f32,
    depth: f32,
    backColor: vec4<f32>,
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
    let _e50 = (*uv)[0u];
    let _e52 = (*uv)[1u];
    let _e55 = textureSampleLevel(_from, _sampler, vec2<f32>(_e50, (1f - _e52)), 0f);
    return _e55;
}

fn premultiply(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e49 = (*c);
    let _e52 = (*c)[3u];
    let _e53 = (_e49.xyz * _e52);
    let _e55 = (*c)[3u];
    return vec4<f32>(_e53.x, _e53.y, _e53.z, _e55);
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e50 = (*uv_1)[0u];
    let _e52 = (*uv_1)[1u];
    let _e55 = textureSampleLevel(_to, _sampler, vec2<f32>(_e50, (1f - _e52)), 0f);
    return _e55;
}

fn roundedBox(q: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>, r: ptr<function, f32>) -> f32 {
    var d: vec2<f32>;

    let _e52 = (*q);
    let _e54 = (*b);
    let _e56 = (*r);
    d = ((abs(_e52) - _e54) + vec2(_e56));
    let _e59 = d;
    let _e64 = d[0u];
    let _e66 = d[1u];
    let _e70 = (*r);
    return ((length(max(_e59, vec2(0f))) + min(max(_e64, _e66), 0f)) - _e70);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dl: f32;
    var d_1: vec2<f32>;
    var local: vec2<f32>;
    var q_1: vec2<f32>;
    var b_1: vec2<f32>;
    var p: f32;
    var h: f32;
    var g: f32;
    var k: f32;
    var sc: f32;
    var rb: f32;
    var db: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: f32;
    var cb: f32;
    var tc: vec4<f32>;
    var param_3: vec2<f32>;
    var col: vec4<f32>;
    var param_4: vec4<f32>;
    var param_5: vec4<f32>;
    var t: f32;
    var lift: f32;
    var u: f32;
    var swing: f32;
    var a: f32;
    var pivot: vec2<f32>;
    var ca: f32;
    var sa: f32;
    var swung: vec2<f32>;
    var far: f32;
    var shift: vec2<f32>;
    var unrotate: mat2x2<f32>;
    var r_1: vec2<f32>;
    var rf: f32;
    var sh: f32;
    var rs: vec2<f32>;
    var ds: f32;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: f32;
    var df: f32;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var cf: f32;
    var fc: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: vec4<f32>;
    var local_1: vec4<f32>;

    let _e100 = uniforms.direction;
    dl = length(_e100);
    let _e102 = dl;
    if (_e102 > 0.000001f) {
        let _e105 = uniforms.direction;
        let _e106 = dl;
        local = (_e105 / vec2(_e106));
    } else {
        local = vec2<f32>(0.970143f, 0.242536f);
    }
    let _e109 = local;
    d_1 = _e109;
    let _e110 = (*uv_2);
    let _e114 = uniforms.ratio;
    q_1 = ((_e110 - vec2(0.5f)) * vec2<f32>(_e114, 1f));
    let _e118 = uniforms.ratio;
    b_1 = vec2<f32>((0.5f * _e118), 0.5f);
    let _e122 = uniforms.progress;
    p = _e122;
    let _e123 = p;
    h = clamp(((_e123 - 0.2f) / 0.8f), 0f, 1f);
    let _e127 = h;
    let _e128 = h;
    let _e130 = h;
    g = ((_e127 * _e128) * (3f - (2f * _e130)));
    let _e134 = g;
    k = (1f - _e134);
    let _e137 = uniforms.depth;
    let _e138 = k;
    sc = (1f - (_e137 * _e138));
    let _e141 = k;
    rb = (0.045f * min(1f, (12f * _e141)));
    let _e145 = b_1;
    let _e146 = sc;
    let _e148 = q_1;
    param = _e148;
    param_1 = (_e145 * _e146);
    let _e149 = rb;
    param_2 = _e149;
    let _e150 = roundedBox((&param), (&param_1), (&param_2));
    db = _e150;
    let _e151 = db;
    let _e152 = k;
    cb = clamp((0.5f - (_e151 / max((0.002f * min(1f, (40f * _e152))), 0.000001f))), 0f, 1f);
    let _e160 = (*uv_2);
    let _e163 = sc;
    param_3 = clamp((vec2(0.5f) + ((_e160 - vec2(0.5f)) / vec2(_e163))), vec2(0f), vec2(1f));
    let _e171 = getToColor((&param_3));
    tc = _e171;
    let _e172 = k;
    let _e174 = k;
    let _e177 = tc;
    let _e179 = (_e177.xyz * (1f - ((0.35f * _e172) * _e174)));
    tc[0u] = _e179.x;
    tc[1u] = _e179.y;
    tc[2u] = _e179.z;
    let _e187 = uniforms.backColor;
    param_4 = _e187;
    let _e188 = premultiply((&param_4));
    let _e189 = tc;
    param_5 = _e189;
    let _e190 = premultiply((&param_5));
    let _e191 = cb;
    col = mix(_e188, _e190, vec4(_e191));
    let _e194 = p;
    t = clamp((_e194 / 0.75f), 0f, 1f);
    let _e197 = p;
    lift = smoothstep(0f, 0.15f, _e197);
    let _e199 = t;
    u = min((_e199 / 0.7f), 1f);
    let _e202 = u;
    let _e203 = u;
    let _e205 = u;
    swing = ((_e202 * _e203) * (3f - (2f * _e205)));
    let _e210 = d_1[0u];
    let _e214 = uniforms.rotation;
    let _e216 = swing;
    a = ((select(-1.3f, 1.3f, (_e210 < 0f)) * _e214) * _e216);
    pivot = vec2<f32>(0f, -1.1f);
    let _e218 = a;
    ca = cos(_e218);
    let _e220 = a;
    sa = sin(_e220);
    let _e222 = pivot;
    let _e223 = ca;
    let _e224 = sa;
    let _e225 = sa;
    let _e227 = ca;
    let _e231 = pivot;
    swung = (_e222 + (mat2x2<f32>(vec2<f32>(_e223, _e224), vec2<f32>(-(_e225), _e227)) * -(_e231)));
    let _e235 = b_1;
    let _e238 = swung;
    far = (((2f * length(_e235)) + length(_e238)) + 0.3f);
    let _e242 = d_1;
    let _e243 = far;
    let _e245 = t;
    let _e247 = t;
    let _e249 = t;
    shift = ((((_e242 * _e243) * _e245) * _e247) * (0.4f + (0.6f * _e249)));
    let _e253 = ca;
    let _e254 = sa;
    let _e256 = sa;
    let _e257 = ca;
    unrotate = mat2x2<f32>(vec2<f32>(_e253, -(_e254)), vec2<f32>(_e256, _e257));
    let _e261 = unrotate;
    let _e262 = q_1;
    let _e263 = shift;
    let _e265 = pivot;
    let _e268 = pivot;
    r_1 = ((_e261 * ((_e262 - _e263) - _e265)) + _e268);
    let _e270 = lift;
    rf = (0.045f * _e270);
    let _e272 = lift;
    let _e274 = t;
    sh = ((0.6f * _e272) * (1f - _e274));
    let _e277 = sh;
    if (_e277 > 0f) {
        let _e279 = unrotate;
        let _e280 = q_1;
        let _e281 = d_1;
        let _e284 = lift;
        let _e287 = shift;
        let _e289 = pivot;
        let _e292 = pivot;
        rs = ((_e279 * (((_e280 - (((_e281 * 0.03f) + vec2<f32>(0f, -0.03f)) * _e284)) - _e287) - _e289)) + _e292);
        let _e294 = rs;
        param_6 = _e294;
        let _e295 = b_1;
        param_7 = _e295;
        let _e296 = rf;
        param_8 = _e296;
        let _e297 = roundedBox((&param_6), (&param_7), (&param_8));
        ds = _e297;
        let _e298 = sh;
        let _e299 = ds;
        let _e304 = col;
        let _e306 = (_e304.xyz * (1f - (_e298 * (1f - smoothstep(-0.05f, 0.08f, _e299)))));
        col[0u] = _e306.x;
        col[1u] = _e306.y;
        col[2u] = _e306.z;
    }
    let _e313 = r_1;
    param_9 = _e313;
    let _e314 = b_1;
    param_10 = _e314;
    let _e315 = rf;
    param_11 = _e315;
    let _e316 = roundedBox((&param_9), (&param_10), (&param_11));
    df = _e316;
    let _e317 = df;
    let _e318 = lift;
    cf = clamp((0.5f - (_e317 / max((0.002f * min(1f, (40f * _e318))), 0.000001f))), 0f, 1f);
    let _e326 = r_1;
    let _e328 = uniforms.ratio;
    param_12 = clamp(((_e326 / vec2<f32>(_e328, 1f)) + vec2(0.5f)), vec2(0f), vec2(1f));
    let _e336 = getFromColor((&param_12));
    fc = _e336;
    let _e337 = col;
    let _e338 = fc;
    param_13 = _e338;
    let _e339 = premultiply((&param_13));
    let _e340 = cf;
    col = mix(_e337, _e339, vec4(_e340));
    let _e344 = col[3u];
    if (_e344 > 0f) {
        let _e346 = col;
        let _e349 = col[3u];
        let _e351 = (_e346.xyz / vec3(_e349));
        let _e353 = col[3u];
        local_1 = vec4<f32>(_e351.x, _e351.y, _e351.z, _e353);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e358 = local_1;
    return _e358;
}

fn main_1() {
    var param_14: vec2<f32>;

    let _e49 = _uv_1;
    param_14 = _e49;
    let _e50 = transition((&param_14));
    _fragColor = _e50;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
