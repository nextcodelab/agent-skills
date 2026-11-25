// SnakeBlockWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SnakeBlockWipe.glsl
// Author: gre
// License: MIT
// Description: Blocks switch to the incoming image one at a time, row after row from the top (or column after column from the left), each line running the opposite way to the one before, like a snake winding across the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    grid: vec2<i32>,
    vertical: i32,
    smoothness: f32,
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
    let _e21 = (*uv)[0u];
    let _e23 = (*uv)[1u];
    let _e26 = textureSampleLevel(_to, _sampler, vec2<f32>(_e21, (1f - _e23)), 0f);
    return _e26;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e21 = (*uv_1)[0u];
    let _e23 = (*uv_1)[1u];
    let _e26 = textureSampleLevel(_from, _sampler, vec2<f32>(_e21, (1f - _e23)), 0f);
    return _e26;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var g: vec2<f32>;
    var cell: vec2<f32>;
    var lines: f32;
    var local: f32;
    var len: f32;
    var local_1: f32;
    var line: f32;
    var local_2: f32;
    var pos: f32;
    var local_3: f32;
    var order: f32;
    var n: f32;
    var w: f32;
    var m: f32;
    var c: vec4<f32>;
    var local_4: vec4<f32>;

    let _e40 = (*uv_2);
    param = _e40;
    let _e41 = getFromColor((&param));
    a = _e41;
    let _e42 = (*uv_2);
    param_1 = _e42;
    let _e43 = getToColor((&param_1));
    b = _e43;
    let _e45 = uniforms.progress;
    if (_e45 <= 0f) {
        let _e47 = a;
        return _e47;
    }
    let _e49 = uniforms.progress;
    if (_e49 >= 1f) {
        let _e51 = b;
        return _e51;
    }
    let _e53 = uniforms.grid;
    g = max(vec2<f32>(_e53), vec2(1f));
    let _e58 = (*uv_2)[0u];
    let _e60 = (*uv_2)[1u];
    let _e63 = g;
    let _e66 = g;
    cell = min(floor((vec2<f32>(_e58, (1f - _e60)) * _e63)), (_e66 - vec2(1f)));
    let _e71 = uniforms.vertical;
    if (_e71 != 0i) {
        let _e74 = g[0u];
        local = _e74;
    } else {
        let _e76 = g[1u];
        local = _e76;
    }
    let _e77 = local;
    lines = _e77;
    let _e79 = uniforms.vertical;
    if (_e79 != 0i) {
        let _e82 = g[1u];
        local_1 = _e82;
    } else {
        let _e84 = g[0u];
        local_1 = _e84;
    }
    let _e85 = local_1;
    len = _e85;
    let _e87 = uniforms.vertical;
    if (_e87 != 0i) {
        let _e90 = cell[0u];
        local_2 = _e90;
    } else {
        let _e92 = cell[1u];
        local_2 = _e92;
    }
    let _e93 = local_2;
    line = _e93;
    let _e95 = uniforms.vertical;
    if (_e95 != 0i) {
        let _e98 = cell[1u];
        local_3 = _e98;
    } else {
        let _e100 = cell[0u];
        local_3 = _e100;
    }
    let _e101 = local_3;
    pos = _e101;
    let _e102 = line;
    if ((_e102 - (floor((_e102 / 2f)) * 2f)) > 0.5f) {
        let _e108 = len;
        let _e110 = pos;
        pos = ((_e108 - 1f) - _e110);
    }
    let _e112 = line;
    let _e113 = len;
    let _e115 = pos;
    order = ((_e112 * _e113) + _e115);
    let _e117 = lines;
    let _e118 = len;
    n = (_e117 * _e118);
    let _e121 = uniforms.smoothness;
    w = max(_e121, 0.001f);
    let _e124 = uniforms.progress;
    let _e125 = n;
    let _e127 = w;
    let _e130 = order;
    let _e132 = w;
    m = clamp((((_e124 * ((_e125 - 1f) + _e127)) - _e130) / _e132), 0f, 1f);
    let _e135 = a;
    let _e138 = a[3u];
    let _e139 = (_e135.xyz * _e138);
    let _e141 = a[3u];
    let _e146 = b;
    let _e149 = b[3u];
    let _e150 = (_e146.xyz * _e149);
    let _e152 = b[3u];
    let _e157 = m;
    c = mix(vec4<f32>(_e139.x, _e139.y, _e139.z, _e141), vec4<f32>(_e150.x, _e150.y, _e150.z, _e152), vec4(_e157));
    let _e161 = c[3u];
    if (_e161 > 0f) {
        let _e163 = c;
        let _e166 = c[3u];
        let _e168 = (_e163.xyz / vec3(_e166));
        let _e170 = c[3u];
        local_4 = vec4<f32>(_e168.x, _e168.y, _e168.z, _e170);
    } else {
        local_4 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e175 = local_4;
    return _e175;
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e20 = _uv_1;
    param_2 = _e20;
    let _e21 = transition((&param_2));
    _fragColor = _e21;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
