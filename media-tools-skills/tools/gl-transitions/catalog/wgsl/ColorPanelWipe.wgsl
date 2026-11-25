// ColorPanelWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorPanelWipe.glsl
// Author: gre
// License: MIT
// Description: Solid color panels, slightly staggered, sweep across and cover the frame, then sweep off the far side and reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    panels: i32,
    color1_: vec4<f32>,
    color2_: vec4<f32>,
    color3_: vec4<f32>,
    stagger: f32,
    skew: f32,
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

fn cover(x: ptr<function, f32>, back: ptr<function, f32>, front: ptr<function, f32>) -> f32 {
    let _e36 = (*back);
    let _e38 = (*back);
    let _e40 = (*x);
    let _e42 = (*front);
    let _e44 = (*front);
    let _e46 = (*x);
    return (smoothstep((_e36 - 0.0015f), (_e38 + 0.0015f), _e40) * (1f - smoothstep((_e42 - 0.0015f), (_e44 + 0.0015f), _e46)));
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv)[0u];
    let _e37 = (*uv)[1u];
    let _e40 = textureSampleLevel(_from, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv_1)[0u];
    let _e37 = (*uv_1)[1u];
    let _e40 = textureSampleLevel(_to, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn ease(t: ptr<function, f32>) -> f32 {
    var s: f32;
    var u: f32;

    let _e36 = (*t);
    s = clamp(_e36, 0f, 1f);
    let _e38 = s;
    let _e39 = s;
    let _e41 = s;
    u = (1f - ((_e38 * _e39) * (3f - (2f * _e41))));
    let _e46 = u;
    let _e47 = u;
    let _e49 = u;
    return (1f - ((_e46 * _e47) * _e49));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var p: vec2<f32>;
    var k: f32;
    var a: vec2<f32>;
    var x_1: f32;
    var e: f32;
    var start: f32;
    var span: f32;
    var n: i32;
    var local_1: i32;
    var local_2: i32;
    var m: f32;
    var st: f32;
    var d: vec2<f32>;
    var front0_: f32;
    var param: f32;
    var back0_: f32;
    var param_1: f32;
    var c: vec4<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var i: i32;
    var t_1: vec2<f32>;
    var front_1: f32;
    var param_7: f32;
    var back_1: f32;
    var param_8: f32;
    var local_3: vec4<f32>;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;

    let _e70 = uniforms.direction;
    if (length(_e70) > 0f) {
        let _e74 = uniforms.direction;
        local = normalize(_e74);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e76 = local;
    dir = _e76;
    let _e77 = (*uv_2);
    let _e81 = uniforms.ratio;
    p = ((_e77 - vec2(0.5f)) * vec2<f32>(_e81, 1f));
    let _e85 = uniforms.skew;
    k = clamp(_e85, -1f, 1f);
    let _e87 = dir;
    let _e88 = k;
    let _e90 = dir[1u];
    let _e93 = dir[0u];
    let _e97 = k;
    let _e98 = k;
    a = ((_e87 + (vec2<f32>(-(_e90), _e93) * _e88)) / vec2(sqrt((1f + (_e97 * _e98)))));
    let _e104 = p;
    let _e105 = a;
    x_1 = dot(_e104, _e105);
    let _e108 = a[0u];
    let _e111 = uniforms.ratio;
    let _e114 = a[1u];
    e = (0.5f * ((abs(_e108) * _e111) + abs(_e114)));
    let _e118 = e;
    start = (-(_e118) - 0.003f);
    let _e121 = e;
    span = (2f * (_e121 + 0.003f));
    let _e125 = uniforms.panels;
    if (_e125 < 1i) {
        local_1 = 1i;
    } else {
        let _e128 = uniforms.panels;
        if (_e128 > 3i) {
            local_2 = 3i;
        } else {
            let _e131 = uniforms.panels;
            local_2 = _e131;
        }
        let _e132 = local_2;
        local_1 = _e132;
    }
    let _e133 = local_1;
    n = _e133;
    let _e134 = n;
    m = f32((_e134 - 1i));
    let _e138 = uniforms.stagger;
    st = clamp(_e138, 0f, 1f);
    let _e140 = m;
    let _e141 = st;
    d = (vec2<f32>(0.45f, 0.53f) / vec2((1f + (_e140 * _e141))));
    let _e146 = start;
    let _e147 = span;
    let _e149 = uniforms.progress;
    let _e151 = d[0u];
    param = (_e149 / _e151);
    let _e153 = ease((&param));
    front0_ = (_e146 + (_e147 * _e153));
    let _e156 = start;
    let _e157 = span;
    let _e159 = uniforms.progress;
    let _e162 = d[1u];
    let _e165 = d[1u];
    param_1 = (((_e159 - 1f) + _e162) / _e165);
    let _e167 = ease((&param_1));
    back0_ = (_e156 + (_e157 * _e167));
    let _e170 = (*uv_2);
    param_2 = _e170;
    let _e171 = getToColor((&param_2));
    let _e172 = (*uv_2);
    param_3 = _e172;
    let _e173 = getFromColor((&param_3));
    let _e174 = front0_;
    let _e175 = back0_;
    let _e178 = x_1;
    c = mix(_e171, _e173, vec4(step((0.5f * (_e174 + _e175)), _e178)));
    let _e182 = c;
    let _e184 = uniforms.color1_;
    let _e185 = x_1;
    param_4 = _e185;
    let _e186 = back0_;
    param_5 = _e186;
    let _e187 = front0_;
    param_6 = _e187;
    let _e188 = cover((&param_4), (&param_5), (&param_6));
    c = mix(_e182, _e184, vec4(_e188));
    i = 1i;
    loop {
        let _e191 = i;
        if (_e191 < 3i) {
            let _e193 = i;
            let _e194 = n;
            if (_e193 < _e194) {
                let _e196 = i;
                let _e198 = st;
                let _e200 = d;
                t_1 = (_e200 * (f32(_e196) * _e198));
                let _e202 = start;
                let _e203 = span;
                let _e205 = uniforms.progress;
                let _e207 = t_1[0u];
                let _e210 = d[0u];
                param_7 = ((_e205 - _e207) / _e210);
                let _e212 = ease((&param_7));
                front_1 = (_e202 + (_e203 * _e212));
                let _e215 = start;
                let _e216 = span;
                let _e218 = uniforms.progress;
                let _e221 = d[1u];
                let _e224 = t_1[1u];
                let _e227 = d[1u];
                param_8 = ((((_e218 - 1f) + _e221) + _e224) / _e227);
                let _e229 = ease((&param_8));
                back_1 = (_e215 + (_e216 * _e229));
                let _e232 = c;
                let _e233 = i;
                if (_e233 == 1i) {
                    let _e236 = uniforms.color2_;
                    local_3 = _e236;
                } else {
                    let _e238 = uniforms.color3_;
                    local_3 = _e238;
                }
                let _e239 = local_3;
                let _e240 = x_1;
                param_9 = _e240;
                let _e241 = back_1;
                param_10 = _e241;
                let _e242 = front_1;
                param_11 = _e242;
                let _e243 = cover((&param_9), (&param_10), (&param_11));
                c = mix(_e232, _e239, vec4(_e243));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e246 = i;
            i = (_e246 + 1i);
        }
    }
    let _e249 = c[3u];
    let _e251 = c;
    return select(vec4<f32>(0f, 0f, 0f, 0f), _e251, vec4((_e249 > 0f)));
}

fn main_1() {
    var param_12: vec2<f32>;

    let _e34 = _uv_1;
    param_12 = _e34;
    let _e35 = transition((&param_12));
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
