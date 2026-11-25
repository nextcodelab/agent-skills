// StripDatamoshGlitch — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StripDatamoshGlitch.glsl
// Author: bread
// License: MIT
// Description: A datamosh glitch: torn strips, chroma shifts and scan noise drag the outgoing image into the incoming one
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    strength: f32,
    horizontalBars: f32,
    verticalSlits: f32,
    tear: f32,
    chroma: f32,
    residue: f32,
    noiseAmount: f32,
    scanAmount: f32,
    flashAmount: f32,
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

fn hash_u0028_vf2_u003b(p: ptr<function, vec2<f32>>) -> f32 {
    let _e108 = (*p);
    return fract((sin(dot(_e108, vec2<f32>(127.1f, 311.7f))) * 43758.547f));
}

fn stripeY(uv: ptr<function, vec2<f32>>, density: ptr<function, f32>, seed: ptr<function, f32>, minWidth: ptr<function, f32>, maxWidth: ptr<function, f32>) -> f32 {
    var y: f32;
    var id: f32;
    var f: f32;
    var c: f32;
    var param: vec2<f32>;
    var w: f32;
    var param_1: vec2<f32>;

    let _e120 = (*uv)[1u];
    let _e121 = (*density);
    let _e123 = (*seed);
    y = ((_e120 * _e121) + (_e123 * 0.137f));
    let _e126 = y;
    id = floor(_e126);
    let _e128 = y;
    f = fract(_e128);
    let _e130 = id;
    let _e131 = (*seed);
    param = vec2<f32>(_e130, _e131);
    let _e133 = hash_u0028_vf2_u003b((&param));
    c = _e133;
    let _e134 = (*minWidth);
    let _e135 = (*maxWidth);
    let _e136 = id;
    let _e138 = (*seed);
    param_1 = vec2<f32>((_e136 + 9.17f), (_e138 + 2.31f));
    let _e141 = hash_u0028_vf2_u003b((&param_1));
    w = mix(_e134, _e135, _e141);
    let _e143 = w;
    let _e144 = w;
    let _e146 = f;
    let _e147 = c;
    return (1f - smoothstep(_e143, (_e144 + 0.018f), abs((_e146 - _e147))));
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e109 = (*uv_1)[0u];
    let _e111 = (*uv_1)[1u];
    let _e114 = textureSampleLevel(_to, _sampler, vec2<f32>(_e109, (1f - _e111)), 0f);
    return _e114;
}

fn safeUv(uv_2: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e108 = (*uv_2);
    return clamp(_e108, vec2<f32>(0f, 0f), vec2<f32>(1f, 1f));
}

fn chromaTo(uv_3: ptr<function, vec2<f32>>, s: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_2: vec2<f32>;
    var center: vec4<f32>;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: vec2<f32>;

    let _e116 = (*uv_3);
    param_2 = _e116;
    let _e117 = safeUv((&param_2));
    (*uv_3) = _e117;
    let _e118 = (*uv_3);
    param_3 = _e118;
    let _e119 = getToColor((&param_3));
    center = _e119;
    let _e120 = (*uv_3);
    let _e121 = (*s);
    param_4 = (_e120 - _e121);
    let _e123 = safeUv((&param_4));
    param_5 = _e123;
    let _e124 = getToColor((&param_5));
    let _e127 = center[1u];
    let _e128 = (*uv_3);
    let _e129 = (*s);
    param_6 = (_e128 + _e129);
    let _e131 = safeUv((&param_6));
    param_7 = _e131;
    let _e132 = getToColor((&param_7));
    let _e135 = center[3u];
    return vec4<f32>(_e124.x, _e127, _e132.z, _e135);
}

fn getFromColor(uv_4: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e109 = (*uv_4)[0u];
    let _e111 = (*uv_4)[1u];
    let _e114 = textureSampleLevel(_from, _sampler, vec2<f32>(_e109, (1f - _e111)), 0f);
    return _e114;
}

