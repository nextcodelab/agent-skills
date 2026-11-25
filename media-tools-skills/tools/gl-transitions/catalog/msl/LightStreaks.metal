// LightStreaks — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightStreaks.glsl
// Author: gre
// License: MIT
// Description: The highlights of the outgoing image flare into long horizontal (or vertical) lens streaks while it smears with motion blur; at the peak the incoming image takes over and its streaks shrink back into its highlights as it sharpens
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float reach;
    float threshold;
    float intensity;
    char _pad5[12];
    metal::packed_float3 tint;
    float blur;
    int vertical;
    char _pad8[12];
};

metal::float3 glow(
    thread metal::float4& c,
    thread float& knee
) {
    float lum = {};
    metal::float4 _e52 = c;
    lum = metal::dot(_e52.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    metal::float4 _e55 = c;
    float _e58 = c[3u];
    float _e60 = knee;
    float _e61 = knee;
    float _e63 = lum;
    return (_e55.xyz * _e58) * metal::smoothstep(_e60, _e61 + 0.2, _e63);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e51 = uv[0u];
    float _e53 = uv[1u];
    metal::float4 _e56 = _to.sample(_sampler, metal::float2(_e51, 1.0 - _e53), metal::level(0.0));
    return _e56;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e51 = uv_1[0u];
    float _e53 = uv_1[1u];
    metal::float4 _e56 = _from.sample(_sampler, metal::float2(_e51, 1.0 - _e53), metal::level(0.0));
    return _e56;
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
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float _e55 = m;
    if (_e55 <= 0.0) {
        metal::float2 _e57 = st;
        param = _e57;
        metal::float4 _e58 = getFromColor(param, _from, _sampler);
        return _e58;
    }
    float _e59 = m;
    if (_e59 >= 1.0) {
        metal::float2 _e61 = st;
        param_1 = _e61;
        metal::float4 _e62 = getToColor(param_1, _sampler, _to);
        return _e62;
    }
    metal::float2 _e63 = st;
    param_2 = _e63;
    metal::float4 _e64 = getFromColor(param_2, _from, _sampler);
    metal::float2 _e65 = st;
    param_3 = _e65;
    metal::float4 _e66 = getToColor(param_3, _sampler, _to);
    float _e67 = m;
    return metal::mix(_e64, _e66, metal::float4(_e67));
}

metal::float4 light(
    thread metal::float2& st_1,
    thread float& m_1,
    thread bool& incoming,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float4 local = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float _e57 = m_1;
    if (_e57 <= 0.0) {
        metal::float2 _e59 = st_1;
        param_4 = _e59;
        metal::float4 _e60 = getFromColor(param_4, _from, _sampler);
        return _e60;
    }
    float _e61 = m_1;
    if (_e61 >= 1.0) {
        metal::float2 _e63 = st_1;
        param_5 = _e63;
        metal::float4 _e64 = getToColor(param_5, _sampler, _to);
        return _e64;
    }
    bool _e65 = incoming;
    if (_e65) {
        metal::float2 _e66 = st_1;
        param_6 = _e66;
        metal::float4 _e67 = getToColor(param_6, _sampler, _to);
        local = _e67;
    } else {
        metal::float2 _e68 = st_1;
        param_7 = _e68;
        metal::float4 _e69 = getFromColor(param_7, _from, _sampler);
        local = _e69;
    }
    metal::float4 _e70 = local;
    return _e70;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e50 = v;
    metal::float2 _e51 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e50 - (metal::floor(_e50 / _e51) * _e51)));
}

