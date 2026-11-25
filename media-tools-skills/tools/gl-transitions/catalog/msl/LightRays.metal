// LightRays — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LightRays.glsl
// Author: gre
// License: MIT
// Description: Shafts of light burst from the highlights of the outgoing image and stream outward from a slowly drifting center; at their peak the incoming image takes over and its own rays shrink back into its highlights
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float drift;
    float reach;
    float threshold;
    float intensity;
    metal::float3 tint;
};

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e57 = v;
    v3_ = metal::fract(_e57.xyx * 0.1031);
    metal::float3 _e61 = v3_;
    metal::float3 _e62 = v3_;
    metal::float3 _e67 = v3_;
    v3_ = _e67 + metal::float3(metal::dot(_e61, _e62.yzx + metal::float3(33.33)));
    float _e71 = v3_[0u];
    float _e73 = v3_[1u];
    float _e76 = v3_[2u];
    return metal::fract((_e71 + _e73) * _e76);
}

float shaftNoise(
    thread float& t,
    thread float& n,
    thread float& seed
) {
    float x = {};
    float i = {};
    float f = {};
    float a = {};
    metal::float2 param = {};
    float b = {};
    metal::float2 param_1 = {};
    float _e65 = t;
    float _e66 = n;
    x = _e65 * _e66;
    float _e68 = x;
    i = metal::floor(_e68);
    float _e70 = x;
    float _e71 = i;
    f = _e70 - _e71;
    float _e73 = i;
    float _e74 = n;
    float _e79 = seed;
    param = metal::float2(_e73 - (metal::floor(_e73 / _e74) * _e74), _e79);
    float _e81 = hash12(param);
    a = _e81;
    float _e82 = i;
    float _e83 = _e82 + 1.0;
    float _e84 = n;
    float _e89 = seed;
    param_1 = metal::float2(_e83 - (metal::floor(_e83 / _e84) * _e84), _e89);
    float _e91 = hash12(param_1);
    b = _e91;
    float _e92 = a;
    float _e93 = b;
    float _e94 = f;
    float _e95 = f;
    float _e97 = f;
    return metal::mix(_e92, _e93, (_e94 * _e95) * (3.0 - (2.0 * _e97)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e57 = uv[0u];
    float _e59 = uv[1u];
    metal::float4 _e62 = _to.sample(_sampler, metal::float2(_e57, 1.0 - _e59), metal::level(0.0));
    return _e62;
}

metal::float3 glow(
    thread metal::float4& c,
    thread float& knee
) {
    float lum = {};
    metal::float4 _e58 = c;
    lum = metal::dot(_e58.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    metal::float4 _e61 = c;
    float _e64 = c[3u];
    float _e66 = knee;
    float _e67 = knee;
    float _e69 = lum;
    return (_e61.xyz * _e64) * metal::smoothstep(_e66, _e67 + 0.2, _e69);
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e57 = uv_1[0u];
    float _e59 = uv_1[1u];
    metal::float4 _e62 = _from.sample(_sampler, metal::float2(_e57, 1.0 - _e59), metal::level(0.0));
    return _e62;
}

metal::float3 light(
    thread metal::float2& st,
    thread float& knee_1,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param_2 = {};
    metal::float4 param_3 = {};
    float param_4 = {};
    metal::float2 param_5 = {};
    metal::float4 param_6 = {};
    float param_7 = {};
    metal::float2 param_8 = {};
    metal::float4 param_9 = {};
    float param_10 = {};
    metal::float2 param_11 = {};
    metal::float4 param_12 = {};
    float param_13 = {};
    float _e70 = m;
    if (_e70 <= 0.0) {
        metal::float2 _e72 = st;
        param_2 = _e72;
        metal::float4 _e73 = getFromColor(param_2, _from, _sampler);
        param_3 = _e73;
        float _e74 = knee_1;
        param_4 = _e74;
        metal::float3 _e75 = glow(param_3, param_4);
        return _e75;
    }
    float _e76 = m;
    if (_e76 >= 1.0) {
        metal::float2 _e78 = st;
        param_5 = _e78;
        metal::float4 _e79 = getToColor(param_5, _sampler, _to);
        param_6 = _e79;
        float _e80 = knee_1;
        param_7 = _e80;
        metal::float3 _e81 = glow(param_6, param_7);
        return _e81;
    }
    metal::float2 _e82 = st;
    param_8 = _e82;
    metal::float4 _e83 = getFromColor(param_8, _from, _sampler);
    param_9 = _e83;
    float _e84 = knee_1;
    param_10 = _e84;
    metal::float3 _e85 = glow(param_9, param_10);
    metal::float2 _e86 = st;
    param_11 = _e86;
    metal::float4 _e87 = getToColor(param_11, _sampler, _to);
    param_12 = _e87;
    float _e88 = knee_1;
    param_13 = _e88;
    metal::float3 _e89 = glow(param_12, param_13);
    float _e90 = m;
    return metal::mix(_e85, _e89, metal::float3(_e90));
}

metal::float2 mirror(
    thread metal::float2& v_1
) {
    metal::float2 _e56 = v_1;
    metal::float2 _e57 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e56 - (metal::floor(_e56 / _e57) * _e57)));
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
    float local = {};
    float peak = {};
    float m_1 = {};
    metal::float4 fromColor = {};
    metal::float2 param_14 = {};
    metal::float4 toColor = {};
    metal::float2 param_15 = {};
    metal::float2 origin = {};
    float len = {};
    float knee_2 = {};
    float jitter = {};
    metal::float2 param_16 = {};
    metal::float3 rays = {};
    float total = {};
    int i_1 = {};
    float s = {};
    float w = {};
    metal::float3 hue = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    float param_19 = {};
    float param_20 = {};
    metal::float2 d = {};
    float turn = {};
    float local_1 = {};
    float shafts = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    metal::float4 c_1 = {};
    metal::float3 base = {};
    float _e93 = uniforms.progress;
    p = _e93;
    float _e94 = p;
    if (_e94 < 0.5) {
        float _e96 = p;
        local = metal::smoothstep(0.0, 0.5, _e96);
    } else {
        float _e98 = p;
        local = 1.0 - metal::smoothstep(0.5, 1.0, _e98);
    }
    float _e101 = local;
    amount = _e101;
    float _e102 = amount;
    float _e103 = amount;
    float _e105 = amount;
    peak = (_e102 * _e103) * _e105;
    float _e107 = p;
    m_1 = metal::smoothstep(0.46, 0.54, _e107);
    metal::float2 _e109 = uv_2;
    param_14 = _e109;
    metal::float4 _e110 = getFromColor(param_14, _from, _sampler);
    fromColor = _e110;
    metal::float2 _e111 = uv_2;
    param_15 = _e111;
    metal::float4 _e112 = getToColor(param_15, _sampler, _to);
    toColor = _e112;
    float _e113 = amount;
    if (_e113 <= 0.0) {
        float _e115 = m_1;
        metal::float4 _e117 = fromColor;
        metal::float4 _e118 = toColor;
        return metal::select(_e118, _e117, metal::bool4(_e115 < 0.5));
    }
    metal::float2 _e122 = uniforms.center;
    float _e124 = uniforms.drift;
    float _e125 = p;
    origin = _e122 + metal::float2(_e124 * (_e125 - 0.5), 0.0);
    float _e131 = uniforms.reach;
    float _e132 = amount;
    len = _e131 * _e132;
    float _e135 = uniforms.threshold;
    float _e137 = uniforms.threshold;
    float _e139 = peak;
    knee_2 = metal::mix(_e135, 0.75 * _e137, _e139);
    metal::float2 _e141 = uv_2;
    float _e143 = uniforms.ratio;
    param_16 = metal::floor((_e141 * metal::float2(_e143, 1.0)) * 997.0);
    float _e148 = hash12(param_16);
    jitter = _e148;
    rays = metal::float3(0.0, 0.0, 0.0);
    total = 0.0;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e185 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e185) + as_type<uint>(1));
        }
        loop_init = false;
        int _e149 = i_1;
        if (_e149 < 20) {
            int _e151 = i_1;
            float _e153 = jitter;
            s = (static_cast<float>(_e151) + _e153) / 20.0;
            float _e156 = s;
            w = metal::exp(-2.0 * _e156);
            metal::float3 _e160 = uniforms.tint;
            float _e161 = s;
            hue = metal::mix(metal::float3(1.0, 1.0, 1.0), _e160, metal::float3(metal::smoothstep(0.0, 0.6, _e161)));
            float _e165 = w;
            metal::float3 _e166 = hue;
            metal::float2 _e168 = uv_2;
            metal::float2 _e169 = origin;
            float _e170 = s;
            float _e171 = len;
            param_17 = metal::mix(_e168, _e169, metal::float2(_e170 * _e171));
            metal::float2 _e175 = mirror(param_17);
            param_18 = _e175;
            float _e176 = knee_2;
            param_19 = _e176;
            float _e177 = m_1;
            param_20 = _e177;
            metal::float3 _e178 = light(param_18, param_19, param_20, _from, _sampler, _to);
            metal::float3 _e180 = rays;
            rays = _e180 + ((_e166 * _e165) * _e178);
            float _e182 = w;
            float _e183 = total;
            total = _e183 + _e182;
            continue;
        } else {
            break;
        }
    }
    metal::float2 _e187 = uv_2;
    metal::float2 _e188 = origin;
    float _e191 = uniforms.ratio;
    d = (_e187 - _e188) * metal::float2(_e191, 1.0);
    metal::float2 _e194 = d;
    if (metal::length(_e194) > 0.000001) {
        float _e198 = d[1u];
        float _e200 = d[0u];
        local_1 = (metal::atan2(_e198, _e200) / 6.2831855) + 0.5;
    } else {
        local_1 = 0.0;
    }
    float _e204 = local_1;
    turn = _e204;
    float _e205 = turn;
    float _e206 = p;
    param_21 = metal::fract(_e205 + (0.03 * _e206));
    param_22 = 23.0;
    param_23 = 1.0;
    float _e210 = shaftNoise(param_21, param_22, param_23);
    float _e212 = turn;
    float _e213 = p;
    param_24 = metal::fract(_e212 - (0.05 * _e213));
    param_25 = 47.0;
    param_26 = 7.0;
    float _e217 = shaftNoise(param_24, param_25, param_26);
    shafts = (0.6 * _e210) + (0.4 * _e217);
    float _e220 = shafts;
    metal::float2 _e223 = d;
    metal::float3 _e227 = rays;
    rays = _e227 * metal::mix(1.0, metal::mix(0.2, 1.6, metal::smoothstep(0.15, 0.85, _e220)), metal::smoothstep(0.0, 0.3, metal::length(_e223)));
    float _e230 = uniforms.intensity;
    float _e231 = amount;
    float _e233 = peak;
    float _e237 = total;
    metal::float3 _e239 = rays;
    rays = _e239 * (((_e230 * _e231) * (1.0 + (3.0 * _e233))) / _e237);
    metal::float3 _e241 = rays;
    rays = (metal::float3(1.0) - metal::exp(-(_e241))) * 0.9;
    metal::float4 _e247 = fromColor;
    float _e250 = fromColor[3u];
    metal::float3 _e251 = _e247.xyz * _e250;
    float _e253 = fromColor[3u];
    metal::float4 _e258 = toColor;
    float _e261 = toColor[3u];
    metal::float3 _e262 = _e258.xyz * _e261;
    float _e264 = toColor[3u];
    float _e269 = m_1;
    c_1 = metal::mix(metal::float4(_e251.x, _e251.y, _e251.z, _e253), metal::float4(_e262.x, _e262.y, _e262.z, _e264), metal::float4(_e269));
    float _e273 = c_1[3u];
    if (_e273 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e275 = c_1;
    float _e278 = c_1[3u];
    float _e281 = peak;
    base = metal::min((_e275.xyz / metal::float3(_e278)) * (1.0 + (0.2 * _e281)), metal::float3(1.0));
    metal::float3 _e287 = base;
    metal::float3 _e288 = rays;
    metal::float3 _e290 = base;
    metal::float3 _e291 = rays;
    metal::float3 _e293 = (_e287 + _e288) - (_e290 * _e291);
    float _e295 = c_1[3u];
    return metal::float4(_e293.x, _e293.y, _e293.z, _e295);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_27 = {};
    metal::float2 _e56 = _uv_1;
    param_27 = _e56;
    metal::float4 _e57 = transition(param_27, _from, _sampler, _to, uniforms);
    _fragColor = _e57;
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
