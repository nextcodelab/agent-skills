// ComicPanels — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ComicPanels.glsl
// Author: gre
// License: MIT
// Description: The frame splits into slanted comic-book panels with gutters and ink borders; one after another in reading order, each panel lifts off the page with a zoom kick and a drop shadow and punches over to the incoming image, then the gutters close up over the full incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float gutter;
    char _pad3[4];
    metal::float4 gutterColor;
    metal::float4 borderColor;
    float seed;
    char _pad6[12];
};

float lift(
    thread float& t
) {
    float u = {};
    float _e64 = t;
    float _e66 = t;
    u = 1.0 - ((1.0 - _e64) * (1.0 - _e66));
    float _e70 = u;
    return metal::sin(3.1415927 * _e70);
}

metal::float4 drawPanel(
    thread metal::float4& color,
    thread metal::float4& img,
    thread float& d,
    thread float& g,
    thread float& ink,
    thread float& fade,
    constant Uniforms& uniforms
) {
    metal::float4 c = {};
    metal::float4 _e70 = uniforms.borderColor;
    metal::float4 _e71 = img;
    float _e72 = g;
    float _e73 = ink;
    float _e76 = g;
    float _e77 = ink;
    float _e80 = d;
    float _e82 = fade;
    c = metal::mix(_e70, _e71, metal::float4(metal::mix(1.0, metal::smoothstep((_e72 + _e73) - 0.0012, (_e76 + _e77) + 0.0012, _e80), _e82)));
    metal::float4 _e86 = color;
    metal::float4 _e87 = c;
    float _e88 = g;
    float _e90 = g;
    float _e92 = d;
    float _e94 = fade;
    return metal::mix(_e86, _e87, metal::float4(metal::mix(1.0, metal::smoothstep(_e88 - 0.0012, _e90 + 0.0012, _e92), _e94)));
}

float hash(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e64 = v;
    v3_ = metal::fract(_e64.xyx * 0.1031);
    metal::float3 _e68 = v3_;
    metal::float3 _e69 = v3_;
    metal::float3 _e74 = v3_;
    v3_ = _e74 + metal::float3(metal::dot(_e68, _e69.yzx + metal::float3(33.33)));
    float _e78 = v3_[0u];
    float _e80 = v3_[1u];
    float _e83 = v3_[2u];
    return metal::fract((_e78 + _e80) * _e83);
}

float colDist(
    thread float& r,
    thread float& j,
    thread float& n,
    thread metal::float2& p,
    constant Uniforms& uniforms
) {
    float x = {};
    metal::float2 param = {};
    float s = {};
    metal::float2 param_1 = {};
    float _e70 = j;
    if (_e70 < 0.5) {
        float _e73 = p[0u];
        return _e73;
    }
    float _e74 = j;
    float _e75 = n;
    if (_e74 > (_e75 - 0.5)) {
        float _e79 = p[0u];
        float _e81 = uniforms.ratio;
        return _e79 - _e81;
    }
    float _e83 = j;
    float _e84 = r;
    float _e86 = j;
    float _e90 = uniforms.seed;
    param = metal::float2((_e84 * 3.0) + (_e86 * 13.0), (_e90 * 1.37) + 2.0);
    float _e94 = hash(param);
    float _e98 = n;
    x = (_e83 + ((_e94 - 0.5) * 0.45)) / _e98;
    float _e100 = r;
    float _e102 = j;
    float _e106 = uniforms.seed;
    param_1 = metal::float2((_e100 * 11.0) + (_e102 * 5.0), (_e106 * 1.37) + 7.0);
    float _e110 = hash(param_1);
    s = (_e110 - 0.5) * 0.5;
    float _e114 = p[0u];
    float _e116 = uniforms.ratio;
    float _e117 = x;
    float _e118 = s;
    float _e120 = p[1u];
    float _e127 = uniforms.ratio;
    float _e129 = uniforms.ratio;
    float _e131 = s;
    float _e133 = s;
    return (_e114 - (_e116 * (_e117 + (_e118 * (_e120 - 0.5))))) / metal::sqrt(1.0 + (((_e127 * _e129) * _e131) * _e133));
}

