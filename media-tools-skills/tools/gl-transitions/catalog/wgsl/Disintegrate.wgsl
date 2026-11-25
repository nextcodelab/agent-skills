// Disintegrate — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Disintegrate.glsl
// Author: gre
// License: MIT
// Description: The outgoing image crumbles into fine dust from one side, its grains blown away by the wind and fading out, revealing the incoming image underneath
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    particleSize: f32,
    direction: vec2<f32>,
    spread: f32,
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

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e56 = (*p);
    p3_ = fract((_e56.xyx * 0.1031f));
    let _e60 = p3_;
    let _e61 = p3_;
    let _e66 = p3_;
    p3_ = (_e66 + vec3(dot(_e60, (_e61.yzx + vec3(33.33f)))));
    let _e70 = p3_[0u];
    let _e72 = p3_[1u];
    let _e75 = p3_[2u];
    return fract(((_e70 + _e72) * _e75));
}

fn gust(x: ptr<function, f32>) -> f32 {
    var i: f32;
    var f: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e59 = (*x);
    i = floor(_e59);
    let _e61 = (*x);
    f = fract(_e61);
    let _e63 = f;
    let _e64 = f;
    let _e66 = f;
    f = ((_e63 * _e64) * (3f - (2f * _e66)));
    let _e70 = i;
    param = vec2<f32>(_e70, 7f);
    let _e72 = hash12((&param));
    let _e73 = i;
    param_1 = vec2<f32>((_e73 + 1f), 7f);
    let _e76 = hash12((&param_1));
    let _e77 = f;
    return ((2f * mix(_e72, _e76, _e77)) - 1f);
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e56 = (*uv)[0u];
    let _e58 = (*uv)[1u];
    let _e61 = textureSampleLevel(_from, _sampler, vec2<f32>(_e56, (1f - _e58)), 0f);
    return _e61;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e56 = (*uv_1)[0u];
    let _e58 = (*uv_1)[1u];
    let _e61 = textureSampleLevel(_to, _sampler, vec2<f32>(_e56, (1f - _e58)), 0f);
    return _e61;
}

fn noise(p_1: ptr<function, vec2<f32>>) -> f32 {
    var i_1: vec2<f32>;
    var f_1: vec2<f32>;
    var a: f32;
    var param_2: vec2<f32>;
    var b: f32;
    var param_3: vec2<f32>;
    var c: f32;
    var param_4: vec2<f32>;
    var d: f32;
    var param_5: vec2<f32>;

    let _e65 = (*p_1);
    i_1 = floor(_e65);
    let _e67 = (*p_1);
    f_1 = fract(_e67);
    let _e69 = f_1;
    let _e70 = f_1;
    let _e72 = f_1;
    f_1 = ((_e69 * _e70) * (vec2(3f) - (_e72 * 2f)));
    let _e77 = i_1;
    param_2 = _e77;
    let _e78 = hash12((&param_2));
    a = _e78;
    let _e79 = i_1;
    param_3 = (_e79 + vec2<f32>(1f, 0f));
    let _e81 = hash12((&param_3));
    b = _e81;
    let _e82 = i_1;
    param_4 = (_e82 + vec2<f32>(0f, 1f));
    let _e84 = hash12((&param_4));
    c = _e84;
    let _e85 = i_1;
    param_5 = (_e85 + vec2<f32>(1f, 1f));
    let _e87 = hash12((&param_5));
    d = _e87;
    let _e88 = a;
    let _e89 = b;
    let _e91 = f_1[0u];
    let _e93 = c;
    let _e94 = d;
    let _e96 = f_1[0u];
    let _e99 = f_1[1u];
    return ((2f * mix(mix(_e88, _e89, _e91), mix(_e93, _e94, _e96), _e99)) - 1f);
}

