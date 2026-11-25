// TangentMotionBlur — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TangentMotionBlur.glsl
// Author: chenkai
// License: MIT
// Description: The outgoing image is flung away along a curve with motion blur
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e38 = (*uv)[0u];
    let _e40 = (*uv)[1u];
    let _e43 = textureSampleLevel(_to, _sampler, vec2<f32>(_e38, (1f - _e40)), 0f);
    return _e43;
}

fn rand(co: ptr<function, vec2<f32>>) -> f32 {
    let _e37 = (*co);
    return fract((sin(dot(_e37, vec2<f32>(12.9898f, 78.233f))) * 43758.547f));
}

fn motionBlurTo(_st: ptr<function, vec2<f32>>, speed: ptr<function, vec2<f32>>) -> vec4<f32> {
    var texCoord: vec2<f32>;
    var color: vec3<f32>;
    var alpha: f32;
    var total: f32;
    var offset: f32;
    var param: vec2<f32>;
    var t: f32;
    var percent: f32;
    var weight: f32;
    var newuv: vec2<f32>;
    var c: vec4<f32>;
    var param_1: vec2<f32>;

    let _e50 = (*_st);
    texCoord = (_e50 / vec2<f32>(1f, 1f));
    color = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    total = 0f;
    let _e52 = (*_st);
    param = _e52;
    let _e53 = rand((&param));
    offset = _e53;
    t = 0f;
    loop {
        let _e54 = t;
        if (_e54 <= 20f) {
            let _e56 = t;
            let _e57 = offset;
            percent = ((_e56 + _e57) / 20f);
            let _e60 = percent;
            let _e61 = percent;
            let _e62 = percent;
            weight = (4f * (_e60 - (_e61 * _e62)));
            let _e66 = texCoord;
            let _e67 = (*speed);
            let _e68 = percent;
            newuv = (_e66 + (_e67 * _e68));
            let _e71 = newuv;
            newuv = fract(_e71);
            let _e73 = newuv;
            param_1 = _e73;
            let _e74 = getToColor((&param_1));
            c = _e74;
            let _e75 = c;
            let _e78 = c[3u];
            let _e80 = weight;
            let _e82 = color;
            color = (_e82 + ((_e75.xyz * _e78) * _e80));
            let _e85 = c[3u];
            let _e86 = weight;
            let _e88 = alpha;
            alpha = (_e88 + (_e85 * _e86));
            let _e90 = weight;
            let _e91 = total;
            total = (_e91 + _e90);
            continue;
        } else {
            break;
        }
        continuing {
            let _e93 = t;
            t = (_e93 + 1f);
        }
    }
    let _e95 = color;
    let _e96 = alpha;
    let _e99 = (_e95 / vec3(max(_e96, 0.00001f)));
    let _e100 = alpha;
    let _e101 = total;
    return vec4<f32>(_e99.x, _e99.y, _e99.z, (_e100 / _e101));
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e38 = (*uv_1)[0u];
    let _e40 = (*uv_1)[1u];
    let _e43 = textureSampleLevel(_from, _sampler, vec2<f32>(_e38, (1f - _e40)), 0f);
    return _e43;
}