float rowDist(
    thread float& k,
    thread metal::float2& p_1,
    constant Uniforms& uniforms
) {
    float y = {};
    metal::float2 param_2 = {};
    float s_1 = {};
    metal::float2 param_3 = {};
    float _e68 = k;
    if (_e68 < 0.5) {
        float _e71 = p_1[1u];
        return _e71;
    }
    float _e72 = k;
    if (_e72 > 2.5) {
        float _e75 = p_1[1u];
        return _e75 - 1.0;
    }
    float _e77 = k;
    float _e78 = k;
    float _e82 = uniforms.seed;
    param_2 = metal::float2((_e78 * 5.0) + 1.0, _e82 * 1.37);
    float _e85 = hash(param_2);
    y = (_e77 + ((_e85 - 0.5) * 0.35)) / 3.0;
    float _e90 = k;
    float _e94 = uniforms.seed;
    param_3 = metal::float2((_e90 * 9.0) + 4.0, (_e94 * 1.37) + 5.0);
    float _e98 = hash(param_3);
    s_1 = (_e98 - 0.5) * 0.24;
    float _e102 = p_1[1u];
    float _e103 = y;
    float _e105 = s_1;
    float _e107 = p_1[0u];
    float _e109 = uniforms.ratio;
    float _e114 = s_1;
    float _e115 = s_1;
    float _e118 = uniforms.ratio;
    float _e120 = uniforms.ratio;
    return ((_e102 - _e103) - (_e105 * ((_e107 / _e109) - 0.5))) / metal::sqrt(1.0 + ((_e114 * _e115) / (_e118 * _e120)));
}

