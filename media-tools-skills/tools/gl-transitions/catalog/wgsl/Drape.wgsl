// Drape — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Drape.glsl
// Author: gre
// License: MIT
// Description: The outgoing image hangs like a sheet of fabric that is let go at the top: it collapses into soft, uneven folds that hide one another as the cloth bunches up and slides down out of the frame, revealing the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    folds: f32,
    depth: f32,
    sway: f32,
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

fn sidePull(sy: ptr<function, f32>, gT: ptr<function, f32>) -> f32 {
    let _e72 = (*gT);
    let _e74 = (*sy);
    return ((0.035f * _e72) * (0.3f + (0.7f * clamp(_e74, 0f, 1f))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e72 = (*uv)[0u];
    let _e74 = (*uv)[1u];
    let _e77 = textureSampleLevel(_to, _sampler, vec2<f32>(_e72, (1f - _e74)), 0f);
    return _e77;
}

fn topEdge(x: ptr<function, f32>, m: ptr<function, vec4<f32>>) -> f32 {
    var c: f32;

    let _e73 = (*x);
    c = ((2f * _e73) - 1f);
    let _e77 = (*m)[1u];
    let _e79 = (*m)[0u];
    let _e81 = c;
    let _e82 = c;
    return (_e77 - ((0.08f * _e79) * (1f - (_e81 * _e82))));
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e72 = (*uv_1)[0u];
    let _e74 = (*uv_1)[1u];
    let _e77 = textureSampleLevel(_from, _sampler, vec2<f32>(_e72, (1f - _e74)), 0f);
    return _e77;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e71 = (*v);
    let _e72 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e71 - (floor((_e71 / _e72)) * _e72)))));
}

fn hash11(p: ptr<function, f32>) -> f32 {
    let _e71 = (*p);
    (*p) = fract((_e71 * 0.1031f));
    let _e74 = (*p);
    let _e76 = (*p);
    (*p) = (_e76 * (_e74 + 33.33f));
    let _e78 = (*p);
    let _e79 = (*p);
    let _e81 = (*p);
    (*p) = (_e81 * (_e78 + _e79));
    let _e83 = (*p);
    return fract(_e83);
}

fn noise1(x_1: ptr<function, f32>) -> f32 {
    var i: f32;
    var f: f32;
    var param: f32;
    var param_1: f32;

    let _e75 = (*x_1);
    i = floor(_e75);
    let _e77 = (*x_1);
    let _e78 = i;
    f = (_e77 - _e78);
    let _e80 = i;
    param = _e80;
    let _e81 = hash11((&param));
    let _e82 = i;
    param_1 = (_e82 + 1f);
    let _e84 = hash11((&param_1));
    let _e85 = f;
    let _e86 = f;
    let _e88 = f;
    return mix(_e81, _e84, ((_e85 * _e86) * (3f - (2f * _e88))));
}

