// WhipTilt — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WhipTilt.glsl
// Author: gre
// License: MIT
// Description: The camera tilts fast from the outgoing image to the incoming one, set edge to edge at an angle above it, streaking both in perspective with a vertical motion blur
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    down: i32,
    blur: f32,
    chroma: f32,
    perspective: f32,
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
    let _e39 = (*uv)[0u];
    let _e41 = (*uv)[1u];
    let _e44 = textureSampleLevel(_from, _sampler, vec2<f32>(_e39, (1f - _e41)), 0f);
    return _e44;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e39 = (*uv_1)[0u];
    let _e41 = (*uv_1)[1u];
    let _e44 = textureSampleLevel(_to, _sampler, vec2<f32>(_e39, (1f - _e41)), 0f);
    return _e44;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    var m: vec2<f32>;

    let _e39 = (*v);
    let _e40 = vec2(2f);
    m = (_e39 - (floor((_e39 / _e40)) * _e40));
    let _e45 = m;
    let _e46 = m;
    let _e49 = m;
    return mix(_e45, (vec2(2f) - _e46), step(vec2(1f), _e49));
}

fn tilt(t: ptr<function, f32>) -> f32 {
    var h: f32;
    var e: f32;
    var local: f32;

    let _e41 = (*t);
    h = (1f - abs(((2f * _e41) - 1f)));
    let _e46 = h;
    let _e48 = h;
    let _e50 = h;
    let _e52 = h;
    e = ((((0.5f * _e46) * _e48) * _e50) * _e52);
    let _e54 = (*t);
    if (_e54 < 0.5f) {
        let _e56 = e;
        local = _e56;
    } else {
        let _e57 = e;
        local = (1f - _e57);
    }
    let _e59 = local;
    return _e59;
}

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e39 = (*p);
    p3_ = fract((_e39.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e43 = p3_;
    let _e44 = p3_;
    let _e49 = p3_;
    p3_ = (_e49 + vec3(dot(_e43, (_e44.yzx + vec3(33.33f)))));
    let _e53 = p3_[0u];
    let _e55 = p3_[1u];
    let _e58 = p3_[2u];
    return fract(((_e53 + _e55) * _e58));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_1: f32;
    var h_1: f32;
    var shutter: f32;
    var halfFov: f32;
    var dist: f32;
    var q: vec2<f32>;
    var jitter: f32;
    var param: vec2<f32>;
    var color: vec3<f32>;
    var weight: vec3<f32>;
    var alpha: f32;
    var i: i32;
    var s: f32;
    var t_1: f32;
    var a: f32;
    var param_1: f32;
    var r: vec2<f32>;
    var c0_: f32;
    var s0_: f32;
    var d0_: vec2<f32>;
    var b: f32;
    var c1_: f32;
    var s1_: f32;
    var d1_: vec2<f32>;
    var incoming: bool;
    var d: vec2<f32>;
    var hit: vec2<f32>;
    var suv: vec2<f32>;
    var param_2: vec2<f32>;
    var col: vec4<f32>;
    var local_1: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var w: vec3<f32>;

    let _e73 = uniforms.progress;
    p_1 = _e73;
    let _e74 = p_1;
    h_1 = (1f - abs(((2f * _e74) - 1f)));
    let _e80 = uniforms.blur;
    let _e82 = h_1;
    let _e84 = h_1;
    shutter = (((_e80 * 0.25f) * _e82) * _e84);
    let _e87 = uniforms.perspective;
    halfFov = ((mix(15f, 45f, _e87) * 3.1415927f) / 180f);
    let _e91 = halfFov;
    dist = (0.5f / tan(_e91));
    let _e94 = (*uv_2);
    let _e98 = uniforms.ratio;
    q = ((_e94 - vec2(0.5f)) * vec2<f32>(_e98, 1f));
    let _e102 = uniforms.down;
    if (_e102 != 0i) {
        let _e105 = q[1u];
        q[1u] = -(_e105);
    }
    let _e108 = (*uv_2);
    let _e110 = uniforms.ratio;
    param = ((_e108 * vec2<f32>(_e110, 1f)) * 731f);
    let _e114 = hash((&param));
    jitter = _e114;
    color = vec3<f32>(0f, 0f, 0f);
    weight = vec3<f32>(0f, 0f, 0f);
    alpha = 0f;
    i = 0i;
    loop {
        let _e115 = i;
        if (_e115 < 24i) {
            let _e117 = i;
            let _e119 = jitter;
            s = (((f32(_e117) + _e119) / 24f) - 0.5f);
            let _e123 = p_1;
            let _e124 = s;
            let _e125 = shutter;
            t_1 = clamp((_e123 + (_e124 * _e125)), 0f, 1f);
            let _e129 = halfFov;
            let _e131 = t_1;
            param_1 = _e131;
            let _e132 = tilt((&param_1));
            a = ((2f * _e129) * _e132);
            let _e134 = q;
            let _e135 = halfFov;
            let _e138 = halfFov;
            let _e139 = a;
            r = ((_e134 * cos(_e135)) / vec2(cos((_e138 - _e139))));
            let _e144 = a;
            c0_ = cos(_e144);
            let _e146 = a;
            s0_ = sin(_e146);
            let _e149 = r[1u];
            let _e150 = c0_;
            let _e152 = dist;
            let _e153 = s0_;
            let _e156 = dist;
            let _e157 = c0_;
            let _e160 = r[1u];
            let _e161 = s0_;
            d0_ = vec2<f32>(((_e149 * _e150) + (_e152 * _e153)), ((_e156 * _e157) - (_e160 * _e161)));
            let _e165 = a;
            let _e166 = halfFov;
            b = (_e165 - (2f * _e166));
            let _e169 = b;
            c1_ = cos(_e169);
            let _e171 = b;
            s1_ = sin(_e171);
            let _e174 = r[1u];
            let _e175 = c1_;
            let _e177 = dist;
            let _e178 = s1_;
            let _e181 = dist;
            let _e182 = c1_;
            let _e185 = r[1u];
            let _e186 = s1_;
            d1_ = vec2<f32>(((_e174 * _e175) + (_e177 * _e178)), ((_e181 * _e182) - (_e185 * _e186)));
            let _e191 = d1_[1u];
            let _e193 = d0_[1u];
            incoming = (_e191 > _e193);
            let _e195 = incoming;
            let _e196 = d1_;
            let _e197 = d0_;
            d = select(_e197, _e196, vec2(_e195));
            let _e200 = dist;
            let _e202 = d[1u];
            let _e205 = r[0u];
            let _e207 = d[0u];
            hit = (vec2<f32>(_e205, _e207) * (_e200 / _e202));
            let _e211 = uniforms.down;
            if (_e211 != 0i) {
                let _e214 = hit[1u];
                hit[1u] = -(_e214);
            }
            let _e217 = hit;
            let _e219 = uniforms.ratio;
            param_2 = ((_e217 / vec2<f32>(_e219, 1f)) + vec2(0.5f));
            let _e224 = mirror((&param_2));
            suv = _e224;
            let _e225 = incoming;
            if _e225 {
                let _e226 = suv;
                param_3 = _e226;
                let _e227 = getToColor((&param_3));
                local_1 = _e227;
            } else {
                let _e228 = suv;
                param_4 = _e228;
                let _e229 = getFromColor((&param_4));
                local_1 = _e229;
            }
            let _e230 = local_1;
            col = _e230;
            let _e232 = uniforms.chroma;
            let _e234 = s;
            let _e238 = uniforms.chroma;
            let _e240 = s;
            w = max(vec3<f32>((1f - ((4f * _e232) * _e234)), 1f, (1f + ((4f * _e238) * _e240))), vec3(0f));
            let _e246 = col;
            let _e249 = col[3u];
            let _e251 = w;
            let _e253 = color;
            color = (_e253 + ((_e246.xyz * _e249) * _e251));
            let _e256 = col[3u];
            let _e257 = w;
            let _e259 = weight;
            weight = (_e259 + (_e257 * _e256));
            let _e262 = col[3u];
            let _e263 = alpha;
            alpha = (_e263 + _e262);
            continue;
        } else {
            break;
        }
        continuing {
            let _e265 = i;
            i = (_e265 + 1i);
        }
    }
    let _e267 = color;
    let _e268 = weight;
    let _e270 = (_e267 / max(_e268, vec3<f32>(0.00001f, 0.00001f, 0.00001f)));
    let _e271 = alpha;
    return vec4<f32>(_e270.x, _e270.y, _e270.z, (_e271 / 24f));
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e38 = _uv_1;
    param_5 = _e38;
    let _e39 = transition((&param_5));
    _fragColor = _e39;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
