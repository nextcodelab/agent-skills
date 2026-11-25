// ShoreWash — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ShoreWash.glsl
// Author: gre
// License: MIT
// Description: A thin sheet of water runs up over the outgoing image like the last of a wave on a beach, its lobed front edged with bubbly foam; it slows, stops just past the far edge and drains back, leaving the incoming image wet and glossy as it dries
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    foam: f32,
    refraction: f32,
    water: vec4<f32>,
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

fn hash22(p: ptr<function, vec2<f32>>) -> vec2<f32> {
    var p3_: vec3<f32>;

    let _e85 = (*p);
    p3_ = fract((_e85.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e89 = p3_;
    let _e90 = p3_;
    let _e95 = p3_;
    p3_ = (_e95 + vec3(dot(_e89, (_e90.yzx + vec3(33.33f)))));
    let _e98 = p3_;
    let _e100 = p3_;
    let _e103 = p3_;
    return fract(((_e98.xx + _e100.yz) * _e103.zy));
}

fn bubbles(p_1: ptr<function, vec2<f32>>, density: ptr<function, f32>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var d1_: f32;
    var d2_: f32;
    var y: i32;
    var x: i32;
    var o: vec2<f32>;
    var c: vec2<f32>;
    var param: vec2<f32>;
    var d: f32;
    var e: f32;
    var w: f32;

    let _e97 = (*p_1);
    i = floor(_e97);
    let _e99 = (*p_1);
    f = fract(_e99);
    d1_ = 8f;
    d2_ = 8f;
    y = -1i;
    loop {
        let _e101 = y;
        if (_e101 <= 1i) {
            x = -1i;
            loop {
                let _e103 = x;
                if (_e103 <= 1i) {
                    let _e105 = x;
                    let _e107 = y;
                    o = vec2<f32>(f32(_e105), f32(_e107));
                    let _e110 = o;
                    let _e113 = i;
                    let _e114 = o;
                    param = (_e113 + _e114);
                    let _e116 = hash22((&param));
                    let _e119 = f;
                    c = (((_e110 + vec2(0.15f)) + (_e116 * 0.7f)) - _e119);
                    let _e121 = c;
                    let _e122 = c;
                    d = dot(_e121, _e122);
                    let _e124 = d;
                    let _e125 = d1_;
                    if (_e124 < _e125) {
                        let _e127 = d1_;
                        d2_ = _e127;
                        let _e128 = d;
                        d1_ = _e128;
                    } else {
                        let _e129 = d;
                        let _e130 = d2_;
                        if (_e129 < _e130) {
                            let _e132 = d;
                            d2_ = _e132;
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e133 = x;
                    x = (_e133 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e135 = y;
            y = (_e135 + 1i);
        }
    }
    let _e137 = d2_;
    let _e139 = d1_;
    e = (sqrt(_e137) - sqrt(_e139));
    let _e142 = (*density);
    w = (0.12f + (0.6f * _e142));
    let _e145 = w;
    let _e147 = w;
    let _e149 = e;
    let _e152 = (*density);
    return ((1f - smoothstep((_e145 - 0.12f), (_e147 + 0.12f), _e149)) * smoothstep(0f, 0.35f, _e152));
}

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

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e84 = (*v);
    let _e85 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e84 - (floor((_e84 / _e85)) * _e85)))));
}

fn hash12(p_2: ptr<function, vec2<f32>>) -> f32 {
    var p3_1: vec3<f32>;

    let _e85 = (*p_2);
    p3_1 = fract((_e85.xyx * 0.1031f));
    let _e89 = p3_1;
    let _e90 = p3_1;
    let _e95 = p3_1;
    p3_1 = (_e95 + vec3(dot(_e89, (_e90.yzx + vec3(33.33f)))));
    let _e99 = p3_1[0u];
    let _e101 = p3_1[1u];
    let _e104 = p3_1[2u];
    return fract(((_e99 + _e101) * _e104));
}

fn vnoise(p_3: ptr<function, vec2<f32>>) -> f32 {
    var i_1: vec2<f32>;
    var f_1: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;

    let _e90 = (*p_3);
    i_1 = floor(_e90);
    let _e92 = (*p_3);
    f_1 = fract(_e92);
    let _e94 = f_1;
    let _e95 = f_1;
    let _e97 = f_1;
    f_1 = ((_e94 * _e95) * (vec2(3f) - (_e97 * 2f)));
    let _e102 = i_1;
    param_1 = _e102;
    let _e103 = hash12((&param_1));
    let _e104 = i_1;
    param_2 = (_e104 + vec2<f32>(1f, 0f));
    let _e106 = hash12((&param_2));
    let _e108 = f_1[0u];
    let _e110 = i_1;
    param_3 = (_e110 + vec2<f32>(0f, 1f));
    let _e112 = hash12((&param_3));
    let _e113 = i_1;
    param_4 = (_e113 + vec2<f32>(1f, 1f));
    let _e115 = hash12((&param_4));
    let _e117 = f_1[0u];
    let _e120 = f_1[1u];
    return mix(mix(_e103, _e106, _e108), mix(_e112, _e115, _e117), _e120);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var q: vec2<f32>;
    var a: f32;
    var b: f32;
    var extent: f32;
    var start: f32;
    var stop: f32;
    var up: f32;
    var back: f32;
    var front: f32;
    var lobes: f32;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var behind: f32;
    var sheet: f32;
    var swapped: f32;
    var rp: vec2<f32>;
    var param_7: vec2<f32>;
    var n0_: f32;
    var param_8: vec2<f32>;
    var g: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var thick: f32;
    var off: vec2<f32>;
    var c_1: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var glint: f32;
    var wet: f32;
    var param_15: vec2<f32>;
    var lp: vec2<f32>;
    var patches: f32;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var bandW: f32;
    var param_18: vec2<f32>;
    var density_1: f32;
    var param_19: vec2<f32>;
    var f_2: f32;
    var param_20: vec2<f32>;
    var param_21: f32;
    var param_22: vec2<f32>;
    var param_23: f32;
    var sh: f32;

    let _e133 = uniforms.direction;
    if (length(_e133) > 0f) {
        let _e137 = uniforms.direction;
        local = normalize(_e137);
    } else {
        local = vec2<f32>(0f, 1f);
    }
    let _e139 = local;
    dir = _e139;
    let _e140 = (*uv_2);
    let _e144 = uniforms.ratio;
    q = ((_e140 - vec2(0.5f)) * vec2<f32>(_e144, 1f));
    let _e147 = q;
    let _e148 = dir;
    a = dot(_e147, _e148);
    let _e150 = q;
    let _e152 = dir[1u];
    let _e155 = dir[0u];
    b = dot(_e150, vec2<f32>(-(_e152), _e155));
    let _e159 = dir[0u];
    let _e162 = uniforms.ratio;
    let _e165 = dir[1u];
    extent = (0.5f * ((abs(_e159) * _e162) + abs(_e165)));
    let _e169 = extent;
    start = ((-(_e169) - 0.06f) - 0.1f);
    let _e173 = extent;
    stop = ((_e173 + 0.06f) + 0.01f);
    let _e177 = uniforms.progress;
    up = clamp((_e177 / 0.4f), 0f, 1f);
    let _e181 = uniforms.progress;
    back = clamp(((_e181 - 0.4f) / 0.6f), 0f, 1f);
    let _e185 = start;
    let _e186 = stop;
    let _e187 = up;
    let _e192 = stop;
    let _e193 = start;
    let _e195 = back;
    front = (mix(_e185, _e186, (1f - pow((1f - _e187), 1.6f))) - ((_e192 - _e193) * pow(_e195, 1.5f)));
    let _e199 = b;
    let _e203 = uniforms.progress;
    param_5 = vec2<f32>(((_e199 * 7f) + 3.1f), (_e203 * 2f));
    let _e206 = vnoise((&param_5));
    let _e208 = b;
    let _e211 = uniforms.progress;
    param_6 = vec2<f32>((_e208 * 17f), (5f + (_e211 * 3f)));
    let _e215 = vnoise((&param_6));
    lobes = ((_e206 * 0.7f) + (_e215 * 0.3f));
    let _e218 = front;
    let _e219 = lobes;
    let _e224 = a;
    behind = ((_e218 + ((0.06f * (_e219 - 0.5f)) * 2f)) - _e224);
    let _e226 = behind;
    sheet = smoothstep(-0.002f, 0.002f, _e226);
    let _e228 = behind;
    let _e231 = uniforms.progress;
    let _e233 = sheet;
    let _e236 = uniforms.progress;
    swapped = max(smoothstep(0.01f, 0.08f, _e228), (select(1f, _e233, (_e231 < 0.4f)) * smoothstep(0.32f, 0.4f, _e236)));
    let _e240 = a;
    let _e242 = b;
    let _e244 = q;
    param_7 = (_e244 * 4f);
    let _e246 = vnoise((&param_7));
    let _e251 = uniforms.progress;
    let _e254 = back;
    rp = (vec2<f32>((_e240 * 20f), ((_e242 * 5f) + (3f * _e246))) - vec2<f32>(((7f * min(_e251, 0.4f)) - (5f * _e254)), 0f));
    let _e259 = rp;
    param_8 = _e259;
    let _e260 = vnoise((&param_8));
    n0_ = _e260;
    let _e261 = rp;
    param_9 = (_e261 + vec2<f32>(0.15f, 0f));
    let _e263 = vnoise((&param_9));
    let _e264 = n0_;
    let _e267 = dir;
    let _e269 = rp;
    param_10 = (_e269 + vec2<f32>(0f, 0.15f));
    let _e271 = vnoise((&param_10));
    let _e272 = n0_;
    let _e276 = dir[1u];
    let _e279 = dir[0u];
    g = ((_e267 * ((_e263 - _e264) / 0.15f)) + (vec2<f32>(-(_e276), _e279) * ((_e271 - _e272) / 0.15f)));
    let _e283 = sheet;
    let _e284 = behind;
    thick = (_e283 * smoothstep(0f, 0.12f, _e284));
    let _e287 = g;
    let _e289 = uniforms.refraction;
    let _e291 = thick;
    let _e294 = uniforms.ratio;
    off = (((_e287 * _e289) * _e291) * vec2<f32>((1f / _e294), 1f));
    let _e298 = (*uv_2);
    let _e299 = off;
    param_11 = (_e298 + _e299);
    let _e301 = mirror((&param_11));
    param_12 = _e301;
    let _e302 = getFromColor((&param_12));
    let _e303 = (*uv_2);
    let _e304 = off;
    param_13 = (_e303 + _e304);
    let _e306 = mirror((&param_13));
    param_14 = _e306;
    let _e307 = getToColor((&param_14));
    let _e308 = swapped;
    c_1 = mix(_e302, _e307, vec4(_e308));
    let _e311 = c_1;
    let _e314 = uniforms.water;
    let _e318 = uniforms.water[3u];
    let _e319 = sheet;
    let _e321 = behind;
    let _e327 = mix(_e311.xyz, _e314.xyz, vec3(((_e318 * _e319) * (0.3f + (0.7f * smoothstep(0f, 0.35f, _e321))))));
    c_1[0u] = _e327.x;
    c_1[1u] = _e327.y;
    c_1[2u] = _e327.z;
    let _e334 = g;
    let _e335 = -(_e334);
    glint = pow(max(dot(normalize(vec3<f32>(_e335.x, _e335.y, 3f)), vec3<f32>(-0.24913643f, 0.49827287f, 0.8304548f)), 0f), 14f);
    let _e343 = glint;
    let _e345 = thick;
    let _e347 = c_1;
    let _e350 = (_e347.xyz + vec3(((_e343 * 0.4f) * _e345)));
    c_1[0u] = _e350.x;
    c_1[1u] = _e350.y;
    c_1[2u] = _e350.z;
    let _e357 = sheet;
    let _e359 = behind;
    let _e365 = uniforms.progress;
    let _e369 = uniforms.progress;
    wet = ((((1f - _e357) * exp((min(_e359, 0f) * 2.5f))) * smoothstep(0.4f, 0.45f, _e365)) * (1f - smoothstep(0.7f, 1f, _e369)));
    let _e373 = c_1;
    let _e375 = wet;
    let _e379 = c_1;
    let _e381 = (_e379.xyz * mix(vec3<f32>(1f, 1f, 1f), _e373.xyz, vec3((0.55f * _e375))));
    c_1[0u] = _e381.x;
    c_1[1u] = _e381.y;
    c_1[2u] = _e381.z;
    let _e388 = wet;
    let _e390 = a;
    let _e392 = b;
    param_15 = vec2<f32>((_e390 * 30f), (_e392 * 6f));
    let _e395 = vnoise((&param_15));
    let _e398 = c_1;
    let _e401 = (_e398.xyz + vec3(((0.1f * _e388) * smoothstep(0.4f, 0.9f, _e395))));
    c_1[0u] = _e401.x;
    c_1[1u] = _e401.y;
    c_1[2u] = _e401.z;
    let _e408 = a;
    let _e410 = uniforms.progress;
    let _e412 = front;
    let _e413 = stop;
    let _e417 = b;
    lp = (vec2<f32>((_e408 - (0.4f * select(_e413, _e412, (_e410 < 0.4f)))), _e417) / vec2(0.045f));
    let _e421 = lp;
    param_16 = ((_e421 * vec2<f32>(0.4f, 0.1f)) + vec2(4f));
    let _e425 = vnoise((&param_16));
    let _e427 = lp;
    param_17 = ((_e427 * 0.3f) + vec2(9f));
    let _e431 = vnoise((&param_17));
    patches = smoothstep(0.45f, 0.8f, ((0.6f * _e425) + (0.4f * _e431)));
    let _e435 = b;
    param_18 = vec2<f32>((_e435 * 25f), 2f);
    let _e438 = vnoise((&param_18));
    bandW = (0.1f * (0.5f + _e438));
    let _e441 = bandW;
    let _e442 = behind;
    let _e446 = uniforms.progress;
    density_1 = ((1f - smoothstep(0f, _e441, _e442)) * (1f - smoothstep(0.35f, 0.52f, _e446)));
    let _e450 = density_1;
    let _e451 = patches;
    let _e453 = behind;
    let _e457 = back;
    density_1 = max(_e450, (((0.55f * _e451) * (1f - smoothstep(0f, 0.3f, _e453))) * (1f - (0.5f * _e457))));
    let _e462 = density_1;
    let _e463 = b;
    param_19 = vec2<f32>((_e463 * 40f), 1f);
    let _e466 = vnoise((&param_19));
    let _e469 = behind;
    density_1 = max(_e462, (0.9f * (1f - smoothstep(0f, (0.012f + (0.02f * _e466)), _e469))));
    let _e474 = sheet;
    let _e475 = density_1;
    density_1 = (_e475 * _e474);
    f_2 = 0f;
    let _e477 = density_1;
    if (_e477 > 0f) {
        let _e479 = lp;
        param_20 = _e479;
        let _e480 = density_1;
        param_21 = _e480;
        let _e481 = bubbles((&param_20), (&param_21));
        let _e482 = lp;
        let _e486 = density_1;
        param_22 = ((_e482 * 1.7f) + vec2(7f));
        param_23 = (_e486 * 0.9f);
        let _e488 = bubbles((&param_22), (&param_23));
        f_2 = max(_e481, (0.85f * _e488));
        let _e491 = f_2;
        let _e492 = density_1;
        let _e497 = uniforms.foam;
        f_2 = (max(_e491, (0.45f * smoothstep(0.15f, 0.7f, _e492))) * _e497);
    }
    let _e499 = sheet;
    let _e502 = uniforms.foam;
    let _e504 = f_2;
    let _e507 = density_1;
    let _e511 = c_1;
    let _e513 = (_e511.xyz * (1f - ((((0.25f * _e499) * _e502) * (1f - _e504)) * smoothstep(0f, 0.6f, _e507))));
    c_1[0u] = _e513.x;
    c_1[1u] = _e513.y;
    c_1[2u] = _e513.z;
    let _e520 = c_1;
    let _e522 = f_2;
    let _e525 = mix(_e520.xyz, vec3<f32>(0.97f, 0.98f, 0.97f), vec3(clamp(_e522, 0f, 1f)));
    c_1[0u] = _e525.x;
    c_1[1u] = _e525.y;
    c_1[2u] = _e525.z;
    let _e532 = behind;
    sh = smoothstep(-0.03f, 0f, _e532);
    let _e534 = sheet;
    let _e537 = sh;
    let _e539 = sh;
    let _e542 = uniforms.progress;
    let _e547 = c_1;
    let _e549 = (_e547.xyz * (1f - ((((0.35f * (1f - _e534)) * _e537) * _e539) * (1f - smoothstep(0.35f, 0.4f, _e542)))));
    c_1[0u] = _e549.x;
    c_1[1u] = _e549.y;
    c_1[2u] = _e549.z;
    let _e556 = c_1;
    return _e556;
}

fn main_1() {
    var param_24: vec2<f32>;

    let _e84 = _uv_1;
    param_24 = _e84;
    let _e85 = transition((&param_24));
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
