// Clothesline — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Clothesline.glsl
// Author: gre
// License: MIT
// Description: The camera pulls back to show the outgoing image as a print hung by two clothespins on a line in front of a wall, the line is pulled sideways and carries it away while the incoming print slides in, both prints swinging and tilting like hanging paper, then the camera moves back in on the incoming print until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    direction: f32,
    sway: f32,
    size: f32,
    background: vec4<f32>,
    lineColor: vec4<f32>,
    pinColor: vec4<f32>,
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

fn premultiply(c: ptr<function, vec4<f32>>) -> vec4<f32> {
    let _e88 = (*c);
    let _e91 = (*c)[3u];
    let _e92 = (_e88.xyz * _e91);
    let _e94 = (*c)[3u];
    return vec4<f32>(_e92.x, _e92.y, _e92.z, _e94);
}

fn roundedBox(q: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>, r: ptr<function, f32>) -> f32 {
    var d: vec2<f32>;

    let _e91 = (*q);
    let _e93 = (*b);
    let _e95 = (*r);
    d = ((abs(_e91) - _e93) + vec2(_e95));
    let _e98 = d;
    let _e103 = d[0u];
    let _e105 = d[1u];
    let _e109 = (*r);
    return ((length(max(_e98, vec2(0f))) + min(max(_e103, _e105), 0f)) - _e109);
}

fn pinDist(uv: ptr<function, vec2<f32>>) -> f32 {
    var q_1: vec2<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: f32;

    let _e93 = (*uv)[0u];
    let _e96 = uniforms.ratio;
    let _e100 = (*uv)[1u];
    q_1 = vec2<f32>((abs(_e93) - (0.32f * _e96)), (_e100 - -0.01f));
    let _e103 = q_1;
    param = _e103;
    param_1 = vec2<f32>(0.021f, 0.072f);
    param_2 = 0.012f;
    let _e104 = roundedBox((&param), (&param_1), (&param_2));
    return _e104;
}

fn drawPins(col: ptr<function, vec4<f32>>, h: ptr<function, vec3<f32>>, aa: ptr<function, f32>, vis: ptr<function, f32>) -> vec4<f32> {
    var lp: vec2<f32>;
    var d_1: f32;
    var param_3: vec2<f32>;
    var cov: f32;
    var k: f32;
    var c_1: vec3<f32>;
    var y: f32;
    var spring: f32;
    var pc: vec4<f32>;
    var param_4: vec4<f32>;

    let _e101 = (*h);
    lp = _e101.xy;
    let _e103 = lp;
    param_3 = _e103;
    let _e104 = pinDist((&param_3));
    d_1 = _e104;
    let _e105 = (*vis);
    let _e106 = d_1;
    let _e108 = (*h)[2u];
    let _e109 = (*aa);
    cov = (_e105 * clamp((0.5f - (_e106 / (_e108 * _e109))), 0f, 1f));
    let _e115 = cov;
    if (_e115 > 0f) {
        let _e118 = lp[0u];
        let _e121 = uniforms.ratio;
        k = clamp(((abs(_e118) - (0.32f * _e121)) / 0.021f), -1f, 1f);
        let _e127 = uniforms.pinColor;
        let _e129 = k;
        let _e130 = k;
        c_1 = (_e127.xyz * (0.62f + (0.45f * sqrt((1f - (_e129 * _e130))))));
        let _e138 = lp[1u];
        y = (_e138 - -0.01f);
        let _e140 = y;
        spring = (1f - smoothstep(0.004f, 0.007f, abs((_e140 + 0.02f))));
        let _e145 = c_1;
        let _e146 = k;
        let _e147 = k;
        let _e154 = spring;
        c_1 = mix(_e145, (vec3<f32>(0.3f, 0.31f, 0.33f) * (0.6f + (0.8f * sqrt((1f - (_e146 * _e147)))))), vec3(_e154));
        let _e157 = y;
        let _e164 = c_1;
        c_1 = (_e164 * (1f - (0.3f * (1f - smoothstep(0.002f, 0.005f, abs((_e157 - 0.012f)))))));
        let _e166 = c_1;
        let _e169 = uniforms.pinColor[3u];
        param_4 = vec4<f32>(_e166.x, _e166.y, _e166.z, _e169);
        let _e174 = premultiply((&param_4));
        pc = _e174;
        let _e175 = pc;
        let _e176 = cov;
        let _e178 = (*col);
        let _e180 = pc[3u];
        let _e181 = cov;
        (*col) = ((_e175 * _e176) + (_e178 * (1f - (_e180 * _e181))));
    }
    let _e186 = (*col);
    return _e186;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e89 = (*uv_1)[0u];
    let _e91 = (*uv_1)[1u];
    let _e94 = textureSampleLevel(_to, _sampler, vec2<f32>(_e89, (1f - _e91)), 0f);
    return _e94;
}

