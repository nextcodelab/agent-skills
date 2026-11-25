// CurtainRise — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CurtainRise.glsl
// Author: gre
// License: MIT
// Description: The outgoing image rises like a theater festoon curtain: cords lift its hem into scalloped swags while the fabric gathers into shaded ruffles, and it is drawn up out of the frame over the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    swags: f32,
    sag: f32,
    ruffles: f32,
    shading: f32,
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
    let _e48 = (*uv)[0u];
    let _e50 = (*uv)[1u];
    let _e53 = textureSampleLevel(_to, _sampler, vec2<f32>(_e48, (1f - _e50)), 0f);
    return _e53;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e48 = (*uv_1)[0u];
    let _e50 = (*uv_1)[1u];
    let _e53 = textureSampleLevel(_from, _sampler, vec2<f32>(_e48, (1f - _e50)), 0f);
    return _e53;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var f: f32;
    var e: f32;
    var s: f32;
    var lift: f32;
    var n: f32;
    var u: f32;
    var bump: f32;
    var hem: f32;
    var aa: f32;
    var inside: f32;
    var c: vec4<f32>;
    var h: f32;
    var q: f32;
    var m: f32;
    var a: f32;
    var g: f32;
    var v: f32;
    var pull: f32;
    var param: vec2<f32>;
    var slope: f32;
    var diffuse: f32;
    var crease: f32;
    var light: f32;
    var depth: f32;
    var to: vec4<f32>;
    var param_1: vec2<f32>;
    var below: f32;
    var shadow: f32;

    let _e77 = uniforms.progress;
    p = _e77;
    let _e78 = p;
    let _e80 = p;
    let _e83 = p;
    f = (1f - (((1f - _e78) * (1f - _e80)) * (1f - _e83)));
    let _e87 = p;
    let _e88 = p;
    let _e89 = p;
    let _e91 = p;
    e = mix(_e87, ((_e88 * _e89) * (3f - (2f * _e91))), 0.4f);
    let _e97 = uniforms.sag;
    let _e98 = f;
    s = (_e97 * _e98);
    let _e101 = uniforms.sag;
    let _e104 = e;
    lift = mix(-0.01f, ((1f + _e101) + 0.08f), _e104);
    let _e107 = uniforms.swags;
    let _e109 = uniforms.ratio;
    n = max(1f, floor(((_e107 * sqrt((_e109 / 1.78f))) + 0.5f)));
    let _e117 = (*uv_2)[0u];
    let _e118 = n;
    u = ((fract((_e117 * _e118)) * 2f) - 1f);
    let _e123 = u;
    let _e124 = u;
    bump = (1f - (_e123 * _e124));
    let _e127 = lift;
    let _e128 = s;
    let _e129 = bump;
    hem = (_e127 - (_e128 * _e129));
    let _e132 = f;
    aa = (0.002f + (0.004f * _e132));
    let _e135 = hem;
    let _e136 = aa;
    let _e138 = hem;
    let _e139 = aa;
    let _e142 = (*uv_2)[1u];
    inside = smoothstep((_e135 - _e136), (_e138 + _e139), _e142);
    c = vec4<f32>(0f, 0f, 0f, 0f);
    let _e144 = inside;
    if (_e144 > 0f) {
        let _e146 = hem;
        h = max((1f - max(_e146, 0f)), 0.0001f);
        let _e151 = (*uv_2)[1u];
        let _e153 = h;
        q = clamp(((1f - _e151) / _e153), 0f, 1f);
        let _e157 = uniforms.ruffles;
        let _e161 = h;
        m = min(max(1f, floor((_e157 + 0.5f))), (_e161 / 0.02f));
        let _e164 = m;
        let _e166 = q;
        a = ((6.2831855f * _e164) * _e166);
        let _e168 = f;
        let _e170 = h;
        let _e176 = bump;
        g = (((0.85f * _e168) * min(1f, (0.3f + (5f * (1f - _e170))))) * (0.6f + (0.4f * _e176)));
        let _e180 = q;
        let _e181 = g;
        let _e182 = a;
        let _e185 = m;
        v = clamp((_e180 + ((_e181 * sin(_e182)) / (6.2831855f * _e185))), 0f, 1f);
        let _e190 = f;
        let _e192 = q;
        let _e194 = q;
        let _e196 = u;
        let _e200 = n;
        pull = (((((0.25f * _e190) * _e192) * _e194) * sin((3.1415927f * _e196))) / (3.1415927f * _e200));
        let _e204 = (*uv_2)[0u];
        let _e205 = pull;
        let _e207 = v;
        param = vec2<f32>((_e204 - _e205), (1f - _e207));
        let _e210 = getFromColor((&param));
        c = _e210;
        let _e211 = g;
        let _e213 = a;
        slope = ((2.5f * _e211) * cos(_e213));
        let _e216 = slope;
        let _e219 = slope;
        let _e220 = slope;
        diffuse = ((1f - (0.35f * _e216)) / sqrt((1f + (_e219 * _e220))));
        let _e225 = a;
        crease = (0.5f + (0.5f * sin(_e225)));
        let _e229 = diffuse;
        let _e230 = crease;
        let _e232 = crease;
        let _e237 = uniforms.shading;
        let _e238 = g;
        light = mix(1f, (_e229 * (1f - ((0.45f * _e230) * _e232))), (_e237 * _e238));
        let _e242 = uniforms.shading;
        let _e244 = g;
        let _e246 = a;
        let _e251 = light;
        light = (_e251 + (((0.18f * _e242) * _e244) * smoothstep(0.4f, 1f, -(cos(_e246)))));
        let _e253 = f;
        let _e254 = q;
        let _e256 = q;
        depth = ((_e253 * _e254) * (0.3f + (0.7f * _e256)));
        let _e261 = uniforms.shading;
        let _e262 = depth;
        let _e264 = u;
        let _e266 = u;
        let _e268 = u;
        let _e278 = light;
        light = (_e278 * (1f - ((_e261 * _e262) * (((0.35f * _e264) * _e266) + (0.5f * exp((-((1f - abs(_e268))) * 14f)))))));
        let _e281 = uniforms.shading;
        let _e283 = f;
        let _e286 = (*uv_2)[1u];
        let _e287 = hem;
        let _e294 = light;
        light = (_e294 * (1f - (((0.35f * _e281) * _e283) * exp((-((_e286 - _e287)) * 120f)))));
        let _e296 = light;
        let _e297 = c;
        let _e299 = (_e297.xyz * _e296);
        c[0u] = _e299.x;
        c[1u] = _e299.y;
        c[2u] = _e299.z;
        let _e306 = inside;
        if (_e306 >= 1f) {
            let _e308 = c;
            return _e308;
        }
    }
    let _e309 = (*uv_2);
    param_1 = _e309;
    let _e310 = getToColor((&param_1));
    to = _e310;
    let _e311 = hem;
    let _e313 = (*uv_2)[1u];
    below = max((_e311 - _e313), 0f);
    let _e317 = uniforms.shading;
    let _e319 = below;
    let _e324 = lift;
    let _e327 = lift;
    let _e328 = s;
    shadow = ((((0.6f * _e317) * exp((-(_e319) * 22f))) * smoothstep(0f, 0.05f, _e324)) * (1f - smoothstep(1f, 1.06f, (_e327 - _e328))));
    let _e333 = shadow;
    let _e335 = to;
    let _e337 = (_e335.xyz * (1f - _e333));
    to[0u] = _e337.x;
    to[1u] = _e337.y;
    to[2u] = _e337.z;
    let _e344 = to;
    let _e345 = c;
    let _e346 = inside;
    return mix(_e344, _e345, vec4(_e346));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e47 = _uv_1;
    param_2 = _e47;
    let _e48 = transition((&param_2));
    _fragColor = _e48;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
