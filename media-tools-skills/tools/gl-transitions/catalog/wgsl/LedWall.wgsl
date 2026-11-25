// LedWall — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LedWall.glsl
// Author: gre
// License: MIT
// Description: The picture zooms into a giant LED screen of round glowing diodes on a dark panel; a refresh wave sweeps across it, each diode flicking with a bright pop as it switches to the incoming image, then the diodes melt back into the plain picture
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cells: f32,
    glow: f32,
    flash: f32,
    zoom: f32,
    triads: i32,
    direction: vec2<f32>,
    panel: vec4<f32>,
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

fn disc(d: ptr<function, f32>, r: ptr<function, f32>) -> f32 {
    let _e56 = (*r);
    let _e58 = (*r);
    let _e60 = (*d);
    return (1f - smoothstep((_e56 - 0.05f), (_e58 + 0.05f), _e60));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e56 = (*uv)[0u];
    let _e58 = (*uv)[1u];
    let _e61 = textureSampleLevel(_to, _sampler, vec2<f32>(_e56, (1f - _e58)), 0f);
    return _e61;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e56 = (*uv_1)[0u];
    let _e58 = (*uv_1)[1u];
    let _e61 = textureSampleLevel(_from, _sampler, vec2<f32>(_e56, (1f - _e58)), 0f);
    return _e61;
}

