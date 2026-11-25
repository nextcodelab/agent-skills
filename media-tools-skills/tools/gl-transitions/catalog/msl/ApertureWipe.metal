// ApertureWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ApertureWipe.glsl
// Author: gre
// License: MIT
// Description: A camera aperture opens its turning blades to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int blades;
    float rotation;
    float shadow;
};

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
    metal::float2 q = {};
    float n = {};
    float sector = {};
    float turn = {};
    float r = {};
    float dist = {};
    float seam = {};
    int i = {};
    float angle = {};
    float d = {};
    float next = {};
    float s = {};
    float rim = {};
    float shade = {};
    metal::float4 from = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e46 = uv_2;
    float _e50 = uniforms.ratio;
    float _e54 = uniforms.ratio;
    q = ((_e46 - metal::float2(0.5)) * metal::float2(_e50, 1.0)) / metal::float2(0.5 * metal::length(metal::float2(_e54, 1.0)));
    int _e61 = uniforms.blades;
    n = metal::clamp(static_cast<float>(_e61), 3.0, 12.0);
    float _e64 = n;
    sector = 6.2831855 / _e64;
    float _e67 = uniforms.rotation;
    float _e70 = uniforms.progress;
    turn = ((_e67) * 0.017453292519943295474) * _e70;
    float _e73 = uniforms.progress;
    r = metal::mix(-0.006, 1.006, _e73);
    dist = -1000.0;
    seam = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e128 = i;
            i = as_type<int>(as_type<uint>(_e128) + as_type<uint>(1));
        }
        loop_init = false;
        int _e75 = i;
        if (_e75 < 12) {
            int _e77 = i;
            float _e79 = n;
            if (static_cast<float>(_e77) < _e79) {
                float _e81 = turn;
                int _e82 = i;
                float _e84 = sector;
                angle = _e81 + (static_cast<float>(_e82) * _e84);
                metal::float2 _e87 = q;
                float _e88 = angle;
                float _e90 = angle;
                float _e94 = r;
                d = metal::dot(_e87, metal::float2(metal::cos(_e88), metal::sin(_e90))) - _e94;
                metal::float2 _e96 = q;
                float _e97 = angle;
                float _e98 = sector;
                float _e101 = angle;
                float _e102 = sector;
                float _e107 = r;
                next = metal::dot(_e96, metal::float2(metal::cos(_e97 + _e98), metal::sin(_e101 + _e102))) - _e107;
                float _e109 = dist;
                float _e110 = d;
                dist = metal::max(_e109, _e110);
                float _e112 = d;
                s = 1.0 - metal::smoothstep(0.0, 0.12, -(_e112));
                float _e116 = seam;
                float _e117 = d;
                float _e120 = s;
                float _e122 = s;
                float _e124 = next;
                seam = metal::max(_e116, (((1.0 - metal::smoothstep(0.0, 0.006, _e117)) * _e120) * _e122) * metal::smoothstep(0.0, 0.006, _e124));
            }
            continue;
        } else {
            break;
        }
    }
    float _e130 = dist;
    rim = 1.0 - metal::smoothstep(0.0, 0.08, _e130);
    float _e134 = uniforms.shadow;
    float _e135 = rim;
    float _e136 = rim;
    float _e138 = seam;
    float _e142 = uniforms.progress;
    shade = (_e134 * metal::max(_e135 * _e136, _e138)) * metal::smoothstep(0.0, 0.1, _e142);
    metal::float2 _e145 = uv_2;
    param = _e145;
    metal::float4 _e146 = getFromColor(param, _from, _sampler);
    from = _e146;
    float _e147 = shade;
    metal::float4 _e149 = from;
    metal::float3 _e151 = _e149.xyz * (1.0 - _e147);
    from[0u] = _e151.x;
    from[1u] = _e151.y;
    from[2u] = _e151.z;
    metal::float4 _e158 = from;
    metal::float2 _e159 = uv_2;
    param_1 = _e159;
    metal::float4 _e160 = getToColor(param_1, _sampler, _to);
    float _e161 = dist;
    return metal::mix(_e158, _e160, metal::float4(1.0 - metal::smoothstep(0.0, 0.006, _e161)));
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
    metal::float2 _e29 = _uv_1;
    param_2 = _e29;
    metal::float4 _e30 = transition(param_2, _from, _sampler, _to, uniforms);
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
