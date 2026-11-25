// LightWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightWipe.glsl
// Author: gre
// License: MIT
// Description: A band of intense light sweeps across the frame like a glint on glass, blooming the highlights of both images, and leaves the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    width: f32,
    intensity: f32,
    color: vec3<f32>,
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

fn highlight(c: ptr<function, vec4<f32>>) -> vec3<f32> {
    var lum: f32;

    let _e44 = (*c);
    lum = dot(_e44.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e47 = (*c);
    let _e50 = (*c)[3u];
    let _e52 = lum;
    return ((_e47.xyz * _e50) * smoothstep(0.45f, 1f, _e52));
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e43 = (*v);
    let _e44 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e43 - (floor((_e43 / _e44)) * _e44)))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv)[0u];
    let _e46 = (*uv)[1u];
    let _e49 = textureSampleLevel(_to, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e44 = (*uv_1)[0u];
    let _e46 = (*uv_1)[1u];
    let _e49 = textureSampleLevel(_from, _sampler, vec2<f32>(_e44, (1f - _e46)), 0f);
    return _e49;
}

fn frame(st: ptr<function, vec2<f32>>, m: ptr<function, f32>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e46 = (*st);
    param = _e46;
    let _e47 = getFromColor((&param));
    let _e48 = (*st);
    param_1 = _e48;
    let _e49 = getToColor((&param_1));
    let _e50 = (*m);
    return mix(_e47, _e49, vec4(_e50));
}

