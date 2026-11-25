// GooeyWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GooeyWipe.glsl
// Author: gre
// License: MIT
// Description: Soft, glossy blobs of liquid pop up over the outgoing image, swell and melt into each other, revealing the incoming image until they cover the whole frame
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float blobs;
    float smoothness;
    metal::float4 highlight;
    metal::float4 shadow;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e58 = uv[0u];
    float _e60 = uv[1u];
    metal::float4 _e63 = _from.sample(_sampler, metal::float2(_e58, 1.0 - _e60), metal::level(0.0));
    return _e63;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e58 = uv_1[0u];
    float _e60 = uv_1[1u];
    metal::float4 _e63 = _to.sample(_sampler, metal::float2(_e58, 1.0 - _e60), metal::level(0.0));
    return _e63;
}

metal::float2 fold(
    thread metal::float2& p
) {
    metal::float2 _e57 = p;
    metal::float2 _e58 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e57 - (metal::floor(_e57 / _e58) * _e58)));
}

float hash(
    thread metal::float2& p_1
) {
    metal::float3 p3_ = {};
    metal::float2 _e58 = p_1;
    p3_ = metal::fract(_e58.xyx * 0.1031);
    metal::float3 _e62 = p3_;
    metal::float3 _e63 = p3_;
    metal::float3 _e68 = p3_;
    p3_ = _e68 + metal::float3(metal::dot(_e62, _e63.yzx + metal::float3(33.33)));
    float _e72 = p3_[0u];
    float _e74 = p3_[1u];
    float _e77 = p3_[2u];
    return metal::fract((_e72 + _e74) * _e77);
}

