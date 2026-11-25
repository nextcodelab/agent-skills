// Refraction — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Refraction.glsl
// Author: gre
// License: MIT
// Description: The frame is seen through flowing liquid glass that bends the outgoing image more and more, with rainbow fringes, flares up as the incoming image takes over, then calms down and clears
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
    scale: f32,
    dispersion: f32,
    brightness: f32,
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

fn spectrum(w: ptr<function, f32>) -> vec3<f32> {
    var c: vec3<f32>;

    let _e64 = (*w);
    let _e67 = (*w);
    let _e71 = (*w);
    let _e77 = (*w);
    c = vec3<f32>(((1f - smoothstep(0f, 0.55f, _e64)) + (0.35f * smoothstep(0.75f, 1f, _e67))), (1f - (abs(((2f * _e71) - 1f)) * 1.2f)), smoothstep(0.45f, 1f, _e77));
    let _e80 = c;
    return clamp(_e80, vec3(0f), vec3(1f));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e64 = (*uv)[0u];
    let _e66 = (*uv)[1u];
    let _e69 = textureSampleLevel(_to, _sampler, vec2<f32>(_e64, (1f - _e66)), 0f);
    return _e69;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e64 = (*uv_1)[0u];
    let _e66 = (*uv_1)[1u];
    let _e69 = textureSampleLevel(_from, _sampler, vec2<f32>(_e64, (1f - _e66)), 0f);
    return _e69;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e63 = (*v);
    let _e64 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e63 - (floor((_e63 / _e64)) * _e64)))));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e64 = (*v_1);
    v3_ = fract((_e64.xyx * 0.1031f));
    let _e68 = v3_;
    let _e69 = v3_;
    let _e74 = v3_;
    v3_ = (_e74 + vec3(dot(_e68, (_e69.yzx + vec3(33.33f)))));
    let _e78 = v3_[0u];
    let _e80 = v3_[1u];
    let _e83 = v3_[2u];
    return fract(((_e78 + _e80) * _e83));
}