fn motionBlurFrom(_st_1: ptr<function, vec2<f32>>, speed_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    var texCoord_1: vec2<f32>;
    var color_1: vec3<f32>;
    var alpha_1: f32;
    var total_1: f32;
    var offset_1: f32;
    var param_2: vec2<f32>;
    var t_1: f32;
    var percent_1: f32;
    var weight_1: f32;
    var newuv_1: vec2<f32>;
    var c_1: vec4<f32>;
    var param_3: vec2<f32>;

    let _e50 = (*_st_1);
    texCoord_1 = (_e50 / vec2<f32>(1f, 1f));
    color_1 = vec3<f32>(0f, 0f, 0f);
    alpha_1 = 0f;
    total_1 = 0f;
    let _e52 = (*_st_1);
    param_2 = _e52;
    let _e53 = rand((&param_2));
    offset_1 = _e53;
    t_1 = 0f;
    loop {
        let _e54 = t_1;
        if (_e54 <= 20f) {
            let _e56 = t_1;
            let _e57 = offset_1;
            percent_1 = ((_e56 + _e57) / 20f);
            let _e60 = percent_1;
            let _e61 = percent_1;
            let _e62 = percent_1;
            weight_1 = (4f * (_e60 - (_e61 * _e62)));
            let _e66 = texCoord_1;
            let _e67 = (*speed_1);
            let _e68 = percent_1;
            newuv_1 = (_e66 + (_e67 * _e68));
            let _e71 = newuv_1;
            newuv_1 = fract(_e71);
            let _e73 = newuv_1;
            param_3 = _e73;
            let _e74 = getFromColor((&param_3));
            c_1 = _e74;
            let _e75 = c_1;
            let _e78 = c_1[3u];
            let _e80 = weight_1;
            let _e82 = color_1;
            color_1 = (_e82 + ((_e75.xyz * _e78) * _e80));
            let _e85 = c_1[3u];
            let _e86 = weight_1;
            let _e88 = alpha_1;
            alpha_1 = (_e88 + (_e85 * _e86));
            let _e90 = weight_1;
            let _e91 = total_1;
            total_1 = (_e91 + _e90);
            continue;
        } else {
            break;
        }
        continuing {
            let _e93 = t_1;
            t_1 = (_e93 + 1f);
        }
    }
    let _e95 = color_1;
    let _e96 = alpha_1;
    let _e99 = (_e95 / vec3(max(_e96, 0.00001f)));
    let _e100 = alpha_1;
    let _e101 = total_1;
    return vec4<f32>(_e99.x, _e99.y, _e99.z, (_e100 / _e101));
}

fn rotateUv(uv_2: ptr<function, vec2<f32>>, angle: ptr<function, f32>, anchor: ptr<function, vec2<f32>>, zDirection: ptr<function, f32>) -> vec2<f32> {
    var s: f32;
    var c_2: f32;
    var m: mat2x2<f32>;

    let _e43 = (*uv_2);
    let _e44 = (*anchor);
    (*uv_2) = (_e43 - _e44);
    let _e46 = (*angle);
    s = sin(_e46);
    let _e48 = (*angle);
    c_2 = cos(_e48);
    let _e50 = c_2;
    let _e51 = s;
    let _e53 = s;
    let _e54 = c_2;
    m = mat2x2<f32>(vec2<f32>(_e50, -(_e51)), vec2<f32>(_e53, _e54));
    let _e58 = m;
    let _e59 = (*uv_2);
    (*uv_2) = (_e58 * _e59);
    let _e61 = (*anchor);
    let _e62 = (*uv_2);
    (*uv_2) = (_e62 + _e61);
    let _e64 = (*uv_2);
    return _e64;
}

fn normpdf(x: ptr<function, f32>) -> f32 {
    var d: f32;

    let _e38 = (*x);
    d = (_e38 - 0.5f);
    let _e40 = d;
    let _e42 = d;
    return exp(((-20f * _e40) * _e42));
}

fn C(aA1_: ptr<function, f32>) -> f32 {
    let _e37 = (*aA1_);
    return (3f * _e37);
}

fn B(aA1_1: ptr<function, f32>, aA2_: ptr<function, f32>) -> f32 {
    let _e38 = (*aA2_);
    let _e40 = (*aA1_1);
    return ((3f * _e38) - (6f * _e40));
}

fn A(aA1_2: ptr<function, f32>, aA2_1: ptr<function, f32>) -> f32 {
    let _e38 = (*aA2_1);
    let _e41 = (*aA1_2);
    return ((1f - (3f * _e38)) + (3f * _e41));
}

fn CalcBezier(aT: ptr<function, f32>, aA1_3: ptr<function, f32>, aA2_2: ptr<function, f32>) -> f32 {
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;

    let _e44 = (*aA1_3);
    param_4 = _e44;
    let _e45 = (*aA2_2);
    param_5 = _e45;
    let _e46 = A((&param_4), (&param_5));
    let _e47 = (*aT);
    let _e49 = (*aA1_3);
    param_6 = _e49;
    let _e50 = (*aA2_2);
    param_7 = _e50;
    let _e51 = B((&param_6), (&param_7));
    let _e53 = (*aT);
    let _e55 = (*aA1_3);
    param_8 = _e55;
    let _e56 = C((&param_8));
    let _e58 = (*aT);
    return (((((_e46 * _e47) + _e51) * _e53) + _e56) * _e58);
}

