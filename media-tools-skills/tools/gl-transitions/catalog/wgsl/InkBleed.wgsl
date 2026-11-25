// InkBleed — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InkBleed.glsl
// Author: gre
// License: MIT
// Description: The incoming image spreads over the outgoing one like drops of ink in water, blooming from a few points with curling, wispy edges and a darker rim, until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    drops: f32,
    tendrils: f32,
    rim: f32,
    seed: f32,
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
    let _e71 = (*uv)[0u];
    let _e73 = (*uv)[1u];
    let _e76 = textureSampleLevel(_from, _sampler, vec2<f32>(_e71, (1f - _e73)), 0f);
    return _e76;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e71 = (*uv_1)[0u];
    let _e73 = (*uv_1)[1u];
    let _e76 = textureSampleLevel(_to, _sampler, vec2<f32>(_e71, (1f - _e73)), 0f);
    return _e76;
}

fn fold(p: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e70 = (*p);
    let _e71 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e70 - (floor((_e70 / _e71)) * _e71)))));
}

fn hash(p_1: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e71 = (*p_1);
    p3_ = fract((_e71.xyx * 0.1031f));
    let _e75 = p3_;
    let _e76 = p3_;
    let _e81 = p3_;
    p3_ = (_e81 + vec3(dot(_e75, (_e76.yzx + vec3(33.33f)))));
    let _e85 = p3_[0u];
    let _e87 = p3_[1u];
    let _e90 = p3_[2u];
    return fract(((_e85 + _e87) * _e90));
}

fn vnoise(p_2: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e76 = (*p_2);
    i = floor(_e76);
    let _e78 = (*p_2);
    f = fract(_e78);
    let _e80 = f;
    let _e81 = f;
    let _e83 = f;
    f = ((_e80 * _e81) * (vec2(3f) - (_e83 * 2f)));
    let _e88 = i;
    param = _e88;
    let _e89 = hash((&param));
    let _e90 = i;
    param_1 = (_e90 + vec2<f32>(1f, 0f));
    let _e92 = hash((&param_1));
    let _e94 = f[0u];
    let _e96 = i;
    param_2 = (_e96 + vec2<f32>(0f, 1f));
    let _e98 = hash((&param_2));
    let _e99 = i;
    param_3 = (_e99 + vec2<f32>(1f, 1f));
    let _e101 = hash((&param_3));
    let _e103 = f[0u];
    let _e106 = f[1u];
    return mix(mix(_e89, _e92, _e94), mix(_e98, _e101, _e103), _e106);
}

