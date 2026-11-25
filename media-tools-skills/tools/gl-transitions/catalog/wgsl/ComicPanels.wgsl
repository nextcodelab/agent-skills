// ComicPanels — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ComicPanels.glsl
// Author: gre
// License: MIT
// Description: The frame splits into slanted comic-book panels with gutters and ink borders; one after another in reading order, each panel lifts off the page with a zoom kick and a drop shadow and punches over to the incoming image, then the gutters close up over the full incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    gutter: f32,
    gutterColor: vec4<f32>,
    borderColor: vec4<f32>,
    seed: f32,
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

fn lift(t: ptr<function, f32>) -> f32 {
    var u: f32;

    let _e64 = (*t);
    let _e66 = (*t);
    u = (1f - ((1f - _e64) * (1f - _e66)));
    let _e70 = u;
    return sin((3.1415927f * _e70));
}

fn drawPanel(color: ptr<function, vec4<f32>>, img: ptr<function, vec4<f32>>, d: ptr<function, f32>, g: ptr<function, f32>, ink: ptr<function, f32>, fade: ptr<function, f32>) -> vec4<f32> {
    var c: vec4<f32>;

    let _e70 = uniforms.borderColor;
    let _e71 = (*img);
    let _e72 = (*g);
    let _e73 = (*ink);
    let _e76 = (*g);
    let _e77 = (*ink);
    let _e80 = (*d);
    let _e82 = (*fade);
    c = mix(_e70, _e71, vec4(mix(1f, smoothstep(((_e72 + _e73) - 0.0012f), ((_e76 + _e77) + 0.0012f), _e80), _e82)));
    let _e86 = (*color);
    let _e87 = c;
    let _e88 = (*g);
    let _e90 = (*g);
    let _e92 = (*d);
    let _e94 = (*fade);
    return mix(_e86, _e87, vec4(mix(1f, smoothstep((_e88 - 0.0012f), (_e90 + 0.0012f), _e92), _e94)));
}

fn hash(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e64 = (*v);
    v3_ = fract((_e64.xyx * 0.1031f));
    let _e68 = v3_;
    let _e69 = v3_;
    let _e74 = v3_;
    v3_ = (_e74 + vec3(dot(_e68, (_e69.yzx + vec3(33.33f)))));
    let _e78 = v3_[0u];
    let _e80 = v3_[1u];
    let _e83 = v3_[2u];
    return fract(((_e78 + _e80) * _e83));
}

fn colDist(r: ptr<function, f32>, j: ptr<function, f32>, n: ptr<function, f32>, p: ptr<function, vec2<f32>>) -> f32 {
    var x: f32;
    var param: vec2<f32>;
    var s: f32;
    var param_1: vec2<f32>;

    let _e70 = (*j);
    if (_e70 < 0.5f) {
        let _e73 = (*p)[0u];
        return _e73;
    }
    let _e74 = (*j);
    let _e75 = (*n);
    if (_e74 > (_e75 - 0.5f)) {
        let _e79 = (*p)[0u];
        let _e81 = uniforms.ratio;
        return (_e79 - _e81);
    }
    let _e83 = (*j);
    let _e84 = (*r);
    let _e86 = (*j);
    let _e90 = uniforms.seed;
    param = vec2<f32>(((_e84 * 3f) + (_e86 * 13f)), ((_e90 * 1.37f) + 2f));
    let _e94 = hash((&param));
    let _e98 = (*n);
    x = ((_e83 + ((_e94 - 0.5f) * 0.45f)) / _e98);
    let _e100 = (*r);
    let _e102 = (*j);
    let _e106 = uniforms.seed;
    param_1 = vec2<f32>(((_e100 * 11f) + (_e102 * 5f)), ((_e106 * 1.37f) + 7f));
    let _e110 = hash((&param_1));
    s = ((_e110 - 0.5f) * 0.5f);
    let _e114 = (*p)[0u];
    let _e116 = uniforms.ratio;
    let _e117 = x;
    let _e118 = s;
    let _e120 = (*p)[1u];
    let _e127 = uniforms.ratio;
    let _e129 = uniforms.ratio;
    let _e131 = s;
    let _e133 = s;
    return ((_e114 - (_e116 * (_e117 + (_e118 * (_e120 - 0.5f))))) / sqrt((1f + (((_e127 * _e129) * _e131) * _e133))));
}

