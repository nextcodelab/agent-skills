// DominoFall — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DominoFall.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is cut into standing slats that topple backward like dominoes in a chain reaction across the frame, each one leaning onto the next and knocking it over, until they all lie flat and reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    count: i32,
    reverse: i32,
    knock: f32,
    lean: f32,
    perspective: f32,
    shading: f32,
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
    let _e38 = (*uv)[0u];
    let _e40 = (*uv)[1u];
    let _e43 = textureSampleLevel(_from, _sampler, vec2<f32>(_e38, (1f - _e40)), 0f);
    return _e43;
}

fn drawSlat(color: ptr<function, vec4<f32>>, j: ptr<function, f32>, pt: ptr<function, vec4<f32>>, front: ptr<function, vec4<f32>>, w: ptr<function, f32>) -> vec4<f32> {
    var t: f32;
    var s: f32;
    var d: f32;
    var m: f32;
    var e: f32;
    var sx: f32;
    var img: vec4<f32>;
    var local: f32;
    var param: vec2<f32>;
    var shade: f32;
    var reach: f32;
    var phi_318_: bool;
    var phi_418_: bool;
    var phi_424_: bool;

    let _e53 = (*pt)[2u];
    t = _e53;
    let _e54 = t;
    if (_e54 < 0f) {
        let _e56 = (*color);
        return _e56;
    }
    let _e58 = (*pt)[3u];
    s = sin(_e58);
    let _e61 = (*pt)[0u];
    let _e62 = (*w);
    let _e64 = (*pt)[0u];
    d = min(_e61, (_e62 - _e64));
    let _e67 = t;
    if (_e67 <= 0f) {
        let _e69 = d;
        let _e70 = (_e69 >= 0f);
        phi_318_ = _e70;
        if _e70 {
            let _e72 = (*pt)[1u];
            phi_318_ = (_e72 <= 1f);
        }
        let _e75 = phi_318_;
        m = select(0f, 1f, _e75);
    } else {
        let _e77 = t;
        let _e82 = uniforms.perspective;
        let _e85 = (*pt)[1u];
        let _e87 = s;
        e = ((0.0015f * min((10f * _e77), 1f)) * (1f + ((max(_e82, 0f) * _e85) * _e87)));
        let _e91 = d;
        let _e92 = e;
        let _e97 = (*pt)[1u];
        let _e100 = (*pt)[3u];
        let _e104 = e;
        m = (clamp(((_e91 / _e92) + 0.5f), 0f, 1f) * clamp(((((1f - _e97) * max(cos(_e100), 0.05f)) / _e104) + 0.5f), 0f, 1f));
    }
    let _e109 = m;
    if (_e109 <= 0f) {
        let _e111 = (*color);
        return _e111;
    }
    let _e112 = (*j);
    let _e113 = (*w);
    let _e116 = (*pt)[0u];
    let _e117 = (*w);
    let _e121 = uniforms.ratio;
    sx = (((_e112 * _e113) + clamp(_e116, 0f, _e117)) / _e121);
    let _e124 = uniforms.reverse;
    if (_e124 != 0i) {
        let _e126 = sx;
        local = (1f - _e126);
    } else {
        let _e128 = sx;
        local = _e128;
    }
    let _e129 = local;
    let _e131 = (*pt)[1u];
    param = vec2<f32>(_e129, min(_e131, 1f));
    let _e134 = getFromColor((&param));
    img = _e134;
    let _e136 = uniforms.shading;
    let _e137 = s;
    let _e140 = (*pt)[1u];
    shade = (1f - ((_e136 * _e137) * (0.4f + (0.6f * _e140))));
    let _e146 = (*front)[2u];
    let _e147 = (_e146 >= 0f);
    phi_418_ = _e147;
    if _e147 {
        let _e149 = (*front)[2u];
        let _e150 = t;
        phi_418_ = (_e149 < _e150);
    }
    let _e153 = phi_418_;
    phi_424_ = _e153;
    if _e153 {
        let _e155 = (*front)[0u];
        phi_424_ = (_e155 < 0f);
    }
    let _e158 = phi_424_;
    if _e158 {
        let _e160 = (*front)[1u];
        reach = clamp((1f - ((_e160 - 1f) / 0.05f)), 0f, 1f);
        let _e166 = uniforms.shading;
        let _e169 = (*front)[0u];
        let _e170 = (*w);
        let _e175 = reach;
        let _e178 = shade;
        shade = (_e178 * (1f - (((0.6f * _e166) * exp((_e169 / (0.15f * _e170)))) * _e175)));
    }
    let _e180 = shade;
    let _e181 = img;
    let _e183 = (_e181.xyz * _e180);
    img[0u] = _e183.x;
    img[1u] = _e183.y;
    img[2u] = _e183.z;
    let _e190 = (*color);
    let _e191 = img;
    let _e192 = m;
    return mix(_e190, _e191, vec4(_e192));
}

