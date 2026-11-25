// Halftone — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Halftone.glsl
// Author: gre
// License: MIT
// Description: The image breaks into printed halftone dots whose size follows its shades, the dots reshape into the incoming image, then merge back into it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    dots: f32,
    angle: f32,
    paper: vec4<f32>,
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

fn dotRadius(c: ptr<function, vec4<f32>>) -> f32 {
    var shade: f32;

    let _e35 = (*c);
    shade = (1f - dot(_e35.xyz, vec3<f32>(0.299f, 0.587f, 0.114f)));
    let _e39 = shade;
    let _e44 = (*c)[3u];
    return (mix(0.1f, 0.74f, sqrt(clamp(_e39, 0f, 1f))) * _e44);
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
    var h: f32;
    var t: f32;
    var a: f32;
    var rot: mat2x2<f32>;
    var scale: vec2<f32>;
    var g: vec2<f32>;
    var base: vec2<f32>;
    var pixel: vec4<f32>;
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var best: f32;
    var ink: vec4<f32>;
    var i: i32;
    var center: vec2<f32>;
    var cuv: vec2<f32>;
    var cf: vec4<f32>;
    var param_2: vec2<f32>;
    var ct: vec4<f32>;
    var param_3: vec2<f32>;
    var m: f32;
    var r: f32;
    var param_4: vec4<f32>;
    var param_5: vec4<f32>;
    var sd: f32;

    let _e60 = uniforms.progress;
    let _e63 = uniforms.progress;
    h = (smoothstep(0f, 0.3f, _e60) * (1f - smoothstep(0.7f, 1f, _e63)));
    let _e68 = uniforms.progress;
    t = ((_e68 - 0.3f) / 0.4f);
    let _e72 = uniforms.angle;
    a = radians(_e72);
    let _e74 = a;
    let _e76 = a;
    let _e78 = a;
    let _e81 = a;
    rot = mat2x2<f32>(vec2<f32>(cos(_e74), sin(_e76)), vec2<f32>(-(sin(_e78)), cos(_e81)));
    let _e87 = uniforms.ratio;
    let _e90 = uniforms.dots;
    let _e93 = uniforms.ratio;
    scale = ((vec2<f32>(_e87, 1f) * _e90) / vec2(min(_e93, 1f)));
    let _e97 = rot;
    let _e98 = (*uv_2);
    let _e101 = scale;
    g = (_e97 * ((_e98 - vec2(0.5f)) * _e101));
    let _e104 = g;
    base = (floor((_e104 - vec2(0.5f))) + vec2(0.5f));
    let _e111 = uniforms.progress;
    if (_e111 < 0.5f) {
        let _e113 = (*uv_2);
        param = _e113;
        let _e114 = getFromColor((&param));
        local = _e114;
    } else {
        let _e115 = (*uv_2);
        param_1 = _e115;
        let _e116 = getToColor((&param_1));
        local = _e116;
    }
    let _e117 = local;
    pixel = _e117;
    best = 1000f;
    let _e118 = pixel;
    ink = _e118;
    i = 0i;
    loop {
        let _e119 = i;
        if (_e119 < 4i) {
            let _e121 = base;
            let _e122 = i;
            let _e123 = f32(_e122);
            let _e128 = i;
            center = (_e121 + vec2<f32>((_e123 - (floor((_e123 / 2f)) * 2f)), floor((f32(_e128) / 2f))));
            let _e134 = center;
            let _e135 = rot;
            let _e137 = scale;
            cuv = (((_e134 * _e135) / _e137) + vec2(0.5f));
            let _e141 = cuv;
            param_2 = _e141;
            let _e142 = getFromColor((&param_2));
            cf = _e142;
            let _e143 = cuv;
            param_3 = _e143;
            let _e144 = getToColor((&param_3));
            ct = _e144;
            let _e145 = t;
            let _e148 = cuv[0u];
            m = smoothstep(0f, 1f, clamp(((2.5f * _e145) - (1.5f * _e148)), 0f, 1f));
            let _e153 = cf;
            param_4 = _e153;
            let _e154 = dotRadius((&param_4));
            let _e155 = ct;
            param_5 = _e155;
            let _e156 = dotRadius((&param_5));
            let _e157 = m;
            let _e159 = h;
            r = mix(0.78f, mix(_e154, _e156, _e157), _e159);
            let _e161 = g;
            let _e162 = center;
            let _e165 = r;
            sd = (length((_e161 - _e162)) - _e165);
            let _e167 = sd;
            let _e168 = best;
            if (_e167 < _e168) {
                let _e170 = sd;
                best = _e170;
                let _e171 = pixel;
                let _e172 = cf;
                let _e173 = ct;
                let _e174 = m;
                let _e177 = h;
                ink = mix(_e171, mix(_e172, _e173, vec4(_e174)), vec4(_e177));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e180 = i;
            i = (_e180 + 1i);
        }
    }
    let _e183 = uniforms.paper;
    let _e184 = ink;
    let _e185 = best;
    return mix(_e183, _e184, vec4((1f - smoothstep(-0.06f, 0.06f, _e185))));
}

fn main_1() {
    var param_6: vec2<f32>;

    let _e34 = _uv_1;
    param_6 = _e34;
    let _e35 = transition((&param_6));
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
