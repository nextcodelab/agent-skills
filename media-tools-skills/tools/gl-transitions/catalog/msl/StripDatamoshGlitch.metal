// StripDatamoshGlitch — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StripDatamoshGlitch.glsl
// Author: bread
// License: MIT
// Description: A datamosh glitch: torn strips, chroma shifts and scan noise drag the outgoing image into the incoming one
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strength;
    float horizontalBars;
    float verticalSlits;
    float tear;
    float chroma;
    float residue;
    float noiseAmount;
    float scanAmount;
    float flashAmount;
};

float hash_u0028_vf2_u003b(
    thread metal::float2& p
) {
    metal::float2 _e108 = p;
    return metal::fract(metal::sin(metal::dot(_e108, metal::float2(127.1, 311.7))) * 43758.547);
}

float stripeY(
    thread metal::float2& uv,
    thread float& density,
    thread float& seed,
    thread float& minWidth,
    thread float& maxWidth
) {
    float y = {};
    float id = {};
    float f = {};
    float c = {};
    metal::float2 param = {};
    float w = {};
    metal::float2 param_1 = {};
    float _e120 = uv[1u];
    float _e121 = density;
    float _e123 = seed;
    y = (_e120 * _e121) + (_e123 * 0.137);
    float _e126 = y;
    id = metal::floor(_e126);
    float _e128 = y;
    f = metal::fract(_e128);
    float _e130 = id;
    float _e131 = seed;
    param = metal::float2(_e130, _e131);
    float _e133 = hash_u0028_vf2_u003b(param);
    c = _e133;
    float _e134 = minWidth;
    float _e135 = maxWidth;
    float _e136 = id;
    float _e138 = seed;
    param_1 = metal::float2(_e136 + 9.17, _e138 + 2.31);
    float _e141 = hash_u0028_vf2_u003b(param_1);
    w = metal::mix(_e134, _e135, _e141);
    float _e143 = w;
    float _e144 = w;
    float _e146 = f;
    float _e147 = c;
    return 1.0 - metal::smoothstep(_e143, _e144 + 0.018, metal::abs(_e146 - _e147));
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e109 = uv_1[0u];
    float _e111 = uv_1[1u];
    metal::float4 _e114 = _to.sample(_sampler, metal::float2(_e109, 1.0 - _e111), metal::level(0.0));
    return _e114;
}

metal::float2 safeUv(
    thread metal::float2& uv_2
) {
    metal::float2 _e108 = uv_2;
    return metal::clamp(_e108, metal::float2(0.0, 0.0), metal::float2(1.0, 1.0));
}

metal::float4 chromaTo(
    thread metal::float2& uv_3,
    thread metal::float2& s,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param_2 = {};
    metal::float4 center = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 _e116 = uv_3;
    param_2 = _e116;
    metal::float2 _e117 = safeUv(param_2);
    uv_3 = _e117;
    metal::float2 _e118 = uv_3;
    param_3 = _e118;
    metal::float4 _e119 = getToColor(param_3, _sampler, _to);
    center = _e119;
    metal::float2 _e120 = uv_3;
    metal::float2 _e121 = s;
    param_4 = _e120 - _e121;
    metal::float2 _e123 = safeUv(param_4);
    param_5 = _e123;
    metal::float4 _e124 = getToColor(param_5, _sampler, _to);
    float _e127 = center[1u];
    metal::float2 _e128 = uv_3;
    metal::float2 _e129 = s;
    param_6 = _e128 + _e129;
    metal::float2 _e131 = safeUv(param_6);
    param_7 = _e131;
    metal::float4 _e132 = getToColor(param_7, _sampler, _to);
    float _e135 = center[3u];
    return metal::float4(_e124.x, _e127, _e132.z, _e135);
}

metal::float4 getFromColor(
    thread metal::float2& uv_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e109 = uv_4[0u];
    float _e111 = uv_4[1u];
    metal::float4 _e114 = _from.sample(_sampler, metal::float2(_e109, 1.0 - _e111), metal::level(0.0));
    return _e114;
}

