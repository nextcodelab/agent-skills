// HeartWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HeartWipe.glsl
// Author: gre
// License: MIT
// Description: A heart grows from the center with a little heartbeat to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    smoothness: f32,
    pulse: f32,
    glowColor: vec3<f32>,
    glow: f32,
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
    let _e41 = (*v);
    let _e42 = (*v);
    return dot(_e41, _e42);
}

fn sdHeart(p: ptr<function, vec2<f32>>) -> f32 {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;

    let _e45 = (*p)[0u];
    (*p)[0u] = abs(_e45);
    let _e49 = (*p)[0u];
    let _e51 = (*p)[1u];
    if ((_e49 + _e51) > 1f) {
        let _e54 = (*p);
        param = (_e54 - vec2<f32>(0.25f, 0.75f));
        let _e56 = dot2((&param));
        return (sqrt(_e56) - 0.35355338f);
    }
    let _e59 = (*p);
    param_1 = (_e59 - vec2<f32>(0f, 1f));
    let _e61 = dot2((&param_1));
    let _e62 = (*p);
    let _e64 = (*p)[0u];
    let _e66 = (*p)[1u];
    param_2 = (_e62 - vec2((0.5f * max((_e64 + _e66), 0f))));
    let _e72 = dot2((&param_2));
    let _e76 = (*p)[0u];
    let _e78 = (*p)[1u];
    return (sqrt(min(_e61, _e72)) * sign((_e76 - _e78)));
}

