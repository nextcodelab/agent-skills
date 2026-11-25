// KeyholeWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/KeyholeWipe.glsl
// Author: gre
// License: MIT
// Description: A keyhole grows steadily from the center until the incoming image fills the frame, its bevelled rim and inner shadow making it read as a hole cut in a plate
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    rim: f32,
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

fn dot2(v: ptr<function, vec2<f32>>) -> f32 {
    let _e53 = (*v);
    let _e54 = (*v);
    return dot(_e53, _e54);
}

fn sdSlot(p: ptr<function, vec2<f32>>) -> f32 {
    var r1_: f32;
    var r2_: f32;
    var he: f32;
    var k1_: vec2<f32>;
    var k2_: vec2<f32>;
    var ca: vec2<f32>;
    var cb: vec2<f32>;
    var param: vec2<f32>;
    var s: f32;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var phi_149_: bool;

    let _e65 = (*p)[1u];
    (*p)[1u] = (_e65 - -0.17f);
    r1_ = 0.14f;
    r2_ = 0.06f;
    he = 0.205f;
    let _e68 = r2_;
    let _e69 = he;
    k1_ = vec2<f32>(_e68, _e69);
    let _e71 = r2_;
    let _e72 = r1_;
    let _e74 = he;
    k2_ = vec2<f32>((_e71 - _e72), (2f * _e74));
    let _e78 = (*p)[0u];
    (*p)[0u] = abs(_e78);
    let _e82 = (*p)[0u];
    let _e84 = (*p)[0u];
    let _e86 = (*p)[1u];
    let _e88 = r1_;
    let _e89 = r2_;
    let _e94 = (*p)[1u];
    let _e96 = he;
    ca = vec2<f32>((_e82 - min(_e84, select(_e89, _e88, (_e86 < 0f)))), (abs(_e94) - _e96));
    let _e99 = (*p);
    let _e100 = k1_;
    let _e102 = k2_;
    let _e103 = k1_;
    let _e104 = (*p);
    let _e106 = k2_;
    let _e108 = k2_;
    param = _e108;
    let _e109 = dot2((&param));
    cb = ((_e99 - _e100) + (_e102 * clamp((dot((_e103 - _e104), _e106) / _e109), 0f, 1f)));
    let _e115 = cb[0u];
    let _e116 = (_e115 < 0f);
    phi_149_ = _e116;
    if _e116 {
        let _e118 = ca[1u];
        phi_149_ = (_e118 < 0f);
    }
    let _e121 = phi_149_;
    s = select(1f, -1f, _e121);
    let _e123 = s;
    let _e124 = ca;
    param_1 = _e124;
    let _e125 = dot2((&param_1));
    let _e126 = cb;
    param_2 = _e126;
    let _e127 = dot2((&param_2));
    return ((_e123 * sqrt(min(_e125, _e127))) - 0.025f);
}

fn sdKeyhole(p_1: ptr<function, vec2<f32>>) -> f32 {
    var param_3: vec2<f32>;

    let _e54 = (*p_1);
    let _e58 = (*p_1);
    param_3 = _e58;
    let _e59 = sdSlot((&param_3));
    return min((length((_e54 - vec2<f32>(0f, 0.2f))) - 0.25f), _e59);
}

