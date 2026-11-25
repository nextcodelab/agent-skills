// EdgeGlow — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/EdgeGlow.glsl
// Author: Woohyun Kim
// License: MIT
// Description: Both images fade through black with their edges glowing
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct type_6 {
    metal::float3 inner[9];
};
struct Uniforms {
    float progress;
    float ratio;
    float edge_thickness;
    float edge_brightness;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e26 = uv[0u];
    float _e28 = uv[1u];
    metal::float4 _e31 = _to.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float3 detectEdgeColor(
    thread type_6& c,
    constant Uniforms& uniforms
) {
    metal::float3 dx = {};
    metal::float3 dy = {};
    float delta = {};
    metal::float3 _e29 = c.inner[7];
    metal::float3 _e31 = c.inner[1];
    metal::float3 _e36 = c.inner[2];
    metal::float3 _e38 = c.inner[6];
    metal::float3 _e43 = c.inner[8];
    metal::float3 _e45 = c.inner[0];
    dx = ((metal::abs(_e29 - _e31) * 2.0) + metal::abs(_e36 - _e38)) + metal::abs(_e43 - _e45);
    metal::float3 _e50 = c.inner[3];
    metal::float3 _e52 = c.inner[5];
    metal::float3 _e57 = c.inner[6];
    metal::float3 _e59 = c.inner[8];
    metal::float3 _e64 = c.inner[0];
    metal::float3 _e66 = c.inner[2];
    dy = ((metal::abs(_e50 - _e52) * 2.0) + metal::abs(_e57 - _e59)) + metal::abs(_e64 - _e66);
    metal::float3 _e70 = dx;
    metal::float3 _e71 = dy;
    delta = metal::length(((_e70 + _e71) * 0.25) * 0.5);
    float _e77 = uniforms.edge_brightness;
    float _e78 = delta;
    metal::float3 _e82 = c.inner[4];
    return _e82 * metal::clamp(_e77 * _e78, 0.0, 1.0);
}

metal::float4 getToEdgeColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float alpha = {};
    int i = {};
    int j = {};
    metal::float4 color = {};
    metal::float2 param = {};
    type_6 c_1 = {};
    type_6 param_1 = {};
    alpha = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e65 = i;
            i = as_type<int>(as_type<uint>(_e65) + as_type<uint>(1));
        }
        loop_init = false;
        int _e32 = i;
        if (_e32 < 3) {
            j = 0;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e63 = j;
                    j = as_type<int>(as_type<uint>(_e63) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e34 = j;
                if (_e34 < 3) {
                    metal::float2 _e36 = uv_1;
                    float _e38 = uniforms.edge_thickness;
                    int _e39 = i;
                    int _e42 = j;
                    param = _e36 + (metal::float2(static_cast<float>(as_type<int>(as_type<uint>(_e39) - as_type<uint>(1))), static_cast<float>(as_type<int>(as_type<uint>(_e42) - as_type<uint>(1)))) * _e38);
                    metal::float4 _e48 = getToColor(param, _sampler, _to);
                    color = _e48;
                    int _e49 = i;
                    int _e51 = j;
                    metal::float4 _e53 = color;
                    c_1.inner[as_type<int>(as_type<uint>(as_type<int>(as_type<uint>(3) * as_type<uint>(_e49))) + as_type<uint>(_e51))] = _e53.xyz;
                    int _e56 = i;
                    int _e58 = j;
                    if ((_e56 == 1) && (_e58 == 1)) {
                        float _e62 = color[3u];
                        alpha = _e62;
                    }
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    type_6 _e67 = c_1;
    param_1 = _e67;
    metal::float3 _e68 = detectEdgeColor(param_1, uniforms);
    float _e69 = alpha;
    return metal::float4(_e68.x, _e68.y, _e68.z, _e69);
}

metal::float4 getFromColor(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e26 = uv_2[0u];
    float _e28 = uv_2[1u];
    metal::float4 _e31 = _from.sample(_sampler, metal::float2(_e26, 1.0 - _e28), metal::level(0.0));
    return _e31;
}

metal::float4 getFromEdgeColor(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    constant Uniforms& uniforms
) {
    float alpha_1 = {};
    int i_1 = {};
    int j_1 = {};
    metal::float4 color_1 = {};
    metal::float2 param_2 = {};
    type_6 c_2 = {};
    type_6 param_3 = {};
    alpha_1 = 0.0;
    i_1 = 0;
    uint2 loop_bound_2 = uint2(4294967295u);
    bool loop_init_2 = true;
    while(true) {
        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
        if (!loop_init_2) {
            int _e65 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e65) + as_type<uint>(1));
        }
        loop_init_2 = false;
        int _e32 = i_1;
        if (_e32 < 3) {
            j_1 = 0;
            uint2 loop_bound_3 = uint2(4294967295u);
            bool loop_init_3 = true;
            while(true) {
                if (metal::all(loop_bound_3 == uint2(0u))) { break; }
                loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
                if (!loop_init_3) {
                    int _e63 = j_1;
                    j_1 = as_type<int>(as_type<uint>(_e63) + as_type<uint>(1));
                }
                loop_init_3 = false;
                int _e34 = j_1;
                if (_e34 < 3) {
                    metal::float2 _e36 = uv_3;
                    float _e38 = uniforms.edge_thickness;
                    int _e39 = i_1;
                    int _e42 = j_1;
                    param_2 = _e36 + (metal::float2(static_cast<float>(as_type<int>(as_type<uint>(_e39) - as_type<uint>(1))), static_cast<float>(as_type<int>(as_type<uint>(_e42) - as_type<uint>(1)))) * _e38);
                    metal::float4 _e48 = getFromColor(param_2, _from, _sampler);
                    color_1 = _e48;
                    int _e49 = i_1;
                    int _e51 = j_1;
                    metal::float4 _e53 = color_1;
                    c_2.inner[as_type<int>(as_type<uint>(as_type<int>(as_type<uint>(3) * as_type<uint>(_e49))) + as_type<uint>(_e51))] = _e53.xyz;
                    int _e56 = i_1;
                    int _e58 = j_1;
                    if ((_e56 == 1) && (_e58 == 1)) {
                        float _e62 = color_1[3u];
                        alpha_1 = _e62;
                    }
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    type_6 _e67 = c_2;
    param_3 = _e67;
    metal::float3 _e68 = detectEdgeColor(param_3, uniforms);
    float _e69 = alpha_1;
    return metal::float4(_e68.x, _e68.y, _e68.z, _e69);
}

metal::float4 transition(
    thread metal::float2& uv_4,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 start = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float4 end = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 _e31 = uv_4;
    param_4 = _e31;
    metal::float4 _e32 = getFromColor(param_4, _from, _sampler);
    metal::float2 _e33 = uv_4;
    param_5 = _e33;
    metal::float4 _e34 = getFromEdgeColor(param_5, _from, _sampler, uniforms);
    float _e36 = uniforms.progress;
    start = metal::mix(_e32, _e34, metal::float4(metal::clamp(2.0 * _e36, 0.0, 1.0)));
    metal::float2 _e41 = uv_4;
    param_6 = _e41;
    metal::float4 _e42 = getToEdgeColor(param_6, _sampler, _to, uniforms);
    metal::float2 _e43 = uv_4;
    param_7 = _e43;
    metal::float4 _e44 = getToColor(param_7, _sampler, _to);
    float _e46 = uniforms.progress;
    end = metal::mix(_e42, _e44, metal::float4(metal::clamp(2.0 * (_e46 - 0.5), 0.0, 1.0)));
    metal::float4 _e52 = start;
    metal::float4 _e53 = end;
    float _e55 = uniforms.progress;
    return metal::mix(_e52, _e53, metal::float4(_e55));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e25 = _uv_1;
    param_8 = _e25;
    metal::float4 _e26 = transition(param_8, _from, _sampler, _to, uniforms);
    _fragColor = _e26;
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
