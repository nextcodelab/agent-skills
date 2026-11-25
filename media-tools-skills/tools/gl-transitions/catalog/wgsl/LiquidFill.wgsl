// LiquidFill — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LiquidFill.glsl
// Author: gre
// License: MIT
// Description: The incoming image rises over the outgoing one like liquid filling a glass, its surface sloshing in waves, lit by a bright meniscus line, bending the image just below it, with a few bubbles rising through it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: vec2<f32>,
    amplitude: f32,
    waves: f32,
    highlight: vec4<f32>,
    refraction: f32,
    bubbles: f32,
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

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e68 = (*p);
    p3_ = fract((_e68.xyx * 0.1031f));
    let _e72 = p3_;
    let _e73 = p3_;
    let _e78 = p3_;
    p3_ = (_e78 + vec3(dot(_e72, (_e73.yzx + vec3(33.33f)))));
    let _e82 = p3_[0u];
    let _e84 = p3_[1u];
    let _e87 = p3_[2u];
    return fract(((_e82 + _e84) * _e87));
}

fn surface(x: ptr<function, f32>, t: ptr<function, f32>) -> f32 {
    var k: f32;

    let _e70 = uniforms.waves;
    k = (3.1415927f * max(_e70, 0.01f));
    let _e73 = k;
    let _e74 = (*x);
    let _e79 = (*t);
    let _e83 = k;
    let _e85 = (*x);
    let _e87 = (*t);
    return (((0.6f * sin(((_e73 * _e74) + 1.5707964f))) * cos((8.168141f * _e79))) + (0.4f * sin(((((1.7f * _e83) * _e85) - (9f * _e87)) + 1.3f))));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e68 = (*uv)[0u];
    let _e70 = (*uv)[1u];
    let _e73 = textureSampleLevel(_to, _sampler, vec2<f32>(_e68, (1f - _e70)), 0f);
    return _e73;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e68 = (*uv_1)[0u];
    let _e70 = (*uv_1)[1u];
    let _e73 = textureSampleLevel(_from, _sampler, vec2<f32>(_e68, (1f - _e70)), 0f);
    return _e73;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var dir: vec2<f32>;
    var local: vec2<f32>;
    var across: vec2<f32>;
    var p_1: vec2<f32>;
    var e: f32;
    var w: f32;
    var d: f32;
    var x_1: f32;
    var t_1: f32;
    var stir: f32;
    var amp: f32;
    var margin: f32;
    var mean: f32;
    var level: f32;
    var param_2: f32;
    var param_3: f32;
    var depth: f32;
    var m: f32;
    var bend: f32;
    var offset: vec2<f32>;
    var b: vec4<f32>;
    var param_4: vec2<f32>;
    var glow: f32;
    var rise: f32;
    var bq: vec2<f32>;
    var cell: vec2<f32>;
    var hs: f32;
    var param_5: vec2<f32>;
    var r: f32;
    var param_6: vec2<f32>;
    var px: f32;
    var c: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var dist: f32;
    var rim: f32;
    var glint: f32;
    var line: f32;
    var light: f32;
    var c_1: vec4<f32>;
    var local_1: vec4<f32>;

    let _e111 = (*uv_2);
    param = _e111;
    let _e112 = getFromColor((&param));
    a = _e112;
    let _e114 = uniforms.progress;
    if (_e114 <= 0f) {
        let _e116 = a;
        return _e116;
    }
    let _e118 = uniforms.progress;
    if (_e118 >= 1f) {
        let _e120 = (*uv_2);
        param_1 = _e120;
        let _e121 = getToColor((&param_1));
        return _e121;
    }
    let _e123 = uniforms.direction;
    if (length(_e123) > 0f) {
        let _e127 = uniforms.direction;
        local = normalize(_e127);
    } else {
        local = vec2<f32>(0f, 1f);
    }
    let _e129 = local;
    dir = _e129;
    let _e131 = dir[1u];
    let _e134 = dir[0u];
    across = vec2<f32>(-(_e131), _e134);
    let _e136 = (*uv_2);
    let _e140 = uniforms.ratio;
    p_1 = ((_e136 - vec2(0.5f)) * vec2<f32>(_e140, 1f));
    let _e144 = dir[0u];
    let _e147 = uniforms.ratio;
    let _e150 = dir[1u];
    e = (0.5f * ((abs(_e144) * _e147) + abs(_e150)));
    let _e155 = dir[1u];
    let _e158 = uniforms.ratio;
    let _e161 = dir[0u];
    w = (0.5f * ((abs(_e155) * _e158) + abs(_e161)));
    let _e165 = p_1;
    let _e166 = dir;
    d = dot(_e165, _e166);
    let _e168 = p_1;
    let _e169 = across;
    x_1 = dot(_e168, _e169);
    let _e172 = uniforms.progress;
    t_1 = _e172;
    let _e173 = t_1;
    stir = sin((3.1415927f * _e173));
    let _e177 = uniforms.amplitude;
    let _e179 = stir;
    amp = (max(_e177, 0f) * (0.35f + (0.65f * _e179)));
    let _e184 = uniforms.amplitude;
    margin = ((max(_e184, 0f) + 0.012f) + 0.0015f);
    let _e188 = e;
    let _e190 = margin;
    let _e192 = e;
    let _e193 = margin;
    let _e195 = t_1;
    let _e196 = t_1;
    let _e197 = t_1;
    let _e199 = t_1;
    mean = mix((-(_e188) - _e190), (_e192 + _e193), mix(_e195, ((_e196 * _e197) * (3f - (2f * _e199))), 0.5f));
    let _e205 = mean;
    let _e206 = amp;
    let _e207 = x_1;
    let _e208 = w;
    param_2 = (_e207 / _e208);
    let _e210 = t_1;
    param_3 = _e210;
    let _e211 = surface((&param_2), (&param_3));
    level = (_e205 + (_e206 * _e211));
    let _e214 = level;
    let _e215 = d;
    depth = (_e214 - _e215);
    let _e217 = depth;
    m = smoothstep(-0.0015f, 0.0015f, _e217);
    let _e220 = uniforms.refraction;
    let _e221 = stir;
    let _e223 = depth;
    bend = ((_e220 * _e221) * exp((-(max(_e223, 0f)) / 0.06f)));
    let _e229 = bend;
    let _e230 = dir;
    let _e231 = x_1;
    let _e233 = t_1;
    let _e238 = across;
    let _e239 = x_1;
    let _e241 = t_1;
    offset = (((_e230 * sin(((18f * _e231) - (7f * _e233)))) + (_e238 * cos(((13f * _e239) + (5f * _e241))))) * _e229);
    let _e248 = (*uv_2);
    let _e249 = offset;
    let _e251 = uniforms.ratio;
    param_4 = clamp((_e248 + (_e249 / vec2<f32>(_e251, 1f))), vec2(0f), vec2(1f));
    let _e258 = getToColor((&param_4));
    b = _e258;
    glow = 0f;
    let _e259 = mean;
    let _e260 = t_1;
    rise = (_e259 + (0.5f * _e260));
    let _e263 = x_1;
    let _e264 = d;
    let _e265 = rise;
    bq = (vec2<f32>(_e263, (_e264 - _e265)) / vec2(0.08f));
    let _e270 = bq;
    cell = floor(_e270);
    let _e272 = cell;
    param_5 = (_e272 + vec2(7.1f));
    let _e275 = hash((&param_5));
    hs = _e275;
    let _e276 = cell;
    param_6 = (_e276 + vec2(3.7f));
    let _e279 = hash((&param_6));
    let _e282 = stir;
    r = ((0.12f + (0.18f * _e279)) * _e282);
    px = 0.01875f;
    let _e284 = hs;
    let _e286 = uniforms.bubbles;
    let _e289 = r;
    let _e290 = px;
    if ((_e284 < (_e286 * 0.6f)) && (_e289 > _e290)) {
        let _e293 = cell;
        let _e296 = r;
        let _e298 = px;
        let _e300 = cell;
        param_7 = (_e300 + vec2(1.3f));
        let _e303 = hash((&param_7));
        let _e304 = cell;
        param_8 = (_e304 + vec2(9.4f));
        let _e307 = hash((&param_8));
        c = ((_e293 + vec2(0.5f)) + (((vec2<f32>(_e303, _e307) * 2f) - vec2(1f)) * ((0.42f - _e296) - _e298)));
        let _e314 = t_1;
        let _e316 = hs;
        let _e322 = c[0u];
        c[0u] = (_e322 + (0.08f * sin(((6f * _e314) + (6.28f * _e316)))));
        let _e325 = bq;
        let _e326 = c;
        dist = length((_e325 - _e326));
        let _e329 = r;
        let _e331 = px;
        let _e333 = r;
        let _e335 = px;
        let _e337 = dist;
        let _e339 = r;
        let _e340 = px;
        let _e342 = r;
        let _e343 = px;
        let _e345 = dist;
        rim = (smoothstep(((0.7f * _e329) - _e331), ((0.7f * _e333) + _e335), _e337) * (1f - smoothstep((_e339 - _e340), (_e342 + _e343), _e345)));
        let _e349 = r;
        let _e351 = px;
        let _e353 = r;
        let _e355 = px;
        let _e357 = bq;
        let _e358 = c;
        let _e360 = r;
        glint = (1f - smoothstep(((0.25f * _e349) - _e351), ((0.25f * _e353) + _e355), length(((_e357 - _e358) - (vec2<f32>(-0.7f, 0.7f) * (0.45f * _e360))))));
        let _e367 = rim;
        let _e369 = glint;
        let _e371 = depth;
        let _e374 = stir;
        glow = ((max((_e367 * 0.6f), _e369) * smoothstep(0f, 0.05f, _e371)) * _e374);
    }
    let _e376 = depth;
    line = (1f - smoothstep(0.0045f, 0.0075f, abs((_e376 - 0.006f))));
    let _e381 = stir;
    let _e383 = depth;
    let _e389 = m;
    let _e391 = line;
    line = (_e391 + (((0.35f * _e381) * exp((-(max(_e383, 0f)) / 0.03f))) * _e389));
    let _e395 = uniforms.highlight[3u];
    let _e396 = line;
    let _e397 = glow;
    let _e401 = stir;
    light = ((_e395 * clamp(max(_e396, _e397), 0f, 1f)) * (0.4f + (0.6f * _e401)));
    let _e405 = b;
    let _e408 = uniforms.highlight;
    let _e410 = light;
    let _e412 = mix(_e405.xyz, _e408.xyz, vec3(_e410));
    b[0u] = _e412.x;
    b[1u] = _e412.y;
    b[2u] = _e412.z;
    let _e419 = a;
    let _e422 = a[3u];
    let _e423 = (_e419.xyz * _e422);
    let _e425 = a[3u];
    let _e430 = b;
    let _e433 = b[3u];
    let _e434 = (_e430.xyz * _e433);
    let _e436 = b[3u];
    let _e441 = m;
    c_1 = mix(vec4<f32>(_e423.x, _e423.y, _e423.z, _e425), vec4<f32>(_e434.x, _e434.y, _e434.z, _e436), vec4(_e441));
    let _e445 = c_1[3u];
    if (_e445 > 0f) {
        let _e447 = c_1;
        let _e450 = c_1[3u];
        let _e452 = (_e447.xyz / vec3(_e450));
        let _e454 = c_1[3u];
        local_1 = vec4<f32>(_e452.x, _e452.y, _e452.z, _e454);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e459 = local_1;
    return _e459;
}

fn main_1() {
    var param_9: vec2<f32>;

    let _e67 = _uv_1;
    param_9 = _e67;
    let _e68 = transition((&param_9));
    _fragColor = _e68;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