fn getFromColor(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e89 = (*uv_2)[0u];
    let _e91 = (*uv_2)[1u];
    let _e94 = textureSampleLevel(_from, _sampler, vec2<f32>(_e89, (1f - _e91)), 0f);
    return _e94;
}

fn bendShift(v: ptr<function, f32>, bend: ptr<function, f32>) -> f32 {
    var h_1: f32;

    let _e90 = (*v);
    h_1 = clamp(_e90, 0f, 1f);
    let _e92 = (*bend);
    let _e93 = h_1;
    let _e95 = h_1;
    return ((_e92 * _e93) * (0.6f + (0.4f * _e95)));
}

fn paperDist(uv_3: ptr<function, vec2<f32>>, bend_1: ptr<function, f32>) -> f32 {
    var q_2: vec2<f32>;
    var param_5: f32;
    var param_6: f32;

    let _e93 = (*uv_3)[0u];
    let _e95 = (*uv_3)[1u];
    param_5 = _e95;
    let _e96 = (*bend_1);
    param_6 = _e96;
    let _e97 = bendShift((&param_5), (&param_6));
    let _e100 = (*uv_3)[1u];
    let _e105 = uniforms.ratio;
    q_2 = (abs(vec2<f32>((_e93 - _e97), (_e100 - 0.5f))) - vec2<f32>((0.5f * _e105), 0.5f));
    let _e109 = q_2;
    let _e114 = q_2[0u];
    let _e116 = q_2[1u];
    return (length(max(_e109, vec2(0f))) + min(max(_e114, _e116), 0f));
}

