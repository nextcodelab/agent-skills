// SplitFlap — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SplitFlap.glsl
// Author: gre
// License: MIT
// Description: The frame becomes a split-flap board: in each cell the top half of the outgoing image flips down on a hinge across the middle, cell after cell, its back bringing the bottom half of the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 size;
    float stagger;
    float randomness;
    int flaps;
    float gap;
    float perspective;
    float shading;
    char _pad9[8];
    metal::float4 background;
};

float cardMask(
    thread float& x,
    thread float& f,
    thread metal::float2& cellSize,
    thread float& g,
    constant Uniforms& uniforms
) {
    float e = {};
    float d = {};
    float _e51 = g;
    if (_e51 <= 0.0) {
        return 1.0;
    }
    float _e53 = g;
    float _e55 = uniforms.gap;
    e = 0.001 * metal::min(1.0, _e53 / metal::max(_e55, 0.0001));
    float _e60 = x;
    float _e61 = x;
    float _e65 = cellSize[0u];
    float _e67 = f;
    float _e69 = f;
    float _e73 = cellSize[1u];
    d = metal::min(metal::min(_e60, 1.0 - _e61) * _e65, metal::min(2.0 * _e67, 0.5 - _e69) * _e73);
    float _e76 = g;
    float _e78 = e;
    float _e80 = g;
    float _e82 = e;
    float _e84 = d;
    return metal::smoothstep((0.5 * _e76) - _e78, (0.5 * _e80) + _e82, _e84);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e47 = uv[0u];
    float _e49 = uv[1u];
    metal::float4 _e52 = _to.sample(_sampler, metal::float2(_e47, 1.0 - _e49), metal::level(0.0));
    return _e52;
}

float hash12(
    thread metal::float2& v
) {
    metal::float3 v3_ = {};
    metal::float2 _e47 = v;
    v3_ = metal::fract(_e47.xyx * 0.1031);
    metal::float3 _e51 = v3_;
    metal::float3 _e52 = v3_;
    metal::float3 _e57 = v3_;
    v3_ = _e57 + metal::float3(metal::dot(_e51, _e52.yzx + metal::float3(33.33)));
    float _e61 = v3_[0u];
    float _e63 = v3_[1u];
    float _e66 = v3_[2u];
    return metal::fract((_e61 + _e63) * _e66);
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e47 = uv_1[0u];
    float _e49 = uv_1[1u];
    metal::float4 _e52 = _from.sample(_sampler, metal::float2(_e47, 1.0 - _e49), metal::level(0.0));
    return _e52;
}

metal::float4 card(
    thread float& i,
    thread float& n,
    thread metal::float2& cell,
    thread metal::float2& grid,
    thread metal::float2& lc,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 param = {};
    metal::float2 src = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float _e55 = i;
    if (_e55 < 0.5) {
        metal::float2 _e57 = cell;
        metal::float2 _e58 = lc;
        metal::float2 _e60 = grid;
        param = (_e57 + _e58) / _e60;
        metal::float4 _e62 = getFromColor(param, _from, _sampler);
        return _e62;
    }
    metal::float2 _e63 = cell;
    src = _e63;
    float _e64 = i;
    float _e65 = n;
    if (_e64 < (_e65 - 0.5)) {
        metal::float2 _e68 = cell;
        float _e70 = i;
        param_1 = (_e68 * 3.7) + metal::float2(_e70 * 11.3);
        float _e74 = hash12(param_1);
        metal::float2 _e75 = cell;
        float _e77 = i;
        param_2 = ((_e75 * 5.3) + metal::float2(_e77 * 7.9)) + metal::float2(1.7);
        float _e83 = hash12(param_2);
        metal::float2 _e85 = grid;
        src = metal::floor(metal::float2(_e74, _e83) * _e85);
    }
    metal::float2 _e88 = src;
    metal::float2 _e89 = lc;
    metal::float2 _e91 = grid;
    param_3 = (_e88 + _e89) / _e91;
    metal::float4 _e93 = getToColor(param_3, _sampler, _to);
    return _e93;
}

float flapIndex(
    thread float& t,
    thread float& n_1
) {
    float _e47 = t;
    float _e48 = n_1;
    float _e51 = n_1;
    return metal::min(metal::floor(_e47 * _e48), _e51 - 1.0);
}

