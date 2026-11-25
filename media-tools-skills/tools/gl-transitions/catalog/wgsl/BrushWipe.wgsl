// BrushWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BrushWipe.glsl
// Author: gre
// License: MIT
// Description: A few broad brush strokes sweep across the frame in turn, back and forth, painting in the incoming image with streaky bristle edges and dry, ragged ends
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strokes: f32,
    angle: f32,
    roughness: f32,
    waviness: f32,
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
    let _e61 = (*uv)[0u];
    let _e63 = (*uv)[1u];
    let _e66 = textureSampleLevel(_to, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e61 = (*uv_1)[0u];
    let _e63 = (*uv_1)[1u];
    let _e66 = textureSampleLevel(_from, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e61 = (*p);
    p3_ = fract((_e61.xyx * 0.1031f));
    let _e65 = p3_;
    let _e66 = p3_;
    let _e71 = p3_;
    p3_ = (_e71 + vec3(dot(_e65, (_e66.yzx + vec3(33.33f)))));
    let _e75 = p3_[0u];
    let _e77 = p3_[1u];
    let _e80 = p3_[2u];
    return fract(((_e75 + _e77) * _e80));
}

fn vnoise(p_1: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e66 = (*p_1);
    i = floor(_e66);
    let _e68 = (*p_1);
    f = fract(_e68);
    let _e70 = f;
    let _e71 = f;
    let _e73 = f;
    f = ((_e70 * _e71) * (vec2(3f) - (_e73 * 2f)));
    let _e78 = i;
    param = _e78;
    let _e79 = hash((&param));
    let _e80 = i;
    param_1 = (_e80 + vec2<f32>(1f, 0f));
    let _e82 = hash((&param_1));
    let _e84 = f[0u];
    let _e86 = i;
    param_2 = (_e86 + vec2<f32>(0f, 1f));
    let _e88 = hash((&param_2));
    let _e89 = i;
    param_3 = (_e89 + vec2<f32>(1f, 1f));
    let _e91 = hash((&param_3));
    let _e93 = f[0u];
    let _e96 = f[1u];
    return mix(mix(_e79, _e82, _e84), mix(_e88, _e91, _e93), _e96);
}

fn bristles(t: ptr<function, f32>, u: ptr<function, f32>, seed: ptr<function, f32>) -> f32 {
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;

    let _e64 = (*t);
    let _e66 = (*seed);
    let _e68 = (*u);
    let _e70 = (*seed);
    param_4 = vec2<f32>(((_e64 * 26f) + _e66), ((_e68 * 1.3f) + _e70));
    let _e73 = vnoise((&param_4));
    let _e75 = (*t);
    let _e77 = (*seed);
    let _e79 = (*u);
    param_5 = vec2<f32>(((_e75 * 8f) - _e77), (_e79 * 0.7f));
    let _e82 = vnoise((&param_5));
    return ((0.6f * _e73) + (0.4f * _e82));
}

fn stroke(k: ptr<function, f32>, t_1: ptr<function, f32>, u_1: ptr<function, f32>, U: ptr<function, f32>, n: ptr<function, f32>, h: ptr<function, f32>) -> vec2<f32> {
    var dir: f32;
    var x: f32;
    var dur: f32;
    var start: f32;
    var local: f32;
    var s: f32;
    var r: f32;
    var lag: f32;
    var dry: f32;
    var head: f32;
    var b: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var front: f32;
    var streak: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var along: f32;
    var fringe: f32;
    var e: f32;
    var reach: f32;
    var param_12: vec2<f32>;
    var hair: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var side: f32;
    var cover: f32;
    var wet: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;

    let _e99 = (*k);
    dir = select(-1f, 1f, ((_e99 - (floor((_e99 / 2f)) * 2f)) < 0.5f));
    let _e106 = (*u_1);
    let _e107 = dir;
    x = (_e106 * _e107);
    let _e109 = (*n);
    dur = min(1f, (1.8f / (_e109 + 0.8f)));
    let _e113 = (*n);
    if (_e113 > 1f) {
        let _e115 = (*k);
        let _e116 = dur;
        let _e119 = (*n);
        local = ((_e115 * (1f - _e116)) / (_e119 - 1f));
    } else {
        local = 0f;
    }
    let _e122 = local;
    start = _e122;
    let _e124 = uniforms.progress;
    let _e125 = start;
    let _e127 = dur;
    s = clamp(((_e124 - _e125) / _e127), 0f, 1f);
    let _e130 = s;
    let _e131 = s;
    let _e132 = s;
    let _e134 = s;
    s = mix(_e130, ((_e131 * _e132) * (3f - (2f * _e134))), 0.7f);
    let _e140 = uniforms.roughness;
    r = _e140;
    let _e141 = r;
    let _e144 = (*h);
    lag = ((0.15f + (0.6f * _e141)) * _e144);
    let _e146 = r;
    let _e149 = (*h);
    dry = ((0.1f + (0.9f * _e146)) * _e149);
    let _e151 = (*U);
    let _e153 = (*U);
    let _e154 = lag;
    let _e156 = (*h);
    let _e159 = dry;
    let _e163 = s;
    head = mix(-(_e151), ((((_e153 + _e154) + (0.3f * _e156)) + (1.15f * _e159)) + 0.01f), _e163);
    let _e165 = (*k);
    let _e167 = (*k);
    let _e169 = (*t_1);
    param_6 = _e169;
    param_7 = (_e165 * 3.7f);
    param_8 = (_e167 * 17f);
    let _e170 = bristles((&param_6), (&param_7), (&param_8));
    b = _e170;
    let _e171 = head;
    let _e172 = lag;
    let _e173 = b;
    let _e177 = (*h);
    let _e179 = (*t_1);
    let _e181 = (*t_1);
    front = ((_e171 - (_e172 * (1f - _e173))) - (((0.3f * _e177) * _e179) * _e181));
    let _e184 = (*t_1);
    let _e186 = x;
    let _e188 = (*h);
    let _e190 = (*k);
    param_9 = (_e184 * 1.7f);
    param_10 = ((_e186 * 2f) / _e188);
    param_11 = ((_e190 * 5f) + 9f);
    let _e193 = bristles((&param_9), (&param_10), (&param_11));
    streak = _e193;
    let _e194 = front;
    let _e195 = x;
    let _e197 = dry;
    let _e201 = streak;
    along = clamp((((((_e194 - _e195) / (_e197 + 0.001f)) - 0.1f) - (0.8f * _e201)) * 6f), 0f, 1f);
    let _e206 = r;
    fringe = (0.1f + (0.7f * _e206));
    let _e209 = (*t_1);
    let _e212 = fringe;
    e = ((abs(_e209) - 1f) / _e212);
    let _e214 = x;
    let _e216 = (*h);
    let _e218 = (*k);
    let _e220 = (*t_1);
    param_12 = vec2<f32>(((_e214 * 2.5f) / _e216), ((_e218 * 7f) + select(0f, 3f, (_e220 > 0f))));
    let _e225 = vnoise((&param_12));
    reach = (0.5f + (0.5f * _e225));
    let _e228 = (*t_1);
    let _e230 = x;
    let _e232 = (*h);
    let _e234 = (*k);
    param_13 = (_e228 * 1.4f);
    param_14 = ((_e230 * 3f) / _e232);
    param_15 = ((_e234 * 11f) + 3f);
    let _e237 = bristles((&param_13), (&param_14), (&param_15));
    hair = clamp(((_e237 * 2f) - 0.5f), 0f, 1f);
    let _e241 = reach;
    let _e242 = hair;
    let _e244 = e;
    side = clamp(((((_e241 * _e242) - _e244) * 12f) + 1f), 0f, 1f);
    let _e249 = along;
    let _e250 = side;
    cover = (_e249 * _e250);
    let _e253 = uniforms.progress;
    let _e254 = start;
    let _e256 = dur;
    let _e262 = uniforms.progress;
    wet = ((1f - clamp((((_e253 - _e254) - _e256) / 0.25f), 0f, 1f)) * min(1f, ((1f - _e262) * 6f)));
    let _e267 = cover;
    let _e268 = cover;
    let _e269 = wet;
    let _e271 = (*t_1);
    let _e273 = x;
    let _e275 = (*h);
    param_16 = (_e271 * 2f);
    param_17 = ((_e273 * 2f) / _e275);
    let _e277 = (*k);
    param_18 = _e277;
    let _e278 = bristles((&param_16), (&param_17), (&param_18));
    return vec2<f32>(_e267, ((_e268 * _e269) * (_e278 - 0.5f)));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: f32;
    var c: f32;
    var sn: f32;
    var q: vec2<f32>;
    var u_2: f32;
    var v: f32;
    var U_1: f32;
    var V: f32;
    var n_1: f32;
    var h_1: f32;
    var A: f32;
    var w: f32;
    var y: f32;
    var hh: f32;
    var k_1: f32;
    var cover_1: f32;
    var shade: f32;
    var i_1: i32;
    var j: f32;
    var s_1: vec2<f32>;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var from_: vec4<f32>;
    var param_25: vec2<f32>;
    var to: vec4<f32>;
    var param_26: vec2<f32>;
    var phi_605_: bool;

    let _e91 = uniforms.angle;
    a = ((_e91 * 3.1415927f) / 180f);
    let _e94 = a;
    c = cos(_e94);
    let _e96 = a;
    sn = sin(_e96);
    let _e98 = (*uv_2);
    let _e102 = uniforms.ratio;
    q = ((_e98 - vec2(0.5f)) * vec2<f32>(_e102, 1f));
    let _e105 = c;
    let _e107 = q[0u];
    let _e109 = sn;
    let _e111 = q[1u];
    u_2 = ((_e105 * _e107) + (_e109 * _e111));
    let _e114 = sn;
    let _e117 = q[0u];
    let _e119 = c;
    let _e121 = q[1u];
    v = ((-(_e114) * _e117) + (_e119 * _e121));
    let _e124 = c;
    let _e127 = uniforms.ratio;
    let _e129 = sn;
    U_1 = (0.5f * ((abs(_e124) * _e127) + abs(_e129)));
    let _e133 = sn;
    let _e136 = uniforms.ratio;
    let _e138 = c;
    V = (0.5f * ((abs(_e133) * _e136) + abs(_e138)));
    let _e143 = uniforms.strokes;
    n_1 = max(1f, floor((_e143 + 0.5f)));
    let _e147 = V;
    let _e149 = n_1;
    h_1 = ((2f * _e147) / _e149);
    let _e152 = uniforms.waviness;
    let _e154 = h_1;
    A = ((0.12f * _e152) * _e154);
    let _e156 = v;
    let _e157 = A;
    let _e158 = u_2;
    let _e160 = U_1;
    let _e162 = v;
    let _e164 = h_1;
    let _e171 = A;
    let _e173 = u_2;
    let _e175 = U_1;
    let _e177 = v;
    let _e179 = h_1;
    w = ((_e156 + (_e157 * sin(((((_e158 * 5f) / _e160) + ((_e162 * 2f) / _e164)) + 1.3f)))) + ((0.5f * _e171) * sin((((_e173 * 11f) / _e175) - ((_e177 * 3f) / _e179)))));
    let _e185 = V;
    let _e186 = A;
    let _e189 = w;
    let _e191 = V;
    let _e193 = A;
    let _e197 = n_1;
    y = ((((_e185 + (1.5f * _e186)) - _e189) / ((2f * _e191) + (3f * _e193))) * _e197);
    let _e199 = V;
    let _e201 = A;
    let _e204 = n_1;
    hh = (((2f * _e199) + (3f * _e201)) / _e204);
    let _e206 = y;
    let _e208 = n_1;
    k_1 = clamp(floor(_e206), 0f, (_e208 - 1f));
    cover_1 = 0f;
    shade = 0f;
    i_1 = -1i;
    loop {
        let _e211 = i_1;
        if (_e211 <= 1i) {
            let _e213 = k_1;
            let _e214 = i_1;
            j = (_e213 + f32(_e214));
            let _e217 = j;
            let _e218 = (_e217 >= 0f);
            phi_605_ = _e218;
            if _e218 {
                let _e219 = j;
                let _e220 = n_1;
                phi_605_ = (_e219 <= (_e220 - 1f));
            }
            let _e224 = phi_605_;
            if _e224 {
                let _e225 = y;
                let _e226 = j;
                let _e230 = j;
                param_19 = _e230;
                param_20 = (((_e225 - _e226) - 0.5f) * 2f);
                let _e231 = u_2;
                param_21 = _e231;
                let _e232 = U_1;
                param_22 = _e232;
                let _e233 = n_1;
                param_23 = _e233;
                let _e234 = hh;
                param_24 = _e234;
                let _e235 = stroke((&param_19), (&param_20), (&param_21), (&param_22), (&param_23), (&param_24));
                s_1 = _e235;
                let _e236 = cover_1;
                let _e238 = s_1[0u];
                cover_1 = max(_e236, _e238);
                let _e240 = shade;
                let _e242 = s_1[1u];
                let _e244 = s_1[0u];
                shade = mix(_e240, _e242, _e244);
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e246 = i_1;
            i_1 = (_e246 + 1i);
        }
    }
    let _e248 = (*uv_2);
    param_25 = _e248;
    let _e249 = getFromColor((&param_25));
    from_ = _e249;
    let _e250 = (*uv_2);
    param_26 = _e250;
    let _e251 = getToColor((&param_26));
    to = _e251;
    let _e252 = to;
    let _e254 = shade;
    let _e259 = min((_e252.xyz * (1f + (0.2f * _e254))), vec3(1f));
    to[0u] = _e259.x;
    to[1u] = _e259.y;
    to[2u] = _e259.z;
    let _e266 = from_;
    let _e267 = to;
    let _e268 = cover_1;
    return mix(_e266, _e267, vec4(_e268));
}

fn main_1() {
    var param_27: vec2<f32>;

    let _e60 = _uv_1;
    param_27 = _e60;
    let _e61 = transition((&param_27));
    _fragColor = _e61;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
