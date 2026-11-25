// HingedSquares — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HingedSquares.glsl
// Author: gre
// License: MIT
// Description: The image is cut into squares that turn in alternate directions while staying hinged at their corners, so the sheet opens into a checkerboard of diamonds showing the incoming image; those diamonds then turn back into place and close the sheet
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cells: i32,
    shading: f32,
    zoom: f32,
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

fn rot(v: ptr<function, vec2<f32>>, cs: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e46 = (*cs)[0u];
    let _e48 = (*v)[0u];
    let _e51 = (*cs)[1u];
    let _e53 = (*v)[1u];
    let _e57 = (*cs)[1u];
    let _e60 = (*v)[0u];
    let _e63 = (*cs)[0u];
    let _e65 = (*v)[1u];
    return vec2<f32>(((_e46 * _e48) + (_e51 * _e53)), ((-(_e57) * _e60) + (_e63 * _e65)));
}

fn parity(n: ptr<function, vec2<f32>>) -> f32 {
    let _e45 = (*n)[0u];
    let _e47 = (*n)[1u];
    let _e48 = (_e45 + _e47);
    return select(-1f, 1f, ((_e48 - (floor((_e48 / 2f)) * 2f)) < 0.5f));
}

fn toUV(c: ptr<function, vec2<f32>>, n_1: ptr<function, f32>) -> vec2<f32> {
    var uv: vec2<f32>;

    let _e46 = (*c);
    let _e47 = (*n_1);
    let _e49 = uniforms.ratio;
    uv = ((_e46 / (vec2<f32>(_e49, 1f) * _e47)) + vec2(0.5f));
    let _e55 = uv;
    let _e57 = (_e55 + vec2(1f));
    let _e58 = vec2(2f);
    return abs(((_e57 - (floor((_e57 / _e58)) * _e58)) - vec2(1f)));
}

fn node(i: ptr<function, f32>) -> vec2<f32> {
    let _e44 = (*i);
    let _e49 = (*i);
    return vec2<f32>((_e44 - (floor((_e44 / 2f)) * 2f)), floor((_e49 * 0.5f)));
}

