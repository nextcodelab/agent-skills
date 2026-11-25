// HorizontalHold — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HorizontalHold.glsl
// Author: gre
// License: MIT
// Description: The picture loses its horizontal hold like an old TV: it shears into diagonal bands that slide sideways and wrap around, separated by a slanted blanking bar that carries the incoming image in, then the shear straightens, wobbles and locks
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    slips: i32,
    shear: f32,
    barWidth: f32,
    barColor: vec4<f32>,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv)[0u];
    let _e48 = (*uv)[1u];
    let _e51 = textureSampleLevel(_from, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv_1)[0u];
    let _e48 = (*uv_1)[1u];
    let _e51 = textureSampleLevel(_to, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn slipCount_u0028_() -> f32 {
    let _e45 = uniforms.slips;
    return max(f32(_e45), 1f);
}

fn stream(x: ptr<function, f32>, y: ptr<function, f32>, unsync: ptr<function, f32>) -> vec4<f32> {
    var period: f32;
    var n: f32;
    var xm: f32;
    var q: vec2<f32>;
    var c: vec4<f32>;
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var d: f32;
    var g: f32;
    var soft: f32;

    let _e59 = uniforms.barWidth;
    period = (1f + _e59);
    let _e61 = (*x);
    let _e62 = period;
    n = floor((_e61 / _e62));
    let _e65 = (*x);
    let _e66 = n;
    let _e67 = period;
    xm = (_e65 - (_e66 * _e67));
    let _e70 = xm;
    let _e72 = (*y);
    q = vec2<f32>(min(_e70, 1f), _e72);
    let _e74 = n;
    let _e75 = slipCount_u0028_();
    if (_e74 >= floor(((0.5f * _e75) + 0.5f))) {
        let _e80 = q;
        param = _e80;
        let _e81 = getToColor((&param));
        local = _e81;
    } else {
        let _e82 = q;
        param_1 = _e82;
        let _e83 = getFromColor((&param_1));
        local = _e83;
    }
    let _e84 = local;
    c = _e84;
    let _e85 = xm;
    let _e86 = xm;
    d = min(_e85, (1f - _e86));
    let _e89 = d;
    g = max((1f - (_e89 / 0.05f)), 0f);
    let _e93 = (*unsync);
    let _e95 = g;
    let _e97 = g;
    let _e100 = c[3u];
    let _e102 = c;
    let _e105 = (_e102.xyz + vec3(((((0.3f * _e93) * _e95) * _e97) * _e100)));
    c[0u] = _e105.x;
    c[1u] = _e105.y;
    c[2u] = _e105.z;
    let _e112 = (*unsync);
    let _e115 = uniforms.barWidth;
    soft = (min((0.012f * _e112), (0.5f * _e115)) + 0.00001f);
    let _e120 = uniforms.barColor;
    let _e121 = c;
    let _e122 = d;
    let _e123 = soft;
    return mix(_e120, _e121, vec4(clamp((_e122 / _e123), 0f, 1f)));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var period_1: f32;
    var t: f32;
    var err: f32;
    var slip: f32;
    var u: f32;
    var lock: f32;
    var tilt: f32;
    var unsync_1: f32;
    var ripple: f32;
    var x_1: f32;
    var blur: f32;
    var c_1: vec4<f32>;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var i: i32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;

    let _e65 = uniforms.barWidth;
    period_1 = (1f + _e65);
    let _e68 = uniforms.progress;
    t = min((_e68 / 0.88f), 1f);
    let _e71 = t;
    let _e73 = t;
    let _e75 = t;
    let _e78 = t;
    err = ((((16f * _e71) * _e73) * (1f - _e75)) * (1f - _e78));
    let _e81 = t;
    let _e82 = t;
    let _e84 = t;
    let _e86 = t;
    let _e87 = t;
    slip = (((_e81 * _e82) * _e84) * ((_e86 * ((_e87 * 6f) - 15f)) + 10f));
    let _e94 = uniforms.progress;
    u = clamp(((_e94 - 0.74f) / 0.26f), 0f, 1f);
    let _e98 = u;
    let _e99 = u;
    let _e102 = u;
    lock = ((_e98 * (1f - _e99)) * (1f - _e102));
    let _e106 = uniforms.shear;
    let _e109 = lock;
    let _e111 = u;
    tilt = (((-0.5f * max(_e106, 0.5f)) * _e109) * sin((9.42478f * _e111)));
    let _e115 = err;
    let _e116 = lock;
    unsync_1 = min((_e115 + (3f * _e116)), 1f);
    let _e121 = (*uv_2)[1u];
    let _e124 = uniforms.progress;
    let _e130 = (*uv_2)[1u];
    let _e133 = uniforms.progress;
    ripple = ((0.012f * sin(((_e121 * 9f) + (_e124 * 40f)))) + (0.005f * sin(((_e130 * 31f) - (_e133 * 70f)))));
    let _e140 = (*uv_2)[0u];
    let _e141 = period_1;
    let _e142 = slipCount_u0028_();
    let _e143 = slip;
    let _e146 = uniforms.shear;
    let _e147 = err;
    let _e150 = (*uv_2)[1u];
    let _e154 = tilt;
    let _e156 = (*uv_2)[1u];
    let _e162 = err;
    let _e163 = ripple;
    x_1 = ((_e140 + (_e141 * (((_e142 * _e143) + ((_e146 * _e147) * (1f - _e150))) + (_e154 * (1f - _e156))))) + (_e162 * _e163));
    let _e166 = err;
    let _e168 = slipCount_u0028_();
    blur = ((0.002f * _e166) * _e168);
    let _e170 = x_1;
    param_2 = _e170;
    let _e172 = (*uv_2)[1u];
    param_3 = _e172;
    let _e173 = unsync_1;
    param_4 = _e173;
    let _e174 = stream((&param_2), (&param_3), (&param_4));
    c_1 = _e174;
    let _e175 = blur;
    if (_e175 > 0f) {
        i = 0i;
        loop {
            let _e177 = i;
            if (_e177 < 4i) {
                let _e179 = x_1;
                let _e180 = blur;
                let _e181 = i;
                param_5 = (_e179 + (_e180 * (f32(_e181) - 1.5f)));
                let _e187 = (*uv_2)[1u];
                param_6 = _e187;
                let _e188 = unsync_1;
                param_7 = _e188;
                let _e189 = stream((&param_5), (&param_6), (&param_7));
                let _e190 = c_1;
                c_1 = (_e190 + _e189);
                continue;
            } else {
                break;
            }
            continuing {
                let _e192 = i;
                i = (_e192 + 1i);
            }
        }
        let _e194 = c_1;
        c_1 = (_e194 / vec4(5f));
    }
    let _e197 = unsync_1;
    let _e199 = (*uv_2)[1u];
    let _e206 = c_1;
    let _e208 = (_e206.xyz * (1f - (_e197 * (0.1f + (0.08f * sin((_e199 * 480f)))))));
    c_1[0u] = _e208.x;
    c_1[1u] = _e208.y;
    c_1[2u] = _e208.z;
    let _e215 = c_1;
    return _e215;
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e45 = _uv_1;
    param_8 = _e45;
    let _e46 = transition((&param_8));
    _fragColor = _e46;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
