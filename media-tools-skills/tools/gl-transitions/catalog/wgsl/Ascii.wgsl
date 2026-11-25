// Ascii — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Ascii.glsl
// Author: gre
// License: MIT
// Description: The image turns into text-mode characters, denser where it is brighter, the characters scramble into those of the incoming image, then resolve back into it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cellSize: f32,
    colored: i32,
    ink: vec4<f32>,
    background: vec4<f32>,
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
    let _e121 = (*uv)[0u];
    let _e123 = (*uv)[1u];
    let _e126 = textureSampleLevel(_to, _sampler, vec2<f32>(_e121, (1f - _e123)), 0f);
    return _e126;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e121 = (*uv_1)[0u];
    let _e123 = (*uv_1)[1u];
    let _e126 = textureSampleLevel(_from, _sampler, vec2<f32>(_e121, (1f - _e123)), 0f);
    return _e126;
}

fn segment(q: ptr<function, vec2<f32>>, a: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>) -> f32 {
    var pa: vec2<f32>;
    var ba: vec2<f32>;

    let _e124 = (*q);
    let _e125 = (*a);
    pa = (_e124 - _e125);
    let _e127 = (*b);
    let _e128 = (*a);
    ba = (_e127 - _e128);
    let _e130 = pa;
    let _e131 = ba;
    let _e132 = pa;
    let _e133 = ba;
    let _e135 = ba;
    let _e136 = ba;
    return length((_e130 - (_e131 * clamp((dot(_e132, _e133) / dot(_e135, _e136)), 0f, 1f))));
}

