// SmokeDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SmokeDissolve.glsl
// Author: gre
// License: MIT
// Description: Billowing smoke drifts in across the outgoing image, with lit tops, darker folds and wispy edges, and thickens until it covers the frame; as it thins out and drifts away, the incoming image shows through
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float scale;
    float spread;
    float softness;
    char _pad6[4];
    metal::float4 color;
};

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e67 = v;
    v3_ = metal::fract(_e67.xyx * 0.1031);
    metal::float3 _e71 = v3_;
    metal::float3 _e72 = v3_;
    metal::float3 _e77 = v3_;
    v3_ = _e77 + metal::float3(metal::dot(_e71, _e72.yzx + metal::float3(33.33)));
    float _e81 = v3_[0u];
    float _e83 = v3_[1u];
    float _e86 = v3_[2u];
    return metal::fract((_e81 + _e83) * _e86);
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
    metal::float2 _e72 = v_1;
    i = metal::floor(_e72);
    metal::float2 _e74 = v_1;
    f = metal::fract(_e74);
    metal::float2 _e76 = f;
    metal::float2 _e77 = f;
    metal::float2 _e79 = f;
    f = (_e76 * _e77) * (metal::float2(3.0) - (_e79 * 2.0));
    metal::float2 _e84 = i;
    param = _e84;
    float _e85 = hash12(param);
    metal::float2 _e86 = i;
    param_1 = _e86 + metal::float2(1.0, 0.0);
    float _e88 = hash12(param_1);
    float _e90 = f[0u];
    metal::float2 _e92 = i;
    param_2 = _e92 + metal::float2(0.0, 1.0);
    float _e94 = hash12(param_2);
    metal::float2 _e95 = i;
    param_3 = _e95 + metal::float2(1.0, 1.0);
    float _e97 = hash12(param_3);
    float _e99 = f[0u];
    float _e102 = f[1u];
    return metal::mix(metal::mix(_e85, _e88, _e90), metal::mix(_e94, _e97, _e99), _e102);
}