fn chromaFrom(uv_5: ptr<function, vec2<f32>>, s_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_8: vec2<f32>;
    var center_1: vec4<f32>;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var param_12: vec2<f32>;
    var param_13: vec2<f32>;

    let _e116 = (*uv_5);
    param_8 = _e116;
    let _e117 = safeUv((&param_8));
    (*uv_5) = _e117;
    let _e118 = (*uv_5);
    param_9 = _e118;
    let _e119 = getFromColor((&param_9));
    center_1 = _e119;
    let _e120 = (*uv_5);
    let _e121 = (*s_1);
    param_10 = (_e120 + _e121);
    let _e123 = safeUv((&param_10));
    param_11 = _e123;
    let _e124 = getFromColor((&param_11));
    let _e127 = center_1[1u];
    let _e128 = (*uv_5);
    let _e129 = (*s_1);
    param_12 = (_e128 - _e129);
    let _e131 = safeUv((&param_12));
    param_13 = _e131;
    let _e132 = getFromColor((&param_13));
    let _e135 = center_1[3u];
    return vec4<f32>(_e124.x, _e127, _e132.z, _e135);
}

fn distortUv(uv_6: ptr<function, vec2<f32>>, dir: ptr<function, f32>, b: ptr<function, f32>, h: ptr<function, f32>, v: ptr<function, f32>, frame: ptr<function, f32>) -> vec2<f32> {
    var row: f32;
    var col: f32;
    var rowRnd: f32;
    var param_14: vec2<f32>;
    var colRnd: f32;
    var param_15: vec2<f32>;
    var xTear: f32;
    var yDrag: f32;
    var micro: f32;
    var param_16: vec2<f32>;

    let _e124 = (*uv_6)[1u];
    let _e126 = uniforms.horizontalBars;
    row = floor((_e124 * _e126));
    let _e130 = (*uv_6)[0u];
    let _e132 = uniforms.verticalSlits;
    col = floor((_e130 * _e132));
    let _e135 = row;
    let _e136 = (*frame);
    param_14 = vec2<f32>(_e135, _e136);
    let _e138 = hash_u0028_vf2_u003b((&param_14));
    rowRnd = _e138;
    let _e139 = col;
    let _e140 = (*frame);
    param_15 = vec2<f32>(_e139, (_e140 + 27f));
    let _e143 = hash_u0028_vf2_u003b((&param_15));
    colRnd = _e143;
    let _e144 = rowRnd;
    let _e148 = uniforms.tear;
    let _e150 = (*b);
    let _e152 = (*h);
    xTear = (((((_e144 - 0.5f) * 2f) * _e148) * _e150) * _e152);
    let _e155 = (*uv_6)[1u];
    let _e158 = uniforms.progress;
    let _e163 = (*b);
    let _e165 = xTear;
    xTear = (_e165 + ((sin(((_e155 * 120f) + (_e158 * 95f))) * 0.006f) * _e163));
    let _e167 = colRnd;
    let _e170 = (*b);
    let _e172 = (*v);
    yDrag = ((((_e167 - 0.5f) * 0.13f) * _e170) * _e172);
    let _e174 = row;
    let _e175 = col;
    let _e176 = (*frame);
    param_16 = vec2<f32>(_e174, (_e175 + _e176));
    let _e179 = hash_u0028_vf2_u003b((&param_16));
    let _e182 = (*b);
    let _e184 = (*h);
    let _e185 = (*v);
    micro = ((((_e179 - 0.5f) * 0.018f) * _e182) * max(_e184, _e185));
    let _e188 = (*uv_6);
    let _e189 = xTear;
    let _e190 = (*dir);
    let _e192 = micro;
    let _e194 = yDrag;
    return (_e188 + vec2<f32>(((_e189 * _e190) + _e192), _e194));
}

fn sat(v_1: ptr<function, f32>) -> f32 {
    let _e108 = (*v_1);
    return clamp(_e108, 0f, 1f);
}

