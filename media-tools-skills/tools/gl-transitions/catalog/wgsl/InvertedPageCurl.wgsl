// InvertedPageCurl — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InvertedPageCurl.glsl
// Author: Hewlett-Packard
// License: BSD 3 Clause
// Description: The outgoing image curls away like a page, revealing the incoming one
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
var<private> cylinderAngle: f32;
var<private> amount: f32;
@group(0) @binding(0) 
var<uniform> uniforms: Uniforms;
var<private> cylinderCenter: f32;
var<private> _fragColor: vec4<f32>;
var<private> _uv_1: vec2<f32>;

fn distanceToEdge(point: ptr<function, vec3<f32>>) -> f32 {
    var dx: f32;
    var local: f32;
    var dy: f32;
    var local_1: f32;
    var phi_222_: bool;
    var phi_234_: bool;
    var phi_235_: bool;

    let _e52 = (*point)[0u];
    if (_e52 > 0.5f) {
        let _e55 = (*point)[0u];
        local = (1f - _e55);
    } else {
        let _e58 = (*point)[0u];
        local = _e58;
    }
    let _e59 = local;
    dx = abs(_e59);
    let _e62 = (*point)[1u];
    if (_e62 > 0.5f) {
        let _e65 = (*point)[1u];
        local_1 = (1f - _e65);
    } else {
        let _e68 = (*point)[1u];
        local_1 = _e68;
    }
    let _e69 = local_1;
    dy = abs(_e69);
    let _e72 = (*point)[0u];
    if (_e72 < 0f) {
        let _e75 = (*point)[0u];
        dx = -(_e75);
    }
    let _e78 = (*point)[0u];
    if (_e78 > 1f) {
        let _e81 = (*point)[0u];
        dx = (_e81 - 1f);
    }
    let _e84 = (*point)[1u];
    if (_e84 < 0f) {
        let _e87 = (*point)[1u];
        dy = -(_e87);
    }
    let _e90 = (*point)[1u];
    if (_e90 > 1f) {
        let _e93 = (*point)[1u];
        dy = (_e93 - 1f);
    }
    let _e96 = (*point)[0u];
    let _e97 = (_e96 < 0f);
    phi_222_ = _e97;
    if !(_e97) {
        let _e100 = (*point)[0u];
        phi_222_ = (_e100 > 1f);
    }
    let _e103 = phi_222_;
    phi_235_ = _e103;
    if _e103 {
        let _e105 = (*point)[1u];
        let _e106 = (_e105 < 0f);
        phi_234_ = _e106;
        if !(_e106) {
            let _e109 = (*point)[1u];
            phi_234_ = (_e109 > 1f);
        }
        let _e112 = phi_234_;
        phi_235_ = _e112;
    }
    let _e114 = phi_235_;
    if _e114 {
        let _e115 = dx;
        let _e116 = dx;
        let _e118 = dy;
        let _e119 = dy;
        return sqrt(((_e115 * _e116) + (_e118 * _e119)));
    }
    let _e123 = dx;
    let _e124 = dy;
    return min(_e123, _e124);
}

fn antiAlias(color1_: ptr<function, vec4<f32>>, color2_: ptr<function, vec4<f32>>, distanc: ptr<function, f32>) -> vec4<f32> {
    var dd: f32;

    let _e50 = (*distanc);
    (*distanc) = (_e50 * 512f);
    let _e52 = (*distanc);
    if (_e52 < 0f) {
        let _e54 = (*color2_);
        return _e54;
    }
    let _e55 = (*distanc);
    if (_e55 > 2f) {
        let _e57 = (*color1_);
        return _e57;
    }
    let _e58 = (*distanc);
    dd = pow((1f - (_e58 / 2f)), 3f);
    let _e62 = (*color2_);
    let _e63 = (*color1_);
    let _e65 = dd;
    let _e67 = (*color1_);
    return (((_e62 - _e63) * _e65) + _e67);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e48 = (*uv)[0u];
    let _e50 = (*uv)[1u];
    let _e53 = textureSampleLevel(_to, _sampler, vec2<f32>(_e48, (1f - _e50)), 0f);
    return _e53;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e48 = (*uv_1)[0u];
    let _e50 = (*uv_1)[1u];
    let _e53 = textureSampleLevel(_from, _sampler, vec2<f32>(_e48, (1f - _e50)), 0f);
    return _e53;
}

