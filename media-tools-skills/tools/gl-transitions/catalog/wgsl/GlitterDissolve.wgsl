// GlitterDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitterDissolve.glsl
// Author: gre
// License: MIT
// Description: The image becomes a shimmering field of tiny diamond sequins that flip over in 3D at random moments, each lifting and tilting on its own axis and flashing a glint of light, and land on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    tiles: f32,
    hexagons: i32,
    sparkle: f32,
    glint: vec3<f32>,
    seed: f32,
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
    let _e70 = (*uv)[0u];
    let _e72 = (*uv)[1u];
    let _e75 = textureSampleLevel(_to, _sampler, vec2<f32>(_e70, (1f - _e72)), 0f);
    return _e75;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e70 = (*uv_1)[0u];
    let _e72 = (*uv_1)[1u];
    let _e75 = textureSampleLevel(_from, _sampler, vec2<f32>(_e70, (1f - _e72)), 0f);
    return _e75;
}

fn mirrored(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    var m: vec2<f32>;

    let _e70 = (*v);
    let _e71 = vec2(2f);
    m = (_e70 - (floor((_e70 / _e71)) * _e71));
    let _e76 = m;
    let _e77 = m;
    let _e80 = m;
    return mix(_e76, (vec2(2f) - _e77), step(vec2(1f), _e80));
}

fn unproject(s: ptr<function, vec2<f32>>, n: ptr<function, vec2<f32>>, f: ptr<function, f32>) -> vec2<f32> {
    var c: f32;
    var along: f32;

    let _e73 = (*f);
    c = abs(cos((3.1415927f * _e73)));
    let _e77 = (*s);
    let _e78 = (*n);
    along = dot(_e77, _e78);
    let _e80 = (*s);
    let _e81 = (*n);
    let _e82 = along;
    let _e83 = c;
    let _e86 = along;
    let _e90 = (*f);
    return ((_e80 + (_e81 * ((_e82 / max(_e83, 0.0001f)) - _e86))) / vec2((1f + (0.3f * sin((3.1415927f * _e90))))));
}

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    var p3_: vec3<f32>;

    let _e70 = (*p);
    p3_ = fract((_e70.xyx * 0.1031f));
    let _e74 = p3_;
    let _e75 = p3_;
    let _e80 = p3_;
    p3_ = (_e80 + vec3(dot(_e74, (_e75.yzx + vec3(33.33f)))));
    let _e84 = p3_[0u];
    let _e86 = p3_[1u];
    let _e89 = p3_[2u];
    return fract(((_e84 + _e86) * _e89));
}

fn axisOf(id: ptr<function, vec2<f32>>) -> vec2<f32> {
    var a: f32;
    var param: vec2<f32>;

    let _e71 = (*id);
    param = (_e71 + vec2(41.7f));
    let _e74 = hash12((&param));
    a = (6.2831855f * _e74);
    let _e76 = a;
    let _e78 = a;
    return vec2<f32>(cos(_e76), sin(_e78));
}

fn flipOf(id_1: ptr<function, vec2<f32>>) -> f32 {
    var t: f32;
    var param_1: vec2<f32>;

    let _e72 = uniforms.progress;
    let _e73 = (*id_1);
    param_1 = _e73;
    let _e74 = hash12((&param_1));
    t = clamp(((_e72 - (_e74 * 0.72f)) / 0.28f), 0f, 1f);
    let _e79 = t;
    let _e80 = t;
    let _e82 = t;
    return ((_e79 * _e80) * (3f - (2f * _e82)));
}

fn idOf(center: ptr<function, vec2<f32>>) -> vec2<f32> {
    var grid: vec2<f32>;

    let _e71 = uniforms.hexagons;
    grid = select(vec2<f32>(2f, 2f), vec2<f32>(1.1547005f, 2f), vec2((_e71 != 0i)));
    let _e75 = (*center);
    let _e76 = grid;
    let _e82 = uniforms.seed;
    return ((floor(((_e75 * _e76) + vec2(0.5f))) + (vec2<f32>(13f, 7f) * floor(_e82))) + vec2(3f));
}

