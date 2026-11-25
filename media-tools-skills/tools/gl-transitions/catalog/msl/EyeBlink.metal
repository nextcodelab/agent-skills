// EyeBlink — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/EyeBlink.glsl
// Author: gre
// License: MIT
// Description: Curved eyelids close from the top and bottom over the outgoing image, which blurs and dims, then open on the incoming image as it comes back into focus, as if the viewer blinked
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float blur;
    float softness;
    int blinks;
    char _pad5[12];
    metal::float4 color;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e43 = uv[0u];
    float _e45 = uv[1u];
    metal::float4 _e48 = _from.sample(_sampler, metal::float2(_e43, 1.0 - _e45), metal::level(0.0));
    return _e48;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e43 = uv_1[0u];
    float _e45 = uv_1[1u];
    metal::float4 _e48 = _to.sample(_sampler, metal::float2(_e43, 1.0 - _e45), metal::level(0.0));
    return _e48;
}

metal::float4 image(
    thread metal::float2& uv_2,
    thread bool& incoming,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float4 c = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool _e47 = incoming;
    if (_e47) {
        metal::float2 _e48 = uv_2;
        param = _e48;
        metal::float4 _e49 = getToColor(param, _sampler, _to);
        local = _e49;
    } else {
        metal::float2 _e50 = uv_2;
        param_1 = _e50;
        metal::float4 _e51 = getFromColor(param_1, _from, _sampler);
        local = _e51;
    }
    metal::float4 _e52 = local;
    c = _e52;
    metal::float4 _e53 = c;
    float _e56 = c[3u];
    metal::float3 _e57 = _e53.xyz * _e56;
    float _e59 = c[3u];
    return metal::float4(_e57.x, _e57.y, _e57.z, _e59);
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e42 = v;
    metal::float2 _e43 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e42 - (metal::floor(_e42 / _e43) * _e43)));
}

