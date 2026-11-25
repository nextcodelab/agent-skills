// ApertureWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ApertureWipe.glsl
// Author: gre
// License: MIT
// Description: A camera aperture opens its turning blades to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    blades: i32,
    rotation: f32,
    shadow: f32,
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
    let _e30 = (*uv)[0u];
    let _e32 = (*uv)[1u];
    let _e35 = textureSampleLevel(_to, _sampler, vec2<f32>(_e30, (1f - _e32)), 0f);
    return _e35;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e30 = (*uv_1)[0u];
    let _e32 = (*uv_1)[1u];
    let _e35 = textureSampleLevel(_from, _sampler, vec2<f32>(_e30, (1f - _e32)), 0f);
    return _e35;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var q: vec2<f32>;
    var n: f32;
    var sector: f32;
    var turn: f32;
    var r: f32;
    var dist: f32;
    var seam: f32;
    var i: i32;
    var angle: f32;
    var d: f32;
    var next: f32;
    var s: f32;
    var rim: f32;
    var shade: f32;
    var from_: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e46 = (*uv_2);
    let _e50 = uniforms.ratio;
    let _e54 = uniforms.ratio;
    q = (((_e46 - vec2(0.5f)) * vec2<f32>(_e50, 1f)) / vec2((0.5f * length(vec2<f32>(_e54, 1f)))));
    let _e61 = uniforms.blades;
    n = clamp(f32(_e61), 3f, 12f);
    let _e64 = n;
    sector = (6.2831855f / _e64);
    let _e67 = uniforms.rotation;
    let _e70 = uniforms.progress;
    turn = (radians(_e67) * _e70);
    let _e73 = uniforms.progress;
    r = mix(-0.006f, 1.006f, _e73);
    dist = -1000f;
    seam = 0f;
    i = 0i;
    loop {
        let _e75 = i;
        if (_e75 < 12i) {
            let _e77 = i;
            let _e79 = n;
            if (f32(_e77) < _e79) {
                let _e81 = turn;
                let _e82 = i;
                let _e84 = sector;
                angle = (_e81 + (f32(_e82) * _e84));
                let _e87 = q;
                let _e88 = angle;
                let _e90 = angle;
                let _e94 = r;
                d = (dot(_e87, vec2<f32>(cos(_e88), sin(_e90))) - _e94);
                let _e96 = q;
                let _e97 = angle;
                let _e98 = sector;
                let _e101 = angle;
                let _e102 = sector;
                let _e107 = r;
                next = (dot(_e96, vec2<f32>(cos((_e97 + _e98)), sin((_e101 + _e102)))) - _e107);
                let _e109 = dist;
                let _e110 = d;
                dist = max(_e109, _e110);
                let _e112 = d;
                s = (1f - smoothstep(0f, 0.12f, -(_e112)));
                let _e116 = seam;
                let _e117 = d;
                let _e120 = s;
                let _e122 = s;
                let _e124 = next;
                seam = max(_e116, ((((1f - smoothstep(0f, 0.006f, _e117)) * _e120) * _e122) * smoothstep(0f, 0.006f, _e124)));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e128 = i;
            i = (_e128 + 1i);
        }
    }
    let _e130 = dist;
    rim = (1f - smoothstep(0f, 0.08f, _e130));
    let _e134 = uniforms.shadow;
    let _e135 = rim;
    let _e136 = rim;
    let _e138 = seam;
    let _e142 = uniforms.progress;
    shade = ((_e134 * max((_e135 * _e136), _e138)) * smoothstep(0f, 0.1f, _e142));
    let _e145 = (*uv_2);
    param = _e145;
    let _e146 = getFromColor((&param));
    from_ = _e146;
    let _e147 = shade;
    let _e149 = from_;
    let _e151 = (_e149.xyz * (1f - _e147));
    from_[0u] = _e151.x;
    from_[1u] = _e151.y;
    from_[2u] = _e151.z;
    let _e158 = from_;
    let _e159 = (*uv_2);
    param_1 = _e159;
    let _e160 = getToColor((&param_1));
    let _e161 = dist;
    return mix(_e158, _e160, vec4((1f - smoothstep(0f, 0.006f, _e161))));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e29 = _uv_1;
    param_2 = _e29;
    let _e30 = transition((&param_2));
    _fragColor = _e30;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
