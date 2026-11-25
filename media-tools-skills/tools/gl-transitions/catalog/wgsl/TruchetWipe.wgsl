// TruchetWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TruchetWipe.glsl
// Author: gre
// License: MIT
// Description: A grid of square tiles, each holding two quarter-circle arcs, links into long winding paths; starting from the middle and spreading outward, the paths are drawn as thin lines of the incoming image, then thicken into bands with a dark outline and a soft shadow until they merge over the whole frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cells: f32,
    outline: f32,
    spread: f32,
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

fn hash12(v: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e41 = (*v);
    v3_ = fract((_e41.xyx * 0.1031f));
    let _e45 = v3_;
    let _e46 = v3_;
    let _e51 = v3_;
    v3_ = (_e51 + vec3(dot(_e45, (_e46.yzx + vec3(33.33f)))));
    let _e55 = v3_[0u];
    let _e57 = v3_[1u];
    let _e60 = v3_[2u];
    return fract(((_e55 + _e57) * _e60));
}

fn vnoise(v_1: ptr<function, vec2<f32>>) -> f32 {
    var i: vec2<f32>;
    var f: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;

    let _e46 = (*v_1);
    i = floor(_e46);
    let _e48 = (*v_1);
    f = fract(_e48);
    let _e50 = f;
    let _e51 = f;
    let _e53 = f;
    f = ((_e50 * _e51) * (vec2(3f) - (_e53 * 2f)));
    let _e58 = i;
    param = _e58;
    let _e59 = hash12((&param));
    let _e60 = i;
    param_1 = (_e60 + vec2<f32>(1f, 0f));
    let _e62 = hash12((&param_1));
    let _e64 = f[0u];
    let _e66 = i;
    param_2 = (_e66 + vec2<f32>(0f, 1f));
    let _e68 = hash12((&param_2));
    let _e69 = i;
    param_3 = (_e69 + vec2<f32>(1f, 1f));
    let _e71 = hash12((&param_3));
    let _e73 = f[0u];
    let _e76 = f[1u];
    return mix(mix(_e59, _e62, _e64), mix(_e68, _e71, _e73), _e76);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e41 = (*uv)[0u];
    let _e43 = (*uv)[1u];
    let _e46 = textureSampleLevel(_to, _sampler, vec2<f32>(_e41, (1f - _e43)), 0f);
    return _e46;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e41 = (*uv_1)[0u];
    let _e43 = (*uv_1)[1u];
    let _e46 = textureSampleLevel(_from, _sampler, vec2<f32>(_e41, (1f - _e43)), 0f);
    return _e46;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var n: f32;
    var p: vec2<f32>;
    var g: vec2<f32>;
    var cell: vec2<f32>;
    var q: vec2<f32>;
    var param_6: vec2<f32>;
    var d: f32;
    var T: f32;
    var param_7: vec2<f32>;
    var lag: f32;
    var s: f32;
    var aa: f32;
    var k: f32;
    var w: f32;
    var e: f32;
    var band: f32;
    var gap: f32;
    var fall: f32;
    var edge: f32;
    var shade: f32;
    var a: vec4<f32>;
    var param_8: vec2<f32>;
    var b: vec4<f32>;
    var param_9: vec2<f32>;
    var o: vec4<f32>;
    var local: vec4<f32>;

    let _e69 = uniforms.progress;
    if (_e69 <= 0f) {
        let _e71 = (*uv_2);
        param_4 = _e71;
        let _e72 = getFromColor((&param_4));
        return _e72;
    }
    let _e74 = uniforms.progress;
    if (_e74 >= 1f) {
        let _e76 = (*uv_2);
        param_5 = _e76;
        let _e77 = getToColor((&param_5));
        return _e77;
    }
    let _e79 = uniforms.cells;
    n = max(floor((_e79 + 0.5f)), 1f);
    let _e83 = (*uv_2);
    let _e87 = uniforms.ratio;
    p = ((_e83 - vec2(0.5f)) * vec2<f32>(_e87, 1f));
    let _e90 = p;
    let _e91 = n;
    g = ((_e90 * _e91) + vec2(0.5f));
    let _e95 = g;
    cell = floor(_e95);
    let _e97 = g;
    q = fract(_e97);
    let _e99 = cell;
    param_6 = (_e99 + vec2(17f));
    let _e102 = hash12((&param_6));
    if (_e102 > 0.5f) {
        let _e105 = q[0u];
        q[0u] = (1f - _e105);
    }
    let _e108 = q;
    let _e112 = q;
    d = min(abs((length(_e108) - 0.5f)), abs((length((_e112 - vec2(1f))) - 0.5f)));
    let _e119 = p;
    let _e122 = uniforms.ratio;
    let _e127 = p;
    param_7 = ((_e127 * 3f) + vec2(4f));
    let _e131 = vnoise((&param_7));
    T = clamp(((length(_e119) / (0.5f * length(vec2<f32>(_e122, 1f)))) + (0.4f * (_e131 - 0.5f))), 0f, 1f);
    let _e137 = uniforms.spread;
    lag = (0.8f * clamp(_e137, 0f, 1f));
    let _e141 = uniforms.progress;
    let _e142 = lag;
    let _e143 = T;
    let _e146 = lag;
    s = clamp(((_e141 - (_e142 * _e143)) / (0.95f - _e146)), 0f, 1f);
    let _e150 = n;
    aa = (0.0012f * _e150);
    let _e152 = s;
    k = clamp(((_e152 - 0.25f) / 0.75f), 0f, 1f);
    let _e156 = s;
    let _e159 = n;
    let _e162 = aa;
    let _e166 = k;
    let _e168 = k;
    w = ((0.08f * smoothstep(0f, 0.3f, _e156)) + (((((0.5f + (0.003f * _e159)) + (3f * _e162)) - 0.08f) * _e166) * _e168));
    let _e171 = d;
    let _e172 = w;
    e = (_e171 - _e172);
    let _e174 = aa;
    let _e176 = e;
    band = (1f - smoothstep((-2f * _e174), 0f, _e176));
    let _e179 = e;
    let _e180 = aa;
    gap = max((_e179 + _e180), 0f);
    let _e183 = n;
    let _e185 = gap;
    fall = (1f - smoothstep(0f, (0.025f * _e183), _e185));
    let _e188 = n;
    let _e190 = n;
    let _e192 = aa;
    let _e195 = gap;
    let _e199 = fall;
    let _e201 = fall;
    edge = max((0.8f * (1f - smoothstep((0.003f * _e188), ((0.003f * _e190) + (2f * _e192)), _e195))), ((0.4f * _e199) * _e201));
    let _e205 = uniforms.outline;
    let _e207 = w;
    let _e210 = edge;
    shade = ((clamp(_e205, 0f, 1f) * smoothstep(0f, 0.08f, _e207)) * _e210);
    let _e212 = (*uv_2);
    param_8 = _e212;
    let _e213 = getFromColor((&param_8));
    a = _e213;
    let _e214 = shade;
    let _e216 = a;
    let _e218 = (_e216.xyz * (1f - _e214));
    a[0u] = _e218.x;
    a[1u] = _e218.y;
    a[2u] = _e218.z;
    let _e225 = (*uv_2);
    param_9 = _e225;
    let _e226 = getToColor((&param_9));
    b = _e226;
    let _e227 = a;
    let _e230 = a[3u];
    let _e231 = (_e227.xyz * _e230);
    let _e233 = a[3u];
    let _e238 = b;
    let _e241 = b[3u];
    let _e242 = (_e238.xyz * _e241);
    let _e244 = b[3u];
    let _e249 = band;
    o = mix(vec4<f32>(_e231.x, _e231.y, _e231.z, _e233), vec4<f32>(_e242.x, _e242.y, _e242.z, _e244), vec4(_e249));
    let _e253 = o[3u];
    if (_e253 > 0f) {
        let _e255 = o;
        let _e258 = o[3u];
        let _e260 = (_e255.xyz / vec3(_e258));
        let _e262 = o[3u];
        local = vec4<f32>(_e260.x, _e260.y, _e260.z, _e262);
    } else {
        local = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e267 = local;
    return _e267;
}

fn main_1() {
    var param_10: vec2<f32>;

    let _e40 = _uv_1;
    param_10 = _e40;
    let _e41 = transition((&param_10));
    _fragColor = _e41;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