fn drawPrint(col_1: ptr<function, vec4<f32>>, h_2: ptr<function, vec3<f32>>, isFrom: ptr<function, bool>, bend_2: ptr<function, f32>, psi: ptr<function, f32>, aa_1: ptr<function, f32>, vis_1: ptr<function, f32>) -> vec4<f32> {
    var lp_1: vec2<f32>;
    var d_2: f32;
    var param_7: vec2<f32>;
    var param_8: f32;
    var cov_1: f32;
    var st: vec2<f32>;
    var param_9: f32;
    var param_10: f32;
    var c_2: vec4<f32>;
    var local: vec4<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec4<f32>;
    var shade: f32;
    var ps: f32;
    var param_14: vec2<f32>;

    let _e110 = (*h_2);
    lp_1 = _e110.xy;
    let _e112 = lp_1;
    param_7 = _e112;
    let _e113 = (*bend_2);
    param_8 = _e113;
    let _e114 = paperDist((&param_7), (&param_8));
    d_2 = _e114;
    let _e115 = d_2;
    let _e117 = (*h_2)[2u];
    let _e118 = (*aa_1);
    cov_1 = clamp((0.5f - (_e115 / (_e117 * _e118))), 0f, 1f);
    let _e123 = cov_1;
    if (_e123 > 0f) {
        let _e126 = lp_1[0u];
        let _e128 = lp_1[1u];
        param_9 = _e128;
        let _e129 = (*bend_2);
        param_10 = _e129;
        let _e130 = bendShift((&param_9), (&param_10));
        let _e133 = uniforms.ratio;
        let _e137 = lp_1[1u];
        st = clamp(vec2<f32>((((_e126 - _e130) / _e133) + 0.5f), (1f - _e137)), vec2(0f), vec2(1f));
        let _e143 = (*isFrom);
        if _e143 {
            let _e144 = st;
            param_11 = _e144;
            let _e145 = getFromColor((&param_11));
            local = _e145;
        } else {
            let _e146 = st;
            param_12 = _e146;
            let _e147 = getToColor((&param_12));
            local = _e147;
        }
        let _e148 = local;
        param_13 = _e148;
        let _e149 = premultiply((&param_13));
        c_2 = _e149;
        let _e150 = (*psi);
        let _e155 = lp_1[1u];
        let _e158 = (*bend_2);
        let _e162 = lp_1[1u];
        shade = ((1f - ((1.2f * abs(sin(_e150))) * _e155)) - ((0.35f * abs(_e158)) * _e162));
        let _e165 = lp_1;
        param_14 = (_e165 - vec2<f32>(0.006f, 0.01f));
        let _e167 = pinDist((&param_14));
        ps = _e167;
        let _e168 = (*vis_1);
        let _e170 = ps;
        let _e174 = shade;
        shade = (_e174 - ((0.35f * _e168) * (1f - smoothstep(-0.004f, 0.012f, _e170))));
        let _e176 = shade;
        let _e178 = c_2;
        let _e180 = (_e178.xyz * clamp(_e176, 0f, 1f));
        c_2[0u] = _e180.x;
        c_2[1u] = _e180.y;
        c_2[2u] = _e180.z;
        let _e187 = c_2;
        let _e188 = cov_1;
        let _e190 = (*col_1);
        let _e192 = c_2[3u];
        let _e193 = cov_1;
        (*col_1) = ((_e187 * _e188) + (_e190 * (1f - (_e192 * _e193))));
    }
    let _e198 = (*col_1);
    return _e198;
}

fn printHit(o: ptr<function, vec3<f32>>, d_3: ptr<function, vec3<f32>>, cx: ptr<function, f32>, psi_1: ptr<function, f32>) -> vec3<f32> {
    var dn: vec3<f32>;
    var n: vec3<f32>;
    var p0_: vec3<f32>;
    var t: f32;
    var q_3: vec3<f32>;

    let _e96 = (*psi_1);
    let _e99 = (*psi_1);
    dn = vec3<f32>(0f, -(cos(_e96)), -(sin(_e99)));
    let _e103 = (*psi_1);
    let _e105 = (*psi_1);
    n = vec3<f32>(0f, sin(_e103), -(cos(_e105)));
    let _e109 = (*cx);
    p0_ = vec3<f32>(_e109, 0.5f, 0f);
    let _e111 = p0_;
    let _e112 = (*o);
    let _e114 = n;
    let _e116 = (*d_3);
    let _e117 = n;
    t = (dot((_e111 - _e112), _e114) / dot(_e116, _e117));
    let _e120 = (*o);
    let _e121 = (*d_3);
    let _e122 = t;
    let _e125 = p0_;
    q_3 = ((_e120 + (_e121 * _e122)) - _e125);
    let _e128 = q_3[0u];
    let _e129 = q_3;
    let _e130 = dn;
    let _e132 = t;
    return vec3<f32>(_e128, dot(_e129, _e130), _e132);
}

fn slideTime(p: ptr<function, f32>) -> f32 {
    let _e88 = (*p);
    return clamp(((_e88 - 0.1f) / 0.76f), 0f, 1f);
}

fn slideAccel(p_1: ptr<function, f32>) -> f32 {
    var u: f32;
    var param_15: f32;
    var dur: f32;

    let _e91 = (*p_1);
    param_15 = _e91;
    let _e92 = slideTime((&param_15));
    u = _e92;
    dur = 0.76f;
    let _e93 = u;
    let _e95 = u;
    let _e98 = u;
    let _e102 = dur;
    let _e103 = dur;
    return ((((60f * _e93) * (1f - _e95)) * (1f - (2f * _e98))) / (_e102 * _e103));
}

