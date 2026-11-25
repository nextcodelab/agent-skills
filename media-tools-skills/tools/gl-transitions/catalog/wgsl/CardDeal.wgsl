// CardDeal — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CardDeal.glsl
// Author: gre
// License: MIT
// Description: The incoming image is dealt onto the frame like a hand of cards: tile after tile is flicked from below the frame, spinning through the air with a lifting shadow, and slides to a stop in its place until the picture is complete
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    grid: vec2<i32>,
    deck: vec2<f32>,
    spin: f32,
    shadow: f32,
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

fn cardDist(q: ptr<function, vec2<f32>>, size: ptr<function, vec2<f32>>) -> f32 {
    var e: vec2<f32>;

    let _e60 = (*q);
    let _e61 = (*q);
    let _e65 = (*size);
    e = (min(_e60, (vec2(1f) - _e61)) * _e65);
    let _e68 = e[0u];
    let _e70 = e[1u];
    return min(_e68, _e70);
}

fn hash(n: ptr<function, f32>) -> f32 {
    var p: vec2<f32>;

    let _e59 = (*n);
    p = fract((vec2(_e59) * vec2<f32>(0.1031f, 0.103f)));
    let _e63 = p;
    let _e64 = p;
    let _e69 = p;
    p = (_e69 + vec2(dot(_e63, (_e64.yx + vec2(33.33f)))));
    let _e73 = p[0u];
    let _e75 = p[1u];
    let _e78 = p[0u];
    return fract(((_e73 + _e75) * _e78));
}

fn cardCell(j: ptr<function, f32>, g: ptr<function, vec2<f32>>) -> vec2<f32> {
    var row: f32;

    let _e60 = (*j);
    let _e62 = (*g)[0u];
    row = floor((_e60 / _e62));
    let _e65 = (*j);
    let _e66 = row;
    let _e68 = (*g)[0u];
    let _e72 = (*g)[1u];
    let _e74 = row;
    return vec2<f32>((_e65 - (_e66 * _e68)), ((_e72 - 1f) - _e74));
}

fn cardTime(j_1: ptr<function, f32>, n_1: ptr<function, f32>) -> f32 {
    var flight: f32;

    let _e60 = (*n_1);
    flight = (1f / (1f + ((_e60 - 1f) * 0.16f)));
    let _e66 = uniforms.progress;
    let _e67 = (*j_1);
    let _e69 = flight;
    let _e72 = flight;
    return clamp(((_e66 - ((_e67 * 0.16f) * _e69)) / _e72), 0f, 1f);
}

