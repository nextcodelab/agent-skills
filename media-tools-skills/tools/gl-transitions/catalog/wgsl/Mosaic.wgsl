// Mosaic — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Mosaic.glsl
// Author: Xaychru
// License: MIT
// Description: The view pans across a mosaic of rotated tiles from both images and settles on the incoming one
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    endx: i32,
    endy: i32,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e26 = (*uv)[0u];
    let _e28 = (*uv)[1u];
    let _e31 = textureSampleLevel(_from, _sampler, vec2<f32>(_e26, (1f - _e28)), 0f);
    return _e31;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e26 = (*uv_1)[0u];
    let _e28 = (*uv_1)[1u];
    let _e31 = textureSampleLevel(_to, _sampler, vec2<f32>(_e26, (1f - _e28)), 0f);
    return _e31;
}

fn Rotate(v: ptr<function, vec2<f32>>, a: ptr<function, f32>) -> vec2<f32> {
    var rm: mat2x2<f32>;

    let _e27 = (*a);
    let _e29 = (*a);
    let _e32 = (*a);
    let _e34 = (*a);
    rm = mat2x2<f32>(vec2<f32>(cos(_e27), -(sin(_e29))), vec2<f32>(sin(_e32), cos(_e34)));
    let _e39 = rm;
    let _e40 = (*v);
    return (_e39 * _e40);
}

fn Rand(v_1: ptr<function, vec2<f32>>) -> f32 {
    let _e25 = (*v_1);
    return fract((sin(dot(_e25, vec2<f32>(12.9898f, 78.233f))) * 43758.547f));
}

fn CosInterpolation(x: ptr<function, f32>) -> f32 {
    let _e25 = (*x);
    return ((-(cos((_e25 * 3.1415927f))) / 2f) + 0.5f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: vec2<f32>;
    var rp: vec2<f32>;
    var rpr: f32;
    var z: f32;
    var az: f32;
    var param: f32;
    var param_1: f32;
    var mrp: vec2<f32>;
    var crp: vec2<f32>;
    var onEnd: bool;
    var ang: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var phi_197_: bool;
    var phi_229_: bool;

    let _e42 = (*uv_2);
    p = ((_e42 / vec2<f32>(1f, 1f)) - vec2(0.5f));
    let _e46 = p;
    rp = _e46;
    let _e48 = uniforms.progress;
    rpr = ((_e48 * 2f) - 1f);
    let _e51 = rpr;
    let _e52 = rpr;
    z = (-(((_e51 * _e52) * 2f)) + 3f);
    let _e57 = z;
    az = abs(_e57);
    let _e59 = az;
    let _e60 = rp;
    rp = (_e60 * _e59);
    let _e63 = uniforms.endx;
    let _e67 = uniforms.endy;
    let _e72 = uniforms.progress;
    param = _e72;
    let _e73 = CosInterpolation((&param));
    let _e75 = uniforms.progress;
    param_1 = _e75;
    let _e76 = CosInterpolation((&param_1));
    let _e80 = rp;
    rp = (_e80 + mix(vec2<f32>(0.5f, 0.5f), vec2<f32>((f32(_e63) + 0.5f), (f32(_e67) + 0.5f)), vec2((_e73 * _e76))));
    let _e82 = rp;
    let _e83 = vec2(1f);
    mrp = (_e82 - (floor((_e82 / _e83)) * _e83));
    let _e88 = rp;
    crp = _e88;
    let _e90 = crp[0u];
    let _e94 = uniforms.endx;
    let _e95 = (i32(floor(_e90)) == _e94);
    phi_197_ = _e95;
    if _e95 {
        let _e97 = crp[1u];
        let _e101 = uniforms.endy;
        phi_197_ = (i32(floor(_e97)) == _e101);
    }
    let _e104 = phi_197_;
    onEnd = _e104;
    let _e105 = onEnd;
    if !(_e105) {
        let _e107 = crp;
        param_2 = floor(_e107);
        let _e109 = Rand((&param_2));
        ang = ((f32(i32((_e109 * 4f))) * 0.5f) * 3.1415927f);
        let _e115 = mrp;
        param_3 = (_e115 - vec2<f32>(0.5f, 0.5f));
        let _e117 = ang;
        param_4 = _e117;
        let _e118 = Rotate((&param_3), (&param_4));
        mrp = (vec2<f32>(0.5f, 0.5f) + _e118);
    }
    let _e120 = onEnd;
    phi_229_ = _e120;
    if !(_e120) {
        let _e122 = crp;
        param_5 = floor(_e122);
        let _e124 = Rand((&param_5));
        phi_229_ = (_e124 > 0.5f);
    }
    let _e127 = phi_229_;
    if _e127 {
        let _e128 = mrp;
        param_6 = _e128;
        let _e129 = getToColor((&param_6));
        return _e129;
    } else {
        let _e130 = mrp;
        param_7 = _e130;
        let _e131 = getFromColor((&param_7));
        return _e131;
    }
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e25 = _uv_1;
    param_8 = _e25;
    let _e26 = transition((&param_8));
    _fragColor = _e26;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