fn knockPart_u0028_() -> f32 {
    let _e37 = uniforms.knock;
    return clamp(_e37, 0.05f, 1f);
}

fn fallAngle(t_1: ptr<function, f32>) -> f32 {
    let _e37 = (*t_1);
    let _e39 = (*t_1);
    return ((1.5707964f * _e37) * (0.2f + (0.8f * _e39)));
}

fn fallTime(j_1: ptr<function, f32>, n: ptr<function, f32>) -> f32 {
    var k: f32;
    var d_1: f32;

    let _e41 = uniforms.progress;
    if (_e41 >= 1f) {
        return 1f;
    }
    let _e43 = knockPart_u0028_();
    k = _e43;
    let _e44 = (*n);
    let _e46 = k;
    d_1 = (1f / (1f + ((_e44 - 1f) * _e46)));
    let _e51 = uniforms.progress;
    let _e52 = (*j_1);
    let _e53 = k;
    let _e55 = d_1;
    let _e58 = d_1;
    return clamp(((_e51 - ((_e52 * _e53) * _e55)) / _e58), 0f, 1f);
}

fn slatPoint(j_2: ptr<function, f32>, n_1: ptr<function, f32>, w_1: ptr<function, f32>, xc: ptr<function, f32>, y: ptr<function, f32>) -> vec4<f32> {
    var none: vec4<f32>;
    var t_2: f32;
    var param_1: f32;
    var param_2: f32;
    var a: f32;
    var param_3: f32;
    var c: f32;
    var s_1: f32;
    var eye: vec3<f32>;
    var dir: vec3<f32>;
    var den: f32;
    var r: f32;
    var hit: vec3<f32>;
    var h: f32;
    var side: f32;
    var phi_152_: bool;

    none = vec4<f32>(0f, 0f, -1f, 0f);
    let _e56 = (*j_2);
    let _e57 = (_e56 < 0f);
    phi_152_ = _e57;
    if !(_e57) {
        let _e59 = (*j_2);
        let _e60 = (*n_1);
        phi_152_ = (_e59 > (_e60 - 1f));
    }
    let _e64 = phi_152_;
    if _e64 {
        let _e65 = none;
        return _e65;
    }
    let _e66 = (*j_2);
    param_1 = _e66;
    let _e67 = (*n_1);
    param_2 = _e67;
    let _e68 = fallTime((&param_1), (&param_2));
    t_2 = _e68;
    let _e69 = t_2;
    if (_e69 >= 1f) {
        let _e71 = none;
        return _e71;
    }
    let _e72 = t_2;
    param_3 = _e72;
    let _e73 = fallAngle((&param_3));
    a = _e73;
    let _e74 = a;
    c = cos(_e74);
    let _e76 = a;
    s_1 = sin(_e76);
    let _e78 = (*j_2);
    let _e80 = (*w_1);
    let _e82 = c;
    let _e85 = uniforms.perspective;
    eye = vec3<f32>(((_e78 + 0.5f) * _e80), (0.5f * _e82), (-1f / max(_e85, 0.01f)));
    let _e89 = (*xc);
    let _e90 = (*y);
    let _e92 = eye;
    dir = (vec3<f32>(_e89, _e90, 0f) - _e92);
    let _e95 = dir[2u];
    let _e96 = c;
    let _e99 = dir[1u];
    let _e100 = s_1;
    den = ((_e95 * _e96) - (_e99 * _e100));
    let _e103 = den;
    if (_e103 <= 0f) {
        let _e105 = none;
        return _e105;
    }
    let _e107 = eye[1u];
    let _e108 = s_1;
    let _e111 = eye[2u];
    let _e112 = c;
    let _e115 = den;
    r = (((_e107 * _e108) - (_e111 * _e112)) / _e115);
    let _e117 = eye;
    let _e118 = r;
    let _e119 = dir;
    hit = (_e117 + (_e119 * _e118));
    let _e123 = hit[1u];
    let _e124 = c;
    let _e127 = hit[2u];
    let _e128 = s_1;
    h = ((_e123 * _e124) + (_e127 * _e128));
    let _e131 = r;
    let _e133 = h;
    if ((_e131 <= 0f) || (_e133 < 0f)) {
        let _e136 = none;
        return _e136;
    }
    let _e138 = uniforms.lean;
    let _e140 = (*w_1);
    let _e142 = t_2;
    let _e143 = knockPart_u0028_();
    let _e147 = h;
    side = (((clamp(_e138, 0f, 1f) * _e140) * min((_e142 / _e143), 1f)) * _e147);
    let _e150 = hit[0u];
    let _e151 = side;
    let _e153 = (*j_2);
    let _e154 = (*w_1);
    let _e157 = h;
    let _e158 = t_2;
    let _e159 = a;
    return vec4<f32>(((_e150 - _e151) - (_e153 * _e154)), _e157, _e158, _e159);
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e38 = (*uv_1)[0u];
    let _e40 = (*uv_1)[1u];
    let _e43 = textureSampleLevel(_to, _sampler, vec2<f32>(_e38, (1f - _e40)), 0f);
    return _e43;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n_2: f32;
    var local_1: i32;
    var w_2: f32;
    var xc_1: f32;
    var local_2: f32;
    var col: f32;
    var color_1: vec4<f32>;
    var param_4: vec2<f32>;
    var t0_: f32;
    var param_5: f32;
    var param_6: f32;
    var cur: vec4<f32>;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: vec4<f32>;
    var param_18: f32;
    var param_19: vec4<f32>;
    var param_20: vec4<f32>;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;
    var param_27: vec4<f32>;
    var param_28: f32;
    var param_29: vec4<f32>;
    var param_30: vec4<f32>;
    var param_31: f32;

    let _e75 = uniforms.count;
    if (_e75 < 1i) {
        local_1 = 1i;
    } else {
        let _e78 = uniforms.count;
        local_1 = _e78;
    }
    let _e79 = local_1;
    n_2 = f32(_e79);
    let _e82 = uniforms.ratio;
    let _e83 = n_2;
    w_2 = (_e82 / _e83);
    let _e86 = uniforms.reverse;
    if (_e86 != 0i) {
        let _e89 = (*uv_2)[0u];
        local_2 = (1f - _e89);
    } else {
        let _e92 = (*uv_2)[0u];
        local_2 = _e92;
    }
    let _e93 = local_2;
    let _e95 = uniforms.ratio;
    xc_1 = (_e93 * _e95);
    let _e97 = xc_1;
    let _e98 = w_2;
    let _e101 = n_2;
    col = clamp(floor((_e97 / _e98)), 0f, (_e101 - 1f));
    let _e104 = (*uv_2);
    param_4 = _e104;
    let _e105 = getToColor((&param_4));
    color_1 = _e105;
    let _e106 = col;
    param_5 = _e106;
    let _e107 = n_2;
    param_6 = _e107;
    let _e108 = fallTime((&param_5), (&param_6));
    t0_ = _e108;
    let _e110 = uniforms.shading;
    let _e112 = t0_;
    let _e114 = t0_;
    let _e118 = (*uv_2)[1u];
    let _e123 = color_1;
    let _e125 = (_e123.xyz * (1f - ((((2.4f * _e110) * _e112) * (1f - _e114)) * exp((-40f * _e118)))));
    color_1[0u] = _e125.x;
    color_1[1u] = _e125.y;
    color_1[2u] = _e125.z;
    let _e132 = col;
    param_7 = _e132;
    let _e133 = n_2;
    param_8 = _e133;
    let _e134 = w_2;
    param_9 = _e134;
    let _e135 = xc_1;
    param_10 = _e135;
    let _e137 = (*uv_2)[1u];
    param_11 = _e137;
    let _e138 = slatPoint((&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
    cur = _e138;
    let _e139 = col;
    let _e141 = col;
    param_12 = (_e141 - 1f);
    let _e143 = n_2;
    param_13 = _e143;
    let _e144 = w_2;
    param_14 = _e144;
    let _e145 = xc_1;
    param_15 = _e145;
    let _e147 = (*uv_2)[1u];
    param_16 = _e147;
    let _e148 = slatPoint((&param_12), (&param_13), (&param_14), (&param_15), (&param_16));
    let _e149 = color_1;
    param_17 = _e149;
    param_18 = (_e139 - 1f);
    param_19 = _e148;
    let _e150 = cur;
    param_20 = _e150;
    let _e151 = w_2;
    param_21 = _e151;
    let _e152 = drawSlat((&param_17), (&param_18), (&param_19), (&param_20), (&param_21));
    color_1 = _e152;
    let _e153 = col;
    param_22 = (_e153 + 1f);
    let _e155 = n_2;
    param_23 = _e155;
    let _e156 = w_2;
    param_24 = _e156;
    let _e157 = xc_1;
    param_25 = _e157;
    let _e159 = (*uv_2)[1u];
    param_26 = _e159;
    let _e160 = slatPoint((&param_22), (&param_23), (&param_24), (&param_25), (&param_26));
    let _e161 = color_1;
    param_27 = _e161;
    let _e162 = col;
    param_28 = _e162;
    let _e163 = cur;
    param_29 = _e163;
    param_30 = _e160;
    let _e164 = w_2;
    param_31 = _e164;
    let _e165 = drawSlat((&param_27), (&param_28), (&param_29), (&param_30), (&param_31));
    color_1 = _e165;
    let _e166 = color_1;
    return _e166;
}

fn main_1() {
    var param_32: vec2<f32>;

    let _e37 = _uv_1;
    param_32 = _e37;
    let _e38 = transition((&param_32));
    _fragColor = _e38;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
