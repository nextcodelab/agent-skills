// RingSpin — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RingSpin.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into concentric rings that spin like the dials of a combination lock, in alternating directions and blurred with speed, one after another from the center outward; each ring overshoots a little and locks into place on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    rings: i32,
    square: i32,
    turns: i32,
    stagger: f32,
    blur: f32,
    settle: f32,
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

fn ringDelay(n: ptr<function, f32>) -> f32 {
    var m: f32;

    let _e55 = (*n);
    m = max((_e55 - 1f), 1f);
    let _e59 = uniforms.stagger;
    let _e61 = m;
    let _e63 = m;
    return min((clamp(_e59, 0f, 0.8f) / _e61), (0.7f / (1f + (0.7f * _e63))));
}

fn ringTime(i: ptr<function, f32>, n_1: ptr<function, f32>) -> f32 {
    var d: f32;
    var param: f32;
    var local: f32;

    let _e58 = (*n_1);
    param = _e58;
    let _e59 = ringDelay((&param));
    d = _e59;
    let _e61 = uniforms.progress;
    if (_e61 >= 1f) {
        local = 1f;
    } else {
        let _e64 = uniforms.progress;
        let _e65 = d;
        let _e66 = (*i);
        let _e69 = d;
        let _e70 = (*n_1);
        local = clamp(((_e64 - (_e65 * _e66)) / (1f - (_e69 * (_e70 - 1f)))), 0f, 1f);
    }
    let _e76 = local;
    return _e76;
}

fn activity(i_1: ptr<function, f32>, n_2: ptr<function, f32>) -> f32 {
    var t: f32;
    var param_1: f32;
    var param_2: f32;

    let _e58 = (*i_1);
    param_1 = _e58;
    let _e59 = (*n_2);
    param_2 = _e59;
    let _e60 = ringTime((&param_1), (&param_2));
    t = _e60;
    let _e61 = t;
    let _e63 = t;
    return (smoothstep(0f, 0.08f, _e61) * (1f - smoothstep(0.88f, 1f, _e63)));
}

fn mirrorUV(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e54 = (*v);
    let _e55 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e54 - (floor((_e54 / _e55)) * _e55)))));
}

fn rotate(v_1: ptr<function, vec2<f32>>, a: ptr<function, f32>) -> vec2<f32> {
    var c: f32;
    var s: f32;

    let _e57 = (*a);
    c = cos(_e57);
    let _e59 = (*a);
    s = sin(_e59);
    let _e61 = c;
    let _e63 = (*v_1)[0u];
    let _e65 = s;
    let _e67 = (*v_1)[1u];
    let _e70 = c;
    let _e72 = (*v_1)[1u];
    let _e74 = s;
    let _e76 = (*v_1)[0u];
    return vec2<f32>(((_e61 * _e63) + (_e65 * _e67)), ((_e70 * _e72) - (_e74 * _e76)));
}

