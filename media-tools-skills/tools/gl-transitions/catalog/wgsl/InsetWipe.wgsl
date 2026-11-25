// InsetWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InsetWipe.glsl
// Author: gre
// License: MIT
// Description: A rectangle anchored in a corner, on an edge or in the center grows until the incoming image fills the frame, revealing it in place without scaling it; in reverse, the outgoing image shrinks into the rectangle
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    anchor: vec2<f32>,
    smoothness: f32,
    borderWidth: f32,
    borderColor: vec4<f32>,
    reverse: i32,
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

fn premultiplied(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e24 = (*c);
    let _e27 = (*c)[3u];
    let _e28 = (_e24.xyz * _e27);
    let _e30 = (*c)[3u];
    return vec4<f32>(_e28.x, _e28.y, _e28.z, _e30);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e25 = (*uv)[0u];
    let _e27 = (*uv)[1u];
    let _e30 = textureSampleLevel(_to, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e25 = (*uv_1)[0u];
    let _e27 = (*uv_1)[1u];
    let _e30 = textureSampleLevel(_from, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var an: vec2<f32>;
    var sq: vec2<f32>;
    var ext: vec2<f32>;
    var d: vec2<f32>;
    var s: f32;
    var bw: f32;
    var t: f32;
    var local: f32;
    var p: f32;
    var size: vec2<f32>;
    var e: f32;
    var inside: vec4<f32>;
    var c_1: vec4<f32>;
    var param_2: vec4<f32>;
    var m: f32;
    var param_3: vec4<f32>;
    var param_4: vec4<f32>;
    var local_1: vec4<f32>;

    let _e46 = (*uv_2);
    param = _e46;
    let _e47 = getFromColor((&param));
    a = _e47;
    let _e48 = (*uv_2);
    param_1 = _e48;
    let _e49 = getToColor((&param_1));
    b = _e49;
    let _e51 = uniforms.progress;
    if (_e51 <= 0f) {
        let _e53 = a;
        return _e53;
    }
    let _e55 = uniforms.progress;
    if (_e55 >= 1f) {
        let _e57 = b;
        return _e57;
    }
    let _e59 = uniforms.anchor;
    an = clamp(_e59, vec2(0f), vec2(1f));
    let _e64 = uniforms.ratio;
    sq = vec2<f32>(_e64, 1f);
    let _e66 = an;
    let _e67 = an;
    let _e71 = sq;
    ext = (max(_e66, (vec2(1f) - _e67)) * _e71);
    let _e73 = (*uv_2);
    let _e74 = an;
    let _e77 = sq;
    d = (abs((_e73 - _e74)) * _e77);
    let _e80 = uniforms.smoothness;
    s = max(_e80, 0.001f);
    let _e83 = uniforms.borderWidth;
    bw = max(_e83, 0f);
    let _e86 = uniforms.reverse;
    if (_e86 != 0i) {
        let _e89 = uniforms.progress;
        local = (1f - _e89);
    } else {
        let _e92 = uniforms.progress;
        local = _e92;
    }
    let _e93 = local;
    t = _e93;
    let _e94 = t;
    let _e95 = t;
    let _e96 = t;
    let _e98 = t;
    p = mix(_e94, ((_e95 * _e96) * (3f - (2f * _e98))), 0.3f);
    let _e103 = p;
    let _e104 = ext;
    let _e106 = bw;
    let _e107 = s;
    let _e110 = s;
    let _e111 = p;
    size = ((_e104 * _e103) + vec2(mix(-((_e106 + _e107)), _e110, _e111)));
    let _e116 = d[0u];
    let _e118 = size[0u];
    let _e121 = d[1u];
    let _e123 = size[1u];
    e = max((_e116 - _e118), (_e121 - _e123));
    let _e127 = uniforms.reverse;
    let _e129 = a;
    let _e130 = b;
    inside = select(_e130, _e129, vec4((_e127 != 0i)));
    let _e134 = uniforms.reverse;
    let _e136 = b;
    let _e137 = a;
    param_2 = select(_e137, _e136, vec4((_e134 != 0i)));
    let _e140 = premultiplied((&param_2));
    c_1 = _e140;
    let _e141 = bw;
    if (_e141 > 0f) {
        let _e143 = bw;
        let _e144 = s;
        let _e146 = bw;
        let _e147 = s;
        let _e149 = e;
        m = (1f - smoothstep((_e143 - _e144), (_e146 + _e147), _e149));
        let _e153 = uniforms.borderColor;
        param_3 = _e153;
        let _e154 = premultiplied((&param_3));
        let _e155 = m;
        let _e157 = c_1;
        let _e160 = uniforms.borderColor[3u];
        let _e161 = m;
        c_1 = ((_e154 * _e155) + (_e157 * (1f - (_e160 * _e161))));
    }
    let _e166 = c_1;
    let _e167 = inside;
    param_4 = _e167;
    let _e168 = premultiplied((&param_4));
    let _e169 = s;
    let _e171 = s;
    let _e172 = e;
    c_1 = mix(_e166, _e168, vec4((1f - smoothstep(-(_e169), _e171, _e172))));
    let _e178 = c_1[3u];
    if (_e178 > 0f) {
        let _e180 = c_1;
        let _e183 = c_1[3u];
        let _e185 = (_e180.xyz / vec3(_e183));
        let _e187 = c_1[3u];
        local_1 = vec4<f32>(_e185.x, _e185.y, _e185.z, _e187);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e192 = local_1;
    return _e192;
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e24 = _uv_1;
    param_5 = _e24;
    let _e25 = transition((&param_5));
    _fragColor = _e25;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
