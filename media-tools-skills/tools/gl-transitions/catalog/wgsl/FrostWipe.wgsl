// FrostWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FrostWipe.glsl
// Author: gre
// License: MIT
// Description: Ice crystals grow in from the edges of the frame with feathery, branching fronts, frosting the outgoing image white and blurry until it is covered, then thaw back out to the edges on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    spread: f32,
    scale: f32,
    blur: f32,
    color: vec4<f32>,
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
    let _e86 = (*v);
    let _e87 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e86 - (floor((_e86 / _e87)) * _e87)))));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e87 = (*v_1);
    v3_ = fract((_e87.xyx * 0.1031f));
    let _e91 = v3_;
    let _e92 = v3_;
    let _e97 = v3_;
    v3_ = (_e97 + vec3(dot(_e91, (_e92.yzx + vec3(33.33f)))));
    let _e101 = v3_[0u];
    let _e103 = v3_[1u];
    let _e106 = v3_[2u];
    return fract(((_e101 + _e103) * _e106));
}

fn vnoise(v_2: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e92 = (*v_2);
    i = floor(_e92);
    let _e94 = (*v_2);
    f = fract(_e94);
    let _e96 = f;
    let _e97 = f;
    let _e99 = f;
    f = ((_e96 * _e97) * (vec2(3f) - (_e99 * 2f)));
    let _e104 = i;
    param = _e104;
    let _e105 = hash12((&param));
    let _e106 = i;
    param_1 = (_e106 + vec2<f32>(1f, 0f));
    let _e108 = hash12((&param_1));
    let _e110 = f[0u];
    let _e112 = i;
    param_2 = (_e112 + vec2<f32>(0f, 1f));
    let _e114 = hash12((&param_2));
    let _e115 = i;
    param_3 = (_e115 + vec2<f32>(1f, 1f));
    let _e117 = hash12((&param_3));
    let _e119 = f[0u];
    let _e122 = f[1u];
    return mix(mix(_e105, _e108, _e110), mix(_e114, _e117, _e119), _e122);
}

fn ridged(v_3: ptr<function, vec2<f32>>) -> f32 {
    var sum: f32;
    var amp: f32;
    var i_1: i32;
    var n: f32;
    var param_4: vec2<f32>;

    sum = 0f;
    amp = 0.5f;
    i_1 = 0i;
    loop {
        let _e91 = i_1;
        if (_e91 < 4i) {
            let _e93 = (*v_3);
            param_4 = _e93;
            let _e94 = vnoise((&param_4));
            n = (1f - abs(((2f * _e94) - 1f)));
            let _e99 = amp;
            let _e100 = n;
            let _e102 = n;
            let _e104 = sum;
            sum = (_e104 + ((_e99 * _e100) * _e102));
            let _e106 = (*v_3);
            (*v_3) = ((mat2x2<f32>(vec2<f32>(1.6f, 1.2f), vec2<f32>(-1.2f, 1.6f)) * _e106) + vec2(4.7f));
            let _e110 = amp;
            amp = (_e110 * 0.5f);
            continue;
        } else {
            break;
        }
        continuing {
            let _e112 = i_1;
            i_1 = (_e112 + 1i);
        }
    }
    let _e114 = sum;
    return (_e114 / 0.9375f);
}

