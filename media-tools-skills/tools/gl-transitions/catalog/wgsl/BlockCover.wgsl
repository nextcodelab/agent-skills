// BlockCover — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BlockCover.glsl
// Author: gre
// License: MIT
// Description: Blocks of a solid color pop in at random over the outgoing image until they cover the frame, then pop out in another random order to show the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    blocks: i32,
    color: vec4<f32>,
    pop: f32,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv)[0u];
    let _e37 = (*uv)[1u];
    let _e40 = textureSampleLevel(_to, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv_1)[0u];
    let _e37 = (*uv_1)[1u];
    let _e40 = textureSampleLevel(_from, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e35 = (*p);
    p3_ = fract((_e35.xyx * 0.1031f));
    let _e39 = p3_;
    let _e40 = p3_;
    let _e45 = p3_;
    p3_ = (_e45 + vec3(dot(_e39, (_e40.yzx + vec3(33.33f)))));
    let _e49 = p3_[0u];
    let _e51 = p3_[1u];
    let _e54 = p3_[2u];
    return fract(((_e49 + _e51) * _e54));
}

fn timing(cell: ptr<function, vec2<f32>>) -> vec2<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e36 = (*cell);
    param = (_e36 + vec2(0.5f));
    let _e39 = hash((&param));
    let _e41 = (*cell);
    param_1 = (_e41 + vec2(71.7f));
    let _e44 = hash((&param_1));
    return vec2<f32>((0.29f * _e39), (0.47f + (0.39f * _e44)));
}

fn backOut(t: ptr<function, f32>, c: ptr<function, f32>) -> f32 {
    var u: f32;

    let _e36 = (*t);
    u = (_e36 - 1f);
    let _e38 = (*c);
    let _e40 = u;
    let _e42 = u;
    let _e44 = u;
    let _e47 = (*c);
    let _e48 = u;
    let _e50 = u;
    return ((1f + ((((_e38 + 1f) * _e40) * _e42) * _e44)) + ((_e47 * _e48) * _e50));
}

fn coverage(q: ptr<function, vec2<f32>>, cell_1: ptr<function, vec2<f32>>, s: ptr<function, f32>, sm: ptr<function, f32>) -> f32 {
    var h: f32;
    var d: vec2<f32>;
    var local: f32;

    let _e40 = (*s);
    let _e41 = (*sm);
    h = (_e40 * (0.5f + _e41));
    let _e44 = (*q);
    let _e45 = (*cell_1);
    d = abs(((_e44 - _e45) - vec2(0.5f)));
    let _e50 = (*s);
    if (_e50 > 0f) {
        let _e52 = h;
        let _e53 = (*sm);
        let _e55 = h;
        let _e57 = d[0u];
        let _e59 = d[1u];
        local = (1f - smoothstep((_e52 - _e53), _e55, max(_e57, _e59)));
    } else {
        local = 0f;
    }
    let _e63 = local;
    return _e63;
}

