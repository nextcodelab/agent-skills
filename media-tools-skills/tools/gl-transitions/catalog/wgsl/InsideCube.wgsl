// InsideCube — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InsideCube.glsl
// Author: gre
// License: MIT
// Description: The camera stands inside a cube: the outgoing image covers the wall in front of it and the view turns toward the next inner wall, so the outgoing image swings away in perspective as the incoming one turns into view, the walls darkening into the shaded inner corner between them
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    fov: f32,
    shading: f32,
    background: vec4<f32>,
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

fn premultiply(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e36 = (*c);
    let _e39 = (*c)[3u];
    let _e40 = (_e36.xyz * _e39);
    let _e42 = (*c)[3u];
    return vec4<f32>(_e40.x, _e40.y, _e40.z, _e42);
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e37 = (*uv)[0u];
    let _e39 = (*uv)[1u];
    let _e42 = textureSampleLevel(_from, _sampler, vec2<f32>(_e37, (1f - _e39)), 0f);
    return _e42;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e37 = (*uv_1)[0u];
    let _e39 = (*uv_1)[1u];
    let _e42 = textureSampleLevel(_to, _sampler, vec2<f32>(_e37, (1f - _e39)), 0f);
    return _e42;
}

fn wallColor(l: ptr<function, vec2<f32>>, incoming: ptr<function, bool>, vertical: ptr<function, bool>, s: ptr<function, f32>) -> vec4<f32> {
    var h: vec2<f32>;
    var p: vec2<f32>;
    var local: vec2<f32>;
    var st: vec2<f32>;
    var local_1: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec4<f32>;

    let _e48 = (*l)[0u];
    let _e49 = (*s);
    let _e52 = (*l)[1u];
    h = vec2<f32>((_e48 * _e49), _e52);
    let _e54 = (*vertical);
    if _e54 {
        let _e55 = h;
        local = _e55.yx;
    } else {
        let _e57 = h;
        local = _e57;
    }
    let _e58 = local;
    p = _e58;
    let _e59 = p;
    let _e61 = uniforms.ratio;
    st = clamp(((_e59 / vec2<f32>(_e61, 1f)) + vec2(0.5f)), vec2(0f), vec2(1f));
    let _e69 = (*incoming);
    if _e69 {
        let _e70 = st;
        param = _e70;
        let _e71 = getToColor((&param));
        local_1 = _e71;
    } else {
        let _e72 = st;
        param_1 = _e72;
        let _e73 = getFromColor((&param_1));
        local_1 = _e73;
    }
    let _e74 = local_1;
    param_2 = _e74;
    let _e75 = premultiply((&param_2));
    return _e75;
}

