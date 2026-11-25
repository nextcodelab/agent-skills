// PaperTear — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PaperTear.glsl
// Author: gre
// License: MIT
// Description: The outgoing image tears in two along a ragged line, and the halves are pulled apart to reveal the incoming one
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    roughness: f32,
    tilt: f32,
    rim: f32,
    paper: vec4<f32>,
    shadow: vec4<f32>,
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

fn torn(bg: ptr<function, vec4<f32>>, col: ptr<function, vec4<f32>>, e: ptr<function, f32>, limit: ptr<function, f32>, aa: ptr<function, f32>) -> vec4<f32> {
    var c: vec4<f32>;

    let _e53 = (*col);
    let _e56 = uniforms.paper;
    let _e58 = (*e);
    let _e59 = (*aa);
    let _e65 = uniforms.paper[3u];
    let _e68 = mix(_e53.xyz, _e56.xyz, vec3((clamp((0.5f + (_e58 / _e59)), 0f, 1f) * _e65)));
    let _e70 = (*col)[3u];
    c = vec4<f32>(_e68.x, _e68.y, _e68.z, _e70);
    let _e75 = (*bg);
    let _e76 = c;
    let _e77 = (*e);
    let _e78 = (*limit);
    let _e80 = (*aa);
    return mix(_e75, _e76, vec4(clamp((0.5f - ((_e77 - _e78) / _e80)), 0f, 1f)));
}

fn tri(x: ptr<function, f32>) -> f32 {
    let _e48 = (*x);
    return (abs((fract(_e48) - 0.5f)) - 0.25f);
}

fn fibers(y: ptr<function, f32>, seed: ptr<function, f32>) -> f32 {
    var param: f32;

    let _e51 = uniforms.rim;
    let _e52 = (*y);
    let _e54 = (*seed);
    let _e59 = (*y);
    let _e61 = (*seed);
    param = ((_e59 * 83f) + _e61);
    let _e63 = tri((&param));
    return (_e51 * ((0.7f + (0.3f * sin(((_e52 * 37f) + _e54)))) + (0.4f * _e63)));
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e49 = (*uv)[0u];
    let _e51 = (*uv)[1u];
    let _e54 = textureSampleLevel(_from, _sampler, vec2<f32>(_e49, (1f - _e51)), 0f);
    return _e54;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e49 = (*uv_1)[0u];
    let _e51 = (*uv_1)[1u];
    let _e54 = textureSampleLevel(_to, _sampler, vec2<f32>(_e49, (1f - _e51)), 0f);
    return _e54;
}

fn meander(y_1: ptr<function, f32>) -> f32 {
    let _e49 = uniforms.ratio;
    let _e52 = uniforms.roughness;
    let _e53 = (*y_1);
    let _e58 = (*y_1);
    return ((0.5f * _e49) + (_e52 * ((0.5f * sin(((_e53 * 4.7f) + 1.3f))) + (0.25f * sin(((_e58 * 11.3f) + 4.1f))))));
}

fn tear(y_2: ptr<function, f32>) -> f32 {
    var param_1: f32;
    var param_2: f32;
    var param_3: f32;

    let _e51 = (*y_2);
    param_1 = _e51;
    let _e52 = meander((&param_1));
    let _e54 = uniforms.roughness;
    let _e55 = (*y_2);
    let _e60 = (*y_2);
    let _e62 = (*y_2);
    param_2 = ((_e60 * 19f) + sin((_e62 * 7f)));
    let _e66 = tri((&param_2));
    let _e69 = (*y_2);
    let _e71 = (*y_2);
    param_3 = ((_e69 * 47f) + (0.6f * sin((_e71 * 13f))));
    let _e76 = tri((&param_3));
    return (_e52 + (_e54 * (((0.1f * sin(((_e55 * 29f) + 0.7f))) + (0.35f * _e66)) + (0.12f * _e76))));
}

