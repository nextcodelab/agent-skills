// GridFlip — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GridFlip.glsl
// Author: TimDonselaar
// License: MIT
// Description: The image splits into a grid of cards that lift apart and turn over in perspective one after another, each one showing its part of the incoming image on its back
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 size;
    float pause;
    float dividerWidth;
    char _pad5[8];
    metal::float4 bgcolor;
    float randomness;
    char _pad7[12];
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e54 = uv[0u];
    float _e56 = uv[1u];
    metal::float4 _e59 = _to.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e54 = uv_1[0u];
    float _e56 = uv_1[1u];
    metal::float4 _e59 = _from.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

float aa(
    thread float& d,
    thread float& e
) {
    float _e54 = d;
    float _e55 = e;
    return metal::clamp((_e54 / metal::max(2.0 * _e55, 0.000001)) + 0.5, 0.0, 1.0);
}

float boxShadow(
    thread metal::float2& p,
    thread metal::float2& halfSize,
    thread float& blur
) {
    metal::float2 d_1 = {};
    float dist = {};
    metal::float2 _e57 = p;
    metal::float2 _e59 = halfSize;
    d_1 = metal::abs(_e57) - _e59;
    metal::float2 _e61 = d_1;
    float _e66 = d_1[0u];
    float _e68 = d_1[1u];
    dist = metal::length(metal::max(_e61, metal::float2(0.0))) + metal::min(metal::max(_e66, _e68), 0.0);
    float _e72 = blur;
    float _e74 = blur;
    float _e75 = dist;
    return 1.0 - metal::smoothstep(-(_e72), _e74, _e75);
}

float easeInOut(
    thread float& t
) {
    float _e53 = t;
    float _e54 = t;
    float _e55 = t;
    float _e57 = t;
    return metal::mix(_e53, (_e54 * _e55) * (3.0 - (2.0 * _e57)), 0.7);
}

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e54 = v;
    v3_ = metal::fract(_e54.xyx * 0.1031);
    metal::float3 _e58 = v3_;
    metal::float3 _e59 = v3_;
    metal::float3 _e64 = v3_;
    v3_ = _e64 + metal::float3(metal::dot(_e58, _e59.yzx + metal::float3(33.33)));
    float _e68 = v3_[0u];
    float _e70 = v3_[1u];
    float _e73 = v3_[2u];
    return metal::fract((_e68 + _e70) * _e73);
}

float flipTime(
    thread metal::float2& cell,
    thread metal::float2& grid,
    thread float& q,
    thread float& stagger,
    constant Uniforms& uniforms
) {
    float wave = {};
    float order = {};
    metal::float2 param = {};
    float param_1 = {};
    float _e61 = cell[0u];
    float _e63 = grid[1u];
    float _e66 = cell[1u];
    float _e70 = grid[0u];
    float _e72 = grid[1u];
    wave = (_e61 + ((_e63 - 1.0) - _e66)) / metal::max((_e70 + _e72) - 2.0, 1.0);
    float _e77 = wave;
    metal::float2 _e78 = cell;
    param = _e78 + metal::float2(7.31);
    float _e81 = hash12(param);
    float _e83 = uniforms.randomness;
    order = metal::mix(_e77, _e81, metal::clamp(_e83, 0.0, 1.0));
    float _e86 = q;
    float _e87 = order;
    float _e88 = stagger;
    float _e91 = stagger;
    param_1 = metal::clamp((_e86 - (_e87 * _e88)) / (1.0 - _e91), 0.0, 1.0);
    float _e95 = easeInOut(param_1);
    return _e95;
}

float pausePart_u0028_(
    constant Uniforms& uniforms
) {
    float _e53 = uniforms.pause;
    return metal::clamp(_e53, 0.05, 0.4);
}

