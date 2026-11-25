// WhipSpin — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WhipSpin.glsl
// Author: gre
// License: MIT
// Description: The camera rolls faster and faster around the center of the frame, streaking the outgoing image in a spin blur, then the incoming one takes over mid-spin and slows to a stop
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    turns: f32,
    blur: f32,
    chroma: f32,
    zoom: f32,
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
    let _e36 = (*uv)[0u];
    let _e38 = (*uv)[1u];
    let _e41 = textureSampleLevel(_to, _sampler, vec2<f32>(_e36, (1f - _e38)), 0f);
    return _e41;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e36 = (*uv_1)[0u];
    let _e38 = (*uv_1)[1u];
    let _e41 = textureSampleLevel(_from, _sampler, vec2<f32>(_e36, (1f - _e38)), 0f);
    return _e41;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    var m: vec2<f32>;

    let _e36 = (*v);
    let _e37 = vec2(2f);
    m = (_e36 - (floor((_e36 / _e37)) * _e37));
    let _e42 = m;
    let _e43 = m;
    let _e46 = m;
    return mix(_e42, (vec2(2f) - _e43), step(vec2(1f), _e46));
}

fn rollAngle(t: ptr<function, f32>) -> f32 {
    var halfTurn: f32;
    var x: f32;
    var x_1: f32;

    let _e39 = uniforms.turns;
    halfTurn = (3.1415927f * _e39);
    let _e41 = (*t);
    if (_e41 < 0.5f) {
        let _e43 = (*t);
        x = (2f * _e43);
        let _e45 = halfTurn;
        let _e46 = x;
        let _e48 = x;
        let _e50 = x;
        return (((_e45 * _e46) * _e48) * _e50);
    }
    let _e52 = (*t);
    x_1 = (2f - (2f * _e52));
    let _e55 = halfTurn;
    let _e57 = x_1;
    let _e59 = x_1;
    let _e61 = x_1;
    return (((-(_e55) * _e57) * _e59) * _e61);
}

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e36 = (*p);
    p3_ = fract((_e36.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e40 = p3_;
    let _e41 = p3_;
    let _e46 = p3_;
    p3_ = (_e46 + vec3(dot(_e40, (_e41.yzx + vec3(33.33f)))));
    let _e50 = p3_[0u];
    let _e52 = p3_[1u];
    let _e55 = p3_[2u];
    return fract(((_e50 + _e52) * _e55));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_1: f32;
    var h: f32;
    var shutter: f32;
    var scale: f32;
    var q: vec2<f32>;
    var jitter: f32;
    var param: vec2<f32>;
    var color: vec3<f32>;
    var weight: vec3<f32>;
    var alpha: f32;
    var i: i32;
    var s: f32;
    var t_1: f32;
    var a: f32;
    var param_1: f32;
    var c: f32;
    var sn: f32;
    var r: vec2<f32>;
    var suv: vec2<f32>;
    var param_2: vec2<f32>;
    var col: vec4<f32>;
    var local: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var w: vec3<f32>;

    let _e61 = uniforms.progress;
    p_1 = _e61;
    let _e62 = p_1;
    h = (1f - abs(((2f * _e62) - 1f)));
    let _e68 = uniforms.blur;
    let _e70 = h;
    shutter = ((_e68 * 0.1f) * _e70);
    let _e73 = uniforms.zoom;
    let _e74 = h;
    let _e76 = h;
    let _e78 = h;
    scale = (1f + (((_e73 * _e74) * _e76) * _e78));
    let _e81 = (*uv_2);
    let _e85 = uniforms.ratio;
    q = ((_e81 - vec2(0.5f)) * vec2<f32>(_e85, 1f));
    let _e88 = (*uv_2);
    let _e90 = uniforms.ratio;
    param = ((_e88 * vec2<f32>(_e90, 1f)) * 731f);
    let _e94 = hash((&param));
    jitter = _e94;
    color = vec3<f32>(0f, 0f, 0f);
    weight = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    i = 0i;
    loop {
        let _e95 = i;
        if (_e95 < 24i) {
            let _e97 = i;
            let _e99 = jitter;
            s = (((f32(_e97) + _e99) / 24f) - 0.5f);
            let _e103 = p_1;
            let _e104 = s;
            let _e105 = shutter;
            t_1 = clamp((_e103 + (_e104 * _e105)), 0f, 1f);
            let _e109 = t_1;
            param_1 = _e109;
            let _e110 = rollAngle((&param_1));
            a = _e110;
            let _e111 = a;
            c = cos(_e111);
            let _e113 = a;
            sn = sin(_e113);
            let _e115 = c;
            let _e117 = q[0u];
            let _e119 = sn;
            let _e121 = q[1u];
            let _e124 = sn;
            let _e127 = q[0u];
            let _e129 = c;
            let _e131 = q[1u];
            let _e135 = scale;
            r = (vec2<f32>(((_e115 * _e117) + (_e119 * _e121)), ((-(_e124) * _e127) + (_e129 * _e131))) / vec2(_e135));
            let _e138 = r;
            let _e140 = uniforms.ratio;
            param_2 = ((_e138 / vec2<f32>(_e140, 1f)) + vec2(0.5f));
            let _e145 = mirror((&param_2));
            suv = _e145;
            let _e146 = t_1;
            if (_e146 < 0.5f) {
                let _e148 = suv;
                param_3 = _e148;
                let _e149 = getFromColor((&param_3));
                local = _e149;
            } else {
                let _e150 = suv;
                param_4 = _e150;
                let _e151 = getToColor((&param_4));
                local = _e151;
            }
            let _e152 = local;
            col = _e152;
            let _e154 = uniforms.chroma;
            let _e156 = s;
            let _e160 = uniforms.chroma;
            let _e162 = s;
            w = max(vec3<f32>((1f - ((4f * _e154) * _e156)), 1f, (1f + ((4f * _e160) * _e162))), vec3(0f));
            let _e168 = col;
            let _e171 = col[3u];
            let _e173 = w;
            let _e175 = color;
            color = (_e175 + ((_e168.xyz * _e171) * _e173));
            let _e178 = col[3u];
            let _e179 = w;
            let _e181 = weight;
            weight = (_e181 + (_e179 * _e178));
            let _e184 = col[3u];
            let _e185 = alpha;
            alpha = (_e185 + _e184);
            continue;
        } else {
            break;
        }
        continuing {
            let _e187 = i;
            i = (_e187 + 1i);
        }
    }
    let _e189 = color;
    let _e190 = weight;
    let _e192 = (_e189 / max(_e190, vec3<f32>(0.00001f, 0.00001f, 0.00001f)));
    let _e193 = alpha;
    return vec4<f32>(_e192.x, _e192.y, _e192.z, (_e193 / 24f));
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e35 = _uv_1;
    param_5 = _e35;
    let _e36 = transition((&param_5));
    _fragColor = _e36;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
