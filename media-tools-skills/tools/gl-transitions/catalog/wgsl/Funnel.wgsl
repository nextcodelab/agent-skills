// Funnel — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Funnel.glsl
// Author: gre
// License: MIT
// Description: The outgoing image narrows into a curved funnel toward a point on the bottom edge and slides into it, its sides bending like a window minimized into a dock, revealing the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    target_: f32,
    curvature: f32,
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
    let _e35 = (*uv)[0u];
    let _e37 = (*uv)[1u];
    let _e40 = textureSampleLevel(_to, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv_1)[0u];
    let _e37 = (*uv_1)[1u];
    let _e40 = textureSampleLevel(_from, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var t: f32;
    var f: f32;
    var slide: f32;
    var r: f32;
    var nh: f32;
    var tx: f32;
    var c: f32;
    var q: f32;
    var w: f32;
    var dw: f32;
    var L: f32;
    var R: f32;
    var dL: f32;
    var dR: f32;
    var v: f32;
    var e: f32;
    var left: f32;
    var local: f32;
    var right: f32;
    var local_1: f32;
    var cov: f32;
    var img: vec4<f32>;
    var s: f32;
    var width: f32;
    var src: vec2<f32>;
    var param: vec2<f32>;
    var across: f32;
    var bg: vec4<f32>;
    var param_1: vec2<f32>;
    var ox: f32;
    var oy: f32;
    var dist: f32;

    let _e67 = uniforms.progress;
    t = _e67;
    let _e68 = t;
    let _e70 = t;
    let _e73 = t;
    f = smoothstep(0f, 1f, (1f - (((1f - _e68) * (1f - _e70)) * (1f - _e73))));
    let _e78 = t;
    let _e80 = t;
    let _e82 = t;
    slide = (((1.03f * _e78) * _e80) * (1.5f - (0.5f * _e82)));
    let _e87 = uniforms.ratio;
    r = max(_e87, 0.0001f);
    let _e89 = r;
    nh = (0.02f / _e89);
    let _e92 = uniforms.target_;
    let _e93 = nh;
    let _e94 = nh;
    tx = clamp(_e92, _e93, (1f - _e94));
    let _e98 = uniforms.curvature;
    c = clamp(_e98, 0f, 1f);
    let _e101 = (*uv_2)[1u];
    q = clamp(_e101, 0f, 1f);
    let _e103 = q;
    let _e104 = q;
    let _e105 = q;
    let _e107 = q;
    let _e111 = c;
    w = mix(_e103, ((_e104 * _e105) * (3f - (2f * _e107))), _e111);
    let _e113 = q;
    let _e115 = q;
    let _e118 = c;
    dw = mix(1f, ((6f * _e113) * (1f - _e115)), _e118);
    let _e120 = f;
    let _e121 = tx;
    let _e122 = nh;
    let _e124 = w;
    L = (_e120 * mix((_e121 - _e122), 0f, _e124));
    let _e127 = f;
    let _e128 = tx;
    let _e129 = nh;
    let _e131 = w;
    R = (1f - (_e127 * (1f - mix((_e128 + _e129), 1f, _e131))));
    let _e136 = f;
    let _e138 = tx;
    let _e139 = nh;
    let _e142 = dw;
    dL = ((-(_e136) * (_e138 - _e139)) * _e142);
    let _e144 = f;
    let _e145 = tx;
    let _e147 = nh;
    let _e150 = dw;
    dR = ((_e144 * ((1f - _e145) - _e147)) * _e150);
    let _e153 = (*uv_2)[1u];
    let _e154 = slide;
    v = (_e153 + _e154);
    let _e156 = t;
    e = ((0.0015f * min(1f, (10f * _e156))) + 0.000001f);
    let _e161 = L;
    if (_e161 > 0f) {
        let _e164 = (*uv_2)[0u];
        let _e165 = L;
        let _e167 = r;
        let _e169 = dL;
        let _e170 = dL;
        let _e172 = r;
        let _e174 = r;
        local = (((_e164 - _e165) * _e167) / sqrt((1f + (((_e169 * _e170) * _e172) * _e174))));
    } else {
        local = 1f;
    }
    let _e179 = local;
    left = _e179;
    let _e180 = R;
    if (_e180 < 1f) {
        let _e182 = R;
        let _e184 = (*uv_2)[0u];
        let _e186 = r;
        let _e188 = dR;
        let _e189 = dR;
        let _e191 = r;
        let _e193 = r;
        local_1 = (((_e182 - _e184) * _e186) / sqrt((1f + (((_e188 * _e189) * _e191) * _e193))));
    } else {
        local_1 = 1f;
    }
    let _e198 = local_1;
    right = _e198;
    let _e199 = left;
    let _e200 = right;
    let _e202 = v;
    let _e205 = e;
    cov = clamp(((min(min(_e199, _e200), (1f - _e202)) / _e205) + 0.5f), 0f, 1f);
    img = vec4<f32>(0f, 0f, 0f, 0f);
    let _e210 = uniforms.shadow;
    s = clamp(_e210, 0f, 1f);
    let _e212 = cov;
    if (_e212 > 0f) {
        let _e214 = R;
        let _e215 = L;
        width = (_e214 - _e215);
        let _e218 = (*uv_2)[0u];
        let _e219 = L;
        let _e221 = width;
        let _e223 = v;
        src = clamp(vec2<f32>(((_e218 - _e219) / _e221), _e223), vec2(0f), vec2(1f));
        let _e228 = src;
        param = _e228;
        let _e229 = getFromColor((&param));
        img = _e229;
        let _e231 = src[0u];
        across = ((2f * _e231) - 1f);
        let _e234 = s;
        let _e235 = width;
        let _e238 = across;
        let _e240 = across;
        let _e242 = w;
        let _e248 = img;
        let _e250 = (_e248.xyz * (1f - ((_e234 * (1f - _e235)) * (((0.5f * _e238) * _e240) + (0.3f * (1f - _e242))))));
        img[0u] = _e250.x;
        img[1u] = _e250.y;
        img[2u] = _e250.z;
        let _e257 = cov;
        if (_e257 >= 1f) {
            let _e259 = img;
            return _e259;
        }
    }
    let _e260 = (*uv_2);
    param_1 = _e260;
    let _e261 = getToColor((&param_1));
    bg = _e261;
    let _e262 = L;
    let _e264 = (*uv_2)[0u];
    let _e267 = (*uv_2)[0u];
    let _e268 = R;
    let _e271 = r;
    ox = (max((_e262 - _e264), (_e267 - _e268)) * _e271);
    let _e274 = (*uv_2)[1u];
    let _e275 = slide;
    oy = (_e274 - (1f - _e275));
    let _e278 = ox;
    let _e279 = oy;
    dist = length(max(vec2<f32>(_e278, _e279), vec2(0f)));
    let _e284 = s;
    let _e286 = f;
    let _e288 = t;
    let _e291 = dist;
    let _e296 = bg;
    let _e298 = (_e296.xyz * (1f - ((((_e284 * 0.6f) * _e286) * (1f - _e288)) * (1f - smoothstep(0f, 0.06f, _e291)))));
    bg[0u] = _e298.x;
    bg[1u] = _e298.y;
    bg[2u] = _e298.z;
    let _e305 = bg;
    let _e306 = img;
    let _e307 = cov;
    return mix(_e305, _e306, vec4(_e307));
}

fn main_1() {
    var param_2: vec2<f32>;

    let _e34 = _uv_1;
    param_2 = _e34;
    let _e35 = transition((&param_2));
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
