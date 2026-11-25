// FallOver — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FallOver.glsl
// Author: gre
// License: MIT
// Description: The outgoing image falls over backward, hinged on its bottom edge, revealing the incoming one behind it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    perspective: f32,
    shading: f32,
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
    let _e24 = (*uv)[0u];
    let _e26 = (*uv)[1u];
    let _e29 = textureSampleLevel(_to, _sampler, vec2<f32>(_e24, (1f - _e26)), 0f);
    return _e29;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e24 = (*uv_1)[0u];
    let _e26 = (*uv_1)[1u];
    let _e29 = textureSampleLevel(_from, _sampler, vec2<f32>(_e24, (1f - _e26)), 0f);
    return _e29;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var fall: f32;
    var angle: f32;
    var c: f32;
    var s: f32;
    var dist: f32;
    var eye: vec3<f32>;
    var dir: vec3<f32>;
    var den: f32;
    var t: f32;
    var hit: vec3<f32>;
    var puv: vec2<f32>;
    var col: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var phi_172_: bool;
    var phi_178_: bool;
    var phi_184_: bool;
    var phi_190_: bool;

    let _e38 = uniforms.progress;
    let _e40 = uniforms.progress;
    fall = (_e38 * (0.25f + (0.75f * _e40)));
    let _e44 = fall;
    angle = (1.5707964f * _e44);
    let _e46 = angle;
    c = cos(_e46);
    let _e48 = angle;
    s = sin(_e48);
    let _e51 = uniforms.perspective;
    dist = (1f / max(_e51, 0.01f));
    let _e55 = uniforms.ratio;
    let _e57 = c;
    let _e59 = dist;
    eye = vec3<f32>((0.5f * _e55), (0.5f * _e57), -(_e59));
    let _e63 = (*uv_2)[0u];
    let _e65 = uniforms.ratio;
    let _e68 = (*uv_2)[1u];
    let _e70 = eye;
    dir = (vec3<f32>((_e63 * _e65), _e68, 0f) - _e70);
    let _e73 = dir[2u];
    let _e74 = c;
    let _e77 = dir[1u];
    let _e78 = s;
    den = ((_e73 * _e74) - (_e77 * _e78));
    let _e81 = den;
    if (_e81 > 0f) {
        let _e84 = eye[1u];
        let _e85 = s;
        let _e88 = eye[2u];
        let _e89 = c;
        let _e92 = den;
        t = (((_e84 * _e85) - (_e88 * _e89)) / _e92);
        let _e94 = eye;
        let _e95 = t;
        let _e96 = dir;
        hit = (_e94 + (_e96 * _e95));
        let _e100 = hit[0u];
        let _e102 = uniforms.ratio;
        let _e105 = hit[1u];
        let _e106 = c;
        let _e109 = hit[2u];
        let _e110 = s;
        puv = vec2<f32>((_e100 / _e102), ((_e105 * _e106) + (_e109 * _e110)));
        let _e114 = t;
        let _e115 = (_e114 > 0f);
        phi_172_ = _e115;
        if _e115 {
            let _e117 = puv[1u];
            phi_172_ = (_e117 > 0f);
        }
        let _e120 = phi_172_;
        phi_178_ = _e120;
        if _e120 {
            let _e122 = puv[1u];
            phi_178_ = (_e122 <= 1f);
        }
        let _e125 = phi_178_;
        phi_184_ = _e125;
        if _e125 {
            let _e127 = puv[0u];
            phi_184_ = (_e127 >= 0f);
        }
        let _e130 = phi_184_;
        phi_190_ = _e130;
        if _e130 {
            let _e132 = puv[0u];
            phi_190_ = (_e132 <= 1f);
        }
        let _e135 = phi_190_;
        if _e135 {
            let _e136 = puv;
            param = _e136;
            let _e137 = getFromColor((&param));
            col = _e137;
            let _e138 = col;
            let _e141 = uniforms.shading;
            let _e142 = s;
            let _e145 = (_e138.xyz * (1f - (_e141 * _e142)));
            let _e147 = col[3u];
            return vec4<f32>(_e145.x, _e145.y, _e145.z, _e147);
        }
    }
    let _e152 = (*uv_2);
    param_1 = _e152;
    let _e153 = getToColor((&param_1));
    return _e153;
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e23 = _uv_1;
    param_2 = _e23;
    let _e24 = transition((&param_2));
    _fragColor = _e24;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
