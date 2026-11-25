// MoireWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/MoireWipe.glsl
// Author: gre
// License: MIT
// Description: Two sets of fine concentric rings, centered on two points that drift toward each other, overlay the image and interfere into a shifting moire of wide bands; the bands open onto the incoming image and widen until it fills the frame, while the thin dark and light ring lines fade away
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    density: f32,
    bands: f32,
    drift: f32,
    lines: f32,
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

fn ringLines(r: ptr<function, f32>, f: ptr<function, f32>) -> f32 {
    var q: f32;
    var aa: f32;
    var c: f32;

    let _e41 = (*r);
    let _e42 = (*f);
    q = abs((fract(((_e41 * _e42) + 0.5f)) - 0.5f));
    let _e48 = (*f);
    aa = (0.0012f * _e48);
    let _e50 = q;
    let _e52 = aa;
    c = clamp((((0.1f - _e50) / (2f * _e52)) + 0.5f), 0f, 1f);
    let _e57 = c;
    let _e58 = aa;
    return mix(_e57, 0.2f, clamp(((10f * _e58) - 0.5f), 0f, 1f));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e38 = (*uv)[0u];
    let _e40 = (*uv)[1u];
    let _e43 = textureSampleLevel(_to, _sampler, vec2<f32>(_e38, (1f - _e40)), 0f);
    return _e43;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e38 = (*uv_1)[0u];
    let _e40 = (*uv_1)[1u];
    let _e43 = textureSampleLevel(_from, _sampler, vec2<f32>(_e38, (1f - _e40)), 0f);
    return _e43;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var t: f32;
    var f_1: f32;
    var p: vec2<f32>;
    var ang: f32;
    var k: f32;
    var axis: vec2<f32>;
    var r1_: f32;
    var r2_: f32;
    var f2_: f32;
    var beat: f32;
    var grad: vec2<f32>;
    var s: f32;
    var w: f32;
    var m: f32;
    var c_1: vec4<f32>;
    var o: f32;
    var l: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var local: vec4<f32>;

    let _e63 = (*uv_2);
    param = _e63;
    let _e64 = getFromColor((&param));
    a = _e64;
    let _e65 = (*uv_2);
    param_1 = _e65;
    let _e66 = getToColor((&param_1));
    b = _e66;
    let _e68 = uniforms.progress;
    if (_e68 <= 0f) {
        let _e70 = a;
        return _e70;
    }
    let _e72 = uniforms.progress;
    if (_e72 >= 1f) {
        let _e74 = b;
        return _e74;
    }
    let _e76 = uniforms.progress;
    let _e78 = uniforms.progress;
    let _e81 = uniforms.progress;
    t = ((_e76 * _e78) * (3f - (2f * _e81)));
    let _e86 = uniforms.density;
    f_1 = max(_e86, 1f);
    let _e88 = (*uv_2);
    let _e92 = uniforms.ratio;
    p = ((_e88 - vec2(0.5f)) * vec2<f32>(_e92, 1f));
    let _e96 = uniforms.drift;
    let _e98 = t;
    ang = (((6.2831855f * _e96) * _e98) + 0.35f);
    let _e102 = uniforms.bands;
    let _e104 = t;
    k = (max(_e102, 1f) * (1f - (0.75f * _e104)));
    let _e108 = ang;
    let _e110 = ang;
    let _e114 = k;
    let _e116 = f_1;
    axis = (((vec2<f32>(cos(_e108), sin(_e110)) * 0.5f) * _e114) / vec2(_e116));
    let _e119 = p;
    let _e120 = axis;
    r1_ = length((_e119 - _e120));
    let _e123 = p;
    let _e124 = axis;
    r2_ = length((_e123 + _e124));
    let _e127 = f_1;
    let _e128 = k;
    f2_ = (_e127 + (1.2f * _e128));
    let _e131 = f2_;
    let _e132 = r2_;
    let _e134 = f_1;
    let _e135 = r1_;
    beat = abs((fract((((_e131 * _e132) - (_e134 * _e135)) + 0.5f)) - 0.5f));
    let _e142 = f2_;
    let _e143 = p;
    let _e144 = axis;
    let _e147 = r2_;
    let _e151 = f_1;
    let _e152 = p;
    let _e153 = axis;
    let _e156 = r1_;
    grad = ((((_e143 + _e144) * _e142) / vec2(max(_e147, 0.0012f))) - (((_e152 - _e153) * _e151) / vec2(max(_e156, 0.0012f))));
    let _e161 = grad;
    s = min(((0.0012f * length(_e161)) + 0.004f), 0.05f);
    let _e166 = t;
    w = mix(-0.05f, 0.55f, _e166);
    let _e168 = w;
    let _e169 = s;
    let _e171 = w;
    let _e172 = s;
    let _e174 = beat;
    m = (1f - smoothstep((_e168 - _e169), (_e171 + _e172), _e174));
    let _e177 = a;
    let _e180 = a[3u];
    let _e181 = (_e177.xyz * _e180);
    let _e183 = a[3u];
    let _e188 = b;
    let _e191 = b[3u];
    let _e192 = (_e188.xyz * _e191);
    let _e194 = b[3u];
    let _e199 = m;
    c_1 = mix(vec4<f32>(_e181.x, _e181.y, _e181.z, _e183), vec4<f32>(_e192.x, _e192.y, _e192.z, _e194), vec4(_e199));
    let _e203 = uniforms.lines;
    let _e206 = t;
    o = ((0.7f * clamp(_e203, 0f, 1f)) * sin((3.1415927f * _e206)));
    let _e210 = o;
    let _e211 = r1_;
    param_2 = _e211;
    let _e212 = f_1;
    param_3 = _e212;
    let _e213 = ringLines((&param_2), (&param_3));
    let _e216 = o;
    let _e217 = r2_;
    param_4 = _e217;
    let _e218 = f2_;
    param_5 = _e218;
    let _e219 = ringLines((&param_4), (&param_5));
    l = (1f - ((1f - (_e210 * _e213)) * (1f - (_e216 * _e219))));
    let _e224 = c_1;
    let _e227 = c_1[3u];
    let _e228 = m;
    let _e231 = l;
    let _e233 = mix(_e224.xyz, vec3((_e227 * _e228)), vec3(_e231));
    c_1[0u] = _e233.x;
    c_1[1u] = _e233.y;
    c_1[2u] = _e233.z;
    let _e241 = c_1[3u];
    if (_e241 > 0f) {
        let _e243 = c_1;
        let _e246 = c_1[3u];
        let _e248 = (_e243.xyz / vec3(_e246));
        let _e250 = c_1[3u];
        local = vec4<f32>(_e248.x, _e248.y, _e248.z, _e250);
    } else {
        local = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e255 = local;
    return _e255;
}

fn main_1() {
    var param_6: vec2<f32>;

    let _e37 = _uv_1;
    param_6 = _e37;
    let _e38 = transition((&param_6));
    _fragColor = _e38;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
