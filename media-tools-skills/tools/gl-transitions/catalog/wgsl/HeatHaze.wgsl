// HeatHaze — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HeatHaze.glsl
// Author: gre
// License: MIT
// Description: Shimmering heat waves rise through the frame, strongest at the bottom, making the outgoing image wobble like the air over hot asphalt; the incoming image shows through the haze and settles as it calms
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
    scale: f32,
    speed: f32,
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

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e45 = (*v);
    let _e46 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e45 - (floor((_e45 / _e46)) * _e46)))));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e46 = (*v_1);
    v3_ = fract((_e46.xyx * 0.1031f));
    let _e50 = v3_;
    let _e51 = v3_;
    let _e56 = v3_;
    v3_ = (_e56 + vec3(dot(_e50, (_e51.yzx + vec3(33.33f)))));
    let _e60 = v3_[0u];
    let _e62 = v3_[1u];
    let _e65 = v3_[2u];
    return fract(((_e60 + _e62) * _e65));
}

fn vnoise(v_2: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e51 = (*v_2);
    i = floor(_e51);
    let _e53 = (*v_2);
    f = fract(_e53);
    let _e55 = f;
    let _e56 = f;
    let _e58 = f;
    f = ((_e55 * _e56) * (vec2(3f) - (_e58 * 2f)));
    let _e63 = i;
    param = _e63;
    let _e64 = hash12((&param));
    let _e65 = i;
    param_1 = (_e65 + vec2<f32>(1f, 0f));
    let _e67 = hash12((&param_1));
    let _e69 = f[0u];
    let _e71 = i;
    param_2 = (_e71 + vec2<f32>(0f, 1f));
    let _e73 = hash12((&param_2));
    let _e74 = i;
    param_3 = (_e74 + vec2<f32>(1f, 1f));
    let _e76 = hash12((&param_3));
    let _e78 = f[0u];
    let _e81 = f[1u];
    return mix(mix(_e64, _e67, _e69), mix(_e73, _e76, _e78), _e81);
}

