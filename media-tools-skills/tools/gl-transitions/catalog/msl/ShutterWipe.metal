// ShutterWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ShutterWipe.glsl
// Author: gre
// License: MIT
// Description: A camera's focal-plane shutter fires across the frame, seen through the camera's gate: thin metal blades fan down from a tight stack above it until they overlap over the whole frame, then keep running down and stack below it, uncovering the incoming image from the top
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int blades;
    float tilt;
    float gate;
    char _pad5[12];
    metal::float4 color;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e61 = uv[0u];
    float _e63 = uv[1u];
    metal::float4 _e66 = _to.sample(_sampler, metal::float2(_e61, 1.0 - _e63), metal::level(0.0));
    return _e66;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e61 = uv_1[0u];
    float _e63 = uv_1[1u];
    metal::float4 _e66 = _from.sample(_sampler, metal::float2(_e61, 1.0 - _e63), metal::level(0.0));
    return _e66;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n = {};
    float h = {};
    float pile = {};
    float travel = {};
    metal::float2 t = {};
    metal::float2 pos = {};
    metal::float2 vel = {};
    float x = {};
    metal::float4 col = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    int i = {};
    float k = {};
    float v = {};
    float d = {};
    float aa = {};
    float sh = {};
    float l = {};
    float lip = {};
    float s = {};
    float sheen = {};
    metal::float3 metal_ = {};
    float cover = {};
    float g = {};
    metal::float2 c = {};
    float e = {};
    float on = {};
    metal::float3 housing = {};
    int _e90 = uniforms.blades;
    n = metal::clamp(static_cast<float>(_e90), 3.0, 10.0);
    float _e93 = n;
    h = (1.7 / _e93) + 0.02;
    float _e96 = n;
    pile = (_e96 - 1.0) * 0.016;
    float _e99 = h;
    float _e101 = pile;
    travel = (1.1 + _e99) + _e101;
    float _e104 = uniforms.progress;
    t = metal::clamp((metal::float2(_e104) - metal::float2(0.0, 0.3)) / metal::float2(0.7), metal::float2(0.0), metal::float2(1.0));
    float _e112 = pile;
    float _e116 = travel;
    metal::float2 _e117 = t;
    metal::float2 _e119 = t;
    metal::float2 _e121 = t;
    pos = (metal::float2(1.05) + metal::float2(0.0, _e112)) - (((_e117 * _e116) * _e119) * (metal::float2(3.0) - (_e121 * 2.0)));
    float _e127 = travel;
    metal::float2 _e129 = t;
    metal::float2 _e131 = t;
    vel = ((_e129 * (_e127 * 6.0)) * (metal::float2(1.0) - _e131)) / metal::float2(0.7);
    float _e138 = uv_2[0u];
    float _e141 = uniforms.ratio;
    x = (_e138 - 0.5) * _e141;
    float _e144 = uniforms.progress;
    if (_e144 < 0.5) {
        metal::float2 _e146 = uv_2;
        param = _e146;
        metal::float4 _e147 = getFromColor(param, _from, _sampler);
        local = _e147;
    } else {
        metal::float2 _e148 = uv_2;
        param_1 = _e148;
        metal::float4 _e149 = getToColor(param_1, _sampler, _to);
        local = _e149;
    }
    metal::float4 _e150 = local;
    col = _e150;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e308 = i;
            i = as_type<int>(as_type<uint>(_e308) + as_type<uint>(1));
        }
        loop_init = false;
        int _e151 = i;
        if (_e151 < 10) {
            int _e153 = i;
            float _e155 = n;
            k = static_cast<float>(_e153) / (_e155 - 1.0);
            float _e158 = k;
            if (_e158 < 1.0001) {
                float _e161 = vel[0u];
                float _e163 = vel[1u];
                float _e164 = k;
                v = metal::mix(_e161, _e163, _e164);
                float _e167 = uv_2[1u];
                float _e169 = pos[0u];
                float _e171 = pos[1u];
                float _e172 = k;
                float _e176 = uniforms.tilt;
                float _e178 = v;
                float _e180 = x;
                d = (_e167 - metal::mix(_e169, _e171, _e172)) + (((_e176 * 0.1) * _e178) * _e180);
                float _e183 = v;
                aa = 0.002 + (0.005 * _e183);
                float _e186 = v;
                float _e189 = d;
                float _e193 = aa;
                float _e195 = aa;
                float _e196 = d;
                sh = (1.0 - metal::smoothstep(0.0, 0.03 + (0.012 * _e186), -(_e189))) * (1.0 - metal::smoothstep(-(_e193), _e195, _e196));
                float _e202 = uniforms.color[3u];
                float _e204 = sh;
                float _e206 = sh;
                metal::float4 _e209 = col;
                metal::float3 _e211 = _e209.xyz * (1.0 - (((0.65 * _e202) * _e204) * _e206));
                col[0u] = _e211.x;
                col[1u] = _e211.y;
                col[2u] = _e211.z;
                float _e218 = d;
                float _e219 = h;
                l = metal::clamp(_e218 / _e219, 0.0, 1.0);
                float _e222 = d;
                float _e224 = d;
                lip = metal::smoothstep(0.003, 0.007, _e222) * (1.0 - metal::smoothstep(0.007, 0.014, _e224));
                float _e229 = uv_2[1u];
                float _e230 = d;
                float _e233 = x;
                s = (((_e229 - _e230) - 0.55) + (0.3 * _e233)) * 2.5;
                float _e237 = s;
                float _e239 = s;
                float _e243 = l;
                float _e246 = l;
                sheen = ((0.3 * metal::exp(-(_e237) * _e239)) * (1.0 - _e243)) * (1.0 - _e246);
                metal::float4 _e250 = uniforms.color;
                float _e252 = l;
                float _e256 = lip;
                float _e258 = sheen;
                metal::float4 _e261 = uniforms.color;
                float _e269 = uniforms.color[3u];
                metal_ = (_e250.xyz * (1.3 - (0.75 * _e252))) + (((metal::float3(0.6) + (_e261.xyz * 0.4)) * ((0.25 * _e256) + _e258)) * _e269);
                float _e272 = d;
                metal::float3 _e276 = metal_;
                metal_ = _e276 * (0.4 + (0.6 * metal::smoothstep(0.0, 0.005, _e272)));
                float _e278 = aa;
                float _e280 = aa;
                float _e281 = d;
                float _e283 = h;
                float _e284 = aa;
                float _e286 = h;
                float _e287 = aa;
                float _e289 = d;
                cover = metal::smoothstep(-(_e278), _e280, _e281) * (1.0 - metal::smoothstep(_e283 - _e284, _e286 + _e287, _e289));
                metal::float4 _e293 = col;
                metal::float3 _e294 = metal_;
                metal::float3 _e297 = metal::clamp(_e294, metal::float3(0.0), metal::float3(1.0));
                float _e300 = uniforms.color[3u];
                float _e305 = cover;
                col = metal::mix(_e293, metal::float4(_e297.x, _e297.y, _e297.z, _e300), metal::float4(_e305));
            }
            continue;
        } else {
            break;
        }
    }
    float _e311 = uniforms.gate;
    float _e313 = uniforms.progress;
    float _e317 = uniforms.progress;
    g = (_e311 * metal::smoothstep(0.0, 0.12, _e313)) * (1.0 - metal::smoothstep(0.88, 1.0, _e317));
    metal::float2 _e321 = uv_2;
    float _e326 = uniforms.ratio;
    float _e330 = uniforms.ratio;
    float _e334 = g;
    c = ((metal::abs(_e321 - metal::float2(0.5)) * metal::float2(_e326, 1.0)) - metal::float2(0.5 * _e330, 0.5)) + metal::float2(1.5 * _e334);
    metal::float2 _e338 = c;
    float _e343 = c[0u];
    float _e345 = c[1u];
    float _e349 = g;
    e = (metal::length(metal::max(_e338, metal::float2(0.0))) + metal::min(metal::max(_e343, _e345), 0.0)) - (0.5 * _e349);
    float _e353 = uniforms.gate;
    float _e356 = uniforms.progress;
    float _e360 = uniforms.progress;
    on = (metal::smoothstep(0.0, 0.002, _e353) * metal::smoothstep(0.0, 0.04, _e356)) * (1.0 - metal::smoothstep(0.96, 1.0, _e360));
    float _e366 = uniforms.color[3u];
    float _e368 = on;
    float _e370 = g;
    float _e373 = e;
    metal::float4 _e377 = col;
    metal::float3 _e379 = _e377.xyz * (1.0 - (((0.5 * _e366) * _e368) * metal::smoothstep((-0.4 * _e370) - 0.001, 0.0, _e373)));
    col[0u] = _e379.x;
    col[1u] = _e379.y;
    col[2u] = _e379.z;
    metal::float4 _e387 = uniforms.color;
    float _e389 = g;
    float _e392 = e;
    housing = metal::min(_e387.xyz * (1.5 - metal::smoothstep(0.0, (0.2 * _e389) + 0.001, _e392)), metal::float3(1.0));
    metal::float4 _e398 = col;
    metal::float3 _e399 = housing;
    float _e402 = uniforms.color[3u];
    float _e407 = on;
    float _e408 = e;
    return metal::mix(_e398, metal::float4(_e399.x, _e399.y, _e399.z, _e402), metal::float4(_e407 * metal::smoothstep(-0.002, 0.002, _e408)));
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
    metal::float2 _e60 = _uv_1;
    param_2 = _e60;
    metal::float4 _e61 = transition(param_2, _from, _sampler, _to, uniforms);
    _fragColor = _e61;
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
