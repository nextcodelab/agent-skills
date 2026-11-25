// SmokeDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SmokeDissolve.glsl
// Author: gre
// License: MIT
// Description: Billowing smoke drifts in across the outgoing image, with lit tops, darker folds and wispy edges, and thickens until it covers the frame; as it thins out and drifts away, the incoming image shows through
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    scale: f32,
    spread: f32,
    softness: f32,
    color: vec4<f32>,
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

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e67 = (*v);
    v3_ = fract((_e67.xyx * 0.1031f));
    let _e71 = v3_;
    let _e72 = v3_;
    let _e77 = v3_;
    v3_ = (_e77 + vec3(dot(_e71, (_e72.yzx + vec3(33.33f)))));
    let _e81 = v3_[0u];
    let _e83 = v3_[1u];
    let _e86 = v3_[2u];
    return fract(((_e81 + _e83) * _e86));
}

fn vnoise(v_1: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e72 = (*v_1);
    i = floor(_e72);
    let _e74 = (*v_1);
    f = fract(_e74);
    let _e76 = f;
    let _e77 = f;
    let _e79 = f;
    f = ((_e76 * _e77) * (vec2(3f) - (_e79 * 2f)));
    let _e84 = i;
    param = _e84;
    let _e85 = hash12((&param));
    let _e86 = i;
    param_1 = (_e86 + vec2<f32>(1f, 0f));
    let _e88 = hash12((&param_1));
    let _e90 = f[0u];
    let _e92 = i;
    param_2 = (_e92 + vec2<f32>(0f, 1f));
    let _e94 = hash12((&param_2));
    let _e95 = i;
    param_3 = (_e95 + vec2<f32>(1f, 1f));
    let _e97 = hash12((&param_3));
    let _e99 = f[0u];
    let _e102 = f[1u];
    return mix(mix(_e85, _e88, _e90), mix(_e94, _e97, _e99), _e102);
}

