// RingsWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RingsWipe.glsl
// Author: gre
// License: MIT
// Description: Concentric rings ripple out from the center and, one after another, each sweeps around like a clock hand in the opposite direction of its neighbors to reveal the incoming image, or fills across its width, with optional colored borders between the rings
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    count: i32,
    center: vec2<f32>,
    stagger: f32,
    radial: i32,
    borderWidth: f32,
    borderColor: vec4<f32>,
    smoothness: f32,
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

fn ringMask(i: ptr<function, f32>, lp: ptr<function, f32>, w: ptr<function, f32>, rad: ptr<function, f32>, a: ptr<function, f32>, s: ptr<function, f32>) -> f32 {
    var odd: bool;
    var e: f32;
    var f: f32;
    var x: f32;
    var dist: f32;
    var local: f32;
    var aa: f32;
    var local_1: f32;
    var arc: f32;
    var e_1: f32;
    var lo: f32;
    var hi: f32;
    var dist_1: f32;

    let _e51 = (*i);
    odd = ((_e51 - (floor((_e51 / 2f)) * 2f)) > 0.5f);
    let _e58 = uniforms.radial;
    if (_e58 != 0i) {
        let _e60 = (*s);
        let _e61 = (*w);
        e = (_e60 / _e61);
        let _e63 = e;
        let _e65 = e;
        let _e67 = (*lp);
        f = mix(-(_e63), (1f + _e65), _e67);
        let _e69 = (*rad);
        let _e70 = (*i);
        let _e71 = (*w);
        let _e74 = (*w);
        x = clamp(((_e69 - (_e70 * _e71)) / _e74), 0f, 1f);
        let _e77 = odd;
        if _e77 {
            let _e78 = f;
            let _e79 = x;
            local = (_e78 - (1f - _e79));
        } else {
            let _e82 = f;
            let _e83 = x;
            local = (_e82 - _e83);
        }
        let _e85 = local;
        let _e86 = (*w);
        dist = (_e85 * _e86);
        let _e88 = (*s);
        let _e90 = (*s);
        let _e91 = dist;
        return smoothstep(-(_e88), _e90, _e91);
    }
    let _e93 = odd;
    if _e93 {
        let _e94 = (*a);
        local_1 = (1f - _e94);
    } else {
        let _e96 = (*a);
        local_1 = _e96;
    }
    let _e97 = local_1;
    aa = _e97;
    let _e98 = (*rad);
    let _e99 = (*s);
    arc = (6.2831855f * max(_e98, _e99));
    let _e102 = (*s);
    let _e103 = arc;
    e_1 = (_e102 / _e103);
    let _e105 = e_1;
    let _e106 = e_1;
    let _e108 = (*lp);
    lo = mix(_e105, -(_e106), _e108);
    let _e110 = e_1;
    let _e112 = e_1;
    let _e114 = (*lp);
    hi = mix(-(_e110), (1f + _e112), _e114);
    let _e116 = aa;
    let _e117 = lo;
    let _e119 = hi;
    let _e120 = aa;
    let _e123 = aa;
    let _e125 = lo;
    let _e127 = hi;
    let _e128 = aa;
    dist_1 = max(min((_e116 - _e117), (_e119 - _e120)), min(((_e123 - 1f) - _e125), ((_e127 - _e128) + 1f)));
    let _e133 = (*s);
    let _e135 = (*s);
    let _e136 = dist_1;
    let _e137 = arc;
    return smoothstep(-(_e133), _e135, (_e136 * _e137));
}