fn backside(yc: ptr<function, f32>, point_1: ptr<function, vec3<f32>>) -> vec4<f32> {
    var color: vec4<f32>;
    var param: vec2<f32>;
    var gray: f32;

    let _e51 = (*point_1);
    param = _e51.xy;
    let _e53 = getFromColor((&param));
    color = _e53;
    let _e55 = color[0u];
    let _e57 = color[2u];
    let _e60 = color[1u];
    gray = (((_e55 + _e57) + _e60) / 15f);
    let _e63 = (*yc);
    let _e72 = gray;
    gray = (_e72 + (0.8f * ((pow(max(0f, (1f - abs((_e63 / 0.15915494f)))), 0.2f) / 2f) + 0.5f)));
    let _e74 = gray;
    let _e75 = vec3(_e74);
    color[0u] = _e75.x;
    color[1u] = _e75.y;
    color[2u] = _e75.z;
    let _e82 = color;
    return _e82;
}

fn hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b(hitAngle: ptr<function, f32>, yc_1: ptr<function, f32>, point_2: ptr<function, vec3<f32>>, rrotation: ptr<function, mat3x3<f32>>) -> vec3<f32> {
    var hitPoint: f32;

    let _e51 = (*hitAngle);
    hitPoint = (_e51 / 6.2831855f);
    let _e53 = hitPoint;
    (*point_2)[1u] = _e53;
    let _e55 = (*rrotation);
    let _e56 = (*point_2);
    return (_e55 * _e56);
}

fn seeThrough(yc_2: ptr<function, f32>, p: ptr<function, vec2<f32>>, rotation: ptr<function, mat3x3<f32>>, rrotation_1: ptr<function, mat3x3<f32>>) -> vec4<f32> {
    var hitAngle_1: f32;
    var point_3: vec3<f32>;
    var param_1: f32;
    var param_2: f32;
    var param_3: vec3<f32>;
    var param_4: mat3x3<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var color_1: vec4<f32>;
    var param_7: vec2<f32>;
    var tcolor: vec4<f32>;
    var param_8: vec3<f32>;
    var param_9: vec4<f32>;
    var param_10: vec4<f32>;
    var param_11: f32;
    var phi_293_: bool;
    var phi_300_: bool;
    var phi_307_: bool;
    var phi_308_: bool;

    let _e65 = (*yc_2);
    let _e69 = cylinderAngle;
    hitAngle_1 = (3.1415927f - (acos(clamp((_e65 / 0.15915494f), -1f, 1f)) - _e69));
    let _e72 = (*rotation);
    let _e73 = (*p);
    let _e78 = hitAngle_1;
    param_1 = _e78;
    let _e79 = (*yc_2);
    param_2 = _e79;
    param_3 = (_e72 * vec3<f32>(_e73.x, _e73.y, 1f));
    let _e80 = (*rrotation_1);
    param_4 = _e80;
    let _e81 = hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b((&param_1), (&param_2), (&param_3), (&param_4));
    point_3 = _e81;
    let _e82 = (*yc_2);
    let _e83 = (_e82 <= 0f);
    phi_308_ = _e83;
    if _e83 {
        let _e85 = point_3[0u];
        let _e86 = (_e85 < 0f);
        phi_293_ = _e86;
        if !(_e86) {
            let _e89 = point_3[1u];
            phi_293_ = (_e89 < 0f);
        }
        let _e92 = phi_293_;
        phi_300_ = _e92;
        if !(_e92) {
            let _e95 = point_3[0u];
            phi_300_ = (_e95 > 1f);
        }
        let _e98 = phi_300_;
        phi_307_ = _e98;
        if !(_e98) {
            let _e101 = point_3[1u];
            phi_307_ = (_e101 > 1f);
        }
        let _e104 = phi_307_;
        phi_308_ = _e104;
    }
    let _e106 = phi_308_;
    if _e106 {
        let _e107 = (*p);
        param_5 = _e107;
        let _e108 = getToColor((&param_5));
        return _e108;
    }
    let _e109 = (*yc_2);
    if (_e109 > 0f) {
        let _e111 = (*p);
        param_6 = _e111;
        let _e112 = getFromColor((&param_6));
        return _e112;
    }
    let _e113 = point_3;
    param_7 = _e113.xy;
    let _e115 = getFromColor((&param_7));
    color_1 = _e115;
    tcolor = vec4<f32>(0f, 0f, 0f, 0f);
    let _e116 = point_3;
    param_8 = _e116;
    let _e117 = distanceToEdge((&param_8));
    let _e118 = color_1;
    param_9 = _e118;
    let _e119 = tcolor;
    param_10 = _e119;
    param_11 = _e117;
    let _e120 = antiAlias((&param_9), (&param_10), (&param_11));
    return _e120;
}

