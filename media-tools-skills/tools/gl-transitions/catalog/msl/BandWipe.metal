// BandWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BandWipe.glsl
// Author: gre
// License: MIT
// Description: Alternating bands wipe in from opposite sides together and interleave like fingers, while both images stay still
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int bands;
    int vertical;
    float smoothness;
    float stagger;
};

float bandMask(
    thread float& i,
    thread float& n,
    thread float& a,
    thread float& l,
    thread float& s,
    constant Uniforms& uniforms
) {
    float k = {};
    float local = {};
    float g = {};
    float t = {};
    float x = {};
    float local_1 = {};
    float c = {};
    int _e36 = uniforms.vertical;
    if (_e36 != 0) {
        float _e38 = i;
        local = _e38;
    } else {
        float _e39 = n;
        float _e41 = i;
        local = (_e39 - 1.0) - _e41;
    }
    float _e43 = local;
    k = _e43;
    float _e45 = uniforms.stagger;
    g = metal::clamp(_e45, 0.0, 0.95);
    float _e48 = uniforms.progress;
    float _e49 = g;
    float _e50 = k;
    float _e52 = n;
    float _e57 = g;
    t = metal::clamp((_e48 - ((_e49 * _e50) / metal::max(_e52 - 1.0, 1.0))) / (1.0 - _e57), 0.0, 1.0);
    float _e61 = t;
    float _e62 = t;
    float _e63 = t;
    float _e65 = t;
    t = metal::mix(_e61, (_e62 * _e63) * (3.0 - (2.0 * _e65)), 0.5);
    float _e70 = i;
    if ((_e70 - (metal::floor(_e70 / 2.0) * 2.0)) > 0.5) {
        float _e76 = l;
        float _e77 = a;
        local_1 = _e76 - _e77;
    } else {
        float _e79 = a;
        local_1 = _e79;
    }
    float _e80 = local_1;
    x = _e80;
    float _e81 = s;
    float _e83 = l;
    float _e84 = s;
    float _e86 = t;
    c = metal::mix(-(_e81), _e83 + _e84, _e86);
    float _e88 = c;
    float _e89 = s;
    float _e91 = c;
    float _e92 = s;
    float _e94 = x;
    return 1.0 - metal::smoothstep(_e88 - _e89, _e91 + _e92, _e94);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e25 = uv[0u];
    float _e27 = uv[1u];
    metal::float4 _e30 = _to.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e25 = uv_1[0u];
    float _e27 = uv_1[1u];
    metal::float4 _e30 = _from.sample(_sampler, metal::float2(_e25, 1.0 - _e27), metal::level(0.0));
    return _e30;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float n_1 = {};
    int local_2 = {};
    float along = {};
    float local_3 = {};
    float across = {};
    float local_4 = {};
    float l_1 = {};
    float local_5 = {};
    float aaAcross = {};
    float local_6 = {};
    float s_1 = {};
    float f = {};
    float i_1 = {};
    float m = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float fr = {};
    float edge = {};
    float j = {};
    float local_7 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float4 a_1 = {};
    metal::float2 param_14 = {};
    metal::float4 b = {};
    metal::float2 param_15 = {};
    metal::float4 c_1 = {};
    metal::float4 local_8 = {};
    float _e63 = uniforms.progress;
    if (_e63 <= 0.0) {
        metal::float2 _e65 = uv_2;
        param = _e65;
        metal::float4 _e66 = getFromColor(param, _from, _sampler);
        return _e66;
    }
    float _e68 = uniforms.progress;
    if (_e68 >= 1.0) {
        metal::float2 _e70 = uv_2;
        param_1 = _e70;
        metal::float4 _e71 = getToColor(param_1, _sampler, _to);
        return _e71;
    }
    int _e73 = uniforms.bands;
    if (_e73 < 1) {
        local_2 = 1;
    } else {
        int _e76 = uniforms.bands;
        local_2 = _e76;
    }
    int _e77 = local_2;
    n_1 = static_cast<float>(_e77);
    int _e80 = uniforms.vertical;
    if (_e80 != 0) {
        float _e83 = uv_2[1u];
        local_3 = _e83;
    } else {
        float _e85 = uv_2[0u];
        float _e87 = uniforms.ratio;
        local_3 = _e85 * _e87;
    }
    float _e89 = local_3;
    along = _e89;
    int _e91 = uniforms.vertical;
    if (_e91 != 0) {
        float _e94 = uv_2[0u];
        local_4 = _e94;
    } else {
        float _e96 = uv_2[1u];
        local_4 = _e96;
    }
    float _e97 = local_4;
    across = _e97;
    int _e99 = uniforms.vertical;
    if (_e99 != 0) {
        local_5 = 1.0;
    } else {
        float _e102 = uniforms.ratio;
        local_5 = _e102;
    }
    float _e103 = local_5;
    l_1 = _e103;
    int _e105 = uniforms.vertical;
    if (_e105 != 0) {
        float _e108 = uniforms.ratio;
        local_6 = 0.0015 / _e108;
    } else {
        local_6 = 0.0015;
    }
    float _e110 = local_6;
    aaAcross = _e110;
    float _e112 = uniforms.smoothness;
    s_1 = metal::max(_e112, 0.0015);
    float _e114 = across;
    float _e115 = n_1;
    f = _e114 * _e115;
    float _e117 = f;
    float _e119 = n_1;
    i_1 = metal::clamp(metal::floor(_e117), 0.0, _e119 - 1.0);
    float _e122 = i_1;
    param_2 = _e122;
    float _e123 = n_1;
    param_3 = _e123;
    float _e124 = along;
    param_4 = _e124;
    float _e125 = l_1;
    param_5 = _e125;
    float _e126 = s_1;
    param_6 = _e126;
    float _e127 = bandMask(param_2, param_3, param_4, param_5, param_6, uniforms);
    m = _e127;
    float _e128 = f;
    float _e129 = i_1;
    fr = _e128 - _e129;
    float _e131 = fr;
    float _e132 = fr;
    float _e135 = n_1;
    edge = metal::min(_e131, 1.0 - _e132) / _e135;
    float _e137 = edge;
    float _e138 = aaAcross;
    if (_e137 < _e138) {
        float _e140 = fr;
        if (_e140 < 0.5) {
            float _e142 = i_1;
            local_7 = _e142 - 1.0;
        } else {
            float _e144 = i_1;
            local_7 = _e144 + 1.0;
        }
        float _e146 = local_7;
        float _e147 = n_1;
        j = metal::clamp(_e146, 0.0, _e147 - 1.0);
        float _e150 = j;
        param_7 = _e150;
        float _e151 = n_1;
        param_8 = _e151;
        float _e152 = along;
        param_9 = _e152;
        float _e153 = l_1;
        param_10 = _e153;
        float _e154 = s_1;
        param_11 = _e154;
        float _e155 = bandMask(param_7, param_8, param_9, param_10, param_11, uniforms);
        float _e156 = m;
        float _e157 = aaAcross;
        float _e158 = edge;
        m = metal::mix(_e155, _e156, 0.5 + (0.5 * metal::smoothstep(0.0, _e157, _e158)));
    }
    float _e163 = m;
    if (_e163 <= 0.0) {
        metal::float2 _e165 = uv_2;
        param_12 = _e165;
        metal::float4 _e166 = getFromColor(param_12, _from, _sampler);
        return _e166;
    }
    float _e167 = m;
    if (_e167 >= 1.0) {
        metal::float2 _e169 = uv_2;
        param_13 = _e169;
        metal::float4 _e170 = getToColor(param_13, _sampler, _to);
        return _e170;
    }
    metal::float2 _e171 = uv_2;
    param_14 = _e171;
    metal::float4 _e172 = getFromColor(param_14, _from, _sampler);
    a_1 = _e172;
    metal::float2 _e173 = uv_2;
    param_15 = _e173;
    metal::float4 _e174 = getToColor(param_15, _sampler, _to);
    b = _e174;
    metal::float4 _e175 = a_1;
    float _e178 = a_1[3u];
    metal::float3 _e179 = _e175.xyz * _e178;
    float _e181 = a_1[3u];
    metal::float4 _e186 = b;
    float _e189 = b[3u];
    metal::float3 _e190 = _e186.xyz * _e189;
    float _e192 = b[3u];
    float _e197 = m;
    c_1 = metal::mix(metal::float4(_e179.x, _e179.y, _e179.z, _e181), metal::float4(_e190.x, _e190.y, _e190.z, _e192), metal::float4(_e197));
    float _e201 = c_1[3u];
    if (_e201 > 0.0) {
        metal::float4 _e203 = c_1;
        float _e206 = c_1[3u];
        metal::float3 _e208 = _e203.xyz / metal::float3(_e206);
        float _e210 = c_1[3u];
        local_8 = metal::float4(_e208.x, _e208.y, _e208.z, _e210);
    } else {
        local_8 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e215 = local_8;
    return _e215;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_16 = {};
    metal::float2 _e24 = _uv_1;
    param_16 = _e24;
    metal::float4 _e25 = transition(param_16, _from, _sampler, _to, uniforms);
    _fragColor = _e25;
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
