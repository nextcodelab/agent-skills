// StereoViewer — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StereoViewer.glsl
// Author: Ted Schundler
// License: BSD 2 Clause
// Description: Both images shrink into rounded cards that swap, like a stereo viewer toy
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float zoom;
    float corner_radius;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e32 = uv[0u];
    float _e34 = uv[1u];
    metal::float4 _e37 = _to.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

bool in_corner(
    thread metal::float2& p,
    thread metal::float2& corner,
    thread metal::float2& radius
) {
    metal::float2 axis = {};
    bool phi_156_ = {};
    bool phi_168_ = {};
    bool phi_169_ = {};
    bool phi_177_ = {};
    metal::float2 _e34 = corner;
    metal::float2 _e36 = corner;
    axis = (metal::float2(1.0, 1.0) - _e34) - _e36;
    metal::float2 _e38 = p;
    metal::float2 _e39 = corner;
    metal::float2 _e40 = axis;
    metal::float2 _e41 = radius;
    p = _e38 - (_e39 + (_e40 * _e41));
    metal::float2 _e45 = axis;
    metal::float2 _e46 = radius;
    metal::float2 _e48 = p;
    p = _e48 * (_e45 / _e46);
    float _e51 = p[0u];
    bool _e52 = _e51 > 0.0;
    phi_156_ = _e52;
    if (_e52) {
        float _e54 = p[1u];
        phi_156_ = _e54 > -1.0;
    }
    bool _e57 = phi_156_;
    phi_169_ = _e57;
    if (!(_e57)) {
        float _e60 = p[1u];
        bool _e61 = _e60 > 0.0;
        phi_168_ = _e61;
        if (_e61) {
            float _e63 = p[0u];
            phi_168_ = _e63 > -1.0;
        }
        bool _e66 = phi_168_;
        phi_169_ = _e66;
    }
    bool _e68 = phi_169_;
    phi_177_ = _e68;
    if (!(_e68)) {
        metal::float2 _e70 = p;
        metal::float2 _e71 = p;
        phi_177_ = metal::dot(_e70, _e71) < 1.0;
    }
    bool _e75 = phi_177_;
    return _e75;
}

bool test_rounded_mask(
    thread metal::float2& p_1,
    thread metal::float2& corner_size
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    bool phi_196_ = {};
    bool phi_206_ = {};
    bool phi_215_ = {};
    metal::float2 _e44 = p_1;
    param = _e44;
    param_1 = metal::float2(0.0, 0.0);
    metal::float2 _e45 = corner_size;
    param_2 = _e45;
    bool _e46 = in_corner(param, param_1, param_2);
    phi_196_ = _e46;
    if (_e46) {
        metal::float2 _e47 = p_1;
        param_3 = _e47;
        param_4 = metal::float2(0.0, 1.0);
        metal::float2 _e48 = corner_size;
        param_5 = _e48;
        bool _e49 = in_corner(param_3, param_4, param_5);
        phi_196_ = _e49;
    }
    bool _e51 = phi_196_;
    phi_206_ = _e51;
    if (_e51) {
        metal::float2 _e52 = p_1;
        param_6 = _e52;
        param_7 = metal::float2(1.0, 0.0);
        metal::float2 _e53 = corner_size;
        param_8 = _e53;
        bool _e54 = in_corner(param_6, param_7, param_8);
        phi_206_ = _e54;
    }
    bool _e56 = phi_206_;
    phi_215_ = _e56;
    if (_e56) {
        metal::float2 _e57 = p_1;
        param_9 = _e57;
        param_10 = metal::float2(1.0, 1.0);
        metal::float2 _e58 = corner_size;
        param_11 = _e58;
        bool _e59 = in_corner(param_9, param_10, param_11);
        phi_215_ = _e59;
    }
    bool _e61 = phi_215_;
    return _e61;
}

metal::float4 simple_sample_with_corners_to(
    thread metal::float2& p_2,
    thread metal::float2& corner_size_1,
    thread float& zoom_amt,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 _e36 = p_2;
    float _e39 = zoom_amt;
    float _e42 = uniforms.zoom;
    float _e43 = zoom_amt;
    p_2 = ((_e36 - metal::float2(0.5)) / metal::float2((1.0 - _e39) + (_e42 * _e43))) + metal::float2(0.5);
    metal::float2 _e50 = p_2;
    param_12 = _e50;
    metal::float2 _e51 = corner_size_1;
    param_13 = _e51;
    bool _e52 = test_rounded_mask(param_12, param_13);
    if (!(_e52)) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float2 _e54 = p_2;
    param_14 = _e54;
    metal::float4 _e55 = getToColor(param_14, _sampler, _to);
    return _e55;
}