fn rowDist(k: ptr<function, f32>, p_1: ptr<function, vec2<f32>>) -> f32 {
    var y: f32;
    var param_2: vec2<f32>;
    var s_1: f32;
    var param_3: vec2<f32>;

    let _e68 = (*k);
    if (_e68 < 0.5f) {
        let _e71 = (*p_1)[1u];
        return _e71;
    }
    let _e72 = (*k);
    if (_e72 > 2.5f) {
        let _e75 = (*p_1)[1u];
        return (_e75 - 1f);
    }
    let _e77 = (*k);
    let _e78 = (*k);
    let _e82 = uniforms.seed;
    param_2 = vec2<f32>(((_e78 * 5f) + 1f), (_e82 * 1.37f));
    let _e85 = hash((&param_2));
    y = ((_e77 + ((_e85 - 0.5f) * 0.35f)) / 3f);
    let _e90 = (*k);
    let _e94 = uniforms.seed;
    param_3 = vec2<f32>(((_e90 * 9f) + 4f), ((_e94 * 1.37f) + 5f));
    let _e98 = hash((&param_3));
    s_1 = ((_e98 - 0.5f) * 0.24f);
    let _e102 = (*p_1)[1u];
    let _e103 = y;
    let _e105 = s_1;
    let _e107 = (*p_1)[0u];
    let _e109 = uniforms.ratio;
    let _e114 = s_1;
    let _e115 = s_1;
    let _e118 = uniforms.ratio;
    let _e120 = uniforms.ratio;
    return (((_e102 - _e103) - (_e105 * ((_e107 / _e109) - 0.5f))) / sqrt((1f + ((_e114 * _e115) / (_e118 * _e120)))));
}

fn panelDist(r_1: ptr<function, f32>, c_1: ptr<function, f32>, n_1: ptr<function, f32>, p_2: ptr<function, vec2<f32>>) -> f32 {
    var param_4: f32;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: vec2<f32>;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: vec2<f32>;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: vec2<f32>;

    let _e78 = (*r_1);
    param_4 = _e78;
    let _e79 = (*p_2);
    param_5 = _e79;
    let _e80 = rowDist((&param_4), (&param_5));
    let _e81 = (*r_1);
    param_6 = (_e81 + 1f);
    let _e83 = (*p_2);
    param_7 = _e83;
    let _e84 = rowDist((&param_6), (&param_7));
    let _e87 = (*r_1);
    param_8 = _e87;
    let _e88 = (*c_1);
    param_9 = _e88;
    let _e89 = (*n_1);
    param_10 = _e89;
    let _e90 = (*p_2);
    param_11 = _e90;
    let _e91 = colDist((&param_8), (&param_9), (&param_10), (&param_11));
    let _e92 = (*c_1);
    let _e94 = (*r_1);
    param_12 = _e94;
    param_13 = (_e92 + 1f);
    let _e95 = (*n_1);
    param_14 = _e95;
    let _e96 = (*p_2);
    param_15 = _e96;
    let _e97 = colDist((&param_12), (&param_13), (&param_14), (&param_15));
    return min(min(_e80, -(_e84)), min(_e91, -(_e97)));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e64 = (*uv)[0u];
    let _e66 = (*uv)[1u];
    let _e69 = textureSampleLevel(_to, _sampler, vec2<f32>(_e64, (1f - _e66)), 0f);
    return _e69;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e64 = (*uv_1)[0u];
    let _e66 = (*uv_1)[1u];
    let _e69 = textureSampleLevel(_from, _sampler, vec2<f32>(_e64, (1f - _e66)), 0f);
    return _e69;
}