fn cloth(p_1: ptr<function, vec2<f32>>, m_1: ptr<function, vec4<f32>>, foldN: ptr<function, f32>) -> vec4<f32> {
    var gT_1: f32;
    var botY: f32;
    var x_2: f32;
    var top: f32;
    var param_2: f32;
    var param_3: vec4<f32>;
    var sy_1: f32;
    var pull: f32;
    var param_4: f32;
    var param_5: f32;
    var xc: f32;
    var wander: f32;
    var param_6: f32;
    var ph: f32;
    var param_7: f32;
    var d: f32;
    var param_8: f32;
    var amp: f32;
    var w: f32;
    var prof: f32;
    var dt: f32;
    var crease: f32;
    var on: bool;
    var local: vec4<f32>;

    let _e98 = (*m_1)[0u];
    gT_1 = _e98;
    let _e100 = (*m_1)[2u];
    botY = _e100;
    let _e102 = (*p_1)[0u];
    let _e104 = (*m_1)[3u];
    x_2 = (_e102 - _e104);
    let _e106 = x_2;
    param_2 = _e106;
    let _e107 = (*m_1);
    param_3 = _e107;
    let _e108 = topEdge((&param_2), (&param_3));
    top = _e108;
    let _e110 = (*p_1)[1u];
    let _e111 = botY;
    let _e113 = top;
    let _e114 = botY;
    sy_1 = ((_e110 - _e111) / max((_e113 - _e114), 0.0001f));
    let _e118 = sy_1;
    param_4 = _e118;
    let _e119 = gT_1;
    param_5 = _e119;
    let _e120 = sidePull((&param_4), (&param_5));
    pull = _e120;
    let _e121 = x_2;
    let _e122 = pull;
    let _e124 = pull;
    xc = ((_e121 - _e122) / (1f - (2f * _e124)));
    let _e128 = (*foldN);
    let _e130 = xc;
    let _e132 = sy_1;
    param_6 = ((((0.5f * _e128) * _e130) + (2.5f * _e132)) + 5.3f);
    let _e136 = noise1((&param_6));
    let _e139 = sy_1;
    wander = (((_e136 - 0.5f) * 2.4f) * (1f - _e139));
    let _e142 = (*foldN);
    let _e143 = xc;
    let _e145 = (*foldN);
    let _e147 = xc;
    param_7 = (((0.7f * _e145) * _e147) + 1.7f);
    let _e150 = noise1((&param_7));
    let _e154 = wander;
    ph = ((6.2831855f * ((_e142 * _e143) + (0.6f * _e150))) + _e154);
    let _e156 = (*foldN);
    let _e158 = xc;
    let _e160 = sy_1;
    param_8 = ((((1.1f * _e156) * _e158) + (1.4f * _e160)) + 7f);
    let _e164 = noise1((&param_8));
    d = (0.15f + (0.85f * _e164));
    let _e168 = uniforms.depth;
    let _e170 = gT_1;
    let _e172 = sy_1;
    let _e174 = sy_1;
    let _e180 = (*foldN);
    amp = ((((0.8f * _e168) * _e170) * (0.3f + ((0.7f * _e172) * sqrt(max(_e174, 0f))))) / max(_e180, 2f));
    let _e183 = (*foldN);
    w = (0.6f / _e183);
    let _e185 = w;
    let _e186 = xc;
    let _e188 = w;
    let _e189 = xc;
    let _e193 = amp;
    amp = (_e193 * (smoothstep(0f, _e185, _e186) * smoothstep(0f, _e188, (1f - _e189))));
    let _e195 = ph;
    prof = (0.5f - (0.5f * cos(_e195)));
    let _e199 = sy_1;
    let _e201 = top;
    let _e202 = botY;
    dt = ((1f - _e199) * (_e201 - _e202));
    let _e205 = dt;
    let _e208 = dt;
    let _e210 = ph;
    crease = (exp((-30f * _e205)) * (0.5f + (0.5f * sin(((80f * _e208) + (0.7f * _e210))))));
    let _e217 = sy_1;
    let _e219 = sy_1;
    let _e222 = xc;
    let _e225 = xc;
    on = ((((_e217 >= 0f) && (_e219 <= 1f)) && (_e222 >= 0f)) && (_e225 <= 1f));
    let _e228 = on;
    if _e228 {
        let _e229 = amp;
        let _e230 = d;
        let _e231 = prof;
        let _e233 = crease;
        let _e237 = xc;
        let _e238 = sy_1;
        let _e239 = ph;
        local = vec4<f32>((_e229 * ((_e230 * _e231) + (0.15f * _e233))), _e237, _e238, _e239);
    } else {
        local = vec4<f32>(-1f, -1f, -1f, -1f);
    }
    let _e241 = local;
    return _e241;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var t: f32;
    var topY: f32;
    var botY_1: f32;
    var f_1: f32;
    var foldN_1: f32;
    var shiftX: f32;
    var view: vec2<f32>;
    var zMax: f32;
    var m_2: vec4<f32>;
    var zA: f32;
    var zB: f32;
    var found: bool;
    var dA: f32;
    var dB: f32;
    var onA: bool;
    var i_1: i32;
    var z: f32;
    var s: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: vec4<f32>;
    var param_11: f32;
    var dz: f32;
    var zHit: f32;
    var za: f32;
    var j: i32;
    var zm: f32;
    var param_12: vec2<f32>;
    var param_13: vec4<f32>;
    var param_14: f32;
    var hp: vec2<f32>;
    var hit: vec4<f32>;
    var local_1: vec4<f32>;
    var param_15: vec2<f32>;
    var param_16: vec4<f32>;
    var param_17: f32;
    var param_18: vec2<f32>;
    var param_19: vec4<f32>;
    var param_20: f32;
    var col: vec4<f32>;
    var cover: f32;
    var xc_1: f32;
    var sy_2: f32;
    var ph_1: f32;
    var slope: f32;
    var mu: f32;
    var u: f32;
    var h: f32;
    var comp: f32;
    var v_1: f32;
    var tex: vec4<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var span: f32;
    var param_23: f32;
    var param_24: vec4<f32>;
    var e: f32;
    var hx: f32;
    var param_25: vec2<f32>;
    var param_26: vec4<f32>;
    var param_27: f32;
    var hy: f32;
    var param_28: vec2<f32>;
    var param_29: vec4<f32>;
    var param_30: f32;
    var hx0_: f32;
    var local_2: f32;
    var hy0_: f32;
    var local_3: f32;
    var nrm: vec3<f32>;
    var light: vec3<f32>;
    var diffuse: f32;
    var valley: f32;
    var ao: f32;
    var rim: f32;
    var under: f32;
    var back: f32;
    var aa: f32;
    var inside: f32;
    var local_4: f32;
    var to: vec4<f32>;
    var param_31: vec2<f32>;
    var x_3: f32;
    var pull_1: f32;
    var param_32: f32;
    var param_33: vec4<f32>;
    var param_34: f32;
    var param_35: f32;
    var outside: f32;
    var param_36: f32;
    var param_37: vec4<f32>;
    var sh: f32;
    var phi_610_: bool;

    let _e163 = uniforms.progress;
    t = _e163;
    let _e164 = t;
    let _e166 = t;
    topY = (1f - ((1.06f * _e164) * (0.35f + (0.65f * _e166))));
    let _e171 = t;
    let _e173 = t;
    let _e175 = t;
    botY_1 = (((-0.75f * _e171) * _e173) * _e175);
    let _e177 = t;
    let _e179 = t;
    let _e182 = t;
    f_1 = (1f - (((1f - _e177) * (1f - _e179)) * (1f - _e182)));
    let _e187 = uniforms.folds;
    let _e189 = uniforms.ratio;
    foldN_1 = max(1f, floor(((_e187 * min(_e189, 1f)) + 0.5f)));
    let _e196 = uniforms.sway;
    let _e198 = t;
    let _e202 = f_1;
    shiftX = (((_e196 * 0.035f) * sin((6.2831855f * _e198))) * _e202);
    let _e205 = uniforms.sway;
    let _e207 = t;
    let _e211 = f_1;
    view = vec2<f32>((0.75f + (((0.5f * _e205) * sin((3.1415927f * _e207))) * _e211)), -0.35f);
    let _e216 = uniforms.depth;
    let _e218 = f_1;
    let _e220 = foldN_1;
    zMax = (((0.92f * _e216) * _e218) / max(_e220, 2f));
    let _e223 = f_1;
    let _e224 = topY;
    let _e225 = botY_1;
    let _e226 = shiftX;
    m_2 = vec4<f32>(_e223, _e224, _e225, _e226);
    let _e228 = zMax;
    zA = _e228;
    zB = 0f;
    found = false;
    dA = 0f;
    dB = 0f;
    onA = false;
    i_1 = 0i;
    loop {
        let _e229 = i_1;
        if (_e229 < 24i) {
            let _e231 = found;
            if !(_e231) {
                let _e233 = zMax;
                let _e234 = i_1;
                z = max((_e233 * (1f - (f32(_e234) / 23f))), 0f);
                let _e240 = (*uv_2);
                let _e241 = view;
                let _e242 = z;
                param_9 = (_e240 - (_e241 * _e242));
                let _e245 = m_2;
                param_10 = _e245;
                let _e246 = foldN_1;
                param_11 = _e246;
                let _e247 = cloth((&param_9), (&param_10), (&param_11));
                s = _e247;
                let _e249 = s[0u];
                let _e250 = z;
                dz = (_e249 - _e250);
                let _e253 = s[0u];
                let _e255 = dz;
                if ((_e253 >= 0f) && (_e255 >= 0f)) {
                    found = true;
                    let _e258 = z;
                    zB = _e258;
                    let _e259 = dz;
                    dB = _e259;
                } else {
                    let _e260 = z;
                    zA = _e260;
                    let _e261 = dz;
                    dA = _e261;
                    let _e263 = s[0u];
                    onA = (_e263 >= 0f);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e265 = i_1;
            i_1 = (_e265 + 1i);
        }
    }
    let _e267 = zB;
    zHit = _e267;
    let _e268 = found;
    let _e269 = zA;
    let _e270 = zB;
    if (_e268 && (_e269 > _e270)) {
        let _e273 = onA;
        if _e273 {
            let _e274 = zA;
            let _e275 = zB;
            let _e276 = dA;
            let _e277 = dA;
            let _e278 = dB;
            zHit = mix(_e274, _e275, (_e276 / (_e277 - _e278)));
        } else {
            let _e282 = zA;
            za = _e282;
            j = 0i;
            loop {
                let _e283 = j;
                if (_e283 < 5i) {
                    let _e285 = za;
                    let _e286 = zHit;
                    zm = (0.5f * (_e285 + _e286));
                    let _e289 = (*uv_2);
                    let _e290 = view;
                    let _e291 = zm;
                    param_12 = (_e289 - (_e290 * _e291));
                    let _e294 = m_2;
                    param_13 = _e294;
                    let _e295 = foldN_1;
                    param_14 = _e295;
                    let _e296 = cloth((&param_12), (&param_13), (&param_14));
                    let _e298 = zm;
                    if (_e296.x >= _e298) {
                        let _e300 = zm;
                        zHit = _e300;
                    } else {
                        let _e301 = zm;
                        za = _e301;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e302 = j;
                    j = (_e302 + 1i);
                }
            }
        }
    }
    let _e304 = (*uv_2);
    let _e305 = view;
    let _e306 = zHit;
    hp = (_e304 - (_e305 * _e306));
    let _e309 = found;
    if _e309 {
        let _e310 = hp;
        param_15 = _e310;
        let _e311 = m_2;
        param_16 = _e311;
        let _e312 = foldN_1;
        param_17 = _e312;
        let _e313 = cloth((&param_15), (&param_16), (&param_17));
        local_1 = _e313;
    } else {
        local_1 = vec4<f32>(-1f, -1f, -1f, -1f);
    }
    let _e314 = local_1;
    hit = _e314;
    let _e315 = found;
    phi_610_ = _e315;
    if _e315 {
        let _e317 = hit[0u];
        phi_610_ = (_e317 < 0f);
    }
    let _e320 = phi_610_;
    if _e320 {
        let _e321 = zB;
        zHit = _e321;
        let _e322 = (*uv_2);
        let _e323 = view;
        let _e324 = zB;
        hp = (_e322 - (_e323 * _e324));
        let _e327 = hp;
        param_18 = _e327;
        let _e328 = m_2;
        param_19 = _e328;
        let _e329 = foldN_1;
        param_20 = _e329;
        let _e330 = cloth((&param_18), (&param_19), (&param_20));
        hit = _e330;
    }
    col = vec4<f32>(0f, 0f, 0f, 0f);
    cover = 0f;
    let _e332 = hit[0u];
    if (_e332 >= 0f) {
        let _e335 = hit[1u];
        xc_1 = _e335;
        let _e337 = hit[2u];
        sy_2 = _e337;
        let _e339 = hit[3u];
        ph_1 = _e339;
        let _e340 = zMax;
        let _e342 = foldN_1;
        slope = ((3.1415927f * _e340) * _e342);
        let _e344 = slope;
        let _e346 = slope;
        let _e348 = slope;
        let _e350 = slope;
        mu = min((((0.25f * _e344) * _e346) / (1f + ((0.25f * _e348) * _e350))), 0.5f);
        let _e355 = xc_1;
        let _e356 = mu;
        let _e357 = ph_1;
        let _e361 = foldN_1;
        u = (_e355 - ((_e356 * sin((2f * _e357))) / (12.566371f * _e361)));
        let _e365 = topY;
        let _e366 = botY_1;
        h = max((_e365 - _e366), 0.0001f);
        let _e369 = h;
        comp = max((1f - _e369), 0f);
        let _e372 = sy_2;
        let _e373 = comp;
        let _e376 = comp;
        let _e377 = sy_2;
        let _e379 = sy_2;
        let _e381 = sy_2;
        v_1 = ((_e372 * (1f - _e373)) + (((_e376 * _e377) * _e379) * _e381));
        let _e384 = u;
        let _e385 = v_1;
        param_21 = vec2<f32>(_e384, _e385);
        let _e387 = mirror((&param_21));
        param_22 = _e387;
        let _e388 = getFromColor((&param_22));
        tex = _e388;
        let _e390 = hp[0u];
        let _e391 = shiftX;
        param_23 = (_e390 - _e391);
        let _e393 = m_2;
        param_24 = _e393;
        let _e394 = topEdge((&param_23), (&param_24));
        let _e395 = botY_1;
        span = (_e394 - _e395);
        e = 0.002f;
        let _e397 = hp;
        let _e398 = e;
        param_25 = (_e397 + vec2<f32>(_e398, 0f));
        let _e401 = m_2;
        param_26 = _e401;
        let _e402 = foldN_1;
        param_27 = _e402;
        let _e403 = cloth((&param_25), (&param_26), (&param_27));
        hx = _e403.x;
        let _e405 = hp;
        let _e406 = e;
        param_28 = (_e405 + vec2<f32>(0f, _e406));
        let _e409 = m_2;
        param_29 = _e409;
        let _e410 = foldN_1;
        param_30 = _e410;
        let _e411 = cloth((&param_28), (&param_29), (&param_30));
        hy = _e411.x;
        let _e413 = hx;
        if (_e413 >= 0f) {
            let _e415 = hx;
            local_2 = _e415;
        } else {
            let _e417 = hit[0u];
            local_2 = _e417;
        }
        let _e418 = local_2;
        hx0_ = _e418;
        let _e419 = hy;
        if (_e419 >= 0f) {
            let _e421 = hy;
            local_3 = _e421;
        } else {
            let _e423 = hit[0u];
            local_3 = _e423;
        }
        let _e424 = local_3;
        hy0_ = _e424;
        let _e425 = hx0_;
        let _e427 = hit[0u];
        let _e430 = e;
        let _e432 = hy0_;
        let _e434 = hit[0u];
        let _e437 = e;
        nrm = normalize(vec3<f32>((-((_e425 - _e427)) / _e430), (-((_e432 - _e434)) / _e437), 1f));
        light = vec3<f32>(-0.390935f, 0.30406058f, 0.8687445f);
        let _e441 = nrm;
        let _e442 = light;
        let _e446 = light[2u];
        let _e448 = f_1;
        diffuse = mix(1f, (max(dot(_e441, _e442), 0f) / _e446), min(1f, (3f * _e448)));
        let _e452 = ph_1;
        valley = (1f - (0.5f - (0.5f * cos(_e452))));
        let _e458 = uniforms.depth;
        let _e460 = f_1;
        let _e462 = valley;
        let _e464 = valley;
        let _e466 = sy_2;
        ao = (1f - (((((0.6f * _e458) * _e460) * _e462) * _e464) * (0.35f + (0.65f * _e466))));
        let _e471 = sy_2;
        let _e474 = span;
        let _e479 = f_1;
        rim = ((exp(((-((1f - _e471)) * _e474) * 70f)) * 0.35f) * _e479);
        let _e482 = hit[0u];
        let _e483 = zHit;
        under = max((_e482 - _e483), 0f);
        let _e486 = under;
        let _e487 = zMax;
        back = min(1f, (_e486 / max((0.1f * _e487), 0.000001f)));
        let _e492 = diffuse;
        let _e493 = ao;
        let _e495 = rim;
        let _e498 = back;
        let _e502 = tex;
        let _e504 = (_e502.xyz * (((_e492 * _e493) * (1f - _e495)) * (1f - (0.6f * _e498))));
        tex[0u] = _e504.x;
        tex[1u] = _e504.y;
        tex[2u] = _e504.z;
        let _e511 = tex;
        col = _e511;
        let _e512 = f_1;
        aa = (0.003f * _e512);
        let _e514 = sy_2;
        let _e516 = span;
        let _e519 = view[1u];
        let _e520 = under;
        let _e523 = xc_1;
        let _e524 = xc_1;
        inside = min((((1f - _e514) * _e516) - (_e519 * _e520)), min(_e523, (1f - _e524)));
        let _e528 = aa;
        if (_e528 > 0f) {
            let _e530 = inside;
            let _e531 = aa;
            local_4 = clamp((_e530 / _e531), 0f, 1f);
        } else {
            local_4 = 1f;
        }
        let _e534 = local_4;
        cover = _e534;
        let _e535 = cover;
        if (_e535 >= 1f) {
            let _e537 = col;
            return _e537;
        }
    }
    let _e538 = (*uv_2);
    param_31 = _e538;
    let _e539 = getToColor((&param_31));
    to = _e539;
    let _e541 = (*uv_2)[0u];
    let _e542 = shiftX;
    x_3 = (_e541 - _e542);
    let _e545 = (*uv_2)[1u];
    let _e546 = botY_1;
    let _e548 = x_3;
    param_32 = _e548;
    let _e549 = m_2;
    param_33 = _e549;
    let _e550 = topEdge((&param_32), (&param_33));
    let _e551 = botY_1;
    param_34 = ((_e545 - _e546) / max((_e550 - _e551), 0.0001f));
    let _e555 = f_1;
    param_35 = _e555;
    let _e556 = sidePull((&param_34), (&param_35));
    pull_1 = _e556;
    let _e558 = (*uv_2)[1u];
    let _e559 = x_3;
    param_36 = _e559;
    let _e560 = m_2;
    param_37 = _e560;
    let _e561 = topEdge((&param_36), (&param_37));
    let _e563 = x_3;
    let _e565 = x_3;
    let _e568 = pull_1;
    outside = max((_e558 - _e561), (max(-(_e563), (_e565 - 1f)) - _e568));
    let _e572 = uniforms.shadow;
    let _e573 = outside;
    let _e579 = f_1;
    let _e581 = t;
    sh = (((_e572 * exp((-(max(_e573, 0f)) * 16f))) * _e579) * clamp((8f * (1f - _e581)), 0f, 1f));
    let _e586 = to;
    let _e588 = sh;
    let _e591 = (_e586.xyz * (1f - (0.8f * _e588)));
    let _e593 = to[3u];
    let _e598 = col;
    let _e599 = cover;
    return mix(vec4<f32>(_e591.x, _e591.y, _e591.z, _e593), _e598, vec4(_e599));
}

fn main_1() {
    var param_38: vec2<f32>;

    let _e71 = _uv_1;
    param_38 = _e71;
    let _e72 = transition((&param_38));
    _fragColor = _e72;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
