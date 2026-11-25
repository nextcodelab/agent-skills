// Puzzle — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Puzzle.glsl
// Author: gre
// License: MIT
// Description: The image is cut into jigsaw puzzle pieces that lift one after another and fall away, revealing the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float pieces;
    float shadow;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e64 = uv[0u];
    float _e66 = uv[1u];
    metal::float4 _e69 = _from.sample(_sampler, metal::float2(_e64, 1.0 - _e66), metal::level(0.0));
    return _e69;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e64 = uv_1[0u];
    float _e66 = uv_1[1u];
    metal::float4 _e69 = _to.sample(_sampler, metal::float2(_e64, 1.0 - _e66), metal::level(0.0));
    return _e69;
}

float hash(
    thread metal::float2& c
) {
    metal::float2 p = {};
    metal::float2 _e64 = c;
    p = metal::fract(_e64 * metal::float2(0.1031, 0.103));
    metal::float2 _e67 = p;
    metal::float2 _e68 = p;
    metal::float2 _e73 = p;
    p = _e73 + metal::float2(metal::dot(_e67, _e68.yx + metal::float2(33.33)));
    float _e77 = p[0u];
    float _e79 = p[1u];
    float _e82 = p[0u];
    return metal::fract((_e77 + _e79) * _e82);
}

float boxDist(
    thread metal::float2& p_1,
    thread metal::float2& halfSize
) {
    metal::float2 q = {};
    metal::float2 _e65 = p_1;
    metal::float2 _e67 = halfSize;
    q = metal::abs(_e65) - _e67;
    metal::float2 _e69 = q;
    float _e74 = q[0u];
    float _e76 = q[1u];
    return metal::length(metal::max(_e69, metal::float2(0.0))) + metal::min(metal::max(_e74, _e76), 0.0);
}

