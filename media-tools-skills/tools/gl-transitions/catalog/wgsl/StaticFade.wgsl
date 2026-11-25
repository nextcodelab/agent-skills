// StaticFade — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StaticFade.glsl
// Author: Ben Lucas
// License: MIT
// Description: Cuts to the incoming image halfway, hidden behind a burst of TV static
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    n_noise_pixels: f32,
    static_luminosity: f32,
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
    let _e26 = (*st);
    return fract((sin(dot(_e26, vec2<f32>(10.530234f, 70.23493f))) * 12345.545f));
}

fn staticIntensity(t: ptr<function, f32>) -> f32 {
    var transitionProgress: f32;
    var transformedThreshold: f32;

    let _e28 = (*t);
    transitionProgress = abs((2f * (_e28 - 0.5f)));
    let _e32 = transitionProgress;
    transformedThreshold = ((1.2f * (1f - _e32)) - 0.1f);
    let _e36 = transformedThreshold;
    return min(1f, _e36);
}

fn staticNoise(st_1: ptr<function, vec2<f32>>, offset: ptr<function, f32>, luminosity: ptr<function, f32>, alpha: ptr<function, f32>) -> vec4<f32> {
    var staticR: f32;
    var param: vec2<f32>;
    var staticG: f32;
    var param_1: vec2<f32>;
    var staticB: f32;
    var param_2: vec2<f32>;

    let _e35 = (*luminosity);
    let _e36 = (*st_1);
    let _e37 = (*offset);
    let _e39 = (*offset);
    param = (_e36 * vec2<f32>((_e37 * 2f), (_e39 * 3f)));
    let _e43 = rnd((&param));
    staticR = (_e35 * _e43);
    let _e45 = (*luminosity);
    let _e46 = (*st_1);
    let _e47 = (*offset);
    let _e49 = (*offset);
    param_1 = (_e46 * vec2<f32>((_e47 * 3f), (_e49 * 5f)));
    let _e53 = rnd((&param_1));
    staticG = (_e45 * _e53);
    let _e55 = (*luminosity);
    let _e56 = (*st_1);
    let _e57 = (*offset);
    let _e59 = (*offset);
    param_2 = (_e56 * vec2<f32>((_e57 * 5f), (_e59 * 7f)));
    let _e63 = rnd((&param_2));
    staticB = (_e55 * _e63);
    let _e65 = staticR;
    let _e66 = staticG;
    let _e67 = staticB;
    let _e68 = (*alpha);
    return vec4<f32>(_e65, _e66, _e67, _e68);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e27 = (*uv)[0u];
    let _e29 = (*uv)[1u];
    let _e32 = textureSampleLevel(_to, _sampler, vec2<f32>(_e27, (1f - _e29)), 0f);
    return _e32;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e27 = (*uv_1)[0u];
    let _e29 = (*uv_1)[1u];
    let _e32 = textureSampleLevel(_from, _sampler, vec2<f32>(_e27, (1f - _e29)), 0f);
    return _e32;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var baseMix: f32;
    var transitionMix: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var uvStatic: vec2<f32>;
    var staticColor: vec4<f32>;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var staticThresh: f32;
    var param_9: f32;
    var staticMix: f32;
    var param_10: vec2<f32>;

    let _e41 = uniforms.progress;
    baseMix = step(0.5f, _e41);
    let _e43 = (*uv_2);
    param_3 = _e43;
    let _e44 = getFromColor((&param_3));
    let _e45 = (*uv_2);
    param_4 = _e45;
    let _e46 = getToColor((&param_4));
    let _e47 = baseMix;
    transitionMix = mix(_e44, _e46, vec4(_e47));
    let _e50 = (*uv_2);
    let _e52 = uniforms.n_noise_pixels;
    let _e56 = uniforms.n_noise_pixels;
    uvStatic = (floor((_e50 * _e52)) / vec2(_e56));
    let _e59 = uvStatic;
    param_5 = _e59;
    let _e61 = uniforms.progress;
    param_6 = _e61;
    let _e63 = uniforms.static_luminosity;
    param_7 = _e63;
    let _e65 = transitionMix[3u];
    param_8 = _e65;
    let _e66 = staticNoise((&param_5), (&param_6), (&param_7), (&param_8));
    staticColor = _e66;
    let _e68 = uniforms.progress;
    param_9 = _e68;
    let _e69 = staticIntensity((&param_9));
    staticThresh = _e69;
    let _e70 = uvStatic;
    param_10 = _e70;
    let _e71 = rnd((&param_10));
    let _e72 = staticThresh;
    staticMix = step(_e71, _e72);
    let _e74 = transitionMix;
    let _e75 = staticColor;
    let _e76 = staticMix;
    return mix(_e74, _e75, vec4(_e76));
}

fn main_1() {
    var param_11: vec2<f32>;

    let _e26 = _uv_1;
    param_11 = _e26;
    let _e27 = transition((&param_11));
    _fragColor = _e27;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