fn blockScale(cell_2: ptr<function, vec2<f32>>, c_1: ptr<function, f32>) -> f32 {
    var t_1: vec2<f32>;
    var param_2: vec2<f32>;
    var a: f32;
    var b: f32;
    var local_1: f32;
    var param_3: f32;
    var param_4: f32;

    let _e42 = (*cell_2);
    param_2 = _e42;
    let _e43 = timing((&param_2));
    t_1 = _e43;
    let _e45 = uniforms.progress;
    let _e47 = t_1[0u];
    a = clamp(((_e45 - _e47) / 0.14f), 0f, 1f);
    let _e52 = uniforms.progress;
    let _e54 = t_1[1u];
    b = clamp(((_e52 - _e54) / 0.14f), 0f, 1f);
    let _e58 = b;
    if (_e58 > 0f) {
        let _e60 = b;
        let _e62 = b;
        local_1 = ((1f - _e60) * (1f - _e62));
    } else {
        let _e65 = a;
        param_3 = _e65;
        let _e66 = (*c_1);
        param_4 = _e66;
        let _e67 = backOut((&param_3), (&param_4));
        local_1 = _e67;
    }
    let _e68 = local_1;
    return _e68;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var nLong: f32;
    var n: vec2<f32>;
    var local_2: vec2<f32>;
    var q_1: vec2<f32>;
    var cell_3: vec2<f32>;
    var sm_1: f32;
    var c_2: f32;
    var s_1: f32;
    var param_5: vec2<f32>;
    var param_6: f32;
    var cover: f32;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var u_1: f32;
    var reach: f32;
    var param_11: f32;
    var param_12: f32;
    var o: vec2<f32>;
    var j: i32;
    var i: i32;
    var nb: vec2<f32>;
    var inside: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: f32;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var param_17: f32;
    var param_18: f32;
    var t_2: vec2<f32>;
    var param_19: vec2<f32>;
    var under: vec4<f32>;
    var local_3: vec4<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var phi_398_: bool;

    let _e71 = uniforms.blocks;
    nLong = max(f32(_e71), 1f);
    let _e75 = uniforms.ratio;
    if (_e75 >= 1f) {
        let _e77 = nLong;
        let _e78 = nLong;
        let _e80 = uniforms.ratio;
        local_2 = vec2<f32>(_e77, max(1f, floor(((_e78 / _e80) + 0.5f))));
    } else {
        let _e86 = nLong;
        let _e88 = uniforms.ratio;
        let _e93 = nLong;
        local_2 = vec2<f32>(max(1f, floor(((_e86 * _e88) + 0.5f))), _e93);
    }
    let _e95 = local_2;
    n = _e95;
    let _e96 = (*uv_2);
    let _e97 = n;
    q_1 = (_e96 * _e97);
    let _e99 = q_1;
    cell_3 = floor(_e99);
    let _e102 = uniforms.smoothness;
    sm_1 = max(_e102, 0.001f);
    let _e105 = uniforms.pop;
    c_2 = (2f * clamp(_e105, 0f, 1f));
    let _e108 = cell_3;
    param_5 = _e108;
    let _e109 = c_2;
    param_6 = _e109;
    let _e110 = blockScale((&param_5), (&param_6));
    s_1 = _e110;
    let _e111 = s_1;
    if (_e111 >= 1f) {
        let _e114 = uniforms.color;
        return _e114;
    }
    let _e115 = q_1;
    param_7 = _e115;
    let _e116 = cell_3;
    param_8 = _e116;
    let _e117 = s_1;
    param_9 = _e117;
    let _e118 = sm_1;
    param_10 = _e118;
    let _e119 = coverage((&param_7), (&param_8), (&param_9), (&param_10));
    cover = _e119;
    let _e120 = c_2;
    let _e122 = c_2;
    u_1 = ((-2f * _e120) / (3f * (_e122 + 1f)));
    let _e126 = u_1;
    param_11 = (1f + _e126);
    let _e128 = c_2;
    param_12 = _e128;
    let _e129 = backOut((&param_11), (&param_12));
    let _e130 = sm_1;
    reach = (_e129 * (0.5f + _e130));
    let _e133 = q_1;
    let _e134 = cell_3;
    o = abs(((_e133 - _e134) - vec2(0.5f)));
    let _e140 = o[0u];
    let _e142 = o[1u];
    let _e144 = reach;
    if (max(_e140, _e142) > (1f - _e144)) {
        j = -1i;
        loop {
            let _e147 = j;
            if (_e147 <= 1i) {
                i = -1i;
                loop {
                    let _e149 = i;
                    if (_e149 <= 1i) {
                        let _e151 = cell_3;
                        let _e152 = i;
                        let _e154 = j;
                        nb = (_e151 + vec2<f32>(f32(_e152), f32(_e154)));
                        let _e158 = nb;
                        let _e160 = nb;
                        let _e161 = n;
                        inside = (step(vec2<f32>(0f, 0f), _e158) * step(_e160, (_e161 - vec2(1f))));
                        let _e167 = inside[0u];
                        let _e169 = inside[1u];
                        let _e171 = ((_e167 * _e169) > 0f);
                        phi_398_ = _e171;
                        if _e171 {
                            let _e172 = i;
                            let _e174 = j;
                            phi_398_ = ((_e172 != 0i) || (_e174 != 0i));
                        }
                        let _e178 = phi_398_;
                        if _e178 {
                            let _e179 = cover;
                            let _e180 = nb;
                            param_13 = _e180;
                            let _e181 = c_2;
                            param_14 = _e181;
                            let _e182 = blockScale((&param_13), (&param_14));
                            let _e183 = q_1;
                            param_15 = _e183;
                            let _e184 = nb;
                            param_16 = _e184;
                            param_17 = _e182;
                            let _e185 = sm_1;
                            param_18 = _e185;
                            let _e186 = coverage((&param_15), (&param_16), (&param_17), (&param_18));
                            cover = max(_e179, _e186);
                        }
                        continue;
                    } else {
                        break;
                    }
                    continuing {
                        let _e188 = i;
                        i = (_e188 + 1i);
                    }
                }
                continue;
            } else {
                break;
            }
            continuing {
                let _e190 = j;
                j = (_e190 + 1i);
            }
        }
    }
    let _e192 = cell_3;
    param_19 = _e192;
    let _e193 = timing((&param_19));
    t_2 = _e193;
    let _e195 = uniforms.progress;
    let _e197 = t_2[0u];
    let _e200 = t_2[1u];
    if (_e195 < (0.5f * ((_e197 + 0.14f) + _e200))) {
        let _e204 = (*uv_2);
        param_20 = _e204;
        let _e205 = getFromColor((&param_20));
        local_3 = _e205;
    } else {
        let _e206 = (*uv_2);
        param_21 = _e206;
        let _e207 = getToColor((&param_21));
        local_3 = _e207;
    }
    let _e208 = local_3;
    under = _e208;
    let _e209 = under;
    let _e211 = uniforms.color;
    let _e212 = cover;
    return mix(_e209, _e211, vec4(_e212));
}

fn main_1() {
    var param_22: vec2<f32>;

    let _e34 = _uv_1;
    param_22 = _e34;
    let _e35 = transition((&param_22));
    _fragColor = _e35;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
