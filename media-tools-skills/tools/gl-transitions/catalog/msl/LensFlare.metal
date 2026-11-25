// LensFlare — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LensFlare.glsl
// Author: gre
// License: MIT
// Description: A bright light sweeps across the frame and flares the lens: a long thin horizontal streak, a glowing core and a trail of colored ghost reflections; at its peak the incoming image spreads out from the light under its glare
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float angle;
    float height;
    float intensity;
    char _pad5[12];
    metal::float3 color;
};

metal::float3 highlight(
    thread metal::float4& c
) {
    float lum = {};
    metal::float4 _e69 = c;
    lum = metal::dot(_e69.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    metal::float4 _e72 = c;
    float _e74 = lum;
    return _e72.xyz * metal::smoothstep(0.55, 0.95, _e74);
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e68 = v;
    metal::float2 _e69 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e68 - (metal::floor(_e68 / _e69) * _e69)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e69 = uv[0u];
    float _e71 = uv[1u];
    metal::float4 _e74 = _to.sample(_sampler, metal::float2(_e69, 1.0 - _e71), metal::level(0.0));
    return _e74;
}

metal::float4 premultiplied(
    thread metal::float4& c_1
) {
    metal::float4 _e68 = c_1;
    float _e71 = c_1[3u];
    metal::float3 _e72 = _e68.xyz * _e71;
    float _e74 = c_1[3u];
    return metal::float4(_e72.x, _e72.y, _e72.z, _e74);
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e69 = uv_1[0u];
    float _e71 = uv_1[1u];
    metal::float4 _e74 = _from.sample(_sampler, metal::float2(_e69, 1.0 - _e71), metal::level(0.0));
    return _e74;
}

metal::float4 frame(
    thread metal::float2& st,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param = {};
    metal::float4 param_1 = {};
    metal::float2 param_2 = {};
    metal::float4 param_3 = {};
    metal::float2 param_4 = {};
    metal::float4 param_5 = {};
    metal::float2 param_6 = {};
    metal::float4 param_7 = {};
    float _e77 = m;
    if (_e77 <= 0.0) {
        metal::float2 _e79 = st;
        param = _e79;
        metal::float4 _e80 = getFromColor(param, _from, _sampler);
        param_1 = _e80;
        metal::float4 _e81 = premultiplied(param_1);
        return _e81;
    }
    float _e82 = m;
    if (_e82 >= 1.0) {
        metal::float2 _e84 = st;
        param_2 = _e84;
        metal::float4 _e85 = getToColor(param_2, _sampler, _to);
        param_3 = _e85;
        metal::float4 _e86 = premultiplied(param_3);
        return _e86;
    }
    metal::float2 _e87 = st;
    param_4 = _e87;
    metal::float4 _e88 = getFromColor(param_4, _from, _sampler);
    param_5 = _e88;
    metal::float4 _e89 = premultiplied(param_5);
    metal::float2 _e90 = st;
    param_6 = _e90;
    metal::float4 _e91 = getToColor(param_6, _sampler, _to);
    param_7 = _e91;
    metal::float4 _e92 = premultiplied(param_7);
    float _e93 = m;
    return metal::mix(_e89, _e92, metal::float4(_e93));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float env = {};
    float peak = {};
    metal::float2 aspect = {};
    metal::float2 q = {};
    float r = {};
    metal::float2 dir = {};
    metal::float2 normal = {};
    float t = {};
    float travel = {};
    float along = {};
    metal::float2 src = {};
    metal::float2 d = {};
    float dist = {};
    float k = {};
    float cut = {};
    float s = {};
    float soft = {};
    float reach = {};
    float front = {};
    float m_1 = {};
    metal::float4 base = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    float ax = {};
    float ay = {};
    float thin = {};
    float wide = {};
    metal::float3 tint = {};
    metal::float3 streak = {};
    metal::float3 core = {};
    metal::float3 ghosts = {};
    int i = {};
    float fi = {};
    float f = {};
    metal::float2 g = {};
    float size = {};
    float gd = {};
    float disc = {};
    metal::float3 hue = {};
    metal::float3 bloom = {};
    float radius = {};
    int i_1 = {};
    float fi_1 = {};
    float a = {};
    float rr = {};
    metal::float2 o = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    metal::float4 param_15 = {};
    metal::float3 glare = {};
    metal::float3 light = {};
    metal::float3 c_2 = {};
    float _e125 = uniforms.progress;
    p = _e125;
    float _e126 = p;
    if (_e126 <= 0.0) {
        metal::float2 _e128 = uv_2;
        param_8 = _e128;
        metal::float4 _e129 = getFromColor(param_8, _from, _sampler);
        return _e129;
    }
    float _e130 = p;
    if (_e130 >= 1.0) {
        metal::float2 _e132 = uv_2;
        param_9 = _e132;
        metal::float4 _e133 = getToColor(param_9, _sampler, _to);
        return _e133;
    }
    float _e134 = p;
    float _e136 = p;
    env = (4.0 * _e134) * (1.0 - _e136);
    float _e139 = env;
    peak = metal::pow(_e139, 24.0);
    float _e142 = uniforms.ratio;
    aspect = metal::float2(_e142, 1.0);
    metal::float2 _e144 = uv_2;
    metal::float2 _e147 = aspect;
    q = (_e144 - metal::float2(0.5)) * _e147;
    float _e150 = uniforms.angle;
    r = ((_e150) * 0.017453292519943295474);
    float _e152 = r;
    float _e154 = r;
    dir = metal::float2(metal::cos(_e152), -(metal::sin(_e154)));
    float _e159 = dir[1u];
    float _e162 = dir[0u];
    normal = metal::float2(-(_e159), _e162);
    float _e164 = p;
    t = _e164 - 0.5;
    float _e167 = dir[0u];
    float _e170 = uniforms.ratio;
    float _e173 = dir[1u];
    travel = (0.5 * ((metal::abs(_e167) * _e170) + metal::abs(_e173))) + 0.3;
    float _e178 = travel;
    float _e179 = t;
    float _e182 = t;
    float _e184 = t;
    along = (_e178 * (2.0 * _e179)) * (0.55 + ((1.8 * _e182) * _e184));
    metal::float2 _e188 = dir;
    float _e189 = along;
    metal::float2 _e191 = normal;
    float _e193 = uniforms.height;
    src = (_e188 * _e189) + (_e191 * _e193);
    metal::float2 _e196 = q;
    metal::float2 _e197 = src;
    d = _e196 - _e197;
    metal::float2 _e199 = d;
    dist = metal::length(_e199);
    float _e202 = uniforms.intensity;
    float _e203 = env;
    k = _e202 * _e203;
    float _e206 = uniforms.intensity;
    cut = metal::mix(0.2, 0.06, metal::clamp(_e206, 0.0, 1.0));
    float _e209 = p;
    float _e211 = cut;
    float _e213 = cut;
    s = metal::clamp(((_e209 - 0.5) + _e211) / (2.0 * _e213), 0.0, 1.0);
    soft = 0.3;
    metal::float2 _e217 = aspect;
    metal::float2 _e220 = src;
    float _e223 = soft;
    reach = ((0.5 * metal::length(_e217)) + metal::length(_e220)) + _e223;
    float _e225 = s;
    float _e226 = reach;
    float _e227 = soft;
    front = _e225 * (_e226 + _e227);
    float _e230 = front;
    float _e231 = front;
    float _e232 = soft;
    float _e234 = dist;
    m_1 = metal::smoothstep(_e230, _e231 - _e232, _e234);
    metal::float2 _e236 = uv_2;
    param_10 = _e236;
    float _e237 = m_1;
    param_11 = _e237;
    metal::float4 _e238 = frame(param_10, param_11, _from, _sampler, _to);
    base = _e238;
    float _e240 = d[0u];
    ax = metal::abs(_e240);
    float _e243 = d[1u];
    ay = metal::abs(_e243);
    float _e245 = ay;
    float _e249 = ax;
    thin = metal::exp(-(_e245) * 140.0) * metal::exp(-(_e249) * 0.7);
    float _e254 = ay;
    float _e258 = ax;
    wide = metal::exp(-(_e254) * 30.0) * metal::exp(-(_e258) * 1.6);
    metal::float3 _e264 = uniforms.color;
    tint = _e264;
    float _e265 = thin;
    metal::float3 _e266 = tint;
    float _e267 = ax;
    float _e272 = wide;
    metal::float3 _e274 = tint;
    streak = ((metal::mix(metal::float3(1.0, 1.0, 1.0), _e266, metal::float3(metal::smoothstep(0.0, 0.3, _e267))) * _e265) + (_e274 * (0.5 * _e272))) * 3.0;
    float _e278 = dist;
    float _e280 = dist;
    metal::float3 _e286 = tint;
    float _e289 = dist;
    core = ((metal::float3(1.0, 0.97, 0.92) * metal::exp((-(_e278) * _e280) * 600.0)) * 3.0) + ((metal::mix(metal::float3(1.0, 1.0, 1.0), _e286, metal::float3(0.5)) * metal::exp(-(_e289) * 7.0)) * 0.6);
    ghosts = metal::float3(0.0, 0.0, 0.0);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e349 = i;
            i = as_type<int>(as_type<uint>(_e349) + as_type<uint>(1));
        }
        loop_init = false;
        int _e296 = i;
        if (_e296 < 6) {
            int _e298 = i;
            fi = static_cast<float>(_e298);
            float _e300 = fi;
            float _e303 = fi;
            f = (-0.45 + (0.42 * _e300)) + (0.08 * metal::sin(_e303 * 2.3));
            metal::float2 _e308 = src;
            float _e310 = f;
            g = -(_e308) * _e310;
            float _e312 = fi;
            size = 0.025 + (0.06 * metal::fract((_e312 * 0.618) + 0.2));
            metal::float2 _e318 = q;
            metal::float2 _e319 = g;
            float _e322 = size;
            gd = metal::length(_e318 - _e319) / _e322;
            float _e324 = gd;
            float _e326 = gd;
            disc = metal::smoothstep(1.0, 0.8, _e324) * (0.35 + (0.65 * metal::smoothstep(0.4, 0.95, _e326)));
            metal::float3 _e331 = tint;
            float _e332 = fi;
            hue = metal::mix(_e331, metal::float3(1.0, 0.65, 0.35), metal::float3(metal::fract(_e332 * 0.53)));
            metal::float3 _e337 = hue;
            float _e338 = fi;
            hue = metal::mix(_e337, metal::float3(0.5, 1.0, 0.6), metal::float3(metal::step(4.5, _e338) * 0.6));
            float _e343 = disc;
            metal::float3 _e344 = hue;
            metal::float3 _e347 = ghosts;
            ghosts = _e347 + ((_e344 * _e343) * 0.45);
            continue;
        } else {
            break;
        }
    }
    bloom = metal::float3(0.0, 0.0, 0.0);
    float _e351 = peak;
    if (_e351 > 0.001) {
        float _e353 = env;
        radius = 0.06 * _e353;
        i_1 = 0;
        uint2 loop_bound_1 = uint2(4294967295u);
        bool loop_init_1 = true;
        while(true) {
            if (metal::all(loop_bound_1 == uint2(0u))) { break; }
            loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
            if (!loop_init_1) {
                int _e385 = i_1;
                i_1 = as_type<int>(as_type<uint>(_e385) + as_type<uint>(1));
            }
            loop_init_1 = false;
            int _e355 = i_1;
            if (_e355 < 12) {
                int _e357 = i_1;
                fi_1 = static_cast<float>(_e357);
                float _e359 = fi_1;
                a = _e359 * 2.39996;
                float _e361 = radius;
                float _e362 = fi_1;
                rr = _e361 * metal::sqrt((_e362 + 0.5) / 12.0);
                float _e367 = a;
                float _e369 = a;
                float _e372 = rr;
                metal::float2 _e374 = aspect;
                o = (metal::float2(metal::cos(_e367), metal::sin(_e369)) * _e372) / _e374;
                metal::float2 _e376 = uv_2;
                metal::float2 _e377 = o;
                param_12 = _e376 + _e377;
                metal::float2 _e379 = mirror(param_12);
                param_13 = _e379;
                float _e380 = m_1;
                param_14 = _e380;
                metal::float4 _e381 = frame(param_13, param_14, _from, _sampler, _to);
                param_15 = _e381;
                metal::float3 _e382 = highlight(param_15);
                metal::float3 _e383 = bloom;
                bloom = _e383 + _e382;
                continue;
            } else {
                break;
            }
        }
        metal::float3 _e387 = bloom;
        bloom = _e387 / metal::float3(12.0);
    }
    metal::float3 _e390 = tint;
    float _e393 = peak;
    float _e395 = dist;
    glare = (metal::mix(metal::float3(1.0, 1.0, 1.0), _e390, metal::float3(0.5)) * _e393) * (0.45 + (2.2 * metal::exp(-(_e395) * 3.0)));
    float _e402 = k;
    metal::float3 _e403 = streak;
    metal::float3 _e404 = core;
    metal::float3 _e406 = ghosts;
    float _e410 = uniforms.intensity;
    metal::float3 _e411 = bloom;
    float _e413 = peak;
    metal::float3 _e415 = glare;
    light = (((_e403 + _e404) + _e406) * _e402) + ((((_e411 * 2.5) * _e413) + _e415) * _e410);
    metal::float3 _e419 = light;
    light = metal::float3(1.0) - metal::exp(-(_e419));
    metal::float4 _e424 = base;
    metal::float3 _e426 = light;
    float _e428 = base[3u];
    metal::float4 _e431 = base;
    metal::float3 _e433 = light;
    c_2 = (_e424.xyz + (_e426 * _e428)) - (_e431.xyz * _e433);
    float _e437 = base[3u];
    if (_e437 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float3 _e439 = c_2;
    float _e441 = base[3u];
    metal::float3 _e446 = metal::clamp(_e439 / metal::float3(_e441), metal::float3(0.0), metal::float3(1.0));
    float _e448 = base[3u];
    return metal::float4(_e446.x, _e446.y, _e446.z, _e448);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_16 = {};
    metal::float2 _e68 = _uv_1;
    param_16 = _e68;
    metal::float4 _e69 = transition(param_16, _from, _sampler, _to, uniforms);
    _fragColor = _e69;
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
