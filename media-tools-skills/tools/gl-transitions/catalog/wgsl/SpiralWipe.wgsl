// SpiralWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SpiralWipe.glsl
// Author: gre
// License: MIT
// Description: A spiral arm winds out from the center and widens to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    turns: f32,
    smoothness: f32,
    clockwise: i32,
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

fn arm(s: ptr<function, f32>, d: ptr<function, f32>) -> f32 {
    var end: f32;
    var tip: f32;
    var width: f32;
    var e: f32;

    let _e30 = uniforms.turns;
    end = (-0.5f + ((_e30 + 0.5f) / 0.6f));
    let _e34 = end;
    let _e36 = uniforms.progress;
    tip = mix(-0.5f, _e34, _e36);
    let _e38 = (*s);
    (*s) = max(_e38, -0.5f);
    let _e40 = tip;
    let _e41 = (*s);
    let _e43 = end;
    let _e44 = (*s);
    width = sqrt(clamp(((_e40 - _e41) / max((_e43 - _e44), 0.001f)), 0f, 1f));
    let _e51 = uniforms.smoothness;
    let _e53 = uniforms.turns;
    e = (_e51 + (0.005f * _e53));
    let _e56 = e;
    let _e57 = width;
    let _e58 = e;
    let _e61 = (*d);
    return smoothstep(0f, _e56, ((_e57 * (0.5f + _e58)) - _e61));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var q: vec2<f32>;
    var a: f32;
    var local: f32;
    var local_1: f32;
    var w: f32;
    var n: f32;
    var f: f32;
    var m: f32;
    var param: f32;
    var param_1: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;

    let _e40 = (*uv_2);
    let _e44 = uniforms.ratio;
    let _e48 = uniforms.ratio;
    q = (((_e40 - vec2(0.5f)) * vec2<f32>(_e44, 1f)) / vec2((0.5f * length(vec2<f32>(_e48, 1f)))));
    let _e54 = q;
    let _e55 = q;
    if (dot(_e54, _e55) < 0.000000000001f) {
        local = 0f;
    } else {
        let _e59 = q[0u];
        let _e61 = q[1u];
        local = (atan2(_e59, _e61) / 6.2831855f);
    }
    let _e64 = local;
    a = _e64;
    let _e66 = uniforms.clockwise;
    if (_e66 != 0i) {
        let _e68 = a;
        local_1 = _e68;
    } else {
        let _e69 = a;
        local_1 = -(_e69);
    }
    let _e71 = local_1;
    a = fract(_e71);
    let _e73 = q;
    let _e76 = uniforms.turns;
    let _e78 = a;
    w = ((length(_e73) * _e76) - _e78);
    let _e80 = w;
    n = floor(_e80);
    let _e82 = w;
    let _e83 = n;
    f = (_e82 - _e83);
    let _e85 = n;
    let _e86 = a;
    let _e88 = f;
    param = (_e85 + _e86);
    param_1 = abs((_e88 - 0.5f));
    let _e91 = arm((&param), (&param_1));
    let _e92 = n;
    let _e94 = a;
    let _e96 = f;
    param_2 = ((_e92 + 1f) + _e94);
    param_3 = (1.5f - _e96);
    let _e98 = arm((&param_2), (&param_3));
    let _e99 = n;
    let _e101 = a;
    let _e103 = f;
    param_4 = ((_e99 - 1f) + _e101);
    param_5 = (_e103 + 0.5f);
    let _e105 = arm((&param_4), (&param_5));
    m = max(_e91, max(_e98, _e105));
    let _e108 = (*uv_2);
    param_6 = _e108;
    let _e109 = getFromColor((&param_6));
    let _e110 = (*uv_2);
    param_7 = _e110;
    let _e111 = getToColor((&param_7));
    let _e112 = m;
    return mix(_e109, _e111, vec4(_e112));
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e24 = _uv_1;
    param_8 = _e24;
    let _e25 = transition((&param_8));
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
