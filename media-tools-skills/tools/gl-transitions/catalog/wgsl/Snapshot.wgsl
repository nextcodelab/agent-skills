// Snapshot — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Snapshot.glsl
// Author: gre
// License: MIT
// Description: A camera flash freezes the outgoing image into a printed photo with a white border, which shrinks, tilts and drops out of the frame, revealing the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    tilt: f32,
    border: f32,
    flash: f32,
    shadow: f32,
    borderColor: vec4<f32>,
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
    let _e40 = (*uv)[0u];
    let _e42 = (*uv)[1u];
    let _e45 = textureSampleLevel(_from, _sampler, vec2<f32>(_e40, (1f - _e42)), 0f);
    return _e45;
}

fn premultiply(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e39 = (*c);
    let _e42 = (*c)[3u];
    let _e43 = (_e39.xyz * _e42);
    let _e45 = (*c)[3u];
    return vec4<f32>(_e43.x, _e43.y, _e43.z, _e45);
}

fn roundedBox(q: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>, r: ptr<function, f32>) -> f32 {
    var d: vec2<f32>;

    let _e42 = (*q);
    let _e44 = (*b);
    let _e46 = (*r);
    d = ((abs(_e42) - _e44) + vec2(_e46));
    let _e49 = d;
    let _e54 = d[0u];
    let _e56 = d[1u];
    let _e60 = (*r);
    return ((length(max(_e49, vec2(0f))) + min(max(_e54, _e56), 0f)) - _e60);
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e40 = (*uv_1)[0u];
    let _e42 = (*uv_1)[1u];
    let _e45 = textureSampleLevel(_to, _sampler, vec2<f32>(_e40, (1f - _e42)), 0f);
    return _e45;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var asp: vec2<f32>;
    var q_1: vec2<f32>;
    var halfImage: vec2<f32>;
    var halfCard: vec2<f32>;
    var k: f32;
    var t: f32;
    var fall: f32;
    var s: f32;
    var a: f32;
    var bound: f32;
    var lift: f32;
    var center: vec2<f32>;
    var rad: f32;
    var ca: f32;
    var sa: f32;
    var unrotate: mat2x2<f32>;
    var col: vec4<f32>;
    var param: vec2<f32>;
    var sh: f32;
    var rs: vec2<f32>;
    var ds: f32;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: f32;
    var blur: f32;
    var param_4: vec4<f32>;
    var r_1: vec2<f32>;
    var dCard: f32;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: f32;
    var dImage: f32;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: f32;
    var cardCover: f32;
    var imageCover: f32;
    var photo: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec4<f32>;
    var paper: vec4<f32>;
    var param_13: vec4<f32>;
    var card: vec4<f32>;
    var f: f32;

    let _e85 = uniforms.progress;
    p = _e85;
    let _e87 = uniforms.ratio;
    asp = vec2<f32>(_e87, 1f);
    let _e89 = (*uv_2);
    let _e92 = asp;
    q_1 = ((_e89 - vec2(0.5f)) * _e92);
    let _e94 = asp;
    halfImage = (_e94 * 0.5f);
    let _e96 = halfImage;
    let _e98 = uniforms.border;
    halfCard = (_e96 + vec2(_e98));
    let _e101 = p;
    k = smoothstep(0.05f, 0.4f, _e101);
    let _e103 = p;
    t = clamp(((_e103 - 0.3f) / 0.7f), 0f, 1f);
    let _e107 = t;
    let _e108 = t;
    fall = (_e107 * _e108);
    let _e110 = k;
    s = (1f - (0.24f * _e110));
    let _e114 = uniforms.tilt;
    let _e116 = k;
    let _e118 = fall;
    a = (-(_e114) * ((0.12f * _e116) + (0.88f * _e118)));
    let _e123 = uniforms.tilt;
    let _e127 = halfCard[0u];
    let _e130 = uniforms.tilt;
    let _e134 = halfCard[1u];
    bound = (((abs(sin(_e123)) * _e127) + (abs(cos(_e130)) * _e134)) * 0.76f);
    let _e138 = k;
    let _e140 = fall;
    lift = ((0.035f * _e138) * (1f - _e140));
    let _e143 = fall;
    let _e145 = lift;
    let _e146 = bound;
    let _e149 = fall;
    center = vec2<f32>((0.08f * _e143), (_e145 - (((0.5f + _e146) + 0.1f) * _e149)));
    let _e153 = k;
    rad = (0.008f * _e153);
    let _e155 = a;
    ca = cos(_e155);
    let _e157 = a;
    sa = sin(_e157);
    let _e159 = ca;
    let _e160 = sa;
    let _e162 = sa;
    let _e163 = ca;
    unrotate = mat2x2<f32>(vec2<f32>(_e159, -(_e160)), vec2<f32>(_e162, _e163));
    let _e167 = (*uv_2);
    param = _e167;
    let _e168 = getToColor((&param));
    col = _e168;
    let _e170 = uniforms.shadow;
    let _e171 = k;
    sh = (_e170 * _e171);
    let _e173 = sh;
    if (_e173 > 0f) {
        let _e175 = unrotate;
        let _e176 = q_1;
        let _e177 = center;
        let _e179 = k;
        let _e183 = s;
        rs = ((_e175 * ((_e176 - _e177) - (vec2<f32>(0.012f, -0.022f) * _e179))) / vec2(_e183));
        let _e186 = rs;
        param_1 = _e186;
        let _e187 = halfCard;
        param_2 = _e187;
        let _e188 = rad;
        param_3 = _e188;
        let _e189 = roundedBox((&param_1), (&param_2), (&param_3));
        let _e190 = s;
        ds = (_e189 * _e190);
        let _e192 = s;
        blur = (0.035f * _e192);
        let _e194 = sh;
        let _e195 = blur;
        let _e197 = blur;
        let _e198 = ds;
        let _e203 = col;
        let _e205 = (_e203.xyz * (1f - (_e194 * (1f - smoothstep(-(_e195), _e197, _e198)))));
        col[0u] = _e205.x;
        col[1u] = _e205.y;
        col[2u] = _e205.z;
    }
    let _e212 = col;
    param_4 = _e212;
    let _e213 = premultiply((&param_4));
    col = _e213;
    let _e214 = unrotate;
    let _e215 = q_1;
    let _e216 = center;
    let _e219 = s;
    r_1 = ((_e214 * (_e215 - _e216)) / vec2(_e219));
    let _e222 = r_1;
    param_5 = _e222;
    let _e223 = halfCard;
    param_6 = _e223;
    let _e224 = rad;
    param_7 = _e224;
    let _e225 = roundedBox((&param_5), (&param_6), (&param_7));
    let _e226 = s;
    dCard = (_e225 * _e226);
    let _e228 = r_1;
    param_8 = _e228;
    let _e229 = halfImage;
    param_9 = _e229;
    param_10 = 0f;
    let _e230 = roundedBox((&param_8), (&param_9), (&param_10));
    let _e231 = s;
    dImage = (_e230 * _e231);
    let _e233 = dCard;
    cardCover = clamp((1.5f - (_e233 / 0.0015f)), 0f, 1f);
    let _e237 = dImage;
    imageCover = clamp((1.5f - (_e237 / 0.0015f)), 0f, 1f);
    let _e241 = r_1;
    let _e242 = asp;
    param_11 = clamp(((_e241 / _e242) + vec2(0.5f)), vec2(0f), vec2(1f));
    let _e249 = getFromColor((&param_11));
    param_12 = _e249;
    let _e250 = premultiply((&param_12));
    photo = _e250;
    let _e252 = uniforms.borderColor;
    param_13 = _e252;
    let _e253 = premultiply((&param_13));
    paper = _e253;
    let _e254 = paper;
    let _e255 = col;
    let _e257 = paper[3u];
    let _e261 = photo;
    let _e262 = imageCover;
    card = mix((_e254 + (_e255 * (1f - _e257))), _e261, vec4(_e262));
    let _e265 = col;
    let _e266 = card;
    let _e267 = cardCover;
    col = mix(_e265, _e266, vec4(_e267));
    let _e271 = col[3u];
    if (_e271 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e274 = col[3u];
    let _e275 = col;
    let _e278 = (_e275.xyz / vec3(_e274));
    col[0u] = _e278.x;
    col[1u] = _e278.y;
    col[2u] = _e278.z;
    let _e286 = uniforms.flash;
    let _e287 = p;
    let _e290 = p;
    f = ((_e286 * smoothstep(0f, 0.05f, _e287)) * (1f - smoothstep(0.05f, 0.3f, _e290)));
    let _e294 = col;
    let _e298 = f;
    let _e302 = (vec3(1f) - ((vec3(1f) - _e294.xyz) * (1f - _e298)));
    col[0u] = _e302.x;
    col[1u] = _e302.y;
    col[2u] = _e302.z;
    let _e309 = col;
    return _e309;
}

fn main_1() {
    var param_14: vec2<f32>;

    let _e39 = _uv_1;
    param_14 = _e39;
    let _e40 = transition((&param_14));
    _fragColor = _e40;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