metal::float4 chromaFrom(
    thread metal::float2& uv_5,
    thread metal::float2& s_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    metal::float2 param_8 = {};
    metal::float4 center_1 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 _e116 = uv_5;
    param_8 = _e116;
    metal::float2 _e117 = safeUv(param_8);
    uv_5 = _e117;
    metal::float2 _e118 = uv_5;
    param_9 = _e118;
    metal::float4 _e119 = getFromColor(param_9, _from, _sampler);
    center_1 = _e119;
    metal::float2 _e120 = uv_5;
    metal::float2 _e121 = s_1;
    param_10 = _e120 + _e121;
    metal::float2 _e123 = safeUv(param_10);
    param_11 = _e123;
    metal::float4 _e124 = getFromColor(param_11, _from, _sampler);
    float _e127 = center_1[1u];
    metal::float2 _e128 = uv_5;
    metal::float2 _e129 = s_1;
    param_12 = _e128 - _e129;
    metal::float2 _e131 = safeUv(param_12);
    param_13 = _e131;
    metal::float4 _e132 = getFromColor(param_13, _from, _sampler);
    float _e135 = center_1[3u];
    return metal::float4(_e124.x, _e127, _e132.z, _e135);
}

metal::float2 distortUv(
    thread metal::float2& uv_6,
    thread float& dir,
    thread float& b,
    thread float& h,
    thread float& v,
    thread float& frame,
    constant Uniforms& uniforms
) {
    float row = {};
    float col = {};
    float rowRnd = {};
    metal::float2 param_14 = {};
    float colRnd = {};
    metal::float2 param_15 = {};
    float xTear = {};
    float yDrag = {};
    float micro = {};
    metal::float2 param_16 = {};
    float _e124 = uv_6[1u];
    float _e126 = uniforms.horizontalBars;
    row = metal::floor(_e124 * _e126);
    float _e130 = uv_6[0u];
    float _e132 = uniforms.verticalSlits;
    col = metal::floor(_e130 * _e132);
    float _e135 = row;
    float _e136 = frame;
    param_14 = metal::float2(_e135, _e136);
    float _e138 = hash_u0028_vf2_u003b(param_14);
    rowRnd = _e138;
    float _e139 = col;
    float _e140 = frame;
    param_15 = metal::float2(_e139, _e140 + 27.0);
    float _e143 = hash_u0028_vf2_u003b(param_15);
    colRnd = _e143;
    float _e144 = rowRnd;
    float _e148 = uniforms.tear;
    float _e150 = b;
    float _e152 = h;
    xTear = ((((_e144 - 0.5) * 2.0) * _e148) * _e150) * _e152;
    float _e155 = uv_6[1u];
    float _e158 = uniforms.progress;
    float _e163 = b;
    float _e165 = xTear;
    xTear = _e165 + ((metal::sin((_e155 * 120.0) + (_e158 * 95.0)) * 0.006) * _e163);
    float _e167 = colRnd;
    float _e170 = b;
    float _e172 = v;
    yDrag = (((_e167 - 0.5) * 0.13) * _e170) * _e172;
    float _e174 = row;
    float _e175 = col;
    float _e176 = frame;
    param_16 = metal::float2(_e174, _e175 + _e176);
    float _e179 = hash_u0028_vf2_u003b(param_16);
    float _e182 = b;
    float _e184 = h;
    float _e185 = v;
    micro = (((_e179 - 0.5) * 0.018) * _e182) * metal::max(_e184, _e185);
    metal::float2 _e188 = uv_6;
    float _e189 = xTear;
    float _e190 = dir;
    float _e192 = micro;
    float _e194 = yDrag;
    return _e188 + metal::float2((_e189 * _e190) + _e192, _e194);
}

float sat(
    thread float& v_1
) {
    float _e108 = v_1;
    return metal::clamp(_e108, 0.0, 1.0);
}

float stripeX(
    thread metal::float2& uv_7,
    thread float& density_1,
    thread float& seed_1,
    thread float& minWidth_1,
    thread float& maxWidth_1
) {
    float x = {};
    float id_1 = {};
    float f_1 = {};
    float c_1 = {};
    metal::float2 param_17 = {};
    float w_1 = {};
    metal::float2 param_18 = {};
    float _e120 = uv_7[0u];
    float _e121 = density_1;
    float _e123 = seed_1;
    x = (_e120 * _e121) + (_e123 * 0.091);
    float _e126 = x;
    id_1 = metal::floor(_e126);
    float _e128 = x;
    f_1 = metal::fract(_e128);
    float _e130 = id_1;
    float _e131 = seed_1;
    param_17 = metal::float2(_e130, _e131 + 41.0);
    float _e134 = hash_u0028_vf2_u003b(param_17);
    c_1 = _e134;
    float _e135 = minWidth_1;
    float _e136 = maxWidth_1;
    float _e137 = id_1;
    float _e139 = seed_1;
    param_18 = metal::float2(_e137 + 4.7, _e139 + 8.9);
    float _e142 = hash_u0028_vf2_u003b(param_18);
    w_1 = metal::mix(_e135, _e136, _e142);
    float _e144 = w_1;
    float _e145 = w_1;
    float _e147 = f_1;
    float _e148 = c_1;
    return 1.0 - metal::smoothstep(_e144, _e145 + 0.012, metal::abs(_e147 - _e148));
}

