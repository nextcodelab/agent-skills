// WaveWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WaveWipe.glsl
// Author: gre
// License: MIT
// Description: A breaking wave crashes across the frame, its lip curling over in front of its face and throwing foam and spray ahead, its shadow darkening the outgoing image; the incoming image is left behind it, tinted and bent by the water, clearing as the wave passes
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    curl: f32,
    foam: f32,
    refraction: f32,
    water: vec4<f32>,
    foamColor: vec4<f32>,
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
    let _e88 = (*v);
    let _e89 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e88 - (floor((_e88 / _e89)) * _e89)))));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e89 = (*v_1);
    v3_ = fract((_e89.xyx * 0.1031f));
    let _e93 = v3_;
    let _e94 = v3_;
    let _e99 = v3_;
    v3_ = (_e99 + vec3(dot(_e93, (_e94.yzx + vec3(33.33f)))));
    let _e103 = v3_[0u];
    let _e105 = v3_[1u];
    let _e108 = v3_[2u];
    return fract(((_e103 + _e105) * _e108));
}

fn droplets(q: ptr<function, vec2<f32>>, cell: ptr<function, f32>, density: ptr<function, f32>, seed: ptr<function, f32>) -> f32 {
    var g: vec2<f32>;
    var id: vec2<f32>;
    var param: vec2<f32>;
    var r: f32;
    var param_1: vec2<f32>;
    var c: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var px: f32;

    let _e100 = (*q);
    let _e101 = (*cell);
    g = (_e100 / vec2(_e101));
    let _e104 = g;
    id = floor(_e104);
    let _e106 = id;
    let _e107 = (*seed);
    param = (_e106 + vec2(_e107));
    let _e110 = hash12((&param));
    let _e111 = (*density);
    if (_e110 >= _e111) {
        return 0f;
    }
    let _e113 = id;
    let _e114 = (*seed);
    param_1 = ((_e113 + vec2(_e114)) + vec2(4.7f));
    let _e119 = hash12((&param_1));
    r = (0.1f + (0.2f * _e119));
    let _e122 = id;
    let _e125 = r;
    let _e127 = id;
    let _e128 = (*seed);
    param_2 = ((_e127 + vec2(_e128)) + vec2(1.3f));
    let _e133 = hash12((&param_2));
    let _e134 = id;
    let _e135 = (*seed);
    param_3 = ((_e134 + vec2(_e135)) + vec2(8.1f));
    let _e140 = hash12((&param_3));
    c = ((_e122 + vec2(0.5f)) + (((vec2<f32>(_e133, _e140) * 2f) - vec2(1f)) * (0.45f - _e125)));
    let _e147 = (*cell);
    px = (0.002f / _e147);
    let _e149 = r;
    let _e150 = px;
    let _e152 = r;
    let _e153 = px;
    let _e155 = g;
    let _e156 = c;
    return (1f - smoothstep((_e149 - _e150), (_e152 + _e153), length((_e155 - _e156))));
}

