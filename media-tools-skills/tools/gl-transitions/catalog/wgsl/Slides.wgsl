// Slides — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Slides.glsl
// Author: Mark Craig
// License: MIT
// Description: The outgoing image slides out, or the incoming one slides in, toward an edge, a corner or the center
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    type_: i32,
    In: i32,
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
    let _e23 = (*uv)[0u];
    let _e25 = (*uv)[1u];
    let _e28 = textureSampleLevel(_from, _sampler, vec2<f32>(_e23, (1f - _e25)), 0f);
    return _e28;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e23 = (*uv_1)[0u];
    let _e25 = (*uv_1)[1u];
    let _e28 = textureSampleLevel(_to, _sampler, vec2<f32>(_e23, (1f - _e25)), 0f);
    return _e28;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var uv0_: vec2<f32>;
    var rad: f32;
    var local: f32;
    var xc1_: f32;
    var yc1_: f32;
    var uv2_: vec2<f32>;
    var local_1: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var local_2: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var phi_193_: bool;
    var phi_200_: bool;
    var phi_209_: bool;

    let _e34 = (*uv_2);
    uv0_ = _e34;
    let _e36 = uniforms.In;
    if (_e36 != 0i) {
        let _e39 = uniforms.progress;
        local = _e39;
    } else {
        let _e41 = uniforms.progress;
        local = (1f - _e41);
    }
    let _e43 = local;
    rad = _e43;
    let _e45 = uniforms.type_;
    if (_e45 == 0i) {
        let _e47 = rad;
        xc1_ = (0.5f - (_e47 / 2f));
        yc1_ = 0f;
    } else {
        let _e51 = uniforms.type_;
        if (_e51 == 1i) {
            let _e53 = rad;
            xc1_ = (1f - _e53);
            let _e55 = rad;
            yc1_ = (0.5f - (_e55 / 2f));
        } else {
            let _e59 = uniforms.type_;
            if (_e59 == 2i) {
                let _e61 = rad;
                xc1_ = (0.5f - (_e61 / 2f));
                let _e64 = rad;
                yc1_ = (1f - _e64);
            } else {
                let _e67 = uniforms.type_;
                if (_e67 == 3i) {
                    xc1_ = 0f;
                    let _e69 = rad;
                    yc1_ = (0.5f - (_e69 / 2f));
                } else {
                    let _e73 = uniforms.type_;
                    if (_e73 == 4i) {
                        let _e75 = rad;
                        xc1_ = (1f - _e75);
                        yc1_ = 0f;
                    } else {
                        let _e78 = uniforms.type_;
                        if (_e78 == 5i) {
                            let _e80 = rad;
                            xc1_ = (1f - _e80);
                            let _e82 = rad;
                            yc1_ = (1f - _e82);
                        } else {
                            let _e85 = uniforms.type_;
                            if (_e85 == 6i) {
                                xc1_ = 0f;
                                let _e87 = rad;
                                yc1_ = (1f - _e87);
                            } else {
                                let _e90 = uniforms.type_;
                                if (_e90 == 7i) {
                                    xc1_ = 0f;
                                    yc1_ = 0f;
                                } else {
                                    let _e93 = uniforms.type_;
                                    if (_e93 == 8i) {
                                        let _e95 = rad;
                                        xc1_ = (0.5f - (_e95 / 2f));
                                        let _e98 = rad;
                                        yc1_ = (0.5f - (_e98 / 2f));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    let _e102 = (*uv_2)[1u];
    (*uv_2)[1u] = (1f - _e102);
    let _e106 = (*uv_2)[0u];
    let _e107 = xc1_;
    let _e108 = (_e106 >= _e107);
    phi_193_ = _e108;
    if _e108 {
        let _e110 = (*uv_2)[0u];
        let _e111 = xc1_;
        let _e112 = rad;
        phi_193_ = (_e110 <= (_e111 + _e112));
    }
    let _e116 = phi_193_;
    phi_200_ = _e116;
    if _e116 {
        let _e118 = (*uv_2)[1u];
        let _e119 = yc1_;
        phi_200_ = (_e118 >= _e119);
    }
    let _e122 = phi_200_;
    phi_209_ = _e122;
    if _e122 {
        let _e124 = (*uv_2)[1u];
        let _e125 = yc1_;
        let _e126 = rad;
        phi_209_ = (_e124 <= (_e125 + _e126));
    }
    let _e130 = phi_209_;
    if _e130 {
        let _e132 = (*uv_2)[0u];
        let _e133 = xc1_;
        let _e135 = rad;
        let _e138 = (*uv_2)[1u];
        let _e139 = yc1_;
        let _e141 = rad;
        uv2_ = vec2<f32>(((_e132 - _e133) / _e135), (1f - ((_e138 - _e139) / _e141)));
        let _e146 = uniforms.In;
        if (_e146 != 0i) {
            let _e148 = uv2_;
            param = _e148;
            let _e149 = getToColor((&param));
            local_1 = _e149;
        } else {
            let _e150 = uv2_;
            param_1 = _e150;
            let _e151 = getFromColor((&param_1));
            local_1 = _e151;
        }
        let _e152 = local_1;
        return _e152;
    }
    let _e154 = uniforms.In;
    if (_e154 != 0i) {
        let _e156 = uv0_;
        param_2 = _e156;
        let _e157 = getFromColor((&param_2));
        local_2 = _e157;
    } else {
        let _e158 = uv0_;
        param_3 = _e158;
        let _e159 = getToColor((&param_3));
        local_2 = _e159;
    }
    let _e160 = local_2;
    return _e160;
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e22 = _uv_1;
    param_4 = _e22;
    let _e23 = transition((&param_4));
    _fragColor = _e23;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
