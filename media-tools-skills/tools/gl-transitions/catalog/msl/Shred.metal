// Shred — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Shred.glsl
// Author: gre
// License: MIT
// Description: The outgoing image is cut into paper strips that drop away at uneven speeds, tilting as they fall, revealing the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int strips;
    float stagger;
    float tilt;
    float shadow;
};

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

float hash(
    thread float& n
) {
    float _e34 = n;
    n = metal::fract(_e34 * 0.1031);
    float _e37 = n;
    float _e39 = n;
    n = _e39 * (_e37 + 33.33);
    float _e41 = n;
    float _e42 = n;
    float _e44 = n;
    n = _e44 * (_e41 + _e42);
    float _e46 = n;
    return metal::fract(_e46);
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

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n_1 = {};
    float w = {};
    metal::float2 q = {};
    metal::float4 color = {};
    metal::float2 param = {};
    float cover = {};
    float shade = {};
    float maxTilt = {};
    int d = {};
    float i = {};
    float delay = {};
    float param_1 = {};
    float speed = {};
    float param_2 = {};
    float t = {};
    float fall = {};
    float angle = {};
    float param_3 = {};
    float lift = {};
    float gap = {};
    metal::float2 v = {};
    float ca = {};
    float sa = {};
    metal::float2 l = {};
    metal::float2 edge = {};
    metal::float2 so = {};
    metal::float2 p = {};
    metal::float4 img = {};
    metal::float2 param_4 = {};
    float cut = {};
    bool phi_152_ = {};
    int _e65 = uniforms.strips;
    n_1 = static_cast<float>(_e65);
    float _e68 = uniforms.ratio;
    float _e69 = n_1;
    w = _e68 / _e69;
    float _e72 = uv_2[0u];
    float _e74 = uniforms.ratio;
    float _e77 = uv_2[1u];
    q = metal::float2(_e72 * _e74, _e77);
    metal::float2 _e79 = uv_2;
    param = _e79;
    metal::float4 _e80 = getToColor(param, _sampler, _to);
    color = _e80;
    cover = -1.0;
    shade = 0.0;
    float _e82 = uniforms.tilt;
    float _e83 = w;
    maxTilt = metal::min(_e82, 2.0 * _e83);
    d = -3;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e282 = d;
            d = as_type<int>(as_type<uint>(_e282) + as_type<uint>(1));
        }
        loop_init = false;
        int _e86 = d;
        if (_e86 <= 3) {
            float _e89 = uv_2[0u];
            float _e90 = n_1;
            int _e93 = d;
            i = metal::floor(_e89 * _e90) + static_cast<float>(_e93);
            float _e96 = i;
            bool _e97 = _e96 < 0.0;
            phi_152_ = _e97;
            if (!(_e97)) {
                float _e99 = i;
                float _e100 = n_1;
                phi_152_ = _e99 > (_e100 - 1.0);
            }
            bool _e104 = phi_152_;
            if (_e104) {
                continue;
            }
            float _e106 = uniforms.stagger;
            float _e107 = i;
            param_1 = _e107 + 1.0;
            float _e109 = hash(param_1);
            delay = _e106 * metal::max(0.0, (1.25 * _e109) - 0.25);
            float _e114 = i;
            param_2 = _e114 + 71.0;
            float _e116 = hash(param_2);
            speed = 1.0 + (0.5 * _e116);
            float _e120 = uniforms.progress;
            float _e121 = delay;
            float _e123 = delay;
            t = metal::clamp((_e120 - _e121) / (1.0 - _e123), 0.0, 1.0);
            float _e127 = t;
            float _e129 = t;
            float _e131 = t;
            float _e134 = w;
            float _e136 = uniforms.tilt;
            float _e141 = speed;
            fall = (((0.4 * _e127) + ((0.6 * _e129) * _e131)) * (1.0 + (_e134 * (0.5 + _e136)))) * _e141;
            float _e143 = maxTilt;
            float _e144 = i;
            param_3 = _e144 + 37.0;
            float _e146 = hash(param_3);
            float _e150 = t;
            angle = (_e143 * ((2.0 * _e146) - 1.0)) * _e150;
            float _e152 = t;
            lift = metal::min(1.0, 8.0 * _e152);
            float _e155 = w;
            float _e157 = lift;
            gap = (0.06 * _e155) * _e157;
            metal::float2 _e159 = q;
            float _e160 = i;
            float _e162 = w;
            float _e164 = fall;
            v = _e159 - metal::float2((_e160 + 0.5) * _e162, 0.5 - _e164);
            float _e168 = angle;
            ca = metal::cos(_e168);
            float _e170 = angle;
            sa = metal::sin(_e170);
            float _e172 = ca;
            float _e174 = v[0u];
            float _e176 = sa;
            float _e178 = v[1u];
            float _e181 = ca;
            float _e183 = v[1u];
            float _e185 = sa;
            float _e187 = v[0u];
            l = metal::float2((_e172 * _e174) + (_e176 * _e178), (_e181 * _e183) - (_e185 * _e187));
            float _e191 = w;
            float _e193 = gap;
            metal::float2 _e196 = l;
            edge = metal::float2((0.5 * _e191) - _e193, 0.5) - metal::abs(_e196);
            metal::float2 _e199 = l;
            float _e200 = lift;
            float _e201 = w;
            float _e203 = w;
            float _e209 = w;
            float _e211 = gap;
            so = metal::abs(_e199 - (metal::float2(0.15 * _e201, -0.25 * _e203) * _e200)) - metal::float2((0.5 * _e209) - _e211, 0.5);
            float _e215 = shade;
            float _e216 = lift;
            float _e217 = w;
            float _e220 = so[0u];
            float _e222 = so[1u];
            shade = metal::max(_e215, _e216 * (1.0 - metal::smoothstep(0.0, 0.5 * _e217, metal::max(_e220, _e222))));
            float _e229 = edge[0u];
            float _e231 = edge[1u];
            float _e234 = fall;
            float _e235 = cover;
            if ((metal::min(_e229, _e231) >= 0.0) && (_e234 > _e235)) {
                float _e238 = i;
                float _e240 = w;
                float _e243 = l[0u];
                float _e246 = l[1u];
                p = metal::float2(((_e238 + 0.5) * _e240) + _e243, 0.5 + _e246);
                float _e250 = p[0u];
                float _e252 = uniforms.ratio;
                float _e255 = p[1u];
                param_4 = metal::float2(_e250 / _e252, _e255);
                metal::float4 _e257 = getFromColor(param_4, _from, _sampler);
                img = _e257;
                float _e258 = lift;
                float _e259 = w;
                float _e262 = edge[0u];
                cut = _e258 * (1.0 - metal::smoothstep(0.0, 0.25 * _e259, _e262));
                metal::float4 _e266 = img;
                float _e269 = uniforms.shadow;
                float _e271 = cut;
                metal::float3 _e274 = _e266.xyz * (1.0 - ((0.5 * _e269) * _e271));
                float _e276 = img[3u];
                color = metal::float4(_e274.x, _e274.y, _e274.z, _e276);
                float _e281 = fall;
                cover = _e281;
            }
            continue;
        } else {
            break;
        }
    }
    float _e284 = cover;
    if (_e284 < 0.0) {
        metal::float4 _e286 = color;
        float _e289 = uniforms.shadow;
        float _e291 = shade;
        metal::float3 _e294 = _e286.xyz * (1.0 - ((0.6 * _e289) * _e291));
        float _e296 = color[3u];
        color = metal::float4(_e294.x, _e294.y, _e294.z, _e296);
    }
    metal::float4 _e301 = color;
    return _e301;
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
    metal::float2 _e34 = _uv_1;
    param_5 = _e34;
    metal::float4 _e35 = transition(param_5, _from, _sampler, _to, uniforms);
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
