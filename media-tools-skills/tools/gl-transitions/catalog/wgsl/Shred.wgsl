// Shred — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Shred.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is cut into paper strips that drop away at uneven speeds, tilting as they fall, revealing the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strips: i32,
    stagger: f32,
    tilt: f32,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv)[0u];
    let _e37 = (*uv)[1u];
    let _e40 = textureSampleLevel(_from, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn hash(n: ptr<function, f32>) -> f32 {
    let _e34 = (*n);
    (*n) = fract((_e34 * 0.1031f));
    let _e37 = (*n);
    let _e39 = (*n);
    (*n) = (_e39 * (_e37 + 33.33f));
    let _e41 = (*n);
    let _e42 = (*n);
    let _e44 = (*n);
    (*n) = (_e44 * (_e41 + _e42));
    let _e46 = (*n);
    return fract(_e46);
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e35 = (*uv_1)[0u];
    let _e37 = (*uv_1)[1u];
    let _e40 = textureSampleLevel(_to, _sampler, vec2<f32>(_e35, (1f - _e37)), 0f);
    return _e40;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n_1: f32;
    var w: f32;
    var q: vec2<f32>;
    var color: vec4<f32>;
    var param: vec2<f32>;
    var cover: f32;
    var shade: f32;
    var maxTilt: f32;
    var d: i32;
    var i: f32;
    var delay: f32;
    var param_1: f32;
    var speed: f32;
    var param_2: f32;
    var t: f32;
    var fall: f32;
    var angle: f32;
    var param_3: f32;
    var lift: f32;
    var gap: f32;
    var v: vec2<f32>;
    var ca: f32;
    var sa: f32;
    var l: vec2<f32>;
    var edge: vec2<f32>;
    var so: vec2<f32>;
    var p: vec2<f32>;
    var img: vec4<f32>;
    var param_4: vec2<f32>;
    var cut: f32;
    var phi_152_: bool;

    let _e65 = uniforms.strips;
    n_1 = f32(_e65);
    let _e68 = uniforms.ratio;
    let _e69 = n_1;
    w = (_e68 / _e69);
    let _e72 = (*uv_2)[0u];
    let _e74 = uniforms.ratio;
    let _e77 = (*uv_2)[1u];
    q = vec2<f32>((_e72 * _e74), _e77);
    let _e79 = (*uv_2);
    param = _e79;
    let _e80 = getToColor((&param));
    color = _e80;
    cover = -1f;
    shade = 0f;
    let _e82 = uniforms.tilt;
    let _e83 = w;
    maxTilt = min(_e82, (2f * _e83));
    d = -3i;
    loop {
        let _e86 = d;
        if (_e86 <= 3i) {
            let _e89 = (*uv_2)[0u];
            let _e90 = n_1;
            let _e93 = d;
            i = (floor((_e89 * _e90)) + f32(_e93));
            let _e96 = i;
            let _e97 = (_e96 < 0f);
            phi_152_ = _e97;
            if !(_e97) {
                let _e99 = i;
                let _e100 = n_1;
                phi_152_ = (_e99 > (_e100 - 1f));
            }
            let _e104 = phi_152_;
            if _e104 {
                continue;
            }
            let _e106 = uniforms.stagger;
            let _e107 = i;
            param_1 = (_e107 + 1f);
            let _e109 = hash((&param_1));
            delay = (_e106 * max(0f, ((1.25f * _e109) - 0.25f)));
            let _e114 = i;
            param_2 = (_e114 + 71f);
            let _e116 = hash((&param_2));
            speed = (1f + (0.5f * _e116));
            let _e120 = uniforms.progress;
            let _e121 = delay;
            let _e123 = delay;
            t = clamp(((_e120 - _e121) / (1f - _e123)), 0f, 1f);
            let _e127 = t;
            let _e129 = t;
            let _e131 = t;
            let _e134 = w;
            let _e136 = uniforms.tilt;
            let _e141 = speed;
            fall = ((((0.4f * _e127) + ((0.6f * _e129) * _e131)) * (1f + (_e134 * (0.5f + _e136)))) * _e141);
            let _e143 = maxTilt;
            let _e144 = i;
            param_3 = (_e144 + 37f);
            let _e146 = hash((&param_3));
            let _e150 = t;
            angle = ((_e143 * ((2f * _e146) - 1f)) * _e150);
            let _e152 = t;
            lift = min(1f, (8f * _e152));
            let _e155 = w;
            let _e157 = lift;
            gap = ((0.06f * _e155) * _e157);
            let _e159 = q;
            let _e160 = i;
            let _e162 = w;
            let _e164 = fall;
            v = (_e159 - vec2<f32>(((_e160 + 0.5f) * _e162), (0.5f - _e164)));
            let _e168 = angle;
            ca = cos(_e168);
            let _e170 = angle;
            sa = sin(_e170);
            let _e172 = ca;
            let _e174 = v[0u];
            let _e176 = sa;
            let _e178 = v[1u];
            let _e181 = ca;
            let _e183 = v[1u];
            let _e185 = sa;
            let _e187 = v[0u];
            l = vec2<f32>(((_e172 * _e174) + (_e176 * _e178)), ((_e181 * _e183) - (_e185 * _e187)));
            let _e191 = w;
            let _e193 = gap;
            let _e196 = l;
            edge = (vec2<f32>(((0.5f * _e191) - _e193), 0.5f) - abs(_e196));
            let _e199 = l;
            let _e200 = lift;
            let _e201 = w;
            let _e203 = w;
            let _e209 = w;
            let _e211 = gap;
            so = (abs((_e199 - (vec2<f32>((0.15f * _e201), (-0.25f * _e203)) * _e200))) - vec2<f32>(((0.5f * _e209) - _e211), 0.5f));
            let _e215 = shade;
            let _e216 = lift;
            let _e217 = w;
            let _e220 = so[0u];
            let _e222 = so[1u];
            shade = max(_e215, (_e216 * (1f - smoothstep(0f, (0.5f * _e217), max(_e220, _e222)))));
            let _e229 = edge[0u];
            let _e231 = edge[1u];
            let _e234 = fall;
            let _e235 = cover;
            if ((min(_e229, _e231) >= 0f) && (_e234 > _e235)) {
                let _e238 = i;
                let _e240 = w;
                let _e243 = l[0u];
                let _e246 = l[1u];
                p = vec2<f32>((((_e238 + 0.5f) * _e240) + _e243), (0.5f + _e246));
                let _e250 = p[0u];
                let _e252 = uniforms.ratio;
                let _e255 = p[1u];
                param_4 = vec2<f32>((_e250 / _e252), _e255);
                let _e257 = getFromColor((&param_4));
                img = _e257;
                let _e258 = lift;
                let _e259 = w;
                let _e262 = edge[0u];
                cut = (_e258 * (1f - smoothstep(0f, (0.25f * _e259), _e262)));
                let _e266 = img;
                let _e269 = uniforms.shadow;
                let _e271 = cut;
                let _e274 = (_e266.xyz * (1f - ((0.5f * _e269) * _e271)));
                let _e276 = img[3u];
                color = vec4<f32>(_e274.x, _e274.y, _e274.z, _e276);
                let _e281 = fall;
                cover = _e281;
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e282 = d;
            d = (_e282 + 1i);
        }
    }
    let _e284 = cover;
    if (_e284 < 0f) {
        let _e286 = color;
        let _e289 = uniforms.shadow;
        let _e291 = shade;
        let _e294 = (_e286.xyz * (1f - ((0.6f * _e289) * _e291)));
        let _e296 = color[3u];
        color = vec4<f32>(_e294.x, _e294.y, _e294.z, _e296);
    }
    let _e301 = color;
    return _e301;
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e34 = _uv_1;
    param_5 = _e34;
    let _e35 = transition((&param_5));
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
