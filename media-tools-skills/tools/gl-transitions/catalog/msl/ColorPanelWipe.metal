// ColorPanelWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ColorPanelWipe.glsl
// Author: gre
// License: MIT
// Description: Solid color panels, slightly staggered, sweep across and cover the frame, then sweep off the far side and reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 direction;
    int panels;
    char _pad4[12];
    metal::float4 color1_;
    metal::float4 color2_;
    metal::float4 color3_;
    float stagger;
    float skew;
    char _pad9[8];
};

float cover(
    thread float& x,
    thread float& back,
    thread float& front
) {
    float _e36 = back;
    float _e38 = back;
    float _e40 = x;
    float _e42 = front;
    float _e44 = front;
    float _e46 = x;
    return metal::smoothstep(_e36 - 0.0015, _e38 + 0.0015, _e40) * (1.0 - metal::smoothstep(_e42 - 0.0015, _e44 + 0.0015, _e46));
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

float ease(
    thread float& t
) {
    float s = {};
    float u = {};
    float _e36 = t;
    s = metal::clamp(_e36, 0.0, 1.0);
    float _e38 = s;
    float _e39 = s;
    float _e41 = s;
    u = 1.0 - ((_e38 * _e39) * (3.0 - (2.0 * _e41)));
    float _e46 = u;
    float _e47 = u;
    float _e49 = u;
    return 1.0 - ((_e46 * _e47) * _e49);
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
    metal::float2 p = {};
    float k = {};
    metal::float2 a = {};
    float x_1 = {};
    float e = {};
    float start = {};
    float span = {};
    int n = {};
    int local_1 = {};
    int local_2 = {};
    float m = {};
    float st = {};
    metal::float2 d = {};
    float front0_ = {};
    float param = {};
    float back0_ = {};
    float param_1 = {};
    metal::float4 c = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    int i = {};
    metal::float2 t_1 = {};
    float front_1 = {};
    float param_7 = {};
    float back_1 = {};
    float param_8 = {};
    metal::float4 local_3 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    metal::float2 _e70 = uniforms.direction;
    if (metal::length(_e70) > 0.0) {
        metal::float2 _e74 = uniforms.direction;
        local = metal::normalize(_e74);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e76 = local;
    dir = _e76;
    metal::float2 _e77 = uv_2;
    float _e81 = uniforms.ratio;
    p = (_e77 - metal::float2(0.5)) * metal::float2(_e81, 1.0);
    float _e85 = uniforms.skew;
    k = metal::clamp(_e85, -1.0, 1.0);
    metal::float2 _e87 = dir;
    float _e88 = k;
    float _e90 = dir[1u];
    float _e93 = dir[0u];
    float _e97 = k;
    float _e98 = k;
    a = (_e87 + (metal::float2(-(_e90), _e93) * _e88)) / metal::float2(metal::sqrt(1.0 + (_e97 * _e98)));
    metal::float2 _e104 = p;
    metal::float2 _e105 = a;
    x_1 = metal::dot(_e104, _e105);
    float _e108 = a[0u];
    float _e111 = uniforms.ratio;
    float _e114 = a[1u];
    e = 0.5 * ((metal::abs(_e108) * _e111) + metal::abs(_e114));
    float _e118 = e;
    start = -(_e118) - 0.003;
    float _e121 = e;
    span = 2.0 * (_e121 + 0.003);
    int _e125 = uniforms.panels;
    if (_e125 < 1) {
        local_1 = 1;
    } else {
        int _e128 = uniforms.panels;
        if (_e128 > 3) {
            local_2 = 3;
        } else {
            int _e131 = uniforms.panels;
            local_2 = _e131;
        }
        int _e132 = local_2;
        local_1 = _e132;
    }
    int _e133 = local_1;
    n = _e133;
    int _e134 = n;
    m = static_cast<float>(as_type<int>(as_type<uint>(_e134) - as_type<uint>(1)));
    float _e138 = uniforms.stagger;
    st = metal::clamp(_e138, 0.0, 1.0);
    float _e140 = m;
    float _e141 = st;
    d = metal::float2(0.45, 0.53) / metal::float2(1.0 + (_e140 * _e141));
    float _e146 = start;
    float _e147 = span;
    float _e149 = uniforms.progress;
    float _e151 = d[0u];
    param = _e149 / _e151;
    float _e153 = ease(param);
    front0_ = _e146 + (_e147 * _e153);
    float _e156 = start;
    float _e157 = span;
    float _e159 = uniforms.progress;
    float _e162 = d[1u];
    float _e165 = d[1u];
    param_1 = ((_e159 - 1.0) + _e162) / _e165;
    float _e167 = ease(param_1);
    back0_ = _e156 + (_e157 * _e167);
    metal::float2 _e170 = uv_2;
    param_2 = _e170;
    metal::float4 _e171 = getToColor(param_2, _sampler, _to);
    metal::float2 _e172 = uv_2;
    param_3 = _e172;
    metal::float4 _e173 = getFromColor(param_3, _from, _sampler);
    float _e174 = front0_;
    float _e175 = back0_;
    float _e178 = x_1;
    c = metal::mix(_e171, _e173, metal::float4(metal::step(0.5 * (_e174 + _e175), _e178)));
    metal::float4 _e182 = c;
    metal::float4 _e184 = uniforms.color1_;
    float _e185 = x_1;
    param_4 = _e185;
    float _e186 = back0_;
    param_5 = _e186;
    float _e187 = front0_;
    param_6 = _e187;
    float _e188 = cover(param_4, param_5, param_6);
    c = metal::mix(_e182, _e184, metal::float4(_e188));
    i = 1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e246 = i;
            i = as_type<int>(as_type<uint>(_e246) + as_type<uint>(1));
        }
        loop_init = false;
        int _e191 = i;
        if (_e191 < 3) {
            int _e193 = i;
            int _e194 = n;
            if (_e193 < _e194) {
                int _e196 = i;
                float _e198 = st;
                metal::float2 _e200 = d;
                t_1 = _e200 * (static_cast<float>(_e196) * _e198);
                float _e202 = start;
                float _e203 = span;
                float _e205 = uniforms.progress;
                float _e207 = t_1[0u];
                float _e210 = d[0u];
                param_7 = (_e205 - _e207) / _e210;
                float _e212 = ease(param_7);
                front_1 = _e202 + (_e203 * _e212);
                float _e215 = start;
                float _e216 = span;
                float _e218 = uniforms.progress;
                float _e221 = d[1u];
                float _e224 = t_1[1u];
                float _e227 = d[1u];
                param_8 = (((_e218 - 1.0) + _e221) + _e224) / _e227;
                float _e229 = ease(param_8);
                back_1 = _e215 + (_e216 * _e229);
                metal::float4 _e232 = c;
                int _e233 = i;
                if (_e233 == 1) {
                    metal::float4 _e236 = uniforms.color2_;
                    local_3 = _e236;
                } else {
                    metal::float4 _e238 = uniforms.color3_;
                    local_3 = _e238;
                }
                metal::float4 _e239 = local_3;
                float _e240 = x_1;
                param_9 = _e240;
                float _e241 = back_1;
                param_10 = _e241;
                float _e242 = front_1;
                param_11 = _e242;
                float _e243 = cover(param_9, param_10, param_11);
                c = metal::mix(_e232, _e239, metal::float4(_e243));
            }
            continue;
        } else {
            break;
        }
    }
    float _e249 = c[3u];
    metal::float4 _e251 = c;
    return metal::select(metal::float4(0.0, 0.0, 0.0, 0.0), _e251, metal::bool4(_e249 > 0.0));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_12 = {};
    metal::float2 _e34 = _uv_1;
    param_12 = _e34;
    metal::float4 _e35 = transition(param_12, _from, _sampler, _to, uniforms);
    _fragColor = _e35;
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
