// DreamyZoom — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DreamyZoom.glsl
// Author: Zeh Fernando
// License: MIT
// Description: Zooms and rotates into a bright flash, then out to the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    rotation: f32,
    scale: f32,
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
    let _e22 = (*uv)[0u];
    let _e24 = (*uv)[1u];
    let _e27 = textureSampleLevel(_to, _sampler, vec2<f32>(_e22, (1f - _e24)), 0f);
    return _e27;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e22 = (*uv_1)[0u];
    let _e24 = (*uv_1)[1u];
    let _e27 = textureSampleLevel(_from, _sampler, vec2<f32>(_e22, (1f - _e24)), 0f);
    return _e27;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var phase: f32;
    var local: f32;
    var angleOffset: f32;
    var local_1: f32;
    var newScale: f32;
    var local_2: f32;
    var center: vec2<f32>;
    var assumedCenter: vec2<f32>;
    var p: vec2<f32>;
    var angle: f32;
    var dist: f32;
    var c: vec4<f32>;
    var local_3: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var local_4: f32;

    let _e38 = uniforms.progress;
    if (_e38 < 0.5f) {
        let _e41 = uniforms.progress;
        local = (_e41 * 2f);
    } else {
        let _e44 = uniforms.progress;
        local = ((_e44 - 0.5f) * 2f);
    }
    let _e47 = local;
    phase = _e47;
    let _e49 = uniforms.progress;
    if (_e49 < 0.5f) {
        let _e52 = uniforms.rotation;
        let _e54 = phase;
        local_1 = mix(0f, (_e52 * 0.03926991f), _e54);
    } else {
        let _e57 = uniforms.rotation;
        let _e60 = phase;
        local_1 = mix((-(_e57) * 0.03926991f), 0f, _e60);
    }
    let _e62 = local_1;
    angleOffset = _e62;
    let _e64 = uniforms.progress;
    if (_e64 < 0.5f) {
        let _e67 = uniforms.scale;
        let _e68 = phase;
        local_2 = mix(1f, _e67, _e68);
    } else {
        let _e71 = uniforms.scale;
        let _e72 = phase;
        local_2 = mix(_e71, 1f, _e72);
    }
    let _e74 = local_2;
    newScale = _e74;
    center = vec2<f32>(0f, 0f);
    assumedCenter = vec2<f32>(0.5f, 0.5f);
    let _e75 = (*uv_2);
    let _e77 = newScale;
    let _e81 = uniforms.ratio;
    p = (((_e75 - vec2<f32>(0.5f, 0.5f)) / vec2(_e77)) * vec2<f32>(_e81, 1f));
    let _e85 = p[1u];
    let _e87 = p[0u];
    let _e89 = angleOffset;
    angle = (atan2(_e85, _e87) + _e89);
    let _e91 = center;
    let _e92 = p;
    dist = distance(_e91, _e92);
    let _e94 = angle;
    let _e96 = dist;
    let _e99 = uniforms.ratio;
    p[0u] = (((cos(_e94) * _e96) / _e99) + 0.5f);
    let _e103 = angle;
    let _e105 = dist;
    p[1u] = ((sin(_e103) * _e105) + 0.5f);
    let _e110 = uniforms.progress;
    if (_e110 < 0.5f) {
        let _e112 = p;
        param = _e112;
        let _e113 = getFromColor((&param));
        local_3 = _e113;
    } else {
        let _e114 = p;
        param_1 = _e114;
        let _e115 = getToColor((&param_1));
        local_3 = _e115;
    }
    let _e116 = local_3;
    c = _e116;
    let _e117 = c;
    let _e120 = uniforms.progress;
    if (_e120 < 0.5f) {
        let _e122 = phase;
        local_4 = mix(0f, 1f, _e122);
    } else {
        let _e124 = phase;
        local_4 = mix(1f, 0f, _e124);
    }
    let _e126 = local_4;
    let _e128 = (_e117.xyz + vec3(_e126));
    let _e130 = c[3u];
    return vec4<f32>(_e128.x, _e128.y, _e128.z, _e130);
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e21 = _uv_1;
    param_2 = _e21;
    let _e22 = transition((&param_2));
    _fragColor = _e22;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