fn GetSlope(aT_1: ptr<function, f32>, aA1_4: ptr<function, f32>, aA2_3: ptr<function, f32>) -> f32 {
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;

    let _e44 = (*aA1_4);
    param_9 = _e44;
    let _e45 = (*aA2_3);
    param_10 = _e45;
    let _e46 = A((&param_9), (&param_10));
    let _e48 = (*aT_1);
    let _e50 = (*aT_1);
    let _e52 = (*aA1_4);
    param_11 = _e52;
    let _e53 = (*aA2_3);
    param_12 = _e53;
    let _e54 = B((&param_11), (&param_12));
    let _e56 = (*aT_1);
    let _e59 = (*aA1_4);
    param_13 = _e59;
    let _e60 = C((&param_13));
    return (((((3f * _e46) * _e48) * _e50) + ((2f * _e54) * _e56)) + _e60);
}

fn GetTForX(aX: ptr<function, f32>, mX1_: ptr<function, f32>, mX2_: ptr<function, f32>) -> f32 {
    var aGuessT: f32;
    var i: i32;
    var currentSlope: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var currentX: f32;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;

    let _e49 = (*aX);
    aGuessT = _e49;
    i = 0i;
    loop {
        let _e50 = i;
        if (_e50 < 4i) {
            let _e52 = aGuessT;
            param_14 = _e52;
            let _e53 = (*mX1_);
            param_15 = _e53;
            let _e54 = (*mX2_);
            param_16 = _e54;
            let _e55 = GetSlope((&param_14), (&param_15), (&param_16));
            currentSlope = _e55;
            let _e56 = currentSlope;
            if (_e56 == 0f) {
                let _e58 = aGuessT;
                return _e58;
            }
            let _e59 = aGuessT;
            param_17 = _e59;
            let _e60 = (*mX1_);
            param_18 = _e60;
            let _e61 = (*mX2_);
            param_19 = _e61;
            let _e62 = CalcBezier((&param_17), (&param_18), (&param_19));
            let _e63 = (*aX);
            currentX = (_e62 - _e63);
            let _e65 = currentX;
            let _e66 = currentSlope;
            let _e68 = aGuessT;
            aGuessT = (_e68 - (_e65 / _e66));
            continue;
        } else {
            break;
        }
        continuing {
            let _e70 = i;
            i = (_e70 + 1i);
        }
    }
    let _e72 = aGuessT;
    return _e72;
}