fn panelImage(p_3: ptr<function, vec2<f32>>, center: ptr<function, vec2<f32>>, t_1: ptr<function, f32>) -> vec4<f32> {
    var k_1: f32;
    var param_16: f32;
    var q: vec2<f32>;
    var uv_2: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var v_1: vec2<f32>;
    var a: f32;
    var i: f32;
    var spike: f32;
    var param_19: vec2<f32>;
    var burst: f32;
    var d_1: f32;
    var w: f32;
    var c_2: vec4<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;

    let _e82 = (*t_1);
    param_16 = _e82;
    let _e83 = lift((&param_16));
    k_1 = _e83;
    let _e84 = (*center);
    let _e85 = (*p_3);
    let _e86 = (*center);
    let _e88 = k_1;
    q = (_e84 + ((_e85 - _e86) / vec2((1f + (0.1f * _e88)))));
    let _e95 = q[0u];
    let _e97 = uniforms.ratio;
    let _e100 = q[1u];
    uv_2 = vec2<f32>((_e95 / _e97), (1f - _e100));
    let _e103 = (*t_1);
    if (_e103 <= 0f) {
        let _e105 = uv_2;
        param_17 = _e105;
        let _e106 = getFromColor((&param_17));
        return _e106;
    }
    let _e107 = (*t_1);
    if (_e107 >= 1f) {
        let _e109 = uv_2;
        param_18 = _e109;
        let _e110 = getToColor((&param_18));
        return _e110;
    }
    let _e111 = (*p_3);
    let _e112 = (*center);
    v_1 = (_e111 - _e112);
    let _e115 = v_1[1u];
    let _e117 = v_1[0u];
    let _e124 = (*center)[0u];
    a = ((((atan2(_e115, (_e117 + 0.000001f)) + 3.1415927f) / 6.2831855f) * 11f) + (_e124 * 7f));
    let _e127 = a;
    i = floor(_e127);
    let _e129 = a;
    let _e130 = i;
    let _e136 = i;
    let _e142 = (*center)[1u];
    let _e145 = uniforms.seed;
    param_19 = vec2<f32>((_e136 - (floor((_e136 / 11f)) * 11f)), ((_e142 * 13f) + _e145));
    let _e148 = hash((&param_19));
    spike = ((1f - abs(((2f * (_e129 - _e130)) - 1f))) * (0.5f + (0.5f * _e148)));
    let _e153 = uniforms.ratio;
    let _e157 = (*t_1);
    burst = ((1.5f * max(1f, (_e153 / 1.8f))) * smoothstep(0.06f, 0.42f, _e157));
    let _e160 = v_1;
    let _e162 = burst;
    let _e163 = spike;
    d_1 = (length(_e160) - (_e162 * (0.62f + (0.38f * _e163))));
    w = 0.007f;
    let _e168 = uv_2;
    param_20 = _e168;
    let _e169 = getToColor((&param_20));
    let _e171 = uniforms.borderColor;
    let _e172 = w;
    let _e175 = w;
    let _e178 = d_1;
    c_2 = mix(_e169, _e171, vec4(smoothstep((-(_e172) - 0.0012f), (-(_e175) + 0.0012f), _e178)));
    let _e182 = c_2;
    let _e183 = uv_2;
    param_21 = _e183;
    let _e184 = getFromColor((&param_21));
    let _e185 = d_1;
    return mix(_e182, _e184, vec4(smoothstep(-0.0012f, 0.0012f, _e185)));
}

