// LayoutGrid — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LayoutGrid.glsl
// Author: gre
// License: MIT
// Description: The frame splits into an asymmetric magazine grid as paper gutters open between the panels; panel after panel in reading order, the incoming image pushes the outgoing one out of its panel from a different side, a colored accent band between them, then the gutters close over the full incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    gutter: f32,
    overlap: f32,
    band: f32,
    shadow: f32,
    paper: vec4<f32>,
    accent: vec4<f32>,
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

fn easeInOut(t: ptr<function, f32>) -> f32 {
    var local: f32;

    let _e71 = (*t);
    if (_e71 < 0.5f) {
        let _e73 = (*t);
        let _e75 = (*t);
        let _e77 = (*t);
        local = (((4f * _e73) * _e75) * _e77);
    } else {
        let _e79 = (*t);
        let _e82 = (*t);
        let _e85 = (*t);
        local = (1f - (((4f * (1f - _e79)) * (1f - _e82)) * (1f - _e85)));
    }
    let _e89 = local;
    return _e89;
}

fn panelDir(i: ptr<function, i32>, portrait: ptr<function, bool>) -> vec2<f32> {
    let _e71 = (*portrait);
    if _e71 {
        let _e72 = (*i);
        if (_e72 == 0i) {
            return vec2<f32>(1f, 0f);
        }
        let _e74 = (*i);
        if (_e74 == 1i) {
            return vec2<f32>(0f, -1f);
        }
        let _e76 = (*i);
        if (_e76 == 2i) {
            return vec2<f32>(-1f, 0f);
        }
        let _e78 = (*i);
        if (_e78 == 3i) {
            return vec2<f32>(0f, 1f);
        }
        let _e80 = (*i);
        if (_e80 == 4i) {
            return vec2<f32>(1f, 0f);
        }
        return vec2<f32>(-1f, 0f);
    }
    let _e82 = (*i);
    if (_e82 == 0i) {
        return vec2<f32>(0f, -1f);
    }
    let _e84 = (*i);
    if (_e84 == 1i) {
        return vec2<f32>(-1f, 0f);
    }
    let _e86 = (*i);
    if (_e86 == 2i) {
        return vec2<f32>(0f, 1f);
    }
    let _e88 = (*i);
    if (_e88 == 3i) {
        return vec2<f32>(1f, 0f);
    }
    let _e90 = (*i);
    if (_e90 == 4i) {
        return vec2<f32>(-1f, 0f);
    }
    return vec2<f32>(1f, 0f);
}

fn span1(x: ptr<function, f32>, lo: ptr<function, f32>, hi: ptr<function, f32>, aa: ptr<function, f32>) -> f32 {
    let _e73 = (*lo);
    let _e74 = (*aa);
    let _e76 = (*lo);
    let _e77 = (*aa);
    let _e79 = (*x);
    let _e81 = (*hi);
    let _e82 = (*aa);
    let _e84 = (*hi);
    let _e85 = (*aa);
    let _e87 = (*x);
    return (smoothstep((_e73 - _e74), (_e76 + _e77), _e79) * (1f - smoothstep((_e81 - _e82), (_e84 + _e85), _e87)));
}

fn boxDist(p: ptr<function, vec2<f32>>, lo_1: ptr<function, vec2<f32>>, hi_1: ptr<function, vec2<f32>>) -> f32 {
    var d: vec2<f32>;

    let _e73 = (*p);
    let _e74 = (*lo_1);
    let _e75 = (*hi_1);
    let _e80 = (*hi_1);
    let _e81 = (*lo_1);
    d = (abs((_e73 - ((_e74 + _e75) * 0.5f))) - ((_e80 - _e81) * 0.5f));
    let _e85 = d;
    let _e90 = d[0u];
    let _e92 = d[1u];
    return (length(max(_e85, vec2(0f))) + min(max(_e90, _e92), 0f));
}

