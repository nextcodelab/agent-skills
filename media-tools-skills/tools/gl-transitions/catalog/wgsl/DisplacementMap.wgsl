// DisplacementMap — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DisplacementMap.glsl
// Author: Travis Fischer
// License: MIT
// Description: A crossfade in which a displacement map (an extra grayscale texture) warps both images
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
}

@group(0) @binding(2) 
var _from: texture_2d<f32>;
@group(0) @binding(1) 
var _sampler: sampler;
@group(0) @binding(3) 
var _to: texture_2d<f32>;
@group(0) @binding(4) 
var displacementMap: texture_2d<f32>;
@group(0) @binding(0) 
var<uniform> uniforms: Uniforms;
var<private> _fragColor: vec4<f32>;
var<private> _uv_1: vec2<f32>;

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e15 = (*uv)[0u];
    let _e17 = (*uv)[1u];
    let _e20 = textureSampleLevel(_to, _sampler, vec2<f32>(_e15, (1f - _e17)), 0f);
    return _e20;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e15 = (*uv_1)[0u];
    let _e17 = (*uv_1)[1u];
    let _e20 = textureSampleLevel(_from, _sampler, vec2<f32>(_e15, (1f - _e17)), 0f);
    return _e20;
}

fn _texture_displacementMap(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e15 = (*uv_2)[0u];
    let _e17 = (*uv_2)[1u];
    let _e20 = textureSampleLevel(displacementMap, _sampler, vec2<f32>(_e15, (1f - _e17)), 0f);
    return _e20;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var displacement: f32;
    var param: vec2<f32>;
    var uvFrom: vec2<f32>;
    var uvTo: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e20 = (*uv_3);
    param = _e20;
    let _e21 = _texture_displacementMap((&param));
    let _e24 = uniforms.strength;
    displacement = (_e21.x * _e24);
    let _e27 = (*uv_3)[0u];
    let _e29 = uniforms.progress;
    let _e30 = displacement;
    let _e34 = (*uv_3)[1u];
    uvFrom = vec2<f32>((_e27 + (_e29 * _e30)), _e34);
    let _e37 = (*uv_3)[0u];
    let _e39 = uniforms.progress;
    let _e41 = displacement;
    let _e45 = (*uv_3)[1u];
    uvTo = vec2<f32>((_e37 - ((1f - _e39) * _e41)), _e45);
    let _e47 = uvFrom;
    param_1 = _e47;
    let _e48 = getFromColor((&param_1));
    let _e49 = uvTo;
    param_2 = _e49;
    let _e50 = getToColor((&param_2));
    let _e52 = uniforms.progress;
    return mix(_e48, _e50, vec4(_e52));
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e14 = _uv_1;
    param_3 = _e14;
    let _e15 = transition((&param_3));
    _fragColor = _e15;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