fn panelCenter(r_2: ptr<function, f32>, c_3: ptr<function, f32>, n_2: ptr<function, f32>) -> vec2<f32> {
    var y0_: f32;
    var param_22: f32;
    var param_23: vec2<f32>;
    var param_24: f32;
    var param_25: vec2<f32>;
    var y1_: f32;
    var param_26: f32;
    var param_27: vec2<f32>;
    var param_28: f32;
    var param_29: vec2<f32>;
    var y_1: f32;
    var x0_: f32;
    var param_30: f32;
    var param_31: f32;
    var param_32: f32;
    var param_33: vec2<f32>;
    var param_34: f32;
    var param_35: f32;
    var param_36: f32;
    var param_37: vec2<f32>;
    var x1_: f32;
    var param_38: f32;
    var param_39: f32;
    var param_40: f32;
    var param_41: vec2<f32>;
    var param_42: f32;
    var param_43: f32;
    var param_44: f32;
    var param_45: vec2<f32>;

    let _e95 = uniforms.ratio;
    let _e98 = (*r_2);
    param_22 = _e98;
    param_23 = vec2<f32>((0.5f * _e95), 0f);
    let _e99 = rowDist((&param_22), (&param_23));
    let _e100 = (*r_2);
    let _e103 = uniforms.ratio;
    param_24 = (_e100 + 1f);
    param_25 = vec2<f32>((0.5f * _e103), 0f);
    let _e106 = rowDist((&param_24), (&param_25));
    y0_ = (_e99 + _e106);
    let _e109 = uniforms.ratio;
    let _e112 = (*r_2);
    param_26 = _e112;
    param_27 = vec2<f32>((0.5f * _e109), 1f);
    let _e113 = rowDist((&param_26), (&param_27));
    let _e114 = (*r_2);
    let _e117 = uniforms.ratio;
    param_28 = (_e114 + 1f);
    param_29 = vec2<f32>((0.5f * _e117), 1f);
    let _e120 = rowDist((&param_28), (&param_29));
    y1_ = (_e113 + _e120);
    let _e122 = y0_;
    let _e123 = y0_;
    let _e124 = y1_;
    y_1 = (_e122 / (_e123 - _e124));
    let _e127 = y_1;
    let _e129 = (*r_2);
    param_30 = _e129;
    let _e130 = (*c_3);
    param_31 = _e130;
    let _e131 = (*n_2);
    param_32 = _e131;
    param_33 = vec2<f32>(0f, _e127);
    let _e132 = colDist((&param_30), (&param_31), (&param_32), (&param_33));
    let _e133 = (*c_3);
    let _e135 = y_1;
    let _e137 = (*r_2);
    param_34 = _e137;
    param_35 = (_e133 + 1f);
    let _e138 = (*n_2);
    param_36 = _e138;
    param_37 = vec2<f32>(0f, _e135);
    let _e139 = colDist((&param_34), (&param_35), (&param_36), (&param_37));
    x0_ = (_e132 + _e139);
    let _e141 = y_1;
    let _e143 = (*r_2);
    param_38 = _e143;
    let _e144 = (*c_3);
    param_39 = _e144;
    let _e145 = (*n_2);
    param_40 = _e145;
    param_41 = vec2<f32>(1f, _e141);
    let _e146 = colDist((&param_38), (&param_39), (&param_40), (&param_41));
    let _e147 = (*c_3);
    let _e149 = y_1;
    let _e151 = (*r_2);
    param_42 = _e151;
    param_43 = (_e147 + 1f);
    let _e152 = (*n_2);
    param_44 = _e152;
    param_45 = vec2<f32>(1f, _e149);
    let _e153 = colDist((&param_42), (&param_43), (&param_44), (&param_45));
    x1_ = (_e146 + _e153);
    let _e155 = x0_;
    let _e156 = x0_;
    let _e157 = x1_;
    let _e160 = y_1;
    return vec2<f32>((_e155 / (_e156 - _e157)), _e160);
}

fn panelTime(k_2: ptr<function, f32>, total: ptr<function, f32>) -> f32 {
    var t0_: f32;

    let _e65 = (*k_2);
    let _e67 = (*total);
    t0_ = (0.05f + ((0.62f * _e65) / max((_e67 - 1f), 1f)));
    let _e73 = uniforms.progress;
    let _e74 = t0_;
    return clamp(((_e73 - _e74) / 0.3f), 0f, 1f);
}

