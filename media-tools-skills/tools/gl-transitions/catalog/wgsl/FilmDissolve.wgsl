// FilmDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmDissolve.glsl
// Author: gre
// License: MIT
// Description: A cross-dissolve blended in linear light, as light adds up on film: the frame keeps its brightness all the way through and the highlights of each image shine through the other
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    overlap: f32,
    smoothness: f32,
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

fn toSrgb(c: ptr<function, vec3<f32>>) -> vec3<f32> {
    var lo: vec3<f32>;
    var hi: vec3<f32>;

    let _e33 = (*c);
    lo = (_e33 * 12.92f);
    let _e35 = (*c);
    hi = ((pow(_e35, vec3<f32>(0.41666666f, 0.41666666f, 0.41666666f)) * 1.055f) - vec3(0.055f));
    let _e40 = lo;
    let _e41 = hi;
    let _e42 = (*c);
    return mix(_e40, _e41, select(vec3<f32>(0f, 0f, 0f), vec3<f32>(1f, 1f, 1f), (_e42 > vec3<f32>(0.0031308f, 0.0031308f, 0.0031308f))));
}

fn toLinear(c_1: ptr<function, vec3<f32>>) -> vec3<f32> {
    var lo_1: vec3<f32>;
    var hi_1: vec3<f32>;

    let _e33 = (*c_1);
    lo_1 = (_e33 / vec3(12.92f));
    let _e36 = (*c_1);
    hi_1 = pow(((_e36 + vec3(0.055f)) / vec3(1.055f)), vec3<f32>(2.4f, 2.4f, 2.4f));
    let _e42 = lo_1;
    let _e43 = hi_1;
    let _e44 = (*c_1);
    return mix(_e42, _e43, select(vec3<f32>(0f, 0f, 0f), vec3<f32>(1f, 1f, 1f), (_e44 > vec3<f32>(0.04045f, 0.04045f, 0.04045f))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e32 = (*uv)[0u];
    let _e34 = (*uv)[1u];
    let _e37 = textureSampleLevel(_to, _sampler, vec2<f32>(_e32, (1f - _e34)), 0f);
    return _e37;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e32 = (*uv_1)[0u];
    let _e34 = (*uv_1)[1u];
    let _e37 = textureSampleLevel(_from, _sampler, vec2<f32>(_e32, (1f - _e34)), 0f);
    return _e37;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var t: f32;
    var la: vec3<f32>;
    var param_2: vec3<f32>;
    var lb: vec3<f32>;
    var param_3: vec3<f32>;
    var base: vec3<f32>;
    var alpha: f32;
    var extra: f32;
    var excess: vec3<f32>;
    var room: vec3<f32>;
    var color: vec3<f32>;
    var param_4: vec3<f32>;

    let _e47 = (*uv_2);
    param = _e47;
    let _e48 = getFromColor((&param));
    a = _e48;
    let _e49 = (*uv_2);
    param_1 = _e49;
    let _e50 = getToColor((&param_1));
    b = _e50;
    let _e52 = uniforms.progress;
    if (_e52 <= 0f) {
        let _e54 = a;
        return _e54;
    }
    let _e56 = uniforms.progress;
    if (_e56 >= 1f) {
        let _e58 = b;
        return _e58;
    }
    let _e60 = uniforms.progress;
    let _e62 = uniforms.progress;
    let _e65 = uniforms.smoothness;
    t = mix(_e60, smoothstep(0f, 1f, _e62), _e65);
    let _e67 = a;
    param_2 = clamp(_e67.xyz, vec3(0f), vec3(1f));
    let _e72 = toLinear((&param_2));
    let _e74 = a[3u];
    la = (_e72 * _e74);
    let _e76 = b;
    param_3 = clamp(_e76.xyz, vec3(0f), vec3(1f));
    let _e81 = toLinear((&param_3));
    let _e83 = b[3u];
    lb = (_e81 * _e83);
    let _e85 = la;
    let _e86 = lb;
    let _e87 = t;
    base = mix(_e85, _e86, vec3(_e87));
    let _e91 = a[3u];
    let _e93 = b[3u];
    let _e94 = t;
    alpha = mix(_e91, _e93, _e94);
    let _e97 = uniforms.overlap;
    let _e98 = t;
    let _e99 = t;
    extra = (_e97 * min(_e98, (1f - _e99)));
    let _e103 = extra;
    let _e104 = la;
    let _e105 = lb;
    excess = ((_e104 + _e105) * _e103);
    let _e108 = alpha;
    let _e110 = base;
    room = max((vec3(_e108) - _e110), vec3<f32>(0.00001f, 0.00001f, 0.00001f));
    let _e113 = base;
    let _e114 = room;
    let _e115 = excess;
    let _e117 = room;
    color = (_e113 + (_e114 * (vec3(1f) - exp((-(_e115) / _e117)))));
    let _e124 = alpha;
    if (_e124 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e126 = color;
    let _e127 = alpha;
    param_4 = clamp((_e126 / vec3(_e127)), vec3(0f), vec3(1f));
    let _e133 = toSrgb((&param_4));
    let _e134 = alpha;
    return vec4<f32>(_e133.x, _e133.y, _e133.z, _e134);
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e31 = _uv_1;
    param_5 = _e31;
    let _e32 = transition((&param_5));
    _fragColor = _e32;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