metal::float4 screen(
    thread metal::float4& a,
    thread metal::float4& b
) {
    metal::float4 _e32 = a;
    metal::float4 _e35 = b;
    return metal::float4(1.0) - ((metal::float4(1.0) - _e32) * (metal::float4(1.0) - _e35));
}

metal::float4 unscreen(
    thread metal::float4& c
) {
    metal::float4 _e31 = c;
    return metal::float4(1.0) - metal::sqrt(metal::float4(1.0) - _e31);
}

metal::float4 sample_with_corners_to(
    thread metal::float2& p_3,
    thread metal::float2& corner_size_2,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float4 param_18 = {};
    metal::float2 _e36 = p_3;
    float _e40 = uniforms.zoom;
    p_3 = ((_e36 - metal::float2(0.5)) / metal::float2(_e40)) + metal::float2(0.5);
    metal::float2 _e45 = p_3;
    param_15 = _e45;
    metal::float2 _e46 = corner_size_2;
    param_16 = _e46;
    bool _e47 = test_rounded_mask(param_15, param_16);
    if (!(_e47)) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float2 _e49 = p_3;
    param_17 = _e49;
    metal::float4 _e50 = getToColor(param_17, _sampler, _to);
    param_18 = _e50;
    metal::float4 _e51 = unscreen(param_18);
    return _e51;
}

metal::float3x3 rotate2d(
    thread float& angle,
    thread float& ratio
) {
    float s = {};
    float c_1 = {};
    float _e34 = angle;
    s = metal::sin(_e34);
    float _e36 = angle;
    c_1 = metal::cos(_e36);
    float _e38 = c_1;
    float _e39 = s;
    float _e40 = s;
    float _e42 = c_1;
    return metal::float3x3(metal::float3(_e38, _e39, 0.0), metal::float3(-(_e40), _e42, 0.0), metal::float3(0.0, 0.0, 1.0));
}

metal::float3x3 scale2d(
    thread float& x,
    thread float& y
) {
    float _e32 = x;
    float _e33 = y;
    return metal::float3x3(metal::float3(_e32, 0.0, 0.0), metal::float3(0.0, _e33, 0.0), metal::float3(0.0, 0.0, 1.0));
}

metal::float3x3 translate2d(
    thread float& x_1,
    thread float& y_1
) {
    float _e32 = x_1;
    float _e34 = y_1;
    return metal::float3x3(metal::float3(1.0, 0.0, 0.0), metal::float3(0.0, 1.0, 0.0), metal::float3(-(_e32), -(_e34), 1.0));
}

