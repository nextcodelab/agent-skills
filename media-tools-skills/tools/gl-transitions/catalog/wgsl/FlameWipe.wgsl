// FlameWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FlameWipe.glsl
// Author: gre
// License: MIT
// Description: A wall of flames sweeps across the frame, scorching the outgoing image ahead of it and leaving the incoming image under a fading warm glow
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    height: f32,
    scorch: f32,
    glow: f32,
    color: vec3<f32>,
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

fn fire(h: ptr<function, f32>) -> vec3<f32> {
    var c: vec3<f32>;

    let _e96 = uniforms.color;
    let _e98 = uniforms.color;
    let _e101 = (*h);
    c = mix(vec3<f32>(0.22f, 0.01f, 0f), ((_e96 * _e98) * vec3<f32>(1f, 0.6f, 0.4f)), vec3(smoothstep(0f, 0.3f, _e101)));
    let _e105 = c;
    let _e107 = uniforms.color;
    let _e108 = (*h);
    c = mix(_e105, _e107, vec3(smoothstep(0.25f, 0.55f, _e108)));
    let _e112 = c;
    let _e113 = (*h);
    c = mix(_e112, vec3<f32>(1f, 0.8f, 0.35f), vec3(smoothstep(0.55f, 0.8f, _e113)));
    let _e117 = c;
    let _e118 = (*h);
    return mix(_e117, vec3<f32>(1f, 0.96f, 0.82f), vec3(smoothstep(0.8f, 1f, _e118)));
}

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e95 = (*v);
    v3_ = fract((_e95.xyx * 0.1031f));
    let _e99 = v3_;
    let _e100 = v3_;
    let _e105 = v3_;
    v3_ = (_e105 + vec3(dot(_e99, (_e100.yzx + vec3(33.33f)))));
    let _e109 = v3_[0u];
    let _e111 = v3_[1u];
    let _e114 = v3_[2u];
    return fract(((_e109 + _e111) * _e114));
}

fn noise(v_1: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e100 = (*v_1);
    i = floor(_e100);
    let _e102 = (*v_1);
    let _e103 = i;
    f = (_e102 - _e103);
    let _e105 = f;
    let _e106 = f;
    let _e108 = f;
    f = ((_e105 * _e106) * (vec2(3f) - (_e108 * 2f)));
    let _e113 = i;
    param = _e113;
    let _e114 = hash12((&param));
    let _e115 = i;
    param_1 = (_e115 + vec2<f32>(1f, 0f));
    let _e117 = hash12((&param_1));
    let _e119 = f[0u];
    let _e121 = i;
    param_2 = (_e121 + vec2<f32>(0f, 1f));
    let _e123 = hash12((&param_2));
    let _e124 = i;
    param_3 = (_e124 + vec2<f32>(1f, 1f));
    let _e126 = hash12((&param_3));
    let _e128 = f[0u];
    let _e131 = f[1u];
    return mix(mix(_e114, _e117, _e119), mix(_e123, _e126, _e128), _e131);
}

fn fbm(v_2: ptr<function, vec2<f32>>) -> f32 {
    var sum: f32;
    var amp: f32;
    var i_1: i32;
    var param_4: vec2<f32>;

    sum = 0f;
    amp = 0.5f;
    i_1 = 0i;
    loop {
        let _e98 = i_1;
        if (_e98 < 4i) {
            let _e100 = amp;
            let _e101 = (*v_2);
            param_4 = _e101;
            let _e102 = noise((&param_4));
            let _e104 = sum;
            sum = (_e104 + (_e100 * _e102));
            let _e106 = (*v_2);
            (*v_2) = ((_e106 * 2.03f) + vec2<f32>(17.3f, 9.1f));
            let _e109 = amp;
            amp = (_e109 * 0.5f);
            continue;
        } else {
            break;
        }
        continuing {
            let _e111 = i_1;
            i_1 = (_e111 + 1i);
        }
    }
    let _e113 = sum;
    return (_e113 / 0.9375f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e95 = (*uv)[0u];
    let _e97 = (*uv)[1u];
    let _e100 = textureSampleLevel(_to, _sampler, vec2<f32>(_e95, (1f - _e97)), 0f);
    return _e100;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e95 = (*uv_1)[0u];
    let _e97 = (*uv_1)[1u];
    let _e100 = textureSampleLevel(_from, _sampler, vec2<f32>(_e95, (1f - _e97)), 0f);
    return _e100;
}

fn mirror(v_3: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e94 = (*v_3);
    let _e95 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e94 - (floor((_e94 / _e95)) * _e95)))));
}

