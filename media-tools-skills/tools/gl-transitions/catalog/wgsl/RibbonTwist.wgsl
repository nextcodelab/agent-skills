// RibbonTwist — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RibbonTwist.glsl
// Author: gre
// License: MIT
// Description: The image twists like a ribbon around its horizontal center line, the twist travelling smoothly across its width, the outgoing image on its front and the incoming one on its back
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    spread: f32,
    perspective: f32,
    shading: f32,
    vertical: i32,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e27 = (*uv)[0u];
    let _e29 = (*uv)[1u];
    let _e32 = textureSampleLevel(_to, _sampler, vec2<f32>(_e27, (1f - _e29)), 0f);
    return _e32;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e27 = (*uv_1)[0u];
    let _e29 = (*uv_1)[1u];
    let _e32 = textureSampleLevel(_from, _sampler, vec2<f32>(_e27, (1f - _e29)), 0f);
    return _e32;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var q: vec2<f32>;
    var local: vec2<f32>;
    var halfSize: f32;
    var local_1: f32;
    var t: f32;
    var front: bool;
    var angle: f32;
    var local_2: f32;
    var c: f32;
    var s: f32;
    var w: f32;
    var den: f32;
    var v: f32;
    var edge: f32;
    var top: f32;
    var bottom: f32;
    var cover: f32;
    var p: vec2<f32>;
    var local_3: vec2<f32>;
    var img: vec4<f32>;
    var local_4: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var lambert: f32;
    var color: vec4<f32>;

    let _e52 = uniforms.vertical;
    if (_e52 != 0i) {
        let _e55 = (*uv_2)[1u];
        let _e58 = (*uv_2)[0u];
        local = vec2<f32>((1f - _e55), _e58);
    } else {
        let _e60 = (*uv_2);
        local = _e60;
    }
    let _e61 = local;
    q = _e61;
    let _e63 = uniforms.vertical;
    if (_e63 != 0i) {
        let _e66 = uniforms.ratio;
        local_1 = (0.5f * _e66);
    } else {
        local_1 = 0.5f;
    }
    let _e68 = local_1;
    halfSize = _e68;
    let _e70 = uniforms.progress;
    let _e72 = uniforms.spread;
    let _e76 = q[0u];
    let _e79 = uniforms.spread;
    t = smoothstep(0f, 1f, (((_e70 * (1f + _e72)) - _e76) / _e79));
    let _e82 = t;
    front = (_e82 < 0.5f);
    let _e84 = front;
    if _e84 {
        let _e85 = t;
        local_2 = _e85;
    } else {
        let _e86 = t;
        local_2 = (_e86 - 1f);
    }
    let _e88 = local_2;
    angle = (3.1415927f * _e88);
    let _e90 = angle;
    c = cos(_e90);
    let _e92 = angle;
    s = sin(_e92);
    let _e95 = q[1u];
    w = ((2f * _e95) - 1f);
    let _e98 = c;
    let _e100 = uniforms.perspective;
    let _e101 = w;
    let _e103 = s;
    den = (_e98 + ((_e100 * _e101) * _e103));
    let _e106 = den;
    if (_e106 <= 0f) {
        let _e109 = uniforms.backColor;
        return _e109;
    }
    let _e110 = w;
    let _e111 = den;
    v = (_e110 / _e111);
    let _e113 = v;
    if (abs(_e113) >= 1f) {
        let _e117 = uniforms.backColor;
        return _e117;
    }
    let _e118 = s;
    edge = max((0.002f * min(1f, (20f * abs(_e118)))), 0.0001f);
    let _e124 = c;
    let _e126 = uniforms.perspective;
    let _e127 = s;
    top = (_e124 / (1f - (_e126 * _e127)));
    let _e131 = c;
    let _e134 = uniforms.perspective;
    let _e135 = s;
    bottom = (-(_e131) / (1f + (_e134 * _e135)));
    let _e139 = top;
    let _e140 = w;
    let _e142 = w;
    let _e143 = bottom;
    let _e146 = halfSize;
    let _e148 = edge;
    cover = clamp(((min((_e139 - _e140), (_e142 - _e143)) * _e146) / _e148), 0f, 1f);
    let _e152 = q[0u];
    let _e153 = v;
    p = vec2<f32>(_e152, (0.5f + (0.5f * _e153)));
    let _e158 = uniforms.vertical;
    if (_e158 != 0i) {
        let _e161 = p[1u];
        let _e163 = p[0u];
        local_3 = vec2<f32>(_e161, (1f - _e163));
    } else {
        let _e166 = p;
        local_3 = _e166;
    }
    let _e167 = local_3;
    p = _e167;
    let _e168 = front;
    if _e168 {
        let _e169 = p;
        param = _e169;
        let _e170 = getFromColor((&param));
        local_4 = _e170;
    } else {
        let _e171 = p;
        param_1 = _e171;
        let _e172 = getToColor((&param_1));
        local_4 = _e172;
    }
    let _e173 = local_4;
    img = _e173;
    let _e174 = c;
    let _e175 = s;
    lambert = clamp((_e174 - (0.25f * _e175)), 0f, 1f);
    let _e179 = img;
    let _e182 = uniforms.shading;
    let _e184 = lambert;
    let _e186 = (_e179.xyz * mix((1f - _e182), 1f, _e184));
    let _e188 = img[3u];
    color = vec4<f32>(_e186.x, _e186.y, _e186.z, _e188);
    let _e194 = uniforms.backColor;
    let _e195 = color;
    let _e196 = cover;
    return mix(_e194, _e195, vec4(_e196));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e26 = _uv_1;
    param_2 = _e26;
    let _e27 = transition((&param_2));
    _fragColor = _e27;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
