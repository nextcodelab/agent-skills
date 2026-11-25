// SplitFlap — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplitFlap.glsl
// Author: gre
// License: MIT
// Description: The frame becomes a split-flap board: in each cell the top half of the outgoing image flips down on a hinge across the middle, cell after cell, its back bringing the bottom half of the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    size: vec2<i32>,
    stagger: f32,
    randomness: f32,
    flaps: i32,
    gap: f32,
    perspective: f32,
    shading: f32,
    background: vec4<f32>,
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

fn cardMask(x: ptr<function, f32>, f: ptr<function, f32>, cellSize: ptr<function, vec2<f32>>, g: ptr<function, f32>) -> f32 {
    var e: f32;
    var d: f32;

    let _e51 = (*g);
    if (_e51 <= 0f) {
        return 1f;
    }
    let _e53 = (*g);
    let _e55 = uniforms.gap;
    e = (0.001f * min(1f, (_e53 / max(_e55, 0.0001f))));
    let _e60 = (*x);
    let _e61 = (*x);
    let _e65 = (*cellSize)[0u];
    let _e67 = (*f);
    let _e69 = (*f);
    let _e73 = (*cellSize)[1u];
    d = min((min(_e60, (1f - _e61)) * _e65), (min((2f * _e67), (0.5f - _e69)) * _e73));
    let _e76 = (*g);
    let _e78 = e;
    let _e80 = (*g);
    let _e82 = e;
    let _e84 = d;
    return smoothstep(((0.5f * _e76) - _e78), ((0.5f * _e80) + _e82), _e84);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e47 = (*uv)[0u];
    let _e49 = (*uv)[1u];
    let _e52 = textureSampleLevel(_to, _sampler, vec2<f32>(_e47, (1f - _e49)), 0f);
    return _e52;
}

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e47 = (*v);
    v3_ = fract((_e47.xyx * 0.1031f));
    let _e51 = v3_;
    let _e52 = v3_;
    let _e57 = v3_;
    v3_ = (_e57 + vec3(dot(_e51, (_e52.yzx + vec3(33.33f)))));
    let _e61 = v3_[0u];
    let _e63 = v3_[1u];
    let _e66 = v3_[2u];
    return fract(((_e61 + _e63) * _e66));
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e47 = (*uv_1)[0u];
    let _e49 = (*uv_1)[1u];
    let _e52 = textureSampleLevel(_from, _sampler, vec2<f32>(_e47, (1f - _e49)), 0f);
    return _e52;
}

fn card(i: ptr<function, f32>, n: ptr<function, f32>, cell: ptr<function, vec2<f32>>, grid: ptr<function, vec2<f32>>, lc: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var src: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e55 = (*i);
    if (_e55 < 0.5f) {
        let _e57 = (*cell);
        let _e58 = (*lc);
        let _e60 = (*grid);
        param = ((_e57 + _e58) / _e60);
        let _e62 = getFromColor((&param));
        return _e62;
    }
    let _e63 = (*cell);
    src = _e63;
    let _e64 = (*i);
    let _e65 = (*n);
    if (_e64 < (_e65 - 0.5f)) {
        let _e68 = (*cell);
        let _e70 = (*i);
        param_1 = ((_e68 * 3.7f) + vec2((_e70 * 11.3f)));
        let _e74 = hash12((&param_1));
        let _e75 = (*cell);
        let _e77 = (*i);
        param_2 = (((_e75 * 5.3f) + vec2((_e77 * 7.9f))) + vec2(1.7f));
        let _e83 = hash12((&param_2));
        let _e85 = (*grid);
        src = floor((vec2<f32>(_e74, _e83) * _e85));
    }
    let _e88 = src;
    let _e89 = (*lc);
    let _e91 = (*grid);
    param_3 = ((_e88 + _e89) / _e91);
    let _e93 = getToColor((&param_3));
    return _e93;
}

fn flapIndex(t: ptr<function, f32>, n_1: ptr<function, f32>) -> f32 {
    let _e47 = (*t);
    let _e48 = (*n_1);
    let _e51 = (*n_1);
    return min(floor((_e47 * _e48)), (_e51 - 1f));
}