fn gridSize_u0028_() -> vec2<f32> {
    let _e58 = uniforms.grid;
    return clamp(vec2<f32>(_e58), vec2(1f), vec2(6f));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e59 = (*uv)[0u];
    let _e61 = (*uv)[1u];
    let _e64 = textureSampleLevel(_to, _sampler, vec2<f32>(_e59, (1f - _e61)), 0f);
    return _e64;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e59 = (*uv_1)[0u];
    let _e61 = (*uv_1)[1u];
    let _e64 = textureSampleLevel(_from, _sampler, vec2<f32>(_e59, (1f - _e61)), 0f);
    return _e64;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var g_1: vec2<f32>;
    var n_2: f32;
    var asp: vec2<f32>;
    var size_1: vec2<f32>;
    var p_1: vec2<f32>;
    var origin: vec2<f32>;
    var darkness: f32;
    var own: vec2<f32>;
    var ownIndex: f32;
    var col: vec4<f32>;
    var param_2: f32;
    var param_3: f32;
    var local: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var i: i32;
    var j_2: f32;
    var u: f32;
    var param_6: f32;
    var param_7: f32;
    var cell: vec2<f32>;
    var param_8: f32;
    var param_9: vec2<f32>;
    var target_: vec2<f32>;
    var way: vec2<f32>;
    var len: f32;
    var side: vec2<f32>;
    var r1_: f32;
    var param_10: f32;
    var r2_: f32;
    var param_11: f32;
    var turn: f32;
    var slide: f32;
    var a: f32;
    var s: f32;
    var v1_: f32;
    var f: f32;
    var e_1: f32;
    var local_1: f32;
    var c: vec2<f32>;
    var h: f32;
    var angle: f32;
    var tilt: f32;
    var air: f32;
    var fade: f32;
    var sp: vec2<f32>;
    var ca: f32;
    var sa: f32;
    var rot: mat2x2<f32>;
    var sq: vec2<f32>;
    var soft: f32;
    var sh: f32;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var dark: f32;
    var d: vec2<f32>;
    var ct: f32;
    var st: f32;
    var den: f32;
    var k: f32;
    var local_2: f32;
    var q_1: vec2<f32>;
    var edge: f32;
    var m: f32;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var face: vec4<f32>;
    var param_16: vec2<f32>;
    var light: f32;
    var rim: f32;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;

    let _e133 = uniforms.progress;
    if (_e133 <= 0f) {
        let _e135 = (*uv_2);
        param = _e135;
        let _e136 = getFromColor((&param));
        return _e136;
    }
    let _e138 = uniforms.progress;
    if (_e138 >= 1f) {
        let _e140 = (*uv_2);
        param_1 = _e140;
        let _e141 = getToColor((&param_1));
        return _e141;
    }
    let _e142 = gridSize_u0028_();
    g_1 = _e142;
    let _e144 = g_1[0u];
    let _e146 = g_1[1u];
    n_2 = (_e144 * _e146);
    let _e149 = uniforms.ratio;
    asp = vec2<f32>(_e149, 1f);
    let _e151 = asp;
    let _e152 = g_1;
    size_1 = (_e151 / _e152);
    let _e154 = (*uv_2);
    let _e155 = asp;
    p_1 = (_e154 * _e155);
    let _e158 = uniforms.deck;
    let _e159 = asp;
    origin = (_e158 * _e159);
    let _e162 = uniforms.shadow;
    darkness = clamp(_e162, 0f, 1f);
    let _e164 = (*uv_2);
    let _e165 = g_1;
    let _e168 = g_1;
    own = min(floor((_e164 * _e165)), (_e168 - vec2(1f)));
    let _e173 = g_1[1u];
    let _e176 = own[1u];
    let _e179 = g_1[0u];
    let _e182 = own[0u];
    ownIndex = ((((_e173 - 1f) - _e176) * _e179) + _e182);
    let _e184 = ownIndex;
    param_2 = _e184;
    let _e185 = n_2;
    param_3 = _e185;
    let _e186 = cardTime((&param_2), (&param_3));
    if (_e186 >= 1f) {
        let _e188 = (*uv_2);
        param_4 = _e188;
        let _e189 = getToColor((&param_4));
        local = _e189;
    } else {
        let _e190 = (*uv_2);
        param_5 = _e190;
        let _e191 = getFromColor((&param_5));
        local = _e191;
    }
    let _e192 = local;
    col = _e192;
    i = 0i;
    loop {
        let _e193 = i;
        if (_e193 < 36i) {
            let _e195 = i;
            j_2 = f32(_e195);
            let _e197 = j_2;
            let _e198 = n_2;
            if (_e197 >= _e198) {
                break;
            }
            let _e200 = j_2;
            param_6 = _e200;
            let _e201 = n_2;
            param_7 = _e201;
            let _e202 = cardTime((&param_6), (&param_7));
            u = _e202;
            let _e203 = u;
            if (_e203 <= 0f) {
                break;
            }
            let _e205 = u;
            if (_e205 >= 1f) {
                continue;
            }
            let _e207 = j_2;
            param_8 = _e207;
            let _e208 = g_1;
            param_9 = _e208;
            let _e209 = cardCell((&param_8), (&param_9));
            cell = _e209;
            let _e210 = cell;
            let _e213 = size_1;
            target_ = ((_e210 + vec2(0.5f)) * _e213);
            let _e215 = target_;
            let _e216 = origin;
            way = (_e215 - _e216);
            let _e218 = way;
            len = max(length(_e218), 0.001f);
            let _e222 = way[1u];
            let _e225 = way[0u];
            side = vec2<f32>(-(_e222), _e225);
            let _e227 = j_2;
            param_10 = (_e227 + 1f);
            let _e229 = hash((&param_10));
            r1_ = _e229;
            let _e230 = j_2;
            param_11 = (_e230 + 60f);
            let _e232 = hash((&param_11));
            r2_ = _e232;
            let _e233 = r2_;
            turn = select(1f, -1f, (_e233 < 0.5f));
            let _e237 = size_1[1u];
            let _e239 = len;
            slide = min(((0.35f * _e237) / _e239), 0.5f);
            let _e242 = u;
            a = min((_e242 / 0.55f), 1f);
            let _e245 = u;
            s = clamp(((_e245 - 0.55f) / 0.45f), 0f, 1f);
            let _e249 = slide;
            let _e252 = slide;
            v1_ = (((2f * _e249) * 0.55f) / (0.45f * (1f - _e252)));
            let _e256 = a;
            let _e259 = a;
            let _e261 = a;
            let _e263 = a;
            let _e264 = a;
            let _e266 = a;
            let _e268 = a;
            let _e270 = a;
            let _e273 = a;
            let _e277 = v1_;
            let _e278 = a;
            let _e279 = a;
            let _e281 = a;
            let _e283 = a;
            let _e284 = a;
            f = (((((3f - (2f * _e256)) * _e259) * _e261) + (2.2f * ((((_e263 * _e264) * _e266) - ((2f * _e268) * _e270)) + _e273))) + (_e277 * (((_e278 * _e279) * _e281) - (_e283 * _e284))));
            let _e289 = u;
            if (_e289 < 0.55f) {
                let _e291 = slide;
                let _e293 = f;
                local_1 = ((1f - _e291) * _e293);
            } else {
                let _e295 = slide;
                let _e296 = s;
                let _e299 = s;
                local_1 = (1f - ((_e295 * (1f - _e296)) * (1f - _e299)));
            }
            let _e303 = local_1;
            e_1 = _e303;
            let _e304 = origin;
            let _e305 = way;
            let _e306 = e_1;
            let _e309 = side;
            let _e310 = turn;
            let _e312 = r1_;
            let _e316 = e_1;
            c = ((_e304 + (_e305 * _e306)) + (((_e309 * _e310) * (0.05f + (0.05f * _e312))) * sin((3.1415927f * _e316))));
            let _e321 = r1_;
            let _e325 = a;
            let _e329 = a;
            h = (((0.45f * (0.7f + (0.3f * _e321))) * sin((3.1415927f * _e325))) * (1f - (0.35f * _e329)));
            let _e333 = turn;
            let _e335 = uniforms.spin;
            let _e337 = r2_;
            let _e343 = e_1;
            angle = (((((_e333 * _e335) * (0.8f + (0.4f * _e337))) * 2f) * 3.1415927f) * (1f - _e343));
            let _e346 = a;
            let _e350 = angle;
            let _e352 = r1_;
            tilt = ((0.45f * sin((3.1415927f * _e346))) * cos(((_e350 * 0.5f) + (6f * _e352))));
            let _e357 = a;
            let _e358 = a;
            air = (1f - (_e357 * _e358));
            let _e361 = u;
            fade = smoothstep(0f, 0.05f, _e361);
            let _e363 = p_1;
            let _e364 = c;
            let _e366 = h;
            sp = (((_e363 - _e364) - (vec2<f32>(0.18f, -0.3f) * _e366)) - vec2<f32>(0.002f, -0.003f));
            let _e370 = angle;
            ca = cos(_e370);
            let _e372 = angle;
            sa = sin(_e372);
            let _e374 = ca;
            let _e375 = sa;
            let _e377 = sa;
            let _e378 = ca;
            rot = mat2x2<f32>(vec2<f32>(_e374, -(_e375)), vec2<f32>(_e377, _e378));
            let _e382 = rot;
            let _e383 = sp;
            let _e385 = size_1;
            sq = (((_e382 * _e383) / _e385) + vec2(0.5f));
            let _e389 = h;
            soft = (0.006f + (0.08f * _e389));
            let _e392 = soft;
            let _e394 = soft;
            let _e395 = sq;
            param_12 = _e395;
            let _e396 = size_1;
            param_13 = _e396;
            let _e397 = cardDist((&param_12), (&param_13));
            sh = smoothstep(-(_e392), _e394, _e397);
            let _e399 = s;
            let _e402 = h;
            let _e406 = air;
            dark = mix((0.8f * (1f - _e399)), (0.65f - ((0.3f * _e402) / 0.45f)), _e406);
            let _e408 = fade;
            let _e409 = darkness;
            let _e411 = dark;
            let _e413 = sh;
            let _e416 = col;
            let _e418 = (_e416.xyz * (1f - (((_e408 * _e409) * _e411) * _e413)));
            col[0u] = _e418.x;
            col[1u] = _e418.y;
            col[2u] = _e418.z;
            let _e425 = rot;
            let _e426 = p_1;
            let _e427 = c;
            let _e430 = h;
            d = (((_e425 * (_e426 - _e427)) * (2.4f - _e430)) / vec2(2.4f));
            let _e435 = tilt;
            ct = cos(_e435);
            let _e437 = tilt;
            st = sin(_e437);
            let _e439 = ct;
            let _e442 = d[1u];
            let _e443 = st;
            den = ((2.4f * _e439) + (_e442 * _e443));
            let _e446 = den;
            if (_e446 > 0.001f) {
                let _e448 = ct;
                let _e450 = den;
                local_2 = ((2.4f * _e448) / _e450);
            } else {
                local_2 = 1000f;
            }
            let _e452 = local_2;
            k = _e452;
            let _e453 = k;
            let _e455 = d[0u];
            let _e457 = k;
            let _e459 = d[1u];
            let _e461 = ct;
            let _e463 = k;
            let _e466 = st;
            let _e470 = size_1;
            q_1 = ((vec2<f32>((_e453 * _e455), (((_e457 * _e459) * _e461) + ((2.4f * (1f - _e463)) * _e466))) / _e470) + vec2(0.5f));
            let _e474 = air;
            let _e478 = s;
            edge = ((0.0015f * (1f + (2f * _e474))) * min((10f * (1f - _e478)), 1f));
            let _e483 = fade;
            let _e484 = q_1;
            param_14 = _e484;
            let _e485 = size_1;
            param_15 = _e485;
            let _e486 = cardDist((&param_14), (&param_15));
            let _e487 = edge;
            m = (_e483 * clamp(((_e486 / max(_e487, 0.000001f)) + 0.5f), 0f, 1f));
            let _e493 = m;
            if (_e493 > 0f) {
                let _e495 = cell;
                let _e496 = q_1;
                let _e501 = g_1;
                param_16 = ((_e495 + clamp(_e496, vec2(0f), vec2(1f))) / _e501);
                let _e503 = getToColor((&param_16));
                face = _e503;
                let _e504 = st;
                let _e506 = turn;
                let _e508 = angle;
                light = (1f + ((0.6f * _e504) * (0.6f - ((0.4f * _e506) * sin(_e508)))));
                let _e514 = q_1;
                param_17 = _e514;
                let _e515 = size_1;
                param_18 = _e515;
                let _e516 = cardDist((&param_17), (&param_18));
                rim = (1f - smoothstep(0f, 0.008f, _e516));
                let _e519 = face;
                let _e521 = light;
                let _e524 = face[3u];
                let _e528 = face[3u];
                let _e530 = air;
                let _e532 = rim;
                let _e535 = mix(min((_e519.xyz * _e521), vec3(_e524)), vec3(_e528), vec3(((0.45f * _e530) * _e532)));
                face[0u] = _e535.x;
                face[1u] = _e535.y;
                face[2u] = _e535.z;
                let _e542 = col;
                let _e543 = face;
                let _e544 = m;
                col = mix(_e542, _e543, vec4(_e544));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e547 = i;
            i = (_e547 + 1i);
        }
    }
    let _e549 = col;
    return _e549;
}

fn main_1() {
    var param_19: vec2<f32>;

    let _e58 = _uv_1;
    param_19 = _e58;
    let _e59 = transition((&param_19));
    _fragColor = _e59;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
