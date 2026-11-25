// GeometricCollage — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GeometricCollage.glsl
// Author: gre
// License: MIT
// Description: The incoming image arrives cut into a geometric poster of quarter discs, half discs, triangles and their complements: piece after piece swings in around a corner of its cell, a flat plate of color just ahead of it, and lands flat with a soft paper shadow
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cells: i32,
    stagger: f32,
    plates: i32,
    color1_: vec4<f32>,
    color2_: vec4<f32>,
    color3_: vec4<f32>,
    shadow: f32,
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

fn boxDist(l: ptr<function, vec2<f32>>) -> f32 {
    let _e67 = (*l)[0u];
    let _e69 = (*l)[1u];
    let _e72 = (*l)[0u];
    let _e75 = (*l)[1u];
    return min(min(_e67, _e69), min((1f - _e72), (1f - _e75)));
}

fn shapeDist(o: ptr<function, vec2<f32>>, type_20: ptr<function, f32>) -> f32 {
    let _e67 = (*type_20);
    if (_e67 < 0.5f) {
        let _e69 = (*o);
        return (length(_e69) - 1f);
    }
    let _e72 = (*type_20);
    if (_e72 < 1.5f) {
        let _e74 = (*o);
        return (length((_e74 - vec2<f32>(0.5f, 0f))) - 0.5f);
    }
    let _e79 = (*o)[0u];
    let _e81 = (*o)[1u];
    return (((_e79 + _e81) - 1f) * 0.70710677f);
}

fn orient(l_1: ptr<function, vec2<f32>>, k: ptr<function, f32>) -> vec2<f32> {
    var c: vec2<f32>;

    let _e68 = (*l_1);
    c = (_e68 - vec2(0.5f));
    let _e71 = (*k);
    if (_e71 < 0.5f) {
        let _e73 = (*l_1);
        return _e73;
    }
    let _e74 = (*k);
    if (_e74 < 1.5f) {
        let _e77 = c[1u];
        let _e80 = c[0u];
        return (vec2<f32>(-(_e77), _e80) + vec2(0.5f));
    }
    let _e84 = (*k);
    if (_e84 < 2.5f) {
        let _e86 = c;
        return (vec2(0.5f) - _e86);
    }
    let _e90 = c[1u];
    let _e92 = c[0u];
    return (vec2<f32>(_e90, -(_e92)) + vec2(0.5f));
}

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e67 = (*v);
    v3_ = fract((_e67.xyx * 0.1031f));
    let _e71 = v3_;
    let _e72 = v3_;
    let _e77 = v3_;
    v3_ = (_e77 + vec3(dot(_e71, (_e72.yzx + vec3(33.33f)))));
    let _e81 = v3_[0u];
    let _e83 = v3_[1u];
    let _e86 = v3_[2u];
    return fract(((_e81 + _e83) * _e86));
}

fn pieceDist(l_2: ptr<function, vec2<f32>>, cell: ptr<function, vec2<f32>>, piece: ptr<function, f32>) -> f32 {
    var k_1: f32;
    var param: vec2<f32>;
    var sd: f32;
    var param_1: vec2<f32>;
    var param_2: f32;
    var param_3: vec2<f32>;
    var param_4: f32;
    var local: f32;

    let _e76 = (*cell);
    param = (_e76 + vec2(1.7f));
    let _e79 = hash12((&param));
    k_1 = floor((_e79 * 4f));
    let _e82 = (*l_2);
    param_1 = _e82;
    let _e83 = k_1;
    param_2 = _e83;
    let _e84 = orient((&param_1), (&param_2));
    let _e86 = (*cell)[0u];
    let _e88 = (*cell)[1u];
    let _e91 = ((_e86 + (2f * _e88)) + 1f);
    param_3 = _e84;
    param_4 = (_e91 - (floor((_e91 / 3f)) * 3f));
    let _e96 = shapeDist((&param_3), (&param_4));
    sd = _e96;
    let _e97 = (*piece);
    if (_e97 > 0.5f) {
        let _e99 = sd;
        local = -(_e99);
    } else {
        let _e101 = sd;
        local = _e101;
    }
    let _e102 = local;
    return _e102;
}

fn easeOutCubic(t: ptr<function, f32>) -> f32 {
    var u: f32;

    let _e67 = (*t);
    u = (1f - clamp(_e67, 0f, 1f));
    let _e70 = u;
    let _e71 = u;
    let _e73 = u;
    return (1f - ((_e70 * _e71) * _e73));
}

