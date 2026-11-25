// Vaporize — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Vaporize.glsl
// Author: gre
// License: MIT
// Description: The outgoing image goes up in smoke: from one side, the picture itself turns to vapour that rises over what is still intact, curls into wisps and pales as it thins out, revealing the incoming image underneath
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    rise: f32,
    swirl: f32,
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
    let _e62 = (*v);
    let _e63 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e62 - (floor((_e62 / _e63)) * _e63)))));
}

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e63 = (*p);
    p3_ = fract((_e63.xyx * 0.1031f));
    let _e67 = p3_;
    let _e68 = p3_;
    let _e73 = p3_;
    p3_ = (_e73 + vec3(dot(_e67, (_e68.yzx + vec3(33.33f)))));
    let _e77 = p3_[0u];
    let _e79 = p3_[1u];
    let _e82 = p3_[2u];
    return fract(((_e77 + _e79) * _e82));
}

fn vnoise(p_1: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e68 = (*p_1);
    i = floor(_e68);
    let _e70 = (*p_1);
    f = fract(_e70);
    let _e72 = f;
    let _e73 = f;
    let _e75 = f;
    f = ((_e72 * _e73) * (vec2(3f) - (_e75 * 2f)));
    let _e80 = i;
    param = _e80;
    let _e81 = hash12((&param));
    let _e82 = i;
    param_1 = (_e82 + vec2<f32>(1f, 0f));
    let _e84 = hash12((&param_1));
    let _e86 = f[0u];
    let _e88 = i;
    param_2 = (_e88 + vec2<f32>(0f, 1f));
    let _e90 = hash12((&param_2));
    let _e91 = i;
    param_3 = (_e91 + vec2<f32>(1f, 1f));
    let _e93 = hash12((&param_3));
    let _e95 = f[0u];
    let _e98 = f[1u];
    return mix(mix(_e81, _e84, _e86), mix(_e90, _e93, _e95), _e98);
}

fn curl(p_2: ptr<function, vec2<f32>>) -> vec2<f32> {
    var e: f32;
    var n: f32;
    var param_4: vec2<f32>;
    var nx: f32;
    var param_5: vec2<f32>;
    var ny: f32;
    var param_6: vec2<f32>;

    e = 0.1f;
    let _e69 = (*p_2);
    param_4 = _e69;
    let _e70 = vnoise((&param_4));
    n = _e70;
    let _e71 = (*p_2);
    let _e72 = e;
    param_5 = (_e71 + vec2<f32>(_e72, 0f));
    let _e75 = vnoise((&param_5));
    nx = _e75;
    let _e76 = (*p_2);
    let _e77 = e;
    param_6 = (_e76 + vec2<f32>(0f, _e77));
    let _e80 = vnoise((&param_6));
    ny = _e80;
    let _e81 = ny;
    let _e82 = n;
    let _e84 = n;
    let _e85 = nx;
    let _e88 = e;
    return (vec2<f32>((_e81 - _e82), (_e84 - _e85)) / vec2(_e88));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e63 = (*uv)[0u];
    let _e65 = (*uv)[1u];
    let _e68 = textureSampleLevel(_to, _sampler, vec2<f32>(_e63, (1f - _e65)), 0f);
    return _e68;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e63 = (*uv_1)[0u];
    let _e65 = (*uv_1)[1u];
    let _e68 = textureSampleLevel(_from, _sampler, vec2<f32>(_e63, (1f - _e65)), 0f);
    return _e68;
}

fn sweep(t: ptr<function, f32>) -> f32 {
    let _e62 = (*t);
    let _e63 = (*t);
    let _e65 = (*t);
    let _e68 = (*t);
    return (_e62 + (((0.6f * _e63) * (1f - _e65)) * (1f - (2f * _e68))));
}

