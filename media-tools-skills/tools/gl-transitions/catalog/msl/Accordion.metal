// Accordion — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Accordion.glsl
// Author: gre
// License: MIT
// Description: The outgoing image folds up like a pleated paper toward one side while the incoming one unfolds out of the other, both in 3D with lit and shadowed pleats
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int pleats;
    char _pad3[4];
    metal::float2 direction;
    float shading;
    float perspective;
    metal::float4 backColor;
};

float panelLight(
    thread float& c,
    thread float& s,
    thread float& facing,
    constant Uniforms& uniforms
) {
    float lambert = {};
    float _e37 = c;
    float _e39 = facing;
    float _e40 = s;
    lambert = ((_e37 * 0.835) + ((_e39 * _e40) * 0.55)) / 0.835;
    float _e45 = lambert;
    float _e48 = uniforms.shading;
    return metal::mix(1.0, metal::clamp(_e45, 0.08, 1.25), _e48);
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 pleated(
    thread float& f,
    thread float& c_1,
    thread float& len,
    thread float& b,
    thread float& bLen,
    thread bool& incoming,
    thread bool& flipA,
    thread bool& vertical,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float m = {};
    int local = {};
    float s_1 = {};
    float u = {};
    float panel = {};
    float fu = {};
    float tri = {};
    float panelLen = {};
    float z = {};
    float scale = {};
    float bb = {};
    float edge = {};
    float cover = {};
    float a = {};
    float local_1 = {};
    metal::float2 st = {};
    metal::float2 local_2 = {};
    metal::float4 img = {};
    metal::float4 local_3 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float facing_1 = {};
    float toEdge = {};
    float k = {};
    float light = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float valley = {};
    int _e74 = uniforms.pleats;
    if (_e74 > 1) {
        int _e77 = uniforms.pleats;
        local = _e77;
    } else {
        local = 1;
    }
    int _e78 = local;
    m = 2.0 * static_cast<float>(_e78);
    float _e81 = c_1;
    float _e82 = c_1;
    s_1 = metal::sqrt(metal::max(1.0 - (_e81 * _e82), 0.0));
    float _e87 = f;
    float _e88 = m;
    u = _e87 * _e88;
    float _e90 = u;
    float _e92 = m;
    panel = metal::min(metal::floor(_e90), _e92 - 1.0);
    float _e95 = u;
    float _e96 = panel;
    fu = _e95 - _e96;
    float _e98 = u;
    tri = 1.0 - metal::abs((_e98 - (metal::floor(_e98 / 2.0) * 2.0)) - 1.0);
    float _e106 = len;
    float _e107 = m;
    panelLen = _e106 / _e107;
    float _e109 = panelLen;
    float _e110 = s_1;
    float _e112 = tri;
    z = (_e109 * _e110) * (1.0 - _e112);
    float _e116 = uniforms.perspective;
    float _e117 = z;
    scale = 1.0 / (1.0 + (_e116 * _e117));
    float _e121 = b;
    float _e122 = bLen;
    float _e125 = scale;
    float _e127 = bLen;
    bb = (((_e121 - (0.5 * _e122)) / _e125) / _e127) + 0.5;
    float _e130 = s_1;
    float _e132 = c_1;
    edge = (0.0015 * metal::min(1.0, (20.0 * _e130) * _e132)) + 0.000001;
    float _e137 = bb;
    float _e138 = bb;
    float _e141 = bLen;
    float _e143 = scale;
    float _e145 = edge;
    cover = metal::clamp(((metal::min(_e137, 1.0 - _e138) * _e141) * _e143) / _e145, 0.0, 1.0);
    bool _e148 = flipA;
    if (_e148) {
        float _e149 = f;
        local_1 = 1.0 - _e149;
    } else {
        float _e151 = f;
        local_1 = _e151;
    }
    float _e152 = local_1;
    a = _e152;
    bool _e153 = vertical;
    if (_e153) {
        float _e154 = bb;
        float _e155 = a;
        local_2 = metal::float2(_e154, _e155);
    } else {
        float _e157 = a;
        float _e158 = bb;
        local_2 = metal::float2(_e157, _e158);
    }
    metal::float2 _e160 = local_2;
    st = metal::clamp(_e160, metal::float2(0.0), metal::float2(1.0));
    bool _e164 = incoming;
    if (_e164) {
        metal::float2 _e165 = st;
        param = _e165;
        metal::float4 _e166 = getToColor(param, _sampler, _to);
        local_3 = _e166;
    } else {
        metal::float2 _e167 = st;
        param_1 = _e167;
        metal::float4 _e168 = getFromColor(param_1, _from, _sampler);
        local_3 = _e168;
    }
    metal::float4 _e169 = local_3;
    img = _e169;
    float _e170 = panel;
    facing_1 = ((_e170 - (metal::floor(_e170 / 2.0) * 2.0)) < 0.5) ? 1.0 : -1.0;
    float _e177 = fu;
    float _e178 = fu;
    float _e181 = panelLen;
    float _e183 = c_1;
    toEdge = (metal::min(_e177, 1.0 - _e178) * _e181) * _e183;
    float _e185 = toEdge;
    k = 0.5 + (0.5 * metal::clamp(_e185 / 0.0015, 0.0, 1.0));
    float _e190 = facing_1;
    float _e192 = c_1;
    param_2 = _e192;
    float _e193 = s_1;
    param_3 = _e193;
    param_4 = -(_e190);
    float _e194 = panelLight(param_2, param_3, param_4, uniforms);
    float _e195 = c_1;
    param_5 = _e195;
    float _e196 = s_1;
    param_6 = _e196;
    float _e197 = facing_1;
    param_7 = _e197;
    float _e198 = panelLight(param_5, param_6, param_7, uniforms);
    float _e199 = k;
    light = metal::mix(_e194, _e198, _e199);
    float _e201 = tri;
    valley = 1.0 - _e201;
    float _e204 = uniforms.shading;
    float _e206 = s_1;
    float _e208 = valley;
    float _e210 = valley;
    float _e213 = light;
    light = _e213 * (1.0 - ((((0.4 * _e204) * _e206) * _e208) * _e210));
    metal::float4 _e216 = uniforms.backColor;
    metal::float4 _e217 = img;
    float _e219 = light;
    metal::float3 _e220 = _e217.xyz * _e219;
    float _e222 = img[3u];
    float _e227 = cover;
    return metal::mix(_e216, metal::float4(_e220.x, _e220.y, _e220.z, _e222), metal::float4(_e227));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    bool vertical_1 = {};
    bool positive = {};
    bool local_4 = {};
    float a_1 = {};
    float local_5 = {};
    float b_1 = {};
    float local_6 = {};
    float len_1 = {};
    float local_7 = {};
    float bLen_1 = {};
    float local_8 = {};
    float p = {};
    float e = {};
    float cFrom = {};
    float cTo = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    bool param_13 = {};
    bool param_14 = {};
    bool param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float param_20 = {};
    bool param_21 = {};
    bool param_22 = {};
    bool param_23 = {};
    float _e67 = uniforms.direction[1u];
    float _e71 = uniforms.direction[0u];
    vertical_1 = metal::abs(_e67) > metal::abs(_e71);
    bool _e74 = vertical_1;
    if (_e74) {
        float _e77 = uniforms.direction[1u];
        local_4 = _e77 > 0.0;
    } else {
        float _e81 = uniforms.direction[0u];
        local_4 = _e81 > 0.0;
    }
    bool _e83 = local_4;
    positive = _e83;
    bool _e84 = vertical_1;
    if (_e84) {
        float _e86 = uv_2[1u];
        local_5 = _e86;
    } else {
        float _e88 = uv_2[0u];
        local_5 = _e88;
    }
    float _e89 = local_5;
    a_1 = _e89;
    bool _e90 = positive;
    if (_e90) {
        float _e91 = a_1;
        a_1 = 1.0 - _e91;
    }
    bool _e93 = vertical_1;
    if (_e93) {
        float _e95 = uv_2[0u];
        local_6 = _e95;
    } else {
        float _e97 = uv_2[1u];
        local_6 = _e97;
    }
    float _e98 = local_6;
    b_1 = _e98;
    bool _e99 = vertical_1;
    if (_e99) {
        local_7 = 1.0;
    } else {
        float _e101 = uniforms.ratio;
        local_7 = _e101;
    }
    float _e102 = local_7;
    len_1 = _e102;
    bool _e103 = vertical_1;
    if (_e103) {
        float _e105 = uniforms.ratio;
        local_8 = _e105;
    } else {
        local_8 = 1.0;
    }
    float _e106 = local_8;
    bLen_1 = _e106;
    float _e108 = uniforms.progress;
    p = _e108;
    float _e109 = p;
    float _e110 = p;
    float _e112 = p;
    e = (_e109 * _e110) * (3.0 - (2.0 * _e112));
    float _e116 = p;
    float _e117 = e;
    e = metal::mix(_e116, _e117, 0.8);
    float _e119 = e;
    cFrom = 1.0 - _e119;
    float _e121 = e;
    cTo = _e121;
    float _e122 = a_1;
    float _e123 = cFrom;
    float _e125 = cTo;
    if ((_e122 < _e123) || (_e125 <= 0.0)) {
        float _e128 = a_1;
        float _e129 = cFrom;
        float _e131 = b_1;
        float _e132 = bLen_1;
        param_8 = _e128 / _e129;
        float _e134 = cFrom;
        param_9 = _e134;
        float _e135 = len_1;
        param_10 = _e135;
        param_11 = _e131 * _e132;
        float _e136 = bLen_1;
        param_12 = _e136;
        param_13 = false;
        bool _e137 = positive;
        param_14 = _e137;
        bool _e138 = vertical_1;
        param_15 = _e138;
        metal::float4 _e139 = pleated(param_8, param_9, param_10, param_11, param_12, param_13, param_14, param_15, _from, _sampler, _to, uniforms);
        return _e139;
    }
    float _e140 = a_1;
    float _e142 = cTo;
    float _e145 = b_1;
    float _e146 = bLen_1;
    param_16 = 1.0 - ((1.0 - _e140) / _e142);
    float _e148 = cTo;
    param_17 = _e148;
    float _e149 = len_1;
    param_18 = _e149;
    param_19 = _e145 * _e146;
    float _e150 = bLen_1;
    param_20 = _e150;
    param_21 = true;
    bool _e151 = positive;
    param_22 = _e151;
    bool _e152 = vertical_1;
    param_23 = _e152;
    metal::float4 _e153 = pleated(param_16, param_17, param_18, param_19, param_20, param_21, param_22, param_23, _from, _sampler, _to, uniforms);
    return _e153;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_24 = {};
    metal::float2 _e34 = _uv_1;
    param_24 = _e34;
    metal::float4 _e35 = transition(param_24, _from, _sampler, _to, uniforms);
    _fragColor = _e35;
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
