// WaterDrop — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WaterDrop.glsl
// Author: Paweł Płóciennik
// License: MIT
// Description: A drop falls into the image like into still water: round ripples spread out from where it hits, bending the image with glints on their slopes, the incoming image shows up inside the leading ripple, and the water calms down
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    amplitude: f32,
    speed: f32,
    center: vec2<f32>,
    refraction: f32,
    highlight: f32,
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

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e39 = (*v);
    let _e40 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e39 - (floor((_e39 / _e40)) * _e40)))));
}

fn wave(s: ptr<function, f32>, k: ptr<function, f32>, lambda: ptr<function, f32>, t: ptr<function, f32>) -> f32 {
    var env: f32;

    let _e43 = (*lambda);
    let _e45 = (*lambda);
    let _e47 = (*s);
    let _e49 = (*s);
    let _e51 = (*lambda);
    env = (smoothstep((-0.3f * _e43), (0.6f * _e45), _e47) * exp((-(_e49) / (3.5f * _e51))));
    let _e56 = env;
    let _e57 = (*k);
    let _e58 = (*s);
    let _e61 = uniforms.speed;
    let _e62 = (*t);
    return (_e56 * sin(((_e57 * _e58) + (_e61 * _e62))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e40 = (*uv)[0u];
    let _e42 = (*uv)[1u];
    let _e45 = textureSampleLevel(_to, _sampler, vec2<f32>(_e40, (1f - _e42)), 0f);
    return _e45;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e40 = (*uv_1)[0u];
    let _e42 = (*uv_1)[1u];
    let _e45 = textureSampleLevel(_from, _sampler, vec2<f32>(_e40, (1f - _e42)), 0f);
    return _e45;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var k_1: f32;
    var lambda_1: f32;
    var q: vec2<f32>;
    var r: f32;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var far: vec2<f32>;
    var R: f32;
    var edge: f32;
    var soft: f32;
    var t_1: f32;
    var e: f32;
    var front: f32;
    var s_1: f32;
    var calm: f32;
    var d: f32;
    var r0_: f32;
    var slope: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var offset: vec2<f32>;
    var ca: vec4<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var cb: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var m: f32;
    var c: vec4<f32>;
    var h: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var lit: f32;
    var glint: f32;
    var local_1: vec4<f32>;

    let _e85 = uniforms.progress;
    if (_e85 <= 0f) {
        let _e87 = (*uv_2);
        param = _e87;
        let _e88 = getFromColor((&param));
        return _e88;
    }
    let _e90 = uniforms.progress;
    if (_e90 >= 1f) {
        let _e92 = (*uv_2);
        param_1 = _e92;
        let _e93 = getToColor((&param_1));
        return _e93;
    }
    let _e95 = uniforms.amplitude;
    k_1 = (2f * max(_e95, 1f));
    let _e98 = k_1;
    lambda_1 = (6.2831855f / _e98);
    let _e100 = (*uv_2);
    let _e102 = uniforms.center;
    let _e105 = uniforms.ratio;
    q = ((_e100 - _e102) * vec2<f32>(_e105, 1f));
    let _e108 = q;
    r = length(_e108);
    let _e110 = r;
    if (_e110 > 0f) {
        let _e112 = q;
        let _e113 = r;
        local = (_e112 / vec2(_e113));
    } else {
        local = vec2<f32>(0f, 0f);
    }
    let _e116 = local;
    dir = _e116;
    let _e118 = uniforms.center;
    let _e120 = uniforms.center;
    let _e125 = uniforms.ratio;
    far = (max(_e118, (vec2(1f) - _e120)) * vec2<f32>(_e125, 1f));
    let _e128 = far;
    R = length(_e128);
    let _e130 = lambda_1;
    edge = (0.35f * _e130);
    let _e132 = lambda_1;
    soft = (0.1f * _e132);
    let _e135 = uniforms.progress;
    t_1 = _e135;
    let _e136 = t_1;
    let _e137 = t_1;
    let _e139 = t_1;
    e = mix(_e136, (1f - ((1f - _e137) * (1f - _e139))), 0.4f);
    let _e144 = lambda_1;
    let _e146 = R;
    let _e147 = edge;
    let _e149 = soft;
    let _e152 = e;
    front = mix((-0.3f * _e144), (((_e146 + _e147) + _e149) + 0.01f), _e152);
    let _e154 = front;
    let _e155 = r;
    s_1 = (_e154 - _e155);
    let _e157 = t_1;
    calm = (1f - smoothstep(0.55f, 1f, _e157));
    let _e160 = calm;
    let _e161 = calm;
    calm = (_e161 * _e160);
    let _e163 = lambda_1;
    d = (0.02f * _e163);
    let _e165 = r;
    let _e166 = d;
    r0_ = max((_e165 - _e166), 0f);
    let _e169 = calm;
    let _e170 = front;
    let _e171 = r;
    let _e173 = d;
    param_2 = ((_e170 - _e171) - _e173);
    let _e175 = k_1;
    param_3 = _e175;
    let _e176 = lambda_1;
    param_4 = _e176;
    let _e177 = t_1;
    param_5 = _e177;
    let _e178 = wave((&param_2), (&param_3), (&param_4), (&param_5));
    let _e179 = front;
    let _e180 = r0_;
    param_6 = (_e179 - _e180);
    let _e182 = k_1;
    param_7 = _e182;
    let _e183 = lambda_1;
    param_8 = _e183;
    let _e184 = t_1;
    param_9 = _e184;
    let _e185 = wave((&param_6), (&param_7), (&param_8), (&param_9));
    let _e188 = r;
    let _e189 = d;
    let _e191 = r0_;
    let _e193 = k_1;
    slope = ((_e169 * (_e178 - _e185)) / (((_e188 + _e189) - _e191) * _e193));
    let _e196 = dir;
    let _e197 = slope;
    let _e200 = uniforms.refraction;
    let _e203 = uniforms.ratio;
    offset = (((_e196 * _e197) * _e200) / vec2<f32>(_e203, 1f));
    let _e206 = (*uv_2);
    let _e207 = offset;
    param_10 = (_e206 - _e207);
    let _e209 = mirror((&param_10));
    param_11 = _e209;
    let _e210 = getFromColor((&param_11));
    ca = _e210;
    let _e211 = (*uv_2);
    let _e212 = offset;
    param_12 = (_e211 - _e212);
    let _e214 = mirror((&param_12));
    param_13 = _e214;
    let _e215 = getToColor((&param_13));
    cb = _e215;
    let _e216 = edge;
    let _e217 = soft;
    let _e219 = edge;
    let _e220 = soft;
    let _e222 = s_1;
    m = smoothstep((_e216 - _e217), (_e219 + _e220), _e222);
    let _e224 = ca;
    let _e227 = ca[3u];
    let _e228 = (_e224.xyz * _e227);
    let _e230 = ca[3u];
    let _e235 = cb;
    let _e238 = cb[3u];
    let _e239 = (_e235.xyz * _e238);
    let _e241 = cb[3u];
    let _e246 = m;
    c = mix(vec4<f32>(_e228.x, _e228.y, _e228.z, _e230), vec4<f32>(_e239.x, _e239.y, _e239.z, _e241), vec4(_e246));
    let _e249 = calm;
    let _e250 = s_1;
    param_14 = _e250;
    let _e251 = k_1;
    param_15 = _e251;
    let _e252 = lambda_1;
    param_16 = _e252;
    let _e253 = t_1;
    param_17 = _e253;
    let _e254 = wave((&param_14), (&param_15), (&param_16), (&param_17));
    h = (_e249 * _e254);
    let _e256 = dir;
    let _e259 = slope;
    lit = (-(dot(_e256, vec2<f32>(-0.6f, 0.8f))) * _e259);
    let _e262 = uniforms.highlight;
    let _e263 = h;
    let _e265 = lit;
    let _e269 = lit;
    glint = (_e262 * (((0.2f * _e263) + (0.6f * smoothstep(0.2f, 0.9f, _e265))) - (0.3f * smoothstep(0.2f, 0.9f, -(_e269)))));
    let _e275 = c;
    let _e277 = glint;
    let _e279 = c[3u];
    let _e284 = c[3u];
    let _e287 = clamp((_e275.xyz + vec3((_e277 * _e279))), vec3(0f), vec3(_e284));
    c[0u] = _e287.x;
    c[1u] = _e287.y;
    c[2u] = _e287.z;
    let _e295 = c[3u];
    if (_e295 > 0f) {
        let _e297 = c;
        let _e300 = c[3u];
        let _e302 = (_e297.xyz / vec3(_e300));
        let _e304 = c[3u];
        local_1 = vec4<f32>(_e302.x, _e302.y, _e302.z, _e304);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e309 = local_1;
    return _e309;
}

fn main_1() {
    var param_18: vec2<f32>;

    let _e39 = _uv_1;
    param_18 = _e39;
    let _e40 = transition((&param_18));
    _fragColor = _e40;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