fn lift(t_1: ptr<function, f32>) -> f32 {
    let _e66 = (*t_1);
    return (1f - smoothstep(0.3f, 1f, _e66));
}

fn pivotCorner(k_2: ptr<function, f32>) -> vec2<f32> {
    let _e66 = (*k_2);
    if (_e66 < 0.5f) {
        return vec2<f32>(0f, 0f);
    }
    let _e68 = (*k_2);
    if (_e68 < 1.5f) {
        return vec2<f32>(0f, 1f);
    }
    let _e70 = (*k_2);
    if (_e70 < 2.5f) {
        return vec2<f32>(1f, 1f);
    }
    return vec2<f32>(1f, 0f);
}

fn swingPoint(p: ptr<function, vec2<f32>>, cell_1: ptr<function, vec2<f32>>, cs: ptr<function, vec2<f32>>, piece_1: ptr<function, f32>, t_2: ptr<function, f32>) -> vec3<f32> {
    var pc: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: f32;
    var piv: vec2<f32>;
    var local_1: vec2<f32>;
    var sgn: f32;
    var param_7: vec2<f32>;
    var s: f32;
    var param_8: f32;
    var a: f32;
    var param_9: f32;
    var ca: f32;
    var sa: f32;
    var d: vec2<f32>;

    let _e84 = (*cell_1);
    param_5 = (_e84 + vec2(1.7f));
    let _e87 = hash12((&param_5));
    param_6 = floor((_e87 * 4f));
    let _e90 = pivotCorner((&param_6));
    pc = _e90;
    let _e91 = (*cell_1);
    let _e92 = (*piece_1);
    if (_e92 < 0.5f) {
        let _e94 = pc;
        local_1 = _e94;
    } else {
        let _e95 = pc;
        local_1 = (vec2(1f) - _e95);
    }
    let _e98 = local_1;
    let _e100 = (*cs);
    piv = ((_e91 + _e98) * _e100);
    let _e102 = (*cell_1);
    let _e103 = (*piece_1);
    param_7 = (_e102 + vec2<f32>((_e103 * 3.3f), 5.2f));
    let _e107 = hash12((&param_7));
    sgn = select(1f, -1f, (_e107 < 0.5f));
    let _e110 = (*t_2);
    let _e112 = (*t_2);
    param_8 = _e112;
    let _e113 = lift((&param_8));
    s = (smoothstep(0f, 0.45f, _e110) * (1f + (0.1f * _e113)));
    let _e117 = sgn;
    let _e120 = (*t_2);
    param_9 = (_e120 / 0.8f);
    let _e122 = easeOutCubic((&param_9));
    a = (((_e117 * 0.5f) * 3.1415927f) * (1f - _e122));
    let _e125 = a;
    ca = cos(_e125);
    let _e127 = a;
    sa = sin(_e127);
    let _e129 = (*p);
    let _e130 = piv;
    d = (_e129 - _e130);
    let _e132 = ca;
    let _e134 = d[0u];
    let _e136 = sa;
    let _e138 = d[1u];
    let _e141 = sa;
    let _e144 = d[0u];
    let _e146 = ca;
    let _e148 = d[1u];
    let _e152 = s;
    d = (vec2<f32>(((_e132 * _e134) + (_e136 * _e138)), ((-(_e141) * _e144) + (_e146 * _e148))) / vec2(max(_e152, 0.001f)));
    let _e156 = piv;
    let _e157 = d;
    let _e159 = (*cs);
    let _e161 = (*cell_1);
    let _e162 = (((_e156 + _e157) / _e159) - _e161);
    let _e163 = s;
    return vec3<f32>(_e162.x, _e162.y, _e163);
}

