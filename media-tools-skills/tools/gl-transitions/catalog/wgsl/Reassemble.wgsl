// Reassemble — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Reassemble.glsl
// Author: gre
// License: MIT
// Description: The outgoing image cracks into irregular shards that burst apart toward the viewer, each one turning over in 3D at its own moment, then fly back together and lock into place as the incoming image carried on their backs
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    rows: i32,
    depth: f32,
    spread: f32,
    backColor: vec4<f32>,
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
    let _e68 = (*uv)[0u];
    let _e70 = (*uv)[1u];
    let _e73 = textureSampleLevel(_to, _sampler, vec2<f32>(_e68, (1f - _e70)), 0f);
    return _e73;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e68 = (*uv_1)[0u];
    let _e70 = (*uv_1)[1u];
    let _e73 = textureSampleLevel(_from, _sampler, vec2<f32>(_e68, (1f - _e70)), 0f);
    return _e73;
}

fn hash3(p: ptr<function, vec2<f32>>) -> vec3<f32> {
    var q: vec3<f32>;

    let _e68 = (*p);
    q = fract((_e68.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e72 = q;
    let _e73 = q;
    let _e78 = q;
    q = (_e78 + vec3(dot(_e72, (_e73.yxz + vec3(33.33f)))));
    let _e81 = q;
    let _e83 = q;
    let _e86 = q;
    return fract(((_e81.xxy + _e83.yzz) * _e86.zyx));
}

fn seed(g: ptr<function, vec2<f32>>, size: ptr<function, f32>) -> vec2<f32> {
    var param: vec2<f32>;

    let _e69 = (*g);
    let _e72 = (*g);
    param = _e72;
    let _e73 = hash3((&param));
    let _e79 = (*size);
    return (((_e69 + vec2(0.5f)) + ((_e73.xy - vec2(0.5f)) * 0.7f)) * _e79);
}

fn shardDist(q_1: ptr<function, vec2<f32>>, g_1: ptr<function, vec2<f32>>, size_1: ptr<function, f32>) -> f32 {
    var sj: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: f32;
    var d: f32;
    var y: i32;
    var x: i32;
    var sk: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var dir: vec2<f32>;

    let _e79 = (*g_1);
    param_1 = _e79;
    let _e80 = (*size_1);
    param_2 = _e80;
    let _e81 = seed((&param_1), (&param_2));
    sj = _e81;
    d = 1000000000f;
    y = -1i;
    loop {
        let _e82 = y;
        if (_e82 <= 1i) {
            x = -1i;
            loop {
                let _e84 = x;
                if (_e84 <= 1i) {
                    let _e86 = x;
                    let _e88 = y;
                    if ((_e86 == 0i) && (_e88 == 0i)) {
                        continue;
                    }
                    let _e91 = (*g_1);
                    let _e92 = x;
                    let _e94 = y;
                    param_3 = (_e91 + vec2<f32>(f32(_e92), f32(_e94)));
                    let _e98 = (*size_1);
                    param_4 = _e98;
                    let _e99 = seed((&param_3), (&param_4));
                    sk = _e99;
                    let _e100 = sk;
                    let _e101 = sj;
                    dir = (_e100 - _e101);
                    let _e103 = d;
                    let _e104 = sj;
                    let _e105 = sk;
                    let _e108 = (*q_1);
                    let _e110 = dir;
                    let _e112 = dir;
                    d = min(_e103, (dot((((_e104 + _e105) * 0.5f) - _e108), _e110) / length(_e112)));
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e116 = x;
                    x = (_e116 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e118 = y;
            y = (_e118 + 1i);
        }
    }
    let _e120 = d;
    return _e120;
}

fn ease(t: ptr<function, f32>) -> f32 {
    let _e67 = (*t);
    let _e68 = (*t);
    let _e70 = (*t);
    return ((_e67 * _e68) * (3f - (2f * _e70)));
}

fn burst(t_1: ptr<function, f32>) -> f32 {
    var u: f32;
    var v: f32;
    var local: f32;
    var param_5: f32;

    let _e71 = (*t_1);
    u = clamp((_e71 / 0.4f), 0f, 1f);
    let _e74 = (*t_1);
    v = clamp(((_e74 - 0.4f) / 0.6f), 0f, 1f);
    let _e78 = (*t_1);
    if (_e78 < 0.4f) {
        let _e80 = u;
        let _e82 = u;
        local = (1f - ((1f - _e80) * (1f - _e82)));
    } else {
        let _e86 = v;
        param_5 = _e86;
        let _e87 = ease((&param_5));
        local = (1f - _e87);
    }
    let _e89 = local;
    return _e89;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var aspect: vec2<f32>;
    var x_1: vec2<f32>;
    var size_2: f32;
    var E: f32;
    var Z: f32;
    var p_1: f32;
    var L: vec3<f32>;
    var H: vec3<f32>;
    var eye: vec3<f32>;
    var dir_1: vec3<f32>;
    var act: f32;
    var b0_: f32;
    var param_6: f32;
    var x0_: vec2<f32>;
    var cell0_: vec2<f32>;
    var z1_: f32;
    var z2_: f32;
    var q1_: vec2<f32>;
    var q2_: vec2<f32>;
    var f1_: f32;
    var f2_: f32;
    var m1_: f32;
    var m2_: f32;
    var s1_: f32;
    var s2_: f32;
    var r1_: f32;
    var r2_: f32;
    var j: i32;
    var i: i32;
    var g_2: vec2<f32>;
    var h: vec3<f32>;
    var param_7: vec2<f32>;
    var t_2: f32;
    var b: f32;
    var param_8: f32;
    var th: f32;
    var param_9: f32;
    var ct: f32;
    var st: f32;
    var phi: f32;
    var rz: f32;
    var a0_: vec2<f32>;
    var p0_: vec2<f32>;
    var a: vec3<f32>;
    var w: vec3<f32>;
    var c: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var center: vec3<f32>;
    var nrm: vec3<f32>;
    var den: f32;
    var lam: f32;
    var hit: vec3<f32>;
    var u_1: f32;
    var v_1: f32;
    var front: f32;
    var q_2: vec2<f32>;
    var k: f32;
    var e: f32;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var box: vec2<f32>;
    var m: f32;
    var zk: f32;
    var n: vec3<f32>;
    var lit: f32;
    var glint: f32;
    var lock: f32;
    var rim: f32;
    var col: vec4<f32>;
    var src: vec2<f32>;
    var img: vec4<f32>;
    var local_1: vec4<f32>;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var src_1: vec2<f32>;
    var img_1: vec4<f32>;
    var local_2: vec4<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;

    let _e149 = uniforms.ratio;
    aspect = vec2<f32>(_e149, 1f);
    let _e151 = (*uv_2);
    let _e154 = aspect;
    x_1 = ((_e151 - vec2(0.5f)) * _e154);
    let _e157 = uniforms.rows;
    size_2 = (1f / clamp(f32(_e157), 1f, 8f));
    let _e162 = uniforms.spread;
    E = clamp(_e162, 0f, 0.5f);
    let _e165 = uniforms.depth;
    Z = clamp(_e165, 0f, 1f);
    let _e168 = uniforms.progress;
    p_1 = clamp(_e168, 0f, 1f);
    L = vec3<f32>(-0.36681262f, 0.44832653f, 0.8151392f);
    let _e170 = L;
    H = normalize((_e170 + vec3<f32>(0f, 0f, 1f)));
    eye = vec3<f32>(0f, 0f, 2.5f);
    let _e173 = x_1;
    dir_1 = vec3<f32>(_e173.x, _e173.y, -2.5f);
    let _e177 = p_1;
    let _e179 = p_1;
    act = (smoothstep(0f, 0.11f, _e177) * (1f - smoothstep(0.89f, 1f, _e179)));
    let _e183 = p_1;
    param_6 = clamp((((_e183 - 0.03f) - 0.04f) / 0.86f), 0f, 1f);
    let _e188 = burst((&param_6));
    b0_ = _e188;
    let _e189 = x_1;
    let _e190 = Z;
    let _e192 = b0_;
    let _e198 = E;
    let _e199 = b0_;
    x0_ = (((_e189 * (2.5f - ((0.75f * _e190) * _e192))) / vec2(2.5f)) / vec2((1f + (_e198 * _e199))));
    let _e204 = x0_;
    let _e205 = size_2;
    cell0_ = floor((_e204 / vec2(_e205)));
    z1_ = 1000000000f;
    z2_ = 1000000000f;
    let _e209 = x_1;
    q1_ = _e209;
    let _e210 = x_1;
    q2_ = _e210;
    f1_ = 1f;
    f2_ = 1f;
    m1_ = 0f;
    m2_ = 0f;
    s1_ = 1f;
    s2_ = 1f;
    r1_ = 0f;
    r2_ = 0f;
    j = -1i;
    loop {
        let _e211 = j;
        if (_e211 <= 1i) {
            i = -1i;
            loop {
                let _e213 = i;
                if (_e213 <= 1i) {
                    let _e215 = cell0_;
                    let _e216 = i;
                    let _e218 = j;
                    g_2 = (_e215 + vec2<f32>(f32(_e216), f32(_e218)));
                    let _e222 = g_2;
                    param_7 = (_e222 + vec2(17f));
                    let _e225 = hash3((&param_7));
                    h = _e225;
                    let _e226 = p_1;
                    let _e229 = h[0u];
                    t_2 = clamp((((_e226 - 0.03f) - (0.08f * _e229)) / 0.86f), 0f, 1f);
                    let _e234 = t_2;
                    param_8 = _e234;
                    let _e235 = burst((&param_8));
                    b = _e235;
                    let _e236 = t_2;
                    let _e239 = h[2u];
                    param_9 = clamp((((_e236 - 0.1f) - (0.48f * _e239)) / 0.24f), 0f, 1f);
                    let _e244 = ease((&param_9));
                    th = (3.1415927f * _e244);
                    let _e246 = th;
                    ct = cos(_e246);
                    let _e248 = th;
                    st = sin(_e248);
                    let _e251 = h[1u];
                    phi = (3.1415927f * _e251);
                    let _e254 = h[2u];
                    let _e257 = b;
                    rz = ((0.5f * (_e254 - 0.5f)) * _e257);
                    let _e259 = phi;
                    let _e261 = phi;
                    a0_ = vec2<f32>(cos(_e259), sin(_e261));
                    let _e265 = a0_[1u];
                    let _e268 = a0_[0u];
                    p0_ = vec2<f32>(-(_e265), _e268);
                    let _e270 = phi;
                    let _e271 = rz;
                    let _e274 = phi;
                    let _e275 = rz;
                    a = vec3<f32>(cos((_e270 + _e271)), sin((_e274 + _e275)), 0f);
                    let _e280 = a[1u];
                    let _e283 = a[0u];
                    let _e285 = ct;
                    let _e287 = st;
                    w = ((vec3<f32>(-(_e280), _e283, 0f) * _e285) + vec3<f32>(0f, 0f, _e287));
                    let _e290 = g_2;
                    param_10 = _e290;
                    let _e291 = size_2;
                    param_11 = _e291;
                    let _e292 = seed((&param_10), (&param_11));
                    c = _e292;
                    let _e293 = c;
                    let _e294 = E;
                    let _e295 = b;
                    let _e298 = (_e293 * (1f + (_e294 * _e295)));
                    let _e299 = Z;
                    let _e300 = b;
                    let _e303 = h[0u];
                    center = vec3<f32>(_e298.x, _e298.y, ((_e299 * _e300) * (0.5f + (0.5f * _e303))));
                    let _e310 = a;
                    let _e311 = w;
                    nrm = cross(_e310, _e311);
                    let _e313 = dir_1;
                    let _e314 = nrm;
                    den = dot(_e313, _e314);
                    let _e316 = den;
                    if (abs(_e316) < 0.000001f) {
                        continue;
                    }
                    let _e319 = center;
                    let _e320 = eye;
                    let _e322 = nrm;
                    let _e324 = den;
                    lam = (dot((_e319 - _e320), _e322) / _e324);
                    let _e326 = lam;
                    if (_e326 <= 0f) {
                        continue;
                    }
                    let _e328 = eye;
                    let _e329 = lam;
                    let _e330 = dir_1;
                    let _e333 = center;
                    hit = ((_e328 + (_e330 * _e329)) - _e333);
                    let _e335 = hit;
                    let _e336 = a;
                    u_1 = dot(_e335, _e336);
                    let _e338 = hit;
                    let _e339 = w;
                    v_1 = dot(_e338, _e339);
                    let _e341 = den;
                    front = select(-1f, 1f, (_e341 < 0f));
                    let _e344 = c;
                    let _e345 = u_1;
                    let _e346 = a0_;
                    let _e349 = front;
                    let _e350 = v_1;
                    let _e352 = p0_;
                    q_2 = ((_e344 + (_e346 * _e345)) + (_e352 * (_e349 * _e350)));
                    let _e356 = center[2u];
                    k = (2.5f / (2.5f - _e356));
                    let _e359 = q_2;
                    param_12 = _e359;
                    let _e360 = g_2;
                    param_13 = _e360;
                    let _e361 = size_2;
                    param_14 = _e361;
                    let _e362 = shardDist((&param_12), (&param_13), (&param_14));
                    let _e363 = act;
                    e = (_e362 - (0.005f * _e363));
                    let _e366 = aspect;
                    let _e368 = q_2;
                    box = ((_e366 * 0.5f) - abs(_e368));
                    let _e371 = e;
                    let _e373 = box[0u];
                    let _e375 = box[1u];
                    let _e378 = k;
                    let _e380 = ct;
                    let _e383 = b;
                    let _e388 = act;
                    e = (((min(_e371, min(_e373, _e375)) * _e378) * mix(1f, max(abs(_e380), 0.2f), min((_e383 * 8f), 1f))) + (0.006f * (1f - _e388)));
                    let _e392 = e;
                    m = clamp(((_e392 / 0.003f) + 0.5f), 0f, 1f);
                    let _e396 = lam;
                    let _e397 = m;
                    zk = (_e396 - (0.001f * _e397));
                    let _e400 = m;
                    let _e402 = zk;
                    let _e403 = z2_;
                    if ((_e400 <= 0f) || (_e402 >= _e403)) {
                        continue;
                    }
                    let _e406 = nrm;
                    let _e407 = front;
                    n = (_e406 * _e407);
                    let _e409 = n;
                    let _e410 = L;
                    let _e413 = L[2u];
                    lit = mix(0.45f, 1f, clamp((dot(_e409, _e410) / _e413), 0f, 1f));
                    let _e417 = b;
                    let _e421 = n;
                    let _e422 = H;
                    glint = ((0.2f * min((_e417 * 4f), 1f)) * pow(max(dot(_e421, _e422), 0f), 24f));
                    let _e427 = t_2;
                    lock = sin((3.1415927f * clamp(((_e427 - 0.86f) / 0.14f), 0f, 1f)));
                    let _e433 = act;
                    let _e435 = b;
                    let _e439 = lock;
                    let _e442 = e;
                    rim = ((((0.3f * _e433) * min((_e435 * 4f), 1f)) + (0.35f * _e439)) * (1f - smoothstep(0f, 0.006f, _e442)));
                    let _e446 = zk;
                    let _e447 = z1_;
                    if (_e446 < _e447) {
                        let _e449 = z1_;
                        z2_ = _e449;
                        let _e450 = q1_;
                        q2_ = _e450;
                        let _e451 = f1_;
                        f2_ = _e451;
                        let _e452 = m1_;
                        m2_ = _e452;
                        let _e453 = s1_;
                        s2_ = _e453;
                        let _e454 = r1_;
                        r2_ = _e454;
                        let _e455 = zk;
                        z1_ = _e455;
                        let _e456 = q_2;
                        q1_ = _e456;
                        let _e457 = front;
                        f1_ = _e457;
                        let _e458 = m;
                        m1_ = _e458;
                        let _e459 = lit;
                        let _e460 = glint;
                        s1_ = (_e459 + _e460);
                        let _e462 = rim;
                        r1_ = _e462;
                    } else {
                        let _e463 = zk;
                        z2_ = _e463;
                        let _e464 = q_2;
                        q2_ = _e464;
                        let _e465 = front;
                        f2_ = _e465;
                        let _e466 = m;
                        m2_ = _e466;
                        let _e467 = lit;
                        let _e468 = glint;
                        s2_ = (_e467 + _e468);
                        let _e470 = rim;
                        r2_ = _e470;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e471 = i;
                    i = (_e471 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e473 = j;
            j = (_e473 + 1i);
        }
    }
    let _e476 = uniforms.backColor;
    col = _e476;
    let _e477 = m2_;
    if (_e477 > 0f) {
        let _e479 = q2_;
        let _e480 = aspect;
        src = ((_e479 / _e480) + vec2(0.5f));
        let _e484 = f2_;
        if (_e484 > 0f) {
            let _e486 = src;
            param_15 = _e486;
            let _e487 = getFromColor((&param_15));
            local_1 = _e487;
        } else {
            let _e488 = src;
            param_16 = _e488;
            let _e489 = getToColor((&param_16));
            local_1 = _e489;
        }
        let _e490 = local_1;
        img = _e490;
        let _e491 = img;
        let _e493 = s2_;
        let _e496 = img[3u];
        let _e500 = img[3u];
        let _e502 = r2_;
        let _e504 = mix(min((_e491.xyz * _e493), vec3(_e496)), vec3(_e500), vec3(_e502));
        img[0u] = _e504.x;
        img[1u] = _e504.y;
        img[2u] = _e504.z;
        let _e511 = col;
        let _e512 = img;
        let _e513 = m2_;
        col = mix(_e511, _e512, vec4(_e513));
    }
    let _e516 = m1_;
    if (_e516 > 0f) {
        let _e518 = q1_;
        let _e519 = aspect;
        src_1 = ((_e518 / _e519) + vec2(0.5f));
        let _e523 = f1_;
        if (_e523 > 0f) {
            let _e525 = src_1;
            param_17 = _e525;
            let _e526 = getFromColor((&param_17));
            local_2 = _e526;
        } else {
            let _e527 = src_1;
            param_18 = _e527;
            let _e528 = getToColor((&param_18));
            local_2 = _e528;
        }
        let _e529 = local_2;
        img_1 = _e529;
        let _e530 = img_1;
        let _e532 = s1_;
        let _e535 = img_1[3u];
        let _e539 = img_1[3u];
        let _e541 = r1_;
        let _e543 = mix(min((_e530.xyz * _e532), vec3(_e535)), vec3(_e539), vec3(_e541));
        img_1[0u] = _e543.x;
        img_1[1u] = _e543.y;
        img_1[2u] = _e543.z;
        let _e550 = col;
        let _e551 = img_1;
        let _e552 = m1_;
        col = mix(_e550, _e551, vec4(_e552));
    }
    let _e555 = col;
    return _e555;
}

fn main_1() {
    var param_19: vec2<f32>;

    let _e67 = _uv_1;
    param_19 = _e67;
    let _e68 = transition((&param_19));
    _fragColor = _e68;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