fn cols(r_3: ptr<function, f32>) -> f32 {
    var h: f32;
    var param_46: vec2<f32>;
    var n_3: f32;
    var local: f32;

    let _e67 = (*r_3);
    let _e71 = uniforms.seed;
    param_46 = vec2<f32>(((_e67 * 7f) + 3f), ((_e71 * 1.37f) + 11f));
    let _e75 = hash((&param_46));
    h = _e75;
    let _e76 = h;
    if (_e76 < 0.15f) {
        local = 1f;
    } else {
        let _e78 = h;
        local = select(3f, 2f, (_e78 < 0.6f));
    }
    let _e81 = local;
    n_3 = _e81;
    let _e82 = (*r_3);
    if (_e82 == 1f) {
        let _e84 = n_3;
        n_3 = max(_e84, 2f);
    }
    let _e87 = uniforms.ratio;
    if (_e87 < 0.8f) {
        let _e89 = n_3;
        n_3 = min(_e89, 2f);
    }
    let _e91 = n_3;
    return _e91;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_47: vec2<f32>;
    var param_48: vec2<f32>;
    var p_4: vec2<f32>;
    var open: f32;
    var g_1: f32;
    var ink_1: f32;
    var fade_1: f32;
    var n0_: f32;
    var param_49: f32;
    var n1_: f32;
    var param_50: f32;
    var n2_: f32;
    var param_51: f32;
    var total_1: f32;
    var r_4: f32;
    var param_52: f32;
    var param_53: vec2<f32>;
    var local_1: f32;
    var param_54: f32;
    var param_55: vec2<f32>;
    var n_4: f32;
    var local_2: f32;
    var c_4: f32;
    var param_56: f32;
    var param_57: f32;
    var param_58: f32;
    var param_59: vec2<f32>;
    var local_3: f32;
    var param_60: f32;
    var param_61: f32;
    var param_62: f32;
    var param_63: vec2<f32>;
    var first: f32;
    var local_4: f32;
    var local_5: f32;
    var t_2: f32;
    var param_64: f32;
    var param_65: f32;
    var color_1: vec4<f32>;
    var param_66: f32;
    var param_67: f32;
    var param_68: f32;
    var param_69: vec2<f32>;
    var param_70: vec2<f32>;
    var param_71: f32;
    var param_72: f32;
    var param_73: f32;
    var param_74: f32;
    var param_75: vec2<f32>;
    var param_76: vec4<f32>;
    var param_77: vec4<f32>;
    var param_78: f32;
    var param_79: f32;
    var param_80: f32;
    var param_81: f32;
    var spacing: f32;
    var kFirst: f32;
    var i_1: i32;
    var pk: f32;
    var pt: f32;
    var param_82: f32;
    var param_83: f32;
    var pr: f32;
    var local_6: f32;
    var pn: f32;
    var local_7: f32;
    var pc: f32;
    var local_8: f32;
    var local_9: f32;
    var k_3: f32;
    var param_84: f32;
    var center_1: vec2<f32>;
    var param_85: f32;
    var param_86: f32;
    var param_87: f32;
    var s_2: f32;
    var sq: vec2<f32>;
    var sd: f32;
    var param_88: f32;
    var param_89: f32;
    var param_90: f32;
    var param_91: vec2<f32>;
    var q_1: vec2<f32>;
    var param_92: vec2<f32>;
    var param_93: vec2<f32>;
    var param_94: f32;
    var param_95: f32;
    var param_96: f32;
    var param_97: f32;
    var param_98: vec2<f32>;
    var param_99: vec4<f32>;
    var param_100: vec4<f32>;
    var param_101: f32;
    var param_102: f32;
    var param_103: f32;
    var param_104: f32;
    var phi_942_: bool;

    let _e160 = uniforms.progress;
    if (_e160 <= 0f) {
        let _e162 = (*uv_3);
        param_47 = _e162;
        let _e163 = getFromColor((&param_47));
        return _e163;
    }
    let _e165 = uniforms.progress;
    if (_e165 >= 1f) {
        let _e167 = (*uv_3);
        param_48 = _e167;
        let _e168 = getToColor((&param_48));
        return _e168;
    }
    let _e170 = (*uv_3)[0u];
    let _e172 = uniforms.ratio;
    let _e175 = (*uv_3)[1u];
    p_4 = vec2<f32>((_e170 * _e172), (1f - _e175));
    let _e179 = uniforms.progress;
    let _e182 = uniforms.progress;
    open = (smoothstep(0f, 0.14f, _e179) * (1f - smoothstep(0.8f, 1f, _e182)));
    let _e187 = uniforms.gutter;
    let _e189 = open;
    g_1 = ((0.5f * _e187) * _e189);
    let _e191 = open;
    ink_1 = (0.005f * _e191);
    let _e193 = open;
    fade_1 = clamp((_e193 * 6f), 0f, 1f);
    param_49 = 0f;
    let _e196 = cols((&param_49));
    n0_ = _e196;
    param_50 = 1f;
    let _e197 = cols((&param_50));
    n1_ = _e197;
    param_51 = 2f;
    let _e198 = cols((&param_51));
    n2_ = _e198;
    let _e199 = n0_;
    let _e200 = n1_;
    let _e202 = n2_;
    total_1 = ((_e199 + _e200) + _e202);
    param_52 = 1f;
    let _e204 = p_4;
    param_53 = _e204;
    let _e205 = rowDist((&param_52), (&param_53));
    if (_e205 < 0f) {
        local_1 = 0f;
    } else {
        param_54 = 2f;
        let _e207 = p_4;
        param_55 = _e207;
        let _e208 = rowDist((&param_54), (&param_55));
        local_1 = select(2f, 1f, (_e208 < 0f));
    }
    let _e211 = local_1;
    r_4 = _e211;
    let _e212 = r_4;
    if (_e212 == 0f) {
        let _e214 = n0_;
        local_2 = _e214;
    } else {
        let _e215 = r_4;
        let _e217 = n1_;
        let _e218 = n2_;
        local_2 = select(_e218, _e217, (_e215 == 1f));
    }
    let _e220 = local_2;
    n_4 = _e220;
    let _e221 = r_4;
    param_56 = _e221;
    param_57 = 1f;
    let _e222 = n_4;
    param_58 = _e222;
    let _e223 = p_4;
    param_59 = _e223;
    let _e224 = colDist((&param_56), (&param_57), (&param_58), (&param_59));
    if (_e224 < 0f) {
        local_3 = 0f;
    } else {
        let _e226 = r_4;
        param_60 = _e226;
        param_61 = 2f;
        let _e227 = n_4;
        param_62 = _e227;
        let _e228 = p_4;
        param_63 = _e228;
        let _e229 = colDist((&param_60), (&param_61), (&param_62), (&param_63));
        let _e231 = n_4;
        local_3 = select(2f, 1f, ((_e229 < 0f) || (_e231 < 2.5f)));
    }
    let _e235 = local_3;
    c_4 = _e235;
    let _e236 = c_4;
    let _e237 = n_4;
    c_4 = min(_e236, (_e237 - 1f));
    let _e240 = r_4;
    if (_e240 == 0f) {
        local_4 = 0f;
    } else {
        let _e242 = r_4;
        if (_e242 == 1f) {
            let _e244 = n0_;
            local_5 = _e244;
        } else {
            let _e245 = n0_;
            let _e246 = n1_;
            local_5 = (_e245 + _e246);
        }
        let _e248 = local_5;
        local_4 = _e248;
    }
    let _e249 = local_4;
    first = _e249;
    let _e250 = first;
    let _e251 = c_4;
    param_64 = (_e250 + _e251);
    let _e253 = total_1;
    param_65 = _e253;
    let _e254 = panelTime((&param_64), (&param_65));
    t_2 = _e254;
    let _e256 = uniforms.gutterColor;
    color_1 = _e256;
    let _e257 = t_2;
    let _e259 = t_2;
    if ((_e257 <= 0f) || (_e259 >= 1f)) {
        let _e262 = r_4;
        param_66 = _e262;
        let _e263 = c_4;
        param_67 = _e263;
        let _e264 = n_4;
        param_68 = _e264;
        let _e265 = panelCenter((&param_66), (&param_67), (&param_68));
        let _e266 = p_4;
        param_69 = _e266;
        param_70 = _e265;
        let _e267 = t_2;
        param_71 = _e267;
        let _e268 = panelImage((&param_69), (&param_70), (&param_71));
        let _e269 = r_4;
        param_72 = _e269;
        let _e270 = c_4;
        param_73 = _e270;
        let _e271 = n_4;
        param_74 = _e271;
        let _e272 = p_4;
        param_75 = _e272;
        let _e273 = panelDist((&param_72), (&param_73), (&param_74), (&param_75));
        let _e274 = color_1;
        param_76 = _e274;
        param_77 = _e268;
        param_78 = _e273;
        let _e275 = g_1;
        param_79 = _e275;
        let _e276 = ink_1;
        param_80 = _e276;
        let _e277 = fade_1;
        param_81 = _e277;
        let _e278 = drawPanel((&param_76), (&param_77), (&param_78), (&param_79), (&param_80), (&param_81));
        color_1 = _e278;
    }
    let _e279 = total_1;
    spacing = (0.62f / max((_e279 - 1f), 1f));
    let _e284 = uniforms.progress;
    let _e287 = spacing;
    kFirst = (floor(((((_e284 - 0.05f) - 0.3f) / _e287) - 0.01f)) + 1f);
    i_1 = 0i;
    loop {
        let _e292 = i_1;
        if (_e292 < 4i) {
            let _e294 = kFirst;
            let _e295 = i_1;
            pk = (_e294 + f32(_e295));
            let _e298 = pk;
            let _e299 = (_e298 < 0f);
            phi_942_ = _e299;
            if !(_e299) {
                let _e301 = pk;
                let _e302 = total_1;
                phi_942_ = (_e301 > (_e302 - 0.5f));
            }
            let _e306 = phi_942_;
            if _e306 {
                continue;
            }
            let _e307 = pk;
            param_82 = _e307;
            let _e308 = total_1;
            param_83 = _e308;
            let _e309 = panelTime((&param_82), (&param_83));
            pt = _e309;
            let _e310 = pt;
            let _e312 = pt;
            if ((_e310 <= 0f) || (_e312 >= 1f)) {
                continue;
            }
            let _e315 = pk;
            let _e316 = n0_;
            if (_e315 < _e316) {
                local_6 = 0f;
            } else {
                let _e318 = pk;
                let _e319 = n0_;
                let _e320 = n1_;
                local_6 = select(2f, 1f, (_e318 < (_e319 + _e320)));
            }
            let _e324 = local_6;
            pr = _e324;
            let _e325 = pr;
            if (_e325 == 0f) {
                let _e327 = n0_;
                local_7 = _e327;
            } else {
                let _e328 = pr;
                let _e330 = n1_;
                let _e331 = n2_;
                local_7 = select(_e331, _e330, (_e328 == 1f));
            }
            let _e333 = local_7;
            pn = _e333;
            let _e334 = pk;
            let _e335 = pr;
            if (_e335 == 0f) {
                local_8 = 0f;
            } else {
                let _e337 = pr;
                if (_e337 == 1f) {
                    let _e339 = n0_;
                    local_9 = _e339;
                } else {
                    let _e340 = n0_;
                    let _e341 = n1_;
                    local_9 = (_e340 + _e341);
                }
                let _e343 = local_9;
                local_8 = _e343;
            }
            let _e344 = local_8;
            pc = (_e334 - _e344);
            let _e346 = pt;
            param_84 = _e346;
            let _e347 = lift((&param_84));
            k_3 = _e347;
            let _e348 = pr;
            param_85 = _e348;
            let _e349 = pc;
            param_86 = _e349;
            let _e350 = pn;
            param_87 = _e350;
            let _e351 = panelCenter((&param_85), (&param_86), (&param_87));
            center_1 = _e351;
            let _e352 = k_3;
            s_2 = (1f + (0.08f * _e352));
            let _e355 = center_1;
            let _e356 = p_4;
            let _e357 = k_3;
            let _e360 = center_1;
            let _e362 = s_2;
            sq = (_e355 + (((_e356 - (vec2<f32>(0.012f, 0.018f) * _e357)) - _e360) / vec2(_e362)));
            let _e366 = pr;
            param_88 = _e366;
            let _e367 = pc;
            param_89 = _e367;
            let _e368 = pn;
            param_90 = _e368;
            let _e369 = sq;
            param_91 = _e369;
            let _e370 = panelDist((&param_88), (&param_89), (&param_90), (&param_91));
            let _e371 = g_1;
            sd = (_e370 - _e371);
            let _e373 = k_3;
            let _e375 = fade_1;
            let _e377 = sd;
            let _e381 = color_1;
            let _e383 = (_e381.xyz * (1f - (((0.4f * _e373) * _e375) * smoothstep(-0.02f, 0.01f, _e377))));
            color_1[0u] = _e383.x;
            color_1[1u] = _e383.y;
            color_1[2u] = _e383.z;
            let _e390 = center_1;
            let _e391 = p_4;
            let _e392 = center_1;
            let _e394 = s_2;
            q_1 = (_e390 + ((_e391 - _e392) / vec2(_e394)));
            let _e398 = q_1;
            param_92 = _e398;
            let _e399 = center_1;
            param_93 = _e399;
            let _e400 = pt;
            param_94 = _e400;
            let _e401 = panelImage((&param_92), (&param_93), (&param_94));
            let _e402 = pr;
            param_95 = _e402;
            let _e403 = pc;
            param_96 = _e403;
            let _e404 = pn;
            param_97 = _e404;
            let _e405 = q_1;
            param_98 = _e405;
            let _e406 = panelDist((&param_95), (&param_96), (&param_97), (&param_98));
            let _e407 = color_1;
            param_99 = _e407;
            param_100 = _e401;
            param_101 = _e406;
            let _e408 = g_1;
            param_102 = _e408;
            let _e409 = ink_1;
            param_103 = _e409;
            param_104 = 1f;
            let _e410 = drawPanel((&param_99), (&param_100), (&param_101), (&param_102), (&param_103), (&param_104));
            color_1 = _e410;
            continue;
        } else {
            break;
        }
        continuing {
            let _e411 = i_1;
            i_1 = (_e411 + 1i);
        }
    }
    let _e413 = color_1;
    return _e413;
}

fn main_1() {
    var param_105: vec2<f32>;

    let _e63 = _uv_1;
    param_105 = _e63;
    let _e64 = transition((&param_105));
    _fragColor = _e64;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
