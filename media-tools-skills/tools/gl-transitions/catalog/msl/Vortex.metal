// Vortex — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Vortex.glsl
// Author: gre
// License: MIT
// Description: The outgoing image breaks into hundreds of small squares that a tornado carries away along a spiral around the center, from the eye outward, uncovering the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int grid;
    char _pad3[4];
    metal::float2 center;
    float spin;
    float randomness;
};

float hash(
    thread metal::float2& n
) {
    metal::float2 _e45 = n;
    return metal::fract(metal::sin(metal::dot(_e45, metal::float2(12.9898, 78.233))) * 43758.547);
}

metal::float4 premultiplied(
    thread metal::float4& c
) {
    metal::float4 _e45 = c;
    float _e48 = c[3u];
    metal::float3 _e49 = _e45.xyz * _e48;
    float _e51 = c[3u];
    return metal::float4(_e49.x, _e49.y, _e49.z, _e51);
}

float flight(
    thread int& g,
    constant Uniforms& uniforms
) {
    float delay = {};
    int _e46 = g;
    delay = (static_cast<float>(_e46) / 24.0) * 0.75;
    float _e51 = uniforms.progress;
    float _e52 = delay;
    return metal::clamp((_e51 - _e52) / 0.25, 0.0, 1.0);
}

int naga_f2i32(float value) {
    return static_cast<int>(metal::clamp(value, -2147483600.0, 2147483500.0));
}

