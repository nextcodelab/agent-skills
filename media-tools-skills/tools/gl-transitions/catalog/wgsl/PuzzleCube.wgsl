// PuzzleCube — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PuzzleCube.glsl
// Author: gre
// License: MIT
// Description: The frame becomes the face of a twisty cube puzzle: dark gaps open between its cubies, then whole columns and rows of cubies turn a quarter turn around the cube one after another in 3D, each bringing the incoming image from the cube's side to the front, until the gaps close on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    size: i32,
    gap: f32,
    shading: f32,
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

fn faceMask(fp: ptr<function, vec2<f32>>, n: ptr<function, f32>, g: ptr<function, f32>) -> f32 {
    var cell: vec2<f32>;
    var c: vec2<f32>;
    var r: vec2<f32>;
    var d: vec2<f32>;
    var local: f32;
    var local_1: f32;
    var e: f32;
    var phi_336_: bool;
    var phi_356_: bool;

    let _e65 = (*g);
    if (_e65 <= 0f) {
        return 1f;
    }
    let _e68 = uniforms.ratio;
    let _e70 = (*n);
    cell = (vec2<f32>(_e68, 1f) / vec2(_e70));
    let _e73 = (*fp);
    let _e74 = cell;
    c = (_e73 / _e74);
    let _e76 = c;
    r = floor((_e76 + vec2(0.5f)));
    let _e80 = c;
    let _e81 = r;
    let _e84 = cell;
    d = (abs((_e80 - _e81)) * _e84);
    let _e87 = r[0u];
    let _e88 = (_e87 < 0.5f);
    phi_336_ = _e88;
    if !(_e88) {
        let _e91 = r[0u];
        let _e92 = (*n);
        phi_336_ = (_e91 > (_e92 - 0.5f));
    }
    let _e96 = phi_336_;
    if _e96 {
        local = 1f;
    } else {
        let _e98 = d[0u];
        local = _e98;
    }
    let _e99 = local;
    d[0u] = _e99;
    let _e102 = r[1u];
    let _e103 = (_e102 < 0.5f);
    phi_356_ = _e103;
    if !(_e103) {
        let _e106 = r[1u];
        let _e107 = (*n);
        phi_356_ = (_e106 > (_e107 - 0.5f));
    }
    let _e111 = phi_356_;
    if _e111 {
        local_1 = 1f;
    } else {
        let _e113 = d[1u];
        local_1 = _e113;
    }
    let _e114 = local_1;
    d[1u] = _e114;
    let _e116 = (*g);
    e = min(0.0012f, (0.5f * _e116));
    let _e119 = (*g);
    let _e121 = e;
    let _e123 = (*g);
    let _e125 = e;
    let _e128 = d[0u];
    let _e130 = d[1u];
    return smoothstep(((0.5f * _e119) - _e121), ((0.5f * _e123) + _e125), min(_e128, _e130));
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e57 = (*uv)[0u];
    let _e59 = (*uv)[1u];
    let _e62 = textureSampleLevel(_from, _sampler, vec2<f32>(_e57, (1f - _e59)), 0f);
    return _e62;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e57 = (*uv_1)[0u];
    let _e59 = (*uv_1)[1u];
    let _e62 = textureSampleLevel(_to, _sampler, vec2<f32>(_e57, (1f - _e59)), 0f);
    return _e62;
}

fn sticker(fp_1: ptr<function, vec2<f32>>, incoming: ptr<function, bool>, light: ptr<function, f32>, n_1: ptr<function, f32>, g_1: ptr<function, f32>) -> vec4<f32> {
    var uv_2: vec2<f32>;
    var img: vec4<f32>;
    var local_2: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var body: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: f32;
    var param_4: f32;

    let _e69 = (*fp_1);
    let _e71 = uniforms.ratio;
    uv_2 = clamp((_e69 / vec2<f32>(_e71, 1f)), vec2(0f), vec2(1f));
    let _e77 = (*incoming);
    if _e77 {
        let _e78 = uv_2;
        param = _e78;
        let _e79 = getToColor((&param));
        local_2 = _e79;
    } else {
        let _e80 = uv_2;
        param_1 = _e80;
        let _e81 = getFromColor((&param_1));
        local_2 = _e81;
    }
    let _e82 = local_2;
    img = _e82;
    let _e84 = uniforms.background;
    let _e86 = (*light);
    let _e87 = (_e84.xyz * _e86);
    let _e90 = uniforms.background[3u];
    body = vec4<f32>(_e87.x, _e87.y, _e87.z, _e90);
    let _e95 = body;
    let _e96 = img;
    let _e98 = (*light);
    let _e99 = (_e96.xyz * _e98);
    let _e101 = img[3u];
    let _e106 = (*fp_1);
    param_2 = _e106;
    let _e107 = (*n_1);
    param_3 = _e107;
    let _e108 = (*g_1);
    param_4 = _e108;
    let _e109 = faceMask((&param_2), (&param_3), (&param_4));
    return mix(_e95, vec4<f32>(_e99.x, _e99.y, _e99.z, _e101), vec4(_e109));
}

