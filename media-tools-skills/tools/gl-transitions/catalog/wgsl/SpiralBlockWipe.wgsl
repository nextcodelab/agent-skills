// SpiralBlockWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SpiralBlockWipe.glsl
// Author: gre
// License: MIT
// Description: Square blocks switch to the incoming image one after another along a rectangular spiral, from the border inward or from the center outward
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    grid: vec2<i32>,
    inward: i32,
    clockwise: i32,
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

fn spiralIndex(c: ptr<function, vec2<f32>>, n: ptr<function, vec2<f32>>) -> f32 {
    var k: f32;
    var s: vec2<f32>;
    var l: vec2<f32>;
    var before: f32;
    var along: f32;

    let _e29 = (*c)[0u];
    let _e31 = (*c)[1u];
    let _e34 = (*n)[0u];
    let _e37 = (*c)[0u];
    let _e40 = (*n)[1u];
    let _e43 = (*c)[1u];
    k = min(min(_e29, _e31), min(((_e34 - 1f) - _e37), ((_e40 - 1f) - _e43)));
    let _e47 = (*n);
    let _e48 = k;
    s = (_e47 - vec2((2f * _e48)));
    let _e52 = (*c);
    let _e53 = k;
    l = (_e52 - vec2(_e53));
    let _e57 = (*n)[0u];
    let _e59 = (*n)[1u];
    let _e62 = s[0u];
    let _e64 = s[1u];
    before = ((_e57 * _e59) - (_e62 * _e64));
    let _e68 = l[1u];
    if (_e68 == 0f) {
        let _e71 = l[0u];
        along = _e71;
    } else {
        let _e73 = l[0u];
        let _e75 = s[0u];
        if (_e73 == (_e75 - 1f)) {
            let _e79 = s[0u];
            let _e82 = l[1u];
            along = ((_e79 - 1f) + _e82);
        } else {
            let _e85 = l[1u];
            let _e87 = s[1u];
            if (_e85 == (_e87 - 1f)) {
                let _e91 = s[0u];
                let _e94 = s[1u];
                let _e98 = l[0u];
                along = ((((2f * _e91) + _e94) - 3f) - _e98);
            } else {
                let _e101 = s[0u];
                let _e105 = s[1u];
                let _e110 = l[1u];
                along = (((2f * (_e101 - 1f)) + (2f * (_e105 - 1f))) - _e110);
            }
        }
    }
    let _e112 = before;
    let _e113 = along;
    return (_e112 + _e113);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e23 = (*uv)[0u];
    let _e25 = (*uv)[1u];
    let _e28 = textureSampleLevel(_to, _sampler, vec2<f32>(_e23, (1f - _e25)), 0f);
    return _e28;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e23 = (*uv_1)[0u];
    let _e25 = (*uv_1)[1u];
    let _e28 = textureSampleLevel(_from, _sampler, vec2<f32>(_e23, (1f - _e25)), 0f);
    return _e28;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var n_1: vec2<f32>;
    var c_1: vec2<f32>;
    var count: f32;
    var i: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var w: f32;
    var o: f32;
    var x: f32;
    var m: f32;
    var local: f32;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var a: vec4<f32>;
    var param_6: vec2<f32>;
    var b: vec4<f32>;
    var param_7: vec2<f32>;
    var col: vec4<f32>;
    var local_1: vec4<f32>;

    let _e44 = uniforms.progress;
    if (_e44 <= 0f) {
        let _e46 = (*uv_2);
        param = _e46;
        let _e47 = getFromColor((&param));
        return _e47;
    }
    let _e49 = uniforms.progress;
    if (_e49 >= 1f) {
        let _e51 = (*uv_2);
        param_1 = _e51;
        let _e52 = getToColor((&param_1));
        return _e52;
    }
    let _e54 = uniforms.grid;
    n_1 = max(vec2<f32>(_e54), vec2<f32>(1f, 1f));
    let _e58 = (*uv_2)[0u];
    let _e60 = (*uv_2)[1u];
    let _e63 = n_1;
    let _e66 = n_1;
    c_1 = min(floor((vec2<f32>(_e58, (1f - _e60)) * _e63)), (_e66 - vec2(1f)));
    let _e71 = uniforms.clockwise;
    let _e74 = uniforms.inward;
    if ((_e71 != 0i) != (_e74 != 0i)) {
        let _e77 = c_1;
        c_1 = _e77.yx;
        let _e79 = n_1;
        n_1 = _e79.yx;
    }
    let _e82 = n_1[0u];
    let _e84 = n_1[1u];
    count = (_e82 * _e84);
    let _e86 = c_1;
    param_2 = _e86;
    let _e87 = n_1;
    param_3 = _e87;
    let _e88 = spiralIndex((&param_2), (&param_3));
    i = _e88;
    let _e90 = uniforms.inward;
    if !((_e90 != 0i)) {
        let _e93 = count;
        let _e95 = i;
        i = ((_e93 - 1f) - _e95);
    }
    let _e98 = uniforms.smoothness;
    let _e100 = count;
    w = (max(_e98, 0f) * _e100);
    let _e102 = w;
    o = max((0.5f * (1f - _e102)), 0f);
    let _e107 = uniforms.progress;
    let _e108 = count;
    let _e110 = o;
    let _e113 = w;
    let _e116 = i;
    let _e118 = o;
    x = (((_e107 * (((_e108 - 1f) + (2f * _e110)) + _e113)) - _e116) - _e118);
    let _e120 = w;
    if (_e120 > 0f) {
        let _e122 = w;
        let _e123 = x;
        local = smoothstep(0f, _e122, _e123);
    } else {
        let _e125 = x;
        local = step(0f, _e125);
    }
    let _e127 = local;
    m = _e127;
    let _e128 = m;
    if (_e128 <= 0f) {
        let _e130 = (*uv_2);
        param_4 = _e130;
        let _e131 = getFromColor((&param_4));
        return _e131;
    }
    let _e132 = m;
    if (_e132 >= 1f) {
        let _e134 = (*uv_2);
        param_5 = _e134;
        let _e135 = getToColor((&param_5));
        return _e135;
    }
    let _e136 = (*uv_2);
    param_6 = _e136;
    let _e137 = getFromColor((&param_6));
    a = _e137;
    let _e138 = (*uv_2);
    param_7 = _e138;
    let _e139 = getToColor((&param_7));
    b = _e139;
    let _e140 = a;
    let _e143 = a[3u];
    let _e144 = (_e140.xyz * _e143);
    let _e146 = a[3u];
    let _e151 = b;
    let _e154 = b[3u];
    let _e155 = (_e151.xyz * _e154);
    let _e157 = b[3u];
    let _e162 = m;
    col = mix(vec4<f32>(_e144.x, _e144.y, _e144.z, _e146), vec4<f32>(_e155.x, _e155.y, _e155.z, _e157), vec4(_e162));
    let _e166 = col[3u];
    if (_e166 > 0f) {
        let _e168 = col;
        let _e171 = col[3u];
        let _e173 = (_e168.xyz / vec3(_e171));
        let _e175 = col[3u];
        local_1 = vec4<f32>(_e173.x, _e173.y, _e173.z, _e175);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e180 = local_1;
    return _e180;
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e22 = _uv_1;
    param_8 = _e22;
    let _e23 = transition((&param_8));
    _fragColor = _e23;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
