// TvRoll — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvRoll.glsl
// Author: gre
// License: MIT
// Description: The outgoing image rolls faster and faster, like an old TV losing its vertical hold, then the roll slows down and locks on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    rolls: i32,
    barHeight: f32,
    barColor: vec4<f32>,
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
    let _e34 = (*uv)[0u];
    let _e36 = (*uv)[1u];
    let _e39 = textureSampleLevel(_to, _sampler, vec2<f32>(_e34, (1f - _e36)), 0f);
    return _e39;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e34 = (*uv_1)[0u];
    let _e36 = (*uv_1)[1u];
    let _e39 = textureSampleLevel(_from, _sampler, vec2<f32>(_e34, (1f - _e36)), 0f);
    return _e39;
}

fn picture(uv_2: ptr<function, vec2<f32>>, y: ptr<function, f32>, m: ptr<function, f32>) -> vec4<f32> {
    var period: f32;
    var q: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e40 = uniforms.barHeight;
    period = (1f + _e40);
    let _e42 = (*y);
    let _e43 = period;
    (*y) = (_e42 - (floor((_e42 / _e43)) * _e43));
    let _e48 = (*y);
    if (_e48 > 1f) {
        let _e51 = uniforms.barColor;
        return _e51;
    }
    let _e53 = (*uv_2)[0u];
    let _e54 = (*y);
    q = vec2<f32>(_e53, _e54);
    let _e56 = q;
    param = _e56;
    let _e57 = getFromColor((&param));
    let _e58 = q;
    param_1 = _e58;
    let _e59 = getToColor((&param_1));
    let _e60 = (*m);
    return mix(_e57, _e59, vec4(_e60));
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var period_1: f32;
    var s: f32;
    var offset: f32;
    var speed: f32;
    var m_1: f32;
    var p: vec2<f32>;
    var c: vec4<f32>;
    var i: i32;
    var param_2: vec2<f32>;
    var param_3: f32;
    var param_4: f32;
    var scan: f32;
    var flicker: f32;

    let _e47 = uniforms.barHeight;
    period_1 = (1f + _e47);
    let _e50 = uniforms.progress;
    let _e52 = uniforms.progress;
    let _e55 = uniforms.progress;
    s = ((_e50 * _e52) * (3f - (2f * _e55)));
    let _e59 = period_1;
    let _e61 = uniforms.rolls;
    let _e63 = s;
    offset = (_e59 * fract((f32(_e61) * _e63)));
    let _e68 = uniforms.progress;
    let _e71 = uniforms.progress;
    speed = ((4f * _e68) * (1f - _e71));
    let _e75 = uniforms.progress;
    m_1 = smoothstep(0.42f, 0.58f, _e75);
    let _e77 = (*uv_3);
    let _e78 = speed;
    let _e81 = (*uv_3)[1u];
    let _e84 = uniforms.progress;
    p = (_e77 + vec2<f32>(((0.004f * _e78) * sin(((_e81 * 9f) + (_e84 * 30f)))), 0f));
    c = vec4<f32>(0f, 0f, 0f, 0f);
    i = 0i;
    loop {
        let _e91 = i;
        if (_e91 < 5i) {
            let _e94 = p[1u];
            let _e95 = offset;
            let _e98 = uniforms.rolls;
            let _e101 = speed;
            let _e103 = i;
            let _e107 = p;
            param_2 = _e107;
            param_3 = ((_e94 + _e95) - (((0.0015f * f32(_e98)) * _e101) * f32(_e103)));
            let _e108 = m_1;
            param_4 = _e108;
            let _e109 = picture((&param_2), (&param_3), (&param_4));
            let _e110 = c;
            c = (_e110 + _e109);
            continue;
        } else {
            break;
        }
        continuing {
            let _e112 = i;
            i = (_e112 + 1i);
        }
    }
    let _e114 = c;
    c = (_e114 / vec4(5f));
    let _e118 = (*uv_3)[1u];
    scan = (0.5f + (0.5f * sin((_e118 * 400f))));
    let _e124 = uniforms.progress;
    flicker = (0.08f * (0.5f + (0.5f * sin((_e124 * 97f)))));
    let _e130 = speed;
    let _e131 = scan;
    let _e133 = flicker;
    let _e137 = c;
    let _e139 = (_e137.xyz * (1f - (_e130 * ((0.08f * _e131) + _e133))));
    c[0u] = _e139.x;
    c[1u] = _e139.y;
    c[2u] = _e139.z;
    let _e146 = c;
    return _e146;
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e33 = _uv_1;
    param_5 = _e33;
    let _e34 = transition((&param_5));
    _fragColor = _e34;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
