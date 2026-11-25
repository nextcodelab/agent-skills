// SpotlightWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SpotlightWipe.glsl
// Author: gre
// License: MIT
// Description: The stage lights go down on the outgoing image and a soft oval spotlight searches across it along a curved path, comes to rest and lights the incoming image inside it, then widens until the stage lights come back up on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    size: f32,
    darkness: f32,
    warmth: vec3<f32>,
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
    let _e45 = (*uv)[0u];
    let _e47 = (*uv)[1u];
    let _e50 = textureSampleLevel(_to, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e45 = (*uv_1)[0u];
    let _e47 = (*uv_1)[1u];
    let _e50 = textureSampleLevel(_from, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn path(t: ptr<function, f32>, c: ptr<function, vec2<f32>>) -> vec2<f32> {
    var a: vec2<f32>;
    var b: vec2<f32>;
    var d: vec2<f32>;
    var s: f32;

    a = vec2<f32>(0.08f, 0.3f);
    b = vec2<f32>(0.35f, 1.15f);
    d = vec2<f32>(1.05f, 0.95f);
    let _e49 = (*t);
    s = (1f - _e49);
    let _e51 = s;
    let _e52 = s;
    let _e54 = s;
    let _e56 = a;
    let _e58 = s;
    let _e60 = s;
    let _e62 = (*t);
    let _e64 = b;
    let _e67 = s;
    let _e69 = (*t);
    let _e71 = (*t);
    let _e73 = d;
    let _e76 = (*t);
    let _e77 = (*t);
    let _e79 = (*t);
    let _e81 = (*c);
    return ((((_e56 * ((_e51 * _e52) * _e54)) + (_e64 * (((3f * _e58) * _e60) * _e62))) + (_e73 * (((3f * _e67) * _e69) * _e71))) + (_e81 * ((_e76 * _e77) * _e79)));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var asp: vec2<f32>;
    var p: f32;
    var t_1: f32;
    var c_1: vec2<f32>;
    var param: f32;
    var param_1: vec2<f32>;
    var far: vec2<f32>;
    var full: f32;
    var g: f32;
    var radius: f32;
    var q: vec2<f32>;
    var r: f32;
    var core: f32;
    var ring: f32;
    var spot: f32;
    var s_1: f32;
    var light: vec3<f32>;
    var lit: f32;
    var col: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e66 = uniforms.ratio;
    asp = vec2<f32>(_e66, 1f);
    let _e69 = uniforms.progress;
    p = _e69;
    let _e70 = p;
    t_1 = clamp((_e70 / 0.5f), 0f, 1f);
    let _e73 = t_1;
    let _e74 = t_1;
    let _e76 = t_1;
    t_1 = ((_e73 * _e74) * (3f - (2f * _e76)));
    let _e80 = t_1;
    param = _e80;
    let _e82 = uniforms.center;
    param_1 = _e82;
    let _e83 = path((&param), (&param_1));
    c_1 = _e83;
    let _e85 = uniforms.center;
    let _e87 = uniforms.center;
    let _e91 = asp;
    far = (max(_e85, (vec2(1f) - _e87)) * _e91);
    let _e94 = far[0u];
    let _e96 = far[1u];
    full = (length(vec2<f32>(_e94, (_e96 / 0.72f))) / 0.74f);
    let _e101 = p;
    g = smoothstep(0.44f, 1f, _e101);
    let _e104 = uniforms.size;
    let _e106 = full;
    let _e107 = g;
    let _e108 = g;
    radius = mix((0.5f * _e104), _e106, (_e107 * (0.3f + (0.7f * _e108))));
    let _e113 = (*uv_2);
    let _e114 = c_1;
    let _e116 = asp;
    q = ((_e113 - _e114) * _e116);
    let _e119 = q[0u];
    let _e121 = q[1u];
    let _e125 = radius;
    r = (length(vec2<f32>(_e119, (_e121 / 0.72f))) / _e125);
    let _e127 = r;
    core = (1f - smoothstep(0.72f, 1.08f, _e127));
    let _e130 = r;
    ring = ((_e130 - 0.9f) / 0.09f);
    let _e133 = core;
    let _e134 = r;
    let _e136 = r;
    let _e140 = r;
    let _e145 = ring;
    let _e147 = ring;
    spot = (max((_e133 * (1f - ((0.1f * _e134) * _e136))), (0.12f * (1f - smoothstep(0.9f, 2.4f, _e140)))) + (0.16f * exp((-(_e145) * _e147))));
    let _e153 = uniforms.darkness;
    let _e154 = p;
    let _e157 = p;
    s_1 = ((_e153 * smoothstep(0f, 0.18f, _e154)) * (1f - smoothstep(0.72f, 1f, _e157)));
    let _e161 = s_1;
    let _e163 = s_1;
    let _e164 = spot;
    let _e167 = uniforms.warmth;
    light = (vec3((1f - _e161)) + (_e167 * (_e163 * _e164)));
    let _e171 = p;
    let _e173 = r;
    lit = (smoothstep(0.42f, 0.58f, _e171) * (1f - smoothstep(0.74f, 1f, _e173)));
    let _e177 = (*uv_2);
    param_2 = _e177;
    let _e178 = getFromColor((&param_2));
    let _e179 = (*uv_2);
    param_3 = _e179;
    let _e180 = getToColor((&param_3));
    let _e181 = lit;
    col = mix(_e178, _e180, vec4(_e181));
    let _e184 = col;
    let _e186 = light;
    let _e187 = (_e184.xyz * _e186);
    let _e189 = col[3u];
    return vec4<f32>(_e187.x, _e187.y, _e187.z, _e189);
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e44 = _uv_1;
    param_4 = _e44;
    let _e45 = transition((&param_4));
    _fragColor = _e45;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
