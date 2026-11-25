// Cube — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Cube.glsl
// Author: gre
// License: MIT
// Description: The two images are faces of a box that turns a quarter turn in perspective, the outgoing face darkening as it turns away, above a reflective floor
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    persp: f32,
    unzoom: f32,
    reflection: f32,
    floating: f32,
    shading: f32,
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
    let _e43 = (*uv)[0u];
    let _e45 = (*uv)[1u];
    let _e48 = textureSampleLevel(_to, _sampler, vec2<f32>(_e43, (1f - _e45)), 0f);
    return _e48;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e43 = (*uv_1)[0u];
    let _e45 = (*uv_1)[1u];
    let _e48 = textureSampleLevel(_from, _sampler, vec2<f32>(_e43, (1f - _e45)), 0f);
    return _e48;
}

fn hitBox(eye: ptr<function, vec3<f32>>, dir: ptr<function, vec3<f32>>, w: ptr<function, f32>, c: ptr<function, f32>, s: ptr<function, f32>) -> vec4<f32> {
    var pivot: vec2<f32>;
    var e: vec2<f32>;
    var o: vec2<f32>;
    var d: vec2<f32>;
    var inv: vec2<f32>;
    var local: f32;
    var local_1: f32;
    var t0_: vec2<f32>;
    var t1_: vec2<f32>;
    var tn: vec2<f32>;
    var tf: vec2<f32>;
    var tin: f32;
    var hit: vec2<f32>;
    var y: f32;
    var phi_197_: bool;

    let _e60 = (*w);
    pivot = vec2((0.5f * _e60));
    let _e63 = (*eye);
    let _e65 = pivot;
    e = (_e63.xz - _e65);
    let _e68 = e[0u];
    let _e69 = (*c);
    let _e72 = e[1u];
    let _e73 = (*s);
    let _e77 = e[0u];
    let _e79 = (*s);
    let _e82 = e[1u];
    let _e83 = (*c);
    let _e87 = pivot;
    o = (vec2<f32>(((_e68 * _e69) + (_e72 * _e73)), ((-(_e77) * _e79) + (_e82 * _e83))) + _e87);
    let _e90 = (*dir)[0u];
    let _e91 = (*c);
    let _e94 = (*dir)[2u];
    let _e95 = (*s);
    let _e99 = (*dir)[0u];
    let _e101 = (*s);
    let _e104 = (*dir)[2u];
    let _e105 = (*c);
    d = vec2<f32>(((_e90 * _e91) + (_e94 * _e95)), ((-(_e99) * _e101) + (_e104 * _e105)));
    let _e110 = d[0u];
    if (_e110 < 0f) {
        let _e113 = d[0u];
        local = min(_e113, -0.000001f);
    } else {
        let _e116 = d[0u];
        local = max(_e116, 0.000001f);
    }
    let _e118 = local;
    let _e120 = d[1u];
    if (_e120 < 0f) {
        let _e123 = d[1u];
        local_1 = min(_e123, -0.000001f);
    } else {
        let _e126 = d[1u];
        local_1 = max(_e126, 0.000001f);
    }
    let _e128 = local_1;
    inv = (vec2(1f) / vec2<f32>(_e118, _e128));
    let _e132 = o;
    let _e134 = inv;
    t0_ = ((vec2<f32>(0f, 0f) - _e132) * _e134);
    let _e136 = (*w);
    let _e138 = o;
    let _e140 = inv;
    t1_ = ((vec2(_e136) - _e138) * _e140);
    let _e142 = t0_;
    let _e143 = t1_;
    tn = min(_e142, _e143);
    let _e145 = t0_;
    let _e146 = t1_;
    tf = max(_e145, _e146);
    let _e149 = tn[0u];
    let _e151 = tn[1u];
    tin = max(_e149, _e151);
    let _e153 = tin;
    let _e154 = (_e153 <= 0f);
    phi_197_ = _e154;
    if !(_e154) {
        let _e156 = tin;
        let _e158 = tf[0u];
        let _e160 = tf[1u];
        phi_197_ = (_e156 > min(_e158, _e160));
    }
    let _e164 = phi_197_;
    if _e164 {
        return vec4<f32>(-1f, -1f, -1f, -1f);
    }
    let _e165 = o;
    let _e166 = tin;
    let _e167 = d;
    hit = (_e165 + (_e167 * _e166));
    let _e171 = (*eye)[1u];
    let _e172 = tin;
    let _e174 = (*dir)[1u];
    y = (_e171 + (_e172 * _e174));
    let _e177 = y;
    let _e179 = y;
    if ((_e177 < 0f) || (_e179 > 1f)) {
        return vec4<f32>(-1f, -1f, -1f, -1f);
    }
    let _e183 = tn[1u];
    let _e185 = tn[0u];
    if (_e183 >= _e185) {
        let _e188 = d[1u];
        if (_e188 <= 0f) {
            return vec4<f32>(-1f, -1f, -1f, -1f);
        }
        let _e190 = tin;
        let _e192 = hit[0u];
        let _e193 = (*w);
        let _e195 = y;
        return vec4<f32>(_e190, (_e192 / _e193), _e195, 0f);
    }
    let _e198 = d[0u];
    if (_e198 <= 0f) {
        return vec4<f32>(-1f, -1f, -1f, -1f);
    }
    let _e200 = tin;
    let _e202 = hit[1u];
    let _e203 = (*w);
    let _e206 = y;
    return vec4<f32>(_e200, (1f - (_e202 / _e203)), _e206, 1f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var w_1: f32;
    var turn: f32;
    var a: f32;
    var c_1: f32;
    var s_1: f32;
    var motion: f32;
    var zoom: f32;
    var dist: f32;
    var eye_1: vec3<f32>;
    var sp: vec2<f32>;
    var dir_1: vec3<f32>;
    var px: f32;
    var shade0_: f32;
    var shade1_: f32;
    var front: vec4<f32>;
    var b: vec4<f32>;
    var param: vec3<f32>;
    var param_1: vec3<f32>;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var img: vec4<f32>;
    var local_2: vec4<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var m: f32;
    var e_1: f32;
    var n: vec3<f32>;
    var local_3: vec3<f32>;
    var fore: f32;
    var edge: f32;
    var local_4: f32;
    var ground: vec4<f32>;
    var h: f32;
    var tf_1: f32;
    var f: vec3<f32>;
    var meye: vec3<f32>;
    var mdir: vec3<f32>;
    var r: vec4<f32>;
    var param_7: vec3<f32>;
    var param_8: vec3<f32>;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var img_1: vec4<f32>;
    var local_5: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var k: f32;
    var q: vec2<f32>;
    var l: vec2<f32>;
    var soft: f32;
    var sh: f32;
    var bl: vec2<f32>;
    var local_6: f32;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var color: vec4<f32>;
    var local_7: vec4<f32>;
    var phi_493_: bool;

    let _e102 = uniforms.ratio;
    w_1 = _e102;
    let _e104 = uniforms.progress;
    let _e106 = uniforms.progress;
    let _e109 = uniforms.progress;
    turn = ((_e104 * _e106) * (3f - (2f * _e109)));
    let _e113 = turn;
    a = (1.5707964f * _e113);
    let _e115 = a;
    c_1 = cos(_e115);
    let _e117 = a;
    s_1 = sin(_e117);
    let _e120 = uniforms.progress;
    if (_e120 >= 1f) {
        c_1 = 0f;
        s_1 = 1f;
    }
    let _e123 = uniforms.progress;
    motion = sin((3.1415927f * clamp(_e123, 0f, 1f)));
    let _e128 = uniforms.unzoom;
    let _e130 = motion;
    zoom = (1f + (max(_e128, 0f) * _e130));
    let _e133 = w_1;
    let _e137 = uniforms.persp;
    dist = ((0.8f * max(_e133, 1f)) / clamp(_e137, 0.01f, 1f));
    let _e140 = w_1;
    let _e142 = dist;
    eye_1 = vec3<f32>((0.5f * _e140), 0.5f, -(_e142));
    let _e145 = (*uv_2);
    let _e148 = zoom;
    sp = (((_e145 - vec2(0.5f)) * _e148) + vec2(0.5f));
    let _e153 = sp[0u];
    let _e154 = w_1;
    let _e157 = sp[1u];
    let _e159 = eye_1;
    dir_1 = (vec3<f32>((_e153 * _e154), _e157, 0f) - _e159);
    let _e161 = zoom;
    let _e163 = motion;
    px = ((0.002f * _e161) * min((10f * _e163), 1f));
    let _e168 = uniforms.shading;
    let _e169 = c_1;
    shade0_ = (1f - (_e168 * (1f - _e169)));
    let _e174 = uniforms.shading;
    let _e175 = s_1;
    shade1_ = (1f - (_e174 * (1f - _e175)));
    front = vec4<f32>(0f, 0f, 0f, 0f);
    let _e179 = eye_1;
    param = _e179;
    let _e180 = dir_1;
    param_1 = _e180;
    let _e181 = w_1;
    param_2 = _e181;
    let _e182 = c_1;
    param_3 = _e182;
    let _e183 = s_1;
    param_4 = _e183;
    let _e184 = hitBox((&param), (&param_1), (&param_2), (&param_3), (&param_4));
    b = _e184;
    let _e186 = b[0u];
    if (_e186 > 0f) {
        let _e189 = b[3u];
        if (_e189 < 0.5f) {
            let _e192 = b[1u];
            let _e194 = b[2u];
            param_5 = vec2<f32>(_e192, _e194);
            let _e196 = getFromColor((&param_5));
            local_2 = _e196;
        } else {
            let _e198 = b[1u];
            let _e200 = b[2u];
            param_6 = vec2<f32>(_e198, _e200);
            let _e202 = getToColor((&param_6));
            local_2 = _e202;
        }
        let _e203 = local_2;
        img = _e203;
        m = 1f;
        let _e204 = px;
        if (_e204 > 0f) {
            let _e206 = px;
            let _e208 = b[0u];
            e_1 = (_e206 * _e208);
            let _e211 = b[3u];
            if (_e211 < 0.5f) {
                let _e213 = s_1;
                let _e214 = c_1;
                local_3 = vec3<f32>(_e213, 0f, -(_e214));
            } else {
                let _e217 = c_1;
                let _e219 = s_1;
                local_3 = vec3<f32>(-(_e217), 0f, -(_e219));
            }
            let _e222 = local_3;
            n = _e222;
            let _e223 = n;
            let _e224 = dir_1;
            fore = max(abs(dot(_e223, normalize(_e224))), 0.05f);
            let _e230 = b[3u];
            if (_e230 < 0.5f) {
                let _e233 = b[1u];
                local_4 = (1f - _e233);
            } else {
                let _e236 = b[1u];
                local_4 = _e236;
            }
            let _e237 = local_4;
            edge = _e237;
            let _e239 = b[2u];
            let _e241 = b[2u];
            let _e244 = e_1;
            let _e247 = edge;
            let _e248 = w_1;
            let _e250 = fore;
            let _e252 = e_1;
            m = (clamp((min(_e239, (1f - _e241)) / _e244), 0f, 1f) * clamp((((_e247 * _e248) * _e250) / _e252), 0f, 1f));
        }
        let _e256 = m;
        let _e257 = (_e256 >= 1f);
        phi_493_ = _e257;
        if _e257 {
            let _e259 = img[3u];
            phi_493_ = (_e259 >= 1f);
        }
        let _e262 = phi_493_;
        if _e262 {
            let _e263 = img;
            let _e266 = b[3u];
            let _e268 = shade0_;
            let _e269 = shade1_;
            let _e271 = (_e263.xyz * select(_e269, _e268, (_e266 < 0.5f)));
            let _e273 = img[3u];
            return vec4<f32>(_e271.x, _e271.y, _e271.z, _e273);
        }
        let _e278 = img;
        let _e281 = b[3u];
        let _e283 = shade0_;
        let _e284 = shade1_;
        let _e288 = img[3u];
        let _e289 = ((_e278.xyz * select(_e284, _e283, (_e281 < 0.5f))) * _e288);
        let _e291 = img[3u];
        let _e296 = m;
        front = (vec4<f32>(_e289.x, _e289.y, _e289.z, _e291) * _e296);
    }
    ground = vec4<f32>(0f, 0f, 0f, 0f);
    let _e299 = uniforms.floating;
    h = (0.005f * max(_e299, 0f));
    let _e303 = dir_1[1u];
    let _e305 = motion;
    if ((_e303 < 0f) && (_e305 > 0f)) {
        let _e309 = eye_1[1u];
        let _e310 = h;
        let _e314 = dir_1[1u];
        tf_1 = (-((_e309 + _e310)) / _e314);
        let _e316 = eye_1;
        let _e317 = tf_1;
        let _e318 = dir_1;
        f = (_e316 + (_e318 * _e317));
        let _e322 = eye_1[0u];
        let _e323 = h;
        let _e326 = eye_1[1u];
        let _e329 = eye_1[2u];
        meye = vec3<f32>(_e322, ((-2f * _e323) - _e326), _e329);
        let _e332 = dir_1[0u];
        let _e334 = dir_1[1u];
        let _e337 = dir_1[2u];
        mdir = vec3<f32>(_e332, -(_e334), _e337);
        let _e339 = meye;
        param_7 = _e339;
        let _e340 = mdir;
        param_8 = _e340;
        let _e341 = w_1;
        param_9 = _e341;
        let _e342 = c_1;
        param_10 = _e342;
        let _e343 = s_1;
        param_11 = _e343;
        let _e344 = hitBox((&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
        r = _e344;
        let _e346 = r[0u];
        if (_e346 > 0f) {
            let _e349 = r[3u];
            if (_e349 < 0.5f) {
                let _e352 = r[1u];
                let _e354 = r[2u];
                param_12 = vec2<f32>(_e352, _e354);
                let _e356 = getFromColor((&param_12));
                local_5 = _e356;
            } else {
                let _e358 = r[1u];
                let _e360 = r[2u];
                param_13 = vec2<f32>(_e358, _e360);
                let _e362 = getToColor((&param_13));
                local_5 = _e362;
            }
            let _e363 = local_5;
            img_1 = _e363;
            let _e365 = uniforms.reflection;
            let _e368 = r[2u];
            let _e372 = r[2u];
            k = ((clamp(_e365, 0f, 1f) * (1f - _e368)) * (1f - _e372));
            let _e375 = img_1;
            let _e378 = r[3u];
            let _e380 = shade0_;
            let _e381 = shade1_;
            let _e385 = img_1[3u];
            let _e386 = ((_e375.xyz * select(_e381, _e380, (_e378 < 0.5f))) * _e385);
            let _e388 = img_1[3u];
            let _e393 = k;
            ground = (vec4<f32>(_e386.x, _e386.y, _e386.z, _e388) * _e393);
        }
        let _e395 = f;
        let _e397 = w_1;
        q = (_e395.xz - vec2((0.5f * _e397)));
        let _e402 = q[0u];
        let _e403 = c_1;
        let _e406 = q[1u];
        let _e407 = s_1;
        let _e411 = q[0u];
        let _e413 = s_1;
        let _e416 = q[1u];
        let _e417 = c_1;
        l = vec2<f32>(((_e402 * _e403) + (_e406 * _e407)), ((-(_e411) * _e413) + (_e416 * _e417)));
        let _e421 = h;
        soft = (0.03f + (1.5f * _e421));
        let _e425 = uniforms.shading;
        let _e427 = l;
        let _e429 = w_1;
        let _e437 = soft;
        sh = ((_e425 * 0.7f) * exp((-(length(max((abs(_e427) - vec2((0.5f * _e429))), vec2(0f)))) / _e437)));
        let _e441 = l;
        let _e442 = w_1;
        bl = (_e441 + vec2((0.5f * _e442)));
        let _e447 = l[1u];
        let _e449 = l[0u];
        if (_e447 < _e449) {
            let _e452 = bl[0u];
            let _e453 = w_1;
            param_14 = vec2<f32>(clamp((_e452 / _e453), 0f, 1f), 0f);
            let _e457 = getFromColor((&param_14));
            local_6 = _e457.w;
        } else {
            let _e460 = bl[1u];
            let _e461 = w_1;
            param_15 = vec2<f32>(clamp((1f - (_e460 / _e461)), 0f, 1f), 0f);
            let _e466 = getToColor((&param_15));
            local_6 = _e466.w;
        }
        let _e468 = local_6;
        let _e469 = sh;
        sh = (_e469 * _e468);
        let _e471 = ground;
        let _e472 = sh;
        let _e475 = sh;
        ground = ((_e471 * (1f - _e472)) + vec4<f32>(0f, 0f, 0f, _e475));
        let _e478 = motion;
        let _e481 = ground;
        ground = (_e481 * min((6f * _e478), 1f));
    }
    let _e483 = front;
    let _e484 = ground;
    let _e486 = front[3u];
    color = (_e483 + (_e484 * (1f - _e486)));
    let _e491 = color[3u];
    if (_e491 > 0f) {
        let _e493 = color;
        let _e496 = color[3u];
        let _e498 = (_e493.xyz / vec3(_e496));
        let _e500 = color[3u];
        local_7 = vec4<f32>(_e498.x, _e498.y, _e498.z, _e500);
    } else {
        local_7 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e505 = local_7;
    return _e505;
}

fn main_1() {
    var param_16: vec2<f32>;

    let _e42 = _uv_1;
    param_16 = _e42;
    let _e43 = transition((&param_16));
    _fragColor = _e43;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