float panelDist(
    thread float& r_1,
    thread float& c_1,
    thread float& n_1,
    thread metal::float2& p_2,
    constant Uniforms& uniforms
) {
    float param_4 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    metal::float2 param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    metal::float2 param_15 = {};
    float _e78 = r_1;
    param_4 = _e78;
    metal::float2 _e79 = p_2;
    param_5 = _e79;
    float _e80 = rowDist(param_4, param_5, uniforms);
    float _e81 = r_1;
    param_6 = _e81 + 1.0;
    metal::float2 _e83 = p_2;
    param_7 = _e83;
    float _e84 = rowDist(param_6, param_7, uniforms);
    float _e87 = r_1;
    param_8 = _e87;
    float _e88 = c_1;
    param_9 = _e88;
    float _e89 = n_1;
    param_10 = _e89;
    metal::float2 _e90 = p_2;
    param_11 = _e90;
    float _e91 = colDist(param_8, param_9, param_10, param_11, uniforms);
    float _e92 = c_1;
    float _e94 = r_1;
    param_12 = _e94;
    param_13 = _e92 + 1.0;
    float _e95 = n_1;
    param_14 = _e95;
    metal::float2 _e96 = p_2;
    param_15 = _e96;
    float _e97 = colDist(param_12, param_13, param_14, param_15, uniforms);
    return metal::min(metal::min(_e80, -(_e84)), metal::min(_e91, -(_e97)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e64 = uv[0u];
    float _e66 = uv[1u];
    metal::float4 _e69 = _to.sample(_sampler, metal::float2(_e64, 1.0 - _e66), metal::level(0.0));
    return _e69;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e64 = uv_1[0u];
    float _e66 = uv_1[1u];
    metal::float4 _e69 = _from.sample(_sampler, metal::float2(_e64, 1.0 - _e66), metal::level(0.0));
    return _e69;
}

metal::float4 panelImage(
    thread metal::float2& p_3,
    thread metal::float2& center,
    thread float& t_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float k_1 = {};
    float param_16 = {};
    metal::float2 q = {};
    metal::float2 uv_2 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float2 v_1 = {};
    float a = {};
    float i = {};
    float spike = {};
    metal::float2 param_19 = {};
    float burst = {};
    float d_1 = {};
    float w = {};
    metal::float4 c_2 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    float _e82 = t_1;
    param_16 = _e82;
    float _e83 = lift(param_16);
    k_1 = _e83;
    metal::float2 _e84 = center;
    metal::float2 _e85 = p_3;
    metal::float2 _e86 = center;
    float _e88 = k_1;
    q = _e84 + ((_e85 - _e86) / metal::float2(1.0 + (0.1 * _e88)));
    float _e95 = q[0u];
    float _e97 = uniforms.ratio;
    float _e100 = q[1u];
    uv_2 = metal::float2(_e95 / _e97, 1.0 - _e100);
    float _e103 = t_1;
    if (_e103 <= 0.0) {
        metal::float2 _e105 = uv_2;
        param_17 = _e105;
        metal::float4 _e106 = getFromColor(param_17, _from, _sampler);
        return _e106;
    }
    float _e107 = t_1;
    if (_e107 >= 1.0) {
        metal::float2 _e109 = uv_2;
        param_18 = _e109;
        metal::float4 _e110 = getToColor(param_18, _sampler, _to);
        return _e110;
    }
    metal::float2 _e111 = p_3;
    metal::float2 _e112 = center;
    v_1 = _e111 - _e112;
    float _e115 = v_1[1u];
    float _e117 = v_1[0u];
    float _e124 = center[0u];
    a = (((metal::atan2(_e115, _e117 + 0.000001) + 3.1415927) / 6.2831855) * 11.0) + (_e124 * 7.0);
    float _e127 = a;
    i = metal::floor(_e127);
    float _e129 = a;
    float _e130 = i;
    float _e136 = i;
    float _e142 = center[1u];
    float _e145 = uniforms.seed;
    param_19 = metal::float2(_e136 - (metal::floor(_e136 / 11.0) * 11.0), (_e142 * 13.0) + _e145);
    float _e148 = hash(param_19);
    spike = (1.0 - metal::abs((2.0 * (_e129 - _e130)) - 1.0)) * (0.5 + (0.5 * _e148));
    float _e153 = uniforms.ratio;
    float _e157 = t_1;
    burst = (1.5 * metal::max(1.0, _e153 / 1.8)) * metal::smoothstep(0.06, 0.42, _e157);
    metal::float2 _e160 = v_1;
    float _e162 = burst;
    float _e163 = spike;
    d_1 = metal::length(_e160) - (_e162 * (0.62 + (0.38 * _e163)));
    w = 0.007;
    metal::float2 _e168 = uv_2;
    param_20 = _e168;
    metal::float4 _e169 = getToColor(param_20, _sampler, _to);
    metal::float4 _e171 = uniforms.borderColor;
    float _e172 = w;
    float _e175 = w;
    float _e178 = d_1;
    c_2 = metal::mix(_e169, _e171, metal::float4(metal::smoothstep(-(_e172) - 0.0012, -(_e175) + 0.0012, _e178)));
    metal::float4 _e182 = c_2;
    metal::float2 _e183 = uv_2;
    param_21 = _e183;
    metal::float4 _e184 = getFromColor(param_21, _from, _sampler);
    float _e185 = d_1;
    return metal::mix(_e182, _e184, metal::float4(metal::smoothstep(-0.0012, 0.0012, _e185)));
}

metal::float2 panelCenter(
    thread float& r_2,
    thread float& c_3,
    thread float& n_2,
    constant Uniforms& uniforms
) {
    float y0_ = {};
    float param_22 = {};
    metal::float2 param_23 = {};
    float param_24 = {};
    metal::float2 param_25 = {};
    float y1_ = {};
    float param_26 = {};
    metal::float2 param_27 = {};
    float param_28 = {};
    metal::float2 param_29 = {};
    float y_1 = {};
    float x0_ = {};
    float param_30 = {};
    float param_31 = {};
    float param_32 = {};
    metal::float2 param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float param_36 = {};
    metal::float2 param_37 = {};
    float x1_ = {};
    float param_38 = {};
    float param_39 = {};
    float param_40 = {};
    metal::float2 param_41 = {};
    float param_42 = {};
    float param_43 = {};
    float param_44 = {};
    metal::float2 param_45 = {};
    float _e95 = uniforms.ratio;
    float _e98 = r_2;
    param_22 = _e98;
    param_23 = metal::float2(0.5 * _e95, 0.0);
    float _e99 = rowDist(param_22, param_23, uniforms);
    float _e100 = r_2;
    float _e103 = uniforms.ratio;
    param_24 = _e100 + 1.0;
    param_25 = metal::float2(0.5 * _e103, 0.0);
    float _e106 = rowDist(param_24, param_25, uniforms);
    y0_ = _e99 + _e106;
    float _e109 = uniforms.ratio;
    float _e112 = r_2;
    param_26 = _e112;
    param_27 = metal::float2(0.5 * _e109, 1.0);
    float _e113 = rowDist(param_26, param_27, uniforms);
    float _e114 = r_2;
    float _e117 = uniforms.ratio;
    param_28 = _e114 + 1.0;
    param_29 = metal::float2(0.5 * _e117, 1.0);
    float _e120 = rowDist(param_28, param_29, uniforms);
    y1_ = _e113 + _e120;
    float _e122 = y0_;
    float _e123 = y0_;
    float _e124 = y1_;
    y_1 = _e122 / (_e123 - _e124);
    float _e127 = y_1;
    float _e129 = r_2;
    param_30 = _e129;
    float _e130 = c_3;
    param_31 = _e130;
    float _e131 = n_2;
    param_32 = _e131;
    param_33 = metal::float2(0.0, _e127);
    float _e132 = colDist(param_30, param_31, param_32, param_33, uniforms);
    float _e133 = c_3;
    float _e135 = y_1;
    float _e137 = r_2;
    param_34 = _e137;
    param_35 = _e133 + 1.0;
    float _e138 = n_2;
    param_36 = _e138;
    param_37 = metal::float2(0.0, _e135);
    float _e139 = colDist(param_34, param_35, param_36, param_37, uniforms);
    x0_ = _e132 + _e139;
    float _e141 = y_1;
    float _e143 = r_2;
    param_38 = _e143;
    float _e144 = c_3;
    param_39 = _e144;
    float _e145 = n_2;
    param_40 = _e145;
    param_41 = metal::float2(1.0, _e141);
    float _e146 = colDist(param_38, param_39, param_40, param_41, uniforms);
    float _e147 = c_3;
    float _e149 = y_1;
    float _e151 = r_2;
    param_42 = _e151;
    param_43 = _e147 + 1.0;
    float _e152 = n_2;
    param_44 = _e152;
    param_45 = metal::float2(1.0, _e149);
    float _e153 = colDist(param_42, param_43, param_44, param_45, uniforms);
    x1_ = _e146 + _e153;
    float _e155 = x0_;
    float _e156 = x0_;
    float _e157 = x1_;
    float _e160 = y_1;
    return metal::float2(_e155 / (_e156 - _e157), _e160);
}

float panelTime(
    thread float& k_2,
    thread float& total,
    constant Uniforms& uniforms
) {
    float t0_ = {};
    float _e65 = k_2;
    float _e67 = total;
    t0_ = 0.05 + ((0.62 * _e65) / metal::max(_e67 - 1.0, 1.0));
    float _e73 = uniforms.progress;
    float _e74 = t0_;
    return metal::clamp((_e73 - _e74) / 0.3, 0.0, 1.0);
}

float cols(
    thread float& r_3,
    constant Uniforms& uniforms
) {
    float h = {};
    metal::float2 param_46 = {};
    float n_3 = {};
    float local = {};
    float _e67 = r_3;
    float _e71 = uniforms.seed;
    param_46 = metal::float2((_e67 * 7.0) + 3.0, (_e71 * 1.37) + 11.0);
    float _e75 = hash(param_46);
    h = _e75;
    float _e76 = h;
    if (_e76 < 0.15) {
        local = 1.0;
    } else {
        float _e78 = h;
        local = (_e78 < 0.6) ? 2.0 : 3.0;
    }
    float _e81 = local;
    n_3 = _e81;
    float _e82 = r_3;
    if (_e82 == 1.0) {
        float _e84 = n_3;
        n_3 = metal::max(_e84, 2.0);
    }
    float _e87 = uniforms.ratio;
    if (_e87 < 0.8) {
        float _e89 = n_3;
        n_3 = metal::min(_e89, 2.0);
    }
    float _e91 = n_3;
    return _e91;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_47 = {};
    metal::float2 param_48 = {};
    metal::float2 p_4 = {};
    float open = {};
    float g_1 = {};
    float ink_1 = {};
    float fade_1 = {};
    float n0_ = {};
    float param_49 = {};
    float n1_ = {};
    float param_50 = {};
    float n2_ = {};
    float param_51 = {};
    float total_1 = {};
    float r_4 = {};
    float param_52 = {};
    metal::float2 param_53 = {};
    float local_1 = {};
    float param_54 = {};
    metal::float2 param_55 = {};
    float n_4 = {};
    float local_2 = {};
    float c_4 = {};
    float param_56 = {};
    float param_57 = {};
    float param_58 = {};
    metal::float2 param_59 = {};
    float local_3 = {};
    float param_60 = {};
    float param_61 = {};
    float param_62 = {};
    metal::float2 param_63 = {};
    float first = {};
    float local_4 = {};
    float local_5 = {};
    float t_2 = {};
    float param_64 = {};
    float param_65 = {};
    metal::float4 color_1 = {};
    float param_66 = {};
    float param_67 = {};
    float param_68 = {};
    metal::float2 param_69 = {};
    metal::float2 param_70 = {};
    float param_71 = {};
    float param_72 = {};
    float param_73 = {};
    float param_74 = {};
    metal::float2 param_75 = {};
    metal::float4 param_76 = {};
    metal::float4 param_77 = {};
    float param_78 = {};
    float param_79 = {};
    float param_80 = {};
    float param_81 = {};
    float spacing = {};
    float kFirst = {};
    int i_1 = {};
    float pk = {};
    float pt = {};
    float param_82 = {};
    float param_83 = {};
    float pr = {};
    float local_6 = {};
    float pn = {};
    float local_7 = {};
    float pc = {};
    float local_8 = {};
    float local_9 = {};
    float k_3 = {};
    float param_84 = {};
    metal::float2 center_1 = {};
    float param_85 = {};
    float param_86 = {};
    float param_87 = {};
    float s_2 = {};
    metal::float2 sq = {};
    float sd = {};
    float param_88 = {};
    float param_89 = {};
    float param_90 = {};
    metal::float2 param_91 = {};
    metal::float2 q_1 = {};
    metal::float2 param_92 = {};
    metal::float2 param_93 = {};
    float param_94 = {};
    float param_95 = {};
    float param_96 = {};
    float param_97 = {};
    metal::float2 param_98 = {};
    metal::float4 param_99 = {};
    metal::float4 param_100 = {};
    float param_101 = {};
    float param_102 = {};
    float param_103 = {};
    float param_104 = {};
    bool phi_942_ = {};
    float _e160 = uniforms.progress;
    if (_e160 <= 0.0) {
        metal::float2 _e162 = uv_3;
        param_47 = _e162;
        metal::float4 _e163 = getFromColor(param_47, _from, _sampler);
        return _e163;
    }
    float _e165 = uniforms.progress;
    if (_e165 >= 1.0) {
        metal::float2 _e167 = uv_3;
        param_48 = _e167;
        metal::float4 _e168 = getToColor(param_48, _sampler, _to);
        return _e168;
    }
    float _e170 = uv_3[0u];
    float _e172 = uniforms.ratio;
    float _e175 = uv_3[1u];
    p_4 = metal::float2(_e170 * _e172, 1.0 - _e175);
    float _e179 = uniforms.progress;
    float _e182 = uniforms.progress;
    open = metal::smoothstep(0.0, 0.14, _e179) * (1.0 - metal::smoothstep(0.8, 1.0, _e182));
    float _e187 = uniforms.gutter;
    float _e189 = open;
    g_1 = (0.5 * _e187) * _e189;
    float _e191 = open;
    ink_1 = 0.005 * _e191;
    float _e193 = open;
    fade_1 = metal::clamp(_e193 * 6.0, 0.0, 1.0);
    param_49 = 0.0;
    float _e196 = cols(param_49, uniforms);
    n0_ = _e196;
    param_50 = 1.0;
    float _e197 = cols(param_50, uniforms);
    n1_ = _e197;
    param_51 = 2.0;
    float _e198 = cols(param_51, uniforms);
    n2_ = _e198;
    float _e199 = n0_;
    float _e200 = n1_;
    float _e202 = n2_;
    total_1 = (_e199 + _e200) + _e202;
    param_52 = 1.0;
    metal::float2 _e204 = p_4;
    param_53 = _e204;
    float _e205 = rowDist(param_52, param_53, uniforms);
    if (_e205 < 0.0) {
        local_1 = 0.0;
    } else {
        param_54 = 2.0;
        metal::float2 _e207 = p_4;
        param_55 = _e207;
        float _e208 = rowDist(param_54, param_55, uniforms);
        local_1 = (_e208 < 0.0) ? 1.0 : 2.0;
    }
    float _e211 = local_1;
    r_4 = _e211;
    float _e212 = r_4;
    if (_e212 == 0.0) {
        float _e214 = n0_;
        local_2 = _e214;
    } else {
        float _e215 = r_4;
        float _e217 = n1_;
        float _e218 = n2_;
        local_2 = (_e215 == 1.0) ? _e217 : _e218;
    }
    float _e220 = local_2;
    n_4 = _e220;
    float _e221 = r_4;
    param_56 = _e221;
    param_57 = 1.0;
    float _e222 = n_4;
    param_58 = _e222;
    metal::float2 _e223 = p_4;
    param_59 = _e223;
    float _e224 = colDist(param_56, param_57, param_58, param_59, uniforms);
    if (_e224 < 0.0) {
        local_3 = 0.0;
    } else {
        float _e226 = r_4;
        param_60 = _e226;
        param_61 = 2.0;
        float _e227 = n_4;
        param_62 = _e227;
        metal::float2 _e228 = p_4;
        param_63 = _e228;
        float _e229 = colDist(param_60, param_61, param_62, param_63, uniforms);
        float _e231 = n_4;
        local_3 = ((_e229 < 0.0) || (_e231 < 2.5)) ? 1.0 : 2.0;
    }
    float _e235 = local_3;
    c_4 = _e235;
    float _e236 = c_4;
    float _e237 = n_4;
    c_4 = metal::min(_e236, _e237 - 1.0);
    float _e240 = r_4;
    if (_e240 == 0.0) {
        local_4 = 0.0;
    } else {
        float _e242 = r_4;
        if (_e242 == 1.0) {
            float _e244 = n0_;
            local_5 = _e244;
        } else {
            float _e245 = n0_;
            float _e246 = n1_;
            local_5 = _e245 + _e246;
        }
        float _e248 = local_5;
        local_4 = _e248;
    }
    float _e249 = local_4;
    first = _e249;
    float _e250 = first;
    float _e251 = c_4;
    param_64 = _e250 + _e251;
    float _e253 = total_1;
    param_65 = _e253;
    float _e254 = panelTime(param_64, param_65, uniforms);
    t_2 = _e254;
    metal::float4 _e256 = uniforms.gutterColor;
    color_1 = _e256;
    float _e257 = t_2;
    float _e259 = t_2;
    if ((_e257 <= 0.0) || (_e259 >= 1.0)) {
        float _e262 = r_4;
        param_66 = _e262;
        float _e263 = c_4;
        param_67 = _e263;
        float _e264 = n_4;
        param_68 = _e264;
        metal::float2 _e265 = panelCenter(param_66, param_67, param_68, uniforms);
        metal::float2 _e266 = p_4;
        param_69 = _e266;
        param_70 = _e265;
        float _e267 = t_2;
        param_71 = _e267;
        metal::float4 _e268 = panelImage(param_69, param_70, param_71, _from, _sampler, _to, uniforms);
        float _e269 = r_4;
        param_72 = _e269;
        float _e270 = c_4;
        param_73 = _e270;
        float _e271 = n_4;
        param_74 = _e271;
        metal::float2 _e272 = p_4;
        param_75 = _e272;
        float _e273 = panelDist(param_72, param_73, param_74, param_75, uniforms);
        metal::float4 _e274 = color_1;
        param_76 = _e274;
        param_77 = _e268;
        param_78 = _e273;
        float _e275 = g_1;
        param_79 = _e275;
        float _e276 = ink_1;
        param_80 = _e276;
        float _e277 = fade_1;
        param_81 = _e277;
        metal::float4 _e278 = drawPanel(param_76, param_77, param_78, param_79, param_80, param_81, uniforms);
        color_1 = _e278;
    }
    float _e279 = total_1;
    spacing = 0.62 / metal::max(_e279 - 1.0, 1.0);
    float _e284 = uniforms.progress;
    float _e287 = spacing;
    kFirst = metal::floor((((_e284 - 0.05) - 0.3) / _e287) - 0.01) + 1.0;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e411 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e411) + as_type<uint>(1));
        }
        loop_init = false;
        int _e292 = i_1;
        if (_e292 < 4) {
            float _e294 = kFirst;
            int _e295 = i_1;
            pk = _e294 + static_cast<float>(_e295);
            float _e298 = pk;
            bool _e299 = _e298 < 0.0;
            phi_942_ = _e299;
            if (!(_e299)) {
                float _e301 = pk;
                float _e302 = total_1;
                phi_942_ = _e301 > (_e302 - 0.5);
            }
            bool _e306 = phi_942_;
            if (_e306) {
                continue;
            }
            float _e307 = pk;
            param_82 = _e307;
            float _e308 = total_1;
            param_83 = _e308;
            float _e309 = panelTime(param_82, param_83, uniforms);
            pt = _e309;
            float _e310 = pt;
            float _e312 = pt;
            if ((_e310 <= 0.0) || (_e312 >= 1.0)) {
                continue;
            }
            float _e315 = pk;
            float _e316 = n0_;
            if (_e315 < _e316) {
                local_6 = 0.0;
            } else {
                float _e318 = pk;
                float _e319 = n0_;
                float _e320 = n1_;
                local_6 = (_e318 < (_e319 + _e320)) ? 1.0 : 2.0;
            }
            float _e324 = local_6;
            pr = _e324;
            float _e325 = pr;
            if (_e325 == 0.0) {
                float _e327 = n0_;
                local_7 = _e327;
            } else {
                float _e328 = pr;
                float _e330 = n1_;
                float _e331 = n2_;
                local_7 = (_e328 == 1.0) ? _e330 : _e331;
            }
            float _e333 = local_7;
            pn = _e333;
            float _e334 = pk;
            float _e335 = pr;
            if (_e335 == 0.0) {
                local_8 = 0.0;
            } else {
                float _e337 = pr;
                if (_e337 == 1.0) {
                    float _e339 = n0_;
                    local_9 = _e339;
                } else {
                    float _e340 = n0_;
                    float _e341 = n1_;
                    local_9 = _e340 + _e341;
                }
                float _e343 = local_9;
                local_8 = _e343;
            }
            float _e344 = local_8;
            pc = _e334 - _e344;
            float _e346 = pt;
            param_84 = _e346;
            float _e347 = lift(param_84);
            k_3 = _e347;
            float _e348 = pr;
            param_85 = _e348;
            float _e349 = pc;
            param_86 = _e349;
            float _e350 = pn;
            param_87 = _e350;
            metal::float2 _e351 = panelCenter(param_85, param_86, param_87, uniforms);
            center_1 = _e351;
            float _e352 = k_3;
            s_2 = 1.0 + (0.08 * _e352);
            metal::float2 _e355 = center_1;
            metal::float2 _e356 = p_4;
            float _e357 = k_3;
            metal::float2 _e360 = center_1;
            float _e362 = s_2;
            sq = _e355 + (((_e356 - (metal::float2(0.012, 0.018) * _e357)) - _e360) / metal::float2(_e362));
            float _e366 = pr;
            param_88 = _e366;
            float _e367 = pc;
            param_89 = _e367;
            float _e368 = pn;
            param_90 = _e368;
            metal::float2 _e369 = sq;
            param_91 = _e369;
            float _e370 = panelDist(param_88, param_89, param_90, param_91, uniforms);
            float _e371 = g_1;
            sd = _e370 - _e371;
            float _e373 = k_3;
            float _e375 = fade_1;
            float _e377 = sd;
            metal::float4 _e381 = color_1;
            metal::float3 _e383 = _e381.xyz * (1.0 - (((0.4 * _e373) * _e375) * metal::smoothstep(-0.02, 0.01, _e377)));
            color_1[0u] = _e383.x;
            color_1[1u] = _e383.y;
            color_1[2u] = _e383.z;
            metal::float2 _e390 = center_1;
            metal::float2 _e391 = p_4;
            metal::float2 _e392 = center_1;
            float _e394 = s_2;
            q_1 = _e390 + ((_e391 - _e392) / metal::float2(_e394));
            metal::float2 _e398 = q_1;
            param_92 = _e398;
            metal::float2 _e399 = center_1;
            param_93 = _e399;
            float _e400 = pt;
            param_94 = _e400;
            metal::float4 _e401 = panelImage(param_92, param_93, param_94, _from, _sampler, _to, uniforms);
            float _e402 = pr;
            param_95 = _e402;
            float _e403 = pc;
            param_96 = _e403;
            float _e404 = pn;
            param_97 = _e404;
            metal::float2 _e405 = q_1;
            param_98 = _e405;
            float _e406 = panelDist(param_95, param_96, param_97, param_98, uniforms);
            metal::float4 _e407 = color_1;
            param_99 = _e407;
            param_100 = _e401;
            param_101 = _e406;
            float _e408 = g_1;
            param_102 = _e408;
            float _e409 = ink_1;
            param_103 = _e409;
            param_104 = 1.0;
            metal::float4 _e410 = drawPanel(param_99, param_100, param_101, param_102, param_103, param_104, uniforms);
            color_1 = _e410;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e413 = color_1;
    return _e413;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_105 = {};
    metal::float2 _e63 = _uv_1;
    param_105 = _e63;
    metal::float4 _e64 = transition(param_105, _from, _sampler, _to, uniforms);
    _fragColor = _e64;
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
