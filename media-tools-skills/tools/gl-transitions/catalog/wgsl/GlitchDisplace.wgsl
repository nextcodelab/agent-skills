// GlitchDisplace — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchDisplace.glsl
// Author: Matt DesLauriers
// License: MIT
// Description: Blocks of the image are displaced in a glitch that flashes into the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
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

fn ease2(t: ptr<function, f32>) -> f32 {
    var local: f32;

    let _e35 = (*t);
    if (_e35 == 1f) {
        let _e37 = (*t);
        local = _e37;
    } else {
        let _e38 = (*t);
        local = (1f - pow(2f, (-10f * _e38)));
    }
    let _e42 = local;
    return _e42;
}

fn random(co: ptr<function, vec2<f32>>) -> f32 {
    var a: f32;
    var b: f32;
    var c: f32;
    var dt: f32;
    var sn: f32;

    a = 12.9898f;
    b = 78.233f;
    c = 43758.547f;
    let _e39 = (*co);
    let _e40 = a;
    let _e41 = b;
    dt = dot(_e39, vec2<f32>(_e40, _e41));
    let _e44 = dt;
    sn = (_e44 - (floor((_e44 / 3.14f)) * 3.14f));
    let _e49 = sn;
    let _e51 = c;
    return fract((sin(_e49) * _e51));
}

