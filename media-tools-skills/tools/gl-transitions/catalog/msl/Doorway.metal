// Doorway — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Doorway.glsl
// Author: gre
// License: MIT
// Description: The outgoing image opens like double doors swinging toward the viewer, as the incoming one comes forward from the dark room behind, with a floor reflection
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float reflection;
    float perspective;
    float depth;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e44 = uv[0u];
    float _e46 = uv[1u];
    metal::float4 _e49 = _from.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float2 leafHit(
    thread float& x,
    thread float& w,
    thread float& eye,
    thread float& a
) {
    float c = {};
    float s = {};
    float t = {};
    metal::float2 hit = {};
    float _e50 = a;
    c = metal::cos(_e50);
    float _e52 = a;
    s = metal::sin(_e52);
    float _e54 = eye;
    float _e55 = c;
    float _e57 = w;
    float _e59 = s;
    float _e62 = s;
    float _e63 = x;
    float _e64 = w;
    float _e68 = eye;
    float _e69 = c;
    t = ((_e54 * _e55) - ((0.5 * _e57) * _e59)) / ((_e62 * (_e63 - (0.5 * _e64))) + (_e68 * _e69));
    float _e73 = w;
    float _e75 = t;
    float _e76 = x;
    float _e77 = w;
    float _e82 = eye;
    float _e83 = t;
    hit = metal::float2((0.5 * _e73) + (_e75 * (_e76 - (0.5 * _e77))), _e82 * (_e83 - 1.0));
    float _e87 = t;
    float _e89 = hit[0u];
    float _e90 = c;
    float _e93 = hit[1u];
    float _e94 = s;
    return metal::float2(_e87, (_e89 * _e90) - (_e93 * _e94));
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e44 = uv_1[0u];
    float _e46 = uv_1[1u];
    metal::float4 _e49 = _to.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 room(
    thread metal::float2& uv_2,
    thread float& x_1,
    thread float& edgeL,
    thread float& edgeR,
    thread float& close,
    thread float& dolly,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float size = {};
    metal::float2 p = {};
    float soft = {};
    metal::float2 m = {};
    metal::float4 c_1 = {};
    metal::float2 param = {};
    metal::float2 r = {};
    float f = {};
    metal::float2 param_1 = {};
    float wl = {};
    float shadow = {};
    float light = {};
    float _e61 = uniforms.depth;
    float _e63 = dolly;
    size = metal::mix(metal::max(_e61, 1.0), 1.0, _e63);
    metal::float2 _e65 = uv_2;
    float _e68 = size;
    p = ((_e65 - metal::float2(0.5)) * _e68) + metal::float2(0.5);
    float _e72 = size;
    soft = (0.004 * (_e72 - 1.0)) + 0.000001;
    float _e76 = soft;
    float _e78 = soft;
    metal::float2 _e79 = p;
    float _e83 = soft;
    float _e85 = soft;
    metal::float2 _e86 = p;
    m = metal::smoothstep(metal::float2(-(_e76)), metal::float2(_e78), _e79) * metal::smoothstep(metal::float2(-(_e83)), metal::float2(_e85), metal::float2(1.0) - _e86);
    metal::float2 _e93 = p;
    param = metal::clamp(_e93, metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e97 = getToColor(param, _sampler, _to);
    float _e99 = m[0u];
    float _e101 = m[1u];
    c_1 = _e97 * (_e99 * _e101);
    float _e105 = p[1u];
    if (_e105 < 0.0) {
        float _e108 = p[0u];
        float _e110 = p[1u];
        r = metal::float2(_e108, (-1.2 * _e110) - 0.02);
        float _e115 = uniforms.reflection;
        float _e117 = r[1u];
        float _e121 = m[0u];
        float _e124 = r[1u];
        f = ((_e115 * (1.0 - _e117)) * _e121) * metal::smoothstep(0.0, 0.01, _e124);
        metal::float2 _e127 = r;
        param_1 = metal::clamp(_e127, metal::float2(0.0), metal::float2(1.0));
        metal::float4 _e131 = getToColor(param_1, _sampler, _to);
        float _e132 = f;
        float _e135 = m[1u];
        metal::float4 _e138 = c_1;
        c_1 = _e138 + ((_e131 * _e132) * (1.0 - _e135));
    }
    float _e140 = close;
    wl = 0.03 + (0.12 * _e140);
    float _e143 = wl;
    float _e144 = x_1;
    float _e145 = edgeL;
    float _e149 = wl;
    float _e150 = edgeR;
    float _e151 = x_1;
    shadow = (1.0 - metal::smoothstep(0.0, _e143, _e144 - _e145)) + (1.0 - metal::smoothstep(0.0, _e149, _e150 - _e151));
    float _e156 = close;
    float _e158 = close;
    float _e161 = close;
    float _e163 = shadow;
    light = (1.0 + ((0.6 * _e156) * _e158)) * (1.0 - ((0.7 * _e161) * metal::min(_e163, 1.0)));
    metal::float4 _e168 = c_1;
    float _e170 = light;
    float _e173 = c_1[3u];
    metal::float3 _e175 = metal::min(_e168.xyz * _e170, metal::float3(_e173));
    float _e177 = c_1[3u];
    return metal::float4(_e175.x, _e175.y, _e175.z, _e177);
}

float project(
    thread metal::float2& p_1,
    thread float& w_1,
    thread float& eye_1
) {
    float _e45 = w_1;
    float _e48 = p_1[0u];
    float _e49 = w_1;
    float _e52 = eye_1;
    float _e54 = eye_1;
    float _e56 = p_1[1u];
    return (0.5 * _e45) + (((_e48 - (0.5 * _e49)) * _e52) / (_e54 + _e56));
}

float easeInOut(
    thread float& t_1
) {
    float local = {};
    float _e44 = t_1;
    if (_e44 < 0.5) {
        float _e46 = t_1;
        float _e48 = t_1;
        float _e50 = t_1;
        local = ((4.0 * _e46) * _e48) * _e50;
    } else {
        float _e52 = t_1;
        float _e55 = t_1;
        float _e58 = t_1;
        local = 1.0 - (((4.0 * (1.0 - _e52)) * (1.0 - _e55)) * (1.0 - _e58));
    }
    float _e62 = local;
    return _e62;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float w_2 = {};
    float x_2 = {};
    float eye_2 = {};
    float swing = {};
    float a_1 = {};
    float dolly_1 = {};
    float param_2 = {};
    float hw = {};
    metal::float2 front = {};
    float thick = {};
    float edgeL_1 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float backL = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float close_1 = {};
    metal::float4 back = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    bool left = {};
    float lx = {};
    float local_1 = {};
    metal::float2 hit_1 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float s_1 = {};
    float v = {};
    metal::float4 leaf = {};
    float local_2 = {};
    metal::float2 param_19 = {};
    metal::float4 side = {};
    metal::float2 param_20 = {};
    float aa = {};
    metal::float4 c_2 = {};
    float _e87 = uniforms.ratio;
    w_2 = _e87;
    float _e89 = uv_3[0u];
    float _e90 = w_2;
    x_2 = _e89 * _e90;
    float _e92 = w_2;
    float _e95 = uniforms.perspective;
    eye_2 = metal::max(_e92, 1.0) * (0.5 + (0.2 / metal::max(_e95, 0.01)));
    float _e101 = uniforms.progress;
    float _e103 = uniforms.progress;
    float _e106 = uniforms.progress;
    swing = (_e101 * _e103) * (3.0 - (2.0 * _e106));
    float _e110 = eye_2;
    float _e112 = w_2;
    float _e117 = swing;
    a_1 = metal::min(metal::atan((2.0 * _e110) / _e112) + 0.1, 1.5707964) * _e117;
    float _e120 = uniforms.progress;
    param_2 = _e120;
    float _e121 = easeInOut(param_2);
    float _e123 = uniforms.progress;
    dolly_1 = metal::mix(_e121, _e123, 0.3);
    float _e125 = w_2;
    hw = 0.5 * _e125;
    float _e127 = hw;
    float _e128 = a_1;
    float _e130 = a_1;
    front = metal::float2(metal::cos(_e128), -(metal::sin(_e130))) * _e127;
    float _e135 = w_2;
    float _e137 = swing;
    thick = (0.02 * _e135) * (1.0 - metal::smoothstep(0.8, 1.0, _e137));
    metal::float2 _e141 = front;
    param_3 = _e141;
    float _e142 = w_2;
    param_4 = _e142;
    float _e143 = eye_2;
    param_5 = _e143;
    float _e144 = project(param_3, param_4, param_5);
    edgeL_1 = _e144;
    metal::float2 _e145 = front;
    float _e146 = thick;
    float _e147 = a_1;
    float _e149 = a_1;
    param_6 = _e145 + (metal::float2(metal::sin(_e147), metal::cos(_e149)) * _e146);
    float _e154 = w_2;
    param_7 = _e154;
    float _e155 = eye_2;
    param_8 = _e155;
    float _e156 = project(param_6, param_7, param_8);
    backL = _e156;
    float _e157 = swing;
    close_1 = 1.0 - _e157;
    float _e159 = w_2;
    float _e160 = backL;
    metal::float2 _e162 = uv_3;
    param_9 = _e162;
    float _e163 = x_2;
    param_10 = _e163;
    float _e164 = backL;
    param_11 = _e164;
    param_12 = _e159 - _e160;
    float _e165 = close_1;
    param_13 = _e165;
    float _e166 = dolly_1;
    param_14 = _e166;
    metal::float4 _e167 = room(param_9, param_10, param_11, param_12, param_13, param_14, _sampler, _to, uniforms);
    back = _e167;
    float _e168 = x_2;
    float _e169 = hw;
    left = _e168 < _e169;
    bool _e171 = left;
    if (_e171) {
        float _e172 = x_2;
        local_1 = _e172;
    } else {
        float _e173 = w_2;
        float _e174 = x_2;
        local_1 = _e173 - _e174;
    }
    float _e176 = local_1;
    lx = _e176;
    float _e177 = lx;
    param_15 = _e177;
    float _e178 = w_2;
    param_16 = _e178;
    float _e179 = eye_2;
    param_17 = _e179;
    float _e180 = a_1;
    param_18 = _e180;
    metal::float2 _e181 = leafHit(param_15, param_16, param_17, param_18);
    hit_1 = _e181;
    float _e183 = hit_1[1u];
    float _e184 = hw;
    s_1 = metal::clamp(_e183, 0.0, _e184);
    float _e187 = uv_3[1u];
    float _e190 = hit_1[0u];
    v = 0.5 + ((_e187 - 0.5) * _e190);
    bool _e193 = left;
    if (_e193) {
        float _e194 = s_1;
        float _e195 = w_2;
        local_2 = _e194 / _e195;
    } else {
        float _e197 = s_1;
        float _e198 = w_2;
        local_2 = 1.0 - (_e197 / _e198);
    }
    float _e201 = local_2;
    float _e202 = v;
    param_19 = metal::clamp(metal::float2(_e201, _e202), metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e207 = getFromColor(param_19, _from, _sampler);
    leaf = _e207;
    float _e208 = a_1;
    float _e213 = a_1;
    float _e216 = s_1;
    float _e217 = hw;
    metal::float4 _e221 = leaf;
    metal::float3 _e223 = _e221.xyz * ((1.0 - (0.5 * (1.0 - metal::cos(_e208)))) - ((0.25 * metal::sin(_e213)) * (_e216 / _e217)));
    leaf[0u] = _e223.x;
    leaf[1u] = _e223.y;
    leaf[2u] = _e223.z;
    bool _e230 = left;
    float _e232 = v;
    param_20 = metal::clamp(metal::float2(_e230 ? 0.499 : 0.501, _e232), metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e237 = getFromColor(param_20, _from, _sampler);
    side = _e237;
    metal::float4 _e238 = side;
    float _e242 = side[3u];
    metal::float3 _e244 = metal::min(_e238.xyz * 1.5, metal::float3(_e242));
    side[0u] = _e244.x;
    side[1u] = _e244.y;
    side[2u] = _e244.z;
    float _e251 = a_1;
    float _e252 = close_1;
    aa = (0.003 * metal::min(1.0, 20.0 * metal::min(_e251, _e252))) + 0.000001;
    metal::float4 _e258 = back;
    metal::float4 _e259 = side;
    float _e260 = aa;
    float _e262 = aa;
    float _e263 = backL;
    float _e264 = lx;
    c_2 = metal::mix(_e258, _e259, metal::float4(metal::smoothstep(-(_e260), _e262, _e263 - _e264)));
    metal::float4 _e269 = c_2;
    metal::float4 _e270 = leaf;
    float _e271 = aa;
    float _e273 = aa;
    float _e274 = edgeL_1;
    float _e275 = lx;
    return metal::mix(_e269, _e270, metal::float4(metal::smoothstep(-(_e271), _e273, _e274 - _e275)));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_21 = {};
    metal::float2 _e43 = _uv_1;
    param_21 = _e43;
    metal::float4 _e44 = transition(param_21, _from, _sampler, _to, uniforms);
    _fragColor = _e44;
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
