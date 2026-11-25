// SplatterWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplatterWipe.glsl
// Author: gre
// License: MIT
// Description: Splats of paint land one after another, each popping in with a spiky outline, flung droplets and a few drips running down, revealing the incoming image until they cover the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    splats: f32,
    spikiness: f32,
    droplets: f32,
    drips: f32,
    rim: f32,
    seed: f32,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e78 = (*uv)[0u];
    let _e80 = (*uv)[1u];
    let _e83 = textureSampleLevel(_to, _sampler, vec2<f32>(_e78, (1f - _e80)), 0f);
    return _e83;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e78 = (*uv_1)[0u];
    let _e80 = (*uv_1)[1u];
    let _e83 = textureSampleLevel(_from, _sampler, vec2<f32>(_e78, (1f - _e80)), 0f);
    return _e83;
}

fn smax(a: ptr<function, f32>, b: ptr<function, f32>, k: ptr<function, f32>) -> f32 {
    var h: f32;

    let _e80 = (*k);
    let _e81 = (*a);
    let _e82 = (*b);
    let _e87 = (*k);
    h = (max((_e80 - abs((_e81 - _e82))), 0f) / _e87);
    let _e89 = (*a);
    let _e90 = (*b);
    let _e92 = h;
    let _e93 = h;
    let _e95 = (*k);
    return (max(_e89, _e90) + (((_e92 * _e93) * _e95) * 0.25f));
}

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e78 = (*v);
    v3_ = fract((_e78.xyx * 0.1031f));
    let _e82 = v3_;
    let _e83 = v3_;
    let _e88 = v3_;
    v3_ = (_e88 + vec3(dot(_e82, (_e83.yzx + vec3(33.33f)))));
    let _e92 = v3_[0u];
    let _e94 = v3_[1u];
    let _e97 = v3_[2u];
    return fract(((_e92 + _e94) * _e97));
}

fn turnNoise(t: ptr<function, f32>, n: ptr<function, f32>, key: ptr<function, vec2<f32>>) -> f32 {
    var x: f32;
    var i: f32;
    var f: f32;
    var a_1: f32;
    var param: vec2<f32>;
    var b_1: f32;
    var param_1: vec2<f32>;

    let _e86 = (*t);
    let _e87 = (*n);
    x = (_e86 * _e87);
    let _e89 = x;
    i = floor(_e89);
    let _e91 = x;
    let _e92 = i;
    f = (_e91 - _e92);
    let _e94 = (*key);
    let _e95 = i;
    let _e96 = (*n);
    param = (_e94 + vec2<f32>((_e95 - (floor((_e95 / _e96)) * _e96)), 61f));
    let _e103 = hash12((&param));
    a_1 = _e103;
    let _e104 = (*key);
    let _e105 = i;
    let _e106 = (_e105 + 1f);
    let _e107 = (*n);
    param_1 = (_e104 + vec2<f32>((_e106 - (floor((_e106 / _e107)) * _e107)), 61f));
    let _e114 = hash12((&param_1));
    b_1 = _e114;
    let _e115 = a_1;
    let _e116 = b_1;
    let _e117 = f;
    let _e118 = f;
    let _e120 = f;
    return mix(_e115, _e116, ((_e117 * _e118) * (3f - (2f * _e120))));
}

