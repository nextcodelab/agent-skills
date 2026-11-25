// LightRays — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightRays.glsl
// Author: gre
// License: MIT
// Description: Shafts of light burst from the highlights of the outgoing image and stream outward from a slowly drifting center; at their peak the incoming image takes over and its own rays shrink back into its highlights
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    drift: f32,
    reach: f32,
    threshold: f32,
    intensity: f32,
    tint: vec3<f32>,
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

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e57 = (*v);
    v3_ = fract((_e57.xyx * 0.1031f));
    let _e61 = v3_;
    let _e62 = v3_;
    let _e67 = v3_;
    v3_ = (_e67 + vec3(dot(_e61, (_e62.yzx + vec3(33.33f)))));
    let _e71 = v3_[0u];
    let _e73 = v3_[1u];
    let _e76 = v3_[2u];
    return fract(((_e71 + _e73) * _e76));
}

fn shaftNoise(t: ptr<function, f32>, n: ptr<function, f32>, seed: ptr<function, f32>) -> f32 {
    var x: f32;
    var i: f32;
    var f: f32;
    var a: f32;
    var param: vec2<f32>;
    var b: f32;
    var param_1: vec2<f32>;

    let _e65 = (*t);
    let _e66 = (*n);
    x = (_e65 * _e66);
    let _e68 = x;
    i = floor(_e68);
    let _e70 = x;
    let _e71 = i;
    f = (_e70 - _e71);
    let _e73 = i;
    let _e74 = (*n);
    let _e79 = (*seed);
    param = vec2<f32>((_e73 - (floor((_e73 / _e74)) * _e74)), _e79);
    let _e81 = hash12((&param));
    a = _e81;
    let _e82 = i;
    let _e83 = (_e82 + 1f);
    let _e84 = (*n);
    let _e89 = (*seed);
    param_1 = vec2<f32>((_e83 - (floor((_e83 / _e84)) * _e84)), _e89);
    let _e91 = hash12((&param_1));
    b = _e91;
    let _e92 = a;
    let _e93 = b;
    let _e94 = f;
    let _e95 = f;
    let _e97 = f;
    return mix(_e92, _e93, ((_e94 * _e95) * (3f - (2f * _e97))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e57 = (*uv)[0u];
    let _e59 = (*uv)[1u];
    let _e62 = textureSampleLevel(_to, _sampler, vec2<f32>(_e57, (1f - _e59)), 0f);
    return _e62;
}

fn glow(c: ptr<function, vec4<f32>>, knee: ptr<function, f32>) -> vec3<f32> {
    var lum: f32;

    let _e58 = (*c);
    lum = dot(_e58.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e61 = (*c);
    let _e64 = (*c)[3u];
    let _e66 = (*knee);
    let _e67 = (*knee);
    let _e69 = lum;
    return ((_e61.xyz * _e64) * smoothstep(_e66, (_e67 + 0.2f), _e69));
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e57 = (*uv_1)[0u];
    let _e59 = (*uv_1)[1u];
    let _e62 = textureSampleLevel(_from, _sampler, vec2<f32>(_e57, (1f - _e59)), 0f);
    return _e62;
}

fn light(st: ptr<function, vec2<f32>>, knee_1: ptr<function, f32>, m: ptr<function, f32>) -> vec3<f32> {
    var param_2: vec2<f32>;
    var param_3: vec4<f32>;
    var param_4: f32;
    var param_5: vec2<f32>;
    var param_6: vec4<f32>;
    var param_7: f32;
    var param_8: vec2<f32>;
    var param_9: vec4<f32>;
    var param_10: f32;
    var param_11: vec2<f32>;
    var param_12: vec4<f32>;
    var param_13: f32;

    let _e70 = (*m);
    if (_e70 <= 0f) {
        let _e72 = (*st);
        param_2 = _e72;
        let _e73 = getFromColor((&param_2));
        param_3 = _e73;
        let _e74 = (*knee_1);
        param_4 = _e74;
        let _e75 = glow((&param_3), (&param_4));
        return _e75;
    }
    let _e76 = (*m);
    if (_e76 >= 1f) {
        let _e78 = (*st);
        param_5 = _e78;
        let _e79 = getToColor((&param_5));
        param_6 = _e79;
        let _e80 = (*knee_1);
        param_7 = _e80;
        let _e81 = glow((&param_6), (&param_7));
        return _e81;
    }
    let _e82 = (*st);
    param_8 = _e82;
    let _e83 = getFromColor((&param_8));
    param_9 = _e83;
    let _e84 = (*knee_1);
    param_10 = _e84;
    let _e85 = glow((&param_9), (&param_10));
    let _e86 = (*st);
    param_11 = _e86;
    let _e87 = getToColor((&param_11));
    param_12 = _e87;
    let _e88 = (*knee_1);
    param_13 = _e88;
    let _e89 = glow((&param_12), (&param_13));
    let _e90 = (*m);
    return mix(_e85, _e89, vec3(_e90));
}

fn mirror(v_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e56 = (*v_1);
    let _e57 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e56 - (floor((_e56 / _e57)) * _e57)))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var amount: f32;
    var local: f32;
    var peak: f32;
    var m_1: f32;
    var fromColor: vec4<f32>;
    var param_14: vec2<f32>;
    var toColor: vec4<f32>;
    var param_15: vec2<f32>;
    var origin: vec2<f32>;
    var len: f32;
    var knee_2: f32;
    var jitter: f32;
    var param_16: vec2<f32>;
    var rays: vec3<f32>;
    var total: f32;
    var i_1: i32;
    var s: f32;
    var w: f32;
    var hue: vec3<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var param_19: f32;
    var param_20: f32;
    var d: vec2<f32>;
    var turn: f32;
    var local_1: f32;
    var shafts: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;
    var c_1: vec4<f32>;
    var base: vec3<f32>;

    let _e93 = uniforms.progress;
    p = _e93;
    let _e94 = p;
    if (_e94 < 0.5f) {
        let _e96 = p;
        local = smoothstep(0f, 0.5f, _e96);
    } else {
        let _e98 = p;
        local = (1f - smoothstep(0.5f, 1f, _e98));
    }
    let _e101 = local;
    amount = _e101;
    let _e102 = amount;
    let _e103 = amount;
    let _e105 = amount;
    peak = ((_e102 * _e103) * _e105);
    let _e107 = p;
    m_1 = smoothstep(0.46f, 0.54f, _e107);
    let _e109 = (*uv_2);
    param_14 = _e109;
    let _e110 = getFromColor((&param_14));
    fromColor = _e110;
    let _e111 = (*uv_2);
    param_15 = _e111;
    let _e112 = getToColor((&param_15));
    toColor = _e112;
    let _e113 = amount;
    if (_e113 <= 0f) {
        let _e115 = m_1;
        let _e117 = fromColor;
        let _e118 = toColor;
        return select(_e118, _e117, vec4((_e115 < 0.5f)));
    }
    let _e122 = uniforms.center;
    let _e124 = uniforms.drift;
    let _e125 = p;
    origin = (_e122 + vec2<f32>((_e124 * (_e125 - 0.5f)), 0f));
    let _e131 = uniforms.reach;
    let _e132 = amount;
    len = (_e131 * _e132);
    let _e135 = uniforms.threshold;
    let _e137 = uniforms.threshold;
    let _e139 = peak;
    knee_2 = mix(_e135, (0.75f * _e137), _e139);
    let _e141 = (*uv_2);
    let _e143 = uniforms.ratio;
    param_16 = floor(((_e141 * vec2<f32>(_e143, 1f)) * 997f));
    let _e148 = hash12((&param_16));
    jitter = _e148;
    rays = vec3<f32>(0f, 0f, 0f);
    total = 0f;
    i_1 = 0i;
    loop {
        let _e149 = i_1;
        if (_e149 < 20i) {
            let _e151 = i_1;
            let _e153 = jitter;
            s = ((f32(_e151) + _e153) / 20f);
            let _e156 = s;
            w = exp((-2f * _e156));
            let _e160 = uniforms.tint;
            let _e161 = s;
            hue = mix(vec3<f32>(1f, 1f, 1f), _e160, vec3(smoothstep(0f, 0.6f, _e161)));
            let _e165 = w;
            let _e166 = hue;
            let _e168 = (*uv_2);
            let _e169 = origin;
            let _e170 = s;
            let _e171 = len;
            param_17 = mix(_e168, _e169, vec2((_e170 * _e171)));
            let _e175 = mirror((&param_17));
            param_18 = _e175;
            let _e176 = knee_2;
            param_19 = _e176;
            let _e177 = m_1;
            param_20 = _e177;
            let _e178 = light((&param_18), (&param_19), (&param_20));
            let _e180 = rays;
            rays = (_e180 + ((_e166 * _e165) * _e178));
            let _e182 = w;
            let _e183 = total;
            total = (_e183 + _e182);
            continue;
        } else {
            break;
        }
        continuing {
            let _e185 = i_1;
            i_1 = (_e185 + 1i);
        }
    }
    let _e187 = (*uv_2);
    let _e188 = origin;
    let _e191 = uniforms.ratio;
    d = ((_e187 - _e188) * vec2<f32>(_e191, 1f));
    let _e194 = d;
    if (length(_e194) > 0.000001f) {
        let _e198 = d[1u];
        let _e200 = d[0u];
        local_1 = ((atan2(_e198, _e200) / 6.2831855f) + 0.5f);
    } else {
        local_1 = 0f;
    }
    let _e204 = local_1;
    turn = _e204;
    let _e205 = turn;
    let _e206 = p;
    param_21 = fract((_e205 + (0.03f * _e206)));
    param_22 = 23f;
    param_23 = 1f;
    let _e210 = shaftNoise((&param_21), (&param_22), (&param_23));
    let _e212 = turn;
    let _e213 = p;
    param_24 = fract((_e212 - (0.05f * _e213)));
    param_25 = 47f;
    param_26 = 7f;
    let _e217 = shaftNoise((&param_24), (&param_25), (&param_26));
    shafts = ((0.6f * _e210) + (0.4f * _e217));
    let _e220 = shafts;
    let _e223 = d;
    let _e227 = rays;
    rays = (_e227 * mix(1f, mix(0.2f, 1.6f, smoothstep(0.15f, 0.85f, _e220)), smoothstep(0f, 0.3f, length(_e223))));
    let _e230 = uniforms.intensity;
    let _e231 = amount;
    let _e233 = peak;
    let _e237 = total;
    let _e239 = rays;
    rays = (_e239 * (((_e230 * _e231) * (1f + (3f * _e233))) / _e237));
    let _e241 = rays;
    rays = ((vec3(1f) - exp(-(_e241))) * 0.9f);
    let _e247 = fromColor;
    let _e250 = fromColor[3u];
    let _e251 = (_e247.xyz * _e250);
    let _e253 = fromColor[3u];
    let _e258 = toColor;
    let _e261 = toColor[3u];
    let _e262 = (_e258.xyz * _e261);
    let _e264 = toColor[3u];
    let _e269 = m_1;
    c_1 = mix(vec4<f32>(_e251.x, _e251.y, _e251.z, _e253), vec4<f32>(_e262.x, _e262.y, _e262.z, _e264), vec4(_e269));
    let _e273 = c_1[3u];
    if (_e273 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e275 = c_1;
    let _e278 = c_1[3u];
    let _e281 = peak;
    base = min(((_e275.xyz / vec3(_e278)) * (1f + (0.2f * _e281))), vec3(1f));
    let _e287 = base;
    let _e288 = rays;
    let _e290 = base;
    let _e291 = rays;
    let _e293 = ((_e287 + _e288) - (_e290 * _e291));
    let _e295 = c_1[3u];
    return vec4<f32>(_e293.x, _e293.y, _e293.z, _e295);
}

fn main_1() {
    var param_27: vec2<f32>;

    let _e56 = _uv_1;
    param_27 = _e56;
    let _e57 = transition((&param_27));
    _fragColor = _e57;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
