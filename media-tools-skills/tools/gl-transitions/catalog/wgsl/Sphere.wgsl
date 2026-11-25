// Sphere — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Sphere.glsl
// Author: gre
// License: MIT
// Description: The outgoing image wraps itself onto a shaded ball that shrinks and rolls away, revealing the incoming image under its shadow
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    size: f32,
    shading: f32,
    shadow: f32,
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
    let _e51 = (*uv)[0u];
    let _e53 = (*uv)[1u];
    let _e56 = textureSampleLevel(_to, _sampler, vec2<f32>(_e51, (1f - _e53)), 0f);
    return _e56;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e51 = (*uv_1)[0u];
    let _e53 = (*uv_1)[1u];
    let _e56 = textureSampleLevel(_from, _sampler, vec2<f32>(_e51, (1f - _e53)), 0f);
    return _e56;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var side: vec2<f32>;
    var p: vec2<f32>;
    var shorter: f32;
    var r0_: f32;
    var w: f32;
    var away: f32;
    var wrapped: f32;
    var radius: f32;
    var tight: f32;
    var paper: f32;
    var e: f32;
    var full: f32;
    var travel: f32;
    var center: vec2<f32>;
    var angle: f32;
    var d: vec2<f32>;
    var r: f32;
    var sd: vec2<f32>;
    var sh: f32;
    var bg: vec4<f32>;
    var ball: vec4<f32>;
    var cover: f32;
    var nd: vec2<f32>;
    var n: vec3<f32>;
    var u: f32;
    var s: f32;
    var cu: f32;
    var su: f32;
    var q: vec3<f32>;
    var lq: f32;
    var arc: f32;
    var img: vec2<f32>;
    var local_1: vec2<f32>;
    var iuv: vec2<f32>;
    var edge: vec2<f32>;
    var inside: f32;
    var c: vec4<f32>;
    var param_2: vec2<f32>;
    var diff: f32;
    var spec: f32;
    var k: f32;
    var lit: vec3<f32>;
    var c_1: vec4<f32>;
    var local_2: vec4<f32>;

    let _e100 = uniforms.progress;
    if (_e100 <= 0f) {
        let _e102 = (*uv_2);
        param = _e102;
        let _e103 = getFromColor((&param));
        return _e103;
    }
    let _e104 = (*uv_2);
    param_1 = _e104;
    let _e105 = getToColor((&param_1));
    b = _e105;
    let _e107 = uniforms.progress;
    if (_e107 >= 1f) {
        let _e109 = b;
        return _e109;
    }
    let _e111 = uniforms.direction;
    if (length(_e111) > 0f) {
        let _e115 = uniforms.direction;
        local = normalize(_e115);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e117 = local;
    dir = _e117;
    let _e119 = dir[1u];
    let _e122 = dir[0u];
    side = vec2<f32>(-(_e119), _e122);
    let _e124 = (*uv_2);
    let _e128 = uniforms.ratio;
    p = ((_e124 - vec2(0.5f)) * vec2<f32>(_e128, 1f));
    let _e132 = uniforms.ratio;
    shorter = min(_e132, 1f);
    let _e135 = uniforms.size;
    let _e137 = shorter;
    r0_ = (clamp(_e135, 0.1f, 0.5f) * _e137);
    let _e140 = uniforms.progress;
    w = clamp((_e140 / 0.45f), 0f, 1f);
    let _e143 = w;
    let _e145 = w;
    w = (1f - ((1f - _e143) * (1f - _e145)));
    let _e150 = uniforms.progress;
    away = smoothstep(0.3f, 1f, _e150);
    let _e152 = away;
    let _e153 = away;
    away = (_e153 * _e152);
    let _e155 = r0_;
    let _e156 = w;
    wrapped = (_e155 / max(_e156, 0.0001f));
    let _e159 = wrapped;
    let _e160 = away;
    radius = (_e159 * mix(1f, 0.5f, _e160));
    let _e163 = shorter;
    let _e165 = r0_;
    let _e169 = w;
    let _e170 = w;
    tight = mix(1f, min(1f, ((0.48f * _e163) / (3.1415927f * _e165))), (_e169 * _e170));
    let _e173 = radius;
    let _e174 = tight;
    paper = (_e173 * _e174);
    let _e177 = dir[0u];
    let _e180 = uniforms.ratio;
    let _e183 = dir[1u];
    e = (0.5f * ((abs(_e177) * _e180) + abs(_e183)));
    let _e187 = e;
    let _e188 = r0_;
    full = ((_e187 + (1.1f * _e188)) + 0.003f);
    let _e192 = away;
    let _e193 = full;
    travel = (_e192 * _e193);
    let _e195 = dir;
    let _e196 = travel;
    center = (_e195 * _e196);
    let _e198 = full;
    let _e200 = away;
    let _e205 = wrapped;
    angle = (((-2f * _e198) * log((1f - (0.5f * _e200)))) / _e205);
    let _e207 = p;
    let _e208 = center;
    d = (_e207 - _e208);
    let _e210 = d;
    r = length(_e210);
    let _e212 = d;
    let _e213 = radius;
    let _e215 = w;
    sd = (_e212 - ((vec2<f32>(0.25f, -0.3f) * _e213) * _e215));
    let _e219 = uniforms.shadow;
    let _e220 = w;
    let _e222 = radius;
    let _e224 = radius;
    let _e226 = sd;
    sh = ((_e219 * _e220) * (1f - smoothstep((0.6f * _e222), (1.4f * _e224), length(_e226))));
    let _e231 = b;
    let _e234 = b[3u];
    let _e236 = sh;
    let _e238 = ((_e231.xyz * _e234) * (1f - _e236));
    let _e240 = b[3u];
    bg = vec4<f32>(_e238.x, _e238.y, _e238.z, _e240);
    ball = vec4<f32>(0f, 0f, 0f, 0f);
    let _e245 = radius;
    let _e247 = radius;
    let _e249 = r;
    cover = (1f - smoothstep((_e245 - 0.0015f), (_e247 + 0.0015f), _e249));
    let _e252 = cover;
    if (_e252 > 0f) {
        let _e254 = d;
        let _e255 = radius;
        nd = (_e254 / vec2(_e255));
        let _e258 = nd;
        let _e259 = nd;
        let _e260 = nd;
        n = vec3<f32>(_e258.x, _e258.y, sqrt(max((1f - dot(_e259, _e260)), 0f)));
        let _e268 = n;
        let _e270 = dir;
        u = dot(_e268.xy, _e270);
        let _e272 = n;
        let _e274 = side;
        s = dot(_e272.xy, _e274);
        let _e276 = angle;
        cu = cos(_e276);
        let _e278 = angle;
        su = sin(_e278);
        let _e280 = u;
        let _e281 = cu;
        let _e284 = n[2u];
        let _e285 = su;
        let _e288 = s;
        let _e289 = u;
        let _e290 = su;
        let _e293 = n[2u];
        let _e294 = cu;
        q = vec3<f32>(((_e280 * _e281) - (_e284 * _e285)), _e288, ((_e289 * _e290) + (_e293 * _e294)));
        let _e298 = q;
        lq = length(_e298.xy);
        let _e301 = lq;
        let _e303 = q[2u];
        let _e305 = paper;
        arc = (atan2(_e301, _e303) * _e305);
        let _e307 = lq;
        if (_e307 > 0f) {
            let _e310 = q[0u];
            let _e311 = dir;
            let _e314 = q[1u];
            let _e315 = side;
            let _e318 = lq;
            let _e321 = arc;
            local_1 = ((((_e311 * _e310) + (_e315 * _e314)) / vec2(_e318)) * _e321);
        } else {
            local_1 = vec2<f32>(0f, 0f);
        }
        let _e323 = local_1;
        img = _e323;
        let _e324 = img;
        let _e326 = uniforms.ratio;
        iuv = ((_e324 / vec2<f32>(_e326, 1f)) + vec2(0.5f));
        let _e331 = iuv;
        let _e332 = iuv;
        let _e337 = uniforms.ratio;
        edge = (min(_e331, (vec2(1f) - _e332)) * vec2<f32>(_e337, 1f));
        let _e340 = cover;
        let _e342 = edge[0u];
        let _e344 = edge[1u];
        inside = (_e340 * smoothstep(-0.0015f, 0.0015f, min(_e342, _e344)));
        let _e348 = inside;
        if (_e348 > 0f) {
            let _e350 = iuv;
            param_2 = clamp(_e350, vec2(0f), vec2(1f));
            let _e354 = getFromColor((&param_2));
            c = _e354;
            let _e355 = n;
            diff = max(dot(_e355, vec3<f32>(-0.39404207f, 0.4728505f, 0.78808415f)), 0f);
            let _e358 = n;
            spec = pow(max(reflect(vec3<f32>(0.39404207f, -0.4728505f, -0.78808415f), _e358).z, 0f), 24f);
            let _e364 = uniforms.shading;
            let _e365 = w;
            k = (_e364 * _e365);
            let _e367 = c;
            let _e369 = diff;
            let _e372 = k;
            let _e375 = k;
            let _e377 = spec;
            lit = ((_e367.xyz * mix(1f, (0.25f + (0.85f * _e369)), _e372)) + vec3(((0.35f * _e375) * _e377)));
            let _e381 = lit;
            let _e386 = c[3u];
            let _e387 = (clamp(_e381, vec3(0f), vec3(1f)) * _e386);
            let _e389 = c[3u];
            let _e394 = inside;
            ball = (vec4<f32>(_e387.x, _e387.y, _e387.z, _e389) * _e394);
        }
    }
    let _e396 = ball;
    let _e397 = bg;
    let _e399 = ball[3u];
    c_1 = (_e396 + (_e397 * (1f - _e399)));
    let _e404 = c_1[3u];
    if (_e404 > 0f) {
        let _e406 = c_1;
        let _e409 = c_1[3u];
        let _e411 = (_e406.xyz / vec3(_e409));
        let _e413 = c_1[3u];
        local_2 = vec4<f32>(_e411.x, _e411.y, _e411.z, _e413);
    } else {
        local_2 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e418 = local_2;
    return _e418;
}

fn main_1() {
    var param_3: vec2<f32>;

    let _e50 = _uv_1;
    param_3 = _e50;
    let _e51 = transition((&param_3));
    _fragColor = _e51;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