fn turnTime(tl: ptr<function, vec3<f32>>, isCol: ptr<function, bool>, idx: ptr<function, f32>, n_2: ptr<function, f32>) -> f32 {
    var k: f32;
    var local_3: f32;
    var odd: bool;
    var start: f32;
    var local_4: f32;
    var local_5: f32;

    let _e65 = (*isCol);
    if _e65 {
        let _e66 = (*idx);
        local_3 = _e66;
    } else {
        let _e67 = (*n_2);
        let _e69 = (*idx);
        local_3 = ((_e67 - 1f) - _e69);
    }
    let _e71 = local_3;
    k = _e71;
    let _e72 = k;
    odd = ((_e72 - (floor((_e72 / 2f)) * 2f)) > 0.5f);
    let _e78 = odd;
    let _e79 = (*isCol);
    if (_e78 && !(_e79)) {
        return 0f;
    }
    let _e82 = odd;
    if _e82 {
        let _e84 = (*tl)[1u];
        local_4 = (2f * _e84);
    } else {
        let _e86 = (*isCol);
        if _e86 {
            local_5 = 0f;
        } else {
            let _e88 = (*tl)[1u];
            local_5 = _e88;
        }
        let _e89 = local_5;
        local_4 = _e89;
    }
    let _e90 = local_4;
    let _e91 = k;
    start = (_e90 + (floor((_e91 * 0.5f)) * 0.45f));
    let _e97 = (*tl)[0u];
    let _e98 = start;
    return clamp((_e97 - _e98), 0f, 1f);
}

fn isDone(tl_1: ptr<function, vec3<f32>>, fp_2: ptr<function, vec2<f32>>, n_3: ptr<function, f32>) -> bool {
    var cell_1: vec2<f32>;
    var param_5: vec3<f32>;
    var param_6: bool;
    var param_7: f32;
    var param_8: f32;
    var param_9: vec3<f32>;
    var param_10: bool;
    var param_11: f32;
    var param_12: f32;
    var phi_426_: bool;

    let _e67 = (*fp_2);
    let _e69 = uniforms.ratio;
    let _e71 = (*n_3);
    let _e76 = (*n_3);
    cell_1 = clamp(floor((_e67 / (vec2<f32>(_e69, 1f) / vec2(_e71)))), vec2(0f), vec2((_e76 - 1f)));
    let _e81 = (*tl_1);
    param_5 = _e81;
    param_6 = true;
    let _e83 = cell_1[0u];
    param_7 = _e83;
    let _e84 = (*n_3);
    param_8 = _e84;
    let _e85 = turnTime((&param_5), (&param_6), (&param_7), (&param_8));
    let _e86 = (_e85 >= 1f);
    phi_426_ = _e86;
    if !(_e86) {
        let _e88 = (*tl_1);
        param_9 = _e88;
        param_10 = false;
        let _e90 = cell_1[1u];
        param_11 = _e90;
        let _e91 = (*n_3);
        param_12 = _e91;
        let _e92 = turnTime((&param_9), (&param_10), (&param_11), (&param_12));
        phi_426_ = (_e92 >= 1f);
    }
    let _e95 = phi_426_;
    return _e95;
}

fn rot(v: ptr<function, vec2<f32>>, a: ptr<function, f32>) -> vec2<f32> {
    var c_1: f32;
    var s: f32;

    let _e59 = (*a);
    c_1 = cos(_e59);
    let _e61 = (*a);
    s = sin(_e61);
    let _e63 = c_1;
    let _e65 = (*v)[0u];
    let _e67 = s;
    let _e69 = (*v)[1u];
    let _e72 = s;
    let _e74 = (*v)[0u];
    let _e76 = c_1;
    let _e78 = (*v)[1u];
    return vec2<f32>(((_e63 * _e65) - (_e67 * _e69)), ((_e72 * _e74) + (_e76 * _e78)));
}

