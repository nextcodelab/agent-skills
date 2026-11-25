// Puzzle — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Puzzle.glsl
// Author: gre
// License: MIT
// Description: The image is cut into jigsaw puzzle pieces that lift one after another and fall away, revealing the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    pieces: f32,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e64 = (*uv)[0u];
    let _e66 = (*uv)[1u];
    let _e69 = textureSampleLevel(_from, _sampler, vec2<f32>(_e64, (1f - _e66)), 0f);
    return _e69;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e64 = (*uv_1)[0u];
    let _e66 = (*uv_1)[1u];
    let _e69 = textureSampleLevel(_to, _sampler, vec2<f32>(_e64, (1f - _e66)), 0f);
    return _e69;
}

fn hash(c: ptr<function, vec2<f32>>) -> f32 {
    var p: vec2<f32>;

    let _e64 = (*c);
    p = fract((_e64 * vec2<f32>(0.1031f, 0.103f)));
    let _e67 = p;
    let _e68 = p;
    let _e73 = p;
    p = (_e73 + vec2(dot(_e67, (_e68.yx + vec2(33.33f)))));
    let _e77 = p[0u];
    let _e79 = p[1u];
    let _e82 = p[0u];
    return fract(((_e77 + _e79) * _e82));
}

fn boxDist(p_1: ptr<function, vec2<f32>>, halfSize: ptr<function, vec2<f32>>) -> f32 {
    var q: vec2<f32>;

    let _e65 = (*p_1);
    let _e67 = (*halfSize);
    q = (abs(_e65) - _e67);
    let _e69 = q;
    let _e74 = q[0u];
    let _e76 = q[1u];
    return (length(max(_e69, vec2(0f))) + min(max(_e74, _e76), 0f));
}

