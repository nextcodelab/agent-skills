// CameraShake — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CameraShake.glsl
// Author: gre
// License: MIT
// Description: The camera jolts violently in random directions, with motion blur and color fringes along each jolt; the cut happens at the peak of the shake, which then settles on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
    jolts: f32,
    blur: f32,
    split: f32,
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
    let _e43 = (*uv)[0u];
    let _e45 = (*uv)[1u];
    let _e48 = textureSampleLevel(_from, _sampler, vec2<f32>(_e43, (1f - _e45)), 0f);
    return _e48;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e43 = (*uv_1)[0u];
    let _e45 = (*uv_1)[1u];
    let _e48 = textureSampleLevel(_to, _sampler, vec2<f32>(_e43, (1f - _e45)), 0f);
    return _e48;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e42 = (*v);
    let _e43 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e42 - (floor((_e42 / _e43)) * _e43)))));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e43 = (*v_1);
    v3_ = fract((_e43.xyx * 0.1031f));
    let _e47 = v3_;
    let _e48 = v3_;
    let _e53 = v3_;
    v3_ = (_e53 + vec3(dot(_e47, (_e48.yzx + vec3(33.33f)))));
    let _e57 = v3_[0u];
    let _e59 = v3_[1u];
    let _e62 = v3_[2u];
    return fract(((_e57 + _e59) * _e62));
}

fn jolt(k: ptr<function, f32>) -> vec3<f32> {
    var a: f32;
    var param: vec2<f32>;
    var m: f32;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e47 = (*k);
    let _e49 = (*k);
    param = vec2<f32>(_e49, 11f);
    let _e51 = hash12((&param));
    a = ((2.4f * _e47) + (1.2f * _e51));
    let _e54 = (*k);
    param_1 = vec2<f32>(_e54, 23f);
    let _e56 = hash12((&param_1));
    m = (0.55f + (0.45f * _e56));
    let _e59 = m;
    let _e60 = a;
    let _e63 = m;
    let _e64 = a;
    let _e67 = (*k);
    param_2 = vec2<f32>(_e67, 37f);
    let _e69 = hash12((&param_2));
    return vec3<f32>((_e59 * cos(_e60)), (_e63 * sin(_e64)), ((2f * _e69) - 1f));
}

fn envelope(t: ptr<function, f32>) -> f32 {
    var h: f32;

    let _e43 = (*t);
    h = clamp((1.6f * (1f - abs(((2f * _e43) - 1f)))), 0f, 1f);
    let _e50 = h;
    let _e51 = h;
    let _e53 = h;
    return ((_e50 * _e51) * (3f - (2f * _e53)));
}

