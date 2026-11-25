// PlasmaDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PlasmaDissolve.glsl
// Author: gre
// License: MIT
// Description: A flowing plasma of sine waves, as in the old demos, draws moving bands through which the incoming image spreads like tendrils, with a glowing edge
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    scale: f32,
    smoothness: f32,
    flow: f32,
    edgeColor: vec3<f32>,
    edgeStrength: f32,
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
    let _e35 = (*uv)[0u];
    let _e37 = (*uv)[1u];
    let _e40 = textureSampleLevel(_to, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv_1)[0u];
    let _e37 = (*uv_1)[1u];
    let _e40 = textureSampleLevel(_from, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var p: vec2<f32>;
    var t: f32;
    var v: f32;
    var s: f32;
    var threshold: f32;
    var m: f32;
    var col: vec4<f32>;
    var glow: f32;

    let _e46 = (*uv_2);
    param = _e46;
    let _e47 = getFromColor((&param));
    a = _e47;
    let _e48 = (*uv_2);
    param_1 = _e48;
    let _e49 = getToColor((&param_1));
    b = _e49;
    let _e51 = uniforms.progress;
    if (_e51 <= 0f) {
        let _e53 = a;
        return _e53;
    }
    let _e55 = uniforms.progress;
    if (_e55 >= 1f) {
        let _e57 = b;
        return _e57;
    }
    let _e58 = (*uv_2);
    let _e62 = uniforms.ratio;
    let _e66 = uniforms.scale;
    p = (((((_e58 - vec2(0.5f)) * vec2<f32>(_e62, 1f)) * max(_e66, 0f)) * 2f) * 3.1415927f);
    let _e72 = uniforms.flow;
    let _e75 = uniforms.progress;
    t = ((clamp(_e72, 0f, 1f) * _e75) * 0.5f);
    let _e79 = p[0u];
    let _e81 = t;
    let _e85 = p[1u];
    let _e87 = t;
    let _e93 = p[0u];
    let _e96 = p[1u];
    let _e100 = t;
    let _e105 = p;
    let _e107 = uniforms.scale;
    let _e115 = t;
    v = (((sin(((_e79 * 0.6f) + _e81)) + sin(((_e85 * 0.8f) - (_e87 * 0.8f)))) + sin(((((_e93 * 0.5f) + (_e96 * 0.7f)) * 0.7f) + (_e100 * 0.6f)))) + sin(((length((_e105 - (((vec2<f32>(0.15f, -0.1f) * max(_e107, 0f)) * 2f) * 3.1415927f))) * 0.9f) - (_e115 * 1.2f))));
    let _e120 = v;
    v = abs(((fract(((_e120 * 0.25f) + 0.5f)) * 2f) - 1f));
    let _e128 = uniforms.smoothness;
    s = max(_e128, 0.001f);
    let _e130 = s;
    let _e132 = s;
    let _e135 = uniforms.progress;
    threshold = mix(-(_e130), (1f + _e132), _e135);
    let _e137 = threshold;
    let _e138 = s;
    let _e140 = threshold;
    let _e141 = s;
    let _e143 = v;
    m = (1f - smoothstep((_e137 - _e138), (_e140 + _e141), _e143));
    let _e146 = a;
    let _e149 = a[3u];
    let _e150 = (_e146.xyz * _e149);
    let _e152 = a[3u];
    let _e157 = b;
    let _e160 = b[3u];
    let _e161 = (_e157.xyz * _e160);
    let _e163 = b[3u];
    let _e168 = m;
    col = mix(vec4<f32>(_e150.x, _e150.y, _e150.z, _e152), vec4<f32>(_e161.x, _e161.y, _e161.z, _e163), vec4(_e168));
    let _e172 = col[3u];
    if (_e172 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e174 = m;
    let _e176 = m;
    let _e180 = uniforms.edgeStrength;
    glow = (((4f * _e174) * (1f - _e176)) * max(_e180, 0f));
    let _e183 = col;
    let _e186 = col[3u];
    let _e190 = uniforms.edgeColor;
    let _e191 = glow;
    let _e193 = ((_e183.xyz / vec3(_e186)) + (_e190 * _e191));
    let _e195 = col[3u];
    return vec4<f32>(_e193.x, _e193.y, _e193.z, _e195);
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e34 = _uv_1;
    param_2 = _e34;
    let _e35 = transition((&param_2));
    _fragColor = _e35;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