fn lighting(nrm: ptr<function, vec3<f32>>, isCol_1: ptr<function, bool>) -> f32 {
    var l: vec3<f32>;

    l = vec3<f32>(-0.29319772f, 0.46073928f, 0.8377078f);
    let _e58 = (*isCol_1);
    if _e58 {
        let _e59 = l;
        l = _e59.yxz;
    }
    let _e62 = uniforms.shading;
    let _e63 = (*nrm);
    let _e64 = l;
    let _e67 = l[2u];
    return (1f - (_e62 * (1f - clamp((dot(_e63, _e64) / _e67), 0f, 1f))));
}

fn sliceColor(hit: ptr<function, vec4<f32>>, tl_2: ptr<function, vec3<f32>>, isCol_2: ptr<function, bool>, a_1: ptr<function, f32>, dir: ptr<function, f32>, S: ptr<function, f32>, n_4: ptr<function, f32>, g_2: ptr<function, f32>) -> vec4<f32> {
    var f: f32;
    var param_13: vec3<f32>;
    var param_14: bool;
    var nl: vec2<f32>;
    var local_6: vec2<f32>;
    var local_7: vec2<f32>;
    var light_1: f32;
    var param_15: vec2<f32>;
    var param_16: f32;
    var param_17: vec3<f32>;
    var param_18: bool;
    var front: bool;
    var coming: bool;
    var r_1: f32;
    var local_8: f32;
    var fp_3: vec2<f32>;
    var local_9: vec2<f32>;
    var param_19: vec3<f32>;
    var param_20: vec2<f32>;
    var param_21: f32;
    var param_22: vec2<f32>;
    var param_23: bool;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;
    var phi_878_: bool;

    let _e89 = (*hit)[1u];
    f = _e89;
    let _e90 = f;
    if (_e90 > 3.5f) {
        let _e93 = uniforms.background;
        let _e96 = (*hit)[3u];
        param_13 = vec3<f32>(_e96, 0f, 0f);
        let _e98 = (*isCol_2);
        param_14 = _e98;
        let _e99 = lighting((&param_13), (&param_14));
        let _e100 = (_e93.xyz * _e99);
        let _e103 = uniforms.background[3u];
        return vec4<f32>(_e100.x, _e100.y, _e100.z, _e103);
    }
    let _e108 = f;
    if (_e108 < 0.5f) {
        local_6 = vec2<f32>(0f, 1f);
    } else {
        let _e110 = f;
        if (_e110 < 1.5f) {
            local_7 = vec2<f32>(0f, -1f);
        } else {
            let _e112 = f;
            local_7 = select(vec2<f32>(-1f, 0f), vec2<f32>(1f, 0f), vec2((_e112 < 2.5f)));
        }
        let _e116 = local_7;
        local_6 = _e116;
    }
    let _e117 = local_6;
    nl = _e117;
    let _e118 = nl;
    param_15 = _e118;
    let _e119 = (*a_1);
    param_16 = _e119;
    let _e120 = rot((&param_15), (&param_16));
    param_17 = vec3<f32>(0f, _e120.x, _e120.y);
    let _e124 = (*isCol_2);
    param_18 = _e124;
    let _e125 = lighting((&param_17), (&param_18));
    light_1 = _e125;
    let _e126 = f;
    front = (_e126 < 0.5f);
    let _e129 = nl[0u];
    let _e130 = (*dir);
    coming = ((_e129 * _e130) > 0.5f);
    let _e133 = front;
    let _e135 = coming;
    if (!(_e133) && !(_e135)) {
        let _e139 = uniforms.background;
        let _e141 = light_1;
        let _e142 = (_e139.xyz * _e141);
        let _e145 = uniforms.background[3u];
        return vec4<f32>(_e142.x, _e142.y, _e142.z, _e145);
    }
    let _e150 = (*S);
    let _e152 = front;
    if _e152 {
        let _e154 = (*hit)[3u];
        local_8 = _e154;
    } else {
        let _e155 = (*dir);
        let _e158 = (*hit)[3u];
        local_8 = (-(_e155) * _e158);
    }
    let _e160 = local_8;
    r_1 = ((0.5f * _e150) * (1f + _e160));
    let _e163 = (*isCol_2);
    if _e163 {
        let _e165 = (*hit)[2u];
        let _e166 = r_1;
        local_9 = vec2<f32>(_e165, _e166);
    } else {
        let _e168 = r_1;
        let _e170 = (*hit)[2u];
        local_9 = vec2<f32>(_e168, _e170);
    }
    let _e172 = local_9;
    fp_3 = _e172;
    let _e173 = coming;
    phi_878_ = _e173;
    if !(_e173) {
        let _e175 = (*tl_2);
        param_19 = _e175;
        let _e176 = fp_3;
        param_20 = _e176;
        let _e177 = (*n_4);
        param_21 = _e177;
        let _e178 = isDone((&param_19), (&param_20), (&param_21));
        phi_878_ = _e178;
    }
    let _e180 = phi_878_;
    let _e181 = fp_3;
    param_22 = _e181;
    param_23 = _e180;
    let _e182 = light_1;
    param_24 = _e182;
    let _e183 = (*n_4);
    param_25 = _e183;
    let _e184 = (*g_2);
    param_26 = _e184;
    let _e185 = sticker((&param_22), (&param_23), (&param_24), (&param_25), (&param_26));
    return _e185;
}