fn spin(t_1: ptr<function, f32>, total: ptr<function, f32>) -> f32 {
    var amp: f32;
    var stopT: f32;
    var v1_: f32;
    var u: f32;
    var b: f32;

    let _e61 = uniforms.settle;
    let _e63 = (*total);
    amp = ((0.1f * _e61) * sign(_e63));
    stopT = 0.8f;
    let _e66 = amp;
    let _e68 = stopT;
    let _e70 = (*total);
    v1_ = (((_e66 * 3.1415927f) * _e68) / (_e70 * 0.2f));
    let _e73 = (*t_1);
    let _e74 = stopT;
    u = clamp((_e73 / _e74), 0f, 1f);
    let _e77 = (*t_1);
    let _e78 = stopT;
    b = clamp(((_e77 - _e78) / 0.2f), 0f, 1f);
    let _e82 = (*total);
    let _e83 = u;
    let _e84 = u;
    let _e86 = u;
    let _e90 = v1_;
    let _e91 = u;
    let _e92 = u;
    let _e94 = u;
    let _e96 = u;
    let _e97 = u;
    let _e103 = amp;
    let _e104 = b;
    let _e108 = b;
    let _e111 = b;
    return ((_e82 * (((_e83 * _e84) * (3f - (2f * _e86))) + (_e90 * (((_e91 * _e92) * _e94) - (_e96 * _e97))))) + (((_e103 * sin((3.1415927f * _e104))) * (1f - _e108)) * (1f - _e111)));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e55 = (*uv)[0u];
    let _e57 = (*uv)[1u];
    let _e60 = textureSampleLevel(_to, _sampler, vec2<f32>(_e55, (1f - _e57)), 0f);
    return _e60;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e55 = (*uv_1)[0u];
    let _e57 = (*uv_1)[1u];
    let _e60 = textureSampleLevel(_from, _sampler, vec2<f32>(_e55, (1f - _e57)), 0f);
    return _e60;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var aspect: vec2<f32>;
    var c_1: vec2<f32>;
    var r: f32;
    var local_1: f32;
    var n_3: f32;
    var w: f32;
    var local_2: f32;
    var f: f32;
    var i_2: f32;
    var t_2: f32;
    var param_3: f32;
    var param_4: f32;
    var col: vec4<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var total_1: f32;
    var a_1: f32;
    var param_7: f32;
    var param_8: f32;
    var u_1: f32;
    var omega: f32;
    var param_9: f32;
    var span: f32;
    var m_1: f32;
    var ws: f32;
    var k: i32;
    var x: f32;
    var q: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: f32;
    var param_12: vec2<f32>;
    var s_1: vec4<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var bj: f32;
    var act: f32;
    var local_3: f32;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: f32;
    var d_1: f32;
    var nr: vec2<f32>;
    var local_4: vec2<f32>;
    var local_5: vec2<f32>;
    var light: f32;
    var local_6: vec3<f32>;

    let _e102 = uniforms.ratio;
    aspect = vec2<f32>(_e102, 1f);
    let _e104 = (*uv_2);
    let _e107 = aspect;
    c_1 = ((_e104 - vec2(0.5f)) * _e107);
    let _e110 = uniforms.square;
    if (_e110 != 0i) {
        let _e113 = c_1[0u];
        let _e116 = c_1[1u];
        local_1 = max(abs(_e113), abs(_e116));
    } else {
        let _e119 = c_1;
        local_1 = length(_e119);
    }
    let _e121 = local_1;
    r = _e121;
    let _e123 = uniforms.rings;
    n_3 = clamp(f32(_e123), 1f, 12f);
    let _e127 = uniforms.square;
    if (_e127 != 0i) {
        let _e130 = uniforms.ratio;
        local_2 = (0.5f * max(_e130, 1f));
    } else {
        let _e133 = aspect;
        local_2 = length((_e133 * 0.5f));
    }
    let _e136 = local_2;
    let _e137 = n_3;
    w = (_e136 / _e137);
    let _e139 = r;
    let _e140 = w;
    f = (_e139 / _e140);
    let _e142 = f;
    let _e144 = n_3;
    i_2 = min(floor(_e142), (_e144 - 1f));
    let _e147 = i_2;
    param_3 = _e147;
    let _e148 = n_3;
    param_4 = _e148;
    let _e149 = ringTime((&param_3), (&param_4));
    t_2 = _e149;
    let _e150 = t_2;
    if (_e150 <= 0f) {
        let _e152 = (*uv_2);
        param_5 = _e152;
        let _e153 = getFromColor((&param_5));
        col = _e153;
    } else {
        let _e154 = t_2;
        if (_e154 >= 1f) {
            let _e156 = (*uv_2);
            param_6 = _e156;
            let _e157 = getToColor((&param_6));
            col = _e157;
        } else {
            let _e159 = uniforms.turns;
            let _e163 = i_2;
            total_1 = ((6.2831855f * max(f32(_e159), 1f)) * select(-1f, 1f, ((_e163 - (floor((_e163 / 2f)) * 2f)) < 0.5f)));
            let _e171 = t_2;
            param_7 = _e171;
            let _e172 = total_1;
            param_8 = _e172;
            let _e173 = spin((&param_7), (&param_8));
            a_1 = _e173;
            let _e174 = t_2;
            u_1 = min((_e174 / 0.8f), 1f);
            let _e177 = total_1;
            let _e180 = u_1;
            let _e182 = u_1;
            let _e185 = n_3;
            param_9 = _e185;
            let _e186 = ringDelay((&param_9));
            let _e187 = n_3;
            omega = ((((abs(_e177) * 6f) * _e180) * (1f - _e182)) / (0.8f * (1f - (_e186 * (_e187 - 1f)))));
            let _e194 = uniforms.blur;
            let _e195 = omega;
            let _e197 = r;
            span = (_e194 * min((_e195 * 0.015f), (0.1f / max(_e197, 0.01f))));
            let _e202 = t_2;
            m_1 = smoothstep(0.3f, 0.5f, _e202);
            col = vec4<f32>(0f, 0f, 0f, 0f);
            ws = 0f;
            k = 0i;
            loop {
                let _e204 = k;
                if (_e204 < 8i) {
                    let _e206 = k;
                    x = ((f32(_e206) / 7f) - 0.5f);
                    let _e210 = a_1;
                    let _e211 = span;
                    let _e212 = x;
                    let _e215 = c_1;
                    param_10 = _e215;
                    param_11 = (_e210 + (_e211 * _e212));
                    let _e216 = rotate((&param_10), (&param_11));
                    let _e217 = aspect;
                    param_12 = ((_e216 / _e217) + vec2(0.5f));
                    let _e221 = mirrorUV((&param_12));
                    q = _e221;
                    let _e222 = q;
                    param_13 = _e222;
                    let _e223 = getFromColor((&param_13));
                    let _e224 = q;
                    param_14 = _e224;
                    let _e225 = getToColor((&param_14));
                    let _e226 = m_1;
                    s_1 = mix(_e223, _e225, vec4(_e226));
                    let _e229 = x;
                    let _e232 = s_1;
                    let _e234 = col;
                    col = (_e234 + (_e232 * (1f - abs(_e229))));
                    let _e236 = x;
                    let _e239 = ws;
                    ws = (_e239 + (1f - abs(_e236)));
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e241 = k;
                    k = (_e241 + 1i);
                }
            }
            let _e243 = ws;
            let _e244 = col;
            col = (_e244 / vec4(_e243));
        }
    }
    let _e247 = f;
    let _e250 = n_3;
    bj = clamp(floor((_e247 + 0.5f)), 1f, max((_e250 - 1f), 1f));
    let _e254 = n_3;
    if (_e254 > 1.5f) {
        let _e256 = bj;
        param_15 = (_e256 - 1f);
        let _e258 = n_3;
        param_16 = _e258;
        let _e259 = activity((&param_15), (&param_16));
        let _e260 = bj;
        param_17 = _e260;
        let _e261 = n_3;
        param_18 = _e261;
        let _e262 = activity((&param_17), (&param_18));
        local_3 = max(_e259, _e262);
    } else {
        local_3 = 0f;
    }
    let _e264 = local_3;
    act = _e264;
    let _e265 = f;
    let _e266 = bj;
    let _e268 = w;
    d_1 = ((_e265 - _e266) * _e268);
    let _e271 = uniforms.square;
    if (_e271 != 0i) {
        let _e274 = c_1[0u];
        let _e277 = c_1[1u];
        if (abs(_e274) > abs(_e277)) {
            let _e281 = c_1[0u];
            local_5 = vec2<f32>(sign(_e281), 0f);
        } else {
            let _e285 = c_1[1u];
            local_5 = vec2<f32>(0f, sign(_e285));
        }
        let _e288 = local_5;
        local_4 = _e288;
    } else {
        let _e289 = c_1;
        let _e290 = r;
        local_4 = (_e289 / vec2(max(_e290, 0.0001f)));
    }
    let _e294 = local_4;
    nr = _e294;
    let _e295 = d_1;
    let _e298 = nr;
    let _e301 = d_1;
    let _e306 = act;
    light = (((-(sign(_e295)) * dot(_e298, vec2<f32>(-0.6f, 0.8f))) * (1f - smoothstep(0.0035f, 0.0155f, abs(_e301)))) * _e306);
    let _e308 = light;
    if (_e308 > 0f) {
        let _e310 = col;
        let _e313 = col[3u];
        let _e315 = light;
        local_6 = mix(_e310.xyz, vec3(_e313), vec3((0.35f * _e315)));
    } else {
        let _e319 = col;
        let _e321 = light;
        local_6 = (_e319.xyz * (1f + (0.45f * _e321)));
    }
    let _e325 = local_6;
    col[0u] = _e325.x;
    col[1u] = _e325.y;
    col[2u] = _e325.z;
    let _e332 = act;
    let _e334 = d_1;
    let _e340 = col;
    let _e342 = (_e340.xyz * (1f - ((0.85f * _e332) * (1f - smoothstep(0.002f, 0.005f, abs(_e334))))));
    col[0u] = _e342.x;
    col[1u] = _e342.y;
    col[2u] = _e342.z;
    let _e349 = col;
    return _e349;
}

fn main_1() {
    var param_19: vec2<f32>;

    let _e54 = _uv_1;
    param_19 = _e54;
    let _e55 = transition((&param_19));
    _fragColor = _e55;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
