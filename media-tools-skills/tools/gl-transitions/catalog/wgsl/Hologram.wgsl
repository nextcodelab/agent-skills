// Hologram — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Hologram.glsl
// Author: gre
// License: MIT
// Description: The outgoing image turns into a flickering hologram (blue by default) with scanlines and jittering rows, breaks up, and the hologram resolves into the incoming image in full color
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    tint: vec3<f32>,
    background: vec4<f32>,
    scanlines: f32,
    jitter: f32,
    flicker: f32,
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

fn premultiplied(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e60 = (*c);
    let _e63 = (*c)[3u];
    let _e64 = (_e60.xyz * _e63);
    let _e66 = (*c)[3u];
    return vec4<f32>(_e64.x, _e64.y, _e64.z, _e66);
}

fn luma(c_1: ptr<function, vec3<f32>>) -> f32 {
    let _e60 = (*c_1);
    return dot(_e60, vec3<f32>(0.299f, 0.587f, 0.114f));
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e61 = (*uv)[0u];
    let _e63 = (*uv)[1u];
    let _e66 = textureSampleLevel(_from, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e61 = (*uv_1)[0u];
    let _e63 = (*uv_1)[1u];
    let _e66 = textureSampleLevel(_to, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn source(uv_2: ptr<function, vec2<f32>>, m: ptr<function, f32>) -> vec4<f32> {
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e64 = (*m);
    if (_e64 > 0.5f) {
        let _e66 = (*uv_2);
        param = _e66;
        let _e67 = getToColor((&param));
        local = _e67;
    } else {
        let _e68 = (*uv_2);
        param_1 = _e68;
        let _e69 = getFromColor((&param_1));
        local = _e69;
    }
    let _e70 = local;
    return _e70;
}

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    let _e60 = (*p);
    (*p) = fract((_e60 * vec2<f32>(443.897f, 441.423f)));
    let _e63 = (*p);
    let _e64 = (*p);
    let _e69 = (*p);
    (*p) = (_e69 + vec2(dot(_e63, (_e64.yx + vec2(19.19f)))));
    let _e73 = (*p)[0u];
    let _e75 = (*p)[1u];
    let _e78 = (*p)[0u];
    return fract(((_e73 + _e75) * _e78));
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var p_1: f32;
    var h: f32;
    var b: f32;
    var f: f32;
    var band: f32;
    var jump: f32;
    var param_4: vec2<f32>;
    var offset: f32;
    var param_5: vec2<f32>;
    var q: vec2<f32>;
    var m_1: f32;
    var param_6: vec2<f32>;
    var c_2: vec4<f32>;
    var param_7: vec2<f32>;
    var param_8: f32;
    var dx: vec2<f32>;
    var l: f32;
    var param_9: vec3<f32>;
    var cr: vec4<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var cb: vec4<f32>;
    var param_12: vec2<f32>;
    var param_13: f32;
    var lr: f32;
    var param_14: vec3<f32>;
    var lb: f32;
    var param_15: vec3<f32>;
    var g: vec3<f32>;
    var holo: vec3<f32>;
    var roll: f32;
    var inside: f32;
    var lines: f32;
    var vis: f32;
    var param_16: vec2<f32>;
    var gap: f32;
    var param_17: vec2<f32>;
    var layer: vec4<f32>;
    var plain: vec4<f32>;
    var param_18: vec2<f32>;
    var param_19: f32;
    var param_20: vec4<f32>;
    var back: vec4<f32>;
    var param_21: vec4<f32>;
    var holoColor: vec4<f32>;
    var param_22: vec4<f32>;
    var o: vec4<f32>;
    var local_1: vec4<f32>;

    let _e111 = uniforms.progress;
    if (_e111 <= 0f) {
        let _e113 = (*uv_3);
        param_2 = _e113;
        let _e114 = getFromColor((&param_2));
        return _e114;
    }
    let _e116 = uniforms.progress;
    if (_e116 >= 1f) {
        let _e118 = (*uv_3);
        param_3 = _e118;
        let _e119 = getToColor((&param_3));
        return _e119;
    }
    let _e121 = uniforms.progress;
    p_1 = _e121;
    let _e122 = p_1;
    let _e124 = p_1;
    h = (smoothstep(0f, 0.3f, _e122) * (1f - smoothstep(0.7f, 1f, _e124)));
    let _e128 = p_1;
    b = smoothstep(0f, 1f, (1f - (abs((_e128 - 0.5f)) / 0.22f)));
    let _e134 = p_1;
    f = floor((_e134 * 32f));
    let _e138 = (*uv_3)[1u];
    band = floor((_e138 * 36f));
    let _e141 = b;
    let _e144 = h;
    let _e147 = band;
    let _e148 = f;
    param_4 = vec2<f32>(_e147, _e148);
    let _e150 = hash((&param_4));
    jump = step((1f - ((0.2f + (0.6f * _e141)) * _e144)), _e150);
    let _e152 = band;
    let _e153 = f;
    param_5 = vec2<f32>(_e152, (_e153 + 0.37f));
    let _e156 = hash((&param_5));
    let _e160 = uniforms.jitter;
    let _e162 = jump;
    let _e164 = b;
    offset = (((((_e156 - 0.5f) * 2f) * _e160) * _e162) * (0.3f + (0.7f * _e164)));
    let _e169 = (*uv_3)[1u];
    let _e171 = f;
    let _e176 = h;
    let _e178 = offset;
    offset = (_e178 + ((sin(((_e169 * 23f) + (_e171 * 1.7f))) * 0.0015f) * _e176));
    let _e180 = (*uv_3);
    let _e181 = offset;
    q = (_e180 + vec2<f32>(_e181, 0f));
    let _e185 = (*uv_3)[1u];
    param_6 = vec2<f32>(floor((_e185 * 24f)), 7f);
    let _e189 = hash((&param_6));
    let _e190 = p_1;
    m_1 = step(_e189, ((_e190 - 0.35f) / 0.3f));
    let _e194 = q;
    param_7 = clamp(_e194, vec2(0f), vec2(1f));
    let _e198 = m_1;
    param_8 = _e198;
    let _e199 = source((&param_7), (&param_8));
    c_2 = _e199;
    let _e200 = b;
    dx = vec2<f32>((0.003f + (0.01f * _e200)), 0f);
    let _e204 = c_2;
    param_9 = _e204.xyz;
    let _e206 = luma((&param_9));
    l = _e206;
    let _e207 = q;
    let _e208 = dx;
    param_10 = clamp((_e207 + _e208), vec2(0f), vec2(1f));
    let _e213 = m_1;
    param_11 = _e213;
    let _e214 = source((&param_10), (&param_11));
    cr = _e214;
    let _e215 = q;
    let _e216 = dx;
    param_12 = clamp((_e215 - _e216), vec2(0f), vec2(1f));
    let _e221 = m_1;
    param_13 = _e221;
    let _e222 = source((&param_12), (&param_13));
    cb = _e222;
    let _e223 = cr;
    param_14 = _e223.xyz;
    let _e225 = luma((&param_14));
    let _e227 = cr[3u];
    lr = (_e225 * _e227);
    let _e229 = cb;
    param_15 = _e229.xyz;
    let _e231 = luma((&param_15));
    let _e233 = cb[3u];
    lb = (_e231 * _e233);
    let _e235 = lr;
    let _e236 = l;
    let _e237 = lb;
    g = smoothstep(vec3(0.05f), vec3(0.9f), vec3<f32>(_e235, _e236, _e237));
    let _e243 = uniforms.tint;
    let _e244 = g;
    let _e249 = g;
    let _e251 = g;
    let _e253 = g;
    holo = ((_e243 * (vec3(0.06f) + (_e244 * 1.25f))) + (((_e249 * 0.45f) * _e251) * _e253));
    let _e257 = (*uv_3)[1u];
    let _e258 = p_1;
    roll = fract((_e257 + (2f * _e258)));
    let _e263 = uniforms.tint;
    let _e265 = roll;
    let _e268 = roll;
    let _e272 = holo;
    holo = (_e272 + (((_e263 * 0.35f) * smoothstep(0.85f, 1f, _e265)) * (1f - smoothstep(0.98f, 1f, _e268))));
    let _e274 = holo;
    holo = clamp(_e274, vec3(0f), vec3(1f));
    let _e279 = q[0u];
    let _e282 = q[0u];
    inside = (step(0f, _e279) * step(_e282, 1f));
    let _e286 = (*uv_3)[1u];
    let _e288 = uniforms.scanlines;
    let _e290 = p_1;
    lines = (0.5f + (0.5f * sin(((((_e286 * _e288) - (_e290 * 6f)) * 2f) * 3.1415927f))));
    let _e298 = lines;
    let _e301 = h;
    vis = mix(1f, (0.15f + (0.85f * _e298)), _e301);
    let _e304 = uniforms.flicker;
    let _e305 = b;
    let _e309 = f;
    param_16 = vec2<f32>(_e309, 3.1f);
    let _e311 = hash((&param_16));
    let _e313 = h;
    let _e316 = vis;
    vis = (_e316 * (1f - (((_e304 * (0.25f + (0.75f * _e305))) * _e311) * _e313)));
    let _e319 = (*uv_3)[1u];
    let _e322 = f;
    param_17 = vec2<f32>(floor((_e319 * 90f)), (_e322 + 0.71f));
    let _e325 = hash((&param_17));
    let _e327 = uniforms.flicker;
    let _e329 = b;
    gap = step(_e325, ((_e327 * 0.45f) * _e329));
    let _e332 = gap;
    let _e334 = vis;
    vis = (_e334 * (1f - _e332));
    let _e336 = holo;
    let _e338 = c_2[3u];
    let _e339 = vis;
    let _e341 = inside;
    layer = vec4<f32>(_e336.x, _e336.y, _e336.z, ((_e338 * _e339) * _e341));
    let _e347 = (*uv_3);
    param_18 = _e347;
    let _e348 = m_1;
    param_19 = _e348;
    let _e349 = source((&param_18), (&param_19));
    param_20 = _e349;
    let _e350 = premultiplied((&param_20));
    plain = _e350;
    let _e352 = uniforms.background;
    let _e353 = _e352.xyz;
    let _e356 = uniforms.background[3u];
    let _e358 = plain[3u];
    let _e360 = layer[3u];
    param_21 = vec4<f32>(_e353.x, _e353.y, _e353.z, (_e356 * max(_e358, _e360)));
    let _e367 = premultiplied((&param_21));
    back = _e367;
    let _e368 = layer;
    param_22 = _e368;
    let _e369 = premultiplied((&param_22));
    let _e370 = back;
    let _e372 = layer[3u];
    holoColor = (_e369 + (_e370 * (1f - _e372)));
    let _e376 = plain;
    let _e377 = holoColor;
    let _e378 = h;
    o = mix(_e376, _e377, vec4(_e378));
    let _e382 = o[3u];
    if (_e382 > 0f) {
        let _e384 = o;
        let _e387 = o[3u];
        let _e389 = (_e384.xyz / vec3(_e387));
        let _e391 = o[3u];
        local_1 = vec4<f32>(_e389.x, _e389.y, _e389.z, _e391);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e396 = local_1;
    return _e396;
}

fn main_1() {
    var param_23: vec2<f32>;

    let _e60 = _uv_1;
    param_23 = _e60;
    let _e61 = transition((&param_23));
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
