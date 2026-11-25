// ProjectorThrow — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ProjectorThrow.glsl
// Author: gre
// License: MIT
// Description: The lights go down on the outgoing image and a projector throws the incoming one onto it: a small, blurred, keystoned picture of light lands on the scene, tinted by the colors it falls on, then grows, comes into focus and squares up until it fills the frame as the scene beneath it fades away
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    darkness: f32,
    keystone: f32,
    blur: f32,
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
    let _e46 = (*uv)[0u];
    let _e48 = (*uv)[1u];
    let _e51 = textureSampleLevel(_to, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e45 = (*v);
    let _e46 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e45 - (floor((_e45 / _e46)) * _e46)))));
}

fn projected(q: ptr<function, vec2<f32>>, r: ptr<function, vec2<f32>>) -> vec4<f32> {
    var c: vec4<f32>;
    var i: i32;
    var a: f32;
    var o: vec2<f32>;
    var t: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var local: vec4<f32>;

    c = vec4<f32>(0f, 0f, 0f, 0f);
    i = 0i;
    loop {
        let _e54 = i;
        if (_e54 < 8i) {
            let _e56 = i;
            a = (f32(_e56) * 2.39996f);
            let _e59 = i;
            let _e64 = a;
            let _e66 = a;
            o = (vec2<f32>(cos(_e64), sin(_e66)) * sqrt(((f32(_e59) + 0.5f) / 8f)));
            let _e70 = (*q);
            let _e71 = o;
            let _e72 = (*r);
            param = (_e70 + (_e71 * _e72));
            let _e75 = mirror((&param));
            param_1 = _e75;
            let _e76 = getToColor((&param_1));
            t = _e76;
            let _e77 = t;
            let _e80 = t[3u];
            let _e81 = (_e77.xyz * _e80);
            let _e83 = t[3u];
            let _e88 = c;
            c = (_e88 + vec4<f32>(_e81.x, _e81.y, _e81.z, _e83));
            continue;
        } else {
            break;
        }
        continuing {
            let _e90 = i;
            i = (_e90 + 1i);
        }
    }
    let _e93 = c[3u];
    if (_e93 > 0f) {
        let _e95 = c;
        let _e98 = c[3u];
        let _e100 = (_e95.xyz / vec3(_e98));
        let _e102 = c[3u];
        local = vec4<f32>(_e100.x, _e100.y, _e100.z, (_e102 / 8f));
    } else {
        local = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e108 = local;
    return _e108;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv_1)[0u];
    let _e48 = (*uv_1)[1u];
    let _e51 = textureSampleLevel(_from, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var from_: vec4<f32>;
    var param_4: vec2<f32>;
    var on: f32;
    var ambient: f32;
    var g: f32;
    var focus: f32;
    var size: f32;
    var k: f32;
    var cy: f32;
    var y: f32;
    var wy: f32;
    var q_1: vec2<f32>;
    var e: f32;
    var soft: f32;
    var cov: f32;
    var halo: f32;
    var d: vec2<f32>;
    var gain: f32;
    var r_1: vec2<f32>;
    var pic: vec4<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var light: vec3<f32>;
    var screen: f32;
    var surface: vec3<f32>;
    var col: vec3<f32>;

    let _e75 = uniforms.progress;
    p = _e75;
    let _e76 = p;
    if (_e76 <= 0f) {
        let _e78 = (*uv_2);
        param_2 = _e78;
        let _e79 = getFromColor((&param_2));
        return _e79;
    }
    let _e80 = p;
    if (_e80 >= 1f) {
        let _e82 = (*uv_2);
        param_3 = _e82;
        let _e83 = getToColor((&param_3));
        return _e83;
    }
    let _e84 = (*uv_2);
    param_4 = _e84;
    let _e85 = getFromColor((&param_4));
    from_ = _e85;
    let _e86 = p;
    on = smoothstep(0.06f, 0.26f, _e86);
    let _e89 = uniforms.darkness;
    let _e90 = p;
    ambient = (1f - (_e89 * smoothstep(0f, 0.2f, _e90)));
    let _e94 = p;
    g = smoothstep(0.02f, 1f, _e94);
    let _e96 = p;
    focus = (1f - smoothstep(0.15f, 0.85f, _e96));
    let _e99 = g;
    let _e100 = g;
    size = mix(0.32f, 1f, (_e99 * (0.6f + (0.4f * _e100))));
    let _e106 = uniforms.keystone;
    let _e107 = g;
    k = (_e106 * (1f - _e107));
    let _e110 = g;
    cy = mix(0.58f, 0.5f, _e110);
    let _e113 = (*uv_2)[1u];
    let _e114 = cy;
    let _e116 = size;
    y = (((_e113 - _e114) / _e116) + 0.5f);
    let _e119 = k;
    let _e122 = k;
    let _e123 = y;
    wy = max(((1f - (0.5f * _e119)) + (_e122 * _e123)), 0.05f);
    let _e128 = (*uv_2)[0u];
    let _e130 = size;
    let _e131 = wy;
    let _e135 = y;
    let _e136 = k;
    let _e140 = wy;
    q_1 = vec2<f32>((((_e128 - 0.5f) / (_e130 * _e131)) + 0.5f), ((_e135 * (1f + (0.5f * _e136))) / _e140));
    let _e143 = size;
    let _e145 = wy;
    let _e148 = (*uv_2)[0u];
    let _e153 = uniforms.ratio;
    let _e155 = size;
    let _e156 = y;
    let _e157 = y;
    e = min(((((0.5f * _e143) * _e145) - abs((_e148 - 0.5f))) * _e153), (_e155 * min(_e156, (1f - _e157))));
    let _e162 = focus;
    soft = (0.0015f + (0.035f * _e162));
    let _e165 = soft;
    let _e167 = soft;
    let _e168 = e;
    let _e170 = p;
    cov = mix(smoothstep(-(_e165), _e167, _e168), 1f, smoothstep(0.9f, 1f, _e170));
    let _e173 = focus;
    let _e175 = on;
    let _e177 = e;
    let _e183 = cov;
    halo = ((((0.15f * _e173) * _e175) * exp((-24f * max(-(_e177), 0f)))) * (1f - _e183));
    let _e186 = q_1;
    d = (_e186 - vec2(0.5f));
    let _e189 = on;
    let _e190 = g;
    let _e193 = focus;
    let _e194 = d;
    let _e195 = d;
    gain = ((_e189 * mix(1.25f, 1f, _e190)) * (1f + (_e193 * (0.15f - (1.2f * dot(_e194, _e195))))));
    let _e203 = uniforms.blur;
    let _e204 = focus;
    let _e206 = size;
    let _e207 = wy;
    let _e211 = uniforms.ratio;
    let _e213 = k;
    let _e215 = k;
    let _e218 = wy;
    r_1 = (vec2<f32>((1f / _e211), ((1f - ((0.25f * _e213) * _e215)) / _e218)) * ((_e203 * _e204) / (_e206 * _e207)));
    let _e222 = q_1;
    param_5 = _e222;
    let _e223 = r_1;
    param_6 = _e223;
    let _e224 = projected((&param_5), (&param_6));
    pic = _e224;
    let _e225 = pic;
    let _e227 = gain;
    let _e229 = cov;
    let _e231 = halo;
    light = (((_e225.xyz * _e227) * _e229) + vec3(_e231));
    let _e234 = p;
    screen = smoothstep(0.35f, 0.95f, _e234);
    let _e236 = from_;
    let _e238 = screen;
    surface = mix(_e236.xyz, vec3<f32>(1f, 1f, 1f), vec3((0.35f + (0.65f * _e238))));
    let _e243 = from_;
    let _e245 = ambient;
    let _e247 = cov;
    let _e248 = screen;
    let _e252 = surface;
    let _e253 = light;
    col = (((_e243.xyz * _e245) * (1f - (_e247 * _e248))) + (_e252 * _e253));
    let _e256 = col;
    let _e258 = from_[3u];
    let _e260 = pic[3u];
    let _e261 = cov;
    let _e263 = on;
    let _e267 = pic[3u];
    let _e268 = cov;
    let _e269 = screen;
    return vec4<f32>(_e256.x, _e256.y, _e256.z, mix(max(_e258, ((_e260 * _e261) * _e263)), _e267, (_e268 * _e269)));
}

fn main_1() {
    var param_7: vec2<f32>;

    let _e45 = _uv_1;
    param_7 = _e45;
    let _e46 = transition((&param_7));
    _fragColor = _e46;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
