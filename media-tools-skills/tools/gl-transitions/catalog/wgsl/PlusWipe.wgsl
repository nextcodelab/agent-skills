// PlusWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PlusWipe.glsl
// Author: gre
// License: MIT
// Description: A plus-shaped cross grows from the center and widens its arms until the incoming image fills the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    smoothness: f32,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e19 = (*uv)[0u];
    let _e21 = (*uv)[1u];
    let _e24 = textureSampleLevel(_to, _sampler, vec2<f32>(_e19, (1f - _e21)), 0f);
    return _e24;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e19 = (*uv_1)[0u];
    let _e21 = (*uv_1)[1u];
    let _e24 = textureSampleLevel(_from, _sampler, vec2<f32>(_e19, (1f - _e21)), 0f);
    return _e24;
}

fn boxDist(p: ptr<function, vec2<f32>>, halfSize: ptr<function, vec2<f32>>) -> f32 {
    var d: vec2<f32>;

    let _e20 = (*p);
    let _e22 = (*halfSize);
    d = (abs(_e20) - _e22);
    let _e24 = d;
    let _e29 = d[0u];
    let _e31 = d[1u];
    return (length(max(_e24, vec2(0f))) + min(max(_e29, _e31), 0f));
}

fn plus(q: ptr<function, vec2<f32>>, t: ptr<function, f32>, s: ptr<function, f32>) -> f32 {
    var frame: vec2<f32>;
    var k: f32;
    var halfWidth: vec2<f32>;
    var halfLength: f32;
    var d_1: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e30 = uniforms.ratio;
    frame = vec2<f32>((0.5f * _e30), 0.5f);
    let _e34 = frame[0u];
    let _e36 = frame[1u];
    k = min(_e34, _e36);
    let _e38 = k;
    let _e39 = (*t);
    let _e41 = frame;
    let _e42 = k;
    let _e45 = (*t);
    let _e47 = (*t);
    halfWidth = (vec2((_e38 * _e39)) + (((_e41 - vec2(_e42)) * _e45) * _e47));
    let _e52 = frame[0u];
    let _e54 = frame[1u];
    let _e57 = (*t);
    halfLength = ((3f * max(_e52, _e54)) * _e57);
    let _e59 = halfLength;
    let _e61 = halfWidth[1u];
    let _e63 = (*q);
    param = _e63;
    param_1 = vec2<f32>(_e59, _e61);
    let _e64 = boxDist((&param), (&param_1));
    let _e66 = halfWidth[0u];
    let _e67 = halfLength;
    let _e69 = (*q);
    param_2 = _e69;
    param_3 = vec2<f32>(_e66, _e67);
    let _e70 = boxDist((&param_2), (&param_3));
    d_1 = min(_e64, _e70);
    let _e72 = (*s);
    let _e73 = d_1;
    let _e74 = (*s);
    let _e75 = (*t);
    return (1f - smoothstep(0f, _e72, (_e73 + (_e74 * (1f - _e75)))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var q_1: vec2<f32>;
    var s_1: f32;
    var m: f32;
    var local: f32;
    var param_4: vec2<f32>;
    var param_5: f32;
    var param_6: f32;
    var param_7: vec2<f32>;
    var param_8: f32;
    var param_9: f32;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;

    let _e30 = (*uv_2);
    let _e34 = uniforms.ratio;
    q_1 = ((_e30 - vec2(0.5f)) * vec2<f32>(_e34, 1f));
    let _e38 = uniforms.smoothness;
    s_1 = max(_e38, 0.001f);
    let _e41 = uniforms.reverse;
    if (_e41 != 0i) {
        let _e44 = uniforms.progress;
        let _e46 = q_1;
        param_4 = _e46;
        param_5 = (1f - _e44);
        let _e47 = s_1;
        param_6 = _e47;
        let _e48 = plus((&param_4), (&param_5), (&param_6));
        local = (1f - _e48);
    } else {
        let _e50 = q_1;
        param_7 = _e50;
        let _e52 = uniforms.progress;
        param_8 = _e52;
        let _e53 = s_1;
        param_9 = _e53;
        let _e54 = plus((&param_7), (&param_8), (&param_9));
        local = _e54;
    }
    let _e55 = local;
    m = _e55;
    let _e56 = (*uv_2);
    param_10 = _e56;
    let _e57 = getFromColor((&param_10));
    let _e58 = (*uv_2);
    param_11 = _e58;
    let _e59 = getToColor((&param_11));
    let _e60 = m;
    return mix(_e57, _e59, vec4(_e60));
}

fn main_1() {
    var param_12: vec2<f32>;

    let _e18 = _uv_1;
    param_12 = _e18;
    let _e19 = transition((&param_12));
    _fragColor = _e19;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
