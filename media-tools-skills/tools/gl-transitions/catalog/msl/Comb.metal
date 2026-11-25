// Comb — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Comb.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into interleaved strips that slide in opposite directions, each pushing the outgoing image out and the incoming one in
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int strips;
    int vertical;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e20 = uv[0u];
    float _e22 = uv[1u];
    metal::float4 _e25 = _to.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e20 = uv_1[0u];
    float _e22 = uv_1[1u];
    metal::float4 _e25 = _from.sample(_sampler, metal::float2(_e20, 1.0 - _e22), metal::level(0.0));
    return _e25;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float a = {};
    float local = {};
    float b = {};
    float local_1 = {};
    float dir = {};
    float t = {};
    float fa = {};
    metal::float2 local_2 = {};
    metal::float2 param = {};
    float ta = {};
    metal::float2 local_3 = {};
    metal::float2 param_1 = {};
    int _e32 = uniforms.vertical;
    if (_e32 != 0) {
        float _e35 = uv_2[1u];
        local = _e35;
    } else {
        float _e37 = uv_2[0u];
        local = _e37;
    }
    float _e38 = local;
    a = _e38;
    int _e40 = uniforms.vertical;
    if (_e40 != 0) {
        float _e43 = uv_2[0u];
        local_1 = _e43;
    } else {
        float _e45 = uv_2[1u];
        local_1 = _e45;
    }
    float _e46 = local_1;
    b = _e46;
    float _e47 = b;
    int _e49 = uniforms.strips;
    float _e52 = metal::floor(_e47 * static_cast<float>(_e49));
    dir = ((_e52 - (metal::floor(_e52 / 2.0) * 2.0)) < 0.5) ? 1.0 : -1.0;
    float _e60 = uniforms.progress;
    float _e62 = uniforms.progress;
    float _e64 = uniforms.progress;
    float _e67 = uniforms.progress;
    t = metal::mix(_e60, (_e62 * _e64) * (3.0 - (2.0 * _e67)), 0.6);
    float _e72 = a;
    float _e73 = dir;
    float _e74 = t;
    fa = _e72 - (_e73 * _e74);
    float _e77 = fa;
    float _e79 = fa;
    if ((_e77 >= 0.0) && (_e79 <= 1.0)) {
        int _e83 = uniforms.vertical;
        if (_e83 != 0) {
            float _e85 = b;
            float _e86 = fa;
            local_2 = metal::float2(_e85, _e86);
        } else {
            float _e88 = fa;
            float _e89 = b;
            local_2 = metal::float2(_e88, _e89);
        }
        metal::float2 _e91 = local_2;
        param = _e91;
        metal::float4 _e92 = getFromColor(param, _from, _sampler);
        return _e92;
    }
    float _e93 = fa;
    float _e94 = dir;
    ta = _e93 + _e94;
    int _e97 = uniforms.vertical;
    if (_e97 != 0) {
        float _e99 = b;
        float _e100 = ta;
        local_3 = metal::float2(_e99, _e100);
    } else {
        float _e102 = ta;
        float _e103 = b;
        local_3 = metal::float2(_e102, _e103);
    }
    metal::float2 _e105 = local_3;
    param_1 = _e105;
    metal::float4 _e106 = getToColor(param_1, _sampler, _to);
    return _e106;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_2 = {};
    metal::float2 _e19 = _uv_1;
    param_2 = _e19;
    metal::float4 _e20 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e20;
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
