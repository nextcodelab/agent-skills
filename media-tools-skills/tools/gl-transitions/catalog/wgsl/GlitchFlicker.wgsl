// GlitchFlicker — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchFlicker.glsl
// Author: bread
// License: MIT
// Description: A flickering glitch with RGB offset, ghosting and scanlines that flashes back to the outgoing image
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    frameRate: f32,
    rgbOffset: f32,
    blockAmount: f32,
    ghostAmount: f32,
    redCyan: f32,
    scanline: f32,
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
    let _e107 = (*uv)[0u];
    let _e109 = (*uv)[1u];
    let _e112 = textureSampleLevel(_to, _sampler, vec2<f32>(_e107, (1f - _e109)), 0f);
    return _e112;
}

fn safeUv(uv_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e106 = (*uv_1);
    return clamp(_e106, vec2<f32>(0.001f, 0.001f), vec2<f32>(0.999f, 0.999f));
}

fn chromaTo(uv_2: ptr<function, vec2<f32>>, amt: ptr<function, f32>) -> vec4<f32> {
    var o: vec2<f32>;
    var center: vec4<f32>;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: vec2<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;

    let _e115 = (*amt);
    o = vec2<f32>(_e115, 0f);
    let _e117 = (*uv_2);
    param = _e117;
    let _e118 = safeUv((&param));
    param_1 = _e118;
    let _e119 = getToColor((&param_1));
    center = _e119;
    let _e120 = (*uv_2);
    let _e121 = o;
    param_2 = (_e120 - _e121);
    let _e123 = safeUv((&param_2));
    param_3 = _e123;
    let _e124 = getToColor((&param_3));
    let _e127 = center[1u];
    let _e128 = (*uv_2);
    let _e129 = o;
    param_4 = (_e128 + _e129);
    let _e131 = safeUv((&param_4));
    param_5 = _e131;
    let _e132 = getToColor((&param_5));
    let _e135 = center[3u];
    return vec4<f32>(_e124.x, _e127, _e132.z, _e135);
}

fn getFromColor(uv_3: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e107 = (*uv_3)[0u];
    let _e109 = (*uv_3)[1u];
    let _e112 = textureSampleLevel(_from, _sampler, vec2<f32>(_e107, (1f - _e109)), 0f);
    return _e112;
}

fn chromaFrom(uv_4: ptr<function, vec2<f32>>, amt_1: ptr<function, f32>) -> vec4<f32> {
    var o_1: vec2<f32>;
    var center_1: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;

    let _e115 = (*amt_1);
    o_1 = vec2<f32>(_e115, 0f);
    let _e117 = (*uv_4);
    param_6 = _e117;
    let _e118 = safeUv((&param_6));
    param_7 = _e118;
    let _e119 = getFromColor((&param_7));
    center_1 = _e119;
    let _e120 = (*uv_4);
    let _e121 = o_1;
    param_8 = (_e120 + _e121);
    let _e123 = safeUv((&param_8));
    param_9 = _e123;
    let _e124 = getFromColor((&param_9));
    let _e127 = center_1[1u];
    let _e128 = (*uv_4);
    let _e129 = o_1;
    param_10 = (_e128 - _e129);
    let _e131 = safeUv((&param_10));
    param_11 = _e131;
    let _e132 = getFromColor((&param_11));
    let _e135 = center_1[3u];
    return vec4<f32>(_e124.x, _e127, _e132.z, _e135);
}

fn sat(x: ptr<function, f32>) -> f32 {
    let _e106 = (*x);
    return clamp(_e106, 0f, 1f);
}

fn hash12(p: ptr<function, vec2<f32>>) -> f32 {
    let _e106 = (*p);
    (*p) = fract((_e106 * vec2<f32>(443.8975f, 397.2973f)));
    let _e109 = (*p);
    let _e110 = (*p);
    let _e115 = (*p);
    (*p) = (_e115 + vec2(dot(_e109, (_e110.yx + vec2(19.19f)))));
    let _e119 = (*p)[0u];
    let _e121 = (*p)[1u];
    return fract((_e119 * _e121));
}

