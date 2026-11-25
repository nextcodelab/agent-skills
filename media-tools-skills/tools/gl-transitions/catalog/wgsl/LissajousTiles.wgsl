// LissajousTiles — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LissajousTiles.glsl
// Author: Boundless <info@boundless-beta.com>
// License: MIT
// Description: The image breaks into a grid of tiles that swirl along Lissajous curves, in a Scanimate style, and flip one by one to the incoming image before settling back
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    speed: f32,
    freq: vec2<f32>,
    offset: f32,
    zoom: f32,
    fade: f32,
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
    let _e30 = (*uv)[0u];
    let _e32 = (*uv)[1u];
    let _e35 = textureSampleLevel(_to, _sampler, vec2<f32>(_e30, (1f - _e32)), 0f);
    return _e35;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e30 = (*uv_1)[0u];
    let _e32 = (*uv_1)[1u];
    let _e35 = textureSampleLevel(_from, _sampler, vec2<f32>(_e30, (1f - _e32)), 0f);
    return _e35;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var jBig: f32;
    var iBig: f32;
    var i: f32;
    var j: f32;
    var k: f32;
    var uv0_: vec2<f32>;
    var tileMix: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var phi_179_: bool;
    var phi_186_: bool;
    var phi_194_: bool;

    let _e40 = uniforms.progress;
    p = (1f - pow((1f - smoothstep(0f, 1f, (1f - abs((1f - (2f * _e40)))))), 3f));
    jBig = 9f;
    loop {
        let _e49 = jBig;
        if (_e49 >= 0f) {
            iBig = 9f;
            loop {
                let _e51 = iBig;
                if (_e51 >= 0f) {
                    let _e53 = iBig;
                    i = (_e53 / 10f);
                    let _e55 = jBig;
                    j = (_e55 / 10f);
                    let _e57 = i;
                    let _e59 = j;
                    k = ((_e57 / 10f) + _e59);
                    let _e61 = (*uv_2);
                    let _e62 = i;
                    let _e63 = j;
                    let _e69 = k;
                    let _e73 = uniforms.freq[0u];
                    let _e76 = uniforms.progress;
                    let _e79 = uniforms.speed;
                    let _e83 = k;
                    let _e87 = uniforms.freq[1u];
                    let _e90 = uniforms.progress;
                    let _e93 = uniforms.offset;
                    let _e97 = uniforms.speed;
                    let _e103 = uniforms.zoom;
                    uv0_ = ((((_e61 + vec2<f32>(_e62, _e63)) - vec2(0.5f)) + vec2<f32>(0.05f, 0.05f)) + ((vec2<f32>(cos((((_e69 * 6.2831855f) * _e73) + ((_e76 * 6f) * _e79))), sin((((_e83 * 6.2831855f) * _e87) + (((_e90 * 6f) * (1f + _e93)) * _e97)))) * _e103) / vec2(2f)));
                    let _e108 = (*uv_2);
                    let _e109 = uv0_;
                    let _e110 = p;
                    uv0_ = mix(_e108, _e109, vec2(_e110));
                    let _e114 = uv0_[0u];
                    let _e115 = i;
                    let _e116 = (_e114 >= _e115);
                    phi_179_ = _e116;
                    if _e116 {
                        let _e118 = uv0_[0u];
                        let _e119 = i;
                        phi_179_ = (_e118 < (_e119 + 0.1f));
                    }
                    let _e123 = phi_179_;
                    phi_186_ = _e123;
                    if _e123 {
                        let _e125 = uv0_[1u];
                        let _e126 = j;
                        phi_186_ = (_e125 >= _e126);
                    }
                    let _e129 = phi_186_;
                    phi_194_ = _e129;
                    if _e129 {
                        let _e131 = uv0_[1u];
                        let _e132 = j;
                        phi_194_ = (_e131 < (_e132 + 0.1f));
                    }
                    let _e136 = phi_194_;
                    if _e136 {
                        let _e138 = uniforms.progress;
                        let _e140 = uniforms.fade;
                        let _e144 = uniforms.progress;
                        let _e148 = uniforms.fade;
                        let _e150 = k;
                        let _e152 = uniforms.fade;
                        tileMix = clamp((((_e138 * (((1f + _e140) * 2f) * _e144)) - _e148) + (_e150 * _e152)), 0f, 1f);
                        let _e156 = uv0_;
                        param = _e156;
                        let _e157 = getFromColor((&param));
                        let _e158 = uv0_;
                        param_1 = _e158;
                        let _e159 = getToColor((&param_1));
                        let _e160 = tileMix;
                        return mix(_e157, _e159, vec4(_e160));
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e163 = iBig;
                    iBig = (_e163 - 1f);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e165 = jBig;
            jBig = (_e165 - 1f);
        }
    }
    return vec4<f32>(0f, 0f, 0f, 0f);
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e29 = _uv_1;
    param_2 = _e29;
    let _e30 = transition((&param_2));
    _fragColor = _e30;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
