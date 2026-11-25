// StopMotion — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StopMotion.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is a paper cutout that jerks off the frame in choppy stop-motion steps, with a tiny new tilt and offset each step and a drop shadow, while the incoming cutout jerks in the same way and lands
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    steps: i32,
    jitter: f32,
    shadow: f32,
    backColor: vec4<f32>,
    rimColor: vec4<f32>,
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

fn premultiply(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e53 = (*c);
    let _e56 = (*c)[3u];
    let _e57 = (_e53.xyz * _e56);
    let _e59 = (*c)[3u];
    return vec4<f32>(_e57.x, _e57.y, _e57.z, _e59);
}

fn roundedBox(q: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>, r: ptr<function, f32>) -> f32 {
    var d: vec2<f32>;

    let _e56 = (*q);
    let _e58 = (*b);
    let _e60 = (*r);
    d = ((abs(_e56) - _e58) + vec2(_e60));
    let _e63 = d;
    let _e68 = d[0u];
    let _e70 = d[1u];
    let _e74 = (*r);
    return ((length(max(_e63, vec2(0f))) + min(max(_e68, _e70), 0f)) - _e74);
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv)[0u];
    let _e56 = (*uv)[1u];
    let _e59 = textureSampleLevel(_from, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv_1)[0u];
    let _e56 = (*uv_1)[1u];
    let _e59 = textureSampleLevel(_to, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn drawCutout(col: ptr<function, vec4<f32>>, q_1: ptr<function, vec2<f32>>, c_1: ptr<function, vec2<f32>>, a: ptr<function, f32>, s: ptr<function, f32>, l: ptr<function, f32>, incoming: ptr<function, bool>) -> vec4<f32> {
    var asp: vec2<f32>;
    var halfImage: vec2<f32>;
    var halfCut: vec2<f32>;
    var rad: f32;
    var ca: f32;
    var sa: f32;
    var unrotate: mat2x2<f32>;
    var rs: vec2<f32>;
    var ss: vec2<f32>;
    var sAlpha: f32;
    var local: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var ds: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var blur: f32;
    var r_1: vec2<f32>;
    var dCut: f32;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: f32;
    var dImage: f32;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: f32;
    var cutCover: f32;
    var imageCover: f32;
    var st: vec2<f32>;
    var img: vec4<f32>;
    var local_1: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec4<f32>;
    var cut: vec4<f32>;
    var param_14: vec4<f32>;

    let _e97 = uniforms.ratio;
    asp = vec2<f32>(_e97, 1f);
    let _e99 = asp;
    halfImage = (_e99 * 0.5f);
    let _e101 = halfImage;
    let _e102 = (*l);
    halfCut = (_e101 + vec2((0.012f * _e102)));
    let _e106 = (*l);
    rad = (0.006f * _e106);
    let _e108 = (*a);
    ca = cos(_e108);
    let _e110 = (*a);
    sa = sin(_e110);
    let _e112 = ca;
    let _e113 = sa;
    let _e115 = sa;
    let _e116 = ca;
    unrotate = mat2x2<f32>(vec2<f32>(_e112, -(_e113)), vec2<f32>(_e115, _e116));
    let _e120 = unrotate;
    let _e121 = (*q_1);
    let _e122 = (*c_1);
    let _e124 = (*l);
    let _e128 = (*s);
    rs = ((_e120 * ((_e121 - _e122) - (vec2<f32>(0.018f, -0.026f) * _e124))) / vec2(_e128));
    let _e131 = rs;
    let _e132 = asp;
    ss = clamp(((_e131 / _e132) + vec2(0.5f)), vec2(0f), vec2(1f));
    let _e139 = (*incoming);
    if _e139 {
        let _e140 = ss;
        param = _e140;
        let _e141 = getToColor((&param));
        local = _e141.w;
    } else {
        let _e143 = ss;
        param_1 = _e143;
        let _e144 = getFromColor((&param_1));
        local = _e144.w;
    }
    let _e146 = local;
    let _e149 = uniforms.rimColor[3u];
    sAlpha = max(_e146, _e149);
    let _e151 = rs;
    param_2 = _e151;
    let _e152 = halfCut;
    param_3 = _e152;
    let _e153 = rad;
    param_4 = _e153;
    let _e154 = roundedBox((&param_2), (&param_3), (&param_4));
    let _e155 = (*s);
    ds = (_e154 * _e155);
    let _e157 = (*l);
    blur = (0.004f + (0.016f * _e157));
    let _e161 = uniforms.shadow;
    let _e164 = (*l);
    let _e166 = sAlpha;
    let _e168 = blur;
    let _e170 = blur;
    let _e171 = ds;
    let _e176 = (*col);
    let _e178 = (_e176.xyz * (1f - ((((clamp(_e161, 0f, 1f) * 0.75f) * _e164) * _e166) * (1f - smoothstep(-(_e168), _e170, _e171)))));
    (*col)[0u] = _e178.x;
    (*col)[1u] = _e178.y;
    (*col)[2u] = _e178.z;
    let _e185 = unrotate;
    let _e186 = (*q_1);
    let _e187 = (*c_1);
    let _e190 = (*s);
    r_1 = ((_e185 * (_e186 - _e187)) / vec2(_e190));
    let _e193 = r_1;
    param_5 = _e193;
    let _e194 = halfCut;
    param_6 = _e194;
    let _e195 = rad;
    param_7 = _e195;
    let _e196 = roundedBox((&param_5), (&param_6), (&param_7));
    let _e197 = (*s);
    dCut = (_e196 * _e197);
    let _e199 = r_1;
    param_8 = _e199;
    let _e200 = halfImage;
    param_9 = _e200;
    param_10 = 0f;
    let _e201 = roundedBox((&param_8), (&param_9), (&param_10));
    let _e202 = (*s);
    dImage = (_e201 * _e202);
    let _e204 = dCut;
    cutCover = clamp((0.5f - (_e204 / 0.0015f)), 0f, 1f);
    let _e208 = dImage;
    imageCover = clamp((0.5f - (_e208 / 0.0015f)), 0f, 1f);
    let _e212 = r_1;
    let _e213 = asp;
    st = clamp(((_e212 / _e213) + vec2(0.5f)), vec2(0f), vec2(1f));
    let _e220 = (*incoming);
    if _e220 {
        let _e221 = st;
        param_11 = _e221;
        let _e222 = getToColor((&param_11));
        local_1 = _e222;
    } else {
        let _e223 = st;
        param_12 = _e223;
        let _e224 = getFromColor((&param_12));
        local_1 = _e224;
    }
    let _e225 = local_1;
    param_13 = _e225;
    let _e226 = premultiply((&param_13));
    img = _e226;
    let _e228 = uniforms.rimColor;
    param_14 = _e228;
    let _e229 = premultiply((&param_14));
    let _e230 = img;
    let _e231 = imageCover;
    let _e234 = cutCover;
    cut = (mix(_e229, _e230, vec4(_e231)) * _e234);
    let _e236 = cut;
    let _e237 = (*col);
    let _e239 = cut[3u];
    return (_e236 + (_e237 * (1f - _e239)));
}

fn offFrame(h: ptr<function, vec2<f32>>, a_1: ptr<function, f32>) -> f32 {
    let _e55 = uniforms.ratio;
    let _e57 = (*a_1);
    let _e61 = (*h)[0u];
    let _e64 = (*a_1);
    let _e68 = (*h)[1u];
    return ((((0.5f * _e55) + (abs(cos(_e57)) * _e61)) + (abs(sin(_e64)) * _e68)) + 0.08f);
}

fn cutoutSize(s_1: ptr<function, f32>, l_1: ptr<function, f32>) -> vec2<f32> {
    let _e55 = uniforms.ratio;
    let _e58 = (*l_1);
    let _e62 = (*s_1);
    return (((vec2<f32>(_e55, 1f) * 0.5f) + vec2((0.012f * _e58))) * _e62);
}

fn hash11(p: ptr<function, f32>) -> f32 {
    let _e53 = (*p);
    (*p) = fract((_e53 * 0.1031f));
    let _e56 = (*p);
    let _e58 = (*p);
    (*p) = (_e58 * (_e56 + 33.33f));
    let _e60 = (*p);
    let _e61 = (*p);
    let _e63 = (*p);
    (*p) = (_e63 * (_e60 + _e61));
    let _e65 = (*p);
    return fract(_e65);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n: f32;
    var local_2: i32;
    var k: f32;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var q_2: vec2<f32>;
    var j: f32;
    var l0_: f32;
    var m0_: f32;
    var s0_: f32;
    var a0_: f32;
    var param_17: f32;
    var c0_: vec2<f32>;
    var param_18: f32;
    var param_19: f32;
    var param_20: vec2<f32>;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var l1_: f32;
    var m1_: f32;
    var s1_: f32;
    var a1_: f32;
    var param_24: f32;
    var c1_: vec2<f32>;
    var param_25: f32;
    var param_26: f32;
    var param_27: vec2<f32>;
    var param_28: f32;
    var param_29: f32;
    var param_30: f32;
    var col_1: vec4<f32>;
    var param_31: vec4<f32>;
    var param_32: vec4<f32>;
    var param_33: vec2<f32>;
    var param_34: vec2<f32>;
    var param_35: f32;
    var param_36: f32;
    var param_37: f32;
    var param_38: bool;
    var param_39: vec4<f32>;
    var param_40: vec2<f32>;
    var param_41: vec2<f32>;
    var param_42: f32;
    var param_43: f32;
    var param_44: f32;
    var param_45: bool;
    var param_46: f32;

    let _e102 = uniforms.steps;
    if (_e102 < 2i) {
        local_2 = 2i;
    } else {
        let _e105 = uniforms.steps;
        local_2 = _e105;
    }
    let _e106 = local_2;
    n = f32(_e106);
    let _e109 = uniforms.progress;
    let _e110 = n;
    k = floor(((_e109 * _e110) + 0.5f));
    let _e114 = k;
    if (_e114 <= 0f) {
        let _e116 = (*uv_2);
        param_15 = _e116;
        let _e117 = getFromColor((&param_15));
        return _e117;
    }
    let _e118 = k;
    let _e119 = n;
    if (_e118 >= _e119) {
        let _e121 = (*uv_2);
        param_16 = _e121;
        let _e122 = getToColor((&param_16));
        return _e122;
    }
    let _e123 = (*uv_2);
    let _e127 = uniforms.ratio;
    q_2 = ((_e123 - vec2(0.5f)) * vec2<f32>(_e127, 1f));
    let _e131 = uniforms.jitter;
    j = clamp(_e131, 0f, 1f);
    let _e133 = k;
    l0_ = min((_e133 / 2f), 1f);
    let _e136 = k;
    let _e138 = n;
    m0_ = clamp(((_e136 - 1f) / (0.45f * _e138)), 0f, 1f);
    let _e142 = m0_;
    let _e143 = m0_;
    let _e145 = m0_;
    m0_ = ((_e142 * _e143) * (0.4f + (0.6f * _e145)));
    let _e149 = l0_;
    s0_ = (1f - (0.2f * _e149));
    let _e152 = m0_;
    let _e154 = l0_;
    let _e155 = j;
    let _e158 = k;
    param_17 = _e158;
    let _e159 = hash11((&param_17));
    a0_ = ((0.22f * _e152) + (((_e154 * _e155) * 0.2f) * (_e159 - 0.5f)));
    let _e163 = s0_;
    param_18 = _e163;
    let _e164 = l0_;
    param_19 = _e164;
    let _e165 = cutoutSize((&param_18), (&param_19));
    param_20 = _e165;
    let _e166 = a0_;
    param_21 = _e166;
    let _e167 = offFrame((&param_20), (&param_21));
    let _e169 = m0_;
    let _e171 = m0_;
    let _e173 = m0_;
    let _e176 = l0_;
    let _e177 = j;
    let _e179 = k;
    param_22 = (_e179 + 100f);
    let _e181 = hash11((&param_22));
    let _e184 = k;
    param_23 = (_e184 + 200f);
    let _e186 = hash11((&param_23));
    c0_ = (vec2<f32>((-(_e167) * _e169), ((0.05f * _e171) * _e173)) + (vec2<f32>((0.07f * (_e181 - 0.5f)), (0.05f * (_e186 - 0.5f))) * (_e176 * _e177)));
    let _e192 = n;
    let _e193 = k;
    l1_ = min(((_e192 - _e193) / 2f), 1f);
    let _e197 = n;
    let _e199 = k;
    let _e201 = n;
    m1_ = clamp((((_e197 - 2f) - _e199) / (0.45f * _e201)), 0f, 1f);
    let _e205 = m1_;
    let _e206 = m1_;
    let _e208 = m1_;
    m1_ = ((_e205 * _e206) * (0.4f + (0.6f * _e208)));
    let _e212 = l1_;
    s1_ = (1f - (0.2f * _e212));
    let _e215 = m1_;
    let _e217 = l1_;
    let _e218 = j;
    let _e221 = k;
    param_24 = (_e221 + 300f);
    let _e223 = hash11((&param_24));
    a1_ = ((-0.25f * _e215) + (((_e217 * _e218) * 0.2f) * (_e223 - 0.5f)));
    let _e227 = s1_;
    param_25 = _e227;
    let _e228 = l1_;
    param_26 = _e228;
    let _e229 = cutoutSize((&param_25), (&param_26));
    param_27 = _e229;
    let _e230 = a1_;
    param_28 = _e230;
    let _e231 = offFrame((&param_27), (&param_28));
    let _e232 = m1_;
    let _e234 = m1_;
    let _e236 = m1_;
    let _e239 = l1_;
    let _e240 = j;
    let _e242 = k;
    param_29 = (_e242 + 400f);
    let _e244 = hash11((&param_29));
    let _e247 = k;
    param_30 = (_e247 + 500f);
    let _e249 = hash11((&param_30));
    c1_ = (vec2<f32>((_e231 * _e232), ((-0.06f * _e234) * _e236)) + (vec2<f32>((0.07f * (_e244 - 0.5f)), (0.05f * (_e249 - 0.5f))) * (_e239 * _e240)));
    let _e256 = uniforms.backColor;
    param_31 = _e256;
    let _e257 = premultiply((&param_31));
    col_1 = _e257;
    let _e258 = m0_;
    if (_e258 < 1f) {
        let _e260 = col_1;
        param_32 = _e260;
        let _e261 = q_2;
        param_33 = _e261;
        let _e262 = c0_;
        param_34 = _e262;
        let _e263 = a0_;
        param_35 = _e263;
        let _e264 = s0_;
        param_36 = _e264;
        let _e265 = l0_;
        param_37 = _e265;
        param_38 = false;
        let _e266 = drawCutout((&param_32), (&param_33), (&param_34), (&param_35), (&param_36), (&param_37), (&param_38));
        col_1 = _e266;
    }
    let _e267 = m1_;
    if (_e267 < 1f) {
        let _e269 = col_1;
        param_39 = _e269;
        let _e270 = q_2;
        param_40 = _e270;
        let _e271 = c1_;
        param_41 = _e271;
        let _e272 = a1_;
        param_42 = _e272;
        let _e273 = s1_;
        param_43 = _e273;
        let _e274 = l1_;
        param_44 = _e274;
        param_45 = true;
        let _e275 = drawCutout((&param_39), (&param_40), (&param_41), (&param_42), (&param_43), (&param_44), (&param_45));
        col_1 = _e275;
    }
    let _e277 = col_1[3u];
    if (_e277 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e280 = col_1[3u];
    let _e281 = col_1;
    let _e284 = (_e281.xyz / vec3(_e280));
    col_1[0u] = _e284.x;
    col_1[1u] = _e284.y;
    col_1[2u] = _e284.z;
    let _e291 = j;
    let _e293 = k;
    param_46 = (_e293 + 600f);
    let _e295 = hash11((&param_46));
    let _e298 = col_1;
    let _e300 = (_e298.xyz * (1f - ((0.04f * _e291) * _e295)));
    col_1[0u] = _e300.x;
    col_1[1u] = _e300.y;
    col_1[2u] = _e300.z;
    let _e307 = col_1;
    return _e307;
}

fn main_1() {
    var param_47: vec2<f32>;

    let _e53 = _uv_1;
    param_47 = _e53;
    let _e54 = transition((&param_47));
    _fragColor = _e54;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
