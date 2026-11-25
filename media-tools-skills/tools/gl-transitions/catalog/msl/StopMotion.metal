// StopMotion — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/StopMotion.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is a paper cutout that jerks off the frame in choppy stop-motion steps, with a tiny new tilt and offset each step and a drop shadow, while the incoming cutout jerks in the same way and lands
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int steps;
    float jitter;
    float shadow;
    char _pad5[12];
    metal::float4 backColor;
    metal::float4 rimColor;
};

metal::float4 premultiply(
    thread metal::float4& c
) {
    metal::float4 _e53 = c;
    float _e56 = c[3u];
    metal::float3 _e57 = _e53.xyz * _e56;
    float _e59 = c[3u];
    return metal::float4(_e57.x, _e57.y, _e57.z, _e59);
}

float roundedBox(
    thread metal::float2& q,
    thread metal::float2& b,
    thread float& r
) {
    metal::float2 d = {};
    metal::float2 _e56 = q;
    metal::float2 _e58 = b;
    float _e60 = r;
    d = (metal::abs(_e56) - _e58) + metal::float2(_e60);
    metal::float2 _e63 = d;
    float _e68 = d[0u];
    float _e70 = d[1u];
    float _e74 = r;
    return (metal::length(metal::max(_e63, metal::float2(0.0))) + metal::min(metal::max(_e68, _e70), 0.0)) - _e74;
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e54 = uv[0u];
    float _e56 = uv[1u];
    metal::float4 _e59 = _from.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e54 = uv_1[0u];
    float _e56 = uv_1[1u];
    metal::float4 _e59 = _to.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

metal::float4 drawCutout(
    thread metal::float4& col,
    thread metal::float2& q_1,
    thread metal::float2& c_1,
    thread float& a,
    thread float& s,
    thread float& l,
    thread bool& incoming,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 asp = {};
    metal::float2 halfImage = {};
    metal::float2 halfCut = {};
    float rad = {};
    float ca = {};
    float sa = {};
    metal::float2x2 unrotate = {};
    metal::float2 rs = {};
    metal::float2 ss = {};
    float sAlpha = {};
    float local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float ds = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float blur = {};
    metal::float2 r_1 = {};
    float dCut = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    float dImage = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    float cutCover = {};
    float imageCover = {};
    metal::float2 st = {};
    metal::float4 img = {};
    metal::float4 local_1 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float4 param_13 = {};
    metal::float4 cut = {};
    metal::float4 param_14 = {};
    float _e97 = uniforms.ratio;
    asp = metal::float2(_e97, 1.0);
    metal::float2 _e99 = asp;
    halfImage = _e99 * 0.5;
    metal::float2 _e101 = halfImage;
    float _e102 = l;
    halfCut = _e101 + metal::float2(0.012 * _e102);
    float _e106 = l;
    rad = 0.006 * _e106;
    float _e108 = a;
    ca = metal::cos(_e108);
    float _e110 = a;
    sa = metal::sin(_e110);
    float _e112 = ca;
    float _e113 = sa;
    float _e115 = sa;
    float _e116 = ca;
    unrotate = metal::float2x2(metal::float2(_e112, -(_e113)), metal::float2(_e115, _e116));
    metal::float2x2 _e120 = unrotate;
    metal::float2 _e121 = q_1;
    metal::float2 _e122 = c_1;
    float _e124 = l;
    float _e128 = s;
    rs = (_e120 * ((_e121 - _e122) - (metal::float2(0.018, -0.026) * _e124))) / metal::float2(_e128);
    metal::float2 _e131 = rs;
    metal::float2 _e132 = asp;
    ss = metal::clamp((_e131 / _e132) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
    bool _e139 = incoming;
    if (_e139) {
        metal::float2 _e140 = ss;
        param = _e140;
        metal::float4 _e141 = getToColor(param, _sampler, _to);
        local = _e141.w;
    } else {
        metal::float2 _e143 = ss;
        param_1 = _e143;
        metal::float4 _e144 = getFromColor(param_1, _from, _sampler);
        local = _e144.w;
    }
    float _e146 = local;
    float _e149 = uniforms.rimColor[3u];
    sAlpha = metal::max(_e146, _e149);
    metal::float2 _e151 = rs;
    param_2 = _e151;
    metal::float2 _e152 = halfCut;
    param_3 = _e152;
    float _e153 = rad;
    param_4 = _e153;
    float _e154 = roundedBox(param_2, param_3, param_4);
    float _e155 = s;
    ds = _e154 * _e155;
    float _e157 = l;
    blur = 0.004 + (0.016 * _e157);
    float _e161 = uniforms.shadow;
    float _e164 = l;
    float _e166 = sAlpha;
    float _e168 = blur;
    float _e170 = blur;
    float _e171 = ds;
    metal::float4 _e176 = col;
    metal::float3 _e178 = _e176.xyz * (1.0 - ((((metal::clamp(_e161, 0.0, 1.0) * 0.75) * _e164) * _e166) * (1.0 - metal::smoothstep(-(_e168), _e170, _e171))));
    col[0u] = _e178.x;
    col[1u] = _e178.y;
    col[2u] = _e178.z;
    metal::float2x2 _e185 = unrotate;
    metal::float2 _e186 = q_1;
    metal::float2 _e187 = c_1;
    float _e190 = s;
    r_1 = (_e185 * (_e186 - _e187)) / metal::float2(_e190);
    metal::float2 _e193 = r_1;
    param_5 = _e193;
    metal::float2 _e194 = halfCut;
    param_6 = _e194;
    float _e195 = rad;
    param_7 = _e195;
    float _e196 = roundedBox(param_5, param_6, param_7);
    float _e197 = s;
    dCut = _e196 * _e197;
    metal::float2 _e199 = r_1;
    param_8 = _e199;
    metal::float2 _e200 = halfImage;
    param_9 = _e200;
    param_10 = 0.0;
    float _e201 = roundedBox(param_8, param_9, param_10);
    float _e202 = s;
    dImage = _e201 * _e202;
    float _e204 = dCut;
    cutCover = metal::clamp(0.5 - (_e204 / 0.0015), 0.0, 1.0);
    float _e208 = dImage;
    imageCover = metal::clamp(0.5 - (_e208 / 0.0015), 0.0, 1.0);
    metal::float2 _e212 = r_1;
    metal::float2 _e213 = asp;
    st = metal::clamp((_e212 / _e213) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
    bool _e220 = incoming;
    if (_e220) {
        metal::float2 _e221 = st;
        param_11 = _e221;
        metal::float4 _e222 = getToColor(param_11, _sampler, _to);
        local_1 = _e222;
    } else {
        metal::float2 _e223 = st;
        param_12 = _e223;
        metal::float4 _e224 = getFromColor(param_12, _from, _sampler);
        local_1 = _e224;
    }
    metal::float4 _e225 = local_1;
    param_13 = _e225;
    metal::float4 _e226 = premultiply(param_13);
    img = _e226;
    metal::float4 _e228 = uniforms.rimColor;
    param_14 = _e228;
    metal::float4 _e229 = premultiply(param_14);
    metal::float4 _e230 = img;
    float _e231 = imageCover;
    float _e234 = cutCover;
    cut = metal::mix(_e229, _e230, metal::float4(_e231)) * _e234;
    metal::float4 _e236 = cut;
    metal::float4 _e237 = col;
    float _e239 = cut[3u];
    return _e236 + (_e237 * (1.0 - _e239));
}

float offFrame(
    thread metal::float2& h,
    thread float& a_1,
    constant Uniforms& uniforms
) {
    float _e55 = uniforms.ratio;
    float _e57 = a_1;
    float _e61 = h[0u];
    float _e64 = a_1;
    float _e68 = h[1u];
    return (((0.5 * _e55) + (metal::abs(metal::cos(_e57)) * _e61)) + (metal::abs(metal::sin(_e64)) * _e68)) + 0.08;
}

metal::float2 cutoutSize(
    thread float& s_1,
    thread float& l_1,
    constant Uniforms& uniforms
) {
    float _e55 = uniforms.ratio;
    float _e58 = l_1;
    float _e62 = s_1;
    return ((metal::float2(_e55, 1.0) * 0.5) + metal::float2(0.012 * _e58)) * _e62;
}

float hash11(
    thread float& p
) {
    float _e53 = p;
    p = metal::fract(_e53 * 0.1031);
    float _e56 = p;
    float _e58 = p;
    p = _e58 * (_e56 + 33.33);
    float _e60 = p;
    float _e61 = p;
    float _e63 = p;
    p = _e63 * (_e60 + _e61);
    float _e65 = p;
    return metal::fract(_e65);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n = {};
    int local_2 = {};
    float k = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 q_2 = {};
    float j = {};
    float l0_ = {};
    float m0_ = {};
    float s0_ = {};
    float a0_ = {};
    float param_17 = {};
    metal::float2 c0_ = {};
    float param_18 = {};
    float param_19 = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float l1_ = {};
    float m1_ = {};
    float s1_ = {};
    float a1_ = {};
    float param_24 = {};
    metal::float2 c1_ = {};
    float param_25 = {};
    float param_26 = {};
    metal::float2 param_27 = {};
    float param_28 = {};
    float param_29 = {};
    float param_30 = {};
    metal::float4 col_1 = {};
    metal::float4 param_31 = {};
    metal::float4 param_32 = {};
    metal::float2 param_33 = {};
    metal::float2 param_34 = {};
    float param_35 = {};
    float param_36 = {};
    float param_37 = {};
    bool param_38 = {};
    metal::float4 param_39 = {};
    metal::float2 param_40 = {};
    metal::float2 param_41 = {};
    float param_42 = {};
    float param_43 = {};
    float param_44 = {};
    bool param_45 = {};
    float param_46 = {};
    int _e102 = uniforms.steps;
    if (_e102 < 2) {
        local_2 = 2;
    } else {
        int _e105 = uniforms.steps;
        local_2 = _e105;
    }
    int _e106 = local_2;
    n = static_cast<float>(_e106);
    float _e109 = uniforms.progress;
    float _e110 = n;
    k = metal::floor((_e109 * _e110) + 0.5);
    float _e114 = k;
    if (_e114 <= 0.0) {
        metal::float2 _e116 = uv_2;
        param_15 = _e116;
        metal::float4 _e117 = getFromColor(param_15, _from, _sampler);
        return _e117;
    }
    float _e118 = k;
    float _e119 = n;
    if (_e118 >= _e119) {
        metal::float2 _e121 = uv_2;
        param_16 = _e121;
        metal::float4 _e122 = getToColor(param_16, _sampler, _to);
        return _e122;
    }
    metal::float2 _e123 = uv_2;
    float _e127 = uniforms.ratio;
    q_2 = (_e123 - metal::float2(0.5)) * metal::float2(_e127, 1.0);
    float _e131 = uniforms.jitter;
    j = metal::clamp(_e131, 0.0, 1.0);
    float _e133 = k;
    l0_ = metal::min(_e133 / 2.0, 1.0);
    float _e136 = k;
    float _e138 = n;
    m0_ = metal::clamp((_e136 - 1.0) / (0.45 * _e138), 0.0, 1.0);
    float _e142 = m0_;
    float _e143 = m0_;
    float _e145 = m0_;
    m0_ = (_e142 * _e143) * (0.4 + (0.6 * _e145));
    float _e149 = l0_;
    s0_ = 1.0 - (0.2 * _e149);
    float _e152 = m0_;
    float _e154 = l0_;
    float _e155 = j;
    float _e158 = k;
    param_17 = _e158;
    float _e159 = hash11(param_17);
    a0_ = (0.22 * _e152) + (((_e154 * _e155) * 0.2) * (_e159 - 0.5));
    float _e163 = s0_;
    param_18 = _e163;
    float _e164 = l0_;
    param_19 = _e164;
    metal::float2 _e165 = cutoutSize(param_18, param_19, uniforms);
    param_20 = _e165;
    float _e166 = a0_;
    param_21 = _e166;
    float _e167 = offFrame(param_20, param_21, uniforms);
    float _e169 = m0_;
    float _e171 = m0_;
    float _e173 = m0_;
    float _e176 = l0_;
    float _e177 = j;
    float _e179 = k;
    param_22 = _e179 + 100.0;
    float _e181 = hash11(param_22);
    float _e184 = k;
    param_23 = _e184 + 200.0;
    float _e186 = hash11(param_23);
    c0_ = metal::float2(-(_e167) * _e169, (0.05 * _e171) * _e173) + (metal::float2(0.07 * (_e181 - 0.5), 0.05 * (_e186 - 0.5)) * (_e176 * _e177));
    float _e192 = n;
    float _e193 = k;
    l1_ = metal::min((_e192 - _e193) / 2.0, 1.0);
    float _e197 = n;
    float _e199 = k;
    float _e201 = n;
    m1_ = metal::clamp(((_e197 - 2.0) - _e199) / (0.45 * _e201), 0.0, 1.0);
    float _e205 = m1_;
    float _e206 = m1_;
    float _e208 = m1_;
    m1_ = (_e205 * _e206) * (0.4 + (0.6 * _e208));
    float _e212 = l1_;
    s1_ = 1.0 - (0.2 * _e212);
    float _e215 = m1_;
    float _e217 = l1_;
    float _e218 = j;
    float _e221 = k;
    param_24 = _e221 + 300.0;
    float _e223 = hash11(param_24);
    a1_ = (-0.25 * _e215) + (((_e217 * _e218) * 0.2) * (_e223 - 0.5));
    float _e227 = s1_;
    param_25 = _e227;
    float _e228 = l1_;
    param_26 = _e228;
    metal::float2 _e229 = cutoutSize(param_25, param_26, uniforms);
    param_27 = _e229;
    float _e230 = a1_;
    param_28 = _e230;
    float _e231 = offFrame(param_27, param_28, uniforms);
    float _e232 = m1_;
    float _e234 = m1_;
    float _e236 = m1_;
    float _e239 = l1_;
    float _e240 = j;
    float _e242 = k;
    param_29 = _e242 + 400.0;
    float _e244 = hash11(param_29);
    float _e247 = k;
    param_30 = _e247 + 500.0;
    float _e249 = hash11(param_30);
    c1_ = metal::float2(_e231 * _e232, (-0.06 * _e234) * _e236) + (metal::float2(0.07 * (_e244 - 0.5), 0.05 * (_e249 - 0.5)) * (_e239 * _e240));
    metal::float4 _e256 = uniforms.backColor;
    param_31 = _e256;
    metal::float4 _e257 = premultiply(param_31);
    col_1 = _e257;
    float _e258 = m0_;
    if (_e258 < 1.0) {
        metal::float4 _e260 = col_1;
        param_32 = _e260;
        metal::float2 _e261 = q_2;
        param_33 = _e261;
        metal::float2 _e262 = c0_;
        param_34 = _e262;
        float _e263 = a0_;
        param_35 = _e263;
        float _e264 = s0_;
        param_36 = _e264;
        float _e265 = l0_;
        param_37 = _e265;
        param_38 = false;
        metal::float4 _e266 = drawCutout(param_32, param_33, param_34, param_35, param_36, param_37, param_38, _from, _sampler, _to, uniforms);
        col_1 = _e266;
    }
    float _e267 = m1_;
    if (_e267 < 1.0) {
        metal::float4 _e269 = col_1;
        param_39 = _e269;
        metal::float2 _e270 = q_2;
        param_40 = _e270;
        metal::float2 _e271 = c1_;
        param_41 = _e271;
        float _e272 = a1_;
        param_42 = _e272;
        float _e273 = s1_;
        param_43 = _e273;
        float _e274 = l1_;
        param_44 = _e274;
        param_45 = true;
        metal::float4 _e275 = drawCutout(param_39, param_40, param_41, param_42, param_43, param_44, param_45, _from, _sampler, _to, uniforms);
        col_1 = _e275;
    }
    float _e277 = col_1[3u];
    if (_e277 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    float _e280 = col_1[3u];
    metal::float4 _e281 = col_1;
    metal::float3 _e284 = _e281.xyz / metal::float3(_e280);
    col_1[0u] = _e284.x;
    col_1[1u] = _e284.y;
    col_1[2u] = _e284.z;
    float _e291 = j;
    float _e293 = k;
    param_46 = _e293 + 600.0;
    float _e295 = hash11(param_46);
    metal::float4 _e298 = col_1;
    metal::float3 _e300 = _e298.xyz * (1.0 - ((0.04 * _e291) * _e295));
    col_1[0u] = _e300.x;
    col_1[1u] = _e300.y;
    col_1[2u] = _e300.z;
    metal::float4 _e307 = col_1;
    return _e307;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_47 = {};
    metal::float2 _e53 = _uv_1;
    param_47 = _e53;
    metal::float4 _e54 = transition(param_47, _from, _sampler, _to, uniforms);
    _fragColor = _e54;
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