fn swing(p_2: ptr<function, f32>) -> f32 {
    var x: f32;
    var v_1: f32;
    var i: i32;
    var t0_: f32;
    var dt: f32;
    var a: f32;
    var param_16: f32;

    x = 0f;
    v_1 = 0f;
    i = 0i;
    loop {
        let _e95 = i;
        if (_e95 < 32i) {
            let _e97 = i;
            t0_ = (f32(_e97) * 0.03125f);
            let _e100 = (*p_2);
            let _e101 = t0_;
            dt = clamp((_e100 - _e101), 0f, 0.03125f);
            let _e104 = t0_;
            let _e105 = dt;
            param_16 = (_e104 + (0.5f * _e105));
            let _e108 = slideAccel((&param_16));
            let _e109 = x;
            let _e112 = v_1;
            a = ((_e108 - (100f * _e109)) - (5.6f * _e112));
            let _e115 = a;
            let _e116 = dt;
            let _e118 = v_1;
            v_1 = (_e118 + (_e115 * _e116));
            let _e120 = v_1;
            let _e121 = dt;
            let _e123 = x;
            x = (_e123 + (_e120 * _e121));
            continue;
        } else {
            break;
        }
        continuing {
            let _e125 = i;
            i = (_e125 + 1i);
        }
    }
    let _e127 = x;
    let _e128 = (*p_2);
    return (_e127 * (1f - smoothstep(0.7f, 1f, _e128)));
}

fn slideAmount(u_1: ptr<function, f32>) -> f32 {
    let _e88 = (*u_1);
    let _e89 = (*u_1);
    let _e91 = (*u_1);
    let _e93 = (*u_1);
    let _e94 = (*u_1);
    return (((_e88 * _e89) * _e91) * ((_e93 * ((_e94 * 6f) - 15f)) + 10f));
}