fn glyph(g: ptr<function, f32>, q_1: ptr<function, vec2<f32>>) -> f32 {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var d: f32;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var param_23: vec2<f32>;
    var d_1: f32;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;
    var param_28: vec2<f32>;
    var param_29: vec2<f32>;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;
    var param_32: vec2<f32>;
    var param_33: vec2<f32>;
    var param_34: vec2<f32>;
    var param_35: vec2<f32>;
    var d_2: f32;
    var param_36: vec2<f32>;
    var param_37: vec2<f32>;
    var param_38: vec2<f32>;
    var d_3: f32;
    var param_39: vec2<f32>;
    var param_40: vec2<f32>;
    var param_41: vec2<f32>;

    let _e167 = (*g);
    if (_e167 < 0.5f) {
        return 1f;
    }
    let _e169 = (*g);
    if (_e169 < 1.5f) {
        let _e171 = (*q_1);
        return (length((_e171 - vec2<f32>(0f, -0.27f))) - 0.035f);
    }
    let _e175 = (*g);
    if (_e175 < 2.5f) {
        let _e177 = (*q_1);
        let _e180 = (*q_1);
        return (min(length((_e177 - vec2<f32>(0f, -0.25f))), length((_e180 - vec2<f32>(0f, 0.1f)))) - 0.035f);
    }
    let _e185 = (*g);
    if (_e185 < 3.5f) {
        let _e187 = (*q_1);
        param = _e187;
        param_1 = vec2<f32>(-0.17f, 0f);
        param_2 = vec2<f32>(0.17f, 0f);
        let _e188 = segment((&param), (&param_1), (&param_2));
        return (_e188 - 0.05f);
    }
    let _e190 = (*g);
    if (_e190 < 4.5f) {
        let _e192 = (*q_1);
        param_3 = _e192;
        param_4 = vec2<f32>(-0.18f, 0.1f);
        param_5 = vec2<f32>(0.18f, 0.1f);
        let _e193 = segment((&param_3), (&param_4), (&param_5));
        let _e194 = (*q_1);
        param_6 = _e194;
        param_7 = vec2<f32>(-0.18f, -0.1f);
        param_8 = vec2<f32>(0.18f, -0.1f);
        let _e195 = segment((&param_6), (&param_7), (&param_8));
        return (min(_e193, _e195) - 0.05f);
    }
    let _e198 = (*g);
    if (_e198 < 5.5f) {
        let _e200 = (*q_1);
        param_9 = _e200;
        param_10 = vec2<f32>(-0.19f, 0f);
        param_11 = vec2<f32>(0.19f, 0f);
        let _e201 = segment((&param_9), (&param_10), (&param_11));
        let _e202 = (*q_1);
        param_12 = _e202;
        param_13 = vec2<f32>(0f, -0.19f);
        param_14 = vec2<f32>(0f, 0.19f);
        let _e203 = segment((&param_12), (&param_13), (&param_14));
        return (min(_e201, _e203) - 0.05f);
    }
    let _e206 = (*g);
    if (_e206 < 6.5f) {
        let _e208 = (*q_1);
        param_15 = _e208;
        param_16 = vec2<f32>(0f, -0.2f);
        param_17 = vec2<f32>(0f, 0.2f);
        let _e209 = segment((&param_15), (&param_16), (&param_17));
        d = _e209;
        let _e210 = d;
        let _e211 = (*q_1);
        param_18 = _e211;
        param_19 = vec2<f32>(-0.18f, -0.11f);
        param_20 = vec2<f32>(0.18f, 0.11f);
        let _e212 = segment((&param_18), (&param_19), (&param_20));
        d = min(_e210, _e212);
        let _e214 = d;
        let _e215 = (*q_1);
        param_21 = _e215;
        param_22 = vec2<f32>(-0.18f, 0.11f);
        param_23 = vec2<f32>(0.18f, -0.11f);
        let _e216 = segment((&param_21), (&param_22), (&param_23));
        d = min(_e214, _e216);
        let _e218 = d;
        return (_e218 - 0.05f);
    }
    let _e220 = (*g);
    if (_e220 < 7.5f) {
        let _e222 = (*q_1);
        param_24 = _e222;
        param_25 = vec2<f32>(-0.06f, -0.3f);
        param_26 = vec2<f32>(-0.1f, 0.3f);
        let _e223 = segment((&param_24), (&param_25), (&param_26));
        let _e224 = (*q_1);
        param_27 = _e224;
        param_28 = vec2<f32>(0.12f, -0.3f);
        param_29 = vec2<f32>(0.08f, 0.3f);
        let _e225 = segment((&param_27), (&param_28), (&param_29));
        d_1 = min(_e223, _e225);
        let _e227 = d_1;
        let _e228 = (*q_1);
        param_30 = _e228;
        param_31 = vec2<f32>(-0.24f, 0.11f);
        param_32 = vec2<f32>(0.24f, 0.11f);
        let _e229 = segment((&param_30), (&param_31), (&param_32));
        let _e230 = (*q_1);
        param_33 = _e230;
        param_34 = vec2<f32>(-0.24f, -0.11f);
        param_35 = vec2<f32>(0.24f, -0.11f);
        let _e231 = segment((&param_33), (&param_34), (&param_35));
        d_1 = min(_e227, min(_e229, _e231));
        let _e234 = d_1;
        return (_e234 - 0.05f);
    }
    let _e236 = (*g);
    if (_e236 < 8.5f) {
        let _e238 = (*q_1);
        param_36 = _e238;
        param_37 = vec2<f32>(-0.2f, -0.3f);
        param_38 = vec2<f32>(0.2f, 0.3f);
        let _e239 = segment((&param_36), (&param_37), (&param_38));
        d_2 = _e239;
        let _e240 = d_2;
        let _e241 = (*q_1);
        d_2 = min(_e240, abs((length((_e241 - vec2<f32>(-0.13f, 0.19f))) - 0.08f)));
        let _e247 = d_2;
        let _e248 = (*q_1);
        d_2 = min(_e247, abs((length((_e248 - vec2<f32>(0.13f, -0.19f))) - 0.08f)));
        let _e254 = d_2;
        return (_e254 - 0.05f);
    }
    let _e256 = (*q_1);
    d_3 = abs((length(_e256) - 0.25f));
    let _e260 = d_3;
    let _e261 = (*q_1);
    d_3 = min(_e260, abs((length((_e261 - vec2<f32>(-0.02f, 0f))) - 0.1f)));
    let _e267 = d_3;
    let _e268 = (*q_1);
    param_39 = _e268;
    param_40 = vec2<f32>(0.08f, 0.1f);
    param_41 = vec2<f32>(0.08f, -0.12f);
    let _e269 = segment((&param_39), (&param_40), (&param_41));
    d_3 = min(_e267, _e269);
    let _e271 = d_3;
    return (_e271 - 0.04f);
}

fn density(c: ptr<function, vec4<f32>>) -> f32 {
    let _e120 = (*c);
    let _e124 = (*c)[3u];
    return floor((pow(clamp((dot(_e120.xyz, vec3<f32>(0.299f, 0.587f, 0.114f)) * _e124), 0f, 1f), 0.75f) * 9.99f));
}

