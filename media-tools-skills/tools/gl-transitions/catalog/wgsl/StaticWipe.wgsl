// StaticWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StaticWipe.glsl
// Author: Ben Lucas
// License: MIT
// Description: A wipe from top to bottom with a band of TV static at its edge
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    u_transitionUpToDown: i32,
    u_max_static_span: f32,
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

fn rnd(st: ptr<function, vec2<f32>>) -> f32 {
    let _e21 = (*st);
    return fract((sin(dot(_e21, vec2<f32>(10f, 70f))) * 12345.545f));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e22 = (*uv)[0u];
    let _e24 = (*uv)[1u];
    let _e27 = textureSampleLevel(_to, _sampler, vec2<f32>(_e22, (1f - _e24)), 0f);
    return _e27;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e22 = (*uv_1)[0u];
    let _e24 = (*uv_1)[1u];
    let _e27 = textureSampleLevel(_from, _sampler, vec2<f32>(_e22, (1f - _e24)), 0f);
    return _e27;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var span: f32;
    var transitionEdge: f32;
    var local: f32;
    var mixRatio: f32;
    var transitionMix: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var noiseEnvelope: f32;
    var noise: vec4<f32>;
    var param_2: vec2<f32>;

    let _e32 = uniforms.u_max_static_span;
    let _e34 = uniforms.progress;
    span = (_e32 * pow(sin((3.1415927f * _e34)), 0.5f));
    let _e40 = uniforms.u_transitionUpToDown;
    if (_e40 != 0i) {
        let _e43 = (*uv_2)[1u];
        local = (1f - _e43);
    } else {
        let _e46 = (*uv_2)[1u];
        local = _e46;
    }
    let _e47 = local;
    transitionEdge = _e47;
    let _e49 = uniforms.progress;
    let _e50 = transitionEdge;
    mixRatio = (1f - step(_e49, _e50));
    let _e53 = (*uv_2);
    param = _e53;
    let _e54 = getFromColor((&param));
    let _e55 = (*uv_2);
    param_1 = _e55;
    let _e56 = getToColor((&param_1));
    let _e57 = mixRatio;
    transitionMix = mix(_e54, _e56, vec4(_e57));
    let _e61 = uniforms.progress;
    let _e62 = span;
    let _e65 = uniforms.progress;
    let _e66 = transitionEdge;
    let _e69 = uniforms.progress;
    let _e71 = uniforms.progress;
    let _e72 = span;
    let _e74 = transitionEdge;
    noiseEnvelope = (smoothstep((_e61 - _e62), _e65, _e66) * (1f - smoothstep(_e69, (_e71 + _e72), _e74)));
    let _e78 = (*uv_2);
    let _e80 = uniforms.progress;
    param_2 = (_e78 * (1f + _e80));
    let _e83 = rnd((&param_2));
    let _e84 = vec3(_e83);
    let _e86 = transitionMix[3u];
    noise = vec4<f32>(_e84.x, _e84.y, _e84.z, _e86);
    let _e91 = transitionMix;
    let _e92 = noise;
    let _e93 = noiseEnvelope;
    return mix(_e91, _e92, vec4(_e93));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e21 = _uv_1;
    param_3 = _e21;
    let _e22 = transition((&param_3));
    _fragColor = _e22;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
