// BlockSlide — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BlockSlide.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into a grid of blocks that slide out one after another in a staggered cascade, some of them shrinking as they go, while the blocks of the incoming image slide in behind them to take their place
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    grid: vec2<i32>,
    direction: vec2<f32>,
    stagger: f32,
    zoom: f32,
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

fn hash(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e33 = (*p);
    p3_ = fract((_e33.xyx * 0.1031f));
    let _e37 = p3_;
    let _e38 = p3_;
    let _e43 = p3_;
    p3_ = (_e43 + vec3(dot(_e37, (_e38.yzx + vec3(33.33f)))));
    let _e47 = p3_[0u];
    let _e49 = p3_[1u];
    let _e52 = p3_[2u];
    return fract(((_e47 + _e49) * _e52));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e33 = (*uv)[0u];
    let _e35 = (*uv)[1u];
    let _e38 = textureSampleLevel(_to, _sampler, vec2<f32>(_e33, (1f - _e35)), 0f);
    return _e38;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e33 = (*uv_1)[0u];
    let _e35 = (*uv_1)[1u];
    let _e38 = textureSampleLevel(_from, _sampler, vec2<f32>(_e33, (1f - _e35)), 0f);
    return _e38;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var vertical: bool;
    var backward: bool;
    var local: bool;
    var g: vec2<f32>;
    var a: f32;
    var local_1: f32;
    var b: f32;
    var local_2: f32;
    var n: f32;
    var local_3: f32;
    var strips: f32;
    var local_4: f32;
    var r: f32;
    var rowOrder: f32;
    var local_5: f32;
    var local_6: f32;
    var st: f32;
    var z: f32;
    var an: f32;
    var bn: f32;
    var rear: f32;
    var k: i32;
    var i: f32;
    var order: f32;
    var local_7: f32;
    var p_1: f32;
    var pin: f32;
    var zi: f32;
    var param_2: vec2<f32>;
    var sFrom: f32;
    var sTo: f32;
    var l: vec4<f32>;
    var inFrom: bool;
    var inTo: bool;
    var q: vec2<f32>;
    var local_8: vec2<f32>;
    var local_9: vec2<f32>;
    var local_10: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var phi_428_: bool;
    var phi_440_: bool;

    let _e75 = uniforms.progress;
    if (_e75 <= 0f) {
        let _e77 = (*uv_2);
        param = _e77;
        let _e78 = getFromColor((&param));
        return _e78;
    }
    let _e80 = uniforms.progress;
    if (_e80 >= 1f) {
        let _e82 = (*uv_2);
        param_1 = _e82;
        let _e83 = getToColor((&param_1));
        return _e83;
    }
    let _e86 = uniforms.direction[1u];
    let _e90 = uniforms.direction[0u];
    vertical = (abs(_e86) > abs(_e90));
    let _e93 = vertical;
    if _e93 {
        let _e96 = uniforms.direction[1u];
        local = (_e96 < 0f);
    } else {
        let _e100 = uniforms.direction[0u];
        local = (_e100 < 0f);
    }
    let _e102 = local;
    backward = _e102;
    let _e104 = uniforms.grid;
    g = max(vec2<f32>(_e104), vec2(1f));
    let _e108 = vertical;
    if _e108 {
        let _e110 = (*uv_2)[1u];
        local_1 = _e110;
    } else {
        let _e112 = (*uv_2)[0u];
        local_1 = _e112;
    }
    let _e113 = local_1;
    a = _e113;
    let _e114 = vertical;
    if _e114 {
        let _e116 = (*uv_2)[0u];
        local_2 = _e116;
    } else {
        let _e118 = (*uv_2)[1u];
        local_2 = _e118;
    }
    let _e119 = local_2;
    b = _e119;
    let _e120 = backward;
    if _e120 {
        let _e121 = a;
        a = (1f - _e121);
    }
    let _e123 = vertical;
    if _e123 {
        let _e125 = g[1u];
        local_3 = _e125;
    } else {
        let _e127 = g[0u];
        local_3 = _e127;
    }
    let _e128 = local_3;
    n = min(_e128, 40f);
    let _e130 = vertical;
    if _e130 {
        let _e132 = g[0u];
        local_4 = _e132;
    } else {
        let _e134 = g[1u];
        local_4 = _e134;
    }
    let _e135 = local_4;
    strips = _e135;
    let _e136 = b;
    let _e137 = strips;
    let _e140 = strips;
    r = min(floor((_e136 * _e137)), (_e140 - 1f));
    let _e143 = strips;
    if (_e143 > 1f) {
        let _e145 = vertical;
        if _e145 {
            let _e146 = r;
            local_6 = _e146;
        } else {
            let _e147 = strips;
            let _e149 = r;
            local_6 = ((_e147 - 1f) - _e149);
        }
        let _e151 = local_6;
        let _e152 = strips;
        local_5 = (_e151 / (_e152 - 1f));
    } else {
        local_5 = 0f;
    }
    let _e155 = local_5;
    rowOrder = _e155;
    let _e157 = uniforms.stagger;
    st = clamp(_e157, 0f, 0.95f);
    let _e160 = uniforms.zoom;
    z = clamp(_e160, 0f, 0.9f);
    let _e162 = a;
    let _e163 = n;
    an = (_e162 * _e163);
    let _e165 = b;
    let _e166 = strips;
    let _e168 = r;
    bn = ((_e165 * _e166) - _e168);
    let _e171 = uniforms.progress;
    let _e172 = st;
    let _e173 = rowOrder;
    let _e177 = st;
    rear = clamp(((_e171 - (_e172 * mix(_e173, 1f, 0.2f))) / (1f - _e177)), 0f, 1f);
    let _e181 = rear;
    let _e182 = rear;
    let _e184 = rear;
    rear = ((_e181 * _e182) * (3f - (2f * _e184)));
    k = 0i;
    loop {
        let _e188 = k;
        if (_e188 < 40i) {
            let _e190 = k;
            i = f32(_e190);
            let _e192 = i;
            let _e193 = n;
            if (_e192 >= _e193) {
                break;
            }
            let _e195 = rowOrder;
            let _e196 = n;
            if (_e196 > 1f) {
                let _e198 = n;
                let _e200 = i;
                let _e202 = n;
                local_7 = (((_e198 - 1f) - _e200) / (_e202 - 1f));
            } else {
                local_7 = 0f;
            }
            let _e205 = local_7;
            order = mix(_e195, _e205, 0.2f);
            let _e208 = uniforms.progress;
            let _e209 = st;
            let _e210 = order;
            let _e213 = st;
            p_1 = clamp(((_e208 - (_e209 * _e210)) / (1f - _e213)), 0f, 1f);
            let _e217 = p_1;
            let _e218 = p_1;
            let _e220 = p_1;
            p_1 = ((_e217 * _e218) * (3f - (2f * _e220)));
            let _e224 = rear;
            let _e226 = n;
            let _e228 = i;
            let _e230 = n;
            pin = max(0f, (1f - ((1f - _e224) * (1f + (((_e226 - 1f) - _e228) / _e230)))));
            let _e236 = i;
            let _e237 = r;
            param_2 = (vec2<f32>(_e236, _e237) + vec2(3.7f));
            let _e241 = hash((&param_2));
            let _e243 = z;
            zi = select(0f, _e243, (_e241 < 0.5f));
            let _e245 = zi;
            let _e246 = p_1;
            let _e248 = p_1;
            sFrom = (1f - ((_e245 * _e246) * _e248));
            let _e251 = zi;
            let _e252 = pin;
            let _e255 = pin;
            sTo = (1f - ((_e251 * (1f - _e252)) * (1f - _e255)));
            let _e259 = an;
            let _e260 = i;
            let _e262 = p_1;
            let _e263 = n;
            let _e266 = sFrom;
            let _e270 = sFrom;
            let _e272 = bn;
            let _e273 = sFrom;
            let _e277 = sFrom;
            let _e279 = an;
            let _e280 = i;
            let _e282 = pin;
            let _e284 = n;
            let _e287 = sTo;
            let _e291 = sTo;
            let _e293 = bn;
            let _e294 = sTo;
            let _e298 = sTo;
            l = vec4<f32>(((((_e259 - _e260) - (_e262 * _e263)) - (0.5f * (1f - _e266))) / _e270), ((_e272 - (0.5f * (1f - _e273))) / _e277), ((((_e279 - _e280) - ((_e282 - 1f) * _e284)) - (0.5f * (1f - _e287))) / _e291), ((_e293 - (0.5f * (1f - _e294))) / _e298));
            let _e301 = l;
            let _e304 = all((_e301.xy >= vec2<f32>(0f, 0f)));
            phi_428_ = _e304;
            if _e304 {
                let _e305 = l;
                phi_428_ = all((_e305.xy < vec2<f32>(1f, 1f)));
            }
            let _e310 = phi_428_;
            inFrom = _e310;
            let _e311 = l;
            let _e314 = all((_e311.zw >= vec2<f32>(0f, 0f)));
            phi_440_ = _e314;
            if _e314 {
                let _e315 = l;
                phi_440_ = all((_e315.zw < vec2<f32>(1f, 1f)));
            }
            let _e320 = phi_440_;
            inTo = _e320;
            let _e321 = inFrom;
            let _e322 = inTo;
            if (_e321 || _e322) {
                let _e324 = i;
                let _e325 = r;
                let _e327 = inTo;
                if _e327 {
                    let _e328 = l;
                    local_8 = _e328.zw;
                } else {
                    let _e330 = l;
                    local_8 = _e330.xy;
                }
                let _e332 = local_8;
                let _e334 = n;
                let _e335 = strips;
                q = ((vec2<f32>(_e324, _e325) + _e332) / vec2<f32>(_e334, _e335));
                let _e338 = backward;
                if _e338 {
                    let _e340 = q[0u];
                    q[0u] = (1f - _e340);
                }
                let _e343 = vertical;
                if _e343 {
                    let _e344 = q;
                    local_9 = _e344.yx;
                } else {
                    let _e346 = q;
                    local_9 = _e346;
                }
                let _e347 = local_9;
                q = _e347;
                let _e348 = inTo;
                if _e348 {
                    let _e349 = q;
                    param_3 = _e349;
                    let _e350 = getToColor((&param_3));
                    local_10 = _e350;
                } else {
                    let _e351 = q;
                    param_4 = _e351;
                    let _e352 = getFromColor((&param_4));
                    local_10 = _e352;
                }
                let _e353 = local_10;
                return _e353;
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e354 = k;
            k = (_e354 + 1i);
        }
    }
    let _e357 = uniforms.background;
    return _e357;
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e32 = _uv_1;
    param_5 = _e32;
    let _e33 = transition((&param_5));
    _fragColor = _e33;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