fn ease(t: ptr<function, f32>) -> f32 {
    let _e43 = (*t);
    let _e44 = (*t);
    let _e45 = (*t);
    let _e47 = (*t);
    return (0.5f * (_e43 + ((_e44 * _e45) * (3f - (2f * _e47)))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var p: vec2<f32>;
    var e: f32;
    var w: f32;
    var s: f32;
    var margin: f32;
    var pos: f32;
    var param_2: f32;
    var d: f32;
    var m_1: f32;
    var env: f32;
    var core: f32;
    var g: f32;
    var glint: f32;
    var halo: f32;
    var band: f32;
    var glow: f32;
    var c_1: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var bloom: vec3<f32>;
    var spread: f32;
    var i: i32;
    var t_1: f32;
    var st_1: vec2<f32>;
    var param_5: vec2<f32>;
    var dq: f32;
    var param_6: vec2<f32>;
    var param_7: f32;
    var param_8: vec4<f32>;
    var hue: vec3<f32>;
    var lum_1: f32;
    var light: vec3<f32>;
    var rgb: vec3<f32>;

    let _e79 = uniforms.direction;
    if (length(_e79) > 0f) {
        let _e83 = uniforms.direction;
        local = normalize(_e83);
    } else {
        local = vec2<f32>(1f, 0f);
    }
    let _e85 = local;
    dir = _e85;
    let _e86 = (*uv_2);
    let _e90 = uniforms.ratio;
    p = ((_e86 - vec2(0.5f)) * vec2<f32>(_e90, 1f));
    let _e94 = dir[0u];
    let _e97 = uniforms.ratio;
    let _e100 = dir[1u];
    e = (0.5f * ((abs(_e94) * _e97) + abs(_e100)));
    let _e105 = uniforms.width;
    w = max(_e105, 0.001f);
    let _e107 = w;
    s = (0.35f * _e107);
    let _e109 = s;
    let _e110 = w;
    margin = (_e109 + (2f * _e110));
    let _e113 = e;
    let _e115 = margin;
    let _e117 = e;
    let _e118 = margin;
    let _e122 = uniforms.progress;
    param_2 = _e122;
    let _e123 = ease((&param_2));
    pos = ((-(_e113) - _e115) + ((2f * (_e117 + _e118)) * _e123));
    let _e126 = p;
    let _e127 = dir;
    let _e129 = pos;
    d = (dot(_e126, _e127) - _e129);
    let _e131 = s;
    let _e133 = s;
    let _e134 = d;
    m_1 = (1f - smoothstep(-(_e131), _e133, _e134));
    let _e138 = uniforms.progress;
    let _e141 = uniforms.progress;
    env = (smoothstep(0f, 0.2f, _e138) * (1f - smoothstep(0.8f, 1f, _e141)));
    let _e145 = d;
    let _e147 = d;
    let _e149 = w;
    let _e150 = w;
    core = exp(((-(_e145) * _e147) / (_e149 * _e150)));
    let _e154 = d;
    let _e155 = w;
    let _e158 = w;
    g = ((_e154 + (2.2f * _e155)) / (0.3f * _e158));
    let _e161 = g;
    let _e163 = g;
    glint = (0.45f * exp((-(_e161) * _e163)));
    let _e167 = d;
    let _e170 = w;
    halo = (0.35f * exp((-(abs(_e167)) / (5f * _e170))));
    let _e175 = core;
    let _e176 = glint;
    let _e178 = halo;
    let _e180 = env;
    let _e183 = uniforms.intensity;
    band = ((((_e175 + _e176) + _e178) * _e180) * _e183);
    let _e185 = core;
    let _e186 = glint;
    let _e188 = env;
    let _e191 = uniforms.intensity;
    glow = (((_e185 + _e186) * _e188) * _e191);
    let _e193 = (*uv_2);
    param_3 = _e193;
    let _e194 = m_1;
    param_4 = _e194;
    let _e195 = frame((&param_3), (&param_4));
    c_1 = _e195;
    bloom = vec3<f32>(0f, 0f, 0f);
    let _e196 = w;
    spread = min((3f * _e196), 0.12f);
    i = 0i;
    loop {
        let _e199 = i;
        if (_e199 < 12i) {
            let _e201 = i;
            t_1 = ((((f32(_e201) + 0.5f) / 12f) * 2f) - 1f);
            let _e207 = p;
            let _e208 = dir;
            let _e209 = t_1;
            let _e210 = spread;
            let _e215 = uniforms.ratio;
            param_5 = (((_e207 + (_e208 * (_e209 * _e210))) / vec2<f32>(_e215, 1f)) + vec2(0.5f));
            let _e220 = mirror((&param_5));
            st_1 = _e220;
            let _e221 = st_1;
            let _e225 = uniforms.ratio;
            let _e228 = dir;
            let _e230 = pos;
            dq = (dot(((_e221 - vec2(0.5f)) * vec2<f32>(_e225, 1f)), _e228) - _e230);
            let _e232 = t_1;
            let _e235 = s;
            let _e237 = s;
            let _e238 = dq;
            let _e241 = st_1;
            param_6 = _e241;
            param_7 = (1f - smoothstep(-(_e235), _e237, _e238));
            let _e242 = frame((&param_6), (&param_7));
            param_8 = _e242;
            let _e243 = highlight((&param_8));
            let _e245 = bloom;
            bloom = (_e245 + (_e243 * (1f - abs(_e232))));
            continue;
        } else {
            break;
        }
        continuing {
            let _e247 = i;
            i = (_e247 + 1i);
        }
    }
    let _e249 = bloom;
    bloom = (_e249 / vec3(6f));
    let _e253 = uniforms.color;
    let _e254 = core;
    let _e255 = core;
    hue = mix(_e253, vec3<f32>(1f, 1f, 1f), vec3((_e254 * _e255)));
    let _e259 = c_1;
    lum_1 = dot(_e259.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e262 = hue;
    let _e263 = band;
    let _e265 = lum_1;
    let _e269 = hue;
    let _e270 = bloom;
    let _e272 = glow;
    let _e276 = hue;
    let _e277 = core;
    let _e279 = env;
    let _e282 = uniforms.intensity;
    light = ((((_e262 * _e263) * (0.3f + (0.9f * _e265))) + (((_e269 * _e270) * _e272) * 4f)) + ((((_e276 * _e277) * _e279) * _e282) * 1.6f));
    let _e286 = c_1;
    let _e290 = light;
    rgb = (vec3(1f) - ((vec3(1f) - _e286.xyz) * exp(-(_e290))));
    let _e296 = rgb;
    let _e298 = c_1[3u];
    return vec4<f32>(_e296.x, _e296.y, _e296.z, _e298);
}

fn main_1() {
    var param_9: vec2<f32>;

    let _e43 = _uv_1;
    param_9 = _e43;
    let _e44 = transition((&param_9));
    _fragColor = _e44;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
