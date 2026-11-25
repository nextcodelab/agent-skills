// LightWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightWipe.glsl
// Author: gre
// License: MIT
// Description: A band of intense light sweeps across the frame like a glint on glass, blooming the highlights of both images, and leaves the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float width;
    float intensity;
    char _pad5[8];
    metal::float3 color;
};

metal::float3 highlight(
    thread metal::float4& c
) {
    float lum = {};
    metal::float4 _e44 = c;
    lum = metal::dot(_e44.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    metal::float4 _e47 = c;
    float _e50 = c[3u];
    float _e52 = lum;
    return (_e47.xyz * _e50) * metal::smoothstep(0.45, 1.0, _e52);
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e43 = v;
    metal::float2 _e44 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e43 - (metal::floor(_e43 / _e44) * _e44)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e44 = uv[0u];
    float _e46 = uv[1u];
    metal::float4 _e49 = _to.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e44 = uv_1[0u];
    float _e46 = uv_1[1u];
    metal::float4 _e49 = _from.sample(_sampler, metal::float2(_e44, 1.0 - _e46), metal::level(0.0));
    return _e49;
}

metal::float4 frame(
    thread metal::float2& st,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 _e46 = st;
    param = _e46;
    metal::float4 _e47 = getFromColor(param, _from, _sampler);
    metal::float2 _e48 = st;
    param_1 = _e48;
    metal::float4 _e49 = getToColor(param_1, _sampler, _to);
    float _e50 = m;
    return metal::mix(_e47, _e49, metal::float4(_e50));
}

float ease(
    thread float& t
) {
    float _e43 = t;
    float _e44 = t;
    float _e45 = t;
    float _e47 = t;
    return 0.5 * (_e43 + ((_e44 * _e45) * (3.0 - (2.0 * _e47))));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 p = {};
    float e = {};
    float w = {};
    float s = {};
    float margin = {};
    float pos = {};
    float param_2 = {};
    float d = {};
    float m_1 = {};
    float env = {};
    float core = {};
    float g = {};
    float glint = {};
    float halo = {};
    float band = {};
    float glow = {};
    metal::float4 c_1 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    metal::float3 bloom = {};
    float spread = {};
    int i = {};
    float t_1 = {};
    metal::float2 st_1 = {};
    metal::float2 param_5 = {};
    float dq = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    metal::float4 param_8 = {};
    metal::float3 hue = {};
    float lum_1 = {};
    metal::float3 light = {};
    metal::float3 rgb = {};
    metal::float2 _e79 = uniforms.direction;
    if (metal::length(_e79) > 0.0) {
        metal::float2 _e83 = uniforms.direction;
        local = metal::normalize(_e83);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e85 = local;
    dir = _e85;
    metal::float2 _e86 = uv_2;
    float _e90 = uniforms.ratio;
    p = (_e86 - metal::float2(0.5)) * metal::float2(_e90, 1.0);
    float _e94 = dir[0u];
    float _e97 = uniforms.ratio;
    float _e100 = dir[1u];
    e = 0.5 * ((metal::abs(_e94) * _e97) + metal::abs(_e100));
    float _e105 = uniforms.width;
    w = metal::max(_e105, 0.001);
    float _e107 = w;
    s = 0.35 * _e107;
    float _e109 = s;
    float _e110 = w;
    margin = _e109 + (2.0 * _e110);
    float _e113 = e;
    float _e115 = margin;
    float _e117 = e;
    float _e118 = margin;
    float _e122 = uniforms.progress;
    param_2 = _e122;
    float _e123 = ease(param_2);
    pos = (-(_e113) - _e115) + ((2.0 * (_e117 + _e118)) * _e123);
    metal::float2 _e126 = p;
    metal::float2 _e127 = dir;
    float _e129 = pos;
    d = metal::dot(_e126, _e127) - _e129;
    float _e131 = s;
    float _e133 = s;
    float _e134 = d;
    m_1 = 1.0 - metal::smoothstep(-(_e131), _e133, _e134);
    float _e138 = uniforms.progress;
    float _e141 = uniforms.progress;
    env = metal::smoothstep(0.0, 0.2, _e138) * (1.0 - metal::smoothstep(0.8, 1.0, _e141));
    float _e145 = d;
    float _e147 = d;
    float _e149 = w;
    float _e150 = w;
    core = metal::exp((-(_e145) * _e147) / (_e149 * _e150));
    float _e154 = d;
    float _e155 = w;
    float _e158 = w;
    g = (_e154 + (2.2 * _e155)) / (0.3 * _e158);
    float _e161 = g;
    float _e163 = g;
    glint = 0.45 * metal::exp(-(_e161) * _e163);
    float _e167 = d;
    float _e170 = w;
    halo = 0.35 * metal::exp(-(metal::abs(_e167)) / (5.0 * _e170));
    float _e175 = core;
    float _e176 = glint;
    float _e178 = halo;
    float _e180 = env;
    float _e183 = uniforms.intensity;
    band = (((_e175 + _e176) + _e178) * _e180) * _e183;
    float _e185 = core;
    float _e186 = glint;
    float _e188 = env;
    float _e191 = uniforms.intensity;
    glow = ((_e185 + _e186) * _e188) * _e191;
    metal::float2 _e193 = uv_2;
    param_3 = _e193;
    float _e194 = m_1;
    param_4 = _e194;
    metal::float4 _e195 = frame(param_3, param_4, _from, _sampler, _to);
    c_1 = _e195;
    bloom = metal::float3(0.0, 0.0, 0.0);
    float _e196 = w;
    spread = metal::min(3.0 * _e196, 0.12);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e247 = i;
            i = as_type<int>(as_type<uint>(_e247) + as_type<uint>(1));
        }
        loop_init = false;
        int _e199 = i;
        if (_e199 < 12) {
            int _e201 = i;
            t_1 = (((static_cast<float>(_e201) + 0.5) / 12.0) * 2.0) - 1.0;
            metal::float2 _e207 = p;
            metal::float2 _e208 = dir;
            float _e209 = t_1;
            float _e210 = spread;
            float _e215 = uniforms.ratio;
            param_5 = ((_e207 + (_e208 * (_e209 * _e210))) / metal::float2(_e215, 1.0)) + metal::float2(0.5);
            metal::float2 _e220 = mirror(param_5);
            st_1 = _e220;
            metal::float2 _e221 = st_1;
            float _e225 = uniforms.ratio;
            metal::float2 _e228 = dir;
            float _e230 = pos;
            dq = metal::dot((_e221 - metal::float2(0.5)) * metal::float2(_e225, 1.0), _e228) - _e230;
            float _e232 = t_1;
            float _e235 = s;
            float _e237 = s;
            float _e238 = dq;
            metal::float2 _e241 = st_1;
            param_6 = _e241;
            param_7 = 1.0 - metal::smoothstep(-(_e235), _e237, _e238);
            metal::float4 _e242 = frame(param_6, param_7, _from, _sampler, _to);
            param_8 = _e242;
            metal::float3 _e243 = highlight(param_8);
            metal::float3 _e245 = bloom;
            bloom = _e245 + (_e243 * (1.0 - metal::abs(_e232)));
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e249 = bloom;
    bloom = _e249 / metal::float3(6.0);
    metal::float3 _e253 = uniforms.color;
    float _e254 = core;
    float _e255 = core;
    hue = metal::mix(_e253, metal::float3(1.0, 1.0, 1.0), metal::float3(_e254 * _e255));
    metal::float4 _e259 = c_1;
    lum_1 = metal::dot(_e259.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    metal::float3 _e262 = hue;
    float _e263 = band;
    float _e265 = lum_1;
    metal::float3 _e269 = hue;
    metal::float3 _e270 = bloom;
    float _e272 = glow;
    metal::float3 _e276 = hue;
    float _e277 = core;
    float _e279 = env;
    float _e282 = uniforms.intensity;
    light = (((_e262 * _e263) * (0.3 + (0.9 * _e265))) + (((_e269 * _e270) * _e272) * 4.0)) + ((((_e276 * _e277) * _e279) * _e282) * 1.6);
    metal::float4 _e286 = c_1;
    metal::float3 _e290 = light;
    rgb = metal::float3(1.0) - ((metal::float3(1.0) - _e286.xyz) * metal::exp(-(_e290)));
    metal::float3 _e296 = rgb;
    float _e298 = c_1[3u];
    return metal::float4(_e296.x, _e296.y, _e296.z, _e298);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_9 = {};
    metal::float2 _e43 = _uv_1;
    param_9 = _e43;
    metal::float4 _e44 = transition(param_9, _from, _sampler, _to, uniforms);
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