fn seeThroughWithShadow(yc_3: ptr<function, f32>, p_1: ptr<function, vec2<f32>>, point_4: ptr<function, vec3<f32>>, rotation_1: ptr<function, mat3x3<f32>>, rrotation_2: ptr<function, mat3x3<f32>>) -> vec4<f32> {
    var shadow: f32;
    var param_12: vec3<f32>;
    var shadowColor: vec4<f32>;
    var param_13: f32;
    var param_14: vec2<f32>;
    var param_15: mat3x3<f32>;
    var param_16: mat3x3<f32>;

    let _e58 = (*point_4);
    param_12 = _e58;
    let _e59 = distanceToEdge((&param_12));
    shadow = (_e59 * 30f);
    let _e61 = shadow;
    shadow = ((1f - _e61) / 3f);
    let _e64 = shadow;
    if (_e64 < 0f) {
        shadow = 0f;
    } else {
        let _e66 = amount;
        let _e67 = shadow;
        shadow = (_e67 * _e66);
    }
    let _e69 = (*yc_3);
    param_13 = _e69;
    let _e70 = (*p_1);
    param_14 = _e70;
    let _e71 = (*rotation_1);
    param_15 = _e71;
    let _e72 = (*rrotation_2);
    param_16 = _e72;
    let _e73 = seeThrough((&param_13), (&param_14), (&param_15), (&param_16));
    shadowColor = _e73;
    let _e74 = shadow;
    let _e76 = shadowColor[0u];
    shadowColor[0u] = (_e76 - _e74);
    let _e79 = shadow;
    let _e81 = shadowColor[1u];
    shadowColor[1u] = (_e81 - _e79);
    let _e84 = shadow;
    let _e86 = shadowColor[2u];
    shadowColor[2u] = (_e86 - _e84);
    let _e89 = shadowColor;
    return _e89;
}