fn panelRect(i_1: ptr<function, i32>, portrait_1: ptr<function, bool>) -> vec4<f32> {
    let _e71 = (*portrait_1);
    if _e71 {
        let _e72 = (*i_1);
        if (_e72 == 0i) {
            return vec4<f32>(0f, 0.68f, 0.62f, 1f);
        }
        let _e74 = (*i_1);
        if (_e74 == 1i) {
            return vec4<f32>(0.62f, 0.68f, 1f, 1f);
        }
        let _e76 = (*i_1);
        if (_e76 == 2i) {
            return vec4<f32>(0f, 0.36f, 1f, 0.68f);
        }
        let _e78 = (*i_1);
        if (_e78 == 3i) {
            return vec4<f32>(0f, 0f, 0.46f, 0.36f);
        }
        let _e80 = (*i_1);
        if (_e80 == 4i) {
            return vec4<f32>(0.46f, 0.17f, 1f, 0.36f);
        }
        return vec4<f32>(0.46f, 0f, 1f, 0.17f);
    }
    let _e82 = (*i_1);
    if (_e82 == 0i) {
        return vec4<f32>(0f, 0.42f, 0.4f, 1f);
    }
    let _e84 = (*i_1);
    if (_e84 == 1i) {
        return vec4<f32>(0.4f, 0.64f, 1f, 1f);
    }
    let _e86 = (*i_1);
    if (_e86 == 2i) {
        return vec4<f32>(0.4f, 0f, 0.7f, 0.64f);
    }
    let _e88 = (*i_1);
    if (_e88 == 3i) {
        return vec4<f32>(0.7f, 0.32f, 1f, 0.64f);
    }
    let _e90 = (*i_1);
    if (_e90 == 4i) {
        return vec4<f32>(0.7f, 0f, 1f, 0.32f);
    }
    return vec4<f32>(0f, 0f, 0.4f, 0.42f);
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e71 = (*uv)[0u];
    let _e73 = (*uv)[1u];
    let _e76 = textureSampleLevel(_to, _sampler, vec2<f32>(_e71, (1f - _e73)), 0f);
    return _e76;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e71 = (*uv_1)[0u];
    let _e73 = (*uv_1)[1u];
    let _e76 = textureSampleLevel(_from, _sampler, vec2<f32>(_e71, (1f - _e73)), 0f);
    return _e76;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var portrait_2: bool;
    var aspect: vec2<f32>;
    var p_1: vec2<f32>;
    var open: f32;
    var g: f32;
    var ov: f32;
    var span: f32;
    var color: vec4<f32>;
    var cover: f32;
    var shade: f32;
    var i_2: i32;
    var r: vec4<f32>;
    var param_2: i32;
    var param_3: bool;
    var lo_2: vec2<f32>;
    var hi_2: vec2<f32>;
    var t_1: f32;
    var lift: f32;
    var sd: f32;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var inside: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var dir: vec2<f32>;
    var param_15: i32;
    var param_16: bool;
    var c: vec4<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var e: f32;
    var param_19: f32;
    var len: f32;
    var w: f32;
    var q: vec2<f32>;
    var a: f32;
    var local_1: vec2<f32>;
    var af: f32;
    var wf: f32;
    var fromW: f32;
    var toW: f32;
    var bandShade: f32;
    var b: vec4<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var bg: vec4<f32>;

    let _e126 = uniforms.progress;
    if (_e126 <= 0f) {
        let _e128 = (*uv_2);
        param = _e128;
        let _e129 = getFromColor((&param));
        return _e129;
    }
    let _e131 = uniforms.progress;
    if (_e131 >= 1f) {
        let _e133 = (*uv_2);
        param_1 = _e133;
        let _e134 = getToColor((&param_1));
        return _e134;
    }
    let _e136 = uniforms.ratio;
    portrait_2 = (_e136 < 1f);
    let _e139 = uniforms.ratio;
    let _e142 = uniforms.ratio;
    aspect = (vec2<f32>(_e139, 1f) / vec2(min(_e142, 1f)));
    let _e146 = (*uv_2);
    let _e147 = aspect;
    p_1 = (_e146 * _e147);
    let _e150 = uniforms.progress;
    let _e153 = uniforms.progress;
    open = (smoothstep(0f, 0.28f, _e150) * (1f - smoothstep(0.72f, 1f, _e153)));
    let _e158 = uniforms.gutter;
    let _e159 = open;
    g = (_e158 * _e159);
    let _e162 = uniforms.overlap;
    ov = clamp(_e162, 0f, 0.9f);
    let _e164 = ov;
    span = (0.8f / (1f + (5f * (1f - _e164))));
    color = vec4<f32>(0f, 0f, 0f, 0f);
    cover = 0f;
    shade = 0f;
    i_2 = 0i;
    loop {
        let _e169 = i_2;
        if (_e169 < 6i) {
            let _e171 = i_2;
            param_2 = _e171;
            let _e172 = portrait_2;
            param_3 = _e172;
            let _e173 = panelRect((&param_2), (&param_3));
            r = _e173;
            let _e174 = r;
            let _e176 = aspect;
            let _e178 = g;
            lo_2 = ((_e174.xy * _e176) + vec2((0.5f * _e178)));
            let _e182 = r;
            let _e184 = aspect;
            let _e186 = g;
            hi_2 = ((_e182.zw * _e184) - vec2((0.5f * _e186)));
            let _e190 = lo_2;
            let _e191 = r;
            lo_2 = mix(_e190, vec2<f32>(-1f, -1f), step(_e191.xy, vec2<f32>(0f, 0f)));
            let _e195 = hi_2;
            let _e196 = aspect;
            let _e199 = r;
            hi_2 = mix(_e195, (_e196 + vec2(1f)), step(vec2<f32>(1f, 1f), _e199.zw));
            let _e204 = uniforms.progress;
            let _e206 = i_2;
            let _e208 = span;
            let _e210 = ov;
            let _e214 = span;
            t_1 = clamp((((_e204 - 0.1f) - ((f32(_e206) * _e208) * (1f - _e210))) / _e214), 0f, 1f);
            let _e217 = t_1;
            lift = (1f + (1.2f * sin((3.1415927f * _e217))));
            let _e222 = p_1;
            let _e223 = g;
            let _e225 = lift;
            param_4 = (_e222 - ((vec2<f32>(0.2f, -0.35f) * _e223) * _e225));
            let _e228 = lo_2;
            param_5 = _e228;
            let _e229 = hi_2;
            param_6 = _e229;
            let _e230 = boxDist((&param_4), (&param_5), (&param_6));
            sd = _e230;
            let _e231 = shade;
            let _e232 = g;
            let _e234 = g;
            let _e236 = lift;
            let _e239 = sd;
            let _e242 = lift;
            shade = max(_e231, ((1f - smoothstep((-0.2f * _e232), (((0.6f * _e234) * _e236) + 0.0001f), _e239)) / sqrt(_e242)));
            let _e247 = p_1[0u];
            param_7 = _e247;
            let _e249 = lo_2[0u];
            param_8 = _e249;
            let _e251 = hi_2[0u];
            param_9 = _e251;
            param_10 = 0.0025f;
            let _e252 = span1((&param_7), (&param_8), (&param_9), (&param_10));
            let _e254 = p_1[1u];
            param_11 = _e254;
            let _e256 = lo_2[1u];
            param_12 = _e256;
            let _e258 = hi_2[1u];
            param_13 = _e258;
            param_14 = 0.0025f;
            let _e259 = span1((&param_11), (&param_12), (&param_13), (&param_14));
            inside = (_e252 * _e259);
            let _e261 = inside;
            if (_e261 > 0f) {
                let _e263 = i_2;
                param_15 = _e263;
                let _e264 = portrait_2;
                param_16 = _e264;
                let _e265 = panelDir((&param_15), (&param_16));
                dir = _e265;
                let _e266 = t_1;
                if (_e266 <= 0f) {
                    let _e268 = (*uv_2);
                    param_17 = _e268;
                    let _e269 = getFromColor((&param_17));
                    c = _e269;
                } else {
                    let _e270 = t_1;
                    if (_e270 >= 1f) {
                        let _e272 = (*uv_2);
                        param_18 = _e272;
                        let _e273 = getToColor((&param_18));
                        c = _e273;
                    } else {
                        let _e274 = t_1;
                        param_19 = _e274;
                        let _e275 = easeInOut((&param_19));
                        e = _e275;
                        let _e276 = r;
                        let _e278 = r;
                        let _e281 = dir;
                        len = abs(dot((_e276.zw - _e278.xy), _e281));
                        let _e285 = uniforms.band;
                        let _e286 = len;
                        w = (_e285 * _e286);
                        let _e288 = (*uv_2);
                        let _e289 = dir;
                        let _e290 = e;
                        let _e292 = len;
                        let _e293 = w;
                        q = (_e288 - ((_e289 * _e290) * (_e292 + _e293)));
                        let _e297 = q;
                        let _e299 = dir[0u];
                        let _e301 = dir[1u];
                        if ((_e299 + _e301) < 0f) {
                            let _e304 = r;
                            local_1 = _e304.zw;
                        } else {
                            let _e306 = r;
                            local_1 = _e306.xy;
                        }
                        let _e308 = local_1;
                        let _e310 = dir;
                        a = dot((_e297 - _e308), _e310);
                        let _e312 = a;
                        let _e313 = aspect;
                        let _e314 = dir;
                        af = (_e312 * abs(dot(_e313, _e314)));
                        let _e318 = w;
                        let _e319 = aspect;
                        let _e320 = dir;
                        wf = (_e318 * abs(dot(_e319, _e320)));
                        let _e324 = af;
                        fromW = smoothstep(-0.0025f, 0f, _e324);
                        let _e326 = wf;
                        let _e328 = wf;
                        let _e331 = af;
                        toW = (1f - smoothstep(-(_e326), (-(_e328) + 0.0025f), _e331));
                        let _e335 = uniforms.shadow;
                        let _e337 = wf;
                        let _e339 = wf;
                        let _e341 = wf;
                        let _e345 = af;
                        bandShade = (1f - ((_e335 * 0.5f) * (1f - smoothstep(-(_e337), ((-(_e339) + (0.35f * _e341)) + 0.0001f), _e345))));
                        let _e351 = uniforms.accent;
                        let _e353 = bandShade;
                        let _e354 = (_e351.xyz * _e353);
                        let _e357 = uniforms.accent[3u];
                        b = vec4<f32>(_e354.x, _e354.y, _e354.z, _e357);
                        let _e362 = b;
                        let _e363 = q;
                        let _e364 = r;
                        let _e366 = r;
                        param_20 = clamp(_e363, _e364.xy, _e366.zw);
                        let _e369 = getFromColor((&param_20));
                        let _e370 = fromW;
                        c = mix(_e362, _e369, vec4(_e370));
                        let _e373 = c;
                        let _e374 = q;
                        let _e375 = dir;
                        let _e376 = len;
                        let _e377 = w;
                        let _e381 = r;
                        let _e383 = r;
                        param_21 = clamp((_e374 + (_e375 * (_e376 + _e377))), _e381.xy, _e383.zw);
                        let _e386 = getToColor((&param_21));
                        let _e387 = toW;
                        c = mix(_e373, _e386, vec4(_e387));
                    }
                }
                let _e390 = c;
                let _e391 = inside;
                let _e393 = color;
                color = (_e393 + (_e390 * _e391));
                let _e395 = inside;
                let _e396 = cover;
                cover = (_e396 + _e395);
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e398 = i_2;
            i_2 = (_e398 + 1i);
        }
    }
    let _e400 = cover;
    let _e402 = color;
    color = (_e402 / vec4(max(_e400, 1f)));
    let _e405 = cover;
    cover = min(_e405, 1f);
    let _e408 = uniforms.paper;
    let _e411 = uniforms.shadow;
    let _e412 = shade;
    let _e414 = open;
    let _e417 = (_e408.xyz * (1f - ((_e411 * _e412) * _e414)));
    let _e420 = uniforms.paper[3u];
    bg = vec4<f32>(_e417.x, _e417.y, _e417.z, _e420);
    let _e425 = color;
    let _e426 = bg;
    let _e427 = cover;
    return (_e425 + (_e426 * (1f - _e427)));
}

fn main_1() {
    var param_22: vec2<f32>;

    let _e70 = _uv_1;
    param_22 = _e70;
    let _e71 = transition((&param_22));
    _fragColor = _e71;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