float lidBlink(
    thread float& t,
    thread float& c_1,
    thread float& wc,
    thread float& wo,
    thread float& hold
) {
    float _e46 = hold;
    float _e47 = t;
    float _e48 = c_1;
    float _e50 = wc;
    float _e51 = wo;
    float _e53 = t;
    float _e54 = c_1;
    return 1.0 - metal::smoothstep(_e46, (_e47 < _e48) ? _e50 : _e51, metal::abs(_e53 - _e54));
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    bool two = {};
    float cut = {};
    float closed = {};
    float local_1 = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    bool incoming_1 = {};
    float soft = {};
    float x = {};
    float rim = {};
    float y = {};
    float d = {};
    float s = {};
    float lid = {};
    float f = {};
    float local_2 = {};
    metal::float4 c_2 = {};
    metal::float4 local_3 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    float r = {};
    int i = {};
    float k = {};
    float a = {};
    metal::float2 o = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    bool param_21 = {};
    metal::float4 local_4 = {};
    int _e85 = uniforms.blinks;
    two = _e85 > 1;
    bool _e87 = two;
    cut = _e87 ? 0.3 : 0.42;
    bool _e89 = two;
    if (_e89) {
        float _e91 = uniforms.progress;
        param_2 = _e91;
        float _e92 = cut;
        param_3 = _e92;
        param_4 = 0.26;
        param_5 = 0.26;
        param_6 = 0.015;
        float _e93 = lidBlink(param_2, param_3, param_4, param_5, param_6);
        float _e95 = uniforms.progress;
        param_7 = _e95;
        param_8 = 0.7;
        param_9 = 0.14;
        param_10 = 0.24;
        param_11 = 0.01;
        float _e96 = lidBlink(param_7, param_8, param_9, param_10, param_11);
        local_1 = metal::max(_e93, _e96);
    } else {
        float _e99 = uniforms.progress;
        param_12 = _e99;
        float _e100 = cut;
        param_13 = _e100;
        param_14 = 0.36;
        param_15 = 0.5;
        param_16 = 0.02;
        float _e101 = lidBlink(param_12, param_13, param_14, param_15, param_16);
        local_1 = _e101;
    }
    float _e102 = local_1;
    closed = _e102;
    float _e104 = uniforms.progress;
    float _e105 = cut;
    incoming_1 = _e104 >= _e105;
    float _e108 = uniforms.softness;
    soft = metal::clamp(_e108, 0.001, 0.3);
    float _e111 = uv_3[0u];
    x = (2.0 * _e111) - 1.0;
    float _e114 = closed;
    float _e117 = x;
    float _e119 = x;
    rim = ((1.0 - _e114) * 1.56) - ((0.25 * _e117) * _e119);
    float _e123 = uv_3[1u];
    y = _e123 - 0.44;
    float _e125 = rim;
    float _e126 = y;
    float _e128 = y;
    d = _e125 - metal::max(_e126 / 0.56, -(_e128) / 0.44);
    float _e133 = soft;
    float _e134 = d;
    s = 1.0 - metal::smoothstep(0.0, _e133, _e134);
    float _e137 = s;
    float _e138 = s;
    lid = _e137 * _e138;
    float _e140 = lid;
    if (_e140 >= 1.0) {
        metal::float4 _e143 = uniforms.color;
        return _e143;
    }
    float _e145 = uniforms.progress;
    float _e146 = cut;
    if (_e145 < _e146) {
        float _e149 = uniforms.progress;
        float _e150 = cut;
        local_2 = _e149 / _e150;
    } else {
        float _e153 = uniforms.progress;
        float _e155 = cut;
        local_2 = (1.0 - _e153) / (1.0 - _e155);
    }
    float _e158 = local_2;
    f = _e158;
    float _e159 = f;
    f = metal::clamp(_e159, 0.0, 1.0);
    float _e161 = f;
    float _e162 = f;
    float _e165 = closed;
    float _e168 = uniforms.blur;
    f = metal::max(_e161 * (2.0 - _e162), _e165) * _e168;
    float _e170 = f;
    if (_e170 <= 0.0) {
        bool _e172 = incoming_1;
        if (_e172) {
            metal::float2 _e173 = uv_3;
            param_17 = _e173;
            metal::float4 _e174 = getToColor(param_17, _sampler, _to);
            local_3 = _e174;
        } else {
            metal::float2 _e175 = uv_3;
            param_18 = _e175;
            metal::float4 _e176 = getFromColor(param_18, _from, _sampler);
            local_3 = _e176;
        }
        metal::float4 _e177 = local_3;
        c_2 = _e177;
    } else {
        float _e178 = f;
        r = 0.025 * _e178;
        c_2 = metal::float4(0.0, 0.0, 0.0, 0.0);
        i = 0;
        uint2 loop_bound = uint2(4294967295u);
        bool loop_init = true;
        while(true) {
            if (metal::all(loop_bound == uint2(0u))) { break; }
            loop_bound -= uint2(loop_bound.y == 0u, 1u);
            if (!loop_init) {
                int _e211 = i;
                i = as_type<int>(as_type<uint>(_e211) + as_type<uint>(1));
            }
            loop_init = false;
            int _e180 = i;
            if (_e180 < 16) {
                int _e182 = i;
                k = static_cast<float>(_e182) + 0.5;
                float _e185 = k;
                a = 2.39996 * _e185;
                float _e187 = k;
                float _e190 = a;
                float _e192 = a;
                float _e196 = r;
                o = (metal::float2(metal::cos(_e190), metal::sin(_e192)) * metal::sqrt(_e187 / 16.0)) * _e196;
                metal::float2 _e198 = uv_3;
                metal::float2 _e199 = o;
                float _e201 = uniforms.ratio;
                param_19 = _e198 + (_e199 * metal::float2(1.0 / _e201, 1.0));
                metal::float2 _e206 = mirror(param_19);
                param_20 = _e206;
                bool _e207 = incoming_1;
                param_21 = _e207;
                metal::float4 _e208 = image(param_20, param_21, _from, _sampler, _to);
                metal::float4 _e209 = c_2;
                c_2 = _e209 + _e208;
                continue;
            } else {
                break;
            }
        }
        metal::float4 _e213 = c_2;
        c_2 = _e213 / metal::float4(16.0);
        float _e217 = c_2[3u];
        if (_e217 > 0.0) {
            metal::float4 _e219 = c_2;
            float _e222 = c_2[3u];
            metal::float3 _e224 = _e219.xyz / metal::float3(_e222);
            float _e226 = c_2[3u];
            local_4 = metal::float4(_e224.x, _e224.y, _e224.z, _e226);
        } else {
            local_4 = metal::float4(0.0, 0.0, 0.0, 0.0);
        }
        metal::float4 _e231 = local_4;
        c_2 = _e231;
        float _e232 = f;
        metal::float4 _e235 = c_2;
        metal::float3 _e237 = _e235.xyz * (1.0 - (0.35 * _e232));
        c_2[0u] = _e237.x;
        c_2[1u] = _e237.y;
        c_2[2u] = _e237.z;
    }
    metal::float4 _e244 = c_2;
    metal::float4 _e246 = uniforms.color;
    float _e247 = lid;
    return metal::mix(_e244, _e246, metal::float4(_e247));
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
    metal::float2 _e42 = _uv_1;
    param_22 = _e42;
    metal::float4 _e43 = transition(param_22, _from, _sampler, _to, uniforms);
    _fragColor = _e43;
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
