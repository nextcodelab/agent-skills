// Disintegrate — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Disintegrate.glsl
// Author: gre
// License: MIT
// Description: The outgoing image crumbles into fine dust from one side, its grains blown away by the wind and fading out, revealing the incoming image underneath
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float particleSize;
    char _pad3[4];
    metal::float2 direction;
    float spread;
    char _pad5[4];
};

float hash12(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e56 = p;
    p3_ = metal::fract(_e56.xyx * 0.1031);
    metal::float3 _e60 = p3_;
    metal::float3 _e61 = p3_;
    metal::float3 _e66 = p3_;
    p3_ = _e66 + metal::float3(metal::dot(_e60, _e61.yzx + metal::float3(33.33)));
    float _e70 = p3_[0u];
    float _e72 = p3_[1u];
    float _e75 = p3_[2u];
    return metal::fract((_e70 + _e72) * _e75);
}

float gust(
    thread float& x
) {
    float i = {};
    float f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float _e59 = x;
    i = metal::floor(_e59);
    float _e61 = x;
    f = metal::fract(_e61);
    float _e63 = f;
    float _e64 = f;
    float _e66 = f;
    f = (_e63 * _e64) * (3.0 - (2.0 * _e66));
    float _e70 = i;
    param = metal::float2(_e70, 7.0);
    float _e72 = hash12(param);
    float _e73 = i;
    param_1 = metal::float2(_e73 + 1.0, 7.0);
    float _e76 = hash12(param_1);
    float _e77 = f;
    return (2.0 * metal::mix(_e72, _e76, _e77)) - 1.0;
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e56 = uv[0u];
    float _e58 = uv[1u];
    metal::float4 _e61 = _from.sample(_sampler, metal::float2(_e56, 1.0 - _e58), metal::level(0.0));
    return _e61;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e56 = uv_1[0u];
    float _e58 = uv_1[1u];
    metal::float4 _e61 = _to.sample(_sampler, metal::float2(_e56, 1.0 - _e58), metal::level(0.0));
    return _e61;
}

float noise(
    thread metal::float2& p_1
) {
    metal::float2 i_1 = {};
    metal::float2 f_1 = {};
    float a = {};
    metal::float2 param_2 = {};
    float b = {};
    metal::float2 param_3 = {};
    float c = {};
    metal::float2 param_4 = {};
    float d = {};
    metal::float2 param_5 = {};
    metal::float2 _e65 = p_1;
    i_1 = metal::floor(_e65);
    metal::float2 _e67 = p_1;
    f_1 = metal::fract(_e67);
    metal::float2 _e69 = f_1;
    metal::float2 _e70 = f_1;
    metal::float2 _e72 = f_1;
    f_1 = (_e69 * _e70) * (metal::float2(3.0) - (_e72 * 2.0));
    metal::float2 _e77 = i_1;
    param_2 = _e77;
    float _e78 = hash12(param_2);
    a = _e78;
    metal::float2 _e79 = i_1;
    param_3 = _e79 + metal::float2(1.0, 0.0);
    float _e81 = hash12(param_3);
    b = _e81;
    metal::float2 _e82 = i_1;
    param_4 = _e82 + metal::float2(0.0, 1.0);
    float _e84 = hash12(param_4);
    c = _e84;
    metal::float2 _e85 = i_1;
    param_5 = _e85 + metal::float2(1.0, 1.0);
    float _e87 = hash12(param_5);
    d = _e87;
    float _e88 = a;
    float _e89 = b;
    float _e91 = f_1[0u];
    float _e93 = c;
    float _e94 = d;
    float _e96 = f_1[0u];
    float _e99 = f_1[1u];
    return (2.0 * metal::mix(metal::mix(_e88, _e89, _e91), metal::mix(_e93, _e94, _e96), _e99)) - 1.0;
}