metal::float4 get_cross_masked(
    thread metal::float3& p3_,
    thread float& angle_1,
    thread metal::float2& corner_size_3,
    thread float& ratio_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float3x3 center_and_scale = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    metal::float3x3 unscale_and_uncenter = {};
    float param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    metal::float3x3 slide_left = {};
    float param_27 = {};
    float param_28 = {};
    metal::float3x3 slide_right = {};
    float param_29 = {};
    float param_30 = {};
    metal::float3x3 rotate = {};
    float param_31 = {};
    float param_32 = {};
    metal::float3x3 op_a = {};
    metal::float3x3 op_b = {};
    bool mask_a = {};
    metal::float2 param_33 = {};
    metal::float2 param_34 = {};
    bool mask_b = {};
    metal::float2 param_35 = {};
    metal::float2 param_36 = {};
    metal::float4 img = {};
    metal::float2 param_37 = {};
    metal::float2 param_38 = {};
    metal::float4 param_39 = {};
    metal::float4 param_40 = {};
    float _e66 = angle_1;
    angle_1 = 1.0 - _e66;
    float _e68 = angle_1;
    float _e69 = angle_1;
    angle_1 = _e68 * _e69;
    float _e71 = angle_1;
    angle_1 = _e71 / 2.4;
    param_19 = -0.5;
    param_20 = -0.5;
    metal::float3x3 _e73 = translate2d(param_19, param_20);
    param_21 = 1.0;
    float _e74 = ratio_1;
    param_22 = _e74;
    metal::float3x3 _e75 = scale2d(param_21, param_22);
    center_and_scale = _e73 * _e75;
    float _e78 = uniforms.zoom;
    float _e81 = uniforms.zoom;
    float _e82 = ratio_1;
    param_23 = 1.0 / _e78;
    param_24 = 1.0 / (_e81 * _e82);
    metal::float3x3 _e85 = scale2d(param_23, param_24);
    param_25 = 0.5;
    param_26 = 0.5;
    metal::float3x3 _e86 = translate2d(param_25, param_26);
    unscale_and_uncenter = _e85 * _e86;
    param_27 = -2.0;
    param_28 = 0.0;
    metal::float3x3 _e88 = translate2d(param_27, param_28);
    slide_left = _e88;
    param_29 = 2.0;
    param_30 = 0.0;
    metal::float3x3 _e89 = translate2d(param_29, param_30);
    slide_right = _e89;
    float _e90 = angle_1;
    param_31 = _e90;
    float _e91 = ratio_1;
    param_32 = _e91;
    metal::float3x3 _e92 = rotate2d(param_31, param_32);
    rotate = _e92;
    metal::float3x3 _e93 = center_and_scale;
    metal::float3x3 _e94 = slide_right;
    metal::float3x3 _e96 = rotate;
    metal::float3x3 _e98 = slide_left;
    metal::float3x3 _e100 = unscale_and_uncenter;
    op_a = (((_e93 * _e94) * _e96) * _e98) * _e100;
    metal::float3x3 _e102 = center_and_scale;
    metal::float3x3 _e103 = slide_left;
    metal::float3x3 _e105 = rotate;
    metal::float3x3 _e107 = slide_right;
    metal::float3x3 _e109 = unscale_and_uncenter;
    op_b = (((_e102 * _e103) * _e105) * _e107) * _e109;
    metal::float3x3 _e111 = op_a;
    metal::float3 _e112 = p3_;
    param_33 = (_e111 * _e112).xy;
    metal::float2 _e115 = corner_size_3;
    param_34 = _e115;
    bool _e116 = test_rounded_mask(param_33, param_34);
    mask_a = _e116;
    metal::float3x3 _e117 = op_b;
    metal::float3 _e118 = p3_;
    param_35 = (_e117 * _e118).xy;
    metal::float2 _e121 = corner_size_3;
    param_36 = _e121;
    bool _e122 = test_rounded_mask(param_35, param_36);
    mask_b = _e122;
    bool _e123 = mask_a;
    bool _e124 = mask_b;
    if (_e123 || _e124) {
        metal::float3 _e126 = p3_;
        param_37 = _e126.xy;
        metal::float2 _e128 = corner_size_3;
        param_38 = _e128;
        metal::float4 _e129 = sample_with_corners_to(param_37, param_38, _sampler, _to, uniforms);
        img = _e129;
        bool _e130 = mask_a;
        metal::float4 _e131 = img;
        bool _e134 = mask_b;
        metal::float4 _e135 = img;
        param_39 = metal::select(metal::float4(0.0, 0.0, 0.0, 0.0), _e131, metal::bool4(_e130));
        param_40 = metal::select(metal::float4(0.0, 0.0, 0.0, 0.0), _e135, metal::bool4(_e134));
        metal::float4 _e138 = screen(param_39, param_40);
        return _e138;
    } else {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e32 = uv_1[0u];
    float _e34 = uv_1[1u];
    metal::float4 _e37 = _from.sample(_sampler, metal::float2(_e32, 1.0 - _e34), metal::level(0.0));
    return _e37;
}

metal::float4 sample_with_corners_from(
    thread metal::float2& p_4,
    thread metal::float2& corner_size_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    metal::float2 param_41 = {};
    metal::float2 param_42 = {};
    metal::float2 param_43 = {};
    metal::float4 param_44 = {};
    metal::float2 _e36 = p_4;
    float _e40 = uniforms.zoom;
    p_4 = ((_e36 - metal::float2(0.5)) / metal::float2(_e40)) + metal::float2(0.5);
    metal::float2 _e45 = p_4;
    param_41 = _e45;
    metal::float2 _e46 = corner_size_4;
    param_42 = _e46;
    bool _e47 = test_rounded_mask(param_41, param_42);
    if (!(_e47)) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float2 _e49 = p_4;
    param_43 = _e49;
    metal::float4 _e50 = getFromColor(param_43, _from, _sampler);
    param_44 = _e50;
    metal::float4 _e51 = unscreen(param_44);
    return _e51;
}

metal::float4 get_cross_rotated(
    thread metal::float3& p3_1,
    thread float& angle_2,
    thread metal::float2& corner_size_5,
    thread float& ratio_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    metal::float3x3 center_and_scale_1 = {};
    float param_45 = {};
    float param_46 = {};
    float param_47 = {};
    float param_48 = {};
    metal::float3x3 unscale_and_uncenter_1 = {};
    float param_49 = {};
    float param_50 = {};
    float param_51 = {};
    float param_52 = {};
    metal::float3x3 slide_left_1 = {};
    float param_53 = {};
    float param_54 = {};
    metal::float3x3 slide_right_1 = {};
    float param_55 = {};
    float param_56 = {};
    metal::float3x3 rotate_1 = {};
    float param_57 = {};
    float param_58 = {};
    metal::float3x3 op_a_1 = {};
    metal::float3x3 op_b_1 = {};
    metal::float4 a_1 = {};
    metal::float2 param_59 = {};
    metal::float2 param_60 = {};
    metal::float4 b_1 = {};
    metal::float2 param_61 = {};
    metal::float2 param_62 = {};
    metal::float4 param_63 = {};
    metal::float4 param_64 = {};
    float _e63 = angle_2;
    float _e64 = angle_2;
    angle_2 = _e63 * _e64;
    float _e66 = angle_2;
    angle_2 = _e66 / 2.4;
    param_45 = -0.5;
    param_46 = -0.5;
    metal::float3x3 _e68 = translate2d(param_45, param_46);
    param_47 = 1.0;
    float _e69 = ratio_2;
    param_48 = _e69;
    metal::float3x3 _e70 = scale2d(param_47, param_48);
    center_and_scale_1 = _e68 * _e70;
    float _e72 = ratio_2;
    param_49 = 1.0;
    param_50 = 1.0 / _e72;
    metal::float3x3 _e74 = scale2d(param_49, param_50);
    param_51 = 0.5;
    param_52 = 0.5;
    metal::float3x3 _e75 = translate2d(param_51, param_52);
    unscale_and_uncenter_1 = _e74 * _e75;
    param_53 = -2.0;
    param_54 = 0.0;
    metal::float3x3 _e77 = translate2d(param_53, param_54);
    slide_left_1 = _e77;
    param_55 = 2.0;
    param_56 = 0.0;
    metal::float3x3 _e78 = translate2d(param_55, param_56);
    slide_right_1 = _e78;
    float _e79 = angle_2;
    param_57 = _e79;
    float _e80 = ratio_2;
    param_58 = _e80;
    metal::float3x3 _e81 = rotate2d(param_57, param_58);
    rotate_1 = _e81;
    metal::float3x3 _e82 = center_and_scale_1;
    metal::float3x3 _e83 = slide_right_1;
    metal::float3x3 _e85 = rotate_1;
    metal::float3x3 _e87 = slide_left_1;
    metal::float3x3 _e89 = unscale_and_uncenter_1;
    op_a_1 = (((_e82 * _e83) * _e85) * _e87) * _e89;
    metal::float3x3 _e91 = center_and_scale_1;
    metal::float3x3 _e92 = slide_left_1;
    metal::float3x3 _e94 = rotate_1;
    metal::float3x3 _e96 = slide_right_1;
    metal::float3x3 _e98 = unscale_and_uncenter_1;
    op_b_1 = (((_e91 * _e92) * _e94) * _e96) * _e98;
    metal::float3x3 _e100 = op_a_1;
    metal::float3 _e101 = p3_1;
    param_59 = (_e100 * _e101).xy;
    metal::float2 _e104 = corner_size_5;
    param_60 = _e104;
    metal::float4 _e105 = sample_with_corners_from(param_59, param_60, _from, _sampler, uniforms);
    a_1 = _e105;
    metal::float3x3 _e106 = op_b_1;
    metal::float3 _e107 = p3_1;
    param_61 = (_e106 * _e107).xy;
    metal::float2 _e110 = corner_size_5;
    param_62 = _e110;
    metal::float4 _e111 = sample_with_corners_from(param_61, param_62, _from, _sampler, uniforms);
    b_1 = _e111;
    metal::float4 _e112 = a_1;
    param_63 = _e112;
    metal::float4 _e113 = b_1;
    param_64 = _e113;
    metal::float4 _e114 = screen(param_63, param_64);
    return _e114;
}

metal::float4 simple_sample_with_corners_from(
    thread metal::float2& p_5,
    thread metal::float2& corner_size_6,
    thread float& zoom_amt_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    metal::float2 param_65 = {};
    metal::float2 param_66 = {};
    metal::float2 param_67 = {};
    metal::float2 _e36 = p_5;
    float _e39 = zoom_amt_1;
    float _e42 = uniforms.zoom;
    float _e43 = zoom_amt_1;
    p_5 = ((_e36 - metal::float2(0.5)) / metal::float2((1.0 - _e39) + (_e42 * _e43))) + metal::float2(0.5);
    metal::float2 _e50 = p_5;
    param_65 = _e50;
    metal::float2 _e51 = corner_size_6;
    param_66 = _e51;
    bool _e52 = test_rounded_mask(param_65, param_66);
    if (!(_e52)) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float2 _e54 = p_5;
    param_67 = _e54;
    metal::float4 _e55 = getFromColor(param_67, _from, _sampler);
    return _e55;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p_6 = {};
    metal::float3 p3_2 = {};
    metal::float2 corner_size_7 = {};
    metal::float2 param_68 = {};
    float a_2 = {};
    metal::float2 param_69 = {};
    metal::float2 param_70 = {};
    float param_71 = {};
    metal::float3 param_72 = {};
    float param_73 = {};
    metal::float2 param_74 = {};
    float param_75 = {};
    metal::float3 param_76 = {};
    float param_77 = {};
    metal::float2 param_78 = {};
    float param_79 = {};
    metal::float2 param_80 = {};
    metal::float2 param_81 = {};
    float param_82 = {};
    metal::float2 param_83 = {};
    metal::float2 _e51 = uv_2;
    p_6 = _e51 / metal::float2(1.0, 1.0);
    metal::float2 _e53 = p_6;
    p3_2 = metal::float3(_e53.x, _e53.y, 1.0);
    float _e58 = uniforms.corner_radius;
    float _e60 = uniforms.ratio;
    float _e63 = uniforms.corner_radius;
    corner_size_7 = metal::float2(_e58 / _e60, _e63);
    float _e66 = uniforms.progress;
    if (_e66 <= 0.0) {
        metal::float2 _e68 = p_6;
        param_68 = _e68;
        metal::float4 _e69 = getFromColor(param_68, _from, _sampler);
        return _e69;
    } else {
        float _e71 = uniforms.progress;
        if (_e71 < 0.1) {
            float _e74 = uniforms.progress;
            a_2 = _e74 / 0.1;
            metal::float2 _e76 = corner_size_7;
            float _e77 = a_2;
            metal::float2 _e79 = p_6;
            param_69 = _e79;
            param_70 = _e76 * _e77;
            float _e80 = a_2;
            param_71 = _e80;
            metal::float4 _e81 = simple_sample_with_corners_from(param_69, param_70, param_71, _from, _sampler, uniforms);
            return _e81;
        } else {
            float _e83 = uniforms.progress;
            if (_e83 < 0.48) {
                float _e86 = uniforms.progress;
                a_2 = (_e86 - 0.1) / 0.38;
                metal::float3 _e89 = p3_2;
                param_72 = _e89;
                float _e90 = a_2;
                param_73 = _e90;
                metal::float2 _e91 = corner_size_7;
                param_74 = _e91;
                float _e93 = uniforms.ratio;
                param_75 = _e93;
                metal::float4 _e94 = get_cross_rotated(param_72, param_73, param_74, param_75, _from, _sampler, uniforms);
                return _e94;
            } else {
                float _e96 = uniforms.progress;
                if (_e96 < 0.9) {
                    float _e99 = uniforms.progress;
                    metal::float3 _e102 = p3_2;
                    param_76 = _e102;
                    param_77 = (_e99 - 0.52) / 0.38;
                    metal::float2 _e103 = corner_size_7;
                    param_78 = _e103;
                    float _e105 = uniforms.ratio;
                    param_79 = _e105;
                    metal::float4 _e106 = get_cross_masked(param_76, param_77, param_78, param_79, _sampler, _to, uniforms);
                    return _e106;
                } else {
                    float _e108 = uniforms.progress;
                    if (_e108 < 1.0) {
                        float _e111 = uniforms.progress;
                        a_2 = (1.0 - _e111) / 0.1;
                        metal::float2 _e114 = corner_size_7;
                        float _e115 = a_2;
                        metal::float2 _e117 = p_6;
                        param_80 = _e117;
                        param_81 = _e114 * _e115;
                        float _e118 = a_2;
                        param_82 = _e118;
                        metal::float4 _e119 = simple_sample_with_corners_to(param_80, param_81, param_82, _sampler, _to, uniforms);
                        return _e119;
                    } else {
                        metal::float2 _e120 = p_6;
                        param_83 = _e120;
                        metal::float4 _e121 = getToColor(param_83, _sampler, _to);
                        return _e121;
                    }
                }
            }
        }
    }
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_84 = {};
    metal::float2 _e31 = _uv_1;
    param_84 = _e31;
    metal::float4 _e32 = transition(param_84, _from, _sampler, _to, uniforms);
    _fragColor = _e32;
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
