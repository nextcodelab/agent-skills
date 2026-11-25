// Gallery — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Gallery.glsl
// Author: gre
// License: MIT
// Description: The camera pulls back from the outgoing image to show it as a slide hanging in a row on a wall in perspective, the row glides along as each slide turns away from the center, and the camera moves back in on the incoming slide until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: f32,
    tilt: f32,
    gap: f32,
    zoom: f32,
    reflection: f32,
    background: vec4<f32>,
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

fn offset(k: ptr<function, f32>, camQ: ptr<function, f32>, spacing: ptr<function, f32>) -> f32 {
    let _e46 = (*k);
    let _e47 = (*spacing);
    let _e49 = (*camQ);
    let _e51 = (*spacing);
    return clamp((((_e46 * _e47) - _e49) / _e51), -1f, 1f);
}

fn slideHit(o: ptr<function, vec3<f32>>, d: ptr<function, vec3<f32>>, k_1: ptr<function, f32>, s: ptr<function, f32>, camQ_1: ptr<function, f32>, spacing_1: ptr<function, f32>, aa: ptr<function, f32>) -> vec4<f32> {
    var a: f32;
    var param: f32;
    var param_1: f32;
    var param_2: f32;
    var c: vec3<f32>;
    var tg: vec3<f32>;
    var n: vec3<f32>;
    var dn: f32;
    var t: f32;
    var q: vec3<f32>;
    var lx: f32;
    var ly: f32;
    var jx: f32;
    var ex: f32;
    var ey: f32;
    var cov: f32;
    var local: f32;

    let _e67 = (*s);
    let _e71 = uniforms.tilt;
    let _e73 = (*k_1);
    param = _e73;
    let _e74 = (*camQ_1);
    param_1 = _e74;
    let _e75 = (*spacing_1);
    param_2 = _e75;
    let _e76 = offset((&param), (&param_1), (&param_2));
    a = (((-(_e67) * 1.4f) * _e71) * _e76);
    let _e78 = (*s);
    let _e79 = (*k_1);
    let _e81 = (*spacing_1);
    c = vec3<f32>(((_e78 * _e79) * _e81), 0f, 0f);
    let _e84 = a;
    let _e86 = a;
    tg = vec3<f32>(cos(_e84), 0f, sin(_e86));
    let _e90 = tg[2u];
    let _e93 = tg[0u];
    n = vec3<f32>(-(_e90), 0f, _e93);
    let _e95 = (*d);
    let _e96 = n;
    dn = dot(_e95, _e96);
    let _e98 = dn;
    if (abs(_e98) < 0.00001f) {
        return vec4<f32>(0f, 0f, -1f, 0f);
    }
    let _e101 = c;
    let _e102 = (*o);
    let _e104 = n;
    let _e106 = dn;
    t = (dot((_e101 - _e102), _e104) / _e106);
    let _e108 = (*o);
    let _e109 = (*d);
    let _e110 = t;
    let _e113 = c;
    q = ((_e108 + (_e109 * _e110)) - _e113);
    let _e115 = q;
    let _e116 = tg;
    let _e119 = uniforms.ratio;
    lx = (dot(_e115, _e116) + (0.5f * _e119));
    let _e123 = q[1u];
    ly = (_e123 + 0.5f);
    let _e125 = t;
    let _e127 = tg[0u];
    let _e128 = (*d);
    let _e129 = tg;
    let _e132 = n[0u];
    let _e134 = dn;
    jx = abs((_e125 * (_e127 - ((dot(_e128, _e129) * _e132) / _e134))));
    let _e139 = lx;
    let _e141 = uniforms.ratio;
    let _e142 = lx;
    let _e145 = jx;
    ex = (min(_e139, (_e141 - _e142)) / max(_e145, 0.000001f));
    let _e148 = ly;
    let _e149 = ly;
    let _e152 = t;
    ey = (min(_e148, (1f - _e149)) / max(_e152, 0.000001f));
    let _e155 = t;
    if (_e155 > 0f) {
        let _e157 = ex;
        let _e158 = ey;
        let _e160 = (*aa);
        local = clamp((0.5f + (min(_e157, _e158) / _e160)), 0f, 1f);
    } else {
        local = 0f;
    }
    let _e164 = local;
    cov = _e164;
    let _e165 = lx;
    let _e167 = uniforms.ratio;
    let _e169 = ly;
    let _e170 = t;
    let _e171 = cov;
    return vec4<f32>((_e165 / _e167), _e169, _e170, _e171);
}