fn cellColor(center: ptr<function, vec2<f32>>, dims: ptr<function, vec2<f32>>, incoming: ptr<function, bool>) -> vec4<f32> {
    var c_1: vec4<f32>;
    var i: i32;
    var o: vec2<f32>;
    var st: vec2<f32>;
    var local: vec4<f32>;
    var param_42: vec2<f32>;
    var param_43: vec2<f32>;

    c_1 = vec4<f32>(0f, 0f, 0f, 0f);
    i = 0i;
    loop {
        let _e129 = i;
        if (_e129 < 4i) {
            let _e131 = i;
            let _e132 = f32(_e131);
            let _e137 = i;
            let _e145 = (*dims);
            o = (((vec2<f32>((_e132 - (floor((_e132 / 2f)) * 2f)), floor((f32(_e137) / 2f))) - vec2(0.5f)) * 0.5f) * _e145);
            let _e147 = (*center);
            let _e148 = o;
            let _e151 = uniforms.ratio;
            st = clamp((((_e147 + _e148) / vec2<f32>(_e151, 1f)) + vec2(0.5f)), vec2(0f), vec2(1f));
            let _e159 = (*incoming);
            if _e159 {
                let _e160 = st;
                param_42 = _e160;
                let _e161 = getToColor((&param_42));
                local = _e161;
            } else {
                let _e162 = st;
                param_43 = _e162;
                let _e163 = getFromColor((&param_43));
                local = _e163;
            }
            let _e164 = local;
            let _e165 = c_1;
            c_1 = (_e165 + _e164);
            continue;
        } else {
            break;
        }
        continuing {
            let _e167 = i;
            i = (_e167 + 1i);
        }
    }
    let _e169 = c_1;
    return (_e169 * 0.25f);
}

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e121 = (*p);
    p3_ = fract((_e121.xyx * 0.1031f));
    let _e125 = p3_;
    let _e126 = p3_;
    let _e131 = p3_;
    p3_ = (_e131 + vec3(dot(_e125, (_e126.yzx + vec3(33.33f)))));
    let _e135 = p3_[0u];
    let _e137 = p3_[1u];
    let _e140 = p3_[2u];
    return fract(((_e135 + _e137) * _e140));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_1: f32;
    var h: f32;
    var fp: vec2<f32>;
    var dims_1: vec2<f32>;
    var cell: vec2<f32>;
    var center_1: vec2<f32>;
    var q_2: vec2<f32>;
    var r: f32;
    var param_44: vec2<f32>;
    var at: f32;
    var incoming_1: bool;
    var c_2: vec4<f32>;
    var param_45: vec2<f32>;
    var param_46: vec2<f32>;
    var param_47: bool;
    var g_1: f32;
    var param_48: vec4<f32>;
    var scramble: f32;
    var param_49: vec2<f32>;
    var param_50: vec2<f32>;
    var cover: f32;
    var param_51: f32;
    var param_52: vec2<f32>;
    var tint: vec3<f32>;
    var local_1: vec3<f32>;
    var alpha: f32;
    var local_2: f32;
    var behind: vec3<f32>;
    var local_3: vec3<f32>;
    var back: vec4<f32>;
    var text: vec4<f32>;
    var into: f32;
    var param_53: vec2<f32>;
    var outof: f32;
    var param_54: vec2<f32>;
    var show: f32;
    var image: vec4<f32>;
    var local_4: vec4<f32>;
    var param_55: vec2<f32>;
    var param_56: vec2<f32>;

    let _e161 = uniforms.progress;
    p_1 = _e161;
    let _e163 = uniforms.cellSize;
    h = _e163;
    let _e164 = (*uv_2);
    let _e168 = uniforms.ratio;
    fp = ((_e164 - vec2(0.5f)) * vec2<f32>(_e168, 1f));
    let _e171 = h;
    let _e173 = h;
    dims_1 = vec2<f32>((0.6f * _e171), _e173);
    let _e175 = fp;
    let _e176 = dims_1;
    cell = floor((_e175 / _e176));
    let _e179 = cell;
    let _e182 = dims_1;
    center_1 = ((_e179 + vec2(0.5f)) * _e182);
    let _e184 = fp;
    let _e185 = center_1;
    let _e187 = h;
    q_2 = ((_e184 - _e185) / vec2(_e187));
    let _e190 = cell;
    param_44 = (_e190 + vec2(100f));
    let _e193 = hash12((&param_44));
    r = _e193;
    let _e194 = r;
    at = (0.4f + (0.2f * _e194));
    let _e197 = p_1;
    let _e198 = at;
    incoming_1 = (_e197 > _e198);
    let _e200 = center_1;
    param_45 = _e200;
    let _e201 = dims_1;
    param_46 = _e201;
    let _e202 = incoming_1;
    param_47 = _e202;
    let _e203 = cellColor((&param_45), (&param_46), (&param_47));
    c_2 = _e203;
    let _e204 = c_2;
    param_48 = _e204;
    let _e205 = density((&param_48));
    g_1 = _e205;
    let _e206 = p_1;
    let _e207 = at;
    scramble = (1f - smoothstep(0.02f, 0.045f, abs((_e206 - _e207))));
    let _e212 = cell;
    let _e213 = p_1;
    param_49 = (_e212 + (vec2<f32>(17f, 31f) * floor((_e213 * 40f))));
    let _e218 = hash12((&param_49));
    let _e219 = scramble;
    if (_e218 < _e219) {
        let _e221 = cell;
        let _e223 = p_1;
        param_50 = ((_e221 * 1.7f) + (vec2<f32>(5f, 11f) * floor((_e223 * 40f))));
        let _e228 = hash12((&param_50));
        g_1 = (1f + floor((9f * _e228)));
    }
    let _e232 = g_1;
    param_51 = _e232;
    let _e233 = q_2;
    param_52 = _e233;
    let _e234 = glyph((&param_51), (&param_52));
    cover = (1f - smoothstep(-0.02f, 0.02f, _e234));
    let _e238 = uniforms.colored;
    if (_e238 != 0i) {
        let _e240 = c_2;
        let _e242 = c_2;
        let _e245 = c_2[0u];
        let _e247 = c_2[1u];
        let _e249 = c_2[2u];
        local_1 = mix(_e240.xyz, (_e242.xyz / vec3(max(max(_e245, max(_e247, _e249)), 0.05f))), vec3(0.7f));
    } else {
        let _e258 = uniforms.ink;
        local_1 = _e258.xyz;
    }
    let _e260 = local_1;
    tint = _e260;
    let _e262 = uniforms.colored;
    if (_e262 != 0i) {
        let _e265 = c_2[3u];
        local_2 = _e265;
    } else {
        let _e268 = uniforms.ink[3u];
        let _e270 = c_2[3u];
        local_2 = (_e268 * _e270);
    }
    let _e272 = local_2;
    alpha = _e272;
    let _e274 = uniforms.colored;
    if (_e274 != 0i) {
        let _e277 = uniforms.background;
        let _e279 = c_2;
        local_3 = mix(_e277.xyz, _e279.xyz, vec3(0.3f));
    } else {
        let _e284 = uniforms.background;
        local_3 = _e284.xyz;
    }
    let _e286 = local_3;
    behind = _e286;
    let _e287 = behind;
    let _e290 = uniforms.background[3u];
    let _e292 = c_2[3u];
    back = vec4<f32>(_e287.x, _e287.y, _e287.z, (_e290 * _e292));
    let _e298 = back;
    let _e299 = tint;
    let _e302 = clamp(_e299, vec3(0f), vec3(1f));
    let _e303 = alpha;
    let _e308 = cover;
    text = mix(_e298, vec4<f32>(_e302.x, _e302.y, _e302.z, _e303), vec4(_e308));
    let _e311 = cell;
    param_53 = (_e311 + vec2(200f));
    let _e314 = hash12((&param_53));
    into = (0.05f + (0.22f * _e314));
    let _e317 = cell;
    param_54 = (_e317 + vec2(300f));
    let _e320 = hash12((&param_54));
    outof = (0.95f - (0.22f * _e320));
    let _e323 = into;
    let _e324 = into;
    let _e326 = p_1;
    let _e328 = outof;
    let _e330 = outof;
    let _e331 = p_1;
    show = (smoothstep(_e323, (_e324 + 0.08f), _e326) * (1f - smoothstep((_e328 - 0.08f), _e330, _e331)));
    let _e335 = p_1;
    if (_e335 < 0.5f) {
        let _e337 = (*uv_2);
        param_55 = _e337;
        let _e338 = getFromColor((&param_55));
        local_4 = _e338;
    } else {
        let _e339 = (*uv_2);
        param_56 = _e339;
        let _e340 = getToColor((&param_56));
        local_4 = _e340;
    }
    let _e341 = local_4;
    image = _e341;
    let _e342 = image;
    let _e343 = text;
    let _e344 = show;
    return mix(_e342, _e343, vec4(_e344));
}

fn main_1() {
    var param_57: vec2<f32>;

    let _e120 = _uv_1;
    param_57 = _e120;
    let _e121 = transition((&param_57));
    _fragColor = _e121;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
