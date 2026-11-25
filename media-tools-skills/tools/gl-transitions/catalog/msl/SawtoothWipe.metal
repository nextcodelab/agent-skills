// SawtoothWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SawtoothWipe.glsl
// Author: gre
// License: MIT
// Description: A wipe whose edge is a row of sharp, regular triangular teeth sweeps across the frame, or two toothed edges that start interlocked part from the middle like jaws opening
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    int teeth;
    float depth;
    int jaws;
    float smoothness;
};

float zigzag(
    thread metal::float2& q,
    thread float& w,
    thread float& h
) {
    float x = {};
    metal::float2 a = {};
    metal::float2 ab = {};
    metal::float2 aq = {};
    float d = {};
    float local = {};
    float _e38 = q[0u];
    float _e39 = w;
    float _e44 = w;
    x = metal::abs(metal::fract(_e38 / _e39) - 0.5) * _e44;
    float _e46 = h;
    a = metal::float2(0.0, -0.5 * _e46);
    float _e49 = w;
    float _e51 = h;
    ab = metal::float2(0.5 * _e49, _e51);
    float _e53 = x;
    float _e55 = q[1u];
    metal::float2 _e57 = a;
    aq = metal::float2(_e53, _e55) - _e57;
    metal::float2 _e59 = aq;
    metal::float2 _e60 = ab;
    metal::float2 _e61 = aq;
    metal::float2 _e62 = ab;
    metal::float2 _e64 = ab;
    metal::float2 _e65 = ab;
    d = metal::length(_e59 - (_e60 * metal::clamp(metal::dot(_e61, _e62) / metal::dot(_e64, _e65), 0.0, 1.0)));
    float _e73 = q[1u];
    float _e74 = h;
    float _e75 = x;
    float _e77 = w;
    if (_e73 > (_e74 * (((2.0 * _e75) / _e77) - 0.5))) {
        float _e82 = d;
        local = _e82;
    } else {
        float _e83 = d;
        local = -(_e83);
    }
    float _e85 = local;
    return _e85;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e30 = uv[0u];
    float _e32 = uv[1u];
    metal::float4 _e35 = _to.sample(_sampler, metal::float2(_e30, 1.0 - _e32), metal::level(0.0));
    return _e35;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e30 = uv_1[0u];
    float _e32 = uv_1[1u];
    metal::float4 _e35 = _from.sample(_sampler, metal::float2(_e30, 1.0 - _e32), metal::level(0.0));
    return _e35;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a_1 = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    metal::float2 dir = {};
    metal::float2 local_1 = {};
    metal::float2 p = {};
    float e = {};
    float w_1 = {};
    float period = {};
    int local_2 = {};
    metal::float2 q_1 = {};
    float h_1 = {};
    float s = {};
    float t = {};
    float overlap = {};
    float o = {};
    float d_1 = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    float param_4 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float c = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float m = {};
    metal::float4 c_1 = {};
    metal::float4 local_3 = {};
    metal::float2 _e60 = uv_2;
    param = _e60;
    metal::float4 _e61 = getFromColor(param, _from, _sampler);
    a_1 = _e61;
    metal::float2 _e62 = uv_2;
    param_1 = _e62;
    metal::float4 _e63 = getToColor(param_1, _sampler, _to);
    b = _e63;
    float _e65 = uniforms.progress;
    if (_e65 <= 0.0) {
        metal::float4 _e67 = a_1;
        return _e67;
    }
    float _e69 = uniforms.progress;
    if (_e69 >= 1.0) {
        metal::float4 _e71 = b;
        return _e71;
    }
    metal::float2 _e73 = uniforms.direction;
    if (metal::length(_e73) > 0.0) {
        metal::float2 _e77 = uniforms.direction;
        local_1 = metal::normalize(_e77);
    } else {
        local_1 = metal::float2(1.0, 0.0);
    }
    metal::float2 _e79 = local_1;
    dir = _e79;
    metal::float2 _e80 = uv_2;
    float _e84 = uniforms.ratio;
    p = (_e80 - metal::float2(0.5)) * metal::float2(_e84, 1.0);
    float _e88 = dir[0u];
    float _e91 = uniforms.ratio;
    float _e94 = dir[1u];
    e = 0.5 * ((metal::abs(_e88) * _e91) + metal::abs(_e94));
    float _e99 = dir[1u];
    float _e102 = uniforms.ratio;
    float _e105 = dir[0u];
    w_1 = 0.5 * ((metal::abs(_e99) * _e102) + metal::abs(_e105));
    float _e109 = w_1;
    int _e112 = uniforms.teeth;
    if (_e112 < 1) {
        local_2 = 1;
    } else {
        int _e115 = uniforms.teeth;
        local_2 = _e115;
    }
    int _e116 = local_2;
    period = (2.0 * _e109) / static_cast<float>(_e116);
    metal::float2 _e119 = p;
    float _e121 = dir[1u];
    float _e124 = dir[0u];
    float _e127 = w_1;
    float _e129 = period;
    metal::float2 _e132 = p;
    metal::float2 _e133 = dir;
    q_1 = metal::float2((metal::dot(_e119, metal::float2(-(_e121), _e124)) + _e127) + (0.5 * _e129), metal::dot(_e132, _e133));
    float _e137 = uniforms.depth;
    float _e139 = period;
    h_1 = metal::max(_e137, 0.0) * _e139;
    float _e142 = uniforms.smoothness;
    float _e143 = period;
    s = metal::max(metal::min(_e142, 0.25 * _e143), 0.0015);
    float _e148 = uniforms.progress;
    float _e150 = uniforms.progress;
    float _e152 = uniforms.progress;
    float _e155 = uniforms.progress;
    t = metal::mix(_e148, (_e150 * _e152) * (3.0 - (2.0 * _e155)), 0.35);
    int _e161 = uniforms.jaws;
    if (_e161 != 0) {
        float _e163 = s;
        float _e164 = h_1;
        float _e166 = h_1;
        float _e168 = period;
        float _e169 = period;
        overlap = _e163 * metal::sqrt(1.0 + (((4.0 * _e164) * _e166) / (_e168 * _e169)));
        float _e175 = overlap;
        float _e177 = e;
        float _e178 = h_1;
        float _e181 = s;
        float _e183 = t;
        o = metal::mix(-(_e175), (_e177 + (0.5 * _e178)) + _e181, _e183);
        metal::float2 _e185 = q_1;
        float _e186 = o;
        param_2 = _e185 - metal::float2(0.0, _e186);
        float _e189 = period;
        param_3 = _e189;
        float _e190 = h_1;
        param_4 = _e190;
        float _e191 = zigzag(param_2, param_3, param_4);
        metal::float2 _e192 = q_1;
        float _e193 = o;
        param_5 = _e192 + metal::float2(0.0, _e193);
        float _e196 = period;
        param_6 = _e196;
        float _e197 = h_1;
        param_7 = _e197;
        float _e198 = zigzag(param_5, param_6, param_7);
        d_1 = metal::max(_e191, -(_e198));
    } else {
        float _e201 = e;
        float _e203 = h_1;
        float _e206 = s;
        float _e208 = e;
        float _e209 = h_1;
        float _e212 = s;
        float _e214 = t;
        c = metal::mix((-(_e201) - (0.5 * _e203)) - _e206, (_e208 + (0.5 * _e209)) + _e212, _e214);
        metal::float2 _e216 = q_1;
        float _e217 = c;
        param_8 = _e216 - metal::float2(0.0, _e217);
        float _e220 = period;
        param_9 = _e220;
        float _e221 = h_1;
        param_10 = _e221;
        float _e222 = zigzag(param_8, param_9, param_10);
        d_1 = _e222;
    }
    float _e223 = s;
    float _e225 = s;
    float _e226 = d_1;
    m = 1.0 - metal::smoothstep(-(_e223), _e225, _e226);
    metal::float4 _e229 = a_1;
    float _e232 = a_1[3u];
    metal::float3 _e233 = _e229.xyz * _e232;
    float _e235 = a_1[3u];
    metal::float4 _e240 = b;
    float _e243 = b[3u];
    metal::float3 _e244 = _e240.xyz * _e243;
    float _e246 = b[3u];
    float _e251 = m;
    c_1 = metal::mix(metal::float4(_e233.x, _e233.y, _e233.z, _e235), metal::float4(_e244.x, _e244.y, _e244.z, _e246), metal::float4(_e251));
    float _e255 = c_1[3u];
    if (_e255 > 0.0) {
        metal::float4 _e257 = c_1;
        float _e260 = c_1[3u];
        metal::float3 _e262 = _e257.xyz / metal::float3(_e260);
        float _e264 = c_1[3u];
        local_3 = metal::float4(_e262.x, _e262.y, _e262.z, _e264);
    } else {
        local_3 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e269 = local_3;
    return _e269;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_11 = {};
    metal::float2 _e29 = _uv_1;
    param_11 = _e29;
    metal::float4 _e30 = transition(param_11, _from, _sampler, _to, uniforms);
    _fragColor = _e30;
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