fn voronoi(x: ptr<function, vec2<f32>>) -> f32 {
    var p: vec2<f32>;
    var f: vec2<f32>;
    var res: f32;
    var j: f32;
    var i: f32;
    var b_1: vec2<f32>;
    var r: vec2<f32>;
    var param: vec2<f32>;
    var d: f32;

    let _e43 = (*x);
    p = floor(_e43);
    let _e45 = (*x);
    f = fract(_e45);
    res = 8f;
    j = -1f;
    loop {
        let _e47 = j;
        if (_e47 <= 1f) {
            i = -1f;
            loop {
                let _e49 = i;
                if (_e49 <= 1f) {
                    let _e51 = i;
                    let _e52 = j;
                    b_1 = vec2<f32>(_e51, _e52);
                    let _e54 = b_1;
                    let _e55 = f;
                    let _e57 = p;
                    let _e58 = b_1;
                    param = (_e57 + _e58);
                    let _e60 = random((&param));
                    r = ((_e54 - _e55) + vec2(_e60));
                    let _e63 = r;
                    let _e64 = r;
                    d = dot(_e63, _e64);
                    let _e66 = res;
                    let _e67 = d;
                    res = min(_e66, _e67);
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e69 = i;
                    i = (_e69 + 1f);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e71 = j;
            j = (_e71 + 1f);
        }
    }
    let _e73 = res;
    return sqrt(_e73);
}

fn displace(tex: ptr<function, vec4<f32>>, texCoord: ptr<function, vec2<f32>>, dotDepth: ptr<function, f32>, textureDepth: ptr<function, f32>, strength: ptr<function, f32>) -> vec2<f32> {
    var b_2: f32;
    var param_1: vec2<f32>;
    var g: f32;
    var param_2: vec2<f32>;
    var r_1: f32;
    var param_3: vec2<f32>;
    var dt_1: vec4<f32>;
    var dis: vec4<f32>;
    var res_uv: vec2<f32>;

    let _e47 = (*texCoord);
    param_1 = ((_e47 * 0.003f) + vec2(2f));
    let _e51 = voronoi((&param_1));
    b_2 = _e51;
    let _e52 = (*texCoord);
    param_2 = (_e52 * 0.2f);
    let _e54 = voronoi((&param_2));
    g = _e54;
    let _e55 = (*texCoord);
    param_3 = (_e55 - vec2(1f));
    let _e58 = voronoi((&param_3));
    r_1 = _e58;
    let _e59 = (*tex);
    dt_1 = (_e59 * 1f);
    let _e61 = dt_1;
    let _e62 = (*dotDepth);
    let _e66 = (*tex);
    let _e67 = (*textureDepth);
    dis = (((_e61 * _e62) + vec4(1f)) - (_e66 * _e67));
    let _e71 = dis[0u];
    let _e73 = (*textureDepth);
    let _e74 = (*dotDepth);
    dis[0u] = ((_e71 - 1f) + (_e73 * _e74));
    let _e79 = dis[1u];
    let _e81 = (*textureDepth);
    let _e82 = (*dotDepth);
    dis[1u] = ((_e79 - 1f) + (_e81 * _e82));
    let _e86 = (*strength);
    let _e88 = dis[0u];
    dis[0u] = (_e88 * _e86);
    let _e91 = (*strength);
    let _e93 = dis[1u];
    dis[1u] = (_e93 * _e91);
    let _e96 = (*texCoord);
    res_uv = _e96;
    let _e98 = res_uv[0u];
    let _e100 = dis[0u];
    res_uv[0u] = ((_e98 + _e100) - 0f);
    let _e105 = res_uv[1u];
    let _e107 = dis[1u];
    res_uv[1u] = (_e105 + _e107);
    let _e110 = res_uv;
    return _e110;
}

fn ease1(t_1: ptr<function, f32>) -> f32 {
    var local_1: f32;
    var local_2: f32;

    let _e36 = (*t_1);
    let _e38 = (*t_1);
    if ((_e36 == 0f) || (_e38 == 1f)) {
        let _e41 = (*t_1);
        local_1 = _e41;
    } else {
        let _e42 = (*t_1);
        if (_e42 < 0.5f) {
            let _e44 = (*t_1);
            local_2 = (0.5f * pow(2f, ((20f * _e44) - 10f)));
        } else {
            let _e49 = (*t_1);
            local_2 = ((-0.5f * pow(2f, (10f - (_e49 * 20f)))) + 1f);
        }
        let _e55 = local_2;
        local_1 = _e55;
    }
    let _e56 = local_1;
    return _e56;
}

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

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_1: vec2<f32>;
    var color1_: vec4<f32>;
    var param_4: vec2<f32>;
    var color2_: vec4<f32>;
    var param_5: vec2<f32>;
    var disp: vec2<f32>;
    var param_6: f32;
    var param_7: vec4<f32>;
    var param_8: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var disp2_: vec2<f32>;
    var param_12: f32;
    var param_13: vec4<f32>;
    var param_14: vec2<f32>;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var dColor1_: vec4<f32>;
    var param_18: vec2<f32>;
    var dColor2_: vec4<f32>;
    var param_19: vec2<f32>;
    var val: f32;
    var param_20: f32;
    var gray: vec3<f32>;

    let _e60 = (*uv_2);
    p_1 = (_e60 / vec2<f32>(1f, 1f));
    let _e62 = p_1;
    param_4 = _e62;
    let _e63 = getFromColor((&param_4));
    color1_ = _e63;
    let _e64 = p_1;
    param_5 = _e64;
    let _e65 = getToColor((&param_5));
    color2_ = _e65;
    let _e67 = uniforms.progress;
    param_6 = _e67;
    let _e68 = ease1((&param_6));
    let _e70 = color1_;
    param_7 = _e70;
    let _e71 = p_1;
    param_8 = _e71;
    param_9 = 0.33f;
    param_10 = 0.7f;
    param_11 = (1f - _e68);
    let _e72 = displace((&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
    disp = _e72;
    let _e74 = uniforms.progress;
    param_12 = _e74;
    let _e75 = ease2((&param_12));
    let _e76 = color2_;
    param_13 = _e76;
    let _e77 = p_1;
    param_14 = _e77;
    param_15 = 0.33f;
    param_16 = 0.5f;
    param_17 = _e75;
    let _e78 = displace((&param_13), (&param_14), (&param_15), (&param_16), (&param_17));
    disp2_ = _e78;
    let _e79 = disp;
    param_18 = _e79;
    let _e80 = getToColor((&param_18));
    dColor1_ = _e80;
    let _e81 = disp2_;
    param_19 = _e81;
    let _e82 = getFromColor((&param_19));
    dColor2_ = _e82;
    let _e84 = uniforms.progress;
    param_20 = _e84;
    let _e85 = ease1((&param_20));
    val = _e85;
    let _e86 = dColor2_;
    let _e87 = dColor1_;
    gray = vec3(dot(min(_e86, _e87).xyz, vec3<f32>(0.299f, 0.587f, 0.114f)));
    let _e92 = gray;
    let _e93 = (_e92 * 2f);
    let _e95 = dColor2_[3u];
    dColor2_ = vec4<f32>(_e93.x, _e93.y, _e93.z, _e95);
    let _e100 = color1_;
    let _e101 = dColor2_;
    let _e103 = uniforms.progress;
    color1_ = mix(_e100, _e101, vec4(smoothstep(0f, 0.5f, _e103)));
    let _e107 = color2_;
    let _e108 = dColor1_;
    let _e110 = uniforms.progress;
    color2_ = mix(_e107, _e108, vec4(smoothstep(1f, 0.5f, _e110)));
    let _e114 = color1_;
    let _e115 = color2_;
    let _e116 = val;
    return mix(_e114, _e115, vec4(_e116));
}

fn main_1() {
    var param_21: vec2<f32>;

    let _e34 = _uv_1;
    param_21 = _e34;
    let _e35 = transition((&param_21));
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
