// BokehDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BokehDissolve.glsl
// Author: gre
// License: MIT
// Description: The image falls out of focus like a camera lens, its highlights swelling into large bright bokeh discs, and the incoming image sharpens back out of its own bokeh
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    radius: f32,
    blades: i32,
    threshold: f32,
    intensity: f32,
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
    let _e40 = (*v);
    let _e41 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e40 - (floor((_e40 / _e41)) * _e41)))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e41 = (*uv)[0u];
    let _e43 = (*uv)[1u];
    let _e46 = textureSampleLevel(_to, _sampler, vec2<f32>(_e41, (1f - _e43)), 0f);
    return _e46;
}

fn highlight(c: ptr<function, vec4<f32>>, t: ptr<function, f32>) -> f32 {
    var lum: f32;
    var h: f32;

    let _e43 = (*c);
    lum = dot(_e43.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e46 = (*t);
    if (_e46 >= 1f) {
        return 0f;
    }
    let _e48 = (*t);
    let _e49 = lum;
    h = smoothstep(_e48, 1f, _e49);
    let _e51 = h;
    let _e52 = h;
    let _e55 = (*c)[3u];
    return ((_e51 * _e52) * _e55);
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e41 = (*uv_1)[0u];
    let _e43 = (*uv_1)[1u];
    let _e46 = textureSampleLevel(_from, _sampler, vec2<f32>(_e41, (1f - _e43)), 0f);
    return _e46;
}

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e41 = (*p);
    p3_ = fract((_e41.xyx * 0.1031f));
    let _e45 = p3_;
    let _e46 = p3_;
    let _e51 = p3_;
    p3_ = (_e51 + vec3(dot(_e45, (_e46.yzx + vec3(33.33f)))));
    let _e55 = p3_[0u];
    let _e57 = p3_[1u];
    let _e60 = p3_[2u];
    return fract(((_e55 + _e57) * _e60));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var t_1: f32;
    var k: f32;
    var w: f32;
    var r: f32;
    var boost: f32;
    var n: f32;
    var local: f32;
    var sector: f32;
    var local_1: f32;
    var apothem: f32;
    var cell: vec2<f32>;
    var spin: f32;
    var param: vec2<f32>;
    var jitter: f32;
    var param_1: vec2<f32>;
    var useFrom: bool;
    var useTo: bool;
    var s0_: vec4<f32>;
    var s1_: vec4<f32>;
    var t0_: f32;
    var t1_: f32;
    var l0_: vec3<f32>;
    var l1_: vec3<f32>;
    var c_1: vec4<f32>;
    var param_2: vec2<f32>;
    var h_1: f32;
    var param_3: vec4<f32>;
    var param_4: f32;
    var wt: f32;
    var c_2: vec4<f32>;
    var param_5: vec2<f32>;
    var h_2: f32;
    var param_6: vec4<f32>;
    var param_7: f32;
    var wt_1: f32;
    var i: i32;
    var fi: f32;
    var a: f32;
    var d: f32;
    var s: f32;
    var st: vec2<f32>;
    var param_8: vec2<f32>;
    var c_3: vec4<f32>;
    var param_9: vec2<f32>;
    var h_3: f32;
    var param_10: vec4<f32>;
    var param_11: f32;
    var wt_2: f32;
    var c_4: vec4<f32>;
    var param_12: vec2<f32>;
    var h_4: f32;
    var param_13: vec4<f32>;
    var param_14: f32;
    var wt_3: f32;
    var b: vec4<f32>;
    var local_2: vec4<f32>;
    var local_3: vec4<f32>;
    var rgb: vec3<f32>;
    var light: vec3<f32>;

    let _e100 = uniforms.progress;
    t_1 = (1f - abs(((2f * _e100) - 1f)));
    let _e105 = t_1;
    let _e106 = t_1;
    let _e108 = t_1;
    k = ((_e105 * _e106) * (3f - (2f * _e108)));
    let _e113 = uniforms.progress;
    w = smoothstep(0.35f, 0.65f, _e113);
    let _e116 = uniforms.radius;
    let _e117 = k;
    r = (_e116 * _e117);
    let _e120 = uniforms.intensity;
    let _e122 = k;
    boost = ((12f * _e120) * _e122);
    let _e125 = uniforms.blades;
    if (_e125 >= 3i) {
        let _e128 = uniforms.blades;
        local = f32(_e128);
    } else {
        local = 0f;
    }
    let _e130 = local;
    n = _e130;
    let _e131 = n;
    if (_e131 > 0f) {
        let _e133 = n;
        local_1 = (6.2831855f / _e133);
    } else {
        local_1 = 1f;
    }
    let _e135 = local_1;
    sector = _e135;
    let _e136 = sector;
    apothem = cos((0.5f * _e136));
    let _e139 = (*uv_2);
    let _e141 = uniforms.ratio;
    cell = floor(((_e139 * vec2<f32>(_e141, 1f)) * 997f));
    let _e146 = cell;
    param = _e146;
    let _e147 = hash12((&param));
    spin = (6.2831855f * _e147);
    let _e149 = cell;
    param_1 = (_e149 + vec2(17f));
    let _e152 = hash12((&param_1));
    jitter = _e152;
    let _e153 = w;
    useFrom = (_e153 < 1f);
    let _e155 = w;
    useTo = (_e155 > 0f);
    s0_ = vec4<f32>(0f, 0f, 0f, 0f);
    s1_ = vec4<f32>(0f, 0f, 0f, 0f);
    t0_ = 0f;
    t1_ = 0f;
    l0_ = vec3<f32>(0f, 0f, 0f);
    l1_ = vec3<f32>(0f, 0f, 0f);
    let _e157 = useFrom;
    if _e157 {
        let _e158 = (*uv_2);
        param_2 = _e158;
        let _e159 = getFromColor((&param_2));
        c_1 = _e159;
        let _e160 = c_1;
        param_3 = _e160;
        let _e162 = uniforms.threshold;
        param_4 = _e162;
        let _e163 = highlight((&param_3), (&param_4));
        h_1 = _e163;
        let _e164 = boost;
        let _e165 = h_1;
        wt = (1f + (_e164 * _e165));
        let _e168 = wt;
        let _e169 = c_1;
        let _e172 = c_1[3u];
        let _e173 = (_e169.xyz * _e172);
        let _e175 = c_1[3u];
        s0_ = (vec4<f32>(_e173.x, _e173.y, _e173.z, _e175) * _e168);
        let _e181 = wt;
        t0_ = _e181;
        let _e182 = h_1;
        let _e183 = c_1;
        l0_ = (_e183.xyz * _e182);
    }
    let _e186 = useTo;
    if _e186 {
        let _e187 = (*uv_2);
        param_5 = _e187;
        let _e188 = getToColor((&param_5));
        c_2 = _e188;
        let _e189 = c_2;
        param_6 = _e189;
        let _e191 = uniforms.threshold;
        param_7 = _e191;
        let _e192 = highlight((&param_6), (&param_7));
        h_2 = _e192;
        let _e193 = boost;
        let _e194 = h_2;
        wt_1 = (1f + (_e193 * _e194));
        let _e197 = wt_1;
        let _e198 = c_2;
        let _e201 = c_2[3u];
        let _e202 = (_e198.xyz * _e201);
        let _e204 = c_2[3u];
        s1_ = (vec4<f32>(_e202.x, _e202.y, _e202.z, _e204) * _e197);
        let _e210 = wt_1;
        t1_ = _e210;
        let _e211 = h_2;
        let _e212 = c_2;
        l1_ = (_e212.xyz * _e211);
    }
    i = 0i;
    loop {
        let _e215 = i;
        if (_e215 < 16i) {
            let _e217 = i;
            fi = f32(_e217);
            let _e219 = fi;
            let _e221 = spin;
            a = ((_e219 * 2.3999631f) + _e221);
            let _e223 = fi;
            let _e224 = jitter;
            d = sqrt(((_e223 + _e224) / 16f));
            let _e228 = n;
            if (_e228 > 0f) {
                let _e230 = a;
                let _e231 = sector;
                let _e236 = sector;
                s = ((_e230 - (floor((_e230 / _e231)) * _e231)) - (0.5f * _e236));
                let _e239 = apothem;
                let _e240 = s;
                let _e243 = d;
                d = (_e243 * (_e239 / cos(_e240)));
            }
            let _e245 = (*uv_2);
            let _e246 = r;
            let _e247 = d;
            let _e249 = a;
            let _e252 = uniforms.ratio;
            let _e254 = a;
            param_8 = (_e245 + (vec2<f32>((cos(_e249) / _e252), sin(_e254)) * (_e246 * _e247)));
            let _e259 = mirror((&param_8));
            st = _e259;
            let _e260 = useFrom;
            if _e260 {
                let _e261 = st;
                param_9 = _e261;
                let _e262 = getFromColor((&param_9));
                c_3 = _e262;
                let _e263 = c_3;
                param_10 = _e263;
                let _e265 = uniforms.threshold;
                param_11 = _e265;
                let _e266 = highlight((&param_10), (&param_11));
                h_3 = _e266;
                let _e267 = boost;
                let _e268 = h_3;
                wt_2 = (1f + (_e267 * _e268));
                let _e271 = wt_2;
                let _e272 = c_3;
                let _e275 = c_3[3u];
                let _e276 = (_e272.xyz * _e275);
                let _e278 = c_3[3u];
                let _e284 = s0_;
                s0_ = (_e284 + (vec4<f32>(_e276.x, _e276.y, _e276.z, _e278) * _e271));
                let _e286 = wt_2;
                let _e287 = t0_;
                t0_ = (_e287 + _e286);
                let _e289 = h_3;
                let _e290 = c_3;
                let _e293 = l0_;
                l0_ = (_e293 + (_e290.xyz * _e289));
            }
            let _e295 = useTo;
            if _e295 {
                let _e296 = st;
                param_12 = _e296;
                let _e297 = getToColor((&param_12));
                c_4 = _e297;
                let _e298 = c_4;
                param_13 = _e298;
                let _e300 = uniforms.threshold;
                param_14 = _e300;
                let _e301 = highlight((&param_13), (&param_14));
                h_4 = _e301;
                let _e302 = boost;
                let _e303 = h_4;
                wt_3 = (1f + (_e302 * _e303));
                let _e306 = wt_3;
                let _e307 = c_4;
                let _e310 = c_4[3u];
                let _e311 = (_e307.xyz * _e310);
                let _e313 = c_4[3u];
                let _e319 = s1_;
                s1_ = (_e319 + (vec4<f32>(_e311.x, _e311.y, _e311.z, _e313) * _e306));
                let _e321 = wt_3;
                let _e322 = t1_;
                t1_ = (_e322 + _e321);
                let _e324 = h_4;
                let _e325 = c_4;
                let _e328 = l1_;
                l1_ = (_e328 + (_e325.xyz * _e324));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e330 = i;
            i = (_e330 + 1i);
        }
    }
    let _e332 = useFrom;
    if _e332 {
        let _e333 = s0_;
        let _e334 = t0_;
        local_2 = (_e333 / vec4(_e334));
    } else {
        local_2 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e337 = local_2;
    let _e338 = useTo;
    if _e338 {
        let _e339 = s1_;
        let _e340 = t1_;
        local_3 = (_e339 / vec4(_e340));
    } else {
        local_3 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e343 = local_3;
    let _e344 = w;
    b = mix(_e337, _e343, vec4(_e344));
    let _e348 = b[3u];
    if (_e348 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e350 = b;
    let _e353 = b[3u];
    rgb = (_e350.xyz / vec3(_e353));
    let _e356 = l0_;
    let _e357 = l1_;
    let _e358 = w;
    let _e362 = uniforms.intensity;
    let _e363 = k;
    light = (mix(_e356, _e357, vec3(_e358)) * (((_e362 * _e363) * 4f) / 17f));
    let _e368 = rgb;
    let _e374 = light;
    rgb = (vec3(1f) - ((vec3(1f) - clamp(_e368, vec3(0f), vec3(1f))) * exp(-(_e374))));
    let _e380 = rgb;
    let _e382 = b[3u];
    return vec4<f32>(_e380.x, _e380.y, _e380.z, _e382);
}

fn main_1() {
    var param_15: vec2<f32>;

    let _e40 = _uv_1;
    param_15 = _e40;
    let _e41 = transition((&param_15));
    _fragColor = _e41;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