fn stripeX(uv_7: ptr<function, vec2<f32>>, density_1: ptr<function, f32>, seed_1: ptr<function, f32>, minWidth_1: ptr<function, f32>, maxWidth_1: ptr<function, f32>) -> f32 {
    var x: f32;
    var id_1: f32;
    var f_1: f32;
    var c_1: f32;
    var param_17: vec2<f32>;
    var w_1: f32;
    var param_18: vec2<f32>;

    let _e120 = (*uv_7)[0u];
    let _e121 = (*density_1);
    let _e123 = (*seed_1);
    x = ((_e120 * _e121) + (_e123 * 0.091f));
    let _e126 = x;
    id_1 = floor(_e126);
    let _e128 = x;
    f_1 = fract(_e128);
    let _e130 = id_1;
    let _e131 = (*seed_1);
    param_17 = vec2<f32>(_e130, (_e131 + 41f));
    let _e134 = hash_u0028_vf2_u003b((&param_17));
    c_1 = _e134;
    let _e135 = (*minWidth_1);
    let _e136 = (*maxWidth_1);
    let _e137 = id_1;
    let _e139 = (*seed_1);
    param_18 = vec2<f32>((_e137 + 4.7f), (_e139 + 8.9f));
    let _e142 = hash_u0028_vf2_u003b((&param_18));
    w_1 = mix(_e135, _e136, _e142);
    let _e144 = w_1;
    let _e145 = w_1;
    let _e147 = f_1;
    let _e148 = c_1;
    return (1f - smoothstep(_e144, (_e145 + 0.012f), abs((_e147 - _e148))));
}

fn hash_u0028_f1_u003b(n: ptr<function, f32>) -> f32 {
    let _e108 = (*n);
    return fract((sin(_e108) * 43758.547f));
}

fn verticalMask(uv_8: ptr<function, vec2<f32>>, frame_1: ptr<function, f32>) -> f32 {
    var col_1: f32;
    var param_19: f32;
    var slit: f32;
    var param_20: vec2<f32>;
    var param_21: f32;
    var param_22: f32;
    var param_23: f32;
    var param_24: f32;
    var param_25: vec2<f32>;
    var param_26: f32;

    let _e120 = (*uv_8)[0u];
    let _e121 = (*frame_1);
    param_19 = (_e121 + 12f);
    let _e123 = hash_u0028_f1_u003b((&param_19));
    let _e127 = uniforms.verticalSlits;
    col_1 = floor(((_e120 + (_e123 * 0.017f)) * _e127));
    let _e130 = (*frame_1);
    let _e132 = (*uv_8);
    param_20 = _e132;
    let _e134 = uniforms.verticalSlits;
    param_21 = _e134;
    param_22 = (_e130 + 13f);
    param_23 = 0.01f;
    param_24 = 0.075f;
    let _e135 = stripeX((&param_20), (&param_21), (&param_22), (&param_23), (&param_24));
    slit = _e135;
    let _e136 = col_1;
    let _e137 = (*frame_1);
    param_25 = vec2<f32>(_e136, (_e137 + 19f));
    let _e140 = hash_u0028_vf2_u003b((&param_25));
    let _e142 = slit;
    slit = (_e142 * step(0.66f, _e140));
    let _e144 = slit;
    param_26 = _e144;
    let _e145 = sat((&param_26));
    return _e145;
}

fn brokenGate(uv_9: ptr<function, vec2<f32>>, row_1: ptr<function, f32>, rnd: ptr<function, f32>, frame_2: ptr<function, f32>) -> f32 {
    var segs: f32;
    var param_27: vec2<f32>;
    var seg: f32;
    var param_28: vec2<f32>;

    let _e115 = (*row_1);
    let _e116 = (*frame_2);
    param_27 = vec2<f32>(_e115, (_e116 + 44f));
    let _e119 = hash_u0028_vf2_u003b((&param_27));
    segs = mix(1f, 9f, _e119);
    let _e122 = (*uv_9)[0u];
    let _e123 = segs;
    seg = floor((_e122 * _e123));
    let _e126 = seg;
    let _e127 = (*row_1);
    let _e128 = (*frame_2);
    let _e131 = (*rnd);
    param_28 = vec2<f32>(_e126, ((_e127 + (_e128 * 3f)) + _e131));
    let _e134 = hash_u0028_vf2_u003b((&param_28));
    return step(0.16f, _e134);
}

