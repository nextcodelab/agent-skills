// GooeyWipe — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GooeyWipe.glsl
// Author: gre
// License: MIT
// Description: Soft, glossy blobs of liquid pop up over the outgoing image, swell and melt into each other, revealing the incoming image until they cover the whole frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    blobs: f32,
    smoothness: f32,
    highlight: vec4<f32>,
    shadow: vec4<f32>,
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
    let _e58 = (*uv)[0u];
    let _e60 = (*uv)[1u];
    let _e63 = textureSampleLevel(_from, _sampler, vec2<f32>(_e58, (1f - _e60)), 0f);
    return _e63;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e58 = (*uv_1)[0u];
    let _e60 = (*uv_1)[1u];
    let _e63 = textureSampleLevel(_to, _sampler, vec2<f32>(_e58, (1f - _e60)), 0f);
    return _e63;
}

fn fold(p: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e57 = (*p);
    let _e58 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e57 - (floor((_e57 / _e58)) * _e58)))));
}

fn hash(p_1: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e58 = (*p_1);
    p3_ = fract((_e58.xyx * 0.1031f));
    let _e62 = p3_;
    let _e63 = p3_;
    let _e68 = p3_;
    p3_ = (_e68 + vec3(dot(_e62, (_e63.yzx + vec3(33.33f)))));
    let _e72 = p3_[0u];
    let _e74 = p3_[1u];
    let _e77 = p3_[2u];
    return fract(((_e72 + _e74) * _e77));
}

