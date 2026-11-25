// TvTurnOff — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TvTurnOff.glsl
// Author: gre
// License: MIT
// Description: The outgoing image collapses into a glowing line and a dot, like an old TV turned off, then the incoming image powers on from the dot
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    color: vec4<f32>,
    glow: f32,
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
    let _e36 = (*uv)[0u];
    let _e38 = (*uv)[1u];
    let _e41 = textureSampleLevel(_to, _sampler, vec2<f32>(_e36, (1f - _e38)), 0f);
    return _e41;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e36 = (*uv_1)[0u];
    let _e38 = (*uv_1)[1u];
    let _e41 = textureSampleLevel(_from, _sampler, vec2<f32>(_e36, (1f - _e38)), 0f);
    return _e41;
}

fn getColor(uv_2: ptr<function, vec2<f32>>, isFrom: ptr<function, bool>) -> vec4<f32> {
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e39 = (*isFrom);
    if _e39 {
        let _e40 = (*uv_2);
        param = _e40;
        let _e41 = getFromColor((&param));
        local = _e41;
    } else {
        let _e42 = (*uv_2);
        param_1 = _e42;
        let _e43 = getToColor((&param_1));
        local = _e43;
    }
    let _e44 = local;
    return _e44;
}

fn screen(uv_3: ptr<function, vec2<f32>>, t: ptr<function, f32>, isFrom_1: ptr<function, bool>) -> vec4<f32> {
    var collapse: f32;
    var shrink: f32;
    var fade: f32;
    var radius: f32;
    var size: vec2<f32>;
    var p: vec2<f32>;
    var q: vec2<f32>;
    var c: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: bool;
    var white: f32;
    var light: vec4<f32>;
    var d: vec2<f32>;
    var dist: f32;
    var inside: f32;
    var mid: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: bool;
    var halo: vec4<f32>;
    var h: f32;
    var col: vec4<f32>;

    let _e58 = (*t);
    collapse = smoothstep(0f, 0.4f, _e58);
    let _e60 = (*t);
    shrink = smoothstep(0.3f, 0.65f, _e60);
    let _e62 = (*t);
    fade = (0.4f * smoothstep(0.75f, 1f, _e62));
    let _e65 = fade;
    radius = (0.01f * (1f - _e65));
    let _e69 = uniforms.ratio;
    let _e71 = radius;
    let _e72 = shrink;
    let _e74 = radius;
    let _e75 = collapse;
    size = vec2<f32>(mix((0.5f * _e69), _e71, _e72), mix(0.5f, _e74, _e75));
    let _e78 = (*uv_3);
    let _e82 = uniforms.ratio;
    p = ((_e78 - vec2(0.5f)) * vec2<f32>(_e82, 1f));
    let _e85 = p;
    let _e87 = size;
    q = clamp((vec2(0.5f) + ((_e85 * 0.5f) / _e87)), vec2(0f), vec2(1f));
    let _e94 = q;
    param_2 = _e94;
    let _e95 = (*isFrom_1);
    param_3 = _e95;
    let _e96 = getColor((&param_2), (&param_3));
    c = _e96;
    let _e97 = collapse;
    white = smoothstep(0.4f, 1f, _e97);
    let _e99 = c;
    let _e101 = collapse;
    let _e107 = white;
    let _e109 = mix(min((_e99.xyz * (1f + (2f * _e101))), vec3(1f)), vec3<f32>(1f, 1f, 1f), vec3(_e107));
    let _e111 = c[3u];
    light = vec4<f32>(_e109.x, _e109.y, _e109.z, _e111);
    let _e116 = p;
    let _e118 = size;
    d = (abs(_e116) - _e118);
    let _e120 = d;
    let _e125 = d[0u];
    let _e127 = d[1u];
    dist = (length(max(_e120, vec2(0f))) + min(max(_e125, _e127), 0f));
    let _e131 = dist;
    inside = clamp((1f - (_e131 / 0.004f)), 0f, 1f);
    param_4 = vec2<f32>(0.5f, 0.5f);
    let _e135 = (*isFrom_1);
    param_5 = _e135;
    let _e136 = getColor((&param_4), (&param_5));
    mid = _e136;
    let _e137 = mid;
    let _e141 = shrink;
    let _e143 = mix(mix(_e137.xyz, vec3<f32>(1f, 1f, 1f), vec3(0.7f)), vec3<f32>(1f, 0.92f, 0.8f), vec3(_e141));
    let _e145 = mid[3u];
    halo = vec4<f32>(_e143.x, _e143.y, _e143.z, _e145);
    let _e151 = uniforms.glow;
    let _e153 = white;
    let _e155 = dist;
    let _e158 = shrink;
    h = (1f - exp((((-2f * _e151) * _e153) * exp((-(max(_e155, 0f)) / (0.02f + (0.04f * _e158)))))));
    let _e167 = uniforms.color;
    let _e168 = halo;
    let _e169 = h;
    let _e170 = fade;
    col = mix(_e167, _e168, vec4((_e169 * (1f - _e170))));
    let _e175 = col;
    let _e176 = light;
    let _e177 = inside;
    let _e178 = fade;
    return mix(_e175, _e176, vec4((_e177 * (1f - _e178))));
}

fn transition(uv_4: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_6: vec2<f32>;
    var param_7: f32;
    var param_8: bool;
    var param_9: vec2<f32>;
    var param_10: f32;
    var param_11: bool;

    let _e42 = uniforms.progress;
    if (_e42 < 0.5f) {
        let _e45 = uniforms.progress;
        let _e47 = (*uv_4);
        param_6 = _e47;
        param_7 = (2f * _e45);
        param_8 = true;
        let _e48 = screen((&param_6), (&param_7), (&param_8));
        return _e48;
    }
    let _e50 = uniforms.progress;
    let _e53 = (*uv_4);
    param_9 = _e53;
    param_10 = (2f - (2f * _e50));
    param_11 = false;
    let _e54 = screen((&param_9), (&param_10), (&param_11));
    return _e54;
}

fn main_1() {
    var param_12: vec2<f32>;

    let _e35 = _uv_1;
    param_12 = _e35;
    let _e36 = transition((&param_12));
    _fragColor = _e36;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
