// CurvedWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CurvedWipe.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is pulled away by its middle: the wipe edge bulges into a smooth curve that leads the way, then flattens as it reaches the far side
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    curvature: f32,
    smoothness: f32,
    shadow: vec4<f32>,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e29 = (*uv)[0u];
    let _e31 = (*uv)[1u];
    let _e34 = textureSampleLevel(_from, _sampler, vec2<f32>(_e29, (1f - _e31)), 0f);
    return _e34;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e29 = (*uv_1)[0u];
    let _e31 = (*uv_1)[1u];
    let _e34 = textureSampleLevel(_to, _sampler, vec2<f32>(_e29, (1f - _e31)), 0f);
    return _e34;
}

fn ease(t: ptr<function, f32>) -> f32 {
    let _e28 = (*t);
    let _e29 = (*t);
    let _e30 = (*t);
    let _e32 = (*t);
    return (0.5f * (_e28 + ((_e29 * _e30) * (3f - (2f * _e32)))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var p: vec2<f32>;
    var e: f32;
    var w: f32;
    var across: vec2<f32>;
    var d: f32;
    var x: f32;
    var s: f32;
    var k: f32;
    var t_1: f32;
    var travel: f32;
    var edge: f32;
    var param: f32;
    var side: f32;
    var param_1: f32;
    var m: f32;
    var lift: f32;
    var spread: f32;
    var to: vec4<f32>;
    var param_2: vec2<f32>;
    var caster: vec2<f32>;
    var sh: f32;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;

    let _e54 = uniforms.direction;
    if (length(_e54) > 0f) {
        let _e58 = uniforms.direction;
        local = normalize(_e58);
    } else {
        local = vec2<f32>(0f, 1f);
    }
    let _e60 = local;
    dir = _e60;
    let _e61 = (*uv_2);
    let _e65 = uniforms.ratio;
    p = ((_e61 - vec2(0.5f)) * vec2<f32>(_e65, 1f));
    let _e69 = dir[0u];
    let _e72 = uniforms.ratio;
    let _e75 = dir[1u];
    e = (0.5f * ((abs(_e69) * _e72) + abs(_e75)));
    let _e80 = dir[1u];
    let _e83 = uniforms.ratio;
    let _e86 = dir[0u];
    w = (0.5f * ((abs(_e80) * _e83) + abs(_e86)));
    let _e91 = dir[1u];
    let _e94 = dir[0u];
    across = vec2<f32>(-(_e91), _e94);
    let _e96 = p;
    let _e97 = dir;
    d = dot(_e96, _e97);
    let _e99 = p;
    let _e100 = across;
    let _e102 = w;
    x = clamp((dot(_e99, _e100) / _e102), -1f, 1f);
    let _e106 = uniforms.smoothness;
    s = max(_e106, 0.001f);
    let _e109 = uniforms.curvature;
    let _e111 = w;
    let _e112 = e;
    let _e116 = x;
    let _e117 = x;
    k = ((clamp(_e109, 0f, 1f) * min(1f, (_e111 / _e112))) * (1f - (_e116 * _e117)));
    let _e122 = uniforms.progress;
    let _e123 = k;
    let _e125 = uniforms.progress;
    let _e128 = uniforms.progress;
    t_1 = (_e122 + ((_e123 * _e125) * (1f - _e128)));
    let _e132 = e;
    let _e133 = s;
    travel = (2f * (_e132 + _e133));
    let _e136 = e;
    let _e138 = s;
    let _e140 = travel;
    let _e141 = t_1;
    param = _e141;
    let _e142 = ease((&param));
    edge = ((-(_e136) - _e138) + (_e140 * _e142));
    let _e145 = e;
    let _e147 = s;
    let _e149 = travel;
    let _e151 = uniforms.progress;
    param_1 = _e151;
    let _e152 = ease((&param_1));
    side = ((-(_e145) - _e147) + (_e149 * _e152));
    let _e155 = s;
    let _e157 = s;
    let _e158 = d;
    let _e159 = edge;
    m = (1f - smoothstep(-(_e155), _e157, (_e158 - _e159)));
    let _e163 = edge;
    let _e164 = side;
    lift = (_e163 - _e164);
    let _e166 = lift;
    spread = (0.012f + (0.25f * _e166));
    let _e169 = (*uv_2);
    param_2 = _e169;
    let _e170 = getToColor((&param_2));
    to = _e170;
    let _e171 = p;
    let _e172 = edge;
    let _e173 = d;
    let _e175 = dir;
    let _e179 = uniforms.ratio;
    caster = clamp((((_e171 + (_e175 * (_e172 - _e173))) / vec2<f32>(_e179, 1f)) + vec2(0.5f)), vec2(0f), vec2(1f));
    let _e189 = uniforms.shadow[3u];
    let _e191 = uniforms.progress;
    let _e195 = edge;
    let _e196 = d;
    let _e200 = spread;
    let _e204 = m;
    let _e206 = caster;
    param_3 = _e206;
    let _e207 = getFromColor((&param_3));
    let _e211 = to[3u];
    sh = (((((_e189 * sin((3.1415927f * _e191))) * exp((-(max((_e195 - _e196), 0f)) / _e200))) * _e204) * _e207.w) * _e211);
    let _e213 = to;
    let _e216 = uniforms.shadow;
    let _e218 = sh;
    let _e220 = mix(_e213.xyz, _e216.xyz, vec3(_e218));
    to[0u] = _e220.x;
    to[1u] = _e220.y;
    to[2u] = _e220.z;
    let _e227 = (*uv_2);
    param_4 = _e227;
    let _e228 = getFromColor((&param_4));
    let _e229 = to;
    let _e230 = m;
    return mix(_e228, _e229, vec4(_e230));
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e28 = _uv_1;
    param_5 = _e28;
    let _e29 = transition((&param_5));
    _fragColor = _e29;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
