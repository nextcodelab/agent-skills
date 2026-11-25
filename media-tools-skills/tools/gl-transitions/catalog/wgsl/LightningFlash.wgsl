// LightningFlash — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightningFlash.glsl
// Author: gre
// License: MIT
// Description: Forked lightning bolts crack down from the top of the frame, the screen flashes white in a few stuttering strobes, and the incoming image appears lit by the last flickers as they fade out
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    bolts: i32,
    strike: f32,
    seed: f32,
    color: vec3<f32>,
    glow: f32,
    flashes: i32,
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
    let _e85 = (*uv)[0u];
    let _e87 = (*uv)[1u];
    let _e90 = textureSampleLevel(_to, _sampler, vec2<f32>(_e85, (1f - _e87)), 0f);
    return _e90;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e85 = (*uv_1)[0u];
    let _e87 = (*uv_1)[1u];
    let _e90 = textureSampleLevel(_from, _sampler, vec2<f32>(_e85, (1f - _e87)), 0f);
    return _e90;
}

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e85 = (*p);
    p3_ = fract((_e85.xyx * 0.1031f));
    let _e89 = p3_;
    let _e90 = p3_;
    let _e95 = p3_;
    p3_ = (_e95 + vec3(dot(_e89, (_e90.yzx + vec3(33.33f)))));
    let _e99 = p3_[0u];
    let _e101 = p3_[1u];
    let _e104 = p3_[2u];
    return fract(((_e99 + _e101) * _e104));
}

fn jag(s: ptr<function, f32>, k: ptr<function, f32>) -> f32 {
    var i: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e88 = (*s);
    i = floor(_e88);
    let _e90 = i;
    let _e91 = (*k);
    param = vec2<f32>(_e90, _e91);
    let _e93 = hash((&param));
    let _e94 = i;
    let _e96 = (*k);
    param_1 = vec2<f32>((_e94 + 1f), _e96);
    let _e98 = hash((&param_1));
    let _e99 = (*s);
    return (mix(_e93, _e98, fract(_e99)) - 0.5f);
}

fn zigzag(y: ptr<function, f32>, k_1: ptr<function, f32>) -> f32 {
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;

    let _e94 = uniforms.ratio;
    let _e96 = (*y);
    param_2 = (_e96 * 5f);
    let _e98 = (*k_1);
    param_3 = _e98;
    let _e99 = jag((&param_2), (&param_3));
    let _e101 = (*y);
    let _e103 = (*k_1);
    param_4 = (_e101 * 13f);
    param_5 = (_e103 + 1f);
    let _e105 = jag((&param_4), (&param_5));
    let _e108 = (*y);
    let _e110 = (*k_1);
    param_6 = (_e108 * 31f);
    param_7 = (_e110 + 2f);
    let _e112 = jag((&param_6), (&param_7));
    let _e115 = (*y);
    let _e117 = (*k_1);
    param_8 = (_e115 * 67f);
    param_9 = (_e117 + 3f);
    let _e119 = jag((&param_8), (&param_9));
    return (min(_e94, 1f) * ((((0.15f * _e99) + (0.06f * _e105)) + (0.03f * _e112)) + (0.012f * _e119)));
}

fn branchX(y_1: ptr<function, f32>, xb: ptr<function, f32>, yb: ptr<function, f32>, zb: ptr<function, f32>, dir: ptr<function, f32>, k_2: ptr<function, f32>) -> f32 {
    var param_10: f32;
    var param_11: f32;

    let _e91 = (*xb);
    let _e92 = (*dir);
    let _e93 = (*yb);
    let _e94 = (*y_1);
    let _e98 = (*y_1);
    param_10 = _e98;
    let _e99 = (*k_2);
    param_11 = _e99;
    let _e100 = zigzag((&param_10), (&param_11));
    let _e101 = (*zb);
    return ((_e91 + (_e92 * (_e93 - _e94))) + (0.6f * (_e100 - _e101)));
}

