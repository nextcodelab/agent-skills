// LightStreaks — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightStreaks.glsl
// Author: gre
// License: MIT
// Description: The highlights of the outgoing image flare into long horizontal (or vertical) lens streaks while it smears with motion blur; at the peak the incoming image takes over and its streaks shrink back into its highlights as it sharpens
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    reach: f32,
    threshold: f32,
    intensity: f32,
    tint: vec3<f32>,
    blur: f32,
    vertical: i32,
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

fn glow(c: ptr<function, vec4<f32>>, knee: ptr<function, f32>) -> vec3<f32> {
    var lum: f32;

    let _e52 = (*c);
    lum = dot(_e52.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e55 = (*c);
    let _e58 = (*c)[3u];
    let _e60 = (*knee);
    let _e61 = (*knee);
    let _e63 = lum;
    return ((_e55.xyz * _e58) * smoothstep(_e60, (_e61 + 0.2f), _e63));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e51 = (*uv)[0u];
    let _e53 = (*uv)[1u];
    let _e56 = textureSampleLevel(_to, _sampler, vec2<f32>(_e51, (1f - _e53)), 0f);
    return _e56;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e51 = (*uv_1)[0u];
    let _e53 = (*uv_1)[1u];
    let _e56 = textureSampleLevel(_from, _sampler, vec2<f32>(_e51, (1f - _e53)), 0f);
    return _e56;
}

fn frame(st: ptr<function, vec2<f32>>, m: ptr<function, f32>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e55 = (*m);
    if (_e55 <= 0f) {
        let _e57 = (*st);
        param = _e57;
        let _e58 = getFromColor((&param));
        return _e58;
    }
    let _e59 = (*m);
    if (_e59 >= 1f) {
        let _e61 = (*st);
        param_1 = _e61;
        let _e62 = getToColor((&param_1));
        return _e62;
    }
    let _e63 = (*st);
    param_2 = _e63;
    let _e64 = getFromColor((&param_2));
    let _e65 = (*st);
    param_3 = _e65;
    let _e66 = getToColor((&param_3));
    let _e67 = (*m);
    return mix(_e64, _e66, vec4(_e67));
}

fn light(st_1: ptr<function, vec2<f32>>, m_1: ptr<function, f32>, incoming: ptr<function, bool>) -> vec4<f32> {
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var local: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;

    let _e57 = (*m_1);
    if (_e57 <= 0f) {
        let _e59 = (*st_1);
        param_4 = _e59;
        let _e60 = getFromColor((&param_4));
        return _e60;
    }
    let _e61 = (*m_1);
    if (_e61 >= 1f) {
        let _e63 = (*st_1);
        param_5 = _e63;
        let _e64 = getToColor((&param_5));
        return _e64;
    }
    let _e65 = (*incoming);
    if _e65 {
        let _e66 = (*st_1);
        param_6 = _e66;
        let _e67 = getToColor((&param_6));
        local = _e67;
    } else {
        let _e68 = (*st_1);
        param_7 = _e68;
        let _e69 = getFromColor((&param_7));
        local = _e69;
    }
    let _e70 = local;
    return _e70;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e50 = (*v);
    let _e51 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e50 - (floor((_e50 / _e51)) * _e51)))));
}