fn release(center: ptr<function, vec2<f32>>, h: ptr<function, f32>, halfLength: ptr<function, f32>, s: ptr<function, f32>) -> f32 {
    var front: f32;
    var param_6: vec2<f32>;

    let _e61 = (*center)[0u];
    let _e62 = (*halfLength);
    let _e64 = (*halfLength);
    let _e68 = (*center);
    let _e69 = (*s);
    param_6 = ((_e68 * _e69) * 6f);
    let _e72 = noise((&param_6));
    let _e75 = (*h);
    front = (((1f - ((_e61 + _e62) / (2f * _e64))) + (0.14f * _e72)) + (0.08f * (_e75 - 0.5f)));
    let _e79 = front;
    return (clamp(((_e79 + 0.12f) / 1.24f), 0f, 1f) * 0.55f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var d_1: vec2<f32>;
    var local: vec2<f32>;
    var n: vec2<f32>;
    var fp: vec2<f32>;
    var s_1: f32;
    var g: vec2<f32>;
    var halfLength_1: f32;
    var reach: f32;
    var px: f32;
    var own: vec2<f32>;
    var under: vec4<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var local_1: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var grainUV: vec2<f32>;
    var cover: f32;
    var i_2: i32;
    var fi: f32;
    var cx: f32;
    var visible: f32;
    var local_2: f32;
    var drift: f32;
    var param_14: f32;
    var cell: vec2<f32>;
    var center_1: vec2<f32>;
    var cuv: vec2<f32>;
    var h_1: f32;
    var param_15: vec2<f32>;
    var t: f32;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;
    var r2_: f32;
    var travel: f32;
    var crumble: f32;
    var pos: vec2<f32>;
    var local_3: vec2<f32>;
    var size: f32;
    var feather: f32;
    var a_1: f32;
    var param_20: vec2<f32>;
    var phi_461_: bool;
    var phi_468_: bool;
    var phi_475_: bool;

    let _e103 = uniforms.direction;
    if (length(_e103) > 0f) {
        let _e107 = uniforms.direction;
        local = normalize(_e107);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e109 = local;
    d_1 = _e109;
    let _e111 = d_1[1u];
    let _e114 = d_1[0u];
    n = vec2<f32>(-(_e111), _e114);
    let _e116 = (*uv_2);
    let _e120 = uniforms.ratio;
    fp = ((_e116 - vec2(0.5f)) * vec2<f32>(_e120, 1f));
    let _e124 = uniforms.particleSize;
    s_1 = _e124;
    let _e125 = fp;
    let _e126 = d_1;
    let _e128 = fp;
    let _e129 = n;
    let _e132 = s_1;
    g = (vec2<f32>(dot(_e125, _e126), dot(_e128, _e129)) / vec2(_e132));
    let _e136 = uniforms.ratio;
    let _e138 = d_1[0u];
    let _e142 = d_1[1u];
    let _e146 = s_1;
    halfLength_1 = ((0.5f * ((_e136 * abs(_e138)) + abs(_e142))) / _e146);
    let _e149 = uniforms.spread;
    let _e151 = s_1;
    reach = min(((_e149 * 0.45f) / _e151), 60f);
    let _e155 = g[0u];
    px = floor(_e155);
    let _e157 = g;
    own = floor(_e157);
    let _e160 = uniforms.progress;
    let _e161 = own;
    let _e164 = own;
    param_7 = _e164;
    let _e165 = hash12((&param_7));
    param_8 = (_e161 + vec2(0.5f));
    param_9 = _e165;
    let _e166 = halfLength_1;
    param_10 = _e166;
    let _e167 = s_1;
    param_11 = _e167;
    let _e168 = release((&param_8), (&param_9), (&param_10), (&param_11));
    if (_e160 > _e168) {
        let _e170 = (*uv_2);
        param_12 = _e170;
        let _e171 = getToColor((&param_12));
        local_1 = _e171;
    } else {
        let _e172 = (*uv_2);
        param_13 = _e172;
        let _e173 = getFromColor((&param_13));
        local_1 = _e173;
    }
    let _e174 = local_1;
    under = _e174;
    grainUV = vec2<f32>(0.5f, 0.5f);
    cover = 0f;
    i_2 = 0i;
    loop {
        let _e175 = i_2;
        if (_e175 < 35i) {
            let _e177 = i_2;
            fi = f32(_e177);
            let _e179 = px;
            let _e180 = fi;
            cx = (_e179 - _e180);
            let _e182 = i_2;
            if (_e182 >= 26i) {
                let _e184 = px;
                let _e188 = fi;
                cx = ((floor((_e184 / 4f)) * 4f) - (4f * ((_e188 - 26f) + 8f)));
            } else {
                let _e193 = i_2;
                if (_e193 >= 17i) {
                    let _e195 = px;
                    let _e199 = fi;
                    cx = ((floor((_e195 / 2f)) * 2f) - (2f * ((_e199 - 17f) + 8f)));
                }
            }
            let _e204 = cx;
            if ((_e204 - (floor((_e204 / 4f)) * 4f)) < 0.5f) {
                local_2 = 63f;
            } else {
                let _e210 = cx;
                local_2 = select(15f, 31f, ((_e210 - (floor((_e210 / 2f)) * 2f)) < 0.5f));
            }
            let _e217 = local_2;
            visible = _e217;
            let _e218 = cx;
            let _e219 = s_1;
            param_14 = ((_e218 * _e219) * 4f);
            let _e222 = gust((&param_14));
            drift = (0.3f * _e222);
            let _e224 = cx;
            let _e226 = g[1u];
            let _e227 = drift;
            let _e229 = g[0u];
            let _e230 = cx;
            cell = vec2<f32>(_e224, floor((_e226 - (_e227 * ((_e229 - _e230) - 0.5f)))));
            let _e237 = cell;
            center_1 = (_e237 + vec2(0.5f));
            let _e241 = center_1[0u];
            let _e242 = d_1;
            let _e245 = center_1[1u];
            let _e246 = n;
            let _e249 = s_1;
            let _e252 = uniforms.ratio;
            cuv = (((((_e242 * _e241) + (_e246 * _e245)) * _e249) / vec2<f32>(_e252, 1f)) + vec2(0.5f));
            let _e258 = cuv[0u];
            let _e259 = (_e258 < 0f);
            phi_461_ = _e259;
            if !(_e259) {
                let _e262 = cuv[0u];
                phi_461_ = (_e262 > 1f);
            }
            let _e265 = phi_461_;
            phi_468_ = _e265;
            if !(_e265) {
                let _e268 = cuv[1u];
                phi_468_ = (_e268 < 0f);
            }
            let _e271 = phi_468_;
            phi_475_ = _e271;
            if !(_e271) {
                let _e274 = cuv[1u];
                phi_475_ = (_e274 > 1f);
            }
            let _e277 = phi_475_;
            if _e277 {
                continue;
            }
            let _e278 = cell;
            param_15 = _e278;
            let _e279 = hash12((&param_15));
            h_1 = _e279;
            let _e281 = uniforms.progress;
            let _e282 = center_1;
            param_16 = _e282;
            let _e283 = h_1;
            param_17 = _e283;
            let _e284 = halfLength_1;
            param_18 = _e284;
            let _e285 = s_1;
            param_19 = _e285;
            let _e286 = release((&param_16), (&param_17), (&param_18), (&param_19));
            t = ((_e281 - _e286) / 0.45f);
            let _e289 = t;
            let _e291 = t;
            if ((_e289 <= 0f) || (_e291 >= 1f)) {
                continue;
            }
            let _e294 = h_1;
            r2_ = fract((_e294 * 13.7f));
            let _e297 = reach;
            let _e298 = r2_;
            let _e302 = t;
            let _e304 = t;
            travel = (((_e297 * (0.4f + (0.6f * _e298))) * _e302) * (0.2f + (0.8f * _e304)));
            let _e308 = t;
            crumble = smoothstep(0f, 0.25f, _e308);
            let _e310 = center_1;
            let _e311 = travel;
            let _e312 = h_1;
            let _e317 = crumble;
            let _e320 = drift;
            let _e321 = travel;
            pos = (_e310 + vec2<f32>((_e311 + (((fract((_e312 * 71.1f)) - 0.5f) * 0.3f) * _e317)), (_e320 * _e321)));
            let _e325 = g;
            let _e326 = pos;
            local_3 = abs((_e325 - _e326));
            let _e329 = t;
            let _e333 = h_1;
            let _e337 = crumble;
            size = mix(0.5f, ((0.3f * (1f - (0.5f * _e329))) * (0.6f + (0.4f * _e333))), _e337);
            let _e339 = crumble;
            feather = (0.001f + (0.12f * _e339));
            let _e342 = size;
            let _e343 = feather;
            let _e345 = size;
            let _e347 = local_3[0u];
            let _e349 = local_3[1u];
            let _e353 = t;
            let _e357 = visible;
            let _e359 = visible;
            let _e360 = travel;
            a_1 = (((1f - smoothstep((_e342 - _e343), _e345, max(_e347, _e349))) * (1f - smoothstep(0.15f, 1f, _e353))) * (1f - smoothstep((0.6f * _e357), _e359, _e360)));
            let _e364 = a_1;
            let _e365 = cover;
            if (_e364 > _e365) {
                let _e367 = a_1;
                cover = _e367;
                let _e368 = cuv;
                grainUV = _e368;
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e369 = i_2;
            i_2 = (_e369 + 1i);
        }
    }
    let _e371 = under;
    let _e372 = grainUV;
    param_20 = _e372;
    let _e373 = getFromColor((&param_20));
    let _e374 = cover;
    return mix(_e371, _e373, vec4(_e374));
}

fn main_1() {
    var param_21: vec2<f32>;

    let _e55 = _uv_1;
    param_21 = _e55;
    let _e56 = transition((&param_21));
    _fragColor = _e56;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
