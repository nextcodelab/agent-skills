// WarpSpeed — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WarpSpeed.glsl
// Author: gre
// License: MIT
// Description: The camera jumps to light speed: star streaks shoot out from the center and stretch longer and longer while the outgoing image is pulled into a radial smear, then after a flash the incoming image emerges from the center as the streaks shrink back
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    streaks: f32,
    streakColor: vec4<f32>,
    strength: f32,
    flash: f32,
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

    let _e65 = (*p);
    p3_ = fract((_e65.xyx * 0.1031f));
    let _e69 = p3_;
    let _e70 = p3_;
    let _e75 = p3_;
    p3_ = (_e75 + vec3(dot(_e69, (_e70.yzx + vec3(33.33f)))));
    let _e79 = p3_[0u];
    let _e81 = p3_[1u];
    let _e84 = p3_[2u];
    return fract(((_e79 + _e81) * _e84));
}

fn stars(a: ptr<function, f32>, r: ptr<function, f32>, n: ptr<function, f32>, layer: ptr<function, f32>, travel: ptr<function, f32>, speed: ptr<function, f32>, reach: ptr<function, f32>) -> f32 {
    var cell: f32;
    var h1_: f32;
    var param: vec2<f32>;
    var h2_: f32;
    var param_1: vec2<f32>;
    var h3_: f32;
    var param_2: vec2<f32>;
    var life: f32;
    var head: f32;
    var tail: f32;
    var along: f32;
    var inside: f32;
    var profile: f32;
    var f: f32;
    var cellWidth: f32;
    var offset: f32;
    var across: f32;
    var width: f32;
    var x: f32;
    var line: f32;
    var fade: f32;
    var param_3: vec2<f32>;

    let _e92 = (*a);
    let _e93 = (*n);
    cell = floor((_e92 * _e93));
    let _e96 = cell;
    let _e97 = (*layer);
    param = vec2<f32>(_e96, _e97);
    let _e99 = hash((&param));
    h1_ = _e99;
    let _e100 = cell;
    let _e101 = (*layer);
    param_1 = vec2<f32>(_e100, (_e101 + 17f));
    let _e104 = hash((&param_1));
    h2_ = _e104;
    let _e105 = cell;
    let _e106 = (*layer);
    param_2 = vec2<f32>(_e105, (_e106 + 31f));
    let _e109 = hash((&param_2));
    h3_ = _e109;
    let _e110 = h1_;
    let _e111 = (*travel);
    let _e112 = h2_;
    life = fract((_e110 + (_e111 * (0.6f + (0.8f * _e112)))));
    let _e118 = (*reach);
    let _e119 = life;
    head = (_e118 * (0.05f + (1.05f * pow(_e119, 1.4f))));
    let _e124 = head;
    let _e125 = (*speed);
    let _e126 = h3_;
    tail = (_e124 * (1f - min(0.9f, (_e125 * (0.15f + (0.5f * _e126))))));
    let _e133 = (*r);
    let _e134 = tail;
    let _e136 = head;
    let _e137 = tail;
    along = clamp(((_e133 - _e134) / max((_e136 - _e137), 0.0001f)), 0f, 1f);
    let _e142 = tail;
    let _e143 = (*r);
    let _e145 = head;
    let _e147 = head;
    let _e148 = (*r);
    inside = (step(_e142, _e143) * (1f - smoothstep((_e145 - 0.006f), _e147, _e148)));
    let _e152 = inside;
    let _e153 = along;
    let _e155 = along;
    profile = ((_e152 * _e153) * _e155);
    let _e157 = (*a);
    let _e158 = (*n);
    f = fract((_e157 * _e158));
    let _e161 = (*r);
    let _e163 = (*n);
    cellWidth = ((6.2831855f * _e161) / _e163);
    let _e165 = h3_;
    offset = (0.3f + (0.4f * _e165));
    let _e168 = f;
    let _e169 = offset;
    let _e171 = cellWidth;
    across = ((_e168 - _e169) * _e171);
    let _e173 = (*r);
    let _e175 = (*reach);
    let _e178 = cellWidth;
    width = min((0.0014f + ((0.002f * _e173) / _e175)), (0.15f * _e178));
    let _e181 = across;
    let _e182 = across;
    let _e184 = width;
    let _e185 = width;
    x = ((_e181 * _e182) / (_e184 * _e185));
    let _e188 = x;
    let _e191 = x;
    let _e197 = f;
    let _e198 = f;
    line = ((exp(-(_e188)) + (0.25f * exp((-(_e191) / 9f)))) * smoothstep(0f, 0.2f, min(_e197, (1f - _e198))));
    let _e203 = life;
    let _e205 = life;
    fade = (smoothstep(0f, 0.2f, _e203) * (1f - smoothstep(0.9f, 1f, _e205)));
    let _e209 = profile;
    let _e210 = line;
    let _e212 = fade;
    let _e214 = h2_;
    let _e218 = cell;
    let _e219 = (*layer);
    param_3 = vec2<f32>(_e218, (_e219 + 43f));
    let _e222 = hash((&param_3));
    return ((((_e209 * _e210) * _e212) * (0.4f + (0.6f * _e214))) * step(0.25f, _e222));
}

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e65 = (*uv)[0u];
    let _e67 = (*uv)[1u];
    let _e70 = textureSampleLevel(_from, _sampler, vec2<f32>(_e65, (1f - _e67)), 0f);
    return _e70;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e65 = (*uv_1)[0u];
    let _e67 = (*uv_1)[1u];
    let _e70 = textureSampleLevel(_to, _sampler, vec2<f32>(_e65, (1f - _e67)), 0f);
    return _e70;
}