fn fbm(v_3: ptr<function, vec2<f32>>) -> f32 {
    var sum: f32;
    var amp: f32;
    var i_1: i32;
    var param_4: vec2<f32>;

    sum = 0f;
    amp = 0.5f;
    i_1 = 0i;
    loop {
        let _e49 = i_1;
        if (_e49 < 4i) {
            let _e51 = amp;
            let _e52 = (*v_3);
            param_4 = _e52;
            let _e53 = vnoise((&param_4));
            let _e55 = sum;
            sum = (_e55 + (_e51 * _e53));
            let _e57 = (*v_3);
            (*v_3) = ((mat2x2<f32>(vec2<f32>(1.6f, 1.2f), vec2<f32>(-1.2f, 1.6f)) * _e57) + vec2(5.3f));
            let _e61 = amp;
            amp = (_e61 * 0.5f);
            continue;
        } else {
            break;
        }
        continuing {
            let _e63 = i_1;
            i_1 = (_e63 + 1i);
        }
    }
    let _e65 = sum;
    return (((_e65 / 0.9375f) - 0.5f) * 3f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv)[0u];
    let _e48 = (*uv)[1u];
    let _e51 = textureSampleLevel(_to, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv_1)[0u];
    let _e48 = (*uv_1)[1u];
    let _e51 = textureSampleLevel(_from, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var p: f32;
    var amount: f32;
    var t: f32;
    var q: vec2<f32>;
    var w: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var offset: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var ground: f32;
    var d: vec2<f32>;
    var param_11: vec2<f32>;
    var m: f32;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var a: vec4<f32>;
    var param_14: vec2<f32>;
    var b: vec4<f32>;
    var param_15: vec2<f32>;
    var c: vec4<f32>;
    var local: vec4<f32>;

    let _e70 = uniforms.progress;
    if (_e70 <= 0f) {
        let _e72 = (*uv_2);
        param_5 = _e72;
        let _e73 = getFromColor((&param_5));
        return _e73;
    }
    let _e75 = uniforms.progress;
    if (_e75 >= 1f) {
        let _e77 = (*uv_2);
        param_6 = _e77;
        let _e78 = getToColor((&param_6));
        return _e78;
    }
    let _e80 = uniforms.progress;
    p = _e80;
    let _e81 = p;
    amount = sin((3.1415927f * _e81));
    let _e84 = p;
    let _e86 = uniforms.speed;
    t = (_e84 * _e86);
    let _e89 = (*uv_2)[0u];
    let _e91 = uniforms.ratio;
    let _e94 = (*uv_2)[1u];
    let _e98 = uniforms.scale;
    q = (vec2<f32>((_e89 * _e91), (_e94 * 2.5f)) * _e98);
    let _e100 = t;
    let _e102 = uniforms.scale;
    let _e105 = q[1u];
    q[1u] = (_e105 - (_e100 * _e102));
    let _e108 = q;
    let _e110 = t;
    param_7 = ((_e108 * 0.35f) + vec2<f32>(0f, _e110));
    let _e113 = fbm((&param_7));
    let _e114 = q;
    let _e116 = t;
    param_8 = ((_e114 * 0.35f) + vec2<f32>(7.1f, -(_e116)));
    let _e120 = fbm((&param_8));
    w = vec2<f32>(_e113, _e120);
    let _e122 = w;
    let _e124 = q;
    q = (_e124 + (_e122 * 1.5f));
    let _e126 = q;
    param_9 = _e126;
    let _e127 = fbm((&param_9));
    let _e128 = q;
    param_10 = (_e128 + vec2<f32>(3.7f, 1.9f));
    let _e130 = fbm((&param_10));
    offset = vec2<f32>(_e127, (0.5f * _e130));
    let _e134 = (*uv_2)[1u];
    ground = mix(1f, 0.3f, _e134);
    let _e137 = uniforms.strength;
    let _e138 = amount;
    let _e140 = ground;
    let _e143 = uniforms.ratio;
    let _e147 = offset;
    offset = (_e147 * (vec2<f32>((1f / _e143), 1f) * ((_e137 * _e138) * _e140)));
    let _e149 = (*uv_2);
    let _e150 = offset;
    param_11 = (_e149 + _e150);
    let _e152 = mirror((&param_11));
    d = _e152;
    let _e153 = p;
    m = smoothstep(0.3f, 0.7f, _e153);
    let _e155 = m;
    if (_e155 <= 0f) {
        let _e157 = d;
        param_12 = _e157;
        let _e158 = getFromColor((&param_12));
        return _e158;
    }
    let _e159 = m;
    if (_e159 >= 1f) {
        let _e161 = d;
        param_13 = _e161;
        let _e162 = getToColor((&param_13));
        return _e162;
    }
    let _e163 = d;
    param_14 = _e163;
    let _e164 = getFromColor((&param_14));
    a = _e164;
    let _e165 = d;
    param_15 = _e165;
    let _e166 = getToColor((&param_15));
    b = _e166;
    let _e167 = a;
    let _e170 = a[3u];
    let _e171 = (_e167.xyz * _e170);
    let _e173 = a[3u];
    let _e178 = b;
    let _e181 = b[3u];
    let _e182 = (_e178.xyz * _e181);
    let _e184 = b[3u];
    let _e189 = m;
    c = mix(vec4<f32>(_e171.x, _e171.y, _e171.z, _e173), vec4<f32>(_e182.x, _e182.y, _e182.z, _e184), vec4(_e189));
    let _e193 = c[3u];
    if (_e193 > 0f) {
        let _e195 = c;
        let _e198 = c[3u];
        let _e200 = (_e195.xyz / vec3(_e198));
        let _e202 = c[3u];
        local = vec4<f32>(_e200.x, _e200.y, _e200.z, _e202);
    } else {
        local = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e207 = local;
    return _e207;
}

fn main_1() {
    var param_16: vec2<f32>;

    let _e45 = _uv_1;
    param_16 = _e45;
    let _e46 = transition((&param_16));
    _fragColor = _e46;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