int groupOf(
    thread metal::float2& n_1,
    thread float& h,
    thread metal::float2& c_1,
    thread float& maxR,
    constant Uniforms& uniforms
) {
    float r = {};
    float key = {};
    metal::float2 param = {};
    metal::float2 _e51 = n_1;
    float _e54 = h;
    metal::float2 _e56 = c_1;
    float _e59 = maxR;
    r = metal::min(metal::length(((_e51 + metal::float2(0.5)) * _e54) - _e56) / (0.85 * _e59), 1.0);
    float _e63 = r;
    float _e64 = r;
    metal::float2 _e67 = n_1;
    param = _e67;
    float _e68 = hash(param);
    float _e70 = uniforms.randomness;
    key = metal::clamp(metal::mix(_e63 * metal::sqrt(_e64), _e68, metal::clamp(_e70, 0.0, 1.0)), 0.0, 0.9999);
    float _e74 = key;
    return naga_f2i32(metal::floor(_e74 * 24.0));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e46 = uv[0u];
    float _e48 = uv[1u];
    metal::float4 _e51 = _to.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e46 = uv_1[0u];
    float _e48 = uv_1[1u];
    metal::float4 _e51 = _from.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 aspect = {};
    metal::float2 p = {};
    metal::float2 c_2 = {};
    float maxR_1 = {};
    float h_1 = {};
    int local = {};
    float reach = {};
    metal::float2 n0_ = {};
    metal::float4 col = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    metal::float2 param_5 = {};
    float param_6 = {};
    int param_7 = {};
    metal::float4 local_1 = {};
    metal::float2 param_8 = {};
    metal::float4 param_9 = {};
    metal::float2 param_10 = {};
    metal::float4 param_11 = {};
    int k = {};
    int g_1 = {};
    float s = {};
    int param_12 = {};
    float e = {};
    float angle = {};
    float push = {};
    float size = {};
    float ca = {};
    float sa = {};
    metal::float2x2 rot = {};
    metal::float2 u = {};
    float ru = {};
    metal::float2 guess = {};
    metal::float2 local_2 = {};
    metal::float2 ng = {};
    int j = {};
    int i = {};
    metal::float2 n_2 = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float2 home = {};
    metal::float2 rel = {};
    float rr = {};
    metal::float2 dir = {};
    metal::float2 local_3 = {};
    metal::float2 pos = {};
    float tumble = {};
    metal::float2 param_17 = {};
    float ct = {};
    float st = {};
    metal::float2 d = {};
    float edge = {};
    float cov = {};
    metal::float2 src = {};
    metal::float4 piece = {};
    metal::float2 param_18 = {};
    metal::float4 param_19 = {};
    metal::float4 local_4 = {};
    bool phi_537_ = {};
    bool phi_544_ = {};
    bool phi_553_ = {};
    bool phi_560_ = {};
    float _e108 = uniforms.progress;
    if (_e108 <= 0.0) {
        metal::float2 _e110 = uv_2;
        param_1 = _e110;
        metal::float4 _e111 = getFromColor(param_1, _from, _sampler);
        return _e111;
    }
    float _e113 = uniforms.progress;
    if (_e113 >= 1.0) {
        metal::float2 _e115 = uv_2;
        param_2 = _e115;
        metal::float4 _e116 = getToColor(param_2, _sampler, _to);
        return _e116;
    }
    float _e118 = uniforms.ratio;
    aspect = metal::float2(_e118, 1.0);
    metal::float2 _e120 = uv_2;
    metal::float2 _e121 = aspect;
    p = _e120 * _e121;
    metal::float2 _e124 = uniforms.center;
    metal::float2 _e125 = aspect;
    c_2 = _e124 * _e125;
    metal::float2 _e127 = c_2;
    metal::float2 _e129 = c_2;
    float _e131 = uniforms.ratio;
    metal::float2 _e136 = c_2;
    metal::float2 _e139 = c_2;
    metal::float2 _e140 = aspect;
    maxR_1 = metal::max(metal::max(metal::length(_e127), metal::length(_e129 - metal::float2(_e131, 0.0))), metal::max(metal::length(_e136 - metal::float2(0.0, 1.0)), metal::length(_e139 - _e140)));
    int _e146 = uniforms.grid;
    if (_e146 < 1) {
        local = 1;
    } else {
        int _e149 = uniforms.grid;
        local = _e149;
    }
    int _e150 = local;
    h_1 = 1.0 / static_cast<float>(_e150);
    float _e153 = maxR_1;
    reach = 0.7 * _e153;
    metal::float2 _e155 = p;
    float _e156 = h_1;
    n0_ = metal::floor(_e155 / metal::float2(_e156));
    metal::float2 _e160 = n0_;
    param_3 = _e160;
    float _e161 = h_1;
    param_4 = _e161;
    metal::float2 _e162 = c_2;
    param_5 = _e162;
    float _e163 = maxR_1;
    param_6 = _e163;
    int _e164 = groupOf(param_3, param_4, param_5, param_6, uniforms);
    param_7 = _e164;
    float _e165 = flight(param_7, uniforms);
    if (_e165 <= 0.0) {
        metal::float2 _e167 = uv_2;
        param_8 = _e167;
        metal::float4 _e168 = getFromColor(param_8, _from, _sampler);
        param_9 = _e168;
        metal::float4 _e169 = premultiplied(param_9);
        local_1 = _e169;
    } else {
        metal::float2 _e170 = uv_2;
        param_10 = _e170;
        metal::float4 _e171 = getToColor(param_10, _sampler, _to);
        param_11 = _e171;
        metal::float4 _e172 = premultiplied(param_11);
        local_1 = _e172;
    }
    metal::float4 _e173 = local_1;
    col = _e173;
    k = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e398 = k;
            k = as_type<int>(as_type<uint>(_e398) + as_type<uint>(1));
        }
        loop_init = false;
        int _e174 = k;
        if (_e174 < 24) {
            int _e176 = k;
            g_1 = as_type<int>(as_type<uint>(23) - as_type<uint>(_e176));
            int _e178 = g_1;
            param_12 = _e178;
            float _e179 = flight(param_12, uniforms);
            s = _e179;
            float _e180 = s;
            float _e182 = s;
            if ((_e180 <= 0.0) || (_e182 >= 1.0)) {
                continue;
            }
            float _e185 = s;
            float _e186 = s;
            e = _e185 * _e186;
            float _e189 = uniforms.spin;
            float _e191 = e;
            int _e194 = g_1;
            angle = (((_e189 * 6.2831855) * _e191) * 2.0) / (1.0 + ((6.0 * static_cast<float>(_e194)) / 24.0));
            float _e200 = reach;
            float _e201 = e;
            float _e203 = s;
            push = (_e200 * _e201) * _e203;
            float _e205 = s;
            float _e210 = s;
            float _e211 = s;
            float _e213 = s;
            size = (1.0 + (0.35 * metal::sin(3.1415927 * _e205))) * (1.0 - ((_e210 * _e211) * _e213));
            float _e217 = angle;
            ca = metal::cos(_e217);
            float _e219 = angle;
            sa = metal::sin(_e219);
            float _e221 = ca;
            float _e222 = sa;
            float _e223 = sa;
            float _e225 = ca;
            rot = metal::float2x2(metal::float2(_e221, _e222), metal::float2(-(_e223), _e225));
            metal::float2 _e229 = p;
            metal::float2 _e230 = c_2;
            metal::float2x2 _e232 = rot;
            u = (_e229 - _e230) * _e232;
            metal::float2 _e234 = u;
            ru = metal::length(_e234);
            metal::float2 _e236 = c_2;
            float _e237 = ru;
            if (_e237 > 0.0) {
                metal::float2 _e239 = u;
                float _e240 = ru;
                local_2 = _e239 / metal::float2(_e240);
            } else {
                local_2 = metal::float2(0.0, 0.0);
            }
            metal::float2 _e243 = local_2;
            float _e244 = ru;
            float _e245 = push;
            guess = _e236 + (_e243 * metal::max(_e244 - _e245, 0.0));
            metal::float2 _e250 = guess;
            float _e251 = h_1;
            ng = metal::floor(_e250 / metal::float2(_e251));
            j = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e396 = j;
                    j = as_type<int>(as_type<uint>(_e396) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e255 = j;
                if (_e255 <= 1) {
                    i = -1;
                    uint2 loop_bound_2 = uint2(4294967295u);
                    bool loop_init_2 = true;
                    while(true) {
                        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
                        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
                        if (!loop_init_2) {
                            int _e394 = i;
                            i = as_type<int>(as_type<uint>(_e394) + as_type<uint>(1));
                        }
                        loop_init_2 = false;
                        int _e257 = i;
                        if (_e257 <= 1) {
                            metal::float2 _e259 = ng;
                            int _e260 = i;
                            int _e262 = j;
                            n_2 = _e259 + metal::float2(static_cast<float>(_e260), static_cast<float>(_e262));
                            metal::float2 _e266 = n_2;
                            param_13 = _e266;
                            float _e267 = h_1;
                            param_14 = _e267;
                            metal::float2 _e268 = c_2;
                            param_15 = _e268;
                            float _e269 = maxR_1;
                            param_16 = _e269;
                            int _e270 = groupOf(param_13, param_14, param_15, param_16, uniforms);
                            int _e271 = g_1;
                            if (_e270 != _e271) {
                                continue;
                            }
                            metal::float2 _e273 = n_2;
                            float _e276 = h_1;
                            home = (_e273 + metal::float2(0.5)) * _e276;
                            metal::float2 _e278 = home;
                            metal::float2 _e279 = c_2;
                            rel = _e278 - _e279;
                            metal::float2 _e281 = rel;
                            rr = metal::length(_e281);
                            float _e283 = rr;
                            if (_e283 > 0.0) {
                                metal::float2 _e285 = rel;
                                float _e286 = rr;
                                local_3 = _e285 / metal::float2(_e286);
                            } else {
                                local_3 = metal::float2(0.0, 0.0);
                            }
                            metal::float2 _e289 = local_3;
                            dir = _e289;
                            metal::float2 _e290 = c_2;
                            metal::float2x2 _e291 = rot;
                            metal::float2 _e292 = dir;
                            float _e293 = rr;
                            float _e294 = push;
                            pos = _e290 + (_e291 * (_e292 * (_e293 + _e294)));
                            float _e299 = angle;
                            metal::float2 _e300 = n_2;
                            param_17 = _e300 + metal::float2(17.0);
                            float _e303 = hash(param_17);
                            float _e306 = e;
                            float _e309 = uniforms.spin;
                            tumble = _e299 + ((((_e303 - 0.5) * 3.0) * _e306) * metal::sign(_e309));
                            float _e313 = tumble;
                            ct = metal::cos(_e313);
                            float _e315 = tumble;
                            st = metal::sin(_e315);
                            metal::float2 _e317 = p;
                            metal::float2 _e318 = pos;
                            float _e320 = ct;
                            float _e321 = st;
                            float _e322 = st;
                            float _e324 = ct;
                            float _e329 = size;
                            d = ((_e317 - _e318) * metal::float2x2(metal::float2(_e320, _e321), metal::float2(-(_e322), _e324))) / metal::float2(metal::max(_e329, 0.0001));
                            float _e333 = h_1;
                            float _e336 = d[0u];
                            float _e339 = d[1u];
                            edge = (0.5 * _e333) - metal::max(metal::abs(_e336), metal::abs(_e339));
                            float _e343 = edge;
                            float _e344 = size;
                            cov = metal::clamp(((_e343 * _e344) / 0.003) + 0.5, 0.0, 1.0);
                            metal::float2 _e349 = home;
                            metal::float2 _e350 = d;
                            src = _e349 + _e350;
                            float _e352 = cov;
                            bool _e353 = _e352 <= 0.0;
                            phi_537_ = _e353;
                            if (!(_e353)) {
                                float _e356 = src[0u];
                                phi_537_ = _e356 < 0.0;
                            }
                            bool _e359 = phi_537_;
                            phi_544_ = _e359;
                            if (!(_e359)) {
                                float _e362 = src[1u];
                                phi_544_ = _e362 < 0.0;
                            }
                            bool _e365 = phi_544_;
                            phi_553_ = _e365;
                            if (!(_e365)) {
                                float _e368 = src[0u];
                                float _e370 = uniforms.ratio;
                                phi_553_ = _e368 > _e370;
                            }
                            bool _e373 = phi_553_;
                            phi_560_ = _e373;
                            if (!(_e373)) {
                                float _e376 = src[1u];
                                phi_560_ = _e376 > 1.0;
                            }
                            bool _e379 = phi_560_;
                            if (_e379) {
                                continue;
                            }
                            metal::float2 _e380 = src;
                            metal::float2 _e381 = aspect;
                            param_18 = _e380 / _e381;
                            metal::float4 _e383 = getFromColor(param_18, _from, _sampler);
                            param_19 = _e383;
                            metal::float4 _e384 = premultiplied(param_19);
                            float _e385 = cov;
                            piece = _e384 * _e385;
                            metal::float4 _e387 = piece;
                            metal::float4 _e388 = col;
                            float _e390 = piece[3u];
                            col = _e387 + (_e388 * (1.0 - _e390));
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
            continue;
        } else {
            break;
        }
    }
    float _e401 = col[3u];
    if (_e401 > 0.0) {
        metal::float4 _e403 = col;
        float _e406 = col[3u];
        metal::float3 _e408 = _e403.xyz / metal::float3(_e406);
        float _e410 = col[3u];
        local_4 = metal::float4(_e408.x, _e408.y, _e408.z, _e410);
    } else {
        local_4 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e415 = local_4;
    return _e415;
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
    metal::float2 _e45 = _uv_1;
    param_20 = _e45;
    metal::float4 _e46 = transition(param_20, _from, _sampler, _to, uniforms);
    _fragColor = _e46;
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
