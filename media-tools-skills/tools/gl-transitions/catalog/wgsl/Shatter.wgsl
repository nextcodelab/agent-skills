// Shatter — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Shatter.glsl
// Author: lbl
// License: MIT
// Description: The outgoing image cracks like a pane of glass from an impact point, then its shards break loose from the impact outward, tumbling in 3D and falling away with gravity to reveal the incoming image behind
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    shards: f32,
    gravity: f32,
    seed: f32,
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

fn impact_u0028_() -> vec2<f32> {
    let _e94 = uniforms.center;
    let _e99 = uniforms.ratio;
    return (clamp(_e94, vec2(0f), vec2(1f)) * vec2<f32>(_e99, 1f));
}

fn flash(q: ptr<function, vec2<f32>>) -> f32 {
    var f: f32;
    var d: vec2<f32>;

    let _e97 = uniforms.progress;
    f = sin((3.1415927f * clamp((_e97 / 0.12f), 0f, 1f)));
    let _e102 = (*q);
    let _e103 = impact_u0028_();
    d = (_e102 - _e103);
    let _e105 = f;
    let _e107 = d;
    let _e108 = d;
    let _e112 = uniforms.progress;
    return ((0.6f * _e105) * exp((-(dot(_e107, _e108)) / (0.004f + (0.02f * _e112)))));
}

fn side(q_1: ptr<function, vec2<f32>>, a: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>) -> f32 {
    var d_1: vec2<f32>;

    let _e97 = (*b);
    let _e98 = (*a);
    d_1 = (_e97 - _e98);
    let _e101 = d_1[0u];
    let _e103 = (*q_1)[1u];
    let _e105 = (*a)[1u];
    let _e109 = d_1[1u];
    let _e111 = (*q_1)[0u];
    let _e113 = (*a)[0u];
    let _e117 = d_1;
    return (((_e101 * (_e103 - _e105)) - (_e109 * (_e111 - _e113))) / length(_e117));
}

fn triangleDist(q_2: ptr<function, vec2<f32>>, p0_: ptr<function, vec2<f32>>, p1_: ptr<function, vec2<f32>>, p2_: ptr<function, vec2<f32>>) -> f32 {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;

    let _e106 = (*q_2);
    param = _e106;
    let _e107 = (*p0_);
    param_1 = _e107;
    let _e108 = (*p1_);
    param_2 = _e108;
    let _e109 = side((&param), (&param_1), (&param_2));
    let _e110 = (*q_2);
    param_3 = _e110;
    let _e111 = (*p1_);
    param_4 = _e111;
    let _e112 = (*p2_);
    param_5 = _e112;
    let _e113 = side((&param_3), (&param_4), (&param_5));
    let _e115 = (*q_2);
    param_6 = _e115;
    let _e116 = (*p2_);
    param_7 = _e116;
    let _e117 = (*p0_);
    param_8 = _e117;
    let _e118 = side((&param_6), (&param_7), (&param_8));
    return min(min(_e109, _e113), _e118);
}

fn rotate(v: ptr<function, vec3<f32>>, k: ptr<function, vec3<f32>>, angle: ptr<function, f32>) -> vec3<f32> {
    var c: f32;
    var s: f32;

    let _e98 = (*angle);
    c = cos(_e98);
    let _e100 = (*angle);
    s = sin(_e100);
    let _e102 = (*v);
    let _e103 = c;
    let _e105 = (*k);
    let _e106 = (*v);
    let _e108 = s;
    let _e111 = (*k);
    let _e112 = (*k);
    let _e113 = (*v);
    let _e116 = c;
    return (((_e102 * _e103) + (cross(_e105, _e106) * _e108)) + ((_e111 * dot(_e112, _e113)) * (1f - _e116)));
}

fn releaseTime(mid: ptr<function, vec2<f32>>, dn: ptr<function, f32>, h: ptr<function, f32>, g: ptr<function, f32>, margin: ptr<function, f32>) -> f32 {
    var latest: f32;

    let _e100 = (*mid)[1u];
    let _e101 = (*margin);
    let _e104 = (*g);
    latest = max((0.98f - sqrt(((2f * (_e100 + _e101)) / _e104))), 0.04f);
    let _e109 = latest;
    let _e111 = (*dn);
    let _e114 = (*h);
    return (0.04f + ((_e109 - 0.04f) * ((0.8f * pow(_e111, 0.8f)) + (0.2f * _e114))));
}