fn behindSurface(p_2: ptr<function, vec2<f32>>, yc_4: ptr<function, f32>, point_5: ptr<function, vec3<f32>>, rrotation_3: ptr<function, mat3x3<f32>>) -> vec4<f32> {
    var safeAmount: f32;
    var local_2: f32;
    var shado: f32;
    var hitAngle_2: f32;
    var param_17: f32;
    var param_18: f32;
    var param_19: vec3<f32>;
    var param_20: mat3x3<f32>;
    var dx_1: f32;
    var dy_1: f32;
    var nyc: f32;
    var to: vec4<f32>;
    var param_21: vec2<f32>;
    var phi_487_: bool;
    var phi_493_: bool;
    var phi_499_: bool;
    var phi_505_: bool;
    var phi_513_: bool;

    let _e63 = amount;
    if (_e63 >= 0f) {
        let _e65 = amount;
        local_2 = max(_e65, 0.0001f);
    } else {
        let _e67 = amount;
        local_2 = min(_e67, -0.0001f);
    }
    let _e69 = local_2;
    safeAmount = _e69;
    let _e70 = (*yc_4);
    let _e72 = safeAmount;
    shado = ((1f - (((-0.15915494f - _e70) / _e72) * 7f)) / 6f);
    let _e78 = (*point_5)[0u];
    let _e82 = shado;
    shado = (_e82 * (1f - abs((_e78 - 0.5f))));
    let _e84 = (*yc_4);
    (*yc_4) = (-0.31830987f - _e84);
    let _e86 = (*yc_4);
    let _e90 = cylinderAngle;
    hitAngle_2 = ((acos(clamp((_e86 / 0.15915494f), -1f, 1f)) + _e90) - 3.1415927f);
    let _e93 = hitAngle_2;
    param_17 = _e93;
    let _e94 = (*yc_4);
    param_18 = _e94;
    let _e95 = (*point_5);
    param_19 = _e95;
    let _e96 = (*rrotation_3);
    param_20 = _e96;
    let _e97 = hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b((&param_17), (&param_18), (&param_19), (&param_20));
    (*point_5) = _e97;
    let _e98 = (*yc_4);
    let _e99 = (_e98 < 0f);
    phi_487_ = _e99;
    if _e99 {
        let _e101 = (*point_5)[0u];
        phi_487_ = (_e101 >= 0f);
    }
    let _e104 = phi_487_;
    phi_493_ = _e104;
    if _e104 {
        let _e106 = (*point_5)[1u];
        phi_493_ = (_e106 >= 0f);
    }
    let _e109 = phi_493_;
    phi_499_ = _e109;
    if _e109 {
        let _e111 = (*point_5)[0u];
        phi_499_ = (_e111 <= 1f);
    }
    let _e114 = phi_499_;
    phi_505_ = _e114;
    if _e114 {
        let _e116 = (*point_5)[1u];
        phi_505_ = (_e116 <= 1f);
    }
    let _e119 = phi_505_;
    phi_513_ = _e119;
    if _e119 {
        let _e120 = hitAngle_2;
        let _e122 = amount;
        phi_513_ = ((_e120 < 3.1415927f) || (_e122 > 0.5f));
    }
    let _e126 = phi_513_;
    if _e126 {
        let _e128 = (*point_5)[0u];
        dx_1 = (_e128 - 0.5f);
        let _e131 = (*point_5)[1u];
        dy_1 = (_e131 - 0.5f);
        let _e133 = dx_1;
        let _e134 = dx_1;
        let _e136 = dy_1;
        let _e137 = dy_1;
        shado = (1f - (sqrt(((_e133 * _e134) + (_e136 * _e137))) / 0.71f));
        let _e143 = (*yc_4);
        nyc = (-(_e143) / 0.15915494f);
        let _e146 = nyc;
        let _e147 = nyc;
        let _e149 = nyc;
        let _e151 = shado;
        shado = (_e151 * ((_e146 * _e147) * _e149));
        let _e153 = shado;
        shado = (_e153 * 0.5f);
    } else {
        shado = 0f;
    }
    let _e155 = (*p_2);
    param_21 = _e155;
    let _e156 = getToColor((&param_21));
    to = _e156;
    let _e157 = to;
    let _e159 = shado;
    let _e161 = (_e157.xyz - vec3(_e159));
    let _e163 = to[3u];
    return vec4<f32>(_e161.x, _e161.y, _e161.z, _e163);
}

