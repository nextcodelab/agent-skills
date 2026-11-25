// ShutterWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ShutterWipe.glsl
// Author: gre
// License: MIT
// Description: A camera's focal-plane shutter fires across the frame, seen through the camera's gate: thin metal blades fan down from a tight stack above it until they overlap over the whole frame, then keep running down and stack below it, uncovering the incoming image from the top
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    blades: i32,
    tilt: f32,
    gate: f32,
    color: vec4<f32>,
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
    let _e61 = (*uv)[0u];
    let _e63 = (*uv)[1u];
    let _e66 = textureSampleLevel(_to, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e61 = (*uv_1)[0u];
    let _e63 = (*uv_1)[1u];
    let _e66 = textureSampleLevel(_from, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n: f32;
    var h: f32;
    var pile: f32;
    var travel: f32;
    var t: vec2<f32>;
    var pos: vec2<f32>;
    var vel: vec2<f32>;
    var x: f32;
    var col: vec4<f32>;
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var i: i32;
    var k: f32;
    var v: f32;
    var d: f32;
    var aa: f32;
    var sh: f32;
    var l: f32;
    var lip: f32;
    var s: f32;
    var sheen: f32;
    var metal: vec3<f32>;
    var cover: f32;
    var g: f32;
    var c: vec2<f32>;
    var e: f32;
    var on: f32;
    var housing: vec3<f32>;

    let _e90 = uniforms.blades;
    n = clamp(f32(_e90), 3f, 10f);
    let _e93 = n;
    h = ((1.7f / _e93) + 0.02f);
    let _e96 = n;
    pile = ((_e96 - 1f) * 0.016f);
    let _e99 = h;
    let _e101 = pile;
    travel = ((1.1f + _e99) + _e101);
    let _e104 = uniforms.progress;
    t = clamp(((vec2(_e104) - vec2<f32>(0f, 0.3f)) / vec2(0.7f)), vec2(0f), vec2(1f));
    let _e112 = pile;
    let _e116 = travel;
    let _e117 = t;
    let _e119 = t;
    let _e121 = t;
    pos = ((vec2(1.05f) + vec2<f32>(0f, _e112)) - (((_e117 * _e116) * _e119) * (vec2(3f) - (_e121 * 2f))));
    let _e127 = travel;
    let _e129 = t;
    let _e131 = t;
    vel = (((_e129 * (_e127 * 6f)) * (vec2(1f) - _e131)) / vec2(0.7f));
    let _e138 = (*uv_2)[0u];
    let _e141 = uniforms.ratio;
    x = ((_e138 - 0.5f) * _e141);
    let _e144 = uniforms.progress;
    if (_e144 < 0.5f) {
        let _e146 = (*uv_2);
        param = _e146;
        let _e147 = getFromColor((&param));
        local = _e147;
    } else {
        let _e148 = (*uv_2);
        param_1 = _e148;
        let _e149 = getToColor((&param_1));
        local = _e149;
    }
    let _e150 = local;
    col = _e150;
    i = 0i;
    loop {
        let _e151 = i;
        if (_e151 < 10i) {
            let _e153 = i;
            let _e155 = n;
            k = (f32(_e153) / (_e155 - 1f));
            let _e158 = k;
            if (_e158 < 1.0001f) {
                let _e161 = vel[0u];
                let _e163 = vel[1u];
                let _e164 = k;
                v = mix(_e161, _e163, _e164);
                let _e167 = (*uv_2)[1u];
                let _e169 = pos[0u];
                let _e171 = pos[1u];
                let _e172 = k;
                let _e176 = uniforms.tilt;
                let _e178 = v;
                let _e180 = x;
                d = ((_e167 - mix(_e169, _e171, _e172)) + (((_e176 * 0.1f) * _e178) * _e180));
                let _e183 = v;
                aa = (0.002f + (0.005f * _e183));
                let _e186 = v;
                let _e189 = d;
                let _e193 = aa;
                let _e195 = aa;
                let _e196 = d;
                sh = ((1f - smoothstep(0f, (0.03f + (0.012f * _e186)), -(_e189))) * (1f - smoothstep(-(_e193), _e195, _e196)));
                let _e202 = uniforms.color[3u];
                let _e204 = sh;
                let _e206 = sh;
                let _e209 = col;
                let _e211 = (_e209.xyz * (1f - (((0.65f * _e202) * _e204) * _e206)));
                col[0u] = _e211.x;
                col[1u] = _e211.y;
                col[2u] = _e211.z;
                let _e218 = d;
                let _e219 = h;
                l = clamp((_e218 / _e219), 0f, 1f);
                let _e222 = d;
                let _e224 = d;
                lip = (smoothstep(0.003f, 0.007f, _e222) * (1f - smoothstep(0.007f, 0.014f, _e224)));
                let _e229 = (*uv_2)[1u];
                let _e230 = d;
                let _e233 = x;
                s = ((((_e229 - _e230) - 0.55f) + (0.3f * _e233)) * 2.5f);
                let _e237 = s;
                let _e239 = s;
                let _e243 = l;
                let _e246 = l;
                sheen = (((0.3f * exp((-(_e237) * _e239))) * (1f - _e243)) * (1f - _e246));
                let _e250 = uniforms.color;
                let _e252 = l;
                let _e256 = lip;
                let _e258 = sheen;
                let _e261 = uniforms.color;
                let _e269 = uniforms.color[3u];
                metal = ((_e250.xyz * (1.3f - (0.75f * _e252))) + (((vec3(0.6f) + (_e261.xyz * 0.4f)) * ((0.25f * _e256) + _e258)) * _e269));
                let _e272 = d;
                let _e276 = metal;
                metal = (_e276 * (0.4f + (0.6f * smoothstep(0f, 0.005f, _e272))));
                let _e278 = aa;
                let _e280 = aa;
                let _e281 = d;
                let _e283 = h;
                let _e284 = aa;
                let _e286 = h;
                let _e287 = aa;
                let _e289 = d;
                cover = (smoothstep(-(_e278), _e280, _e281) * (1f - smoothstep((_e283 - _e284), (_e286 + _e287), _e289)));
                let _e293 = col;
                let _e294 = metal;
                let _e297 = clamp(_e294, vec3(0f), vec3(1f));
                let _e300 = uniforms.color[3u];
                let _e305 = cover;
                col = mix(_e293, vec4<f32>(_e297.x, _e297.y, _e297.z, _e300), vec4(_e305));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e308 = i;
            i = (_e308 + 1i);
        }
    }
    let _e311 = uniforms.gate;
    let _e313 = uniforms.progress;
    let _e317 = uniforms.progress;
    g = ((_e311 * smoothstep(0f, 0.12f, _e313)) * (1f - smoothstep(0.88f, 1f, _e317)));
    let _e321 = (*uv_2);
    let _e326 = uniforms.ratio;
    let _e330 = uniforms.ratio;
    let _e334 = g;
    c = (((abs((_e321 - vec2(0.5f))) * vec2<f32>(_e326, 1f)) - vec2<f32>((0.5f * _e330), 0.5f)) + vec2((1.5f * _e334)));
    let _e338 = c;
    let _e343 = c[0u];
    let _e345 = c[1u];
    let _e349 = g;
    e = ((length(max(_e338, vec2(0f))) + min(max(_e343, _e345), 0f)) - (0.5f * _e349));
    let _e353 = uniforms.gate;
    let _e356 = uniforms.progress;
    let _e360 = uniforms.progress;
    on = ((smoothstep(0f, 0.002f, _e353) * smoothstep(0f, 0.04f, _e356)) * (1f - smoothstep(0.96f, 1f, _e360)));
    let _e366 = uniforms.color[3u];
    let _e368 = on;
    let _e370 = g;
    let _e373 = e;
    let _e377 = col;
    let _e379 = (_e377.xyz * (1f - (((0.5f * _e366) * _e368) * smoothstep(((-0.4f * _e370) - 0.001f), 0f, _e373))));
    col[0u] = _e379.x;
    col[1u] = _e379.y;
    col[2u] = _e379.z;
    let _e387 = uniforms.color;
    let _e389 = g;
    let _e392 = e;
    housing = min((_e387.xyz * (1.5f - smoothstep(0f, ((0.2f * _e389) + 0.001f), _e392))), vec3(1f));
    let _e398 = col;
    let _e399 = housing;
    let _e402 = uniforms.color[3u];
    let _e407 = on;
    let _e408 = e;
    return mix(_e398, vec4<f32>(_e399.x, _e399.y, _e399.z, _e402), vec4((_e407 * smoothstep(-0.002f, 0.002f, _e408))));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e60 = _uv_1;
    param_2 = _e60;
    let _e61 = transition((&param_2));
    _fragColor = _e61;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
