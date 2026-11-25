// ButterflyWaveScrawler — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ButterflyWaveScrawler.glsl
// Author: mandubian
// License: MIT
// Description: Wavy, color-separated ripples scramble the outgoing image into the incoming one
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    amplitude: f32,
    waves: f32,
    colorSeparation: f32,
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

fn compute(p: ptr<function, vec2<f32>>, progress: ptr<function, f32>, center: ptr<function, vec2<f32>>) -> f32 {
    var o: vec2<f32>;
    var h: vec2<f32>;
    var theta: f32;
    var s: f32;
    var s2_: f32;

    let _e32 = (*p);
    let _e33 = (*progress);
    let _e35 = uniforms.amplitude;
    let _e39 = (*center);
    o = ((_e32 * sin((_e33 * _e35))) - _e39);
    h = vec2<f32>(1f, 0f);
    let _e41 = o;
    let _e42 = h;
    let _e46 = uniforms.waves;
    theta = (acos(dot(_e41, _e42)) * _e46);
    let _e48 = theta;
    s = sin((((2f * _e48) - 3.1415927f) / 24f));
    let _e53 = s;
    let _e54 = s;
    s2_ = (_e53 * _e54);
    let _e56 = theta;
    let _e59 = theta;
    let _e64 = s2_;
    let _e65 = s2_;
    let _e67 = s;
    return (((exp(cos(_e56)) - (2f * cos((4f * _e59)))) + ((_e64 * _e65) * _e67)) / 10f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e26 = (*uv)[0u];
    let _e28 = (*uv)[1u];
    let _e31 = textureSampleLevel(_to, _sampler, vec2<f32>(_e26, (1f - _e28)), 0f);
    return _e31;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e26 = (*uv_1)[0u];
    let _e28 = (*uv_1)[1u];
    let _e31 = textureSampleLevel(_from, _sampler, vec2<f32>(_e26, (1f - _e28)), 0f);
    return _e31;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var p_1: vec2<f32>;
    var inv: f32;
    var disp: f32;
    var param_2: vec2<f32>;
    var param_3: f32;
    var param_4: vec2<f32>;
    var texTo: vec4<f32>;
    var param_5: vec2<f32>;
    var fromCenter: vec4<f32>;
    var param_6: vec2<f32>;
    var texFrom: vec4<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;

    let _e41 = uniforms.progress;
    if (_e41 <= 0f) {
        let _e43 = (*uv_2);
        param = _e43;
        let _e44 = getFromColor((&param));
        return _e44;
    }
    let _e46 = uniforms.progress;
    if (_e46 >= 1f) {
        let _e48 = (*uv_2);
        param_1 = _e48;
        let _e49 = getToColor((&param_1));
        return _e49;
    }
    let _e50 = (*uv_2);
    p_1 = _e50;
    let _e52 = uniforms.progress;
    inv = (1f - _e52);
    let _e54 = p_1;
    param_2 = _e54;
    let _e56 = uniforms.progress;
    param_3 = _e56;
    param_4 = vec2<f32>(0.5f, 0.5f);
    let _e57 = compute((&param_2), (&param_3), (&param_4));
    disp = _e57;
    let _e58 = p_1;
    let _e59 = inv;
    let _e60 = disp;
    param_5 = (_e58 + vec2((_e59 * _e60)));
    let _e64 = getToColor((&param_5));
    texTo = _e64;
    let _e65 = p_1;
    let _e67 = uniforms.progress;
    let _e68 = disp;
    param_6 = (_e65 + vec2((_e67 * _e68)));
    let _e72 = getFromColor((&param_6));
    fromCenter = _e72;
    let _e73 = p_1;
    let _e75 = uniforms.progress;
    let _e76 = disp;
    let _e79 = uniforms.colorSeparation;
    param_7 = (_e73 + vec2(((_e75 * _e76) * (1f - _e79))));
    let _e84 = getFromColor((&param_7));
    let _e87 = fromCenter[1u];
    let _e88 = p_1;
    let _e90 = uniforms.progress;
    let _e91 = disp;
    let _e94 = uniforms.colorSeparation;
    param_8 = (_e88 + vec2(((_e90 * _e91) * (1f + _e94))));
    let _e99 = getFromColor((&param_8));
    let _e102 = fromCenter[3u];
    texFrom = vec4<f32>(_e84.x, _e87, _e99.z, _e102);
    let _e104 = texTo;
    let _e106 = uniforms.progress;
    let _e108 = texFrom;
    let _e109 = inv;
    return ((_e104 * _e106) + (_e108 * _e109));
}

fn main_1() {
    var param_9: vec2<f32>;

    let _e25 = _uv_1;
    param_9 = _e25;
    let _e26 = transition((&param_9));
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