fn curveDist(q: ptr<function, vec2<f32>>, x: ptr<function, f32>, slope: ptr<function, f32>, outside: ptr<function, f32>) -> f32 {
    var dx: f32;
    var d: f32;

    let _e90 = (*q)[0u];
    let _e91 = (*x);
    dx = abs((_e90 - _e91));
    let _e94 = dx;
    let _e95 = (*slope);
    let _e96 = (*slope);
    let _e100 = dx;
    d = (_e94 * mix(inverseSqrt((1f + (_e95 * _e96))), 1f, smoothstep(0f, 0.08f, _e100)));
    let _e104 = d;
    let _e105 = (*outside);
    return length(vec2<f32>(_e104, max(_e105, 0f)));
}

fn boltX(y_2: ptr<function, f32>, x0_: ptr<function, f32>, x1_: ptr<function, f32>, y1_: ptr<function, f32>, z0_: ptr<function, f32>, z1_: ptr<function, f32>, k_3: ptr<function, f32>) -> f32 {
    var t: f32;
    var param_12: f32;
    var param_13: f32;

    let _e93 = (*y_2);
    let _e95 = (*y1_);
    t = ((1f - _e93) / (1f - _e95));
    let _e98 = (*x0_);
    let _e99 = (*z0_);
    let _e101 = (*x1_);
    let _e102 = (*z1_);
    let _e104 = t;
    let _e106 = (*y_2);
    param_12 = _e106;
    let _e107 = (*k_3);
    param_13 = _e107;
    let _e108 = zigzag((&param_12), (&param_13));
    return (mix((_e98 - _e99), (_e101 - _e102), _e104) + _e108);
}