fn flapAngle(t_1: ptr<function, f32>, n_2: ptr<function, f32>) -> f32 {
    var u: f32;
    var param_4: f32;
    var param_5: f32;

    let _e50 = (*t_1);
    let _e51 = (*n_2);
    let _e53 = (*t_1);
    param_4 = _e53;
    let _e54 = (*n_2);
    param_5 = _e54;
    let _e55 = flapIndex((&param_4), (&param_5));
    u = ((_e50 * _e51) - _e55);
    let _e57 = u;
    let _e59 = u;
    return ((3.1415927f * _e57) * (0.3f + (0.7f * _e59)));
}

fn cellTime(cell_1: ptr<function, vec2<f32>>, grid_1: ptr<function, vec2<f32>>) -> f32 {
    var wave: f32;
    var order: f32;
    var param_6: vec2<f32>;
    var delay: f32;

    let _e52 = (*cell_1)[0u];
    let _e54 = (*grid_1)[1u];
    let _e57 = (*cell_1)[1u];
    let _e62 = (*grid_1)[0u];
    let _e65 = (*grid_1)[1u];
    wave = ((_e52 + (0.5f * ((_e54 - 1f) - _e57))) / max(((_e62 - 1f) + (0.5f * (_e65 - 1f))), 1f));
    let _e71 = wave;
    let _e72 = (*cell_1);
    param_6 = (_e72 + vec2(17f));
    let _e75 = hash12((&param_6));
    let _e77 = uniforms.randomness;
    order = mix(_e71, _e75, _e77);
    let _e80 = uniforms.stagger;
    delay = clamp(_e80, 0f, 0.99f);
    let _e83 = uniforms.progress;
    let _e84 = order;
    let _e85 = delay;
    let _e88 = delay;
    return clamp(((_e83 - (_e84 * _e85)) / (1f - _e88)), 0f, 1f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var grid_2: vec2<f32>;
    var n_3: f32;
    var cellSize_1: vec2<f32>;
    var cell_2: vec2<f32>;
    var l: vec2<f32>;
    var g_1: f32;
    var w: f32;
    var upper: bool;
    var t_2: f32;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var k: f32;
    var param_9: f32;
    var param_10: f32;
    var a: f32;
    var param_11: f32;
    var param_12: f32;
    var started: bool;
    var landed: bool;
    var color: vec4<f32>;
    var local: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var local_1: f32;
    var param_18: f32;
    var param_19: f32;
    var param_20: vec2<f32>;
    var param_21: f32;
    var nearest: f32;
    var d_1: i32;
    var nc: vec2<f32>;
    var nt: f32;
    var local_2: f32;
    var param_22: vec2<f32>;
    var param_23: vec2<f32>;
    var na: f32;
    var local_3: f32;
    var param_24: f32;
    var param_25: f32;
    var fc: f32;
    var fs: f32;
    var f_1: f32;
    var z: f32;
    var lx: f32;
    var front: bool;
    var lc_1: vec2<f32>;
    var local_4: f32;
    var m: f32;
    var param_26: f32;
    var param_27: f32;
    var param_28: vec2<f32>;
    var param_29: f32;
    var img: vec4<f32>;
    var param_30: f32;
    var param_31: f32;
    var param_32: f32;
    var param_33: f32;
    var param_34: vec2<f32>;
    var param_35: vec2<f32>;
    var param_36: vec2<f32>;
    var lambert: f32;
    var local_5: f32;
    var phi_506_: bool;
    var phi_556_: bool;

    let _e112 = uniforms.size;
    grid_2 = max(vec2<f32>(_e112), vec2(1f));
    let _e117 = uniforms.flaps;
    n_3 = max(f32(_e117), 1f);
    let _e121 = uniforms.ratio;
    let _e123 = grid_2;
    let _e126 = uniforms.ratio;
    cellSize_1 = ((vec2<f32>(_e121, 1f) / _e123) / vec2(min(_e126, 1f)));
    let _e130 = (*uv_2);
    let _e131 = grid_2;
    cell_2 = floor((_e130 * _e131));
    let _e134 = (*uv_2);
    let _e135 = grid_2;
    let _e137 = cell_2;
    l = ((_e134 * _e135) - _e137);
    let _e140 = uniforms.gap;
    let _e142 = uniforms.progress;
    let _e146 = uniforms.progress;
    g_1 = ((_e140 * smoothstep(0f, 0.12f, _e142)) * (1f - smoothstep(0.88f, 1f, _e146)));
    let _e151 = l[1u];
    w = (_e151 - 0.5f);
    let _e153 = w;
    upper = (_e153 >= 0f);
    let _e155 = cell_2;
    param_7 = _e155;
    let _e156 = grid_2;
    param_8 = _e156;
    let _e157 = cellTime((&param_7), (&param_8));
    t_2 = _e157;
    let _e158 = t_2;
    param_9 = _e158;
    let _e159 = n_3;
    param_10 = _e159;
    let _e160 = flapIndex((&param_9), (&param_10));
    k = _e160;
    let _e161 = t_2;
    param_11 = _e161;
    let _e162 = n_3;
    param_12 = _e162;
    let _e163 = flapAngle((&param_11), (&param_12));
    a = _e163;
    let _e164 = t_2;
    let _e165 = n_3;
    let _e167 = k;
    started = ((_e164 * _e165) > _e167);
    let _e169 = t_2;
    landed = (_e169 >= 1f);
    let _e171 = k;
    let _e172 = upper;
    if _e172 {
        let _e173 = started;
        local = select(0f, 1f, _e173);
    } else {
        let _e175 = landed;
        local = select(0f, 1f, _e175);
    }
    let _e177 = local;
    param_13 = (_e171 + _e177);
    let _e179 = n_3;
    param_14 = _e179;
    let _e180 = cell_2;
    param_15 = _e180;
    let _e181 = grid_2;
    param_16 = _e181;
    let _e182 = l;
    param_17 = _e182;
    let _e183 = card((&param_13), (&param_14), (&param_15), (&param_16), (&param_17));
    color = _e183;
    let _e184 = started;
    let _e185 = landed;
    if (_e184 && !(_e185)) {
        let _e189 = uniforms.shading;
        let _e191 = upper;
        if _e191 {
            let _e192 = a;
            local_1 = cos(_e192);
        } else {
            let _e194 = a;
            local_1 = -(cos(_e194));
        }
        let _e197 = local_1;
        let _e201 = color;
        let _e203 = (_e201.xyz * (1f - ((0.45f * _e189) * max(_e197, 0f))));
        color[0u] = _e203.x;
        color[1u] = _e203.y;
        color[2u] = _e203.z;
    }
    let _e211 = uniforms.background;
    let _e212 = color;
    let _e213 = w;
    let _e216 = l[0u];
    param_18 = _e216;
    param_19 = abs(_e213);
    let _e217 = cellSize_1;
    param_20 = _e217;
    let _e218 = g_1;
    param_21 = _e218;
    let _e219 = cardMask((&param_18), (&param_19), (&param_20), (&param_21));
    color = mix(_e211, _e212, vec4(_e219));
    nearest = -1f;
    d_1 = -1i;
    loop {
        let _e222 = d_1;
        if (_e222 <= 1i) {
            let _e224 = cell_2;
            let _e225 = d_1;
            nc = (_e224 + vec2<f32>(f32(_e225), 0f));
            let _e230 = nc[0u];
            let _e231 = (_e230 < 0f);
            phi_506_ = _e231;
            if !(_e231) {
                let _e234 = nc[0u];
                let _e236 = grid_2[0u];
                phi_506_ = (_e234 > (_e236 - 1f));
            }
            let _e240 = phi_506_;
            if _e240 {
                continue;
            }
            let _e241 = d_1;
            if (_e241 == 0i) {
                let _e243 = t_2;
                local_2 = _e243;
            } else {
                let _e244 = nc;
                param_22 = _e244;
                let _e245 = grid_2;
                param_23 = _e245;
                let _e246 = cellTime((&param_22), (&param_23));
                local_2 = _e246;
            }
            let _e247 = local_2;
            nt = _e247;
            let _e248 = d_1;
            if (_e248 == 0i) {
                let _e250 = a;
                local_3 = _e250;
            } else {
                let _e251 = nt;
                param_24 = _e251;
                let _e252 = n_3;
                param_25 = _e252;
                let _e253 = flapAngle((&param_24), (&param_25));
                local_3 = _e253;
            }
            let _e254 = local_3;
            na = _e254;
            let _e255 = na;
            fc = cos(_e255);
            let _e257 = na;
            fs = sin(_e257);
            let _e259 = fc;
            let _e261 = (abs(_e259) < 0.00001f);
            phi_556_ = _e261;
            if !(_e261) {
                let _e263 = w;
                let _e265 = fc;
                phi_556_ = ((_e263 >= 0f) != (_e265 > 0f));
            }
            let _e269 = phi_556_;
            if _e269 {
                continue;
            }
            let _e270 = w;
            let _e271 = fc;
            f_1 = (_e270 / _e271);
            let _e273 = f_1;
            if (_e273 > 0.5f) {
                continue;
            }
            let _e275 = f_1;
            let _e276 = fs;
            z = (_e275 * _e276);
            let _e278 = z;
            let _e279 = nearest;
            if (_e278 <= _e279) {
                continue;
            }
            let _e282 = l[0u];
            let _e283 = d_1;
            let _e288 = uniforms.perspective;
            let _e289 = z;
            lx = (0.5f + (((_e282 - f32(_e283)) - 0.5f) * (1f - (_e288 * _e289))));
            let _e294 = lx;
            let _e296 = lx;
            if ((_e294 < 0f) || (_e296 > 1f)) {
                continue;
            }
            let _e299 = fc;
            front = (_e299 > 0f);
            let _e301 = lx;
            let _e302 = front;
            if _e302 {
                let _e303 = f_1;
                local_4 = (0.5f + _e303);
            } else {
                let _e305 = f_1;
                local_4 = (0.5f - _e305);
            }
            let _e307 = local_4;
            lc_1 = vec2<f32>(_e301, _e307);
            let _e309 = lx;
            param_26 = _e309;
            let _e310 = f_1;
            param_27 = _e310;
            let _e311 = cellSize_1;
            param_28 = _e311;
            let _e312 = g_1;
            param_29 = _e312;
            let _e313 = cardMask((&param_26), (&param_27), (&param_28), (&param_29));
            m = _e313;
            let _e314 = m;
            if (_e314 <= 0f) {
                continue;
            }
            let _e316 = nt;
            param_30 = _e316;
            let _e317 = n_3;
            param_31 = _e317;
            let _e318 = flapIndex((&param_30), (&param_31));
            let _e319 = front;
            param_32 = (_e318 + select(1f, 0f, _e319));
            let _e322 = n_3;
            param_33 = _e322;
            let _e323 = nc;
            param_34 = _e323;
            let _e324 = grid_2;
            param_35 = _e324;
            let _e325 = lc_1;
            param_36 = _e325;
            let _e326 = card((&param_32), (&param_33), (&param_34), (&param_35), (&param_36));
            img = _e326;
            let _e327 = front;
            if _e327 {
                let _e328 = fc;
                let _e330 = fs;
                local_5 = ((0.92f * _e328) - (0.4f * _e330));
            } else {
                let _e333 = fs;
                let _e335 = fc;
                local_5 = ((0.4f * _e333) - (0.92f * _e335));
            }
            let _e338 = local_5;
            lambert = (_e338 / 0.92f);
            let _e341 = uniforms.shading;
            let _e343 = lambert;
            let _e346 = img;
            let _e348 = (_e346.xyz * mix((1f - _e341), 1f, clamp(_e343, 0f, 1f)));
            img[0u] = _e348.x;
            img[1u] = _e348.y;
            img[2u] = _e348.z;
            let _e355 = color;
            let _e356 = img;
            let _e357 = m;
            color = mix(_e355, _e356, vec4(_e357));
            let _e360 = z;
            nearest = _e360;
            continue;
        } else {
            break;
        }
        continuing {
            let _e361 = d_1;
            d_1 = (_e361 + 1i);
        }
    }
    let _e363 = color;
    return _e363;
}

fn main_1() {
    var param_37: vec2<f32>;

    let _e46 = _uv_1;
    param_37 = _e46;
    let _e47 = transition((&param_37));
    _fragColor = _e47;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