fn sceneCover(o_1: ptr<function, vec3<f32>>, d_1: ptr<function, vec3<f32>>, s_1: ptr<function, f32>, camQ_2: ptr<function, f32>, spacing_2: ptr<function, f32>, aa_1: ptr<function, f32>) -> f32 {
    var kc: f32;
    var w0_: f32;
    var param_3: vec3<f32>;
    var param_4: vec3<f32>;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var w1_: f32;
    var param_10: vec3<f32>;
    var param_11: vec3<f32>;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var w2_: f32;
    var param_17: vec3<f32>;
    var param_18: vec3<f32>;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;

    let _e74 = (*s_1);
    let _e76 = (*o_1)[0u];
    let _e78 = (*d_1)[0u];
    let _e80 = (*o_1)[2u];
    let _e83 = (*d_1)[2u];
    let _e88 = (*spacing_2);
    kc = floor((((_e74 * (_e76 + ((_e78 * _e80) / -(_e83)))) / _e88) + 0.5f));
    let _e92 = kc;
    let _e94 = (*o_1);
    param_3 = _e94;
    let _e95 = (*d_1);
    param_4 = _e95;
    param_5 = (_e92 - 1f);
    let _e96 = (*s_1);
    param_6 = _e96;
    let _e97 = (*camQ_2);
    param_7 = _e97;
    let _e98 = (*spacing_2);
    param_8 = _e98;
    let _e99 = (*aa_1);
    param_9 = _e99;
    let _e100 = slideHit((&param_3), (&param_4), (&param_5), (&param_6), (&param_7), (&param_8), (&param_9));
    w0_ = _e100.w;
    let _e102 = (*o_1);
    param_10 = _e102;
    let _e103 = (*d_1);
    param_11 = _e103;
    let _e104 = kc;
    param_12 = _e104;
    let _e105 = (*s_1);
    param_13 = _e105;
    let _e106 = (*camQ_2);
    param_14 = _e106;
    let _e107 = (*spacing_2);
    param_15 = _e107;
    let _e108 = (*aa_1);
    param_16 = _e108;
    let _e109 = slideHit((&param_10), (&param_11), (&param_12), (&param_13), (&param_14), (&param_15), (&param_16));
    w1_ = _e109.w;
    let _e111 = kc;
    let _e113 = (*o_1);
    param_17 = _e113;
    let _e114 = (*d_1);
    param_18 = _e114;
    param_19 = (_e111 + 1f);
    let _e115 = (*s_1);
    param_20 = _e115;
    let _e116 = (*camQ_2);
    param_21 = _e116;
    let _e117 = (*spacing_2);
    param_22 = _e117;
    let _e118 = (*aa_1);
    param_23 = _e118;
    let _e119 = slideHit((&param_17), (&param_18), (&param_19), (&param_20), (&param_21), (&param_22), (&param_23));
    w2_ = _e119.w;
    let _e121 = w0_;
    let _e123 = w1_;
    let _e126 = w2_;
    return (1f - (((1f - _e121) * (1f - _e123)) * (1f - _e126)));
}

