// Vaporize — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Vaporize.glsl
// Author: gre
// License: MIT
// Description: The outgoing image goes up in smoke: from one side, the picture itself turns to vapour that rises over what is still intact, curls into wisps and pales as it thins out, revealing the incoming image underneath
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    float rise;
    float swirl;
    char _pad5[8];
    metal::float4 color;
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e62 = v;
    metal::float2 _e63 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e62 - (metal::floor(_e62 / _e63) * _e63)));
}

float hash12(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e63 = p;
    p3_ = metal::fract(_e63.xyx * 0.1031);
    metal::float3 _e67 = p3_;
    metal::float3 _e68 = p3_;
    metal::float3 _e73 = p3_;
    p3_ = _e73 + metal::float3(metal::dot(_e67, _e68.yzx + metal::float3(33.33)));
    float _e77 = p3_[0u];
    float _e79 = p3_[1u];
    float _e82 = p3_[2u];
    return metal::fract((_e77 + _e79) * _e82);
}

float vnoise(
    thread metal::float2& p_1
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e68 = p_1;
    i = metal::floor(_e68);
    metal::float2 _e70 = p_1;
    f = metal::fract(_e70);
    metal::float2 _e72 = f;
    metal::float2 _e73 = f;
    metal::float2 _e75 = f;
    f = (_e72 * _e73) * (metal::float2(3.0) - (_e75 * 2.0));
    metal::float2 _e80 = i;
    param = _e80;
    float _e81 = hash12(param);
    metal::float2 _e82 = i;
    param_1 = _e82 + metal::float2(1.0, 0.0);
    float _e84 = hash12(param_1);
    float _e86 = f[0u];
    metal::float2 _e88 = i;
    param_2 = _e88 + metal::float2(0.0, 1.0);
    float _e90 = hash12(param_2);
    metal::float2 _e91 = i;
    param_3 = _e91 + metal::float2(1.0, 1.0);
    float _e93 = hash12(param_3);
    float _e95 = f[0u];
    float _e98 = f[1u];
    return metal::mix(metal::mix(_e81, _e84, _e86), metal::mix(_e90, _e93, _e95), _e98);
}

metal::float2 curl(
    thread metal::float2& p_2
) {
    float e = {};
    float n = {};
    metal::float2 param_4 = {};
    float nx = {};
    metal::float2 param_5 = {};
    float ny = {};
    metal::float2 param_6 = {};
    e = 0.1;
    metal::float2 _e69 = p_2;
    param_4 = _e69;
    float _e70 = vnoise(param_4);
    n = _e70;
    metal::float2 _e71 = p_2;
    float _e72 = e;
    param_5 = _e71 + metal::float2(_e72, 0.0);
    float _e75 = vnoise(param_5);
    nx = _e75;
    metal::float2 _e76 = p_2;
    float _e77 = e;
    param_6 = _e76 + metal::float2(0.0, _e77);
    float _e80 = vnoise(param_6);
    ny = _e80;
    float _e81 = ny;
    float _e82 = n;
    float _e84 = n;
    float _e85 = nx;
    float _e88 = e;
    return metal::float2(_e81 - _e82, _e84 - _e85) / metal::float2(_e88);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e63 = uv[0u];
    float _e65 = uv[1u];
    metal::float4 _e68 = _to.sample(_sampler, metal::float2(_e63, 1.0 - _e65), metal::level(0.0));
    return _e68;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e63 = uv_1[0u];
    float _e65 = uv_1[1u];
    metal::float4 _e68 = _from.sample(_sampler, metal::float2(_e63, 1.0 - _e65), metal::level(0.0));
    return _e68;
}

float sweep(
    thread float& t
) {
    float _e62 = t;
    float _e63 = t;
    float _e65 = t;
    float _e68 = t;
    return _e62 + (((0.6 * _e63) * (1.0 - _e65)) * (1.0 - (2.0 * _e68)));
}