fn fbm(v_2: ptr<function, vec2<f32>>) -> f32 {
    var sum: f32;
    var amp: f32;
    var i_1: i32;
    var param_4: vec2<f32>;

    sum = 0f;
    amp = 0.5f;
    i_1 = 0i;
    loop {
        let _e70 = i_1;
        if (_e70 < 4i) {
            let _e72 = amp;
            let _e73 = (*v_2);
            param_4 = _e73;
            let _e74 = vnoise((&param_4));
            let _e76 = sum;
            sum = (_e76 + (_e72 * _e74));
            let _e78 = (*v_2);
            (*v_2) = ((mat2x2<f32>(vec2<f32>(1.6f, 1.2f), vec2<f32>(-1.2f, 1.6f)) * _e78) + vec2(5.3f));
            let _e82 = amp;
            amp = (_e82 * 0.5f);
            continue;
        } else {
            break;
        }
        continuing {
            let _e84 = i_1;
            i_1 = (_e84 + 1i);
        }
    }
    let _e86 = sum;
    return (_e86 / 0.9375f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e67 = (*uv)[0u];
    let _e69 = (*uv)[1u];
    let _e72 = textureSampleLevel(_to, _sampler, vec2<f32>(_e67, (1f - _e69)), 0f);
    return _e72;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e67 = (*uv_1)[0u];
    let _e69 = (*uv_1)[1u];
    let _e72 = textureSampleLevel(_from, _sampler, vec2<f32>(_e67, (1f - _e69)), 0f);
    return _e72;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var pos: vec2<f32>;
    var len: f32;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var ext: f32;
    var along: f32;
    var local_1: f32;
    var arrive: f32;
    var leave: f32;
    var body: f32;
    var m: f32;
    var local_2: vec4<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var q: vec2<f32>;
    var churn: vec2<f32>;
    var warp: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var w: vec2<f32>;
    var n: f32;
    var param_9: vec2<f32>;
    var lit: f32;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var wisp: f32;
    var param_12: vec2<f32>;
    var edge: f32;
    var d: f32;
    var base: vec4<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var a: vec4<f32>;
    var param_15: vec2<f32>;
    var b: vec4<f32>;
    var param_16: vec2<f32>;
    var local_3: vec4<f32>;
    var shade: f32;
    var smoke: vec3<f32>;

    let _e107 = uniforms.progress;
    p = _e107;
    let _e108 = (*uv_2);
    let _e112 = uniforms.ratio;
    pos = ((_e108 - vec2(0.5f)) * vec2<f32>(_e112, 1f));
    let _e116 = uniforms.direction;
    len = length(_e116);
    let _e118 = len;
    if (_e118 > 0.0001f) {
        let _e121 = uniforms.direction;
        let _e122 = len;
        local = (_e121 / vec2(_e122));
    } else {
        local = vec2<f32>(0f, 0f);
    }
    let _e125 = local;
    dir = _e125;
    let _e127 = dir[0u];
    let _e130 = uniforms.ratio;
    let _e133 = dir[1u];
    ext = ((0.5f * ((abs(_e127) * _e130) + abs(_e133))) + 0.0001f);
    let _e138 = len;
    if (_e138 > 0.0001f) {
        let _e140 = pos;
        let _e141 = dir;
        let _e144 = ext;
        local_1 = (0.5f + ((0.5f * dot(_e140, _e141)) / _e144));
    } else {
        local_1 = 0.5f;
    }
    let _e147 = local_1;
    along = _e147;
    let _e148 = p;
    let _e151 = uniforms.spread;
    let _e155 = uniforms.spread;
    let _e156 = along;
    arrive = (((_e148 / 0.45f) * (1f + _e151)) - (_e155 * _e156));
    let _e159 = p;
    let _e163 = uniforms.spread;
    let _e167 = uniforms.spread;
    let _e168 = along;
    leave = ((((_e159 - 0.55f) / 0.45f) * (1f + _e163)) - (_e167 * _e168));
    let _e171 = arrive;
    let _e173 = leave;
    body = (smoothstep(0f, 1f, _e171) * (1f - smoothstep(0f, 1f, _e173)));
    let _e177 = p;
    m = smoothstep(0.48f, 0.52f, _e177);
    let _e179 = body;
    if (_e179 <= 0f) {
        let _e181 = m;
        if (_e181 < 0.5f) {
            let _e183 = (*uv_2);
            param_5 = _e183;
            let _e184 = getFromColor((&param_5));
            local_2 = _e184;
        } else {
            let _e185 = (*uv_2);
            param_6 = _e185;
            let _e186 = getToColor((&param_6));
            local_2 = _e186;
        }
        let _e187 = local_2;
        return _e187;
    }
    let _e188 = pos;
    let _e190 = uniforms.direction;
    let _e191 = p;
    let _e196 = uniforms.scale;
    q = ((_e188 - (_e190 * (_e191 - 0.5f))) * _e196);
    let _e198 = p;
    let _e200 = p;
    churn = vec2<f32>((0.5f * _e198), (-0.35f * _e200));
    let _e203 = q;
    let _e205 = churn;
    param_7 = ((_e203 + vec2<f32>(3.1f, 1.7f)) + _e205);
    let _e207 = fbm((&param_7));
    let _e208 = q;
    let _e210 = churn;
    param_8 = ((_e208 + vec2<f32>(8.3f, 2.8f)) - _e210);
    let _e212 = fbm((&param_8));
    warp = vec2<f32>(_e207, _e212);
    let _e214 = q;
    let _e215 = warp;
    w = (_e214 + ((_e215 - vec2(0.5f)) * 1.1f));
    let _e220 = w;
    param_9 = _e220;
    let _e221 = fbm((&param_9));
    n = _e221;
    let _e222 = w;
    param_10 = _e222;
    let _e223 = vnoise((&param_10));
    let _e224 = w;
    param_11 = (_e224 + vec2<f32>(0f, 0.2f));
    let _e226 = vnoise((&param_11));
    lit = (0.53f * (_e223 - _e226));
    let _e229 = w;
    let _e231 = churn;
    param_12 = ((_e229 * 3.3f) - (_e231 * 2f));
    let _e234 = vnoise((&param_12));
    wisp = (_e234 - 0.5f);
    let _e236 = body;
    let _e238 = n;
    let _e242 = body;
    let _e244 = body;
    let _e247 = wisp;
    edge = (((2f * _e236) - (1f - smoothstep(0.1f, 0.6f, _e238))) + (((1.6f * _e242) * (1f - _e244)) * _e247));
    let _e251 = uniforms.softness;
    let _e252 = edge;
    let _e254 = body;
    d = (smoothstep(0f, _e251, _e252) * mix(0.5f, 1f, smoothstep(0.2f, 0.9f, _e254)));
    let _e258 = m;
    if (_e258 <= 0f) {
        let _e260 = (*uv_2);
        param_13 = _e260;
        let _e261 = getFromColor((&param_13));
        base = _e261;
    } else {
        let _e262 = m;
        if (_e262 >= 1f) {
            let _e264 = (*uv_2);
            param_14 = _e264;
            let _e265 = getToColor((&param_14));
            base = _e265;
        } else {
            let _e266 = (*uv_2);
            param_15 = _e266;
            let _e267 = getFromColor((&param_15));
            a = _e267;
            let _e268 = (*uv_2);
            param_16 = _e268;
            let _e269 = getToColor((&param_16));
            b = _e269;
            let _e270 = a;
            let _e273 = a[3u];
            let _e274 = (_e270.xyz * _e273);
            let _e276 = a[3u];
            let _e281 = b;
            let _e284 = b[3u];
            let _e285 = (_e281.xyz * _e284);
            let _e287 = b[3u];
            let _e292 = m;
            base = mix(vec4<f32>(_e274.x, _e274.y, _e274.z, _e276), vec4<f32>(_e285.x, _e285.y, _e285.z, _e287), vec4(_e292));
            let _e296 = base[3u];
            if (_e296 > 0f) {
                let _e298 = base;
                let _e301 = base[3u];
                let _e303 = (_e298.xyz / vec3(_e301));
                let _e305 = base[3u];
                local_3 = vec4<f32>(_e303.x, _e303.y, _e303.z, _e305);
            } else {
                local_3 = vec4<f32>(0f, 0f, 0f, 0f);
            }
            let _e310 = local_3;
            base = _e310;
        }
    }
    let _e311 = d;
    if (_e311 <= 0f) {
        let _e313 = base;
        return _e313;
    }
    let _e314 = lit;
    shade = (0.92f + (1.3f * _e314));
    let _e317 = n;
    let _e320 = shade;
    shade = (_e320 * mix(0.76f, 1.04f, smoothstep(0.25f, 0.75f, _e317)));
    let _e322 = shade;
    let _e323 = d;
    shade = mix(1f, _e322, (0.3f + (0.7f * _e323)));
    let _e328 = uniforms.color;
    let _e330 = shade;
    smoke = clamp((_e328.xyz * _e330), vec3(0f), vec3(1f));
    let _e335 = base;
    let _e336 = smoke;
    let _e339 = uniforms.color[3u];
    let _e344 = d;
    return mix(_e335, vec4<f32>(_e336.x, _e336.y, _e336.z, _e339), vec4(_e344));
}

fn main_1() {
    var param_17: vec2<f32>;

    let _e66 = _uv_1;
    param_17 = _e66;
    let _e67 = transition((&param_17));
    _fragColor = _e67;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
