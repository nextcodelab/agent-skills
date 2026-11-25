// PaperFold — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PaperFold.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is a sheet of paper that folds in half in 3D along a vertical crease, then in half again along a horizontal one, its lit and shaded faces turning to show the back of the paper, and the small folded packet flies off the frame, leaving its shadow on the incoming image underneath
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    tilt: f32,
    shading: f32,
    paper: vec4<f32>,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e52 = (*uv)[0u];
    let _e54 = (*uv)[1u];
    let _e57 = textureSampleLevel(_from, _sampler, vec2<f32>(_e52, (1f - _e54)), 0f);
    return _e57;
}

fn front(st: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;

    let _e52 = (*st);
    let _e54 = uniforms.ratio;
    param = (_e52 / vec2<f32>(_e54, 1f));
    let _e57 = getFromColor((&param));
    return _e57;
}

fn back(st_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    var c: vec4<f32>;
    var param_1: vec2<f32>;

    let _e53 = (*st_1);
    param_1 = _e53;
    let _e54 = front((&param_1));
    c = _e54;
    let _e56 = uniforms.paper;
    let _e58 = c;
    let _e61 = mix(_e56.xyz, _e58.xyz, vec3(0.1f));
    let _e63 = c[3u];
    let _e66 = uniforms.paper[3u];
    return vec4<f32>(_e61.x, _e61.y, _e61.z, (_e63 * _e66));
}

fn hitFlap(o: ptr<function, vec3<f32>>, v: ptr<function, vec3<f32>>, h: ptr<function, f32>, n: ptr<function, vec3<f32>>, along: ptr<function, vec3<f32>>) -> vec3<f32> {
    var den: f32;
    var hinge: vec3<f32>;
    var t: f32;
    var q: vec3<f32>;

    let _e59 = (*n);
    let _e60 = (*v);
    den = dot(_e59, _e60);
    let _e62 = den;
    if (abs(_e62) < 0.00001f) {
        return vec3<f32>(-1f, 0f, 0f);
    }
    let _e65 = (*h);
    hinge = vec3<f32>(_e65, 0f, 0f);
    let _e67 = (*n);
    let _e68 = hinge;
    let _e69 = (*o);
    let _e72 = den;
    t = (dot(_e67, (_e68 - _e69)) / _e72);
    let _e74 = (*o);
    let _e75 = t;
    let _e76 = (*v);
    q = (_e74 + (_e76 * _e75));
    let _e79 = t;
    let _e80 = q;
    let _e81 = hinge;
    let _e83 = (*along);
    let _e86 = q[1u];
    return vec3<f32>(_e79, dot((_e80 - _e81), _e83), _e86);
}

fn topFace(st_2: ptr<function, vec2<f32>>, second: ptr<function, bool>) -> vec4<f32> {
    var local: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e55 = (*second);
    if _e55 {
        let _e57 = uniforms.ratio;
        let _e59 = (*st_2)[0u];
        let _e62 = (*st_2)[1u];
        param_2 = vec2<f32>((_e57 - _e59), _e62);
        let _e64 = back((&param_2));
        local = _e64;
    } else {
        let _e65 = (*st_2);
        param_3 = _e65;
        let _e66 = front((&param_3));
        local = _e66;
    }
    let _e67 = local;
    return _e67;
}

fn inside(p: ptr<function, vec2<f32>>, h_1: ptr<function, f32>, k: ptr<function, f32>) -> f32 {
    let _e54 = (*p)[0u];
    let _e55 = (*h_1);
    let _e57 = (*p)[0u];
    let _e61 = (*p)[1u];
    let _e62 = (*k);
    let _e64 = (*p)[1u];
    return min(min(_e54, (_e55 - _e57)), min(_e61, (_e62 - _e64)));
}

