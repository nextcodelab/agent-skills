// GridFlip — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GridFlip.glsl
// Author: TimDonselaar
// License: MIT
// Description: The image splits into a grid of cards that lift apart and turn over in perspective one after another, each one showing its part of the incoming image on its back
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    size: vec2<i32>,
    pause: f32,
    dividerWidth: f32,
    bgcolor: vec4<f32>,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv)[0u];
    let _e56 = (*uv)[1u];
    let _e59 = textureSampleLevel(_to, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv_1)[0u];
    let _e56 = (*uv_1)[1u];
    let _e59 = textureSampleLevel(_from, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn aa(d: ptr<function, f32>, e: ptr<function, f32>) -> f32 {
    let _e54 = (*d);
    let _e55 = (*e);
    return clamp(((_e54 / max((2f * _e55), 0.000001f)) + 0.5f), 0f, 1f);
}

fn boxShadow(p: ptr<function, vec2<f32>>, halfSize: ptr<function, vec2<f32>>, blur: ptr<function, f32>) -> f32 {
    var d_1: vec2<f32>;
    var dist: f32;

    let _e57 = (*p);
    let _e59 = (*halfSize);
    d_1 = (abs(_e57) - _e59);
    let _e61 = d_1;
    let _e66 = d_1[0u];
    let _e68 = d_1[1u];
    dist = (length(max(_e61, vec2(0f))) + min(max(_e66, _e68), 0f));
    let _e72 = (*blur);
    let _e74 = (*blur);
    let _e75 = dist;
    return (1f - smoothstep(-(_e72), _e74, _e75));
}

fn easeInOut(t: ptr<function, f32>) -> f32 {
    let _e53 = (*t);
    let _e54 = (*t);
    let _e55 = (*t);
    let _e57 = (*t);
    return mix(_e53, ((_e54 * _e55) * (3f - (2f * _e57))), 0.7f);
}

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e54 = (*v);
    v3_ = fract((_e54.xyx * 0.1031f));
    let _e58 = v3_;
    let _e59 = v3_;
    let _e64 = v3_;
    v3_ = (_e64 + vec3(dot(_e58, (_e59.yzx + vec3(33.33f)))));
    let _e68 = v3_[0u];
    let _e70 = v3_[1u];
    let _e73 = v3_[2u];
    return fract(((_e68 + _e70) * _e73));
}

fn flipTime(cell: ptr<function, vec2<f32>>, grid: ptr<function, vec2<f32>>, q: ptr<function, f32>, stagger: ptr<function, f32>) -> f32 {
    var wave: f32;
    var order: f32;
    var param: vec2<f32>;
    var param_1: f32;

    let _e61 = (*cell)[0u];
    let _e63 = (*grid)[1u];
    let _e66 = (*cell)[1u];
    let _e70 = (*grid)[0u];
    let _e72 = (*grid)[1u];
    wave = ((_e61 + ((_e63 - 1f) - _e66)) / max(((_e70 + _e72) - 2f), 1f));
    let _e77 = wave;
    let _e78 = (*cell);
    param = (_e78 + vec2(7.31f));
    let _e81 = hash12((&param));
    let _e83 = uniforms.randomness;
    order = mix(_e77, _e81, clamp(_e83, 0f, 1f));
    let _e86 = (*q);
    let _e87 = order;
    let _e88 = (*stagger);
    let _e91 = (*stagger);
    param_1 = clamp(((_e86 - (_e87 * _e88)) / (1f - _e91)), 0f, 1f);
    let _e95 = easeInOut((&param_1));
    return _e95;
}

fn pausePart_u0028_() -> f32 {
    let _e53 = uniforms.pause;
    return clamp(_e53, 0.05f, 0.4f);
}

