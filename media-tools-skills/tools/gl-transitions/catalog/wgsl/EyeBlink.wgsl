// EyeBlink — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/EyeBlink.glsl
// Author: gre
// License: MIT
// Description: Curved eyelids close from the top and bottom over the outgoing image, which blurs and dims, then open on the incoming image as it comes back into focus, as if the viewer blinked
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    blur: f32,
    softness: f32,
    blinks: i32,
    color: vec4<f32>,
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
    let _e43 = (*uv)[0u];
    let _e45 = (*uv)[1u];
    let _e48 = textureSampleLevel(_from, _sampler, vec2<f32>(_e43, (1f - _e45)), 0f);
    return _e48;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e43 = (*uv_1)[0u];
    let _e45 = (*uv_1)[1u];
    let _e48 = textureSampleLevel(_to, _sampler, vec2<f32>(_e43, (1f - _e45)), 0f);
    return _e48;
}

fn image(uv_2: ptr<function, vec2<f32>>, incoming: ptr<function, bool>) -> vec4<f32> {
    var c: vec4<f32>;
    var local: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;

    let _e47 = (*incoming);
    if _e47 {
        let _e48 = (*uv_2);
        param = _e48;
        let _e49 = getToColor((&param));
        local = _e49;
    } else {
        let _e50 = (*uv_2);
        param_1 = _e50;
        let _e51 = getFromColor((&param_1));
        local = _e51;
    }
    let _e52 = local;
    c = _e52;
    let _e53 = c;
    let _e56 = c[3u];
    let _e57 = (_e53.xyz * _e56);
    let _e59 = c[3u];
    return vec4<f32>(_e57.x, _e57.y, _e57.z, _e59);
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e42 = (*v);
    let _e43 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e42 - (floor((_e42 / _e43)) * _e43)))));
}

