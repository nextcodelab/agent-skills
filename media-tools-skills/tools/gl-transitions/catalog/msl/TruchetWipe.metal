// TruchetWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TruchetWipe.glsl
// Author: gre
// License: MIT
// Description: A grid of square tiles, each holding two quarter-circle arcs, links into long winding paths; starting from the middle and spreading outward, the paths are drawn as thin lines of the incoming image, then thicken into bands with a dark outline and a soft shadow until they merge over the whole frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float cells;
    float outline;
    float spread;
};

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e41 = v;
    v3_ = metal::fract(_e41.xyx * 0.1031);
    metal::float3 _e45 = v3_;
    metal::float3 _e46 = v3_;
    metal::float3 _e51 = v3_;
    v3_ = _e51 + metal::float3(metal::dot(_e45, _e46.yzx + metal::float3(33.33)));
    float _e55 = v3_[0u];
    float _e57 = v3_[1u];
    float _e60 = v3_[2u];
    return metal::fract((_e55 + _e57) * _e60);
}

float vnoise(
    thread metal::float2& v_1
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e46 = v_1;
    i = metal::floor(_e46);
    metal::float2 _e48 = v_1;
    f = metal::fract(_e48);
    metal::float2 _e50 = f;
    metal::float2 _e51 = f;
    metal::float2 _e53 = f;
    f = (_e50 * _e51) * (metal::float2(3.0) - (_e53 * 2.0));
    metal::float2 _e58 = i;
    param = _e58;
    float _e59 = hash12(param);
    metal::float2 _e60 = i;
    param_1 = _e60 + metal::float2(1.0, 0.0);
    float _e62 = hash12(param_1);
    float _e64 = f[0u];
    metal::float2 _e66 = i;
    param_2 = _e66 + metal::float2(0.0, 1.0);
    float _e68 = hash12(param_2);
    metal::float2 _e69 = i;
    param_3 = _e69 + metal::float2(1.0, 1.0);
    float _e71 = hash12(param_3);
    float _e73 = f[0u];
    float _e76 = f[1u];
    return metal::mix(metal::mix(_e59, _e62, _e64), metal::mix(_e68, _e71, _e73), _e76);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e41 = uv[0u];
    float _e43 = uv[1u];
    metal::float4 _e46 = _to.sample(_sampler, metal::float2(_e41, 1.0 - _e43), metal::level(0.0));
    return _e46;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e41 = uv_1[0u];
    float _e43 = uv_1[1u];
    metal::float4 _e46 = _from.sample(_sampler, metal::float2(_e41, 1.0 - _e43), metal::level(0.0));
    return _e46;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float n = {};
    metal::float2 p = {};
    metal::float2 g = {};
    metal::float2 cell = {};
    metal::float2 q = {};
    metal::float2 param_6 = {};
    float d = {};
    float T = {};
    metal::float2 param_7 = {};
    float lag = {};
    float s = {};
    float aa = {};
    float k = {};
    float w = {};
    float e = {};
    float band = {};
    float gap = {};
    float fall = {};
    float edge = {};
    float shade = {};
    metal::float4 a = {};
    metal::float2 param_8 = {};
    metal::float4 b = {};
    metal::float2 param_9 = {};
    metal::float4 o = {};
    metal::float4 local = {};
    float _e69 = uniforms.progress;
    if (_e69 <= 0.0) {
        metal::float2 _e71 = uv_2;
        param_4 = _e71;
        metal::float4 _e72 = getFromColor(param_4, _from, _sampler);
        return _e72;
    }
    float _e74 = uniforms.progress;
    if (_e74 >= 1.0) {
        metal::float2 _e76 = uv_2;
        param_5 = _e76;
        metal::float4 _e77 = getToColor(param_5, _sampler, _to);
        return _e77;
    }
    float _e79 = uniforms.cells;
    n = metal::max(metal::floor(_e79 + 0.5), 1.0);
    metal::float2 _e83 = uv_2;
    float _e87 = uniforms.ratio;
    p = (_e83 - metal::float2(0.5)) * metal::float2(_e87, 1.0);
    metal::float2 _e90 = p;
    float _e91 = n;
    g = (_e90 * _e91) + metal::float2(0.5);
    metal::float2 _e95 = g;
    cell = metal::floor(_e95);
    metal::float2 _e97 = g;
    q = metal::fract(_e97);
    metal::float2 _e99 = cell;
    param_6 = _e99 + metal::float2(17.0);
    float _e102 = hash12(param_6);
    if (_e102 > 0.5) {
        float _e105 = q[0u];
        q[0u] = 1.0 - _e105;
    }
    metal::float2 _e108 = q;
    metal::float2 _e112 = q;
    d = metal::min(metal::abs(metal::length(_e108) - 0.5), metal::abs(metal::length(_e112 - metal::float2(1.0)) - 0.5));
    metal::float2 _e119 = p;
    float _e122 = uniforms.ratio;
    metal::float2 _e127 = p;
    param_7 = (_e127 * 3.0) + metal::float2(4.0);
    float _e131 = vnoise(param_7);
    T = metal::clamp((metal::length(_e119) / (0.5 * metal::length(metal::float2(_e122, 1.0)))) + (0.4 * (_e131 - 0.5)), 0.0, 1.0);
    float _e137 = uniforms.spread;
    lag = 0.8 * metal::clamp(_e137, 0.0, 1.0);
    float _e141 = uniforms.progress;
    float _e142 = lag;
    float _e143 = T;
    float _e146 = lag;
    s = metal::clamp((_e141 - (_e142 * _e143)) / (0.95 - _e146), 0.0, 1.0);
    float _e150 = n;
    aa = 0.0012 * _e150;
    float _e152 = s;
    k = metal::clamp((_e152 - 0.25) / 0.75, 0.0, 1.0);
    float _e156 = s;
    float _e159 = n;
    float _e162 = aa;
    float _e166 = k;
    float _e168 = k;
    w = (0.08 * metal::smoothstep(0.0, 0.3, _e156)) + (((((0.5 + (0.003 * _e159)) + (3.0 * _e162)) - 0.08) * _e166) * _e168);
    float _e171 = d;
    float _e172 = w;
    e = _e171 - _e172;
    float _e174 = aa;
    float _e176 = e;
    band = 1.0 - metal::smoothstep(-2.0 * _e174, 0.0, _e176);
    float _e179 = e;
    float _e180 = aa;
    gap = metal::max(_e179 + _e180, 0.0);
    float _e183 = n;
    float _e185 = gap;
    fall = 1.0 - metal::smoothstep(0.0, 0.025 * _e183, _e185);
    float _e188 = n;
    float _e190 = n;
    float _e192 = aa;
    float _e195 = gap;
    float _e199 = fall;
    float _e201 = fall;
    edge = metal::max(0.8 * (1.0 - metal::smoothstep(0.003 * _e188, (0.003 * _e190) + (2.0 * _e192), _e195)), (0.4 * _e199) * _e201);
    float _e205 = uniforms.outline;
    float _e207 = w;
    float _e210 = edge;
    shade = (metal::clamp(_e205, 0.0, 1.0) * metal::smoothstep(0.0, 0.08, _e207)) * _e210;
    metal::float2 _e212 = uv_2;
    param_8 = _e212;
    metal::float4 _e213 = getFromColor(param_8, _from, _sampler);
    a = _e213;
    float _e214 = shade;
    metal::float4 _e216 = a;
    metal::float3 _e218 = _e216.xyz * (1.0 - _e214);
    a[0u] = _e218.x;
    a[1u] = _e218.y;
    a[2u] = _e218.z;
    metal::float2 _e225 = uv_2;
    param_9 = _e225;
    metal::float4 _e226 = getToColor(param_9, _sampler, _to);
    b = _e226;
    metal::float4 _e227 = a;
    float _e230 = a[3u];
    metal::float3 _e231 = _e227.xyz * _e230;
    float _e233 = a[3u];
    metal::float4 _e238 = b;
    float _e241 = b[3u];
    metal::float3 _e242 = _e238.xyz * _e241;
    float _e244 = b[3u];
    float _e249 = band;
    o = metal::mix(metal::float4(_e231.x, _e231.y, _e231.z, _e233), metal::float4(_e242.x, _e242.y, _e242.z, _e244), metal::float4(_e249));
    float _e253 = o[3u];
    if (_e253 > 0.0) {
        metal::float4 _e255 = o;
        float _e258 = o[3u];
        metal::float3 _e260 = _e255.xyz / metal::float3(_e258);
        float _e262 = o[3u];
        local = metal::float4(_e260.x, _e260.y, _e260.z, _e262);
    } else {
        local = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e267 = local;
    return _e267;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_10 = {};
    metal::float2 _e40 = _uv_1;
    param_10 = _e40;
    metal::float4 _e41 = transition(param_10, _from, _sampler, _to, uniforms);
    _fragColor = _e41;
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