fn lightWeight(m_2: ptr<function, f32>, incoming_1: ptr<function, bool>) -> f32 {
    var local_1: f32;

    let _e52 = (*m_2);
    let _e54 = (*m_2);
    if ((_e52 <= 0f) || (_e54 >= 1f)) {
        return 1f;
    }
    let _e57 = (*incoming_1);
    if _e57 {
        let _e58 = (*m_2);
        local_1 = (2f * _e58);
    } else {
        let _e60 = (*m_2);
        local_1 = (2f * (1f - _e60));
    }
    let _e63 = local_1;
    return _e63;
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e51 = (*v_1);
    v3_ = fract((_e51.xyx * 0.1031f));
    let _e55 = v3_;
    let _e56 = v3_;
    let _e61 = v3_;
    v3_ = (_e61 + vec3(dot(_e55, (_e56.yzx + vec3(33.33f)))));
    let _e65 = v3_[0u];
    let _e67 = v3_[1u];
    let _e70 = v3_[2u];
    return fract(((_e65 + _e67) * _e70));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var amount: f32;
    var local_2: f32;
    var peak: f32;
    var m_3: f32;
    var axis: vec2<f32>;
    var jitter: f32;
    var param_8: vec2<f32>;
    var smear: f32;
    var base: vec3<f32>;
    var alpha: f32;
    var total: f32;
    var i: i32;
    var t: f32;
    var w: f32;
    var incoming_2: bool;
    var param_9: f32;
    var param_10: bool;
    var c_1: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: f32;
    var param_14: bool;
    var falloff: f32;
    var knee_1: f32;
    var streak: vec3<f32>;
    var param_15: vec2<f32>;
    var param_16: f32;
    var param_17: vec4<f32>;
    var param_18: f32;
    var weights: f32;
    var k: i32;
    var d: f32;
    var span: f32;
    var hue: vec3<f32>;
    var w_1: f32;
    var incoming_3: bool;
    var ahead: vec4<f32>;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var param_21: f32;
    var param_22: bool;
    var behind: vec4<f32>;
    var param_23: vec2<f32>;
    var param_24: vec2<f32>;
    var param_25: f32;
    var param_26: bool;
    var param_27: vec4<f32>;
    var param_28: f32;
    var param_29: f32;
    var param_30: bool;
    var param_31: vec4<f32>;
    var param_32: f32;
    var param_33: f32;
    var param_34: bool;
    var color: vec3<f32>;
    var a: f32;

    let _e108 = uniforms.progress;
    p = _e108;
    let _e109 = p;
    if (_e109 < 0.5f) {
        let _e111 = p;
        local_2 = smoothstep(0f, 0.5f, _e111);
    } else {
        let _e113 = p;
        local_2 = pow((2f - (2f * _e113)), 3f);
    }
    let _e117 = local_2;
    amount = _e117;
    let _e118 = amount;
    let _e119 = amount;
    let _e121 = amount;
    peak = ((_e118 * _e119) * _e121);
    let _e123 = p;
    m_3 = smoothstep(0.44f, 0.56f, _e123);
    let _e126 = uniforms.vertical;
    axis = select(vec2<f32>(1f, 0f), vec2<f32>(0f, 1f), vec2((_e126 != 0i)));
    let _e130 = (*uv_2);
    let _e132 = uniforms.ratio;
    param_8 = floor(((_e130 * vec2<f32>(_e132, 1f)) * 997f));
    let _e137 = hash12((&param_8));
    jitter = (_e137 - 0.5f);
    let _e140 = uniforms.blur;
    let _e141 = amount;
    smear = (_e140 * _e141);
    base = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    total = 0f;
    i = 0i;
    loop {
        let _e143 = i;
        if (_e143 < 6i) {
            let _e145 = i;
            let _e148 = jitter;
            t = ((((f32(_e145) + 0.5f) + _e148) / 6f) - 0.5f);
            let _e152 = t;
            w = (1f - abs(_e152));
            let _e155 = w;
            let _e156 = total;
            total = (_e156 + _e155);
            let _e158 = i;
            let _e159 = f32(_e158);
            incoming_2 = ((_e159 - (floor((_e159 / 2f)) * 2f)) > 0.5f);
            let _e165 = m_3;
            param_9 = _e165;
            let _e166 = incoming_2;
            param_10 = _e166;
            let _e167 = lightWeight((&param_9), (&param_10));
            let _e168 = w;
            w = (_e168 * _e167);
            let _e170 = (*uv_2);
            let _e171 = axis;
            let _e172 = t;
            let _e174 = smear;
            param_11 = (_e170 + ((_e171 * _e172) * _e174));
            let _e177 = mirror((&param_11));
            param_12 = _e177;
            let _e178 = m_3;
            param_13 = _e178;
            let _e179 = incoming_2;
            param_14 = _e179;
            let _e180 = light((&param_12), (&param_13), (&param_14));
            c_1 = _e180;
            let _e181 = w;
            let _e182 = c_1;
            let _e186 = c_1[3u];
            let _e188 = base;
            base = (_e188 + ((_e182.xyz * _e181) * _e186));
            let _e190 = w;
            let _e192 = c_1[3u];
            let _e194 = alpha;
            alpha = (_e194 + (_e190 * _e192));
            continue;
        } else {
            break;
        }
        continuing {
            let _e196 = i;
            i = (_e196 + 1i);
        }
    }
    let _e198 = total;
    let _e199 = base;
    base = (_e199 / vec3(_e198));
    let _e202 = total;
    let _e203 = alpha;
    alpha = (_e203 / _e202);
    let _e206 = uniforms.reach;
    let _e208 = amount;
    falloff = ((0.25f * _e206) * _e208);
    let _e211 = uniforms.threshold;
    let _e213 = uniforms.threshold;
    let _e215 = peak;
    knee_1 = mix(_e211, (0.8f * _e213), _e215);
    let _e217 = (*uv_2);
    param_15 = _e217;
    let _e218 = m_3;
    param_16 = _e218;
    let _e219 = frame((&param_15), (&param_16));
    param_17 = _e219;
    let _e220 = knee_1;
    param_18 = _e220;
    let _e221 = glow((&param_17), (&param_18));
    streak = _e221;
    weights = 1f;
    k = 1i;
    loop {
        let _e222 = k;
        if (_e222 <= 11i) {
            let _e224 = k;
            let _e226 = jitter;
            d = (exp((0.14f * (f32(_e224) + (0.8f * _e226)))) - 1f);
            let _e232 = d;
            span = (0.14f * (_e232 + 1f));
            let _e236 = uniforms.tint;
            let _e237 = d;
            hue = mix(vec3<f32>(1f, 1f, 1f), _e236, vec3(smoothstep(0f, 0.8f, _e237)));
            let _e241 = d;
            let _e245 = hue;
            hue = (_e245 * exp((vec3<f32>(0.6f, 0.2f, -0.15f) * -(_e241))));
            let _e247 = d;
            let _e250 = span;
            w_1 = ((exp(-(_e247)) * _e250) * 4f);
            let _e253 = k;
            let _e254 = f32(_e253);
            incoming_3 = ((_e254 - (floor((_e254 / 2f)) * 2f)) > 0.5f);
            let _e260 = (*uv_2);
            let _e261 = axis;
            let _e262 = d;
            let _e264 = falloff;
            param_19 = (_e260 + ((_e261 * _e262) * _e264));
            let _e267 = mirror((&param_19));
            param_20 = _e267;
            let _e268 = m_3;
            param_21 = _e268;
            let _e269 = incoming_3;
            param_22 = _e269;
            let _e270 = light((&param_20), (&param_21), (&param_22));
            ahead = _e270;
            let _e271 = (*uv_2);
            let _e272 = axis;
            let _e273 = d;
            let _e275 = falloff;
            param_23 = (_e271 - ((_e272 * _e273) * _e275));
            let _e278 = mirror((&param_23));
            let _e279 = incoming_3;
            param_24 = _e278;
            let _e281 = m_3;
            param_25 = _e281;
            param_26 = !(_e279);
            let _e282 = light((&param_24), (&param_25), (&param_26));
            behind = _e282;
            let _e283 = w_1;
            let _e284 = hue;
            let _e286 = ahead;
            param_27 = _e286;
            let _e287 = knee_1;
            param_28 = _e287;
            let _e288 = glow((&param_27), (&param_28));
            let _e289 = m_3;
            param_29 = _e289;
            let _e290 = incoming_3;
            param_30 = _e290;
            let _e291 = lightWeight((&param_29), (&param_30));
            let _e293 = behind;
            param_31 = _e293;
            let _e294 = knee_1;
            param_32 = _e294;
            let _e295 = glow((&param_31), (&param_32));
            let _e296 = incoming_3;
            let _e298 = m_3;
            param_33 = _e298;
            param_34 = !(_e296);
            let _e299 = lightWeight((&param_33), (&param_34));
            let _e303 = streak;
            streak = (_e303 + ((_e284 * _e283) * ((_e288 * _e291) + (_e295 * _e299))));
            let _e305 = w_1;
            let _e307 = weights;
            weights = (_e307 + (2f * _e305));
            continue;
        } else {
            break;
        }
        continuing {
            let _e309 = k;
            k = (_e309 + 1i);
        }
    }
    let _e312 = uniforms.intensity;
    let _e313 = amount;
    let _e315 = peak;
    let _e320 = weights;
    let _e322 = streak;
    streak = (_e322 * ((((_e312 * _e313) * (0.6f + (2.4f * _e315))) * 2f) / _e320));
    let _e324 = streak;
    streak = ((vec3(1f) - exp(-(_e324))) * 0.85f);
    let _e330 = base;
    let _e331 = peak;
    let _e335 = alpha;
    base = min((_e330 * (1f + (0.2f * _e331))), vec3(_e335));
    let _e338 = base;
    let _e339 = streak;
    let _e341 = base;
    let _e342 = streak;
    color = ((_e338 + _e339) - (_e341 * _e342));
    let _e345 = alpha;
    let _e347 = streak[0u];
    let _e349 = streak[1u];
    let _e351 = streak[2u];
    let _e354 = alpha;
    a = (_e345 + (max(_e347, max(_e349, _e351)) * (1f - _e354)));
    let _e358 = color;
    let _e359 = a;
    let _e365 = clamp((_e358 / vec3(max(_e359, 0.00001f))), vec3(0f), vec3(1f));
    let _e366 = a;
    return vec4<f32>(_e365.x, _e365.y, _e365.z, _e366);
}

fn main_1() {
    var param_35: vec2<f32>;

    let _e50 = _uv_1;
    param_35 = _e50;
    let _e51 = transition((&param_35));
    _fragColor = _e51;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