fn sliceHit(o: ptr<function, vec3<f32>>, d_1: ptr<function, vec3<f32>>, a0_: ptr<function, f32>, w: ptr<function, f32>, S_1: ptr<function, f32>, a_2: ptr<function, f32>) -> vec4<f32> {
    var lo: vec2<f32>;
    var param_27: vec2<f32>;
    var param_28: f32;
    var ld: vec2<f32>;
    var param_29: vec2<f32>;
    var param_30: f32;
    var local_10: f32;
    var local_11: f32;
    var dx: f32;
    var local_12: f32;
    var t1_: vec3<f32>;
    var t2_: vec3<f32>;
    var tn: vec3<f32>;
    var tf: vec3<f32>;
    var tNear: f32;
    var tFar: f32;
    var q: vec2<f32>;
    var across: f32;
    var phi_702_: bool;

    let _e79 = (*o);
    let _e81 = (*S_1);
    let _e83 = (*S_1);
    let _e87 = (*a_2);
    param_27 = (_e79.yz - vec2<f32>((0.5f * _e81), (-0.5f * _e83)));
    param_28 = -(_e87);
    let _e89 = rot((&param_27), (&param_28));
    lo = _e89;
    let _e90 = (*a_2);
    let _e92 = (*d_1);
    param_29 = _e92.yz;
    param_30 = -(_e90);
    let _e94 = rot((&param_29), (&param_30));
    ld = _e94;
    let _e96 = ld[0u];
    if (abs(_e96) < 0.000001f) {
        local_10 = 0.000001f;
    } else {
        let _e100 = ld[0u];
        local_10 = _e100;
    }
    let _e101 = local_10;
    let _e103 = ld[1u];
    if (abs(_e103) < 0.000001f) {
        local_11 = 0.000001f;
    } else {
        let _e107 = ld[1u];
        local_11 = _e107;
    }
    let _e108 = local_11;
    ld = vec2<f32>(_e101, _e108);
    let _e111 = (*d_1)[0u];
    if (abs(_e111) < 0.000001f) {
        local_12 = 0.000001f;
    } else {
        let _e115 = (*d_1)[0u];
        local_12 = _e115;
    }
    let _e116 = local_12;
    dx = _e116;
    let _e117 = (*a0_);
    let _e119 = (*o)[0u];
    let _e121 = dx;
    let _e123 = (*S_1);
    let _e125 = lo;
    let _e128 = ld;
    let _e129 = ((vec2((-0.5f * _e123)) - _e125) / _e128);
    t1_ = vec3<f32>(((_e117 - _e119) / _e121), _e129.x, _e129.y);
    let _e133 = (*a0_);
    let _e134 = (*w);
    let _e137 = (*o)[0u];
    let _e139 = dx;
    let _e141 = (*S_1);
    let _e143 = lo;
    let _e146 = ld;
    let _e147 = ((vec2((0.5f * _e141)) - _e143) / _e146);
    t2_ = vec3<f32>((((_e133 + _e134) - _e137) / _e139), _e147.x, _e147.y);
    let _e151 = t1_;
    let _e152 = t2_;
    tn = min(_e151, _e152);
    let _e154 = t1_;
    let _e155 = t2_;
    tf = max(_e154, _e155);
    let _e158 = tn[0u];
    let _e160 = tn[1u];
    let _e162 = tn[2u];
    tNear = max(_e158, max(_e160, _e162));
    let _e166 = tf[0u];
    let _e168 = tf[1u];
    let _e170 = tf[2u];
    tFar = min(_e166, min(_e168, _e170));
    let _e173 = tNear;
    let _e174 = tFar;
    let _e176 = tNear;
    if ((_e173 > _e174) || (_e176 <= 0f)) {
        return vec4<f32>(-1f, -1f, -1f, -1f);
    }
    let _e179 = lo;
    let _e180 = tNear;
    let _e181 = ld;
    let _e184 = (*S_1);
    q = ((_e179 + (_e181 * _e180)) / vec2((0.5f * _e184)));
    let _e189 = (*o)[0u];
    let _e190 = tNear;
    let _e192 = (*d_1)[0u];
    across = (_e189 + (_e190 * _e192));
    let _e196 = tn[0u];
    let _e198 = tn[1u];
    let _e199 = (_e196 >= _e198);
    phi_702_ = _e199;
    if _e199 {
        let _e201 = tn[0u];
        let _e203 = tn[2u];
        phi_702_ = (_e201 >= _e203);
    }
    let _e206 = phi_702_;
    if _e206 {
        let _e207 = tNear;
        let _e208 = across;
        let _e209 = dx;
        return vec4<f32>(_e207, 4f, _e208, sign(-(_e209)));
    }
    let _e214 = tn[1u];
    let _e216 = tn[2u];
    if (_e214 > _e216) {
        let _e218 = tNear;
        let _e220 = ld[0u];
        let _e223 = across;
        let _e225 = q[1u];
        return vec4<f32>(_e218, select(3f, 2f, (_e220 < 0f)), _e223, _e225);
    }
    let _e227 = tNear;
    let _e229 = ld[1u];
    let _e232 = across;
    let _e234 = q[0u];
    return vec4<f32>(_e227, select(1f, 0f, (_e229 < 0f)), _e232, _e234);
}

