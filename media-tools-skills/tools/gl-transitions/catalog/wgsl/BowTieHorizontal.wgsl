// BowTieHorizontal — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BowTieHorizontal.glsl
// Author: huynx
// License: MIT
// Description: Two triangles grow from the left and right edges into a bow tie that reveals the incoming image
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

fn check(p1_: ptr<function, vec2<f32>>, p2_: ptr<function, vec2<f32>>, p3_: ptr<function, vec2<f32>>) -> f32 {
    let _e25 = (*p1_)[0u];
    let _e27 = (*p3_)[0u];
    let _e30 = (*p2_)[1u];
    let _e32 = (*p3_)[1u];
    let _e36 = (*p2_)[0u];
    let _e38 = (*p3_)[0u];
    let _e41 = (*p1_)[1u];
    let _e43 = (*p3_)[1u];
    return (((_e25 - _e27) * (_e30 - _e32)) - ((_e36 - _e38) * (_e41 - _e43)));
}

fn PointInTriangle(pt: ptr<function, vec2<f32>>, p1_1: ptr<function, vec2<f32>>, p2_1: ptr<function, vec2<f32>>, p3_1: ptr<function, vec2<f32>>) -> bool {
    var b1_: bool;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var b2_: bool;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var b3_: bool;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;

    let _e37 = (*pt);
    param = _e37;
    let _e38 = (*p1_1);
    param_1 = _e38;
    let _e39 = (*p2_1);
    param_2 = _e39;
    let _e40 = check((&param), (&param_1), (&param_2));
    b1_ = (_e40 < 0f);
    let _e42 = (*pt);
    param_3 = _e42;
    let _e43 = (*p2_1);
    param_4 = _e43;
    let _e44 = (*p3_1);
    param_5 = _e44;
    let _e45 = check((&param_3), (&param_4), (&param_5));
    b2_ = (_e45 < 0f);
    let _e47 = (*pt);
    param_6 = _e47;
    let _e48 = (*p3_1);
    param_7 = _e48;
    let _e49 = (*p1_1);
    param_8 = _e49;
    let _e50 = check((&param_6), (&param_7), (&param_8));
    b3_ = (_e50 < 0f);
    let _e52 = b1_;
    let _e53 = b2_;
    let _e55 = b2_;
    let _e56 = b3_;
    return ((_e52 == _e53) && (_e55 == _e56));
}

fn in_right_triangle(p: ptr<function, vec2<f32>>) -> bool {
    var vertex1_: vec2<f32>;
    var vertex2_: vec2<f32>;
    var vertex3_: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;

    let _e30 = uniforms.progress;
    vertex1_ = vec2<f32>((1f - _e30), 0.5f);
    let _e34 = uniforms.progress;
    vertex2_ = vec2<f32>(1f, (0.5f - _e34));
    let _e38 = uniforms.progress;
    vertex3_ = vec2<f32>(1f, (0.5f + _e38));
    let _e41 = (*p);
    param_9 = _e41;
    let _e42 = vertex1_;
    param_10 = _e42;
    let _e43 = vertex2_;
    param_11 = _e43;
    let _e44 = vertex3_;
    param_12 = _e44;
    let _e45 = PointInTriangle((&param_9), (&param_10), (&param_11), (&param_12));
    if _e45 {
        return true;
    }
    return false;
}

fn blur_edge(bot1_: ptr<function, vec2<f32>>, bot2_: ptr<function, vec2<f32>>, top: ptr<function, vec2<f32>>, testPt: ptr<function, vec2<f32>>) -> f32 {
    var lineDir: vec2<f32>;
    var perpDir: vec2<f32>;
    var dirToPt1_: vec2<f32>;
    var dist1_: f32;
    var min_dist: f32;

    let _e30 = (*bot1_);
    let _e31 = (*top);
    lineDir = (_e30 - _e31);
    let _e34 = lineDir[1u];
    let _e36 = lineDir[0u];
    perpDir = vec2<f32>(_e34, -(_e36));
    let _e39 = (*bot1_);
    let _e40 = (*testPt);
    dirToPt1_ = (_e39 - _e40);
    let _e42 = perpDir;
    let _e44 = dirToPt1_;
    dist1_ = abs(dot(normalize(_e42), _e44));
    let _e47 = (*bot2_);
    let _e48 = (*top);
    lineDir = (_e47 - _e48);
    let _e51 = lineDir[1u];
    let _e53 = lineDir[0u];
    perpDir = vec2<f32>(_e51, -(_e53));
    let _e56 = (*bot2_);
    let _e57 = (*testPt);
    dirToPt1_ = (_e56 - _e57);
    let _e59 = perpDir;
    let _e61 = dirToPt1_;
    let _e64 = dist1_;
    min_dist = min(abs(dot(normalize(_e59), _e61)), _e64);
    let _e66 = min_dist;
    if (_e66 < 0.005f) {
        let _e68 = min_dist;
        return (_e68 / 0.005f);
    } else {
        return 1f;
    }
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e23 = (*uv)[0u];
    let _e25 = (*uv)[1u];
    let _e28 = textureSampleLevel(_to, _sampler, vec2<f32>(_e23, (1f - _e25)), 0f);
    return _e28;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e23 = (*uv_1)[0u];
    let _e25 = (*uv_1)[1u];
    let _e28 = textureSampleLevel(_from, _sampler, vec2<f32>(_e23, (1f - _e25)), 0f);
    return _e28;
}

