// DominoFall — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DominoFall.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is cut into standing slats that topple backward like dominoes in a chain reaction across the frame, each one leaning onto the next and knocking it over, until they all lie flat and reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int count;
    int reverse;
    float knock;
    float lean;
    float perspective;
    float shading;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e38 = uv[0u];
    float _e40 = uv[1u];
    metal::float4 _e43 = _from.sample(_sampler, metal::float2(_e38, 1.0 - _e40), metal::level(0.0));
    return _e43;
}

metal::float4 drawSlat(
    thread metal::float4& color,
    thread float& j,
    thread metal::float4& pt,
    thread metal::float4& front,
    thread float& w,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    float t = {};
    float s = {};
    float d = {};
    float m = {};
    float e = {};
    float sx = {};
    metal::float4 img = {};
    float local = {};
    metal::float2 param = {};
    float shade = {};
    float reach = {};
    bool phi_318_ = {};
    bool phi_418_ = {};
    bool phi_424_ = {};
    float _e53 = pt[2u];
    t = _e53;
    float _e54 = t;
    if (_e54 < 0.0) {
        metal::float4 _e56 = color;
        return _e56;
    }
    float _e58 = pt[3u];
    s = metal::sin(_e58);
    float _e61 = pt[0u];
    float _e62 = w;
    float _e64 = pt[0u];
    d = metal::min(_e61, _e62 - _e64);
    float _e67 = t;
    if (_e67 <= 0.0) {
        float _e69 = d;
        bool _e70 = _e69 >= 0.0;
        phi_318_ = _e70;
        if (_e70) {
            float _e72 = pt[1u];
            phi_318_ = _e72 <= 1.0;
        }
        bool _e75 = phi_318_;
        m = _e75 ? 1.0 : 0.0;
    } else {
        float _e77 = t;
        float _e82 = uniforms.perspective;
        float _e85 = pt[1u];
        float _e87 = s;
        e = (0.0015 * metal::min(10.0 * _e77, 1.0)) * (1.0 + ((metal::max(_e82, 0.0) * _e85) * _e87));
        float _e91 = d;
        float _e92 = e;
        float _e97 = pt[1u];
        float _e100 = pt[3u];
        float _e104 = e;
        m = metal::clamp((_e91 / _e92) + 0.5, 0.0, 1.0) * metal::clamp((((1.0 - _e97) * metal::max(metal::cos(_e100), 0.05)) / _e104) + 0.5, 0.0, 1.0);
    }
    float _e109 = m;
    if (_e109 <= 0.0) {
        metal::float4 _e111 = color;
        return _e111;
    }
    float _e112 = j;
    float _e113 = w;
    float _e116 = pt[0u];
    float _e117 = w;
    float _e121 = uniforms.ratio;
    sx = ((_e112 * _e113) + metal::clamp(_e116, 0.0, _e117)) / _e121;
    int _e124 = uniforms.reverse;
    if (_e124 != 0) {
        float _e126 = sx;
        local = 1.0 - _e126;
    } else {
        float _e128 = sx;
        local = _e128;
    }
    float _e129 = local;
    float _e131 = pt[1u];
    param = metal::float2(_e129, metal::min(_e131, 1.0));
    metal::float4 _e134 = getFromColor(param, _from, _sampler);
    img = _e134;
    float _e136 = uniforms.shading;
    float _e137 = s;
    float _e140 = pt[1u];
    shade = 1.0 - ((_e136 * _e137) * (0.4 + (0.6 * _e140)));
    float _e146 = front[2u];
    bool _e147 = _e146 >= 0.0;
    phi_418_ = _e147;
    if (_e147) {
        float _e149 = front[2u];
        float _e150 = t;
        phi_418_ = _e149 < _e150;
    }
    bool _e153 = phi_418_;
    phi_424_ = _e153;
    if (_e153) {
        float _e155 = front[0u];
        phi_424_ = _e155 < 0.0;
    }
    bool _e158 = phi_424_;
    if (_e158) {
        float _e160 = front[1u];
        reach = metal::clamp(1.0 - ((_e160 - 1.0) / 0.05), 0.0, 1.0);
        float _e166 = uniforms.shading;
        float _e169 = front[0u];
        float _e170 = w;
        float _e175 = reach;
        float _e178 = shade;
        shade = _e178 * (1.0 - (((0.6 * _e166) * metal::exp(_e169 / (0.15 * _e170))) * _e175));
    }
    float _e180 = shade;
    metal::float4 _e181 = img;
    metal::float3 _e183 = _e181.xyz * _e180;
    img[0u] = _e183.x;
    img[1u] = _e183.y;
    img[2u] = _e183.z;
    metal::float4 _e190 = color;
    metal::float4 _e191 = img;
    float _e192 = m;
    return metal::mix(_e190, _e191, metal::float4(_e192));
}

float knockPart_u0028_(
    constant Uniforms& uniforms
) {
    float _e37 = uniforms.knock;
    return metal::clamp(_e37, 0.05, 1.0);
}