float flapAngle(
    thread float& t_1,
    thread float& n_2
) {
    float u = {};
    float param_4 = {};
    float param_5 = {};
    float _e50 = t_1;
    float _e51 = n_2;
    float _e53 = t_1;
    param_4 = _e53;
    float _e54 = n_2;
    param_5 = _e54;
    float _e55 = flapIndex(param_4, param_5);
    u = (_e50 * _e51) - _e55;
    float _e57 = u;
    float _e59 = u;
    return (3.1415927 * _e57) * (0.3 + (0.7 * _e59));
}

float cellTime(
    thread metal::float2& cell_1,
    thread metal::float2& grid_1,
    constant Uniforms& uniforms
) {
    float wave = {};
    float order = {};
    metal::float2 param_6 = {};
    float delay = {};
    float _e52 = cell_1[0u];
    float _e54 = grid_1[1u];
    float _e57 = cell_1[1u];
    float _e62 = grid_1[0u];
    float _e65 = grid_1[1u];
    wave = (_e52 + (0.5 * ((_e54 - 1.0) - _e57))) / metal::max((_e62 - 1.0) + (0.5 * (_e65 - 1.0)), 1.0);
    float _e71 = wave;
    metal::float2 _e72 = cell_1;
    param_6 = _e72 + metal::float2(17.0);
    float _e75 = hash12(param_6);
    float _e77 = uniforms.randomness;
    order = metal::mix(_e71, _e75, _e77);
    float _e80 = uniforms.stagger;
    delay = metal::clamp(_e80, 0.0, 0.99);
    float _e83 = uniforms.progress;
    float _e84 = order;
    float _e85 = delay;
    float _e88 = delay;
    return metal::clamp((_e83 - (_e84 * _e85)) / (1.0 - _e88), 0.0, 1.0);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 grid_2 = {};
    float n_3 = {};
    metal::float2 cellSize_1 = {};
    metal::float2 cell_2 = {};
    metal::float2 l = {};
    float g_1 = {};
    float w = {};
    bool upper = {};
    float t_2 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    float k = {};
    float param_9 = {};
    float param_10 = {};
    float a = {};
    float param_11 = {};
    float param_12 = {};
    bool started = {};
    bool landed = {};
    metal::float4 color = {};
    float local = {};
    float param_13 = {};
    float param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    float local_1 = {};
    float param_18 = {};
    float param_19 = {};
    metal::float2 param_20 = {};
    float param_21 = {};
    float nearest = {};
    int d_1 = {};
    metal::float2 nc = {};
    float nt = {};
    float local_2 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    float na = {};
    float local_3 = {};
    float param_24 = {};
    float param_25 = {};
    float fc = {};
    float fs = {};
    float f_1 = {};
    float z = {};
    float lx = {};
    bool front = {};
    metal::float2 lc_1 = {};
    float local_4 = {};
    float m = {};
    float param_26 = {};
    float param_27 = {};
    metal::float2 param_28 = {};
    float param_29 = {};
    metal::float4 img = {};
    float param_30 = {};
    float param_31 = {};
    float param_32 = {};
    float param_33 = {};
    metal::float2 param_34 = {};
    metal::float2 param_35 = {};
    metal::float2 param_36 = {};
    float lambert = {};
    float local_5 = {};
    bool phi_506_ = {};
    bool phi_556_ = {};
    metal::int2 _e112 = uniforms.size;
    grid_2 = metal::max(static_cast<metal::float2>(_e112), metal::float2(1.0));
    int _e117 = uniforms.flaps;
    n_3 = metal::max(static_cast<float>(_e117), 1.0);
    float _e121 = uniforms.ratio;
    metal::float2 _e123 = grid_2;
    float _e126 = uniforms.ratio;
    cellSize_1 = (metal::float2(_e121, 1.0) / _e123) / metal::float2(metal::min(_e126, 1.0));
    metal::float2 _e130 = uv_2;
    metal::float2 _e131 = grid_2;
    cell_2 = metal::floor(_e130 * _e131);
    metal::float2 _e134 = uv_2;
    metal::float2 _e135 = grid_2;
    metal::float2 _e137 = cell_2;
    l = (_e134 * _e135) - _e137;
    float _e140 = uniforms.gap;
    float _e142 = uniforms.progress;
    float _e146 = uniforms.progress;
    g_1 = (_e140 * metal::smoothstep(0.0, 0.12, _e142)) * (1.0 - metal::smoothstep(0.88, 1.0, _e146));
    float _e151 = l[1u];
    w = _e151 - 0.5;
    float _e153 = w;
    upper = _e153 >= 0.0;
    metal::float2 _e155 = cell_2;
    param_7 = _e155;
    metal::float2 _e156 = grid_2;
    param_8 = _e156;
    float _e157 = cellTime(param_7, param_8, uniforms);
    t_2 = _e157;
    float _e158 = t_2;
    param_9 = _e158;
    float _e159 = n_3;
    param_10 = _e159;
    float _e160 = flapIndex(param_9, param_10);
    k = _e160;
    float _e161 = t_2;
    param_11 = _e161;
    float _e162 = n_3;
    param_12 = _e162;
    float _e163 = flapAngle(param_11, param_12);
    a = _e163;
    float _e164 = t_2;
    float _e165 = n_3;
    float _e167 = k;
    started = (_e164 * _e165) > _e167;
    float _e169 = t_2;
    landed = _e169 >= 1.0;
    float _e171 = k;
    bool _e172 = upper;
    if (_e172) {
        bool _e173 = started;
        local = _e173 ? 1.0 : 0.0;
    } else {
        bool _e175 = landed;
        local = _e175 ? 1.0 : 0.0;
    }
    float _e177 = local;
    param_13 = _e171 + _e177;
    float _e179 = n_3;
    param_14 = _e179;
    metal::float2 _e180 = cell_2;
    param_15 = _e180;
    metal::float2 _e181 = grid_2;
    param_16 = _e181;
    metal::float2 _e182 = l;
    param_17 = _e182;
    metal::float4 _e183 = card(param_13, param_14, param_15, param_16, param_17, _from, _sampler, _to);
    color = _e183;
    bool _e184 = started;
    bool _e185 = landed;
    if (_e184 && !(_e185)) {
        float _e189 = uniforms.shading;
        bool _e191 = upper;
        if (_e191) {
            float _e192 = a;
            local_1 = metal::cos(_e192);
        } else {
            float _e194 = a;
            local_1 = -(metal::cos(_e194));
        }
        float _e197 = local_1;
        metal::float4 _e201 = color;
        metal::float3 _e203 = _e201.xyz * (1.0 - ((0.45 * _e189) * metal::max(_e197, 0.0)));
        color[0u] = _e203.x;
        color[1u] = _e203.y;
        color[2u] = _e203.z;
    }
    metal::float4 _e211 = uniforms.background;
    metal::float4 _e212 = color;
    float _e213 = w;
    float _e216 = l[0u];
    param_18 = _e216;
    param_19 = metal::abs(_e213);
    metal::float2 _e217 = cellSize_1;
    param_20 = _e217;
    float _e218 = g_1;
    param_21 = _e218;
    float _e219 = cardMask(param_18, param_19, param_20, param_21, uniforms);
    color = metal::mix(_e211, _e212, metal::float4(_e219));
    nearest = -1.0;
    d_1 = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e361 = d_1;
            d_1 = as_type<int>(as_type<uint>(_e361) + as_type<uint>(1));
        }
        loop_init = false;
        int _e222 = d_1;
        if (_e222 <= 1) {
            metal::float2 _e224 = cell_2;
            int _e225 = d_1;
            nc = _e224 + metal::float2(static_cast<float>(_e225), 0.0);
            float _e230 = nc[0u];
            bool _e231 = _e230 < 0.0;
            phi_506_ = _e231;
            if (!(_e231)) {
                float _e234 = nc[0u];
                float _e236 = grid_2[0u];
                phi_506_ = _e234 > (_e236 - 1.0);
            }
            bool _e240 = phi_506_;
            if (_e240) {
                continue;
            }
            int _e241 = d_1;
            if (_e241 == 0) {
                float _e243 = t_2;
                local_2 = _e243;
            } else {
                metal::float2 _e244 = nc;
                param_22 = _e244;
                metal::float2 _e245 = grid_2;
                param_23 = _e245;
                float _e246 = cellTime(param_22, param_23, uniforms);
                local_2 = _e246;
            }
            float _e247 = local_2;
            nt = _e247;
            int _e248 = d_1;
            if (_e248 == 0) {
                float _e250 = a;
                local_3 = _e250;
            } else {
                float _e251 = nt;
                param_24 = _e251;
                float _e252 = n_3;
                param_25 = _e252;
                float _e253 = flapAngle(param_24, param_25);
                local_3 = _e253;
            }
            float _e254 = local_3;
            na = _e254;
            float _e255 = na;
            fc = metal::cos(_e255);
            float _e257 = na;
            fs = metal::sin(_e257);
            float _e259 = fc;
            bool _e261 = metal::abs(_e259) < 0.00001;
            phi_556_ = _e261;
            if (!(_e261)) {
                float _e263 = w;
                float _e265 = fc;
                phi_556_ = (_e263 >= 0.0) != (_e265 > 0.0);
            }
            bool _e269 = phi_556_;
            if (_e269) {
                continue;
            }
            float _e270 = w;
            float _e271 = fc;
            f_1 = _e270 / _e271;
            float _e273 = f_1;
            if (_e273 > 0.5) {
                continue;
            }
            float _e275 = f_1;
            float _e276 = fs;
            z = _e275 * _e276;
            float _e278 = z;
            float _e279 = nearest;
            if (_e278 <= _e279) {
                continue;
            }
            float _e282 = l[0u];
            int _e283 = d_1;
            float _e288 = uniforms.perspective;
            float _e289 = z;
            lx = 0.5 + (((_e282 - static_cast<float>(_e283)) - 0.5) * (1.0 - (_e288 * _e289)));
            float _e294 = lx;
            float _e296 = lx;
            if ((_e294 < 0.0) || (_e296 > 1.0)) {
                continue;
            }
            float _e299 = fc;
            front = _e299 > 0.0;
            float _e301 = lx;
            bool _e302 = front;
            if (_e302) {
                float _e303 = f_1;
                local_4 = 0.5 + _e303;
            } else {
                float _e305 = f_1;
                local_4 = 0.5 - _e305;
            }
            float _e307 = local_4;
            lc_1 = metal::float2(_e301, _e307);
            float _e309 = lx;
            param_26 = _e309;
            float _e310 = f_1;
            param_27 = _e310;
            metal::float2 _e311 = cellSize_1;
            param_28 = _e311;
            float _e312 = g_1;
            param_29 = _e312;
            float _e313 = cardMask(param_26, param_27, param_28, param_29, uniforms);
            m = _e313;
            float _e314 = m;
            if (_e314 <= 0.0) {
                continue;
            }
            float _e316 = nt;
            param_30 = _e316;
            float _e317 = n_3;
            param_31 = _e317;
            float _e318 = flapIndex(param_30, param_31);
            bool _e319 = front;
            param_32 = _e318 + (_e319 ? 0.0 : 1.0);
            float _e322 = n_3;
            param_33 = _e322;
            metal::float2 _e323 = nc;
            param_34 = _e323;
            metal::float2 _e324 = grid_2;
            param_35 = _e324;
            metal::float2 _e325 = lc_1;
            param_36 = _e325;
            metal::float4 _e326 = card(param_32, param_33, param_34, param_35, param_36, _from, _sampler, _to);
            img = _e326;
            bool _e327 = front;
            if (_e327) {
                float _e328 = fc;
                float _e330 = fs;
                local_5 = (0.92 * _e328) - (0.4 * _e330);
            } else {
                float _e333 = fs;
                float _e335 = fc;
                local_5 = (0.4 * _e333) - (0.92 * _e335);
            }
            float _e338 = local_5;
            lambert = _e338 / 0.92;
            float _e341 = uniforms.shading;
            float _e343 = lambert;
            metal::float4 _e346 = img;
            metal::float3 _e348 = _e346.xyz * metal::mix(1.0 - _e341, 1.0, metal::clamp(_e343, 0.0, 1.0));
            img[0u] = _e348.x;
            img[1u] = _e348.y;
            img[2u] = _e348.z;
            metal::float4 _e355 = color;
            metal::float4 _e356 = img;
            float _e357 = m;
            color = metal::mix(_e355, _e356, metal::float4(_e357));
            float _e360 = z;
            nearest = _e360;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e363 = color;
    return _e363;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_37 = {};
    metal::float2 _e46 = _uv_1;
    param_37 = _e46;
    metal::float4 _e47 = transition(param_37, _from, _sampler, _to, uniforms);
    _fragColor = _e47;
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