fn layerShadow(p_1: ptr<function, vec2<f32>>, cell_2: ptr<function, vec2<f32>>, cs_1: ptr<function, vec2<f32>>, piece_2: ptr<function, f32>, t_3: ptr<function, f32>) -> f32 {
    var h: f32;
    var param_10: f32;
    var q: vec3<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: f32;
    var soft: f32;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: f32;
    var param_19: vec2<f32>;

    let _e83 = (*t_3);
    param_10 = _e83;
    let _e84 = lift((&param_10));
    h = _e84;
    let _e85 = (*p_1);
    let _e86 = h;
    let _e89 = (*cs_1)[1u];
    param_11 = (_e85 - ((vec2<f32>(0.07f, -0.1f) * _e86) * _e89));
    let _e92 = (*cell_2);
    param_12 = _e92;
    let _e93 = (*cs_1);
    param_13 = _e93;
    let _e94 = (*piece_2);
    param_14 = _e94;
    let _e95 = (*t_3);
    param_15 = _e95;
    let _e96 = swingPoint((&param_11), (&param_12), (&param_13), (&param_14), (&param_15));
    q = _e96;
    let _e98 = q[2u];
    if (_e98 < 0.01f) {
        return 0f;
    }
    let _e100 = h;
    soft = (0.02f + (0.05f * _e100));
    let _e103 = h;
    let _e104 = soft;
    let _e106 = soft;
    let _e107 = q;
    param_16 = _e107.xy;
    let _e109 = (*cell_2);
    param_17 = _e109;
    let _e110 = (*piece_2);
    param_18 = _e110;
    let _e111 = pieceDist((&param_16), (&param_17), (&param_18));
    let _e115 = soft;
    let _e117 = soft;
    let _e118 = q;
    param_19 = _e118.xy;
    let _e120 = boxDist((&param_19));
    return ((_e103 * (1f - smoothstep(-(_e104), _e106, _e111))) * smoothstep(-(_e115), _e117, _e120));
}

fn plateColor(cell_3: ptr<function, vec2<f32>>, piece_3: ptr<function, f32>) -> vec4<f32> {
    var c_1: f32;
    var param_20: vec2<f32>;
    var local_2: vec4<f32>;
    var local_3: vec4<f32>;

    let _e71 = (*cell_3);
    param_20 = ((_e71 * 1.3f) + vec2(0.7f));
    let _e75 = hash12((&param_20));
    let _e78 = (*piece_3);
    let _e79 = (floor((_e75 * 3f)) + _e78);
    c_1 = (_e79 - (floor((_e79 / 3f)) * 3f));
    let _e84 = c_1;
    if (_e84 < 0.5f) {
        let _e87 = uniforms.color1_;
        local_2 = _e87;
    } else {
        let _e88 = c_1;
        if (_e88 < 1.5f) {
            let _e91 = uniforms.color2_;
            local_3 = _e91;
        } else {
            let _e93 = uniforms.color3_;
            local_3 = _e93;
        }
        let _e94 = local_3;
        local_2 = _e94;
    }
    let _e95 = local_2;
    return _e95;
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e67 = (*uv)[0u];
    let _e69 = (*uv)[1u];
    let _e72 = textureSampleLevel(_to, _sampler, vec2<f32>(_e67, (1f - _e69)), 0f);
    return _e72;
}

fn premultiplied(c_2: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e66 = (*c_2);
    let _e69 = (*c_2)[3u];
    let _e70 = (_e66.xyz * _e69);
    let _e72 = (*c_2)[3u];
    return vec4<f32>(_e70.x, _e70.y, _e70.z, _e72);
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e67 = (*uv_1)[0u];
    let _e69 = (*uv_1)[1u];
    let _e72 = textureSampleLevel(_from, _sampler, vec2<f32>(_e67, (1f - _e69)), 0f);
    return _e72;
}

fn layerCover(p_2: ptr<function, vec2<f32>>, cell_4: ptr<function, vec2<f32>>, cs_2: ptr<function, vec2<f32>>, piece_4: ptr<function, f32>, t_4: ptr<function, f32>) -> vec3<f32> {
    var q_1: vec3<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var param_23: vec2<f32>;
    var param_24: f32;
    var param_25: f32;
    var e: f32;
    var m: f32;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;
    var param_28: vec2<f32>;
    var param_29: f32;

    let _e82 = (*p_2);
    param_21 = _e82;
    let _e83 = (*cell_4);
    param_22 = _e83;
    let _e84 = (*cs_2);
    param_23 = _e84;
    let _e85 = (*piece_4);
    param_24 = _e85;
    let _e86 = (*t_4);
    param_25 = _e86;
    let _e87 = swingPoint((&param_21), (&param_22), (&param_23), (&param_24), (&param_25));
    q_1 = _e87;
    let _e89 = q_1[2u];
    if (_e89 < 0.01f) {
        return vec3<f32>(0f, 0f, 0f);
    }
    let _e92 = (*cs_2)[0u];
    let _e94 = (*cs_2)[1u];
    let _e97 = q_1[2u];
    e = (0.002f / (min(_e92, _e94) * _e97));
    let _e100 = q_1;
    param_26 = _e100.xy;
    let _e102 = boxDist((&param_26));
    let _e103 = e;
    let _e107 = q_1;
    param_27 = _e107.xy;
    let _e109 = (*cell_4);
    param_28 = _e109;
    let _e110 = (*piece_4);
    param_29 = _e110;
    let _e111 = pieceDist((&param_27), (&param_28), (&param_29));
    let _e113 = e;
    m = (clamp(((_e102 / _e103) + 0.5f), 0f, 1f) * clamp(((-(_e111) / _e113) + 0.5f), 0f, 1f));
    let _e118 = m;
    let _e119 = q_1;
    let _e123 = clamp(_e119.xy, vec2(0f), vec2(1f));
    return vec3<f32>(_e118, _e123.x, _e123.y);
}