fn turnDir(isCol_3: ptr<function, bool>, idx_1: ptr<function, f32>) -> f32 {
    let _e57 = (*idx_1);
    let _e58 = (*isCol_3);
    let _e60 = (_e57 + select(1f, 0f, _e58));
    return select(-1f, 1f, ((_e60 - (floor((_e60 / 2f)) * 2f)) < 0.5f));
}

fn turnAngle(t: ptr<function, f32>) -> f32 {
    let _e56 = (*t);
    let _e57 = (*t);
    let _e58 = (*t);
    let _e60 = (*t);
    return (1.5707964f * mix(_e56, ((_e57 * _e58) * (3f - (2f * _e60))), 0.8f));
}

fn groupLength(m: ptr<function, f32>) -> f32 {
    var local_13: f32;

    let _e57 = (*m);
    if (_e57 > 0f) {
        let _e59 = (*m);
        local_13 = (1f + ((_e59 - 1f) * 0.45f));
    } else {
        local_13 = 0f;
    }
    let _e63 = local_13;
    return _e63;
}

fn timeline(n_5: ptr<function, f32>) -> vec3<f32> {
    var lenEven: f32;
    var param_31: f32;
    var lenOdd: f32;
    var param_32: f32;
    var u: f32;

    let _e61 = (*n_5);
    param_31 = floor(((_e61 + 1f) * 0.5f));
    let _e65 = groupLength((&param_31));
    lenEven = _e65;
    let _e66 = (*n_5);
    param_32 = floor((_e66 * 0.5f));
    let _e69 = groupLength((&param_32));
    lenOdd = _e69;
    let _e71 = uniforms.progress;
    let _e75 = lenEven;
    let _e77 = lenOdd;
    u = (clamp(((_e71 - 0.05f) / 0.85f), 0f, 1f) * ((2f * _e75) + _e77));
    let _e80 = u;
    let _e81 = lenEven;
    let _e82 = lenOdd;
    return vec3<f32>(_e80, _e81, _e82);
}