fn shot(uv_2: ptr<function, vec2<f32>>, t_1: ptr<function, f32>, incoming: ptr<function, bool>) -> vec4<f32> {
    var env: f32;
    var param_3: f32;
    var s: f32;
    var k_1: f32;
    var g: f32;
    var e: f32;
    var j: vec3<f32>;
    var param_4: f32;
    var param_5: f32;
    var omax: f32;
    var rmax: f32;
    var off: vec2<f32>;
    var roll: f32;
    var zoom: f32;
    var q: vec2<f32>;
    var p: vec2<f32>;
    var param_6: vec2<f32>;
    var c: vec4<f32>;
    var local: vec4<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;

    let _e65 = (*t_1);
    param_3 = _e65;
    let _e66 = envelope((&param_3));
    env = _e66;
    let _e67 = (*t_1);
    let _e70 = uniforms.jolts;
    s = ((_e67 - 0.5f) * _e70);
    let _e72 = s;
    k_1 = floor(_e72);
    let _e74 = s;
    let _e75 = k_1;
    g = (1f - (_e74 - _e75));
    let _e78 = g;
    let _e79 = g;
    let _e81 = g;
    e = (1f - ((_e78 * _e79) * _e81));
    let _e84 = k_1;
    param_4 = _e84;
    let _e85 = jolt((&param_4));
    let _e86 = k_1;
    param_5 = (_e86 + 1f);
    let _e88 = jolt((&param_5));
    let _e89 = e;
    let _e92 = env;
    j = (mix(_e85, _e88, vec3(_e89)) * _e92);
    let _e95 = uniforms.strength;
    let _e97 = env;
    omax = ((0.14f * _e95) * _e97);
    let _e100 = uniforms.strength;
    let _e102 = env;
    rmax = ((0.07f * _e100) * _e102);
    let _e104 = j;
    let _e106 = omax;
    off = (_e104.xy * _e106);
    let _e109 = j[2u];
    let _e110 = rmax;
    roll = (_e109 * _e110);
    let _e112 = rmax;
    let _e114 = rmax;
    let _e117 = uniforms.ratio;
    let _e119 = uniforms.ratio;
    let _e124 = omax;
    zoom = ((cos(_e112) + (sin(_e114) * max(_e117, (1f / _e119)))) / (1f - (2f * _e124)));
    let _e128 = (*uv_2);
    let _e132 = uniforms.ratio;
    q = ((_e128 - vec2(0.5f)) * vec2<f32>(_e132, 1f));
    let _e135 = roll;
    let _e137 = roll;
    let _e139 = roll;
    let _e142 = roll;
    let _e147 = q;
    let _e149 = zoom;
    q = ((mat2x2<f32>(vec2<f32>(cos(_e135), sin(_e137)), vec2<f32>(-(sin(_e139)), cos(_e142))) * _e147) / vec2(_e149));
    let _e152 = q;
    let _e154 = uniforms.ratio;
    let _e159 = off;
    param_6 = (((_e152 / vec2<f32>(_e154, 1f)) + vec2(0.5f)) + _e159);
    let _e161 = mirror((&param_6));
    p = _e161;
    let _e162 = (*incoming);
    if _e162 {
        let _e163 = p;
        param_7 = _e163;
        let _e164 = getToColor((&param_7));
        local = _e164;
    } else {
        let _e165 = p;
        param_8 = _e165;
        let _e166 = getFromColor((&param_8));
        local = _e166;
    }
    let _e167 = local;
    c = _e167;
    let _e168 = c;
    let _e171 = c[3u];
    let _e172 = (_e168.xyz * _e171);
    let _e174 = c[3u];
    return vec4<f32>(_e172.x, _e172.y, _e172.z, _e174);
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var open: f32;
    var param_9: f32;
    var shutter: f32;
    var lag: f32;
    var sumR: vec2<f32>;
    var sumG: vec2<f32>;
    var sumB: vec2<f32>;
    var wsum: f32;
    var i: i32;
    var u: f32;
    var t_2: f32;
    var w: f32;
    var incoming_1: bool;
    var r: vec4<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var param_12: bool;
    var c_1: vec4<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: bool;
    var b: vec4<f32>;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: bool;
    var alpha: f32;
    var color: vec3<f32>;

    let _e70 = uniforms.progress;
    param_9 = _e70;
    let _e71 = envelope((&param_9));
    open = _e71;
    let _e73 = uniforms.blur;
    let _e76 = uniforms.jolts;
    let _e78 = open;
    shutter = (((0.8f * _e73) / _e76) * _e78);
    let _e81 = uniforms.split;
    let _e84 = uniforms.jolts;
    let _e86 = open;
    lag = (((0.2f * _e81) / _e84) * _e86);
    sumR = vec2<f32>(0f, 0f);
    sumG = vec2<f32>(0f, 0f);
    sumB = vec2<f32>(0f, 0f);
    wsum = 0f;
    i = 0i;
    loop {
        let _e88 = i;
        if (_e88 < 10i) {
            let _e90 = i;
            u = (((f32(_e90) + 0.5f) / 10f) - 0.5f);
            let _e96 = uniforms.progress;
            let _e97 = u;
            let _e98 = shutter;
            t_2 = (_e96 + (_e97 * _e98));
            let _e101 = u;
            w = (1f - (1.4f * abs(_e101)));
            let _e105 = t_2;
            incoming_1 = (_e105 >= 0.5f);
            let _e107 = t_2;
            let _e108 = lag;
            let _e110 = (*uv_3);
            param_10 = _e110;
            param_11 = (_e107 + _e108);
            let _e111 = incoming_1;
            param_12 = _e111;
            let _e112 = shot((&param_10), (&param_11), (&param_12));
            r = _e112;
            let _e113 = (*uv_3);
            param_13 = _e113;
            let _e114 = t_2;
            param_14 = _e114;
            let _e115 = incoming_1;
            param_15 = _e115;
            let _e116 = shot((&param_13), (&param_14), (&param_15));
            c_1 = _e116;
            let _e117 = t_2;
            let _e118 = lag;
            let _e120 = (*uv_3);
            param_16 = _e120;
            param_17 = (_e117 - _e118);
            let _e121 = incoming_1;
            param_18 = _e121;
            let _e122 = shot((&param_16), (&param_17), (&param_18));
            b = _e122;
            let _e123 = w;
            let _e124 = r;
            let _e127 = sumR;
            sumR = (_e127 + (_e124.xw * _e123));
            let _e129 = w;
            let _e130 = c_1;
            let _e133 = sumG;
            sumG = (_e133 + (_e130.yw * _e129));
            let _e135 = w;
            let _e136 = b;
            let _e139 = sumB;
            sumB = (_e139 + (_e136.zw * _e135));
            let _e141 = w;
            let _e142 = wsum;
            wsum = (_e142 + _e141);
            continue;
        } else {
            break;
        }
        continuing {
            let _e144 = i;
            i = (_e144 + 1i);
        }
    }
    let _e147 = sumR[1u];
    let _e149 = sumG[1u];
    let _e152 = sumB[1u];
    let _e154 = wsum;
    alpha = (((_e147 + _e149) + _e152) / (3f * _e154));
    let _e157 = alpha;
    if (_e157 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e160 = sumR[0u];
    let _e162 = sumR[1u];
    let _e166 = sumG[0u];
    let _e168 = sumG[1u];
    let _e172 = sumB[0u];
    let _e174 = sumB[1u];
    color = vec3<f32>((_e160 / max(_e162, 0.00001f)), (_e166 / max(_e168, 0.00001f)), (_e172 / max(_e174, 0.00001f)));
    let _e178 = color;
    let _e179 = alpha;
    return vec4<f32>(_e178.x, _e178.y, _e178.z, _e179);
}

fn main_1() {
    var param_19: vec2<f32>;

    let _e42 = _uv_1;
    param_19 = _e42;
    let _e43 = transition((&param_19));
    _fragColor = _e43;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
