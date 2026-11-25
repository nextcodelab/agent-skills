// ArrowWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ArrowWipe.glsl
// Author: gre
// License: MIT
// Description: A notched arrowhead window onto the incoming image flies in from the edge behind it (or appears at the center), then swells until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    notch: f32,
    width: f32,
    count: i32,
    origin: i32,
    smoothness: f32,
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
    let _e37 = (*uv)[0u];
    let _e39 = (*uv)[1u];
    let _e42 = textureSampleLevel(_to, _sampler, vec2<f32>(_e37, (1f - _e39)), 0f);
    return _e42;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e37 = (*uv_1)[0u];
    let _e39 = (*uv_1)[1u];
    let _e42 = textureSampleLevel(_from, _sampler, vec2<f32>(_e37, (1f - _e39)), 0f);
    return _e42;
}

fn arrow(q: ptr<function, vec2<f32>>, tip: ptr<function, f32>, back: ptr<function, f32>, tipN: ptr<function, vec2<f32>>, notchN: ptr<function, vec2<f32>>) -> f32 {
    var front: f32;
    var rear: f32;

    let _e43 = (*q)[0u];
    let _e44 = (*tip);
    let _e47 = (*q)[1u];
    let _e49 = (*tipN);
    front = dot(vec2<f32>((_e43 - _e44), _e47), _e49);
    let _e51 = (*back);
    let _e53 = (*q)[0u];
    let _e56 = (*q)[1u];
    let _e59 = (*notchN);
    rear = dot(vec2<f32>((_e51 - _e53), -(_e56)), _e59);
    let _e61 = front;
    let _e62 = rear;
    return max(_e61, _e62);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var across: vec2<f32>;
    var p: vec2<f32>;
    var q_1: vec2<f32>;
    var s: f32;
    var n: f32;
    var h: f32;
    var cot: f32;
    var tipN_1: vec2<f32>;
    var notchLen: f32;
    var notchN_1: vec2<f32>;
    var tipPad: f32;
    var c1_: vec2<f32>;
    var c2_: vec2<f32>;
    var k1_: vec2<f32>;
    var k2_: vec2<f32>;
    var e: f32;
    var r: f32;
    var tipMin: f32;
    var notchMax: f32;
    var body: f32;
    var cover: f32;
    var t: f32;
    var o: f32;
    var l: f32;
    var l0_: f32;
    var o0_: f32;
    var u: f32;
    var fly: f32;
    var grow: f32;
    var gap: f32;
    var d: f32;
    var param: vec2<f32>;
    var param_1: f32;
    var param_2: f32;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var i: i32;
    var back_1: f32;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: f32;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var m: f32;
    var a: vec4<f32>;
    var param_10: vec2<f32>;
    var b: vec4<f32>;
    var param_11: vec2<f32>;
    var c: vec4<f32>;
    var local_1: vec4<f32>;

    let _e89 = uniforms.direction;
    if (length(_e89) > 0f) {
        let _e93 = uniforms.direction;
        local = normalize(_e93);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e95 = local;
    dir = _e95;
    let _e97 = dir[1u];
    let _e100 = dir[0u];
    across = vec2<f32>(-(_e97), _e100);
    let _e102 = (*uv_2);
    let _e106 = uniforms.ratio;
    p = ((_e102 - vec2(0.5f)) * vec2<f32>(_e106, 1f));
    let _e109 = p;
    let _e110 = dir;
    let _e112 = p;
    let _e113 = across;
    q_1 = vec2<f32>(dot(_e109, _e110), abs(dot(_e112, _e113)));
    let _e118 = uniforms.smoothness;
    s = max(_e118, 0.001f);
    let _e121 = uniforms.notch;
    n = clamp(_e121, 0f, 0.9f);
    let _e124 = uniforms.width;
    h = radians((0.5f * clamp(_e124, 20f, 160f)));
    let _e128 = h;
    let _e130 = h;
    cot = (cos(_e128) / sin(_e130));
    let _e133 = h;
    let _e135 = h;
    tipN_1 = vec2<f32>(sin(_e133), cos(_e135));
    let _e138 = n;
    let _e139 = cot;
    notchLen = length(vec2<f32>(1f, (_e138 * _e139)));
    let _e143 = n;
    let _e144 = cot;
    let _e147 = notchLen;
    notchN_1 = (vec2<f32>(1f, (_e143 * _e144)) / vec2(_e147));
    let _e150 = s;
    let _e151 = h;
    tipPad = (_e150 / sin(_e151));
    let _e155 = uniforms.ratio;
    c1_ = vec2<f32>((0.5f * _e155), 0.5f);
    let _e159 = uniforms.ratio;
    c2_ = vec2<f32>((0.5f * _e159), -0.5f);
    let _e162 = c1_;
    let _e163 = dir;
    let _e166 = c1_;
    let _e167 = across;
    k1_ = vec2<f32>(abs(dot(_e162, _e163)), abs(dot(_e166, _e167)));
    let _e171 = c2_;
    let _e172 = dir;
    let _e175 = c2_;
    let _e176 = across;
    k2_ = vec2<f32>(abs(dot(_e171, _e172)), abs(dot(_e175, _e176)));
    let _e181 = k1_[0u];
    let _e183 = k2_[0u];
    e = max(_e181, _e183);
    let _e186 = dir[0u];
    let _e189 = uniforms.ratio;
    let _e192 = dir[1u];
    r = (0.5f / max((abs(_e186) / _e189), abs(_e192)));
    let _e197 = k1_[0u];
    let _e199 = k1_[1u];
    let _e200 = cot;
    let _e204 = k2_[0u];
    let _e206 = k2_[1u];
    let _e207 = cot;
    let _e211 = tipPad;
    tipMin = (max((_e197 + (_e199 * _e200)), (_e204 + (_e206 * _e207))) + _e211);
    let _e213 = n;
    let _e214 = cot;
    let _e217 = k1_[1u];
    let _e220 = k1_[0u];
    let _e222 = n;
    let _e223 = cot;
    let _e226 = k2_[1u];
    let _e229 = k2_[0u];
    let _e232 = r;
    let _e235 = s;
    let _e236 = notchLen;
    notchMax = (min(min((((_e213 * _e214) * _e217) - _e220), (((_e222 * _e223) * _e226) - _e229)), -(_e232)) - (_e235 * _e236));
    let _e239 = n;
    body = (0.5f * (1f - _e239));
    let _e242 = tipMin;
    let _e243 = notchMax;
    let _e246 = body;
    cover = (max(_e242, -(_e243)) / _e246);
    let _e249 = uniforms.progress;
    t = _e249;
    let _e251 = uniforms.origin;
    if (_e251 != 0i) {
        o = 0f;
        let _e253 = cover;
        let _e254 = t;
        let _e256 = t;
        l = ((_e253 * _e254) * (0.4f + (0.6f * _e256)));
    } else {
        let _e261 = uniforms.ratio;
        let _e264 = h;
        l0_ = ((0.92f * min(1f, _e261)) / max(1f, (2f * tan(_e264))));
        let _e269 = e;
        let _e271 = tipPad;
        let _e274 = body;
        let _e275 = l0_;
        o0_ = ((-(_e269) - (2f * _e271)) - (_e274 * _e275));
        let _e278 = t;
        u = (1f - clamp((_e278 / 0.65f), 0f, 1f));
        let _e282 = u;
        let _e283 = u;
        let _e285 = u;
        fly = (1f - ((_e282 * _e283) * _e285));
        let _e288 = t;
        grow = clamp(((_e288 - 0.3f) / 0.7f), 0f, 1f);
        let _e292 = o0_;
        let _e293 = fly;
        o = mix(_e292, 0f, _e293);
        let _e295 = l0_;
        let _e296 = cover;
        let _e297 = grow;
        let _e298 = grow;
        let _e300 = grow;
        l = mix(_e295, _e296, ((_e297 * _e298) * (2f - _e300)));
    }
    let _e304 = n;
    gap = ((1f - _e304) * 1.35f);
    let _e307 = o;
    let _e308 = body;
    let _e309 = l;
    let _e312 = o;
    let _e313 = body;
    let _e314 = l;
    let _e317 = q_1;
    param = _e317;
    param_1 = (_e307 + (_e308 * _e309));
    param_2 = (_e312 - (_e313 * _e314));
    let _e318 = tipN_1;
    param_3 = _e318;
    let _e319 = notchN_1;
    param_4 = _e319;
    let _e320 = arrow((&param), (&param_1), (&param_2), (&param_3), (&param_4));
    d = _e320;
    i = 1i;
    loop {
        let _e321 = i;
        if (_e321 < 3i) {
            let _e323 = i;
            let _e325 = uniforms.count;
            if (_e323 < _e325) {
                let _e327 = o;
                let _e328 = i;
                let _e330 = gap;
                let _e332 = l;
                back_1 = (_e327 - ((f32(_e328) * _e330) * _e332));
                let _e335 = d;
                let _e336 = back_1;
                let _e337 = body;
                let _e338 = l;
                let _e341 = back_1;
                let _e342 = body;
                let _e343 = l;
                let _e346 = q_1;
                param_5 = _e346;
                param_6 = (_e336 + (_e337 * _e338));
                param_7 = (_e341 - (_e342 * _e343));
                let _e347 = tipN_1;
                param_8 = _e347;
                let _e348 = notchN_1;
                param_9 = _e348;
                let _e349 = arrow((&param_5), (&param_6), (&param_7), (&param_8), (&param_9));
                d = min(_e335, _e349);
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e351 = i;
            i = (_e351 + 1i);
        }
    }
    let _e353 = s;
    let _e355 = s;
    let _e356 = d;
    let _e357 = s;
    let _e359 = t;
    m = (1f - smoothstep(-(_e353), _e355, (_e356 + ((2f * _e357) * (1f - _e359)))));
    let _e365 = (*uv_2);
    param_10 = _e365;
    let _e366 = getFromColor((&param_10));
    a = _e366;
    let _e367 = (*uv_2);
    param_11 = _e367;
    let _e368 = getToColor((&param_11));
    b = _e368;
    let _e369 = a;
    let _e372 = a[3u];
    let _e373 = (_e369.xyz * _e372);
    let _e375 = a[3u];
    let _e380 = b;
    let _e383 = b[3u];
    let _e384 = (_e380.xyz * _e383);
    let _e386 = b[3u];
    let _e391 = m;
    c = mix(vec4<f32>(_e373.x, _e373.y, _e373.z, _e375), vec4<f32>(_e384.x, _e384.y, _e384.z, _e386), vec4(_e391));
    let _e395 = c[3u];
    if (_e395 > 0f) {
        let _e397 = c;
        let _e400 = c[3u];
        let _e402 = (_e397.xyz / vec3(_e400));
        let _e404 = c[3u];
        local_1 = vec4<f32>(_e402.x, _e402.y, _e402.z, _e404);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e409 = local_1;
    return _e409;
}

fn main_1() {
    var param_12: vec2<f32>;

    let _e36 = _uv_1;
    param_12 = _e36;
    let _e37 = transition((&param_12));
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