fn heartScale(p_1: ptr<function, vec2<f32>>) -> f32 {
    var l: f32;
    var d: vec2<f32>;
    var m: vec2<f32>;
    var b: f32;
    var tDisk: f32;
    var param_3: vec2<f32>;
    var tSide: f32;
    var local: f32;
    var tTop: f32;
    var local_1: f32;

    let _e51 = (*p_1);
    l = length(_e51);
    let _e53 = l;
    if (_e53 < 0.000001f) {
        return 0f;
    }
    let _e56 = (*p_1)[0u];
    let _e59 = (*p_1)[1u];
    let _e61 = l;
    d = (vec2<f32>(abs(_e56), _e59) / vec2(_e61));
    m = vec2<f32>(-0.25f, -0.2f);
    let _e64 = m;
    let _e65 = d;
    b = dot(_e64, _e65);
    let _e67 = b;
    let _e69 = b;
    let _e70 = b;
    let _e72 = m;
    param_3 = _e72;
    let _e73 = dot2((&param_3));
    tDisk = (-(_e67) + sqrt((((_e69 * _e70) - _e73) + 0.125f)));
    let _e79 = d[0u];
    let _e81 = d[1u];
    if (_e79 > _e81) {
        let _e84 = d[0u];
        let _e86 = d[1u];
        local = (0.55f / (_e84 - _e86));
    } else {
        local = 1000000f;
    }
    let _e89 = local;
    tSide = _e89;
    let _e91 = d[0u];
    let _e93 = d[1u];
    if ((_e91 + _e93) > 0f) {
        let _e97 = d[0u];
        let _e99 = d[1u];
        local_1 = (0.45f / (_e97 + _e99));
    } else {
        local_1 = 1000000f;
    }
    let _e102 = local_1;
    tTop = _e102;
    let _e103 = l;
    let _e104 = tDisk;
    let _e105 = tSide;
    let _e106 = tTop;
    return (_e103 / max(_e104, min(_e105, _e106)));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e42 = (*uv)[0u];
    let _e44 = (*uv)[1u];
    let _e47 = textureSampleLevel(_to, _sampler, vec2<f32>(_e42, (1f - _e44)), 0f);
    return _e47;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e42 = (*uv_1)[0u];
    let _e44 = (*uv_1)[1u];
    let _e47 = textureSampleLevel(_from, _sampler, vec2<f32>(_e42, (1f - _e44)), 0f);
    return _e47;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param_4: vec2<f32>;
    var b_1: vec4<f32>;
    var param_5: vec2<f32>;
    var asp: vec2<f32>;
    var c: vec2<f32>;
    var cx: f32;
    var full: f32;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var sm: f32;
    var p_2: f32;
    var e: f32;
    var env: f32;
    var beat: f32;
    var s: f32;
    var q: vec2<f32>;
    var d_1: f32;
    var param_11: vec2<f32>;
    var m_1: f32;
    var col: vec4<f32>;
    var light: f32;

    let _e66 = (*uv_2);
    param_4 = _e66;
    let _e67 = getFromColor((&param_4));
    a = _e67;
    let _e68 = (*uv_2);
    param_5 = _e68;
    let _e69 = getToColor((&param_5));
    b_1 = _e69;
    let _e71 = uniforms.ratio;
    asp = vec2<f32>(_e71, 1f);
    let _e74 = uniforms.center;
    let _e75 = asp;
    c = (_e74 * _e75);
    let _e79 = uniforms.center[0u];
    let _e82 = uniforms.ratio;
    cx = (clamp(_e79, 0f, 1f) * _e82);
    let _e84 = c;
    param_6 = (vec2<f32>(0f, 0f) - _e84);
    let _e86 = heartScale((&param_6));
    let _e88 = uniforms.ratio;
    let _e90 = c;
    param_7 = (vec2<f32>(_e88, 0f) - _e90);
    let _e92 = heartScale((&param_7));
    let _e94 = c;
    param_8 = (vec2<f32>(0f, 1f) - _e94);
    let _e96 = heartScale((&param_8));
    let _e98 = uniforms.ratio;
    let _e100 = c;
    param_9 = (vec2<f32>(_e98, 1f) - _e100);
    let _e102 = heartScale((&param_9));
    let _e105 = cx;
    let _e107 = c;
    param_10 = (vec2<f32>(_e105, 1f) - _e107);
    let _e109 = heartScale((&param_10));
    full = max(max(max(_e86, _e92), max(_e96, _e102)), _e109);
    let _e112 = uniforms.smoothness;
    sm = max(_e112, 0.001f);
    let _e114 = sm;
    let _e116 = full;
    full = (_e116 + (4f * _e114));
    let _e119 = uniforms.progress;
    p_2 = _e119;
    let _e120 = p_2;
    let _e121 = p_2;
    let _e123 = p_2;
    e = ((_e120 * _e121) * (2f - _e123));
    let _e126 = p_2;
    env = max(sin((3.1415927f * _e126)), 0f);
    let _e130 = p_2;
    let _e133 = env;
    let _e135 = env;
    beat = ((sin((12.566371f * _e130)) * _e133) * _e135);
    let _e137 = full;
    let _e138 = e;
    let _e140 = uniforms.pulse;
    let _e142 = beat;
    s = (_e137 * clamp((_e138 + ((0.09f * _e140) * _e142)), 0f, 1f));
    let _e147 = s;
    if (_e147 <= 0f) {
        let _e149 = a;
        return _e149;
    }
    let _e150 = (*uv_2);
    let _e151 = asp;
    let _e153 = c;
    q = ((_e150 * _e151) - _e153);
    let _e155 = s;
    let _e156 = q;
    let _e157 = s;
    param_11 = ((_e156 / vec2(_e157)) + vec2<f32>(0f, 0.55f));
    let _e161 = sdHeart((&param_11));
    d_1 = (_e155 * _e161);
    let _e163 = sm;
    let _e164 = d_1;
    m_1 = smoothstep(0f, _e163, -(_e164));
    let _e167 = a;
    let _e168 = b_1;
    let _e169 = m_1;
    col = mix(_e167, _e168, vec4(_e169));
    let _e172 = d_1;
    let _e175 = sm;
    let _e179 = m_1;
    let _e183 = uniforms.glow;
    let _e185 = env;
    light = (((exp((-(max(_e172, 0f)) / (0.008f + _e175))) * (1f - _e179)) * _e183) * min(1f, (4f * _e185)));
    let _e189 = col;
    let _e191 = uniforms.glowColor;
    let _e192 = light;
    let _e193 = (_e191 * _e192);
    return (_e189 + vec4<f32>(_e193.x, _e193.y, _e193.z, 0f));
}

fn main_1() {
    var param_12: vec2<f32>;

    let _e41 = _uv_1;
    param_12 = _e41;
    let _e42 = transition((&param_12));
    _fragColor = _e42;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