fn blockMask(uv_5: ptr<function, vec2<f32>>, f: ptr<function, f32>) -> f32 {
    var big: vec2<f32>;
    var small: vec2<f32>;
    var wide: f32;
    var param_12: vec2<f32>;
    var chunks: f32;
    var param_13: vec2<f32>;
    var verticalCut: f32;
    var param_14: vec2<f32>;
    var param_15: f32;

    let _e116 = (*uv_5);
    big = floor((_e116 * vec2<f32>(4f, 2f)));
    let _e119 = (*uv_5);
    small = floor((_e119 * vec2<f32>(8f, 4f)));
    let _e123 = big[0u];
    let _e124 = (*f);
    param_12 = vec2<f32>(_e123, (_e124 * 1.37f));
    let _e127 = hash12((&param_12));
    wide = step(0.48f, _e127);
    let _e129 = small;
    let _e130 = (*f);
    let _e132 = (*f);
    param_13 = (_e129 + vec2<f32>((_e130 * 2.11f), (_e132 * 0.73f)));
    let _e136 = hash12((&param_13));
    chunks = step(0.56f, _e136);
    let _e139 = (*uv_5)[0u];
    let _e140 = (*f);
    param_14 = vec2<f32>(_e140, 4.7f);
    let _e142 = hash12((&param_14));
    verticalCut = smoothstep(-0.035f, 0.035f, (_e139 - mix(0.18f, 0.78f, _e142)));
    let _e146 = wide;
    let _e147 = chunks;
    let _e150 = verticalCut;
    param_15 = ((mix(_e146, _e147, 0.38f) * 0.72f) + (_e150 * 0.28f));
    let _e153 = sat((&param_15));
    return _e153;
}

fn frameGlitch(f_1: ptr<function, f32>) -> f32 {
    let _e106 = (*f_1);
    if (_e106 < 0.5f) {
        return 0f;
    }
    let _e108 = (*f_1);
    if (_e108 < 6.5f) {
        return 0.92f;
    }
    let _e110 = (*f_1);
    if (_e110 < 10.5f) {
        return 0.38f;
    }
    let _e112 = (*f_1);
    if (_e112 < 11.5f) {
        return 0.78f;
    }
    let _e114 = (*f_1);
    if (_e114 < 12.5f) {
        return 0.12f;
    }
    let _e116 = (*f_1);
    if (_e116 < 17.5f) {
        return 0.74f;
    }
    let _e118 = (*f_1);
    if (_e118 < 22.5f) {
        return 0.88f;
    }
    let _e120 = (*f_1);
    if (_e120 < 23.5f) {
        return 0.28f;
    }
    return 0f;
}

fn frameReveal(f_2: ptr<function, f32>) -> f32 {
    let _e106 = (*f_2);
    if (_e106 < 0.5f) {
        return 0f;
    }
    let _e108 = (*f_2);
    if (_e108 < 1.5f) {
        return 0.28f;
    }
    let _e110 = (*f_2);
    if (_e110 < 2.5f) {
        return 0.43f;
    }
    let _e112 = (*f_2);
    if (_e112 < 3.5f) {
        return 0.46f;
    }
    let _e114 = (*f_2);
    if (_e114 < 4.5f) {
        return 0.38f;
    }
    let _e116 = (*f_2);
    if (_e116 < 5.5f) {
        return 0.48f;
    }
    let _e118 = (*f_2);
    if (_e118 < 6.5f) {
        return 0.26f;
    }
    let _e120 = (*f_2);
    if (_e120 < 7.5f) {
        return 0.1f;
    }
    let _e122 = (*f_2);
    if (_e122 < 8.5f) {
        return 0f;
    }
    let _e124 = (*f_2);
    if (_e124 < 9.5f) {
        return 0f;
    }
    let _e126 = (*f_2);
    if (_e126 < 10.5f) {
        return 0.3f;
    }
    let _e128 = (*f_2);
    if (_e128 < 11.5f) {
        return 0.58f;
    }
    let _e130 = (*f_2);
    if (_e130 < 12.5f) {
        return 1f;
    }
    let _e132 = (*f_2);
    if (_e132 < 13.5f) {
        return 0.7f;
    }
    let _e134 = (*f_2);
    if (_e134 < 14.5f) {
        return 0.42f;
    }
    let _e136 = (*f_2);
    if (_e136 < 15.5f) {
        return 0.55f;
    }
    let _e138 = (*f_2);
    if (_e138 < 16.5f) {
        return 0.72f;
    }
    let _e140 = (*f_2);
    if (_e140 < 17.5f) {
        return 0.88f;
    }
    let _e142 = (*f_2);
    if (_e142 < 18.5f) {
        return 0.34f;
    }
    let _e144 = (*f_2);
    if (_e144 < 19.5f) {
        return 0.48f;
    }
    let _e146 = (*f_2);
    if (_e146 < 20.5f) {
        return 0.56f;
    }
    let _e148 = (*f_2);
    if (_e148 < 21.5f) {
        return 0.76f;
    }
    let _e150 = (*f_2);
    if (_e150 < 22.5f) {
        return 0.93f;
    }
    return 1f;
}