fn unfold(q: ptr<function, vec2<f32>>, away: ptr<function, f32>, lean: ptr<function, f32>) -> vec2<f32> {
    let _e51 = (*q)[0u];
    let _e52 = (*away);
    let _e54 = (*lean);
    let _e56 = (*q)[1u];
    let _e60 = (*q)[1u];
    return vec2<f32>(((_e51 + _e52) + (_e54 * _e56)), _e60);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var away_1: f32;
    var lean_1: f32;
    var fiber: f32;
    var aa_1: f32;
    var q_1: vec2<f32>;
    var l: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: f32;
    var param_6: f32;
    var r: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: f32;
    var param_9: f32;
    var el: f32;
    var param_10: f32;
    var er: f32;
    var param_11: f32;
    var sq: vec2<f32>;
    var dl: f32;
    var param_12: vec2<f32>;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var dr: f32;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;
    var to: vec4<f32>;
    var param_20: vec2<f32>;
    var sh: f32;
    var c_1: vec4<f32>;
    var param_21: vec2<f32>;
    var param_22: f32;
    var param_23: f32;
    var param_24: vec4<f32>;
    var param_25: vec4<f32>;
    var param_26: f32;
    var param_27: f32;
    var param_28: f32;
    var param_29: vec2<f32>;
    var param_30: f32;
    var param_31: f32;
    var param_32: vec4<f32>;
    var param_33: vec4<f32>;
    var param_34: f32;
    var param_35: f32;
    var param_36: f32;

    let _e98 = uniforms.progress;
    p = _e98;
    let _e99 = p;
    let _e100 = p;
    let _e103 = uniforms.ratio;
    let _e107 = uniforms.roughness;
    let _e110 = uniforms.rim;
    away_1 = ((_e99 * _e100) * ((((0.5f * _e103) + 0.1f) + _e107) + (2f * _e110)));
    let _e115 = uniforms.tilt;
    let _e116 = p;
    let _e118 = p;
    lean_1 = ((_e115 * _e116) * (2f - _e118));
    let _e121 = p;
    fiber = smoothstep(0f, 0.15f, _e121);
    let _e123 = fiber;
    aa_1 = ((0.002f * _e123) + 0.000001f);
    let _e127 = (*uv_2)[0u];
    let _e129 = uniforms.ratio;
    let _e132 = (*uv_2)[1u];
    q_1 = vec2<f32>((_e127 * _e129), _e132);
    let _e134 = q_1;
    param_4 = _e134;
    let _e135 = away_1;
    param_5 = _e135;
    let _e136 = lean_1;
    param_6 = _e136;
    let _e137 = unfold((&param_4), (&param_5), (&param_6));
    l = _e137;
    let _e139 = uniforms.ratio;
    let _e141 = q_1[0u];
    let _e144 = q_1[1u];
    param_7 = vec2<f32>((_e139 - _e141), _e144);
    let _e146 = away_1;
    param_8 = _e146;
    let _e147 = lean_1;
    param_9 = _e147;
    let _e148 = unfold((&param_7), (&param_8), (&param_9));
    r = _e148;
    let _e150 = l[0u];
    let _e152 = l[1u];
    param_10 = _e152;
    let _e153 = tear((&param_10));
    el = (_e150 - _e153);
    let _e156 = r[0u];
    let _e158 = uniforms.ratio;
    let _e160 = r[1u];
    param_11 = _e160;
    let _e161 = tear((&param_11));
    er = (_e156 - (_e158 - _e161));
    let _e164 = q_1;
    sq = (_e164 - vec2<f32>(0.01f, 0f));
    let _e166 = sq;
    param_12 = _e166;
    let _e167 = away_1;
    param_13 = _e167;
    let _e168 = lean_1;
    param_14 = _e168;
    let _e169 = unfold((&param_12), (&param_13), (&param_14));
    let _e172 = sq[1u];
    param_15 = _e172;
    let _e173 = meander((&param_15));
    dl = (_e169.x - _e173);
    let _e176 = uniforms.ratio;
    let _e178 = sq[0u];
    let _e181 = sq[1u];
    param_16 = vec2<f32>((_e176 - _e178), _e181);
    let _e183 = away_1;
    param_17 = _e183;
    let _e184 = lean_1;
    param_18 = _e184;
    let _e185 = unfold((&param_16), (&param_17), (&param_18));
    let _e188 = uniforms.ratio;
    let _e190 = sq[1u];
    param_19 = _e190;
    let _e191 = meander((&param_19));
    dr = (_e185.x - (_e188 - _e191));
    let _e194 = (*uv_2);
    param_20 = _e194;
    let _e195 = getToColor((&param_20));
    to = _e195;
    let _e198 = uniforms.shadow[3u];
    let _e199 = dl;
    let _e200 = dr;
    sh = (_e198 * (1f - smoothstep(-0.02f, 0.08f, min(_e199, _e200))));
    let _e205 = to;
    let _e208 = uniforms.shadow;
    let _e210 = sh;
    let _e212 = mix(_e205.xyz, _e208.xyz, vec3(_e210));
    let _e214 = to[3u];
    c_1 = vec4<f32>(_e212.x, _e212.y, _e212.z, _e214);
    let _e220 = r[0u];
    if (_e220 >= 0f) {
        let _e223 = r[0u];
        let _e225 = uniforms.ratio;
        let _e229 = r[1u];
        param_21 = vec2<f32>((1f - (_e223 / _e225)), _e229);
        let _e231 = getFromColor((&param_21));
        let _e233 = r[1u];
        param_22 = _e233;
        param_23 = 2f;
        let _e234 = fibers((&param_22), (&param_23));
        let _e236 = fiber;
        let _e238 = c_1;
        param_24 = _e238;
        param_25 = _e231;
        let _e239 = er;
        param_26 = _e239;
        param_27 = ((_e234 * 1.5f) * _e236);
        let _e240 = aa_1;
        param_28 = _e240;
        let _e241 = torn((&param_24), (&param_25), (&param_26), (&param_27), (&param_28));
        c_1 = _e241;
    }
    let _e243 = l[0u];
    if (_e243 >= 0f) {
        let _e246 = l[0u];
        let _e248 = uniforms.ratio;
        let _e251 = l[1u];
        param_29 = vec2<f32>((_e246 / _e248), _e251);
        let _e253 = getFromColor((&param_29));
        let _e255 = l[1u];
        param_30 = _e255;
        param_31 = 0f;
        let _e256 = fibers((&param_30), (&param_31));
        let _e257 = fiber;
        let _e259 = c_1;
        param_32 = _e259;
        param_33 = _e253;
        let _e260 = el;
        param_34 = _e260;
        param_35 = (_e256 * _e257);
        let _e261 = aa_1;
        param_36 = _e261;
        let _e262 = torn((&param_32), (&param_33), (&param_34), (&param_35), (&param_36));
        c_1 = _e262;
    }
    let _e263 = c_1;
    return _e263;
}

fn main_1() {
    var param_37: vec2<f32>;

    let _e48 = _uv_1;
    param_37 = _e48;
    let _e49 = transition((&param_37));
    _fragColor = _e49;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
