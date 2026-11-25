// FilmStrip — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmStrip.glsl
// Author: gre
// License: MIT
// Description: The picture slips like film in a projector gate: it shrinks to show the sprocket holes, the strip runs down with motion blur and a slight weave, then the incoming frame lands in place
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    frames: i32,
    shrink: f32,
    blur: f32,
    weave: f32,
    filmColor: vec4<f32>,
    holeColor: vec4<f32>,
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

fn dither(cell: ptr<function, vec2<f32>>) -> f32 {
    let _e61 = (*cell);
    return fract((52.982918f * fract(dot(_e61, vec2<f32>(0.06711056f, 0.00583715f)))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e62 = (*uv)[0u];
    let _e64 = (*uv)[1u];
    let _e67 = textureSampleLevel(_to, _sampler, vec2<f32>(_e62, (1f - _e64)), 0f);
    return _e67;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e62 = (*uv_1)[0u];
    let _e64 = (*uv_1)[1u];
    let _e67 = textureSampleLevel(_from, _sampler, vec2<f32>(_e62, (1f - _e64)), 0f);
    return _e67;
}

fn film(x: ptr<function, f32>, y: ptr<function, f32>, base: ptr<function, f32>, n: ptr<function, f32>, aa: ptr<function, f32>, holeX: ptr<function, f32>, holeSize: ptr<function, vec2<f32>>, holes: ptr<function, f32>) -> vec4<f32> {
    var pitch: f32;
    var jy: f32;
    var j: f32;
    var fy: f32;
    var c: vec4<f32>;
    var q: vec2<f32>;
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var inside: f32;
    var hy: f32;
    var hx: f32;
    var dd: vec2<f32>;
    var sd: f32;

    pitch = 1.08f;
    let _e82 = (*y);
    let _e83 = pitch;
    jy = floor((_e82 / _e83));
    let _e86 = (*base);
    let _e87 = jy;
    j = (_e86 + _e87);
    let _e89 = (*y);
    let _e90 = jy;
    let _e91 = pitch;
    fy = (_e89 - (_e90 * _e91));
    let _e95 = uniforms.filmColor;
    c = _e95;
    let _e96 = (*x);
    let _e98 = (*x);
    let _e101 = fy;
    if (((_e96 >= 0f) && (_e98 <= 1f)) && (_e101 <= 1f)) {
        let _e104 = (*x);
        let _e105 = fy;
        q = vec2<f32>(_e104, _e105);
        let _e107 = j;
        let _e108 = (*n);
        if (_e107 < _e108) {
            let _e110 = q;
            param = _e110;
            let _e111 = getFromColor((&param));
            local = _e111;
        } else {
            let _e112 = q;
            param_1 = _e112;
            let _e113 = getToColor((&param_1));
            local = _e113;
        }
        let _e114 = local;
        c = _e114;
    }
    let _e115 = (*x);
    let _e116 = (*x);
    let _e120 = uniforms.ratio;
    let _e122 = fy;
    let _e123 = fy;
    inside = min((min(_e115, (1f - _e116)) * _e120), min(_e122, (1f - _e123)));
    let _e128 = uniforms.filmColor;
    let _e129 = c;
    let _e130 = inside;
    let _e131 = (*aa);
    c = mix(_e128, _e129, vec4(clamp(((_e130 / _e131) + 0.5f), 0f, 1f)));
    let _e137 = (*y);
    let _e138 = pitch;
    let _e139 = (_e138 / 4f);
    let _e144 = pitch;
    hy = ((_e137 - (floor((_e137 / _e139)) * _e139)) - ((0.5f * _e144) / 4f));
    let _e148 = (*x);
    let _e151 = (*holeX);
    let _e154 = uniforms.ratio;
    hx = ((abs((_e148 - 0.5f)) - _e151) * _e154);
    let _e156 = hx;
    let _e157 = hy;
    let _e160 = (*holeSize);
    let _e163 = (*holeSize)[0u];
    dd = ((abs(vec2<f32>(_e156, _e157)) - _e160) + vec2((0.3f * _e163)));
    let _e167 = dd;
    let _e172 = dd[0u];
    let _e174 = dd[1u];
    let _e179 = (*holeSize)[0u];
    sd = ((length(max(_e167, vec2(0f))) + min(max(_e172, _e174), 0f)) - (0.3f * _e179));
    let _e182 = c;
    let _e184 = uniforms.holeColor;
    let _e185 = sd;
    let _e186 = (*aa);
    let _e190 = (*holes);
    return mix(_e182, _e184, vec4((clamp((0.5f - (_e185 / _e186)), 0f, 1f) * _e190)));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var n_1: f32;
    var pitch_1: f32;
    var p: f32;
    var env: f32;
    var k: f32;
    var x0_: f32;
    var slip: f32;
    var speed: f32;
    var wob: f32;
    var dx: f32;
    var dy: f32;
    var frameSlip: f32;
    var base_1: f32;
    var x_1: f32;
    var y_1: f32;
    var aa_1: f32;
    var margin: f32;
    var holeX_1: f32;
    var holeSize_1: vec2<f32>;
    var holes_1: f32;
    var len: f32;
    var color: vec4<f32>;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: vec2<f32>;
    var param_11: f32;
    var jitter: f32;
    var param_12: vec2<f32>;
    var i: i32;
    var t: f32;
    var c_1: vec4<f32>;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;
    var param_19: vec2<f32>;
    var param_20: f32;
    var local_1: vec3<f32>;

    let _e108 = uniforms.progress;
    if (_e108 <= 0f) {
        let _e110 = (*uv_2);
        param_2 = _e110;
        let _e111 = getFromColor((&param_2));
        return _e111;
    }
    let _e113 = uniforms.progress;
    if (_e113 >= 1f) {
        let _e115 = (*uv_2);
        param_3 = _e115;
        let _e116 = getToColor((&param_3));
        return _e116;
    }
    let _e118 = uniforms.frames;
    n_1 = max(f32(_e118), 1f);
    pitch_1 = 1.08f;
    let _e122 = uniforms.progress;
    p = _e122;
    let _e123 = p;
    let _e125 = p;
    env = (smoothstep(0f, 0.3f, _e123) * (1f - smoothstep(0.7f, 1f, _e125)));
    let _e130 = uniforms.shrink;
    let _e131 = env;
    k = (1f - (_e130 * _e131));
    let _e134 = p;
    x0_ = clamp(((_e134 - 0.15f) / 0.7f), 0f, 1f);
    let _e138 = x0_;
    let _e139 = x0_;
    let _e141 = x0_;
    let _e143 = x0_;
    let _e144 = x0_;
    slip = (((_e138 * _e139) * _e141) * ((_e143 * ((_e144 * 6f) - 15f)) + 10f));
    let _e150 = x0_;
    let _e152 = x0_;
    let _e154 = x0_;
    let _e157 = x0_;
    speed = (((((30f * _e150) * _e152) * (1f - _e154)) * (1f - _e157)) / 0.7f);
    let _e162 = uniforms.weave;
    let _e163 = env;
    wob = (_e162 * _e163);
    let _e165 = wob;
    let _e167 = uniforms.shrink;
    let _e170 = p;
    let _e174 = p;
    dx = ((_e165 * smoothstep(0f, 0.1f, _e167)) * ((0.006f * sin((_e170 * 47f))) + (0.004f * sin(((_e174 * 113f) + 1.3f)))));
    let _e181 = wob;
    let _e183 = p;
    let _e188 = speed;
    dy = (((_e181 * 0.012f) * sin(((_e183 * 71f) + 0.4f))) * (1f - (_e188 / 2.7f)));
    let _e192 = slip;
    let _e193 = n_1;
    frameSlip = (_e192 * _e193);
    let _e195 = frameSlip;
    base_1 = floor(_e195);
    let _e198 = (*uv_2)[0u];
    let _e200 = k;
    let _e203 = dx;
    x_1 = ((((_e198 - 0.5f) / _e200) + 0.5f) + _e203);
    let _e206 = (*uv_2)[1u];
    let _e208 = k;
    let _e211 = dy;
    let _e213 = frameSlip;
    let _e214 = base_1;
    let _e216 = pitch_1;
    y_1 = (((((_e206 - 0.5f) / _e208) + 0.5f) + _e211) + ((_e213 - _e214) * _e216));
    let _e219 = env;
    let _e224 = uniforms.shrink;
    aa_1 = (((0.002f * min(1f, (10f * _e219))) * min(1f, (20f * _e224))) + 0.0001f);
    let _e230 = uniforms.shrink;
    let _e233 = uniforms.shrink;
    margin = ((0.5f * _e230) / max((1f - _e233), 0.01f));
    let _e237 = margin;
    holeX_1 = (0.5f + (0.5f * _e237));
    let _e240 = margin;
    let _e243 = uniforms.ratio;
    let _e245 = pitch_1;
    holeSize_1 = vec2<f32>(((0.28f * _e240) * _e243), ((0.11f * _e245) / 4f));
    let _e249 = margin;
    holes_1 = smoothstep(0f, 0.02f, _e249);
    let _e252 = uniforms.blur;
    let _e254 = speed;
    let _e256 = n_1;
    len = (((_e252 * 0.06f) * _e254) * _e256);
    color = vec4<f32>(0f, 0f, 0f, 0f);
    let _e258 = len;
    if (_e258 < 0.00001f) {
        let _e260 = x_1;
        param_4 = _e260;
        let _e261 = y_1;
        param_5 = _e261;
        let _e262 = base_1;
        param_6 = _e262;
        let _e263 = n_1;
        param_7 = _e263;
        let _e264 = aa_1;
        param_8 = _e264;
        let _e265 = holeX_1;
        param_9 = _e265;
        let _e266 = holeSize_1;
        param_10 = _e266;
        let _e267 = holes_1;
        param_11 = _e267;
        let _e268 = film((&param_4), (&param_5), (&param_6), (&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
        color = _e268;
    } else {
        let _e269 = (*uv_2);
        let _e271 = uniforms.ratio;
        param_12 = floor(((_e269 * vec2<f32>(_e271, 1f)) * 540f));
        let _e276 = dither((&param_12));
        jitter = _e276;
        i = 0i;
        loop {
            let _e277 = i;
            if (_e277 < 16i) {
                let _e279 = i;
                let _e281 = jitter;
                t = (((f32(_e279) + _e281) / 16f) - 0.5f);
                let _e285 = y_1;
                let _e286 = t;
                let _e287 = len;
                let _e290 = x_1;
                param_13 = _e290;
                param_14 = (_e285 + (_e286 * _e287));
                let _e291 = base_1;
                param_15 = _e291;
                let _e292 = n_1;
                param_16 = _e292;
                let _e293 = aa_1;
                param_17 = _e293;
                let _e294 = holeX_1;
                param_18 = _e294;
                let _e295 = holeSize_1;
                param_19 = _e295;
                let _e296 = holes_1;
                param_20 = _e296;
                let _e297 = film((&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18), (&param_19), (&param_20));
                c_1 = _e297;
                let _e298 = c_1;
                let _e301 = c_1[3u];
                let _e302 = (_e298.xyz * _e301);
                let _e304 = c_1[3u];
                let _e309 = color;
                color = (_e309 + vec4<f32>(_e302.x, _e302.y, _e302.z, _e304));
                continue;
            } else {
                break;
            }
            continuing {
                let _e311 = i;
                i = (_e311 + 1i);
            }
        }
        let _e313 = color;
        color = (_e313 / vec4(16f));
        let _e317 = color[3u];
        if (_e317 > 0f) {
            let _e319 = color;
            let _e322 = color[3u];
            local_1 = (_e319.xyz / vec3(_e322));
        } else {
            local_1 = vec3<f32>(0f, 0f, 0f);
        }
        let _e325 = local_1;
        color[0u] = _e325.x;
        color[1u] = _e325.y;
        color[2u] = _e325.z;
    }
    let _e332 = wob;
    let _e334 = p;
    let _e341 = color;
    let _e343 = (_e341.xyz * (1f - ((0.08f * _e332) * (0.5f + (0.5f * sin((_e334 * 157f)))))));
    color[0u] = _e343.x;
    color[1u] = _e343.y;
    color[2u] = _e343.z;
    let _e350 = color;
    return _e350;
}

fn main_1() {
    var param_21: vec2<f32>;

    let _e61 = _uv_1;
    param_21 = _e61;
    let _e62 = transition((&param_21));
    _fragColor = _e62;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