fn premultiply(c_1: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e44 = (*c_1);
    let _e47 = (*c_1)[3u];
    let _e48 = (_e44.xyz * _e47);
    let _e50 = (*c_1)[3u];
    return vec4<f32>(_e48.x, _e48.y, _e48.z, _e50);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e45 = (*uv)[0u];
    let _e47 = (*uv)[1u];
    let _e50 = textureSampleLevel(_to, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e45 = (*uv_1)[0u];
    let _e47 = (*uv_1)[1u];
    let _e50 = textureSampleLevel(_from, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn slideColor(h: ptr<function, vec4<f32>>, k_2: ptr<function, f32>, camQ_3: ptr<function, f32>, spacing_3: ptr<function, f32>, refl: ptr<function, f32>, bg: ptr<function, vec4<f32>>) -> vec4<f32> {
    var st: vec2<f32>;
    var c_2: vec4<f32>;
    var local_1: vec4<f32>;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: vec4<f32>;
    var param_27: f32;
    var param_28: f32;
    var param_29: f32;
    var f: f32;
    var local_2: f32;

    let _e61 = (*h)[3u];
    if (_e61 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e63 = (*h);
    st = clamp(_e63.xy, vec2(0f), vec2(1f));
    let _e68 = (*k_2);
    if (_e68 < 0.5f) {
        let _e70 = st;
        param_24 = _e70;
        let _e71 = getFromColor((&param_24));
        local_1 = _e71;
    } else {
        let _e72 = st;
        param_25 = _e72;
        let _e73 = getToColor((&param_25));
        local_1 = _e73;
    }
    let _e74 = local_1;
    param_26 = _e74;
    let _e75 = premultiply((&param_26));
    c_2 = _e75;
    let _e77 = uniforms.tilt;
    let _e79 = (*k_2);
    param_27 = _e79;
    let _e80 = (*camQ_3);
    param_28 = _e80;
    let _e81 = (*spacing_3);
    param_29 = _e81;
    let _e82 = offset((&param_27), (&param_28), (&param_29));
    let _e86 = c_2;
    let _e88 = (_e86.xyz * (1f - ((0.3f * _e77) * abs(_e82))));
    c_2[0u] = _e88.x;
    c_2[1u] = _e88.y;
    c_2[2u] = _e88.z;
    let _e95 = (*k_2);
    let _e97 = (*k_2);
    if ((_e95 < -0.5f) || (_e97 > 1.5f)) {
        let _e100 = (*bg);
        let _e101 = c_2;
        c_2 = mix(_e100, _e101, vec4(0.3f));
    }
    let _e104 = (*refl);
    if (_e104 > 0f) {
        let _e106 = (*refl);
        let _e108 = st[1u];
        local_2 = (_e106 * (1f - smoothstep(0f, 0.6f, _e108)));
    } else {
        local_2 = 1f;
    }
    let _e112 = local_2;
    f = _e112;
    let _e113 = c_2;
    let _e115 = (*h)[3u];
    let _e116 = f;
    return (_e113 * (_e115 * _e116));
}

fn scene(o_2: ptr<function, vec3<f32>>, d_2: ptr<function, vec3<f32>>, s_2: ptr<function, f32>, camQ_4: ptr<function, f32>, spacing_4: ptr<function, f32>, aa_2: ptr<function, f32>, refl_1: ptr<function, f32>, bg_1: ptr<function, vec4<f32>>) -> vec4<f32> {
    var wallQ: f32;
    var kc_1: f32;
    var h0_: vec4<f32>;
    var param_30: vec3<f32>;
    var param_31: vec3<f32>;
    var param_32: f32;
    var param_33: f32;
    var param_34: f32;
    var param_35: f32;
    var param_36: f32;
    var h1_: vec4<f32>;
    var param_37: vec3<f32>;
    var param_38: vec3<f32>;
    var param_39: f32;
    var param_40: f32;
    var param_41: f32;
    var param_42: f32;
    var param_43: f32;
    var h2_: vec4<f32>;
    var param_44: vec3<f32>;
    var param_45: vec3<f32>;
    var param_46: f32;
    var param_47: f32;
    var param_48: f32;
    var param_49: f32;
    var param_50: f32;
    var c0_: vec4<f32>;
    var param_51: vec4<f32>;
    var param_52: f32;
    var param_53: f32;
    var param_54: f32;
    var param_55: f32;
    var param_56: vec4<f32>;
    var c1_: vec4<f32>;
    var param_57: vec4<f32>;
    var param_58: f32;
    var param_59: f32;
    var param_60: f32;
    var param_61: f32;
    var param_62: vec4<f32>;
    var c2_: vec4<f32>;
    var param_63: vec4<f32>;
    var param_64: f32;
    var param_65: f32;
    var param_66: f32;
    var param_67: f32;
    var param_68: vec4<f32>;
    var t0_: f32;
    var local_3: f32;
    var t1_: f32;
    var local_4: f32;
    var t2_: f32;
    var local_5: f32;
    var tc: vec4<f32>;
    var tt: f32;
    var col: vec4<f32>;

    let _e107 = (*s_2);
    let _e109 = (*o_2)[0u];
    let _e111 = (*d_2)[0u];
    let _e113 = (*o_2)[2u];
    let _e116 = (*d_2)[2u];
    wallQ = (_e107 * (_e109 + ((_e111 * _e113) / -(_e116))));
    let _e121 = wallQ;
    let _e122 = (*spacing_4);
    kc_1 = floor(((_e121 / _e122) + 0.5f));
    let _e126 = kc_1;
    let _e128 = (*o_2);
    param_30 = _e128;
    let _e129 = (*d_2);
    param_31 = _e129;
    param_32 = (_e126 - 1f);
    let _e130 = (*s_2);
    param_33 = _e130;
    let _e131 = (*camQ_4);
    param_34 = _e131;
    let _e132 = (*spacing_4);
    param_35 = _e132;
    let _e133 = (*aa_2);
    param_36 = _e133;
    let _e134 = slideHit((&param_30), (&param_31), (&param_32), (&param_33), (&param_34), (&param_35), (&param_36));
    h0_ = _e134;
    let _e135 = (*o_2);
    param_37 = _e135;
    let _e136 = (*d_2);
    param_38 = _e136;
    let _e137 = kc_1;
    param_39 = _e137;
    let _e138 = (*s_2);
    param_40 = _e138;
    let _e139 = (*camQ_4);
    param_41 = _e139;
    let _e140 = (*spacing_4);
    param_42 = _e140;
    let _e141 = (*aa_2);
    param_43 = _e141;
    let _e142 = slideHit((&param_37), (&param_38), (&param_39), (&param_40), (&param_41), (&param_42), (&param_43));
    h1_ = _e142;
    let _e143 = kc_1;
    let _e145 = (*o_2);
    param_44 = _e145;
    let _e146 = (*d_2);
    param_45 = _e146;
    param_46 = (_e143 + 1f);
    let _e147 = (*s_2);
    param_47 = _e147;
    let _e148 = (*camQ_4);
    param_48 = _e148;
    let _e149 = (*spacing_4);
    param_49 = _e149;
    let _e150 = (*aa_2);
    param_50 = _e150;
    let _e151 = slideHit((&param_44), (&param_45), (&param_46), (&param_47), (&param_48), (&param_49), (&param_50));
    h2_ = _e151;
    let _e152 = kc_1;
    let _e154 = h0_;
    param_51 = _e154;
    param_52 = (_e152 - 1f);
    let _e155 = (*camQ_4);
    param_53 = _e155;
    let _e156 = (*spacing_4);
    param_54 = _e156;
    let _e157 = (*refl_1);
    param_55 = _e157;
    let _e158 = (*bg_1);
    param_56 = _e158;
    let _e159 = slideColor((&param_51), (&param_52), (&param_53), (&param_54), (&param_55), (&param_56));
    c0_ = _e159;
    let _e160 = h1_;
    param_57 = _e160;
    let _e161 = kc_1;
    param_58 = _e161;
    let _e162 = (*camQ_4);
    param_59 = _e162;
    let _e163 = (*spacing_4);
    param_60 = _e163;
    let _e164 = (*refl_1);
    param_61 = _e164;
    let _e165 = (*bg_1);
    param_62 = _e165;
    let _e166 = slideColor((&param_57), (&param_58), (&param_59), (&param_60), (&param_61), (&param_62));
    c1_ = _e166;
    let _e167 = kc_1;
    let _e169 = h2_;
    param_63 = _e169;
    param_64 = (_e167 + 1f);
    let _e170 = (*camQ_4);
    param_65 = _e170;
    let _e171 = (*spacing_4);
    param_66 = _e171;
    let _e172 = (*refl_1);
    param_67 = _e172;
    let _e173 = (*bg_1);
    param_68 = _e173;
    let _e174 = slideColor((&param_63), (&param_64), (&param_65), (&param_66), (&param_67), (&param_68));
    c2_ = _e174;
    let _e176 = h0_[3u];
    if (_e176 > 0f) {
        let _e179 = h0_[2u];
        local_3 = _e179;
    } else {
        local_3 = 1000000f;
    }
    let _e180 = local_3;
    t0_ = _e180;
    let _e182 = h1_[3u];
    if (_e182 > 0f) {
        let _e185 = h1_[2u];
        local_4 = _e185;
    } else {
        local_4 = 1000000f;
    }
    let _e186 = local_4;
    t1_ = _e186;
    let _e188 = h2_[3u];
    if (_e188 > 0f) {
        let _e191 = h2_[2u];
        local_5 = _e191;
    } else {
        local_5 = 1000000f;
    }
    let _e192 = local_5;
    t2_ = _e192;
    let _e193 = t0_;
    let _e194 = t1_;
    if (_e193 < _e194) {
        let _e196 = c0_;
        tc = _e196;
        let _e197 = c1_;
        c0_ = _e197;
        let _e198 = tc;
        c1_ = _e198;
        let _e199 = t0_;
        tt = _e199;
        let _e200 = t1_;
        t0_ = _e200;
        let _e201 = tt;
        t1_ = _e201;
    }
    let _e202 = t1_;
    let _e203 = t2_;
    if (_e202 < _e203) {
        let _e205 = c1_;
        tc = _e205;
        let _e206 = c2_;
        c1_ = _e206;
        let _e207 = tc;
        c2_ = _e207;
        let _e208 = t1_;
        tt = _e208;
        let _e209 = t2_;
        t1_ = _e209;
        let _e210 = tt;
        t2_ = _e210;
    }
    let _e211 = t0_;
    let _e212 = t1_;
    if (_e211 < _e212) {
        let _e214 = c0_;
        tc = _e214;
        let _e215 = c1_;
        c0_ = _e215;
        let _e216 = tc;
        c1_ = _e216;
    }
    let _e217 = c0_;
    col = _e217;
    let _e218 = c1_;
    let _e219 = col;
    let _e221 = c1_[3u];
    col = (_e218 + (_e219 * (1f - _e221)));
    let _e225 = c2_;
    let _e226 = col;
    let _e228 = c2_[3u];
    col = (_e225 + (_e226 * (1f - _e228)));
    let _e232 = col;
    return _e232;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var s_3: f32;
    var spacing_5: f32;
    var back: f32;
    var m: f32;
    var glide: f32;
    var camQ_5: f32;
    var o_3: vec3<f32>;
    var d_3: vec3<f32>;
    var amount: f32;
    var aa_3: f32;
    var bg_2: vec4<f32>;
    var param_69: vec4<f32>;
    var col_1: vec4<f32>;
    var param_70: vec3<f32>;
    var param_71: vec3<f32>;
    var param_72: f32;
    var param_73: f32;
    var param_74: f32;
    var param_75: f32;
    var param_76: f32;
    var param_77: vec4<f32>;
    var under: vec4<f32>;
    var r: vec4<f32>;
    var param_78: vec3<f32>;
    var param_79: vec3<f32>;
    var param_80: f32;
    var param_81: f32;
    var param_82: f32;
    var param_83: f32;
    var param_84: f32;
    var param_85: vec4<f32>;
    var param_86: vec3<f32>;
    var param_87: vec3<f32>;
    var param_88: f32;
    var param_89: f32;
    var param_90: f32;
    var param_91: f32;
    var local_6: vec4<f32>;
    var phi_780_: bool;

    let _e84 = uniforms.progress;
    p = _e84;
    let _e86 = uniforms.direction;
    s_3 = select(1f, -1f, (_e86 < 0f));
    let _e90 = uniforms.ratio;
    let _e92 = uniforms.gap;
    spacing_5 = (_e90 * (1f + _e92));
    let _e95 = p;
    let _e97 = p;
    back = (smoothstep(0f, 0.42f, _e95) * (1f - smoothstep(0.58f, 1f, _e97)));
    let _e101 = p;
    m = clamp(((_e101 - 0.18f) / 0.64f), 0f, 1f);
    let _e105 = m;
    let _e106 = m;
    let _e108 = m;
    let _e110 = m;
    let _e111 = m;
    glide = (((_e105 * _e106) * _e108) * ((_e110 * ((_e111 * 6f) - 15f)) + 10f));
    let _e117 = spacing_5;
    let _e118 = glide;
    camQ_5 = (_e117 * _e118);
    let _e120 = s_3;
    let _e121 = camQ_5;
    let _e124 = uniforms.zoom;
    let _e125 = back;
    o_3 = vec3<f32>((_e120 * _e121), 0f, (1.6f * (1f + (_e124 * _e125))));
    let _e130 = (*uv_2);
    let _e134 = uniforms.ratio;
    let _e136 = ((_e130 - vec2(0.5f)) * vec2<f32>(_e134, 1f));
    d_3 = vec3<f32>(_e136.x, _e136.y, -1.6f);
    let _e140 = back;
    amount = min(1f, (40f * _e140));
    let _e143 = amount;
    aa_3 = max((0.002f * _e143), 0.000001f);
    let _e147 = uniforms.background;
    param_69 = _e147;
    let _e148 = premultiply((&param_69));
    bg_2 = _e148;
    let _e149 = o_3;
    param_70 = _e149;
    let _e150 = d_3;
    param_71 = _e150;
    let _e151 = s_3;
    param_72 = _e151;
    let _e152 = camQ_5;
    param_73 = _e152;
    let _e153 = spacing_5;
    param_74 = _e153;
    let _e154 = aa_3;
    param_75 = _e154;
    param_76 = 0f;
    let _e155 = bg_2;
    param_77 = _e155;
    let _e156 = scene((&param_70), (&param_71), (&param_72), (&param_73), (&param_74), (&param_75), (&param_76), (&param_77));
    col_1 = _e156;
    let _e158 = col_1[3u];
    if (_e158 < 1f) {
        let _e160 = bg_2;
        under = _e160;
        let _e162 = d_3[1u];
        let _e163 = (_e162 < 0f);
        phi_780_ = _e163;
        if _e163 {
            let _e165 = uniforms.reflection;
            phi_780_ = (_e165 > 0f);
        }
        let _e168 = phi_780_;
        if _e168 {
            let _e170 = o_3[0u];
            let _e172 = o_3[1u];
            let _e175 = o_3[2u];
            let _e178 = d_3[0u];
            let _e180 = d_3[1u];
            let _e183 = d_3[2u];
            param_78 = vec3<f32>(_e170, (-1f - _e172), _e175);
            param_79 = vec3<f32>(_e178, -(_e180), _e183);
            let _e185 = s_3;
            param_80 = _e185;
            let _e186 = camQ_5;
            param_81 = _e186;
            let _e187 = spacing_5;
            param_82 = _e187;
            let _e188 = aa_3;
            param_83 = _e188;
            let _e190 = uniforms.reflection;
            param_84 = _e190;
            let _e191 = bg_2;
            param_85 = _e191;
            let _e192 = scene((&param_78), (&param_79), (&param_80), (&param_81), (&param_82), (&param_83), (&param_84), (&param_85));
            r = _e192;
            let _e193 = r;
            let _e194 = bg_2;
            let _e196 = r[3u];
            under = (_e193 + (_e194 * (1f - _e196)));
        }
        let _e200 = under;
        let _e201 = amount;
        let _e202 = o_3;
        param_86 = _e202;
        let _e203 = d_3;
        param_87 = _e203;
        let _e204 = s_3;
        param_88 = _e204;
        let _e205 = camQ_5;
        param_89 = _e205;
        let _e206 = spacing_5;
        param_90 = _e206;
        let _e207 = aa_3;
        param_91 = _e207;
        let _e208 = sceneCover((&param_86), (&param_87), (&param_88), (&param_89), (&param_90), (&param_91));
        let _e211 = col_1[3u];
        let _e215 = col_1;
        col_1 = (_e215 + (_e200 * (mix(1f, _e201, _e208) * (1f - _e211))));
    }
    let _e218 = col_1[3u];
    if (_e218 > 0f) {
        let _e220 = col_1;
        let _e223 = col_1[3u];
        let _e225 = (_e220.xyz / vec3(_e223));
        let _e227 = col_1[3u];
        local_6 = vec4<f32>(_e225.x, _e225.y, _e225.z, _e227);
    } else {
        local_6 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e232 = local_6;
    return _e232;
}

fn main_1() {
    var param_92: vec2<f32>;

    let _e44 = _uv_1;
    param_92 = _e44;
    let _e45 = transition((&param_92));
    _fragColor = _e45;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