fn pieceDist(p_2: ptr<function, vec2<f32>>, c_1: ptr<function, vec2<f32>>, grid: ptr<function, vec2<f32>>, aspect: ptr<function, f32>) -> f32 {
    var halfSize_1: vec2<f32>;
    var d: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var tabs: f32;
    var e: i32;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var local_1: vec2<f32>;
    var key: vec2<f32>;
    var next: vec2<f32>;
    var h: f32;
    var param_2: vec2<f32>;
    var tab: bool;
    var out1_: vec2<f32>;
    var along: vec2<f32>;
    var edge: vec2<f32>;
    var k: f32;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var phi_191_: bool;
    var phi_199_: bool;
    var phi_207_: bool;

    let _e86 = (*aspect);
    halfSize_1 = vec2<f32>((0.5f * _e86), 0.5f);
    let _e89 = (*p_2);
    param = _e89;
    let _e90 = halfSize_1;
    param_1 = _e90;
    let _e91 = boxDist((&param), (&param_1));
    d = _e91;
    tabs = 1000f;
    e = 0i;
    loop {
        let _e92 = e;
        if (_e92 < 4i) {
            let _e94 = e;
            if (_e94 == 0i) {
                local = vec2<f32>(1f, 0f);
            } else {
                let _e96 = e;
                if (_e96 == 1i) {
                    local_1 = vec2<f32>(-1f, 0f);
                } else {
                    let _e98 = e;
                    local_1 = select(vec2<f32>(0f, -1f), vec2<f32>(0f, 1f), vec2((_e98 == 2i)));
                }
                let _e102 = local_1;
                local = _e102;
            }
            let _e103 = local;
            dir = _e103;
            let _e104 = (*c_1);
            let _e105 = dir;
            key = (_e104 + min(_e105, vec2(0f)));
            let _e109 = (*c_1);
            let _e110 = dir;
            next = (_e109 + _e110);
            let _e113 = next[0u];
            let _e114 = (_e113 >= 0f);
            phi_191_ = _e114;
            if _e114 {
                let _e116 = next[1u];
                phi_191_ = (_e116 >= 0f);
            }
            let _e119 = phi_191_;
            phi_199_ = _e119;
            if _e119 {
                let _e121 = next[0u];
                let _e123 = (*grid)[0u];
                phi_199_ = (_e121 < _e123);
            }
            let _e126 = phi_199_;
            phi_207_ = _e126;
            if _e126 {
                let _e128 = next[1u];
                let _e130 = (*grid)[1u];
                phi_207_ = (_e128 < _e130);
            }
            let _e133 = phi_207_;
            if _e133 {
                let _e134 = key;
                let _e135 = e;
                param_2 = (_e134 + select(vec2<f32>(71f, 37f), vec2<f32>(0f, 0f), vec2((_e135 < 2i))));
                let _e140 = hash((&param_2));
                h = _e140;
                let _e141 = h;
                let _e144 = dir[0u];
                let _e146 = dir[1u];
                tab = ((_e141 < 0.5f) == ((_e144 + _e146) > 0f));
                let _e150 = dir;
                let _e151 = tab;
                out1_ = (_e150 * select(-1f, 1f, _e151));
                let _e155 = dir[1u];
                let _e158 = dir[0u];
                along = vec2<f32>(abs(_e155), abs(_e158));
                let _e161 = dir;
                let _e162 = halfSize_1;
                let _e164 = along;
                let _e165 = h;
                edge = ((_e161 * _e162) + ((_e164 * (fract((_e165 * 2f)) - 0.5f)) * 0.16f));
                let _e172 = (*p_2);
                let _e173 = edge;
                let _e175 = out1_;
                let _e180 = (*p_2);
                let _e181 = edge;
                let _e183 = out1_;
                let _e186 = dir;
                let _e189 = along;
                param_3 = ((_e180 - _e181) - (_e183 * 0.06f));
                param_4 = ((abs(_e186) * 0.08f) + (_e189 * 0.085f));
                let _e192 = boxDist((&param_3), (&param_4));
                k = min((length(((_e172 - _e173) - (_e175 * 0.15f))) - 0.125f), _e192);
                let _e194 = tab;
                if _e194 {
                    let _e195 = tabs;
                    let _e196 = k;
                    tabs = min(_e195, _e196);
                } else {
                    let _e198 = d;
                    let _e199 = k;
                    d = max(_e198, -(_e199));
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e202 = e;
            e = (_e202 + 1i);
        }
    }
    let _e204 = d;
    let _e205 = tabs;
    return min(_e204, _e205);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var rows: f32;
    var local_2: f32;
    var cols: f32;
    var local_3: f32;
    var grid_1: vec2<f32>;
    var aspect_1: f32;
    var g: vec2<f32>;
    var cell: vec2<f32>;
    var boardSum: f32;
    var allSum: f32;
    var prio1_: f32;
    var prio2_: f32;
    var cov1_: f32;
    var cov2_: f32;
    var shade1_: f32;
    var shade2_: f32;
    var uv1_: vec2<f32>;
    var uv2_: vec2<f32>;
    var shadowAll: f32;
    var seam: f32;
    var i: i32;
    var c_2: vec2<f32>;
    var center: vec2<f32>;
    var local_4: vec2<f32>;
    var h_1: f32;
    var param_5: vec2<f32>;
    var diag: f32;
    var delay: f32;
    var t: f32;
    var d0_: f32;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: f32;
    var w: f32;
    var lift: f32;
    var fall: f32;
    var s: f32;
    var a: f32;
    var off: vec2<f32>;
    var rot: mat2x2<f32>;
    var pl: vec2<f32>;
    var dp: f32;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: f32;
    var cov: f32;
    var shade: f32;
    var puv: vec2<f32>;
    var sl: vec2<f32>;
    var sh: f32;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var param_17: f32;
    var prio: f32;
    var base: vec4<f32>;
    var param_18: vec2<f32>;
    var param_19: vec2<f32>;
    var p2_: vec4<f32>;
    var param_20: vec2<f32>;
    var p1_: vec4<f32>;
    var param_21: vec2<f32>;
    var phi_413_: bool;
    var phi_421_: bool;
    var phi_429_: bool;

    let _e128 = uniforms.ratio;
    if (_e128 < 1f) {
        let _e131 = uniforms.pieces;
        let _e133 = uniforms.ratio;
        local_2 = floor(((_e131 / _e133) + 0.5f));
    } else {
        let _e138 = uniforms.pieces;
        local_2 = _e138;
    }
    let _e139 = local_2;
    rows = _e139;
    let _e141 = uniforms.ratio;
    if (_e141 < 1f) {
        let _e144 = uniforms.pieces;
        local_3 = _e144;
    } else {
        let _e146 = uniforms.pieces;
        let _e148 = uniforms.ratio;
        local_3 = floor(((_e146 * _e148) + 0.5f));
    }
    let _e152 = local_3;
    cols = _e152;
    let _e153 = cols;
    let _e154 = rows;
    grid_1 = vec2<f32>(_e153, _e154);
    let _e157 = uniforms.ratio;
    let _e158 = rows;
    let _e160 = cols;
    aspect_1 = ((_e157 * _e158) / _e160);
    let _e162 = (*uv_2);
    let _e163 = grid_1;
    g = (_e162 * _e163);
    let _e165 = g;
    cell = floor(_e165);
    boardSum = 0f;
    allSum = 0f;
    prio1_ = -1f;
    prio2_ = -1f;
    cov1_ = 0f;
    cov2_ = 0f;
    shade1_ = 1f;
    shade2_ = 1f;
    let _e167 = (*uv_2);
    uv1_ = _e167;
    let _e168 = (*uv_2);
    uv2_ = _e168;
    shadowAll = 0f;
    seam = 1f;
    i = 0i;
    loop {
        let _e169 = i;
        if (_e169 < 9i) {
            let _e171 = cell;
            let _e172 = i;
            let _e173 = f32(_e172);
            let _e178 = i;
            c_2 = ((_e171 + vec2<f32>((_e173 - (floor((_e173 / 3f)) * 3f)), floor((f32(_e178) / 3f)))) - vec2(1f));
            let _e187 = c_2[0u];
            let _e188 = (_e187 < 0f);
            phi_413_ = _e188;
            if !(_e188) {
                let _e191 = c_2[1u];
                phi_413_ = (_e191 < 0f);
            }
            let _e194 = phi_413_;
            phi_421_ = _e194;
            if !(_e194) {
                let _e197 = c_2[0u];
                let _e198 = cols;
                phi_421_ = (_e197 >= _e198);
            }
            let _e201 = phi_421_;
            phi_429_ = _e201;
            if !(_e201) {
                let _e204 = c_2[1u];
                let _e205 = rows;
                phi_429_ = (_e204 >= _e205);
            }
            let _e208 = phi_429_;
            if _e208 {
                continue;
            }
            let _e209 = c_2;
            center = (_e209 + vec2(0.5f));
            let _e212 = g;
            let _e213 = center;
            let _e215 = aspect_1;
            local_4 = ((_e212 - _e213) * vec2<f32>(_e215, 1f));
            let _e218 = c_2;
            param_5 = (_e218 + vec2<f32>(13f, 7f));
            let _e220 = hash((&param_5));
            h_1 = _e220;
            let _e222 = c_2[0u];
            let _e223 = cols;
            let _e227 = rows;
            let _e230 = c_2[1u];
            let _e232 = rows;
            diag = (((_e222 / max((_e223 - 1f), 1f)) + (((_e227 - 1f) - _e230) / max((_e232 - 1f), 1f))) * 0.5f);
            let _e238 = diag;
            let _e239 = h_1;
            let _e242 = diag;
            let _e244 = diag;
            delay = ((_e238 + (((1.2f * (_e239 - 0.5f)) * _e242) * (1f - _e244))) * 0.6f);
            let _e250 = uniforms.progress;
            let _e251 = delay;
            t = clamp(((_e250 - _e251) / 0.4f), 0f, 1f);
            let _e255 = local_4;
            param_6 = _e255;
            let _e256 = c_2;
            param_7 = _e256;
            let _e257 = grid_1;
            param_8 = _e257;
            let _e258 = aspect_1;
            param_9 = _e258;
            let _e259 = pieceDist((&param_6), (&param_7), (&param_8), (&param_9));
            d0_ = _e259;
            let _e260 = d0_;
            w = (1f - smoothstep(-0.01f, 0.01f, _e260));
            let _e263 = w;
            let _e264 = allSum;
            allSum = (_e264 + _e263);
            let _e266 = t;
            if (_e266 <= 0f) {
                let _e268 = w;
                let _e269 = boardSum;
                boardSum = (_e269 + _e268);
                let _e271 = seam;
                let _e272 = d0_;
                seam = min(_e271, abs(_e272));
                continue;
            }
            let _e275 = t;
            lift = smoothstep(0f, 0.25f, _e275);
            let _e277 = t;
            fall = clamp(((_e277 - 0.2f) / 0.8f), 0f, 1f);
            let _e281 = fall;
            let _e282 = fall;
            fall = (_e282 * _e281);
            let _e284 = fall;
            s = max((1f - _e284), 0.001f);
            let _e287 = h_1;
            let _e290 = fall;
            a = (((_e287 - 0.5f) * 3f) * _e290);
            let _e292 = fall;
            off = vec2<f32>(0f, (-1.2f * _e292));
            let _e295 = a;
            let _e297 = a;
            let _e300 = a;
            let _e302 = a;
            rot = mat2x2<f32>(vec2<f32>(cos(_e295), -(sin(_e297))), vec2<f32>(sin(_e300), cos(_e302)));
            let _e307 = rot;
            let _e308 = local_4;
            let _e309 = off;
            let _e312 = s;
            pl = ((_e307 * (_e308 - _e309)) / vec2(_e312));
            let _e315 = pl;
            param_10 = _e315;
            let _e316 = c_2;
            param_11 = _e316;
            let _e317 = grid_1;
            param_12 = _e317;
            let _e318 = aspect_1;
            param_13 = _e318;
            let _e319 = pieceDist((&param_10), (&param_11), (&param_12), (&param_13));
            dp = _e319;
            let _e320 = dp;
            let _e321 = s;
            let _e325 = s;
            cov = ((1f - smoothstep(-0.01f, 0.01f, (_e320 * _e321))) * min((_e325 * 20f), 1f));
            let _e329 = fall;
            let _e332 = lift;
            let _e334 = dp;
            shade = ((1f - (0.5f * _e329)) * (1f - ((0.3f * _e332) * (1f - smoothstep(0f, 0.035f, -(_e334))))));
            let _e341 = center;
            let _e342 = pl;
            let _e343 = aspect_1;
            let _e347 = grid_1;
            puv = ((_e341 + (_e342 / vec2<f32>(_e343, 1f))) / _e347);
            let _e349 = rot;
            let _e350 = local_4;
            let _e351 = off;
            let _e353 = lift;
            let _e357 = s;
            sl = ((_e349 * ((_e350 - _e351) - (vec2<f32>(0.08f, -0.1f) * _e353))) / vec2(_e357));
            let _e360 = sl;
            param_14 = _e360;
            let _e361 = c_2;
            param_15 = _e361;
            let _e362 = grid_1;
            param_16 = _e362;
            let _e363 = aspect_1;
            param_17 = _e363;
            let _e364 = pieceDist((&param_14), (&param_15), (&param_16), (&param_17));
            let _e365 = s;
            let _e369 = lift;
            let _e371 = fall;
            let _e375 = uniforms.shadow;
            sh = ((((1f - smoothstep(-0.05f, 0.12f, (_e364 * _e365))) * _e369) * (1f - _e371)) * _e375);
            let _e377 = shadowAll;
            let _e378 = sh;
            let _e379 = w;
            let _e380 = lift;
            let _e382 = t;
            let _e387 = uniforms.shadow;
            shadowAll = max(_e377, max(_e378, (((_e379 * _e380) * (1f - smoothstep(0.2f, 0.5f, _e382))) * _e387)));
            let _e391 = delay;
            prio = _e391;
            let _e392 = cov;
            let _e394 = prio;
            let _e395 = prio1_;
            if ((_e392 > 0f) && (_e394 > _e395)) {
                let _e398 = prio1_;
                prio2_ = _e398;
                let _e399 = cov1_;
                cov2_ = _e399;
                let _e400 = uv1_;
                uv2_ = _e400;
                let _e401 = shade1_;
                shade2_ = _e401;
                let _e402 = prio;
                prio1_ = _e402;
                let _e403 = cov;
                cov1_ = _e403;
                let _e404 = puv;
                uv1_ = _e404;
                let _e405 = shade;
                shade1_ = _e405;
            } else {
                let _e406 = cov;
                let _e408 = prio;
                let _e409 = prio2_;
                if ((_e406 > 0f) && (_e408 > _e409)) {
                    let _e412 = prio;
                    prio2_ = _e412;
                    let _e413 = cov;
                    cov2_ = _e413;
                    let _e414 = puv;
                    uv2_ = _e414;
                    let _e415 = shade;
                    shade2_ = _e415;
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e416 = i;
            i = (_e416 + 1i);
        }
    }
    let _e418 = (*uv_2);
    param_18 = _e418;
    let _e419 = getToColor((&param_18));
    let _e420 = (*uv_2);
    param_19 = _e420;
    let _e421 = getFromColor((&param_19));
    let _e422 = boardSum;
    let _e423 = allSum;
    base = mix(_e419, _e421, vec4((_e422 / max(_e423, 0.001f))));
    let _e428 = shadowAll;
    let _e431 = uniforms.progress;
    let _e434 = seam;
    let _e440 = base;
    let _e442 = (_e440.xyz * ((1f - _e428) * (1f - ((0.4f * smoothstep(0f, 0.1f, _e431)) * (1f - smoothstep(0f, 0.015f, _e434))))));
    base[0u] = _e442.x;
    base[1u] = _e442.y;
    base[2u] = _e442.z;
    let _e449 = uv2_;
    param_20 = _e449;
    let _e450 = getFromColor((&param_20));
    p2_ = _e450;
    let _e451 = shade2_;
    let _e452 = p2_;
    let _e454 = (_e452.xyz * _e451);
    p2_[0u] = _e454.x;
    p2_[1u] = _e454.y;
    p2_[2u] = _e454.z;
    let _e461 = uv1_;
    param_21 = _e461;
    let _e462 = getFromColor((&param_21));
    p1_ = _e462;
    let _e463 = shade1_;
    let _e464 = p1_;
    let _e466 = (_e464.xyz * _e463);
    p1_[0u] = _e466.x;
    p1_[1u] = _e466.y;
    p1_[2u] = _e466.z;
    let _e473 = base;
    let _e474 = p2_;
    let _e475 = cov2_;
    let _e478 = p1_;
    let _e479 = cov1_;
    return mix(mix(_e473, _e474, vec4(_e475)), _e478, vec4(_e479));
}

fn main_1() {
    var param_22: vec2<f32>;

    let _e63 = _uv_1;
    param_22 = _e63;
    let _e64 = transition((&param_22));
    _fragColor = _e64;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