fn gap(w: ptr<function, vec2<f32>>, g: ptr<function, vec2<f32>>, spacing: ptr<function, f32>, off: ptr<function, vec2<f32>>, cs_1: ptr<function, vec2<f32>>) -> vec3<f32> {
    var best: vec3<f32>;
    var r: f32;
    var i_1: i32;
    var n_2: vec2<f32>;
    var param: f32;
    var v_1: vec2<f32>;
    var h: vec2<f32>;
    var param_1: vec2<f32>;
    var local: vec2<f32>;
    var ri: f32;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;

    best = vec3<f32>(0f, 0f, 0f);
    r = 100000f;
    i_1 = 0i;
    loop {
        let _e61 = i_1;
        if (_e61 < 4i) {
            let _e63 = (*g);
            let _e64 = i_1;
            param = f32(_e64);
            let _e66 = node((&param));
            n_2 = (_e63 + _e66);
            let _e68 = (*w);
            let _e69 = n_2;
            let _e70 = (*off);
            let _e72 = (*spacing);
            v_1 = (_e68 - ((_e69 + _e70) * _e72));
            let _e75 = n_2;
            param_1 = _e75;
            let _e76 = parity((&param_1));
            if (_e76 > 0f) {
                let _e78 = (*cs_1);
                local = _e78.yx;
            } else {
                let _e80 = (*cs_1);
                local = _e80;
            }
            let _e81 = local;
            h = _e81;
            let _e83 = v_1[0u];
            let _e86 = h[1u];
            let _e89 = v_1[1u];
            let _e92 = h[0u];
            ri = ((abs(_e83) * _e86) + (abs(_e89) * _e92));
            let _e95 = ri;
            let _e96 = r;
            if (_e95 < _e96) {
                let _e98 = ri;
                r = _e98;
                let _e99 = n_2;
                param_2 = _e99;
                let _e100 = parity((&param_2));
                let _e103 = v_1;
                param_3 = _e103;
                param_4 = vec2<f32>(0.7071068f, (_e100 * 0.7071068f));
                let _e104 = rot((&param_3), (&param_4));
                let _e105 = i_1;
                best = vec3<f32>(_e104.x, _e104.y, f32(_e105));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e110 = i_1;
            i_1 = (_e110 + 1i);
        }
    }
    let _e112 = best;
    return _e112;
}

fn nearest(w_1: ptr<function, vec2<f32>>, g_1: ptr<function, vec2<f32>>, spacing_1: ptr<function, f32>, off_1: ptr<function, vec2<f32>>, cs_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var best_1: vec4<f32>;
    var i_2: i32;
    var n_3: vec2<f32>;
    var param_5: f32;
    var l: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var q: vec2<f32>;
    var d: f32;

    best_1 = vec4<f32>(0f, 0f, 100000f, 0f);
    i_2 = 0i;
    loop {
        let _e58 = i_2;
        if (_e58 < 4i) {
            let _e60 = (*g_1);
            let _e61 = i_2;
            param_5 = f32(_e61);
            let _e63 = node((&param_5));
            n_3 = (_e60 + _e63);
            let _e65 = (*w_1);
            let _e66 = n_3;
            let _e67 = (*off_1);
            let _e69 = (*spacing_1);
            let _e73 = (*cs_2)[0u];
            let _e74 = n_3;
            param_6 = _e74;
            let _e75 = parity((&param_6));
            let _e77 = (*cs_2)[1u];
            param_7 = (_e65 - ((_e66 + _e67) * _e69));
            param_8 = vec2<f32>(_e73, (_e75 * _e77));
            let _e80 = rot((&param_7), (&param_8));
            l = _e80;
            let _e81 = l;
            q = (abs(_e81) - vec2(0.5f));
            let _e85 = q;
            let _e90 = q[0u];
            let _e92 = q[1u];
            d = (length(max(_e85, vec2(0f))) + min(max(_e90, _e92), 0f));
            let _e96 = d;
            let _e98 = best_1[2u];
            if (_e96 < _e98) {
                let _e100 = l;
                let _e101 = d;
                let _e102 = i_2;
                best_1 = vec4<f32>(_e100.x, _e100.y, _e101, f32(_e102));
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e107 = i_2;
            i_2 = (_e107 + 1i);
        }
    }
    let _e109 = best_1;
    return _e109;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e45 = (*uv_1)[0u];
    let _e47 = (*uv_1)[1u];
    let _e50 = textureSampleLevel(_to, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn getFromColor(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e45 = (*uv_2)[0u];
    let _e47 = (*uv_2)[1u];
    let _e50 = textureSampleLevel(_from, _sampler, vec2<f32>(_e45, (1f - _e47)), 0f);
    return _e50;
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var n_4: f32;
    var e: f32;
    var a: f32;
    var th: f32;
    var cs_3: vec2<f32>;
    var spacing_2: f32;
    var scale: f32;
    var w_2: vec2<f32>;
    var first: bool;
    var offF: vec2<f32>;
    var offB: vec2<f32>;
    var gF: vec2<f32>;
    var gB: vec2<f32>;
    var f: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: f32;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var b: vec3<f32>;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var param_18: f32;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var nf: vec2<f32>;
    var param_21: f32;
    var nb: vec2<f32>;
    var param_22: f32;
    var uvF: vec2<f32>;
    var param_23: vec2<f32>;
    var param_24: f32;
    var uvB: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: f32;
    var colF: vec4<f32>;
    var local_1: vec4<f32>;
    var param_27: vec2<f32>;
    var param_28: vec2<f32>;
    var colB: vec4<f32>;
    var local_2: vec4<f32>;
    var param_29: vec2<f32>;
    var param_30: vec2<f32>;
    var depth: f32;
    var ws: vec2<f32>;
    var sh: vec4<f32>;
    var param_31: vec2<f32>;
    var param_32: vec2<f32>;
    var param_33: f32;
    var param_34: vec2<f32>;
    var param_35: vec2<f32>;
    var side: vec2<f32>;
    var local_3: vec2<f32>;
    var facing: f32;
    var param_36: vec2<f32>;
    var param_37: vec2<f32>;
    var param_38: vec2<f32>;
    var rim: f32;
    var aa: f32;
    var seal: f32;
    var cover: f32;

    let _e108 = uniforms.progress;
    if (_e108 <= 0f) {
        let _e110 = (*uv_3);
        param_9 = _e110;
        let _e111 = getFromColor((&param_9));
        return _e111;
    }
    let _e113 = uniforms.progress;
    if (_e113 >= 1f) {
        let _e115 = (*uv_3);
        param_10 = _e115;
        let _e116 = getToColor((&param_10));
        return _e116;
    }
    let _e118 = uniforms.cells;
    n_4 = max(f32(_e118), 1f);
    let _e122 = uniforms.progress;
    let _e124 = uniforms.progress;
    let _e127 = uniforms.progress;
    e = ((_e122 * _e124) * (3f - (2f * _e127)));
    let _e131 = e;
    a = (1.5707964f * _e131);
    let _e133 = a;
    let _e134 = a;
    th = min(_e133, (1.5707964f - _e134));
    let _e137 = th;
    let _e139 = th;
    cs_3 = vec2<f32>(cos(_e137), sin(_e139));
    let _e143 = cs_3[0u];
    let _e145 = cs_3[1u];
    spacing_2 = (_e143 + _e145);
    let _e147 = n_4;
    let _e148 = spacing_2;
    let _e150 = uniforms.zoom;
    scale = (_e147 * mix(1f, _e148, clamp(_e150, 0f, 1f)));
    let _e154 = (*uv_3);
    let _e158 = uniforms.ratio;
    let _e161 = scale;
    w_2 = (((_e154 - vec2(0.5f)) * vec2<f32>(_e158, 1f)) * _e161);
    let _e163 = a;
    first = (_e163 < 0.7853982f);
    let _e165 = first;
    offF = select(vec2<f32>(0.5f, 0.5f), vec2<f32>(0f, 0f), vec2(_e165));
    let _e168 = offF;
    offB = (vec2<f32>(0.5f, 0.5f) - _e168);
    let _e170 = w_2;
    let _e171 = spacing_2;
    let _e174 = offF;
    gF = floor(((_e170 / vec2(_e171)) - _e174));
    let _e177 = w_2;
    let _e178 = spacing_2;
    let _e181 = offB;
    gB = floor(((_e177 / vec2(_e178)) - _e181));
    let _e184 = w_2;
    param_11 = _e184;
    let _e185 = gF;
    param_12 = _e185;
    let _e186 = spacing_2;
    param_13 = _e186;
    let _e187 = offF;
    param_14 = _e187;
    let _e188 = cs_3;
    param_15 = _e188;
    let _e189 = nearest((&param_11), (&param_12), (&param_13), (&param_14), (&param_15));
    f = _e189;
    let _e190 = w_2;
    param_16 = _e190;
    let _e191 = gB;
    param_17 = _e191;
    let _e192 = spacing_2;
    param_18 = _e192;
    let _e193 = offB;
    param_19 = _e193;
    let _e194 = cs_3;
    param_20 = _e194;
    let _e195 = gap((&param_16), (&param_17), (&param_18), (&param_19), (&param_20));
    b = _e195;
    let _e196 = gF;
    let _e198 = f[3u];
    param_21 = _e198;
    let _e199 = node((&param_21));
    nf = (_e196 + _e199);
    let _e201 = gB;
    let _e203 = b[2u];
    param_22 = _e203;
    let _e204 = node((&param_22));
    nb = (_e201 + _e204);
    let _e206 = nf;
    let _e207 = offF;
    let _e209 = f;
    param_23 = ((_e206 + _e207) + _e209.xy);
    let _e212 = n_4;
    param_24 = _e212;
    let _e213 = toUV((&param_23), (&param_24));
    uvF = _e213;
    let _e214 = nb;
    let _e215 = offB;
    let _e217 = b;
    param_25 = ((_e214 + _e215) + _e217.xy);
    let _e220 = n_4;
    param_26 = _e220;
    let _e221 = toUV((&param_25), (&param_26));
    uvB = _e221;
    let _e222 = first;
    if _e222 {
        let _e223 = uvF;
        param_27 = _e223;
        let _e224 = getFromColor((&param_27));
        local_1 = _e224;
    } else {
        let _e225 = uvF;
        param_28 = _e225;
        let _e226 = getToColor((&param_28));
        local_1 = _e226;
    }
    let _e227 = local_1;
    colF = _e227;
    let _e228 = first;
    if _e228 {
        let _e229 = uvB;
        param_29 = _e229;
        let _e230 = getToColor((&param_29));
        local_2 = _e230;
    } else {
        let _e231 = uvB;
        param_30 = _e231;
        let _e232 = getFromColor((&param_30));
        local_2 = _e232;
    }
    let _e233 = local_2;
    colB = _e233;
    let _e235 = uniforms.shading;
    let _e237 = th;
    depth = (clamp(_e235, 0f, 1f) * sin((4f * _e237)));
    let _e241 = depth;
    if (_e241 > 0f) {
        let _e243 = w_2;
        let _e244 = depth;
        ws = (_e243 - (vec2<f32>(0.12f, -0.12f) * _e244));
        let _e247 = ws;
        let _e248 = spacing_2;
        let _e251 = offF;
        let _e254 = ws;
        param_31 = _e254;
        param_32 = floor(((_e247 / vec2(_e248)) - _e251));
        let _e255 = spacing_2;
        param_33 = _e255;
        let _e256 = offF;
        param_34 = _e256;
        let _e257 = cs_3;
        param_35 = _e257;
        let _e258 = nearest((&param_31), (&param_32), (&param_33), (&param_34), (&param_35));
        sh = _e258;
        let _e259 = depth;
        let _e262 = sh[2u];
        let _e267 = colB;
        let _e269 = (_e267.xyz * (1f - ((0.75f * _e259) * (1f - smoothstep(-0.12f, 0.25f, _e262)))));
        colB[0u] = _e269.x;
        colB[1u] = _e269.y;
        colB[2u] = _e269.z;
    }
    let _e277 = f[0u];
    let _e280 = f[1u];
    if (abs(_e277) > abs(_e280)) {
        let _e284 = f[0u];
        local_3 = vec2<f32>(sign(_e284), 0f);
    } else {
        let _e288 = f[1u];
        local_3 = vec2<f32>(0f, sign(_e288));
    }
    let _e291 = local_3;
    side = _e291;
    let _e293 = cs_3[0u];
    let _e294 = nf;
    param_36 = _e294;
    let _e295 = parity((&param_36));
    let _e298 = cs_3[1u];
    let _e301 = side;
    param_37 = _e301;
    param_38 = vec2<f32>(_e293, (-(_e295) * _e298));
    let _e302 = rot((&param_37), (&param_38));
    facing = dot(_e302, vec2<f32>(-0.7071f, 0.7071f));
    let _e305 = f[2u];
    rim = smoothstep(-0.07f, -0.01f, _e305);
    let _e307 = depth;
    let _e309 = rim;
    let _e311 = facing;
    let _e314 = colF;
    let _e316 = (_e314.xyz * (1f + (((0.35f * _e307) * _e309) * _e311)));
    colF[0u] = _e316.x;
    colF[1u] = _e316.y;
    colF[2u] = _e316.z;
    let _e323 = scale;
    aa = (0.0012f * _e323);
    let _e325 = aa;
    let _e326 = aa;
    let _e329 = cs_3[1u];
    seal = (_e325 * (1f - smoothstep(0f, (3f * _e326), _e329)));
    let _e333 = aa;
    let _e335 = aa;
    let _e337 = f[2u];
    let _e338 = seal;
    cover = (1f - smoothstep(-(_e333), _e335, (_e337 - _e338)));
    let _e342 = colB;
    let _e343 = colF;
    let _e344 = cover;
    return mix(_e342, _e343, vec4(_e344));
}

fn main_1() {
    var param_39: vec2<f32>;

    let _e44 = _uv_1;
    param_39 = _e44;
    let _e45 = transition((&param_39));
    _fragColor = _e45;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
