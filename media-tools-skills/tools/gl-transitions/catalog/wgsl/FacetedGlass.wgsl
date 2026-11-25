// FacetedGlass — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FacetedGlass.glsl
// Author: gre
// License: MIT
// Description: The frame is seen through a pane of irregular cut-glass facets, each one showing its own shifted, zoomed and tilted view of the image, with bright beveled edges and thin dark seams; the facets turn to the incoming image one by one, then the glass flattens out and clears
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    facets: f32,
    refraction: f32,
    bevel: f32,
    highlight: vec4<f32>,
    seed: f32,
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

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e57 = (*v);
    let _e58 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e57 - (floor((_e57 / _e58)) * _e58)))));
}

fn hash22(p: ptr<function, vec2<f32>>) -> vec2<f32> {
    var p3_: vec3<f32>;

    let _e58 = (*p);
    p3_ = fract((_e58.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e62 = p3_;
    let _e63 = p3_;
    let _e68 = p3_;
    p3_ = (_e68 + vec3(dot(_e62, (_e63.yzx + vec3(33.33f)))));
    let _e71 = p3_;
    let _e73 = p3_;
    let _e76 = p3_;
    return fract(((_e71.xx + _e73.yz) * _e76.zy));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e58 = (*uv)[0u];
    let _e60 = (*uv)[1u];
    let _e63 = textureSampleLevel(_to, _sampler, vec2<f32>(_e58, (1f - _e60)), 0f);
    return _e63;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e58 = (*uv_1)[0u];
    let _e60 = (*uv_1)[1u];
    let _e63 = textureSampleLevel(_from, _sampler, vec2<f32>(_e58, (1f - _e60)), 0f);
    return _e63;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var h: f32;
    var amount: f32;
    var n: f32;
    var aspect: vec2<f32>;
    var p_1: vec2<f32>;
    var i: vec2<f32>;
    var f: vec2<f32>;
    var offset: vec2<f32>;
    var bw: f32;
    var mg: vec2<f32>;
    var mr: vec2<f32>;
    var md: f32;
    var y: i32;
    var x: i32;
    var g: vec2<f32>;
    var r: vec2<f32>;
    var param_2: vec2<f32>;
    var d: f32;
    var edge: f32;
    var normal: vec2<f32>;
    var y_1: i32;
    var x_1: i32;
    var g_1: vec2<f32>;
    var r_1: vec2<f32>;
    var param_3: vec2<f32>;
    var dr: vec2<f32>;
    var dn: vec2<f32>;
    var e: f32;
    var w: f32;
    var nl: f32;
    var local: vec2<f32>;
    var id: vec2<f32>;
    var h1_: vec2<f32>;
    var param_4: vec2<f32>;
    var h2_: vec2<f32>;
    var param_5: vec2<f32>;
    var h3_: vec2<f32>;
    var param_6: vec2<f32>;
    var angle: f32;
    var dir: vec2<f32>;
    var shift: vec2<f32>;
    var zoom: f32;
    var tilt: f32;
    var q: vec2<f32>;
    var view: vec2<f32>;
    var bv: f32;
    var bend: vec2<f32>;
    var start: f32;
    var m: f32;
    var d_1: vec2<f32>;
    var s: vec2<f32>;
    var ca: vec4<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var cb: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var c: vec4<f32>;
    var light: vec2<f32>;
    var slope: vec2<f32>;
    var facetLight: f32;
    var lit: f32;
    var k: f32;
    var glow: f32;
    var shade: f32;
    var turn: f32;
    var seam: f32;
    var local_1: vec4<f32>;

    let _e128 = uniforms.progress;
    if (_e128 <= 0f) {
        let _e130 = (*uv_2);
        param = _e130;
        let _e131 = getFromColor((&param));
        return _e131;
    }
    let _e133 = uniforms.progress;
    if (_e133 >= 1f) {
        let _e135 = (*uv_2);
        param_1 = _e135;
        let _e136 = getToColor((&param_1));
        return _e136;
    }
    let _e138 = uniforms.progress;
    h = (1f - abs(((2f * _e138) - 1f)));
    let _e143 = h;
    let _e144 = h;
    let _e146 = h;
    amount = ((_e143 * _e144) * (3f - (2f * _e146)));
    let _e151 = uniforms.facets;
    n = max(_e151, 1f);
    let _e154 = uniforms.ratio;
    aspect = vec2<f32>(_e154, 1f);
    let _e156 = (*uv_2);
    let _e157 = aspect;
    let _e159 = n;
    p_1 = ((_e156 * _e157) * _e159);
    let _e161 = p_1;
    i = floor(_e161);
    let _e163 = p_1;
    let _e164 = i;
    f = (_e163 - _e164);
    let _e167 = uniforms.seed;
    offset = (vec2<f32>(17.31f, 41.97f) * _e167);
    let _e169 = amount;
    bw = (0.18f * _e169);
    mg = vec2<f32>(0f, 0f);
    mr = vec2<f32>(0f, 0f);
    md = 8f;
    y = -1i;
    loop {
        let _e171 = y;
        if (_e171 <= 1i) {
            x = -1i;
            loop {
                let _e173 = x;
                if (_e173 <= 1i) {
                    let _e175 = x;
                    let _e177 = y;
                    g = vec2<f32>(f32(_e175), f32(_e177));
                    let _e180 = g;
                    let _e183 = i;
                    let _e184 = g;
                    let _e186 = offset;
                    param_2 = ((_e183 + _e184) + _e186);
                    let _e188 = hash22((&param_2));
                    let _e191 = f;
                    r = (((_e180 + vec2(0.1f)) + (_e188 * 0.8f)) - _e191);
                    let _e193 = r;
                    let _e194 = r;
                    d = dot(_e193, _e194);
                    let _e196 = d;
                    let _e197 = md;
                    if (_e196 < _e197) {
                        let _e199 = d;
                        md = _e199;
                        let _e200 = r;
                        mr = _e200;
                        let _e201 = g;
                        mg = _e201;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e202 = x;
                    x = (_e202 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e204 = y;
            y = (_e204 + 1i);
        }
    }
    edge = 8f;
    normal = vec2<f32>(0f, 0f);
    y_1 = -2i;
    loop {
        let _e206 = y_1;
        if (_e206 <= 2i) {
            x_1 = -2i;
            loop {
                let _e208 = x_1;
                if (_e208 <= 2i) {
                    let _e210 = mg;
                    let _e211 = x_1;
                    let _e213 = y_1;
                    g_1 = (_e210 + vec2<f32>(f32(_e211), f32(_e213)));
                    let _e217 = g_1;
                    let _e220 = i;
                    let _e221 = g_1;
                    let _e223 = offset;
                    param_3 = ((_e220 + _e221) + _e223);
                    let _e225 = hash22((&param_3));
                    let _e228 = f;
                    r_1 = (((_e217 + vec2(0.1f)) + (_e225 * 0.8f)) - _e228);
                    let _e230 = r_1;
                    let _e231 = mr;
                    dr = (_e230 - _e231);
                    let _e233 = dr;
                    let _e234 = dr;
                    if (dot(_e233, _e234) > 0.00001f) {
                        let _e237 = dr;
                        dn = normalize(_e237);
                        let _e239 = mr;
                        let _e240 = r_1;
                        let _e243 = dn;
                        e = dot(((_e239 + _e240) * 0.5f), _e243);
                        let _e245 = edge;
                        let _e246 = e;
                        edge = min(_e245, _e246);
                        let _e248 = e;
                        let _e249 = bw;
                        w = max((1f - (_e248 / _e249)), 0f);
                        let _e253 = dn;
                        let _e254 = w;
                        let _e256 = w;
                        let _e258 = normal;
                        normal = (_e258 + ((_e253 * _e254) * _e256));
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e260 = x_1;
                    x_1 = (_e260 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e262 = y_1;
            y_1 = (_e262 + 1i);
        }
    }
    let _e264 = normal;
    nl = length(_e264);
    let _e266 = nl;
    if (_e266 > 0f) {
        let _e268 = normal;
        let _e269 = nl;
        local = (_e268 / vec2(_e269));
    } else {
        local = vec2<f32>(0f, 0f);
    }
    let _e272 = local;
    normal = _e272;
    let _e273 = i;
    let _e274 = mg;
    let _e276 = offset;
    id = ((_e273 + _e274) + _e276);
    let _e278 = id;
    param_4 = (_e278 + vec2(31.7f));
    let _e281 = hash22((&param_4));
    h1_ = _e281;
    let _e282 = id;
    param_5 = (_e282 + vec2(59.3f));
    let _e285 = hash22((&param_5));
    h2_ = _e285;
    let _e286 = id;
    param_6 = (_e286 + vec2(97.1f));
    let _e289 = hash22((&param_6));
    h3_ = _e289;
    let _e291 = h1_[0u];
    angle = (6.2831855f * _e291);
    let _e293 = angle;
    let _e295 = angle;
    dir = vec2<f32>(cos(_e293), sin(_e295));
    let _e298 = dir;
    let _e300 = h1_[1u];
    let _e305 = uniforms.refraction;
    shift = ((_e298 * (0.4f + (0.6f * _e300))) * _e305);
    let _e308 = h2_[0u];
    let _e312 = uniforms.refraction;
    zoom = (((_e308 - 0.5f) * 6f) * _e312);
    let _e315 = h2_[1u];
    let _e319 = uniforms.refraction;
    tilt = (((_e315 - 0.5f) * 2f) * _e319);
    let _e321 = mr;
    let _e323 = n;
    q = (-(_e321) / vec2(_e323));
    let _e326 = q;
    let _e328 = zoom;
    let _e331 = q[1u];
    let _e334 = q[0u];
    let _e336 = tilt;
    let _e340 = q;
    let _e341 = tilt;
    view = (((-(_e326) * _e328) + (vec2<f32>(-(_e331), _e334) * sin(_e336))) + (_e340 * (cos(_e341) - 1f)));
    let _e346 = bw;
    let _e347 = edge;
    bv = (1f - smoothstep(0f, _e346, _e347));
    let _e350 = bv;
    let _e351 = bv;
    bv = (_e351 * _e350);
    let _e353 = normal;
    let _e354 = bv;
    let _e358 = uniforms.refraction;
    bend = (((_e353 * _e354) * 0.4f) * _e358);
    let _e361 = h3_[0u];
    start = (0.15f + (0.5f * _e361));
    let _e364 = start;
    let _e365 = start;
    let _e368 = uniforms.progress;
    m = smoothstep(_e364, (_e365 + 0.2f), _e368);
    let _e370 = amount;
    let _e371 = view;
    let _e372 = bend;
    d_1 = ((_e371 + _e372) * _e370);
    let _e375 = amount;
    let _e376 = shift;
    s = (_e376 * _e375);
    let _e378 = (*uv_2);
    let _e379 = s;
    let _e380 = d_1;
    let _e382 = aspect;
    param_7 = (_e378 + ((_e379 + _e380) / _e382));
    let _e385 = mirror((&param_7));
    param_8 = _e385;
    let _e386 = getFromColor((&param_8));
    ca = _e386;
    let _e387 = (*uv_2);
    let _e388 = d_1;
    let _e389 = s;
    let _e391 = aspect;
    param_9 = (_e387 + ((_e388 - _e389) / _e391));
    let _e394 = mirror((&param_9));
    param_10 = _e394;
    let _e395 = getToColor((&param_10));
    cb = _e395;
    let _e396 = ca;
    let _e399 = ca[3u];
    let _e400 = (_e396.xyz * _e399);
    let _e402 = ca[3u];
    let _e407 = cb;
    let _e410 = cb[3u];
    let _e411 = (_e407.xyz * _e410);
    let _e413 = cb[3u];
    let _e418 = m;
    c = mix(vec4<f32>(_e400.x, _e400.y, _e400.z, _e402), vec4<f32>(_e411.x, _e411.y, _e411.z, _e413), vec4(_e418));
    light = vec2<f32>(-0.6f, 0.8f);
    let _e421 = dir;
    let _e423 = h1_[1u];
    slope = (_e421 * (0.4f + (0.6f * _e423)));
    let _e427 = amount;
    let _e429 = slope;
    let _e430 = light;
    facetLight = ((0.12f * _e427) * dot(_e429, _e430));
    let _e433 = normal;
    let _e434 = light;
    lit = dot(_e433, _e434);
    let _e437 = uniforms.bevel;
    k = clamp(_e437, 0f, 1f);
    let _e439 = k;
    let _e440 = bv;
    let _e442 = lit;
    let _e446 = amount;
    glow = ((((_e439 * _e440) * max(_e442, 0f)) * 1.1f) * _e446);
    let _e448 = k;
    let _e449 = bv;
    let _e451 = lit;
    let _e456 = amount;
    shade = ((((_e448 * _e449) * max(-(_e451), 0f)) * 0.6f) * _e456);
    let _e458 = m;
    turn = sin((3.1415927f * _e458));
    let _e461 = k;
    let _e463 = amount;
    let _e465 = turn;
    let _e467 = turn;
    let _e469 = glow;
    glow = (_e469 + ((((_e461 * 0.15f) * _e463) * _e465) * _e467));
    let _e471 = amount;
    let _e473 = edge;
    let _e474 = n;
    seam = ((0.6f * _e471) * (1f - smoothstep(0f, 0.003f, ((_e473 / _e474) - 0.00075f))));
    let _e480 = facetLight;
    let _e482 = shade;
    let _e485 = seam;
    let _e488 = c;
    let _e490 = (_e488.xyz * (((1f + _e480) * (1f - _e482)) * (1f - _e485)));
    c[0u] = _e490.x;
    c[1u] = _e490.y;
    c[2u] = _e490.z;
    let _e498 = uniforms.highlight;
    let _e502 = uniforms.highlight[3u];
    let _e504 = glow;
    let _e507 = c[3u];
    let _e509 = c;
    let _e511 = (_e509.xyz + (((_e498.xyz * _e502) * _e504) * _e507));
    c[0u] = _e511.x;
    c[1u] = _e511.y;
    c[2u] = _e511.z;
    let _e519 = c[3u];
    if (_e519 > 0f) {
        let _e521 = c;
        let _e524 = c[3u];
        let _e529 = clamp((_e521.xyz / vec3(_e524)), vec3(0f), vec3(1f));
        let _e531 = c[3u];
        local_1 = vec4<f32>(_e529.x, _e529.y, _e529.z, _e531);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e536 = local_1;
    return _e536;
}

fn main_1() {
    var param_11: vec2<f32>;

    let _e57 = _uv_1;
    param_11 = _e57;
    let _e58 = transition((&param_11));
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
