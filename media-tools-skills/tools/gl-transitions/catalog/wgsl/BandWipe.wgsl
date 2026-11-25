// BandWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BandWipe.glsl
// Author: gre
// License: MIT
// Description: Alternating bands wipe in from opposite sides together and interleave like fingers, while both images stay still
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    bands: i32,
    vertical: i32,
    smoothness: f32,
    stagger: f32,
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

fn bandMask(i: ptr<function, f32>, n: ptr<function, f32>, a: ptr<function, f32>, l: ptr<function, f32>, s: ptr<function, f32>) -> f32 {
    var k: f32;
    var local: f32;
    var g: f32;
    var t: f32;
    var x: f32;
    var local_1: f32;
    var c: f32;

    let _e36 = uniforms.vertical;
    if (_e36 != 0i) {
        let _e38 = (*i);
        local = _e38;
    } else {
        let _e39 = (*n);
        let _e41 = (*i);
        local = ((_e39 - 1f) - _e41);
    }
    let _e43 = local;
    k = _e43;
    let _e45 = uniforms.stagger;
    g = clamp(_e45, 0f, 0.95f);
    let _e48 = uniforms.progress;
    let _e49 = g;
    let _e50 = k;
    let _e52 = (*n);
    let _e57 = g;
    t = clamp(((_e48 - ((_e49 * _e50) / max((_e52 - 1f), 1f))) / (1f - _e57)), 0f, 1f);
    let _e61 = t;
    let _e62 = t;
    let _e63 = t;
    let _e65 = t;
    t = mix(_e61, ((_e62 * _e63) * (3f - (2f * _e65))), 0.5f);
    let _e70 = (*i);
    if ((_e70 - (floor((_e70 / 2f)) * 2f)) > 0.5f) {
        let _e76 = (*l);
        let _e77 = (*a);
        local_1 = (_e76 - _e77);
    } else {
        let _e79 = (*a);
        local_1 = _e79;
    }
    let _e80 = local_1;
    x = _e80;
    let _e81 = (*s);
    let _e83 = (*l);
    let _e84 = (*s);
    let _e86 = t;
    c = mix(-(_e81), (_e83 + _e84), _e86);
    let _e88 = c;
    let _e89 = (*s);
    let _e91 = c;
    let _e92 = (*s);
    let _e94 = x;
    return (1f - smoothstep((_e88 - _e89), (_e91 + _e92), _e94));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e25 = (*uv)[0u];
    let _e27 = (*uv)[1u];
    let _e30 = textureSampleLevel(_to, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e25 = (*uv_1)[0u];
    let _e27 = (*uv_1)[1u];
    let _e30 = textureSampleLevel(_from, _sampler, vec2<f32>(_e25, (1f - _e27)), 0f);
    return _e30;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var n_1: f32;
    var local_2: i32;
    var along: f32;
    var local_3: f32;
    var across: f32;
    var local_4: f32;
    var l_1: f32;
    var local_5: f32;
    var aaAcross: f32;
    var local_6: f32;
    var s_1: f32;
    var f: f32;
    var i_1: f32;
    var m: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var fr: f32;
    var edge: f32;
    var j: f32;
    var local_7: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var a_1: vec4<f32>;
    var param_14: vec2<f32>;
    var b: vec4<f32>;
    var param_15: vec2<f32>;
    var c_1: vec4<f32>;
    var local_8: vec4<f32>;

    let _e63 = uniforms.progress;
    if (_e63 <= 0f) {
        let _e65 = (*uv_2);
        param = _e65;
        let _e66 = getFromColor((&param));
        return _e66;
    }
    let _e68 = uniforms.progress;
    if (_e68 >= 1f) {
        let _e70 = (*uv_2);
        param_1 = _e70;
        let _e71 = getToColor((&param_1));
        return _e71;
    }
    let _e73 = uniforms.bands;
    if (_e73 < 1i) {
        local_2 = 1i;
    } else {
        let _e76 = uniforms.bands;
        local_2 = _e76;
    }
    let _e77 = local_2;
    n_1 = f32(_e77);
    let _e80 = uniforms.vertical;
    if (_e80 != 0i) {
        let _e83 = (*uv_2)[1u];
        local_3 = _e83;
    } else {
        let _e85 = (*uv_2)[0u];
        let _e87 = uniforms.ratio;
        local_3 = (_e85 * _e87);
    }
    let _e89 = local_3;
    along = _e89;
    let _e91 = uniforms.vertical;
    if (_e91 != 0i) {
        let _e94 = (*uv_2)[0u];
        local_4 = _e94;
    } else {
        let _e96 = (*uv_2)[1u];
        local_4 = _e96;
    }
    let _e97 = local_4;
    across = _e97;
    let _e99 = uniforms.vertical;
    if (_e99 != 0i) {
        local_5 = 1f;
    } else {
        let _e102 = uniforms.ratio;
        local_5 = _e102;
    }
    let _e103 = local_5;
    l_1 = _e103;
    let _e105 = uniforms.vertical;
    if (_e105 != 0i) {
        let _e108 = uniforms.ratio;
        local_6 = (0.0015f / _e108);
    } else {
        local_6 = 0.0015f;
    }
    let _e110 = local_6;
    aaAcross = _e110;
    let _e112 = uniforms.smoothness;
    s_1 = max(_e112, 0.0015f);
    let _e114 = across;
    let _e115 = n_1;
    f = (_e114 * _e115);
    let _e117 = f;
    let _e119 = n_1;
    i_1 = clamp(floor(_e117), 0f, (_e119 - 1f));
    let _e122 = i_1;
    param_2 = _e122;
    let _e123 = n_1;
    param_3 = _e123;
    let _e124 = along;
    param_4 = _e124;
    let _e125 = l_1;
    param_5 = _e125;
    let _e126 = s_1;
    param_6 = _e126;
    let _e127 = bandMask((&param_2), (&param_3), (&param_4), (&param_5), (&param_6));
    m = _e127;
    let _e128 = f;
    let _e129 = i_1;
    fr = (_e128 - _e129);
    let _e131 = fr;
    let _e132 = fr;
    let _e135 = n_1;
    edge = (min(_e131, (1f - _e132)) / _e135);
    let _e137 = edge;
    let _e138 = aaAcross;
    if (_e137 < _e138) {
        let _e140 = fr;
        if (_e140 < 0.5f) {
            let _e142 = i_1;
            local_7 = (_e142 - 1f);
        } else {
            let _e144 = i_1;
            local_7 = (_e144 + 1f);
        }
        let _e146 = local_7;
        let _e147 = n_1;
        j = clamp(_e146, 0f, (_e147 - 1f));
        let _e150 = j;
        param_7 = _e150;
        let _e151 = n_1;
        param_8 = _e151;
        let _e152 = along;
        param_9 = _e152;
        let _e153 = l_1;
        param_10 = _e153;
        let _e154 = s_1;
        param_11 = _e154;
        let _e155 = bandMask((&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
        let _e156 = m;
        let _e157 = aaAcross;
        let _e158 = edge;
        m = mix(_e155, _e156, (0.5f + (0.5f * smoothstep(0f, _e157, _e158))));
    }
    let _e163 = m;
    if (_e163 <= 0f) {
        let _e165 = (*uv_2);
        param_12 = _e165;
        let _e166 = getFromColor((&param_12));
        return _e166;
    }
    let _e167 = m;
    if (_e167 >= 1f) {
        let _e169 = (*uv_2);
        param_13 = _e169;
        let _e170 = getToColor((&param_13));
        return _e170;
    }
    let _e171 = (*uv_2);
    param_14 = _e171;
    let _e172 = getFromColor((&param_14));
    a_1 = _e172;
    let _e173 = (*uv_2);
    param_15 = _e173;
    let _e174 = getToColor((&param_15));
    b = _e174;
    let _e175 = a_1;
    let _e178 = a_1[3u];
    let _e179 = (_e175.xyz * _e178);
    let _e181 = a_1[3u];
    let _e186 = b;
    let _e189 = b[3u];
    let _e190 = (_e186.xyz * _e189);
    let _e192 = b[3u];
    let _e197 = m;
    c_1 = mix(vec4<f32>(_e179.x, _e179.y, _e179.z, _e181), vec4<f32>(_e190.x, _e190.y, _e190.z, _e192), vec4(_e197));
    let _e201 = c_1[3u];
    if (_e201 > 0f) {
        let _e203 = c_1;
        let _e206 = c_1[3u];
        let _e208 = (_e203.xyz / vec3(_e206));
        let _e210 = c_1[3u];
        local_8 = vec4<f32>(_e208.x, _e208.y, _e208.z, _e210);
    } else {
        local_8 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e215 = local_8;
    return _e215;
}

fn main_1() {
    var param_16: vec2<f32>;

    let _e24 = _uv_1;
    param_16 = _e24;
    let _e25 = transition((&param_16));
    _fragColor = _e25;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
