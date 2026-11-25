// CylinderRoll — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CylinderRoll.glsl
// Author: gre
// License: MIT
// Description: The frame wraps around a drum that rolls up, the outgoing image turning away over its top in a motion blur and the incoming one coming around from below and unrolling flat
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    curvature: f32,
    blur: f32,
    shading: f32,
    chroma: f32,
    downward: i32,
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
    let _e45 = (*uv)[0u];
    let _e47 = (*uv)[1u];
    let _e50 = textureSampleLevel(_from, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e45 = (*uv_1)[0u];
    let _e47 = (*uv_1)[1u];
    let _e50 = textureSampleLevel(_to, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn fold(v: ptr<function, f32>) -> f32 {
    let _e44 = (*v);
    return (1f - abs((1f - (_e44 - (floor((_e44 / 2f)) * 2f)))));
}

fn strip(x: ptr<function, f32>, v_1: ptr<function, f32>) -> vec4<f32> {
    var local: bool;
    var local_1: f32;
    var param: f32;
    var param_1: vec2<f32>;
    var param_2: f32;
    var param_3: vec2<f32>;

    let _e52 = uniforms.downward;
    if (_e52 != 0i) {
        let _e54 = (*v_1);
        local = (_e54 > 1f);
    } else {
        let _e56 = (*v_1);
        local = (_e56 < 0f);
    }
    let _e58 = local;
    if _e58 {
        let _e59 = (*x);
        let _e61 = uniforms.downward;
        if (_e61 != 0i) {
            let _e63 = (*v_1);
            local_1 = (_e63 - 1f);
        } else {
            let _e65 = (*v_1);
            local_1 = (_e65 + 1f);
        }
        let _e67 = local_1;
        param = _e67;
        let _e68 = fold((&param));
        param_1 = vec2<f32>(_e59, _e68);
        let _e70 = getToColor((&param_1));
        return _e70;
    }
    let _e71 = (*x);
    let _e72 = (*v_1);
    param_2 = _e72;
    let _e73 = fold((&param_2));
    param_3 = vec2<f32>(_e71, _e73);
    let _e75 = getFromColor((&param_3));
    return _e75;
}

fn hash(c: ptr<function, vec2<f32>>) -> f32 {
    var q: vec2<f32>;

    let _e45 = (*c);
    q = fract((_e45 * vec2<f32>(0.1031f, 0.103f)));
    let _e48 = q;
    let _e49 = q;
    let _e54 = q;
    q = (_e54 + vec2(dot(_e48, (_e49.yx + vec2(33.33f)))));
    let _e58 = q[0u];
    let _e60 = q[1u];
    let _e63 = q[0u];
    return fract(((_e58 + _e60) * _e63));
}

fn angleAt(c_1: ptr<function, f32>) -> f32 {
    let _e44 = (*c_1);
    (*c_1) = clamp(_e44, -0.40833333f, 0.40833333f);
    let _e46 = (*c_1);
    let _e48 = (*c_1);
    let _e49 = (*c_1);
    let _e55 = (*c_1);
    return (asin(((_e46 * 2.6f) / sqrt((1f + (_e48 * _e49))))) - atan(_e55));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var h: f32;
    var e: f32;
    var roll: f32;
    var local_2: f32;
    var h3_: f32;
    var peak: f32;
    var bend: f32;
    var local_3: f32;
    var phi: f32;
    var arcK: f32;
    var edgeY: f32;
    var n: vec2<f32>;
    var xr: f32;
    var yn: f32;
    var theta: f32;
    var param_4: f32;
    var thetaCorner: f32;
    var param_5: f32;
    var width: f32;
    var zoom: f32;
    var x_1: f32;
    var facing: f32;
    var light: f32;
    var v_2: f32;
    var local_4: f32;
    var len: f32;
    var split: f32;
    var jitter: f32;
    var param_6: vec2<f32>;
    var color: vec3<f32>;
    var weight: vec3<f32>;
    var alpha: f32;
    var i: i32;
    var t: f32;
    var img: vec4<f32>;
    var param_7: f32;
    var param_8: f32;
    var w: vec3<f32>;

    let _e84 = uniforms.progress;
    p = _e84;
    let _e85 = p;
    h = (1f - abs(((2f * _e85) - 1f)));
    let _e90 = h;
    let _e92 = h;
    let _e94 = h;
    e = ((0.5f * _e90) * (0.1f + ((0.9f * _e92) * _e94)));
    let _e98 = p;
    if (_e98 < 0.5f) {
        let _e100 = e;
        local_2 = _e100;
    } else {
        let _e101 = e;
        local_2 = (1f - _e101);
    }
    let _e103 = local_2;
    roll = _e103;
    let _e104 = h;
    let _e105 = h;
    let _e107 = h;
    h3_ = ((_e104 * _e105) * _e107);
    let _e109 = h3_;
    let _e110 = h3_;
    peak = (_e109 * _e110);
    let _e113 = uniforms.curvature;
    let _e114 = p;
    if (_e114 < 0.5f) {
        let _e116 = h;
        let _e117 = h;
        local_3 = (_e116 * (2f - _e117));
    } else {
        let _e120 = h;
        let _e121 = h;
        let _e123 = h;
        local_3 = ((_e120 * _e121) * (3f - (2f * _e123)));
    }
    let _e127 = local_3;
    bend = (_e113 * _e127);
    let _e129 = bend;
    phi = ((1.1f * _e129) + 0.0001f);
    let _e132 = bend;
    arcK = (0.12f * _e132);
    let _e134 = phi;
    let _e136 = phi;
    edgeY = (sin(_e134) / (2.6f - cos(_e136)));
    let _e140 = (*uv_2);
    n = ((_e140 * 2f) - vec2(1f));
    let _e145 = n[0u];
    let _e147 = uniforms.ratio;
    xr = (_e145 * _e147);
    let _e150 = n[1u];
    let _e151 = arcK;
    let _e152 = xr;
    let _e154 = xr;
    yn = (_e150 * (1f + ((_e151 * _e152) * _e154)));
    let _e158 = yn;
    let _e159 = edgeY;
    param_4 = (_e158 * _e159);
    let _e161 = angleAt((&param_4));
    theta = _e161;
    let _e162 = arcK;
    let _e164 = uniforms.ratio;
    let _e167 = uniforms.ratio;
    let _e170 = edgeY;
    param_5 = ((1f + ((_e162 * _e164) * _e167)) * _e170);
    let _e172 = angleAt((&param_5));
    thetaCorner = _e172;
    let _e173 = theta;
    width = (1.6f / (2.6f - cos(_e173)));
    let _e177 = thetaCorner;
    zoom = ((2.6f - cos(_e177)) / 1.6f);
    let _e182 = n[0u];
    let _e184 = zoom;
    let _e185 = width;
    x_1 = (0.5f + ((0.5f * _e182) / (_e184 * _e185)));
    let _e189 = theta;
    let _e193 = theta;
    facing = (((2.6f * cos(_e189)) - 1f) / sqrt((7.76f - (5.2f * cos(_e193)))));
    let _e199 = facing;
    let _e202 = uniforms.shading;
    light = mix(1f, clamp(_e199, 0f, 1f), _e202);
    let _e204 = theta;
    let _e205 = phi;
    let _e210 = uniforms.downward;
    if (_e210 != 0i) {
        let _e212 = roll;
        local_4 = _e212;
    } else {
        let _e213 = roll;
        local_4 = -(_e213);
    }
    let _e215 = local_4;
    v_2 = ((0.5f * ((_e204 / _e205) + 1f)) + _e215);
    let _e218 = uniforms.blur;
    let _e220 = peak;
    len = ((0.5f * _e218) * _e220);
    let _e223 = uniforms.chroma;
    let _e224 = peak;
    split = (_e223 * _e224);
    let _e226 = (*uv_2);
    param_6 = (_e226 * 1000f);
    let _e228 = hash((&param_6));
    jitter = _e228;
    color = vec3<f32>(0f, 0f, 0f);
    weight = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    i = 0i;
    loop {
        let _e229 = i;
        if (_e229 < 24i) {
            let _e231 = i;
            let _e233 = jitter;
            t = (((f32(_e231) + _e233) / 24f) - 0.5f);
            let _e237 = v_2;
            let _e238 = t;
            let _e239 = len;
            let _e242 = x_1;
            param_7 = _e242;
            param_8 = (_e237 + (_e238 * _e239));
            let _e243 = strip((&param_7), (&param_8));
            img = _e243;
            let _e244 = split;
            let _e246 = t;
            let _e250 = split;
            let _e252 = t;
            w = vec3<f32>(max((1f - ((4f * _e244) * _e246)), 0f), 1f, max((1f + ((4f * _e250) * _e252)), 0f));
            let _e257 = img;
            let _e260 = img[3u];
            let _e262 = w;
            let _e264 = color;
            color = (_e264 + ((_e257.xyz * _e260) * _e262));
            let _e267 = img[3u];
            let _e268 = w;
            let _e270 = weight;
            weight = (_e270 + (_e268 * _e267));
            let _e273 = img[3u];
            let _e274 = alpha;
            alpha = (_e274 + _e273);
            continue;
        } else {
            break;
        }
        continuing {
            let _e276 = i;
            i = (_e276 + 1i);
        }
    }
    let _e278 = color;
    let _e279 = weight;
    color = (_e278 / max(_e279, vec3<f32>(0.00001f, 0.00001f, 0.00001f)));
    let _e282 = color;
    let _e283 = light;
    let _e284 = (_e282 * _e283);
    let _e285 = alpha;
    return vec4<f32>(_e284.x, _e284.y, _e284.z, (_e285 / 24f));
}

fn main_1() {
    var param_9: vec2<f32>;

    let _e44 = _uv_1;
    param_9 = _e44;
    let _e45 = transition((&param_9));
    _fragColor = _e45;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