float pieceDist(
    thread metal::float2& p_2,
    thread metal::float2& c_1,
    thread metal::float2& grid,
    thread float& aspect
) {
    metal::float2 halfSize_1 = {};
    float d = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float tabs = {};
    int e = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    metal::float2 local_1 = {};
    metal::float2 key = {};
    metal::float2 next = {};
    float h = {};
    metal::float2 param_2 = {};
    bool tab = {};
    metal::float2 out1_ = {};
    metal::float2 along = {};
    metal::float2 edge = {};
    float k = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    bool phi_191_ = {};
    bool phi_199_ = {};
    bool phi_207_ = {};
    float _e86 = aspect;
    halfSize_1 = metal::float2(0.5 * _e86, 0.5);
    metal::float2 _e89 = p_2;
    param = _e89;
    metal::float2 _e90 = halfSize_1;
    param_1 = _e90;
    float _e91 = boxDist(param, param_1);
    d = _e91;
    tabs = 1000.0;
    e = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e202 = e;
            e = as_type<int>(as_type<uint>(_e202) + as_type<uint>(1));
        }
        loop_init = false;
        int _e92 = e;
        if (_e92 < 4) {
            int _e94 = e;
            if (_e94 == 0) {
                local = metal::float2(1.0, 0.0);
            } else {
                int _e96 = e;
                if (_e96 == 1) {
                    local_1 = metal::float2(-1.0, 0.0);
                } else {
                    int _e98 = e;
                    local_1 = metal::select(metal::float2(0.0, -1.0), metal::float2(0.0, 1.0), metal::bool2(_e98 == 2));
                }
                metal::float2 _e102 = local_1;
                local = _e102;
            }
            metal::float2 _e103 = local;
            dir = _e103;
            metal::float2 _e104 = c_1;
            metal::float2 _e105 = dir;
            key = _e104 + metal::min(_e105, metal::float2(0.0));
            metal::float2 _e109 = c_1;
            metal::float2 _e110 = dir;
            next = _e109 + _e110;
            float _e113 = next[0u];
            bool _e114 = _e113 >= 0.0;
            phi_191_ = _e114;
            if (_e114) {
                float _e116 = next[1u];
                phi_191_ = _e116 >= 0.0;
            }
            bool _e119 = phi_191_;
            phi_199_ = _e119;
            if (_e119) {
                float _e121 = next[0u];
                float _e123 = grid[0u];
                phi_199_ = _e121 < _e123;
            }
            bool _e126 = phi_199_;
            phi_207_ = _e126;
            if (_e126) {
                float _e128 = next[1u];
                float _e130 = grid[1u];
                phi_207_ = _e128 < _e130;
            }
            bool _e133 = phi_207_;
            if (_e133) {
                metal::float2 _e134 = key;
                int _e135 = e;
                param_2 = _e134 + metal::select(metal::float2(71.0, 37.0), metal::float2(0.0, 0.0), metal::bool2(_e135 < 2));
                float _e140 = hash(param_2);
                h = _e140;
                float _e141 = h;
                float _e144 = dir[0u];
                float _e146 = dir[1u];
                tab = (_e141 < 0.5) == ((_e144 + _e146) > 0.0);
                metal::float2 _e150 = dir;
                bool _e151 = tab;
                out1_ = _e150 * (_e151 ? 1.0 : -1.0);
                float _e155 = dir[1u];
                float _e158 = dir[0u];
                along = metal::float2(metal::abs(_e155), metal::abs(_e158));
                metal::float2 _e161 = dir;
                metal::float2 _e162 = halfSize_1;
                metal::float2 _e164 = along;
                float _e165 = h;
                edge = (_e161 * _e162) + ((_e164 * (metal::fract(_e165 * 2.0) - 0.5)) * 0.16);
                metal::float2 _e172 = p_2;
                metal::float2 _e173 = edge;
                metal::float2 _e175 = out1_;
                metal::float2 _e180 = p_2;
                metal::float2 _e181 = edge;
                metal::float2 _e183 = out1_;
                metal::float2 _e186 = dir;
                metal::float2 _e189 = along;
                param_3 = (_e180 - _e181) - (_e183 * 0.06);
                param_4 = (metal::abs(_e186) * 0.08) + (_e189 * 0.085);
                float _e192 = boxDist(param_3, param_4);
                k = metal::min(metal::length((_e172 - _e173) - (_e175 * 0.15)) - 0.125, _e192);
                bool _e194 = tab;
                if (_e194) {
                    float _e195 = tabs;
                    float _e196 = k;
                    tabs = metal::min(_e195, _e196);
                } else {
                    float _e198 = d;
                    float _e199 = k;
                    d = metal::max(_e198, -(_e199));
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e204 = d;
    float _e205 = tabs;
    return metal::min(_e204, _e205);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float rows = {};
    float local_2 = {};
    float cols = {};
    float local_3 = {};
    metal::float2 grid_1 = {};
    float aspect_1 = {};
    metal::float2 g = {};
    metal::float2 cell = {};
    float boardSum = {};
    float allSum = {};
    float prio1_ = {};
    float prio2_ = {};
    float cov1_ = {};
    float cov2_ = {};
    float shade1_ = {};
    float shade2_ = {};
    metal::float2 uv1_ = {};
    metal::float2 uv2_ = {};
    float shadowAll = {};
    float seam = {};
    int i = {};
    metal::float2 c_2 = {};
    metal::float2 center = {};
    metal::float2 local_4 = {};
    float h_1 = {};
    metal::float2 param_5 = {};
    float diag = {};
    float delay = {};
    float t = {};
    float d0_ = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float w = {};
    float lift = {};
    float fall = {};
    float s = {};
    float a = {};
    metal::float2 off = {};
    metal::float2x2 rot = {};
    metal::float2 pl = {};
    float dp = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    float cov = {};
    float shade = {};
    metal::float2 puv = {};
    metal::float2 sl = {};
    float sh = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    float param_17 = {};
    float prio = {};
    metal::float4 base = {};
    metal::float2 param_18 = {};
    metal::float2 param_19 = {};
    metal::float4 p2_ = {};
    metal::float2 param_20 = {};
    metal::float4 p1_ = {};
    metal::float2 param_21 = {};
    bool phi_413_ = {};
    bool phi_421_ = {};
    bool phi_429_ = {};
    float _e128 = uniforms.ratio;
    if (_e128 < 1.0) {
        float _e131 = uniforms.pieces;
        float _e133 = uniforms.ratio;
        local_2 = metal::floor((_e131 / _e133) + 0.5);
    } else {
        float _e138 = uniforms.pieces;
        local_2 = _e138;
    }
    float _e139 = local_2;
    rows = _e139;
    float _e141 = uniforms.ratio;
    if (_e141 < 1.0) {
        float _e144 = uniforms.pieces;
        local_3 = _e144;
    } else {
        float _e146 = uniforms.pieces;
        float _e148 = uniforms.ratio;
        local_3 = metal::floor((_e146 * _e148) + 0.5);
    }
    float _e152 = local_3;
    cols = _e152;
    float _e153 = cols;
    float _e154 = rows;
    grid_1 = metal::float2(_e153, _e154);
    float _e157 = uniforms.ratio;
    float _e158 = rows;
    float _e160 = cols;
    aspect_1 = (_e157 * _e158) / _e160;
    metal::float2 _e162 = uv_2;
    metal::float2 _e163 = grid_1;
    g = _e162 * _e163;
    metal::float2 _e165 = g;
    cell = metal::floor(_e165);
    boardSum = 0.0;
    allSum = 0.0;
    prio1_ = -1.0;
    prio2_ = -1.0;
    cov1_ = 0.0;
    cov2_ = 0.0;
    shade1_ = 1.0;
    shade2_ = 1.0;
    metal::float2 _e167 = uv_2;
    uv1_ = _e167;
    metal::float2 _e168 = uv_2;
    uv2_ = _e168;
    shadowAll = 0.0;
    seam = 1.0;
    i = 0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e416 = i;
            i = as_type<int>(as_type<uint>(_e416) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e169 = i;
        if (_e169 < 9) {
            metal::float2 _e171 = cell;
            int _e172 = i;
            float _e173 = static_cast<float>(_e172);
            int _e178 = i;
            c_2 = (_e171 + metal::float2(_e173 - (metal::floor(_e173 / 3.0) * 3.0), metal::floor(static_cast<float>(_e178) / 3.0))) - metal::float2(1.0);
            float _e187 = c_2[0u];
            bool _e188 = _e187 < 0.0;
            phi_413_ = _e188;
            if (!(_e188)) {
                float _e191 = c_2[1u];
                phi_413_ = _e191 < 0.0;
            }
            bool _e194 = phi_413_;
            phi_421_ = _e194;
            if (!(_e194)) {
                float _e197 = c_2[0u];
                float _e198 = cols;
                phi_421_ = _e197 >= _e198;
            }
            bool _e201 = phi_421_;
            phi_429_ = _e201;
            if (!(_e201)) {
                float _e204 = c_2[1u];
                float _e205 = rows;
                phi_429_ = _e204 >= _e205;
            }
            bool _e208 = phi_429_;
            if (_e208) {
                continue;
            }
            metal::float2 _e209 = c_2;
            center = _e209 + metal::float2(0.5);
            metal::float2 _e212 = g;
            metal::float2 _e213 = center;
            float _e215 = aspect_1;
            local_4 = (_e212 - _e213) * metal::float2(_e215, 1.0);
            metal::float2 _e218 = c_2;
            param_5 = _e218 + metal::float2(13.0, 7.0);
            float _e220 = hash(param_5);
            h_1 = _e220;
            float _e222 = c_2[0u];
            float _e223 = cols;
            float _e227 = rows;
            float _e230 = c_2[1u];
            float _e232 = rows;
            diag = ((_e222 / metal::max(_e223 - 1.0, 1.0)) + (((_e227 - 1.0) - _e230) / metal::max(_e232 - 1.0, 1.0))) * 0.5;
            float _e238 = diag;
            float _e239 = h_1;
            float _e242 = diag;
            float _e244 = diag;
            delay = (_e238 + (((1.2 * (_e239 - 0.5)) * _e242) * (1.0 - _e244))) * 0.6;
            float _e250 = uniforms.progress;
            float _e251 = delay;
            t = metal::clamp((_e250 - _e251) / 0.4, 0.0, 1.0);
            metal::float2 _e255 = local_4;
            param_6 = _e255;
            metal::float2 _e256 = c_2;
            param_7 = _e256;
            metal::float2 _e257 = grid_1;
            param_8 = _e257;
            float _e258 = aspect_1;
            param_9 = _e258;
            float _e259 = pieceDist(param_6, param_7, param_8, param_9);
            d0_ = _e259;
            float _e260 = d0_;
            w = 1.0 - metal::smoothstep(-0.01, 0.01, _e260);
            float _e263 = w;
            float _e264 = allSum;
            allSum = _e264 + _e263;
            float _e266 = t;
            if (_e266 <= 0.0) {
                float _e268 = w;
                float _e269 = boardSum;
                boardSum = _e269 + _e268;
                float _e271 = seam;
                float _e272 = d0_;
                seam = metal::min(_e271, metal::abs(_e272));
                continue;
            }
            float _e275 = t;
            lift = metal::smoothstep(0.0, 0.25, _e275);
            float _e277 = t;
            fall = metal::clamp((_e277 - 0.2) / 0.8, 0.0, 1.0);
            float _e281 = fall;
            float _e282 = fall;
            fall = _e282 * _e281;
            float _e284 = fall;
            s = metal::max(1.0 - _e284, 0.001);
            float _e287 = h_1;
            float _e290 = fall;
            a = ((_e287 - 0.5) * 3.0) * _e290;
            float _e292 = fall;
            off = metal::float2(0.0, -1.2 * _e292);
            float _e295 = a;
            float _e297 = a;
            float _e300 = a;
            float _e302 = a;
            rot = metal::float2x2(metal::float2(metal::cos(_e295), -(metal::sin(_e297))), metal::float2(metal::sin(_e300), metal::cos(_e302)));
            metal::float2x2 _e307 = rot;
            metal::float2 _e308 = local_4;
            metal::float2 _e309 = off;
            float _e312 = s;
            pl = (_e307 * (_e308 - _e309)) / metal::float2(_e312);
            metal::float2 _e315 = pl;
            param_10 = _e315;
            metal::float2 _e316 = c_2;
            param_11 = _e316;
            metal::float2 _e317 = grid_1;
            param_12 = _e317;
            float _e318 = aspect_1;
            param_13 = _e318;
            float _e319 = pieceDist(param_10, param_11, param_12, param_13);
            dp = _e319;
            float _e320 = dp;
            float _e321 = s;
            float _e325 = s;
            cov = (1.0 - metal::smoothstep(-0.01, 0.01, _e320 * _e321)) * metal::min(_e325 * 20.0, 1.0);
            float _e329 = fall;
            float _e332 = lift;
            float _e334 = dp;
            shade = (1.0 - (0.5 * _e329)) * (1.0 - ((0.3 * _e332) * (1.0 - metal::smoothstep(0.0, 0.035, -(_e334)))));
            metal::float2 _e341 = center;
            metal::float2 _e342 = pl;
            float _e343 = aspect_1;
            metal::float2 _e347 = grid_1;
            puv = (_e341 + (_e342 / metal::float2(_e343, 1.0))) / _e347;
            metal::float2x2 _e349 = rot;
            metal::float2 _e350 = local_4;
            metal::float2 _e351 = off;
            float _e353 = lift;
            float _e357 = s;
            sl = (_e349 * ((_e350 - _e351) - (metal::float2(0.08, -0.1) * _e353))) / metal::float2(_e357);
            metal::float2 _e360 = sl;
            param_14 = _e360;
            metal::float2 _e361 = c_2;
            param_15 = _e361;
            metal::float2 _e362 = grid_1;
            param_16 = _e362;
            float _e363 = aspect_1;
            param_17 = _e363;
            float _e364 = pieceDist(param_14, param_15, param_16, param_17);
            float _e365 = s;
            float _e369 = lift;
            float _e371 = fall;
            float _e375 = uniforms.shadow;
            sh = (((1.0 - metal::smoothstep(-0.05, 0.12, _e364 * _e365)) * _e369) * (1.0 - _e371)) * _e375;
            float _e377 = shadowAll;
            float _e378 = sh;
            float _e379 = w;
            float _e380 = lift;
            float _e382 = t;
            float _e387 = uniforms.shadow;
            shadowAll = metal::max(_e377, metal::max(_e378, ((_e379 * _e380) * (1.0 - metal::smoothstep(0.2, 0.5, _e382))) * _e387));
            float _e391 = delay;
            prio = _e391;
            float _e392 = cov;
            float _e394 = prio;
            float _e395 = prio1_;
            if ((_e392 > 0.0) && (_e394 > _e395)) {
                float _e398 = prio1_;
                prio2_ = _e398;
                float _e399 = cov1_;
                cov2_ = _e399;
                metal::float2 _e400 = uv1_;
                uv2_ = _e400;
                float _e401 = shade1_;
                shade2_ = _e401;
                float _e402 = prio;
                prio1_ = _e402;
                float _e403 = cov;
                cov1_ = _e403;
                metal::float2 _e404 = puv;
                uv1_ = _e404;
                float _e405 = shade;
                shade1_ = _e405;
            } else {
                float _e406 = cov;
                float _e408 = prio;
                float _e409 = prio2_;
                if ((_e406 > 0.0) && (_e408 > _e409)) {
                    float _e412 = prio;
                    prio2_ = _e412;
                    float _e413 = cov;
                    cov2_ = _e413;
                    metal::float2 _e414 = puv;
                    uv2_ = _e414;
                    float _e415 = shade;
                    shade2_ = _e415;
                }
            }
            continue;
        } else {
            break;
        }
    }
    metal::float2 _e418 = uv_2;
    param_18 = _e418;
    metal::float4 _e419 = getToColor(param_18, _sampler, _to);
    metal::float2 _e420 = uv_2;
    param_19 = _e420;
    metal::float4 _e421 = getFromColor(param_19, _from, _sampler);
    float _e422 = boardSum;
    float _e423 = allSum;
    base = metal::mix(_e419, _e421, metal::float4(_e422 / metal::max(_e423, 0.001)));
    float _e428 = shadowAll;
    float _e431 = uniforms.progress;
    float _e434 = seam;
    metal::float4 _e440 = base;
    metal::float3 _e442 = _e440.xyz * ((1.0 - _e428) * (1.0 - ((0.4 * metal::smoothstep(0.0, 0.1, _e431)) * (1.0 - metal::smoothstep(0.0, 0.015, _e434)))));
    base[0u] = _e442.x;
    base[1u] = _e442.y;
    base[2u] = _e442.z;
    metal::float2 _e449 = uv2_;
    param_20 = _e449;
    metal::float4 _e450 = getFromColor(param_20, _from, _sampler);
    p2_ = _e450;
    float _e451 = shade2_;
    metal::float4 _e452 = p2_;
    metal::float3 _e454 = _e452.xyz * _e451;
    p2_[0u] = _e454.x;
    p2_[1u] = _e454.y;
    p2_[2u] = _e454.z;
    metal::float2 _e461 = uv1_;
    param_21 = _e461;
    metal::float4 _e462 = getFromColor(param_21, _from, _sampler);
    p1_ = _e462;
    float _e463 = shade1_;
    metal::float4 _e464 = p1_;
    metal::float3 _e466 = _e464.xyz * _e463;
    p1_[0u] = _e466.x;
    p1_[1u] = _e466.y;
    p1_[2u] = _e466.z;
    metal::float4 _e473 = base;
    metal::float4 _e474 = p2_;
    float _e475 = cov2_;
    metal::float4 _e478 = p1_;
    float _e479 = cov1_;
    return metal::mix(metal::mix(_e473, _e474, metal::float4(_e475)), _e478, metal::float4(_e479));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_22 = {};
    metal::float2 _e63 = _uv_1;
    param_22 = _e63;
    metal::float4 _e64 = transition(param_22, _from, _sampler, _to, uniforms);
    _fragColor = _e64;
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