fn transition(uv_4: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_3: f32;
    var s: f32;
    var sw: f32;
    var back: f32;
    var zoom: f32;
    var vis_2: f32;
    var o_1: vec3<f32>;
    var d_4: vec3<f32>;
    var aa_2: f32;
    var u_2: f32;
    var param_17: f32;
    var m: f32;
    var param_18: f32;
    var speed: f32;
    var spacing: f32;
    var cFrom: f32;
    var cTo: f32;
    var bend_3: f32;
    var param_19: f32;
    var psi_2: f32;
    var hf: vec3<f32>;
    var param_20: vec3<f32>;
    var param_21: vec3<f32>;
    var param_22: f32;
    var param_23: f32;
    var ht: vec3<f32>;
    var param_24: vec3<f32>;
    var param_25: vec3<f32>;
    var param_26: f32;
    var param_27: f32;
    var col_2: vec4<f32>;
    var param_28: vec4<f32>;
    var cover: f32;
    var param_29: vec2<f32>;
    var param_30: f32;
    var param_31: vec2<f32>;
    var param_32: f32;
    var w: vec3<f32>;
    var sf: vec3<f32>;
    var param_33: vec3<f32>;
    var param_34: vec3<f32>;
    var param_35: f32;
    var param_36: f32;
    var st_1: vec3<f32>;
    var param_37: vec3<f32>;
    var param_38: vec3<f32>;
    var param_39: f32;
    var param_40: f32;
    var blur: f32;
    var sh: f32;
    var param_41: vec2<f32>;
    var param_42: f32;
    var param_43: vec2<f32>;
    var param_44: f32;
    var param_45: vec2<f32>;
    var param_46: vec2<f32>;
    var ry: f32;
    var fall: f32;
    var param_47: vec4<f32>;
    var param_48: vec3<f32>;
    var param_49: bool;
    var param_50: f32;
    var param_51: f32;
    var param_52: f32;
    var param_53: f32;
    var param_54: vec4<f32>;
    var param_55: vec3<f32>;
    var param_56: bool;
    var param_57: f32;
    var param_58: f32;
    var param_59: f32;
    var param_60: f32;
    var tl: f32;
    var ly: f32;
    var lc: f32;
    var k_1: f32;
    var lx: f32;
    var strand: f32;
    var c_3: vec3<f32>;
    var lcp: vec4<f32>;
    var param_61: vec4<f32>;
    var param_62: vec4<f32>;
    var param_63: vec3<f32>;
    var param_64: f32;
    var param_65: f32;
    var param_66: vec4<f32>;
    var param_67: vec3<f32>;
    var param_68: f32;
    var param_69: f32;
    var local_1: vec4<f32>;

    let _e179 = uniforms.progress;
    p_3 = _e179;
    let _e181 = uniforms.direction;
    s = select(1f, -1f, (_e181 < 0f));
    let _e185 = uniforms.sway;
    sw = clamp(_e185, 0f, 1f);
    let _e187 = p_3;
    let _e189 = p_3;
    back = (smoothstep(0f, 0.3f, _e187) * (1f - smoothstep(0.6f, 1f, _e189)));
    let _e194 = uniforms.size;
    let _e196 = back;
    zoom = mix(1f, clamp(_e194, 0.1f, 1f), _e196);
    let _e198 = back;
    vis_2 = smoothstep(0f, 0.35f, _e198);
    let _e200 = back;
    let _e202 = zoom;
    o_1 = vec3<f32>(0f, (0.05f * _e200), (2f / _e202));
    let _e205 = (*uv_4);
    let _e209 = uniforms.ratio;
    let _e211 = ((_e205 - vec2(0.5f)) * vec2<f32>(_e209, 1f));
    d_4 = vec3<f32>(_e211.x, _e211.y, -2f);
    let _e215 = back;
    aa_2 = max((0.0015f * min(1f, (40f * _e215))), 0.000001f);
    let _e220 = p_3;
    param_17 = _e220;
    let _e221 = slideTime((&param_17));
    u_2 = _e221;
    let _e222 = u_2;
    param_18 = _e222;
    let _e223 = slideAmount((&param_18));
    m = _e223;
    let _e224 = u_2;
    let _e226 = u_2;
    let _e228 = u_2;
    let _e231 = u_2;
    speed = ((((16f * _e224) * _e226) * (1f - _e228)) * (1f - _e231));
    let _e235 = uniforms.ratio;
    spacing = (_e235 + 0.35f);
    let _e237 = s;
    let _e239 = spacing;
    let _e241 = m;
    cFrom = ((-(_e237) * _e239) * _e241);
    let _e243 = s;
    let _e244 = spacing;
    let _e246 = m;
    cTo = ((_e243 * _e244) * (1f - _e246));
    let _e249 = s;
    let _e251 = sw;
    let _e253 = p_3;
    param_19 = _e253;
    let _e254 = swing((&param_19));
    bend_3 = (((_e249 * 0.65f) * _e251) * _e254);
    let _e256 = sw;
    let _e258 = speed;
    psi_2 = ((0.45f * _e256) * _e258);
    let _e260 = o_1;
    param_20 = _e260;
    let _e261 = d_4;
    param_21 = _e261;
    let _e262 = cFrom;
    param_22 = _e262;
    let _e263 = psi_2;
    param_23 = _e263;
    let _e264 = printHit((&param_20), (&param_21), (&param_22), (&param_23));
    hf = _e264;
    let _e265 = o_1;
    param_24 = _e265;
    let _e266 = d_4;
    param_25 = _e266;
    let _e267 = cTo;
    param_26 = _e267;
    let _e268 = psi_2;
    param_27 = _e268;
    let _e269 = printHit((&param_24), (&param_25), (&param_26), (&param_27));
    ht = _e269;
    let _e271 = uniforms.background;
    param_28 = _e271;
    let _e272 = premultiply((&param_28));
    col_2 = _e272;
    let _e273 = hf;
    param_29 = _e273.xy;
    let _e275 = bend_3;
    param_30 = _e275;
    let _e276 = paperDist((&param_29), (&param_30));
    let _e278 = hf[2u];
    let _e279 = aa_2;
    let _e284 = ht;
    param_31 = _e284.xy;
    let _e286 = bend_3;
    param_32 = _e286;
    let _e287 = paperDist((&param_31), (&param_32));
    let _e289 = ht[2u];
    let _e290 = aa_2;
    cover = max(clamp((0.5f - (_e276 / (_e278 * _e279))), 0f, 1f), clamp((0.5f - (_e287 / (_e289 * _e290))), 0f, 1f));
    let _e296 = back;
    let _e297 = cover;
    let _e299 = col_2;
    col_2 = (_e299 * mix(1f, _e296, _e297));
    let _e301 = back;
    if (_e301 > 0f) {
        let _e303 = o_1;
        let _e304 = d_4;
        let _e306 = o_1[2u];
        w = (_e303 + (_e304 * ((_e306 + 0.14f) / 2f)));
        let _e311 = w;
        param_33 = _e311;
        param_34 = vec3<f32>(-0.28f, 0.48f, 0.83f);
        let _e312 = cFrom;
        param_35 = _e312;
        let _e313 = psi_2;
        param_36 = _e313;
        let _e314 = printHit((&param_33), (&param_34), (&param_35), (&param_36));
        sf = _e314;
        let _e315 = w;
        param_37 = _e315;
        param_38 = vec3<f32>(-0.28f, 0.48f, 0.83f);
        let _e316 = cTo;
        param_39 = _e316;
        let _e317 = psi_2;
        param_40 = _e317;
        let _e318 = printHit((&param_37), (&param_38), (&param_39), (&param_40));
        st_1 = _e318;
        blur = 0.025f;
        let _e319 = blur;
        let _e321 = blur;
        let _e322 = sf;
        param_41 = _e322.xy;
        let _e324 = bend_3;
        param_42 = _e324;
        let _e325 = paperDist((&param_41), (&param_42));
        let _e326 = st_1;
        param_43 = _e326.xy;
        let _e328 = bend_3;
        param_44 = _e328;
        let _e329 = paperDist((&param_43), (&param_44));
        sh = (1f - smoothstep(-(_e319), _e321, min(_e325, _e329)));
        let _e333 = sh;
        let _e334 = sf;
        param_45 = _e334.xy;
        let _e336 = pinDist((&param_45));
        let _e337 = st_1;
        param_46 = _e337.xy;
        let _e339 = pinDist((&param_46));
        sh = max(_e333, (1f - smoothstep(-0.012f, 0.02f, min(_e336, _e339))));
        let _e345 = w[1u];
        ry = ((_e345 + 0.08096386f) - 0.488f);
        let _e348 = sh;
        let _e349 = ry;
        sh = max(_e348, (0.8f * (1f - smoothstep(0f, 0.012f, abs(_e349)))));
        let _e355 = w;
        let _e358 = uniforms.ratio;
        let _e364 = uniforms.ratio;
        fall = (0.1f * clamp((length((_e355.xy - vec2<f32>((-0.4f * _e358), 0.6f))) / ((1.2f * _e364) + 0.6f)), 0f, 1f));
        let _e370 = vis_2;
        let _e372 = sh;
        let _e375 = fall;
        let _e376 = vis_2;
        let _e380 = col_2;
        let _e382 = (_e380.xyz * ((1f - ((0.42f * _e370) * _e372)) * (1f - (_e375 * _e376))));
        col_2[0u] = _e382.x;
        col_2[1u] = _e382.y;
        col_2[2u] = _e382.z;
    }
    let _e389 = col_2;
    param_47 = _e389;
    let _e390 = hf;
    param_48 = _e390;
    param_49 = true;
    let _e391 = bend_3;
    param_50 = _e391;
    let _e392 = psi_2;
    param_51 = _e392;
    let _e393 = aa_2;
    param_52 = _e393;
    let _e394 = vis_2;
    param_53 = _e394;
    let _e395 = drawPrint((&param_47), (&param_48), (&param_49), (&param_50), (&param_51), (&param_52), (&param_53));
    col_2 = _e395;
    let _e396 = col_2;
    param_54 = _e396;
    let _e397 = ht;
    param_55 = _e397;
    param_56 = false;
    let _e398 = bend_3;
    param_57 = _e398;
    let _e399 = psi_2;
    param_58 = _e399;
    let _e400 = aa_2;
    param_59 = _e400;
    let _e401 = vis_2;
    param_60 = _e401;
    let _e402 = drawPrint((&param_54), (&param_55), (&param_56), (&param_57), (&param_58), (&param_59), (&param_60));
    col_2 = _e402;
    let _e403 = vis_2;
    if (_e403 > 0f) {
        let _e406 = o_1[2u];
        tl = ((_e406 - 0.004f) / 2f);
        let _e410 = o_1[1u];
        let _e412 = d_4[1u];
        let _e413 = tl;
        ly = ((_e410 + (_e412 * _e413)) - 0.488f);
        let _e417 = vis_2;
        let _e418 = ly;
        let _e421 = tl;
        let _e422 = aa_2;
        lc = (_e417 * clamp((0.5f - ((abs(_e418) - 0.0055f) / (_e421 * _e422))), 0f, 1f));
        let _e428 = lc;
        if (_e428 > 0f) {
            let _e430 = ly;
            k_1 = clamp((_e430 / 0.0055f), -1f, 1f);
            let _e434 = o_1[0u];
            let _e436 = d_4[0u];
            let _e437 = tl;
            let _e440 = s;
            let _e441 = spacing;
            let _e443 = m;
            lx = ((_e434 + (_e436 * _e437)) + ((_e440 * _e441) * _e443));
            let _e446 = lx;
            let _e447 = ly;
            strand = (0.88f + (0.12f * sin(((_e446 + (_e447 * 0.6f)) * 360f))));
            let _e455 = uniforms.lineColor;
            let _e457 = k_1;
            let _e458 = k_1;
            let _e464 = k_1;
            let _e468 = strand;
            c_3 = ((_e455.xyz * ((0.7f + (0.45f * sqrt((1f - (_e457 * _e458))))) + (0.15f * _e464))) * _e468);
            let _e470 = c_3;
            let _e473 = uniforms.lineColor[3u];
            param_61 = vec4<f32>(_e470.x, _e470.y, _e470.z, _e473);
            let _e478 = premultiply((&param_61));
            lcp = _e478;
            let _e479 = lcp;
            let _e480 = lc;
            let _e482 = col_2;
            let _e484 = lcp[3u];
            let _e485 = lc;
            col_2 = ((_e479 * _e480) + (_e482 * (1f - (_e484 * _e485))));
        }
        let _e490 = col_2;
        param_62 = _e490;
        let _e491 = hf;
        param_63 = _e491;
        let _e492 = aa_2;
        param_64 = _e492;
        let _e493 = vis_2;
        param_65 = _e493;
        let _e494 = drawPins((&param_62), (&param_63), (&param_64), (&param_65));
        col_2 = _e494;
        let _e495 = col_2;
        param_66 = _e495;
        let _e496 = ht;
        param_67 = _e496;
        let _e497 = aa_2;
        param_68 = _e497;
        let _e498 = vis_2;
        param_69 = _e498;
        let _e499 = drawPins((&param_66), (&param_67), (&param_68), (&param_69));
        col_2 = _e499;
    }
    let _e501 = col_2[3u];
    if (_e501 > 0f) {
        let _e503 = col_2;
        let _e506 = col_2[3u];
        let _e508 = (_e503.xyz / vec3(_e506));
        let _e510 = col_2[3u];
        local_1 = vec4<f32>(_e508.x, _e508.y, _e508.z, _e510);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e515 = local_1;
    return _e515;
}

fn main_1() {
    var param_70: vec2<f32>;

    let _e88 = _uv_1;
    param_70 = _e88;
    let _e89 = transition((&param_70));
    _fragColor = _e89;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