fn mirrored(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    var m: vec2<f32>;

    let _e56 = (*v);
    let _e57 = vec2(2f);
    m = (_e56 - (floor((_e56 / _e57)) * _e57));
    let _e62 = m;
    let _e63 = m;
    let _e66 = m;
    return mix(_e62, (vec2(2f) - _e63), step(vec2(1f), _e66));
}

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e56 = (*p);
    p3_ = fract((_e56.xyx * 0.1031f));
    let _e60 = p3_;
    let _e61 = p3_;
    let _e66 = p3_;
    p3_ = (_e66 + vec3(dot(_e60, (_e61.yzx + vec3(33.33f)))));
    let _e70 = p3_[0u];
    let _e72 = p3_[1u];
    let _e75 = p3_[2u];
    return fract(((_e70 + _e72) * _e75));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var led: f32;
    var z: f32;
    var p_1: vec2<f32>;
    var aspect: vec2<f32>;
    var toCells: vec2<f32>;
    var q: vec2<f32>;
    var id: vec2<f32>;
    var local: vec2<f32>;
    var side: vec2<f32>;
    var dir: vec2<f32>;
    var local_1: vec2<f32>;
    var extent: f32;
    var own: vec4<f32>;
    var ownSwitch: f32;
    var halo: vec4<f32>;
    var haloWeight: f32;
    var i: i32;
    var o: vec2<f32>;
    var c: vec2<f32>;
    var cuv: vec2<f32>;
    var s: f32;
    var when: f32;
    var param: vec2<f32>;
    var sw: f32;
    var x: f32;
    var pop: f32;
    var suv: vec2<f32>;
    var param_1: vec2<f32>;
    var col: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var d_1: f32;
    var w: f32;
    var plain: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var d_2: f32;
    var r_1: f32;
    var gap: vec4<f32>;
    var body: vec4<f32>;
    var sub: vec3<f32>;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var m_1: f32;
    var k: f32;
    var lit: f32;
    var color: vec4<f32>;
    var param_12: f32;
    var param_13: f32;
    var phi_268_: bool;

    let _e109 = uniforms.progress;
    let _e112 = uniforms.progress;
    led = (smoothstep(0f, 0.3f, _e109) * (1f - smoothstep(0.7f, 1f, _e112)));
    let _e117 = uniforms.zoom;
    let _e120 = uniforms.progress;
    let _e124 = uniforms.progress;
    z = (1f + ((max(_e117, 0f) * smoothstep(0f, 0.45f, _e120)) * (1f - smoothstep(0.55f, 1f, _e124))));
    let _e129 = (*uv_2);
    let _e132 = z;
    p_1 = (vec2(0.5f) + ((_e129 - vec2(0.5f)) / vec2(_e132)));
    let _e138 = uniforms.ratio;
    aspect = vec2<f32>(_e138, 1f);
    let _e140 = aspect;
    let _e142 = uniforms.cells;
    let _e146 = uniforms.ratio;
    toCells = ((_e140 * max(_e142, 1f)) / vec2(min(_e146, 1f)));
    let _e150 = p_1;
    let _e153 = toCells;
    q = ((_e150 - vec2(0.5f)) * _e153);
    let _e155 = q;
    id = floor((_e155 + vec2(0.5f)));
    let _e159 = q;
    let _e160 = id;
    local = (_e159 - _e160);
    let _e163 = local[0u];
    let _e167 = local[1u];
    side = vec2<f32>(select(1f, -1f, (_e163 < 0f)), select(1f, -1f, (_e167 < 0f)));
    let _e172 = uniforms.direction;
    if (length(_e172) > 0.0001f) {
        let _e176 = uniforms.direction;
        local_1 = normalize(_e176);
    } else {
        local_1 = vec2<f32>(1f, 0f);
    }
    let _e178 = local_1;
    dir = _e178;
    let _e180 = dir[0u];
    let _e183 = uniforms.ratio;
    let _e186 = dir[1u];
    extent = ((abs(_e180) * _e183) + abs(_e186));
    own = vec4<f32>(0f, 0f, 0f, 0f);
    ownSwitch = 0f;
    halo = vec4<f32>(0f, 0f, 0f, 0f);
    haloWeight = 0f;
    i = 0i;
    loop {
        let _e189 = i;
        if (_e189 < 4i) {
            let _e191 = i;
            let _e192 = (_e191 > 0i);
            phi_268_ = _e192;
            if _e192 {
                let _e194 = uniforms.glow;
                let _e195 = led;
                phi_268_ = ((_e194 * _e195) <= 0f);
            }
            let _e199 = phi_268_;
            if _e199 {
                break;
            }
            let _e200 = i;
            let _e201 = f32(_e200);
            let _e206 = i;
            let _e211 = side;
            o = (vec2<f32>((_e201 - (floor((_e201 / 2f)) * 2f)), floor((f32(_e206) / 2f))) * _e211);
            let _e213 = id;
            let _e214 = o;
            c = (_e213 + _e214);
            let _e216 = c;
            let _e217 = toCells;
            cuv = ((_e216 / _e217) + vec2(0.5f));
            let _e221 = cuv;
            let _e224 = z;
            let _e226 = aspect;
            let _e228 = dir;
            let _e230 = extent;
            s = clamp(((dot((((_e221 - vec2(0.5f)) * _e224) * _e226), _e228) / _e230) + 0.5f), 0f, 1f);
            let _e234 = s;
            let _e237 = c;
            param = (_e237 + vec2(71f));
            let _e240 = hash12((&param));
            when = ((0.2f + (0.52f * _e234)) + (0.05f * (_e240 - 0.5f)));
            let _e244 = when;
            let _e246 = when;
            let _e249 = uniforms.progress;
            sw = smoothstep((_e244 - 0.012f), (_e246 + 0.012f), _e249);
            let _e252 = uniforms.progress;
            let _e253 = when;
            x = ((_e252 - _e253) / 0.018f);
            let _e256 = x;
            let _e258 = x;
            let _e261 = x;
            let _e264 = x;
            pop = (exp((-(_e256) * _e258)) - (0.5f * exp((-((_e261 + 1.6f)) * (_e264 + 1.6f)))));
            let _e270 = cuv;
            param_1 = _e270;
            let _e271 = mirrored((&param_1));
            suv = _e271;
            let _e272 = suv;
            param_2 = _e272;
            let _e273 = getFromColor((&param_2));
            let _e274 = suv;
            param_3 = _e274;
            let _e275 = getToColor((&param_3));
            let _e276 = sw;
            col = mix(_e273, _e275, vec4(_e276));
            let _e279 = col;
            let _e282 = uniforms.flash;
            let _e284 = pop;
            let _e289 = uniforms.flash;
            let _e291 = pop;
            let _e295 = ((_e279.xyz * (1f + ((1.4f * _e282) * _e284))) + vec3(((0.2f * _e289) * max(_e291, 0f))));
            col[0u] = _e295.x;
            col[1u] = _e295.y;
            col[2u] = _e295.z;
            let _e302 = i;
            if (_e302 == 0i) {
                let _e304 = col;
                own = _e304;
                let _e305 = sw;
                ownSwitch = _e305;
            }
            let _e306 = local;
            let _e307 = o;
            d_1 = length((_e306 - _e307));
            let _e311 = uniforms.glow;
            let _e313 = d_1;
            let _e320 = uniforms.flash;
            let _e322 = pop;
            w = (((0.9f * _e311) * exp((-6f * max((_e313 - 0.36f), 0f)))) * (1f + ((0.8f * _e320) * max(_e322, 0f))));
            let _e328 = o[0u];
            if (_e328 != 0f) {
                let _e331 = local[0u];
                let _e334 = w;
                w = (_e334 * smoothstep(0f, 0.2f, abs(_e331)));
            }
            let _e337 = o[1u];
            if (_e337 != 0f) {
                let _e340 = local[1u];
                let _e343 = w;
                w = (_e343 * smoothstep(0f, 0.2f, abs(_e340)));
            }
            let _e345 = w;
            let _e346 = col;
            let _e348 = halo;
            halo = (_e348 + (_e346 * _e345));
            let _e350 = w;
            let _e351 = haloWeight;
            haloWeight = (_e351 + _e350);
            continue;
        } else {
            break;
        }
        continuing {
            let _e353 = i;
            i = (_e353 + 1i);
        }
    }
    let _e355 = p_1;
    param_4 = _e355;
    let _e356 = getFromColor((&param_4));
    let _e357 = p_1;
    param_5 = _e357;
    let _e358 = getToColor((&param_5));
    let _e359 = ownSwitch;
    plain = mix(_e356, _e358, vec4(_e359));
    let _e362 = local;
    d_2 = length(_e362);
    let _e364 = led;
    r_1 = mix(0.8f, 0.36f, smoothstep(0f, 0.6f, _e364));
    let _e368 = uniforms.panel;
    let _e369 = _e368.xyz;
    let _e372 = uniforms.panel[3u];
    let _e374 = own[3u];
    gap = vec4<f32>(_e369.x, _e369.y, _e369.z, (_e372 * _e374));
    let _e380 = haloWeight;
    if (_e380 > 0f) {
        let _e382 = gap;
        let _e383 = halo;
        let _e384 = haloWeight;
        let _e387 = haloWeight;
        let _e388 = led;
        gap = mix(_e382, (_e383 / vec4(_e384)), vec4(clamp((_e387 * _e388), 0f, 1f)));
    }
    let _e393 = own;
    body = _e393;
    let _e395 = uniforms.triads;
    if (_e395 != 0i) {
        let _e397 = local;
        param_6 = length((_e397 - vec2<f32>(0f, 0.15f)));
        param_7 = 0.2f;
        let _e400 = disc((&param_6), (&param_7));
        let _e401 = local;
        param_8 = length((_e401 - vec2<f32>(-0.13f, -0.075f)));
        param_9 = 0.2f;
        let _e404 = disc((&param_8), (&param_9));
        let _e405 = local;
        param_10 = length((_e405 - vec2<f32>(0.13f, -0.075f)));
        param_11 = 0.2f;
        let _e408 = disc((&param_10), (&param_11));
        sub = vec3<f32>(_e400, _e404, _e408);
        let _e411 = sub[0u];
        let _e413 = sub[1u];
        let _e415 = sub[2u];
        m_1 = max(_e411, max(_e413, _e415));
        let _e418 = gap;
        let _e420 = m_1;
        let _e423 = own;
        let _e426 = sub;
        let _e428 = ((_e418.xyz * (1f - _e420)) + ((_e423.xyz * 1.5f) * _e426));
        let _e430 = gap[3u];
        let _e432 = own[3u];
        let _e433 = m_1;
        body = vec4<f32>(_e428.x, _e428.y, _e428.z, mix(_e430, _e432, _e433));
        let _e439 = r_1;
        r_1 = max(_e439, 0.45f);
    } else {
        let _e441 = d_2;
        k = clamp((_e441 / 0.36f), 0f, 1f);
        let _e444 = k;
        let _e445 = k;
        let _e450 = body;
        let _e452 = (_e450.xyz * (0.8f + (0.45f * (1f - (_e444 * _e445)))));
        body[0u] = _e452.x;
        body[1u] = _e452.y;
        body[2u] = _e452.z;
    }
    let _e459 = led;
    lit = smoothstep(0f, 0.8f, _e459);
    let _e461 = plain;
    let _e462 = body;
    let _e463 = lit;
    let _e464 = lit;
    let _e465 = d_2;
    body = mix(_e461, _e462, vec4((_e463 * mix(1f, _e464, smoothstep(0f, 0.7f, _e465)))));
    let _e471 = gap;
    let _e472 = body;
    let _e473 = d_2;
    param_12 = _e473;
    let _e474 = r_1;
    param_13 = _e474;
    let _e475 = disc((&param_12), (&param_13));
    color = mix(_e471, _e472, vec4(_e475));
    let _e478 = color;
    return clamp(_e478, vec4(0f), vec4(1f));
}

fn main_1() {
    var param_14: vec2<f32>;

    let _e55 = _uv_1;
    param_14 = _e55;
    let _e56 = transition((&param_14));
    _fragColor = _e56;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