fn smear(uv_2: ptr<function, vec2<f32>>, k: ptr<function, f32>, b: ptr<function, f32>, jitter: ptr<function, f32>, incoming: ptr<function, bool>) -> vec4<f32> {
    var c: vec4<f32>;
    var local: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var sum: vec4<f32>;
    var i: i32;
    var s: f32;
    var q: vec2<f32>;
    var c_1: vec4<f32>;
    var local_1: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;

    let _e80 = (*b);
    let _e82 = (*k);
    if ((_e80 <= 0f) && (_e82 >= 1f)) {
        let _e85 = (*incoming);
        if _e85 {
            let _e86 = (*uv_2);
            param_4 = _e86;
            let _e87 = getToColor((&param_4));
            local = _e87;
        } else {
            let _e88 = (*uv_2);
            param_5 = _e88;
            let _e89 = getFromColor((&param_5));
            local = _e89;
        }
        let _e90 = local;
        c = _e90;
        let _e91 = c;
        let _e94 = c[3u];
        let _e95 = (_e91.xyz * _e94);
        let _e97 = c[3u];
        return vec4<f32>(_e95.x, _e95.y, _e95.z, _e97);
    }
    sum = vec4<f32>(0f, 0f, 0f, 0f);
    i = 0i;
    loop {
        let _e102 = i;
        if (_e102 < 12i) {
            let _e104 = (*k);
            let _e105 = (*b);
            let _e106 = i;
            let _e108 = (*jitter);
            s = (_e104 * (1f - ((_e105 * (f32(_e106) + _e108)) / 12f)));
            let _e115 = uniforms.center;
            let _e116 = (*uv_2);
            let _e118 = uniforms.center;
            let _e120 = s;
            q = (_e115 + ((_e116 - _e118) * _e120));
            let _e123 = (*incoming);
            if _e123 {
                let _e124 = q;
                param_6 = _e124;
                let _e125 = getToColor((&param_6));
                local_1 = _e125;
            } else {
                let _e126 = q;
                param_7 = _e126;
                let _e127 = getFromColor((&param_7));
                local_1 = _e127;
            }
            let _e128 = local_1;
            c_1 = _e128;
            let _e129 = c_1;
            let _e132 = c_1[3u];
            let _e133 = (_e129.xyz * _e132);
            let _e135 = c_1[3u];
            let _e140 = sum;
            sum = (_e140 + vec4<f32>(_e133.x, _e133.y, _e133.z, _e135));
            continue;
        } else {
            break;
        }
        continuing {
            let _e142 = i;
            i = (_e142 + 1i);
        }
    }
    let _e144 = sum;
    return (_e144 / vec4(12f));
}