fn tileColor(p_1: ptr<function, vec2<f32>>, center_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    var id_2: vec2<f32>;
    var param_2: vec2<f32>;
    var f_1: f32;
    var param_3: vec2<f32>;
    var n_1: vec2<f32>;
    var param_4: vec2<f32>;
    var c_1: f32;
    var z: f32;
    var s0_: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: f32;
    var suv: vec2<f32>;
    var param_8: vec2<f32>;
    var col: vec4<f32>;
    var local: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var nrm: vec3<f32>;
    var L: vec3<f32>;
    var shade: f32;
    var H: vec3<f32>;
    var spec: f32;
    var light: vec3<f32>;
    var base: vec3<f32>;

    let _e95 = (*center_1);
    param_2 = _e95;
    let _e96 = idOf((&param_2));
    id_2 = _e96;
    let _e97 = id_2;
    param_3 = _e97;
    let _e98 = flipOf((&param_3));
    f_1 = _e98;
    let _e99 = id_2;
    param_4 = _e99;
    let _e100 = axisOf((&param_4));
    n_1 = _e100;
    let _e101 = f_1;
    c_1 = cos((3.1415927f * _e101));
    let _e104 = f_1;
    z = sin((3.1415927f * _e104));
    let _e107 = (*p_1);
    let _e108 = (*center_1);
    param_5 = (_e107 - _e108);
    let _e110 = n_1;
    param_6 = _e110;
    let _e111 = f_1;
    param_7 = _e111;
    let _e112 = unproject((&param_5), (&param_6), (&param_7));
    s0_ = _e112;
    let _e113 = (*center_1);
    let _e114 = s0_;
    let _e118 = uniforms.tiles;
    let _e122 = uniforms.ratio;
    param_8 = (((((_e113 + _e114) - vec2<f32>(0.37f, 0.21f)) / vec2(_e118)) / vec2<f32>(_e122, 1f)) + vec2(0.5f));
    let _e127 = mirrored((&param_8));
    suv = _e127;
    let _e128 = c_1;
    if (_e128 > 0f) {
        let _e130 = suv;
        param_9 = _e130;
        let _e131 = getFromColor((&param_9));
        local = _e131;
    } else {
        let _e132 = suv;
        param_10 = _e132;
        let _e133 = getToColor((&param_10));
        local = _e133;
    }
    let _e134 = local;
    col = _e134;
    let _e135 = n_1;
    let _e136 = z;
    let _e138 = c_1;
    let _e142 = s0_;
    let _e144 = (((_e135 * _e136) * select(1f, -1f, (_e138 < 0f))) + (_e142 * 0.5f));
    let _e145 = c_1;
    nrm = normalize(vec3<f32>(_e144.x, _e144.y, abs(_e145)));
    L = vec3<f32>(-0.26832816f, 0.3577709f, 0.8944272f);
    let _e151 = nrm;
    let _e152 = L;
    let _e155 = L[2u];
    shade = (0.45f + (0.55f * clamp((dot(_e151, _e152) / _e155), 0f, 1.6f)));
    H = vec3<f32>(-0.36681262f, 0.44832653f, 0.8151392f);
    let _e160 = nrm;
    let _e161 = H;
    let _e165 = c_1;
    spec = ((smoothstep(0.94f, 0.995f, dot(_e160, _e161)) * 2f) + (pow((1f - abs(_e165)), 6f) * 0.6f));
    let _e172 = uniforms.glint;
    let _e174 = uniforms.sparkle;
    let _e176 = spec;
    let _e178 = z;
    light = clamp((((_e172 * _e174) * _e176) * _e178), vec3(0f), vec3(1f));
    let _e183 = col;
    let _e185 = shade;
    let _e186 = z;
    base = clamp((_e183.xyz * mix(1f, _e185, _e186)), vec3(0f), vec3(1f));
    let _e192 = base;
    let _e193 = light;
    let _e195 = base;
    let _e196 = light;
    let _e198 = ((_e192 + _e193) - (_e195 * _e196));
    let _e200 = col[3u];
    return vec4<f32>(_e198.x, _e198.y, _e198.z, _e200);
}

