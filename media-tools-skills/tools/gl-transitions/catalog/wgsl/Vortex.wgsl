// Vortex — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Vortex.glsl
// Author: gre
// License: MIT
// Description: The outgoing image breaks into hundreds of small squares that a tornado carries away along a spiral around the center, from the eye outward, uncovering the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    grid: i32,
    center: vec2<f32>,
    spin: f32,
    randomness: f32,
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

fn hash(n: ptr<function, vec2<f32>>) -> f32 {
    let _e45 = (*n);
    return fract((sin(dot(_e45, vec2<f32>(12.9898f, 78.233f))) * 43758.547f));
}

fn premultiplied(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e45 = (*c);
    let _e48 = (*c)[3u];
    let _e49 = (_e45.xyz * _e48);
    let _e51 = (*c)[3u];
    return vec4<f32>(_e49.x, _e49.y, _e49.z, _e51);
}

fn flight(g: ptr<function, i32>) -> f32 {
    var delay: f32;

    let _e46 = (*g);
    delay = ((f32(_e46) / 24f) * 0.75f);
    let _e51 = uniforms.progress;
    let _e52 = delay;
    return clamp(((_e51 - _e52) / 0.25f), 0f, 1f);
}

fn groupOf(n_1: ptr<function, vec2<f32>>, h: ptr<function, f32>, c_1: ptr<function, vec2<f32>>, maxR: ptr<function, f32>) -> i32 {
    var r: f32;
    var key: f32;
    var param: vec2<f32>;

    let _e51 = (*n_1);
    let _e54 = (*h);
    let _e56 = (*c_1);
    let _e59 = (*maxR);
    r = min((length((((_e51 + vec2(0.5f)) * _e54) - _e56)) / (0.85f * _e59)), 1f);
    let _e63 = r;
    let _e64 = r;
    let _e67 = (*n_1);
    param = _e67;
    let _e68 = hash((&param));
    let _e70 = uniforms.randomness;
    key = clamp(mix((_e63 * sqrt(_e64)), _e68, clamp(_e70, 0f, 1f)), 0f, 0.9999f);
    let _e74 = key;
    return i32(floor((_e74 * 24f)));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv)[0u];
    let _e48 = (*uv)[1u];
    let _e51 = textureSampleLevel(_to, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv_1)[0u];
    let _e48 = (*uv_1)[1u];
    let _e51 = textureSampleLevel(_from, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var aspect: vec2<f32>;
    var p: vec2<f32>;
    var c_2: vec2<f32>;
    var maxR_1: f32;
    var h_1: f32;
    var local: i32;
    var reach: f32;
    var n0_: vec2<f32>;
    var col: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: i32;
    var local_1: vec4<f32>;
    var param_8: vec2<f32>;
    var param_9: vec4<f32>;
    var param_10: vec2<f32>;
    var param_11: vec4<f32>;
    var k: i32;
    var g_1: i32;
    var s: f32;
    var param_12: i32;
    var e: f32;
    var angle: f32;
    var push: f32;
    var size: f32;
    var ca: f32;
    var sa: f32;
    var rot: mat2x2<f32>;
    var u: vec2<f32>;
    var ru: f32;
    var guess: vec2<f32>;
    var local_2: vec2<f32>;
    var ng: vec2<f32>;
    var j: i32;
    var i: i32;
    var n_2: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: vec2<f32>;
    var param_16: f32;
    var home: vec2<f32>;
    var rel: vec2<f32>;
    var rr: f32;
    var dir: vec2<f32>;
    var local_3: vec2<f32>;
    var pos: vec2<f32>;
    var tumble: f32;
    var param_17: vec2<f32>;
    var ct: f32;
    var st: f32;
    var d: vec2<f32>;
    var edge: f32;
    var cov: f32;
    var src: vec2<f32>;
    var piece: vec4<f32>;
    var param_18: vec2<f32>;
    var param_19: vec4<f32>;
    var local_4: vec4<f32>;
    var phi_537_: bool;
    var phi_544_: bool;
    var phi_553_: bool;
    var phi_560_: bool;

    let _e108 = uniforms.progress;
    if (_e108 <= 0f) {
        let _e110 = (*uv_2);
        param_1 = _e110;
        let _e111 = getFromColor((&param_1));
        return _e111;
    }
    let _e113 = uniforms.progress;
    if (_e113 >= 1f) {
        let _e115 = (*uv_2);
        param_2 = _e115;
        let _e116 = getToColor((&param_2));
        return _e116;
    }
    let _e118 = uniforms.ratio;
    aspect = vec2<f32>(_e118, 1f);
    let _e120 = (*uv_2);
    let _e121 = aspect;
    p = (_e120 * _e121);
    let _e124 = uniforms.center;
    let _e125 = aspect;
    c_2 = (_e124 * _e125);
    let _e127 = c_2;
    let _e129 = c_2;
    let _e131 = uniforms.ratio;
    let _e136 = c_2;
    let _e139 = c_2;
    let _e140 = aspect;
    maxR_1 = max(max(length(_e127), length((_e129 - vec2<f32>(_e131, 0f)))), max(length((_e136 - vec2<f32>(0f, 1f))), length((_e139 - _e140))));
    let _e146 = uniforms.grid;
    if (_e146 < 1i) {
        local = 1i;
    } else {
        let _e149 = uniforms.grid;
        local = _e149;
    }
    let _e150 = local;
    h_1 = (1f / f32(_e150));
    let _e153 = maxR_1;
    reach = (0.7f * _e153);
    let _e155 = p;
    let _e156 = h_1;
    n0_ = floor((_e155 / vec2(_e156)));
    let _e160 = n0_;
    param_3 = _e160;
    let _e161 = h_1;
    param_4 = _e161;
    let _e162 = c_2;
    param_5 = _e162;
    let _e163 = maxR_1;
    param_6 = _e163;
    let _e164 = groupOf((&param_3), (&param_4), (&param_5), (&param_6));
    param_7 = _e164;
    let _e165 = flight((&param_7));
    if (_e165 <= 0f) {
        let _e167 = (*uv_2);
        param_8 = _e167;
        let _e168 = getFromColor((&param_8));
        param_9 = _e168;
        let _e169 = premultiplied((&param_9));
        local_1 = _e169;
    } else {
        let _e170 = (*uv_2);
        param_10 = _e170;
        let _e171 = getToColor((&param_10));
        param_11 = _e171;
        let _e172 = premultiplied((&param_11));
        local_1 = _e172;
    }
    let _e173 = local_1;
    col = _e173;
    k = 0i;
    loop {
        let _e174 = k;
        if (_e174 < 24i) {
            let _e176 = k;
            g_1 = (23i - _e176);
            let _e178 = g_1;
            param_12 = _e178;
            let _e179 = flight((&param_12));
            s = _e179;
            let _e180 = s;
            let _e182 = s;
            if ((_e180 <= 0f) || (_e182 >= 1f)) {
                continue;
            }
            let _e185 = s;
            let _e186 = s;
            e = (_e185 * _e186);
            let _e189 = uniforms.spin;
            let _e191 = e;
            let _e194 = g_1;
            angle = ((((_e189 * 6.2831855f) * _e191) * 2f) / (1f + ((6f * f32(_e194)) / 24f)));
            let _e200 = reach;
            let _e201 = e;
            let _e203 = s;
            push = ((_e200 * _e201) * _e203);
            let _e205 = s;
            let _e210 = s;
            let _e211 = s;
            let _e213 = s;
            size = ((1f + (0.35f * sin((3.1415927f * _e205)))) * (1f - ((_e210 * _e211) * _e213)));
            let _e217 = angle;
            ca = cos(_e217);
            let _e219 = angle;
            sa = sin(_e219);
            let _e221 = ca;
            let _e222 = sa;
            let _e223 = sa;
            let _e225 = ca;
            rot = mat2x2<f32>(vec2<f32>(_e221, _e222), vec2<f32>(-(_e223), _e225));
            let _e229 = p;
            let _e230 = c_2;
            let _e232 = rot;
            u = ((_e229 - _e230) * _e232);
            let _e234 = u;
            ru = length(_e234);
            let _e236 = c_2;
            let _e237 = ru;
            if (_e237 > 0f) {
                let _e239 = u;
                let _e240 = ru;
                local_2 = (_e239 / vec2(_e240));
            } else {
                local_2 = vec2<f32>(0f, 0f);
            }
            let _e243 = local_2;
            let _e244 = ru;
            let _e245 = push;
            guess = (_e236 + (_e243 * max((_e244 - _e245), 0f)));
            let _e250 = guess;
            let _e251 = h_1;
            ng = floor((_e250 / vec2(_e251)));
            j = -1i;
            loop {
                let _e255 = j;
                if (_e255 <= 1i) {
                    i = -1i;
                    loop {
                        let _e257 = i;
                        if (_e257 <= 1i) {
                            let _e259 = ng;
                            let _e260 = i;
                            let _e262 = j;
                            n_2 = (_e259 + vec2<f32>(f32(_e260), f32(_e262)));
                            let _e266 = n_2;
                            param_13 = _e266;
                            let _e267 = h_1;
                            param_14 = _e267;
                            let _e268 = c_2;
                            param_15 = _e268;
                            let _e269 = maxR_1;
                            param_16 = _e269;
                            let _e270 = groupOf((&param_13), (&param_14), (&param_15), (&param_16));
                            let _e271 = g_1;
                            if (_e270 != _e271) {
                                continue;
                            }
                            let _e273 = n_2;
                            let _e276 = h_1;
                            home = ((_e273 + vec2(0.5f)) * _e276);
                            let _e278 = home;
                            let _e279 = c_2;
                            rel = (_e278 - _e279);
                            let _e281 = rel;
                            rr = length(_e281);
                            let _e283 = rr;
                            if (_e283 > 0f) {
                                let _e285 = rel;
                                let _e286 = rr;
                                local_3 = (_e285 / vec2(_e286));
                            } else {
                                local_3 = vec2<f32>(0f, 0f);
                            }
                            let _e289 = local_3;
                            dir = _e289;
                            let _e290 = c_2;
                            let _e291 = rot;
                            let _e292 = dir;
                            let _e293 = rr;
                            let _e294 = push;
                            pos = (_e290 + (_e291 * (_e292 * (_e293 + _e294))));
                            let _e299 = angle;
                            let _e300 = n_2;
                            param_17 = (_e300 + vec2(17f));
                            let _e303 = hash((&param_17));
                            let _e306 = e;
                            let _e309 = uniforms.spin;
                            tumble = (_e299 + ((((_e303 - 0.5f) * 3f) * _e306) * sign(_e309)));
                            let _e313 = tumble;
                            ct = cos(_e313);
                            let _e315 = tumble;
                            st = sin(_e315);
                            let _e317 = p;
                            let _e318 = pos;
                            let _e320 = ct;
                            let _e321 = st;
                            let _e322 = st;
                            let _e324 = ct;
                            let _e329 = size;
                            d = (((_e317 - _e318) * mat2x2<f32>(vec2<f32>(_e320, _e321), vec2<f32>(-(_e322), _e324))) / vec2(max(_e329, 0.0001f)));
                            let _e333 = h_1;
                            let _e336 = d[0u];
                            let _e339 = d[1u];
                            edge = ((0.5f * _e333) - max(abs(_e336), abs(_e339)));
                            let _e343 = edge;
                            let _e344 = size;
                            cov = clamp((((_e343 * _e344) / 0.003f) + 0.5f), 0f, 1f);
                            let _e349 = home;
                            let _e350 = d;
                            src = (_e349 + _e350);
                            let _e352 = cov;
                            let _e353 = (_e352 <= 0f);
                            phi_537_ = _e353;
                            if !(_e353) {
                                let _e356 = src[0u];
                                phi_537_ = (_e356 < 0f);
                            }
                            let _e359 = phi_537_;
                            phi_544_ = _e359;
                            if !(_e359) {
                                let _e362 = src[1u];
                                phi_544_ = (_e362 < 0f);
                            }
                            let _e365 = phi_544_;
                            phi_553_ = _e365;
                            if !(_e365) {
                                let _e368 = src[0u];
                                let _e370 = uniforms.ratio;
                                phi_553_ = (_e368 > _e370);
                            }
                            let _e373 = phi_553_;
                            phi_560_ = _e373;
                            if !(_e373) {
                                let _e376 = src[1u];
                                phi_560_ = (_e376 > 1f);
                            }
                            let _e379 = phi_560_;
                            if _e379 {
                                continue;
                            }
                            let _e380 = src;
                            let _e381 = aspect;
                            param_18 = (_e380 / _e381);
                            let _e383 = getFromColor((&param_18));
                            param_19 = _e383;
                            let _e384 = premultiplied((&param_19));
                            let _e385 = cov;
                            piece = (_e384 * _e385);
                            let _e387 = piece;
                            let _e388 = col;
                            let _e390 = piece[3u];
                            col = (_e387 + (_e388 * (1f - _e390)));
                            continue;
                        } else {
                            break;
                        }
                        continuing {
                            let _e394 = i;
                            i = (_e394 + 1i);
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e396 = j;
                    j = (_e396 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e398 = k;
            k = (_e398 + 1i);
        }
    }
    let _e401 = col[3u];
    if (_e401 > 0f) {
        let _e403 = col;
        let _e406 = col[3u];
        let _e408 = (_e403.xyz / vec3(_e406));
        let _e410 = col[3u];
        local_4 = vec4<f32>(_e408.x, _e408.y, _e408.z, _e410);
    } else {
        local_4 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e415 = local_4;
    return _e415;
}

fn main_1() {
    var param_20: vec2<f32>;

    let _e45 = _uv_1;
    param_20 = _e45;
    let _e46 = transition((&param_20));
    _fragColor = _e46;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
