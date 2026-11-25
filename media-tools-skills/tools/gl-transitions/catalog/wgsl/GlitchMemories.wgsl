// GlitchMemories — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchMemories.glsl
// Author: Gunnar Roth
// License: MIT
// Description: A crossfade with glitchy, color-shifted blocks
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
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

fn transition(p: ptr<function, vec2<f32>>) -> vec4<f32> {
    var block: vec2<f32>;
    var uv_noise: vec2<f32>;
    var dist: vec2<f32>;
    var local: vec2<f32>;
    var red: vec2<f32>;
    var green: vec2<f32>;
    var blue: vec2<f32>;
    var center: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;

    let _e39 = (*p);
    block = floor((_e39 / vec2<f32>(16f, 16f)));
    let _e42 = block;
    uv_noise = (_e42 / vec2<f32>(64f, 64f));
    let _e45 = uniforms.progress;
    let _e50 = uv_noise;
    uv_noise = (_e50 + (floor((vec2(_e45) * vec2<f32>(1200f, 3500f))) / vec2<f32>(64f, 64f)));
    let _e53 = uniforms.progress;
    if (_e53 > 0f) {
        let _e55 = uv_noise;
        let _e61 = uniforms.progress;
        local = (((fract(_e55) - vec2(0.5f)) * 0.3f) * (1f - _e61));
    } else {
        local = vec2<f32>(0f, 0f);
    }
    let _e64 = local;
    dist = _e64;
    let _e65 = (*p);
    let _e66 = dist;
    red = (_e65 + (_e66 * 0.2f));
    let _e69 = (*p);
    let _e70 = dist;
    green = (_e69 + (_e70 * 0.3f));
    let _e73 = (*p);
    let _e74 = dist;
    blue = (_e73 + (_e74 * 0.5f));
    let _e77 = green;
    param = _e77;
    let _e78 = getFromColor((&param));
    let _e79 = green;
    param_1 = _e79;
    let _e80 = getToColor((&param_1));
    let _e82 = uniforms.progress;
    center = mix(_e78, _e80, vec4(_e82));
    let _e85 = red;
    param_2 = _e85;
    let _e86 = getFromColor((&param_2));
    let _e87 = red;
    param_3 = _e87;
    let _e88 = getToColor((&param_3));
    let _e90 = uniforms.progress;
    let _e95 = center[1u];
    let _e96 = blue;
    param_4 = _e96;
    let _e97 = getFromColor((&param_4));
    let _e98 = blue;
    param_5 = _e98;
    let _e99 = getToColor((&param_5));
    let _e101 = uniforms.progress;
    let _e106 = center[3u];
    return vec4<f32>(mix(_e86, _e88, vec4(_e90)).x, _e95, mix(_e97, _e99, vec4(_e101)).z, _e106);
}

fn main_1() {
    var param_6: vec2<f32>;

    let _e25 = _uv_1;
    param_6 = _e25;
    let _e26 = transition((&param_6));
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