fn vnoise(v_2: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;

    let _e94 = (*v_2);
    i = floor(_e94);
    let _e96 = (*v_2);
    f = fract(_e96);
    let _e98 = f;
    let _e99 = f;
    let _e101 = f;
    f = ((_e98 * _e99) * (vec2(3f) - (_e101 * 2f)));
    let _e106 = i;
    param_4 = _e106;
    let _e107 = hash12((&param_4));
    let _e108 = i;
    param_5 = (_e108 + vec2<f32>(1f, 0f));
    let _e110 = hash12((&param_5));
    let _e112 = f[0u];
    let _e114 = i;
    param_6 = (_e114 + vec2<f32>(0f, 1f));
    let _e116 = hash12((&param_6));
    let _e117 = i;
    param_7 = (_e117 + vec2<f32>(1f, 1f));
    let _e119 = hash12((&param_7));
    let _e121 = f[0u];
    let _e124 = f[1u];
    return mix(mix(_e107, _e110, _e112), mix(_e116, _e119, _e121), _e124);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e89 = (*uv)[0u];
    let _e91 = (*uv)[1u];
    let _e94 = textureSampleLevel(_to, _sampler, vec2<f32>(_e89, (1f - _e91)), 0f);
    return _e94;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e89 = (*uv_1)[0u];
    let _e91 = (*uv_1)[1u];
    let _e94 = textureSampleLevel(_from, _sampler, vec2<f32>(_e89, (1f - _e91)), 0f);
    return _e94;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var t: f32;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var up: vec2<f32>;
    var e: f32;
    var w: f32;
    var p: vec2<f32>;
    var q_1: vec2<f32>;
    var E: f32;
    var R: f32;
    var Rb: f32;
    var tipAngle: f32;
    var travel: f32;
    var C: vec2<f32>;
    var d: vec2<f32>;
    var r_1: f32;
    var ang: f32;
    var k: f32;
    var rIn: f32;
    var curled: bool;
    var s: f32;
    var face: f32;
    var behind: f32;
    var wet: f32;
    var local_1: f32;
    var lip: f32;
    var local_2: f32;
    var n: f32;
    var param_10: vec2<f32>;
    var a: vec4<f32>;
    var param_11: vec2<f32>;
    var gap: f32;
    var shade: f32;
    var fwd: f32;
    var zone: f32;
    var sq: vec2<f32>;
    var thin: f32;
    var spray: f32;
    var param_12: vec2<f32>;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;
    var mist: f32;
    var band: f32;
    var bend: f32;
    var off: vec2<f32>;
    var b: vec4<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var luma: f32;
    var tinted: vec3<f32>;
    var local_3: f32;
    var crest: f32;
    var local_4: f32;
    var churn: f32;
    var c_1: vec4<f32>;
    var local_5: vec4<f32>;
    var phi_308_: bool;
    var phi_309_: bool;

    let _e152 = uniforms.progress;
    if (_e152 <= 0f) {
        let _e154 = (*uv_2);
        param_8 = _e154;
        let _e155 = getFromColor((&param_8));
        return _e155;
    }
    let _e157 = uniforms.progress;
    if (_e157 >= 1f) {
        let _e159 = (*uv_2);
        param_9 = _e159;
        let _e160 = getToColor((&param_9));
        return _e160;
    }
    let _e162 = uniforms.progress;
    t = _e162;
    let _e164 = uniforms.direction;
    if (length(_e164) > 0f) {
        let _e168 = uniforms.direction;
        local = normalize(_e168);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e170 = local;
    dir = _e170;
    let _e172 = dir[1u];
    let _e175 = dir[0u];
    up = vec2<f32>(-(_e172), _e175);
    let _e178 = up[1u];
    let _e179 = (_e178 < 0f);
    phi_309_ = _e179;
    if !(_e179) {
        let _e182 = up[1u];
        let _e183 = (_e182 == 0f);
        phi_308_ = _e183;
        if _e183 {
            let _e185 = up[0u];
            phi_308_ = (_e185 > 0f);
        }
        let _e188 = phi_308_;
        phi_309_ = _e188;
    }
    let _e190 = phi_309_;
    if _e190 {
        let _e191 = up;
        up = -(_e191);
    }
    let _e194 = dir[0u];
    let _e197 = uniforms.ratio;
    let _e200 = dir[1u];
    e = (0.5f * ((abs(_e194) * _e197) + abs(_e200)));
    let _e205 = up[0u];
    let _e208 = uniforms.ratio;
    let _e211 = up[1u];
    w = (0.5f * ((abs(_e205) * _e208) + abs(_e211)));
    let _e215 = (*uv_2);
    let _e219 = uniforms.ratio;
    let _e222 = w;
    p = (((_e215 - vec2(0.5f)) * vec2<f32>(_e219, 1f)) / vec2((2f * _e222)));
    let _e226 = p;
    let _e227 = dir;
    let _e229 = p;
    let _e230 = up;
    q_1 = vec2<f32>(dot(_e226, _e227), (dot(_e229, _e230) + 0.5f));
    let _e234 = e;
    let _e235 = w;
    E = (_e234 / (2f * _e235));
    let _e239 = uniforms.curl;
    R = max(_e239, 0.01f);
    let _e241 = R;
    Rb = (0.5f * _e241);
    let _e243 = t;
    tipAngle = (3.1415927f * (0.08f - (0.5f * smoothstep(0f, 0.85f, _e243))));
    let _e248 = t;
    let _e249 = t;
    let _e250 = t;
    let _e252 = t;
    travel = mix(_e248, ((_e249 * _e250) * (3f - (2f * _e252))), 0.25f);
    let _e257 = E;
    let _e259 = R;
    let _e262 = E;
    let _e263 = Rb;
    let _e267 = travel;
    let _e269 = R;
    C = vec2<f32>(mix(((-(_e257) - _e259) - 0.25f), (((_e262 + _e263) + 0.35f) + 0.4f), _e267), (1.02f - _e269));
    let _e272 = q_1;
    let _e273 = C;
    d = (_e272 - _e273);
    let _e276 = d[0u];
    if (_e276 == 0f) {
        d[0u] = 0.000001f;
    }
    let _e279 = d;
    r_1 = length(_e279);
    let _e282 = d[1u];
    let _e284 = d[0u];
    ang = atan2(_e282, _e284);
    let _e286 = ang;
    let _e287 = tipAngle;
    let _e289 = tipAngle;
    k = clamp(((_e286 - _e287) / (3.1415927f - _e289)), 0f, 1f);
    let _e293 = R;
    let _e294 = R;
    let _e295 = Rb;
    let _e297 = k;
    let _e299 = k;
    rIn = (_e293 - ((_e294 - _e295) * (1f - ((1f - _e297) * (1f - _e299)))));
    let _e305 = ang;
    let _e306 = tipAngle;
    curled = (_e305 >= _e306);
    let _e309 = q_1[1u];
    let _e311 = C[1u];
    s = (1f - clamp((_e309 / _e311), 0f, 1f));
    let _e316 = C[0u];
    let _e317 = Rb;
    let _e319 = s;
    let _e321 = s;
    face = ((_e316 - _e317) - ((0.35f * _e319) * _e321));
    let _e324 = face;
    let _e326 = q_1[0u];
    behind = (_e324 - _e326);
    let _e328 = curled;
    if _e328 {
        let _e329 = r_1;
        let _e330 = rIn;
        let _e333 = ang;
        if (_e333 > 1.5707964f) {
            local_1 = 1f;
        } else {
            let _e335 = r_1;
            let _e336 = R;
            local_1 = (1f - smoothstep(-0.002f, 0.002f, (_e335 - _e336)));
        }
        let _e340 = local_1;
        wet = (smoothstep(-0.002f, 0.002f, (_e329 - _e330)) * _e340);
    } else {
        let _e342 = behind;
        wet = smoothstep(-0.002f, 0.002f, _e342);
    }
    let _e344 = curled;
    if _e344 {
        let _e345 = ang;
        local_2 = (1f - smoothstep(1.2707963f, 2.0707963f, _e345));
    } else {
        local_2 = 0f;
    }
    let _e348 = local_2;
    lip = _e348;
    let _e349 = q_1;
    let _e351 = t;
    let _e353 = t;
    param_10 = ((_e349 * vec2<f32>(14f, 10f)) + vec2<f32>((-9f * _e351), (3f * _e353)));
    let _e357 = vnoise((&param_10));
    n = _e357;
    let _e358 = (*uv_2);
    param_11 = _e358;
    let _e359 = getFromColor((&param_11));
    a = _e359;
    let _e360 = r_1;
    let _e361 = R;
    let _e363 = behind;
    gap = max(min((_e360 - _e361), -(_e363)), 0f);
    let _e367 = gap;
    let _e372 = gap;
    let _e377 = q_1[1u];
    let _e381 = C[1u];
    let _e382 = R;
    let _e386 = C[1u];
    let _e387 = R;
    let _e391 = q_1[1u];
    shade = ((((0.55f * exp((-(_e367) / 0.1f))) * (1f - smoothstep(0f, 0.25f, _e372))) * smoothstep(0f, 0.6f, _e377)) * (1f - smoothstep((_e381 + (0.2f * _e382)), (_e386 + (1.1f * _e387)), _e391)));
    let _e395 = R;
    let _e396 = r_1;
    let _e400 = shade;
    shade = (_e400 + (0.25f * (1f - smoothstep(0f, _e395, _e396))));
    let _e402 = shade;
    let _e404 = a;
    let _e406 = (_e404.xyz * (1f - _e402));
    a[0u] = _e406.x;
    a[1u] = _e406.y;
    a[2u] = _e406.z;
    let _e413 = r_1;
    let _e414 = R;
    fwd = max((_e413 - _e414), 0f);
    let _e417 = tipAngle;
    let _e419 = tipAngle;
    let _e421 = ang;
    let _e423 = fwd;
    let _e427 = r_1;
    let _e428 = R;
    zone = ((smoothstep((_e417 - 0.4f), (_e419 + 0.2f), _e421) * (1f - smoothstep(0f, 0.25f, _e423))) * step(0f, (_e427 - _e428)));
    let _e432 = d;
    let _e433 = t;
    sq = ((_e432 - (vec2<f32>(0.5f, -0.25f) * _e433)) * vec2<f32>(0.55f, 1f));
    let _e437 = fwd;
    thin = exp((-(_e437) / 0.12f));
    let _e442 = uniforms.foam;
    let _e443 = thin;
    let _e445 = sq;
    param_12 = _e445;
    param_13 = 0.02f;
    param_14 = (_e442 * _e443);
    param_15 = 1f;
    let _e446 = droplets((&param_12), (&param_13), (&param_14), (&param_15));
    let _e447 = sq;
    let _e452 = uniforms.foam;
    let _e453 = thin;
    param_16 = ((_e447 * 1.6f) + vec2(3.1f));
    param_17 = 0.02f;
    param_18 = (_e452 * _e453);
    param_19 = 7f;
    let _e455 = droplets((&param_16), (&param_17), (&param_18), (&param_19));
    spray = (_e446 + (0.6f * _e455));
    let _e459 = uniforms.foam;
    let _e460 = n;
    let _e462 = n;
    let _e464 = fwd;
    let _e469 = fwd;
    let _e473 = r_1;
    let _e474 = R;
    let _e478 = tipAngle;
    let _e479 = tipAngle;
    let _e481 = ang;
    mist = ((((((_e459 * _e460) * _e462) * exp((-(_e464) / 0.06f))) * (1f - smoothstep(0f, 0.25f, _e469))) * smoothstep(-0.002f, 0.002f, (_e473 - _e474))) * smoothstep(_e478, (_e479 + 0.3f), _e481));
    let _e484 = a;
    let _e487 = uniforms.foamColor;
    let _e491 = uniforms.foamColor[3u];
    let _e492 = spray;
    let _e493 = zone;
    let _e495 = mist;
    let _e500 = mix(_e484.xyz, _e487.xyz, vec3((_e491 * clamp(((_e492 * _e493) + _e495), 0f, 1f))));
    a[0u] = _e500.x;
    a[1u] = _e500.y;
    a[2u] = _e500.z;
    let _e507 = behind;
    let _e510 = lip;
    band = max((1f - smoothstep(0.05f, 0.4f, _e507)), _e510);
    let _e513 = uniforms.refraction;
    let _e514 = band;
    let _e516 = band;
    bend = ((_e513 * _e514) * _e516);
    let _e518 = bend;
    let _e519 = dir;
    let _e521 = q_1[1u];
    let _e524 = q_1[0u];
    let _e529 = t;
    let _e534 = up;
    let _e536 = q_1[0u];
    let _e538 = t;
    off = (((_e519 * sin((((17f * _e521) + (2f * sin((9f * _e524)))) - (6f * _e529)))) + (_e534 * cos(((13f * _e536) - (5f * _e538))))) * _e518);
    let _e545 = (*uv_2);
    let _e546 = off;
    let _e548 = w;
    let _e551 = uniforms.ratio;
    param_20 = (_e545 + (((_e546 * 2f) * _e548) / vec2<f32>(_e551, 1f)));
    let _e555 = mirror((&param_20));
    param_21 = _e555;
    let _e556 = getToColor((&param_21));
    b = _e556;
    let _e557 = b;
    luma = dot(_e557.xyz, vec3<f32>(0.299f, 0.587f, 0.114f));
    let _e561 = uniforms.water;
    let _e563 = luma;
    let _e568 = q_1[1u];
    tinted = ((_e561.xyz * (0.4f + (0.9f * _e563))) * (1f + (0.6f * _e568)));
    let _e572 = lip;
    let _e574 = k;
    let _e578 = tinted;
    tinted = (_e578 + (vec3<f32>(0.5f, 1f, 0.9f) * ((0.18f * _e572) * (1f - _e574))));
    let _e580 = lip;
    let _e582 = r_1;
    let _e583 = rIn;
    let _e589 = tinted;
    tinted = (_e589 * (1f - ((0.35f * _e580) * (1f - smoothstep(0f, 0.06f, (_e582 - _e583))))));
    let _e591 = curled;
    if _e591 {
        let _e592 = k;
        let _e593 = r_1;
        let _e594 = rIn;
        local_3 = (_e592 * (1f - smoothstep(0f, 0.015f, (_e593 - _e594))));
    } else {
        let _e599 = behind;
        local_3 = (1f - smoothstep(0f, 0.015f, _e599));
    }
    let _e602 = local_3;
    let _e605 = tinted;
    tinted = (_e605 + (vec3<f32>(0.7f, 0.95f, 1f) * (0.35f * _e602)));
    let _e607 = b;
    let _e609 = tinted;
    let _e612 = uniforms.water[3u];
    let _e613 = band;
    let _e616 = mix(_e607.xyz, _e609, vec3((_e612 * _e613)));
    b[0u] = _e616.x;
    b[1u] = _e616.y;
    b[2u] = _e616.z;
    let _e623 = curled;
    if _e623 {
        let _e624 = n;
        let _e627 = R;
        let _e628 = r_1;
        let _e633 = tipAngle;
        let _e634 = tipAngle;
        let _e636 = ang;
        let _e639 = ang;
        local_4 = (((1f - smoothstep(0.01f, (0.02f + (0.12f * _e624)), abs((_e627 - _e628)))) * smoothstep(_e633, (_e634 + 0.4f), _e636)) * (1f - smoothstep(1.7707963f, 2.3707964f, _e639)));
    } else {
        local_4 = 0f;
    }
    let _e643 = local_4;
    crest = _e643;
    let _e644 = n;
    let _e648 = q_1[1u];
    let _e651 = behind;
    let _e656 = n;
    churn = (((1f - smoothstep(0f, (0.15f + (0.1f * _e644)), _e648)) * (1f - smoothstep(0f, 0.3f, abs(_e651)))) * smoothstep(0.3f, 0.7f, _e656));
    let _e659 = b;
    let _e662 = uniforms.foamColor;
    let _e666 = uniforms.foamColor[3u];
    let _e668 = uniforms.foam;
    let _e670 = crest;
    let _e671 = churn;
    let _e677 = mix(_e659.xyz, _e662.xyz, vec3((_e666 * clamp(((_e668 * 1.5f) * (_e670 + _e671)), 0f, 1f))));
    b[0u] = _e677.x;
    b[1u] = _e677.y;
    b[2u] = _e677.z;
    let _e684 = a;
    let _e687 = a[3u];
    let _e688 = (_e684.xyz * _e687);
    let _e690 = a[3u];
    let _e695 = b;
    let _e698 = b[3u];
    let _e699 = (_e695.xyz * _e698);
    let _e701 = b[3u];
    let _e706 = wet;
    c_1 = mix(vec4<f32>(_e688.x, _e688.y, _e688.z, _e690), vec4<f32>(_e699.x, _e699.y, _e699.z, _e701), vec4(_e706));
    let _e710 = c_1[3u];
    if (_e710 > 0f) {
        let _e712 = c_1;
        let _e715 = c_1[3u];
        let _e717 = (_e712.xyz / vec3(_e715));
        let _e719 = c_1[3u];
        local_5 = vec4<f32>(_e717.x, _e717.y, _e717.z, _e719);
    } else {
        local_5 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e724 = local_5;
    return _e724;
}

fn main_1() {
    var param_22: vec2<f32>;

    let _e88 = _uv_1;
    param_22 = _e88;
    let _e89 = transition((&param_22));
    _fragColor = _e89;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