float hash_u0028_f1_u003b(
    thread float& n
) {
    float _e108 = n;
    return metal::fract(metal::sin(_e108) * 43758.547);
}

float verticalMask(
    thread metal::float2& uv_8,
    thread float& frame_1,
    constant Uniforms& uniforms
) {
    float col_1 = {};
    float param_19 = {};
    float slit = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    metal::float2 param_25 = {};
    float param_26 = {};
    float _e120 = uv_8[0u];
    float _e121 = frame_1;
    param_19 = _e121 + 12.0;
    float _e123 = hash_u0028_f1_u003b(param_19);
    float _e127 = uniforms.verticalSlits;
    col_1 = metal::floor((_e120 + (_e123 * 0.017)) * _e127);
    float _e130 = frame_1;
    metal::float2 _e132 = uv_8;
    param_20 = _e132;
    float _e134 = uniforms.verticalSlits;
    param_21 = _e134;
    param_22 = _e130 + 13.0;
    param_23 = 0.01;
    param_24 = 0.075;
    float _e135 = stripeX(param_20, param_21, param_22, param_23, param_24);
    slit = _e135;
    float _e136 = col_1;
    float _e137 = frame_1;
    param_25 = metal::float2(_e136, _e137 + 19.0);
    float _e140 = hash_u0028_vf2_u003b(param_25);
    float _e142 = slit;
    slit = _e142 * metal::step(0.66, _e140);
    float _e144 = slit;
    param_26 = _e144;
    float _e145 = sat(param_26);
    return _e145;
}

float brokenGate(
    thread metal::float2& uv_9,
    thread float& row_1,
    thread float& rnd,
    thread float& frame_2
) {
    float segs = {};
    metal::float2 param_27 = {};
    float seg = {};
    metal::float2 param_28 = {};
    float _e115 = row_1;
    float _e116 = frame_2;
    param_27 = metal::float2(_e115, _e116 + 44.0);
    float _e119 = hash_u0028_vf2_u003b(param_27);
    segs = metal::mix(1.0, 9.0, _e119);
    float _e122 = uv_9[0u];
    float _e123 = segs;
    seg = metal::floor(_e122 * _e123);
    float _e126 = seg;
    float _e127 = row_1;
    float _e128 = frame_2;
    float _e131 = rnd;
    param_28 = metal::float2(_e126, (_e127 + (_e128 * 3.0)) + _e131);
    float _e134 = hash_u0028_vf2_u003b(param_28);
    return metal::step(0.16, _e134);
}

