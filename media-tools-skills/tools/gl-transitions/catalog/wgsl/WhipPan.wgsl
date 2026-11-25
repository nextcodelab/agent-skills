// WhipPan — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WhipPan.glsl
// Author: gre
// License: MIT
// Description: A fast camera pan that streaks both images with motion blur, the incoming one arriving from the opposite side
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    blur: f32,
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
    let _e31 = (*uv)[0u];
    let _e33 = (*uv)[1u];
    let _e36 = textureSampleLevel(_to, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e31 = (*uv_1)[0u];
    let _e33 = (*uv_1)[1u];
    let _e36 = textureSampleLevel(_from, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn strip(q: ptr<function, vec2<f32>>, d: ptr<function, vec2<f32>>) -> vec4<f32> {
    var qt: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e34 = (*q);
    let _e35 = (*d);
    qt = (_e34 + _e35);
    let _e37 = (*q);
    let _e40 = (*d);
    let _e43 = (*d);
    let _e44 = (*d);
    if (dot((_e37 - vec2(0.5f)), -(_e40)) < (0.5f * dot(_e43, _e44))) {
        let _e48 = (*q);
        param = clamp(_e48, vec2(0f), vec2(1f));
        let _e52 = getFromColor((&param));
        return _e52;
    }
    let _e53 = qt;
    param_1 = clamp(_e53, vec2(0f), vec2(1f));
    let _e57 = getToColor((&param_1));
    return _e57;
}

fn rand(co: ptr<function, vec2<f32>>) -> f32 {
    let _e30 = (*co);
    return fract((sin(dot(_e30, vec2<f32>(12.9898f, 78.233f))) * 43758.547f));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var d_1: vec2<f32>;
    var p: f32;
    var h: f32;
    var e: f32;
    var pos: f32;
    var local: f32;
    var len: f32;
    var q_1: vec2<f32>;
    var jitter: f32;
    var param_2: vec2<f32>;
    var color: vec3<f32>;
    var alpha: f32;
    var i: i32;
    var t: f32;
    var c: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;

    let _e48 = uniforms.direction;
    d_1 = sign(_e48);
    let _e51 = uniforms.progress;
    p = _e51;
    let _e52 = p;
    h = (1f - abs(((2f * _e52) - 1f)));
    let _e57 = h;
    let _e59 = h;
    let _e61 = h;
    e = ((0.5f * _e57) * (0.1f + ((0.9f * _e59) * _e61)));
    let _e65 = p;
    if (_e65 < 0.5f) {
        let _e67 = e;
        local = _e67;
    } else {
        let _e68 = e;
        local = (1f - _e68);
    }
    let _e70 = local;
    pos = _e70;
    let _e72 = uniforms.blur;
    let _e73 = h;
    let _e75 = h;
    let _e77 = h;
    len = (((_e72 * _e73) * (0.1f + ((2.7f * _e75) * _e77))) / 2.8f);
    let _e82 = (*uv_2);
    let _e83 = d_1;
    let _e84 = pos;
    q_1 = (_e82 - (_e83 * _e84));
    let _e87 = (*uv_2);
    param_2 = _e87;
    let _e88 = rand((&param_2));
    jitter = _e88;
    color = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    i = 0i;
    loop {
        let _e89 = i;
        if (_e89 < 24i) {
            let _e91 = i;
            let _e93 = jitter;
            t = (((f32(_e91) + _e93) / 24f) - 0.5f);
            let _e97 = q_1;
            let _e98 = d_1;
            let _e99 = t;
            let _e101 = len;
            param_3 = (_e97 + ((_e98 * _e99) * _e101));
            let _e104 = d_1;
            param_4 = _e104;
            let _e105 = strip((&param_3), (&param_4));
            c = _e105;
            let _e106 = c;
            let _e109 = c[3u];
            let _e111 = color;
            color = (_e111 + (_e106.xyz * _e109));
            let _e114 = c[3u];
            let _e115 = alpha;
            alpha = (_e115 + _e114);
            continue;
        } else {
            break;
        }
        continuing {
            let _e117 = i;
            i = (_e117 + 1i);
        }
    }
    let _e119 = color;
    let _e120 = alpha;
    let _e123 = (_e119 / vec3(max(_e120, 0.00001f)));
    let _e124 = alpha;
    return vec4<f32>(_e123.x, _e123.y, _e123.z, (_e124 / 24f));
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e30 = _uv_1;
    param_5 = _e30;
    let _e31 = transition((&param_5));
    _fragColor = _e31;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