metal::float3 blob(
    thread metal::float2& cell,
    thread float& rStart,
    thread float& rEnd,
    constant Uniforms& uniforms
) {
    metal::float2 c = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float t0_ = {};
    metal::float2 param_2 = {};
    float s = {};
    float pop = {};
    float r = {};
    metal::float2 _e67 = cell;
    metal::float2 _e70 = cell;
    param = _e70 + metal::float2(0.5);
    float _e73 = hash(param);
    metal::float2 _e74 = cell;
    param_1 = _e74 + metal::float2(41.3);
    float _e77 = hash(param_1);
    c = (_e67 + metal::float2(0.5)) + ((metal::float2(_e73, _e77) - metal::float2(0.5)) * 0.7);
    metal::float2 _e83 = cell;
    param_2 = _e83 + metal::float2(17.9);
    float _e86 = hash(param_2);
    t0_ = 0.02 + (0.43 * _e86);
    float _e90 = uniforms.progress;
    float _e91 = t0_;
    float _e93 = t0_;
    s = metal::clamp((_e90 - _e91) / (1.0 - _e93), 0.0, 1.0);
    float _e98 = uniforms.progress;
    float _e99 = t0_;
    pop = metal::clamp((_e98 - _e99) / 0.12, 0.0, 1.0);
    float _e103 = pop;
    float _e105 = pop;
    float _e108 = pop;
    pop = 1.0 - (((1.0 - _e103) * (1.0 - _e105)) * (1.0 - _e108));
    float _e112 = rStart;
    float _e113 = pop;
    float _e115 = rEnd;
    float _e117 = s;
    float _e119 = s;
    r = metal::mix(_e112, 0.18, _e113) + (((_e115 - 0.18) * _e117) * metal::sqrt(_e119));
    float _e123 = pop;
    float _e127 = s;
    float _e130 = pop;
    float _e132 = r;
    r = _e132 + (((0.05 * metal::sin(_e123 * 9.0)) * (1.0 - _e127)) * _e130);
    float _e134 = r;
    metal::float2 _e135 = c;
    return metal::float3(_e134, _e135.x, _e135.y);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n = {};
    float cellSize = {};
    metal::float2 q = {};
    metal::float2 base = {};
    float k = {};
    float w = {};
    float rStart_1 = {};
    float rEnd_1 = {};
    float m = {};
    float sum = {};
    metal::float2 grad = {};
    float rNear = {};
    int j = {};
    int i = {};
    metal::float3 b = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float param_5 = {};
    metal::float2 dq = {};
    float l = {};
    float dist = {};
    metal::float2 g = {};
    float scale = {};
    float wt = {};
    float d = {};
    float aa = {};
    float inside = {};
    float h = {};
    float settle = {};
    float tilt = {};
    metal::float3 nrm = {};
    metal::float3 halfway = {};
    float spec = {};
    float shade = {};
    metal::float4 to = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float t2_ = {};
    float gloss = {};
    metal::float4 from = {};
    metal::float2 param_8 = {};
    float sh = {};
    float _e100 = uniforms.blobs;
    n = metal::max(1.0, metal::floor(_e100 + 0.5));
    float _e105 = uniforms.ratio;
    float _e107 = n;
    cellSize = metal::max(_e105, 1.0) / _e107;
    float _e110 = uv_2[0u];
    float _e112 = uniforms.ratio;
    float _e115 = uv_2[1u];
    float _e117 = cellSize;
    q = metal::float2(_e110 * _e112, _e115) / metal::float2(_e117);
    metal::float2 _e120 = q;
    base = metal::floor(_e120);
    float _e123 = uniforms.smoothness;
    k = 0.02 + (0.25 * _e123);
    w = 0.16;
    float _e126 = k;
    rStart_1 = -((0.03 + (4.0 * _e126)));
    float _e130 = w;
    rEnd_1 = (1.2020816 + _e130) + 0.05;
    m = 1000.0;
    sum = 0.0;
    grad = metal::float2(0.0, 0.0);
    rNear = 0.0;
    j = -3;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e199 = j;
            j = as_type<int>(as_type<uint>(_e199) + as_type<uint>(1));
        }
        loop_init = false;
        int _e133 = j;
        if (_e133 <= 3) {
            i = -3;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e197 = i;
                    i = as_type<int>(as_type<uint>(_e197) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e135 = i;
                if (_e135 <= 3) {
                    metal::float2 _e137 = base;
                    int _e138 = i;
                    int _e140 = j;
                    param_3 = _e137 + metal::float2(static_cast<float>(_e138), static_cast<float>(_e140));
                    float _e144 = rStart_1;
                    param_4 = _e144;
                    float _e145 = rEnd_1;
                    param_5 = _e145;
                    metal::float3 _e146 = blob(param_3, param_4, param_5, uniforms);
                    b = _e146;
                    metal::float2 _e147 = q;
                    metal::float3 _e148 = b;
                    dq = _e147 - _e148.yz;
                    metal::float2 _e151 = dq;
                    l = metal::length(_e151);
                    float _e153 = l;
                    float _e155 = b[0u];
                    dist = _e153 - _e155;
                    metal::float2 _e157 = dq;
                    float _e158 = l;
                    g = _e157 / metal::float2(metal::max(_e158, 0.0001));
                    float _e162 = dist;
                    float _e163 = m;
                    if (_e162 < _e163) {
                        float _e165 = dist;
                        float _e166 = m;
                        float _e168 = k;
                        scale = metal::exp((_e165 - _e166) / _e168);
                        float _e171 = sum;
                        float _e172 = scale;
                        sum = (_e171 * _e172) + 1.0;
                        metal::float2 _e175 = grad;
                        float _e176 = scale;
                        metal::float2 _e178 = g;
                        grad = (_e175 * _e176) + _e178;
                        float _e180 = dist;
                        m = _e180;
                        float _e182 = b[0u];
                        rNear = _e182;
                    } else {
                        float _e183 = m;
                        float _e184 = dist;
                        float _e186 = k;
                        wt = metal::exp((_e183 - _e184) / _e186);
                        float _e189 = wt;
                        float _e190 = sum;
                        sum = _e190 + _e189;
                        float _e192 = wt;
                        metal::float2 _e193 = g;
                        metal::float2 _e195 = grad;
                        grad = _e195 + (_e193 * _e192);
                    }
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e201 = m;
    float _e202 = k;
    float _e203 = sum;
    d = _e201 - (_e202 * metal::log(_e203));
    float _e207 = sum;
    metal::float2 _e208 = grad;
    grad = _e208 / metal::float2(_e207);
    float _e211 = n;
    aa = (0.012 * _e211) / 5.0;
    float _e214 = aa;
    float _e216 = aa;
    float _e217 = d;
    inside = 1.0 - metal::smoothstep(-(_e214), _e216, _e217);
    float _e220 = d;
    float _e222 = w;
    h = metal::clamp(-(_e220) / _e222, 0.0, 1.0);
    float _e226 = uniforms.progress;
    settle = 1.0 - metal::smoothstep(0.45, 0.85, _e226);
    float _e229 = h;
    float _e231 = h;
    float _e234 = settle;
    tilt = ((1.0 - _e229) * (1.0 - _e231)) * _e234;
    metal::float2 _e236 = grad;
    float _e237 = tilt;
    metal::float2 _e239 = (_e236 * _e237) * 3.0;
    nrm = metal::normalize(metal::float3(_e239.x, _e239.y, 1.0));
    halfway = metal::float3(-0.16829646, 0.21638116, 0.96169406);
    metal::float3 _e244 = nrm;
    metal::float3 _e245 = halfway;
    float _e249 = settle;
    spec = metal::pow(metal::max(metal::dot(_e244, _e245), 0.0), 200.0) * _e249;
    float _e251 = tilt;
    metal::float2 _e252 = grad;
    shade = 1.0 - (_e251 * (0.25 + (0.3 * metal::clamp(metal::dot(_e252, metal::float2(0.6, -0.8)) + 0.3, 0.0, 1.0))));
    metal::float2 _e260 = uv_2;
    metal::float2 _e261 = grad;
    float _e262 = tilt;
    float _e265 = cellSize;
    float _e268 = uniforms.ratio;
    param_6 = _e260 - ((((_e261 * _e262) * 0.01) * _e265) / metal::float2(_e268, 1.0));
    metal::float2 _e272 = fold(param_6);
    param_7 = _e272;
    metal::float4 _e273 = getToColor(param_7, _sampler, _to);
    to = _e273;
    float _e274 = tilt;
    float _e275 = tilt;
    t2_ = _e274 * _e275;
    float _e277 = t2_;
    float _e279 = t2_;
    gloss = (0.3 * _e277) * _e279;
    metal::float4 _e281 = to;
    float _e283 = shade;
    metal::float4 _e286 = uniforms.highlight;
    float _e288 = spec;
    float _e289 = gloss;
    float _e294 = uniforms.highlight[3u];
    metal::float3 _e297 = metal::mix(_e281.xyz * _e283, _e286.xyz, metal::float3(metal::clamp(_e288 + _e289, 0.0, 1.0) * _e294));
    to[0u] = _e297.x;
    to[1u] = _e297.y;
    to[2u] = _e297.z;
    metal::float2 _e304 = uv_2;
    param_8 = _e304;
    metal::float4 _e305 = getFromColor(param_8, _from, _sampler);
    from = _e305;
    float _e308 = uniforms.shadow[3u];
    float _e309 = d;
    float _e314 = rNear;
    sh = (_e308 * (1.0 - metal::smoothstep(0.0, 0.15, _e309 + 0.03))) * metal::smoothstep(0.0, 0.3, _e314);
    metal::float4 _e317 = from;
    metal::float4 _e320 = uniforms.shadow;
    float _e322 = sh;
    metal::float3 _e324 = metal::mix(_e317.xyz, _e320.xyz, metal::float3(_e322));
    from[0u] = _e324.x;
    from[1u] = _e324.y;
    from[2u] = _e324.z;
    metal::float4 _e331 = from;
    metal::float4 _e332 = to;
    float _e333 = inside;
    return metal::mix(_e331, _e332, metal::float4(_e333));
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
    metal::float2 _e57 = _uv_1;
    param_9 = _e57;
    metal::float4 _e58 = transition(param_9, _from, _sampler, _to, uniforms);
    _fragColor = _e58;
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