float gapAmount_u0028_(
    constant Uniforms& uniforms
) {
    float pp = {};
    float _e53 = pausePart_u0028_(uniforms);
    pp = _e53;
    float _e54 = pp;
    float _e56 = uniforms.progress;
    float _e58 = pp;
    float _e61 = uniforms.progress;
    return metal::smoothstep(0.0, _e54, _e56) * (1.0 - metal::smoothstep(1.0 - _e58, 1.0, _e61));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 grid_1 = {};
    metal::float2 frame = {};
    metal::float2 tileSize = {};
    metal::float2 cell_1 = {};
    metal::float2 pos = {};
    float gapOpen = {};
    float minSide = {};
    float gap = {};
    metal::float2 halfTile = {};
    float eye = {};
    float pp_1 = {};
    float q_1 = {};
    float stagger_1 = {};
    metal::float4 c1_ = {};
    metal::float4 c2_ = {};
    float m1_ = {};
    float m2_ = {};
    float z1_ = {};
    float z2_ = {};
    bool rest1_ = {};
    bool rest2_ = {};
    float shadowBg = {};
    float shadowFlip = {};
    int j = {};
    int i = {};
    metal::float2 nc = {};
    float t_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float a = {};
    float ca = {};
    float sa = {};
    bool rest = {};
    metal::float2 center = {};
    metal::float2 q_2 = {};
    float lift = {};
    metal::float2 shOffset = {};
    metal::float2 shHalf = {};
    float sh = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float param_8 = {};
    float den = {};
    float s = {};
    metal::float3 hit = {};
    float u = {};
    float xa = {};
    float xb = {};
    float dx = {};
    float dy = {};
    float e_1 = {};
    float m = {};
    float param_9 = {};
    float param_10 = {};
    bool front = {};
    metal::float2 src = {};
    float local = {};
    metal::float4 col = {};
    metal::float4 local_1 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    float nx = {};
    float local_2 = {};
    float lit = {};
    metal::float4 color = {};
    bool phi_380_ = {};
    bool phi_390_ = {};
    bool phi_400_ = {};
    metal::int2 _e121 = uniforms.size;
    grid_1 = metal::max(static_cast<metal::float2>(_e121), metal::float2(1.0));
    float _e126 = uniforms.ratio;
    frame = metal::float2(_e126, 1.0);
    metal::float2 _e128 = frame;
    metal::float2 _e129 = grid_1;
    tileSize = _e128 / _e129;
    metal::float2 _e131 = uv_2;
    metal::float2 _e132 = grid_1;
    metal::float2 _e135 = grid_1;
    cell_1 = metal::clamp(metal::floor(_e131 * _e132), metal::float2(0.0, 0.0), _e135 - metal::float2(1.0));
    metal::float2 _e139 = uv_2;
    metal::float2 _e140 = frame;
    pos = _e139 * _e140;
    float _e142 = gapAmount_u0028_(uniforms);
    gapOpen = _e142;
    float _e144 = tileSize[0u];
    float _e146 = tileSize[1u];
    minSide = metal::min(_e144, _e146);
    float _e149 = uniforms.dividerWidth;
    float _e151 = minSide;
    float _e153 = gapOpen;
    gap = (metal::clamp(_e149, 0.0, 0.4) * _e151) * _e153;
    metal::float2 _e155 = tileSize;
    float _e157 = gap;
    halfTile = (_e155 * 0.5) - metal::float2(_e157);
    float _e161 = tileSize[0u];
    float _e163 = tileSize[1u];
    eye = 2.2 * metal::max(_e161, _e163);
    float _e166 = pausePart_u0028_(uniforms);
    pp_1 = 0.6 * _e166;
    float _e169 = uniforms.progress;
    float _e170 = pp_1;
    float _e172 = pp_1;
    q_1 = metal::clamp((_e169 - _e170) / (1.0 - (2.0 * _e172)), 0.0, 1.0);
    float _e178 = grid_1[0u];
    float _e180 = grid_1[1u];
    stagger_1 = ((_e178 * _e180) > 1.5) ? 0.55 : 0.0;
    c1_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    c2_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    m1_ = 0.0;
    m2_ = 0.0;
    z1_ = 1000000000.0;
    z2_ = 1000000000.0;
    rest1_ = true;
    rest2_ = true;
    shadowBg = 0.0;
    shadowFlip = 0.0;
    j = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e489 = j;
            j = as_type<int>(as_type<uint>(_e489) + as_type<uint>(1));
        }
        loop_init = false;
        int _e184 = j;
        if (_e184 <= 1) {
            i = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e487 = i;
                    i = as_type<int>(as_type<uint>(_e487) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e186 = i;
                if (_e186 <= 1) {
                    metal::float2 _e188 = cell_1;
                    int _e189 = i;
                    int _e191 = j;
                    nc = _e188 + metal::float2(static_cast<float>(_e189), static_cast<float>(_e191));
                    float _e196 = nc[0u];
                    bool _e197 = _e196 < 0.0;
                    phi_380_ = _e197;
                    if (!(_e197)) {
                        float _e200 = nc[1u];
                        phi_380_ = _e200 < 0.0;
                    }
                    bool _e203 = phi_380_;
                    phi_390_ = _e203;
                    if (!(_e203)) {
                        float _e206 = nc[0u];
                        float _e208 = grid_1[0u];
                        phi_390_ = _e206 > (_e208 - 1.0);
                    }
                    bool _e212 = phi_390_;
                    phi_400_ = _e212;
                    if (!(_e212)) {
                        float _e215 = nc[1u];
                        float _e217 = grid_1[1u];
                        phi_400_ = _e215 > (_e217 - 1.0);
                    }
                    bool _e221 = phi_400_;
                    if (_e221) {
                        continue;
                    }
                    metal::float2 _e222 = nc;
                    param_2 = _e222;
                    metal::float2 _e223 = grid_1;
                    param_3 = _e223;
                    float _e224 = q_1;
                    param_4 = _e224;
                    float _e225 = stagger_1;
                    param_5 = _e225;
                    float _e226 = flipTime(param_2, param_3, param_4, param_5, uniforms);
                    t_1 = _e226;
                    float _e227 = t_1;
                    a = 3.1415927 * _e227;
                    float _e229 = a;
                    ca = metal::cos(_e229);
                    float _e231 = a;
                    sa = metal::sin(_e231);
                    float _e233 = t_1;
                    float _e235 = t_1;
                    rest = (_e233 <= 0.0) || (_e235 >= 1.0);
                    bool _e238 = rest;
                    if (_e238) {
                        float _e239 = t_1;
                        ca = (_e239 <= 0.0) ? 1.0 : -1.0;
                        sa = 0.0;
                    }
                    metal::float2 _e242 = nc;
                    metal::float2 _e245 = tileSize;
                    center = (_e242 + metal::float2(0.5)) * _e245;
                    metal::float2 _e247 = pos;
                    metal::float2 _e248 = center;
                    q_2 = _e247 - _e248;
                    float _e250 = gapOpen;
                    float _e252 = minSide;
                    float _e255 = halfTile[0u];
                    float _e257 = sa;
                    lift = ((0.05 * _e250) * _e252) + ((0.35 * _e255) * _e257);
                    float _e260 = lift;
                    shOffset = metal::float2(0.45, -0.3) * _e260;
                    float _e263 = halfTile[0u];
                    float _e264 = ca;
                    float _e267 = lift;
                    float _e271 = halfTile[1u];
                    shHalf = metal::float2((_e263 * metal::abs(_e264)) + (0.5 * _e267), _e271);
                    metal::float2 _e273 = q_2;
                    metal::float2 _e274 = shOffset;
                    float _e276 = minSide;
                    float _e278 = lift;
                    param_6 = _e273 - _e274;
                    metal::float2 _e281 = shHalf;
                    param_7 = _e281;
                    param_8 = (0.01 * _e276) + (0.5 * _e278);
                    float _e282 = boxShadow(param_6, param_7, param_8);
                    sh = _e282;
                    float _e283 = shadowBg;
                    float _e285 = gapOpen;
                    float _e287 = sh;
                    shadowBg = 1.0 - ((1.0 - _e283) * (1.0 - ((0.45 * _e285) * _e287)));
                    float _e292 = shadowFlip;
                    float _e293 = sa;
                    float _e295 = sa;
                    float _e297 = sh;
                    shadowFlip = metal::max(_e292, ((0.45 * _e293) * _e295) * _e297);
                    float _e300 = eye;
                    float _e301 = ca;
                    float _e304 = q_2[0u];
                    float _e305 = sa;
                    den = (_e300 * _e301) - (_e304 * _e305);
                    float _e308 = den;
                    if (metal::abs(_e308) < 0.000001) {
                        continue;
                    }
                    float _e311 = eye;
                    float _e312 = ca;
                    float _e314 = den;
                    s = (_e311 * _e312) / _e314;
                    float _e316 = s;
                    if (_e316 <= 0.0) {
                        continue;
                    }
                    float _e318 = s;
                    float _e320 = q_2[0u];
                    float _e322 = s;
                    float _e324 = q_2[1u];
                    float _e326 = eye;
                    float _e327 = s;
                    hit = metal::float3(_e318 * _e320, _e322 * _e324, _e326 * (1.0 - _e327));
                    float _e332 = hit[0u];
                    float _e333 = ca;
                    float _e336 = hit[2u];
                    float _e337 = sa;
                    u = (_e332 * _e333) - (_e336 * _e337);
                    float _e341 = halfTile[0u];
                    float _e342 = ca;
                    float _e344 = eye;
                    float _e346 = eye;
                    float _e348 = halfTile[0u];
                    float _e349 = sa;
                    xa = ((_e341 * _e342) * _e344) / (_e346 + (_e348 * _e349));
                    float _e354 = halfTile[0u];
                    float _e356 = ca;
                    float _e358 = eye;
                    float _e360 = eye;
                    float _e362 = halfTile[0u];
                    float _e363 = sa;
                    xb = ((-(_e354) * _e356) * _e358) / (_e360 - (_e362 * _e363));
                    float _e368 = q_2[0u];
                    float _e369 = xa;
                    float _e370 = xb;
                    float _e373 = xa;
                    float _e374 = xb;
                    float _e377 = q_2[0u];
                    dx = metal::min(_e368 - metal::min(_e369, _e370), metal::max(_e373, _e374) - _e377);
                    float _e381 = halfTile[1u];
                    float _e383 = hit[1u];
                    float _e386 = s;
                    dy = (_e381 - metal::abs(_e383)) / _e386;
                    float _e388 = gap;
                    float _e390 = sa;
                    e_1 = metal::max(metal::min(0.0012, _e388), 0.0012 * metal::min(8.0 * _e390, 1.0));
                    float _e395 = dx;
                    float _e396 = dy;
                    param_9 = metal::min(_e395, _e396);
                    float _e398 = e_1;
                    param_10 = _e398;
                    float _e399 = aa(param_9, param_10);
                    m = _e399;
                    float _e400 = m;
                    if (_e400 <= 0.0) {
                        continue;
                    }
                    float _e402 = ca;
                    front = _e402 > 0.0;
                    metal::float2 _e404 = center;
                    bool _e405 = front;
                    if (_e405) {
                        float _e406 = u;
                        local = _e406;
                    } else {
                        float _e407 = u;
                        local = -(_e407);
                    }
                    float _e409 = local;
                    float _e411 = hit[1u];
                    metal::float2 _e414 = frame;
                    src = (_e404 + metal::float2(_e409, _e411)) / _e414;
                    bool _e416 = front;
                    if (_e416) {
                        metal::float2 _e417 = src;
                        param_11 = _e417;
                        metal::float4 _e418 = getFromColor(param_11, _from, _sampler);
                        local_1 = _e418;
                    } else {
                        metal::float2 _e419 = src;
                        param_12 = _e419;
                        metal::float4 _e420 = getToColor(param_12, _sampler, _to);
                        local_1 = _e420;
                    }
                    metal::float4 _e421 = local_1;
                    col = _e421;
                    bool _e422 = rest;
                    if (!(_e422)) {
                        bool _e424 = front;
                        if (_e424) {
                            float _e425 = sa;
                            local_2 = _e425;
                        } else {
                            float _e426 = sa;
                            local_2 = -(_e426);
                        }
                        float _e428 = local_2;
                        nx = _e428;
                        float _e429 = ca;
                        float _e431 = nx;
                        lit = metal::abs(_e429) + (_e431 * -0.45);
                        float _e434 = lit;
                        float _e437 = lit;
                        metal::float4 _e442 = col;
                        metal::float3 _e444 = _e442.xyz * (metal::mix(0.35, 1.0, metal::clamp(_e434, 0.0, 1.0)) + (0.25 * metal::max(_e437 - 1.0, 0.0)));
                        col[0u] = _e444.x;
                        col[1u] = _e444.y;
                        col[2u] = _e444.z;
                        float _e451 = sa;
                        float _e453 = dx;
                        float _e454 = dy;
                        metal::float4 _e459 = col;
                        metal::float3 _e462 = _e459.xyz + metal::float3((0.12 * _e451) * (1.0 - metal::smoothstep(0.0, 0.0036, metal::min(_e453, _e454))));
                        col[0u] = _e462.x;
                        col[1u] = _e462.y;
                        col[2u] = _e462.z;
                    }
                    float _e469 = s;
                    float _e470 = z1_;
                    if (_e469 < _e470) {
                        metal::float4 _e472 = c1_;
                        c2_ = _e472;
                        float _e473 = m1_;
                        m2_ = _e473;
                        float _e474 = z1_;
                        z2_ = _e474;
                        bool _e475 = rest1_;
                        rest2_ = _e475;
                        metal::float4 _e476 = col;
                        c1_ = _e476;
                        float _e477 = m;
                        m1_ = _e477;
                        float _e478 = s;
                        z1_ = _e478;
                        bool _e479 = rest;
                        rest1_ = _e479;
                    } else {
                        float _e480 = s;
                        float _e481 = z2_;
                        if (_e480 < _e481) {
                            metal::float4 _e483 = col;
                            c2_ = _e483;
                            float _e484 = m;
                            m2_ = _e484;
                            float _e485 = s;
                            z2_ = _e485;
                            bool _e486 = rest;
                            rest2_ = _e486;
                        }
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
    metal::float4 _e492 = uniforms.bgcolor;
    color = _e492;
    float _e493 = shadowBg;
    float _e494 = shadowFlip;
    metal::float4 _e498 = color;
    metal::float3 _e500 = _e498.xyz * (1.0 - metal::clamp(metal::max(_e493, _e494), 0.0, 1.0));
    color[0u] = _e500.x;
    color[1u] = _e500.y;
    color[2u] = _e500.z;
    bool _e507 = rest2_;
    if (_e507) {
        float _e508 = shadowFlip;
        metal::float4 _e510 = c2_;
        metal::float3 _e512 = _e510.xyz * (1.0 - _e508);
        c2_[0u] = _e512.x;
        c2_[1u] = _e512.y;
        c2_[2u] = _e512.z;
    }
    bool _e519 = rest1_;
    if (_e519) {
        float _e520 = shadowFlip;
        metal::float4 _e522 = c1_;
        metal::float3 _e524 = _e522.xyz * (1.0 - _e520);
        c1_[0u] = _e524.x;
        c1_[1u] = _e524.y;
        c1_[2u] = _e524.z;
    }
    metal::float4 _e531 = color;
    metal::float4 _e532 = c2_;
    float _e533 = m2_;
    color = metal::mix(_e531, _e532, metal::float4(_e533));
    metal::float4 _e536 = color;
    metal::float4 _e537 = c1_;
    float _e538 = m1_;
    color = metal::mix(_e536, _e537, metal::float4(_e538));
    metal::float4 _e541 = color;
    return _e541;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_13 = {};
    metal::float2 _e53 = _uv_1;
    param_13 = _e53;
    metal::float4 _e54 = transition(param_13, _from, _sampler, _to, uniforms);
    _fragColor = _e54;
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