fn fbm(p_3: ptr<function, vec2<f32>>) -> f32 {
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;

    let _e65 = (*p_3);
    param_7 = _e65;
    let _e66 = vnoise((&param_7));
    let _e68 = (*p_3);
    param_8 = ((_e68 * 2.03f) + vec2(5.1f));
    let _e72 = vnoise((&param_8));
    let _e75 = (*p_3);
    param_9 = ((_e75 * 4.1f) + vec2(9.7f));
    let _e79 = vnoise((&param_9));
    return (((0.55f * _e66) + (0.3f * _e72)) + (0.15f * _e79));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var side: vec2<f32>;
    var q: vec2<f32>;
    var along: f32;
    var across: f32;
    var ext: f32;
    var ragged: f32;
    var param_10: vec2<f32>;
    var start: f32;
    var travel: f32;
    var front: f32;
    var param_11: f32;
    var gone: f32;
    var base: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var height: f32;
    var param_14: vec2<f32>;
    var age: f32;
    var released: f32;
    var origin: f32;
    var param_15: f32;
    var org: vec2<f32>;
    var sw: vec2<f32>;
    var param_16: vec2<f32>;
    var src: vec2<f32>;
    var spreadOut: vec2<f32>;
    var c: vec4<f32>;
    var i_1: i32;
    var t_1: f32;
    var img: vec4<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var local_1: vec4<f32>;
    var wq: vec2<f32>;
    var w: f32;
    var param_19: vec2<f32>;
    var density: f32;
    var pale: f32;
    var l: f32;
    var a: f32;
    var outA: f32;

    let _e106 = uniforms.direction;
    if (length(_e106) > 0f) {
        let _e110 = uniforms.direction;
        local = normalize(_e110);
    } else {
        local = vec2<f32>(0f, 1f);
    }
    let _e112 = local;
    dir = _e112;
    let _e114 = dir[1u];
    let _e117 = dir[0u];
    side = vec2<f32>(-(_e114), _e117);
    let _e119 = (*uv_2);
    let _e123 = uniforms.ratio;
    q = ((_e119 - vec2(0.5f)) * vec2<f32>(_e123, 1f));
    let _e126 = q;
    let _e127 = dir;
    along = dot(_e126, _e127);
    let _e129 = q;
    let _e130 = side;
    across = dot(_e129, _e130);
    let _e133 = dir[0u];
    let _e136 = uniforms.ratio;
    let _e139 = dir[1u];
    ext = (0.5f * ((abs(_e133) * _e136) + abs(_e139)));
    let _e143 = q;
    param_10 = ((_e143 * 2.5f) + vec2(1.3f));
    let _e147 = fbm((&param_10));
    ragged = (0.09f * ((2f * _e147) - 1f));
    let _e151 = ext;
    start = (-(_e151) - 0.09f);
    let _e154 = ext;
    travel = (((2f * _e154) + 0.18f) + 0.12f);
    let _e158 = start;
    let _e159 = travel;
    let _e161 = uniforms.progress;
    param_11 = _e161;
    let _e162 = sweep((&param_11));
    let _e165 = ragged;
    front = ((_e158 + (_e159 * _e162)) + _e165);
    let _e167 = front;
    let _e168 = along;
    gone = smoothstep(0f, 0.12f, (_e167 - _e168));
    let _e171 = (*uv_2);
    param_12 = _e171;
    let _e172 = getFromColor((&param_12));
    let _e173 = (*uv_2);
    param_13 = _e173;
    let _e174 = getToColor((&param_13));
    let _e175 = gone;
    base = mix(_e172, _e174, vec4(_e175));
    let _e179 = uniforms.rise;
    let _e181 = across;
    param_14 = vec2<f32>(((_e181 * 3f) + 2.7f), 0.5f);
    let _e185 = vnoise((&param_14));
    height = (max(_e179, 0.05f) * (0.7f + (0.6f * _e185)));
    let _e189 = along;
    let _e190 = front;
    let _e192 = height;
    age = ((_e189 - _e190) / _e192);
    let _e195 = uniforms.progress;
    let _e196 = age;
    released = (_e195 - (_e196 * 0.16f));
    let _e199 = age;
    let _e201 = age;
    let _e204 = released;
    if (((_e199 <= 0f) || (_e201 >= 1f)) || (_e204 <= 0f)) {
        let _e207 = base;
        return _e207;
    }
    let _e208 = start;
    let _e209 = travel;
    let _e210 = released;
    param_15 = _e210;
    let _e211 = sweep((&param_15));
    let _e214 = ragged;
    origin = ((_e208 + (_e209 * _e211)) + _e214);
    let _e216 = q;
    let _e217 = dir;
    let _e218 = along;
    let _e219 = origin;
    org = (_e216 - (_e217 * (_e218 - _e219)));
    let _e223 = org;
    let _e225 = dir;
    let _e227 = uniforms.progress;
    param_16 = ((_e223 * 3f) + ((_e225 * _e227) * 1.5f));
    let _e231 = curl((&param_16));
    let _e233 = uniforms.swirl;
    let _e235 = age;
    sw = (_e231 * ((_e233 * 0.08f) * sqrt(_e235)));
    let _e239 = org;
    let _e240 = sw;
    src = (_e239 - _e240);
    let _e242 = side;
    let _e244 = dir;
    let _e247 = age;
    spreadOut = (((_e242 * 0.07f) + (_e244 * 0.02f)) * sqrt(_e247));
    c = vec4<f32>(0f, 0f, 0f, 0f);
    i_1 = 0i;
    loop {
        let _e250 = i_1;
        if (_e250 < 6i) {
            let _e252 = i_1;
            t_1 = ((f32(_e252) / 5f) - 0.5f);
            let _e256 = src;
            let _e257 = spreadOut;
            let _e258 = t_1;
            let _e262 = uniforms.ratio;
            param_17 = (((_e256 + (_e257 * _e258)) / vec2<f32>(_e262, 1f)) + vec2(0.5f));
            let _e267 = mirror((&param_17));
            param_18 = _e267;
            let _e268 = getFromColor((&param_18));
            img = _e268;
            let _e269 = img;
            let _e272 = img[3u];
            let _e273 = (_e269.xyz * _e272);
            let _e275 = img[3u];
            let _e280 = c;
            c = (_e280 + vec4<f32>(_e273.x, _e273.y, _e273.z, _e275));
            continue;
        } else {
            break;
        }
        continuing {
            let _e282 = i_1;
            i_1 = (_e282 + 1i);
        }
    }
    let _e285 = c[3u];
    if (_e285 > 0f) {
        let _e287 = c;
        let _e290 = c[3u];
        let _e292 = (_e287.xyz / vec3(_e290));
        let _e294 = c[3u];
        local_1 = vec4<f32>(_e292.x, _e292.y, _e292.z, (_e294 / 6f));
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e300 = local_1;
    c = _e300;
    let _e301 = q;
    let _e302 = sw;
    let _e305 = dir;
    let _e307 = uniforms.progress;
    wq = (((_e301 - (_e302 * 0.6f)) - (_e305 * (_e307 * 2.5f))) * 4f);
    let _e312 = wq;
    let _e313 = side;
    let _e315 = wq;
    let _e316 = dir;
    param_19 = (vec2<f32>(dot(_e312, _e313), (dot(_e315, _e316) * 0.6f)) + vec2(2f));
    let _e322 = fbm((&param_19));
    w = _e322;
    let _e323 = age;
    let _e326 = age;
    let _e329 = w;
    density = smoothstep(((1.2f * _e323) - 0.2f), ((1.2f * _e326) + 0.1f), _e329);
    let _e331 = age;
    let _e334 = density;
    density = (_e334 * (1f - smoothstep(0.3f, 1f, _e331)));
    let _e336 = ext;
    let _e338 = ext;
    let _e341 = origin;
    let _e343 = density;
    density = (_e343 * smoothstep(-(_e336), (-(_e338) + 0.05f), _e341));
    let _e345 = age;
    pale = smoothstep(0f, 0.5f, _e345);
    let _e347 = c;
    l = dot(_e347.xyz, vec3<f32>(0.299f, 0.587f, 0.114f));
    let _e350 = c;
    let _e351 = l;
    let _e354 = uniforms.color;
    let _e357 = mix(vec3(_e351), _e354.xyz, vec3(0.7f));
    let _e359 = c[3u];
    let _e362 = uniforms.color[3u];
    let _e368 = pale;
    c = mix(_e350, vec4<f32>(_e357.x, _e357.y, _e357.z, (_e359 * _e362)), vec4((_e368 * 0.85f)));
    let _e372 = c;
    let _e374 = pale;
    let _e376 = density;
    let _e378 = density;
    let _e383 = min((_e372.xyz + vec3((((0.12f * _e374) * _e376) * (1f - _e378)))), vec3<f32>(1f, 1f, 1f));
    c[0u] = _e383.x;
    c[1u] = _e383.y;
    c[2u] = _e383.z;
    let _e390 = density;
    let _e392 = c[3u];
    a = (_e390 * _e392);
    let _e394 = a;
    let _e396 = base[3u];
    let _e397 = a;
    outA = (_e394 + (_e396 * (1f - _e397)));
    let _e401 = outA;
    if (_e401 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e403 = c;
    let _e405 = a;
    let _e407 = base;
    let _e410 = base[3u];
    let _e412 = a;
    let _e416 = outA;
    let _e418 = (((_e403.xyz * _e405) + ((_e407.xyz * _e410) * (1f - _e412))) / vec3(_e416));
    let _e419 = outA;
    return vec4<f32>(_e418.x, _e418.y, _e418.z, _e419);
}

fn main_1() {
    var param_20: vec2<f32>;

    let _e62 = _uv_1;
    param_20 = _e62;
    let _e63 = transition((&param_20));
    _fragColor = _e63;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