fn hash32(p: ptr<function, vec2<f32>>) -> vec3<f32> {
    var p3_: vec3<f32>;

    let _e95 = (*p);
    p3_ = fract((_e95.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e99 = p3_;
    let _e100 = p3_;
    let _e105 = p3_;
    p3_ = (_e105 + vec3(dot(_e99, (_e100.yxz + vec3(33.33f)))));
    let _e108 = p3_;
    let _e110 = p3_;
    let _e113 = p3_;
    return fract(((_e108.xxy + _e110.yzz) * _e113.zyx));
}

fn seedOffset_u0028_() -> vec2<f32> {
    let _e94 = uniforms.seed;
    return (vec2<f32>(37f, 17f) * floor(_e94));
}

fn diagonalUp(c_1: ptr<function, vec2<f32>>) -> bool {
    var param_9: vec2<f32>;

    let _e95 = (*c_1);
    let _e96 = seedOffset_u0028_();
    param_9 = ((_e95 + _e96) + vec2(0.5f));
    let _e100 = hash32((&param_9));
    return (_e100.z > 0.5f);
}

fn cellSize_u0028_() -> f32 {
    let _e94 = uniforms.shards;
    return (1f / clamp(_e94, 3f, 8f));
}

fn corner(p_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    var param_10: vec2<f32>;

    let _e95 = (*p_1);
    let _e96 = (*p_1);
    let _e97 = seedOffset_u0028_();
    param_10 = (_e96 + _e97);
    let _e99 = hash32((&param_10));
    let _e106 = cellSize_u0028_();
    return ((_e95 + (((_e99.xy * 2f) - vec2(1f)) * 0.32f)) * _e106);
}

fn locate(q_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var c_2: vec2<f32>;
    var i: i32;
    var a_1: vec2<f32>;
    var param_11: vec2<f32>;
    var b_1: vec2<f32>;
    var param_12: vec2<f32>;
    var cc: vec2<f32>;
    var param_13: vec2<f32>;
    var d_2: vec2<f32>;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var local: f32;
    var param_18: vec2<f32>;
    var param_19: vec2<f32>;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var param_22: vec2<f32>;
    var param_23: vec2<f32>;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;
    var local_1: f32;
    var param_28: vec2<f32>;
    var param_29: vec2<f32>;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;
    var param_32: vec2<f32>;
    var param_33: vec2<f32>;
    var param_34: vec2<f32>;
    var up: bool;
    var param_35: vec2<f32>;
    var d0_: f32;
    var local_2: f32;
    var param_36: vec2<f32>;
    var param_37: vec2<f32>;
    var param_38: vec2<f32>;
    var param_39: vec2<f32>;
    var param_40: vec2<f32>;
    var param_41: vec2<f32>;
    var param_42: vec2<f32>;
    var param_43: vec2<f32>;
    var d1_: f32;
    var local_3: f32;
    var param_44: vec2<f32>;
    var param_45: vec2<f32>;
    var param_46: vec2<f32>;
    var param_47: vec2<f32>;
    var param_48: vec2<f32>;
    var param_49: vec2<f32>;
    var param_50: vec2<f32>;
    var param_51: vec2<f32>;

    let _e148 = (*q_3);
    let _e149 = cellSize_u0028_();
    c_2 = floor((_e148 / vec2(_e149)));
    i = 0i;
    loop {
        let _e153 = i;
        if (_e153 < 2i) {
            let _e155 = c_2;
            param_11 = _e155;
            let _e156 = corner((&param_11));
            a_1 = _e156;
            let _e157 = c_2;
            param_12 = (_e157 + vec2<f32>(1f, 0f));
            let _e159 = corner((&param_12));
            b_1 = _e159;
            let _e160 = c_2;
            param_13 = (_e160 + vec2(1f));
            let _e163 = corner((&param_13));
            cc = _e163;
            let _e164 = c_2;
            param_14 = (_e164 + vec2<f32>(0f, 1f));
            let _e166 = corner((&param_14));
            d_2 = _e166;
            let _e167 = (*q_3);
            param_15 = _e167;
            let _e168 = d_2;
            param_16 = _e168;
            let _e169 = a_1;
            param_17 = _e169;
            let _e170 = side((&param_15), (&param_16), (&param_17));
            if (_e170 < 0f) {
                local = -1f;
            } else {
                let _e172 = (*q_3);
                param_18 = _e172;
                let _e173 = b_1;
                param_19 = _e173;
                let _e174 = cc;
                param_20 = _e174;
                let _e175 = side((&param_18), (&param_19), (&param_20));
                local = select(0f, 1f, (_e175 < 0f));
            }
            let _e178 = local;
            let _e180 = c_2[0u];
            c_2[0u] = (_e180 + _e178);
            let _e183 = c_2;
            param_21 = _e183;
            let _e184 = corner((&param_21));
            a_1 = _e184;
            let _e185 = c_2;
            param_22 = (_e185 + vec2<f32>(1f, 0f));
            let _e187 = corner((&param_22));
            b_1 = _e187;
            let _e188 = c_2;
            param_23 = (_e188 + vec2(1f));
            let _e191 = corner((&param_23));
            cc = _e191;
            let _e192 = c_2;
            param_24 = (_e192 + vec2<f32>(0f, 1f));
            let _e194 = corner((&param_24));
            d_2 = _e194;
            let _e195 = (*q_3);
            param_25 = _e195;
            let _e196 = a_1;
            param_26 = _e196;
            let _e197 = b_1;
            param_27 = _e197;
            let _e198 = side((&param_25), (&param_26), (&param_27));
            if (_e198 < 0f) {
                local_1 = -1f;
            } else {
                let _e200 = (*q_3);
                param_28 = _e200;
                let _e201 = cc;
                param_29 = _e201;
                let _e202 = d_2;
                param_30 = _e202;
                let _e203 = side((&param_28), (&param_29), (&param_30));
                local_1 = select(0f, 1f, (_e203 < 0f));
            }
            let _e206 = local_1;
            let _e208 = c_2[1u];
            c_2[1u] = (_e208 + _e206);
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
    param_31 = _e213;
    let _e214 = corner((&param_31));
    a_1 = _e214;
    let _e215 = c_2;
    param_32 = (_e215 + vec2<f32>(1f, 0f));
    let _e217 = corner((&param_32));
    b_1 = _e217;
    let _e218 = c_2;
    param_33 = (_e218 + vec2(1f));
    let _e221 = corner((&param_33));
    cc = _e221;
    let _e222 = c_2;
    param_34 = (_e222 + vec2<f32>(0f, 1f));
    let _e224 = corner((&param_34));
    d_2 = _e224;
    let _e225 = c_2;
    param_35 = _e225;
    let _e226 = diagonalUp((&param_35));
    up = _e226;
    let _e227 = up;
    if _e227 {
        let _e228 = (*q_3);
        param_36 = _e228;
        let _e229 = a_1;
        param_37 = _e229;
        let _e230 = b_1;
        param_38 = _e230;
        let _e231 = cc;
        param_39 = _e231;
        let _e232 = triangleDist((&param_36), (&param_37), (&param_38), (&param_39));
        local_2 = _e232;
    } else {
        let _e233 = (*q_3);
        param_40 = _e233;
        let _e234 = a_1;
        param_41 = _e234;
        let _e235 = b_1;
        param_42 = _e235;
        let _e236 = d_2;
        param_43 = _e236;
        let _e237 = triangleDist((&param_40), (&param_41), (&param_42), (&param_43));
        local_2 = _e237;
    }
    let _e238 = local_2;
    d0_ = _e238;
    let _e239 = up;
    if _e239 {
        let _e240 = (*q_3);
        param_44 = _e240;
        let _e241 = a_1;
        param_45 = _e241;
        let _e242 = cc;
        param_46 = _e242;
        let _e243 = d_2;
        param_47 = _e243;
        let _e244 = triangleDist((&param_44), (&param_45), (&param_46), (&param_47));
        local_3 = _e244;
    } else {
        let _e245 = (*q_3);
        param_48 = _e245;
        let _e246 = b_1;
        param_49 = _e246;
        let _e247 = cc;
        param_50 = _e247;
        let _e248 = d_2;
        param_51 = _e248;
        let _e249 = triangleDist((&param_48), (&param_49), (&param_50), (&param_51));
        local_3 = _e249;
    }
    let _e250 = local_3;
    d1_ = _e250;
    let _e251 = c_2;
    let _e252 = d1_;
    let _e253 = d0_;
    let _e256 = d0_;
    let _e257 = d1_;
    return vec4<f32>(_e251.x, _e251.y, select(0f, 1f, (_e252 > _e253)), abs(max(_e256, _e257)));
}

fn fallMargin_u0028_() -> f32 {
    let _e93 = cellSize_u0028_();
    return (0.1f + (1.5f * _e93));
}

fn reach_u0028_() -> f32 {
    var c_3: vec2<f32>;

    let _e94 = impact_u0028_();
    c_3 = _e94;
    let _e95 = c_3;
    let _e97 = uniforms.ratio;
    let _e99 = c_3;
    return length(max(_e95, (vec2<f32>(_e97, 1f) - _e99)));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e95 = (*uv)[0u];
    let _e97 = (*uv)[1u];
    let _e100 = textureSampleLevel(_to, _sampler, vec2<f32>(_e95, (1f - _e97)), 0f);
    return _e100;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e95 = (*uv_1)[0u];
    let _e97 = (*uv_1)[1u];
    let _e100 = textureSampleLevel(_from, _sampler, vec2<f32>(_e95, (1f - _e97)), 0f);
    return _e100;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_52: vec2<f32>;
    var param_53: vec2<f32>;
    var s_1: f32;
    var a_2: vec2<f32>;
    var eye: vec3<f32>;
    var ray: vec3<f32>;
    var light: vec3<f32>;
    var halfway: vec3<f32>;
    var g_1: f32;
    var imp: vec2<f32>;
    var rch: f32;
    var margin_1: f32;
    var crackTime: f32;
    var pane: vec4<f32>;
    var paneDepth: f32;
    var here: vec4<f32>;
    var param_54: vec2<f32>;
    var hc: vec2<f32>;
    var ha: vec2<f32>;
    var param_55: vec2<f32>;
    var hb: vec2<f32>;
    var param_56: vec2<f32>;
    var hcc: vec2<f32>;
    var param_57: vec2<f32>;
    var hd: vec2<f32>;
    var param_58: vec2<f32>;
    var hup: bool;
    var param_59: vec2<f32>;
    var hcenter: vec2<f32>;
    var local_4: vec2<f32>;
    var local_5: vec2<f32>;
    var local_6: vec2<f32>;
    var hh: vec3<f32>;
    var param_60: vec2<f32>;
    var param_61: vec2<f32>;
    var param_62: f32;
    var param_63: f32;
    var param_64: f32;
    var param_65: f32;
    var col: vec4<f32>;
    var param_66: vec2<f32>;
    var crack: f32;
    var n: vec3<f32>;
    var param_67: vec3<f32>;
    var param_68: vec3<f32>;
    var param_69: f32;
    var line: f32;
    var t1_: f32;
    var t2_: f32;
    var c1_: vec4<f32>;
    var c2_: vec4<f32>;
    var a1_: f32;
    var a2_: f32;
    var shadow: f32;
    var look: vec2<f32>;
    var g0_: vec2<f32>;
    var rows: f32;
    var ri: i32;
    var j: f32;
    var ci: i32;
    var c_4: vec2<f32>;
    var ca: vec2<f32>;
    var param_70: vec2<f32>;
    var cb: vec2<f32>;
    var param_71: vec2<f32>;
    var ccc: vec2<f32>;
    var param_72: vec2<f32>;
    var cd: vec2<f32>;
    var param_73: vec2<f32>;
    var up_1: bool;
    var param_74: vec2<f32>;
    var k_1: i32;
    var p0_1: vec2<f32>;
    var p1_1: vec2<f32>;
    var p2_1: vec2<f32>;
    var mid_1: vec2<f32>;
    var h1_: vec3<f32>;
    var param_75: vec2<f32>;
    var away: vec2<f32>;
    var dist: f32;
    var dn_1: f32;
    var e: f32;
    var param_76: vec2<f32>;
    var param_77: f32;
    var param_78: f32;
    var param_79: f32;
    var param_80: f32;
    var h2_: vec3<f32>;
    var param_81: vec2<f32>;
    var near: f32;
    var vel: vec3<f32>;
    var pos: vec3<f32>;
    var axis: vec3<f32>;
    var angle_1: f32;
    var n_1: vec3<f32>;
    var param_82: vec3<f32>;
    var param_83: vec3<f32>;
    var param_84: f32;
    var rel: f32;
    var den: f32;
    var t: f32;
    var q_4: vec2<f32>;
    var param_85: vec3<f32>;
    var param_86: vec3<f32>;
    var param_87: f32;
    var border: f32;
    var inside: f32;
    var param_88: vec2<f32>;
    var param_89: vec2<f32>;
    var param_90: vec2<f32>;
    var param_91: vec2<f32>;
    var ed: f32;
    var nf: vec3<f32>;
    var local_7: vec3<f32>;
    var col_1: vec4<f32>;
    var param_92: vec2<f32>;
    var glint: f32;
    var line_1: f32;
    var bevel: f32;
    var cover: f32;
    var lden: f32;
    var ts: f32;
    var qs: vec2<f32>;
    var param_93: vec3<f32>;
    var param_94: vec3<f32>;
    var param_95: f32;
    var eds: f32;
    var param_96: vec2<f32>;
    var param_97: vec2<f32>;
    var param_98: vec2<f32>;
    var param_99: vec2<f32>;
    var back: vec4<f32>;
    var param_100: vec2<f32>;
    var color: vec4<f32>;
    var param_101: vec2<f32>;

    let _e230 = uniforms.progress;
    if (_e230 <= 0f) {
        let _e232 = (*uv_2);
        param_52 = _e232;
        let _e233 = getFromColor((&param_52));
        return _e233;
    }
    let _e235 = uniforms.progress;
    if (_e235 >= 1f) {
        let _e237 = (*uv_2);
        param_53 = _e237;
        let _e238 = getToColor((&param_53));
        return _e238;
    }
    let _e239 = cellSize_u0028_();
    s_1 = _e239;
    let _e241 = (*uv_2)[0u];
    let _e243 = uniforms.ratio;
    let _e246 = (*uv_2)[1u];
    a_2 = vec2<f32>((_e241 * _e243), _e246);
    let _e249 = uniforms.ratio;
    eye = vec3<f32>((0.5f * _e249), 0.5f, -2.5f);
    let _e252 = a_2;
    let _e256 = eye;
    ray = (vec3<f32>(_e252.x, _e252.y, 0f) - _e256);
    light = vec3<f32>(-0.29319772f, 0.46073928f, -0.8377078f);
    let _e258 = light;
    let _e259 = ray;
    halfway = normalize((_e258 - normalize(_e259)));
    let _e264 = uniforms.gravity;
    g_1 = (12f * clamp(_e264, 0.5f, 3f));
    let _e267 = impact_u0028_();
    imp = _e267;
    let _e268 = reach_u0028_();
    rch = _e268;
    let _e269 = fallMargin_u0028_();
    margin_1 = _e269;
    let _e270 = margin_1;
    let _e273 = g_1;
    crackTime = clamp((0.6f * (0.94f - sqrt(((2f * (1f + _e270)) / _e273)))), 0.05f, 0.22f);
    pane = vec4<f32>(0f, 0f, 0f, 0f);
    paneDepth = 1000000000f;
    let _e279 = a_2;
    param_54 = _e279;
    let _e280 = locate((&param_54));
    here = _e280;
    let _e281 = here;
    hc = _e281.xy;
    let _e283 = hc;
    param_55 = _e283;
    let _e284 = corner((&param_55));
    ha = _e284;
    let _e285 = hc;
    param_56 = (_e285 + vec2<f32>(1f, 0f));
    let _e287 = corner((&param_56));
    hb = _e287;
    let _e288 = hc;
    param_57 = (_e288 + vec2(1f));
    let _e291 = corner((&param_57));
    hcc = _e291;
    let _e292 = hc;
    param_58 = (_e292 + vec2<f32>(0f, 1f));
    let _e294 = corner((&param_58));
    hd = _e294;
    let _e295 = hc;
    param_59 = _e295;
    let _e296 = diagonalUp((&param_59));
    hup = _e296;
    let _e298 = here[2u];
    if (_e298 < 0.5f) {
        let _e300 = hup;
        if _e300 {
            let _e301 = ha;
            let _e302 = hb;
            let _e304 = hcc;
            local_5 = ((_e301 + _e302) + _e304);
        } else {
            let _e306 = ha;
            let _e307 = hb;
            let _e309 = hd;
            local_5 = ((_e306 + _e307) + _e309);
        }
        let _e311 = local_5;
        local_4 = _e311;
    } else {
        let _e312 = hup;
        if _e312 {
            let _e313 = ha;
            let _e314 = hcc;
            let _e316 = hd;
            local_6 = ((_e313 + _e314) + _e316);
        } else {
            let _e318 = hb;
            let _e319 = hcc;
            let _e321 = hd;
            local_6 = ((_e318 + _e319) + _e321);
        }
        let _e323 = local_6;
        local_4 = _e323;
    }
    let _e324 = local_4;
    hcenter = _e324;
    let _e325 = hc;
    let _e327 = here[2u];
    let _e331 = seedOffset_u0028_();
    param_60 = ((_e325 + (vec2<f32>(0.31f, 0.57f) * (_e327 + 1f))) + _e331);
    let _e333 = hash32((&param_60));
    hh = _e333;
    let _e334 = hcenter;
    hcenter = (_e334 / vec2(3f));
    let _e338 = uniforms.progress;
    let _e339 = hcenter;
    let _e340 = imp;
    let _e343 = rch;
    let _e346 = hcenter;
    param_61 = _e346;
    param_62 = clamp((length((_e339 - _e340)) / _e343), 0f, 1f);
    let _e348 = hh[0u];
    param_63 = _e348;
    let _e349 = g_1;
    param_64 = _e349;
    let _e350 = margin_1;
    param_65 = _e350;
    let _e351 = releaseTime((&param_61), (&param_62), (&param_63), (&param_64), (&param_65));
    if (_e338 < _e351) {
        let _e353 = (*uv_2);
        param_66 = _e353;
        let _e354 = getFromColor((&param_66));
        col = _e354;
        let _e356 = uniforms.progress;
        let _e357 = crackTime;
        let _e358 = a_2;
        let _e359 = imp;
        let _e363 = rch;
        crack = clamp(((_e356 - ((_e357 * length((_e358 - _e359))) / _e363)) / 0.03f), 0f, 1f);
        let _e368 = hh;
        let _e371 = (_e368.yz - vec2(0.5f));
        let _e378 = crack;
        let _e381 = hh[0u];
        param_67 = vec3<f32>(0f, 0f, -1f);
        param_68 = normalize((vec3<f32>(_e371.x, _e371.y, 0f) + vec3(0.0001f)));
        param_69 = ((0.06f * _e378) * (_e381 - 0.5f));
        let _e384 = rotate((&param_67), (&param_68), (&param_69));
        n = _e384;
        let _e385 = n;
        let _e386 = light;
        let _e389 = light[2u];
        let _e393 = col;
        let _e395 = (_e393.xyz * (1f + (1.2f * (dot(_e385, _e386) + _e389))));
        col[0u] = _e395.x;
        col[1u] = _e395.y;
        col[2u] = _e395.z;
        let _e402 = crack;
        let _e404 = n;
        let _e405 = halfway;
        let _e411 = col[3u];
        let _e413 = col;
        let _e416 = (_e413.xyz + vec3((((_e402 * 0.35f) * pow(max(dot(_e404, _e405), 0f), 400f)) * _e411)));
        col[0u] = _e416.x;
        col[1u] = _e416.y;
        col[2u] = _e416.z;
        let _e423 = crack;
        let _e425 = here[3u];
        line = (_e423 * (1f - smoothstep(0f, 0.0025f, _e425)));
        let _e429 = col;
        let _e432 = col[3u];
        let _e434 = line;
        let _e437 = mix(_e429.xyz, (vec3<f32>(0.95f, 0.98f, 1f) * _e432), vec3((0.85f * _e434)));
        col[0u] = _e437.x;
        col[1u] = _e437.y;
        col[2u] = _e437.z;
        let _e444 = col;
        pane = _e444;
        paneDepth = 1f;
    }
    t1_ = 1000000000f;
    t2_ = 1000000000f;
    c1_ = vec4<f32>(0f, 0f, 0f, 0f);
    c2_ = vec4<f32>(0f, 0f, 0f, 0f);
    a1_ = 0f;
    a2_ = 0f;
    shadow = 0f;
    let _e445 = a_2;
    let _e447 = uniforms.progress;
    let _e449 = a_2;
    let _e450 = imp;
    let _e453 = rch;
    let _e457 = a_2;
    let _e458 = eye;
    let _e463 = uniforms.progress;
    look = ((_e445 - (((_e449 - _e450) * (0.06f * _e447)) / vec2(_e453))) - (((_e457 - _e458.xy) * 0.06f) * _e463));
    let _e466 = look;
    let _e467 = s_1;
    g0_ = (floor((_e466 / vec2(_e467))) - vec2(1f));
    let _e473 = s_1;
    rows = ceil((1f / _e473));
    ri = 0i;
    loop {
        let _e476 = ri;
        if (_e476 < 11i) {
            let _e479 = g0_[1u];
            let _e480 = ri;
            j = (_e479 + f32(_e480));
            let _e483 = j;
            let _e484 = rows;
            if (_e483 > _e484) {
                break;
            }
            let _e486 = j;
            if (_e486 < -1f) {
                continue;
            }
            ci = 0i;
            loop {
                let _e488 = ci;
                if (_e488 < 3i) {
                    let _e491 = g0_[0u];
                    let _e492 = ci;
                    let _e495 = j;
                    c_4 = vec2<f32>((_e491 + f32(_e492)), _e495);
                    let _e497 = c_4;
                    param_70 = _e497;
                    let _e498 = corner((&param_70));
                    ca = _e498;
                    let _e499 = c_4;
                    param_71 = (_e499 + vec2<f32>(1f, 0f));
                    let _e501 = corner((&param_71));
                    cb = _e501;
                    let _e502 = c_4;
                    param_72 = (_e502 + vec2(1f));
                    let _e505 = corner((&param_72));
                    ccc = _e505;
                    let _e506 = c_4;
                    param_73 = (_e506 + vec2<f32>(0f, 1f));
                    let _e508 = corner((&param_73));
                    cd = _e508;
                    let _e509 = c_4;
                    param_74 = _e509;
                    let _e510 = diagonalUp((&param_74));
                    up_1 = _e510;
                    k_1 = 0i;
                    loop {
                        let _e511 = k_1;
                        if (_e511 < 2i) {
                            let _e513 = k_1;
                            let _e515 = up_1;
                            let _e518 = cb;
                            let _e519 = ca;
                            p0_1 = select(_e519, _e518, vec2(((_e513 == 1i) && !(_e515))));
                            let _e522 = k_1;
                            let _e524 = cb;
                            let _e525 = ccc;
                            p1_1 = select(_e525, _e524, vec2((_e522 == 0i)));
                            let _e528 = k_1;
                            let _e530 = up_1;
                            let _e532 = ccc;
                            let _e533 = cd;
                            p2_1 = select(_e533, _e532, vec2(((_e528 == 0i) && _e530)));
                            let _e536 = p0_1;
                            let _e537 = p1_1;
                            let _e539 = p2_1;
                            mid_1 = (((_e536 + _e537) + _e539) / vec2(3f));
                            let _e543 = c_4;
                            let _e544 = k_1;
                            let _e549 = seedOffset_u0028_();
                            param_75 = ((_e543 + (vec2<f32>(0.31f, 0.57f) * f32((_e544 + 1i)))) + _e549);
                            let _e551 = hash32((&param_75));
                            h1_ = _e551;
                            let _e552 = mid_1;
                            let _e553 = imp;
                            away = (_e552 - _e553);
                            let _e555 = away;
                            dist = length(_e555);
                            let _e557 = dist;
                            let _e558 = rch;
                            dn_1 = clamp((_e557 / _e558), 0f, 1f);
                            let _e562 = uniforms.progress;
                            let _e563 = mid_1;
                            param_76 = _e563;
                            let _e564 = dn_1;
                            param_77 = _e564;
                            let _e566 = h1_[0u];
                            param_78 = _e566;
                            let _e567 = g_1;
                            param_79 = _e567;
                            let _e568 = margin_1;
                            param_80 = _e568;
                            let _e569 = releaseTime((&param_76), (&param_77), (&param_78), (&param_79), (&param_80));
                            e = (_e562 - _e569);
                            let _e571 = e;
                            if (_e571 <= 0f) {
                                continue;
                            }
                            let _e573 = c_4;
                            let _e574 = k_1;
                            let _e579 = seedOffset_u0028_();
                            param_81 = ((_e573 + (vec2<f32>(0.73f, 0.19f) * f32((_e574 + 1i)))) + _e579);
                            let _e581 = hash32((&param_81));
                            h2_ = _e581;
                            let _e582 = dn_1;
                            near = (1f - _e582);
                            let _e584 = away;
                            let _e585 = dist;
                            let _e590 = h1_[1u];
                            let _e594 = near;
                            let _e596 = (((_e584 / vec2(max(_e585, 0.001f))) * (0.03f + (0.08f * _e590))) * (0.4f + _e594));
                            let _e597 = near;
                            let _e600 = h1_[2u];
                            vel = vec3<f32>(_e596.x, _e596.y, -((0.05f + ((0.2f * _e597) * _e600))));
                            let _e607 = mid_1;
                            let _e611 = vel;
                            let _e612 = e;
                            let _e615 = g_1;
                            let _e617 = e;
                            let _e619 = e;
                            pos = ((vec3<f32>(_e607.x, _e607.y, 0f) + (_e611 * _e612)) - vec3<f32>(0f, (((0.5f * _e615) * _e617) * _e619), 0f));
                            let _e624 = pos[1u];
                            let _e625 = s_1;
                            if ((_e624 + (1.5f * _e625)) < -0.05f) {
                                continue;
                            }
                            let _e630 = h2_[0u];
                            let _e633 = h2_[1u];
                            let _e636 = h2_[2u];
                            axis = normalize((vec3<f32>((_e630 - 0.5f), (_e633 - 0.5f), (0.3f * (_e636 - 0.5f))) + vec3(0.0001f)));
                            let _e644 = h2_[2u];
                            let _e648 = h2_[0u];
                            let _e652 = e;
                            angle_1 = (((3f + (5f * _e644)) * select(1f, -1f, (_e648 < 0.5f))) * _e652);
                            param_82 = vec3<f32>(0f, 0f, -1f);
                            let _e654 = axis;
                            param_83 = _e654;
                            let _e655 = angle_1;
                            param_84 = _e655;
                            let _e656 = rotate((&param_82), (&param_83), (&param_84));
                            n_1 = _e656;
                            let _e657 = e;
                            rel = smoothstep(0f, 0.04f, _e657);
                            let _e659 = ray;
                            let _e660 = n_1;
                            den = dot(_e659, _e660);
                            let _e662 = pos;
                            let _e663 = eye;
                            let _e665 = n_1;
                            let _e667 = den;
                            let _e670 = den;
                            t = (dot((_e662 - _e663), _e665) / select(0.0001f, _e670, (abs(_e667) > 0.0001f)));
                            let _e673 = mid_1;
                            let _e674 = eye;
                            let _e675 = t;
                            let _e676 = ray;
                            let _e679 = pos;
                            let _e681 = angle_1;
                            param_85 = ((_e674 + (_e676 * _e675)) - _e679);
                            let _e683 = axis;
                            param_86 = _e683;
                            param_87 = -(_e681);
                            let _e684 = rotate((&param_85), (&param_86), (&param_87));
                            q_4 = (_e673 + _e684.xy);
                            let _e688 = q_4[0u];
                            let _e690 = uniforms.ratio;
                            let _e692 = q_4[0u];
                            let _e696 = q_4[1u];
                            let _e698 = q_4[1u];
                            border = min(min(_e688, (_e690 - _e692)), min(_e696, (1f - _e698)));
                            let _e702 = q_4;
                            param_88 = _e702;
                            let _e703 = p0_1;
                            param_89 = _e703;
                            let _e704 = p1_1;
                            param_90 = _e704;
                            let _e705 = p2_1;
                            param_91 = _e705;
                            let _e706 = triangleDist((&param_88), (&param_89), (&param_90), (&param_91));
                            inside = _e706;
                            let _e707 = inside;
                            let _e708 = border;
                            ed = min(_e707, _e708);
                            let _e710 = t;
                            let _e712 = t;
                            let _e713 = t2_;
                            let _e716 = t;
                            let _e717 = paneDepth;
                            let _e720 = ed;
                            if ((((_e710 > 0f) && (_e712 < _e713)) && (_e716 < _e717)) && (_e720 > 0f)) {
                                let _e723 = den;
                                if (_e723 > 0f) {
                                    let _e725 = n_1;
                                    local_7 = -(_e725);
                                } else {
                                    let _e727 = n_1;
                                    local_7 = _e727;
                                }
                                let _e728 = local_7;
                                nf = _e728;
                                let _e730 = q_4[0u];
                                let _e732 = uniforms.ratio;
                                let _e735 = q_4[1u];
                                param_92 = vec2<f32>((_e730 / _e732), _e735);
                                let _e737 = getFromColor((&param_92));
                                col_1 = _e737;
                                let _e738 = nf;
                                let _e739 = light;
                                let _e742 = light[2u];
                                let _e746 = rel;
                                let _e748 = col_1;
                                let _e750 = (_e748.xyz * mix(1f, clamp((dot(_e738, _e739) / -(_e742)), 0.45f, 1.1f), _e746));
                                col_1[0u] = _e750.x;
                                col_1[1u] = _e750.y;
                                col_1[2u] = _e750.z;
                                let _e757 = nf;
                                let _e758 = halfway;
                                glint = max(dot(_e757, _e758), 0f);
                                let _e761 = rel;
                                let _e763 = glint;
                                let _e767 = col_1[3u];
                                let _e769 = col_1;
                                let _e772 = (_e769.xyz + vec3((((_e761 * 0.3f) * pow(_e763, 60f)) * _e767)));
                                col_1[0u] = _e772.x;
                                col_1[1u] = _e772.y;
                                col_1[2u] = _e772.z;
                                let _e779 = inside;
                                let _e783 = rel;
                                line_1 = ((0.85f * (1f - smoothstep(0f, 0.0025f, _e779))) * (1f - _e783));
                                let _e786 = rel;
                                let _e788 = ed;
                                let _e792 = glint;
                                bevel = (((0.8f * _e786) * (1f - smoothstep(0f, 0.006f, _e788))) * (0.3f + (0.7f * pow(_e792, 6f))));
                                let _e797 = col_1;
                                let _e800 = col_1[3u];
                                let _e802 = line_1;
                                let _e803 = bevel;
                                let _e806 = mix(_e797.xyz, (vec3<f32>(0.92f, 0.97f, 0.97f) * _e800), vec3(max(_e802, _e803)));
                                col_1[0u] = _e806.x;
                                col_1[1u] = _e806.y;
                                col_1[2u] = _e806.z;
                                let _e813 = ed;
                                let _e815 = rel;
                                cover = mix(1f, smoothstep(0f, 0.0024f, _e813), _e815);
                                let _e817 = t;
                                let _e818 = t1_;
                                if (_e817 < _e818) {
                                    let _e820 = t1_;
                                    t2_ = _e820;
                                    let _e821 = c1_;
                                    c2_ = _e821;
                                    let _e822 = a1_;
                                    a2_ = _e822;
                                    let _e823 = t;
                                    t1_ = _e823;
                                    let _e824 = col_1;
                                    c1_ = _e824;
                                    let _e825 = cover;
                                    a1_ = _e825;
                                } else {
                                    let _e826 = t;
                                    t2_ = _e826;
                                    let _e827 = col_1;
                                    c2_ = _e827;
                                    let _e828 = cover;
                                    a2_ = _e828;
                                }
                            }
                            let _e829 = light;
                            let _e830 = n_1;
                            lden = dot(_e829, _e830);
                            let _e832 = pos;
                            let _e833 = a_2;
                            let _e838 = n_1;
                            let _e840 = lden;
                            let _e843 = lden;
                            ts = (dot((_e832 - vec3<f32>(_e833.x, _e833.y, 0f)), _e838) / select(0.0001f, _e843, (abs(_e840) > 0.0001f)));
                            let _e846 = mid_1;
                            let _e847 = a_2;
                            let _e851 = ts;
                            let _e852 = light;
                            let _e855 = pos;
                            let _e857 = angle_1;
                            param_93 = ((vec3<f32>(_e847.x, _e847.y, 0f) + (_e852 * _e851)) - _e855);
                            let _e859 = axis;
                            param_94 = _e859;
                            param_95 = -(_e857);
                            let _e860 = rotate((&param_93), (&param_94), (&param_95));
                            qs = (_e846 + _e860.xy);
                            let _e863 = qs;
                            param_96 = _e863;
                            let _e864 = p0_1;
                            param_97 = _e864;
                            let _e865 = p1_1;
                            param_98 = _e865;
                            let _e866 = p2_1;
                            param_99 = _e866;
                            let _e867 = triangleDist((&param_96), (&param_97), (&param_98), (&param_99));
                            let _e869 = qs[0u];
                            let _e871 = uniforms.ratio;
                            let _e873 = qs[0u];
                            let _e877 = qs[1u];
                            let _e879 = qs[1u];
                            eds = min(_e867, min(min(_e869, (_e871 - _e873)), min(_e877, (1f - _e879))));
                            let _e884 = ts;
                            let _e886 = eds;
                            if ((_e884 > 0f) && (_e886 > 0f)) {
                                let _e889 = shadow;
                                let _e890 = rel;
                                let _e891 = ts;
                                let _e894 = eds;
                                let _e898 = ts;
                                shadow = max(_e889, (((_e890 * smoothstep(0f, (0.004f + (0.08f * _e891)), _e894)) * 0.45f) * (1f - smoothstep(0.1f, 0.9f, _e898))));
                            }
                            continue;
                        } else {
                            break;
                        }
                        continuing {
                            let _e903 = k_1;
                            k_1 = (_e903 + 1i);
                        }
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e905 = ci;
                    ci = (_e905 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e907 = ri;
            ri = (_e907 + 1i);
        }
    }
    let _e909 = (*uv_2);
    param_100 = _e909;
    let _e910 = getToColor((&param_100));
    back = _e910;
    let _e911 = shadow;
    let _e913 = back;
    let _e915 = (_e913.xyz * (1f - _e911));
    back[0u] = _e915.x;
    back[1u] = _e915.y;
    back[2u] = _e915.z;
    let _e922 = shadow;
    let _e924 = pane;
    let _e926 = (_e924.xyz * (1f - _e922));
    pane[0u] = _e926.x;
    pane[1u] = _e926.y;
    pane[2u] = _e926.z;
    let _e933 = paneDepth;
    if (_e933 == 1f) {
        let _e935 = pane;
        back = _e935;
    }
    let _e936 = c1_;
    let _e937 = a1_;
    let _e939 = c2_;
    let _e940 = a2_;
    let _e941 = a1_;
    let _e946 = back;
    let _e947 = a1_;
    let _e949 = a2_;
    color = (((_e936 * _e937) + (_e939 * min(_e940, (1f - _e941)))) + (_e946 * max(((1f - _e947) - _e949), 0f)));
    let _e954 = a_2;
    param_101 = _e954;
    let _e955 = flash((&param_101));
    let _e957 = color[3u];
    let _e959 = color;
    let _e962 = (_e959.xyz + vec3((_e955 * _e957)));
    color[0u] = _e962.x;
    color[1u] = _e962.y;
    color[2u] = _e962.z;
    let _e969 = color;
    return _e969;
}

fn main_1() {
    var param_102: vec2<f32>;

    let _e94 = _uv_1;
    param_102 = _e94;
    let _e95 = transition((&param_102));
    _fragColor = _e95;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
