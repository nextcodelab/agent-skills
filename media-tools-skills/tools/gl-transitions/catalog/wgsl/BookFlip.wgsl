// BookFlip — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BookFlip.glsl
// Author: hong
// License: MIT
// Description: The right half of the outgoing image is a book page that turns over from right to left on the spine at the middle of the frame, curling near its free edge, its back bringing the left half of the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    perspective: f32,
    shading: f32,
    curl: f32,
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
    let _e48 = (*uv)[0u];
    let _e50 = (*uv)[1u];
    let _e53 = textureSampleLevel(_to, _sampler, vec2<f32>(_e48, (1f - _e50)), 0f);
    return _e53;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e48 = (*uv_1)[0u];
    let _e50 = (*uv_1)[1u];
    let _e53 = textureSampleLevel(_from, _sampler, vec2<f32>(_e48, (1f - _e50)), 0f);
    return _e53;
}

fn cross2(a: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>) -> f32 {
    let _e49 = (*a)[0u];
    let _e51 = (*b)[1u];
    let _e54 = (*a)[1u];
    let _e56 = (*b)[0u];
    return ((_e49 * _e51) - (_e54 * _e56));
}

fn hitPage(eye: ptr<function, vec2<f32>>, dir: ptr<function, vec2<f32>>, a_1: ptr<function, f32>, k: ptr<function, f32>, straight: ptr<function, f32>, c: ptr<function, vec2<f32>>, w: ptr<function, f32>) -> vec3<f32> {
    var best: vec3<f32>;
    var d: vec2<f32>;
    var den: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var u: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var t: f32;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var r: f32;
    var oc: vec2<f32>;
    var qa: f32;
    var qb: f32;
    var disc: f32;
    var sq: f32;
    var i: i32;
    var t_1: f32;
    var local: f32;
    var v: vec2<f32>;
    var db: f32;
    var s: f32;
    var phi_255_: bool;
    var phi_256_: bool;
    var phi_297_: bool;

    best = vec3<f32>(-1f, 0f, 0f);
    let _e76 = (*a_1);
    let _e78 = (*a_1);
    d = vec2<f32>(cos(_e76), sin(_e78));
    let _e81 = d;
    param = _e81;
    let _e82 = (*dir);
    param_1 = _e82;
    let _e83 = cross2((&param), (&param_1));
    den = _e83;
    let _e84 = den;
    if (abs(_e84) > 0.0000001f) {
        let _e87 = (*eye);
        param_2 = _e87;
        let _e88 = (*dir);
        param_3 = _e88;
        let _e89 = cross2((&param_2), (&param_3));
        let _e90 = den;
        u = (_e89 / _e90);
        let _e92 = (*eye);
        param_4 = _e92;
        let _e93 = d;
        param_5 = _e93;
        let _e94 = cross2((&param_4), (&param_5));
        let _e95 = den;
        t = (_e94 / _e95);
        let _e97 = t;
        let _e99 = u;
        let _e102 = u;
        let _e103 = (*straight);
        if (((_e97 > 0f) && (_e99 >= 0f)) && (_e102 <= _e103)) {
            let _e106 = t;
            let _e107 = u;
            let _e108 = (*a_1);
            best = vec3<f32>(_e106, _e107, _e108);
        }
    }
    let _e110 = (*k);
    if (_e110 != 0f) {
        let _e112 = (*k);
        r = (1f / _e112);
        let _e114 = (*eye);
        let _e115 = (*c);
        oc = (_e114 - _e115);
        let _e117 = (*dir);
        let _e118 = (*dir);
        qa = dot(_e117, _e118);
        let _e120 = oc;
        let _e121 = (*dir);
        qb = dot(_e120, _e121);
        let _e123 = qb;
        let _e124 = qb;
        let _e126 = qa;
        let _e127 = oc;
        let _e128 = oc;
        let _e130 = r;
        let _e131 = r;
        disc = ((_e123 * _e124) - (_e126 * (dot(_e127, _e128) - (_e130 * _e131))));
        let _e136 = disc;
        if (_e136 >= 0f) {
            let _e138 = disc;
            sq = sqrt(_e138);
            i = 0i;
            loop {
                let _e140 = i;
                if (_e140 < 2i) {
                    let _e142 = qb;
                    let _e144 = i;
                    if (_e144 == 0i) {
                        let _e146 = sq;
                        local = -(_e146);
                    } else {
                        let _e148 = sq;
                        local = _e148;
                    }
                    let _e149 = local;
                    let _e151 = qa;
                    t_1 = ((-(_e142) + _e149) / _e151);
                    let _e153 = t_1;
                    let _e154 = (_e153 > 0f);
                    phi_256_ = _e154;
                    if _e154 {
                        let _e156 = best[0u];
                        let _e157 = (_e156 < 0f);
                        phi_255_ = _e157;
                        if !(_e157) {
                            let _e159 = t_1;
                            let _e161 = best[0u];
                            phi_255_ = (_e159 < _e161);
                        }
                        let _e164 = phi_255_;
                        phi_256_ = _e164;
                    }
                    let _e166 = phi_256_;
                    if _e166 {
                        let _e167 = oc;
                        let _e168 = t_1;
                        let _e169 = (*dir);
                        let _e172 = (*k);
                        v = ((_e167 + (_e169 * _e168)) * _e172);
                        let _e175 = v[0u];
                        let _e177 = v[1u];
                        let _e180 = (*a_1);
                        db = (atan2(_e175, -(_e177)) - _e180);
                        let _e182 = db;
                        let _e187 = db;
                        db = (_e187 - (6.2831855f * floor(((_e182 + 3.1415927f) / 6.2831855f))));
                        let _e189 = db;
                        let _e190 = (*k);
                        s = (_e189 / _e190);
                        let _e192 = s;
                        let _e193 = (_e192 >= 0f);
                        phi_297_ = _e193;
                        if _e193 {
                            let _e194 = s;
                            let _e195 = (*w);
                            let _e196 = (*straight);
                            phi_297_ = (_e194 <= (_e195 - _e196));
                        }
                        let _e200 = phi_297_;
                        if _e200 {
                            let _e201 = t_1;
                            let _e202 = (*straight);
                            let _e203 = s;
                            let _e205 = (*a_1);
                            let _e206 = db;
                            best = vec3<f32>(_e201, (_e202 + _e203), (_e205 + _e206));
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e209 = i;
                    i = (_e209 + 1i);
                }
            }
        }
    }
    let _e211 = best;
    return _e211;
}

fn curlPoint(c_1: ptr<function, vec2<f32>>, k_1: ptr<function, f32>, b_1: ptr<function, f32>) -> vec2<f32> {
    let _e49 = (*c_1);
    let _e50 = (*b_1);
    let _e52 = (*b_1);
    let _e56 = (*k_1);
    return (_e49 + (vec2<f32>(sin(_e50), -(cos(_e52))) / vec2(_e56)));
}

fn pageAngle_u0028_() -> f32 {
    var p: f32;

    let _e48 = uniforms.progress;
    p = clamp(_e48, 0f, 1f);
    let _e50 = p;
    let _e52 = p;
    let _e53 = p;
    return ((3.1415927f * _e50) * (0.35f + (_e52 * (1.95f - (1.3f * _e53)))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a_2: f32;
    var lift: f32;
    var w_1: f32;
    var x: f32;
    var dist: f32;
    var eye_1: vec2<f32>;
    var dir_1: vec2<f32>;
    var d_1: vec2<f32>;
    var k_2: f32;
    var straight_1: f32;
    var local_1: f32;
    var c_2: vec2<f32>;
    var bend: vec2<f32>;
    var middle: vec2<f32>;
    var local_2: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: f32;
    var param_8: f32;
    var edge: vec2<f32>;
    var local_3: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: f32;
    var param_11: f32;
    var aa: f32;
    var img: vec4<f32>;
    var m: f32;
    var hit: vec3<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: vec2<f32>;
    var param_18: f32;
    var t_2: f32;
    var u_1: f32;
    var b_2: f32;
    var pt: vec2<f32>;
    var y: f32;
    var edgeX: f32;
    var local_4: f32;
    var local_5: f32;
    var normal: vec2<f32>;
    var front: bool;
    var local_6: vec4<f32>;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var diffuse: f32;
    var local_7: vec2<f32>;
    var shade: f32;
    var color: vec4<f32>;
    var local_8: vec4<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var toEdge: vec2<f32>;
    var cosEdge: f32;
    var blocked: f32;
    var shadow: f32;
    var slope: f32;
    var reach: vec3<f32>;
    var lo: f32;
    var hi: f32;
    var soft: f32;
    var phi_551_: bool;

    let _e110 = pageAngle_u0028_();
    a_2 = _e110;
    let _e111 = a_2;
    lift = sin(_e111);
    let _e114 = uniforms.ratio;
    w_1 = (0.5f * _e114);
    let _e117 = (*uv_2)[0u];
    let _e119 = uniforms.ratio;
    let _e121 = w_1;
    x = ((_e117 * _e119) - _e121);
    let _e123 = w_1;
    let _e125 = uniforms.perspective;
    dist = (_e123 * (1f + (1.5f / max(_e125, 0.01f))));
    let _e130 = dist;
    eye_1 = vec2<f32>(0f, _e130);
    let _e132 = x;
    let _e133 = dist;
    dir_1 = vec2<f32>(_e132, -(_e133));
    let _e136 = a_2;
    let _e138 = a_2;
    d_1 = vec2<f32>(cos(_e136), sin(_e138));
    let _e142 = uniforms.curl;
    let _e145 = lift;
    let _e147 = w_1;
    k_2 = ((-(clamp(_e142, 0f, 1f)) * _e145) / (0.45f * _e147));
    let _e150 = k_2;
    let _e153 = w_1;
    if (((abs(_e150) * 0.45f) * _e153) <= 0.0001f) {
        k_2 = 0f;
    }
    let _e156 = k_2;
    if (_e156 != 0f) {
        let _e158 = w_1;
        local_1 = (0.55f * _e158);
    } else {
        let _e160 = w_1;
        local_1 = _e160;
    }
    let _e161 = local_1;
    straight_1 = _e161;
    let _e162 = straight_1;
    let _e163 = d_1;
    let _e166 = d_1[1u];
    let _e169 = d_1[0u];
    let _e171 = k_2;
    let _e173 = k_2;
    c_2 = ((_e163 * _e162) + (vec2<f32>(-(_e166), _e169) / vec2(select(1f, _e173, (_e171 != 0f)))));
    let _e178 = straight_1;
    let _e179 = d_1;
    bend = (_e179 * _e178);
    let _e181 = k_2;
    if (_e181 != 0f) {
        let _e183 = a_2;
        let _e184 = k_2;
        let _e186 = w_1;
        let _e187 = straight_1;
        let _e191 = c_2;
        param_6 = _e191;
        let _e192 = k_2;
        param_7 = _e192;
        param_8 = (_e183 + ((0.5f * _e184) * (_e186 - _e187)));
        let _e193 = curlPoint((&param_6), (&param_7), (&param_8));
        local_2 = _e193;
    } else {
        let _e194 = bend;
        local_2 = _e194;
    }
    let _e195 = local_2;
    middle = _e195;
    let _e196 = k_2;
    if (_e196 != 0f) {
        let _e198 = a_2;
        let _e199 = k_2;
        let _e200 = w_1;
        let _e201 = straight_1;
        let _e205 = c_2;
        param_9 = _e205;
        let _e206 = k_2;
        param_10 = _e206;
        param_11 = (_e198 + (_e199 * (_e200 - _e201)));
        let _e207 = curlPoint((&param_9), (&param_10), (&param_11));
        local_3 = _e207;
    } else {
        let _e208 = bend;
        local_3 = _e208;
    }
    let _e209 = local_3;
    edge = _e209;
    let _e210 = lift;
    aa = (0.0015f * min((20f * _e210), 1f));
    img = vec4<f32>(0f, 0f, 0f, 0f);
    m = 0f;
    let _e214 = eye_1;
    param_12 = _e214;
    let _e215 = dir_1;
    param_13 = _e215;
    let _e216 = a_2;
    param_14 = _e216;
    let _e217 = k_2;
    param_15 = _e217;
    let _e218 = straight_1;
    param_16 = _e218;
    let _e219 = c_2;
    param_17 = _e219;
    let _e220 = w_1;
    param_18 = _e220;
    let _e221 = hitPage((&param_12), (&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    hit = _e221;
    let _e223 = hit[0u];
    if (_e223 > 0f) {
        let _e226 = hit[0u];
        t_2 = _e226;
        let _e228 = hit[1u];
        u_1 = _e228;
        let _e230 = hit[2u];
        b_2 = _e230;
        let _e231 = eye_1;
        let _e232 = t_2;
        let _e233 = dir_1;
        pt = (_e231 + (_e233 * _e232));
        let _e237 = (*uv_2)[1u];
        let _e239 = t_2;
        y = clamp((0.5f + ((_e237 - 0.5f) * _e239)), 0f, 1f);
        let _e244 = edge[0u];
        let _e245 = dist;
        let _e247 = dist;
        let _e249 = edge[1u];
        edgeX = ((_e244 * _e245) / max((_e247 - _e249), 0.0001f));
        let _e253 = aa;
        let _e254 = (_e253 > 0f);
        phi_551_ = _e254;
        if _e254 {
            let _e255 = u_1;
            let _e256 = k_2;
            if (_e256 != 0f) {
                let _e258 = straight_1;
                local_4 = _e258;
            } else {
                let _e259 = w_1;
                local_4 = (0.5f * _e259);
            }
            let _e261 = local_4;
            phi_551_ = (_e255 > _e261);
        }
        let _e264 = phi_551_;
        if _e264 {
            let _e265 = x;
            let _e266 = edgeX;
            let _e269 = aa;
            local_5 = clamp((abs((_e265 - _e266)) / _e269), 0f, 1f);
        } else {
            local_5 = 1f;
        }
        let _e272 = local_5;
        m = _e272;
        let _e273 = b_2;
        let _e276 = b_2;
        normal = vec2<f32>(-(sin(_e273)), cos(_e276));
        let _e279 = normal;
        let _e280 = eye_1;
        let _e281 = pt;
        front = (dot(_e279, (_e280 - _e281)) > 0f);
        let _e285 = front;
        if _e285 {
            let _e286 = w_1;
            let _e287 = u_1;
            let _e289 = w_1;
            let _e291 = uniforms.ratio;
            let _e294 = uniforms.ratio;
            let _e296 = y;
            param_19 = vec2<f32>((clamp((_e286 + _e287), _e289, _e291) / _e294), _e296);
            let _e298 = getFromColor((&param_19));
            local_6 = _e298;
        } else {
            let _e299 = w_1;
            let _e300 = u_1;
            let _e302 = w_1;
            let _e305 = uniforms.ratio;
            let _e307 = y;
            param_20 = vec2<f32>((clamp((_e299 - _e300), 0f, _e302) / _e305), _e307);
            let _e309 = getToColor((&param_20));
            local_6 = _e309;
        }
        let _e310 = local_6;
        img = _e310;
        let _e311 = front;
        if _e311 {
            let _e312 = normal;
            local_7 = _e312;
        } else {
            let _e313 = normal;
            local_7 = -(_e313);
        }
        let _e315 = local_7;
        diffuse = (max(dot(_e315, vec2<f32>(-0.447214f, 0.894427f)), 0f) / 0.894427f);
        let _e319 = diffuse;
        let _e323 = uniforms.shading;
        shade = mix(1f, (0.25f + (0.75f * _e319)), _e323);
        let _e326 = uniforms.shading;
        let _e328 = lift;
        let _e330 = u_1;
        let _e332 = w_1;
        let _e338 = shade;
        shade = (_e338 * (1f - (((0.35f * _e326) * _e328) * exp((-(_e330) / (0.04f * _e332))))));
        let _e340 = shade;
        let _e341 = img;
        let _e343 = (_e341.xyz * _e340);
        img[0u] = _e343.x;
        img[1u] = _e343.y;
        img[2u] = _e343.z;
        let _e350 = m;
        if (_e350 >= 1f) {
            let _e352 = img;
            return _e352;
        }
    }
    let _e353 = x;
    if (_e353 < 0f) {
        let _e355 = (*uv_2);
        param_21 = _e355;
        let _e356 = getFromColor((&param_21));
        local_8 = _e356;
    } else {
        let _e357 = (*uv_2);
        param_22 = _e357;
        let _e358 = getToColor((&param_22));
        local_8 = _e358;
    }
    let _e359 = local_8;
    color = _e359;
    let _e360 = edge;
    let _e361 = x;
    toEdge = (_e360 - vec2<f32>(_e361, 0f));
    let _e365 = toEdge[0u];
    let _e366 = toEdge;
    cosEdge = (_e365 / max(length(_e366), 0.000001f));
    let _e370 = x;
    let _e373 = cosEdge;
    blocked = (0.5f * abs((select(-1f, 1f, (_e370 < 0f)) - _e373)));
    let _e377 = blocked;
    let _e378 = blocked;
    let _e380 = blocked;
    shadow = ((_e377 * _e378) * (3f - (2f * _e380)));
    slope = 0.50000054f;
    let _e385 = bend[0u];
    let _e387 = middle[0u];
    let _e389 = edge[0u];
    let _e391 = slope;
    let _e393 = bend[1u];
    let _e395 = middle[1u];
    let _e397 = edge[1u];
    reach = (vec3<f32>(_e385, _e387, _e389) + (vec3<f32>(_e393, _e395, _e397) * _e391));
    let _e402 = reach[0u];
    let _e404 = reach[1u];
    let _e406 = reach[2u];
    lo = min(0f, min(_e402, min(_e404, _e406)));
    let _e411 = reach[0u];
    let _e413 = reach[1u];
    let _e415 = reach[2u];
    hi = max(0f, max(_e411, max(_e413, _e415)));
    let _e420 = edge[1u];
    soft = max((0.25f * _e420), 0.00001f);
    let _e423 = shadow;
    let _e425 = x;
    let _e426 = lo;
    let _e428 = hi;
    let _e429 = x;
    let _e432 = soft;
    let _e437 = lift;
    shadow = max((0.5f * _e423), ((0.85f * clamp(((min((_e425 - _e426), (_e428 - _e429)) / _e432) + 0.5f), 0f, 1f)) * min((4f * _e437), 1f)));
    let _e443 = uniforms.shading;
    let _e444 = shadow;
    let _e447 = color;
    let _e449 = (_e447.xyz * (1f - (_e443 * _e444)));
    color[0u] = _e449.x;
    color[1u] = _e449.y;
    color[2u] = _e449.z;
    let _e456 = color;
    let _e457 = img;
    let _e458 = m;
    return mix(_e456, _e457, vec4(_e458));
}

fn main_1() {
    var param_23: vec2<f32>;

    let _e47 = _uv_1;
    param_23 = _e47;
    let _e48 = transition((&param_23));
    _fragColor = _e48;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