fn pulse(p_1: ptr<function, f32>, t0_: ptr<function, f32>, hold: ptr<function, f32>, decay: ptr<function, f32>) -> f32 {
    var x_1: f32;

    let _e88 = (*p_1);
    let _e89 = (*t0_);
    x_1 = (_e88 - _e89);
    let _e91 = x_1;
    if (_e91 < 0f) {
        let _e93 = x_1;
        return smoothstep(-0.012f, 0f, _e93);
    }
    let _e95 = x_1;
    let _e96 = (*hold);
    let _e100 = (*decay);
    return exp((-(max((_e95 - _e96), 0f)) / _e100));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_2: f32;
    var q_1: vec2<f32>;
    var k0_: f32;
    var nb: i32;
    var local: i32;
    var local_1: i32;
    var nf: i32;
    var local_2: i32;
    var local_3: i32;
    var cut: i32;
    var flash: f32;
    var lit: f32;
    var tCut: f32;
    var tLast: f32;
    var t_1: f32;
    var i_1: i32;
    var isCut: bool;
    var amp: f32;
    var local_4: f32;
    var local_5: f32;
    var s_1: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: vec2<f32>;
    var stutter: f32;
    var param_23: vec2<f32>;
    var whiteout: f32;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;
    var param_27: f32;
    var tail: f32;
    var local_6: f32;
    var param_28: vec2<f32>;
    var grow: f32;
    var faint: f32;
    var param_29: vec2<f32>;
    var boltLight: f32;
    var local_7: f32;
    var core: f32;
    var halo: f32;
    var near: f32;
    var lightsOn: bool;
    var b: i32;
    var fb: f32;
    var kb: f32;
    var x1_1: f32;
    var y1_1: f32;
    var bright: f32;
    var roomy: f32;
    var cramped: bool;
    var side: f32;
    var local_8: f32;
    var dist: f32;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;
    var x0_1: f32;
    var param_32: vec2<f32>;
    var tip: f32;
    var e: f32;
    var z0_1: f32;
    var param_33: f32;
    var param_34: f32;
    var z1_1: f32;
    var param_35: f32;
    var param_36: f32;
    var x_2: f32;
    var param_37: f32;
    var param_38: f32;
    var param_39: f32;
    var param_40: f32;
    var param_41: f32;
    var param_42: f32;
    var param_43: f32;
    var slope_1: f32;
    var param_44: f32;
    var param_45: f32;
    var param_46: f32;
    var param_47: f32;
    var param_48: f32;
    var param_49: f32;
    var param_50: f32;
    var param_51: f32;
    var param_52: f32;
    var param_53: f32;
    var param_54: f32;
    var param_55: f32;
    var param_56: f32;
    var param_57: f32;
    var d_1: f32;
    var param_58: vec2<f32>;
    var param_59: f32;
    var param_60: f32;
    var param_61: f32;
    var w: f32;
    var j: i32;
    var fj: f32;
    var kj: f32;
    var tb: f32;
    var param_62: vec2<f32>;
    var yb_1: f32;
    var len: f32;
    var param_63: vec2<f32>;
    var dir_1: f32;
    var param_64: vec2<f32>;
    var xb_1: f32;
    var param_65: f32;
    var param_66: f32;
    var param_67: f32;
    var param_68: f32;
    var param_69: f32;
    var param_70: f32;
    var param_71: f32;
    var zb_1: f32;
    var param_72: f32;
    var param_73: f32;
    var bx: f32;
    var param_74: f32;
    var param_75: f32;
    var param_76: f32;
    var param_77: f32;
    var param_78: f32;
    var param_79: f32;
    var bs: f32;
    var param_80: f32;
    var param_81: f32;
    var param_82: f32;
    var param_83: f32;
    var param_84: f32;
    var param_85: f32;
    var param_86: f32;
    var param_87: f32;
    var param_88: f32;
    var param_89: f32;
    var param_90: f32;
    var param_91: f32;
    var bd: f32;
    var param_92: vec2<f32>;
    var param_93: f32;
    var param_94: f32;
    var param_95: f32;
    var along: f32;
    var fade: f32;
    var bw: f32;
    var m: f32;
    var c: vec4<f32>;
    var a: vec4<f32>;
    var param_96: vec2<f32>;
    var a_1: vec4<f32>;
    var param_97: vec2<f32>;
    var col: vec3<f32>;
    var live: f32;
    var dim: f32;
    var f: f32;
    var g: f32;
    var light: vec3<f32>;

    let _e247 = uniforms.progress;
    p_2 = _e247;
    let _e249 = (*uv_2)[0u];
    let _e251 = uniforms.ratio;
    let _e254 = (*uv_2)[1u];
    q_1 = vec2<f32>((_e249 * _e251), _e254);
    let _e257 = uniforms.seed;
    k0_ = (floor(_e257) * 61f);
    let _e261 = uniforms.bolts;
    if (_e261 < 1i) {
        local = 1i;
    } else {
        let _e264 = uniforms.bolts;
        if (_e264 > 3i) {
            local_1 = 3i;
        } else {
            let _e267 = uniforms.bolts;
            local_1 = _e267;
        }
        let _e268 = local_1;
        local = _e268;
    }
    let _e269 = local;
    nb = _e269;
    let _e271 = uniforms.flashes;
    if (_e271 < 1i) {
        local_2 = 1i;
    } else {
        let _e274 = uniforms.flashes;
        if (_e274 > 4i) {
            local_3 = 4i;
        } else {
            let _e277 = uniforms.flashes;
            local_3 = _e277;
        }
        let _e278 = local_3;
        local_2 = _e278;
    }
    let _e279 = local_2;
    nf = _e279;
    let _e280 = nf;
    cut = select(0i, 1i, (_e280 > 1i));
    flash = 0f;
    lit = 0f;
    tCut = 0.3f;
    tLast = 0.3f;
    t_1 = 0.3f;
    i_1 = 0i;
    loop {
        let _e283 = i_1;
        if (_e283 < 4i) {
            let _e285 = i_1;
            let _e286 = nf;
            if (_e285 < _e286) {
                let _e288 = i_1;
                let _e289 = cut;
                isCut = (_e288 == _e289);
                let _e291 = isCut;
                if _e291 {
                    local_4 = 1f;
                } else {
                    let _e292 = i_1;
                    let _e293 = cut;
                    if (_e292 < _e293) {
                        local_5 = 0.55f;
                    } else {
                        let _e295 = i_1;
                        let _e296 = cut;
                        local_5 = (0.7f * pow(0.75f, f32(((_e295 - _e296) - 1i))));
                    }
                    let _e302 = local_5;
                    local_4 = _e302;
                }
                let _e303 = local_4;
                amp = _e303;
                let _e304 = amp;
                let _e305 = isCut;
                let _e307 = isCut;
                let _e309 = p_2;
                param_14 = _e309;
                let _e310 = t_1;
                param_15 = _e310;
                param_16 = select(0.004f, 0.025f, _e305);
                param_17 = select(0.022f, 0.03f, _e307);
                let _e311 = pulse((&param_14), (&param_15), (&param_16), (&param_17));
                s_1 = (_e304 * _e311);
                let _e313 = flash;
                let _e314 = s_1;
                flash = max(_e313, _e314);
                let _e316 = lit;
                let _e317 = p_2;
                param_18 = _e317;
                let _e318 = t_1;
                param_19 = _e318;
                param_20 = 0.01f;
                param_21 = 0.045f;
                let _e319 = pulse((&param_18), (&param_19), (&param_20), (&param_21));
                lit = max(_e316, _e319);
                let _e321 = isCut;
                if _e321 {
                    let _e322 = t_1;
                    tCut = _e322;
                }
                let _e323 = t_1;
                tLast = _e323;
                let _e324 = isCut;
                let _e326 = i_1;
                let _e328 = k0_;
                param_22 = vec2<f32>(f32(_e326), (_e328 + 5f));
                let _e331 = hash((&param_22));
                let _e334 = t_1;
                t_1 = (_e334 + (select(0.08f, 0.12f, _e324) + (0.04f * _e331)));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e336 = i_1;
            i_1 = (_e336 + 1i);
        }
    }
    let _e338 = p_2;
    let _e341 = k0_;
    param_23 = vec2<f32>(floor((_e338 * 70f)), (_e341 + 9f));
    let _e344 = hash((&param_23));
    stutter = mix(0.7f, 1f, _e344);
    let _e346 = stutter;
    let _e347 = flash;
    flash = (_e347 * _e346);
    let _e349 = p_2;
    param_24 = _e349;
    let _e350 = tCut;
    param_25 = _e350;
    param_26 = 0.025f;
    param_27 = 0.02f;
    let _e351 = pulse((&param_24), (&param_25), (&param_26), (&param_27));
    whiteout = _e351;
    let _e352 = p_2;
    let _e353 = tLast;
    if (_e352 > _e353) {
        let _e355 = p_2;
        let _e356 = tLast;
        let _e361 = p_2;
        let _e362 = tLast;
        local_6 = (exp((-((_e355 - _e356)) / 0.1f)) * smoothstep(0.03f, 0.06f, (_e361 - _e362)));
    } else {
        local_6 = 0f;
    }
    let _e366 = local_6;
    tail = _e366;
    let _e367 = flash;
    let _e368 = tail;
    let _e370 = p_2;
    let _e373 = k0_;
    param_28 = vec2<f32>(floor((_e370 * 40f)), (_e373 + 13f));
    let _e376 = hash((&param_28));
    flash = max(_e367, ((0.35f * _e368) * step(0.45f, _e376)));
    let _e380 = p_2;
    grow = clamp((_e380 / 0.3f), 0f, 1f);
    let _e383 = grow;
    let _e386 = grow;
    grow = ((floor((_e383 * 7f)) + smoothstep(0f, 1f, fract((_e386 * 7f)))) / 7f);
    let _e392 = p_2;
    let _e395 = k0_;
    param_29 = vec2<f32>(floor((_e392 * 50f)), (_e395 + 11f));
    let _e398 = hash((&param_29));
    faint = (0.5f * mix(0.6f, 1f, _e398));
    let _e401 = p_2;
    if (_e401 < 0.3f) {
        let _e403 = faint;
        let _e404 = p_2;
        local_7 = (_e403 * smoothstep(0f, 0.06f, _e404));
    } else {
        let _e407 = lit;
        let _e408 = stutter;
        let _e410 = faint;
        let _e411 = p_2;
        local_7 = max((_e407 * _e408), (_e410 * exp((-((_e411 - 0.3f)) / 0.12f))));
    }
    let _e418 = local_7;
    boltLight = _e418;
    let _e419 = boltLight;
    let _e420 = flash;
    let _e422 = tail;
    boltLight = max(_e419, ((0.6f * _e420) * _e422));
    let _e425 = tLast;
    let _e427 = tLast;
    let _e429 = p_2;
    let _e432 = boltLight;
    boltLight = (_e432 * (1f - smoothstep((_e425 + 0.1f), (_e427 + 0.3f), _e429)));
    core = 0f;
    halo = 0f;
    near = 10f;
    let _e434 = boltLight;
    let _e436 = flash;
    lightsOn = ((_e434 > 0f) || (_e436 > 0f));
    b = 0i;
    loop {
        let _e439 = b;
        if (_e439 < 3i) {
            let _e441 = b;
            let _e442 = nb;
            let _e444 = lightsOn;
            if ((_e441 < _e442) && _e444) {
                let _e446 = b;
                fb = f32(_e446);
                let _e448 = k0_;
                let _e449 = fb;
                kb = (_e448 + (_e449 * 17f));
                let _e453 = uniforms.strike;
                let _e455 = uniforms.ratio;
                x1_1 = (_e453 * _e455);
                y1_1 = -0.05f;
                bright = 1f;
                let _e457 = b;
                if (_e457 > 0i) {
                    let _e460 = uniforms.strike;
                    roomy = select(-1f, 1f, (_e460 < 0.5f));
                    let _e464 = uniforms.strike;
                    let _e466 = uniforms.strike;
                    cramped = (min(_e464, (1f - _e466)) < 0.25f);
                    let _e470 = b;
                    let _e472 = cramped;
                    if ((_e470 == 1i) || _e472) {
                        let _e474 = roomy;
                        local_8 = _e474;
                    } else {
                        let _e475 = roomy;
                        local_8 = -(_e475);
                    }
                    let _e477 = local_8;
                    side = _e477;
                    let _e478 = b;
                    let _e480 = cramped;
                    dist = select(0.22f, 0.5f, ((_e478 == 2i) && _e480));
                    let _e483 = x1_1;
                    let _e484 = side;
                    let _e486 = uniforms.ratio;
                    let _e488 = dist;
                    let _e489 = fb;
                    let _e490 = kb;
                    param_30 = vec2<f32>(_e489, _e490);
                    let _e492 = hash((&param_30));
                    let _e498 = uniforms.ratio;
                    let _e501 = uniforms.ratio;
                    x1_1 = clamp((_e483 + ((_e484 * _e486) * (_e488 + (0.12f * _e492)))), (0.08f * _e498), (0.92f * _e501));
                    let _e504 = fb;
                    let _e505 = kb;
                    param_31 = vec2<f32>(_e504, (_e505 + 1f));
                    let _e508 = hash((&param_31));
                    y1_1 = (0.25f + (0.25f * _e508));
                    bright = 0.7f;
                }
                let _e511 = x1_1;
                let _e512 = fb;
                let _e513 = kb;
                param_32 = vec2<f32>(_e512, (_e513 + 2f));
                let _e516 = hash((&param_32));
                let _e520 = uniforms.ratio;
                let _e525 = uniforms.ratio;
                let _e528 = uniforms.ratio;
                x0_1 = clamp((_e511 + (((_e516 - 0.5f) * 0.5f) * min(_e520, 1f))), (0.1f * _e525), (0.9f * _e528));
                let _e531 = y1_1;
                let _e532 = grow;
                tip = mix(1.02f, _e531, _e532);
                e = 0.01f;
                param_33 = 1f;
                let _e534 = kb;
                param_34 = _e534;
                let _e535 = zigzag((&param_33), (&param_34));
                z0_1 = _e535;
                let _e536 = y1_1;
                param_35 = _e536;
                let _e537 = kb;
                param_36 = _e537;
                let _e538 = zigzag((&param_35), (&param_36));
                z1_1 = _e538;
                let _e540 = q_1[1u];
                param_37 = _e540;
                let _e541 = x0_1;
                param_38 = _e541;
                let _e542 = x1_1;
                param_39 = _e542;
                let _e543 = y1_1;
                param_40 = _e543;
                let _e544 = z0_1;
                param_41 = _e544;
                let _e545 = z1_1;
                param_42 = _e545;
                let _e546 = kb;
                param_43 = _e546;
                let _e547 = boltX((&param_37), (&param_38), (&param_39), (&param_40), (&param_41), (&param_42), (&param_43));
                x_2 = _e547;
                let _e549 = q_1[1u];
                let _e550 = e;
                param_44 = (_e549 + _e550);
                let _e552 = x0_1;
                param_45 = _e552;
                let _e553 = x1_1;
                param_46 = _e553;
                let _e554 = y1_1;
                param_47 = _e554;
                let _e555 = z0_1;
                param_48 = _e555;
                let _e556 = z1_1;
                param_49 = _e556;
                let _e557 = kb;
                param_50 = _e557;
                let _e558 = boltX((&param_44), (&param_45), (&param_46), (&param_47), (&param_48), (&param_49), (&param_50));
                let _e560 = q_1[1u];
                let _e561 = e;
                param_51 = (_e560 - _e561);
                let _e563 = x0_1;
                param_52 = _e563;
                let _e564 = x1_1;
                param_53 = _e564;
                let _e565 = y1_1;
                param_54 = _e565;
                let _e566 = z0_1;
                param_55 = _e566;
                let _e567 = z1_1;
                param_56 = _e567;
                let _e568 = kb;
                param_57 = _e568;
                let _e569 = boltX((&param_51), (&param_52), (&param_53), (&param_54), (&param_55), (&param_56), (&param_57));
                let _e571 = e;
                slope_1 = ((_e558 - _e569) / (2f * _e571));
                let _e574 = y1_1;
                let _e575 = tip;
                let _e578 = q_1[1u];
                let _e581 = q_1[1u];
                let _e584 = q_1;
                param_58 = _e584;
                let _e585 = x_2;
                param_59 = _e585;
                let _e586 = slope_1;
                param_60 = _e586;
                param_61 = max((max(_e574, _e575) - _e578), (_e581 - 1.05f));
                let _e587 = curveDist((&param_58), (&param_59), (&param_60), (&param_61));
                d_1 = _e587;
                let _e588 = near;
                let _e589 = d_1;
                near = min(_e588, _e589);
                let _e591 = fb;
                w = (0.003f * mix(1f, 0.7f, (_e591 / 2f)));
                let _e595 = bright;
                let _e596 = d_1;
                let _e598 = d_1;
                let _e600 = w;
                let _e601 = w;
                let _e606 = core;
                core = (_e606 + (_e595 * exp(((-(_e596) * _e598) / (_e600 * _e601)))));
                let _e608 = bright;
                let _e609 = d_1;
                let _e614 = d_1;
                let _e621 = halo;
                halo = (_e621 + (_e608 * ((0.7f * exp((-(_e609) * 24f))) + (0.25f * exp((-(_e614) * 6f))))));
                j = 0i;
                loop {
                    let _e623 = j;
                    if (_e623 < 3i) {
                        let _e625 = j;
                        fj = f32(_e625);
                        let _e627 = kb;
                        let _e629 = fj;
                        kj = ((_e627 + 3f) + (_e629 * 5f));
                        let _e632 = fj;
                        let _e635 = fj;
                        let _e636 = kj;
                        param_62 = vec2<f32>(_e635, _e636);
                        let _e638 = hash((&param_62));
                        tb = ((0.12f + (0.2f * _e632)) + (0.15f * _e638));
                        let _e641 = y1_1;
                        let _e642 = tb;
                        yb_1 = mix(1f, _e641, _e642);
                        let _e644 = fj;
                        let _e645 = kj;
                        param_63 = vec2<f32>(_e644, (_e645 + 1f));
                        let _e648 = hash((&param_63));
                        let _e651 = tb;
                        let _e654 = y1_1;
                        len = (((0.3f + (0.25f * _e648)) * (1f - _e651)) * (1f - _e654));
                        let _e657 = j;
                        let _e660 = fj;
                        let _e661 = kj;
                        param_64 = vec2<f32>(_e660, (_e661 + 2f));
                        let _e664 = hash((&param_64));
                        let _e669 = uniforms.ratio;
                        dir_1 = ((select(1f, -1f, (_e657 == 1i)) * (0.2f + (0.45f * _e664))) * min(_e669, 1f));
                        let _e672 = yb_1;
                        param_65 = _e672;
                        let _e673 = x0_1;
                        param_66 = _e673;
                        let _e674 = x1_1;
                        param_67 = _e674;
                        let _e675 = y1_1;
                        param_68 = _e675;
                        let _e676 = z0_1;
                        param_69 = _e676;
                        let _e677 = z1_1;
                        param_70 = _e677;
                        let _e678 = kb;
                        param_71 = _e678;
                        let _e679 = boltX((&param_65), (&param_66), (&param_67), (&param_68), (&param_69), (&param_70), (&param_71));
                        xb_1 = _e679;
                        let _e680 = yb_1;
                        param_72 = _e680;
                        let _e681 = kj;
                        param_73 = _e681;
                        let _e682 = zigzag((&param_72), (&param_73));
                        zb_1 = _e682;
                        let _e684 = q_1[1u];
                        param_74 = _e684;
                        let _e685 = xb_1;
                        param_75 = _e685;
                        let _e686 = yb_1;
                        param_76 = _e686;
                        let _e687 = zb_1;
                        param_77 = _e687;
                        let _e688 = dir_1;
                        param_78 = _e688;
                        let _e689 = kj;
                        param_79 = _e689;
                        let _e690 = branchX((&param_74), (&param_75), (&param_76), (&param_77), (&param_78), (&param_79));
                        bx = _e690;
                        let _e692 = q_1[1u];
                        let _e693 = e;
                        param_80 = (_e692 + _e693);
                        let _e695 = xb_1;
                        param_81 = _e695;
                        let _e696 = yb_1;
                        param_82 = _e696;
                        let _e697 = zb_1;
                        param_83 = _e697;
                        let _e698 = dir_1;
                        param_84 = _e698;
                        let _e699 = kj;
                        param_85 = _e699;
                        let _e700 = branchX((&param_80), (&param_81), (&param_82), (&param_83), (&param_84), (&param_85));
                        let _e702 = q_1[1u];
                        let _e703 = e;
                        param_86 = (_e702 - _e703);
                        let _e705 = xb_1;
                        param_87 = _e705;
                        let _e706 = yb_1;
                        param_88 = _e706;
                        let _e707 = zb_1;
                        param_89 = _e707;
                        let _e708 = dir_1;
                        param_90 = _e708;
                        let _e709 = kj;
                        param_91 = _e709;
                        let _e710 = branchX((&param_86), (&param_87), (&param_88), (&param_89), (&param_90), (&param_91));
                        let _e712 = e;
                        bs = ((_e700 - _e710) / (2f * _e712));
                        let _e715 = yb_1;
                        let _e716 = len;
                        let _e718 = tip;
                        let _e721 = q_1[1u];
                        let _e724 = q_1[1u];
                        let _e725 = yb_1;
                        let _e728 = q_1;
                        param_92 = _e728;
                        let _e729 = bx;
                        param_93 = _e729;
                        let _e730 = bs;
                        param_94 = _e730;
                        param_95 = max((max((_e715 - _e716), _e718) - _e721), (_e724 - _e725));
                        let _e731 = curveDist((&param_92), (&param_93), (&param_94), (&param_95));
                        bd = _e731;
                        let _e732 = near;
                        let _e733 = bd;
                        near = min(_e732, _e733);
                        let _e735 = yb_1;
                        let _e737 = q_1[1u];
                        let _e739 = len;
                        along = clamp(((_e735 - _e737) / _e739), 0f, 1f);
                        let _e742 = bright;
                        let _e743 = along;
                        fade = (_e742 * (1f - (0.8f * _e743)));
                        let _e747 = w;
                        let _e748 = along;
                        bw = (_e747 * mix(0.8f, 0.4f, _e748));
                        let _e751 = fade;
                        let _e752 = bd;
                        let _e754 = bd;
                        let _e756 = bw;
                        let _e757 = bw;
                        let _e762 = core;
                        core = (_e762 + (_e751 * exp(((-(_e752) * _e754) / (_e756 * _e757)))));
                        let _e764 = fade;
                        let _e766 = bd;
                        let _e771 = bd;
                        let _e778 = halo;
                        halo = (_e778 + ((_e764 * 0.6f) * ((0.7f * exp((-(_e766) * 24f))) + (0.25f * exp((-(_e771) * 6f))))));
                        continue;
                    } else {
                        break;
                    }
                    continuing {
                        let _e780 = j;
                        j = (_e780 + 1i);
                    }
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e782 = b;
            b = (_e782 + 1i);
        }
    }
    let _e784 = tCut;
    let _e785 = tCut;
    let _e787 = p_2;
    m = smoothstep(_e784, (_e785 + 0.025f), _e787);
    c = vec4<f32>(0f, 0f, 0f, 0f);
    let _e789 = m;
    if (_e789 < 1f) {
        let _e791 = (*uv_2);
        param_96 = _e791;
        let _e792 = getFromColor((&param_96));
        a = _e792;
        let _e793 = m;
        let _e795 = a;
        let _e798 = a[3u];
        let _e799 = (_e795.xyz * _e798);
        let _e801 = a[3u];
        let _e807 = c;
        c = (_e807 + (vec4<f32>(_e799.x, _e799.y, _e799.z, _e801) * (1f - _e793)));
    }
    let _e809 = m;
    if (_e809 > 0f) {
        let _e811 = (*uv_2);
        param_97 = _e811;
        let _e812 = getToColor((&param_97));
        a_1 = _e812;
        let _e813 = m;
        let _e814 = a_1;
        let _e817 = a_1[3u];
        let _e818 = (_e814.xyz * _e817);
        let _e820 = a_1[3u];
        let _e826 = c;
        c = (_e826 + (vec4<f32>(_e818.x, _e818.y, _e818.z, _e820) * _e813));
    }
    let _e829 = c[3u];
    if (_e829 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e831 = c;
    let _e834 = c[3u];
    col = (_e831.xyz / vec3(_e834));
    let _e837 = p_2;
    let _e839 = p_2;
    live = (smoothstep(0f, 0.03f, _e837) * (1f - smoothstep(0.85f, 1f, _e839)));
    let _e843 = p_2;
    let _e846 = tCut;
    let _e847 = tLast;
    let _e849 = p_2;
    dim = ((0.4f * smoothstep(0f, 0.3f, _e843)) * (1f - smoothstep(_e846, (_e847 + 0.15f), _e849)));
    let _e853 = flash;
    let _e854 = near;
    let _e860 = flash;
    f = (_e853 * mix((0.6f + (0.4f * exp((-(_e854) * 4f)))), 1f, smoothstep(0.6f, 1f, _e860)));
    let _e864 = dim;
    let _e865 = live;
    let _e868 = col;
    col = (_e868 * (1f - (_e864 * _e865)));
    let _e870 = col;
    let _e871 = f;
    let _e873 = live;
    let _e878 = uniforms.color;
    let _e879 = f;
    let _e881 = live;
    col = ((_e870 * (1f + ((2.5f * _e871) * _e873))) + (_e878 * ((1.1f * _e879) * _e881)));
    let _e886 = uniforms.glow;
    g = (0.4f + (1.2f * _e886));
    let _e890 = uniforms.color;
    let _e893 = core;
    let _e898 = uniforms.color;
    let _e899 = g;
    let _e901 = halo;
    light = (((mix(_e890, vec3<f32>(1f, 1f, 1f), vec3(0.75f)) * min(_e893, 1.5f)) * 1.6f) + ((_e898 * _e899) * _e901));
    let _e904 = light;
    let _e905 = boltLight;
    let _e907 = live;
    let _e909 = col;
    col = (_e909 + ((_e904 * _e905) * _e907));
    let _e911 = col;
    let _e912 = whiteout;
    let _e914 = live;
    col = mix(_e911, vec3<f32>(1f, 1f, 1f), vec3(((0.92f * _e912) * _e914)));
    let _e918 = col;
    let _e921 = clamp(_e918, vec3(0f), vec3(1f));
    let _e923 = c[3u];
    return vec4<f32>(_e921.x, _e921.y, _e921.z, _e923);
}

fn main_1() {
    var param_98: vec2<f32>;

    let _e84 = _uv_1;
    param_98 = _e84;
    let _e85 = transition((&param_98));
    _fragColor = _e85;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
