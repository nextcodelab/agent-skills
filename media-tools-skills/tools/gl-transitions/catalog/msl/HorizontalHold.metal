// HorizontalHold — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HorizontalHold.glsl
// Author: gre
// License: MIT
// Description: The picture loses its horizontal hold like an old TV: it shears into diagonal bands that slide sideways and wrap around, separated by a slanted blanking bar that carries the incoming image in, then the shear straightens, wobbles and locks
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int slips;
    float shear;
    float barWidth;
    char _pad5[12];
    metal::float4 barColor;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e46 = uv[0u];
    float _e48 = uv[1u];
    metal::float4 _e51 = _from.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e46 = uv_1[0u];
    float _e48 = uv_1[1u];
    metal::float4 _e51 = _to.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

float slipCount_u0028_(
    constant Uniforms& uniforms
) {
    int _e45 = uniforms.slips;
    return metal::max(static_cast<float>(_e45), 1.0);
}

metal::float4 stream(
    thread float& x,
    thread float& y,
    thread float& unsync,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float period = {};
    float n = {};
    float xm = {};
    metal::float2 q = {};
    metal::float4 c = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float d = {};
    float g = {};
    float soft = {};
    float _e59 = uniforms.barWidth;
    period = 1.0 + _e59;
    float _e61 = x;
    float _e62 = period;
    n = metal::floor(_e61 / _e62);
    float _e65 = x;
    float _e66 = n;
    float _e67 = period;
    xm = _e65 - (_e66 * _e67);
    float _e70 = xm;
    float _e72 = y;
    q = metal::float2(metal::min(_e70, 1.0), _e72);
    float _e74 = n;
    float _e75 = slipCount_u0028_(uniforms);
    if (_e74 >= metal::floor((0.5 * _e75) + 0.5)) {
        metal::float2 _e80 = q;
        param = _e80;
        metal::float4 _e81 = getToColor(param, _sampler, _to);
        local = _e81;
    } else {
        metal::float2 _e82 = q;
        param_1 = _e82;
        metal::float4 _e83 = getFromColor(param_1, _from, _sampler);
        local = _e83;
    }
    metal::float4 _e84 = local;
    c = _e84;
    float _e85 = xm;
    float _e86 = xm;
    d = metal::min(_e85, 1.0 - _e86);
    float _e89 = d;
    g = metal::max(1.0 - (_e89 / 0.05), 0.0);
    float _e93 = unsync;
    float _e95 = g;
    float _e97 = g;
    float _e100 = c[3u];
    metal::float4 _e102 = c;
    metal::float3 _e105 = _e102.xyz + metal::float3((((0.3 * _e93) * _e95) * _e97) * _e100);
    c[0u] = _e105.x;
    c[1u] = _e105.y;
    c[2u] = _e105.z;
    float _e112 = unsync;
    float _e115 = uniforms.barWidth;
    soft = metal::min(0.012 * _e112, 0.5 * _e115) + 0.00001;
    metal::float4 _e120 = uniforms.barColor;
    metal::float4 _e121 = c;
    float _e122 = d;
    float _e123 = soft;
    return metal::mix(_e120, _e121, metal::float4(metal::clamp(_e122 / _e123, 0.0, 1.0)));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float period_1 = {};
    float t = {};
    float err = {};
    float slip = {};
    float u = {};
    float lock = {};
    float tilt = {};
    float unsync_1 = {};
    float ripple = {};
    float x_1 = {};
    float blur = {};
    metal::float4 c_1 = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    int i = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float _e65 = uniforms.barWidth;
    period_1 = 1.0 + _e65;
    float _e68 = uniforms.progress;
    t = metal::min(_e68 / 0.88, 1.0);
    float _e71 = t;
    float _e73 = t;
    float _e75 = t;
    float _e78 = t;
    err = (((16.0 * _e71) * _e73) * (1.0 - _e75)) * (1.0 - _e78);
    float _e81 = t;
    float _e82 = t;
    float _e84 = t;
    float _e86 = t;
    float _e87 = t;
    slip = ((_e81 * _e82) * _e84) * ((_e86 * ((_e87 * 6.0) - 15.0)) + 10.0);
    float _e94 = uniforms.progress;
    u = metal::clamp((_e94 - 0.74) / 0.26, 0.0, 1.0);
    float _e98 = u;
    float _e99 = u;
    float _e102 = u;
    lock = (_e98 * (1.0 - _e99)) * (1.0 - _e102);
    float _e106 = uniforms.shear;
    float _e109 = lock;
    float _e111 = u;
    tilt = ((-0.5 * metal::max(_e106, 0.5)) * _e109) * metal::sin(9.42478 * _e111);
    float _e115 = err;
    float _e116 = lock;
    unsync_1 = metal::min(_e115 + (3.0 * _e116), 1.0);
    float _e121 = uv_2[1u];
    float _e124 = uniforms.progress;
    float _e130 = uv_2[1u];
    float _e133 = uniforms.progress;
    ripple = (0.012 * metal::sin((_e121 * 9.0) + (_e124 * 40.0))) + (0.005 * metal::sin((_e130 * 31.0) - (_e133 * 70.0)));
    float _e140 = uv_2[0u];
    float _e141 = period_1;
    float _e142 = slipCount_u0028_(uniforms);
    float _e143 = slip;
    float _e146 = uniforms.shear;
    float _e147 = err;
    float _e150 = uv_2[1u];
    float _e154 = tilt;
    float _e156 = uv_2[1u];
    float _e162 = err;
    float _e163 = ripple;
    x_1 = (_e140 + (_e141 * (((_e142 * _e143) + ((_e146 * _e147) * (1.0 - _e150))) + (_e154 * (1.0 - _e156))))) + (_e162 * _e163);
    float _e166 = err;
    float _e168 = slipCount_u0028_(uniforms);
    blur = (0.002 * _e166) * _e168;
    float _e170 = x_1;
    param_2 = _e170;
    float _e172 = uv_2[1u];
    param_3 = _e172;
    float _e173 = unsync_1;
    param_4 = _e173;
    metal::float4 _e174 = stream(param_2, param_3, param_4, _from, _sampler, _to, uniforms);
    c_1 = _e174;
    float _e175 = blur;
    if (_e175 > 0.0) {
        i = 0;
        uint2 loop_bound = uint2(4294967295u);
        bool loop_init = true;
        while(true) {
            if (metal::all(loop_bound == uint2(0u))) { break; }
            loop_bound -= uint2(loop_bound.y == 0u, 1u);
            if (!loop_init) {
                int _e192 = i;
                i = as_type<int>(as_type<uint>(_e192) + as_type<uint>(1));
            }
            loop_init = false;
            int _e177 = i;
            if (_e177 < 4) {
                float _e179 = x_1;
                float _e180 = blur;
                int _e181 = i;
                param_5 = _e179 + (_e180 * (static_cast<float>(_e181) - 1.5));
                float _e187 = uv_2[1u];
                param_6 = _e187;
                float _e188 = unsync_1;
                param_7 = _e188;
                metal::float4 _e189 = stream(param_5, param_6, param_7, _from, _sampler, _to, uniforms);
                metal::float4 _e190 = c_1;
                c_1 = _e190 + _e189;
                continue;
            } else {
                break;
            }
        }
        metal::float4 _e194 = c_1;
        c_1 = _e194 / metal::float4(5.0);
    }
    float _e197 = unsync_1;
    float _e199 = uv_2[1u];
    metal::float4 _e206 = c_1;
    metal::float3 _e208 = _e206.xyz * (1.0 - (_e197 * (0.1 + (0.08 * metal::sin(_e199 * 480.0)))));
    c_1[0u] = _e208.x;
    c_1[1u] = _e208.y;
    c_1[2u] = _e208.z;
    metal::float4 _e215 = c_1;
    return _e215;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e45 = _uv_1;
    param_8 = _e45;
    metal::float4 _e46 = transition(param_8, _from, _sampler, _to, uniforms);
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