fn horizontalMask(uv_10: ptr<function, vec2<f32>>, frame_3: ptr<function, f32>) -> f32 {
    var r1_: f32;
    var param_29: f32;
    var r2_: f32;
    var param_30: f32;
    var r3_: f32;
    var param_31: f32;
    var thick: f32;
    var param_32: vec2<f32>;
    var param_33: f32;
    var param_34: f32;
    var param_35: f32;
    var param_36: f32;
    var mid: f32;
    var param_37: vec2<f32>;
    var param_38: f32;
    var param_39: f32;
    var param_40: f32;
    var param_41: f32;
    var hair: f32;
    var param_42: vec2<f32>;
    var param_43: f32;
    var param_44: f32;
    var param_45: f32;
    var param_46: f32;
    var param_47: vec2<f32>;
    var param_48: vec2<f32>;
    var param_49: vec2<f32>;
    var param_50: vec2<f32>;
    var param_51: vec2<f32>;
    var param_52: f32;
    var param_53: f32;
    var param_54: f32;
    var param_55: vec2<f32>;
    var param_56: vec2<f32>;
    var param_57: f32;
    var param_58: f32;
    var param_59: f32;
    var param_60: f32;

    let _e148 = (*uv_10)[1u];
    let _e149 = (*frame_3);
    param_29 = _e149;
    let _e150 = hash_u0028_f1_u003b((&param_29));
    let _e154 = uniforms.horizontalBars;
    r1_ = floor((((_e148 + (_e150 * 0.031f)) * _e154) * 0.38f));
    let _e159 = (*uv_10)[1u];
    let _e160 = (*frame_3);
    param_30 = (_e160 + 2f);
    let _e162 = hash_u0028_f1_u003b((&param_30));
    let _e166 = uniforms.horizontalBars;
    r2_ = floor(((_e159 + (_e162 * 0.013f)) * _e166));
    let _e170 = (*uv_10)[1u];
    let _e171 = (*frame_3);
    param_31 = (_e171 + 7f);
    let _e173 = hash_u0028_f1_u003b((&param_31));
    let _e177 = uniforms.horizontalBars;
    r3_ = floor((((_e170 + (_e173 * 0.006f)) * _e177) * 3.4f));
    let _e182 = uniforms.horizontalBars;
    let _e184 = (*frame_3);
    let _e186 = (*uv_10);
    param_32 = _e186;
    param_33 = (_e182 * 0.38f);
    param_34 = (_e184 + 1f);
    param_35 = 0.035f;
    param_36 = 0.22f;
    let _e187 = stripeY((&param_32), (&param_33), (&param_34), (&param_35), (&param_36));
    thick = _e187;
    let _e188 = (*frame_3);
    let _e190 = (*uv_10);
    param_37 = _e190;
    let _e192 = uniforms.horizontalBars;
    param_38 = _e192;
    param_39 = (_e188 + 4f);
    param_40 = 0.014f;
    param_41 = 0.11f;
    let _e193 = stripeY((&param_37), (&param_38), (&param_39), (&param_40), (&param_41));
    mid = _e193;
    let _e195 = uniforms.horizontalBars;
    let _e197 = (*frame_3);
    let _e199 = (*uv_10);
    param_42 = _e199;
    param_43 = (_e195 * 3.4f);
    param_44 = (_e197 + 9f);
    param_45 = 0.004f;
    param_46 = 0.035f;
    let _e200 = stripeY((&param_42), (&param_43), (&param_44), (&param_45), (&param_46));
    hair = _e200;
    let _e201 = r1_;
    let _e202 = (*frame_3);
    param_47 = vec2<f32>(_e201, (_e202 + 10f));
    let _e205 = hash_u0028_vf2_u003b((&param_47));
    let _e207 = thick;
    thick = (_e207 * step(0.42f, _e205));
    let _e209 = r2_;
    let _e210 = (*frame_3);
    param_48 = vec2<f32>(_e209, (_e210 + 20f));
    let _e213 = hash_u0028_vf2_u003b((&param_48));
    let _e215 = mid;
    mid = (_e215 * step(0.48f, _e213));
    let _e217 = r3_;
    let _e218 = (*frame_3);
    param_49 = vec2<f32>(_e217, (_e218 + 30f));
    let _e221 = hash_u0028_vf2_u003b((&param_49));
    let _e223 = hair;
    hair = (_e223 * step(0.62f, _e221));
    let _e225 = r1_;
    let _e226 = (*frame_3);
    param_50 = vec2<f32>(_e225, _e226);
    let _e228 = hash_u0028_vf2_u003b((&param_50));
    let _e229 = (*uv_10);
    param_51 = _e229;
    let _e230 = r1_;
    param_52 = _e230;
    param_53 = _e228;
    let _e231 = (*frame_3);
    param_54 = _e231;
    let _e232 = brokenGate((&param_51), (&param_52), (&param_53), (&param_54));
    let _e233 = thick;
    thick = (_e233 * _e232);
    let _e235 = r2_;
    let _e236 = (*frame_3);
    param_55 = vec2<f32>(_e235, _e236);
    let _e238 = hash_u0028_vf2_u003b((&param_55));
    let _e239 = (*frame_3);
    let _e241 = (*uv_10);
    param_56 = _e241;
    let _e242 = r2_;
    param_57 = _e242;
    param_58 = _e238;
    param_59 = (_e239 + 3f);
    let _e243 = brokenGate((&param_56), (&param_57), (&param_58), (&param_59));
    let _e244 = mid;
    mid = (_e244 * _e243);
    let _e246 = thick;
    let _e247 = mid;
    let _e248 = hair;
    param_60 = max(_e246, max(_e247, _e248));
    let _e251 = sat((&param_60));
    return _e251;
}