fn ringProgress(i_1: ptr<function, f32>, k: ptr<function, f32>, d: ptr<function, f32>, t: ptr<function, f32>) -> f32 {
    let _e36 = (*t);
    let _e37 = (*i_1);
    let _e38 = (*k);
    let _e40 = (*d);
    let _e43 = (*d);
    return clamp(((_e36 - ((_e37 * _e38) * _e40)) / _e43), 0f, 1f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e34 = (*uv)[0u];
    let _e36 = (*uv)[1u];
    let _e39 = textureSampleLevel(_to, _sampler, vec2<f32>(_e34, (1f - _e36)), 0f);
    return _e39;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e34 = (*uv_1)[0u];
    let _e36 = (*uv_1)[1u];
    let _e39 = textureSampleLevel(_from, _sampler, vec2<f32>(_e34, (1f - _e36)), 0f);
    return _e39;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a_1: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var n: f32;
    var local_2: i32;
    var p: vec2<f32>;
    var far: vec2<f32>;
    var R: f32;
    var w_1: f32;
    var rad_1: f32;
    var turn: f32;
    var local_3: f32;
    var s_1: f32;
    var t_1: f32;
    var k_1: f32;
    var d_1: f32;
    var j: f32;
    var inner: f32;
    var outer: f32;
    var li: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var lo_1: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var m: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var c: vec4<f32>;
    var on: f32;
    var hw: f32;
    var line: f32;
    var o: f32;
    var local_4: vec4<f32>;
    var phi_447_: bool;

    let _e82 = (*uv_2);
    param = _e82;
    let _e83 = getFromColor((&param));
    a_1 = _e83;
    let _e84 = (*uv_2);
    param_1 = _e84;
    let _e85 = getToColor((&param_1));
    b = _e85;
    let _e87 = uniforms.progress;
    if (_e87 <= 0f) {
        let _e89 = a_1;
        return _e89;
    }
    let _e91 = uniforms.progress;
    if (_e91 >= 1f) {
        let _e93 = b;
        return _e93;
    }
    let _e95 = uniforms.count;
    if (_e95 < 1i) {
        local_2 = 1i;
    } else {
        let _e98 = uniforms.count;
        local_2 = _e98;
    }
    let _e99 = local_2;
    n = f32(_e99);
    let _e101 = (*uv_2);
    let _e103 = uniforms.center;
    let _e106 = uniforms.ratio;
    p = ((_e101 - _e103) * vec2<f32>(_e106, 1f));
    let _e110 = uniforms.center;
    let _e112 = uniforms.center;
    let _e117 = uniforms.ratio;
    far = (max(_e110, (vec2(1f) - _e112)) * vec2<f32>(_e117, 1f));
    let _e120 = far;
    R = (length(_e120) + 0.0015f);
    let _e123 = R;
    let _e124 = n;
    w_1 = (_e123 / _e124);
    let _e126 = p;
    rad_1 = length(_e126);
    let _e128 = rad_1;
    if (_e128 > 0f) {
        let _e131 = p[0u];
        let _e133 = p[1u];
        local_3 = fract((atan2(_e131, _e133) / 6.2831855f));
    } else {
        local_3 = 0f;
    }
    let _e137 = local_3;
    turn = _e137;
    let _e139 = uniforms.smoothness;
    let _e140 = w_1;
    s_1 = max(min(_e139, (0.25f * _e140)), 0.0015f);
    let _e145 = uniforms.progress;
    let _e147 = uniforms.progress;
    let _e149 = uniforms.progress;
    let _e152 = uniforms.progress;
    t_1 = mix(_e145, ((_e147 * _e149) * (3f - (2f * _e152))), 0.35f);
    let _e158 = uniforms.stagger;
    k_1 = clamp(_e158, 0f, 1f);
    let _e160 = k_1;
    let _e161 = n;
    d_1 = (1f / (1f + (_e160 * (_e161 - 1f))));
    let _e166 = rad_1;
    let _e167 = w_1;
    j = floor(((_e166 / _e167) + 0.5f));
    let _e171 = j;
    let _e173 = n;
    inner = clamp((_e171 - 1f), 0f, (_e173 - 1f));
    let _e176 = j;
    let _e177 = n;
    outer = clamp(_e176, 0f, (_e177 - 1f));
    let _e180 = inner;
    param_2 = _e180;
    let _e181 = k_1;
    param_3 = _e181;
    let _e182 = d_1;
    param_4 = _e182;
    let _e183 = t_1;
    param_5 = _e183;
    let _e184 = ringProgress((&param_2), (&param_3), (&param_4), (&param_5));
    li = _e184;
    let _e185 = outer;
    param_6 = _e185;
    let _e186 = k_1;
    param_7 = _e186;
    let _e187 = d_1;
    param_8 = _e187;
    let _e188 = t_1;
    param_9 = _e188;
    let _e189 = ringProgress((&param_6), (&param_7), (&param_8), (&param_9));
    lo_1 = _e189;
    let _e190 = inner;
    param_10 = _e190;
    let _e191 = li;
    param_11 = _e191;
    let _e192 = w_1;
    param_12 = _e192;
    let _e193 = rad_1;
    param_13 = _e193;
    let _e194 = turn;
    param_14 = _e194;
    let _e195 = s_1;
    param_15 = _e195;
    let _e196 = ringMask((&param_10), (&param_11), (&param_12), (&param_13), (&param_14), (&param_15));
    let _e197 = outer;
    param_16 = _e197;
    let _e198 = lo_1;
    param_17 = _e198;
    let _e199 = w_1;
    param_18 = _e199;
    let _e200 = rad_1;
    param_19 = _e200;
    let _e201 = turn;
    param_20 = _e201;
    let _e202 = s_1;
    param_21 = _e202;
    let _e203 = ringMask((&param_16), (&param_17), (&param_18), (&param_19), (&param_20), (&param_21));
    let _e204 = rad_1;
    let _e205 = j;
    let _e206 = w_1;
    m = mix(_e196, _e203, smoothstep(-0.0015f, 0.0015f, (_e204 - (_e205 * _e206))));
    let _e211 = a_1;
    let _e214 = a_1[3u];
    let _e215 = (_e211.xyz * _e214);
    let _e217 = a_1[3u];
    let _e222 = b;
    let _e225 = b[3u];
    let _e226 = (_e222.xyz * _e225);
    let _e228 = b[3u];
    let _e233 = m;
    c = mix(vec4<f32>(_e215.x, _e215.y, _e215.z, _e217), vec4<f32>(_e226.x, _e226.y, _e226.z, _e228), vec4(_e233));
    let _e237 = uniforms.borderWidth;
    let _e239 = j;
    let _e241 = ((_e237 > 0f) && (_e239 >= 1f));
    phi_447_ = _e241;
    if _e241 {
        let _e242 = j;
        let _e243 = n;
        phi_447_ = (_e242 <= (_e243 - 1f));
    }
    let _e247 = phi_447_;
    if _e247 {
        let _e248 = li;
        let _e250 = lo_1;
        on = min(1f, ((4f * _e248) * (1f - _e250)));
        let _e255 = uniforms.borderWidth;
        let _e257 = w_1;
        hw = min((0.5f * _e255), ((0.5f * _e257) - 0.0015f));
        let _e261 = hw;
        let _e263 = hw;
        let _e265 = rad_1;
        let _e266 = j;
        let _e267 = w_1;
        let _e274 = uniforms.borderWidth;
        line = ((1f - smoothstep((_e261 - 0.0015f), (_e263 + 0.0015f), abs((_e265 - (_e266 * _e267))))) * min(1f, (_e274 / 0.003f)));
        let _e280 = uniforms.borderColor[3u];
        let _e281 = line;
        let _e283 = on;
        o = ((_e280 * _e281) * _e283);
        let _e286 = uniforms.borderColor;
        let _e288 = o;
        let _e289 = (_e286.xyz * _e288);
        let _e290 = o;
        let _e295 = c;
        let _e296 = o;
        c = (vec4<f32>(_e289.x, _e289.y, _e289.z, _e290) + (_e295 * (1f - _e296)));
    }
    let _e301 = c[3u];
    if (_e301 > 0f) {
        let _e303 = c;
        let _e306 = c[3u];
        let _e308 = (_e303.xyz / vec3(_e306));
        let _e310 = c[3u];
        local_4 = vec4<f32>(_e308.x, _e308.y, _e308.z, _e310);
    } else {
        local_4 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e315 = local_4;
    return _e315;
}

fn main_1() {
    var param_22: vec2<f32>;

    let _e33 = _uv_1;
    param_22 = _e33;
    let _e34 = transition((&param_22));
    _fragColor = _e34;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