fn gridSize_u0028_() -> f32 {
    var local_14: i32;
    var local_15: i32;

    let _e58 = uniforms.size;
    if (_e58 < 2i) {
        local_14 = 2i;
    } else {
        let _e61 = uniforms.size;
        if (_e61 > 8i) {
            local_15 = 8i;
        } else {
            let _e64 = uniforms.size;
            local_15 = _e64;
        }
        let _e65 = local_15;
        local_14 = _e65;
    }
    let _e66 = local_14;
    return f32(_e66);
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n_6: f32;
    var tl_3: vec3<f32>;
    var param_33: f32;
    var g_3: f32;
    var P: vec2<f32>;
    var isCol_4: bool;
    var w_1: f32;
    var local_16: f32;
    var S_2: f32;
    var local_17: f32;
    var pp: vec2<f32>;
    var local_18: vec2<f32>;
    var o_1: vec3<f32>;
    var local_19: vec2<f32>;
    var d_2: vec3<f32>;
    var k0_: f32;
    var t0_: f32;
    var param_34: vec3<f32>;
    var param_35: bool;
    var param_36: f32;
    var param_37: f32;
    var nearest: f32;
    var color: vec4<f32>;
    var param_38: vec3<f32>;
    var param_39: vec2<f32>;
    var param_40: f32;
    var local_20: vec4<f32>;
    var param_41: vec2<f32>;
    var param_42: vec2<f32>;
    var param_43: vec2<f32>;
    var param_44: f32;
    var param_45: f32;
    var j: i32;
    var k_1: f32;
    var tk: f32;
    var param_46: vec3<f32>;
    var param_47: bool;
    var param_48: f32;
    var param_49: f32;
    var dist: f32;
    var param_50: f32;
    var tw: f32;
    var local_21: f32;
    var local_22: f32;
    var tb: f32;
    var along: f32;
    var depth: f32;
    var light_2: f32;
    var local_23: f32;
    var param_51: vec3<f32>;
    var param_52: bool;
    var local_24: vec4<f32>;
    var j_1: i32;
    var k_2: f32;
    var tk_1: f32;
    var param_53: vec3<f32>;
    var param_54: bool;
    var param_55: f32;
    var param_56: f32;
    var dir_1: f32;
    var param_57: bool;
    var param_58: f32;
    var a_3: f32;
    var param_59: f32;
    var hit_1: vec4<f32>;
    var param_60: vec3<f32>;
    var param_61: vec3<f32>;
    var param_62: f32;
    var param_63: f32;
    var param_64: f32;
    var param_65: f32;
    var param_66: vec4<f32>;
    var param_67: vec3<f32>;
    var param_68: bool;
    var param_69: f32;
    var param_70: f32;
    var param_71: f32;
    var param_72: f32;
    var param_73: f32;
    var phi_936_: bool;
    var phi_1080_: bool;
    var phi_1285_: bool;
    var phi_1344_: bool;

    let _e135 = gridSize_u0028_();
    n_6 = _e135;
    let _e136 = n_6;
    param_33 = _e136;
    let _e137 = timeline((&param_33));
    tl_3 = _e137;
    let _e139 = uniforms.gap;
    let _e141 = uniforms.progress;
    let _e145 = uniforms.progress;
    g_3 = ((_e139 * smoothstep(0f, 0.1f, _e141)) * (1f - smoothstep(0.9f, 1f, _e145)));
    let _e150 = (*uv_3)[0u];
    let _e152 = uniforms.ratio;
    let _e155 = (*uv_3)[1u];
    P = vec2<f32>((_e150 * _e152), _e155);
    let _e158 = tl_3[0u];
    let _e160 = tl_3[1u];
    let _e161 = (_e158 < _e160);
    phi_936_ = _e161;
    if !(_e161) {
        let _e164 = tl_3[0u];
        let _e166 = tl_3[1u];
        phi_936_ = (_e164 >= (2f * _e166));
    }
    let _e170 = phi_936_;
    isCol_4 = _e170;
    let _e171 = isCol_4;
    if _e171 {
        let _e173 = uniforms.ratio;
        local_16 = _e173;
    } else {
        local_16 = 1f;
    }
    let _e174 = local_16;
    let _e175 = n_6;
    w_1 = (_e174 / _e175);
    let _e177 = isCol_4;
    if _e177 {
        local_17 = 1f;
    } else {
        let _e179 = uniforms.ratio;
        local_17 = _e179;
    }
    let _e180 = local_17;
    S_2 = _e180;
    let _e181 = isCol_4;
    if _e181 {
        let _e182 = P;
        local_18 = _e182;
    } else {
        let _e183 = P;
        local_18 = _e183.yx;
    }
    let _e185 = local_18;
    pp = _e185;
    let _e186 = isCol_4;
    if _e186 {
        let _e188 = uniforms.ratio;
        local_19 = vec2<f32>((0.5f * _e188), 0.5f);
    } else {
        let _e192 = uniforms.ratio;
        local_19 = vec2<f32>(0.5f, (0.5f * _e192));
    }
    let _e195 = local_19;
    let _e197 = uniforms.ratio;
    o_1 = vec3<f32>(_e195.x, _e195.y, (1.2f + (0.6f * max(_e197, 1f))));
    let _e204 = pp;
    let _e208 = o_1;
    d_2 = (vec3<f32>(_e204.x, _e204.y, 0f) - _e208);
    let _e211 = pp[0u];
    let _e212 = w_1;
    let _e215 = n_6;
    k0_ = clamp(floor((_e211 / _e212)), 0f, (_e215 - 1f));
    let _e218 = tl_3;
    param_34 = _e218;
    let _e219 = isCol_4;
    param_35 = _e219;
    let _e220 = k0_;
    param_36 = _e220;
    let _e221 = n_6;
    param_37 = _e221;
    let _e222 = turnTime((&param_34), (&param_35), (&param_36), (&param_37));
    t0_ = _e222;
    nearest = 1f;
    let _e223 = t0_;
    let _e225 = t0_;
    if ((_e223 <= 0f) || (_e225 >= 1f)) {
        let _e228 = tl_3;
        param_38 = _e228;
        let _e229 = P;
        param_39 = _e229;
        let _e230 = n_6;
        param_40 = _e230;
        let _e231 = isDone((&param_38), (&param_39), (&param_40));
        if _e231 {
            let _e232 = (*uv_3);
            param_41 = _e232;
            let _e233 = getToColor((&param_41));
            local_20 = _e233;
        } else {
            let _e234 = (*uv_3);
            param_42 = _e234;
            let _e235 = getFromColor((&param_42));
            local_20 = _e235;
        }
        let _e236 = local_20;
        color = _e236;
        let _e238 = uniforms.background;
        let _e239 = color;
        let _e240 = P;
        param_43 = _e240;
        let _e241 = n_6;
        param_44 = _e241;
        let _e242 = g_3;
        param_45 = _e242;
        let _e243 = faceMask((&param_43), (&param_44), (&param_45));
        color = mix(_e238, _e239, vec4(_e243));
        j = -1i;
        loop {
            let _e246 = j;
            if (_e246 <= 1i) {
                let _e248 = k0_;
                let _e249 = j;
                k_1 = (_e248 + f32(_e249));
                let _e252 = k_1;
                let _e253 = (_e252 < 0f);
                phi_1080_ = _e253;
                if !(_e253) {
                    let _e255 = k_1;
                    let _e256 = n_6;
                    phi_1080_ = (_e255 > (_e256 - 1f));
                }
                let _e260 = phi_1080_;
                if _e260 {
                    continue;
                }
                let _e261 = tl_3;
                param_46 = _e261;
                let _e262 = isCol_4;
                param_47 = _e262;
                let _e263 = k_1;
                param_48 = _e263;
                let _e264 = n_6;
                param_49 = _e264;
                let _e265 = turnTime((&param_46), (&param_47), (&param_48), (&param_49));
                tk = _e265;
                let _e266 = tk;
                let _e268 = tk;
                if ((_e266 <= 0f) || (_e268 >= 1f)) {
                    continue;
                }
                let _e272 = pp[0u];
                let _e273 = k_1;
                let _e275 = w_1;
                let _e279 = w_1;
                dist = (abs((_e272 - ((_e273 + 0.5f) * _e275))) - (0.5f * _e279));
                let _e283 = uniforms.shading;
                let _e285 = tk;
                param_50 = _e285;
                let _e286 = turnAngle((&param_50));
                let _e290 = dist;
                let _e292 = w_1;
                let _e298 = color;
                let _e300 = (_e298.xyz * (1f - (((0.5f * _e283) * sin((2f * _e286))) * exp((-(_e290) / (0.2f * _e292))))));
                color[0u] = _e300.x;
                color[1u] = _e300.y;
                color[2u] = _e300.z;
                continue;
            } else {
                break;
            }
            continuing {
                let _e307 = j;
                j = (_e307 + 2i);
            }
        }
    } else {
        let _e310 = d_2[0u];
        if (abs(_e310) < 0.000001f) {
            local_21 = 1000000f;
        } else {
            let _e314 = d_2[0u];
            if (_e314 < 0f) {
                let _e316 = k0_;
                let _e317 = w_1;
                let _e320 = o_1[0u];
                local_22 = ((_e316 * _e317) - _e320);
            } else {
                let _e322 = k0_;
                let _e324 = w_1;
                let _e327 = o_1[0u];
                local_22 = (((_e322 + 1f) * _e324) - _e327);
            }
            let _e329 = local_22;
            let _e331 = d_2[0u];
            local_21 = (_e329 / _e331);
        }
        let _e333 = local_21;
        tw = _e333;
        let _e335 = o_1[2u];
        let _e336 = S_2;
        let _e339 = d_2[2u];
        tb = ((_e335 + _e336) / -(_e339));
        let _e342 = tw;
        let _e343 = tb;
        nearest = min(_e342, _e343);
        let _e346 = o_1[1u];
        let _e347 = nearest;
        let _e349 = d_2[1u];
        along = (_e346 + (_e347 * _e349));
        let _e353 = o_1[2u];
        let _e354 = nearest;
        let _e356 = d_2[2u];
        let _e359 = S_2;
        depth = ((_e353 + (_e354 * _e356)) / -(_e359));
        let _e362 = tw;
        let _e363 = tb;
        if (_e362 < _e363) {
            let _e366 = d_2[0u];
            param_51 = vec3<f32>(-(sign(_e366)), 0f, 0f);
            let _e370 = isCol_4;
            param_52 = _e370;
            let _e371 = lighting((&param_51), (&param_52));
            local_23 = _e371;
        } else {
            local_23 = 1f;
        }
        let _e372 = local_23;
        light_2 = _e372;
        let _e374 = uniforms.shading;
        let _e375 = depth;
        let _e381 = light_2;
        light_2 = (_e381 * (1f - (_e374 * (0.5f + (0.4f * clamp(_e375, 0f, 1f))))));
        let _e383 = along;
        let _e385 = along;
        let _e386 = S_2;
        if ((_e383 < 0f) || (_e385 > _e386)) {
            let _e390 = uniforms.background;
            local_24 = _e390;
        } else {
            let _e392 = uniforms.background;
            let _e394 = light_2;
            let _e395 = (_e392.xyz * _e394);
            let _e398 = uniforms.background[3u];
            local_24 = vec4<f32>(_e395.x, _e395.y, _e395.z, _e398);
        }
        let _e403 = local_24;
        color = _e403;
    }
    j_1 = -1i;
    loop {
        let _e404 = j_1;
        if (_e404 <= 1i) {
            let _e406 = k0_;
            let _e407 = j_1;
            k_2 = (_e406 + f32(_e407));
            let _e410 = k_2;
            let _e411 = (_e410 < 0f);
            phi_1285_ = _e411;
            if !(_e411) {
                let _e413 = k_2;
                let _e414 = n_6;
                phi_1285_ = (_e413 > (_e414 - 1f));
            }
            let _e418 = phi_1285_;
            if _e418 {
                continue;
            }
            let _e419 = tl_3;
            param_53 = _e419;
            let _e420 = isCol_4;
            param_54 = _e420;
            let _e421 = k_2;
            param_55 = _e421;
            let _e422 = n_6;
            param_56 = _e422;
            let _e423 = turnTime((&param_53), (&param_54), (&param_55), (&param_56));
            tk_1 = _e423;
            let _e424 = tk_1;
            let _e426 = tk_1;
            if ((_e424 <= 0f) || (_e426 >= 1f)) {
                continue;
            }
            let _e429 = isCol_4;
            param_57 = _e429;
            let _e430 = k_2;
            param_58 = _e430;
            let _e431 = turnDir((&param_57), (&param_58));
            dir_1 = _e431;
            let _e432 = dir_1;
            let _e433 = tk_1;
            param_59 = _e433;
            let _e434 = turnAngle((&param_59));
            a_3 = (_e432 * _e434);
            let _e436 = k_2;
            let _e437 = w_1;
            let _e439 = o_1;
            param_60 = _e439;
            let _e440 = d_2;
            param_61 = _e440;
            param_62 = (_e436 * _e437);
            let _e441 = w_1;
            param_63 = _e441;
            let _e442 = S_2;
            param_64 = _e442;
            let _e443 = a_3;
            param_65 = _e443;
            let _e444 = sliceHit((&param_60), (&param_61), (&param_62), (&param_63), (&param_64), (&param_65));
            hit_1 = _e444;
            let _e446 = hit_1[0u];
            let _e447 = (_e446 > 0f);
            phi_1344_ = _e447;
            if _e447 {
                let _e449 = hit_1[0u];
                let _e450 = nearest;
                phi_1344_ = (_e449 < _e450);
            }
            let _e453 = phi_1344_;
            if _e453 {
                let _e455 = hit_1[0u];
                nearest = _e455;
                let _e456 = hit_1;
                param_66 = _e456;
                let _e457 = tl_3;
                param_67 = _e457;
                let _e458 = isCol_4;
                param_68 = _e458;
                let _e459 = a_3;
                param_69 = _e459;
                let _e460 = dir_1;
                param_70 = _e460;
                let _e461 = S_2;
                param_71 = _e461;
                let _e462 = n_6;
                param_72 = _e462;
                let _e463 = g_3;
                param_73 = _e463;
                let _e464 = sliceColor((&param_66), (&param_67), (&param_68), (&param_69), (&param_70), (&param_71), (&param_72), (&param_73));
                color = _e464;
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e465 = j_1;
            j_1 = (_e465 + 1i);
        }
    }
    let _e467 = color;
    return _e467;
}

fn main_1() {
    var param_74: vec2<f32>;

    let _e56 = _uv_1;
    param_74 = _e56;
    let _e57 = transition((&param_74));
    _fragColor = _e57;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