fn surface(q: ptr<function, vec2<f32>>, t: ptr<function, f32>) -> f32 {
    var h: f32;

    let _e66 = (*q)[1u];
    let _e68 = (*t);
    let _e73 = (*q)[0u];
    let _e75 = (*t);
    let _e81 = (*q);
    (*q) = (_e81 + (vec2<f32>(sin(((1.3f * _e66) + (0.9f * _e68))), sin(((1.1f * _e73) - (1.2f * _e75)))) * 0.45f));
    let _e84 = (*q)[0u];
    let _e85 = (*t);
    let _e90 = (*q)[1u];
    let _e92 = (*t);
    h = (sin((_e84 + (0.6f * _e85))) * sin(((1.2f * _e90) - (0.8f * _e92))));
    let _e97 = (*q);
    let _e99 = (*t);
    let _e104 = h;
    h = (_e104 + (0.5f * sin((dot(_e97, vec2<f32>(1.6f, -1.2f)) + (1.4f * _e99)))));
    let _e106 = (*q);
    let _e108 = (*t);
    let _e112 = (*q)[0u];
    let _e119 = h;
    h = (_e119 + (0.3f * sin(((dot(_e106, vec2<f32>(-1.1f, 2.9f)) - (1.9f * _e108)) + (1.7f * sin((0.9f * _e112)))))));
    let _e121 = (*q);
    let _e123 = (*t);
    let _e128 = h;
    h = (_e128 + (0.15f * sin((dot(_e121, vec2<f32>(4.3f, 3.1f)) + (2.6f * _e123)))));
    let _e130 = h;
    return _e130;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var h_1: f32;
    var amount: f32;
    var q_1: vec2<f32>;
    var t_1: f32;
    var e: f32;
    var slope: vec2<f32>;
    var param: vec2<f32>;
    var param_1: f32;
    var param_2: vec2<f32>;
    var param_3: f32;
    var param_4: vec2<f32>;
    var param_5: f32;
    var param_6: vec2<f32>;
    var param_7: f32;
    var offset: vec2<f32>;
    var wave: f32;
    var param_8: vec2<f32>;
    var param_9: f32;
    var m: f32;
    var color: vec3<f32>;
    var weights: vec3<f32>;
    var alpha: f32;
    var jitter: f32;
    var param_10: vec2<f32>;
    var i: i32;
    var w_1: f32;
    var wj: f32;
    var st: vec2<f32>;
    var param_11: vec2<f32>;
    var c_1: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var s: vec3<f32>;
    var param_14: f32;
    var flare: f32;

    let _e100 = uniforms.progress;
    p = _e100;
    let _e101 = p;
    h_1 = (1f - abs(((2f * _e101) - 1f)));
    let _e106 = h_1;
    let _e107 = h_1;
    let _e109 = h_1;
    amount = ((_e106 * _e107) * (2f - _e109));
    let _e112 = (*uv_2);
    let _e116 = uniforms.ratio;
    let _e120 = uniforms.scale;
    q_1 = (((_e112 - vec2(0.5f)) * vec2<f32>(_e116, 1f)) * _e120);
    let _e122 = p;
    t_1 = (3f * _e122);
    e = 0.01f;
    let _e124 = q_1;
    let _e125 = e;
    param = (_e124 + vec2<f32>(_e125, 0f));
    let _e128 = t_1;
    param_1 = _e128;
    let _e129 = surface((&param), (&param_1));
    let _e130 = q_1;
    let _e131 = e;
    param_2 = (_e130 - vec2<f32>(_e131, 0f));
    let _e134 = t_1;
    param_3 = _e134;
    let _e135 = surface((&param_2), (&param_3));
    let _e137 = q_1;
    let _e138 = e;
    param_4 = (_e137 + vec2<f32>(0f, _e138));
    let _e141 = t_1;
    param_5 = _e141;
    let _e142 = surface((&param_4), (&param_5));
    let _e143 = q_1;
    let _e144 = e;
    param_6 = (_e143 - vec2<f32>(0f, _e144));
    let _e147 = t_1;
    param_7 = _e147;
    let _e148 = surface((&param_6), (&param_7));
    let _e151 = e;
    slope = (vec2<f32>((_e129 - _e135), (_e142 - _e148)) / vec2((2f * _e151)));
    let _e155 = slope;
    let _e157 = uniforms.strength;
    let _e159 = amount;
    let _e162 = uniforms.scale;
    offset = (((_e155 * _e157) * _e159) / vec2(_e162));
    let _e165 = q_1;
    param_8 = _e165;
    let _e166 = t_1;
    param_9 = _e166;
    let _e167 = surface((&param_8), (&param_9));
    wave = clamp((0.5f * _e167), -1f, 1f);
    let _e170 = p;
    let _e172 = wave;
    m = smoothstep(-0.015f, 0.015f, ((_e170 - 0.5f) + (0.1f * _e172)));
    color = vec3<f32>(0f, 0f, 0f);
    weights = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    let _e176 = (*uv_2);
    let _e178 = uniforms.ratio;
    param_10 = ((_e176 * vec2<f32>(_e178, 1f)) * 1000f);
    let _e182 = hash12((&param_10));
    jitter = (_e182 - 0.5f);
    i = 0i;
    loop {
        let _e184 = i;
        if (_e184 < 7i) {
            let _e186 = i;
            w_1 = (f32(_e186) / 6f);
            let _e189 = i;
            let _e191 = jitter;
            wj = ((f32(_e189) + _e191) / 6f);
            let _e194 = (*uv_2);
            let _e195 = offset;
            let _e197 = uniforms.dispersion;
            let _e198 = wj;
            param_11 = (_e194 + (_e195 * (1f + ((_e197 * (_e198 - 0.5f)) * 1.6f))));
            let _e205 = mirror((&param_11));
            st = _e205;
            let _e206 = st;
            param_12 = _e206;
            let _e207 = getFromColor((&param_12));
            let _e208 = st;
            param_13 = _e208;
            let _e209 = getToColor((&param_13));
            let _e210 = m;
            c_1 = mix(_e207, _e209, vec4(_e210));
            let _e213 = w_1;
            param_14 = _e213;
            let _e214 = spectrum((&param_14));
            s = _e214;
            let _e215 = s;
            let _e216 = c_1;
            let _e220 = c_1[3u];
            let _e222 = color;
            color = (_e222 + ((_e215 * _e216.xyz) * _e220));
            let _e224 = s;
            let _e225 = weights;
            weights = (_e225 + _e224);
            let _e228 = c_1[3u];
            let _e229 = alpha;
            alpha = (_e229 + _e228);
            continue;
        } else {
            break;
        }
        continuing {
            let _e231 = i;
            i = (_e231 + 1i);
        }
    }
    let _e233 = alpha;
    alpha = (_e233 / 7f);
    let _e235 = color;
    let _e236 = weights;
    let _e238 = alpha;
    color = ((_e235 / _e236) / vec3(max(_e238, 0.00001f)));
    let _e243 = uniforms.brightness;
    let _e245 = h_1;
    flare = ((2f * _e243) * pow(_e245, 8f));
    let _e248 = color;
    let _e249 = flare;
    let _e252 = flare;
    let _e253 = color;
    color = ((_e248 * (1f + _e249)) / (vec3(1f) + (_e253 * _e252)));
    let _e258 = flare;
    let _e260 = color;
    let _e263 = color;
    color = (_e263 + vec3(((0.1f * _e258) * dot(_e260, vec3<f32>(0.3333f, 0.3333f, 0.3333f)))));
    let _e266 = color;
    let _e269 = clamp(_e266, vec3(0f), vec3(1f));
    let _e270 = alpha;
    return vec4<f32>(_e269.x, _e269.y, _e269.z, _e270);
}

fn main_1() {
    var param_15: vec2<f32>;

    let _e63 = _uv_1;
    param_15 = _e63;
    let _e64 = transition((&param_15));
    _fragColor = _e64;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
