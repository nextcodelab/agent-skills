// Doorway — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Doorway.glsl
// Author: gre
// License: MIT
// Description: The outgoing image opens like double doors swinging toward the viewer, as the incoming one comes forward from the dark room behind, with a floor reflection
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    reflection: f32,
    perspective: f32,
    depth: f32,
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
    let _e44 = (*uv)[0u];
    let _e46 = (*uv)[1u];
    let _e49 = textureSampleLevel(_from, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn leafHit(x: ptr<function, f32>, w: ptr<function, f32>, eye: ptr<function, f32>, a: ptr<function, f32>) -> vec2<f32> {
    var c: f32;
    var s: f32;
    var t: f32;
    var hit: vec2<f32>;

    let _e50 = (*a);
    c = cos(_e50);
    let _e52 = (*a);
    s = sin(_e52);
    let _e54 = (*eye);
    let _e55 = c;
    let _e57 = (*w);
    let _e59 = s;
    let _e62 = s;
    let _e63 = (*x);
    let _e64 = (*w);
    let _e68 = (*eye);
    let _e69 = c;
    t = (((_e54 * _e55) - ((0.5f * _e57) * _e59)) / ((_e62 * (_e63 - (0.5f * _e64))) + (_e68 * _e69)));
    let _e73 = (*w);
    let _e75 = t;
    let _e76 = (*x);
    let _e77 = (*w);
    let _e82 = (*eye);
    let _e83 = t;
    hit = vec2<f32>(((0.5f * _e73) + (_e75 * (_e76 - (0.5f * _e77)))), (_e82 * (_e83 - 1f)));
    let _e87 = t;
    let _e89 = hit[0u];
    let _e90 = c;
    let _e93 = hit[1u];
    let _e94 = s;
    return vec2<f32>(_e87, ((_e89 * _e90) - (_e93 * _e94)));
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv_1)[0u];
    let _e46 = (*uv_1)[1u];
    let _e49 = textureSampleLevel(_to, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn room(uv_2: ptr<function, vec2<f32>>, x_1: ptr<function, f32>, edgeL: ptr<function, f32>, edgeR: ptr<function, f32>, close: ptr<function, f32>, dolly: ptr<function, f32>) -> vec4<f32> {
    var size: f32;
    var p: vec2<f32>;
    var soft: f32;
    var m: vec2<f32>;
    var c_1: vec4<f32>;
    var param: vec2<f32>;
    var r: vec2<f32>;
    var f: f32;
    var param_1: vec2<f32>;
    var wl: f32;
    var shadow: f32;
    var light: f32;

    let _e61 = uniforms.depth;
    let _e63 = (*dolly);
    size = mix(max(_e61, 1f), 1f, _e63);
    let _e65 = (*uv_2);
    let _e68 = size;
    p = (((_e65 - vec2(0.5f)) * _e68) + vec2(0.5f));
    let _e72 = size;
    soft = ((0.004f * (_e72 - 1f)) + 0.000001f);
    let _e76 = soft;
    let _e78 = soft;
    let _e79 = p;
    let _e83 = soft;
    let _e85 = soft;
    let _e86 = p;
    m = (smoothstep(vec2(-(_e76)), vec2(_e78), _e79) * smoothstep(vec2(-(_e83)), vec2(_e85), (vec2(1f) - _e86)));
    let _e93 = p;
    param = clamp(_e93, vec2(0f), vec2(1f));
    let _e97 = getToColor((&param));
    let _e99 = m[0u];
    let _e101 = m[1u];
    c_1 = (_e97 * (_e99 * _e101));
    let _e105 = p[1u];
    if (_e105 < 0f) {
        let _e108 = p[0u];
        let _e110 = p[1u];
        r = vec2<f32>(_e108, ((-1.2f * _e110) - 0.02f));
        let _e115 = uniforms.reflection;
        let _e117 = r[1u];
        let _e121 = m[0u];
        let _e124 = r[1u];
        f = (((_e115 * (1f - _e117)) * _e121) * smoothstep(0f, 0.01f, _e124));
        let _e127 = r;
        param_1 = clamp(_e127, vec2(0f), vec2(1f));
        let _e131 = getToColor((&param_1));
        let _e132 = f;
        let _e135 = m[1u];
        let _e138 = c_1;
        c_1 = (_e138 + ((_e131 * _e132) * (1f - _e135)));
    }
    let _e140 = (*close);
    wl = (0.03f + (0.12f * _e140));
    let _e143 = wl;
    let _e144 = (*x_1);
    let _e145 = (*edgeL);
    let _e149 = wl;
    let _e150 = (*edgeR);
    let _e151 = (*x_1);
    shadow = ((1f - smoothstep(0f, _e143, (_e144 - _e145))) + (1f - smoothstep(0f, _e149, (_e150 - _e151))));
    let _e156 = (*close);
    let _e158 = (*close);
    let _e161 = (*close);
    let _e163 = shadow;
    light = ((1f + ((0.6f * _e156) * _e158)) * (1f - ((0.7f * _e161) * min(_e163, 1f))));
    let _e168 = c_1;
    let _e170 = light;
    let _e173 = c_1[3u];
    let _e175 = min((_e168.xyz * _e170), vec3(_e173));
    let _e177 = c_1[3u];
    return vec4<f32>(_e175.x, _e175.y, _e175.z, _e177);
}

fn project(p_1: ptr<function, vec2<f32>>, w_1: ptr<function, f32>, eye_1: ptr<function, f32>) -> f32 {
    let _e45 = (*w_1);
    let _e48 = (*p_1)[0u];
    let _e49 = (*w_1);
    let _e52 = (*eye_1);
    let _e54 = (*eye_1);
    let _e56 = (*p_1)[1u];
    return ((0.5f * _e45) + (((_e48 - (0.5f * _e49)) * _e52) / (_e54 + _e56)));
}

fn easeInOut(t_1: ptr<function, f32>) -> f32 {
    var local: f32;

    let _e44 = (*t_1);
    if (_e44 < 0.5f) {
        let _e46 = (*t_1);
        let _e48 = (*t_1);
        let _e50 = (*t_1);
        local = (((4f * _e46) * _e48) * _e50);
    } else {
        let _e52 = (*t_1);
        let _e55 = (*t_1);
        let _e58 = (*t_1);
        local = (1f - (((4f * (1f - _e52)) * (1f - _e55)) * (1f - _e58)));
    }
    let _e62 = local;
    return _e62;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var w_2: f32;
    var x_2: f32;
    var eye_2: f32;
    var swing: f32;
    var a_1: f32;
    var dolly_1: f32;
    var param_2: f32;
    var hw: f32;
    var front: vec2<f32>;
    var thick: f32;
    var edgeL_1: f32;
    var param_3: vec2<f32>;
    var param_4: f32;
    var param_5: f32;
    var backL: f32;
    var param_6: vec2<f32>;
    var param_7: f32;
    var param_8: f32;
    var close_1: f32;
    var back: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var left: bool;
    var lx: f32;
    var local_1: f32;
    var hit_1: vec2<f32>;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;
    var s_1: f32;
    var v: f32;
    var leaf: vec4<f32>;
    var local_2: f32;
    var param_19: vec2<f32>;
    var side: vec4<f32>;
    var param_20: vec2<f32>;
    var aa: f32;
    var c_2: vec4<f32>;

    let _e87 = uniforms.ratio;
    w_2 = _e87;
    let _e89 = (*uv_3)[0u];
    let _e90 = w_2;
    x_2 = (_e89 * _e90);
    let _e92 = w_2;
    let _e95 = uniforms.perspective;
    eye_2 = (max(_e92, 1f) * (0.5f + (0.2f / max(_e95, 0.01f))));
    let _e101 = uniforms.progress;
    let _e103 = uniforms.progress;
    let _e106 = uniforms.progress;
    swing = ((_e101 * _e103) * (3f - (2f * _e106)));
    let _e110 = eye_2;
    let _e112 = w_2;
    let _e117 = swing;
    a_1 = (min((atan(((2f * _e110) / _e112)) + 0.1f), 1.5707964f) * _e117);
    let _e120 = uniforms.progress;
    param_2 = _e120;
    let _e121 = easeInOut((&param_2));
    let _e123 = uniforms.progress;
    dolly_1 = mix(_e121, _e123, 0.3f);
    let _e125 = w_2;
    hw = (0.5f * _e125);
    let _e127 = hw;
    let _e128 = a_1;
    let _e130 = a_1;
    front = (vec2<f32>(cos(_e128), -(sin(_e130))) * _e127);
    let _e135 = w_2;
    let _e137 = swing;
    thick = ((0.02f * _e135) * (1f - smoothstep(0.8f, 1f, _e137)));
    let _e141 = front;
    param_3 = _e141;
    let _e142 = w_2;
    param_4 = _e142;
    let _e143 = eye_2;
    param_5 = _e143;
    let _e144 = project((&param_3), (&param_4), (&param_5));
    edgeL_1 = _e144;
    let _e145 = front;
    let _e146 = thick;
    let _e147 = a_1;
    let _e149 = a_1;
    param_6 = (_e145 + (vec2<f32>(sin(_e147), cos(_e149)) * _e146));
    let _e154 = w_2;
    param_7 = _e154;
    let _e155 = eye_2;
    param_8 = _e155;
    let _e156 = project((&param_6), (&param_7), (&param_8));
    backL = _e156;
    let _e157 = swing;
    close_1 = (1f - _e157);
    let _e159 = w_2;
    let _e160 = backL;
    let _e162 = (*uv_3);
    param_9 = _e162;
    let _e163 = x_2;
    param_10 = _e163;
    let _e164 = backL;
    param_11 = _e164;
    param_12 = (_e159 - _e160);
    let _e165 = close_1;
    param_13 = _e165;
    let _e166 = dolly_1;
    param_14 = _e166;
    let _e167 = room((&param_9), (&param_10), (&param_11), (&param_12), (&param_13), (&param_14));
    back = _e167;
    let _e168 = x_2;
    let _e169 = hw;
    left = (_e168 < _e169);
    let _e171 = left;
    if _e171 {
        let _e172 = x_2;
        local_1 = _e172;
    } else {
        let _e173 = w_2;
        let _e174 = x_2;
        local_1 = (_e173 - _e174);
    }
    let _e176 = local_1;
    lx = _e176;
    let _e177 = lx;
    param_15 = _e177;
    let _e178 = w_2;
    param_16 = _e178;
    let _e179 = eye_2;
    param_17 = _e179;
    let _e180 = a_1;
    param_18 = _e180;
    let _e181 = leafHit((&param_15), (&param_16), (&param_17), (&param_18));
    hit_1 = _e181;
    let _e183 = hit_1[1u];
    let _e184 = hw;
    s_1 = clamp(_e183, 0f, _e184);
    let _e187 = (*uv_3)[1u];
    let _e190 = hit_1[0u];
    v = (0.5f + ((_e187 - 0.5f) * _e190));
    let _e193 = left;
    if _e193 {
        let _e194 = s_1;
        let _e195 = w_2;
        local_2 = (_e194 / _e195);
    } else {
        let _e197 = s_1;
        let _e198 = w_2;
        local_2 = (1f - (_e197 / _e198));
    }
    let _e201 = local_2;
    let _e202 = v;
    param_19 = clamp(vec2<f32>(_e201, _e202), vec2(0f), vec2(1f));
    let _e207 = getFromColor((&param_19));
    leaf = _e207;
    let _e208 = a_1;
    let _e213 = a_1;
    let _e216 = s_1;
    let _e217 = hw;
    let _e221 = leaf;
    let _e223 = (_e221.xyz * ((1f - (0.5f * (1f - cos(_e208)))) - ((0.25f * sin(_e213)) * (_e216 / _e217))));
    leaf[0u] = _e223.x;
    leaf[1u] = _e223.y;
    leaf[2u] = _e223.z;
    let _e230 = left;
    let _e232 = v;
    param_20 = clamp(vec2<f32>(select(0.501f, 0.499f, _e230), _e232), vec2(0f), vec2(1f));
    let _e237 = getFromColor((&param_20));
    side = _e237;
    let _e238 = side;
    let _e242 = side[3u];
    let _e244 = min((_e238.xyz * 1.5f), vec3(_e242));
    side[0u] = _e244.x;
    side[1u] = _e244.y;
    side[2u] = _e244.z;
    let _e251 = a_1;
    let _e252 = close_1;
    aa = ((0.003f * min(1f, (20f * min(_e251, _e252)))) + 0.000001f);
    let _e258 = back;
    let _e259 = side;
    let _e260 = aa;
    let _e262 = aa;
    let _e263 = backL;
    let _e264 = lx;
    c_2 = mix(_e258, _e259, vec4(smoothstep(-(_e260), _e262, (_e263 - _e264))));
    let _e269 = c_2;
    let _e270 = leaf;
    let _e271 = aa;
    let _e273 = aa;
    let _e274 = edgeL_1;
    let _e275 = lx;
    return mix(_e269, _e270, vec4(smoothstep(-(_e271), _e273, (_e274 - _e275))));
}

fn main_1() {
    var param_21: vec2<f32>;

    let _e43 = _uv_1;
    param_21 = _e43;
    let _e44 = transition((&param_21));
    _fragColor = _e44;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
