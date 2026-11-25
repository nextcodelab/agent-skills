// Halftone — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Halftone.glsl
// Author: gre
// License: MIT
// Description: The image breaks into printed halftone dots whose size follows its shades, the dots reshape into the incoming image, then merge back into it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float dots;
    float angle;
    metal::float4 paper;
};

float dotRadius(
    thread metal::float4& c
) {
    float shade = {};
    metal::float4 _e35 = c;
    shade = 1.0 - metal::dot(_e35.xyz, metal::float3(0.299, 0.587, 0.114));
    float _e39 = shade;
    float _e44 = c[3u];
    return metal::mix(0.1, 0.74, metal::sqrt(metal::clamp(_e39, 0.0, 1.0))) * _e44;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float h = {};
    float t = {};
    float a = {};
    metal::float2x2 rot = {};
    metal::float2 scale = {};
    metal::float2 g = {};
    metal::float2 base = {};
    metal::float4 pixel = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float best = {};
    metal::float4 ink = {};
    int i = {};
    metal::float2 center = {};
    metal::float2 cuv = {};
    metal::float4 cf = {};
    metal::float2 param_2 = {};
    metal::float4 ct = {};
    metal::float2 param_3 = {};
    float m = {};
    float r = {};
    metal::float4 param_4 = {};
    metal::float4 param_5 = {};
    float sd = {};
    float _e60 = uniforms.progress;
    float _e63 = uniforms.progress;
    h = metal::smoothstep(0.0, 0.3, _e60) * (1.0 - metal::smoothstep(0.7, 1.0, _e63));
    float _e68 = uniforms.progress;
    t = (_e68 - 0.3) / 0.4;
    float _e72 = uniforms.angle;
    a = ((_e72) * 0.017453292519943295474);
    float _e74 = a;
    float _e76 = a;
    float _e78 = a;
    float _e81 = a;
    rot = metal::float2x2(metal::float2(metal::cos(_e74), metal::sin(_e76)), metal::float2(-(metal::sin(_e78)), metal::cos(_e81)));
    float _e87 = uniforms.ratio;
    float _e90 = uniforms.dots;
    float _e93 = uniforms.ratio;
    scale = (metal::float2(_e87, 1.0) * _e90) / metal::float2(metal::min(_e93, 1.0));
    metal::float2x2 _e97 = rot;
    metal::float2 _e98 = uv_2;
    metal::float2 _e101 = scale;
    g = _e97 * ((_e98 - metal::float2(0.5)) * _e101);
    metal::float2 _e104 = g;
    base = metal::floor(_e104 - metal::float2(0.5)) + metal::float2(0.5);
    float _e111 = uniforms.progress;
    if (_e111 < 0.5) {
        metal::float2 _e113 = uv_2;
        param = _e113;
        metal::float4 _e114 = getFromColor(param, _from, _sampler);
        local = _e114;
    } else {
        metal::float2 _e115 = uv_2;
        param_1 = _e115;
        metal::float4 _e116 = getToColor(param_1, _sampler, _to);
        local = _e116;
    }
    metal::float4 _e117 = local;
    pixel = _e117;
    best = 1000.0;
    metal::float4 _e118 = pixel;
    ink = _e118;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e180 = i;
            i = as_type<int>(as_type<uint>(_e180) + as_type<uint>(1));
        }
        loop_init = false;
        int _e119 = i;
        if (_e119 < 4) {
            metal::float2 _e121 = base;
            int _e122 = i;
            float _e123 = static_cast<float>(_e122);
            int _e128 = i;
            center = _e121 + metal::float2(_e123 - (metal::floor(_e123 / 2.0) * 2.0), metal::floor(static_cast<float>(_e128) / 2.0));
            metal::float2 _e134 = center;
            metal::float2x2 _e135 = rot;
            metal::float2 _e137 = scale;
            cuv = ((_e134 * _e135) / _e137) + metal::float2(0.5);
            metal::float2 _e141 = cuv;
            param_2 = _e141;
            metal::float4 _e142 = getFromColor(param_2, _from, _sampler);
            cf = _e142;
            metal::float2 _e143 = cuv;
            param_3 = _e143;
            metal::float4 _e144 = getToColor(param_3, _sampler, _to);
            ct = _e144;
            float _e145 = t;
            float _e148 = cuv[0u];
            m = metal::smoothstep(0.0, 1.0, metal::clamp((2.5 * _e145) - (1.5 * _e148), 0.0, 1.0));
            metal::float4 _e153 = cf;
            param_4 = _e153;
            float _e154 = dotRadius(param_4);
            metal::float4 _e155 = ct;
            param_5 = _e155;
            float _e156 = dotRadius(param_5);
            float _e157 = m;
            float _e159 = h;
            r = metal::mix(0.78, metal::mix(_e154, _e156, _e157), _e159);
            metal::float2 _e161 = g;
            metal::float2 _e162 = center;
            float _e165 = r;
            sd = metal::length(_e161 - _e162) - _e165;
            float _e167 = sd;
            float _e168 = best;
            if (_e167 < _e168) {
                float _e170 = sd;
                best = _e170;
                metal::float4 _e171 = pixel;
                metal::float4 _e172 = cf;
                metal::float4 _e173 = ct;
                float _e174 = m;
                float _e177 = h;
                ink = metal::mix(_e171, metal::mix(_e172, _e173, metal::float4(_e174)), metal::float4(_e177));
            }
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e183 = uniforms.paper;
    metal::float4 _e184 = ink;
    float _e185 = best;
    return metal::mix(_e183, _e184, metal::float4(1.0 - metal::smoothstep(-0.06, 0.06, _e185)));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_6 = {};
    metal::float2 _e34 = _uv_1;
    param_6 = _e34;
    metal::float4 _e35 = transition(param_6, _from, _sampler, _to, uniforms);
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
