// SawtoothWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SawtoothWipe.glsl
// Author: gre
// License: MIT
// Description: A wipe whose edge is a row of sharp, regular triangular teeth sweeps across the frame, or two toothed edges that start interlocked part from the middle like jaws opening
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    teeth: i32,
    depth: f32,
    jaws: i32,
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

fn zigzag(q: ptr<function, vec2<f32>>, w: ptr<function, f32>, h: ptr<function, f32>) -> f32 {
    var x: f32;
    var a: vec2<f32>;
    var ab: vec2<f32>;
    var aq: vec2<f32>;
    var d: f32;
    var local: f32;

    let _e38 = (*q)[0u];
    let _e39 = (*w);
    let _e44 = (*w);
    x = (abs((fract((_e38 / _e39)) - 0.5f)) * _e44);
    let _e46 = (*h);
    a = vec2<f32>(0f, (-0.5f * _e46));
    let _e49 = (*w);
    let _e51 = (*h);
    ab = vec2<f32>((0.5f * _e49), _e51);
    let _e53 = x;
    let _e55 = (*q)[1u];
    let _e57 = a;
    aq = (vec2<f32>(_e53, _e55) - _e57);
    let _e59 = aq;
    let _e60 = ab;
    let _e61 = aq;
    let _e62 = ab;
    let _e64 = ab;
    let _e65 = ab;
    d = length((_e59 - (_e60 * clamp((dot(_e61, _e62) / dot(_e64, _e65)), 0f, 1f))));
    let _e73 = (*q)[1u];
    let _e74 = (*h);
    let _e75 = x;
    let _e77 = (*w);
    if (_e73 > (_e74 * (((2f * _e75) / _e77) - 0.5f))) {
        let _e82 = d;
        local = _e82;
    } else {
        let _e83 = d;
        local = -(_e83);
    }
    let _e85 = local;
    return _e85;
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e30 = (*uv)[0u];
    let _e32 = (*uv)[1u];
    let _e35 = textureSampleLevel(_to, _sampler, vec2<f32>(_e30, (1f - _e32)), 0f);
    return _e35;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e30 = (*uv_1)[0u];
    let _e32 = (*uv_1)[1u];
    let _e35 = textureSampleLevel(_from, _sampler, vec2<f32>(_e30, (1f - _e32)), 0f);
    return _e35;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a_1: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var dir: vec2<f32>;
    var local_1: vec2<f32>;
    var p: vec2<f32>;
    var e: f32;
    var w_1: f32;
    var period: f32;
    var local_2: i32;
    var q_1: vec2<f32>;
    var h_1: f32;
    var s: f32;
    var t: f32;
    var overlap: f32;
    var o: f32;
    var d_1: f32;
    var param_2: vec2<f32>;
    var param_3: f32;
    var param_4: f32;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: f32;
    var c: f32;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var m: f32;
    var c_1: vec4<f32>;
    var local_3: vec4<f32>;

    let _e60 = (*uv_2);
    param = _e60;
    let _e61 = getFromColor((&param));
    a_1 = _e61;
    let _e62 = (*uv_2);
    param_1 = _e62;
    let _e63 = getToColor((&param_1));
    b = _e63;
    let _e65 = uniforms.progress;
    if (_e65 <= 0f) {
        let _e67 = a_1;
        return _e67;
    }
    let _e69 = uniforms.progress;
    if (_e69 >= 1f) {
        let _e71 = b;
        return _e71;
    }
    let _e73 = uniforms.direction;
    if (length(_e73) > 0f) {
        let _e77 = uniforms.direction;
        local_1 = normalize(_e77);
    } else {
        local_1 = vec2<f32>(1f, 0f);
    }
    let _e79 = local_1;
    dir = _e79;
    let _e80 = (*uv_2);
    let _e84 = uniforms.ratio;
    p = ((_e80 - vec2(0.5f)) * vec2<f32>(_e84, 1f));
    let _e88 = dir[0u];
    let _e91 = uniforms.ratio;
    let _e94 = dir[1u];
    e = (0.5f * ((abs(_e88) * _e91) + abs(_e94)));
    let _e99 = dir[1u];
    let _e102 = uniforms.ratio;
    let _e105 = dir[0u];
    w_1 = (0.5f * ((abs(_e99) * _e102) + abs(_e105)));
    let _e109 = w_1;
    let _e112 = uniforms.teeth;
    if (_e112 < 1i) {
        local_2 = 1i;
    } else {
        let _e115 = uniforms.teeth;
        local_2 = _e115;
    }
    let _e116 = local_2;
    period = ((2f * _e109) / f32(_e116));
    let _e119 = p;
    let _e121 = dir[1u];
    let _e124 = dir[0u];
    let _e127 = w_1;
    let _e129 = period;
    let _e132 = p;
    let _e133 = dir;
    q_1 = vec2<f32>(((dot(_e119, vec2<f32>(-(_e121), _e124)) + _e127) + (0.5f * _e129)), dot(_e132, _e133));
    let _e137 = uniforms.depth;
    let _e139 = period;
    h_1 = (max(_e137, 0f) * _e139);
    let _e142 = uniforms.smoothness;
    let _e143 = period;
    s = max(min(_e142, (0.25f * _e143)), 0.0015f);
    let _e148 = uniforms.progress;
    let _e150 = uniforms.progress;
    let _e152 = uniforms.progress;
    let _e155 = uniforms.progress;
    t = mix(_e148, ((_e150 * _e152) * (3f - (2f * _e155))), 0.35f);
    let _e161 = uniforms.jaws;
    if (_e161 != 0i) {
        let _e163 = s;
        let _e164 = h_1;
        let _e166 = h_1;
        let _e168 = period;
        let _e169 = period;
        overlap = (_e163 * sqrt((1f + (((4f * _e164) * _e166) / (_e168 * _e169)))));
        let _e175 = overlap;
        let _e177 = e;
        let _e178 = h_1;
        let _e181 = s;
        let _e183 = t;
        o = mix(-(_e175), ((_e177 + (0.5f * _e178)) + _e181), _e183);
        let _e185 = q_1;
        let _e186 = o;
        param_2 = (_e185 - vec2<f32>(0f, _e186));
        let _e189 = period;
        param_3 = _e189;
        let _e190 = h_1;
        param_4 = _e190;
        let _e191 = zigzag((&param_2), (&param_3), (&param_4));
        let _e192 = q_1;
        let _e193 = o;
        param_5 = (_e192 + vec2<f32>(0f, _e193));
        let _e196 = period;
        param_6 = _e196;
        let _e197 = h_1;
        param_7 = _e197;
        let _e198 = zigzag((&param_5), (&param_6), (&param_7));
        d_1 = max(_e191, -(_e198));
    } else {
        let _e201 = e;
        let _e203 = h_1;
        let _e206 = s;
        let _e208 = e;
        let _e209 = h_1;
        let _e212 = s;
        let _e214 = t;
        c = mix(((-(_e201) - (0.5f * _e203)) - _e206), ((_e208 + (0.5f * _e209)) + _e212), _e214);
        let _e216 = q_1;
        let _e217 = c;
        param_8 = (_e216 - vec2<f32>(0f, _e217));
        let _e220 = period;
        param_9 = _e220;
        let _e221 = h_1;
        param_10 = _e221;
        let _e222 = zigzag((&param_8), (&param_9), (&param_10));
        d_1 = _e222;
    }
    let _e223 = s;
    let _e225 = s;
    let _e226 = d_1;
    m = (1f - smoothstep(-(_e223), _e225, _e226));
    let _e229 = a_1;
    let _e232 = a_1[3u];
    let _e233 = (_e229.xyz * _e232);
    let _e235 = a_1[3u];
    let _e240 = b;
    let _e243 = b[3u];
    let _e244 = (_e240.xyz * _e243);
    let _e246 = b[3u];
    let _e251 = m;
    c_1 = mix(vec4<f32>(_e233.x, _e233.y, _e233.z, _e235), vec4<f32>(_e244.x, _e244.y, _e244.z, _e246), vec4(_e251));
    let _e255 = c_1[3u];
    if (_e255 > 0f) {
        let _e257 = c_1;
        let _e260 = c_1[3u];
        let _e262 = (_e257.xyz / vec3(_e260));
        let _e264 = c_1[3u];
        local_3 = vec4<f32>(_e262.x, _e262.y, _e262.z, _e264);
    } else {
        local_3 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e269 = local_3;
    return _e269;
}

fn main_1() {
    var param_11: vec2<f32>;

    let _e29 = _uv_1;
    param_11 = _e29;
    let _e30 = transition((&param_11));
    _fragColor = _e30;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