fn shadowAt(q_1: ptr<function, vec3<f32>>, l: ptr<function, vec3<f32>>, h_2: ptr<function, f32>, k_1: ptr<function, f32>, n_1: ptr<function, vec3<f32>>, along_1: ptr<function, vec3<f32>>) -> f32 {
    var sh: f32;
    var soft: f32;
    var param_4: vec2<f32>;
    var param_5: f32;
    var param_6: f32;
    var hit: vec3<f32>;
    var param_7: vec3<f32>;
    var param_8: vec3<f32>;
    var param_9: f32;
    var param_10: vec3<f32>;
    var param_11: vec3<f32>;
    var height: f32;
    var soft_1: f32;
    var param_12: vec2<f32>;
    var param_13: f32;
    var param_14: f32;

    sh = 0f;
    let _e73 = (*q_1)[2u];
    if (_e73 < -0.0001f) {
        let _e76 = (*q_1)[2u];
        soft = (0.004f - (0.4f * _e76));
        let _e79 = soft;
        let _e81 = soft;
        let _e82 = (*q_1);
        let _e85 = (*q_1)[2u];
        let _e87 = (*l)[2u];
        let _e89 = (*l);
        param_4 = (_e82.xy - (_e89.xy * (_e85 / _e87)));
        let _e93 = (*h_2);
        param_5 = _e93;
        let _e94 = (*k_1);
        param_6 = _e94;
        let _e95 = inside((&param_4), (&param_5), (&param_6));
        sh = smoothstep(-(_e79), _e81, _e95);
    }
    let _e97 = (*q_1);
    param_7 = _e97;
    let _e98 = (*l);
    param_8 = _e98;
    let _e99 = (*h_2);
    param_9 = _e99;
    let _e100 = (*n_1);
    param_10 = _e100;
    let _e101 = (*along_1);
    param_11 = _e101;
    let _e102 = hitFlap((&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
    hit = _e102;
    let _e104 = hit[0u];
    if (_e104 > 0f) {
        let _e107 = hit[0u];
        let _e109 = (*l)[2u];
        height = (_e107 * _e109);
        let _e111 = height;
        soft_1 = (0.004f + (0.3f * _e111));
        let _e114 = sh;
        let _e116 = (*n_1)[0u];
        let _e119 = (*n_1)[0u];
        let _e122 = soft_1;
        let _e124 = soft_1;
        let _e125 = hit;
        param_12 = _e125.yz;
        let _e127 = (*h_2);
        param_13 = _e127;
        let _e128 = (*k_1);
        param_14 = _e128;
        let _e129 = inside((&param_12), (&param_13), (&param_14));
        let _e132 = height;
        sh = max(_e114, ((min(((4f * _e116) * _e119), 1f) * smoothstep(-(_e122), _e124, _e129)) / (1f + (3f * _e132))));
    }
    let _e137 = sh;
    return _e137;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e52 = (*uv_1)[0u];
    let _e54 = (*uv_1)[1u];
    let _e57 = textureSampleLevel(_to, _sampler, vec2<f32>(_e52, (1f - _e54)), 0f);
    return _e57;
}

fn toSheet(v_1: ptr<function, vec3<f32>>, yaw: ptr<function, vec2<f32>>, pitch: ptr<function, vec2<f32>>, spin: ptr<function, vec2<f32>>) -> vec3<f32> {
    let _e55 = (*yaw)[0u];
    let _e57 = (*v_1)[0u];
    let _e60 = (*yaw)[1u];
    let _e62 = (*v_1)[2u];
    let _e66 = (*v_1)[1u];
    let _e68 = (*yaw)[0u];
    let _e70 = (*v_1)[2u];
    let _e73 = (*yaw)[1u];
    let _e75 = (*v_1)[0u];
    (*v_1) = vec3<f32>(((_e55 * _e57) + (_e60 * _e62)), _e66, ((_e68 * _e70) - (_e73 * _e75)));
    let _e80 = (*v_1)[0u];
    let _e82 = (*pitch)[0u];
    let _e84 = (*v_1)[1u];
    let _e87 = (*pitch)[1u];
    let _e89 = (*v_1)[2u];
    let _e93 = (*pitch)[0u];
    let _e95 = (*v_1)[2u];
    let _e98 = (*pitch)[1u];
    let _e100 = (*v_1)[1u];
    (*v_1) = vec3<f32>(_e80, ((_e82 * _e84) + (_e87 * _e89)), ((_e93 * _e95) - (_e98 * _e100)));
    let _e105 = (*spin)[0u];
    let _e107 = (*v_1)[0u];
    let _e110 = (*spin)[1u];
    let _e112 = (*v_1)[1u];
    let _e116 = (*spin)[0u];
    let _e118 = (*v_1)[1u];
    let _e121 = (*spin)[1u];
    let _e123 = (*v_1)[0u];
    let _e127 = (*v_1)[2u];
    return vec3<f32>(((_e105 * _e107) + (_e110 * _e112)), ((_e116 * _e118) - (_e121 * _e123)), _e127);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var w: f32;
    var shade: f32;
    var s: f32;
    var second_1: bool;
    var x: f32;
    var local_1: f32;
    var a: f32;
    var f: f32;
    var turn: f32;
    var yaw_1: vec2<f32>;
    var pitch_1: vec2<f32>;
    var dist: f32;
    var recede: f32;
    var dir: vec2<f32>;
    var local_2: vec2<f32>;
    var c_1: vec2<f32>;
    var reach: f32;
    var lift: f32;
    var turned: f32;
    var spin_1: vec2<f32>;
    var center: vec3<f32>;
    var eye: vec3<f32>;
    var e: vec3<f32>;
    var param_15: vec3<f32>;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var d: vec3<f32>;
    var param_19: vec3<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var l_1: vec3<f32>;
    var param_23: vec3<f32>;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: vec2<f32>;
    var h_3: f32;
    var local_3: f32;
    var k_2: f32;
    var local_4: f32;
    var creased: f32;
    var n_2: vec3<f32>;
    var along_2: vec3<f32>;
    var col: vec4<f32>;
    var param_27: vec2<f32>;
    var g: vec3<f32>;
    var param_28: vec3<f32>;
    var param_29: vec3<f32>;
    var param_30: f32;
    var param_31: f32;
    var param_32: vec3<f32>;
    var param_33: vec3<f32>;
    var t_1: f32;
    var local_5: f32;
    var p_1: vec3<f32>;
    var m: f32;
    var param_34: vec2<f32>;
    var param_35: f32;
    var param_36: f32;
    var img: vec4<f32>;
    var local_6: vec2<f32>;
    var param_37: vec2<f32>;
    var param_38: bool;
    var sh_1: f32;
    var param_39: vec3<f32>;
    var param_40: vec3<f32>;
    var param_41: f32;
    var param_42: f32;
    var param_43: vec3<f32>;
    var param_44: vec3<f32>;
    var hit_1: vec3<f32>;
    var param_45: vec3<f32>;
    var param_46: vec3<f32>;
    var param_47: f32;
    var param_48: vec3<f32>;
    var param_49: vec3<f32>;
    var r: f32;
    var dr: f32;
    var fore: f32;
    var mf: f32;
    var up: bool;
    var st_3: vec2<f32>;
    var img_1: vec4<f32>;
    var local_7: vec4<f32>;
    var param_50: vec2<f32>;
    var param_51: bool;
    var param_52: vec2<f32>;
    var lit: f32;
    var local_8: vec3<f32>;

    let _e142 = uniforms.ratio;
    w = _e142;
    let _e144 = uniforms.shading;
    shade = clamp(_e144, 0f, 1f);
    let _e147 = uniforms.progress;
    s = (2f * smoothstep(0f, 0.62f, _e147));
    let _e150 = s;
    second_1 = (_e150 > 1f);
    let _e152 = second_1;
    if _e152 {
        let _e153 = s;
        local_1 = (_e153 - 1f);
    } else {
        let _e155 = s;
        local_1 = _e155;
    }
    let _e156 = local_1;
    x = _e156;
    let _e157 = x;
    let _e158 = x;
    let _e159 = x;
    let _e161 = x;
    a = (3.1415927f * mix(_e157, ((_e158 * _e159) * (3f - (2f * _e161))), 0.6f));
    let _e168 = uniforms.progress;
    f = clamp(((_e168 - 0.5f) / 0.47f), 0f, 1f);
    let _e173 = uniforms.tilt;
    let _e176 = uniforms.progress;
    let _e179 = uniforms.progress;
    turn = (clamp(_e173, 0f, 1f) * (smoothstep(0f, 0.25f, _e176) - smoothstep(0.4f, 0.8f, _e179)));
    let _e183 = turn;
    let _e186 = turn;
    yaw_1 = vec2<f32>(cos((0.45f * _e183)), sin((0.45f * _e186)));
    let _e190 = turn;
    let _e193 = turn;
    pitch_1 = vec2<f32>(cos((0.55f * _e190)), -(sin((0.55f * _e193))));
    let _e198 = w;
    dist = (2.5f * max(_e198, 1f));
    let _e201 = dist;
    let _e203 = turn;
    recede = ((_e201 * 0.35f) * _e203);
    let _e206 = uniforms.direction;
    if (length(_e206) > 0f) {
        let _e210 = uniforms.direction;
        local_2 = normalize(_e210);
    } else {
        local_2 = vec2<f32>(1f, 0f);
    }
    let _e212 = local_2;
    dir = _e212;
    let _e213 = w;
    let _e215 = w;
    let _e217 = s;
    let _e221 = s;
    c_1 = vec2<f32>(((0.5f * _e213) - ((0.25f * _e215) * min(_e217, 1f))), (0.5f - (0.25f * max((_e221 - 1f), 0f))));
    let _e228 = dir[0u];
    let _e230 = w;
    let _e233 = dir[1u];
    let _e237 = w;
    reach = (((0.5f * ((abs(_e228) * _e230) + abs(_e233))) + length(vec2<f32>((0.25f * _e237), 0.25f))) + 0.4f);
    let _e243 = f;
    lift = (0.3f * smoothstep(0f, 0.5f, _e243));
    let _e247 = dir[0u];
    let _e250 = f;
    let _e252 = f;
    turned = ((select(-0.7f, 0.7f, (_e247 < 0f)) * _e250) * _e252);
    let _e254 = turned;
    let _e256 = turned;
    spin_1 = vec2<f32>(cos(_e254), sin(_e256));
    let _e259 = w;
    let _e262 = dir;
    let _e263 = reach;
    let _e265 = f;
    let _e267 = f;
    let _e269 = (vec2<f32>((0.5f * _e259), 0.5f) + (((_e262 * _e263) * _e265) * _e267));
    let _e270 = recede;
    center = vec3<f32>(_e269.x, _e269.y, -(_e270));
    let _e275 = w;
    let _e277 = dist;
    eye = vec3<f32>((0.5f * _e275), 0.5f, _e277);
    let _e279 = eye;
    let _e280 = center;
    param_15 = (_e279 - _e280);
    let _e282 = yaw_1;
    param_16 = _e282;
    let _e283 = pitch_1;
    param_17 = _e283;
    let _e284 = spin_1;
    param_18 = _e284;
    let _e285 = toSheet((&param_15), (&param_16), (&param_17), (&param_18));
    let _e286 = c_1;
    e = (_e285 + vec3<f32>(_e286.x, _e286.y, 0f));
    let _e292 = (*uv_2)[0u];
    let _e293 = w;
    let _e296 = (*uv_2)[1u];
    let _e298 = eye;
    param_19 = (vec3<f32>((_e292 * _e293), _e296, 0f) - _e298);
    let _e300 = yaw_1;
    param_20 = _e300;
    let _e301 = pitch_1;
    param_21 = _e301;
    let _e302 = spin_1;
    param_22 = _e302;
    let _e303 = toSheet((&param_19), (&param_20), (&param_21), (&param_22));
    d = _e303;
    param_23 = vec3<f32>(-0.3995f, 0.4494f, 0.799f);
    let _e304 = yaw_1;
    param_24 = _e304;
    let _e305 = pitch_1;
    param_25 = _e305;
    let _e306 = spin_1;
    param_26 = _e306;
    let _e307 = toSheet((&param_23), (&param_24), (&param_25), (&param_26));
    l_1 = _e307;
    let _e308 = second_1;
    if _e308 {
        let _e309 = e;
        let _e310 = _e309.yx;
        e[0u] = _e310.x;
        e[1u] = _e310.y;
        let _e315 = d;
        let _e316 = _e315.yx;
        d[0u] = _e316.x;
        d[1u] = _e316.y;
        let _e321 = l_1;
        let _e322 = _e321.yx;
        l_1[0u] = _e322.x;
        l_1[1u] = _e322.y;
    }
    let _e327 = second_1;
    if _e327 {
        local_3 = 0.5f;
    } else {
        let _e328 = w;
        local_3 = (0.5f * _e328);
    }
    let _e330 = local_3;
    h_3 = _e330;
    let _e331 = second_1;
    if _e331 {
        let _e332 = w;
        local_4 = (0.5f * _e332);
    } else {
        local_4 = 1f;
    }
    let _e334 = local_4;
    k_2 = _e334;
    let _e335 = a;
    creased = sin(_e335);
    let _e337 = creased;
    let _e339 = a;
    n_2 = vec3<f32>(-(_e337), 0f, cos(_e339));
    let _e342 = a;
    let _e344 = creased;
    along_2 = vec3<f32>(cos(_e342), 0f, _e344);
    let _e346 = (*uv_2);
    param_27 = _e346;
    let _e347 = getToColor((&param_27));
    col = _e347;
    let _e349 = d[2u];
    if (_e349 < 0f) {
        let _e351 = e;
        let _e352 = d;
        let _e354 = e[2u];
        let _e355 = lift;
        let _e359 = d[2u];
        g = (_e351 + ((_e352 * (_e354 + _e355)) / vec3(-(_e359))));
        let _e364 = shade;
        let _e366 = f;
        let _e367 = f;
        let _e371 = g;
        param_28 = _e371;
        let _e372 = l_1;
        param_29 = _e372;
        let _e373 = h_3;
        param_30 = _e373;
        let _e374 = k_2;
        param_31 = _e374;
        let _e375 = n_2;
        param_32 = _e375;
        let _e376 = along_2;
        param_33 = _e376;
        let _e377 = shadowAt((&param_28), (&param_29), (&param_30), (&param_31), (&param_32), (&param_33));
        let _e380 = col;
        let _e382 = (_e380.xyz * (1f - (((0.7f * _e364) * (1f - (_e366 * _e367))) * _e377)));
        col[0u] = _e382.x;
        col[1u] = _e382.y;
        col[2u] = _e382.z;
    }
    let _e390 = d[2u];
    if (_e390 < 0f) {
        let _e393 = e[2u];
        let _e395 = d[2u];
        local_5 = (_e393 / -(_e395));
    } else {
        local_5 = -1f;
    }
    let _e398 = local_5;
    t_1 = _e398;
    let _e399 = e;
    let _e400 = t_1;
    let _e401 = d;
    p_1 = (_e399 + (_e401 * _e400));
    let _e404 = p_1;
    param_34 = _e404.xy;
    let _e406 = h_3;
    param_35 = _e406;
    let _e407 = k_2;
    param_36 = _e407;
    let _e408 = inside((&param_34), (&param_35), (&param_36));
    let _e409 = t_1;
    m = clamp(((_e408 / (0.0015f * _e409)) + 1f), 0f, 1f);
    let _e414 = t_1;
    let _e416 = m;
    if ((_e414 > 0f) && (_e416 > 0f)) {
        let _e419 = second_1;
        if _e419 {
            let _e420 = p_1;
            local_6 = _e420.yx;
        } else {
            let _e422 = p_1;
            local_6 = _e422.xy;
        }
        let _e424 = local_6;
        param_37 = _e424;
        let _e425 = second_1;
        param_38 = _e425;
        let _e426 = topFace((&param_37), (&param_38));
        img = _e426;
        let _e427 = p_1;
        param_39 = _e427;
        let _e428 = l_1;
        param_40 = _e428;
        let _e429 = h_3;
        param_41 = _e429;
        let _e430 = k_2;
        param_42 = _e430;
        let _e431 = n_2;
        param_43 = _e431;
        let _e432 = along_2;
        param_44 = _e432;
        let _e433 = shadowAt((&param_39), (&param_40), (&param_41), (&param_42), (&param_43), (&param_44));
        sh_1 = _e433;
        let _e434 = shade;
        let _e436 = sh_1;
        let _e439 = shade;
        let _e441 = creased;
        let _e443 = h_3;
        let _e445 = p_1[0u];
        let _e454 = img;
        let _e456 = (_e454.xyz * ((1f - ((0.7f * _e434) * _e436)) * (1f - (((0.5f * _e439) * _e441) * exp((-(abs((_e443 - _e445))) / 0.02f))))));
        img[0u] = _e456.x;
        img[1u] = _e456.y;
        img[2u] = _e456.z;
        let _e463 = col;
        let _e464 = img;
        let _e465 = m;
        col = mix(_e463, _e464, vec4(_e465));
    }
    let _e468 = e;
    param_45 = _e468;
    let _e469 = d;
    param_46 = _e469;
    let _e470 = h_3;
    param_47 = _e470;
    let _e471 = n_2;
    param_48 = _e471;
    let _e472 = along_2;
    param_49 = _e472;
    let _e473 = hitFlap((&param_45), (&param_46), (&param_47), (&param_48), (&param_49));
    hit_1 = _e473;
    let _e475 = hit_1[0u];
    if (_e475 > 0f) {
        let _e478 = hit_1[1u];
        r = _e478;
        let _e479 = along_2;
        let _e480 = d;
        dr = dot(_e479, normalize(_e480));
        let _e483 = dr;
        let _e484 = dr;
        fore = sqrt(max((1f - (_e483 * _e484)), 0.0025f));
        let _e489 = r;
        let _e490 = h_3;
        let _e491 = r;
        let _e494 = fore;
        let _e497 = hit_1[2u];
        let _e498 = k_2;
        let _e500 = hit_1[2u];
        let _e505 = hit_1[0u];
        mf = clamp(((min((min(_e489, (_e490 - _e491)) * _e494), min(_e497, (_e498 - _e500))) / (0.0015f * _e505)) + 1f), 0f, 1f);
        let _e510 = mf;
        if (_e510 > 0f) {
            let _e512 = n_2;
            let _e513 = e;
            let _e514 = h_3;
            up = (dot(_e512, (_e513 - vec3<f32>(_e514, 0f, 0f))) > 0f);
            let _e519 = h_3;
            let _e520 = r;
            let _e523 = hit_1[2u];
            st_3 = vec2<f32>((_e519 + _e520), _e523);
            let _e525 = second_1;
            if _e525 {
                let _e526 = st_3;
                st_3 = _e526.yx;
            }
            let _e528 = up;
            if _e528 {
                let _e529 = st_3;
                param_50 = _e529;
                let _e530 = second_1;
                param_51 = _e530;
                let _e531 = topFace((&param_50), (&param_51));
                local_7 = _e531;
            } else {
                let _e532 = st_3;
                param_52 = _e532;
                let _e533 = back((&param_52));
                local_7 = _e533;
            }
            let _e534 = local_7;
            img_1 = _e534;
            let _e535 = up;
            if _e535 {
                let _e536 = n_2;
                local_8 = _e536;
            } else {
                let _e537 = n_2;
                local_8 = -(_e537);
            }
            let _e539 = local_8;
            let _e540 = l_1;
            let _e543 = l_1[2u];
            lit = (dot(_e539, _e540) - _e543);
            let _e545 = shade;
            let _e547 = lit;
            let _e551 = shade;
            let _e553 = creased;
            let _e555 = r;
            let _e563 = img_1;
            let _e565 = (_e563.xyz * (max((1f + ((0.6f * _e545) * _e547)), 0f) * (1f - (((0.5f * _e551) * _e553) * exp((-(abs(_e555)) / 0.02f))))));
            img_1[0u] = _e565.x;
            img_1[1u] = _e565.y;
            img_1[2u] = _e565.z;
            let _e572 = col;
            let _e573 = img_1;
            let _e574 = mf;
            col = mix(_e572, _e573, vec4(_e574));
        }
    }
    let _e577 = col;
    return _e577;
}

fn main_1() {
    var param_53: vec2<f32>;

    let _e51 = _uv_1;
    param_53 = _e51;
    let _e52 = transition((&param_53));
    _fragColor = _e52;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
