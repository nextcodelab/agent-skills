// VhsTracking — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/VhsTracking.glsl
// Author: gre
// License: MIT
// Description: Tape-tracking bands of white snow roll down the frame, tearing the lines around them, with smeared color, wobbling lines, a jittering strip at the bottom and a dropout flash, as the incoming image is recorded over the outgoing one under the densest band
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    bands: i32,
    noise: f32,
    bleed: f32,
    wobble: f32,
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

fn luma(c: ptr<function, vec3<f32>>) -> f32 {
    let _e73 = (*c);
    return dot(_e73, vec3<f32>(0.299f, 0.587f, 0.114f));
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e74 = (*uv)[0u];
    let _e76 = (*uv)[1u];
    let _e79 = textureSampleLevel(_from, _sampler, vec2<f32>(_e74, (1f - _e76)), 0f);
    return _e79;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e74 = (*uv_1)[0u];
    let _e76 = (*uv_1)[1u];
    let _e79 = textureSampleLevel(_to, _sampler, vec2<f32>(_e74, (1f - _e76)), 0f);
    return _e79;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e73 = (*v);
    let _e74 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e73 - (floor((_e73 / _e74)) * _e74)))));
}

fn tape(p: ptr<function, vec2<f32>>, fresh: ptr<function, bool>) -> vec4<f32> {
    var param: vec2<f32>;
    var c_1: vec4<f32>;
    var local: vec4<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e79 = (*p);
    param = _e79;
    let _e80 = mirror((&param));
    (*p) = _e80;
    let _e81 = (*fresh);
    if _e81 {
        let _e82 = (*p);
        param_1 = _e82;
        let _e83 = getToColor((&param_1));
        local = _e83;
    } else {
        let _e84 = (*p);
        param_2 = _e84;
        let _e85 = getFromColor((&param_2));
        local = _e85;
    }
    let _e86 = local;
    c_1 = _e86;
    let _e87 = c_1;
    let _e90 = c_1[3u];
    let _e91 = (_e87.xyz * _e90);
    let _e93 = c_1[3u];
    return vec4<f32>(_e91.x, _e91.y, _e91.z, _e93);
}