fn transition(p_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var c: f32;
    var s: f32;
    var rotation_2: mat3x3<f32>;
    var rrotation_4: mat3x3<f32>;
    var point_6: vec3<f32>;
    var yc_5: f32;
    var param_22: vec2<f32>;
    var param_23: f32;
    var param_24: vec3<f32>;
    var param_25: mat3x3<f32>;
    var param_26: vec2<f32>;
    var hitAngle_3: f32;
    var hitAngleMod: f32;
    var param_27: f32;
    var param_28: vec2<f32>;
    var param_29: mat3x3<f32>;
    var param_30: mat3x3<f32>;
    var param_31: f32;
    var param_32: f32;
    var param_33: vec3<f32>;
    var param_34: mat3x3<f32>;
    var param_35: f32;
    var param_36: vec2<f32>;
    var param_37: vec3<f32>;
    var param_38: mat3x3<f32>;
    var param_39: mat3x3<f32>;
    var color_2: vec4<f32>;
    var param_40: f32;
    var param_41: vec3<f32>;
    var dx2_: f32;
    var dy2_: f32;
    var shado_1: f32;
    var nyc2_: f32;
    var otherColor: vec4<f32>;
    var param_42: vec2<f32>;
    var param_43: vec2<f32>;
    var param_44: vec4<f32>;
    var param_45: vec4<f32>;
    var param_46: f32;
    var cl: vec4<f32>;
    var param_47: f32;
    var param_48: vec2<f32>;
    var param_49: vec3<f32>;
    var param_50: mat3x3<f32>;
    var param_51: mat3x3<f32>;
    var dist: f32;
    var param_52: vec3<f32>;
    var param_53: vec4<f32>;
    var param_54: vec4<f32>;
    var param_55: f32;
    var phi_670_: bool;
    var phi_701_: bool;
    var phi_708_: bool;
    var phi_715_: bool;

    let _e98 = uniforms.progress;
    amount = ((_e98 * 1.66f) + -0.16f);
    let _e101 = amount;
    cylinderCenter = _e101;
    let _e102 = amount;
    cylinderAngle = (6.2831855f * _e102);
    c = -0.17364818f;
    s = -0.9848077f;
    let _e104 = c;
    let _e105 = s;
    let _e106 = s;
    let _e108 = c;
    rotation_2 = mat3x3<f32>(vec3<f32>(_e104, _e105, 0f), vec3<f32>(-(_e106), _e108, 0f), vec3<f32>(-0.801f, 0.89f, 1f));
    c = -0.17364818f;
    s = 0.9848077f;
    let _e113 = c;
    let _e114 = s;
    let _e115 = s;
    let _e117 = c;
    rrotation_4 = mat3x3<f32>(vec3<f32>(_e113, _e114, 0f), vec3<f32>(-(_e115), _e117, 0f), vec3<f32>(0.985f, 0.985f, 1f));
    let _e122 = rotation_2;
    let _e123 = (*p_3);
    point_6 = (_e122 * vec3<f32>(_e123.x, _e123.y, 1f));
    let _e129 = point_6[1u];
    let _e130 = cylinderCenter;
    yc_5 = (_e129 - _e130);
    let _e132 = yc_5;
    if (_e132 < -0.15915494f) {
        let _e134 = (*p_3);
        param_22 = _e134;
        let _e135 = yc_5;
        param_23 = _e135;
        let _e136 = point_6;
        param_24 = _e136;
        let _e137 = rrotation_4;
        param_25 = _e137;
        let _e138 = behindSurface((&param_22), (&param_23), (&param_24), (&param_25));
        return _e138;
    }
    let _e139 = yc_5;
    if (_e139 > 0.15915494f) {
        let _e141 = (*p_3);
        param_26 = _e141;
        let _e142 = getFromColor((&param_26));
        return _e142;
    }
    let _e143 = yc_5;
    let _e147 = cylinderAngle;
    hitAngle_3 = ((acos(clamp((_e143 / 0.15915494f), -1f, 1f)) + _e147) - 3.1415927f);
    let _e150 = hitAngle_3;
    hitAngleMod = (_e150 - (floor((_e150 / 6.2831855f)) * 6.2831855f));
    let _e155 = hitAngleMod;
    let _e157 = amount;
    let _e159 = ((_e155 > 3.1415927f) && (_e157 < 0.5f));
    phi_670_ = _e159;
    if !(_e159) {
        let _e161 = hitAngleMod;
        let _e163 = amount;
        phi_670_ = ((_e161 > 1.5707964f) && (_e163 < 0f));
    }
    let _e167 = phi_670_;
    if _e167 {
        let _e168 = yc_5;
        param_27 = _e168;
        let _e169 = (*p_3);
        param_28 = _e169;
        let _e170 = rotation_2;
        param_29 = _e170;
        let _e171 = rrotation_4;
        param_30 = _e171;
        let _e172 = seeThrough((&param_27), (&param_28), (&param_29), (&param_30));
        return _e172;
    }
    let _e173 = hitAngle_3;
    param_31 = _e173;
    let _e174 = yc_5;
    param_32 = _e174;
    let _e175 = point_6;
    param_33 = _e175;
    let _e176 = rrotation_4;
    param_34 = _e176;
    let _e177 = hitPoint_u0028_f1_u003b_f1_u003b_vf3_u003b_mf33_u003b((&param_31), (&param_32), (&param_33), (&param_34));
    point_6 = _e177;
    let _e179 = point_6[0u];
    let _e180 = (_e179 < 0f);
    phi_701_ = _e180;
    if !(_e180) {
        let _e183 = point_6[1u];
        phi_701_ = (_e183 < 0f);
    }
    let _e186 = phi_701_;
    phi_708_ = _e186;
    if !(_e186) {
        let _e189 = point_6[0u];
        phi_708_ = (_e189 > 1f);
    }
    let _e192 = phi_708_;
    phi_715_ = _e192;
    if !(_e192) {
        let _e195 = point_6[1u];
        phi_715_ = (_e195 > 1f);
    }
    let _e198 = phi_715_;
    if _e198 {
        let _e199 = yc_5;
        param_35 = _e199;
        let _e200 = (*p_3);
        param_36 = _e200;
        let _e201 = point_6;
        param_37 = _e201;
        let _e202 = rotation_2;
        param_38 = _e202;
        let _e203 = rrotation_4;
        param_39 = _e203;
        let _e204 = seeThroughWithShadow((&param_35), (&param_36), (&param_37), (&param_38), (&param_39));
        return _e204;
    }
    let _e205 = yc_5;
    param_40 = _e205;
    let _e206 = point_6;
    param_41 = _e206;
    let _e207 = backside((&param_40), (&param_41));
    color_2 = _e207;
    let _e208 = yc_5;
    if (_e208 < 0f) {
        let _e211 = point_6[0u];
        dx2_ = (_e211 - 0.5f);
        let _e214 = point_6[1u];
        dy2_ = (_e214 - 0.5f);
        let _e216 = dx2_;
        let _e217 = dx2_;
        let _e219 = dy2_;
        let _e220 = dy2_;
        shado_1 = (1f - (sqrt(((_e216 * _e217) + (_e219 * _e220))) / 0.71f));
        let _e226 = yc_5;
        nyc2_ = (-(_e226) / 0.15915494f);
        let _e229 = nyc2_;
        let _e230 = nyc2_;
        let _e232 = nyc2_;
        let _e234 = shado_1;
        shado_1 = (_e234 * ((_e229 * _e230) * _e232));
        let _e236 = shado_1;
        shado_1 = (_e236 * 0.5f);
        let _e238 = shado_1;
        let _e239 = (*p_3);
        param_42 = _e239;
        let _e240 = getToColor((&param_42));
        otherColor = vec4<f32>(0f, 0f, 0f, (_e238 * _e240.w));
    } else {
        let _e244 = (*p_3);
        param_43 = _e244;
        let _e245 = getFromColor((&param_43));
        otherColor = _e245;
    }
    let _e246 = yc_5;
    let _e249 = color_2;
    param_44 = _e249;
    let _e250 = otherColor;
    param_45 = _e250;
    param_46 = (0.15915494f - abs(_e246));
    let _e251 = antiAlias((&param_44), (&param_45), (&param_46));
    color_2 = _e251;
    let _e252 = yc_5;
    param_47 = _e252;
    let _e253 = (*p_3);
    param_48 = _e253;
    let _e254 = point_6;
    param_49 = _e254;
    let _e255 = rotation_2;
    param_50 = _e255;
    let _e256 = rrotation_4;
    param_51 = _e256;
    let _e257 = seeThroughWithShadow((&param_47), (&param_48), (&param_49), (&param_50), (&param_51));
    cl = _e257;
    let _e258 = point_6;
    param_52 = _e258;
    let _e259 = distanceToEdge((&param_52));
    dist = _e259;
    let _e260 = color_2;
    param_53 = _e260;
    let _e261 = cl;
    param_54 = _e261;
    let _e262 = dist;
    param_55 = _e262;
    let _e263 = antiAlias((&param_53), (&param_54), (&param_55));
    return _e263;
}

fn main_1() {
    var param_56: vec2<f32>;

    let _e47 = _uv_1;
    param_56 = _e47;
    let _e48 = transition((&param_56));
    _fragColor = _e48;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
