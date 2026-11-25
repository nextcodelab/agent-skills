// InkBleed — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/InkBleed.glsl
// Author: gre
// License: MIT
// Description: The incoming image spreads over the outgoing one like drops of ink in water, blooming from a few points with curling, wispy edges and a darker rim, until it fills the frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float drops;
    float tendrils;
    float rim;
    float seed;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e71 = uv[0u];
    float _e73 = uv[1u];
    metal::float4 _e76 = _from.sample(_sampler, metal::float2(_e71, 1.0 - _e73), metal::level(0.0));
    return _e76;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e71 = uv_1[0u];
    float _e73 = uv_1[1u];
    metal::float4 _e76 = _to.sample(_sampler, metal::float2(_e71, 1.0 - _e73), metal::level(0.0));
    return _e76;
}

metal::float2 fold(
    thread metal::float2& p
) {
    metal::float2 _e70 = p;
    metal::float2 _e71 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e70 - (metal::floor(_e70 / _e71) * _e71)));
}

float hash(
    thread metal::float2& p_1
) {
    metal::float3 p3_ = {};
    metal::float2 _e71 = p_1;
    p3_ = metal::fract(_e71.xyx * 0.1031);
    metal::float3 _e75 = p3_;
    metal::float3 _e76 = p3_;
    metal::float3 _e81 = p3_;
    p3_ = _e81 + metal::float3(metal::dot(_e75, _e76.yzx + metal::float3(33.33)));
    float _e85 = p3_[0u];
    float _e87 = p3_[1u];
    float _e90 = p3_[2u];
    return metal::fract((_e85 + _e87) * _e90);
}

float vnoise(
    thread metal::float2& p_2
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e76 = p_2;
    i = metal::floor(_e76);
    metal::float2 _e78 = p_2;
    f = metal::fract(_e78);
    metal::float2 _e80 = f;
    metal::float2 _e81 = f;
    metal::float2 _e83 = f;
    f = (_e80 * _e81) * (metal::float2(3.0) - (_e83 * 2.0));
    metal::float2 _e88 = i;
    param = _e88;
    float _e89 = hash(param);
    metal::float2 _e90 = i;
    param_1 = _e90 + metal::float2(1.0, 0.0);
    float _e92 = hash(param_1);
    float _e94 = f[0u];
    metal::float2 _e96 = i;
    param_2 = _e96 + metal::float2(0.0, 1.0);
    float _e98 = hash(param_2);
    metal::float2 _e99 = i;
    param_3 = _e99 + metal::float2(1.0, 1.0);
    float _e101 = hash(param_3);
    float _e103 = f[0u];
    float _e106 = f[1u];
    return metal::mix(metal::mix(_e89, _e92, _e94), metal::mix(_e98, _e101, _e103), _e106);
}