fn bandDensity(y: ptr<function, f32>, c_2: ptr<function, f32>, w: ptr<function, f32>, jitter: ptr<function, f32>) -> f32 {
    var d: f32;

    let _e77 = (*y);
    let _e78 = (*c_2);
    let _e81 = (*w);
    let _e83 = (*jitter);
    d = ((abs((_e77 - _e78)) / _e81) + (0.35f * _e83));
    let _e86 = d;
    return (1f - smoothstep(0f, 1f, _e86));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e74 = (*v_1);
    v3_ = fract((_e74.xyx * 0.1031f));
    let _e78 = v3_;
    let _e79 = v3_;
    let _e84 = v3_;
    v3_ = (_e84 + vec3(dot(_e78, (_e79.yzx + vec3(33.33f)))));
    let _e88 = v3_[0u];
    let _e90 = v3_[1u];
    let _e93 = v3_[2u];
    return fract(((_e88 + _e90) * _e93));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var h: f32;
    var env: f32;
    var f: f32;
    var flash: f32;
    var frame: f32;
    var line: f32;
    var jitter_1: f32;
    var param_3: vec2<f32>;
    var c0_: f32;
    var fresh_1: bool;
    var dens: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var tear: f32;
    var i: i32;
    var k: f32;
    var w_1: f32;
    var param_8: vec2<f32>;
    var speed: f32;
    var cy: f32;
    var param_9: vec2<f32>;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var rowTear: f32;
    var param_14: vec2<f32>;
    var dx: f32;
    var strip: f32;
    var param_15: vec2<f32>;
    var q: vec2<f32>;
    var c_3: vec4<f32>;
    var param_16: vec2<f32>;
    var param_17: bool;
    var len: f32;
    var avg: vec4<f32>;
    var i_1: i32;
    var u: f32;
    var param_18: vec2<f32>;
    var param_19: bool;
    var chroma: vec3<f32>;
    var param_20: vec3<f32>;
    var rgb: vec3<f32>;
    var param_21: vec3<f32>;
    var param_22: vec3<f32>;
    var cell: vec2<f32>;
    var n: f32;
    var param_23: vec2<f32>;
    var amount: f32;
    var snow: f32;
    var local_1: f32;
    var param_24: vec2<f32>;
    var g: f32;
    var param_25: vec2<f32>;
    var local_2: f32;
    var dark: f32;
    var group: f32;
    var drop: f32;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;

    let _e136 = uniforms.progress;
    h = clamp((2.5f * (1f - abs(((2f * _e136) - 1f)))), 0f, 1f);
    let _e143 = h;
    let _e144 = h;
    let _e146 = h;
    env = ((_e143 * _e144) * (3f - (2f * _e146)));
    let _e151 = uniforms.progress;
    f = clamp((1f - (abs((_e151 - 0.5f)) / 0.04f)), 0f, 1f);
    let _e157 = f;
    let _e158 = f;
    let _e160 = f;
    flash = ((_e157 * _e158) * (3f - (2f * _e160)));
    let _e165 = uniforms.progress;
    frame = floor((_e165 * 40f));
    let _e169 = (*uv_2)[1u];
    line = floor((_e169 * 220f));
    let _e172 = line;
    let _e173 = frame;
    param_3 = vec2<f32>(_e172, (_e173 + 7f));
    let _e176 = hash12((&param_3));
    jitter_1 = (_e176 - 0.5f);
    let _e179 = uniforms.progress;
    c0_ = mix(1.132f, -0.132f, _e179);
    let _e182 = (*uv_2)[1u];
    let _e183 = c0_;
    let _e184 = jitter_1;
    fresh_1 = (_e182 > (_e183 + (0.088f * _e184)));
    let _e189 = (*uv_2)[1u];
    param_4 = _e189;
    let _e190 = c0_;
    param_5 = _e190;
    param_6 = 0.11f;
    let _e191 = jitter_1;
    param_7 = _e191;
    let _e192 = bandDensity((&param_4), (&param_5), (&param_6), (&param_7));
    dens = _e192;
    let _e194 = (*uv_2)[1u];
    let _e195 = c0_;
    tear = (1f - smoothstep(0f, 1f, (abs((_e194 - _e195)) / 0.275f)));
    i = 1i;
    loop {
        let _e201 = i;
        if (_e201 < 4i) {
            let _e203 = i;
            let _e205 = uniforms.bands;
            if (_e203 < _e205) {
                let _e207 = i;
                k = f32(_e207);
                let _e209 = k;
                param_8 = vec2<f32>(_e209, 3f);
                let _e211 = hash12((&param_8));
                w_1 = (0.11f * (0.35f + (0.2f * _e211)));
                let _e215 = k;
                speed = (1.3f + (0.9f * _e215));
                let _e218 = w_1;
                let _e220 = w_1;
                let _e223 = k;
                param_9 = vec2<f32>(_e223, 5f);
                let _e225 = hash12((&param_9));
                let _e226 = speed;
                let _e228 = uniforms.progress;
                cy = (-(_e218) + ((1f + (2f * _e220)) * fract((_e225 - (_e226 * _e228)))));
                let _e234 = dens;
                let _e236 = (*uv_2)[1u];
                param_10 = _e236;
                let _e237 = cy;
                param_11 = _e237;
                let _e238 = w_1;
                param_12 = _e238;
                let _e239 = jitter_1;
                param_13 = _e239;
                let _e240 = bandDensity((&param_10), (&param_11), (&param_12), (&param_13));
                dens = max(_e234, (0.6f * _e240));
                let _e243 = tear;
                let _e245 = (*uv_2)[1u];
                let _e246 = cy;
                let _e249 = w_1;
                tear = max(_e243, (0.5f * (1f - smoothstep(0f, 1f, (abs((_e245 - _e246)) / (2.5f * _e249))))));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e256 = i;
            i = (_e256 + 1i);
        }
    }
    let _e258 = env;
    let _e259 = dens;
    dens = (_e259 * _e258);
    let _e261 = env;
    let _e262 = tear;
    tear = (_e262 * _e261);
    let _e265 = (*uv_2)[1u];
    let _e269 = frame;
    param_14 = vec2<f32>(floor(((_e265 * 220f) * 0.5f)), (_e269 + 31f));
    let _e272 = hash12((&param_14));
    rowTear = (_e272 - 0.5f);
    let _e275 = uniforms.wobble;
    let _e276 = env;
    let _e279 = (*uv_2)[1u];
    let _e282 = uniforms.progress;
    let _e287 = jitter_1;
    dx = ((_e275 * _e276) * ((0.006f * sin(((_e279 * 7f) + (_e282 * 23f)))) + (0.004f * _e287)));
    let _e292 = uniforms.noise;
    let _e295 = tear;
    let _e298 = rowTear;
    let _e300 = dx;
    dx = (_e300 + ((((0.3f + (0.7f * _e292)) * _e295) * 0.18f) * _e298));
    let _e302 = env;
    let _e304 = (*uv_2)[1u];
    strip = (_e302 * (1f - smoothstep(0f, 0.06f, _e304)));
    let _e308 = strip;
    let _e310 = (*uv_2)[1u];
    let _e316 = frame;
    param_15 = vec2<f32>(_e316, 41f);
    let _e318 = hash12((&param_15));
    let _e322 = dx;
    dx = (_e322 + ((_e308 * (0.03f + (0.06f * (1f - (_e310 / 0.06f))))) * (0.6f + (0.8f * _e318))));
    let _e325 = (*uv_2)[0u];
    let _e326 = dx;
    let _e329 = (*uv_2)[1u];
    q = vec2<f32>((_e325 + _e326), _e329);
    let _e331 = q;
    param_16 = _e331;
    let _e332 = fresh_1;
    param_17 = _e332;
    let _e333 = tape((&param_16), (&param_17));
    c_3 = _e333;
    let _e335 = c_3[3u];
    if (_e335 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e338 = uniforms.bleed;
    let _e339 = dens;
    let _e343 = env;
    len = ((_e338 * (0.02f + (0.05f * _e339))) * _e343);
    let _e345 = c_3;
    avg = _e345;
    let _e346 = len;
    if (_e346 > 0f) {
        avg = vec4<f32>(0f, 0f, 0f, 0f);
        i_1 = 0i;
        loop {
            let _e348 = i_1;
            if (_e348 < 6i) {
                let _e350 = i_1;
                u = ((f32(_e350) + 0.5f) / 6f);
                let _e354 = q;
                let _e355 = len;
                let _e356 = u;
                param_18 = (_e354 - vec2<f32>((_e355 * (0.4f + _e356)), 0f));
                let _e361 = fresh_1;
                param_19 = _e361;
                let _e362 = tape((&param_18), (&param_19));
                let _e363 = avg;
                avg = (_e363 + _e362);
                continue;
            } else {
                break;
            }
            continuing {
                let _e365 = i_1;
                i_1 = (_e365 + 1i);
            }
        }
        let _e367 = avg;
        avg = (_e367 / vec4(6f));
    }
    let _e370 = avg;
    let _e372 = avg;
    param_20 = _e372.xyz;
    let _e374 = luma((&param_20));
    let _e378 = avg[3u];
    chroma = ((_e370.xyz - vec3(_e374)) / vec3(max(_e378, 0.00001f)));
    let _e382 = c_3;
    param_21 = _e382.xyz;
    let _e384 = luma((&param_21));
    let _e385 = chroma;
    let _e387 = c_3[3u];
    rgb = (vec3(_e384) + (_e385 * _e387));
    let _e391 = rgb;
    let _e392 = rgb;
    param_22 = _e392;
    let _e393 = luma((&param_22));
    let _e395 = dens;
    rgb = mix(_e391, vec3(_e393), vec3((0.6f * _e395)));
    let _e400 = (*uv_2)[0u];
    let _e404 = uniforms.ratio;
    let _e406 = jitter_1;
    let _e410 = line;
    cell = vec2<f32>(floor(((((_e400 * 220f) * 0.3f) * _e404) + (40f * _e406))), _e410);
    let _e412 = cell;
    let _e413 = frame;
    param_23 = (_e412 + (vec2<f32>(37f, 17f) * _e413));
    let _e416 = hash12((&param_23));
    n = _e416;
    let _e418 = uniforms.noise;
    let _e419 = dens;
    let _e421 = strip;
    let _e425 = flash;
    amount = clamp(((_e418 * max((1.3f * _e419), (0.8f * _e421))) + (0.35f * _e425)), 0f, 1f);
    let _e429 = amount;
    if (_e429 > 0f) {
        let _e431 = amount;
        let _e433 = amount;
        let _e436 = n;
        local_1 = smoothstep((1f - _e431), (1f - (0.6f * _e433)), _e436);
    } else {
        local_1 = 0f;
    }
    let _e438 = local_1;
    snow = _e438;
    let _e439 = cell;
    let _e441 = frame;
    param_24 = (_e439.yx + vec2(_e441));
    let _e444 = hash12((&param_24));
    let _e447 = snow;
    snow = (_e447 * (0.55f + (0.45f * _e444)));
    let _e450 = (*uv_2)[0u];
    let _e453 = uniforms.ratio;
    let _e456 = line;
    let _e458 = frame;
    param_25 = (vec2<f32>(floor(((_e450 * 220f) * _e453)), _e456) + (vec2<f32>(13f, 29f) * _e458));
    let _e461 = hash12((&param_25));
    g = _e461;
    let _e462 = snow;
    let _e463 = amount;
    if (_e463 > 0f) {
        let _e465 = amount;
        let _e468 = g;
        local_2 = (0.7f * smoothstep((1f - (0.4f * _e465)), 1f, _e468));
    } else {
        local_2 = 0f;
    }
    let _e471 = local_2;
    snow = max(_e462, _e471);
    let _e473 = g;
    let _e474 = amount;
    dark = select(0f, 1f, (_e473 < (0.1f * _e474)));
    let _e479 = (*uv_2)[1u];
    group = floor(((_e479 * 220f) / 3f));
    let _e483 = flash;
    let _e486 = group;
    let _e488 = (*uv_2)[0u];
    let _e490 = group;
    let _e491 = frame;
    param_26 = vec2<f32>(_e490, _e491);
    let _e493 = hash12((&param_26));
    let _e497 = frame;
    param_27 = vec2<f32>(_e486, (floor(((_e488 * 6f) + (5f * _e493))) + (_e497 * 7f)));
    let _e501 = hash12((&param_27));
    drop = step((1f - (0.15f * _e483)), _e501);
    let _e503 = dark;
    let _e506 = rgb;
    rgb = (_e506 * (1f - (0.5f * _e503)));
    let _e508 = snow;
    let _e509 = drop;
    let _e511 = flash;
    let _e516 = c_3[3u];
    let _e517 = rgb;
    let _e521 = rgb;
    rgb = (_e521 + ((vec3(_e516) - _e517) * clamp(((_e508 + _e509) + (0.12f * _e511)), 0f, 1f)));
    let _e523 = rgb;
    let _e525 = c_3[3u];
    let _e530 = clamp((_e523 / vec3(_e525)), vec3(0f), vec3(1f));
    let _e532 = c_3[3u];
    return vec4<f32>(_e530.x, _e530.y, _e530.z, _e532);
}

fn main_1() {
    var param_28: vec2<f32>;

    let _e73 = _uv_1;
    param_28 = _e73;
    let _e74 = transition((&param_28));
    _fragColor = _e74;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
