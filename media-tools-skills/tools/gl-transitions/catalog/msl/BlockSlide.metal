// BlockSlide — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BlockSlide.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into a grid of blocks that slide out one after another in a staggered cascade, some of them shrinking as they go, while the blocks of the incoming image slide in behind them to take their place
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 grid;
    metal::float2 direction;
    float stagger;
    float zoom;
    metal::float4 background;
};

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e33 = p;
    p3_ = metal::fract(_e33.xyx * 0.1031);
    metal::float3 _e37 = p3_;
    metal::float3 _e38 = p3_;
    metal::float3 _e43 = p3_;
    p3_ = _e43 + metal::float3(metal::dot(_e37, _e38.yzx + metal::float3(33.33)));
    float _e47 = p3_[0u];
    float _e49 = p3_[1u];
    float _e52 = p3_[2u];
    return metal::fract((_e47 + _e49) * _e52);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e33 = uv[0u];
    float _e35 = uv[1u];
    metal::float4 _e38 = _to.sample(_sampler, metal::float2(_e33, 1.0 - _e35), metal::level(0.0));
    return _e38;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e33 = uv_1[0u];
    float _e35 = uv_1[1u];
    metal::float4 _e38 = _from.sample(_sampler, metal::float2(_e33, 1.0 - _e35), metal::level(0.0));
    return _e38;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool vertical = {};
    bool backward = {};
    bool local = {};
    metal::float2 g = {};
    float a = {};
    float local_1 = {};
    float b = {};
    float local_2 = {};
    float n = {};
    float local_3 = {};
    float strips = {};
    float local_4 = {};
    float r = {};
    float rowOrder = {};
    float local_5 = {};
    float local_6 = {};
    float st = {};
    float z = {};
    float an = {};
    float bn = {};
    float rear = {};
    int k = {};
    float i = {};
    float order = {};
    float local_7 = {};
    float p_1 = {};
    float pin = {};
    float zi = {};
    metal::float2 param_2 = {};
    float sFrom = {};
    float sTo = {};
    metal::float4 l = {};
    bool inFrom = {};
    bool inTo = {};
    metal::float2 q = {};
    metal::float2 local_8 = {};
    metal::float2 local_9 = {};
    metal::float4 local_10 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    bool phi_428_ = {};
    bool phi_440_ = {};
    float _e75 = uniforms.progress;
    if (_e75 <= 0.0) {
        metal::float2 _e77 = uv_2;
        param = _e77;
        metal::float4 _e78 = getFromColor(param, _from, _sampler);
        return _e78;
    }
    float _e80 = uniforms.progress;
    if (_e80 >= 1.0) {
        metal::float2 _e82 = uv_2;
        param_1 = _e82;
        metal::float4 _e83 = getToColor(param_1, _sampler, _to);
        return _e83;
    }
    float _e86 = uniforms.direction[1u];
    float _e90 = uniforms.direction[0u];
    vertical = metal::abs(_e86) > metal::abs(_e90);
    bool _e93 = vertical;
    if (_e93) {
        float _e96 = uniforms.direction[1u];
        local = _e96 < 0.0;
    } else {
        float _e100 = uniforms.direction[0u];
        local = _e100 < 0.0;
    }
    bool _e102 = local;
    backward = _e102;
    metal::int2 _e104 = uniforms.grid;
    g = metal::max(static_cast<metal::float2>(_e104), metal::float2(1.0));
    bool _e108 = vertical;
    if (_e108) {
        float _e110 = uv_2[1u];
        local_1 = _e110;
    } else {
        float _e112 = uv_2[0u];
        local_1 = _e112;
    }
    float _e113 = local_1;
    a = _e113;
    bool _e114 = vertical;
    if (_e114) {
        float _e116 = uv_2[0u];
        local_2 = _e116;
    } else {
        float _e118 = uv_2[1u];
        local_2 = _e118;
    }
    float _e119 = local_2;
    b = _e119;
    bool _e120 = backward;
    if (_e120) {
        float _e121 = a;
        a = 1.0 - _e121;
    }
    bool _e123 = vertical;
    if (_e123) {
        float _e125 = g[1u];
        local_3 = _e125;
    } else {
        float _e127 = g[0u];
        local_3 = _e127;
    }
    float _e128 = local_3;
    n = metal::min(_e128, 40.0);
    bool _e130 = vertical;
    if (_e130) {
        float _e132 = g[0u];
        local_4 = _e132;
    } else {
        float _e134 = g[1u];
        local_4 = _e134;
    }
    float _e135 = local_4;
    strips = _e135;
    float _e136 = b;
    float _e137 = strips;
    float _e140 = strips;
    r = metal::min(metal::floor(_e136 * _e137), _e140 - 1.0);
    float _e143 = strips;
    if (_e143 > 1.0) {
        bool _e145 = vertical;
        if (_e145) {
            float _e146 = r;
            local_6 = _e146;
        } else {
            float _e147 = strips;
            float _e149 = r;
            local_6 = (_e147 - 1.0) - _e149;
        }
        float _e151 = local_6;
        float _e152 = strips;
        local_5 = _e151 / (_e152 - 1.0);
    } else {
        local_5 = 0.0;
    }
    float _e155 = local_5;
    rowOrder = _e155;
    float _e157 = uniforms.stagger;
    st = metal::clamp(_e157, 0.0, 0.95);
    float _e160 = uniforms.zoom;
    z = metal::clamp(_e160, 0.0, 0.9);
    float _e162 = a;
    float _e163 = n;
    an = _e162 * _e163;
    float _e165 = b;
    float _e166 = strips;
    float _e168 = r;
    bn = (_e165 * _e166) - _e168;
    float _e171 = uniforms.progress;
    float _e172 = st;
    float _e173 = rowOrder;
    float _e177 = st;
    rear = metal::clamp((_e171 - (_e172 * metal::mix(_e173, 1.0, 0.2))) / (1.0 - _e177), 0.0, 1.0);
    float _e181 = rear;
    float _e182 = rear;
    float _e184 = rear;
    rear = (_e181 * _e182) * (3.0 - (2.0 * _e184));
    k = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e354 = k;
            k = as_type<int>(as_type<uint>(_e354) + as_type<uint>(1));
        }
        loop_init = false;
        int _e188 = k;
        if (_e188 < 40) {
            int _e190 = k;
            i = static_cast<float>(_e190);
            float _e192 = i;
            float _e193 = n;
            if (_e192 >= _e193) {
                break;
            }
            float _e195 = rowOrder;
            float _e196 = n;
            if (_e196 > 1.0) {
                float _e198 = n;
                float _e200 = i;
                float _e202 = n;
                local_7 = ((_e198 - 1.0) - _e200) / (_e202 - 1.0);
            } else {
                local_7 = 0.0;
            }
            float _e205 = local_7;
            order = metal::mix(_e195, _e205, 0.2);
            float _e208 = uniforms.progress;
            float _e209 = st;
            float _e210 = order;
            float _e213 = st;
            p_1 = metal::clamp((_e208 - (_e209 * _e210)) / (1.0 - _e213), 0.0, 1.0);
            float _e217 = p_1;
            float _e218 = p_1;
            float _e220 = p_1;
            p_1 = (_e217 * _e218) * (3.0 - (2.0 * _e220));
            float _e224 = rear;
            float _e226 = n;
            float _e228 = i;
            float _e230 = n;
            pin = metal::max(0.0, 1.0 - ((1.0 - _e224) * (1.0 + (((_e226 - 1.0) - _e228) / _e230))));
            float _e236 = i;
            float _e237 = r;
            param_2 = metal::float2(_e236, _e237) + metal::float2(3.7);
            float _e241 = hash(param_2);
            float _e243 = z;
            zi = (_e241 < 0.5) ? _e243 : 0.0;
            float _e245 = zi;
            float _e246 = p_1;
            float _e248 = p_1;
            sFrom = 1.0 - ((_e245 * _e246) * _e248);
            float _e251 = zi;
            float _e252 = pin;
            float _e255 = pin;
            sTo = 1.0 - ((_e251 * (1.0 - _e252)) * (1.0 - _e255));
            float _e259 = an;
            float _e260 = i;
            float _e262 = p_1;
            float _e263 = n;
            float _e266 = sFrom;
            float _e270 = sFrom;
            float _e272 = bn;
            float _e273 = sFrom;
            float _e277 = sFrom;
            float _e279 = an;
            float _e280 = i;
            float _e282 = pin;
            float _e284 = n;
            float _e287 = sTo;
            float _e291 = sTo;
            float _e293 = bn;
            float _e294 = sTo;
            float _e298 = sTo;
            l = metal::float4((((_e259 - _e260) - (_e262 * _e263)) - (0.5 * (1.0 - _e266))) / _e270, (_e272 - (0.5 * (1.0 - _e273))) / _e277, (((_e279 - _e280) - ((_e282 - 1.0) * _e284)) - (0.5 * (1.0 - _e287))) / _e291, (_e293 - (0.5 * (1.0 - _e294))) / _e298);
            metal::float4 _e301 = l;
            bool _e304 = metal::all(_e301.xy >= metal::float2(0.0, 0.0));
            phi_428_ = _e304;
            if (_e304) {
                metal::float4 _e305 = l;
                phi_428_ = metal::all(_e305.xy < metal::float2(1.0, 1.0));
            }
            bool _e310 = phi_428_;
            inFrom = _e310;
            metal::float4 _e311 = l;
            bool _e314 = metal::all(_e311.zw >= metal::float2(0.0, 0.0));
            phi_440_ = _e314;
            if (_e314) {
                metal::float4 _e315 = l;
                phi_440_ = metal::all(_e315.zw < metal::float2(1.0, 1.0));
            }
            bool _e320 = phi_440_;
            inTo = _e320;
            bool _e321 = inFrom;
            bool _e322 = inTo;
            if (_e321 || _e322) {
                float _e324 = i;
                float _e325 = r;
                bool _e327 = inTo;
                if (_e327) {
                    metal::float4 _e328 = l;
                    local_8 = _e328.zw;
                } else {
                    metal::float4 _e330 = l;
                    local_8 = _e330.xy;
                }
                metal::float2 _e332 = local_8;
                float _e334 = n;
                float _e335 = strips;
                q = (metal::float2(_e324, _e325) + _e332) / metal::float2(_e334, _e335);
                bool _e338 = backward;
                if (_e338) {
                    float _e340 = q[0u];
                    q[0u] = 1.0 - _e340;
                }
                bool _e343 = vertical;
                if (_e343) {
                    metal::float2 _e344 = q;
                    local_9 = _e344.yx;
                } else {
                    metal::float2 _e346 = q;
                    local_9 = _e346;
                }
                metal::float2 _e347 = local_9;
                q = _e347;
                bool _e348 = inTo;
                if (_e348) {
                    metal::float2 _e349 = q;
                    param_3 = _e349;
                    metal::float4 _e350 = getToColor(param_3, _sampler, _to);
                    local_10 = _e350;
                } else {
                    metal::float2 _e351 = q;
                    param_4 = _e351;
                    metal::float4 _e352 = getFromColor(param_4, _from, _sampler);
                    local_10 = _e352;
                }
                metal::float4 _e353 = local_10;
                return _e353;
            }
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e357 = uniforms.background;
    return _e357;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_5 = {};
    metal::float2 _e32 = _uv_1;
    param_5 = _e32;
    metal::float4 _e33 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e33;
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
