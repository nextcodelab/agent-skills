// Tumble — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Tumble.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is thrown away like a rigid card, tumbling end over end with a slight spin as it flies off into the distance in perspective, its darker back showing on every flip and its soft shadow shrinking on the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    flips: f32,
    spin: f32,
    direction: vec2<f32>,
    perspective: f32,
    shading: f32,
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
    let _e61 = (*uv)[0u];
    let _e63 = (*uv)[1u];
    let _e66 = textureSampleLevel(_from, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn cardUv(q: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e61 = (*q)[0u];
    let _e63 = uniforms.ratio;
    let _e66 = (*q)[1u];
    return clamp((vec2<f32>((_e61 / _e63), _e66) + vec2(0.5f)), vec2(0f), vec2(1f));
}

fn cardDistance(q_1: ptr<function, vec2<f32>>) -> f32 {
    var e: vec2<f32>;

    let _e61 = (*q_1);
    let _e64 = uniforms.ratio;
    e = (abs(_e61) - vec2<f32>((0.5f * _e64), 0.5f));
    let _e69 = e[0u];
    let _e71 = e[1u];
    return max(_e69, _e71);
}

fn castOnCard(d: ptr<function, vec3<f32>>, rel: ptr<function, vec3<f32>>, U: ptr<function, vec3<f32>>, V: ptr<function, vec3<f32>>, N: ptr<function, vec3<f32>>) -> vec3<f32> {
    var dn: f32;
    var k: f32;
    var h: vec3<f32>;

    let _e67 = (*d);
    let _e68 = (*N);
    dn = dot(_e67, _e68);
    let _e70 = dn;
    if (abs(_e70) < 0.000001f) {
        return vec3<f32>(0f, 0f, -1f);
    }
    let _e73 = (*rel);
    let _e74 = (*N);
    let _e76 = dn;
    k = (dot(_e73, _e74) / _e76);
    let _e78 = k;
    let _e79 = (*d);
    let _e81 = (*rel);
    h = ((_e79 * _e78) - _e81);
    let _e83 = h;
    let _e84 = (*U);
    let _e86 = h;
    let _e87 = (*V);
    let _e89 = k;
    return vec3<f32>(dot(_e83, _e84), dot(_e86, _e87), _e89);
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e61 = (*uv_1)[0u];
    let _e63 = (*uv_1)[1u];
    let _e66 = textureSampleLevel(_to, _sampler, vec2<f32>(_e61, (1f - _e63)), 0f);
    return _e66;
}

fn roll(v: ptr<function, vec3<f32>>, c: ptr<function, f32>, s: ptr<function, f32>) -> vec3<f32> {
    let _e62 = (*c);
    let _e64 = (*v)[0u];
    let _e66 = (*s);
    let _e68 = (*v)[1u];
    let _e71 = (*s);
    let _e73 = (*v)[0u];
    let _e75 = (*c);
    let _e77 = (*v)[1u];
    let _e81 = (*v)[2u];
    return vec3<f32>(((_e62 * _e64) - (_e66 * _e68)), ((_e71 * _e73) + (_e75 * _e77)), _e81);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var t: f32;
    var size: f32;
    var away: f32;
    var turn: f32;
    var a: f32;
    var r: f32;
    var cr: f32;
    var sr: f32;
    var U_1: vec3<f32>;
    var param: vec3<f32>;
    var param_1: f32;
    var param_2: f32;
    var V_1: vec3<f32>;
    var param_3: vec3<f32>;
    var param_4: f32;
    var param_5: f32;
    var N_1: vec3<f32>;
    var param_6: vec3<f32>;
    var param_7: f32;
    var param_8: f32;
    var dist: f32;
    var seen: vec2<f32>;
    var rel_1: vec3<f32>;
    var fade: f32;
    var shadowAmount: f32;
    var p: vec2<f32>;
    var color: vec4<f32>;
    var param_9: vec2<f32>;
    var ds: vec3<f32>;
    var hs: vec3<f32>;
    var param_10: vec3<f32>;
    var param_11: vec3<f32>;
    var param_12: vec3<f32>;
    var param_13: vec3<f32>;
    var param_14: vec3<f32>;
    var blur: f32;
    var sd: f32;
    var param_15: vec2<f32>;
    var sh: f32;
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var d_1: vec3<f32>;
    var hit: vec3<f32>;
    var param_18: vec3<f32>;
    var param_19: vec3<f32>;
    var param_20: vec3<f32>;
    var param_21: vec3<f32>;
    var param_22: vec3<f32>;
    var dn_1: f32;
    var grazing: f32;
    var e_1: f32;
    var m: f32;
    var param_23: vec2<f32>;
    var card: vec4<f32>;
    var param_24: vec2<f32>;
    var param_25: vec2<f32>;
    var front: bool;
    var facing: vec3<f32>;
    var local: vec3<f32>;
    var lit: f32;
    var shade: f32;
    var glint: f32;
    var mixed: vec4<f32>;
    var local_1: vec4<f32>;

    let _e125 = uniforms.progress;
    t = clamp((_e125 / 0.95f), 0f, 1f);
    let _e128 = t;
    let _e130 = t;
    let _e132 = t;
    size = exp((((-2.8f * _e128) * _e130) * (0.4f + (0.6f * _e132))));
    let _e137 = size;
    away = (1f - _e137);
    let _e139 = t;
    let _e140 = t;
    let _e142 = t;
    turn = ((_e139 * _e140) * (3f - (2f * _e142)));
    let _e147 = uniforms.flips;
    let _e149 = turn;
    a = ((6.2831855f * _e147) * _e149);
    let _e152 = uniforms.spin;
    let _e154 = turn;
    r = ((6.2831855f * _e152) * _e154);
    let _e156 = r;
    cr = cos(_e156);
    let _e158 = r;
    sr = sin(_e158);
    param = vec3<f32>(1f, 0f, 0f);
    let _e160 = cr;
    param_1 = _e160;
    let _e161 = sr;
    param_2 = _e161;
    let _e162 = roll((&param), (&param_1), (&param_2));
    U_1 = _e162;
    let _e163 = a;
    let _e165 = a;
    param_3 = vec3<f32>(0f, cos(_e163), sin(_e165));
    let _e168 = cr;
    param_4 = _e168;
    let _e169 = sr;
    param_5 = _e169;
    let _e170 = roll((&param_3), (&param_4), (&param_5));
    V_1 = _e170;
    let _e171 = a;
    let _e174 = a;
    param_6 = vec3<f32>(0f, -(sin(_e171)), cos(_e174));
    let _e177 = cr;
    param_7 = _e177;
    let _e178 = sr;
    param_8 = _e178;
    let _e179 = roll((&param_6), (&param_7), (&param_8));
    N_1 = _e179;
    let _e181 = uniforms.perspective;
    dist = (1f / clamp(_e181, 0.1f, 1f));
    let _e185 = uniforms.direction;
    let _e186 = away;
    let _e188 = t;
    let _e190 = t;
    seen = ((_e185 * _e186) + vec2<f32>(0f, ((0.12f * _e188) * (1f - _e190))));
    let _e195 = seen;
    let _e196 = size;
    let _e198 = (_e195 / vec2(_e196));
    let _e199 = dist;
    let _e200 = size;
    rel_1 = vec3<f32>(_e198.x, _e198.y, (_e199 / _e200));
    let _e205 = t;
    fade = (1f - smoothstep(0.8f, 1f, _e205));
    let _e209 = uniforms.shading;
    let _e211 = size;
    let _e214 = fade;
    shadowAmount = (((0.6f * _e209) * sqrt(_e211)) * _e214);
    let _e217 = (*uv_2)[0u];
    let _e220 = uniforms.ratio;
    let _e223 = (*uv_2)[1u];
    p = vec2<f32>(((_e217 - 0.5f) * _e220), (_e223 - 0.5f));
    let _e226 = (*uv_2);
    param_9 = _e226;
    let _e227 = getToColor((&param_9));
    color = _e227;
    let _e228 = shadowAmount;
    if (_e228 > 0f) {
        let _e230 = p;
        let _e231 = t;
        let _e235 = size;
        let _e237 = (_e230 - ((vec2<f32>(-0.05f, -0.08f) * min((4f * _e231), 1f)) * _e235));
        let _e238 = dist;
        ds = vec3<f32>(_e237.x, _e237.y, _e238);
        let _e242 = ds;
        param_10 = _e242;
        let _e243 = rel_1;
        param_11 = _e243;
        let _e244 = U_1;
        param_12 = _e244;
        let _e245 = V_1;
        param_13 = _e245;
        let _e246 = N_1;
        param_14 = _e246;
        let _e247 = castOnCard((&param_10), (&param_11), (&param_12), (&param_13), (&param_14));
        hs = _e247;
        let _e249 = hs[2u];
        if (_e249 > 0f) {
            let _e251 = t;
            let _e255 = size;
            blur = (0.005f + ((0.06f * min((3f * _e251), 1f)) * _e255));
            let _e258 = hs;
            param_15 = _e258.xy;
            let _e260 = cardDistance((&param_15));
            let _e261 = ds;
            let _e262 = N_1;
            let _e265 = ds;
            let _e271 = hs[2u];
            sd = ((_e260 * max((abs(dot(_e261, _e262)) / length(_e265)), 0.05f)) / _e271);
            let _e273 = blur;
            let _e275 = blur;
            let _e276 = sd;
            let _e279 = hs;
            param_16 = _e279.xy;
            let _e281 = cardUv((&param_16));
            param_17 = _e281;
            let _e282 = getFromColor((&param_17));
            sh = ((1f - smoothstep(-(_e273), _e275, _e276)) * _e282.w);
            let _e285 = shadowAmount;
            let _e286 = sh;
            let _e289 = color;
            let _e291 = (_e289.xyz * (1f - (_e285 * _e286)));
            color[0u] = _e291.x;
            color[1u] = _e291.y;
            color[2u] = _e291.z;
        }
    }
    let _e298 = p;
    let _e299 = dist;
    d_1 = vec3<f32>(_e298.x, _e298.y, _e299);
    let _e303 = d_1;
    param_18 = _e303;
    let _e304 = rel_1;
    param_19 = _e304;
    let _e305 = U_1;
    param_20 = _e305;
    let _e306 = V_1;
    param_21 = _e306;
    let _e307 = N_1;
    param_22 = _e307;
    let _e308 = castOnCard((&param_18), (&param_19), (&param_20), (&param_21), (&param_22));
    hit = _e308;
    let _e310 = hit[2u];
    if (_e310 <= 0f) {
        let _e312 = color;
        return _e312;
    }
    let _e313 = d_1;
    let _e314 = N_1;
    dn_1 = dot(_e313, _e314);
    let _e316 = dn_1;
    let _e318 = d_1;
    grazing = max((abs(_e316) / length(_e318)), 0.05f);
    let _e322 = t;
    let _e327 = hit[2u];
    let _e329 = grazing;
    e_1 = (((0.0015f * min((20f * _e322), 1f)) * _e327) / _e329);
    let _e331 = hit;
    param_23 = _e331.xy;
    let _e333 = cardDistance((&param_23));
    let _e334 = e_1;
    let _e339 = fade;
    m = (clamp((0.5f - (_e333 / max(_e334, 0.000001f))), 0f, 1f) * _e339);
    let _e341 = m;
    if (_e341 <= 0f) {
        let _e343 = color;
        return _e343;
    }
    let _e344 = hit;
    param_24 = _e344.xy;
    let _e346 = cardUv((&param_24));
    param_25 = _e346;
    let _e347 = getFromColor((&param_25));
    card = _e347;
    let _e348 = dn_1;
    front = (_e348 > 0f);
    let _e350 = front;
    if _e350 {
        let _e351 = N_1;
        local = -(_e351);
    } else {
        let _e353 = N_1;
        local = _e353;
    }
    let _e354 = local;
    facing = _e354;
    let _e355 = facing;
    lit = min(((0.35f + (0.65f * max(dot(_e355, vec3<f32>(0.348f, 0.696f, -0.628f)), 0f))) / 0.7582f), 1f);
    let _e362 = lit;
    let _e363 = front;
    let _e367 = uniforms.shading;
    shade = mix(1f, (_e362 * select(0.55f, 1f, _e363)), _e367);
    let _e369 = front;
    if !(_e369) {
        let _e371 = card;
        let _e373 = card;
        let _e378 = uniforms.shading;
        let _e381 = mix(_e371.xyz, vec3(dot(_e373.xyz, vec3<f32>(0.299f, 0.587f, 0.114f))), vec3((0.4f * _e378)));
        card[0u] = _e381.x;
        card[1u] = _e381.y;
        card[2u] = _e381.z;
    }
    let _e388 = facing;
    let _e389 = d_1;
    glint = pow(max(dot(_e388, normalize((vec3<f32>(0.348f, 0.696f, -0.628f) - normalize(_e389)))), 0f), 60f);
    let _e396 = card;
    let _e398 = shade;
    let _e401 = uniforms.shading;
    let _e403 = glint;
    let _e405 = t;
    let _e409 = ((_e396.xyz * _e398) + vec3((((0.35f * _e401) * _e403) * smoothstep(0f, 0.2f, _e405))));
    card[0u] = _e409.x;
    card[1u] = _e409.y;
    card[2u] = _e409.z;
    let _e416 = m;
    if (_e416 >= 1f) {
        let _e418 = card;
        return _e418;
    }
    let _e419 = color;
    let _e422 = color[3u];
    let _e423 = (_e419.xyz * _e422);
    let _e425 = color[3u];
    let _e430 = card;
    let _e433 = card[3u];
    let _e434 = (_e430.xyz * _e433);
    let _e436 = card[3u];
    let _e441 = m;
    mixed = mix(vec4<f32>(_e423.x, _e423.y, _e423.z, _e425), vec4<f32>(_e434.x, _e434.y, _e434.z, _e436), vec4(_e441));
    let _e445 = mixed[3u];
    if (_e445 > 0f) {
        let _e447 = mixed;
        let _e450 = mixed[3u];
        let _e452 = (_e447.xyz / vec3(_e450));
        let _e454 = mixed[3u];
        local_1 = vec4<f32>(_e452.x, _e452.y, _e452.z, _e454);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e459 = local_1;
    return _e459;
}

fn main_1() {
    var param_26: vec2<f32>;

    let _e60 = _uv_1;
    param_26 = _e60;
    let _e61 = transition((&param_26));
    _fragColor = _e61;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