fn burst_u0028_() -> f32 {
    let _e108 = uniforms.progress;
    let _e114 = uniforms.strength;
    return (pow(max(0f, sin((_e108 * 3.1415927f))), 0.42f) * _e114);
}

fn transition(uv_11: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param_61: vec2<f32>;
    var param_62: vec2<f32>;
    var b_1: f32;
    var frame_4: f32;
    var h_1: f32;
    var param_63: vec2<f32>;
    var param_64: f32;
    var v_2: f32;
    var param_65: vec2<f32>;
    var param_66: f32;
    var glitch: f32;
    var param_67: f32;
    var row_2: f32;
    var rowRnd_1: f32;
    var param_68: vec2<f32>;
    var bandDelay: f32;
    var reveal: f32;
    var split: vec2<f32>;
    var fromUv: vec2<f32>;
    var param_69: vec2<f32>;
    var param_70: f32;
    var param_71: f32;
    var param_72: f32;
    var param_73: f32;
    var param_74: f32;
    var toUv: vec2<f32>;
    var param_75: vec2<f32>;
    var param_76: f32;
    var param_77: f32;
    var param_78: f32;
    var param_79: f32;
    var param_80: f32;
    var color: vec4<f32>;
    var param_81: vec2<f32>;
    var param_82: vec2<f32>;
    var param_83: vec2<f32>;
    var param_84: vec2<f32>;
    var smearUv: vec2<f32>;
    var param_85: vec2<f32>;
    var sliceReveal: f32;
    var sliceColor: vec4<f32>;
    var param_86: vec2<f32>;
    var param_87: vec2<f32>;
    var param_88: vec2<f32>;
    var param_89: vec2<f32>;
    var hairLine: f32;
    var param_90: vec2<f32>;
    var param_91: f32;
    var param_92: f32;
    var param_93: f32;
    var param_94: f32;
    var param_95: vec2<f32>;
    var scan: f32;
    var nCell: vec2<f32>;
    var n_1: f32;
    var param_96: vec2<f32>;
    var luma: f32;
    var strobe: f32;
    var param_97: vec2<f32>;

    let _e168 = uniforms.progress;
    if (_e168 <= 0f) {
        let _e170 = (*uv_11);
        param_61 = _e170;
        let _e171 = getFromColor((&param_61));
        return _e171;
    }
    let _e173 = uniforms.progress;
    if (_e173 >= 1f) {
        let _e175 = (*uv_11);
        param_62 = _e175;
        let _e176 = getToColor((&param_62));
        return _e176;
    }
    let _e177 = burst_u0028_();
    b_1 = _e177;
    let _e179 = uniforms.progress;
    frame_4 = floor((_e179 * 30f));
    let _e182 = (*uv_11);
    param_63 = _e182;
    let _e183 = frame_4;
    param_64 = _e183;
    let _e184 = horizontalMask((&param_63), (&param_64));
    h_1 = _e184;
    let _e185 = (*uv_11);
    param_65 = _e185;
    let _e186 = frame_4;
    param_66 = _e186;
    let _e187 = verticalMask((&param_65), (&param_66));
    v_2 = _e187;
    let _e188 = h_1;
    let _e189 = v_2;
    param_67 = max(_e188, (_e189 * 0.75f));
    let _e192 = sat((&param_67));
    glitch = _e192;
    let _e194 = (*uv_11)[1u];
    let _e196 = uniforms.horizontalBars;
    row_2 = floor((_e194 * _e196));
    let _e199 = row_2;
    let _e200 = frame_4;
    param_68 = vec2<f32>(_e199, (_e200 + 5f));
    let _e203 = hash_u0028_vf2_u003b((&param_68));
    rowRnd_1 = _e203;
    let _e204 = rowRnd_1;
    let _e207 = h_1;
    bandDelay = (((_e204 - 0.5f) * 0.3f) * _e207);
    let _e210 = uniforms.progress;
    let _e211 = bandDelay;
    reveal = smoothstep(0.18f, 0.84f, (_e210 + _e211));
    let _e215 = uniforms.chroma;
    let _e216 = b_1;
    let _e218 = glitch;
    let _e223 = uniforms.chroma;
    let _e225 = b_1;
    let _e227 = v_2;
    split = vec2<f32>(((_e215 * _e216) * (1f + (1.7f * _e218))), (((_e223 * 0.22f) * _e225) * _e227));
    let _e230 = (*uv_11);
    param_69 = _e230;
    param_70 = 1f;
    let _e231 = b_1;
    param_71 = _e231;
    let _e232 = h_1;
    param_72 = _e232;
    let _e233 = v_2;
    param_73 = _e233;
    let _e234 = frame_4;
    param_74 = _e234;
    let _e235 = distortUv((&param_69), (&param_70), (&param_71), (&param_72), (&param_73), (&param_74));
    fromUv = _e235;
    let _e236 = (*uv_11);
    param_75 = _e236;
    param_76 = -1f;
    let _e237 = b_1;
    param_77 = _e237;
    let _e238 = h_1;
    param_78 = _e238;
    let _e239 = v_2;
    param_79 = _e239;
    let _e240 = frame_4;
    param_80 = _e240;
    let _e241 = distortUv((&param_75), (&param_76), (&param_77), (&param_78), (&param_79), (&param_80));
    toUv = _e241;
    let _e242 = fromUv;
    param_81 = _e242;
    let _e243 = split;
    param_82 = _e243;
    let _e244 = chromaFrom((&param_81), (&param_82));
    let _e245 = toUv;
    param_83 = _e245;
    let _e246 = split;
    param_84 = _e246;
    let _e247 = chromaTo((&param_83), (&param_84));
    let _e248 = reveal;
    color = mix(_e244, _e247, vec4(_e248));
    let _e251 = (*uv_11);
    smearUv = _e251;
    let _e252 = rowRnd_1;
    let _e255 = b_1;
    let _e257 = h_1;
    let _e260 = smearUv[0u];
    smearUv[0u] = (_e260 + ((((_e252 - 0.5f) * 0.46f) * _e255) * _e257));
    let _e263 = row_2;
    let _e264 = frame_4;
    param_85 = vec2<f32>(_e263, (_e264 + 31f));
    let _e267 = hash_u0028_vf2_u003b((&param_85));
    let _e270 = b_1;
    let _e272 = h_1;
    let _e275 = smearUv[1u];
    smearUv[1u] = (_e275 + ((((_e267 - 0.5f) * 0.045f) * _e270) * _e272));
    let _e279 = uniforms.progress;
    let _e280 = rowRnd_1;
    sliceReveal = smoothstep(0.28f, 0.78f, (_e279 + ((_e280 - 0.5f) * 0.22f)));
    let _e285 = split;
    let _e287 = smearUv;
    param_86 = _e287;
    param_87 = (_e285 * 1.65f);
    let _e288 = chromaFrom((&param_86), (&param_87));
    let _e289 = smearUv;
    let _e290 = rowRnd_1;
    let _e293 = b_1;
    let _e297 = split;
    param_88 = (_e289 - vec2<f32>((((_e290 - 0.5f) * 0.18f) * _e293), 0f));
    param_89 = (_e297 * 1.65f);
    let _e299 = chromaTo((&param_88), (&param_89));
    let _e300 = sliceReveal;
    sliceColor = mix(_e288, _e299, vec4(_e300));
    let _e303 = color;
    let _e304 = sliceColor;
    let _e305 = h_1;
    let _e306 = b_1;
    let _e309 = uniforms.residue;
    color = mix(_e303, _e304, vec4(((_e305 * _e306) * _e309)));
    let _e313 = frame_4;
    let _e315 = (*uv_11);
    param_90 = _e315;
    param_91 = 190f;
    param_92 = (_e313 + 55f);
    param_93 = 0.002f;
    param_94 = 0.012f;
    let _e316 = stripeY((&param_90), (&param_91), (&param_92), (&param_93), (&param_94));
    hairLine = _e316;
    let _e318 = (*uv_11)[1u];
    let _e321 = frame_4;
    param_95 = vec2<f32>(floor((_e318 * 190f)), (_e321 + 56f));
    let _e324 = hash_u0028_vf2_u003b((&param_95));
    let _e326 = hairLine;
    hairLine = (_e326 * step(0.7f, _e324));
    let _e328 = hairLine;
    let _e330 = b_1;
    let _e333 = color;
    let _e335 = (_e333.xyz + (((vec3<f32>(0.72f, 0.9f, 1f) * _e328) * _e330) * 0.28f));
    color[0u] = _e335.x;
    color[1u] = _e335.y;
    color[2u] = _e335.z;
    let _e343 = (*uv_11)[1u];
    let _e346 = uniforms.progress;
    scan = (0.5f + (0.5f * sin(((_e343 * 980f) + (_e346 * 130f)))));
    let _e353 = uniforms.scanAmount;
    let _e354 = b_1;
    let _e356 = scan;
    let _e359 = color;
    let _e361 = (_e359.xyz * (1f - ((_e353 * _e354) * _e356)));
    color[0u] = _e361.x;
    color[1u] = _e361.y;
    color[2u] = _e361.z;
    let _e368 = (*uv_11);
    let _e370 = uniforms.ratio;
    nCell = floor((_e368 * vec2<f32>((360f * _e370), 210f)));
    let _e375 = nCell;
    let _e376 = frame_4;
    let _e378 = frame_4;
    param_96 = (_e375 + vec2<f32>((_e376 * 7f), (_e378 * 13f)));
    let _e382 = hash_u0028_vf2_u003b((&param_96));
    n_1 = _e382;
    let _e383 = n_1;
    let _e386 = uniforms.noiseAmount;
    let _e388 = b_1;
    let _e390 = glitch;
    let _e393 = color;
    let _e396 = (_e393.xyz + vec3(((((_e383 - 0.5f) * _e386) * _e388) * (0.55f + _e390))));
    color[0u] = _e396.x;
    color[1u] = _e396.y;
    color[2u] = _e396.z;
    let _e403 = color;
    luma = dot(_e403.xyz, vec3<f32>(0.299f, 0.587f, 0.114f));
    let _e406 = color;
    let _e408 = luma;
    let _e410 = b_1;
    let _e412 = glitch;
    let _e415 = mix(_e406.xyz, vec3(_e408), vec3(((0.18f * _e410) * _e412)));
    color[0u] = _e415.x;
    color[1u] = _e415.y;
    color[2u] = _e415.z;
    let _e422 = frame_4;
    param_97 = vec2<f32>(_e422, 3.14f);
    let _e424 = hash_u0028_vf2_u003b((&param_97));
    let _e426 = b_1;
    strobe = (step(0.78f, _e424) * pow(_e426, 1.65f));
    let _e429 = strobe;
    let _e431 = uniforms.flashAmount;
    let _e434 = color;
    let _e436 = (_e434.xyz + vec3((_e429 * _e431)));
    color[0u] = _e436.x;
    color[1u] = _e436.y;
    color[2u] = _e436.z;
    let _e443 = color;
    let _e445 = clamp(_e443.xyz, vec3<f32>(0f, 0f, 0f), vec3<f32>(1f, 1f, 1f));
    let _e447 = color[3u];
    return vec4<f32>(_e445.x, _e445.y, _e445.z, _e447);
}

fn main_1() {
    var param_98: vec2<f32>;

    let _e108 = _uv_1;
    param_98 = _e108;
    let _e109 = transition((&param_98));
    _fragColor = _e109;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
