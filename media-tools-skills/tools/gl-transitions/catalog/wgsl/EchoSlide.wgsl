// EchoSlide — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/EchoSlide.glsl
// Author: gre
// License: MIT
// Description: The outgoing image slides away leaving a trail of discrete fading copies of itself, a stroboscopic echo, and the incoming image's echoes converge into place
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    echoes: i32,
    trail: f32,
    decay: f32,
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
    let _e32 = (*uv)[0u];
    let _e34 = (*uv)[1u];
    let _e37 = textureSampleLevel(_from, _sampler, vec2<f32>(_e32, (1f - _e34)), 0f);
    return _e37;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e32 = (*uv_1)[0u];
    let _e34 = (*uv_1)[1u];
    let _e37 = textureSampleLevel(_to, _sampler, vec2<f32>(_e32, (1f - _e34)), 0f);
    return _e37;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e31 = (*v);
    let _e32 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e31 - (floor((_e31 / _e32)) * _e32)))));
}

fn easeInOut(t: ptr<function, f32>) -> f32 {
    let _e31 = (*t);
    let _e32 = (*t);
    let _e34 = (*t);
    return ((_e31 * _e32) * (3f - (2f * _e34)));
}

fn edgeAt(t_1: ptr<function, f32>) -> f32 {
    var param: f32;

    let _e32 = (*t_1);
    param = clamp(_e32, 0f, 1f);
    let _e34 = easeInOut((&param));
    return _e34;
}

fn echoStep(uv_2: ptr<function, vec2<f32>>, s: ptr<function, f32>, shift: ptr<function, vec2<f32>>, j: ptr<function, f32>, t0_: ptr<function, f32>, lag: ptr<function, f32>, n: ptr<function, f32>) -> vec4<f32> {
    var e0_: f32;
    var param_1: f32;
    var e1_: f32;
    var param_2: f32;
    var a: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var b: vec4<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var c: vec4<f32>;

    let _e48 = (*t0_);
    let _e49 = (*j);
    let _e50 = (*lag);
    param_1 = (_e48 + (_e49 * _e50));
    let _e53 = edgeAt((&param_1));
    e0_ = _e53;
    let _e54 = (*t0_);
    let _e55 = (*j);
    let _e57 = (*lag);
    param_2 = (_e54 + ((_e55 + 1f) * _e57));
    let _e60 = edgeAt((&param_2));
    e1_ = _e60;
    let _e61 = (*uv_2);
    let _e62 = (*shift);
    let _e63 = e0_;
    param_3 = (_e61 - (_e62 * _e63));
    let _e66 = mirror((&param_3));
    param_4 = _e66;
    let _e67 = getFromColor((&param_4));
    a = _e67;
    let _e68 = (*uv_2);
    let _e69 = (*shift);
    let _e70 = e1_;
    param_5 = (_e68 - (_e69 * (_e70 - 1f)));
    let _e74 = mirror((&param_5));
    param_6 = _e74;
    let _e75 = getToColor((&param_6));
    b = _e75;
    let _e76 = b;
    let _e77 = a;
    let _e78 = (*j);
    let _e80 = (*n);
    let _e83 = uniforms.decay;
    c = mix(_e76, _e77, vec4(pow(((_e78 + 0.5f) / _e80), (0.5f + (2f * clamp(_e83, 0f, 1f))))));
    let _e90 = e1_;
    let _e91 = (*s);
    let _e98 = e1_;
    let _e99 = e0_;
    let _e105 = c;
    let _e107 = (_e105.xyz * (1f - ((0.25f * exp((-(max((_e90 - _e91), 0f)) / 0.02f))) * min(((_e98 - _e99) / 0.02f), 1f))));
    c[0u] = _e107.x;
    c[1u] = _e107.y;
    c[2u] = _e107.z;
    let _e114 = c;
    return _e114;
}

