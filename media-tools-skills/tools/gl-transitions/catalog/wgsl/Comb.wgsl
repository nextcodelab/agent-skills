// Comb — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Comb.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into interleaved strips that slide in opposite directions, each pushing the outgoing image out and the incoming one in
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strips: i32,
    vertical: i32,
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
    let _e20 = (*uv)[0u];
    let _e22 = (*uv)[1u];
    let _e25 = textureSampleLevel(_to, _sampler, vec2<f32>(_e20, (1f - _e22)), 0f);
    return _e25;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e20 = (*uv_1)[0u];
    let _e22 = (*uv_1)[1u];
    let _e25 = textureSampleLevel(_from, _sampler, vec2<f32>(_e20, (1f - _e22)), 0f);
    return _e25;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: f32;
    var local: f32;
    var b: f32;
    var local_1: f32;
    var dir: f32;
    var t: f32;
    var fa: f32;
    var local_2: vec2<f32>;
    var param: vec2<f32>;
    var ta: f32;
    var local_3: vec2<f32>;
    var param_1: vec2<f32>;

    let _e32 = uniforms.vertical;
    if (_e32 != 0i) {
        let _e35 = (*uv_2)[1u];
        local = _e35;
    } else {
        let _e37 = (*uv_2)[0u];
        local = _e37;
    }
    let _e38 = local;
    a = _e38;
    let _e40 = uniforms.vertical;
    if (_e40 != 0i) {
        let _e43 = (*uv_2)[0u];
        local_1 = _e43;
    } else {
        let _e45 = (*uv_2)[1u];
        local_1 = _e45;
    }
    let _e46 = local_1;
    b = _e46;
    let _e47 = b;
    let _e49 = uniforms.strips;
    let _e52 = floor((_e47 * f32(_e49)));
    dir = select(-1f, 1f, ((_e52 - (floor((_e52 / 2f)) * 2f)) < 0.5f));
    let _e60 = uniforms.progress;
    let _e62 = uniforms.progress;
    let _e64 = uniforms.progress;
    let _e67 = uniforms.progress;
    t = mix(_e60, ((_e62 * _e64) * (3f - (2f * _e67))), 0.6f);
    let _e72 = a;
    let _e73 = dir;
    let _e74 = t;
    fa = (_e72 - (_e73 * _e74));
    let _e77 = fa;
    let _e79 = fa;
    if ((_e77 >= 0f) && (_e79 <= 1f)) {
        let _e83 = uniforms.vertical;
        if (_e83 != 0i) {
            let _e85 = b;
            let _e86 = fa;
            local_2 = vec2<f32>(_e85, _e86);
        } else {
            let _e88 = fa;
            let _e89 = b;
            local_2 = vec2<f32>(_e88, _e89);
        }
        let _e91 = local_2;
        param = _e91;
        let _e92 = getFromColor((&param));
        return _e92;
    }
    let _e93 = fa;
    let _e94 = dir;
    ta = (_e93 + _e94);
    let _e97 = uniforms.vertical;
    if (_e97 != 0i) {
        let _e99 = b;
        let _e100 = ta;
        local_3 = vec2<f32>(_e99, _e100);
    } else {
        let _e102 = ta;
        let _e103 = b;
        local_3 = vec2<f32>(_e102, _e103);
    }
    let _e105 = local_3;
    param_1 = _e105;
    let _e106 = getToColor((&param_1));
    return _e106;
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e19 = _uv_1;
    param_2 = _e19;
    let _e20 = transition((&param_2));
    _fragColor = _e20;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