float horizontalMask(
    thread metal::float2& uv_10,
    thread float& frame_3,
    constant Uniforms& uniforms
) {
    float r1_ = {};
    float param_29 = {};
    float r2_ = {};
    float param_30 = {};
    float r3_ = {};
    float param_31 = {};
    float thick = {};
    metal::float2 param_32 = {};
    float param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float param_36 = {};
    float mid = {};
    metal::float2 param_37 = {};
    float param_38 = {};
    float param_39 = {};
    float param_40 = {};
    float param_41 = {};
    float hair = {};
    metal::float2 param_42 = {};
    float param_43 = {};
    float param_44 = {};
    float param_45 = {};
    float param_46 = {};
    metal::float2 param_47 = {};
    metal::float2 param_48 = {};
    metal::float2 param_49 = {};
    metal::float2 param_50 = {};
    metal::float2 param_51 = {};
    float param_52 = {};
    float param_53 = {};
    float param_54 = {};
    metal::float2 param_55 = {};
    metal::float2 param_56 = {};
    float param_57 = {};
    float param_58 = {};
    float param_59 = {};
    float param_60 = {};
    float _e148 = uv_10[1u];
    float _e149 = frame_3;
    param_29 = _e149;
    float _e150 = hash_u0028_f1_u003b(param_29);
    float _e154 = uniforms.horizontalBars;
    r1_ = metal::floor(((_e148 + (_e150 * 0.031)) * _e154) * 0.38);
    float _e159 = uv_10[1u];
    float _e160 = frame_3;
    param_30 = _e160 + 2.0;
    float _e162 = hash_u0028_f1_u003b(param_30);
    float _e166 = uniforms.horizontalBars;
    r2_ = metal::floor((_e159 + (_e162 * 0.013)) * _e166);
    float _e170 = uv_10[1u];
    float _e171 = frame_3;
    param_31 = _e171 + 7.0;
    float _e173 = hash_u0028_f1_u003b(param_31);
    float _e177 = uniforms.horizontalBars;
    r3_ = metal::floor(((_e170 + (_e173 * 0.006)) * _e177) * 3.4);
    float _e182 = uniforms.horizontalBars;
    float _e184 = frame_3;
    metal::float2 _e186 = uv_10;
    param_32 = _e186;
    param_33 = _e182 * 0.38;
    param_34 = _e184 + 1.0;
    param_35 = 0.035;
    param_36 = 0.22;
    float _e187 = stripeY(param_32, param_33, param_34, param_35, param_36);
    thick = _e187;
    float _e188 = frame_3;
    metal::float2 _e190 = uv_10;
    param_37 = _e190;
    float _e192 = uniforms.horizontalBars;
    param_38 = _e192;
    param_39 = _e188 + 4.0;
    param_40 = 0.014;
    param_41 = 0.11;
    float _e193 = stripeY(param_37, param_38, param_39, param_40, param_41);
    mid = _e193;
    float _e195 = uniforms.horizontalBars;
    float _e197 = frame_3;
    metal::float2 _e199 = uv_10;
    param_42 = _e199;
    param_43 = _e195 * 3.4;
    param_44 = _e197 + 9.0;
    param_45 = 0.004;
    param_46 = 0.035;
    float _e200 = stripeY(param_42, param_43, param_44, param_45, param_46);
    hair = _e200;
    float _e201 = r1_;
    float _e202 = frame_3;
    param_47 = metal::float2(_e201, _e202 + 10.0);
    float _e205 = hash_u0028_vf2_u003b(param_47);
    float _e207 = thick;
    thick = _e207 * metal::step(0.42, _e205);
    float _e209 = r2_;
    float _e210 = frame_3;
    param_48 = metal::float2(_e209, _e210 + 20.0);
    float _e213 = hash_u0028_vf2_u003b(param_48);
    float _e215 = mid;
    mid = _e215 * metal::step(0.48, _e213);
    float _e217 = r3_;
    float _e218 = frame_3;
    param_49 = metal::float2(_e217, _e218 + 30.0);
    float _e221 = hash_u0028_vf2_u003b(param_49);
    float _e223 = hair;
    hair = _e223 * metal::step(0.62, _e221);
    float _e225 = r1_;
    float _e226 = frame_3;
    param_50 = metal::float2(_e225, _e226);
    float _e228 = hash_u0028_vf2_u003b(param_50);
    metal::float2 _e229 = uv_10;
    param_51 = _e229;
    float _e230 = r1_;
    param_52 = _e230;
    param_53 = _e228;
    float _e231 = frame_3;
    param_54 = _e231;
    float _e232 = brokenGate(param_51, param_52, param_53, param_54);
    float _e233 = thick;
    thick = _e233 * _e232;
    float _e235 = r2_;
    float _e236 = frame_3;
    param_55 = metal::float2(_e235, _e236);
    float _e238 = hash_u0028_vf2_u003b(param_55);
    float _e239 = frame_3;
    metal::float2 _e241 = uv_10;
    param_56 = _e241;
    float _e242 = r2_;
    param_57 = _e242;
    param_58 = _e238;
    param_59 = _e239 + 3.0;
    float _e243 = brokenGate(param_56, param_57, param_58, param_59);
    float _e244 = mid;
    mid = _e244 * _e243;
    float _e246 = thick;
    float _e247 = mid;
    float _e248 = hair;
    param_60 = metal::max(_e246, metal::max(_e247, _e248));
    float _e251 = sat(param_60);
    return _e251;
}