fn gapAmount_u0028_() -> f32 {
    var pp: f32;

    let _e53 = pausePart_u0028_();
    pp = _e53;
    let _e54 = pp;
    let _e56 = uniforms.progress;
    let _e58 = pp;
    let _e61 = uniforms.progress;
    return (smoothstep(0f, _e54, _e56) * (1f - smoothstep((1f - _e58), 1f, _e61)));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var grid_1: vec2<f32>;
    var frame: vec2<f32>;
    var tileSize: vec2<f32>;
    var cell_1: vec2<f32>;
    var pos: vec2<f32>;
    var gapOpen: f32;
    var minSide: f32;
    var gap: f32;
    var halfTile: vec2<f32>;
    var eye: f32;
    var pp_1: f32;
    var q_1: f32;
    var stagger_1: f32;
    var c1_: vec4<f32>;
    var c2_: vec4<f32>;
    var m1_: f32;
    var m2_: f32;
    var z1_: f32;
    var z2_: f32;
    var rest1_: bool;
    var rest2_: bool;
    var shadowBg: f32;
    var shadowFlip: f32;
    var j: i32;
    var i: i32;
    var nc: vec2<f32>;
    var t_1: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var param_5: f32;
    var a: f32;
    var ca: f32;
    var sa: f32;
    var rest: bool;
    var center: vec2<f32>;
    var q_2: vec2<f32>;
    var lift: f32;
    var shOffset: vec2<f32>;
    var shHalf: vec2<f32>;
    var sh: f32;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: f32;
    var den: f32;
    var s: f32;
    var hit: vec3<f32>;
    var u: f32;
    var xa: f32;
    var xb: f32;
    var dx: f32;
    var dy: f32;
    var e_1: f32;
    var m: f32;
    var param_9: f32;
    var param_10: f32;
    var front: bool;
    var src: vec2<f32>;
    var local: f32;
    var col: vec4<f32>;
    var local_1: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var nx: f32;
    var local_2: f32;
    var lit: f32;
    var color: vec4<f32>;
    var phi_380_: bool;
    var phi_390_: bool;
    var phi_400_: bool;

    let _e121 = uniforms.size;
    grid_1 = max(vec2<f32>(_e121), vec2(1f));
    let _e126 = uniforms.ratio;
    frame = vec2<f32>(_e126, 1f);
    let _e128 = frame;
    let _e129 = grid_1;
    tileSize = (_e128 / _e129);
    let _e131 = (*uv_2);
    let _e132 = grid_1;
    let _e135 = grid_1;
    cell_1 = clamp(floor((_e131 * _e132)), vec2<f32>(0f, 0f), (_e135 - vec2(1f)));
    let _e139 = (*uv_2);
    let _e140 = frame;
    pos = (_e139 * _e140);
    let _e142 = gapAmount_u0028_();
    gapOpen = _e142;
    let _e144 = tileSize[0u];
    let _e146 = tileSize[1u];
    minSide = min(_e144, _e146);
    let _e149 = uniforms.dividerWidth;
    let _e151 = minSide;
    let _e153 = gapOpen;
    gap = ((clamp(_e149, 0f, 0.4f) * _e151) * _e153);
    let _e155 = tileSize;
    let _e157 = gap;
    halfTile = ((_e155 * 0.5f) - vec2(_e157));
    let _e161 = tileSize[0u];
    let _e163 = tileSize[1u];
    eye = (2.2f * max(_e161, _e163));
    let _e166 = pausePart_u0028_();
    pp_1 = (0.6f * _e166);
    let _e169 = uniforms.progress;
    let _e170 = pp_1;
    let _e172 = pp_1;
    q_1 = clamp(((_e169 - _e170) / (1f - (2f * _e172))), 0f, 1f);
    let _e178 = grid_1[0u];
    let _e180 = grid_1[1u];
    stagger_1 = select(0f, 0.55f, ((_e178 * _e180) > 1.5f));
    c1_ = vec4<f32>(0f, 0f, 0f, 0f);
    c2_ = vec4<f32>(0f, 0f, 0f, 0f);
    m1_ = 0f;
    m2_ = 0f;
    z1_ = 1000000000f;
    z2_ = 1000000000f;
    rest1_ = true;
    rest2_ = true;
    shadowBg = 0f;
    shadowFlip = 0f;
    j = -1i;
    loop {
        let _e184 = j;
        if (_e184 <= 1i) {
            i = -1i;
            loop {
                let _e186 = i;
                if (_e186 <= 1i) {
                    let _e188 = cell_1;
                    let _e189 = i;
                    let _e191 = j;
                    nc = (_e188 + vec2<f32>(f32(_e189), f32(_e191)));
                    let _e196 = nc[0u];
                    let _e197 = (_e196 < 0f);
                    phi_380_ = _e197;
                    if !(_e197) {
                        let _e200 = nc[1u];
                        phi_380_ = (_e200 < 0f);
                    }
                    let _e203 = phi_380_;
                    phi_390_ = _e203;
                    if !(_e203) {
                        let _e206 = nc[0u];
                        let _e208 = grid_1[0u];
                        phi_390_ = (_e206 > (_e208 - 1f));
                    }
                    let _e212 = phi_390_;
                    phi_400_ = _e212;
                    if !(_e212) {
                        let _e215 = nc[1u];
                        let _e217 = grid_1[1u];
                        phi_400_ = (_e215 > (_e217 - 1f));
                    }
                    let _e221 = phi_400_;
                    if _e221 {
                        continue;
                    }
                    let _e222 = nc;
                    param_2 = _e222;
                    let _e223 = grid_1;
                    param_3 = _e223;
                    let _e224 = q_1;
                    param_4 = _e224;
                    let _e225 = stagger_1;
                    param_5 = _e225;
                    let _e226 = flipTime((&param_2), (&param_3), (&param_4), (&param_5));
                    t_1 = _e226;
                    let _e227 = t_1;
                    a = (3.1415927f * _e227);
                    let _e229 = a;
                    ca = cos(_e229);
                    let _e231 = a;
                    sa = sin(_e231);
                    let _e233 = t_1;
                    let _e235 = t_1;
                    rest = ((_e233 <= 0f) || (_e235 >= 1f));
                    let _e238 = rest;
                    if _e238 {
                        let _e239 = t_1;
                        ca = select(-1f, 1f, (_e239 <= 0f));
                        sa = 0f;
                    }
                    let _e242 = nc;
                    let _e245 = tileSize;
                    center = ((_e242 + vec2(0.5f)) * _e245);
                    let _e247 = pos;
                    let _e248 = center;
                    q_2 = (_e247 - _e248);
                    let _e250 = gapOpen;
                    let _e252 = minSide;
                    let _e255 = halfTile[0u];
                    let _e257 = sa;
                    lift = (((0.05f * _e250) * _e252) + ((0.35f * _e255) * _e257));
                    let _e260 = lift;
                    shOffset = (vec2<f32>(0.45f, -0.3f) * _e260);
                    let _e263 = halfTile[0u];
                    let _e264 = ca;
                    let _e267 = lift;
                    let _e271 = halfTile[1u];
                    shHalf = vec2<f32>(((_e263 * abs(_e264)) + (0.5f * _e267)), _e271);
                    let _e273 = q_2;
                    let _e274 = shOffset;
                    let _e276 = minSide;
                    let _e278 = lift;
                    param_6 = (_e273 - _e274);
                    let _e281 = shHalf;
                    param_7 = _e281;
                    param_8 = ((0.01f * _e276) + (0.5f * _e278));
                    let _e282 = boxShadow((&param_6), (&param_7), (&param_8));
                    sh = _e282;
                    let _e283 = shadowBg;
                    let _e285 = gapOpen;
                    let _e287 = sh;
                    shadowBg = (1f - ((1f - _e283) * (1f - ((0.45f * _e285) * _e287))));
                    let _e292 = shadowFlip;
                    let _e293 = sa;
                    let _e295 = sa;
                    let _e297 = sh;
                    shadowFlip = max(_e292, (((0.45f * _e293) * _e295) * _e297));
                    let _e300 = eye;
                    let _e301 = ca;
                    let _e304 = q_2[0u];
                    let _e305 = sa;
                    den = ((_e300 * _e301) - (_e304 * _e305));
                    let _e308 = den;
                    if (abs(_e308) < 0.000001f) {
                        continue;
                    }
                    let _e311 = eye;
                    let _e312 = ca;
                    let _e314 = den;
                    s = ((_e311 * _e312) / _e314);
                    let _e316 = s;
                    if (_e316 <= 0f) {
                        continue;
                    }
                    let _e318 = s;
                    let _e320 = q_2[0u];
                    let _e322 = s;
                    let _e324 = q_2[1u];
                    let _e326 = eye;
                    let _e327 = s;
                    hit = vec3<f32>((_e318 * _e320), (_e322 * _e324), (_e326 * (1f - _e327)));
                    let _e332 = hit[0u];
                    let _e333 = ca;
                    let _e336 = hit[2u];
                    let _e337 = sa;
                    u = ((_e332 * _e333) - (_e336 * _e337));
                    let _e341 = halfTile[0u];
                    let _e342 = ca;
                    let _e344 = eye;
                    let _e346 = eye;
                    let _e348 = halfTile[0u];
                    let _e349 = sa;
                    xa = (((_e341 * _e342) * _e344) / (_e346 + (_e348 * _e349)));
                    let _e354 = halfTile[0u];
                    let _e356 = ca;
                    let _e358 = eye;
                    let _e360 = eye;
                    let _e362 = halfTile[0u];
                    let _e363 = sa;
                    xb = (((-(_e354) * _e356) * _e358) / (_e360 - (_e362 * _e363)));
                    let _e368 = q_2[0u];
                    let _e369 = xa;
                    let _e370 = xb;
                    let _e373 = xa;
                    let _e374 = xb;
                    let _e377 = q_2[0u];
                    dx = min((_e368 - min(_e369, _e370)), (max(_e373, _e374) - _e377));
                    let _e381 = halfTile[1u];
                    let _e383 = hit[1u];
                    let _e386 = s;
                    dy = ((_e381 - abs(_e383)) / _e386);
                    let _e388 = gap;
                    let _e390 = sa;
                    e_1 = max(min(0.0012f, _e388), (0.0012f * min((8f * _e390), 1f)));
                    let _e395 = dx;
                    let _e396 = dy;
                    param_9 = min(_e395, _e396);
                    let _e398 = e_1;
                    param_10 = _e398;
                    let _e399 = aa((&param_9), (&param_10));
                    m = _e399;
                    let _e400 = m;
                    if (_e400 <= 0f) {
                        continue;
                    }
                    let _e402 = ca;
                    front = (_e402 > 0f);
                    let _e404 = center;
                    let _e405 = front;
                    if _e405 {
                        let _e406 = u;
                        local = _e406;
                    } else {
                        let _e407 = u;
                        local = -(_e407);
                    }
                    let _e409 = local;
                    let _e411 = hit[1u];
                    let _e414 = frame;
                    src = ((_e404 + vec2<f32>(_e409, _e411)) / _e414);
                    let _e416 = front;
                    if _e416 {
                        let _e417 = src;
                        param_11 = _e417;
                        let _e418 = getFromColor((&param_11));
                        local_1 = _e418;
                    } else {
                        let _e419 = src;
                        param_12 = _e419;
                        let _e420 = getToColor((&param_12));
                        local_1 = _e420;
                    }
                    let _e421 = local_1;
                    col = _e421;
                    let _e422 = rest;
                    if !(_e422) {
                        let _e424 = front;
                        if _e424 {
                            let _e425 = sa;
                            local_2 = _e425;
                        } else {
                            let _e426 = sa;
                            local_2 = -(_e426);
                        }
                        let _e428 = local_2;
                        nx = _e428;
                        let _e429 = ca;
                        let _e431 = nx;
                        lit = (abs(_e429) + (_e431 * -0.45f));
                        let _e434 = lit;
                        let _e437 = lit;
                        let _e442 = col;
                        let _e444 = (_e442.xyz * (mix(0.35f, 1f, clamp(_e434, 0f, 1f)) + (0.25f * max((_e437 - 1f), 0f))));
                        col[0u] = _e444.x;
                        col[1u] = _e444.y;
                        col[2u] = _e444.z;
                        let _e451 = sa;
                        let _e453 = dx;
                        let _e454 = dy;
                        let _e459 = col;
                        let _e462 = (_e459.xyz + vec3(((0.12f * _e451) * (1f - smoothstep(0f, 0.0036f, min(_e453, _e454))))));
                        col[0u] = _e462.x;
                        col[1u] = _e462.y;
                        col[2u] = _e462.z;
                    }
                    let _e469 = s;
                    let _e470 = z1_;
                    if (_e469 < _e470) {
                        let _e472 = c1_;
                        c2_ = _e472;
                        let _e473 = m1_;
                        m2_ = _e473;
                        let _e474 = z1_;
                        z2_ = _e474;
                        let _e475 = rest1_;
                        rest2_ = _e475;
                        let _e476 = col;
                        c1_ = _e476;
                        let _e477 = m;
                        m1_ = _e477;
                        let _e478 = s;
                        z1_ = _e478;
                        let _e479 = rest;
                        rest1_ = _e479;
                    } else {
                        let _e480 = s;
                        let _e481 = z2_;
                        if (_e480 < _e481) {
                            let _e483 = col;
                            c2_ = _e483;
                            let _e484 = m;
                            m2_ = _e484;
                            let _e485 = s;
                            z2_ = _e485;
                            let _e486 = rest;
                            rest2_ = _e486;
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e487 = i;
                    i = (_e487 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e489 = j;
            j = (_e489 + 1i);
        }
    }
    let _e492 = uniforms.bgcolor;
    color = _e492;
    let _e493 = shadowBg;
    let _e494 = shadowFlip;
    let _e498 = color;
    let _e500 = (_e498.xyz * (1f - clamp(max(_e493, _e494), 0f, 1f)));
    color[0u] = _e500.x;
    color[1u] = _e500.y;
    color[2u] = _e500.z;
    let _e507 = rest2_;
    if _e507 {
        let _e508 = shadowFlip;
        let _e510 = c2_;
        let _e512 = (_e510.xyz * (1f - _e508));
        c2_[0u] = _e512.x;
        c2_[1u] = _e512.y;
        c2_[2u] = _e512.z;
    }
    let _e519 = rest1_;
    if _e519 {
        let _e520 = shadowFlip;
        let _e522 = c1_;
        let _e524 = (_e522.xyz * (1f - _e520));
        c1_[0u] = _e524.x;
        c1_[1u] = _e524.y;
        c1_[2u] = _e524.z;
    }
    let _e531 = color;
    let _e532 = c2_;
    let _e533 = m2_;
    color = mix(_e531, _e532, vec4(_e533));
    let _e536 = color;
    let _e537 = c1_;
    let _e538 = m1_;
    color = mix(_e536, _e537, vec4(_e538));
    let _e541 = color;
    return _e541;
}

fn main_1() {
    var param_13: vec2<f32>;

    let _e53 = _uv_1;
    param_13 = _e53;
    let _e54 = transition((&param_13));
    _fragColor = _e54;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