fn cornerShadow(dist: ptr<function, f32>, size: ptr<function, f32>) -> f32 {
    var k: f32;

    let _e38 = (*size);
    let _e39 = (*dist);
    k = (1f - smoothstep(0f, _e38, _e39));
    let _e42 = k;
    let _e43 = k;
    return (_e42 * _e43);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var vertical_1: bool;
    var s_1: f32;
    var local_2: f32;
    var p_1: vec2<f32>;
    var q: vec2<f32>;
    var local_3: vec2<f32>;
    var A: f32;
    var local_4: f32;
    var B: f32;
    var local_5: f32;
    var F: f32;
    var e: f32;
    var th: f32;
    var c_1: f32;
    var sn: f32;
    var amount: f32;
    var aa: f32;
    var shadow: f32;
    var cam: vec2<f32>;
    var d: vec2<f32>;
    var P: vec2<f32>;
    var sc: f32;
    var tf: f32;
    var local_6: f32;
    var af: f32;
    var lf: vec2<f32>;
    var ti: f32;
    var local_7: f32;
    var ai: f32;
    var li: vec2<f32>;
    var size_1: f32;
    var edgeF: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var edgeI: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var shadeF: f32;
    var shadeI: f32;
    var wF: f32;
    var covF: f32;
    var covI: f32;
    var colF: vec4<f32>;
    var local_8: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: bool;
    var param_13: bool;
    var param_14: f32;
    var colI: vec4<f32>;
    var local_9: vec4<f32>;
    var param_15: vec2<f32>;
    var param_16: bool;
    var param_17: bool;
    var param_18: f32;
    var bg: vec4<f32>;
    var param_19: vec4<f32>;
    var cov: f32;
    var tb: f32;
    var fl: vec2<f32>;
    var edgeB: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var col: vec4<f32>;
    var local_10: vec4<f32>;

    let _e108 = uniforms.direction[1u];
    let _e112 = uniforms.direction[0u];
    vertical_1 = (abs(_e108) > abs(_e112));
    let _e115 = vertical_1;
    if _e115 {
        let _e118 = uniforms.direction[1u];
        local_2 = _e118;
    } else {
        let _e121 = uniforms.direction[0u];
        local_2 = _e121;
    }
    let _e122 = local_2;
    s_1 = select(1f, -1f, (_e122 < 0f));
    let _e125 = (*uv_2);
    let _e129 = uniforms.ratio;
    p_1 = ((_e125 - vec2(0.5f)) * vec2<f32>(_e129, 1f));
    let _e132 = vertical_1;
    if _e132 {
        let _e133 = p_1;
        local_3 = _e133.yx;
    } else {
        let _e135 = p_1;
        local_3 = _e135;
    }
    let _e136 = local_3;
    q = _e136;
    let _e137 = s_1;
    let _e139 = q[0u];
    q[0u] = (_e139 * _e137);
    let _e142 = vertical_1;
    if _e142 {
        local_4 = 0.5f;
    } else {
        let _e144 = uniforms.ratio;
        local_4 = (0.5f * _e144);
    }
    let _e146 = local_4;
    A = _e146;
    let _e147 = vertical_1;
    if _e147 {
        let _e149 = uniforms.ratio;
        local_5 = (0.5f * _e149);
    } else {
        local_5 = 0.5f;
    }
    let _e151 = local_5;
    B = _e151;
    let _e152 = A;
    let _e154 = uniforms.fov;
    F = (_e152 / tan((radians(clamp(_e154, 55f, 170f)) * 0.5f)));
    let _e161 = uniforms.progress;
    e = smoothstep(0f, 1f, _e161);
    let _e163 = e;
    th = (1.5707964f * _e163);
    let _e165 = th;
    c_1 = cos(_e165);
    let _e167 = th;
    sn = sin(_e167);
    let _e169 = e;
    amount = max(sin((3.1415927f * _e169)), 0f);
    let _e173 = amount;
    aa = ((0.002f * min(1f, (40f * _e173))) + 0.000001f);
    let _e179 = uniforms.shading;
    let _e180 = amount;
    shadow = (_e179 * min(1f, (4f * _e180)));
    let _e184 = A;
    let _e185 = F;
    let _e187 = e;
    cam = (vec2<f32>(1f, -1f) * ((_e184 - _e185) * _e187));
    let _e191 = q[0u];
    let _e192 = c_1;
    let _e194 = F;
    let _e195 = sn;
    let _e198 = F;
    let _e199 = c_1;
    let _e202 = q[0u];
    let _e203 = sn;
    d = vec2<f32>(((_e191 * _e192) + (_e194 * _e195)), ((_e198 * _e199) - (_e202 * _e203)));
    let _e207 = A;
    let _e208 = F;
    let _e210 = cam;
    P = (vec2<f32>(_e207, _e208) - _e210);
    let _e212 = F;
    let _e214 = P[0u];
    let _e215 = c_1;
    let _e218 = P[1u];
    let _e219 = sn;
    let _e224 = P[0u];
    let _e225 = sn;
    let _e228 = P[1u];
    let _e229 = c_1;
    sc = ((_e212 * ((_e214 * _e215) - (_e218 * _e219))) / max(((_e224 * _e225) + (_e228 * _e229)), 0.000001f));
    let _e235 = d[1u];
    if (_e235 > 0.000001f) {
        let _e237 = F;
        let _e239 = cam[1u];
        let _e242 = d[1u];
        local_6 = ((_e237 - _e239) / _e242);
    } else {
        local_6 = 1000000f;
    }
    let _e244 = local_6;
    tf = _e244;
    let _e246 = cam[0u];
    let _e247 = tf;
    let _e249 = d[0u];
    af = (_e246 + (_e247 * _e249));
    let _e252 = af;
    let _e254 = q[1u];
    let _e255 = tf;
    lf = vec2<f32>(_e252, (_e254 * _e255));
    let _e259 = d[0u];
    if (_e259 > 0.000001f) {
        let _e261 = A;
        let _e263 = cam[0u];
        let _e266 = d[0u];
        local_7 = ((_e261 - _e263) / _e266);
    } else {
        local_7 = 1000000f;
    }
    let _e268 = local_7;
    ti = _e268;
    let _e269 = F;
    let _e270 = A;
    let _e273 = cam[1u];
    let _e274 = ti;
    let _e276 = d[1u];
    ai = ((_e269 - _e270) - (_e273 + (_e274 * _e276)));
    let _e280 = ai;
    let _e282 = q[1u];
    let _e283 = ti;
    li = vec2<f32>(_e280, (_e282 * _e283));
    let _e286 = A;
    let _e287 = B;
    size_1 = (0.8f * min(_e286, _e287));
    let _e290 = A;
    let _e291 = af;
    param_3 = (_e290 - _e291);
    let _e293 = size_1;
    param_4 = _e293;
    let _e294 = cornerShadow((&param_3), (&param_4));
    let _e295 = B;
    let _e297 = lf[1u];
    param_5 = (_e295 - abs(_e297));
    let _e300 = size_1;
    param_6 = _e300;
    let _e301 = cornerShadow((&param_5), (&param_6));
    edgeF = (_e294 + (0.5f * _e301));
    let _e304 = ai;
    let _e305 = A;
    param_7 = (_e304 + _e305);
    let _e307 = size_1;
    param_8 = _e307;
    let _e308 = cornerShadow((&param_7), (&param_8));
    let _e309 = B;
    let _e311 = li[1u];
    param_9 = (_e309 - abs(_e311));
    let _e314 = size_1;
    param_10 = _e314;
    let _e315 = cornerShadow((&param_9), (&param_10));
    edgeI = (_e308 + (0.5f * _e315));
    let _e319 = uniforms.shading;
    let _e321 = c_1;
    let _e325 = shadow;
    let _e327 = edgeF;
    shadeF = ((1f - ((_e319 * 0.8f) * (1f - _e321))) * (1f - ((0.7f * _e325) * min(_e327, 1f))));
    let _e333 = uniforms.shading;
    let _e335 = sn;
    let _e339 = shadow;
    let _e341 = edgeI;
    shadeI = ((1f - ((_e333 * 0.8f) * (1f - _e335))) * (1f - ((0.7f * _e339) * min(_e341, 1f))));
    let _e346 = sc;
    let _e348 = q[0u];
    let _e350 = aa;
    wF = clamp((0.5f + ((_e346 - _e348) / _e350)), 0f, 1f);
    let _e354 = wF;
    let _e355 = B;
    let _e356 = tf;
    let _e359 = q[1u];
    let _e362 = aa;
    let _e367 = af;
    let _e368 = A;
    let _e371 = d[1u];
    let _e373 = tf;
    let _e374 = F;
    let _e376 = aa;
    covF = ((_e354 * clamp((0.5f + (((_e355 / _e356) - abs(_e359)) / _e362)), 0f, 1f)) * clamp((0.5f + (((_e367 + _e368) * _e371) / ((_e373 * _e374) * _e376))), 0f, 1f));
    let _e382 = wF;
    let _e384 = B;
    let _e385 = ti;
    let _e388 = q[1u];
    let _e391 = aa;
    let _e396 = A;
    let _e397 = ai;
    let _e400 = d[0u];
    let _e402 = ti;
    let _e403 = F;
    let _e405 = aa;
    covI = (((1f - _e382) * clamp((0.5f + (((_e384 / _e385) - abs(_e388)) / _e391)), 0f, 1f)) * clamp((0.5f + (((_e396 - _e397) * _e400) / ((_e402 * _e403) * _e405))), 0f, 1f));
    let _e411 = covF;
    if (_e411 > 0f) {
        let _e413 = lf;
        param_11 = _e413;
        param_12 = false;
        let _e414 = vertical_1;
        param_13 = _e414;
        let _e415 = s_1;
        param_14 = _e415;
        let _e416 = wallColor((&param_11), (&param_12), (&param_13), (&param_14));
        local_8 = _e416;
    } else {
        local_8 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e417 = local_8;
    colF = _e417;
    let _e418 = covI;
    if (_e418 > 0f) {
        let _e420 = li;
        param_15 = _e420;
        param_16 = true;
        let _e421 = vertical_1;
        param_17 = _e421;
        let _e422 = s_1;
        param_18 = _e422;
        let _e423 = wallColor((&param_15), (&param_16), (&param_17), (&param_18));
        local_9 = _e423;
    } else {
        local_9 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e424 = local_9;
    colI = _e424;
    let _e425 = shadeF;
    let _e426 = colF;
    let _e428 = (_e426.xyz * _e425);
    colF[0u] = _e428.x;
    colF[1u] = _e428.y;
    colF[2u] = _e428.z;
    let _e435 = shadeI;
    let _e436 = colI;
    let _e438 = (_e436.xyz * _e435);
    colI[0u] = _e438.x;
    colI[1u] = _e438.y;
    colI[2u] = _e438.z;
    let _e446 = uniforms.background;
    param_19 = _e446;
    let _e447 = premultiply((&param_19));
    bg = _e447;
    let _e448 = covF;
    let _e449 = covI;
    cov = (_e448 + _e449);
    let _e451 = cov;
    if (_e451 < 1f) {
        let _e453 = B;
        let _e455 = q[1u];
        let _e459 = tf;
        let _e460 = ti;
        tb = min((_e453 / max(abs(_e455), 0.000001f)), min(_e459, _e460));
        let _e463 = cam;
        let _e464 = tb;
        let _e465 = d;
        fl = (_e463 + (_e465 * _e464));
        let _e468 = F;
        let _e470 = fl[1u];
        param_20 = (_e468 - _e470);
        let _e472 = size_1;
        param_21 = _e472;
        let _e473 = cornerShadow((&param_20), (&param_21));
        let _e474 = A;
        let _e476 = fl[0u];
        param_22 = (_e474 - _e476);
        let _e478 = size_1;
        param_23 = _e478;
        let _e479 = cornerShadow((&param_22), (&param_23));
        edgeB = (_e473 + _e479);
        let _e481 = shadow;
        let _e483 = edgeB;
        let _e487 = bg;
        let _e489 = (_e487.xyz * (1f - ((0.5f * _e481) * min(_e483, 1f))));
        bg[0u] = _e489.x;
        bg[1u] = _e489.y;
        bg[2u] = _e489.z;
    }
    let _e496 = colF;
    let _e497 = covF;
    let _e499 = colI;
    let _e500 = covI;
    let _e503 = bg;
    let _e504 = cov;
    col = (((_e496 * _e497) + (_e499 * _e500)) + (_e503 * (1f - _e504)));
    let _e509 = col[3u];
    if (_e509 > 0f) {
        let _e511 = col;
        let _e514 = col[3u];
        let _e516 = (_e511.xyz / vec3(_e514));
        let _e518 = col[3u];
        local_10 = vec4<f32>(_e516.x, _e516.y, _e516.z, _e518);
    } else {
        local_10 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e523 = local_10;
    return _e523;
}

fn main_1() {
    var param_24: vec2<f32>;

    let _e36 = _uv_1;
    param_24 = _e36;
    let _e37 = transition((&param_24));
    _fragColor = _e37;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
