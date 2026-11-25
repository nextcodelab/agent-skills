// EdgeGlow — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/EdgeGlow.glsl
// Author: Woohyun Kim
// License: MIT
// Description: Both images fade through black with their edges glowing
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    edge_thickness: f32,
    edge_brightness: f32,
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
    let _e26 = (*uv)[0u];
    let _e28 = (*uv)[1u];
    let _e31 = textureSampleLevel(_to, _sampler, vec2<f32>(_e26, (1f - _e28)), 0f);
    return _e31;
}

fn detectEdgeColor(c: ptr<function, array<vec3<f32>, 9>>) -> vec3<f32> {
    var dx: vec3<f32>;
    var dy: vec3<f32>;
    var delta: f32;

    let _e29 = (*c)[7i];
    let _e31 = (*c)[1i];
    let _e36 = (*c)[2i];
    let _e38 = (*c)[6i];
    let _e43 = (*c)[8i];
    let _e45 = (*c)[0i];
    dx = (((abs((_e29 - _e31)) * 2f) + abs((_e36 - _e38))) + abs((_e43 - _e45)));
    let _e50 = (*c)[3i];
    let _e52 = (*c)[5i];
    let _e57 = (*c)[6i];
    let _e59 = (*c)[8i];
    let _e64 = (*c)[0i];
    let _e66 = (*c)[2i];
    dy = (((abs((_e50 - _e52)) * 2f) + abs((_e57 - _e59))) + abs((_e64 - _e66)));
    let _e70 = dx;
    let _e71 = dy;
    delta = length((((_e70 + _e71) * 0.25f) * 0.5f));
    let _e77 = uniforms.edge_brightness;
    let _e78 = delta;
    let _e82 = (*c)[4i];
    return (_e82 * clamp((_e77 * _e78), 0f, 1f));
}

fn getToEdgeColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    var alpha: f32;
    var i: i32;
    var j: i32;
    var color: vec4<f32>;
    var param: vec2<f32>;
    var c_1: array<vec3<f32>, 9>;
    var param_1: array<vec3<f32>, 9>;

    alpha = 0f;
    i = 0i;
    loop {
        let _e32 = i;
        if (_e32 < 3i) {
            j = 0i;
            loop {
                let _e34 = j;
                if (_e34 < 3i) {
                    let _e36 = (*uv_1);
                    let _e38 = uniforms.edge_thickness;
                    let _e39 = i;
                    let _e42 = j;
                    param = (_e36 + (vec2<f32>(f32((_e39 - 1i)), f32((_e42 - 1i))) * _e38));
                    let _e48 = getToColor((&param));
                    color = _e48;
                    let _e49 = i;
                    let _e51 = j;
                    let _e53 = color;
                    c_1[((3i * _e49) + _e51)] = _e53.xyz;
                    let _e56 = i;
                    let _e58 = j;
                    if ((_e56 == 1i) && (_e58 == 1i)) {
                        let _e62 = color[3u];
                        alpha = _e62;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e63 = j;
                    j = (_e63 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e65 = i;
            i = (_e65 + 1i);
        }
    }
    let _e67 = c_1;
    param_1 = _e67;
    let _e68 = detectEdgeColor((&param_1));
    let _e69 = alpha;
    return vec4<f32>(_e68.x, _e68.y, _e68.z, _e69);
}

fn getFromColor(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e26 = (*uv_2)[0u];
    let _e28 = (*uv_2)[1u];
    let _e31 = textureSampleLevel(_from, _sampler, vec2<f32>(_e26, (1f - _e28)), 0f);
    return _e31;
}

fn getFromEdgeColor(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var alpha_1: f32;
    var i_1: i32;
    var j_1: i32;
    var color_1: vec4<f32>;
    var param_2: vec2<f32>;
    var c_2: array<vec3<f32>, 9>;
    var param_3: array<vec3<f32>, 9>;

    alpha_1 = 0f;
    i_1 = 0i;
    loop {
        let _e32 = i_1;
        if (_e32 < 3i) {
            j_1 = 0i;
            loop {
                let _e34 = j_1;
                if (_e34 < 3i) {
                    let _e36 = (*uv_3);
                    let _e38 = uniforms.edge_thickness;
                    let _e39 = i_1;
                    let _e42 = j_1;
                    param_2 = (_e36 + (vec2<f32>(f32((_e39 - 1i)), f32((_e42 - 1i))) * _e38));
                    let _e48 = getFromColor((&param_2));
                    color_1 = _e48;
                    let _e49 = i_1;
                    let _e51 = j_1;
                    let _e53 = color_1;
                    c_2[((3i * _e49) + _e51)] = _e53.xyz;
                    let _e56 = i_1;
                    let _e58 = j_1;
                    if ((_e56 == 1i) && (_e58 == 1i)) {
                        let _e62 = color_1[3u];
                        alpha_1 = _e62;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e63 = j_1;
                    j_1 = (_e63 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e65 = i_1;
            i_1 = (_e65 + 1i);
        }
    }
    let _e67 = c_2;
    param_3 = _e67;
    let _e68 = detectEdgeColor((&param_3));
    let _e69 = alpha_1;
    return vec4<f32>(_e68.x, _e68.y, _e68.z, _e69);
}

fn transition(uv_4: ptr<function, vec2<f32>>) -> vec4<f32> {
    var start: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var end: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;

    let _e31 = (*uv_4);
    param_4 = _e31;
    let _e32 = getFromColor((&param_4));
    let _e33 = (*uv_4);
    param_5 = _e33;
    let _e34 = getFromEdgeColor((&param_5));
    let _e36 = uniforms.progress;
    start = mix(_e32, _e34, vec4(clamp((2f * _e36), 0f, 1f)));
    let _e41 = (*uv_4);
    param_6 = _e41;
    let _e42 = getToEdgeColor((&param_6));
    let _e43 = (*uv_4);
    param_7 = _e43;
    let _e44 = getToColor((&param_7));
    let _e46 = uniforms.progress;
    end = mix(_e42, _e44, vec4(clamp((2f * (_e46 - 0.5f)), 0f, 1f)));
    let _e52 = start;
    let _e53 = end;
    let _e55 = uniforms.progress;
    return mix(_e52, _e53, vec4(_e55));
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e25 = _uv_1;
    param_8 = _e25;
    let _e26 = transition((&param_8));
    _fragColor = _e26;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