fn splat(q: ptr<function, vec2<f32>>, cell: ptr<function, vec2<f32>>, key_1: ptr<function, vec2<f32>>) -> f32 {
    var t0_: f32;
    var param_2: vec2<f32>;
    var c: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var d: vec2<f32>;
    var l: f32;
    var pop: f32;
    var x_1: f32;
    var grow: f32;
    var r0_: f32;
    var param_5: vec2<f32>;
    var rc: f32;
    var a_2: f32;
    var local: f32;
    var lumps: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var param_11: vec2<f32>;
    var f_1: f32;
    var s: f32;
    var spike: f32;
    var k_1: i32;
    var sl: f32;
    var sk: vec2<f32>;
    var h_1: f32;
    var param_12: vec2<f32>;
    var w0_: f32;
    var param_13: vec2<f32>;
    var len: f32;
    var w: f32;
    var ang: f32;
    var param_14: vec2<f32>;
    var dir: vec2<f32>;
    var along: f32;
    var across: f32;
    var u: f32;
    var ray: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var j: i32;
    var dk: vec2<f32>;
    var hr: f32;
    var param_18: vec2<f32>;
    var rad: f32;
    var da: f32;
    var param_19: vec2<f32>;
    var dist: f32;
    var param_20: vec2<f32>;
    var run: f32;
    var j_1: i32;
    var dk_1: vec2<f32>;
    var xo: f32;
    var param_21: vec2<f32>;
    var dw: f32;
    var param_22: vec2<f32>;
    var top: f32;
    var bottom: f32;
    var param_23: vec2<f32>;
    var dx: f32;
    var drip: f32;
    var tip: f32;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;

    let _e148 = (*key_1);
    param_2 = (_e148 + vec2<f32>(3f, 0f));
    let _e150 = hash12((&param_2));
    t0_ = (0.01f + (0.6f * _e150));
    let _e154 = uniforms.progress;
    let _e155 = t0_;
    if (_e154 <= _e155) {
        return -1f;
    }
    let _e157 = (*cell);
    let _e160 = (*key_1);
    param_3 = (_e160 + vec2<f32>(5f, 1f));
    let _e162 = hash12((&param_3));
    let _e163 = (*key_1);
    param_4 = (_e163 + vec2<f32>(9f, 2f));
    let _e165 = hash12((&param_4));
    c = ((_e157 + vec2(0.5f)) + ((vec2<f32>(_e162, _e165) - vec2(0.5f)) * 0.3f));
    let _e171 = (*q);
    let _e172 = c;
    d = (_e171 - _e172);
    let _e174 = d;
    l = length(_e174);
    let _e176 = l;
    if (_e176 > 1.35f) {
        return -1f;
    }
    let _e179 = uniforms.progress;
    let _e180 = t0_;
    pop = clamp(((_e179 - _e180) / 0.08f), 0f, 1f);
    let _e184 = pop;
    let _e186 = pop;
    let _e189 = pop;
    pop = (1f - (((1f - _e184) * (1f - _e186)) * (1f - _e189)));
    let _e194 = uniforms.progress;
    let _e195 = t0_;
    let _e197 = t0_;
    x_1 = clamp(((_e194 - _e195) / (0.96f - _e197)), 0f, 1f);
    let _e201 = x_1;
    let _e202 = x_1;
    let _e204 = x_1;
    grow = ((_e201 * _e202) * _e204);
    let _e206 = (*key_1);
    param_5 = (_e206 + vec2<f32>(11f, 3f));
    let _e208 = hash12((&param_5));
    r0_ = (0.42f + (0.2f * _e208));
    let _e211 = r0_;
    let _e212 = pop;
    let _e214 = grow;
    rc = mix((_e211 * _e212), 1.03f, _e214);
    let _e216 = l;
    if (_e216 > 0.00001f) {
        let _e219 = d[1u];
        let _e221 = d[0u];
        local = ((atan2(_e219, _e221) / 6.2831855f) + 0.5f);
    } else {
        local = 0f;
    }
    let _e225 = local;
    a_2 = _e225;
    let _e226 = grow;
    let _e228 = a_2;
    param_6 = _e228;
    param_7 = 5f;
    let _e229 = (*key_1);
    param_8 = _e229;
    let _e230 = turnNoise((&param_6), (&param_7), (&param_8));
    let _e233 = grow;
    let _e235 = (*key_1);
    let _e238 = a_2;
    param_9 = _e238;
    param_10 = 19f;
    param_11 = (_e235 + vec2(3f));
    let _e239 = turnNoise((&param_9), (&param_10), (&param_11));
    lumps = ((mix(0.3f, 0.06f, _e226) * (_e230 - 0.5f)) + (mix(0.18f, 0.06f, _e233) * (_e239 - 0.5f)));
    let _e243 = rc;
    let _e244 = lumps;
    let _e247 = l;
    f_1 = ((_e243 * (1f + _e244)) - _e247);
    let _e249 = a_2;
    s = floor((_e249 * 14f));
    spike = -1f;
    k_1 = -1i;
    loop {
        let _e252 = k_1;
        if (_e252 <= 1i) {
            let _e254 = s;
            let _e255 = k_1;
            sl = (_e254 + f32(_e255));
            let _e258 = (*key_1);
            let _e259 = sl;
            sk = (_e258 + vec2<f32>((_e259 - (floor((_e259 / 14f)) * 14f)), 17f));
            let _e266 = sk;
            param_12 = _e266;
            let _e267 = hash12((&param_12));
            h_1 = _e267;
            let _e268 = sk;
            param_13 = (_e268 + vec2(1.5f));
            let _e271 = hash12((&param_13));
            let _e274 = pop;
            w0_ = ((0.022f + (0.03f * _e271)) * _e274);
            let _e277 = uniforms.spikiness;
            let _e278 = h_1;
            let _e280 = h_1;
            let _e284 = pop;
            let _e286 = w0_;
            let _e289 = rc;
            len = max(min(((_e277 * (0.06f + ((0.6f * _e278) * _e280))) * _e284), ((1.25f - (1.2f * _e286)) - _e289)), 0f);
            let _e293 = len;
            if (_e293 > 0f) {
                let _e295 = w0_;
                let _e296 = len;
                w = (_e295 * min((_e296 / 0.06f), 1f));
                let _e300 = sl;
                let _e302 = sk;
                param_14 = (_e302 + vec2(0.5f));
                let _e305 = hash12((&param_14));
                ang = ((((((_e300 + 0.5f) + (0.4f * (_e305 - 0.5f))) / 14f) * 2f) * 3.1415927f) - 3.1415927f);
                let _e313 = ang;
                let _e315 = ang;
                dir = vec2<f32>(cos(_e313), sin(_e315));
                let _e318 = d;
                let _e319 = dir;
                along = dot(_e318, _e319);
                let _e322 = d[0u];
                let _e324 = dir[1u];
                let _e327 = d[1u];
                let _e329 = dir[0u];
                across = abs(((_e322 * _e324) - (_e327 * _e329)));
                let _e333 = along;
                let _e334 = rc;
                let _e336 = len;
                u = clamp(((_e333 - _e334) / _e336), 0f, 1f);
                let _e339 = w;
                let _e340 = u;
                let _e344 = across;
                let _e346 = rc;
                let _e347 = len;
                let _e349 = along;
                ray = min(((_e339 * (1f - (0.7f * _e340))) - _e344), ((_e346 + _e347) - _e349));
                let _e352 = h_1;
                if (_e352 > 0.5f) {
                    let _e354 = ray;
                    let _e355 = w;
                    let _e357 = d;
                    let _e358 = dir;
                    let _e359 = rc;
                    let _e360 = len;
                    ray = max(_e354, ((_e355 * 1.2f) - length((_e357 - (_e358 * (_e359 + _e360))))));
                }
                let _e367 = spike;
                let _e368 = ray;
                spike = max(_e367, _e368);
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e370 = k_1;
            k_1 = (_e370 + 1i);
        }
    }
    let _e372 = f_1;
    param_15 = _e372;
    let _e373 = spike;
    param_16 = _e373;
    param_17 = 0.08f;
    let _e374 = smax((&param_15), (&param_16), (&param_17));
    f_1 = _e374;
    j = 0i;
    loop {
        let _e375 = j;
        if (_e375 < 5i) {
            let _e377 = (*key_1);
            let _e378 = j;
            dk = (_e377 + vec2<f32>(f32(_e378), 29f));
            let _e382 = dk;
            param_18 = (_e382 + vec2(0.5f));
            let _e385 = hash12((&param_18));
            hr = _e385;
            let _e386 = hr;
            let _e388 = hr;
            let _e392 = uniforms.droplets;
            let _e394 = j;
            let _e399 = pop;
            rad = (((0.015f + ((0.05f * _e386) * _e388)) * clamp(((_e392 * 5f) - f32(_e394)), 0f, 1f)) * _e399);
            let _e401 = rad;
            if (_e401 > 0f) {
                let _e403 = dk;
                param_19 = _e403;
                let _e404 = hash12((&param_19));
                da = (6.2831855f * _e404);
                let _e406 = r0_;
                let _e408 = dk;
                param_20 = (_e408 + vec2(1.5f));
                let _e411 = hash12((&param_20));
                let _e414 = rad;
                let _e417 = pop;
                dist = (min(((_e406 + 0.08f) + (0.5f * _e411)), (1.25f - _e414)) * mix(0.5f, 1f, _e417));
                let _e420 = f_1;
                let _e421 = rad;
                let _e422 = d;
                let _e423 = dist;
                let _e424 = da;
                let _e426 = da;
                f_1 = max(_e420, (_e421 - length((_e422 - (vec2<f32>(cos(_e424), sin(_e426)) * _e423)))));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e434 = j;
            j = (_e434 + 1i);
        }
    }
    let _e437 = uniforms.drips;
    if (_e437 > 0f) {
        let _e440 = uniforms.progress;
        let _e441 = t0_;
        run = clamp((((_e440 - _e441) - 0.03f) / 0.45f), 0f, 1f);
        let _e446 = run;
        let _e447 = run;
        run = (_e446 * (2f - _e447));
        j_1 = 0i;
        loop {
            let _e450 = j_1;
            if (_e450 < 2i) {
                let _e452 = (*key_1);
                let _e453 = j_1;
                dk_1 = (_e452 + vec2<f32>(f32(_e453), 43f));
                let _e457 = dk_1;
                param_21 = _e457;
                let _e458 = hash12((&param_21));
                let _e460 = r0_;
                xo = ((_e458 - 0.5f) * _e460);
                let _e462 = dk_1;
                param_22 = (_e462 + vec2(0.5f));
                let _e465 = hash12((&param_22));
                let _e468 = pop;
                dw = ((0.03f + (0.02f * _e465)) * _e468);
                let _e470 = r0_;
                let _e471 = r0_;
                let _e473 = xo;
                let _e474 = xo;
                let _e478 = pop;
                top = (sqrt(((_e470 * _e471) - (_e473 * _e474))) * _e478);
                let _e480 = top;
                let _e482 = uniforms.drips;
                let _e483 = dk_1;
                param_23 = (_e483 + vec2(1.5f));
                let _e486 = hash12((&param_23));
                let _e490 = run;
                let _e493 = xo;
                let _e494 = xo;
                let _e498 = dw;
                bottom = min((_e480 + ((_e482 * (0.25f + (0.75f * _e486))) * _e490)), (sqrt((1.5625f - (_e493 * _e494))) - (1.6f * _e498)));
                let _e503 = d[0u];
                let _e504 = xo;
                dx = abs((_e503 - _e504));
                let _e507 = dw;
                let _e508 = dx;
                let _e511 = d[1u];
                let _e512 = bottom;
                let _e515 = d[1u];
                drip = min((_e507 - _e508), min((_e511 + _e512), -(_e515)));
                let _e519 = dw;
                let _e521 = dx;
                let _e523 = d[1u];
                let _e524 = bottom;
                let _e526 = dw;
                tip = ((_e519 * 1.4f) - length(vec2<f32>(_e521, ((_e523 + _e524) + (0.2f * _e526)))));
                let _e532 = drip;
                let _e533 = tip;
                let _e535 = f_1;
                param_24 = _e535;
                param_25 = max(_e532, _e533);
                param_26 = 0.05f;
                let _e536 = smax((&param_24), (&param_25), (&param_26));
                f_1 = _e536;
                continue;
            } else {
                break;
            }
            continuing {
                let _e537 = j_1;
                j_1 = (_e537 + 1i);
            }
        }
    }
    let _e539 = f_1;
    return _e539;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n_1: f32;
    var cellSize: f32;
    var q_1: vec2<f32>;
    var base: vec2<f32>;
    var sd: vec2<f32>;
    var f_2: f32;
    var j_2: i32;
    var i_1: i32;
    var cell_1: vec2<f32>;
    var param_27: vec2<f32>;
    var param_28: vec2<f32>;
    var param_29: vec2<f32>;
    var aa: f32;
    var inside: f32;
    var from_: vec4<f32>;
    var param_30: vec2<f32>;
    var to: vec4<f32>;
    var param_31: vec2<f32>;
    var e: f32;
    var amount: f32;
    var dark: f32;
    var gloss: f32;

    let _e100 = uniforms.splats;
    n_1 = max(1f, floor((_e100 + 0.5f)));
    let _e105 = uniforms.ratio;
    let _e107 = n_1;
    cellSize = (max(_e105, 1f) / _e107);
    let _e110 = (*uv_2)[0u];
    let _e112 = uniforms.ratio;
    let _e115 = (*uv_2)[1u];
    let _e117 = cellSize;
    q_1 = (vec2<f32>((_e110 * _e112), _e115) / vec2(_e117));
    let _e120 = q_1;
    base = floor(_e120);
    let _e123 = uniforms.seed;
    sd = (vec2<f32>(7f, 13f) * _e123);
    f_2 = -1f;
    j_2 = -1i;
    loop {
        let _e125 = j_2;
        if (_e125 <= 1i) {
            i_1 = -1i;
            loop {
                let _e127 = i_1;
                if (_e127 <= 1i) {
                    let _e129 = base;
                    let _e130 = i_1;
                    let _e132 = j_2;
                    cell_1 = (_e129 + vec2<f32>(f32(_e130), f32(_e132)));
                    let _e136 = f_2;
                    let _e137 = cell_1;
                    let _e138 = sd;
                    let _e140 = q_1;
                    param_27 = _e140;
                    let _e141 = cell_1;
                    param_28 = _e141;
                    param_29 = (_e137 + _e138);
                    let _e142 = splat((&param_27), (&param_28), (&param_29));
                    f_2 = max(_e136, _e142);
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e144 = i_1;
                    i_1 = (_e144 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e146 = j_2;
            j_2 = (_e146 + 1i);
        }
    }
    let _e148 = cellSize;
    aa = (0.0025f / _e148);
    let _e150 = aa;
    let _e152 = aa;
    let _e153 = f_2;
    inside = smoothstep(-(_e150), _e152, _e153);
    let _e155 = (*uv_2);
    param_30 = _e155;
    let _e156 = getFromColor((&param_30));
    from_ = _e156;
    let _e157 = (*uv_2);
    param_31 = _e157;
    let _e158 = getToColor((&param_31));
    to = _e158;
    let _e159 = f_2;
    e = clamp((_e159 / 0.045f), 0f, 1f);
    let _e163 = uniforms.rim;
    let _e165 = uniforms.progress;
    amount = (_e163 * (1f - smoothstep(0.75f, 1f, _e165)));
    let _e169 = e;
    let _e171 = e;
    dark = (((1f - _e169) * (1f - _e171)) * 0.6f);
    let _e175 = e;
    let _e177 = e;
    gloss = ((smoothstep(0.2f, 0.4f, _e175) * (1f - smoothstep(0.4f, 0.7f, _e177))) * 0.3f);
    let _e182 = to;
    let _e184 = dark;
    let _e185 = amount;
    let _e189 = gloss;
    let _e190 = amount;
    let _e193 = to[3u];
    let _e196 = mix((_e182.xyz * (1f - (_e184 * _e185))), vec3<f32>(1f, 1f, 1f), vec3(((_e189 * _e190) * _e193)));
    to[0u] = _e196.x;
    to[1u] = _e196.y;
    to[2u] = _e196.z;
    let _e203 = from_;
    let _e204 = to;
    let _e205 = inside;
    return mix(_e203, _e204, vec4(_e205));
}

fn main_1() {
    var param_32: vec2<f32>;

    let _e77 = _uv_1;
    param_32 = _e77;
    let _e78 = transition((&param_32));
    _fragColor = _e78;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