fn past(s_1: ptr<function, f32>, x: ptr<function, f32>) -> f32 {
    var local: f32;
    var local_1: f32;

    let _e34 = (*x);
    if (_e34 <= 0f) {
        local = 1f;
    } else {
        let _e36 = (*x);
        if (_e36 >= 1f) {
            local_1 = 0f;
        } else {
            let _e38 = (*s_1);
            let _e39 = (*x);
            local_1 = clamp((((_e38 - _e39) / 0.002f) + 0.5f), 0f, 1f);
        }
        let _e44 = local_1;
        local = _e44;
    }
    let _e45 = local;
    return _e45;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dl: f32;
    var d: vec2<f32>;
    var local_2: vec2<f32>;
    var ext: f32;
    var shift_1: vec2<f32>;
    var s_2: f32;
    var n_1: f32;
    var tr: f32;
    var lag_1: f32;
    var t0_1: f32;
    var local_3: f32;
    var eIn: f32;
    var param_7: f32;
    var eOut: f32;
    var param_8: f32;
    var wIn: f32;
    var param_9: f32;
    var param_10: f32;
    var wOut: f32;
    var param_11: f32;
    var param_12: f32;
    var wGap: f32;
    var c_1: vec4<f32>;
    var jf: f32;
    var k: i32;
    var m: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var j_1: f32;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: vec2<f32>;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: vec2<f32>;
    var param_24: f32;
    var param_25: vec2<f32>;
    var param_26: f32;
    var param_27: f32;
    var param_28: f32;
    var param_29: f32;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;
    var param_32: vec2<f32>;
    var param_33: vec2<f32>;

    let _e80 = uniforms.direction;
    dl = length(_e80);
    let _e82 = dl;
    if (_e82 > 0.000001f) {
        let _e85 = uniforms.direction;
        let _e86 = dl;
        local_2 = (_e85 / vec2(_e86));
    } else {
        local_2 = vec2<f32>(1f, 0f);
    }
    let _e89 = local_2;
    d = _e89;
    let _e91 = d[0u];
    let _e94 = d[1u];
    ext = (abs(_e91) + abs(_e94));
    let _e97 = d;
    let _e98 = ext;
    shift_1 = (_e97 * _e98);
    let _e100 = (*uv_3);
    let _e103 = d;
    let _e105 = ext;
    s_2 = (0.5f + (dot((_e100 - vec2(0.5f)), _e103) / _e105));
    let _e109 = uniforms.echoes;
    n_1 = clamp(f32(_e109), 1f, 7f);
    let _e113 = uniforms.trail;
    tr = clamp(_e113, 0.05f, 0.6f);
    let _e115 = tr;
    let _e116 = n_1;
    lag_1 = (_e115 / _e116);
    let _e119 = uniforms.progress;
    if (_e119 >= 1f) {
        local_3 = 1f;
    } else {
        let _e122 = uniforms.progress;
        let _e123 = tr;
        let _e126 = tr;
        local_3 = ((_e122 * (1f + _e123)) - _e126);
    }
    let _e128 = local_3;
    t0_1 = _e128;
    let _e129 = t0_1;
    param_7 = _e129;
    let _e130 = edgeAt((&param_7));
    eIn = _e130;
    let _e131 = t0_1;
    let _e132 = tr;
    param_8 = (_e131 + _e132);
    let _e134 = edgeAt((&param_8));
    eOut = _e134;
    let _e135 = s_2;
    param_9 = _e135;
    let _e136 = eIn;
    param_10 = _e136;
    let _e137 = past((&param_9), (&param_10));
    wIn = (1f - _e137);
    let _e139 = s_2;
    param_11 = _e139;
    let _e140 = eOut;
    param_12 = _e140;
    let _e141 = past((&param_11), (&param_12));
    wOut = _e141;
    let _e142 = wIn;
    let _e144 = wOut;
    wGap = max(((1f - _e142) - _e144), 0f);
    c_1 = vec4<f32>(0f, 0f, 0f, 0f);
    let _e147 = wGap;
    if (_e147 > 0f) {
        jf = 0f;
        k = 1i;
        loop {
            let _e149 = k;
            if (_e149 < 7i) {
                let _e151 = k;
                m = f32(_e151);
                let _e153 = m;
                let _e154 = n_1;
                if (_e153 >= _e154) {
                    break;
                }
                let _e156 = t0_1;
                let _e157 = m;
                let _e158 = lag_1;
                param_13 = (_e156 + (_e157 * _e158));
                let _e161 = edgeAt((&param_13));
                let _e162 = s_2;
                param_14 = _e162;
                param_15 = _e161;
                let _e163 = past((&param_14), (&param_15));
                let _e164 = jf;
                jf = (_e164 + _e163);
                continue;
            } else {
                break;
            }
            continuing {
                let _e166 = k;
                k = (_e166 + 1i);
            }
        }
        let _e168 = jf;
        j_1 = floor(_e168);
        let _e170 = (*uv_3);
        param_16 = _e170;
        let _e171 = s_2;
        param_17 = _e171;
        let _e172 = shift_1;
        param_18 = _e172;
        let _e173 = j_1;
        param_19 = _e173;
        let _e174 = t0_1;
        param_20 = _e174;
        let _e175 = lag_1;
        param_21 = _e175;
        let _e176 = n_1;
        param_22 = _e176;
        let _e177 = echoStep((&param_16), (&param_17), (&param_18), (&param_19), (&param_20), (&param_21), (&param_22));
        c_1 = _e177;
        let _e178 = jf;
        let _e179 = j_1;
        if (_e178 > _e179) {
            let _e181 = c_1;
            let _e182 = j_1;
            let _e184 = (*uv_3);
            param_23 = _e184;
            let _e185 = s_2;
            param_24 = _e185;
            let _e186 = shift_1;
            param_25 = _e186;
            param_26 = (_e182 + 1f);
            let _e187 = t0_1;
            param_27 = _e187;
            let _e188 = lag_1;
            param_28 = _e188;
            let _e189 = n_1;
            param_29 = _e189;
            let _e190 = echoStep((&param_23), (&param_24), (&param_25), (&param_26), (&param_27), (&param_28), (&param_29));
            let _e191 = jf;
            let _e192 = j_1;
            c_1 = mix(_e181, _e190, vec4((_e191 - _e192)));
        }
        let _e196 = wGap;
        let _e197 = c_1;
        c_1 = (_e197 * _e196);
    }
    let _e199 = wIn;
    if (_e199 > 0f) {
        let _e201 = wIn;
        let _e202 = (*uv_3);
        let _e203 = shift_1;
        let _e204 = eIn;
        param_30 = (_e202 - (_e203 * (_e204 - 1f)));
        let _e208 = mirror((&param_30));
        param_31 = _e208;
        let _e209 = getToColor((&param_31));
        let _e211 = c_1;
        c_1 = (_e211 + (_e209 * _e201));
    }
    let _e213 = wOut;
    if (_e213 > 0f) {
        let _e215 = wOut;
        let _e216 = (*uv_3);
        let _e217 = shift_1;
        let _e218 = eOut;
        param_32 = (_e216 - (_e217 * _e218));
        let _e221 = mirror((&param_32));
        param_33 = _e221;
        let _e222 = getFromColor((&param_33));
        let _e224 = c_1;
        c_1 = (_e224 + (_e222 * _e215));
    }
    let _e226 = c_1;
    return _e226;
}

fn main_1() {
    var param_34: vec2<f32>;

    let _e31 = _uv_1;
    param_34 = _e31;
    let _e32 = transition((&param_34));
    _fragColor = _e32;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
