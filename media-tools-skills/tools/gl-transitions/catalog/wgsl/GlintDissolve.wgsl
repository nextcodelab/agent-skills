// GlintDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlintDissolve.glsl
// Author: gre
// License: MIT
// Description: The bright points of the outgoing image sparkle into crisp four-point star glints that swell and twinkle up to the cut, then shrink back into the highlights of the incoming image, which stays sharp
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    size: f32,
    threshold: f32,
    intensity: f32,
    diagonals: i32,
    rotation: f32,
    rainbow: f32,
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

fn spectrum(a: ptr<function, f32>) -> vec3<f32> {
    let _e75 = (*a);
    return (vec3(0.5f) + (cos(((vec3(_e75) + vec3<f32>(0f, 0.33f, 0.67f)) * 6.2831855f)) * 0.5f));
}

fn ray(d: ptr<function, vec2<f32>>, len: ptr<function, f32>, width: ptr<function, f32>) -> f32 {
    var a_1: f32;
    var fall: f32;
    var w: f32;

    let _e81 = (*d)[0u];
    let _e83 = (*len);
    a_1 = (abs(_e81) / _e83);
    let _e85 = a_1;
    if (_e85 >= 1f) {
        return 0f;
    }
    let _e87 = a_1;
    let _e89 = a_1;
    fall = ((1f - _e87) * (1f - _e89));
    let _e92 = (*width);
    let _e93 = a_1;
    w = (_e92 * (1f - (0.7f * _e93)));
    let _e97 = fall;
    let _e99 = (*d)[1u];
    let _e102 = (*d)[1u];
    let _e104 = w;
    let _e105 = w;
    return (_e97 * exp(((-(_e99) * _e102) / (_e104 * _e105))));
}

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e76 = (*v);
    v3_ = fract((_e76.xyx * 0.1031f));
    let _e80 = v3_;
    let _e81 = v3_;
    let _e86 = v3_;
    v3_ = (_e86 + vec3(dot(_e80, (_e81.yzx + vec3(33.33f)))));
    let _e90 = v3_[0u];
    let _e92 = v3_[1u];
    let _e95 = v3_[2u];
    return fract(((_e90 + _e92) * _e95));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e76 = (*uv)[0u];
    let _e78 = (*uv)[1u];
    let _e81 = textureSampleLevel(_to, _sampler, vec2<f32>(_e76, (1f - _e78)), 0f);
    return _e81;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e76 = (*uv_1)[0u];
    let _e78 = (*uv_1)[1u];
    let _e81 = textureSampleLevel(_from, _sampler, vec2<f32>(_e76, (1f - _e78)), 0f);
    return _e81;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var t: f32;
    var amount: f32;
    var m: f32;
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var fromColor: vec4<f32>;
    var param_2: vec2<f32>;
    var toColor: vec4<f32>;
    var param_3: vec2<f32>;
    var c: vec4<f32>;
    var base: vec3<f32>;
    var cell: f32;
    var ang: f32;
    var cs: vec2<f32>;
    var aspect: vec2<f32>;
    var o: vec2<f32>;
    var q: vec2<f32>;
    var home: vec2<f32>;
    var width_1: f32;
    var light: vec3<f32>;
    var k: i32;
    var fk: f32;
    var off: vec2<f32>;
    var local_1: f32;
    var local_2: f32;
    var id: vec2<f32>;
    var param_4: vec2<f32>;
    var h0_: f32;
    var param_5: vec2<f32>;
    var h1_: f32;
    var param_6: vec2<f32>;
    var h2_: f32;
    var param_7: vec2<f32>;
    var h3_: f32;
    var param_8: vec2<f32>;
    var center: vec2<f32>;
    var cw: vec2<f32>;
    var st: vec2<f32>;
    var turn: f32;
    var src: vec4<f32>;
    var local_3: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var lum: f32;
    var knee: f32;
    var b: f32;
    var twinkle: f32;
    var len_1: f32;
    var d_1: vec2<f32>;
    var r: f32;
    var star: f32;
    var param_11: vec2<f32>;
    var param_12: f32;
    var param_13: f32;
    var param_14: vec2<f32>;
    var param_15: f32;
    var param_16: f32;
    var e: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: f32;
    var param_19: f32;
    var param_20: vec2<f32>;
    var param_21: f32;
    var param_22: f32;
    var cr: f32;
    var along: f32;
    var hue: vec3<f32>;
    var param_23: f32;
    var col: vec3<f32>;
    var phi_502_: bool;
    var phi_509_: bool;
    var phi_516_: bool;

    let _e147 = uniforms.progress;
    p = _e147;
    let _e148 = p;
    t = (1f - abs(((2f * _e148) - 1f)));
    let _e153 = t;
    let _e154 = t;
    amount = (_e153 * (2f - _e154));
    let _e157 = p;
    m = smoothstep(0.42f, 0.58f, _e157);
    let _e159 = amount;
    if (_e159 <= 0f) {
        let _e161 = m;
        if (_e161 < 0.5f) {
            let _e163 = (*uv_2);
            param = _e163;
            let _e164 = getFromColor((&param));
            local = _e164;
        } else {
            let _e165 = (*uv_2);
            param_1 = _e165;
            let _e166 = getToColor((&param_1));
            local = _e166;
        }
        let _e167 = local;
        return _e167;
    }
    let _e168 = (*uv_2);
    param_2 = _e168;
    let _e169 = getFromColor((&param_2));
    fromColor = _e169;
    let _e170 = (*uv_2);
    param_3 = _e170;
    let _e171 = getToColor((&param_3));
    toColor = _e171;
    let _e172 = fromColor;
    let _e175 = fromColor[3u];
    let _e176 = (_e172.xyz * _e175);
    let _e178 = fromColor[3u];
    let _e183 = toColor;
    let _e186 = toColor[3u];
    let _e187 = (_e183.xyz * _e186);
    let _e189 = toColor[3u];
    let _e194 = m;
    c = mix(vec4<f32>(_e176.x, _e176.y, _e176.z, _e178), vec4<f32>(_e187.x, _e187.y, _e187.z, _e189), vec4(_e194));
    let _e198 = c[3u];
    if (_e198 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e200 = c;
    let _e203 = c[3u];
    base = (_e200.xyz / vec3(_e203));
    let _e207 = uniforms.size;
    cell = (_e207 / 6f);
    let _e210 = uniforms.rotation;
    ang = radians(_e210);
    let _e212 = ang;
    let _e214 = ang;
    cs = vec2<f32>(cos(_e212), sin(_e214));
    let _e218 = uniforms.ratio;
    aspect = vec2<f32>(_e218, 1f);
    let _e220 = (*uv_2);
    let _e223 = aspect;
    o = ((_e220 - vec2(0.5f)) * _e223);
    let _e226 = o[0u];
    let _e228 = cs[0u];
    let _e231 = o[1u];
    let _e233 = cs[1u];
    let _e237 = o[1u];
    let _e239 = cs[0u];
    let _e242 = o[0u];
    let _e244 = cs[1u];
    let _e248 = cell;
    q = (vec2<f32>(((_e226 * _e228) + (_e231 * _e233)), ((_e237 * _e239) - (_e242 * _e244))) / vec2(_e248));
    let _e251 = q;
    home = floor(_e251);
    let _e253 = cell;
    width_1 = min((0.0022f / _e253), 0.07f);
    light = vec3<f32>(0f, 0f, 0f);
    k = 0i;
    loop {
        let _e256 = k;
        if (_e256 < 29i) {
            let _e258 = k;
            fk = f32(_e258);
            off = vec2<f32>(0f, 0f);
            let _e260 = k;
            let _e262 = k;
            if ((_e260 >= 1i) && (_e262 <= 12i)) {
                let _e265 = fk;
                if (_e265 < 7f) {
                    let _e267 = fk;
                    local_1 = (_e267 - 7f);
                } else {
                    let _e269 = fk;
                    local_1 = (_e269 - 6f);
                }
                let _e271 = local_1;
                off = vec2<f32>(_e271, 0f);
            } else {
                let _e273 = k;
                let _e275 = k;
                if ((_e273 >= 13i) && (_e275 <= 24i)) {
                    let _e278 = fk;
                    if (_e278 < 19f) {
                        let _e280 = fk;
                        local_2 = (_e280 - 19f);
                    } else {
                        let _e282 = fk;
                        local_2 = (_e282 - 18f);
                    }
                    let _e284 = local_2;
                    off = vec2<f32>(0f, _e284);
                } else {
                    let _e286 = k;
                    if (_e286 >= 25i) {
                        let _e288 = fk;
                        let _e295 = fk;
                        off = vec2<f32>((((_e288 - (floor((_e288 / 2f)) * 2f)) * 2f) - 1f), select(1f, -1f, (_e295 < 27f)));
                    }
                }
            }
            let _e300 = off[0u];
            let _e303 = off[1u];
            let _e306 = amount;
            if (max(abs(_e300), abs(_e303)) > ((6f * _e306) + 1f)) {
                continue;
            }
            let _e310 = home;
            let _e311 = off;
            id = (_e310 + _e311);
            let _e313 = id;
            param_4 = (_e313 + vec2(89.5f));
            let _e316 = hash12((&param_4));
            if (_e316 > 0.55f) {
                continue;
            }
            let _e318 = id;
            param_5 = (_e318 + vec2(0.5f));
            let _e321 = hash12((&param_5));
            h0_ = _e321;
            let _e322 = id;
            param_6 = (_e322 + vec2(19.5f));
            let _e325 = hash12((&param_6));
            h1_ = _e325;
            let _e326 = id;
            param_7 = (_e326 + vec2(41.5f));
            let _e329 = hash12((&param_7));
            h2_ = _e329;
            let _e330 = id;
            param_8 = (_e330 + vec2(67.5f));
            let _e333 = hash12((&param_8));
            h3_ = _e333;
            let _e334 = id;
            let _e337 = h0_;
            let _e338 = h1_;
            center = ((_e334 + vec2(0.5f)) + ((vec2<f32>(_e337, _e338) - vec2(0.5f)) * 0.6f));
            let _e344 = center;
            let _e345 = cell;
            cw = (_e344 * _e345);
            let _e348 = cw[0u];
            let _e350 = cs[0u];
            let _e353 = cw[1u];
            let _e355 = cs[1u];
            let _e359 = cw[0u];
            let _e361 = cs[1u];
            let _e364 = cw[1u];
            let _e366 = cs[0u];
            let _e370 = aspect;
            st = ((vec2<f32>(((_e348 * _e350) - (_e353 * _e355)), ((_e359 * _e361) + (_e364 * _e366))) / _e370) + vec2(0.5f));
            let _e375 = st[0u];
            let _e376 = (_e375 < 0f);
            phi_502_ = _e376;
            if !(_e376) {
                let _e379 = st[0u];
                phi_502_ = (_e379 > 1f);
            }
            let _e382 = phi_502_;
            phi_509_ = _e382;
            if !(_e382) {
                let _e385 = st[1u];
                phi_509_ = (_e385 < 0f);
            }
            let _e388 = phi_509_;
            phi_516_ = _e388;
            if !(_e388) {
                let _e391 = st[1u];
                phi_516_ = (_e391 > 1f);
            }
            let _e394 = phi_516_;
            if _e394 {
                continue;
            }
            let _e395 = h3_;
            turn = (0.15f + (0.7f * _e395));
            let _e398 = m;
            let _e399 = turn;
            if (_e398 < _e399) {
                let _e401 = st;
                param_9 = _e401;
                let _e402 = getFromColor((&param_9));
                local_3 = _e402;
            } else {
                let _e403 = st;
                param_10 = _e403;
                let _e404 = getToColor((&param_10));
                local_3 = _e404;
            }
            let _e405 = local_3;
            src = _e405;
            let _e406 = src;
            let _e410 = src[3u];
            lum = (dot(_e406.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f)) * _e410);
            let _e413 = uniforms.threshold;
            let _e415 = uniforms.threshold;
            let _e418 = h2_;
            knee = (_e413 + ((0.8f * (1f - _e415)) * _e418));
            let _e421 = knee;
            let _e422 = knee;
            let _e424 = uniforms.threshold;
            let _e429 = lum;
            b = smoothstep(_e421, ((_e422 + (0.2f * (1f - _e424))) + 0.001f), _e429);
            let _e431 = b;
            if (_e431 <= 0f) {
                continue;
            }
            let _e433 = h2_;
            let _e434 = h0_;
            let _e436 = p;
            let _e443 = m;
            let _e444 = turn;
            twinkle = ((0.6f + (0.4f * sin((6.2831855f * (_e433 + ((1.5f + _e434) * _e436)))))) * smoothstep(0f, 0.12f, abs((_e443 - _e444))));
            let _e449 = amount;
            let _e451 = b;
            let _e455 = h1_;
            let _e457 = h1_;
            let _e461 = twinkle;
            len_1 = ((((6f * _e449) * (0.45f + (0.55f * _e451))) * (0.3f + ((0.7f * _e455) * _e457))) * (0.85f + (0.15f * _e461)));
            let _e465 = q;
            let _e466 = center;
            d_1 = (_e465 - _e466);
            let _e468 = d_1;
            r = length(_e468);
            let _e470 = d_1;
            param_11 = _e470;
            let _e471 = len_1;
            param_12 = _e471;
            let _e472 = width_1;
            param_13 = _e472;
            let _e473 = ray((&param_11), (&param_12), (&param_13));
            let _e474 = d_1;
            param_14 = _e474.yx;
            let _e476 = len_1;
            param_15 = _e476;
            let _e477 = width_1;
            param_16 = _e477;
            let _e478 = ray((&param_14), (&param_15), (&param_16));
            star = (_e473 + _e478);
            let _e481 = uniforms.diagonals;
            if (_e481 != 0i) {
                let _e484 = d_1[0u];
                let _e486 = d_1[1u];
                let _e489 = d_1[0u];
                let _e491 = d_1[1u];
                e = (vec2<f32>((_e484 + _e486), (_e489 - _e491)) * 0.70710677f);
                let _e495 = len_1;
                let _e497 = e;
                param_17 = _e497;
                param_18 = (0.25f * _e495);
                let _e498 = width_1;
                param_19 = _e498;
                let _e499 = ray((&param_17), (&param_18), (&param_19));
                let _e500 = len_1;
                let _e502 = e;
                param_20 = _e502.yx;
                param_21 = (0.25f * _e500);
                let _e504 = width_1;
                param_22 = _e504;
                let _e505 = ray((&param_20), (&param_21), (&param_22));
                let _e508 = star;
                star = (_e508 + (0.5f * (_e499 + _e505)));
            }
            let _e510 = r;
            let _e511 = len_1;
            cr = (_e510 / (0.08f * _e511));
            let _e514 = cr;
            let _e516 = cr;
            let _e519 = r;
            let _e525 = star;
            star = (_e525 + (exp((-(_e514) * _e516)) + (0.3f * exp((-(_e519) / 0.2f)))));
            let _e527 = r;
            let _e528 = len_1;
            along = (_e527 / _e528);
            let _e530 = along;
            let _e532 = h0_;
            param_23 = ((1.3f * _e530) + _e532);
            let _e534 = spectrum((&param_23));
            let _e536 = uniforms.rainbow;
            let _e537 = along;
            hue = mix(vec3<f32>(1f, 1f, 1f), _e534, vec3((_e536 * smoothstep(0.05f, 0.4f, _e537))));
            let _e542 = src;
            let _e545 = src[0u];
            let _e547 = src[1u];
            let _e549 = src[2u];
            col = mix((_e542.xyz / vec3(max(max(_e545, max(_e547, _e549)), 0.001f))), vec3<f32>(1f, 1f, 1f), vec3(0.6f));
            let _e557 = b;
            let _e558 = twinkle;
            let _e560 = star;
            let _e562 = hue;
            let _e564 = col;
            let _e566 = light;
            light = (_e566 + ((_e562 * ((_e557 * _e558) * _e560)) * _e564));
            continue;
        } else {
            break;
        }
        continuing {
            let _e568 = k;
            k = (_e568 + 1i);
        }
    }
    let _e571 = uniforms.tint;
    let _e573 = uniforms.intensity;
    let _e575 = amount;
    let _e577 = amount;
    let _e579 = light;
    light = (_e579 * (((_e571 * _e573) * _e575) * _e577));
    let _e581 = light;
    light = (vec3(1f) - exp(-(_e581)));
    let _e586 = base;
    let _e587 = light;
    let _e589 = base;
    let _e590 = light;
    let _e595 = clamp(((_e586 + _e587) - (_e589 * _e590)), vec3(0f), vec3(1f));
    let _e597 = c[3u];
    return vec4<f32>(_e595.x, _e595.y, _e595.z, _e597);
}

fn main_1() {
    var param_24: vec2<f32>;

    let _e75 = _uv_1;
    param_24 = _e75;
    let _e76 = transition((&param_24));
    _fragColor = _e76;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