fn climbing(s: ptr<function, f32>, size: ptr<function, f32>) -> f32 {
    let _e95 = (*size);
    let _e99 = (*s);
    let _e101 = (*s);
    let _e104 = (*s);
    return (((((0.42f + (0.56f * _e95)) * 6.75f) * _e99) * (1f - _e101)) * (1f - _e104));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var q: vec2<f32>;
    var rise: f32;
    var w: f32;
    var reach: f32;
    var extent: f32;
    var e: f32;
    var burn: f32;
    var scorchAmount: f32;
    var glowAmount: f32;
    var t: f32;
    var side: f32;
    var front: f32;
    var param_5: vec2<f32>;
    var k: f32;
    var billow: f32;
    var param_6: vec2<f32>;
    var y: f32;
    var y2_: f32;
    var climb: f32;
    var param_7: vec2<f32>;
    var param_8: f32;
    var param_9: f32;
    var param_10: vec2<f32>;
    var param_11: f32;
    var param_12: f32;
    var lineWidth: f32;
    var line: f32;
    var tongue: f32;
    var s_1: f32;
    var heat: f32;
    var near: f32;
    var h_1: vec2<f32>;
    var shimmer: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var a: vec4<f32>;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var b: vec4<f32>;
    var param_17: vec2<f32>;
    var brown: f32;
    var local_1: f32;
    var lum: f32;
    var g: f32;
    var local_2: f32;
    var m: f32;
    var c_1: vec4<f32>;
    var col: vec3<f32>;
    var f_1: vec2<f32>;
    var sway: f32;
    var param_18: vec2<f32>;
    var n: f32;
    var param_19: vec2<f32>;
    var core: f32;
    var root: f32;
    var local_3: f32;
    var local_4: f32;
    var flame: f32;
    var body: f32;
    var param_20: f32;

    let _e157 = uniforms.direction;
    if (length(_e157) > 0.00001f) {
        let _e161 = uniforms.direction;
        local = normalize(_e161);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e163 = local;
    dir = _e163;
    let _e164 = (*uv_2);
    let _e168 = uniforms.ratio;
    q = ((_e164 - vec2(0.5f)) * vec2<f32>(_e168, 1f));
    let _e172 = uniforms.height;
    let _e174 = dir[1u];
    rise = (_e172 * _e174);
    let _e177 = uniforms.height;
    w = (0.05f + (0.35f * _e177));
    let _e180 = w;
    let _e182 = dir[0u];
    reach = (_e180 * (1.75f + (0.6f * abs(_e182))));
    let _e188 = dir[0u];
    let _e191 = uniforms.ratio;
    let _e194 = dir[1u];
    extent = ((0.5f * ((abs(_e188) * _e191) + abs(_e194))) + 0.3f);
    let _e200 = uniforms.progress;
    let _e202 = uniforms.progress;
    let _e204 = uniforms.progress;
    let _e207 = uniforms.progress;
    e = mix(_e200, ((_e202 * _e204) * (3f - (2f * _e207))), 0.3f);
    let _e213 = uniforms.progress;
    let _e216 = uniforms.progress;
    burn = (smoothstep(0f, 0.12f, _e213) * (1f - smoothstep(0.88f, 1f, _e216)));
    let _e221 = uniforms.scorch;
    let _e223 = uniforms.progress;
    scorchAmount = (_e221 * smoothstep(0f, 0.2f, _e223));
    let _e227 = uniforms.glow;
    let _e229 = uniforms.progress;
    glowAmount = (_e227 * (1f - smoothstep(0.75f, 1f, _e229)));
    let _e234 = uniforms.progress;
    t = (_e234 * 5f);
    let _e236 = q;
    let _e238 = dir[1u];
    let _e241 = dir[0u];
    side = dot(_e236, vec2<f32>(-(_e238), _e241));
    let _e244 = extent;
    let _e246 = extent;
    let _e247 = e;
    let _e249 = side;
    let _e251 = t;
    param_5 = vec2<f32>((_e249 * 4f), (_e251 * 0.4f));
    let _e254 = noise((&param_5));
    front = (mix(-(_e244), _e246, _e247) + (0.05f * ((2f * _e254) - 1f)));
    let _e259 = q;
    let _e260 = dir;
    let _e262 = front;
    k = (dot(_e259, _e260) - _e262);
    let _e265 = q[0u];
    let _e269 = q[1u];
    let _e271 = t;
    param_6 = vec2<f32>(((_e265 * 3f) + 5f), ((_e269 * 2.5f) - (_e271 * 1.6f)));
    let _e275 = noise((&param_6));
    billow = _e275;
    let _e277 = q[1u];
    let _e279 = t;
    y = ((_e277 * 3f) - (_e279 * 1.4f));
    let _e282 = y;
    y2_ = (_e282 + 0.5f);
    let _e284 = y;
    let _e286 = y;
    param_7 = vec2<f32>(floor(_e286), 3f);
    let _e289 = hash12((&param_7));
    param_8 = fract(_e284);
    param_9 = _e289;
    let _e290 = climbing((&param_8), (&param_9));
    let _e291 = y2_;
    let _e293 = y2_;
    param_10 = vec2<f32>(floor(_e293), 7f);
    let _e296 = hash12((&param_10));
    param_11 = fract(_e291);
    param_12 = _e296;
    let _e297 = climbing((&param_11), (&param_12));
    climb = max(_e290, _e297);
    let _e299 = billow;
    let _e300 = billow;
    let _e302 = climb;
    let _e305 = dir[0u];
    billow = mix(_e299, ((0.4f * _e300) + _e302), abs(_e305));
    let _e308 = w;
    let _e309 = billow;
    lineWidth = (_e308 * (0.25f + (1.5f * _e309)));
    let _e313 = lineWidth;
    let _e314 = k;
    line = (1f - smoothstep(0f, _e313, abs(_e314)));
    tongue = 0f;
    let _e318 = rise;
    if (abs(_e318) > 0.0001f) {
        let _e321 = k;
        let _e322 = rise;
        s_1 = (_e321 / _e322);
        let _e324 = s_1;
        if (_e324 >= 0f) {
            let _e326 = s_1;
            tongue = clamp((1f - _e326), 0f, 1f);
        }
    }
    let _e329 = line;
    let _e330 = tongue;
    let _e332 = burn;
    heat = (max(_e329, _e330) * _e332);
    let _e334 = k;
    near = (1f - smoothstep(0f, 0.45f, abs(_e334)));
    let _e338 = q;
    let _e340 = t;
    h_1 = ((_e338 * vec2<f32>(9f, 5f)) + vec2<f32>(0f, (-(_e340) * 3f)));
    let _e345 = h_1;
    param_13 = _e345;
    let _e346 = noise((&param_13));
    let _e347 = h_1;
    param_14 = (_e347 + vec2(31.7f));
    let _e350 = noise((&param_14));
    let _e355 = near;
    let _e356 = heat;
    let _e360 = burn;
    shimmer = ((((vec2<f32>(_e346, _e350) - vec2(0.5f)) * 0.012f) * min((_e355 + _e356), 1f)) * _e360);
    let _e362 = (*uv_2);
    let _e363 = shimmer;
    param_15 = (_e362 + _e363);
    let _e365 = mirror((&param_15));
    param_16 = _e365;
    let _e366 = getFromColor((&param_16));
    a = _e366;
    let _e367 = (*uv_2);
    param_17 = _e367;
    let _e368 = getToColor((&param_17));
    b = _e368;
    let _e369 = k;
    if (_e369 > 0f) {
        let _e371 = scorchAmount;
        let _e372 = near;
        local_1 = (_e371 * _e372);
    } else {
        local_1 = 0f;
    }
    let _e374 = local_1;
    brown = _e374;
    let _e375 = a;
    lum = dot(_e375.xyz, vec3<f32>(0.299f, 0.587f, 0.114f));
    let _e378 = a;
    let _e380 = lum;
    let _e382 = brown;
    let _e385 = brown;
    let _e389 = brown;
    let _e391 = near;
    let _e393 = near;
    let _e396 = ((mix(_e378.xyz, (vec3<f32>(0.9f, 0.55f, 0.28f) * _e380), vec3(_e382)) * (1f - (0.35f * _e385))) * (1f - (((0.9f * _e389) * _e391) * _e393)));
    a[0u] = _e396.x;
    a[1u] = _e396.y;
    a[2u] = _e396.z;
    let _e403 = k;
    if (_e403 < 0f) {
        let _e405 = glowAmount;
        let _e406 = near;
        local_2 = (_e405 * _e406);
    } else {
        local_2 = 0f;
    }
    let _e408 = local_2;
    g = _e408;
    let _e409 = b;
    let _e411 = g;
    let _e417 = uniforms.color;
    let _e419 = g;
    let _e421 = g;
    let _e423 = ((_e409.xyz * mix(vec3<f32>(1f, 1f, 1f), vec3<f32>(1f, 0.6f, 0.35f), vec3((0.7f * _e411)))) + (((_e417 * 0.4f) * _e419) * _e421));
    b[0u] = _e423.x;
    b[1u] = _e423.y;
    b[2u] = _e423.z;
    let _e430 = k;
    let _e431 = rise;
    let _e432 = reach;
    if (_e430 >= max(0.45f, max(_e431, _e432))) {
        let _e437 = a[3u];
        let _e439 = a;
        return select(vec4<f32>(0f, 0f, 0f, 0f), _e439, vec4((_e437 > 0f)));
    }
    let _e442 = k;
    let _e444 = rise;
    let _e446 = reach;
    if (-(_e442) >= max(0.45f, max(-(_e444), _e446))) {
        let _e451 = b[3u];
        let _e453 = b;
        return select(vec4<f32>(0f, 0f, 0f, 0f), _e453, vec4((_e451 > 0f)));
    }
    let _e456 = w;
    let _e458 = w;
    let _e460 = k;
    m = smoothstep((-0.5f * _e456), (0.5f * _e458), _e460);
    let _e462 = b;
    let _e465 = b[3u];
    let _e466 = (_e462.xyz * _e465);
    let _e468 = b[3u];
    let _e473 = a;
    let _e476 = a[3u];
    let _e477 = (_e473.xyz * _e476);
    let _e479 = a[3u];
    let _e484 = m;
    c_1 = mix(vec4<f32>(_e466.x, _e466.y, _e466.z, _e468), vec4<f32>(_e477.x, _e477.y, _e477.z, _e479), vec4(_e484));
    let _e488 = c_1[3u];
    if (_e488 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e490 = c_1;
    let _e493 = c_1[3u];
    col = (_e490.xyz / vec3(_e493));
    let _e497 = q[0u];
    let _e499 = dir[0u];
    let _e504 = q[1u];
    let _e506 = dir[0u];
    let _e510 = t;
    f_1 = vec2<f32>((_e497 * mix(10f, 6f, abs(_e499))), ((_e504 * mix(1.8f, 3.2f, abs(_e506))) - (_e510 * 2.4f)));
    let _e515 = q[0u];
    let _e518 = q[1u];
    let _e520 = t;
    param_18 = vec2<f32>((_e515 * 2.5f), ((_e518 * 1.5f) - (_e520 * 1.2f)));
    let _e524 = fbm((&param_18));
    sway = _e524;
    let _e525 = f_1;
    let _e526 = sway;
    param_19 = (_e525 + vec2<f32>(((1.5f * _e526) - 0.75f), 0f));
    let _e531 = fbm((&param_19));
    n = _e531;
    let _e532 = n;
    n = clamp(((1.7f * _e532) - 0.35f), 0f, 1f);
    let _e536 = lineWidth;
    let _e538 = k;
    let _e539 = w;
    let _e541 = sway;
    let _e548 = burn;
    let _e551 = dir[0u];
    core = (((1f - smoothstep(0f, (0.35f * _e536), abs((_e538 + ((0.4f * _e539) * (_e541 - 0.5f)))))) * _e548) * (1f - (0.5f * abs(_e551))));
    let _e556 = rise;
    if (_e556 > 0f) {
        let _e558 = k;
        let _e560 = w;
        local_3 = clamp((-(_e558) / _e560), 0f, 1f);
    } else {
        let _e563 = rise;
        if (_e563 < 0f) {
            let _e565 = k;
            let _e566 = w;
            local_4 = clamp((_e565 / _e566), 0f, 1f);
        } else {
            local_4 = 0f;
        }
        let _e569 = local_4;
        local_3 = _e569;
    }
    let _e570 = local_3;
    root = _e570;
    let _e572 = dir[1u];
    let _e574 = root;
    root = (_e574 * abs(_e572));
    let _e576 = heat;
    let _e578 = core;
    let _e580 = n;
    let _e585 = n;
    let _e588 = root;
    flame = clamp((((_e576 * 0.95f) + ((0.45f * _e578) * (0.75f + (0.25f * _e580)))) - (((1f - _e585) * 1.1f) * (1f - (0.8f * _e588)))), 0f, 1f);
    let _e594 = root;
    let _e597 = flame;
    body = smoothstep(0f, (0.08f + (0.5f * _e594)), _e597);
    let _e599 = col;
    let _e600 = body;
    let _e604 = flame;
    param_20 = _e604;
    let _e605 = fire((&param_20));
    let _e606 = flame;
    let _e610 = body;
    col = ((_e599 * (1f - (0.7f * _e600))) + ((_e605 * (0.45f + (0.65f * _e606))) * _e610));
    let _e614 = uniforms.color;
    let _e616 = heat;
    let _e618 = heat;
    let _e620 = body;
    let _e623 = col;
    col = (_e623 + ((((_e614 * 0.25f) * _e616) * _e618) * (1f - _e620)));
    let _e625 = col;
    let _e628 = clamp(_e625, vec3(0f), vec3(1f));
    let _e630 = c_1[3u];
    return vec4<f32>(_e628.x, _e628.y, _e628.z, _e630);
}

fn main_1() {
    var param_21: vec2<f32>;

    let _e94 = _uv_1;
    param_21 = _e94;
    let _e95 = transition((&param_21));
    _fragColor = _e95;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
