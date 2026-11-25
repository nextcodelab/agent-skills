// Honeycomb — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Honeycomb.glsl
// Author: gre
// License: MIT
// Description: The image splits into hexagons that spin and shrink away in a wave from the center, uncovering the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    size: f32,
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

fn hexDist(p: ptr<function, vec2<f32>>) -> f32 {
    let _e33 = (*p);
    (*p) = abs(_e33);
    let _e36 = (*p)[0u];
    let _e37 = (*p);
    return max(_e36, dot(_e37, vec2<f32>(0.5f, 0.8660254f)));
}

fn rotation(a: ptr<function, f32>) -> mat2x2<f32> {
    let _e33 = (*a);
    let _e35 = (*a);
    let _e37 = (*a);
    let _e40 = (*a);
    return mat2x2<f32>(vec2<f32>(cos(_e33), sin(_e35)), vec2<f32>(-(sin(_e37)), cos(_e40)));
}

fn hexMask(local: ptr<function, vec2<f32>>, s: ptr<function, f32>, a_1: ptr<function, f32>, e: ptr<function, f32>) -> f32 {
    var r: f32;
    var param: f32;
    var param_1: vec2<f32>;

    let _e39 = (*e);
    let _e41 = (*s);
    r = ((0.52f + _e39) * _e41);
    let _e43 = r;
    let _e44 = (*e);
    let _e46 = r;
    let _e47 = (*a_1);
    param = -(_e47);
    let _e49 = rotation((&param));
    let _e50 = (*local);
    param_1 = (_e49 * _e50);
    let _e52 = hexDist((&param_1));
    return (1f - smoothstep((_e43 - _e44), _e46, _e52));
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

fn hexUv(uv_2: ptr<function, vec2<f32>>, local_1: ptr<function, vec2<f32>>, cellToUv: ptr<function, vec2<f32>>, s_1: ptr<function, f32>, a_2: ptr<function, f32>) -> vec2<f32> {
    var param_2: f32;

    let _e38 = (*uv_2);
    let _e39 = (*cellToUv);
    let _e40 = (*a_2);
    param_2 = -(_e40);
    let _e42 = rotation((&param_2));
    let _e43 = (*local_1);
    let _e45 = (*s_1);
    let _e49 = (*local_1);
    return (_e38 + (_e39 * (((_e42 * _e43) / vec2(max(_e45, 0.001f))) - _e49)));
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var toCells: vec2<f32>;
    var p_1: vec2<f32>;
    var a_3: vec2<f32>;
    var b: vec2<f32>;
    var center: vec2<f32>;
    var local_2: vec2<f32>;
    var d: f32;
    var t: f32;
    var s_2: f32;
    var turn: f32;
    var fromTile: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: f32;
    var param_7: f32;
    var param_8: vec2<f32>;
    var below: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: vec2<f32>;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;

    let _e61 = uniforms.ratio;
    let _e64 = uniforms.size;
    let _e67 = uniforms.ratio;
    toCells = ((vec2<f32>(_e61, 1f) * _e64) / vec2(min(_e67, 1f)));
    let _e71 = (*uv_3);
    let _e74 = toCells;
    p_1 = ((_e71 - vec2(0.5f)) * _e74);
    let _e76 = p_1;
    a_3 = ((floor((_e76 / vec2<f32>(1f, 1.7320508f))) + vec2(0.5f)) * vec2<f32>(1f, 1.7320508f));
    let _e82 = p_1;
    b = ((floor(((_e82 - vec2<f32>(0.5f, 0.8660254f)) / vec2<f32>(1f, 1.7320508f))) + vec2(1f)) * vec2<f32>(1f, 1.7320508f));
    let _e89 = p_1;
    let _e90 = a_3;
    let _e92 = p_1;
    let _e93 = a_3;
    let _e96 = p_1;
    let _e97 = b;
    let _e99 = p_1;
    let _e100 = b;
    let _e104 = a_3;
    let _e105 = b;
    center = select(_e105, _e104, vec2((dot((_e89 - _e90), (_e92 - _e93)) < dot((_e96 - _e97), (_e99 - _e100)))));
    let _e108 = p_1;
    let _e109 = center;
    local_2 = (_e108 - _e109);
    let _e111 = center;
    let _e112 = toCells;
    let _e115 = uniforms.ratio;
    let _e120 = uniforms.ratio;
    d = min((length(((_e111 / _e112) * vec2<f32>(_e115, 1f))) / (0.5f * length(vec2<f32>(_e120, 1f)))), 1f);
    let _e127 = uniforms.progress;
    let _e128 = d;
    t = clamp(((_e127 - (0.6f * _e128)) / 0.4f), 0f, 1f);
    let _e133 = t;
    s_2 = (1f - smoothstep(0.1f, 1f, _e133));
    let _e136 = t;
    let _e138 = t;
    turn = ((1.8f * _e136) * (2f - _e138));
    let _e141 = toCells;
    let _e144 = (*uv_3);
    param_3 = _e144;
    let _e145 = local_2;
    param_4 = _e145;
    param_5 = (vec2(1f) / _e141);
    let _e146 = s_2;
    param_6 = _e146;
    let _e147 = turn;
    param_7 = _e147;
    let _e148 = hexUv((&param_3), (&param_4), (&param_5), (&param_6), (&param_7));
    param_8 = _e148;
    let _e149 = getFromColor((&param_8));
    fromTile = _e149;
    let _e150 = t;
    let _e153 = fromTile;
    let _e155 = (_e153.xyz * (1f - (0.3f * _e150)));
    fromTile[0u] = _e155.x;
    fromTile[1u] = _e155.y;
    fromTile[2u] = _e155.z;
    let _e162 = (*uv_3);
    param_9 = _e162;
    let _e163 = getToColor((&param_9));
    below = _e163;
    let _e164 = local_2;
    let _e165 = s_2;
    param_10 = (_e164 - (vec2<f32>(0.06f, -0.08f) * _e165));
    let _e168 = s_2;
    param_11 = _e168;
    let _e169 = turn;
    param_12 = _e169;
    param_13 = 0.2f;
    let _e170 = hexMask((&param_10), (&param_11), (&param_12), (&param_13));
    let _e173 = below;
    let _e175 = (_e173.xyz * (1f - (0.5f * _e170)));
    below[0u] = _e175.x;
    below[1u] = _e175.y;
    below[2u] = _e175.z;
    let _e182 = below;
    let _e183 = fromTile;
    let _e184 = local_2;
    param_14 = _e184;
    let _e185 = s_2;
    param_15 = _e185;
    let _e186 = turn;
    param_16 = _e186;
    param_17 = 0.03f;
    let _e187 = hexMask((&param_14), (&param_15), (&param_16), (&param_17));
    return mix(_e182, _e183, vec4(_e187));
}

fn main_1() {
    var param_18: vec2<f32>;

    let _e33 = _uv_1;
    param_18 = _e33;
    let _e34 = transition((&param_18));
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