fn lidBlink(t: ptr<function, f32>, c_1: ptr<function, f32>, wc: ptr<function, f32>, wo: ptr<function, f32>, hold: ptr<function, f32>) -> f32 {
    let _e46 = (*hold);
    let _e47 = (*t);
    let _e48 = (*c_1);
    let _e50 = (*wc);
    let _e51 = (*wo);
    let _e53 = (*t);
    let _e54 = (*c_1);
    return (1f - smoothstep(_e46, select(_e51, _e50, (_e47 < _e48)), abs((_e53 - _e54))));
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var two: bool;
    var cut: f32;
    var closed: f32;
    var local_1: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var param_8: f32;
    var param_9: f32;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: f32;
    var param_14: f32;
    var param_15: f32;
    var param_16: f32;
    var incoming_1: bool;
    var soft: f32;
    var x: f32;
    var rim: f32;
    var y: f32;
    var d: f32;
    var s: f32;
    var lid: f32;
    var f: f32;
    var local_2: f32;
    var c_2: vec4<f32>;
    var local_3: vec4<f32>;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;
    var r: f32;
    var i: i32;
    var k: f32;
    var a: f32;
    var o: vec2<f32>;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var param_21: bool;
    var local_4: vec4<f32>;

    let _e85 = uniforms.blinks;
    two = (_e85 > 1i);
    let _e87 = two;
    cut = select(0.42f, 0.3f, _e87);
    let _e89 = two;
    if _e89 {
        let _e91 = uniforms.progress;
        param_2 = _e91;
        let _e92 = cut;
        param_3 = _e92;
        param_4 = 0.26f;
        param_5 = 0.26f;
        param_6 = 0.015f;
        let _e93 = lidBlink((&param_2), (&param_3), (&param_4), (&param_5), (&param_6));
        let _e95 = uniforms.progress;
        param_7 = _e95;
        param_8 = 0.7f;
        param_9 = 0.14f;
        param_10 = 0.24f;
        param_11 = 0.01f;
        let _e96 = lidBlink((&param_7), (&param_8), (&param_9), (&param_10), (&param_11));
        local_1 = max(_e93, _e96);
    } else {
        let _e99 = uniforms.progress;
        param_12 = _e99;
        let _e100 = cut;
        param_13 = _e100;
        param_14 = 0.36f;
        param_15 = 0.5f;
        param_16 = 0.02f;
        let _e101 = lidBlink((&param_12), (&param_13), (&param_14), (&param_15), (&param_16));
        local_1 = _e101;
    }
    let _e102 = local_1;
    closed = _e102;
    let _e104 = uniforms.progress;
    let _e105 = cut;
    incoming_1 = (_e104 >= _e105);
    let _e108 = uniforms.softness;
    soft = clamp(_e108, 0.001f, 0.3f);
    let _e111 = (*uv_3)[0u];
    x = ((2f * _e111) - 1f);
    let _e114 = closed;
    let _e117 = x;
    let _e119 = x;
    rim = (((1f - _e114) * 1.56f) - ((0.25f * _e117) * _e119));
    let _e123 = (*uv_3)[1u];
    y = (_e123 - 0.44f);
    let _e125 = rim;
    let _e126 = y;
    let _e128 = y;
    d = (_e125 - max((_e126 / 0.56f), (-(_e128) / 0.44f)));
    let _e133 = soft;
    let _e134 = d;
    s = (1f - smoothstep(0f, _e133, _e134));
    let _e137 = s;
    let _e138 = s;
    lid = (_e137 * _e138);
    let _e140 = lid;
    if (_e140 >= 1f) {
        let _e143 = uniforms.color;
        return _e143;
    }
    let _e145 = uniforms.progress;
    let _e146 = cut;
    if (_e145 < _e146) {
        let _e149 = uniforms.progress;
        let _e150 = cut;
        local_2 = (_e149 / _e150);
    } else {
        let _e153 = uniforms.progress;
        let _e155 = cut;
        local_2 = ((1f - _e153) / (1f - _e155));
    }
    let _e158 = local_2;
    f = _e158;
    let _e159 = f;
    f = clamp(_e159, 0f, 1f);
    let _e161 = f;
    let _e162 = f;
    let _e165 = closed;
    let _e168 = uniforms.blur;
    f = (max((_e161 * (2f - _e162)), _e165) * _e168);
    let _e170 = f;
    if (_e170 <= 0f) {
        let _e172 = incoming_1;
        if _e172 {
            let _e173 = (*uv_3);
            param_17 = _e173;
            let _e174 = getToColor((&param_17));
            local_3 = _e174;
        } else {
            let _e175 = (*uv_3);
            param_18 = _e175;
            let _e176 = getFromColor((&param_18));
            local_3 = _e176;
        }
        let _e177 = local_3;
        c_2 = _e177;
    } else {
        let _e178 = f;
        r = (0.025f * _e178);
        c_2 = vec4<f32>(0f, 0f, 0f, 0f);
        i = 0i;
        loop {
            let _e180 = i;
            if (_e180 < 16i) {
                let _e182 = i;
                k = (f32(_e182) + 0.5f);
                let _e185 = k;
                a = (2.39996f * _e185);
                let _e187 = k;
                let _e190 = a;
                let _e192 = a;
                let _e196 = r;
                o = ((vec2<f32>(cos(_e190), sin(_e192)) * sqrt((_e187 / 16f))) * _e196);
                let _e198 = (*uv_3);
                let _e199 = o;
                let _e201 = uniforms.ratio;
                param_19 = (_e198 + (_e199 * vec2<f32>((1f / _e201), 1f)));
                let _e206 = mirror((&param_19));
                param_20 = _e206;
                let _e207 = incoming_1;
                param_21 = _e207;
                let _e208 = image((&param_20), (&param_21));
                let _e209 = c_2;
                c_2 = (_e209 + _e208);
                continue;
            } else {
                break;
            }
            continuing {
                let _e211 = i;
                i = (_e211 + 1i);
            }
        }
        let _e213 = c_2;
        c_2 = (_e213 / vec4(16f));
        let _e217 = c_2[3u];
        if (_e217 > 0f) {
            let _e219 = c_2;
            let _e222 = c_2[3u];
            let _e224 = (_e219.xyz / vec3(_e222));
            let _e226 = c_2[3u];
            local_4 = vec4<f32>(_e224.x, _e224.y, _e224.z, _e226);
        } else {
            local_4 = vec4<f32>(0f, 0f, 0f, 0f);
        }
        let _e231 = local_4;
        c_2 = _e231;
        let _e232 = f;
        let _e235 = c_2;
        let _e237 = (_e235.xyz * (1f - (0.35f * _e232)));
        c_2[0u] = _e237.x;
        c_2[1u] = _e237.y;
        c_2[2u] = _e237.z;
    }
    let _e244 = c_2;
    let _e246 = uniforms.color;
    let _e247 = lid;
    return mix(_e244, _e246, vec4(_e247));
}

fn main_1() {
    var param_22: vec2<f32>;

    let _e42 = _uv_1;
    param_22 = _e42;
    let _e43 = transition((&param_22));
    _fragColor = _e43;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