fn grains(v_4: ptr<function, vec2<f32>>) -> vec4<f32> {
    var i_2: vec2<f32>;
    var f_1: vec2<f32>;
    var d1_: f32;
    var d2_: f32;
    var seed: vec3<f32>;
    var y: i32;
    var x: i32;
    var c: vec2<f32>;
    var o: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var d: f32;
    var param_7: vec2<f32>;

    let _e99 = (*v_4);
    i_2 = floor(_e99);
    let _e101 = (*v_4);
    f_1 = fract(_e101);
    d1_ = 8f;
    d2_ = 8f;
    seed = vec3<f32>(0f, 0f, 0f);
    y = -1i;
    loop {
        let _e103 = y;
        if (_e103 <= 1i) {
            x = -1i;
            loop {
                let _e105 = x;
                if (_e105 <= 1i) {
                    let _e107 = x;
                    let _e109 = y;
                    c = vec2<f32>(f32(_e107), f32(_e109));
                    let _e112 = c;
                    let _e113 = i_2;
                    let _e114 = c;
                    param_5 = (_e113 + _e114);
                    let _e116 = hash12((&param_5));
                    let _e117 = i_2;
                    let _e118 = c;
                    param_6 = ((_e117 + _e118) + vec2(17.3f));
                    let _e122 = hash12((&param_6));
                    let _e125 = f_1;
                    o = ((_e112 + vec2<f32>(_e116, _e122)) - _e125);
                    let _e127 = o;
                    let _e128 = o;
                    d = dot(_e127, _e128);
                    let _e130 = d;
                    let _e131 = d1_;
                    if (_e130 < _e131) {
                        let _e133 = d1_;
                        d2_ = _e133;
                        let _e134 = d;
                        d1_ = _e134;
                        let _e135 = i_2;
                        let _e136 = c;
                        param_7 = ((_e135 + _e136) + vec2(41.9f));
                        let _e140 = hash12((&param_7));
                        let _e141 = o;
                        let _e142 = -(_e141);
                        seed = vec3<f32>(_e140, _e142.x, _e142.y);
                    } else {
                        let _e146 = d;
                        let _e147 = d2_;
                        if (_e146 < _e147) {
                            let _e149 = d;
                            d2_ = _e149;
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e150 = x;
                    x = (_e150 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e152 = y;
            y = (_e152 + 1i);
        }
    }
    let _e154 = d2_;
    let _e156 = d1_;
    let _e159 = seed;
    return vec4<f32>((sqrt(_e154) - sqrt(_e156)), _e159.x, _e159.y, _e159.z);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e87 = (*uv)[0u];
    let _e89 = (*uv)[1u];
    let _e92 = textureSampleLevel(_to, _sampler, vec2<f32>(_e87, (1f - _e89)), 0f);
    return _e92;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e87 = (*uv_1)[0u];
    let _e89 = (*uv_1)[1u];
    let _e92 = textureSampleLevel(_from, _sampler, vec2<f32>(_e87, (1f - _e89)), 0f);
    return _e92;
}

fn image(uv_2: ptr<function, vec2<f32>>, m: ptr<function, f32>) -> vec4<f32> {
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;

    let _e91 = (*m);
    if (_e91 <= 0f) {
        let _e93 = (*uv_2);
        param_8 = _e93;
        let _e94 = getFromColor((&param_8));
        return _e94;
    }
    let _e95 = (*m);
    if (_e95 >= 1f) {
        let _e97 = (*uv_2);
        param_9 = _e97;
        let _e98 = getToColor((&param_9));
        return _e98;
    }
    let _e99 = (*uv_2);
    param_10 = _e99;
    let _e100 = getFromColor((&param_10));
    let _e101 = (*uv_2);
    param_11 = _e101;
    let _e102 = getToColor((&param_11));
    let _e103 = (*m);
    return mix(_e100, _e102, vec4(_e103));
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var h: f32;
    var a: f32;
    var m_1: f32;
    var param_12: vec2<f32>;
    var param_13: f32;
    var q: vec2<f32>;
    var dEdge: vec2<f32>;
    var depth: f32;
    var reach: f32;
    var front: f32;
    var param_14: vec2<f32>;
    var param_15: f32;
    var gv: vec2<f32>;
    var gr: vec4<f32>;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var u: f32;
    var dir: vec2<f32>;
    var t: f32;
    var needle: f32;
    var nh: f32;
    var len: f32;
    var r: f32;
    var param_19: vec2<f32>;
    var rf: f32;
    var param_20: vec2<f32>;
    var grow: f32;
    var field: f32;
    var inside: f32;
    var f_2: f32;
    var haze: f32;
    var frost: f32;
    var param_21: vec2<f32>;
    var param_22: f32;
    var thick: f32;
    var full: f32;
    var radius: f32;
    var rot: f32;
    var param_23: vec2<f32>;
    var rgb: vec3<f32>;
    var alpha: f32;
    var i_3: i32;
    var k: f32;
    var th: f32;
    var off: vec2<f32>;
    var c_1: vec4<f32>;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: f32;
    var local: vec3<f32>;
    var stem: f32;
    var needles: f32;
    var glint: f32;
    var veins: f32;
    var rim: f32;
    var ice: vec3<f32>;
    var cover: f32;
    var under: vec4<f32>;
    var res: vec4<f32>;
    var sq: vec2<f32>;
    var cell: vec2<f32>;
    var d_1: vec2<f32>;
    var param_27: vec2<f32>;
    var param_28: vec2<f32>;
    var star: f32;
    var tw: f32;
    var param_29: vec2<f32>;
    var sparkle: f32;
    var param_30: vec2<f32>;
    var light: f32;

    let _e159 = uniforms.progress;
    p = _e159;
    let _e160 = p;
    h = (1f - abs(((2f * _e160) - 1f)));
    let _e165 = h;
    a = clamp((_e165 / 0.85f), 0f, 1f);
    let _e168 = a;
    let _e169 = a;
    a = (_e168 * (1.6f - (0.6f * _e169)));
    let _e173 = p;
    m_1 = smoothstep(0.47f, 0.53f, _e173);
    let _e175 = a;
    if (_e175 <= 0f) {
        let _e177 = (*uv_3);
        param_12 = _e177;
        let _e178 = m_1;
        param_13 = _e178;
        let _e179 = image((&param_12), (&param_13));
        return _e179;
    }
    let _e180 = (*uv_3);
    let _e182 = uniforms.ratio;
    q = (_e180 * vec2<f32>(_e182, 1f));
    let _e185 = (*uv_3);
    let _e186 = (*uv_3);
    let _e191 = uniforms.ratio;
    dEdge = (min(_e185, (vec2(1f) - _e186)) * vec2<f32>(_e191, 1f));
    let _e195 = dEdge[0u];
    let _e197 = dEdge[1u];
    let _e200 = uniforms.ratio;
    depth = (min(_e195, _e197) / (0.5f * min(_e200, 1f)));
    let _e204 = depth;
    let _e206 = depth;
    depth = (1f - ((1f - _e204) * (1f - _e206)));
    let _e211 = uniforms.spread;
    reach = (0.2f + (0.6f * clamp(_e211, 0f, 1f)));
    let _e215 = reach;
    let _e218 = a;
    front = mix(-0.1f, ((1f + _e215) + 0.2f), _e218);
    let _e220 = depth;
    let _e221 = front;
    if (_e220 > (_e221 + 0.08f)) {
        let _e224 = (*uv_3);
        param_14 = _e224;
        let _e225 = m_1;
        param_15 = _e225;
        let _e226 = image((&param_14), (&param_15));
        return _e226;
    }
    let _e227 = q;
    let _e229 = uniforms.scale;
    gv = (_e227 * _e229);
    let _e231 = gv;
    let _e232 = gv;
    param_16 = (_e232 * 1.7f);
    let _e234 = vnoise((&param_16));
    let _e235 = gv;
    param_17 = ((_e235 * 1.7f) + vec2(23.1f));
    let _e239 = vnoise((&param_17));
    param_18 = (_e231 + (vec2<f32>(_e234, _e239) * 0.35f));
    let _e243 = grains((&param_18));
    gr = _e243;
    let _e245 = gr[1u];
    u = ((2f * _e245) - 1f);
    let _e248 = u;
    let _e249 = u;
    let _e252 = u;
    let _e255 = u;
    let _e256 = u;
    dir = (vec2<f32>((1f - (_e248 * _e249)), (2f * _e252)) / vec2((1f + (_e255 * _e256))));
    let _e261 = gr;
    let _e263 = dir;
    t = (dot(_e261.zw, _e263) * 7f);
    let _e266 = t;
    needle = (1f - abs(((2f * fract(_e266)) - 1f)));
    let _e273 = gr[1u];
    let _e274 = t;
    nh = fract((_e273 + (0.618034f * floor(_e274))));
    let _e279 = nh;
    len = mix(0.15f, 0.6f, _e279);
    let _e281 = gv;
    param_19 = (_e281 * 1.3f);
    let _e283 = ridged((&param_19));
    r = _e283;
    let _e284 = gv;
    param_20 = ((_e284 * 4f) + vec2(11f));
    let _e288 = ridged((&param_20));
    rf = _e288;
    let _e290 = gr[0u];
    let _e293 = gr[0u];
    let _e294 = len;
    let _e297 = needle;
    let _e301 = nh;
    grow = min((_e290 * 3.5f), ((((_e293 / _e294) * 0.5f) + ((1f - _e297) * 1.2f)) + (0.2f * fract((_e301 * 13.7f)))));
    let _e307 = depth;
    let _e308 = reach;
    let _e309 = grow;
    let _e312 = r;
    let _e318 = rf;
    field = ((_e307 + (_e308 * ((0.8f * min(_e309, 1f)) + (0.2f * (1f - _e312))))) + (0.1f * (1f - _e318)));
    let _e322 = front;
    let _e323 = field;
    inside = (_e322 - _e323);
    let _e325 = inside;
    f_2 = smoothstep(0f, 0.03f, _e325);
    let _e327 = rf;
    let _e330 = inside;
    haze = ((0.4f * smoothstep(0.9f, 1f, _e327)) * smoothstep(-0.08f, 0f, _e330));
    let _e333 = f_2;
    let _e334 = haze;
    frost = max(_e333, _e334);
    let _e336 = frost;
    if (_e336 <= 0f) {
        let _e338 = (*uv_3);
        param_21 = _e338;
        let _e339 = m_1;
        param_22 = _e339;
        let _e340 = image((&param_21), (&param_22));
        return _e340;
    }
    let _e341 = inside;
    thick = smoothstep(0f, 0.5f, _e341);
    let _e343 = h;
    full = smoothstep(0.75f, 0.95f, _e343);
    let _e346 = uniforms.blur;
    let _e349 = frost;
    let _e351 = thick;
    radius = (((0.004f + (0.03f * _e346)) * _e349) * (0.5f + (0.5f * _e351)));
    let _e355 = q;
    param_23 = floor((_e355 * 90f));
    let _e358 = hash12((&param_23));
    rot = (6.2831855f * _e358);
    rgb = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    i_3 = 0i;
    loop {
        let _e360 = i_3;
        if (_e360 < 12i) {
            let _e362 = i_3;
            k = ((f32(_e362) + 0.5f) / 12f);
            let _e366 = rot;
            let _e367 = i_3;
            th = (_e366 + (f32(_e367) * 2.3999631f));
            let _e371 = k;
            let _e373 = th;
            let _e375 = th;
            let _e379 = radius;
            off = ((vec2<f32>(cos(_e373), sin(_e375)) * sqrt(_e371)) * _e379);
            let _e381 = (*uv_3);
            let _e382 = off;
            let _e384 = uniforms.ratio;
            param_24 = (_e381 + (_e382 / vec2<f32>(_e384, 1f)));
            let _e388 = mirror((&param_24));
            param_25 = _e388;
            let _e389 = m_1;
            param_26 = _e389;
            let _e390 = image((&param_25), (&param_26));
            c_1 = _e390;
            let _e391 = c_1;
            let _e394 = c_1[3u];
            let _e396 = rgb;
            rgb = (_e396 + (_e391.xyz * _e394));
            let _e399 = c_1[3u];
            let _e400 = alpha;
            alpha = (_e400 + _e399);
            continue;
        } else {
            break;
        }
        continuing {
            let _e402 = i_3;
            i_3 = (_e402 + 1i);
        }
    }
    let _e404 = alpha;
    alpha = (_e404 / 12f);
    let _e406 = alpha;
    if (_e406 > 0f) {
        let _e408 = rgb;
        let _e409 = alpha;
        local = (_e408 / vec3((_e409 * 12f)));
    } else {
        local = vec3<f32>(0f, 0f, 0f);
    }
    let _e413 = local;
    rgb = _e413;
    let _e415 = gr[0u];
    stem = (1f - smoothstep(0f, 0.03f, _e415));
    let _e418 = needle;
    let _e420 = len;
    let _e422 = gr[0u];
    needles = (smoothstep(0.7f, 1f, _e418) * (1f - smoothstep(0f, _e420, _e422)));
    let _e426 = rf;
    glint = (0.4f + (0.6f * _e426));
    let _e429 = glint;
    let _e430 = stem;
    let _e432 = needles;
    let _e436 = r;
    veins = clamp(((_e429 * max((0.35f * _e430), (0.55f * _e432))) + (0.3f * smoothstep(0.6f, 0.95f, _e436))), 0f, 1f);
    let _e441 = inside;
    let _e443 = inside;
    rim = (smoothstep(0f, 0.02f, _e441) * (1f - smoothstep(0.02f, 0.07f, _e443)));
    let _e448 = uniforms.color;
    let _e450 = veins;
    ice = clamp((_e448.xyz * (0.82f + (0.25f * _e450))), vec3(0f), vec3(1f));
    let _e457 = frost;
    let _e458 = thick;
    let _e461 = veins;
    cover = (_e457 * ((0.35f + (0.3f * _e458)) + (0.25f * _e461)));
    let _e465 = cover;
    let _e466 = frost;
    let _e467 = full;
    cover = clamp(mix(_e465, _e466, _e467), 0f, 1f);
    let _e470 = rgb;
    let _e472 = uniforms.color;
    let _e474 = frost;
    let _e478 = (_e470 * mix(vec3<f32>(1f, 1f, 1f), _e472.xyz, vec3((0.5f * _e474))));
    let _e479 = alpha;
    under = vec4<f32>(_e478.x, _e478.y, _e478.z, _e479);
    let _e484 = under;
    let _e485 = ice;
    let _e488 = uniforms.color[3u];
    let _e493 = cover;
    res = mix(_e484, vec4<f32>(_e485.x, _e485.y, _e485.z, _e488), vec4(_e493));
    let _e496 = q;
    sq = (_e496 * 36f);
    let _e498 = sq;
    cell = floor(_e498);
    let _e500 = sq;
    let _e501 = cell;
    let _e505 = cell;
    param_27 = (_e505 + vec2(1.3f));
    let _e508 = hash12((&param_27));
    let _e509 = cell;
    param_28 = (_e509 + vec2(5.9f));
    let _e512 = hash12((&param_28));
    d_1 = abs((((_e500 - _e501) - vec2(0.25f)) - (vec2<f32>(_e508, _e512) * 0.5f)));
    let _e517 = d_1;
    let _e523 = d_1[0u];
    let _e525 = d_1[1u];
    let _e530 = d_1[0u];
    let _e532 = d_1[1u];
    star = (max(0f, (1f - (9f * length(_e517)))) + max(0f, ((1f - (4f * (_e523 + _e525))) - (30f * min(_e530, _e532)))));
    let _e538 = cell;
    param_29 = (_e538 + vec2(9.1f));
    let _e541 = hash12((&param_29));
    let _e542 = p;
    tw = (0.5f + (0.5f * sin((6.2831855f * (_e541 + (2f * _e542))))));
    let _e549 = cell;
    param_30 = (_e549 + vec2(3.7f));
    let _e552 = hash12((&param_30));
    let _e554 = star;
    let _e557 = tw;
    let _e559 = f_2;
    let _e561 = veins;
    sparkle = ((((step(0.82f, _e552) * min(_e554, 1f)) * _e557) * _e559) * (0.4f + (0.6f * _e561)));
    let _e565 = rim;
    let _e567 = sparkle;
    light = clamp(((0.4f * _e565) + (0.8f * _e567)), 0f, 1f);
    let _e571 = res;
    let _e573 = uniforms.color;
    let _e576 = mix(_e573.xyz, vec3<f32>(1f, 1f, 1f), vec3(0.6f));
    let _e579 = uniforms.color[3u];
    let _e584 = light;
    res = mix(_e571, vec4<f32>(_e576.x, _e576.y, _e576.z, _e579), vec4(_e584));
    let _e587 = res;
    return clamp(_e587, vec4(0f), vec4(1f));
}

fn main_1() {
    var param_31: vec2<f32>;

    let _e86 = _uv_1;
    param_31 = _e86;
    let _e87 = transition((&param_31));
    _fragColor = _e87;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