fn fbm(p_3: ptr<function, vec2<f32>>) -> f32 {
    var v: f32;
    var a: f32;
    var i_1: i32;
    var param_4: vec2<f32>;

    v = 0f;
    a = 0.5f;
    i_1 = 0i;
    loop {
        let _e74 = i_1;
        if (_e74 < 4i) {
            let _e76 = a;
            let _e77 = (*p_3);
            param_4 = _e77;
            let _e78 = vnoise((&param_4));
            let _e80 = v;
            v = (_e80 + (_e76 * _e78));
            let _e82 = (*p_3);
            (*p_3) = ((mat2x2<f32>(vec2<f32>(1.6f, 1.2f), vec2<f32>(-1.2f, 1.6f)) * _e82) + vec2(7.3f));
            let _e86 = a;
            a = (_e86 * 0.5f);
            continue;
        } else {
            break;
        }
        continuing {
            let _e88 = i_1;
            i_1 = (_e88 + 1i);
        }
    }
    let _e90 = v;
    return (_e90 / 0.9375f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_4: f32;
    var q: vec2<f32>;
    var o: vec2<f32>;
    var sq: vec2<f32>;
    var w1_: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var w2_: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var swirl: f32;
    var param_9: vec2<f32>;
    var flow: vec2<f32>;
    var amp: f32;
    var n: f32;
    var rimW: f32;
    var feather: f32;
    var margin: f32;
    var f_1: f32;
    var fs: f32;
    var i_2: i32;
    var fi: f32;
    var hs: vec2<f32>;
    var c: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var start: f32;
    var s: f32;
    var m: vec2<f32>;
    var far: f32;
    var s3_: f32;
    var r: f32;
    var reach: f32;
    var g: f32;
    var aa: f32;
    var inside: f32;
    var wisp: f32;
    var param_12: vec2<f32>;
    var soft: f32;
    var haze: f32;
    var cover: f32;
    var edge: f32;
    var to: vec4<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;

    let _e117 = uniforms.progress;
    p_4 = _e117;
    let _e119 = (*uv_2)[0u];
    let _e121 = uniforms.ratio;
    let _e124 = (*uv_2)[1u];
    q = vec2<f32>((_e119 * _e121), _e124);
    let _e127 = uniforms.seed;
    let _e130 = uniforms.seed;
    o = vec2<f32>((_e127 * 3.1f), (_e130 * 1.7f));
    let _e133 = q;
    let _e135 = o;
    sq = ((_e133 * 2.2f) + _e135);
    let _e137 = sq;
    let _e138 = p_4;
    param_5 = (_e137 + vec2<f32>(0f, (0.6f * _e138)));
    let _e142 = fbm((&param_5));
    let _e143 = sq;
    let _e145 = p_4;
    param_6 = ((_e143 + vec2<f32>(5.2f, 1.3f)) - vec2<f32>((0.5f * _e145), 0f));
    let _e149 = fbm((&param_6));
    w1_ = vec2<f32>(_e142, _e149);
    let _e151 = sq;
    let _e152 = w1_;
    param_7 = ((_e151 + (_e152 * 3f)) + vec2<f32>(1.7f, 9.2f));
    let _e156 = fbm((&param_7));
    let _e157 = sq;
    let _e158 = w1_;
    param_8 = ((_e157 + (_e158 * 3f)) + vec2<f32>(8.3f, 2.8f));
    let _e162 = fbm((&param_8));
    w2_ = vec2<f32>(_e156, _e162);
    let _e164 = sq;
    let _e166 = w2_;
    param_9 = ((_e164 * 0.8f) + (_e166 * 2.5f));
    let _e169 = fbm((&param_9));
    swirl = (_e169 - 0.5f);
    let _e171 = w2_;
    flow = (_e171 - vec2(0.5f));
    let _e175 = uniforms.tendrils;
    amp = (0.05f + (0.35f * _e175));
    let _e179 = uniforms.drops;
    n = clamp(floor((_e179 + 0.5f)), 1f, 8f);
    rimW = 0.1f;
    feather = 0.05f;
    let _e183 = amp;
    let _e185 = rimW;
    margin = (((1.2f * _e183) + _e185) + 0.08f);
    f_1 = -1000f;
    fs = -1000f;
    i_2 = 0i;
    loop {
        let _e188 = i_2;
        if (_e188 < 8i) {
            let _e190 = i_2;
            fi = f32(_e190);
            let _e192 = fi;
            let _e193 = n;
            if (_e192 < _e193) {
                let _e195 = fi;
                let _e198 = uniforms.seed;
                let _e200 = fi;
                let _e203 = uniforms.seed;
                hs = vec2<f32>(((_e195 * 7.13f) + _e198), ((_e200 * 3.71f) - _e203));
                let _e206 = hs;
                param_10 = _e206;
                let _e207 = hash((&param_10));
                let _e210 = uniforms.ratio;
                let _e212 = hs;
                param_11 = (_e212 + vec2(19.7f));
                let _e215 = hash((&param_11));
                c = vec2<f32>((mix(0.15f, 0.85f, _e207) * _e210), mix(0.15f, 0.85f, _e215));
                let _e218 = fi;
                let _e220 = n;
                start = ((0.2f * _e218) / _e220);
                let _e222 = p_4;
                let _e223 = start;
                let _e225 = start;
                s = clamp(((_e222 - _e223) / (1f - _e225)), 0f, 1f);
                let _e229 = c;
                let _e231 = uniforms.ratio;
                let _e233 = c;
                m = max(_e229, (vec2<f32>(_e231, 1f) - _e233));
                let _e236 = m;
                let _e238 = margin;
                far = (length(_e236) + _e238);
                let _e240 = s;
                let _e241 = s;
                let _e243 = s;
                s3_ = ((_e240 * _e241) * _e243);
                let _e245 = far;
                let _e247 = s;
                let _e249 = s3_;
                let _e251 = s3_;
                r = ((((_e245 + 0.02f) * _e247) * (0.35f + ((0.65f * _e249) * _e251))) - 0.02f);
                let _e256 = amp;
                let _e257 = r;
                reach = (_e256 * min(1f, (max(_e257, 0f) * 5f)));
                let _e262 = r;
                let _e263 = q;
                let _e264 = c;
                let _e266 = reach;
                let _e268 = flow;
                let _e273 = reach;
                let _e275 = swirl;
                g = ((_e262 - length(((_e263 - _e264) + (_e268 * (1.3f * _e266))))) + ((_e273 * 0.9f) * _e275));
                let _e278 = f_1;
                let _e279 = g;
                f_1 = max(_e278, _e279);
                let _e281 = fs;
                let _e282 = g;
                let _e283 = s;
                fs = max(_e281, (_e282 - (0.15f * (1f - min(1f, (_e283 * 12f))))));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e290 = i_2;
            i_2 = (_e290 + 1i);
        }
    }
    aa = 0.003f;
    let _e292 = aa;
    let _e294 = aa;
    let _e295 = f_1;
    inside = smoothstep(-(_e292), _e294, _e295);
    let _e297 = sq;
    let _e299 = w2_;
    param_12 = ((_e297 * 2f) + (_e299 * 5f));
    let _e302 = fbm((&param_12));
    wisp = (1f - smoothstep(0f, 0.08f, abs((_e302 - 0.5f))));
    let _e307 = feather;
    let _e309 = fs;
    let _e311 = wisp;
    soft = (smoothstep(-(_e307), 0f, _e309) * (0.35f + (0.4f * _e311)));
    let _e315 = wisp;
    let _e317 = fs;
    haze = ((0.35f * _e315) * (1f - smoothstep(0f, 0.1f, -(_e317))));
    let _e322 = inside;
    let _e323 = soft;
    let _e324 = haze;
    cover = max(_e322, max(_e323, _e324));
    let _e327 = rimW;
    let _e328 = f_1;
    edge = (1f - smoothstep(0f, _e327, _e328));
    let _e331 = (*uv_2);
    let _e332 = edge;
    let _e334 = flow;
    let _e337 = uniforms.ratio;
    param_13 = (_e331 - ((_e334 * (0.015f * _e332)) / vec2<f32>(_e337, 1f)));
    let _e341 = fold((&param_13));
    param_14 = _e341;
    let _e342 = getToColor((&param_14));
    to = _e342;
    let _e343 = to;
    let _e345 = to;
    let _e347 = to;
    let _e352 = uniforms.rim;
    let _e353 = edge;
    let _e356 = mix(_e343.xyz, ((_e345.xyz * _e347.xyz) * 0.7f), vec3((_e352 * _e353)));
    to[0u] = _e356.x;
    to[1u] = _e356.y;
    to[2u] = _e356.z;
    let _e363 = (*uv_2);
    param_15 = _e363;
    let _e364 = getFromColor((&param_15));
    let _e365 = to;
    let _e366 = cover;
    return mix(_e364, _e365, vec4(_e366));
}

fn main_1() {
    var param_16: vec2<f32>;

    let _e70 = _uv_1;
    param_16 = _e70;
    let _e71 = transition((&param_16));
    _fragColor = _e71;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