fn shape(v_1: ptr<function, vec2<f32>>) -> f32 {
    var local_1: f32;

    let _e70 = (*v_1);
    (*v_1) = abs(_e70);
    let _e73 = uniforms.hexagons;
    if (_e73 != 0i) {
        let _e76 = (*v_1)[1u];
        let _e77 = (*v_1);
        local_1 = max(_e76, dot(_e77, vec2<f32>(0.8660254f, 0.5f)));
    } else {
        let _e81 = (*v_1)[0u];
        let _e83 = (*v_1)[1u];
        local_1 = (_e81 + _e83);
    }
    let _e85 = local_1;
    return _e85;
}

fn coverOf(p_2: ptr<function, vec2<f32>>, center_2: ptr<function, vec2<f32>>) -> f32 {
    var id_3: vec2<f32>;
    var param_11: vec2<f32>;
    var f_2: f32;
    var param_12: vec2<f32>;
    var z_1: f32;
    var onScreen: f32;
    var edge: f32;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var param_15: vec2<f32>;
    var param_16: f32;
    var param_17: vec2<f32>;

    let _e82 = (*center_2);
    param_11 = _e82;
    let _e83 = idOf((&param_11));
    id_3 = _e83;
    let _e84 = id_3;
    param_12 = _e84;
    let _e85 = flipOf((&param_12));
    f_2 = _e85;
    let _e86 = f_2;
    let _e88 = f_2;
    if ((_e86 <= 0f) || (_e88 >= 1f)) {
        return 0f;
    }
    let _e91 = f_2;
    z_1 = sin((3.1415927f * _e91));
    let _e94 = z_1;
    let _e97 = f_2;
    onScreen = ((1f + (0.3f * _e94)) * max(abs(cos((3.1415927f * _e97))), 0.15f));
    let _e103 = z_1;
    edge = ((0.04f * min(1f, (4f * _e103))) + 0.0001f);
    let _e108 = (*p_2);
    let _e109 = (*center_2);
    let _e111 = id_3;
    param_13 = _e111;
    let _e112 = axisOf((&param_13));
    param_14 = (_e108 - _e109);
    param_15 = _e112;
    let _e113 = f_2;
    param_16 = _e113;
    let _e114 = unproject((&param_14), (&param_15), (&param_16));
    param_17 = _e114;
    let _e115 = shape((&param_17));
    let _e117 = onScreen;
    let _e119 = edge;
    return clamp((((0.5f - _e115) * _e117) / _e119), 0f, 1f);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_18: vec2<f32>;
    var param_19: vec2<f32>;
    var p_3: vec2<f32>;
    var s_1: vec2<f32>;
    var a_1: vec2<f32>;
    var b: vec2<f32>;
    var home: vec2<f32>;
    var local_2: vec2<f32>;
    var q: vec2<f32>;
    var fHome: f32;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var under: vec4<f32>;
    var local_3: vec4<f32>;
    var param_22: vec2<f32>;
    var local_4: vec4<f32>;
    var param_23: vec2<f32>;
    var z1_: f32;
    var z2_: f32;
    var cover1_: f32;
    var cover2_: f32;
    var center1_: vec2<f32>;
    var center2_: vec2<f32>;
    var k: i32;
    var fk: f32;
    var off: vec2<f32>;
    var local_5: vec2<f32>;
    var local_6: vec2<f32>;
    var o: vec2<f32>;
    var center_3: vec2<f32>;
    var cover: f32;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var z_2: f32;
    var param_26: vec2<f32>;
    var param_27: vec2<f32>;
    var c_2: vec4<f32>;
    var param_28: vec2<f32>;
    var param_29: vec2<f32>;
    var param_30: vec2<f32>;
    var param_31: vec2<f32>;

    let _e111 = uniforms.progress;
    if (_e111 <= 0f) {
        let _e113 = (*uv_2);
        param_18 = _e113;
        let _e114 = getFromColor((&param_18));
        return _e114;
    }
    let _e116 = uniforms.progress;
    if (_e116 >= 1f) {
        let _e118 = (*uv_2);
        param_19 = _e118;
        let _e119 = getToColor((&param_19));
        return _e119;
    }
    let _e120 = (*uv_2);
    let _e124 = uniforms.ratio;
    let _e128 = uniforms.tiles;
    p_3 = ((((_e120 - vec2(0.5f)) * vec2<f32>(_e124, 1f)) * _e128) + vec2<f32>(0.37f, 0.21f));
    let _e132 = uniforms.hexagons;
    if (_e132 != 0i) {
        s_1 = vec2<f32>(1.7320508f, 1f);
        let _e134 = p_3;
        let _e135 = s_1;
        let _e140 = s_1;
        a_1 = ((_e134 - (floor((_e134 / _e135)) * _e135)) - (_e140 * 0.5f));
        let _e143 = p_3;
        let _e144 = s_1;
        let _e146 = (_e143 - (_e144 * 0.5f));
        let _e147 = s_1;
        let _e152 = s_1;
        b = ((_e146 - (floor((_e146 / _e147)) * _e147)) - (_e152 * 0.5f));
        let _e155 = a_1;
        let _e156 = a_1;
        let _e158 = b;
        let _e159 = b;
        if (dot(_e155, _e156) < dot(_e158, _e159)) {
            let _e162 = p_3;
            let _e163 = a_1;
            local_2 = (_e162 - _e163);
        } else {
            let _e165 = p_3;
            let _e166 = b;
            local_2 = (_e165 - _e166);
        }
        let _e168 = local_2;
        home = _e168;
    } else {
        let _e170 = p_3[0u];
        let _e172 = p_3[1u];
        let _e175 = p_3[1u];
        let _e177 = p_3[0u];
        q = (floor(vec2<f32>((_e170 + _e172), (_e175 - _e177))) + vec2(0.5f));
        let _e184 = q[0u];
        let _e186 = q[1u];
        let _e189 = q[0u];
        let _e191 = q[1u];
        home = (vec2<f32>((_e184 - _e186), (_e189 + _e191)) * 0.5f);
    }
    let _e195 = home;
    param_20 = _e195;
    let _e196 = idOf((&param_20));
    param_21 = _e196;
    let _e197 = flipOf((&param_21));
    fHome = _e197;
    let _e198 = fHome;
    if (_e198 <= 0f) {
        let _e200 = (*uv_2);
        param_22 = _e200;
        let _e201 = getFromColor((&param_22));
        local_3 = _e201;
    } else {
        let _e202 = fHome;
        if (_e202 >= 1f) {
            let _e204 = (*uv_2);
            param_23 = _e204;
            let _e205 = getToColor((&param_23));
            local_4 = _e205;
        } else {
            let _e207 = uniforms.backColor;
            local_4 = _e207;
        }
        let _e208 = local_4;
        local_3 = _e208;
    }
    let _e209 = local_3;
    under = _e209;
    z1_ = -1f;
    z2_ = -1f;
    cover1_ = 0f;
    cover2_ = 0f;
    let _e210 = home;
    center1_ = _e210;
    let _e211 = home;
    center2_ = _e211;
    k = 0i;
    loop {
        let _e212 = k;
        if (_e212 < 9i) {
            let _e214 = k;
            fk = f32(_e214);
            let _e217 = uniforms.hexagons;
            if (_e217 != 0i) {
                let _e219 = k;
                if (_e219 > 6i) {
                    break;
                }
                let _e221 = k;
                if (_e221 == 0i) {
                    local_5 = vec2<f32>(0f, 0f);
                } else {
                    let _e223 = k;
                    if (_e223 < 3i) {
                        let _e225 = fk;
                        local_6 = vec2<f32>(0f, ((_e225 * 2f) - 3f));
                    } else {
                        let _e229 = fk;
                        let _e236 = fk;
                        local_6 = vec2<f32>((((_e229 - (floor((_e229 / 2f)) * 2f)) * 1.7320508f) - 0.8660254f), select(0.5f, -0.5f, (_e236 < 5f)));
                    }
                    let _e240 = local_6;
                    local_5 = _e240;
                }
                let _e241 = local_5;
                off = _e241;
            } else {
                let _e242 = fk;
                let _e248 = fk;
                o = vec2<f32>(((_e242 - (floor((_e242 / 3f)) * 3f)) - 1f), (floor((_e248 / 3f)) - 1f));
                let _e254 = o[0u];
                let _e256 = o[1u];
                let _e259 = o[0u];
                let _e261 = o[1u];
                off = (vec2<f32>((_e254 - _e256), (_e259 + _e261)) * 0.5f);
            }
            let _e265 = home;
            let _e266 = off;
            center_3 = (_e265 + _e266);
            let _e268 = p_3;
            param_24 = _e268;
            let _e269 = center_3;
            param_25 = _e269;
            let _e270 = coverOf((&param_24), (&param_25));
            cover = _e270;
            let _e271 = cover;
            if (_e271 <= 0f) {
                continue;
            }
            let _e273 = center_3;
            param_26 = _e273;
            let _e274 = idOf((&param_26));
            param_27 = _e274;
            let _e275 = flipOf((&param_27));
            z_2 = sin((3.1415927f * _e275));
            let _e278 = z_2;
            let _e279 = z1_;
            if (_e278 > _e279) {
                let _e281 = z1_;
                z2_ = _e281;
                let _e282 = cover1_;
                cover2_ = _e282;
                let _e283 = center1_;
                center2_ = _e283;
                let _e284 = z_2;
                z1_ = _e284;
                let _e285 = cover;
                cover1_ = _e285;
                let _e286 = center_3;
                center1_ = _e286;
            } else {
                let _e287 = z_2;
                let _e288 = z2_;
                if (_e287 > _e288) {
                    let _e290 = z_2;
                    z2_ = _e290;
                    let _e291 = cover;
                    cover2_ = _e291;
                    let _e292 = center_3;
                    center2_ = _e292;
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e293 = k;
            k = (_e293 + 1i);
        }
    }
    let _e295 = z1_;
    if (_e295 < 0f) {
        let _e297 = under;
        return _e297;
    }
    let _e298 = under;
    c_2 = _e298;
    let _e299 = z2_;
    let _e301 = cover1_;
    if ((_e299 >= 0f) && (_e301 < 1f)) {
        let _e304 = c_2;
        let _e305 = p_3;
        param_28 = _e305;
        let _e306 = center2_;
        param_29 = _e306;
        let _e307 = tileColor((&param_28), (&param_29));
        let _e308 = cover2_;
        c_2 = mix(_e304, _e307, vec4(_e308));
    }
    let _e311 = c_2;
    let _e312 = p_3;
    param_30 = _e312;
    let _e313 = center1_;
    param_31 = _e313;
    let _e314 = tileColor((&param_30), (&param_31));
    let _e315 = cover1_;
    return mix(_e311, _e314, vec4(_e315));
}

fn main_1() {
    var param_32: vec2<f32>;

    let _e69 = _uv_1;
    param_32 = _e69;
    let _e70 = transition((&param_32));
    _fragColor = _e70;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
