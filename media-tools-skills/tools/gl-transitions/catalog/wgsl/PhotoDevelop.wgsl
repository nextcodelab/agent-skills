// PhotoDevelop — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PhotoDevelop.glsl
// Author: gre
// License: MIT
// Description: The outgoing image washes out to a blank cream card, then the incoming image develops on it like an instant photo: shadows first, faint and tinted, then its contrast and colors come up and it settles
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    card: vec4<f32>,
    wash: f32,
    tint: f32,
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

fn saturation(c: ptr<function, vec3<f32>>, s: ptr<function, f32>) -> vec3<f32> {
    var lum: f32;

    let _e45 = (*c);
    lum = dot(_e45, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e47 = lum;
    let _e49 = (*c);
    let _e50 = (*s);
    return mix(vec3(_e47), _e49, vec3(_e50));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv)[0u];
    let _e46 = (*uv)[1u];
    let _e49 = textureSampleLevel(_to, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv_1)[0u];
    let _e46 = (*uv_1)[1u];
    let _e49 = textureSampleLevel(_from, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var p: f32;
    var split: f32;
    var cardAlpha: f32;
    var cardColor: vec3<f32>;
    var w: f32;
    var fromLum: f32;
    var wl: f32;
    var washed: vec3<f32>;
    var outgoing: vec3<f32>;
    var outAlpha: f32;
    var x: f32;
    var d: f32;
    var lum_1: f32;
    var dev: f32;
    var early: f32;
    var tinted: vec3<f32>;
    var param_2: vec3<f32>;
    var param_3: f32;
    var tone: vec3<f32>;
    var incoming: vec3<f32>;
    var inAlpha: f32;
    var color: vec3<f32>;
    var alpha: f32;

    let _e70 = (*uv_2);
    param = _e70;
    let _e71 = getFromColor((&param));
    a = _e71;
    let _e72 = (*uv_2);
    param_1 = _e72;
    let _e73 = getToColor((&param_1));
    b = _e73;
    let _e75 = uniforms.progress;
    p = _e75;
    let _e76 = p;
    if (_e76 <= 0f) {
        let _e78 = a;
        return _e78;
    }
    let _e79 = p;
    if (_e79 >= 1f) {
        let _e81 = b;
        return _e81;
    }
    let _e83 = uniforms.wash;
    split = mix(0.1f, 0.7f, clamp(_e83, 0f, 1f));
    let _e88 = uniforms.card[3u];
    let _e90 = a[3u];
    let _e92 = b[3u];
    let _e93 = split;
    let _e95 = split;
    let _e97 = p;
    cardAlpha = (_e88 * mix(_e90, _e92, smoothstep((0.6f * _e93), (_e95 + 0.1f), _e97)));
    let _e102 = uniforms.card;
    let _e104 = cardAlpha;
    cardColor = (_e102.xyz * _e104);
    let _e106 = split;
    let _e107 = p;
    w = smoothstep(0f, _e106, _e107);
    let _e109 = a;
    fromLum = dot(_e109.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e112 = w;
    let _e113 = fromLum;
    wl = clamp((_e112 * (1f + (0.5f * _e113))), 0f, 1f);
    let _e118 = a;
    let _e120 = fromLum;
    let _e122 = a;
    let _e126 = w;
    let _e130 = a[3u];
    washed = (mix(_e118.xyz, mix(vec3(_e120), _e122.xyz, vec3(0.4f)), vec3(_e126)) * _e130);
    let _e132 = washed;
    let _e133 = cardColor;
    let _e134 = wl;
    outgoing = mix(_e132, _e133, vec3(_e134));
    let _e138 = a[3u];
    let _e139 = cardAlpha;
    let _e140 = wl;
    outAlpha = mix(_e138, _e139, _e140);
    let _e142 = p;
    let _e143 = split;
    let _e145 = split;
    x = clamp(((_e142 - _e143) / max((1f - _e145), 0.001f)), 0f, 1f);
    let _e150 = x;
    d = (1f - pow((1f - _e150), 1.5f));
    let _e154 = b;
    lum_1 = dot(_e154.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e157 = d;
    let _e158 = lum_1;
    dev = clamp(((_e157 - (0.45f * _e158)) / 0.55f), 0f, 1f);
    let _e163 = dev;
    let _e164 = dev;
    let _e166 = dev;
    dev = ((_e163 * _e164) * (3f - (2f * _e166)));
    let _e170 = d;
    early = (1f - smoothstep(0.2f, 0.95f, _e170));
    let _e173 = d;
    let _e175 = b;
    param_2 = _e175.xyz;
    param_3 = smoothstep(0.3f, 1f, _e173);
    let _e177 = saturation((&param_2), (&param_3));
    tinted = _e177;
    let _e178 = tinted;
    let _e179 = d;
    tinted = mix(vec3<f32>(0.6f, 0.6f, 0.6f), _e178, vec3(mix(0.55f, 1f, _e179)));
    let _e183 = lum_1;
    tone = mix(vec3<f32>(-0.2f, 0.06f, 0.1f), vec3<f32>(0.12f, -0.1f, 0.06f), vec3(smoothstep(0.15f, 0.6f, _e183)));
    let _e187 = tone;
    let _e189 = uniforms.tint;
    let _e191 = early;
    let _e193 = tinted;
    tinted = (_e193 + ((_e187 * _e189) * _e191));
    let _e195 = cardColor;
    let _e196 = tinted;
    let _e201 = b[3u];
    let _e203 = dev;
    incoming = mix(_e195, (clamp(_e196, vec3(0f), vec3(1f)) * _e201), vec3(_e203));
    let _e206 = cardAlpha;
    let _e208 = b[3u];
    let _e209 = dev;
    inAlpha = mix(_e206, _e208, _e209);
    let _e211 = p;
    let _e212 = split;
    let _e214 = outgoing;
    let _e215 = incoming;
    color = select(_e215, _e214, vec3((_e211 < _e212)));
    let _e218 = p;
    let _e219 = split;
    let _e221 = outAlpha;
    let _e222 = inAlpha;
    alpha = select(_e222, _e221, (_e218 < _e219));
    let _e224 = alpha;
    if (_e224 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e226 = color;
    let _e227 = alpha;
    let _e232 = clamp((_e226 / vec3(_e227)), vec3(0f), vec3(1f));
    let _e233 = alpha;
    return vec4<f32>(_e232.x, _e232.y, _e232.z, _e233);
}

fn main_1() {
    var param_4: vec2<f32>;

    let _e43 = _uv_1;
    param_4 = _e43;
    let _e44 = transition((&param_4));
    _fragColor = _e44;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
