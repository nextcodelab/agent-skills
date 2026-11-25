// WhipTilt — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WhipTilt.glsl
// Author: gre
// License: MIT
// Description: The camera tilts fast from the outgoing image to the incoming one, set edge to edge at an angle above it, streaking both in perspective with a vertical motion blur
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int down;
    float blur;
    float chroma;
    float perspective;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e39 = uv[0u];
    float _e41 = uv[1u];
    metal::float4 _e44 = _from.sample(_sampler, metal::float2(_e39, 1.0 - _e41), metal::level(0.0));
    return _e44;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e39 = uv_1[0u];
    float _e41 = uv_1[1u];
    metal::float4 _e44 = _to.sample(_sampler, metal::float2(_e39, 1.0 - _e41), metal::level(0.0));
    return _e44;
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 m = {};
    metal::float2 _e39 = v;
    metal::float2 _e40 = metal::float2(2.0);
    m = _e39 - (metal::floor(_e39 / _e40) * _e40);
    metal::float2 _e45 = m;
    metal::float2 _e46 = m;
    metal::float2 _e49 = m;
    return metal::mix(_e45, metal::float2(2.0) - _e46, metal::step(metal::float2(1.0), _e49));
}

float tilt(
    thread float& t
) {
    float h = {};
    float e = {};
    float local = {};
    float _e41 = t;
    h = 1.0 - metal::abs((2.0 * _e41) - 1.0);
    float _e46 = h;
    float _e48 = h;
    float _e50 = h;
    float _e52 = h;
    e = (((0.5 * _e46) * _e48) * _e50) * _e52;
    float _e54 = t;
    if (_e54 < 0.5) {
        float _e56 = e;
        local = _e56;
    } else {
        float _e57 = e;
        local = 1.0 - _e57;
    }
    float _e59 = local;
    return _e59;
}

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e39 = p;
    p3_ = metal::fract(_e39.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e43 = p3_;
    metal::float3 _e44 = p3_;
    metal::float3 _e49 = p3_;
    p3_ = _e49 + metal::float3(metal::dot(_e43, _e44.yzx + metal::float3(33.33)));
    float _e53 = p3_[0u];
    float _e55 = p3_[1u];
    float _e58 = p3_[2u];
    return metal::fract((_e53 + _e55) * _e58);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_1 = {};
    float h_1 = {};
    float shutter = {};
    float halfFov = {};
    float dist = {};
    metal::float2 q = {};
    float jitter = {};
    metal::float2 param = {};
    metal::float3 color = {};
    metal::float3 weight = {};
    float alpha = {};
    int i = {};
    float s = {};
    float t_1 = {};
    float a = {};
    float param_1 = {};
    metal::float2 r = {};
    float c0_ = {};
    float s0_ = {};
    metal::float2 d0_ = {};
    float b = {};
    float c1_ = {};
    float s1_ = {};
    metal::float2 d1_ = {};
    bool incoming = {};
    metal::float2 d = {};
    metal::float2 hit = {};
    metal::float2 suv = {};
    metal::float2 param_2 = {};
    metal::float4 col = {};
    metal::float4 local_1 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float3 w = {};
    float _e73 = uniforms.progress;
    p_1 = _e73;
    float _e74 = p_1;
    h_1 = 1.0 - metal::abs((2.0 * _e74) - 1.0);
    float _e80 = uniforms.blur;
    float _e82 = h_1;
    float _e84 = h_1;
    shutter = ((_e80 * 0.25) * _e82) * _e84;
    float _e87 = uniforms.perspective;
    halfFov = (metal::mix(15.0, 45.0, _e87) * 3.1415927) / 180.0;
    float _e91 = halfFov;
    dist = 0.5 / metal::tan(_e91);
    metal::float2 _e94 = uv_2;
    float _e98 = uniforms.ratio;
    q = (_e94 - metal::float2(0.5)) * metal::float2(_e98, 1.0);
    int _e102 = uniforms.down;
    if (_e102 != 0) {
        float _e105 = q[1u];
        q[1u] = -(_e105);
    }
    metal::float2 _e108 = uv_2;
    float _e110 = uniforms.ratio;
    param = (_e108 * metal::float2(_e110, 1.0)) * 731.0;
    float _e114 = hash(param);
    jitter = _e114;
    color = metal::float3(0.0, 0.0, 0.0);
    weight = metal::float3(0.0, 0.0, 0.0);
    alpha = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e265 = i;
            i = as_type<int>(as_type<uint>(_e265) + as_type<uint>(1));
        }
        loop_init = false;
        int _e115 = i;
        if (_e115 < 24) {
            int _e117 = i;
            float _e119 = jitter;
            s = ((static_cast<float>(_e117) + _e119) / 24.0) - 0.5;
            float _e123 = p_1;
            float _e124 = s;
            float _e125 = shutter;
            t_1 = metal::clamp(_e123 + (_e124 * _e125), 0.0, 1.0);
            float _e129 = halfFov;
            float _e131 = t_1;
            param_1 = _e131;
            float _e132 = tilt(param_1);
            a = (2.0 * _e129) * _e132;
            metal::float2 _e134 = q;
            float _e135 = halfFov;
            float _e138 = halfFov;
            float _e139 = a;
            r = (_e134 * metal::cos(_e135)) / metal::float2(metal::cos(_e138 - _e139));
            float _e144 = a;
            c0_ = metal::cos(_e144);
            float _e146 = a;
            s0_ = metal::sin(_e146);
            float _e149 = r[1u];
            float _e150 = c0_;
            float _e152 = dist;
            float _e153 = s0_;
            float _e156 = dist;
            float _e157 = c0_;
            float _e160 = r[1u];
            float _e161 = s0_;
            d0_ = metal::float2((_e149 * _e150) + (_e152 * _e153), (_e156 * _e157) - (_e160 * _e161));
            float _e165 = a;
            float _e166 = halfFov;
            b = _e165 - (2.0 * _e166);
            float _e169 = b;
            c1_ = metal::cos(_e169);
            float _e171 = b;
            s1_ = metal::sin(_e171);
            float _e174 = r[1u];
            float _e175 = c1_;
            float _e177 = dist;
            float _e178 = s1_;
            float _e181 = dist;
            float _e182 = c1_;
            float _e185 = r[1u];
            float _e186 = s1_;
            d1_ = metal::float2((_e174 * _e175) + (_e177 * _e178), (_e181 * _e182) - (_e185 * _e186));
            float _e191 = d1_[1u];
            float _e193 = d0_[1u];
            incoming = _e191 > _e193;
            bool _e195 = incoming;
            metal::float2 _e196 = d1_;
            metal::float2 _e197 = d0_;
            d = metal::select(_e197, _e196, metal::bool2(_e195));
            float _e200 = dist;
            float _e202 = d[1u];
            float _e205 = r[0u];
            float _e207 = d[0u];
            hit = metal::float2(_e205, _e207) * (_e200 / _e202);
            int _e211 = uniforms.down;
            if (_e211 != 0) {
                float _e214 = hit[1u];
                hit[1u] = -(_e214);
            }
            metal::float2 _e217 = hit;
            float _e219 = uniforms.ratio;
            param_2 = (_e217 / metal::float2(_e219, 1.0)) + metal::float2(0.5);
            metal::float2 _e224 = mirror(param_2);
            suv = _e224;
            bool _e225 = incoming;
            if (_e225) {
                metal::float2 _e226 = suv;
                param_3 = _e226;
                metal::float4 _e227 = getToColor(param_3, _sampler, _to);
                local_1 = _e227;
            } else {
                metal::float2 _e228 = suv;
                param_4 = _e228;
                metal::float4 _e229 = getFromColor(param_4, _from, _sampler);
                local_1 = _e229;
            }
            metal::float4 _e230 = local_1;
            col = _e230;
            float _e232 = uniforms.chroma;
            float _e234 = s;
            float _e238 = uniforms.chroma;
            float _e240 = s;
            w = metal::max(metal::float3(1.0 - ((4.0 * _e232) * _e234), 1.0, 1.0 + ((4.0 * _e238) * _e240)), metal::float3(0.0));
            metal::float4 _e246 = col;
            float _e249 = col[3u];
            metal::float3 _e251 = w;
            metal::float3 _e253 = color;
            color = _e253 + ((_e246.xyz * _e249) * _e251);
            float _e256 = col[3u];
            metal::float3 _e257 = w;
            metal::float3 _e259 = weight;
            weight = _e259 + (_e257 * _e256);
            float _e262 = col[3u];
            float _e263 = alpha;
            alpha = _e263 + _e262;
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e267 = color;
    metal::float3 _e268 = weight;
    metal::float3 _e270 = _e267 / metal::max(_e268, metal::float3(0.00001, 0.00001, 0.00001));
    float _e271 = alpha;
    return metal::float4(_e270.x, _e270.y, _e270.z, _e271 / 24.0);
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
    metal::float2 _e38 = _uv_1;
    param_5 = _e38;
    metal::float4 _e39 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e39;
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