fn reach(p_2: ptr<function, vec2<f32>>) -> f32 {
    var h: vec2<f32>;
    var k: f32;
    var param_4: vec2<f32>;
    var b: f32;
    var param_5: vec2<f32>;

    h = vec2<f32>(0f, 0.1f);
    let _e58 = h;
    param_4 = _e58;
    let _e59 = dot2((&param_4));
    k = (0.0625f - _e59);
    let _e61 = (*p_2);
    let _e62 = h;
    b = dot(_e61, _e62);
    let _e64 = b;
    let _e65 = b;
    let _e67 = k;
    let _e68 = (*p_2);
    param_5 = _e68;
    let _e69 = dot2((&param_5));
    let _e73 = b;
    let _e75 = k;
    return ((sqrt(((_e64 * _e65) + (_e67 * _e69))) - _e73) / _e75);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv)[0u];
    let _e56 = (*uv)[1u];
    let _e59 = textureSampleLevel(_to, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv_1)[0u];
    let _e56 = (*uv_1)[1u];
    let _e59 = textureSampleLevel(_from, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param_6: vec2<f32>;
    var b_1: vec4<f32>;
    var param_7: vec2<f32>;
    var asp: vec2<f32>;
    var c: vec2<f32>;
    var sm: f32;
    var o: vec2<f32>;
    var lo: vec2<f32>;
    var hi: vec2<f32>;
    var full: f32;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var p_3: f32;
    var s_1: f32;
    var q: vec2<f32>;
    var d: f32;
    var param_12: vec2<f32>;
    var hole: f32;
    var fade: f32;
    var rimA: f32;
    var e: vec2<f32>;
    var n: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var lit: f32;
    var bevel: f32;
    var shade: f32;
    var wall: f32;
    var param_17: vec2<f32>;
    var vign: f32;

    let _e88 = (*uv_2);
    param_6 = _e88;
    let _e89 = getFromColor((&param_6));
    a = _e89;
    let _e90 = (*uv_2);
    param_7 = _e90;
    let _e91 = getToColor((&param_7));
    b_1 = _e91;
    let _e93 = uniforms.ratio;
    asp = vec2<f32>(_e93, 1f);
    let _e96 = uniforms.center;
    let _e97 = asp;
    c = (_e96 * _e97);
    let _e100 = uniforms.smoothness;
    sm = max(_e100, 0.0005f);
    let _e102 = c;
    o = _e102;
    let _e103 = o;
    let _e105 = sm;
    lo = (-(_e103) - vec2((2.5f * _e105)));
    let _e109 = asp;
    let _e110 = o;
    let _e112 = sm;
    hi = ((_e109 - _e110) + vec2((2.5f * _e112)));
    let _e116 = lo;
    param_8 = _e116;
    let _e117 = reach((&param_8));
    let _e118 = hi;
    param_9 = _e118;
    let _e119 = reach((&param_9));
    let _e122 = lo[0u];
    let _e124 = hi[1u];
    param_10 = vec2<f32>(_e122, _e124);
    let _e126 = reach((&param_10));
    let _e128 = hi[0u];
    let _e130 = lo[1u];
    param_11 = vec2<f32>(_e128, _e130);
    let _e132 = reach((&param_11));
    full = max(max(_e117, _e119), max(_e126, _e132));
    let _e136 = uniforms.progress;
    p_3 = _e136;
    let _e137 = full;
    let _e138 = p_3;
    s_1 = (_e137 * _e138);
    let _e140 = s_1;
    if (_e140 <= 0f) {
        let _e142 = a;
        return _e142;
    }
    let _e143 = (*uv_2);
    let _e144 = asp;
    let _e146 = o;
    let _e148 = s_1;
    q = ((((_e143 * _e144) - _e146) / vec2(_e148)) + vec2<f32>(0f, 0.1f));
    let _e152 = q;
    param_12 = _e152;
    let _e153 = sdKeyhole((&param_12));
    d = _e153;
    let _e154 = sm;
    let _e156 = sm;
    let _e157 = d;
    let _e158 = s_1;
    let _e160 = sm;
    hole = (1f - smoothstep(-(_e154), _e156, ((_e157 * _e158) + _e160)));
    let _e164 = p_3;
    let _e166 = p_3;
    fade = (smoothstep(0f, 0.08f, _e164) * (1f - smoothstep(0.7f, 1f, _e166)));
    let _e171 = uniforms.rim;
    let _e172 = fade;
    rimA = (_e171 * _e172);
    let _e174 = rimA;
    if (_e174 > 0f) {
        e = vec2<f32>(0.002f, 0f);
        let _e176 = q;
        let _e177 = e;
        param_13 = (_e176 + _e177);
        let _e179 = sdKeyhole((&param_13));
        let _e180 = q;
        let _e181 = e;
        param_14 = (_e180 - _e181);
        let _e183 = sdKeyhole((&param_14));
        let _e185 = q;
        let _e186 = e;
        param_15 = (_e185 + _e186.yx);
        let _e189 = sdKeyhole((&param_15));
        let _e190 = q;
        let _e191 = e;
        param_16 = (_e190 - _e191.yx);
        let _e194 = sdKeyhole((&param_16));
        n = vec2<f32>((_e179 - _e183), (_e189 - _e194));
        let _e197 = n;
        let _e198 = n;
        lit = -(dot((_e197 / vec2(max(length(_e198), 0.000001f))), vec2<f32>(-0.35f, 0.94f)));
        let _e205 = d;
        bevel = (1f - smoothstep(0f, 0.028f, _e205));
        let _e208 = d;
        shade = exp((-(max(_e208, 0f)) / 0.05f));
        let _e213 = rimA;
        let _e214 = shade;
        let _e216 = bevel;
        let _e218 = lit;
        let _e225 = a;
        let _e227 = (_e225.xyz * (1f - (_e213 * ((0.35f * _e214) + ((_e216 * 0.4f) * max(-(_e218), 0f))))));
        a[0u] = _e227.x;
        a[1u] = _e227.y;
        a[2u] = _e227.z;
        let _e234 = rimA;
        let _e235 = bevel;
        let _e237 = bevel;
        let _e240 = lit;
        let _e244 = a[3u];
        let _e246 = a;
        let _e249 = (_e246.xyz + vec3((((((_e234 * _e235) * _e237) * 0.3f) * max(_e240, 0f)) * _e244)));
        a[0u] = _e249.x;
        a[1u] = _e249.y;
        a[2u] = _e249.z;
        let _e256 = q;
        param_17 = (_e256 + vec2<f32>(0f, 0.05f));
        let _e258 = sdKeyhole((&param_17));
        wall = smoothstep(-0.03f, 0.03f, _e258);
        let _e260 = d;
        vign = exp((min(_e260, 0f) / 0.05f));
        let _e264 = rimA;
        let _e265 = wall;
        let _e267 = vign;
        let _e272 = b_1;
        let _e274 = (_e272.xyz * (1f - (_e264 * ((0.5f * _e265) + (0.3f * _e267)))));
        b_1[0u] = _e274.x;
        b_1[1u] = _e274.y;
        b_1[2u] = _e274.z;
    }
    let _e281 = a;
    let _e282 = b_1;
    let _e283 = hole;
    return mix(_e281, _e282, vec4(_e283));
}

fn main_1() {
    var param_18: vec2<f32>;

    let _e53 = _uv_1;
    param_18 = _e53;
    let _e54 = transition((&param_18));
    _fragColor = _e54;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