float fbm(
    thread metal::float2& v_2
) {
    float sum = {};
    float amp = {};
    int i_1 = {};
    metal::float2 param_4 = {};
    sum = 0.0;
    amp = 0.5;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e84 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e84) + as_type<uint>(1));
        }
        loop_init = false;
        int _e70 = i_1;
        if (_e70 < 4) {
            float _e72 = amp;
            metal::float2 _e73 = v_2;
            param_4 = _e73;
            float _e74 = vnoise(param_4);
            float _e76 = sum;
            sum = _e76 + (_e72 * _e74);
            metal::float2 _e78 = v_2;
            v_2 = (metal::float2x2(metal::float2(1.6, 1.2), metal::float2(-1.2, 1.6)) * _e78) + metal::float2(5.3);
            float _e82 = amp;
            amp = _e82 * 0.5;
            continue;
        } else {
            break;
        }
    }
    float _e86 = sum;
    return _e86 / 0.9375;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e67 = uv[0u];
    float _e69 = uv[1u];
    metal::float4 _e72 = _to.sample(_sampler, metal::float2(_e67, 1.0 - _e69), metal::level(0.0));
    return _e72;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e67 = uv_1[0u];
    float _e69 = uv_1[1u];
    metal::float4 _e72 = _from.sample(_sampler, metal::float2(_e67, 1.0 - _e69), metal::level(0.0));
    return _e72;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    metal::float2 pos = {};
    float len = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    float ext = {};
    float along = {};
    float local_1 = {};
    float arrive = {};
    float leave = {};
    float body = {};
    float m = {};
    metal::float4 local_2 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 q = {};
    metal::float2 churn = {};
    metal::float2 warp = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 w = {};
    float n = {};
    metal::float2 param_9 = {};
    float lit = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    float wisp = {};
    metal::float2 param_12 = {};
    float edge = {};
    float d = {};
    metal::float4 base = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float4 a = {};
    metal::float2 param_15 = {};
    metal::float4 b = {};
    metal::float2 param_16 = {};
    metal::float4 local_3 = {};
    float shade = {};
    metal::float3 smoke = {};
    float _e107 = uniforms.progress;
    p = _e107;
    metal::float2 _e108 = uv_2;
    float _e112 = uniforms.ratio;
    pos = (_e108 - metal::float2(0.5)) * metal::float2(_e112, 1.0);
    metal::float2 _e116 = uniforms.direction;
    len = metal::length(_e116);
    float _e118 = len;
    if (_e118 > 0.0001) {
        metal::float2 _e121 = uniforms.direction;
        float _e122 = len;
        local = _e121 / metal::float2(_e122);
    } else {
        local = metal::float2(0.0, 0.0);
    }
    metal::float2 _e125 = local;
    dir = _e125;
    float _e127 = dir[0u];
    float _e130 = uniforms.ratio;
    float _e133 = dir[1u];
    ext = (0.5 * ((metal::abs(_e127) * _e130) + metal::abs(_e133))) + 0.0001;
    float _e138 = len;
    if (_e138 > 0.0001) {
        metal::float2 _e140 = pos;
        metal::float2 _e141 = dir;
        float _e144 = ext;
        local_1 = 0.5 + ((0.5 * metal::dot(_e140, _e141)) / _e144);
    } else {
        local_1 = 0.5;
    }
    float _e147 = local_1;
    along = _e147;
    float _e148 = p;
    float _e151 = uniforms.spread;
    float _e155 = uniforms.spread;
    float _e156 = along;
    arrive = ((_e148 / 0.45) * (1.0 + _e151)) - (_e155 * _e156);
    float _e159 = p;
    float _e163 = uniforms.spread;
    float _e167 = uniforms.spread;
    float _e168 = along;
    leave = (((_e159 - 0.55) / 0.45) * (1.0 + _e163)) - (_e167 * _e168);
    float _e171 = arrive;
    float _e173 = leave;
    body = metal::smoothstep(0.0, 1.0, _e171) * (1.0 - metal::smoothstep(0.0, 1.0, _e173));
    float _e177 = p;
    m = metal::smoothstep(0.48, 0.52, _e177);
    float _e179 = body;
    if (_e179 <= 0.0) {
        float _e181 = m;
        if (_e181 < 0.5) {
            metal::float2 _e183 = uv_2;
            param_5 = _e183;
            metal::float4 _e184 = getFromColor(param_5, _from, _sampler);
            local_2 = _e184;
        } else {
            metal::float2 _e185 = uv_2;
            param_6 = _e185;
            metal::float4 _e186 = getToColor(param_6, _sampler, _to);
            local_2 = _e186;
        }
        metal::float4 _e187 = local_2;
        return _e187;
    }
    metal::float2 _e188 = pos;
    metal::float2 _e190 = uniforms.direction;
    float _e191 = p;
    float _e196 = uniforms.scale;
    q = (_e188 - (_e190 * (_e191 - 0.5))) * _e196;
    float _e198 = p;
    float _e200 = p;
    churn = metal::float2(0.5 * _e198, -0.35 * _e200);
    metal::float2 _e203 = q;
    metal::float2 _e205 = churn;
    param_7 = (_e203 + metal::float2(3.1, 1.7)) + _e205;
    float _e207 = fbm(param_7);
    metal::float2 _e208 = q;
    metal::float2 _e210 = churn;
    param_8 = (_e208 + metal::float2(8.3, 2.8)) - _e210;
    float _e212 = fbm(param_8);
    warp = metal::float2(_e207, _e212);
    metal::float2 _e214 = q;
    metal::float2 _e215 = warp;
    w = _e214 + ((_e215 - metal::float2(0.5)) * 1.1);
    metal::float2 _e220 = w;
    param_9 = _e220;
    float _e221 = fbm(param_9);
    n = _e221;
    metal::float2 _e222 = w;
    param_10 = _e222;
    float _e223 = vnoise(param_10);
    metal::float2 _e224 = w;
    param_11 = _e224 + metal::float2(0.0, 0.2);
    float _e226 = vnoise(param_11);
    lit = 0.53 * (_e223 - _e226);
    metal::float2 _e229 = w;
    metal::float2 _e231 = churn;
    param_12 = (_e229 * 3.3) - (_e231 * 2.0);
    float _e234 = vnoise(param_12);
    wisp = _e234 - 0.5;
    float _e236 = body;
    float _e238 = n;
    float _e242 = body;
    float _e244 = body;
    float _e247 = wisp;
    edge = ((2.0 * _e236) - (1.0 - metal::smoothstep(0.1, 0.6, _e238))) + (((1.6 * _e242) * (1.0 - _e244)) * _e247);
    float _e251 = uniforms.softness;
    float _e252 = edge;
    float _e254 = body;
    d = metal::smoothstep(0.0, _e251, _e252) * metal::mix(0.5, 1.0, metal::smoothstep(0.2, 0.9, _e254));
    float _e258 = m;
    if (_e258 <= 0.0) {
        metal::float2 _e260 = uv_2;
        param_13 = _e260;
        metal::float4 _e261 = getFromColor(param_13, _from, _sampler);
        base = _e261;
    } else {
        float _e262 = m;
        if (_e262 >= 1.0) {
            metal::float2 _e264 = uv_2;
            param_14 = _e264;
            metal::float4 _e265 = getToColor(param_14, _sampler, _to);
            base = _e265;
        } else {
            metal::float2 _e266 = uv_2;
            param_15 = _e266;
            metal::float4 _e267 = getFromColor(param_15, _from, _sampler);
            a = _e267;
            metal::float2 _e268 = uv_2;
            param_16 = _e268;
            metal::float4 _e269 = getToColor(param_16, _sampler, _to);
            b = _e269;
            metal::float4 _e270 = a;
            float _e273 = a[3u];
            metal::float3 _e274 = _e270.xyz * _e273;
            float _e276 = a[3u];
            metal::float4 _e281 = b;
            float _e284 = b[3u];
            metal::float3 _e285 = _e281.xyz * _e284;
            float _e287 = b[3u];
            float _e292 = m;
            base = metal::mix(metal::float4(_e274.x, _e274.y, _e274.z, _e276), metal::float4(_e285.x, _e285.y, _e285.z, _e287), metal::float4(_e292));
            float _e296 = base[3u];
            if (_e296 > 0.0) {
                metal::float4 _e298 = base;
                float _e301 = base[3u];
                metal::float3 _e303 = _e298.xyz / metal::float3(_e301);
                float _e305 = base[3u];
                local_3 = metal::float4(_e303.x, _e303.y, _e303.z, _e305);
            } else {
                local_3 = metal::float4(0.0, 0.0, 0.0, 0.0);
            }
            metal::float4 _e310 = local_3;
            base = _e310;
        }
    }
    float _e311 = d;
    if (_e311 <= 0.0) {
        metal::float4 _e313 = base;
        return _e313;
    }
    float _e314 = lit;
    shade = 0.92 + (1.3 * _e314);
    float _e317 = n;
    float _e320 = shade;
    shade = _e320 * metal::mix(0.76, 1.04, metal::smoothstep(0.25, 0.75, _e317));
    float _e322 = shade;
    float _e323 = d;
    shade = metal::mix(1.0, _e322, 0.3 + (0.7 * _e323));
    metal::float4 _e328 = uniforms.color;
    float _e330 = shade;
    smoke = metal::clamp(_e328.xyz * _e330, metal::float3(0.0), metal::float3(1.0));
    metal::float4 _e335 = base;
    metal::float3 _e336 = smoke;
    float _e339 = uniforms.color[3u];
    float _e344 = d;
    return metal::mix(_e335, metal::float4(_e336.x, _e336.y, _e336.z, _e339), metal::float4(_e344));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_17 = {};
    metal::float2 _e66 = _uv_1;
    param_17 = _e66;
    metal::float4 _e67 = transition(param_17, _from, _sampler, _to, uniforms);
    _fragColor = _e67;
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