fn blob(cell: ptr<function, vec2<f32>>, rStart: ptr<function, f32>, rEnd: ptr<function, f32>) -> vec3<f32> {
    var c: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var t0_: f32;
    var param_2: vec2<f32>;
    var s: f32;
    var pop: f32;
    var r: f32;

    let _e67 = (*cell);
    let _e70 = (*cell);
    param = (_e70 + vec2(0.5f));
    let _e73 = hash((&param));
    let _e74 = (*cell);
    param_1 = (_e74 + vec2(41.3f));
    let _e77 = hash((&param_1));
    c = ((_e67 + vec2(0.5f)) + ((vec2<f32>(_e73, _e77) - vec2(0.5f)) * 0.7f));
    let _e83 = (*cell);
    param_2 = (_e83 + vec2(17.9f));
    let _e86 = hash((&param_2));
    t0_ = (0.02f + (0.43f * _e86));
    let _e90 = uniforms.progress;
    let _e91 = t0_;
    let _e93 = t0_;
    s = clamp(((_e90 - _e91) / (1f - _e93)), 0f, 1f);
    let _e98 = uniforms.progress;
    let _e99 = t0_;
    pop = clamp(((_e98 - _e99) / 0.12f), 0f, 1f);
    let _e103 = pop;
    let _e105 = pop;
    let _e108 = pop;
    pop = (1f - (((1f - _e103) * (1f - _e105)) * (1f - _e108)));
    let _e112 = (*rStart);
    let _e113 = pop;
    let _e115 = (*rEnd);
    let _e117 = s;
    let _e119 = s;
    r = (mix(_e112, 0.18f, _e113) + (((_e115 - 0.18f) * _e117) * sqrt(_e119)));
    let _e123 = pop;
    let _e127 = s;
    let _e130 = pop;
    let _e132 = r;
    r = (_e132 + (((0.05f * sin((_e123 * 9f))) * (1f - _e127)) * _e130));
    let _e134 = r;
    let _e135 = c;
    return vec3<f32>(_e134, _e135.x, _e135.y);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n: f32;
    var cellSize: f32;
    var q: vec2<f32>;
    var base: vec2<f32>;
    var k: f32;
    var w: f32;
    var rStart_1: f32;
    var rEnd_1: f32;
    var m: f32;
    var sum: f32;
    var grad: vec2<f32>;
    var rNear: f32;
    var j: i32;
    var i: i32;
    var b: vec3<f32>;
    var param_3: vec2<f32>;
    var param_4: f32;
    var param_5: f32;
    var dq: vec2<f32>;
    var l: f32;
    var dist: f32;
    var g: vec2<f32>;
    var scale: f32;
    var wt: f32;
    var d: f32;
    var aa: f32;
    var inside: f32;
    var h: f32;
    var settle: f32;
    var tilt: f32;
    var nrm: vec3<f32>;
    var halfway: vec3<f32>;
    var spec: f32;
    var shade: f32;
    var to: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var t2_: f32;
    var gloss: f32;
    var from_: vec4<f32>;
    var param_8: vec2<f32>;
    var sh: f32;

    let _e100 = uniforms.blobs;
    n = max(1f, floor((_e100 + 0.5f)));
    let _e105 = uniforms.ratio;
    let _e107 = n;
    cellSize = (max(_e105, 1f) / _e107);
    let _e110 = (*uv_2)[0u];
    let _e112 = uniforms.ratio;
    let _e115 = (*uv_2)[1u];
    let _e117 = cellSize;
    q = (vec2<f32>((_e110 * _e112), _e115) / vec2(_e117));
    let _e120 = q;
    base = floor(_e120);
    let _e123 = uniforms.smoothness;
    k = (0.02f + (0.25f * _e123));
    w = 0.16f;
    let _e126 = k;
    rStart_1 = -((0.03f + (4f * _e126)));
    let _e130 = w;
    rEnd_1 = ((1.2020816f + _e130) + 0.05f);
    m = 1000f;
    sum = 0f;
    grad = vec2<f32>(0f, 0f);
    rNear = 0f;
    j = -3i;
    loop {
        let _e133 = j;
        if (_e133 <= 3i) {
            i = -3i;
            loop {
                let _e135 = i;
                if (_e135 <= 3i) {
                    let _e137 = base;
                    let _e138 = i;
                    let _e140 = j;
                    param_3 = (_e137 + vec2<f32>(f32(_e138), f32(_e140)));
                    let _e144 = rStart_1;
                    param_4 = _e144;
                    let _e145 = rEnd_1;
                    param_5 = _e145;
                    let _e146 = blob((&param_3), (&param_4), (&param_5));
                    b = _e146;
                    let _e147 = q;
                    let _e148 = b;
                    dq = (_e147 - _e148.yz);
                    let _e151 = dq;
                    l = length(_e151);
                    let _e153 = l;
                    let _e155 = b[0u];
                    dist = (_e153 - _e155);
                    let _e157 = dq;
                    let _e158 = l;
                    g = (_e157 / vec2(max(_e158, 0.0001f)));
                    let _e162 = dist;
                    let _e163 = m;
                    if (_e162 < _e163) {
                        let _e165 = dist;
                        let _e166 = m;
                        let _e168 = k;
                        scale = exp(((_e165 - _e166) / _e168));
                        let _e171 = sum;
                        let _e172 = scale;
                        sum = ((_e171 * _e172) + 1f);
                        let _e175 = grad;
                        let _e176 = scale;
                        let _e178 = g;
                        grad = ((_e175 * _e176) + _e178);
                        let _e180 = dist;
                        m = _e180;
                        let _e182 = b[0u];
                        rNear = _e182;
                    } else {
                        let _e183 = m;
                        let _e184 = dist;
                        let _e186 = k;
                        wt = exp(((_e183 - _e184) / _e186));
                        let _e189 = wt;
                        let _e190 = sum;
                        sum = (_e190 + _e189);
                        let _e192 = wt;
                        let _e193 = g;
                        let _e195 = grad;
                        grad = (_e195 + (_e193 * _e192));
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e197 = i;
                    i = (_e197 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e199 = j;
            j = (_e199 + 1i);
        }
    }
    let _e201 = m;
    let _e202 = k;
    let _e203 = sum;
    d = (_e201 - (_e202 * log(_e203)));
    let _e207 = sum;
    let _e208 = grad;
    grad = (_e208 / vec2(_e207));
    let _e211 = n;
    aa = ((0.012f * _e211) / 5f);
    let _e214 = aa;
    let _e216 = aa;
    let _e217 = d;
    inside = (1f - smoothstep(-(_e214), _e216, _e217));
    let _e220 = d;
    let _e222 = w;
    h = clamp((-(_e220) / _e222), 0f, 1f);
    let _e226 = uniforms.progress;
    settle = (1f - smoothstep(0.45f, 0.85f, _e226));
    let _e229 = h;
    let _e231 = h;
    let _e234 = settle;
    tilt = (((1f - _e229) * (1f - _e231)) * _e234);
    let _e236 = grad;
    let _e237 = tilt;
    let _e239 = ((_e236 * _e237) * 3f);
    nrm = normalize(vec3<f32>(_e239.x, _e239.y, 1f));
    halfway = vec3<f32>(-0.16829646f, 0.21638116f, 0.96169406f);
    let _e244 = nrm;
    let _e245 = halfway;
    let _e249 = settle;
    spec = (pow(max(dot(_e244, _e245), 0f), 200f) * _e249);
    let _e251 = tilt;
    let _e252 = grad;
    shade = (1f - (_e251 * (0.25f + (0.3f * clamp((dot(_e252, vec2<f32>(0.6f, -0.8f)) + 0.3f), 0f, 1f)))));
    let _e260 = (*uv_2);
    let _e261 = grad;
    let _e262 = tilt;
    let _e265 = cellSize;
    let _e268 = uniforms.ratio;
    param_6 = (_e260 - ((((_e261 * _e262) * 0.01f) * _e265) / vec2<f32>(_e268, 1f)));
    let _e272 = fold((&param_6));
    param_7 = _e272;
    let _e273 = getToColor((&param_7));
    to = _e273;
    let _e274 = tilt;
    let _e275 = tilt;
    t2_ = (_e274 * _e275);
    let _e277 = t2_;
    let _e279 = t2_;
    gloss = ((0.3f * _e277) * _e279);
    let _e281 = to;
    let _e283 = shade;
    let _e286 = uniforms.highlight;
    let _e288 = spec;
    let _e289 = gloss;
    let _e294 = uniforms.highlight[3u];
    let _e297 = mix((_e281.xyz * _e283), _e286.xyz, vec3((clamp((_e288 + _e289), 0f, 1f) * _e294)));
    to[0u] = _e297.x;
    to[1u] = _e297.y;
    to[2u] = _e297.z;
    let _e304 = (*uv_2);
    param_8 = _e304;
    let _e305 = getFromColor((&param_8));
    from_ = _e305;
    let _e308 = uniforms.shadow[3u];
    let _e309 = d;
    let _e314 = rNear;
    sh = ((_e308 * (1f - smoothstep(0f, 0.15f, (_e309 + 0.03f)))) * smoothstep(0f, 0.3f, _e314));
    let _e317 = from_;
    let _e320 = uniforms.shadow;
    let _e322 = sh;
    let _e324 = mix(_e317.xyz, _e320.xyz, vec3(_e322));
    from_[0u] = _e324.x;
    from_[1u] = _e324.y;
    from_[2u] = _e324.z;
    let _e331 = from_;
    let _e332 = to;
    let _e333 = inside;
    return mix(_e331, _e332, vec4(_e333));
}

fn main_1() {
    var param_9: vec2<f32>;

    let _e57 = _uv_1;
    param_9 = _e57;
    let _e58 = transition((&param_9));
    _fragColor = _e58;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