float burst_u0028_(
    constant Uniforms& uniforms
) {
    float _e108 = uniforms.progress;
    float _e114 = uniforms.strength;
    return metal::pow(metal::max(0.0, metal::sin(_e108 * 3.1415927)), 0.42) * _e114;
}

metal::float4 transition(
    thread metal::float2& uv_11,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_61 = {};
    metal::float2 param_62 = {};
    float b_1 = {};
    float frame_4 = {};
    float h_1 = {};
    metal::float2 param_63 = {};
    float param_64 = {};
    float v_2 = {};
    metal::float2 param_65 = {};
    float param_66 = {};
    float glitch = {};
    float param_67 = {};
    float row_2 = {};
    float rowRnd_1 = {};
    metal::float2 param_68 = {};
    float bandDelay = {};
    float reveal = {};
    metal::float2 split = {};
    metal::float2 fromUv = {};
    metal::float2 param_69 = {};
    float param_70 = {};
    float param_71 = {};
    float param_72 = {};
    float param_73 = {};
    float param_74 = {};
    metal::float2 toUv = {};
    metal::float2 param_75 = {};
    float param_76 = {};
    float param_77 = {};
    float param_78 = {};
    float param_79 = {};
    float param_80 = {};
    metal::float4 color = {};
    metal::float2 param_81 = {};
    metal::float2 param_82 = {};
    metal::float2 param_83 = {};
    metal::float2 param_84 = {};
    metal::float2 smearUv = {};
    metal::float2 param_85 = {};
    float sliceReveal = {};
    metal::float4 sliceColor = {};
    metal::float2 param_86 = {};
    metal::float2 param_87 = {};
    metal::float2 param_88 = {};
    metal::float2 param_89 = {};
    float hairLine = {};
    metal::float2 param_90 = {};
    float param_91 = {};
    float param_92 = {};
    float param_93 = {};
    float param_94 = {};
    metal::float2 param_95 = {};
    float scan = {};
    metal::float2 nCell = {};
    float n_1 = {};
    metal::float2 param_96 = {};
    float luma = {};
    float strobe = {};
    metal::float2 param_97 = {};
    float _e168 = uniforms.progress;
    if (_e168 <= 0.0) {
        metal::float2 _e170 = uv_11;
        param_61 = _e170;
        metal::float4 _e171 = getFromColor(param_61, _from, _sampler);
        return _e171;
    }
    float _e173 = uniforms.progress;
    if (_e173 >= 1.0) {
        metal::float2 _e175 = uv_11;
        param_62 = _e175;
        metal::float4 _e176 = getToColor(param_62, _sampler, _to);
        return _e176;
    }
    float _e177 = burst_u0028_(uniforms);
    b_1 = _e177;
    float _e179 = uniforms.progress;
    frame_4 = metal::floor(_e179 * 30.0);
    metal::float2 _e182 = uv_11;
    param_63 = _e182;
    float _e183 = frame_4;
    param_64 = _e183;
    float _e184 = horizontalMask(param_63, param_64, uniforms);
    h_1 = _e184;
    metal::float2 _e185 = uv_11;
    param_65 = _e185;
    float _e186 = frame_4;
    param_66 = _e186;
    float _e187 = verticalMask(param_65, param_66, uniforms);
    v_2 = _e187;
    float _e188 = h_1;
    float _e189 = v_2;
    param_67 = metal::max(_e188, _e189 * 0.75);
    float _e192 = sat(param_67);
    glitch = _e192;
    float _e194 = uv_11[1u];
    float _e196 = uniforms.horizontalBars;
    row_2 = metal::floor(_e194 * _e196);
    float _e199 = row_2;
    float _e200 = frame_4;
    param_68 = metal::float2(_e199, _e200 + 5.0);
    float _e203 = hash_u0028_vf2_u003b(param_68);
    rowRnd_1 = _e203;
    float _e204 = rowRnd_1;
    float _e207 = h_1;
    bandDelay = ((_e204 - 0.5) * 0.3) * _e207;
    float _e210 = uniforms.progress;
    float _e211 = bandDelay;
    reveal = metal::smoothstep(0.18, 0.84, _e210 + _e211);
    float _e215 = uniforms.chroma;
    float _e216 = b_1;
    float _e218 = glitch;
    float _e223 = uniforms.chroma;
    float _e225 = b_1;
    float _e227 = v_2;
    split = metal::float2((_e215 * _e216) * (1.0 + (1.7 * _e218)), ((_e223 * 0.22) * _e225) * _e227);
    metal::float2 _e230 = uv_11;
    param_69 = _e230;
    param_70 = 1.0;
    float _e231 = b_1;
    param_71 = _e231;
    float _e232 = h_1;
    param_72 = _e232;
    float _e233 = v_2;
    param_73 = _e233;
    float _e234 = frame_4;
    param_74 = _e234;
    metal::float2 _e235 = distortUv(param_69, param_70, param_71, param_72, param_73, param_74, uniforms);
    fromUv = _e235;
    metal::float2 _e236 = uv_11;
    param_75 = _e236;
    param_76 = -1.0;
    float _e237 = b_1;
    param_77 = _e237;
    float _e238 = h_1;
    param_78 = _e238;
    float _e239 = v_2;
    param_79 = _e239;
    float _e240 = frame_4;
    param_80 = _e240;
    metal::float2 _e241 = distortUv(param_75, param_76, param_77, param_78, param_79, param_80, uniforms);
    toUv = _e241;
    metal::float2 _e242 = fromUv;
    param_81 = _e242;
    metal::float2 _e243 = split;
    param_82 = _e243;
    metal::float4 _e244 = chromaFrom(param_81, param_82, _from, _sampler);
    metal::float2 _e245 = toUv;
    param_83 = _e245;
    metal::float2 _e246 = split;
    param_84 = _e246;
    metal::float4 _e247 = chromaTo(param_83, param_84, _sampler, _to);
    float _e248 = reveal;
    color = metal::mix(_e244, _e247, metal::float4(_e248));
    metal::float2 _e251 = uv_11;
    smearUv = _e251;
    float _e252 = rowRnd_1;
    float _e255 = b_1;
    float _e257 = h_1;
    float _e260 = smearUv[0u];
    smearUv[0u] = _e260 + ((((_e252 - 0.5) * 0.46) * _e255) * _e257);
    float _e263 = row_2;
    float _e264 = frame_4;
    param_85 = metal::float2(_e263, _e264 + 31.0);
    float _e267 = hash_u0028_vf2_u003b(param_85);
    float _e270 = b_1;
    float _e272 = h_1;
    float _e275 = smearUv[1u];
    smearUv[1u] = _e275 + ((((_e267 - 0.5) * 0.045) * _e270) * _e272);
    float _e279 = uniforms.progress;
    float _e280 = rowRnd_1;
    sliceReveal = metal::smoothstep(0.28, 0.78, _e279 + ((_e280 - 0.5) * 0.22));
    metal::float2 _e285 = split;
    metal::float2 _e287 = smearUv;
    param_86 = _e287;
    param_87 = _e285 * 1.65;
    metal::float4 _e288 = chromaFrom(param_86, param_87, _from, _sampler);
    metal::float2 _e289 = smearUv;
    float _e290 = rowRnd_1;
    float _e293 = b_1;
    metal::float2 _e297 = split;
    param_88 = _e289 - metal::float2(((_e290 - 0.5) * 0.18) * _e293, 0.0);
    param_89 = _e297 * 1.65;
    metal::float4 _e299 = chromaTo(param_88, param_89, _sampler, _to);
    float _e300 = sliceReveal;
    sliceColor = metal::mix(_e288, _e299, metal::float4(_e300));
    metal::float4 _e303 = color;
    metal::float4 _e304 = sliceColor;
    float _e305 = h_1;
    float _e306 = b_1;
    float _e309 = uniforms.residue;
    color = metal::mix(_e303, _e304, metal::float4((_e305 * _e306) * _e309));
    float _e313 = frame_4;
    metal::float2 _e315 = uv_11;
    param_90 = _e315;
    param_91 = 190.0;
    param_92 = _e313 + 55.0;
    param_93 = 0.002;
    param_94 = 0.012;
    float _e316 = stripeY(param_90, param_91, param_92, param_93, param_94);
    hairLine = _e316;
    float _e318 = uv_11[1u];
    float _e321 = frame_4;
    param_95 = metal::float2(metal::floor(_e318 * 190.0), _e321 + 56.0);
    float _e324 = hash_u0028_vf2_u003b(param_95);
    float _e326 = hairLine;
    hairLine = _e326 * metal::step(0.7, _e324);
    float _e328 = hairLine;
    float _e330 = b_1;
    metal::float4 _e333 = color;
    metal::float3 _e335 = _e333.xyz + (((metal::float3(0.72, 0.9, 1.0) * _e328) * _e330) * 0.28);
    color[0u] = _e335.x;
    color[1u] = _e335.y;
    color[2u] = _e335.z;
    float _e343 = uv_11[1u];
    float _e346 = uniforms.progress;
    scan = 0.5 + (0.5 * metal::sin((_e343 * 980.0) + (_e346 * 130.0)));
    float _e353 = uniforms.scanAmount;
    float _e354 = b_1;
    float _e356 = scan;
    metal::float4 _e359 = color;
    metal::float3 _e361 = _e359.xyz * (1.0 - ((_e353 * _e354) * _e356));
    color[0u] = _e361.x;
    color[1u] = _e361.y;
    color[2u] = _e361.z;
    metal::float2 _e368 = uv_11;
    float _e370 = uniforms.ratio;
    nCell = metal::floor(_e368 * metal::float2(360.0 * _e370, 210.0));
    metal::float2 _e375 = nCell;
    float _e376 = frame_4;
    float _e378 = frame_4;
    param_96 = _e375 + metal::float2(_e376 * 7.0, _e378 * 13.0);
    float _e382 = hash_u0028_vf2_u003b(param_96);
    n_1 = _e382;
    float _e383 = n_1;
    float _e386 = uniforms.noiseAmount;
    float _e388 = b_1;
    float _e390 = glitch;
    metal::float4 _e393 = color;
    metal::float3 _e396 = _e393.xyz + metal::float3((((_e383 - 0.5) * _e386) * _e388) * (0.55 + _e390));
    color[0u] = _e396.x;
    color[1u] = _e396.y;
    color[2u] = _e396.z;
    metal::float4 _e403 = color;
    luma = metal::dot(_e403.xyz, metal::float3(0.299, 0.587, 0.114));
    metal::float4 _e406 = color;
    float _e408 = luma;
    float _e410 = b_1;
    float _e412 = glitch;
    metal::float3 _e415 = metal::mix(_e406.xyz, metal::float3(_e408), metal::float3((0.18 * _e410) * _e412));
    color[0u] = _e415.x;
    color[1u] = _e415.y;
    color[2u] = _e415.z;
    float _e422 = frame_4;
    param_97 = metal::float2(_e422, 3.14);
    float _e424 = hash_u0028_vf2_u003b(param_97);
    float _e426 = b_1;
    strobe = metal::step(0.78, _e424) * metal::pow(_e426, 1.65);
    float _e429 = strobe;
    float _e431 = uniforms.flashAmount;
    metal::float4 _e434 = color;
    metal::float3 _e436 = _e434.xyz + metal::float3(_e429 * _e431);
    color[0u] = _e436.x;
    color[1u] = _e436.y;
    color[2u] = _e436.z;
    metal::float4 _e443 = color;
    metal::float3 _e445 = metal::clamp(_e443.xyz, metal::float3(0.0, 0.0, 0.0), metal::float3(1.0, 1.0, 1.0));
    float _e447 = color[3u];
    return metal::float4(_e445.x, _e445.y, _e445.z, _e447);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_98 = {};
    metal::float2 _e108 = _uv_1;
    param_98 = _e108;
    metal::float4 _e109 = transition(param_98, _from, _sampler, _to, uniforms);
    _fragColor = _e109;
    return;
}

struct main_Input {
    metal::float2 _uv [[user(loc0), center_perspective]];
};
struct main_Output {
    metal::float4 member [[color(0)]];
};
fragment main_Output main_(
  main_Input varyings [[stage_in]]
, metal::texture2d<float, metal::access::sample> _from [[texture(0)]]
, metal::sampler _sampler [[sampler(0)]]
, metal::texture2d<float, metal::access::sample> _to [[texture(1)]]
, constant Uniforms& uniforms [[buffer(0)]]
) {
    metal::float4 _fragColor = {};
    metal::float2 _uv_1 = {};
    const auto _uv = varyings._uv;
    _uv_1 = _uv;
    main_1(_from, _sampler, _to, uniforms, _fragColor, _uv_1);
    metal::float4 _e3 = _fragColor;
    return main_Output { _e3 };
}