fn transition(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p_1: f32;
    var aspect: vec2<f32>;
    var d: vec2<f32>;
    var r_1: f32;
    var a_1: f32;
    var far: vec2<f32>;
    var reach_1: f32;
    var speed_1: f32;
    var travel_1: f32;
    var jitter_1: f32;
    var param_8: vec2<f32>;
    var goOut: f32;
    var goIn: f32;
    var soft: f32;
    var edge: f32;
    var m: f32;
    var before: vec4<f32>;
    var after: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: f32;
    var param_11: f32;
    var param_12: f32;
    var param_13: bool;
    var param_14: vec2<f32>;
    var param_15: f32;
    var param_16: f32;
    var param_17: f32;
    var param_18: bool;
    var c_2: vec4<f32>;
    var dark: f32;
    var local_2: f32;
    var n_1: f32;
    var len: f32;
    var s_1: f32;
    var param_19: f32;
    var param_20: f32;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var param_25: f32;
    var param_26: f32;
    var param_27: f32;
    var param_28: f32;
    var param_29: f32;
    var param_30: f32;
    var param_31: f32;
    var param_32: f32;
    var core: f32;
    var peak: f32;
    var glow: f32;
    var light: vec3<f32>;
    var local_3: vec4<f32>;

    let _e118 = uniforms.progress;
    p_1 = _e118;
    let _e120 = uniforms.ratio;
    aspect = vec2<f32>(_e120, 1f);
    let _e122 = (*uv_3);
    let _e124 = uniforms.center;
    let _e126 = aspect;
    d = ((_e122 - _e124) * _e126);
    let _e128 = d;
    r_1 = length(_e128);
    let _e131 = d[1u];
    let _e133 = d[0u];
    a_1 = ((atan2(_e131, (_e133 + 0.000001f)) / 6.2831855f) + 0.5f);
    let _e139 = uniforms.center;
    let _e141 = uniforms.center;
    let _e145 = aspect;
    far = (max(_e139, (vec2(1f) - _e141)) * _e145);
    let _e147 = far;
    reach_1 = length(_e147);
    let _e149 = p_1;
    speed_1 = sin((3.1415927f * _e149));
    let _e152 = speed_1;
    let _e153 = speed_1;
    speed_1 = (_e153 * _e152);
    let _e155 = p_1;
    let _e156 = p_1;
    travel_1 = (3f * (_e155 - (sin((6.2831855f * _e156)) / 6.2831855f)));
    let _e162 = (*uv_3);
    let _e163 = aspect;
    param_8 = floor(((_e162 * _e163) * 997f));
    let _e167 = hash((&param_8));
    jitter_1 = _e167;
    let _e168 = p_1;
    goOut = smoothstep(0f, 0.55f, _e168);
    let _e170 = p_1;
    goIn = (1f - smoothstep(0.45f, 1f, _e170));
    let _e173 = reach_1;
    soft = (0.35f * _e173);
    let _e175 = soft;
    let _e177 = reach_1;
    let _e178 = soft;
    let _e180 = p_1;
    edge = mix(-(_e175), (_e177 + _e178), smoothstep(0.42f, 0.78f, _e180));
    let _e183 = edge;
    let _e184 = soft;
    let _e186 = edge;
    let _e187 = r_1;
    m = (1f - smoothstep((_e183 - _e184), _e186, _e187));
    before = vec4<f32>(0f, 0f, 0f, 0f);
    after = vec4<f32>(0f, 0f, 0f, 0f);
    let _e190 = m;
    if (_e190 < 1f) {
        let _e193 = uniforms.strength;
        let _e195 = goOut;
        let _e197 = goOut;
        let _e201 = uniforms.strength;
        let _e203 = goOut;
        let _e205 = (*uv_3);
        param_9 = _e205;
        param_10 = (1f - (((0.3f * _e193) * _e195) * _e197));
        param_11 = ((0.6f * _e201) * _e203);
        let _e206 = jitter_1;
        param_12 = _e206;
        param_13 = false;
        let _e207 = smear((&param_9), (&param_10), (&param_11), (&param_12), (&param_13));
        before = _e207;
    }
    let _e208 = m;
    if (_e208 > 0f) {
        let _e211 = uniforms.strength;
        let _e213 = goIn;
        let _e215 = goIn;
        let _e219 = uniforms.strength;
        let _e221 = goIn;
        let _e223 = (*uv_3);
        param_14 = _e223;
        param_15 = (1f - (((0.3f * _e211) * _e213) * _e215));
        param_16 = ((0.6f * _e219) * _e221);
        let _e224 = jitter_1;
        param_17 = _e224;
        param_18 = true;
        let _e225 = smear((&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
        after = _e225;
    }
    let _e226 = before;
    let _e227 = after;
    let _e228 = m;
    c_2 = mix(_e226, _e227, vec4(_e228));
    let _e231 = p_1;
    if (_e231 < 0.5f) {
        let _e233 = speed_1;
        local_2 = _e233;
    } else {
        let _e234 = speed_1;
        let _e235 = speed_1;
        let _e237 = speed_1;
        local_2 = ((_e234 * _e235) * _e237);
    }
    let _e239 = local_2;
    dark = _e239;
    let _e241 = uniforms.strength;
    let _e245 = dark;
    let _e248 = c_2;
    let _e250 = (_e248.xyz * (1f - ((0.65f * (0.5f + (0.5f * _e241))) * _e245)));
    c_2[0u] = _e250.x;
    c_2[1u] = _e250.y;
    c_2[2u] = _e250.z;
    let _e258 = uniforms.streaks;
    n_1 = max(floor(_e258), 1f);
    let _e261 = speed_1;
    let _e263 = uniforms.strength;
    len = (_e261 * (0.5f + (1.5f * _e263)));
    let _e267 = a_1;
    param_19 = _e267;
    let _e268 = r_1;
    param_20 = _e268;
    let _e269 = n_1;
    param_21 = _e269;
    param_22 = 1f;
    let _e270 = travel_1;
    param_23 = _e270;
    let _e271 = len;
    param_24 = _e271;
    let _e272 = reach_1;
    param_25 = _e272;
    let _e273 = stars((&param_19), (&param_20), (&param_21), (&param_22), (&param_23), (&param_24), (&param_25));
    s_1 = _e273;
    let _e274 = a_1;
    let _e277 = n_1;
    let _e281 = travel_1;
    param_26 = fract((_e274 + 0.37f));
    let _e283 = r_1;
    param_27 = _e283;
    param_28 = max(floor((_e277 * 0.71f)), 1f);
    param_29 = 2f;
    param_30 = (_e281 * 1.3f);
    let _e284 = len;
    param_31 = _e284;
    let _e285 = reach_1;
    param_32 = _e285;
    let _e286 = stars((&param_26), (&param_27), (&param_28), (&param_29), (&param_30), (&param_31), (&param_32));
    let _e287 = s_1;
    s_1 = (_e287 + _e286);
    let _e289 = r_1;
    let _e290 = reach_1;
    core = (_e289 / (0.35f * _e290));
    let _e293 = p_1;
    peak = ((_e293 - 0.5f) * 9f);
    let _e297 = uniforms.flash;
    let _e298 = peak;
    let _e300 = peak;
    let _e304 = speed_1;
    let _e306 = core;
    let _e308 = core;
    glow = (((_e297 * exp((-(_e298) * _e300))) * _e304) * (0.35f + (0.9f * exp((-(_e306) * _e308)))));
    let _e315 = uniforms.streakColor;
    let _e319 = uniforms.streakColor[3u];
    let _e321 = s_1;
    let _e323 = speed_1;
    let _e325 = glow;
    light = ((_e315.xyz * _e319) * (((2.2f * _e321) * _e323) + _e325));
    let _e329 = c_2[3u];
    if (_e329 > 0f) {
        let _e331 = c_2;
        let _e334 = c_2[3u];
        let _e337 = light;
        let _e341 = clamp(((_e331.xyz / vec3(_e334)) + _e337), vec3(0f), vec3(1f));
        let _e343 = c_2[3u];
        local_3 = vec4<f32>(_e341.x, _e341.y, _e341.z, _e343);
    } else {
        local_3 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e348 = local_3;
    return _e348;
}

fn main_1() {
    var param_33: vec2<f32>;

    let _e64 = _uv_1;
    param_33 = _e64;
    let _e65 = transition((&param_33));
    _fragColor = _e65;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