fn in_left_triangle(p_1: ptr<function, vec2<f32>>) -> bool {
    var vertex1_1: vec2<f32>;
    var vertex2_1: vec2<f32>;
    var vertex3_1: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;

    let _e30 = uniforms.progress;
    vertex1_1 = vec2<f32>(_e30, 0.5f);
    let _e33 = uniforms.progress;
    vertex2_1 = vec2<f32>(0f, (0.5f - _e33));
    let _e37 = uniforms.progress;
    vertex3_1 = vec2<f32>(0f, (0.5f + _e37));
    let _e40 = (*p_1);
    param_13 = _e40;
    let _e41 = vertex1_1;
    param_14 = _e41;
    let _e42 = vertex2_1;
    param_15 = _e42;
    let _e43 = vertex3_1;
    param_16 = _e43;
    let _e44 = PointInTriangle((&param_13), (&param_14), (&param_15), (&param_16));
    if _e44 {
        return true;
    }
    return false;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var vertex1_2: vec2<f32>;
    var vertex2_2: vec2<f32>;
    var vertex3_2: vec2<f32>;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var param_23: vec2<f32>;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;
    var vertex1_3: vec2<f32>;
    var vertex2_3: vec2<f32>;
    var vertex3_3: vec2<f32>;
    var param_28: vec2<f32>;
    var param_29: vec2<f32>;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;
    var param_32: vec2<f32>;
    var param_33: vec2<f32>;
    var param_34: vec2<f32>;
    var param_35: vec2<f32>;

    let _e47 = (*uv_2);
    param_17 = _e47;
    let _e48 = in_left_triangle((&param_17));
    if _e48 {
        let _e50 = uniforms.progress;
        if (_e50 < 0.1f) {
            let _e52 = (*uv_2);
            param_18 = _e52;
            let _e53 = getFromColor((&param_18));
            return _e53;
        }
        let _e55 = (*uv_2)[0u];
        if (_e55 < 0.5f) {
            let _e58 = uniforms.progress;
            vertex1_2 = vec2<f32>(_e58, 0.5f);
            let _e61 = uniforms.progress;
            vertex2_2 = vec2<f32>(0f, (0.5f - _e61));
            let _e65 = uniforms.progress;
            vertex3_2 = vec2<f32>(0f, (0.5f + _e65));
            let _e68 = (*uv_2);
            param_19 = _e68;
            let _e69 = getFromColor((&param_19));
            let _e70 = (*uv_2);
            param_20 = _e70;
            let _e71 = getToColor((&param_20));
            let _e72 = vertex2_2;
            param_21 = _e72;
            let _e73 = vertex3_2;
            param_22 = _e73;
            let _e74 = vertex1_2;
            param_23 = _e74;
            let _e75 = (*uv_2);
            param_24 = _e75;
            let _e76 = blur_edge((&param_21), (&param_22), (&param_23), (&param_24));
            return mix(_e69, _e71, vec4(_e76));
        } else {
            let _e80 = uniforms.progress;
            if (_e80 > 0f) {
                let _e82 = (*uv_2);
                param_25 = _e82;
                let _e83 = getToColor((&param_25));
                return _e83;
            } else {
                let _e84 = (*uv_2);
                param_26 = _e84;
                let _e85 = getFromColor((&param_26));
                return _e85;
            }
        }
    } else {
        let _e86 = (*uv_2);
        param_27 = _e86;
        let _e87 = in_right_triangle((&param_27));
        if _e87 {
            let _e89 = (*uv_2)[0u];
            if (_e89 >= 0.5f) {
                let _e92 = uniforms.progress;
                vertex1_3 = vec2<f32>((1f - _e92), 0.5f);
                let _e96 = uniforms.progress;
                vertex2_3 = vec2<f32>(1f, (0.5f - _e96));
                let _e100 = uniforms.progress;
                vertex3_3 = vec2<f32>(1f, (0.5f + _e100));
                let _e103 = (*uv_2);
                param_28 = _e103;
                let _e104 = getFromColor((&param_28));
                let _e105 = (*uv_2);
                param_29 = _e105;
                let _e106 = getToColor((&param_29));
                let _e107 = vertex2_3;
                param_30 = _e107;
                let _e108 = vertex3_3;
                param_31 = _e108;
                let _e109 = vertex1_3;
                param_32 = _e109;
                let _e110 = (*uv_2);
                param_33 = _e110;
                let _e111 = blur_edge((&param_30), (&param_31), (&param_32), (&param_33));
                return mix(_e104, _e106, vec4(_e111));
            } else {
                let _e114 = (*uv_2);
                param_34 = _e114;
                let _e115 = getFromColor((&param_34));
                return _e115;
            }
        } else {
            let _e116 = (*uv_2);
            param_35 = _e116;
            let _e117 = getFromColor((&param_35));
            return _e117;
        }
    }
}

fn main_1() {
    var param_36: vec2<f32>;

    let _e22 = _uv_1;
    param_36 = _e22;
    let _e23 = transition((&param_36));
    _fragColor = _e23;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
