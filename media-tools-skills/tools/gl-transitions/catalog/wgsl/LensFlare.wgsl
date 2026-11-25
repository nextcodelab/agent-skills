// LensFlare — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LensFlare.glsl
// Author: gre
// License: MIT
// Description: A bright light sweeps across the frame and flares the lens: a long thin horizontal streak, a glowing core and a trail of colored ghost reflections; at its peak the incoming image spreads out from the light under its glare
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    angle: f32,
    height: f32,
    intensity: f32,
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

fn highlight(c: ptr<function, vec4<f32>>) -> vec3<f32> {
    var lum: f32;

    let _e69 = (*c);
    lum = dot(_e69.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e72 = (*c);
    let _e74 = lum;
    return (_e72.xyz * smoothstep(0.55f, 0.95f, _e74));
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e68 = (*v);
    let _e69 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e68 - (floor((_e68 / _e69)) * _e69)))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e69 = (*uv)[0u];
    let _e71 = (*uv)[1u];
    let _e74 = textureSampleLevel(_to, _sampler, vec2<f32>(_e69, (1f - _e71)), 0f);
    return _e74;
}

fn premultiplied(c_1: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e68 = (*c_1);
    let _e71 = (*c_1)[3u];
    let _e72 = (_e68.xyz * _e71);
    let _e74 = (*c_1)[3u];
    return vec4<f32>(_e72.x, _e72.y, _e72.z, _e74);
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e69 = (*uv_1)[0u];
    let _e71 = (*uv_1)[1u];
    let _e74 = textureSampleLevel(_from, _sampler, vec2<f32>(_e69, (1f - _e71)), 0f);
    return _e74;
}