float lightWeight(
    thread float& m_2,
    thread bool& incoming_1
) {
    float local_1 = {};
    float _e52 = m_2;
    float _e54 = m_2;
    if ((_e52 <= 0.0) || (_e54 >= 1.0)) {
        return 1.0;
    }
    bool _e57 = incoming_1;
    if (_e57) {
        float _e58 = m_2;
        local_1 = 2.0 * _e58;
    } else {
        float _e60 = m_2;
        local_1 = 2.0 * (1.0 - _e60);
    }
    float _e63 = local_1;
    return _e63;
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e51 = v_1;
    v3_ = metal::fract(_e51.xyx * 0.1031);
    metal::float3 _e55 = v3_;
    metal::float3 _e56 = v3_;
    metal::float3 _e61 = v3_;
    v3_ = _e61 + metal::float3(metal::dot(_e55, _e56.yzx + metal::float3(33.33)));
    float _e65 = v3_[0u];
    float _e67 = v3_[1u];
    float _e70 = v3_[2u];
    return metal::fract((_e65 + _e67) * _e70);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float amount = {};
    float local_2 = {};
    float peak = {};
    float m_3 = {};
    metal::float2 axis = {};
    float jitter = {};
    metal::float2 param_8 = {};
    float smear = {};
    metal::float3 base = {};
    float alpha = {};
    float total = {};
    int i = {};
    float t = {};
    float w = {};
    bool incoming_2 = {};
    float param_9 = {};
    bool param_10 = {};
    metal::float4 c_1 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    bool param_14 = {};
    float falloff = {};
    float knee_1 = {};
    metal::float3 streak = {};
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float4 param_17 = {};
    float param_18 = {};
    float weights = {};
    int k = {};
    float d = {};
    float span = {};
    metal::float3 hue = {};
    float w_1 = {};
    bool incoming_3 = {};
    metal::float4 ahead = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    bool param_22 = {};
    metal::float4 behind = {};
    metal::float2 param_23 = {};
    metal::float2 param_24 = {};
    float param_25 = {};
    bool param_26 = {};
    metal::float4 param_27 = {};
    float param_28 = {};
    float param_29 = {};
    bool param_30 = {};
    metal::float4 param_31 = {};
    float param_32 = {};
    float param_33 = {};
    bool param_34 = {};
    metal::float3 color = {};
    float a = {};
    float _e108 = uniforms.progress;
    p = _e108;
    float _e109 = p;
    if (_e109 < 0.5) {
        float _e111 = p;
        local_2 = metal::smoothstep(0.0, 0.5, _e111);
    } else {
        float _e113 = p;
        local_2 = metal::pow(2.0 - (2.0 * _e113), 3.0);
    }
    float _e117 = local_2;
    amount = _e117;
    float _e118 = amount;
    float _e119 = amount;
    float _e121 = amount;
    peak = (_e118 * _e119) * _e121;
    float _e123 = p;
    m_3 = metal::smoothstep(0.44, 0.56, _e123);
    int _e126 = uniforms.vertical;
    axis = metal::select(metal::float2(1.0, 0.0), metal::float2(0.0, 1.0), metal::bool2(_e126 != 0));
    metal::float2 _e130 = uv_2;
    float _e132 = uniforms.ratio;
    param_8 = metal::floor((_e130 * metal::float2(_e132, 1.0)) * 997.0);
    float _e137 = hash12(param_8);
    jitter = _e137 - 0.5;
    float _e140 = uniforms.blur;
    float _e141 = amount;
    smear = _e140 * _e141;
    base = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    total = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e196 = i;
            i = as_type<int>(as_type<uint>(_e196) + as_type<uint>(1));
        }
        loop_init = false;
        int _e143 = i;
        if (_e143 < 6) {
            int _e145 = i;
            float _e148 = jitter;
            t = (((static_cast<float>(_e145) + 0.5) + _e148) / 6.0) - 0.5;
            float _e152 = t;
            w = 1.0 - metal::abs(_e152);
            float _e155 = w;
            float _e156 = total;
            total = _e156 + _e155;
            int _e158 = i;
            float _e159 = static_cast<float>(_e158);
            incoming_2 = (_e159 - (metal::floor(_e159 / 2.0) * 2.0)) > 0.5;
            float _e165 = m_3;
            param_9 = _e165;
            bool _e166 = incoming_2;
            param_10 = _e166;
            float _e167 = lightWeight(param_9, param_10);
            float _e168 = w;
            w = _e168 * _e167;
            metal::float2 _e170 = uv_2;
            metal::float2 _e171 = axis;
            float _e172 = t;
            float _e174 = smear;
            param_11 = _e170 + ((_e171 * _e172) * _e174);
            metal::float2 _e177 = mirror(param_11);
            param_12 = _e177;
            float _e178 = m_3;
            param_13 = _e178;
            bool _e179 = incoming_2;
            param_14 = _e179;
            metal::float4 _e180 = light(param_12, param_13, param_14, _from, _sampler, _to);
            c_1 = _e180;
            float _e181 = w;
            metal::float4 _e182 = c_1;
            float _e186 = c_1[3u];
            metal::float3 _e188 = base;
            base = _e188 + ((_e182.xyz * _e181) * _e186);
            float _e190 = w;
            float _e192 = c_1[3u];
            float _e194 = alpha;
            alpha = _e194 + (_e190 * _e192);
            continue;
        } else {
            break;
        }
    }
    float _e198 = total;
    metal::float3 _e199 = base;
    base = _e199 / metal::float3(_e198);
    float _e202 = total;
    float _e203 = alpha;
    alpha = _e203 / _e202;
    float _e206 = uniforms.reach;
    float _e208 = amount;
    falloff = (0.25 * _e206) * _e208;
    float _e211 = uniforms.threshold;
    float _e213 = uniforms.threshold;
    float _e215 = peak;
    knee_1 = metal::mix(_e211, 0.8 * _e213, _e215);
    metal::float2 _e217 = uv_2;
    param_15 = _e217;
    float _e218 = m_3;
    param_16 = _e218;
    metal::float4 _e219 = frame(param_15, param_16, _from, _sampler, _to);
    param_17 = _e219;
    float _e220 = knee_1;
    param_18 = _e220;
    metal::float3 _e221 = glow(param_17, param_18);
    streak = _e221;
    weights = 1.0;
    k = 1;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e309 = k;
            k = as_type<int>(as_type<uint>(_e309) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e222 = k;
        if (_e222 <= 11) {
            int _e224 = k;
            float _e226 = jitter;
            d = metal::exp(0.14 * (static_cast<float>(_e224) + (0.8 * _e226))) - 1.0;
            float _e232 = d;
            span = 0.14 * (_e232 + 1.0);
            metal::float3 _e236 = uniforms.tint;
            float _e237 = d;
            hue = metal::mix(metal::float3(1.0, 1.0, 1.0), _e236, metal::float3(metal::smoothstep(0.0, 0.8, _e237)));
            float _e241 = d;
            metal::float3 _e245 = hue;
            hue = _e245 * metal::exp(metal::float3(0.6, 0.2, -0.15) * -(_e241));
            float _e247 = d;
            float _e250 = span;
            w_1 = (metal::exp(-(_e247)) * _e250) * 4.0;
            int _e253 = k;
            float _e254 = static_cast<float>(_e253);
            incoming_3 = (_e254 - (metal::floor(_e254 / 2.0) * 2.0)) > 0.5;
            metal::float2 _e260 = uv_2;
            metal::float2 _e261 = axis;
            float _e262 = d;
            float _e264 = falloff;
            param_19 = _e260 + ((_e261 * _e262) * _e264);
            metal::float2 _e267 = mirror(param_19);
            param_20 = _e267;
            float _e268 = m_3;
            param_21 = _e268;
            bool _e269 = incoming_3;
            param_22 = _e269;
            metal::float4 _e270 = light(param_20, param_21, param_22, _from, _sampler, _to);
            ahead = _e270;
            metal::float2 _e271 = uv_2;
            metal::float2 _e272 = axis;
            float _e273 = d;
            float _e275 = falloff;
            param_23 = _e271 - ((_e272 * _e273) * _e275);
            metal::float2 _e278 = mirror(param_23);
            bool _e279 = incoming_3;
            param_24 = _e278;
            float _e281 = m_3;
            param_25 = _e281;
            param_26 = !(_e279);
            metal::float4 _e282 = light(param_24, param_25, param_26, _from, _sampler, _to);
            behind = _e282;
            float _e283 = w_1;
            metal::float3 _e284 = hue;
            metal::float4 _e286 = ahead;
            param_27 = _e286;
            float _e287 = knee_1;
            param_28 = _e287;
            metal::float3 _e288 = glow(param_27, param_28);
            float _e289 = m_3;
            param_29 = _e289;
            bool _e290 = incoming_3;
            param_30 = _e290;
            float _e291 = lightWeight(param_29, param_30);
            metal::float4 _e293 = behind;
            param_31 = _e293;
            float _e294 = knee_1;
            param_32 = _e294;
            metal::float3 _e295 = glow(param_31, param_32);
            bool _e296 = incoming_3;
            float _e298 = m_3;
            param_33 = _e298;
            param_34 = !(_e296);
            float _e299 = lightWeight(param_33, param_34);
            metal::float3 _e303 = streak;
            streak = _e303 + ((_e284 * _e283) * ((_e288 * _e291) + (_e295 * _e299)));
            float _e305 = w_1;
            float _e307 = weights;
            weights = _e307 + (2.0 * _e305);
            continue;
        } else {
            break;
        }
    }
    float _e312 = uniforms.intensity;
    float _e313 = amount;
    float _e315 = peak;
    float _e320 = weights;
    metal::float3 _e322 = streak;
    streak = _e322 * ((((_e312 * _e313) * (0.6 + (2.4 * _e315))) * 2.0) / _e320);
    metal::float3 _e324 = streak;
    streak = (metal::float3(1.0) - metal::exp(-(_e324))) * 0.85;
    metal::float3 _e330 = base;
    float _e331 = peak;
    float _e335 = alpha;
    base = metal::min(_e330 * (1.0 + (0.2 * _e331)), metal::float3(_e335));
    metal::float3 _e338 = base;
    metal::float3 _e339 = streak;
    metal::float3 _e341 = base;
    metal::float3 _e342 = streak;
    color = (_e338 + _e339) - (_e341 * _e342);
    float _e345 = alpha;
    float _e347 = streak[0u];
    float _e349 = streak[1u];
    float _e351 = streak[2u];
    float _e354 = alpha;
    a = _e345 + (metal::max(_e347, metal::max(_e349, _e351)) * (1.0 - _e354));
    metal::float3 _e358 = color;
    float _e359 = a;
    metal::float3 _e365 = metal::clamp(_e358 / metal::float3(metal::max(_e359, 0.00001)), metal::float3(0.0), metal::float3(1.0));
    float _e366 = a;
    return metal::float4(_e365.x, _e365.y, _e365.z, _e366);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_35 = {};
    metal::float2 _e50 = _uv_1;
    param_35 = _e50;
    metal::float4 _e51 = transition(param_35, _from, _sampler, _to, uniforms);
    _fragColor = _e51;
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
