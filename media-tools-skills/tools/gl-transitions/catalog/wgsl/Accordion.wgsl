// Accordion — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Accordion.glsl
// Author: gre
// License: MIT
// Description: The outgoing image folds up like a pleated paper toward one side while the incoming one unfolds out of the other, both in 3D with lit and shadowed pleats
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    pleats: i32,
    direction: vec2<f32>,
    shading: f32,
    perspective: f32,
    backColor: vec4<f32>,
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

fn panelLight(c: ptr<function, f32>, s: ptr<function, f32>, facing: ptr<function, f32>) -> f32 {
    var lambert: f32;

    let _e37 = (*c);
    let _e39 = (*facing);
    let _e40 = (*s);
    lambert = (((_e37 * 0.835f) + ((_e39 * _e40) * 0.55f)) / 0.835f);
    let _e45 = lambert;
    let _e48 = uniforms.shading;
    return mix(1f, clamp(_e45, 0.08f, 1.25f), _e48);
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv)[0u];
    let _e37 = (*uv)[1u];
    let _e40 = textureSampleLevel(_from, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv_1)[0u];
    let _e37 = (*uv_1)[1u];
    let _e40 = textureSampleLevel(_to, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn pleated(f: ptr<function, f32>, c_1: ptr<function, f32>, len: ptr<function, f32>, b: ptr<function, f32>, bLen: ptr<function, f32>, incoming: ptr<function, bool>, flipA: ptr<function, bool>, vertical: ptr<function, bool>) -> vec4<f32> {
    var m: f32;
    var local: i32;
    var s_1: f32;
    var u: f32;
    var panel: f32;
    var fu: f32;
    var tri: f32;
    var panelLen: f32;
    var z: f32;
    var scale: f32;
    var bb: f32;
    var edge: f32;
    var cover: f32;
    var a: f32;
    var local_1: f32;
    var st: vec2<f32>;
    var local_2: vec2<f32>;
    var img: vec4<f32>;
    var local_3: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var facing_1: f32;
    var toEdge: f32;
    var k: f32;
    var light: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var valley: f32;

    let _e74 = uniforms.pleats;
    if (_e74 > 1i) {
        let _e77 = uniforms.pleats;
        local = _e77;
    } else {
        local = 1i;
    }
    let _e78 = local;
    m = (2f * f32(_e78));
    let _e81 = (*c_1);
    let _e82 = (*c_1);
    s_1 = sqrt(max((1f - (_e81 * _e82)), 0f));
    let _e87 = (*f);
    let _e88 = m;
    u = (_e87 * _e88);
    let _e90 = u;
    let _e92 = m;
    panel = min(floor(_e90), (_e92 - 1f));
    let _e95 = u;
    let _e96 = panel;
    fu = (_e95 - _e96);
    let _e98 = u;
    tri = (1f - abs(((_e98 - (floor((_e98 / 2f)) * 2f)) - 1f)));
    let _e106 = (*len);
    let _e107 = m;
    panelLen = (_e106 / _e107);
    let _e109 = panelLen;
    let _e110 = s_1;
    let _e112 = tri;
    z = ((_e109 * _e110) * (1f - _e112));
    let _e116 = uniforms.perspective;
    let _e117 = z;
    scale = (1f / (1f + (_e116 * _e117)));
    let _e121 = (*b);
    let _e122 = (*bLen);
    let _e125 = scale;
    let _e127 = (*bLen);
    bb = ((((_e121 - (0.5f * _e122)) / _e125) / _e127) + 0.5f);
    let _e130 = s_1;
    let _e132 = (*c_1);
    edge = ((0.0015f * min(1f, ((20f * _e130) * _e132))) + 0.000001f);
    let _e137 = bb;
    let _e138 = bb;
    let _e141 = (*bLen);
    let _e143 = scale;
    let _e145 = edge;
    cover = clamp((((min(_e137, (1f - _e138)) * _e141) * _e143) / _e145), 0f, 1f);
    let _e148 = (*flipA);
    if _e148 {
        let _e149 = (*f);
        local_1 = (1f - _e149);
    } else {
        let _e151 = (*f);
        local_1 = _e151;
    }
    let _e152 = local_1;
    a = _e152;
    let _e153 = (*vertical);
    if _e153 {
        let _e154 = bb;
        let _e155 = a;
        local_2 = vec2<f32>(_e154, _e155);
    } else {
        let _e157 = a;
        let _e158 = bb;
        local_2 = vec2<f32>(_e157, _e158);
    }
    let _e160 = local_2;
    st = clamp(_e160, vec2(0f), vec2(1f));
    let _e164 = (*incoming);
    if _e164 {
        let _e165 = st;
        param = _e165;
        let _e166 = getToColor((&param));
        local_3 = _e166;
    } else {
        let _e167 = st;
        param_1 = _e167;
        let _e168 = getFromColor((&param_1));
        local_3 = _e168;
    }
    let _e169 = local_3;
    img = _e169;
    let _e170 = panel;
    facing_1 = select(-1f, 1f, ((_e170 - (floor((_e170 / 2f)) * 2f)) < 0.5f));
    let _e177 = fu;
    let _e178 = fu;
    let _e181 = panelLen;
    let _e183 = (*c_1);
    toEdge = ((min(_e177, (1f - _e178)) * _e181) * _e183);
    let _e185 = toEdge;
    k = (0.5f + (0.5f * clamp((_e185 / 0.0015f), 0f, 1f)));
    let _e190 = facing_1;
    let _e192 = (*c_1);
    param_2 = _e192;
    let _e193 = s_1;
    param_3 = _e193;
    param_4 = -(_e190);
    let _e194 = panelLight((&param_2), (&param_3), (&param_4));
    let _e195 = (*c_1);
    param_5 = _e195;
    let _e196 = s_1;
    param_6 = _e196;
    let _e197 = facing_1;
    param_7 = _e197;
    let _e198 = panelLight((&param_5), (&param_6), (&param_7));
    let _e199 = k;
    light = mix(_e194, _e198, _e199);
    let _e201 = tri;
    valley = (1f - _e201);
    let _e204 = uniforms.shading;
    let _e206 = s_1;
    let _e208 = valley;
    let _e210 = valley;
    let _e213 = light;
    light = (_e213 * (1f - ((((0.4f * _e204) * _e206) * _e208) * _e210)));
    let _e216 = uniforms.backColor;
    let _e217 = img;
    let _e219 = light;
    let _e220 = (_e217.xyz * _e219);
    let _e222 = img[3u];
    let _e227 = cover;
    return mix(_e216, vec4<f32>(_e220.x, _e220.y, _e220.z, _e222), vec4(_e227));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var vertical_1: bool;
    var positive: bool;
    var local_4: bool;
    var a_1: f32;
    var local_5: f32;
    var b_1: f32;
    var local_6: f32;
    var len_1: f32;
    var local_7: f32;
    var bLen_1: f32;
    var local_8: f32;
    var p: f32;
    var e: f32;
    var cFrom: f32;
    var cTo: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: bool;
    var param_14: bool;
    var param_15: bool;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;
    var param_20: f32;
    var param_21: bool;
    var param_22: bool;
    var param_23: bool;

    let _e67 = uniforms.direction[1u];
    let _e71 = uniforms.direction[0u];
    vertical_1 = (abs(_e67) > abs(_e71));
    let _e74 = vertical_1;
    if _e74 {
        let _e77 = uniforms.direction[1u];
        local_4 = (_e77 > 0f);
    } else {
        let _e81 = uniforms.direction[0u];
        local_4 = (_e81 > 0f);
    }
    let _e83 = local_4;
    positive = _e83;
    let _e84 = vertical_1;
    if _e84 {
        let _e86 = (*uv_2)[1u];
        local_5 = _e86;
    } else {
        let _e88 = (*uv_2)[0u];
        local_5 = _e88;
    }
    let _e89 = local_5;
    a_1 = _e89;
    let _e90 = positive;
    if _e90 {
        let _e91 = a_1;
        a_1 = (1f - _e91);
    }
    let _e93 = vertical_1;
    if _e93 {
        let _e95 = (*uv_2)[0u];
        local_6 = _e95;
    } else {
        let _e97 = (*uv_2)[1u];
        local_6 = _e97;
    }
    let _e98 = local_6;
    b_1 = _e98;
    let _e99 = vertical_1;
    if _e99 {
        local_7 = 1f;
    } else {
        let _e101 = uniforms.ratio;
        local_7 = _e101;
    }
    let _e102 = local_7;
    len_1 = _e102;
    let _e103 = vertical_1;
    if _e103 {
        let _e105 = uniforms.ratio;
        local_8 = _e105;
    } else {
        local_8 = 1f;
    }
    let _e106 = local_8;
    bLen_1 = _e106;
    let _e108 = uniforms.progress;
    p = _e108;
    let _e109 = p;
    let _e110 = p;
    let _e112 = p;
    e = ((_e109 * _e110) * (3f - (2f * _e112)));
    let _e116 = p;
    let _e117 = e;
    e = mix(_e116, _e117, 0.8f);
    let _e119 = e;
    cFrom = (1f - _e119);
    let _e121 = e;
    cTo = _e121;
    let _e122 = a_1;
    let _e123 = cFrom;
    let _e125 = cTo;
    if ((_e122 < _e123) || (_e125 <= 0f)) {
        let _e128 = a_1;
        let _e129 = cFrom;
        let _e131 = b_1;
        let _e132 = bLen_1;
        param_8 = (_e128 / _e129);
        let _e134 = cFrom;
        param_9 = _e134;
        let _e135 = len_1;
        param_10 = _e135;
        param_11 = (_e131 * _e132);
        let _e136 = bLen_1;
        param_12 = _e136;
        param_13 = false;
        let _e137 = positive;
        param_14 = _e137;
        let _e138 = vertical_1;
        param_15 = _e138;
        let _e139 = pleated((&param_8), (&param_9), (&param_10), (&param_11), (&param_12), (&param_13), (&param_14), (&param_15));
        return _e139;
    }
    let _e140 = a_1;
    let _e142 = cTo;
    let _e145 = b_1;
    let _e146 = bLen_1;
    param_16 = (1f - ((1f - _e140) / _e142));
    let _e148 = cTo;
    param_17 = _e148;
    let _e149 = len_1;
    param_18 = _e149;
    param_19 = (_e145 * _e146);
    let _e150 = bLen_1;
    param_20 = _e150;
    param_21 = true;
    let _e151 = positive;
    param_22 = _e151;
    let _e152 = vertical_1;
    param_23 = _e152;
    let _e153 = pleated((&param_16), (&param_17), (&param_18), (&param_19), (&param_20), (&param_21), (&param_22), (&param_23));
    return _e153;
}

fn main_1() {
    var param_24: vec2<f32>;

    let _e34 = _uv_1;
    param_24 = _e34;
    let _e35 = transition((&param_24));
    _fragColor = _e35;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