float release(
    thread metal::float2& center,
    thread float& h,
    thread float& halfLength,
    thread float& s
) {
    float front = {};
    metal::float2 param_6 = {};
    float _e61 = center[0u];
    float _e62 = halfLength;
    float _e64 = halfLength;
    metal::float2 _e68 = center;
    float _e69 = s;
    param_6 = (_e68 * _e69) * 6.0;
    float _e72 = noise(param_6);
    float _e75 = h;
    front = ((1.0 - ((_e61 + _e62) / (2.0 * _e64))) + (0.14 * _e72)) + (0.08 * (_e75 - 0.5));
    float _e79 = front;
    return metal::clamp((_e79 + 0.12) / 1.24, 0.0, 1.0) * 0.55;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 d_1 = {};
    metal::float2 local = {};
    metal::float2 n = {};
    metal::float2 fp = {};
    float s_1 = {};
    metal::float2 g = {};
    float halfLength_1 = {};
    float reach = {};
    float px = {};
    metal::float2 own = {};
    metal::float4 under = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    metal::float4 local_1 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 grainUV = {};
    float cover = {};
    int i_2 = {};
    float fi = {};
    float cx = {};
    float visible = {};
    float local_2 = {};
    float drift = {};
    float param_14 = {};
    metal::float2 cell = {};
    metal::float2 center_1 = {};
    metal::float2 cuv = {};
    float h_1 = {};
    metal::float2 param_15 = {};
    float t = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float r2_ = {};
    float travel = {};
    float crumble = {};
    metal::float2 pos = {};
    metal::float2 local_3 = {};
    float size = {};
    float feather = {};
    float a_1 = {};
    metal::float2 param_20 = {};
    bool phi_461_ = {};
    bool phi_468_ = {};
    bool phi_475_ = {};
    metal::float2 _e103 = uniforms.direction;
    if (metal::length(_e103) > 0.0) {
        metal::float2 _e107 = uniforms.direction;
        local = metal::normalize(_e107);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e109 = local;
    d_1 = _e109;
    float _e111 = d_1[1u];
    float _e114 = d_1[0u];
    n = metal::float2(-(_e111), _e114);
    metal::float2 _e116 = uv_2;
    float _e120 = uniforms.ratio;
    fp = (_e116 - metal::float2(0.5)) * metal::float2(_e120, 1.0);
    float _e124 = uniforms.particleSize;
    s_1 = _e124;
    metal::float2 _e125 = fp;
    metal::float2 _e126 = d_1;
    metal::float2 _e128 = fp;
    metal::float2 _e129 = n;
    float _e132 = s_1;
    g = metal::float2(metal::dot(_e125, _e126), metal::dot(_e128, _e129)) / metal::float2(_e132);
    float _e136 = uniforms.ratio;
    float _e138 = d_1[0u];
    float _e142 = d_1[1u];
    float _e146 = s_1;
    halfLength_1 = (0.5 * ((_e136 * metal::abs(_e138)) + metal::abs(_e142))) / _e146;
    float _e149 = uniforms.spread;
    float _e151 = s_1;
    reach = metal::min((_e149 * 0.45) / _e151, 60.0);
    float _e155 = g[0u];
    px = metal::floor(_e155);
    metal::float2 _e157 = g;
    own = metal::floor(_e157);
    float _e160 = uniforms.progress;
    metal::float2 _e161 = own;
    metal::float2 _e164 = own;
    param_7 = _e164;
    float _e165 = hash12(param_7);
    param_8 = _e161 + metal::float2(0.5);
    param_9 = _e165;
    float _e166 = halfLength_1;
    param_10 = _e166;
    float _e167 = s_1;
    param_11 = _e167;
    float _e168 = release(param_8, param_9, param_10, param_11);
    if (_e160 > _e168) {
        metal::float2 _e170 = uv_2;
        param_12 = _e170;
        metal::float4 _e171 = getToColor(param_12, _sampler, _to);
        local_1 = _e171;
    } else {
        metal::float2 _e172 = uv_2;
        param_13 = _e172;
        metal::float4 _e173 = getFromColor(param_13, _from, _sampler);
        local_1 = _e173;
    }
    metal::float4 _e174 = local_1;
    under = _e174;
    grainUV = metal::float2(0.5, 0.5);
    cover = 0.0;
    i_2 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e369 = i_2;
            i_2 = as_type<int>(as_type<uint>(_e369) + as_type<uint>(1));
        }
        loop_init = false;
        int _e175 = i_2;
        if (_e175 < 35) {
            int _e177 = i_2;
            fi = static_cast<float>(_e177);
            float _e179 = px;
            float _e180 = fi;
            cx = _e179 - _e180;
            int _e182 = i_2;
            if (_e182 >= 26) {
                float _e184 = px;
                float _e188 = fi;
                cx = (metal::floor(_e184 / 4.0) * 4.0) - (4.0 * ((_e188 - 26.0) + 8.0));
            } else {
                int _e193 = i_2;
                if (_e193 >= 17) {
                    float _e195 = px;
                    float _e199 = fi;
                    cx = (metal::floor(_e195 / 2.0) * 2.0) - (2.0 * ((_e199 - 17.0) + 8.0));
                }
            }
            float _e204 = cx;
            if ((_e204 - (metal::floor(_e204 / 4.0) * 4.0)) < 0.5) {
                local_2 = 63.0;
            } else {
                float _e210 = cx;
                local_2 = ((_e210 - (metal::floor(_e210 / 2.0) * 2.0)) < 0.5) ? 31.0 : 15.0;
            }
            float _e217 = local_2;
            visible = _e217;
            float _e218 = cx;
            float _e219 = s_1;
            param_14 = (_e218 * _e219) * 4.0;
            float _e222 = gust(param_14);
            drift = 0.3 * _e222;
            float _e224 = cx;
            float _e226 = g[1u];
            float _e227 = drift;
            float _e229 = g[0u];
            float _e230 = cx;
            cell = metal::float2(_e224, metal::floor(_e226 - (_e227 * ((_e229 - _e230) - 0.5))));
            metal::float2 _e237 = cell;
            center_1 = _e237 + metal::float2(0.5);
            float _e241 = center_1[0u];
            metal::float2 _e242 = d_1;
            float _e245 = center_1[1u];
            metal::float2 _e246 = n;
            float _e249 = s_1;
            float _e252 = uniforms.ratio;
            cuv = ((((_e242 * _e241) + (_e246 * _e245)) * _e249) / metal::float2(_e252, 1.0)) + metal::float2(0.5);
            float _e258 = cuv[0u];
            bool _e259 = _e258 < 0.0;
            phi_461_ = _e259;
            if (!(_e259)) {
                float _e262 = cuv[0u];
                phi_461_ = _e262 > 1.0;
            }
            bool _e265 = phi_461_;
            phi_468_ = _e265;
            if (!(_e265)) {
                float _e268 = cuv[1u];
                phi_468_ = _e268 < 0.0;
            }
            bool _e271 = phi_468_;
            phi_475_ = _e271;
            if (!(_e271)) {
                float _e274 = cuv[1u];
                phi_475_ = _e274 > 1.0;
            }
            bool _e277 = phi_475_;
            if (_e277) {
                continue;
            }
            metal::float2 _e278 = cell;
            param_15 = _e278;
            float _e279 = hash12(param_15);
            h_1 = _e279;
            float _e281 = uniforms.progress;
            metal::float2 _e282 = center_1;
            param_16 = _e282;
            float _e283 = h_1;
            param_17 = _e283;
            float _e284 = halfLength_1;
            param_18 = _e284;
            float _e285 = s_1;
            param_19 = _e285;
            float _e286 = release(param_16, param_17, param_18, param_19);
            t = (_e281 - _e286) / 0.45;
            float _e289 = t;
            float _e291 = t;
            if ((_e289 <= 0.0) || (_e291 >= 1.0)) {
                continue;
            }
            float _e294 = h_1;
            r2_ = metal::fract(_e294 * 13.7);
            float _e297 = reach;
            float _e298 = r2_;
            float _e302 = t;
            float _e304 = t;
            travel = ((_e297 * (0.4 + (0.6 * _e298))) * _e302) * (0.2 + (0.8 * _e304));
            float _e308 = t;
            crumble = metal::smoothstep(0.0, 0.25, _e308);
            metal::float2 _e310 = center_1;
            float _e311 = travel;
            float _e312 = h_1;
            float _e317 = crumble;
            float _e320 = drift;
            float _e321 = travel;
            pos = _e310 + metal::float2(_e311 + (((metal::fract(_e312 * 71.1) - 0.5) * 0.3) * _e317), _e320 * _e321);
            metal::float2 _e325 = g;
            metal::float2 _e326 = pos;
            local_3 = metal::abs(_e325 - _e326);
            float _e329 = t;
            float _e333 = h_1;
            float _e337 = crumble;
            size = metal::mix(0.5, (0.3 * (1.0 - (0.5 * _e329))) * (0.6 + (0.4 * _e333)), _e337);
            float _e339 = crumble;
            feather = 0.001 + (0.12 * _e339);
            float _e342 = size;
            float _e343 = feather;
            float _e345 = size;
            float _e347 = local_3[0u];
            float _e349 = local_3[1u];
            float _e353 = t;
            float _e357 = visible;
            float _e359 = visible;
            float _e360 = travel;
            a_1 = ((1.0 - metal::smoothstep(_e342 - _e343, _e345, metal::max(_e347, _e349))) * (1.0 - metal::smoothstep(0.15, 1.0, _e353))) * (1.0 - metal::smoothstep(0.6 * _e357, _e359, _e360));
            float _e364 = a_1;
            float _e365 = cover;
            if (_e364 > _e365) {
                float _e367 = a_1;
                cover = _e367;
                metal::float2 _e368 = cuv;
                grainUV = _e368;
            }
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e371 = under;
    metal::float2 _e372 = grainUV;
    param_20 = _e372;
    metal::float4 _e373 = getFromColor(param_20, _from, _sampler);
    float _e374 = cover;
    return metal::mix(_e371, _e373, metal::float4(_e374));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_21 = {};
    metal::float2 _e55 = _uv_1;
    param_21 = _e55;
    metal::float4 _e56 = transition(param_21, _from, _sampler, _to, uniforms);
    _fragColor = _e56;
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