fn transition(uv_6: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_16: vec2<f32>;
    var param_17: vec2<f32>;
    var f_3: f32;
    var reveal: f32;
    var param_18: f32;
    var glitch: f32;
    var param_19: f32;
    var rnd: f32;
    var param_20: vec2<f32>;
    var jitter: vec2<f32>;
    var param_21: vec2<f32>;
    var fromUv: vec2<f32>;
    var param_22: vec2<f32>;
    var toUv: vec2<f32>;
    var param_23: vec2<f32>;
    var block: f32;
    var param_24: vec2<f32>;
    var param_25: f32;
    var localReveal: f32;
    var param_26: vec2<f32>;
    var param_27: f32;
    var oldClip: vec4<f32>;
    var param_28: vec2<f32>;
    var param_29: f32;
    var newClip: vec4<f32>;
    var param_30: vec2<f32>;
    var param_31: f32;
    var color: vec4<f32>;
    var leftWash: f32;
    var cyanWash: f32;
    var redGhost: vec3<f32>;
    var cyanGhost: vec3<f32>;
    var oldReturn: f32;
    var lines: f32;
    var exposurePulse: f32;
    var param_32: vec2<f32>;
    var param_33: f32;
    var param_34: f32;
    var param_35: f32;

    let _e146 = uniforms.progress;
    if (_e146 <= 0f) {
        let _e148 = (*uv_6);
        param_16 = _e148;
        let _e149 = getFromColor((&param_16));
        return _e149;
    }
    let _e151 = uniforms.progress;
    if (_e151 >= 1f) {
        let _e153 = (*uv_6);
        param_17 = _e153;
        let _e154 = getToColor((&param_17));
        return _e154;
    }
    let _e156 = uniforms.progress;
    let _e158 = uniforms.frameRate;
    f_3 = floor((_e156 * _e158));
    let _e161 = f_3;
    param_18 = _e161;
    let _e162 = frameReveal((&param_18));
    reveal = _e162;
    let _e163 = f_3;
    param_19 = _e163;
    let _e164 = frameGlitch((&param_19));
    glitch = _e164;
    let _e165 = f_3;
    param_20 = vec2<f32>(_e165, 9.13f);
    let _e167 = hash12((&param_20));
    rnd = _e167;
    let _e168 = rnd;
    let _e171 = f_3;
    param_21 = vec2<f32>(_e171, 2.71f);
    let _e173 = hash12((&param_21));
    let _e177 = glitch;
    jitter = (vec2<f32>(((_e168 - 0.5f) * 0.042f), ((_e173 - 0.5f) * 0.01f)) * _e177);
    let _e179 = (*uv_6);
    let _e180 = jitter;
    param_22 = (_e179 + _e180);
    let _e182 = safeUv((&param_22));
    fromUv = _e182;
    let _e183 = (*uv_6);
    let _e184 = jitter;
    param_23 = (_e183 - (_e184 * 0.55f));
    let _e187 = safeUv((&param_23));
    toUv = _e187;
    let _e188 = (*uv_6);
    param_24 = _e188;
    let _e189 = f_3;
    param_25 = _e189;
    let _e190 = blockMask((&param_24), (&param_25));
    block = _e190;
    let _e191 = reveal;
    let _e192 = block;
    let _e195 = uniforms.blockAmount;
    let _e197 = glitch;
    let _e200 = f_3;
    let _e202 = (*uv_6)[1u];
    param_26 = vec2<f32>(_e200, floor((_e202 * 9f)));
    let _e206 = hash12((&param_26));
    let _e209 = glitch;
    param_27 = ((_e191 + (((_e192 - 0.5f) * _e195) * _e197)) + (((_e206 - 0.5f) * 0.18f) * _e209));
    let _e212 = sat((&param_27));
    localReveal = _e212;
    let _e213 = localReveal;
    localReveal = smoothstep(0.22f, 0.78f, _e213);
    let _e216 = uniforms.rgbOffset;
    let _e217 = glitch;
    let _e219 = fromUv;
    param_28 = _e219;
    param_29 = (_e216 * _e217);
    let _e220 = chromaFrom((&param_28), (&param_29));
    oldClip = _e220;
    let _e222 = uniforms.rgbOffset;
    let _e223 = glitch;
    let _e225 = toUv;
    param_30 = _e225;
    param_31 = (_e222 * _e223);
    let _e226 = chromaTo((&param_30), (&param_31));
    newClip = _e226;
    let _e227 = oldClip;
    let _e228 = newClip;
    let _e229 = localReveal;
    color = mix(_e227, _e228, vec4(_e229));
    let _e233 = (*uv_6)[0u];
    let _e236 = glitch;
    leftWash = ((1f - smoothstep(0.1f, 0.78f, _e233)) * _e236);
    let _e239 = (*uv_6)[0u];
    let _e242 = (*uv_6)[0u];
    let _e246 = glitch;
    cyanWash = ((smoothstep(0.08f, 0.62f, _e239) * (1f - smoothstep(0.86f, 1f, _e242))) * _e246);
    let _e248 = oldClip;
    redGhost = (_e248.xyz * vec3<f32>(1.34f, 0.42f, 0.38f));
    let _e251 = newClip;
    cyanGhost = (_e251.xyz * vec3<f32>(0.48f, 1.12f, 1.24f));
    let _e254 = color;
    let _e256 = redGhost;
    let _e257 = leftWash;
    let _e259 = uniforms.redCyan;
    let _e263 = mix(_e254.xyz, _e256, vec3(((_e257 * _e259) * 0.42f)));
    color[0u] = _e263.x;
    color[1u] = _e263.y;
    color[2u] = _e263.z;
    let _e270 = color;
    let _e272 = cyanGhost;
    let _e273 = cyanWash;
    let _e275 = uniforms.redCyan;
    let _e279 = mix(_e270.xyz, _e272, vec3(((_e273 * _e275) * 0.3f)));
    color[0u] = _e279.x;
    color[1u] = _e279.y;
    color[2u] = _e279.z;
    let _e286 = glitch;
    let _e287 = reveal;
    oldReturn = (_e286 * (1f - smoothstep(0.94f, 1f, _e287)));
    let _e291 = localReveal;
    let _e298 = oldReturn;
    oldReturn = (_e298 * (0.18f + (0.52f * (1f - (abs((_e291 - 0.5f)) * 2f)))));
    let _e300 = color;
    let _e302 = oldClip;
    let _e304 = oldReturn;
    let _e306 = uniforms.ghostAmount;
    let _e309 = mix(_e300.xyz, _e302.xyz, vec3((_e304 * _e306)));
    color[0u] = _e309.x;
    color[1u] = _e309.y;
    color[2u] = _e309.z;
    let _e317 = (*uv_6)[1u];
    let _e318 = f_3;
    lines = sin(((_e317 + (_e318 * 0.017f)) * 1080f));
    let _e323 = lines;
    let _e325 = uniforms.scanline;
    let _e327 = glitch;
    let _e329 = color;
    let _e332 = (_e329.xyz + vec3(((_e323 * _e325) * _e327)));
    color[0u] = _e332.x;
    color[1u] = _e332.y;
    color[2u] = _e332.z;
    let _e339 = f_3;
    param_32 = vec2<f32>(_e339, 12.4f);
    let _e341 = hash12((&param_32));
    let _e344 = glitch;
    exposurePulse = (((_e341 - 0.35f) * 0.1f) * _e344);
    let _e346 = exposurePulse;
    let _e347 = color;
    let _e350 = (_e347.xyz + vec3(_e346));
    color[0u] = _e350.x;
    color[1u] = _e350.y;
    color[2u] = _e350.z;
    let _e358 = color[0u];
    param_33 = _e358;
    let _e359 = sat((&param_33));
    let _e361 = color[1u];
    param_34 = _e361;
    let _e362 = sat((&param_34));
    let _e364 = color[2u];
    param_35 = _e364;
    let _e365 = sat((&param_35));
    let _e367 = color[3u];
    return vec4<f32>(_e359, _e362, _e365, _e367);
}

fn main_1() {
    var param_36: vec2<f32>;

    let _e106 = _uv_1;
    param_36 = _e106;
    let _e107 = transition((&param_36));
    _fragColor = _e107;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
