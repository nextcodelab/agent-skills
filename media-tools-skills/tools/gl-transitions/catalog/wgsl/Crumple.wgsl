// Crumple — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Crumple.glsl
// Author: gre
// License: MIT
// Description: The outgoing image crumples into a creased paper ball, shaded along its folds, which is then tossed away to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    creases: i32,
    size: f32,
    direction: vec2<f32>,
    paper: vec4<f32>,
    shadow: vec4<f32>,
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

fn hash2(p: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e83 = (*p);
    let _e85 = (*p);
    (*p) = vec2<f32>(dot(_e83, vec2<f32>(127.1f, 311.7f)), dot(_e85, vec2<f32>(269.5f, 183.3f)));
    let _e88 = (*p);
    return fract((sin(_e88) * 43758.547f));
}

fn fold(x: ptr<function, vec2<f32>>, seed: ptr<function, f32>, n: ptr<function, i32>, span: ptr<function, vec2<f32>>, len: ptr<function, f32>, c: ptr<function, f32>, px: ptr<function, f32>, weight: ptr<function, f32>, grad: ptr<function, vec2<f32>>, shift: ptr<function, vec2<f32>>, valley: ptr<function, f32>, ridge: ptr<function, f32>) {
    var tilt: f32;
    var i: i32;
    var fi: f32;
    var h: vec2<f32>;
    var param: vec2<f32>;
    var g: vec2<f32>;
    var param_1: vec2<f32>;
    var o: vec2<f32>;
    var nrm: vec2<f32>;
    var d: f32;
    var along: f32;
    var l: f32;
    var start: f32;
    var act: f32;
    var amp: f32;
    var side: f32;
    var line: f32;

    let _e111 = (*n);
    tilt = (2f / sqrt(f32(_e111)));
    i = 0i;
    loop {
        let _e115 = i;
        if (_e115 < 32i) {
            let _e117 = i;
            let _e118 = (*n);
            if (_e117 >= _e118) {
                break;
            }
            let _e120 = i;
            fi = f32(_e120);
            let _e122 = fi;
            let _e123 = (*seed);
            param = vec2<f32>(_e122, _e123);
            let _e125 = hash2((&param));
            h = _e125;
            let _e126 = fi;
            let _e127 = (*seed);
            param_1 = vec2<f32>(_e126, (_e127 + 11.8f));
            let _e130 = hash2((&param_1));
            g = _e130;
            let _e131 = h;
            let _e135 = (*span);
            o = (((_e131 - vec2(0.5f)) * 2f) * _e135);
            let _e138 = g[0u];
            let _e142 = g[0u];
            nrm = vec2<f32>(cos((6.2831855f * _e138)), sin((6.2831855f * _e142)));
            let _e146 = (*x);
            let _e147 = o;
            let _e149 = nrm;
            d = dot((_e146 - _e147), _e149);
            let _e151 = (*x);
            let _e152 = o;
            let _e155 = nrm[1u];
            let _e158 = nrm[0u];
            along = dot((_e151 - _e152), vec2<f32>(-(_e155), _e158));
            let _e161 = (*len);
            let _e163 = g[1u];
            l = (_e161 * (0.5f + _e163));
            let _e166 = fi;
            let _e168 = (*n);
            start = ((0.4f * _e166) / f32(_e168));
            let _e171 = (*weight);
            let _e172 = start;
            let _e173 = start;
            let _e175 = (*c);
            let _e178 = l;
            let _e180 = l;
            let _e181 = along;
            act = ((_e171 * smoothstep(_e172, (_e173 + 0.3f), _e175)) * (1f - smoothstep((0.5f * _e178), _e180, abs(_e181))));
            let _e187 = h[0u];
            let _e191 = h[1u];
            amp = (select(-1f, 1f, (_e187 > 0.5f)) * (0.5f + (0.5f * _e191)));
            let _e195 = d;
            let _e196 = d;
            let _e198 = (*px);
            side = (_e195 / (abs(_e196) + _e198));
            let _e201 = act;
            let _e202 = amp;
            let _e204 = side;
            let _e206 = nrm;
            let _e208 = tilt;
            let _e210 = (*grad);
            (*grad) = (_e210 + ((_e206 * ((_e201 * _e202) * _e204)) * _e208));
            let _e212 = act;
            let _e214 = side;
            let _e216 = nrm;
            let _e218 = (*shift);
            (*shift) = (_e218 + (_e216 * ((_e212 * 0.03f) * _e214)));
            let _e220 = (*px);
            let _e222 = d;
            line = (1f - smoothstep(0f, (2f * _e220), abs(_e222)));
            let _e226 = amp;
            if (_e226 < 0f) {
                let _e228 = act;
                let _e229 = line;
                let _e231 = (*valley);
                (*valley) = (_e231 + (_e228 * _e229));
            } else {
                let _e233 = act;
                let _e234 = line;
                let _e236 = amp;
                let _e238 = (*ridge);
                (*ridge) = (_e238 + ((_e233 * _e234) * _e236));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e240 = i;
            i = (_e240 + 1i);
        }
    }
    return;
}

fn frame(a: ptr<function, vec2<f32>>) -> f32 {
    let _e84 = uniforms.ratio;
    let _e87 = (*a)[0u];
    let _e92 = (*a)[1u];
    return min(((0.5f * _e84) / max(abs(_e87), 0.0001f)), (0.5f / max(abs(_e92), 0.0001f)));
}

fn outline(a_1: ptr<function, vec2<f32>>, c_1: ptr<function, f32>, k: ptr<function, f32>, radius: ptr<function, f32>) -> f32 {
    var rect: f32;
    var param_2: vec2<f32>;
    var th: f32;
    var buckle: f32;
    var i_1: f32;
    var a0_: f32;
    var a1_: f32;
    var v0_: vec2<f32>;
    var param_3: vec2<f32>;
    var v1_: vec2<f32>;
    var param_4: vec2<f32>;
    var e: vec2<f32>;
    var ball: f32;

    let _e99 = (*a_1);
    param_2 = _e99;
    let _e100 = frame((&param_2));
    rect = _e100;
    let _e102 = (*a_1)[1u];
    let _e104 = (*a_1)[0u];
    th = atan2(_e102, _e104);
    let _e106 = th;
    let _e113 = th;
    let _e120 = th;
    buckle = (((0.03f + (0.05f * abs(sin(((4f * _e106) + 0.7f))))) + (0.03f * abs(sin(((9f * _e113) + 2f))))) + (0.015f * abs(sin(((23f * _e120) + 1.3f)))));
    let _e127 = th;
    i_1 = floor((((_e127 / 6.2831855f) + 0.5f) * 9f));
    let _e132 = i_1;
    a0_ = ((((_e132 * 2f) * 3.1415927f) / 9f) - 3.1415927f);
    let _e137 = a0_;
    a1_ = (_e137 + 0.6981317f);
    let _e139 = a0_;
    let _e141 = a0_;
    let _e144 = i_1;
    param_3 = vec2<f32>((_e144 - (floor((_e144 / 9f)) * 9f)), 3f);
    let _e150 = hash2((&param_3));
    v0_ = (vec2<f32>(cos(_e139), sin(_e141)) * (0.78f + (0.27f * _e150.x)));
    let _e155 = a1_;
    let _e157 = a1_;
    let _e160 = i_1;
    let _e161 = (_e160 + 1f);
    param_4 = vec2<f32>((_e161 - (floor((_e161 / 9f)) * 9f)), 3f);
    let _e167 = hash2((&param_4));
    v1_ = (vec2<f32>(cos(_e155), sin(_e157)) * (0.78f + (0.27f * _e167.x)));
    let _e172 = v1_;
    let _e173 = v0_;
    e = (_e172 - _e173);
    let _e175 = (*radius);
    let _e177 = v0_[0u];
    let _e179 = e[1u];
    let _e182 = v0_[1u];
    let _e184 = e[0u];
    let _e189 = (*a_1)[0u];
    let _e191 = e[1u];
    let _e194 = (*a_1)[1u];
    let _e196 = e[0u];
    ball = ((_e175 * ((_e177 * _e179) - (_e182 * _e184))) / ((_e189 * _e191) - (_e194 * _e196)));
    let _e200 = rect;
    let _e201 = (*c_1);
    let _e204 = (*c_1);
    let _e205 = buckle;
    let _e209 = ball;
    let _e210 = (*k);
    return mix(((_e200 * mix(1f, 0.75f, _e201)) * (1f - (_e204 * _e205))), _e209, _e210);
}

fn rot(a_2: ptr<function, f32>) -> mat2x2<f32> {
    var s: f32;
    var c_2: f32;

    let _e85 = (*a_2);
    s = sin(_e85);
    let _e87 = (*a_2);
    c_2 = cos(_e87);
    let _e89 = c_2;
    let _e90 = s;
    let _e92 = s;
    let _e93 = c_2;
    return mat2x2<f32>(vec2<f32>(_e89, -(_e90)), vec2<f32>(_e92, _e93));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e84 = (*uv)[0u];
    let _e86 = (*uv)[1u];
    let _e89 = textureSampleLevel(_to, _sampler, vec2<f32>(_e84, (1f - _e86)), 0f);
    return _e89;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e84 = (*uv_1)[0u];
    let _e86 = (*uv_1)[1u];
    let _e89 = textureSampleLevel(_from, _sampler, vec2<f32>(_e84, (1f - _e86)), 0f);
    return _e89;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_5: vec2<f32>;
    var b: vec4<f32>;
    var param_6: vec2<f32>;
    var c_3: f32;
    var k_1: f32;
    var t: f32;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var radius_1: f32;
    var reach: f32;
    var bend: f32;
    var center: vec2<f32>;
    var angle: f32;
    var lift: f32;
    var p_1: vec2<f32>;
    var sp: vec2<f32>;
    var param_7: f32;
    var sl: f32;
    var sd: f32;
    var local_1: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var blur: f32;
    var col: vec4<f32>;
    var q: vec2<f32>;
    var param_12: f32;
    var l_1: f32;
    var dq: vec2<f32>;
    var local_2: vec2<f32>;
    var edge: f32;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var aa: f32;
    var inside: f32;
    var r: f32;
    var rect_1: f32;
    var param_17: vec2<f32>;
    var s_1: vec2<f32>;
    var count: i32;
    var local_3: i32;
    var grad_1: vec2<f32>;
    var shift_1: vec2<f32>;
    var valley_1: f32;
    var ridge_1: f32;
    var param_18: vec2<f32>;
    var param_19: f32;
    var param_20: i32;
    var param_21: vec2<f32>;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var param_25: f32;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;
    var param_28: f32;
    var param_29: f32;
    var g2_: vec2<f32>;
    var s2_: vec2<f32>;
    var v2_: f32;
    var r2_: f32;
    var param_30: vec2<f32>;
    var param_31: f32;
    var param_32: i32;
    var param_33: vec2<f32>;
    var param_34: f32;
    var param_35: f32;
    var param_36: f32;
    var param_37: f32;
    var param_38: vec2<f32>;
    var param_39: vec2<f32>;
    var param_40: f32;
    var param_41: f32;
    var piece: vec2<f32>;
    var rr: f32;
    var sphere: vec3<f32>;
    var n_1: vec3<f32>;
    var param_42: f32;
    var light: vec3<f32>;
    var diffuse: f32;
    var hv: vec3<f32>;
    var spec: f32;
    var level: f32;
    var relief: f32;
    var shade: f32;
    var f: vec2<f32>;
    var img: vec4<f32>;
    var param_43: vec2<f32>;
    var ball_1: vec4<f32>;
    var m: f32;
    var o_1: vec4<f32>;
    var local_4: vec4<f32>;

    let _e179 = uniforms.progress;
    if (_e179 <= 0f) {
        let _e181 = (*uv_2);
        param_5 = _e181;
        let _e182 = getFromColor((&param_5));
        return _e182;
    }
    let _e183 = (*uv_2);
    param_6 = _e183;
    let _e184 = getToColor((&param_6));
    b = _e184;
    let _e186 = uniforms.progress;
    if (_e186 >= 1f) {
        let _e188 = b;
        return _e188;
    }
    let _e190 = uniforms.progress;
    c_3 = smoothstep(0f, 0.6f, _e190);
    let _e193 = uniforms.progress;
    k_1 = smoothstep(0.1f, 0.62f, _e193);
    let _e196 = uniforms.progress;
    t = smoothstep(0.58f, 1f, _e196);
    let _e198 = t;
    let _e199 = t;
    t = (_e199 * _e198);
    let _e202 = uniforms.direction;
    if (length(_e202) > 0f) {
        let _e206 = uniforms.direction;
        local = normalize(_e206);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e208 = local;
    dir = _e208;
    let _e210 = uniforms.size;
    let _e212 = t;
    radius_1 = (max(_e210, 0.01f) * mix(1f, 0.6f, _e212));
    let _e216 = dir[0u];
    let _e219 = uniforms.ratio;
    let _e222 = dir[1u];
    let _e226 = radius_1;
    reach = (((0.5f * ((abs(_e216) * _e219) + abs(_e222))) + (1.2f * _e226)) + 0.3f);
    let _e231 = dir[0u];
    bend = select(1f, -1f, (_e231 < 0f));
    let _e234 = dir;
    let _e235 = reach;
    let _e237 = t;
    let _e240 = dir[1u];
    let _e243 = dir[0u];
    let _e246 = bend;
    let _e248 = t;
    center = (((_e234 * _e235) * _e237) + (((vec2<f32>(-(_e240), _e243) * 0.15f) * _e246) * sin((3.1415927f * _e248))));
    let _e253 = c_3;
    let _e255 = bend;
    let _e257 = t;
    angle = ((0.6f * _e253) - ((5f * _e255) * _e257));
    let _e260 = c_3;
    let _e262 = t;
    lift = ((0.012f * _e260) + (0.06f * _e262));
    let _e265 = (*uv_2);
    let _e269 = uniforms.ratio;
    p_1 = ((_e265 - vec2(0.5f)) * vec2<f32>(_e269, 1f));
    let _e272 = angle;
    param_7 = _e272;
    let _e273 = rot((&param_7));
    let _e274 = p_1;
    let _e275 = center;
    let _e277 = lift;
    sp = (_e273 * ((_e274 - _e275) - (vec2<f32>(0.6f, -1f) * _e277)));
    let _e281 = sp;
    sl = length(_e281);
    let _e283 = sl;
    let _e284 = sl;
    if (_e284 > 0.00001f) {
        let _e286 = sp;
        let _e287 = sl;
        local_1 = (_e286 / vec2(_e287));
    } else {
        local_1 = vec2<f32>(1f, 0f);
    }
    let _e290 = local_1;
    param_8 = _e290;
    let _e291 = c_3;
    param_9 = _e291;
    let _e292 = k_1;
    param_10 = _e292;
    let _e293 = radius_1;
    param_11 = _e293;
    let _e294 = outline((&param_8), (&param_9), (&param_10), (&param_11));
    sd = (_e283 - _e294);
    let _e296 = lift;
    blur = (0.005f + (1.2f * _e296));
    let _e299 = b;
    let _e302 = uniforms.shadow;
    let _e306 = uniforms.shadow[3u];
    let _e307 = c_3;
    let _e309 = blur;
    let _e311 = blur;
    let _e312 = sd;
    let _e317 = mix(_e299.xyz, _e302.xyz, vec3(((_e306 * _e307) * (1f - smoothstep(-(_e309), _e311, _e312)))));
    let _e319 = b[3u];
    col = vec4<f32>(_e317.x, _e317.y, _e317.z, _e319);
    let _e324 = angle;
    param_12 = _e324;
    let _e325 = rot((&param_12));
    let _e326 = p_1;
    let _e327 = center;
    q = (_e325 * (_e326 - _e327));
    let _e330 = q;
    l_1 = length(_e330);
    let _e332 = l_1;
    if (_e332 > 0.00001f) {
        let _e334 = q;
        let _e335 = l_1;
        local_2 = (_e334 / vec2(_e335));
    } else {
        local_2 = vec2<f32>(1f, 0f);
    }
    let _e338 = local_2;
    dq = _e338;
    let _e339 = dq;
    param_13 = _e339;
    let _e340 = c_3;
    param_14 = _e340;
    let _e341 = k_1;
    param_15 = _e341;
    let _e342 = radius_1;
    param_16 = _e342;
    let _e343 = outline((&param_13), (&param_14), (&param_15), (&param_16));
    edge = _e343;
    let _e345 = uniforms.progress;
    aa = ((0.003f * smoothstep(0f, 0.1f, _e345)) + 0.00001f);
    let _e349 = aa;
    let _e351 = aa;
    let _e352 = l_1;
    let _e353 = edge;
    inside = (1f - smoothstep(-(_e349), _e351, (_e352 - _e353)));
    let _e357 = inside;
    if (_e357 <= 0f) {
        let _e359 = col;
        return _e359;
    }
    let _e360 = l_1;
    let _e361 = edge;
    r = (_e360 / _e361);
    let _e363 = dq;
    param_17 = _e363;
    let _e364 = frame((&param_17));
    rect_1 = _e364;
    let _e365 = dq;
    let _e366 = rect_1;
    let _e368 = r;
    let _e369 = r;
    let _e370 = r;
    let _e374 = k_1;
    s_1 = ((_e365 * _e366) * mix(_e368, (_e369 * (0.6f + (0.4f * _e370))), _e374));
    let _e378 = uniforms.creases;
    if (_e378 < 1i) {
        local_3 = 1i;
    } else {
        let _e381 = uniforms.creases;
        local_3 = _e381;
    }
    let _e382 = local_3;
    count = _e382;
    grad_1 = vec2<f32>(0f, 0f);
    shift_1 = vec2<f32>(0f, 0f);
    valley_1 = 0f;
    ridge_1 = 0f;
    let _e384 = uniforms.ratio;
    let _e387 = rect_1;
    let _e389 = edge;
    let _e391 = k_1;
    let _e394 = s_1;
    param_18 = _e394;
    param_19 = 7.3f;
    let _e395 = count;
    param_20 = _e395;
    param_21 = (vec2<f32>(_e384, 1f) * 0.45f);
    param_22 = 0.6f;
    let _e396 = c_3;
    param_23 = _e396;
    param_24 = ((0.003f * _e387) / _e389);
    param_25 = (1f - (0.8f * _e391));
    let _e397 = grad_1;
    param_26 = _e397;
    let _e398 = shift_1;
    param_27 = _e398;
    let _e399 = valley_1;
    param_28 = _e399;
    let _e400 = ridge_1;
    param_29 = _e400;
    fold((&param_18), (&param_19), (&param_20), (&param_21), (&param_22), (&param_23), (&param_24), (&param_25), (&param_26), (&param_27), (&param_28), (&param_29));
    let _e401 = param_26;
    grad_1 = _e401;
    let _e402 = param_27;
    shift_1 = _e402;
    let _e403 = param_28;
    valley_1 = _e403;
    let _e404 = param_29;
    ridge_1 = _e404;
    g2_ = vec2<f32>(0f, 0f);
    s2_ = vec2<f32>(0f, 0f);
    v2_ = 0f;
    r2_ = 0f;
    let _e405 = q;
    let _e406 = radius_1;
    let _e409 = radius_1;
    param_30 = (_e405 / vec2(_e406));
    param_31 = 2.9f;
    let _e411 = count;
    param_32 = _e411;
    param_33 = vec2<f32>(0.7f, 0.7f);
    param_34 = 8f;
    let _e412 = k_1;
    param_35 = _e412;
    param_36 = (0.003f / _e409);
    let _e413 = k_1;
    param_37 = _e413;
    let _e414 = g2_;
    param_38 = _e414;
    let _e415 = s2_;
    param_39 = _e415;
    let _e416 = v2_;
    param_40 = _e416;
    let _e417 = r2_;
    param_41 = _e417;
    fold((&param_30), (&param_31), (&param_32), (&param_33), (&param_34), (&param_35), (&param_36), (&param_37), (&param_38), (&param_39), (&param_40), (&param_41));
    let _e418 = param_38;
    g2_ = _e418;
    let _e419 = param_39;
    s2_ = _e419;
    let _e420 = param_40;
    v2_ = _e420;
    let _e421 = param_41;
    r2_ = _e421;
    let _e422 = g2_;
    let _e424 = grad_1;
    grad_1 = (_e424 + (_e422 * 0.8f));
    let _e426 = s_1;
    let _e427 = shift_1;
    let _e429 = s2_;
    piece = ((_e426 + _e427) + (_e429 * 3f));
    let _e432 = l_1;
    let _e433 = radius_1;
    rr = clamp((_e432 / (_e433 * 1.1f)), 0f, 1f);
    let _e437 = q;
    let _e438 = radius_1;
    let _e442 = k_1;
    let _e444 = (((_e437 / vec2((_e438 * 1.1f))) * _e442) * 0.8f);
    let _e445 = rr;
    let _e447 = rr;
    let _e449 = k_1;
    sphere = vec3<f32>(_e444.x, _e444.y, sqrt((1f - (((0.64f * _e445) * _e447) * _e449))));
    let _e456 = sphere;
    let _e457 = grad_1;
    n_1 = normalize((_e456 + vec3<f32>(_e457.x, _e457.y, 0f)));
    let _e463 = angle;
    param_42 = -(_e463);
    let _e465 = rot((&param_42));
    let _e466 = n_1;
    let _e468 = (_e465 * _e466.xy);
    n_1[0u] = _e468.x;
    n_1[1u] = _e468.y;
    light = vec3<f32>(-0.4472136f, 0.5366563f, 0.7155418f);
    let _e473 = n_1;
    let _e474 = light;
    diffuse = max(dot(_e473, _e474), 0f);
    let _e477 = light;
    hv = normalize((_e477 + vec3<f32>(0f, 0f, 1f)));
    let _e480 = n_1;
    let _e481 = hv;
    let _e486 = hv[2u];
    spec = max((pow(max(dot(_e480, _e481), 0f), 20f) - pow(_e486, 20f)), 0f);
    let _e491 = light[2u];
    level = _e491;
    let _e492 = c_3;
    relief = min((2f * _e492), 1f);
    let _e495 = relief;
    let _e496 = diffuse;
    let _e498 = level;
    let _e504 = spec;
    let _e506 = relief;
    shade = ((1f + (_e495 * (((0.12f + _e496) / (0.12f + _e498)) - 1f))) + ((0.7f * _e504) * _e506));
    let _e509 = relief;
    let _e511 = valley_1;
    let _e514 = shade;
    shade = (_e514 - ((0.2f * _e509) * min(_e511, 1f)));
    let _e516 = k_1;
    let _e518 = r;
    let _e522 = shade;
    shade = (_e522 * (1f - ((0.3f * _e516) * smoothstep(0.6f, 1f, _e518))));
    let _e524 = piece;
    let _e526 = uniforms.ratio;
    f = ((_e524 / vec2<f32>(_e526, 1f)) + vec2(0.5f));
    let _e531 = f;
    let _e532 = vec2(2f);
    param_43 = (vec2(1f) - abs((vec2(1f) - (_e531 - (floor((_e531 / _e532)) * _e532)))));
    let _e542 = getFromColor((&param_43));
    img = _e542;
    let _e543 = img;
    let _e546 = uniforms.paper;
    let _e548 = ridge_1;
    let _e553 = uniforms.paper[3u];
    let _e555 = c_3;
    let _e558 = mix(_e543.xyz, _e546.xyz, vec3((((0.6f * min(_e548, 1f)) * _e553) * _e555)));
    img[0u] = _e558.x;
    img[1u] = _e558.y;
    img[2u] = _e558.z;
    let _e565 = img;
    let _e567 = shade;
    let _e568 = (_e565.xyz * _e567);
    let _e570 = img[3u];
    ball_1 = vec4<f32>(_e568.x, _e568.y, _e568.z, _e570);
    let _e575 = inside;
    let _e577 = ball_1[3u];
    m = (_e575 * _e577);
    let _e579 = col;
    let _e582 = col[3u];
    let _e584 = ball_1;
    let _e586 = m;
    let _e588 = mix((_e579.xyz * _e582), _e584.xyz, vec3(_e586));
    let _e590 = col[3u];
    let _e591 = m;
    o_1 = vec4<f32>(_e588.x, _e588.y, _e588.z, mix(_e590, 1f, _e591));
    let _e598 = o_1[3u];
    if (_e598 > 0f) {
        let _e600 = o_1;
        let _e603 = o_1[3u];
        let _e605 = (_e600.xyz / vec3(_e603));
        let _e607 = o_1[3u];
        local_4 = vec4<f32>(_e605.x, _e605.y, _e605.z, _e607);
    } else {
        local_4 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e612 = local_4;
    return _e612;
}

fn main_1() {
    var param_44: vec2<f32>;

    let _e83 = _uv_1;
    param_44 = _e83;
    let _e84 = transition((&param_44));
    _fragColor = _e84;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