float fbm(
    thread metal::float2& p_3
) {
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 _e65 = p_3;
    param_7 = _e65;
    float _e66 = vnoise(param_7);
    metal::float2 _e68 = p_3;
    param_8 = (_e68 * 2.03) + metal::float2(5.1);
    float _e72 = vnoise(param_8);
    metal::float2 _e75 = p_3;
    param_9 = (_e75 * 4.1) + metal::float2(9.7);
    float _e79 = vnoise(param_9);
    return ((0.55 * _e66) + (0.3 * _e72)) + (0.15 * _e79);
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
    metal::float2 side = {};
    metal::float2 q = {};
    float along = {};
    float across = {};
    float ext = {};
    float ragged = {};
    metal::float2 param_10 = {};
    float start = {};
    float travel = {};
    float front = {};
    float param_11 = {};
    float gone = {};
    metal::float4 base = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float height = {};
    metal::float2 param_14 = {};
    float age = {};
    float released = {};
    float origin = {};
    float param_15 = {};
    metal::float2 org = {};
    metal::float2 sw = {};
    metal::float2 param_16 = {};
    metal::float2 src = {};
    metal::float2 spreadOut = {};
    metal::float4 c = {};
    int i_1 = {};
    float t_1 = {};
    metal::float4 img = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float4 local_1 = {};
    metal::float2 wq = {};
    float w = {};
    metal::float2 param_19 = {};
    float density = {};
    float pale = {};
    float l = {};
    float a = {};
    float outA = {};
    metal::float2 _e106 = uniforms.direction;
    if (metal::length(_e106) > 0.0) {
        metal::float2 _e110 = uniforms.direction;
        local = metal::normalize(_e110);
    } else {
        local = metal::float2(0.0, 1.0);
    }
    metal::float2 _e112 = local;
    dir = _e112;
    float _e114 = dir[1u];
    float _e117 = dir[0u];
    side = metal::float2(-(_e114), _e117);
    metal::float2 _e119 = uv_2;
    float _e123 = uniforms.ratio;
    q = (_e119 - metal::float2(0.5)) * metal::float2(_e123, 1.0);
    metal::float2 _e126 = q;
    metal::float2 _e127 = dir;
    along = metal::dot(_e126, _e127);
    metal::float2 _e129 = q;
    metal::float2 _e130 = side;
    across = metal::dot(_e129, _e130);
    float _e133 = dir[0u];
    float _e136 = uniforms.ratio;
    float _e139 = dir[1u];
    ext = 0.5 * ((metal::abs(_e133) * _e136) + metal::abs(_e139));
    metal::float2 _e143 = q;
    param_10 = (_e143 * 2.5) + metal::float2(1.3);
    float _e147 = fbm(param_10);
    ragged = 0.09 * ((2.0 * _e147) - 1.0);
    float _e151 = ext;
    start = -(_e151) - 0.09;
    float _e154 = ext;
    travel = ((2.0 * _e154) + 0.18) + 0.12;
    float _e158 = start;
    float _e159 = travel;
    float _e161 = uniforms.progress;
    param_11 = _e161;
    float _e162 = sweep(param_11);
    float _e165 = ragged;
    front = (_e158 + (_e159 * _e162)) + _e165;
    float _e167 = front;
    float _e168 = along;
    gone = metal::smoothstep(0.0, 0.12, _e167 - _e168);
    metal::float2 _e171 = uv_2;
    param_12 = _e171;
    metal::float4 _e172 = getFromColor(param_12, _from, _sampler);
    metal::float2 _e173 = uv_2;
    param_13 = _e173;
    metal::float4 _e174 = getToColor(param_13, _sampler, _to);
    float _e175 = gone;
    base = metal::mix(_e172, _e174, metal::float4(_e175));
    float _e179 = uniforms.rise;
    float _e181 = across;
    param_14 = metal::float2((_e181 * 3.0) + 2.7, 0.5);
    float _e185 = vnoise(param_14);
    height = metal::max(_e179, 0.05) * (0.7 + (0.6 * _e185));
    float _e189 = along;
    float _e190 = front;
    float _e192 = height;
    age = (_e189 - _e190) / _e192;
    float _e195 = uniforms.progress;
    float _e196 = age;
    released = _e195 - (_e196 * 0.16);
    float _e199 = age;
    float _e201 = age;
    float _e204 = released;
    if (((_e199 <= 0.0) || (_e201 >= 1.0)) || (_e204 <= 0.0)) {
        metal::float4 _e207 = base;
        return _e207;
    }
    float _e208 = start;
    float _e209 = travel;
    float _e210 = released;
    param_15 = _e210;
    float _e211 = sweep(param_15);
    float _e214 = ragged;
    origin = (_e208 + (_e209 * _e211)) + _e214;
    metal::float2 _e216 = q;
    metal::float2 _e217 = dir;
    float _e218 = along;
    float _e219 = origin;
    org = _e216 - (_e217 * (_e218 - _e219));
    metal::float2 _e223 = org;
    metal::float2 _e225 = dir;
    float _e227 = uniforms.progress;
    param_16 = (_e223 * 3.0) + ((_e225 * _e227) * 1.5);
    metal::float2 _e231 = curl(param_16);
    float _e233 = uniforms.swirl;
    float _e235 = age;
    sw = _e231 * ((_e233 * 0.08) * metal::sqrt(_e235));
    metal::float2 _e239 = org;
    metal::float2 _e240 = sw;
    src = _e239 - _e240;
    metal::float2 _e242 = side;
    metal::float2 _e244 = dir;
    float _e247 = age;
    spreadOut = ((_e242 * 0.07) + (_e244 * 0.02)) * metal::sqrt(_e247);
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e282 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e282) + as_type<uint>(1));
        }
        loop_init = false;
        int _e250 = i_1;
        if (_e250 < 6) {
            int _e252 = i_1;
            t_1 = (static_cast<float>(_e252) / 5.0) - 0.5;
            metal::float2 _e256 = src;
            metal::float2 _e257 = spreadOut;
            float _e258 = t_1;
            float _e262 = uniforms.ratio;
            param_17 = ((_e256 + (_e257 * _e258)) / metal::float2(_e262, 1.0)) + metal::float2(0.5);
            metal::float2 _e267 = mirror(param_17);
            param_18 = _e267;
            metal::float4 _e268 = getFromColor(param_18, _from, _sampler);
            img = _e268;
            metal::float4 _e269 = img;
            float _e272 = img[3u];
            metal::float3 _e273 = _e269.xyz * _e272;
            float _e275 = img[3u];
            metal::float4 _e280 = c;
            c = _e280 + metal::float4(_e273.x, _e273.y, _e273.z, _e275);
            continue;
        } else {
            break;
        }
    }
    float _e285 = c[3u];
    if (_e285 > 0.0) {
        metal::float4 _e287 = c;
        float _e290 = c[3u];
        metal::float3 _e292 = _e287.xyz / metal::float3(_e290);
        float _e294 = c[3u];
        local_1 = metal::float4(_e292.x, _e292.y, _e292.z, _e294 / 6.0);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e300 = local_1;
    c = _e300;
    metal::float2 _e301 = q;
    metal::float2 _e302 = sw;
    metal::float2 _e305 = dir;
    float _e307 = uniforms.progress;
    wq = ((_e301 - (_e302 * 0.6)) - (_e305 * (_e307 * 2.5))) * 4.0;
    metal::float2 _e312 = wq;
    metal::float2 _e313 = side;
    metal::float2 _e315 = wq;
    metal::float2 _e316 = dir;
    param_19 = metal::float2(metal::dot(_e312, _e313), metal::dot(_e315, _e316) * 0.6) + metal::float2(2.0);
    float _e322 = fbm(param_19);
    w = _e322;
    float _e323 = age;
    float _e326 = age;
    float _e329 = w;
    density = metal::smoothstep((1.2 * _e323) - 0.2, (1.2 * _e326) + 0.1, _e329);
    float _e331 = age;
    float _e334 = density;
    density = _e334 * (1.0 - metal::smoothstep(0.3, 1.0, _e331));
    float _e336 = ext;
    float _e338 = ext;
    float _e341 = origin;
    float _e343 = density;
    density = _e343 * metal::smoothstep(-(_e336), -(_e338) + 0.05, _e341);
    float _e345 = age;
    pale = metal::smoothstep(0.0, 0.5, _e345);
    metal::float4 _e347 = c;
    l = metal::dot(_e347.xyz, metal::float3(0.299, 0.587, 0.114));
    metal::float4 _e350 = c;
    float _e351 = l;
    metal::float4 _e354 = uniforms.color;
    metal::float3 _e357 = metal::mix(metal::float3(_e351), _e354.xyz, metal::float3(0.7));
    float _e359 = c[3u];
    float _e362 = uniforms.color[3u];
    float _e368 = pale;
    c = metal::mix(_e350, metal::float4(_e357.x, _e357.y, _e357.z, _e359 * _e362), metal::float4(_e368 * 0.85));
    metal::float4 _e372 = c;
    float _e374 = pale;
    float _e376 = density;
    float _e378 = density;
    metal::float3 _e383 = metal::min(_e372.xyz + metal::float3(((0.12 * _e374) * _e376) * (1.0 - _e378)), metal::float3(1.0, 1.0, 1.0));
    c[0u] = _e383.x;
    c[1u] = _e383.y;
    c[2u] = _e383.z;
    float _e390 = density;
    float _e392 = c[3u];
    a = _e390 * _e392;
    float _e394 = a;
    float _e396 = base[3u];
    float _e397 = a;
    outA = _e394 + (_e396 * (1.0 - _e397));
    float _e401 = outA;
    if (_e401 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e403 = c;
    float _e405 = a;
    metal::float4 _e407 = base;
    float _e410 = base[3u];
    float _e412 = a;
    float _e416 = outA;
    metal::float3 _e418 = ((_e403.xyz * _e405) + ((_e407.xyz * _e410) * (1.0 - _e412))) / metal::float3(_e416);
    float _e419 = outA;
    return metal::float4(_e418.x, _e418.y, _e418.z, _e419);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_20 = {};
    metal::float2 _e62 = _uv_1;
    param_20 = _e62;
    metal::float4 _e63 = transition(param_20, _from, _sampler, _to, uniforms);
    _fragColor = _e63;
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
