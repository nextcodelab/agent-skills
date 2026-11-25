// WhipPan — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WhipPan.glsl
// Author: gre
// License: MIT
// Description: A fast camera pan that streaks both images with motion blur, the incoming one arriving from the opposite side
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float blur;
    char _pad4[4];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e31 = uv[0u];
    float _e33 = uv[1u];
    metal::float4 _e36 = _to.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e31 = uv_1[0u];
    float _e33 = uv_1[1u];
    metal::float4 _e36 = _from.sample(_sampler, metal::float2(_e31, 1.0 - _e33), metal::level(0.0));
    return _e36;
}

metal::float4 strip(
    thread metal::float2& q,
    thread metal::float2& d,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 qt = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e34 = q;
    metal::float2 _e35 = d;
    qt = _e34 + _e35;
    metal::float2 _e37 = q;
    metal::float2 _e40 = d;
    metal::float2 _e43 = d;
    metal::float2 _e44 = d;
    if (metal::dot(_e37 - metal::float2(0.5), -(_e40)) < (0.5 * metal::dot(_e43, _e44))) {
        metal::float2 _e48 = q;
        param = metal::clamp(_e48, metal::float2(0.0), metal::float2(1.0));
        metal::float4 _e52 = getFromColor(param, _from, _sampler);
        return _e52;
    }
    metal::float2 _e53 = qt;
    param_1 = metal::clamp(_e53, metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e57 = getToColor(param_1, _sampler, _to);
    return _e57;
}

float rand(
    thread metal::float2& co
) {
    metal::float2 _e30 = co;
    return metal::fract(metal::sin(metal::dot(_e30, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 d_1 = {};
    float p = {};
    float h = {};
    float e = {};
    float pos = {};
    float local = {};
    float len = {};
    metal::float2 q_1 = {};
    float jitter = {};
    metal::float2 param_2 = {};
    metal::float3 color = {};
    float alpha = {};
    int i = {};
    float t = {};
    metal::float4 c = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 _e48 = uniforms.direction;
    d_1 = metal::sign(_e48);
    float _e51 = uniforms.progress;
    p = _e51;
    float _e52 = p;
    h = 1.0 - metal::abs((2.0 * _e52) - 1.0);
    float _e57 = h;
    float _e59 = h;
    float _e61 = h;
    e = (0.5 * _e57) * (0.1 + ((0.9 * _e59) * _e61));
    float _e65 = p;
    if (_e65 < 0.5) {
        float _e67 = e;
        local = _e67;
    } else {
        float _e68 = e;
        local = 1.0 - _e68;
    }
    float _e70 = local;
    pos = _e70;
    float _e72 = uniforms.blur;
    float _e73 = h;
    float _e75 = h;
    float _e77 = h;
    len = ((_e72 * _e73) * (0.1 + ((2.7 * _e75) * _e77))) / 2.8;
    metal::float2 _e82 = uv_2;
    metal::float2 _e83 = d_1;
    float _e84 = pos;
    q_1 = _e82 - (_e83 * _e84);
    metal::float2 _e87 = uv_2;
    param_2 = _e87;
    float _e88 = rand(param_2);
    jitter = _e88;
    color = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e117 = i;
            i = as_type<int>(as_type<uint>(_e117) + as_type<uint>(1));
        }
        loop_init = false;
        int _e89 = i;
        if (_e89 < 24) {
            int _e91 = i;
            float _e93 = jitter;
            t = ((static_cast<float>(_e91) + _e93) / 24.0) - 0.5;
            metal::float2 _e97 = q_1;
            metal::float2 _e98 = d_1;
            float _e99 = t;
            float _e101 = len;
            param_3 = _e97 + ((_e98 * _e99) * _e101);
            metal::float2 _e104 = d_1;
            param_4 = _e104;
            metal::float4 _e105 = strip(param_3, param_4, _from, _sampler, _to);
            c = _e105;
            metal::float4 _e106 = c;
            float _e109 = c[3u];
            metal::float3 _e111 = color;
            color = _e111 + (_e106.xyz * _e109);
            float _e114 = c[3u];
            float _e115 = alpha;
            alpha = _e115 + _e114;
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e119 = color;
    float _e120 = alpha;
    metal::float3 _e123 = _e119 / metal::float3(metal::max(_e120, 0.00001));
    float _e124 = alpha;
    return metal::float4(_e123.x, _e123.y, _e123.z, _e124 / 24.0);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_5 = {};
    metal::float2 _e30 = _uv_1;
    param_5 = _e30;
    metal::float4 _e31 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e31;
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