fn frame(st: ptr<function, vec2<f32>>, m: ptr<function, f32>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: vec4<f32>;

    let _e77 = (*m);
    if (_e77 <= 0f) {
        let _e79 = (*st);
        param = _e79;
        let _e80 = getFromColor((&param));
        param_1 = _e80;
        let _e81 = premultiplied((&param_1));
        return _e81;
    }
    let _e82 = (*m);
    if (_e82 >= 1f) {
        let _e84 = (*st);
        param_2 = _e84;
        let _e85 = getToColor((&param_2));
        param_3 = _e85;
        let _e86 = premultiplied((&param_3));
        return _e86;
    }
    let _e87 = (*st);
    param_4 = _e87;
    let _e88 = getFromColor((&param_4));
    param_5 = _e88;
    let _e89 = premultiplied((&param_5));
    let _e90 = (*st);
    param_6 = _e90;
    let _e91 = getToColor((&param_6));
    param_7 = _e91;
    let _e92 = premultiplied((&param_7));
    let _e93 = (*m);
    return mix(_e89, _e92, vec4(_e93));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var env: f32;
    var peak: f32;
    var aspect: vec2<f32>;
    var q: vec2<f32>;
    var r: f32;
    var dir: vec2<f32>;
    var normal: vec2<f32>;
    var t: f32;
    var travel: f32;
    var along: f32;
    var src: vec2<f32>;
    var d: vec2<f32>;
    var dist: f32;
    var k: f32;
    var cut: f32;
    var s: f32;
    var soft: f32;
    var reach: f32;
    var front: f32;
    var m_1: f32;
    var base: vec4<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var ax: f32;
    var ay: f32;
    var thin: f32;
    var wide: f32;
    var tint: vec3<f32>;
    var streak: vec3<f32>;
    var core: vec3<f32>;
    var ghosts: vec3<f32>;
    var i: i32;
    var fi: f32;
    var f: f32;
    var g: vec2<f32>;
    var size: f32;
    var gd: f32;
    var disc: f32;
    var hue: vec3<f32>;
    var bloom: vec3<f32>;
    var radius: f32;
    var i_1: i32;
    var fi_1: f32;
    var a: f32;
    var rr: f32;
    var o: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: vec4<f32>;
    var glare: vec3<f32>;
    var light: vec3<f32>;
    var c_2: vec3<f32>;

    let _e125 = uniforms.progress;
    p = _e125;
    let _e126 = p;
    if (_e126 <= 0f) {
        let _e128 = (*uv_2);
        param_8 = _e128;
        let _e129 = getFromColor((&param_8));
        return _e129;
    }
    let _e130 = p;
    if (_e130 >= 1f) {
        let _e132 = (*uv_2);
        param_9 = _e132;
        let _e133 = getToColor((&param_9));
        return _e133;
    }
    let _e134 = p;
    let _e136 = p;
    env = ((4f * _e134) * (1f - _e136));
    let _e139 = env;
    peak = pow(_e139, 24f);
    let _e142 = uniforms.ratio;
    aspect = vec2<f32>(_e142, 1f);
    let _e144 = (*uv_2);
    let _e147 = aspect;
    q = ((_e144 - vec2(0.5f)) * _e147);
    let _e150 = uniforms.angle;
    r = radians(_e150);
    let _e152 = r;
    let _e154 = r;
    dir = vec2<f32>(cos(_e152), -(sin(_e154)));
    let _e159 = dir[1u];
    let _e162 = dir[0u];
    normal = vec2<f32>(-(_e159), _e162);
    let _e164 = p;
    t = (_e164 - 0.5f);
    let _e167 = dir[0u];
    let _e170 = uniforms.ratio;
    let _e173 = dir[1u];
    travel = ((0.5f * ((abs(_e167) * _e170) + abs(_e173))) + 0.3f);
    let _e178 = travel;
    let _e179 = t;
    let _e182 = t;
    let _e184 = t;
    along = ((_e178 * (2f * _e179)) * (0.55f + ((1.8f * _e182) * _e184)));
    let _e188 = dir;
    let _e189 = along;
    let _e191 = normal;
    let _e193 = uniforms.height;
    src = ((_e188 * _e189) + (_e191 * _e193));
    let _e196 = q;
    let _e197 = src;
    d = (_e196 - _e197);
    let _e199 = d;
    dist = length(_e199);
    let _e202 = uniforms.intensity;
    let _e203 = env;
    k = (_e202 * _e203);
    let _e206 = uniforms.intensity;
    cut = mix(0.2f, 0.06f, clamp(_e206, 0f, 1f));
    let _e209 = p;
    let _e211 = cut;
    let _e213 = cut;
    s = clamp((((_e209 - 0.5f) + _e211) / (2f * _e213)), 0f, 1f);
    soft = 0.3f;
    let _e217 = aspect;
    let _e220 = src;
    let _e223 = soft;
    reach = (((0.5f * length(_e217)) + length(_e220)) + _e223);
    let _e225 = s;
    let _e226 = reach;
    let _e227 = soft;
    front = (_e225 * (_e226 + _e227));
    let _e230 = front;
    let _e231 = front;
    let _e232 = soft;
    let _e234 = dist;
    m_1 = smoothstep(_e230, (_e231 - _e232), _e234);
    let _e236 = (*uv_2);
    param_10 = _e236;
    let _e237 = m_1;
    param_11 = _e237;
    let _e238 = frame((&param_10), (&param_11));
    base = _e238;
    let _e240 = d[0u];
    ax = abs(_e240);
    let _e243 = d[1u];
    ay = abs(_e243);
    let _e245 = ay;
    let _e249 = ax;
    thin = (exp((-(_e245) * 140f)) * exp((-(_e249) * 0.7f)));
    let _e254 = ay;
    let _e258 = ax;
    wide = (exp((-(_e254) * 30f)) * exp((-(_e258) * 1.6f)));
    let _e264 = uniforms.color;
    tint = _e264;
    let _e265 = thin;
    let _e266 = tint;
    let _e267 = ax;
    let _e272 = wide;
    let _e274 = tint;
    streak = (((mix(vec3<f32>(1f, 1f, 1f), _e266, vec3(smoothstep(0f, 0.3f, _e267))) * _e265) + (_e274 * (0.5f * _e272))) * 3f);
    let _e278 = dist;
    let _e280 = dist;
    let _e286 = tint;
    let _e289 = dist;
    core = (((vec3<f32>(1f, 0.97f, 0.92f) * exp(((-(_e278) * _e280) * 600f))) * 3f) + ((mix(vec3<f32>(1f, 1f, 1f), _e286, vec3(0.5f)) * exp((-(_e289) * 7f))) * 0.6f));
    ghosts = vec3<f32>(0f, 0f, 0f);
    i = 0i;
    loop {
        let _e296 = i;
        if (_e296 < 6i) {
            let _e298 = i;
            fi = f32(_e298);
            let _e300 = fi;
            let _e303 = fi;
            f = ((-0.45f + (0.42f * _e300)) + (0.08f * sin((_e303 * 2.3f))));
            let _e308 = src;
            let _e310 = f;
            g = (-(_e308) * _e310);
            let _e312 = fi;
            size = (0.025f + (0.06f * fract(((_e312 * 0.618f) + 0.2f))));
            let _e318 = q;
            let _e319 = g;
            let _e322 = size;
            gd = (length((_e318 - _e319)) / _e322);
            let _e324 = gd;
            let _e326 = gd;
            disc = (smoothstep(1f, 0.8f, _e324) * (0.35f + (0.65f * smoothstep(0.4f, 0.95f, _e326))));
            let _e331 = tint;
            let _e332 = fi;
            hue = mix(_e331, vec3<f32>(1f, 0.65f, 0.35f), vec3(fract((_e332 * 0.53f))));
            let _e337 = hue;
            let _e338 = fi;
            hue = mix(_e337, vec3<f32>(0.5f, 1f, 0.6f), vec3((step(4.5f, _e338) * 0.6f)));
            let _e343 = disc;
            let _e344 = hue;
            let _e347 = ghosts;
            ghosts = (_e347 + ((_e344 * _e343) * 0.45f));
            continue;
        } else {
            break;
        }
        continuing {
            let _e349 = i;
            i = (_e349 + 1i);
        }
    }
    bloom = vec3<f32>(0f, 0f, 0f);
    let _e351 = peak;
    if (_e351 > 0.001f) {
        let _e353 = env;
        radius = (0.06f * _e353);
        i_1 = 0i;
        loop {
            let _e355 = i_1;
            if (_e355 < 12i) {
                let _e357 = i_1;
                fi_1 = f32(_e357);
                let _e359 = fi_1;
                a = (_e359 * 2.39996f);
                let _e361 = radius;
                let _e362 = fi_1;
                rr = (_e361 * sqrt(((_e362 + 0.5f) / 12f)));
                let _e367 = a;
                let _e369 = a;
                let _e372 = rr;
                let _e374 = aspect;
                o = ((vec2<f32>(cos(_e367), sin(_e369)) * _e372) / _e374);
                let _e376 = (*uv_2);
                let _e377 = o;
                param_12 = (_e376 + _e377);
                let _e379 = mirror((&param_12));
                param_13 = _e379;
                let _e380 = m_1;
                param_14 = _e380;
                let _e381 = frame((&param_13), (&param_14));
                param_15 = _e381;
                let _e382 = highlight((&param_15));
                let _e383 = bloom;
                bloom = (_e383 + _e382);
                continue;
            } else {
                break;
            }
            continuing {
                let _e385 = i_1;
                i_1 = (_e385 + 1i);
            }
        }
        let _e387 = bloom;
        bloom = (_e387 / vec3(12f));
    }
    let _e390 = tint;
    let _e393 = peak;
    let _e395 = dist;
    glare = ((mix(vec3<f32>(1f, 1f, 1f), _e390, vec3(0.5f)) * _e393) * (0.45f + (2.2f * exp((-(_e395) * 3f)))));
    let _e402 = k;
    let _e403 = streak;
    let _e404 = core;
    let _e406 = ghosts;
    let _e410 = uniforms.intensity;
    let _e411 = bloom;
    let _e413 = peak;
    let _e415 = glare;
    light = ((((_e403 + _e404) + _e406) * _e402) + ((((_e411 * 2.5f) * _e413) + _e415) * _e410));
    let _e419 = light;
    light = (vec3(1f) - exp(-(_e419)));
    let _e424 = base;
    let _e426 = light;
    let _e428 = base[3u];
    let _e431 = base;
    let _e433 = light;
    c_2 = ((_e424.xyz + (_e426 * _e428)) - (_e431.xyz * _e433));
    let _e437 = base[3u];
    if (_e437 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e439 = c_2;
    let _e441 = base[3u];
    let _e446 = clamp((_e439 / vec3(_e441)), vec3(0f), vec3(1f));
    let _e448 = base[3u];
    return vec4<f32>(_e446.x, _e446.y, _e446.z, _e448);
}

fn main_1() {
    var param_16: vec2<f32>;

    let _e68 = _uv_1;
    param_16 = _e68;
    let _e69 = transition((&param_16));
    _fragColor = _e69;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