fn spread_u0028_() -> f32 {
    let _e66 = uniforms.stagger;
    return (0.61f * clamp(_e66, 0f, 1f));
}

fn startTime(cell_5: ptr<function, vec2<f32>>, n: ptr<function, vec2<f32>>) -> f32 {
    var order: f32;
    var param_30: vec2<f32>;

    let _e70 = (*cell_5)[0u];
    let _e72 = (*n)[1u];
    let _e75 = (*cell_5)[1u];
    let _e79 = (*n)[0u];
    let _e81 = (*n)[1u];
    order = ((_e70 + ((_e72 - 1f) - _e75)) / max(((_e79 + _e81) - 2f), 1f));
    let _e86 = order;
    let _e88 = (*cell_5);
    param_30 = (_e88 + vec2(4.4f));
    let _e91 = hash12((&param_30));
    order = clamp(((_e86 * 0.75f) + (0.25f * _e91)), 0f, 1f);
    let _e95 = spread_u0028_();
    let _e96 = order;
    return (0.06f + (_e95 * _e96));
}

fn swing_u0028_() -> f32 {
    let _e65 = spread_u0028_();
    return (0.85f - _e65);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var kc: f32;
    var local_4: i32;
    var n_1: vec2<f32>;
    var local_5: vec2<f32>;
    var cs_3: vec2<f32>;
    var p_3: vec2<f32>;
    var cell0_: vec2<f32>;
    var sw: f32;
    var l0_: vec2<f32>;
    var t00_: f32;
    var param_31: vec2<f32>;
    var param_32: vec2<f32>;
    var sd0_: f32;
    var param_33: vec2<f32>;
    var param_34: vec2<f32>;
    var param_35: f32;
    var e0_: f32;
    var landed: f32;
    var local_6: f32;
    var local_7: f32;
    var top: vec4<f32>;
    var topPos: vec4<f32>;
    var und: vec4<f32>;
    var undPos: vec4<f32>;
    var dy: i32;
    var dx: i32;
    var cell_6: vec2<f32>;
    var tc: f32;
    var param_36: vec2<f32>;
    var param_37: vec2<f32>;
    var pc_1: i32;
    var piece_5: f32;
    var t0_: f32;
    var tp: f32;
    var ly: i32;
    var isPlate: f32;
    var ts: f32;
    var t_5: f32;
    var L: vec3<f32>;
    var param_38: vec2<f32>;
    var param_39: vec2<f32>;
    var param_40: vec2<f32>;
    var param_41: f32;
    var param_42: f32;
    var cur: vec4<f32>;
    var curPos: vec4<f32>;
    var local_8: f32;
    var c_3: vec4<f32>;
    var param_43: vec2<f32>;
    var param_44: vec4<f32>;
    var param_45: vec2<f32>;
    var param_46: vec4<f32>;
    var uc: vec4<f32>;
    var local_9: vec4<f32>;
    var param_47: vec2<f32>;
    var param_48: f32;
    var param_49: vec2<f32>;
    var param_50: vec4<f32>;
    var tc_1: vec4<f32>;
    var local_10: vec4<f32>;
    var param_51: vec2<f32>;
    var param_52: f32;
    var param_53: vec2<f32>;
    var param_54: vec4<f32>;
    var sh: f32;
    var dy_1: i32;
    var dx_1: i32;
    var cell_7: vec2<f32>;
    var tc_2: f32;
    var param_55: vec2<f32>;
    var param_56: vec2<f32>;
    var pc_2: i32;
    var piece_6: f32;
    var t0_1: f32;
    var tp_1: f32;
    var ly_1: i32;
    var isPlate_1: f32;
    var ts_1: f32;
    var t_6: f32;
    var param_57: vec2<f32>;
    var param_58: vec2<f32>;
    var param_59: vec2<f32>;
    var param_60: f32;
    var param_61: f32;
    var local_11: vec4<f32>;
    var phi_846_: bool;
    var phi_855_: bool;
    var phi_864_: bool;
    var phi_918_: bool;
    var phi_947_: bool;
    var phi_1032_: bool;
    var phi_1040_: bool;
    var phi_1048_: bool;
    var phi_1203_: bool;
    var phi_1212_: bool;
    var phi_1221_: bool;
    var phi_1277_: bool;

    let _e152 = uniforms.cells;
    if (_e152 < 1i) {
        local_4 = 1i;
    } else {
        let _e155 = uniforms.cells;
        local_4 = _e155;
    }
    let _e156 = local_4;
    kc = f32(_e156);
    let _e159 = uniforms.ratio;
    if (_e159 >= 1f) {
        let _e162 = uniforms.ratio;
        let _e163 = kc;
        let _e168 = kc;
        local_5 = vec2<f32>(max(1f, floor(((_e162 * _e163) + 0.5f))), _e168);
    } else {
        let _e170 = kc;
        let _e171 = kc;
        let _e173 = uniforms.ratio;
        local_5 = vec2<f32>(_e170, max(1f, floor(((_e171 / _e173) + 0.5f))));
    }
    let _e179 = local_5;
    n_1 = _e179;
    let _e181 = uniforms.ratio;
    let _e183 = n_1;
    cs_3 = (vec2<f32>(_e181, 1f) / _e183);
    let _e185 = (*uv_2);
    let _e187 = uniforms.ratio;
    p_3 = (_e185 * vec2<f32>(_e187, 1f));
    let _e190 = p_3;
    let _e191 = cs_3;
    cell0_ = floor((_e190 / _e191));
    let _e194 = swing_u0028_();
    sw = _e194;
    let _e195 = p_3;
    let _e196 = cs_3;
    let _e198 = cell0_;
    l0_ = ((_e195 / _e196) - _e198);
    let _e200 = cell0_;
    param_31 = _e200;
    let _e201 = n_1;
    param_32 = _e201;
    let _e202 = startTime((&param_31), (&param_32));
    t00_ = _e202;
    let _e203 = l0_;
    param_33 = _e203;
    let _e204 = cell0_;
    param_34 = _e204;
    param_35 = 0f;
    let _e205 = pieceDist((&param_33), (&param_34), (&param_35));
    sd0_ = _e205;
    let _e207 = cs_3[0u];
    let _e209 = cs_3[1u];
    e0_ = (0.002f / min(_e207, _e209));
    let _e213 = uniforms.progress;
    let _e214 = t00_;
    let _e215 = sw;
    if (_e213 >= (_e214 + _e215)) {
        let _e218 = sd0_;
        let _e220 = e0_;
        local_6 = clamp(((-(_e218) / _e220) + 0.5f), 0f, 1f);
    } else {
        local_6 = 0f;
    }
    let _e224 = local_6;
    let _e226 = uniforms.progress;
    let _e227 = t00_;
    let _e229 = sw;
    if (_e226 >= ((_e227 + 0.07f) + _e229)) {
        let _e232 = sd0_;
        let _e233 = e0_;
        local_7 = clamp(((_e232 / _e233) + 0.5f), 0f, 1f);
    } else {
        local_7 = 0f;
    }
    let _e237 = local_7;
    landed = (_e224 + _e237);
    top = vec4<f32>(-1f, 0f, 0f, 0f);
    topPos = vec4<f32>(0f, 0f, 0f, 0f);
    und = vec4<f32>(-1f, 0f, 0f, 0f);
    undPos = vec4<f32>(0f, 0f, 0f, 0f);
    dy = -1i;
    loop {
        let _e239 = dy;
        if (_e239 <= 1i) {
            dx = -1i;
            loop {
                let _e241 = dx;
                if (_e241 <= 1i) {
                    let _e243 = cell0_;
                    let _e244 = dx;
                    let _e246 = dy;
                    cell_6 = (_e243 + vec2<f32>(f32(_e244), f32(_e246)));
                    let _e251 = cell_6[0u];
                    let _e252 = (_e251 < 0f);
                    phi_846_ = _e252;
                    if !(_e252) {
                        let _e255 = cell_6[1u];
                        phi_846_ = (_e255 < 0f);
                    }
                    let _e258 = phi_846_;
                    phi_855_ = _e258;
                    if !(_e258) {
                        let _e261 = cell_6[0u];
                        let _e263 = n_1[0u];
                        phi_855_ = (_e261 >= _e263);
                    }
                    let _e266 = phi_855_;
                    phi_864_ = _e266;
                    if !(_e266) {
                        let _e269 = cell_6[1u];
                        let _e271 = n_1[1u];
                        phi_864_ = (_e269 >= _e271);
                    }
                    let _e274 = phi_864_;
                    if _e274 {
                        continue;
                    }
                    let _e275 = cell_6;
                    param_36 = _e275;
                    let _e276 = n_1;
                    param_37 = _e276;
                    let _e277 = startTime((&param_36), (&param_37));
                    tc = _e277;
                    pc_1 = 0i;
                    loop {
                        let _e278 = pc_1;
                        if (_e278 < 2i) {
                            let _e280 = pc_1;
                            piece_5 = f32(_e280);
                            let _e282 = tc;
                            let _e283 = piece_5;
                            t0_ = (_e282 + (0.07f * _e283));
                            let _e287 = uniforms.progress;
                            let _e288 = t0_;
                            let _e290 = sw;
                            tp = ((_e287 - _e288) / _e290);
                            ly = 0i;
                            loop {
                                let _e292 = ly;
                                if (_e292 < 2i) {
                                    let _e294 = ly;
                                    isPlate = select(0f, 1f, (_e294 == 0i));
                                    let _e297 = isPlate;
                                    let _e298 = (_e297 > 0.5f);
                                    phi_918_ = _e298;
                                    if _e298 {
                                        let _e300 = uniforms.plates;
                                        phi_918_ = !((_e300 != 0i));
                                    }
                                    let _e304 = phi_918_;
                                    if _e304 {
                                        continue;
                                    }
                                    let _e305 = t0_;
                                    let _e306 = isPlate;
                                    ts = (_e305 - (0.06f * _e306));
                                    let _e310 = uniforms.progress;
                                    let _e311 = ts;
                                    let _e313 = sw;
                                    t_5 = ((_e310 - _e311) / _e313);
                                    let _e315 = t_5;
                                    let _e317 = tp;
                                    let _e319 = ((_e315 <= 0f) || (_e317 >= 1f));
                                    phi_947_ = _e319;
                                    if !(_e319) {
                                        let _e321 = isPlate;
                                        let _e323 = tp;
                                        phi_947_ = ((_e321 > 0.5f) && (_e323 >= 0.8f));
                                    }
                                    let _e327 = phi_947_;
                                    if _e327 {
                                        continue;
                                    }
                                    let _e328 = t_5;
                                    let _e330 = p_3;
                                    param_38 = _e330;
                                    let _e331 = cell_6;
                                    param_39 = _e331;
                                    let _e332 = cs_3;
                                    param_40 = _e332;
                                    let _e333 = piece_5;
                                    param_41 = _e333;
                                    param_42 = min(_e328, 1f);
                                    let _e334 = layerCover((&param_38), (&param_39), (&param_40), (&param_41), (&param_42));
                                    L = _e334;
                                    let _e335 = isPlate;
                                    if (_e335 > 0.5f) {
                                        let _e337 = tp;
                                        let _e341 = L[0u];
                                        L[0u] = (_e341 * (1f - smoothstep(0.7f, 0.8f, _e337)));
                                    }
                                    let _e345 = L[0u];
                                    if (_e345 <= 0f) {
                                        continue;
                                    }
                                    let _e347 = ts;
                                    let _e349 = L[0u];
                                    let _e350 = isPlate;
                                    let _e351 = piece_5;
                                    cur = vec4<f32>(_e347, _e349, _e350, _e351);
                                    let _e353 = cell_6;
                                    let _e354 = L;
                                    let _e355 = _e354.yz;
                                    curPos = vec4<f32>(_e353.x, _e353.y, _e355.x, _e355.y);
                                    let _e361 = ts;
                                    let _e363 = top[0u];
                                    if (_e361 > _e363) {
                                        let _e365 = top;
                                        und = _e365;
                                        let _e366 = topPos;
                                        undPos = _e366;
                                        let _e367 = cur;
                                        top = _e367;
                                        let _e368 = curPos;
                                        topPos = _e368;
                                    } else {
                                        let _e369 = ts;
                                        let _e371 = und[0u];
                                        if (_e369 > _e371) {
                                            let _e373 = cur;
                                            und = _e373;
                                            let _e374 = curPos;
                                            undPos = _e374;
                                        }
                                    }
                                    continue;
                                } else {
                                    break;
                                }
                                continuing {
                                    let _e375 = ly;
                                    ly = (_e375 + 1i);
                                }
                            }
                            continue;
                        } else {
                            break;
                        }
                        continuing {
                            let _e377 = pc_1;
                            pc_1 = (_e377 + 1i);
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e379 = dx;
                    dx = (_e379 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e381 = dy;
            dy = (_e381 + 1i);
        }
    }
    let _e384 = top[2u];
    let _e385 = (_e384 < 0.5f);
    phi_1032_ = _e385;
    if _e385 {
        let _e387 = und[0u];
        phi_1032_ = (_e387 < 0f);
    }
    let _e390 = phi_1032_;
    phi_1040_ = _e390;
    if _e390 {
        let _e392 = topPos[0u];
        let _e394 = cell0_[0u];
        phi_1040_ = (_e392 == _e394);
    }
    let _e397 = phi_1040_;
    phi_1048_ = _e397;
    if _e397 {
        let _e399 = topPos[1u];
        let _e401 = cell0_[1u];
        phi_1048_ = (_e399 == _e401);
    }
    let _e404 = phi_1048_;
    if _e404 {
        let _e406 = top[1u];
        if (_e406 < 1f) {
            let _e408 = landed;
            let _e410 = top[1u];
            local_8 = (_e408 / (1f - _e410));
        } else {
            local_8 = 1f;
        }
        let _e413 = local_8;
        landed = _e413;
    }
    let _e414 = (*uv_2);
    param_43 = _e414;
    let _e415 = getFromColor((&param_43));
    param_44 = _e415;
    let _e416 = premultiplied((&param_44));
    let _e417 = (*uv_2);
    param_45 = _e417;
    let _e418 = getToColor((&param_45));
    param_46 = _e418;
    let _e419 = premultiplied((&param_46));
    let _e420 = landed;
    c_3 = mix(_e416, _e419, vec4(clamp(_e420, 0f, 1f)));
    let _e425 = und[0u];
    if (_e425 >= 0f) {
        let _e428 = und[2u];
        if (_e428 > 0.5f) {
            let _e430 = undPos;
            param_47 = _e430.xy;
            let _e433 = und[3u];
            param_48 = _e433;
            let _e434 = plateColor((&param_47), (&param_48));
            local_9 = _e434;
        } else {
            let _e435 = undPos;
            let _e437 = undPos;
            let _e440 = cs_3;
            let _e443 = uniforms.ratio;
            param_49 = (((_e435.xy + _e437.zw) * _e440) / vec2<f32>(_e443, 1f));
            let _e446 = getToColor((&param_49));
            local_9 = _e446;
        }
        let _e447 = local_9;
        uc = _e447;
        let _e448 = c_3;
        let _e449 = uc;
        param_50 = _e449;
        let _e450 = premultiplied((&param_50));
        let _e452 = und[1u];
        c_3 = mix(_e448, _e450, vec4(_e452));
    }
    let _e456 = top[0u];
    if (_e456 >= 0f) {
        let _e459 = top[2u];
        if (_e459 > 0.5f) {
            let _e461 = topPos;
            param_51 = _e461.xy;
            let _e464 = top[3u];
            param_52 = _e464;
            let _e465 = plateColor((&param_51), (&param_52));
            local_10 = _e465;
        } else {
            let _e466 = topPos;
            let _e468 = topPos;
            let _e471 = cs_3;
            let _e474 = uniforms.ratio;
            param_53 = (((_e466.xy + _e468.zw) * _e471) / vec2<f32>(_e474, 1f));
            let _e477 = getToColor((&param_53));
            local_10 = _e477;
        }
        let _e478 = local_10;
        tc_1 = _e478;
        let _e479 = c_3;
        let _e480 = tc_1;
        param_54 = _e480;
        let _e481 = premultiplied((&param_54));
        let _e483 = top[1u];
        c_3 = mix(_e479, _e481, vec4(_e483));
    }
    sh = 0f;
    let _e487 = uniforms.shadow;
    if (_e487 > 0f) {
        dy_1 = -1i;
        loop {
            let _e489 = dy_1;
            if (_e489 <= 1i) {
                dx_1 = -1i;
                loop {
                    let _e491 = dx_1;
                    if (_e491 <= 1i) {
                        let _e493 = cell0_;
                        let _e494 = dx_1;
                        let _e496 = dy_1;
                        cell_7 = (_e493 + vec2<f32>(f32(_e494), f32(_e496)));
                        let _e501 = cell_7[0u];
                        let _e502 = (_e501 < 0f);
                        phi_1203_ = _e502;
                        if !(_e502) {
                            let _e505 = cell_7[1u];
                            phi_1203_ = (_e505 < 0f);
                        }
                        let _e508 = phi_1203_;
                        phi_1212_ = _e508;
                        if !(_e508) {
                            let _e511 = cell_7[0u];
                            let _e513 = n_1[0u];
                            phi_1212_ = (_e511 >= _e513);
                        }
                        let _e516 = phi_1212_;
                        phi_1221_ = _e516;
                        if !(_e516) {
                            let _e519 = cell_7[1u];
                            let _e521 = n_1[1u];
                            phi_1221_ = (_e519 >= _e521);
                        }
                        let _e524 = phi_1221_;
                        if _e524 {
                            continue;
                        }
                        let _e525 = cell_7;
                        param_55 = _e525;
                        let _e526 = n_1;
                        param_56 = _e526;
                        let _e527 = startTime((&param_55), (&param_56));
                        tc_2 = _e527;
                        pc_2 = 0i;
                        loop {
                            let _e528 = pc_2;
                            if (_e528 < 2i) {
                                let _e530 = pc_2;
                                piece_6 = f32(_e530);
                                let _e532 = tc_2;
                                let _e533 = piece_6;
                                t0_1 = (_e532 + (0.07f * _e533));
                                let _e537 = uniforms.progress;
                                let _e538 = t0_1;
                                let _e540 = sw;
                                tp_1 = ((_e537 - _e538) / _e540);
                                ly_1 = 0i;
                                loop {
                                    let _e542 = ly_1;
                                    if (_e542 < 2i) {
                                        let _e544 = ly_1;
                                        isPlate_1 = select(0f, 1f, (_e544 == 0i));
                                        let _e547 = isPlate_1;
                                        let _e548 = (_e547 > 0.5f);
                                        phi_1277_ = _e548;
                                        if _e548 {
                                            let _e550 = uniforms.plates;
                                            let _e553 = tp_1;
                                            phi_1277_ = (!((_e550 != 0i)) || (_e553 >= 0.8f));
                                        }
                                        let _e557 = phi_1277_;
                                        if _e557 {
                                            continue;
                                        }
                                        let _e558 = t0_1;
                                        let _e559 = isPlate_1;
                                        ts_1 = (_e558 - (0.06f * _e559));
                                        let _e563 = uniforms.progress;
                                        let _e564 = ts_1;
                                        let _e566 = sw;
                                        t_6 = ((_e563 - _e564) / _e566);
                                        let _e568 = ts_1;
                                        let _e570 = top[0u];
                                        let _e572 = t_6;
                                        let _e575 = t_6;
                                        if (((_e568 <= _e570) || (_e572 <= 0f)) || (_e575 >= 1f)) {
                                            continue;
                                        }
                                        let _e578 = sh;
                                        let _e579 = p_3;
                                        param_57 = _e579;
                                        let _e580 = cell_7;
                                        param_58 = _e580;
                                        let _e581 = cs_3;
                                        param_59 = _e581;
                                        let _e582 = piece_6;
                                        param_60 = _e582;
                                        let _e583 = t_6;
                                        param_61 = _e583;
                                        let _e584 = layerShadow((&param_57), (&param_58), (&param_59), (&param_60), (&param_61));
                                        sh = max(_e578, _e584);
                                        continue;
                                    } else {
                                        break;
                                    }
                                    continuing {
                                        let _e586 = ly_1;
                                        ly_1 = (_e586 + 1i);
                                    }
                                }
                                continue;
                            } else {
                                break;
                            }
                            continuing {
                                let _e588 = pc_2;
                                pc_2 = (_e588 + 1i);
                            }
                        }
                        continue;
                    } else {
                        break;
                    }
                    continuing {
                        let _e590 = dx_1;
                        dx_1 = (_e590 + 1i);
                    }
                }
                continue;
            } else {
                break;
            }
            continuing {
                let _e592 = dy_1;
                dy_1 = (_e592 + 1i);
            }
        }
    }
    let _e595 = uniforms.shadow;
    let _e598 = sh;
    let _e601 = c_3;
    let _e603 = (_e601.xyz * (1f - ((0.7f * clamp(_e595, 0f, 1f)) * _e598)));
    c_3[0u] = _e603.x;
    c_3[1u] = _e603.y;
    c_3[2u] = _e603.z;
    let _e611 = c_3[3u];
    if (_e611 > 0f) {
        let _e613 = c_3;
        let _e616 = c_3[3u];
        let _e618 = (_e613.xyz / vec3(_e616));
        let _e620 = c_3[3u];
        local_11 = vec4<f32>(_e618.x, _e618.y, _e618.z, _e620);
    } else {
        local_11 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e625 = local_11;
    return _e625;
}

fn main_1() {
    var param_62: vec2<f32>;

    let _e66 = _uv_1;
    param_62 = _e66;
    let _e67 = transition((&param_62));
    _fragColor = _e67;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