float fbm(
    thread metal::float2& p_3
) {
    float v = {};
    float a = {};
    int i_1 = {};
    metal::float2 param_4 = {};
    v = 0.0;
    a = 0.5;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e88 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e88) + as_type<uint>(1));
        }
        loop_init = false;
        int _e74 = i_1;
        if (_e74 < 4) {
            float _e76 = a;
            metal::float2 _e77 = p_3;
            param_4 = _e77;
            float _e78 = vnoise(param_4);
            float _e80 = v;
            v = _e80 + (_e76 * _e78);
            metal::float2 _e82 = p_3;
            p_3 = (metal::float2x2(metal::float2(1.6, 1.2), metal::float2(-1.2, 1.6)) * _e82) + metal::float2(7.3);
            float _e86 = a;
            a = _e86 * 0.5;
            continue;
        } else {
            break;
        }
    }
    float _e90 = v;
    return _e90 / 0.9375;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_4 = {};
    metal::float2 q = {};
    metal::float2 o = {};
    metal::float2 sq = {};
    metal::float2 w1_ = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 w2_ = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float swirl = {};
    metal::float2 param_9 = {};
    metal::float2 flow = {};
    float amp = {};
    float n = {};
    float rimW = {};
    float feather = {};
    float margin = {};
    float f_1 = {};
    float fs = {};
    int i_2 = {};
    float fi = {};
    metal::float2 hs = {};
    metal::float2 c = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    float start = {};
    float s = {};
    metal::float2 m = {};
    float far = {};
    float s3_ = {};
    float r = {};
    float reach = {};
    float g = {};
    float aa = {};
    float inside = {};
    float wisp = {};
    metal::float2 param_12 = {};
    float soft = {};
    float haze = {};
    float cover = {};
    float edge = {};
    metal::float4 to = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    float _e117 = uniforms.progress;
    p_4 = _e117;
    float _e119 = uv_2[0u];
    float _e121 = uniforms.ratio;
    float _e124 = uv_2[1u];
    q = metal::float2(_e119 * _e121, _e124);
    float _e127 = uniforms.seed;
    float _e130 = uniforms.seed;
    o = metal::float2(_e127 * 3.1, _e130 * 1.7);
    metal::float2 _e133 = q;
    metal::float2 _e135 = o;
    sq = (_e133 * 2.2) + _e135;
    metal::float2 _e137 = sq;
    float _e138 = p_4;
    param_5 = _e137 + metal::float2(0.0, 0.6 * _e138);
    float _e142 = fbm(param_5);
    metal::float2 _e143 = sq;
    float _e145 = p_4;
    param_6 = (_e143 + metal::float2(5.2, 1.3)) - metal::float2(0.5 * _e145, 0.0);
    float _e149 = fbm(param_6);
    w1_ = metal::float2(_e142, _e149);
    metal::float2 _e151 = sq;
    metal::float2 _e152 = w1_;
    param_7 = (_e151 + (_e152 * 3.0)) + metal::float2(1.7, 9.2);
    float _e156 = fbm(param_7);
    metal::float2 _e157 = sq;
    metal::float2 _e158 = w1_;
    param_8 = (_e157 + (_e158 * 3.0)) + metal::float2(8.3, 2.8);
    float _e162 = fbm(param_8);
    w2_ = metal::float2(_e156, _e162);
    metal::float2 _e164 = sq;
    metal::float2 _e166 = w2_;
    param_9 = (_e164 * 0.8) + (_e166 * 2.5);
    float _e169 = fbm(param_9);
    swirl = _e169 - 0.5;
    metal::float2 _e171 = w2_;
    flow = _e171 - metal::float2(0.5);
    float _e175 = uniforms.tendrils;
    amp = 0.05 + (0.35 * _e175);
    float _e179 = uniforms.drops;
    n = metal::clamp(metal::floor(_e179 + 0.5), 1.0, 8.0);
    rimW = 0.1;
    feather = 0.05;
    float _e183 = amp;
    float _e185 = rimW;
    margin = ((1.2 * _e183) + _e185) + 0.08;
    f_1 = -1000.0;
    fs = -1000.0;
    i_2 = 0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e290 = i_2;
            i_2 = as_type<int>(as_type<uint>(_e290) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e188 = i_2;
        if (_e188 < 8) {
            int _e190 = i_2;
            fi = static_cast<float>(_e190);
            float _e192 = fi;
            float _e193 = n;
            if (_e192 < _e193) {
                float _e195 = fi;
                float _e198 = uniforms.seed;
                float _e200 = fi;
                float _e203 = uniforms.seed;
                hs = metal::float2((_e195 * 7.13) + _e198, (_e200 * 3.71) - _e203);
                metal::float2 _e206 = hs;
                param_10 = _e206;
                float _e207 = hash(param_10);
                float _e210 = uniforms.ratio;
                metal::float2 _e212 = hs;
                param_11 = _e212 + metal::float2(19.7);
                float _e215 = hash(param_11);
                c = metal::float2(metal::mix(0.15, 0.85, _e207) * _e210, metal::mix(0.15, 0.85, _e215));
                float _e218 = fi;
                float _e220 = n;
                start = (0.2 * _e218) / _e220;
                float _e222 = p_4;
                float _e223 = start;
                float _e225 = start;
                s = metal::clamp((_e222 - _e223) / (1.0 - _e225), 0.0, 1.0);
                metal::float2 _e229 = c;
                float _e231 = uniforms.ratio;
                metal::float2 _e233 = c;
                m = metal::max(_e229, metal::float2(_e231, 1.0) - _e233);
                metal::float2 _e236 = m;
                float _e238 = margin;
                far = metal::length(_e236) + _e238;
                float _e240 = s;
                float _e241 = s;
                float _e243 = s;
                s3_ = (_e240 * _e241) * _e243;
                float _e245 = far;
                float _e247 = s;
                float _e249 = s3_;
                float _e251 = s3_;
                r = (((_e245 + 0.02) * _e247) * (0.35 + ((0.65 * _e249) * _e251))) - 0.02;
                float _e256 = amp;
                float _e257 = r;
                reach = _e256 * metal::min(1.0, metal::max(_e257, 0.0) * 5.0);
                float _e262 = r;
                metal::float2 _e263 = q;
                metal::float2 _e264 = c;
                float _e266 = reach;
                metal::float2 _e268 = flow;
                float _e273 = reach;
                float _e275 = swirl;
                g = (_e262 - metal::length((_e263 - _e264) + (_e268 * (1.3 * _e266)))) + ((_e273 * 0.9) * _e275);
                float _e278 = f_1;
                float _e279 = g;
                f_1 = metal::max(_e278, _e279);
                float _e281 = fs;
                float _e282 = g;
                float _e283 = s;
                fs = metal::max(_e281, _e282 - (0.15 * (1.0 - metal::min(1.0, _e283 * 12.0))));
            }
            continue;
        } else {
            break;
        }
    }
    aa = 0.003;
    float _e292 = aa;
    float _e294 = aa;
    float _e295 = f_1;
    inside = metal::smoothstep(-(_e292), _e294, _e295);
    metal::float2 _e297 = sq;
    metal::float2 _e299 = w2_;
    param_12 = (_e297 * 2.0) + (_e299 * 5.0);
    float _e302 = fbm(param_12);
    wisp = 1.0 - metal::smoothstep(0.0, 0.08, metal::abs(_e302 - 0.5));
    float _e307 = feather;
    float _e309 = fs;
    float _e311 = wisp;
    soft = metal::smoothstep(-(_e307), 0.0, _e309) * (0.35 + (0.4 * _e311));
    float _e315 = wisp;
    float _e317 = fs;
    haze = (0.35 * _e315) * (1.0 - metal::smoothstep(0.0, 0.1, -(_e317)));
    float _e322 = inside;
    float _e323 = soft;
    float _e324 = haze;
    cover = metal::max(_e322, metal::max(_e323, _e324));
    float _e327 = rimW;
    float _e328 = f_1;
    edge = 1.0 - metal::smoothstep(0.0, _e327, _e328);
    metal::float2 _e331 = uv_2;
    float _e332 = edge;
    metal::float2 _e334 = flow;
    float _e337 = uniforms.ratio;
    param_13 = _e331 - ((_e334 * (0.015 * _e332)) / metal::float2(_e337, 1.0));
    metal::float2 _e341 = fold(param_13);
    param_14 = _e341;
    metal::float4 _e342 = getToColor(param_14, _sampler, _to);
    to = _e342;
    metal::float4 _e343 = to;
    metal::float4 _e345 = to;
    metal::float4 _e347 = to;
    float _e352 = uniforms.rim;
    float _e353 = edge;
    metal::float3 _e356 = metal::mix(_e343.xyz, (_e345.xyz * _e347.xyz) * 0.7, metal::float3(_e352 * _e353));
    to[0u] = _e356.x;
    to[1u] = _e356.y;
    to[2u] = _e356.z;
    metal::float2 _e363 = uv_2;
    param_15 = _e363;
    metal::float4 _e364 = getFromColor(param_15, _from, _sampler);
    metal::float4 _e365 = to;
    float _e366 = cover;
    return metal::mix(_e364, _e365, metal::float4(_e366));
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
    metal::float2 _e70 = _uv_1;
    param_16 = _e70;
    metal::float4 _e71 = transition(param_16, _from, _sampler, _to, uniforms);
    _fragColor = _e71;
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