fn KeySpline(aX_1: ptr<function, f32>, mX1_1: ptr<function, f32>, mY1_: ptr<function, f32>, mX2_1: ptr<function, f32>, mY2_: ptr<function, f32>) -> f32 {
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var param_25: f32;

    let _e47 = (*mX1_1);
    let _e48 = (*mY1_);
    let _e50 = (*mX2_1);
    let _e51 = (*mY2_);
    if ((_e47 == _e48) && (_e50 == _e51)) {
        let _e54 = (*aX_1);
        return _e54;
    }
    let _e55 = (*aX_1);
    param_20 = _e55;
    let _e56 = (*mX1_1);
    param_21 = _e56;
    let _e57 = (*mX2_1);
    param_22 = _e57;
    let _e58 = GetTForX((&param_20), (&param_21), (&param_22));
    param_23 = _e58;
    let _e59 = (*mY1_);
    param_24 = _e59;
    let _e60 = (*mY2_);
    param_25 = _e60;
    let _e61 = CalcBezier((&param_23), (&param_24), (&param_25));
    return _e61;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var myst: vec2<f32>;
    var animationTime: f32;
    var easingTime: f32;
    var param_26: f32;
    var param_27: f32;
    var param_28: f32;
    var param_29: f32;
    var param_30: f32;
    var blur: f32;
    var param_31: f32;
    var r: f32;
    var rotation: f32;
    var mystCurrent: vec2<f32>;
    var param_32: vec2<f32>;
    var param_33: f32;
    var param_34: vec2<f32>;
    var param_35: f32;
    var timeInterval: f32;
    var mystNext: vec2<f32>;
    var param_36: vec2<f32>;
    var param_37: f32;
    var param_38: vec2<f32>;
    var param_39: f32;
    var speed_2: vec2<f32>;
    var param_40: vec2<f32>;
    var param_41: vec2<f32>;
    var param_42: vec2<f32>;
    var param_43: vec2<f32>;

    let _e65 = (*uv_3);
    myst = _e65;
    let _e67 = uniforms.progress;
    animationTime = _e67;
    let _e68 = animationTime;
    param_26 = _e68;
    param_27 = 0.68f;
    param_28 = 0.01f;
    param_29 = 0.17f;
    param_30 = 0.98f;
    let _e69 = KeySpline((&param_26), (&param_27), (&param_28), (&param_29), (&param_30));
    easingTime = _e69;
    let _e70 = easingTime;
    param_31 = _e70;
    let _e71 = normpdf((&param_31));
    blur = _e71;
    r = 0f;
    rotation = 3.14159f;
    let _e72 = easingTime;
    if (_e72 <= 0.5f) {
        let _e74 = rotation;
        let _e75 = easingTime;
        r = (_e74 * _e75);
    } else {
        let _e77 = rotation;
        let _e79 = rotation;
        let _e80 = easingTime;
        r = (-(_e77) + (_e79 * _e80));
    }
    let _e83 = myst;
    mystCurrent = _e83;
    let _e85 = uniforms.ratio;
    let _e88 = mystCurrent[1u];
    mystCurrent[1u] = (_e88 * (1f / _e85));
    let _e91 = mystCurrent;
    param_32 = _e91;
    let _e92 = r;
    param_33 = _e92;
    param_34 = vec2<f32>(1f, 0f);
    param_35 = -1f;
    let _e93 = rotateUv((&param_32), (&param_33), (&param_34), (&param_35));
    mystCurrent = _e93;
    let _e95 = uniforms.ratio;
    let _e97 = mystCurrent[1u];
    mystCurrent[1u] = (_e97 * _e95);
    timeInterval = 0.0334f;
    let _e100 = easingTime;
    if (_e100 <= 0.5f) {
        let _e102 = rotation;
        let _e103 = easingTime;
        let _e104 = timeInterval;
        r = (_e102 * (_e103 + _e104));
    } else {
        let _e107 = rotation;
        let _e109 = rotation;
        let _e110 = easingTime;
        let _e111 = timeInterval;
        r = (-(_e107) + (_e109 * (_e110 + _e111)));
    }
    let _e115 = myst;
    mystNext = _e115;
    let _e117 = uniforms.ratio;
    let _e120 = mystNext[1u];
    mystNext[1u] = (_e120 * (1f / _e117));
    let _e123 = mystNext;
    param_36 = _e123;
    let _e124 = r;
    param_37 = _e124;
    param_38 = vec2<f32>(1f, 0f);
    param_39 = -1f;
    let _e125 = rotateUv((&param_36), (&param_37), (&param_38), (&param_39));
    mystNext = _e125;
    let _e127 = uniforms.ratio;
    let _e129 = mystNext[1u];
    mystNext[1u] = (_e129 * _e127);
    let _e132 = mystNext;
    let _e133 = mystCurrent;
    let _e135 = timeInterval;
    let _e138 = blur;
    speed_2 = ((((_e132 - _e133) / vec2(_e135)) * _e138) * 0.5f);
    let _e141 = easingTime;
    if (_e141 <= 0.5f) {
        let _e143 = mystCurrent;
        param_40 = _e143;
        let _e144 = speed_2;
        param_41 = _e144;
        let _e145 = motionBlurFrom((&param_40), (&param_41));
        return _e145;
    } else {
        let _e146 = mystCurrent;
        param_42 = _e146;
        let _e147 = speed_2;
        param_43 = _e147;
        let _e148 = motionBlurTo((&param_42), (&param_43));
        return _e148;
    }
}

fn main_1() {
    var param_44: vec2<f32>;

    let _e37 = _uv_1;
    param_44 = _e37;
    let _e38 = transition((&param_44));
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
