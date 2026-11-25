// Prisms — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Prisms.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into 3D prisms that turn in a cascade, like a rotating billboard, from the outgoing image on one face to the incoming one on the next
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    slats: i32,
    stagger: f32,
    perspective: f32,
    shading: f32,
    horizontal: i32,
    backColor: vec4<f32>,
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
    var n: f32;
    var a: f32;
    var local: f32;
    var b: f32;
    var local_1: f32;
    var hw: f32;
    var local_2: f32;
    var k: f32;
    var bScale: f32;
    var local_3: f32;
    var near1_: vec4<f32>;
    var near2_: vec4<f32>;
    var cover1_: f32;
    var cover2_: f32;
    var z1_: f32;
    var z2_: f32;
    var d: i32;
    var i: f32;
    var order: f32;
    var local_4: f32;
    var t: f32;
    var c: f32;
    var s: f32;
    var edge: f32;
    var x: f32;
    var f: i32;
    var cf: f32;
    var u: f32;
    var local_5: f32;
    var z: f32;
    var local_6: f32;
    var scale: f32;
    var y: f32;
    var outer: f32;
    var local_7: f32;
    var cover: f32;
    var sa: f32;
    var p: vec2<f32>;
    var local_8: vec2<f32>;
    var img: vec4<f32>;
    var local_9: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var lambert: f32;
    var local_10: f32;
    var color: vec4<f32>;
    var phi_168_: bool;

    let _e81 = uniforms.slats;
    n = f32(_e81);
    let _e84 = uniforms.horizontal;
    if (_e84 != 0i) {
        let _e87 = (*uv_2)[1u];
        local = _e87;
    } else {
        let _e89 = (*uv_2)[0u];
        local = _e89;
    }
    let _e90 = local;
    a = _e90;
    let _e92 = uniforms.horizontal;
    if (_e92 != 0i) {
        let _e95 = (*uv_2)[0u];
        local_1 = _e95;
    } else {
        let _e97 = (*uv_2)[1u];
        local_1 = _e97;
    }
    let _e98 = local_1;
    b = _e98;
    let _e99 = n;
    let _e102 = uniforms.horizontal;
    if (_e102 != 0i) {
        local_2 = 1f;
    } else {
        let _e105 = uniforms.ratio;
        local_2 = _e105;
    }
    let _e106 = local_2;
    hw = ((0.5f / _e99) * _e106);
    let _e109 = uniforms.perspective;
    let _e110 = hw;
    k = min((_e109 * _e110), 0.5f);
    let _e114 = uniforms.horizontal;
    if (_e114 != 0i) {
        let _e117 = uniforms.ratio;
        local_3 = _e117;
    } else {
        local_3 = 1f;
    }
    let _e118 = local_3;
    bScale = _e118;
    near1_ = vec4<f32>(0f, 0f, 0f, 0f);
    near2_ = vec4<f32>(0f, 0f, 0f, 0f);
    cover1_ = 0f;
    cover2_ = 0f;
    z1_ = -2f;
    z2_ = -2f;
    d = -1i;
    loop {
        let _e119 = d;
        if (_e119 <= 1i) {
            let _e121 = a;
            let _e122 = n;
            let _e125 = d;
            i = (floor((_e121 * _e122)) + f32(_e125));
            let _e128 = i;
            let _e129 = (_e128 < 0f);
            phi_168_ = _e129;
            if !(_e129) {
                let _e131 = i;
                let _e132 = n;
                phi_168_ = (_e131 > (_e132 - 1f));
            }
            let _e136 = phi_168_;
            if _e136 {
                continue;
            }
            let _e138 = uniforms.horizontal;
            if (_e138 != 0i) {
                let _e140 = n;
                let _e142 = i;
                local_4 = ((_e140 - 1f) - _e142);
            } else {
                let _e144 = i;
                local_4 = _e144;
            }
            let _e145 = local_4;
            let _e146 = n;
            order = (_e145 / (_e146 - 1f));
            let _e150 = uniforms.progress;
            let _e152 = uniforms.stagger;
            let _e153 = order;
            let _e157 = uniforms.stagger;
            t = clamp(((_e150 - (_e152 * _e153)) / (1f - _e157)), 0f, 1f);
            let _e161 = t;
            let _e162 = t;
            let _e163 = t;
            let _e165 = t;
            t = mix(_e161, ((_e162 * _e163) * (3f - (2f * _e165))), 0.7f);
            let _e170 = t;
            c = cos((1.5707964f * _e170));
            let _e173 = t;
            s = sin((1.5707964f * _e173));
            let _e176 = s;
            let _e178 = c;
            edge = ((0.002f * min(1f, ((20f * _e176) * _e178))) + 0.000001f);
            let _e183 = a;
            let _e184 = n;
            let _e186 = i;
            x = ((2f * ((_e183 * _e184) - _e186)) - 1f);
            f = 0i;
            loop {
                let _e190 = f;
                if (_e190 < 2i) {
                    let _e192 = f;
                    let _e194 = c;
                    let _e195 = s;
                    cf = select(_e195, _e194, (_e192 == 0i));
                    let _e197 = cf;
                    if (_e197 < 0.0001f) {
                        continue;
                    }
                    let _e199 = f;
                    if (_e199 == 0i) {
                        let _e201 = x;
                        let _e202 = s;
                        let _e204 = c;
                        local_5 = ((_e201 + _e202) / _e204);
                    } else {
                        let _e206 = x;
                        let _e207 = c;
                        let _e209 = s;
                        local_5 = ((_e206 - _e207) / _e209);
                    }
                    let _e211 = local_5;
                    u = _e211;
                    let _e212 = f;
                    if (_e212 == 0i) {
                        let _e214 = u;
                        let _e215 = s;
                        let _e217 = c;
                        local_6 = ((_e214 * _e215) + _e217);
                    } else {
                        let _e219 = s;
                        let _e220 = u;
                        let _e221 = c;
                        local_6 = (_e219 - (_e220 * _e221));
                    }
                    let _e224 = local_6;
                    z = _e224;
                    let _e225 = u;
                    let _e228 = z;
                    let _e229 = z2_;
                    if ((abs(_e225) > 1f) || (_e228 <= _e229)) {
                        continue;
                    }
                    let _e232 = k;
                    let _e233 = z;
                    scale = (1f - (_e232 * (_e233 - 1f)));
                    let _e237 = b;
                    let _e239 = scale;
                    y = (((_e237 - 0.5f) * _e239) + 0.5f);
                    let _e242 = y;
                    let _e244 = y;
                    if ((_e242 < 0f) || (_e244 > 1f)) {
                        continue;
                    }
                    let _e247 = f;
                    if (_e247 == 0i) {
                        let _e249 = u;
                        local_7 = (1f + _e249);
                    } else {
                        let _e251 = u;
                        local_7 = (1f - _e251);
                    }
                    let _e253 = local_7;
                    outer = _e253;
                    let _e254 = outer;
                    let _e255 = hw;
                    let _e257 = cf;
                    let _e259 = edge;
                    let _e262 = y;
                    let _e263 = y;
                    let _e266 = bScale;
                    let _e268 = scale;
                    let _e270 = edge;
                    cover = (clamp((((_e254 * _e255) * _e257) / _e259), 0f, 1f) * clamp((((min(_e262, (1f - _e263)) * _e266) / _e268) / _e270), 0f, 1f));
                    let _e274 = i;
                    let _e276 = u;
                    let _e279 = n;
                    sa = (((_e274 + 0.5f) + (0.5f * _e276)) / _e279);
                    let _e282 = uniforms.horizontal;
                    if (_e282 != 0i) {
                        let _e284 = y;
                        let _e285 = sa;
                        local_8 = vec2<f32>(_e284, _e285);
                    } else {
                        let _e287 = sa;
                        let _e288 = y;
                        local_8 = vec2<f32>(_e287, _e288);
                    }
                    let _e290 = local_8;
                    p = _e290;
                    let _e291 = f;
                    if (_e291 == 0i) {
                        let _e293 = p;
                        param = _e293;
                        let _e294 = getFromColor((&param));
                        local_9 = _e294;
                    } else {
                        let _e295 = p;
                        param_1 = _e295;
                        let _e296 = getToColor((&param_1));
                        local_9 = _e296;
                    }
                    let _e297 = local_9;
                    img = _e297;
                    let _e298 = f;
                    if (_e298 == 0i) {
                        let _e300 = c;
                        let _e301 = s;
                        local_10 = (_e300 - (0.6f * _e301));
                    } else {
                        let _e304 = s;
                        let _e305 = c;
                        local_10 = (_e304 + (0.6f * _e305));
                    }
                    let _e308 = local_10;
                    lambert = clamp(_e308, 0f, 1f);
                    let _e310 = img;
                    let _e313 = uniforms.shading;
                    let _e315 = lambert;
                    let _e317 = (_e310.xyz * mix((1f - _e313), 1f, _e315));
                    let _e319 = img[3u];
                    color = vec4<f32>(_e317.x, _e317.y, _e317.z, _e319);
                    let _e324 = z;
                    let _e325 = z1_;
                    if (_e324 > _e325) {
                        let _e327 = near1_;
                        near2_ = _e327;
                        let _e328 = cover1_;
                        cover2_ = _e328;
                        let _e329 = z1_;
                        z2_ = _e329;
                        let _e330 = color;
                        near1_ = _e330;
                        let _e331 = cover;
                        cover1_ = _e331;
                        let _e332 = z;
                        z1_ = _e332;
                    } else {
                        let _e333 = color;
                        near2_ = _e333;
                        let _e334 = cover;
                        cover2_ = _e334;
                        let _e335 = z;
                        z2_ = _e335;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e336 = f;
                    f = (_e336 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e338 = d;
            d = (_e338 + 1i);
        }
    }
    let _e341 = uniforms.backColor;
    let _e342 = near2_;
    let _e343 = cover2_;
    let _e346 = near1_;
    let _e347 = cover1_;
    return mix(mix(_e341, _e342, vec4(_e343)), _e346, vec4(_e347));
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