float fallAngle(
    thread float& t_1
) {
    float _e37 = t_1;
    float _e39 = t_1;
    return (1.5707964 * _e37) * (0.2 + (0.8 * _e39));
}

float fallTime(
    thread float& j_1,
    thread float& n,
    constant Uniforms& uniforms
) {
    float k = {};
    float d_1 = {};
    float _e41 = uniforms.progress;
    if (_e41 >= 1.0) {
        return 1.0;
    }
    float _e43 = knockPart_u0028_(uniforms);
    k = _e43;
    float _e44 = n;
    float _e46 = k;
    d_1 = 1.0 / (1.0 + ((_e44 - 1.0) * _e46));
    float _e51 = uniforms.progress;
    float _e52 = j_1;
    float _e53 = k;
    float _e55 = d_1;
    float _e58 = d_1;
    return metal::clamp((_e51 - ((_e52 * _e53) * _e55)) / _e58, 0.0, 1.0);
}

metal::float4 slatPoint(
    thread float& j_2,
    thread float& n_1,
    thread float& w_1,
    thread float& xc,
    thread float& y,
    constant Uniforms& uniforms
) {
    metal::float4 none = {};
    float t_2 = {};
    float param_1 = {};
    float param_2 = {};
    float a = {};
    float param_3 = {};
    float c = {};
    float s_1 = {};
    metal::float3 eye = {};
    metal::float3 dir = {};
    float den = {};
    float r = {};
    metal::float3 hit = {};
    float h = {};
    float side = {};
    bool phi_152_ = {};
    none = metal::float4(0.0, 0.0, -1.0, 0.0);
    float _e56 = j_2;
    bool _e57 = _e56 < 0.0;
    phi_152_ = _e57;
    if (!(_e57)) {
        float _e59 = j_2;
        float _e60 = n_1;
        phi_152_ = _e59 > (_e60 - 1.0);
    }
    bool _e64 = phi_152_;
    if (_e64) {
        metal::float4 _e65 = none;
        return _e65;
    }
    float _e66 = j_2;
    param_1 = _e66;
    float _e67 = n_1;
    param_2 = _e67;
    float _e68 = fallTime(param_1, param_2, uniforms);
    t_2 = _e68;
    float _e69 = t_2;
    if (_e69 >= 1.0) {
        metal::float4 _e71 = none;
        return _e71;
    }
    float _e72 = t_2;
    param_3 = _e72;
    float _e73 = fallAngle(param_3);
    a = _e73;
    float _e74 = a;
    c = metal::cos(_e74);
    float _e76 = a;
    s_1 = metal::sin(_e76);
    float _e78 = j_2;
    float _e80 = w_1;
    float _e82 = c;
    float _e85 = uniforms.perspective;
    eye = metal::float3((_e78 + 0.5) * _e80, 0.5 * _e82, -1.0 / metal::max(_e85, 0.01));
    float _e89 = xc;
    float _e90 = y;
    metal::float3 _e92 = eye;
    dir = metal::float3(_e89, _e90, 0.0) - _e92;
    float _e95 = dir[2u];
    float _e96 = c;
    float _e99 = dir[1u];
    float _e100 = s_1;
    den = (_e95 * _e96) - (_e99 * _e100);
    float _e103 = den;
    if (_e103 <= 0.0) {
        metal::float4 _e105 = none;
        return _e105;
    }
    float _e107 = eye[1u];
    float _e108 = s_1;
    float _e111 = eye[2u];
    float _e112 = c;
    float _e115 = den;
    r = ((_e107 * _e108) - (_e111 * _e112)) / _e115;
    metal::float3 _e117 = eye;
    float _e118 = r;
    metal::float3 _e119 = dir;
    hit = _e117 + (_e119 * _e118);
    float _e123 = hit[1u];
    float _e124 = c;
    float _e127 = hit[2u];
    float _e128 = s_1;
    h = (_e123 * _e124) + (_e127 * _e128);
    float _e131 = r;
    float _e133 = h;
    if ((_e131 <= 0.0) || (_e133 < 0.0)) {
        metal::float4 _e136 = none;
        return _e136;
    }
    float _e138 = uniforms.lean;
    float _e140 = w_1;
    float _e142 = t_2;
    float _e143 = knockPart_u0028_(uniforms);
    float _e147 = h;
    side = ((metal::clamp(_e138, 0.0, 1.0) * _e140) * metal::min(_e142 / _e143, 1.0)) * _e147;
    float _e150 = hit[0u];
    float _e151 = side;
    float _e153 = j_2;
    float _e154 = w_1;
    float _e157 = h;
    float _e158 = t_2;
    float _e159 = a;
    return metal::float4((_e150 - _e151) - (_e153 * _e154), _e157, _e158, _e159);
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e38 = uv_1[0u];
    float _e40 = uv_1[1u];
    metal::float4 _e43 = _to.sample(_sampler, metal::float2(_e38, 1.0 - _e40), metal::level(0.0));
    return _e43;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n_2 = {};
    int local_1 = {};
    float w_2 = {};
    float xc_1 = {};
    float local_2 = {};
    float col = {};
    metal::float4 color_1 = {};
    metal::float2 param_4 = {};
    float t0_ = {};
    float param_5 = {};
    float param_6 = {};
    metal::float4 cur = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    metal::float4 param_17 = {};
    float param_18 = {};
    metal::float4 param_19 = {};
    metal::float4 param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    metal::float4 param_27 = {};
    float param_28 = {};
    metal::float4 param_29 = {};
    metal::float4 param_30 = {};
    float param_31 = {};
    int _e75 = uniforms.count;
    if (_e75 < 1) {
        local_1 = 1;
    } else {
        int _e78 = uniforms.count;
        local_1 = _e78;
    }
    int _e79 = local_1;
    n_2 = static_cast<float>(_e79);
    float _e82 = uniforms.ratio;
    float _e83 = n_2;
    w_2 = _e82 / _e83;
    int _e86 = uniforms.reverse;
    if (_e86 != 0) {
        float _e89 = uv_2[0u];
        local_2 = 1.0 - _e89;
    } else {
        float _e92 = uv_2[0u];
        local_2 = _e92;
    }
    float _e93 = local_2;
    float _e95 = uniforms.ratio;
    xc_1 = _e93 * _e95;
    float _e97 = xc_1;
    float _e98 = w_2;
    float _e101 = n_2;
    col = metal::clamp(metal::floor(_e97 / _e98), 0.0, _e101 - 1.0);
    metal::float2 _e104 = uv_2;
    param_4 = _e104;
    metal::float4 _e105 = getToColor(param_4, _sampler, _to);
    color_1 = _e105;
    float _e106 = col;
    param_5 = _e106;
    float _e107 = n_2;
    param_6 = _e107;
    float _e108 = fallTime(param_5, param_6, uniforms);
    t0_ = _e108;
    float _e110 = uniforms.shading;
    float _e112 = t0_;
    float _e114 = t0_;
    float _e118 = uv_2[1u];
    metal::float4 _e123 = color_1;
    metal::float3 _e125 = _e123.xyz * (1.0 - ((((2.4 * _e110) * _e112) * (1.0 - _e114)) * metal::exp(-40.0 * _e118)));
    color_1[0u] = _e125.x;
    color_1[1u] = _e125.y;
    color_1[2u] = _e125.z;
    float _e132 = col;
    param_7 = _e132;
    float _e133 = n_2;
    param_8 = _e133;
    float _e134 = w_2;
    param_9 = _e134;
    float _e135 = xc_1;
    param_10 = _e135;
    float _e137 = uv_2[1u];
    param_11 = _e137;
    metal::float4 _e138 = slatPoint(param_7, param_8, param_9, param_10, param_11, uniforms);
    cur = _e138;
    float _e139 = col;
    float _e141 = col;
    param_12 = _e141 - 1.0;
    float _e143 = n_2;
    param_13 = _e143;
    float _e144 = w_2;
    param_14 = _e144;
    float _e145 = xc_1;
    param_15 = _e145;
    float _e147 = uv_2[1u];
    param_16 = _e147;
    metal::float4 _e148 = slatPoint(param_12, param_13, param_14, param_15, param_16, uniforms);
    metal::float4 _e149 = color_1;
    param_17 = _e149;
    param_18 = _e139 - 1.0;
    param_19 = _e148;
    metal::float4 _e150 = cur;
    param_20 = _e150;
    float _e151 = w_2;
    param_21 = _e151;
    metal::float4 _e152 = drawSlat(param_17, param_18, param_19, param_20, param_21, _from, _sampler, uniforms);
    color_1 = _e152;
    float _e153 = col;
    param_22 = _e153 + 1.0;
    float _e155 = n_2;
    param_23 = _e155;
    float _e156 = w_2;
    param_24 = _e156;
    float _e157 = xc_1;
    param_25 = _e157;
    float _e159 = uv_2[1u];
    param_26 = _e159;
    metal::float4 _e160 = slatPoint(param_22, param_23, param_24, param_25, param_26, uniforms);
    metal::float4 _e161 = color_1;
    param_27 = _e161;
    float _e162 = col;
    param_28 = _e162;
    metal::float4 _e163 = cur;
    param_29 = _e163;
    param_30 = _e160;
    float _e164 = w_2;
    param_31 = _e164;
    metal::float4 _e165 = drawSlat(param_27, param_28, param_29, param_30, param_31, _from, _sampler, uniforms);
    color_1 = _e165;
    metal::float4 _e166 = color_1;
    return _e166;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_32 = {};
    metal::float2 _e37 = _uv_1;
    param_32 = _e37;
    metal::float4 _e38 = transition(param_32, _from, _sampler, _to, uniforms);
    _fragColor = _e38;
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
