// Prisms — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Prisms.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into 3D prisms that turn in a cascade, like a rotating billboard, from the outgoing image on one face to the incoming one on the next
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int slats;
    float stagger;
    float perspective;
    float shading;
    int horizontal;
    char _pad7[4];
    metal::float4 backColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n = {};
    float a = {};
    float local = {};
    float b = {};
    float local_1 = {};
    float hw = {};
    float local_2 = {};
    float k = {};
    float bScale = {};
    float local_3 = {};
    metal::float4 near1_ = {};
    metal::float4 near2_ = {};
    float cover1_ = {};
    float cover2_ = {};
    float z1_ = {};
    float z2_ = {};
    int d = {};
    float i = {};
    float order = {};
    float local_4 = {};
    float t = {};
    float c = {};
    float s = {};
    float edge = {};
    float x = {};
    int f = {};
    float cf = {};
    float u = {};
    float local_5 = {};
    float z = {};
    float local_6 = {};
    float scale = {};
    float y = {};
    float outer = {};
    float local_7 = {};
    float cover = {};
    float sa = {};
    metal::float2 p = {};
    metal::float2 local_8 = {};
    metal::float4 img = {};
    metal::float4 local_9 = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float lambert = {};
    float local_10 = {};
    metal::float4 color = {};
    bool phi_168_ = {};
    int _e81 = uniforms.slats;
    n = static_cast<float>(_e81);
    int _e84 = uniforms.horizontal;
    if (_e84 != 0) {
        float _e87 = uv_2[1u];
        local = _e87;
    } else {
        float _e89 = uv_2[0u];
        local = _e89;
    }
    float _e90 = local;
    a = _e90;
    int _e92 = uniforms.horizontal;
    if (_e92 != 0) {
        float _e95 = uv_2[0u];
        local_1 = _e95;
    } else {
        float _e97 = uv_2[1u];
        local_1 = _e97;
    }
    float _e98 = local_1;
    b = _e98;
    float _e99 = n;
    int _e102 = uniforms.horizontal;
    if (_e102 != 0) {
        local_2 = 1.0;
    } else {
        float _e105 = uniforms.ratio;
        local_2 = _e105;
    }
    float _e106 = local_2;
    hw = (0.5 / _e99) * _e106;
    float _e109 = uniforms.perspective;
    float _e110 = hw;
    k = metal::min(_e109 * _e110, 0.5);
    int _e114 = uniforms.horizontal;
    if (_e114 != 0) {
        float _e117 = uniforms.ratio;
        local_3 = _e117;
    } else {
        local_3 = 1.0;
    }
    float _e118 = local_3;
    bScale = _e118;
    near1_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    near2_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    cover1_ = 0.0;
    cover2_ = 0.0;
    z1_ = -2.0;
    z2_ = -2.0;
    d = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e338 = d;
            d = as_type<int>(as_type<uint>(_e338) + as_type<uint>(1));
        }
        loop_init = false;
        int _e119 = d;
        if (_e119 <= 1) {
            float _e121 = a;
            float _e122 = n;
            int _e125 = d;
            i = metal::floor(_e121 * _e122) + static_cast<float>(_e125);
            float _e128 = i;
            bool _e129 = _e128 < 0.0;
            phi_168_ = _e129;
            if (!(_e129)) {
                float _e131 = i;
                float _e132 = n;
                phi_168_ = _e131 > (_e132 - 1.0);
            }
            bool _e136 = phi_168_;
            if (_e136) {
                continue;
            }
            int _e138 = uniforms.horizontal;
            if (_e138 != 0) {
                float _e140 = n;
                float _e142 = i;
                local_4 = (_e140 - 1.0) - _e142;
            } else {
                float _e144 = i;
                local_4 = _e144;
            }
            float _e145 = local_4;
            float _e146 = n;
            order = _e145 / (_e146 - 1.0);
            float _e150 = uniforms.progress;
            float _e152 = uniforms.stagger;
            float _e153 = order;
            float _e157 = uniforms.stagger;
            t = metal::clamp((_e150 - (_e152 * _e153)) / (1.0 - _e157), 0.0, 1.0);
            float _e161 = t;
            float _e162 = t;
            float _e163 = t;
            float _e165 = t;
            t = metal::mix(_e161, (_e162 * _e163) * (3.0 - (2.0 * _e165)), 0.7);
            float _e170 = t;
            c = metal::cos(1.5707964 * _e170);
            float _e173 = t;
            s = metal::sin(1.5707964 * _e173);
            float _e176 = s;
            float _e178 = c;
            edge = (0.002 * metal::min(1.0, (20.0 * _e176) * _e178)) + 0.000001;
            float _e183 = a;
            float _e184 = n;
            float _e186 = i;
            x = (2.0 * ((_e183 * _e184) - _e186)) - 1.0;
            f = 0;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e336 = f;
                    f = as_type<int>(as_type<uint>(_e336) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e190 = f;
                if (_e190 < 2) {
                    int _e192 = f;
                    float _e194 = c;
                    float _e195 = s;
                    cf = (_e192 == 0) ? _e194 : _e195;
                    float _e197 = cf;
                    if (_e197 < 0.0001) {
                        continue;
                    }
                    int _e199 = f;
                    if (_e199 == 0) {
                        float _e201 = x;
                        float _e202 = s;
                        float _e204 = c;
                        local_5 = (_e201 + _e202) / _e204;
                    } else {
                        float _e206 = x;
                        float _e207 = c;
                        float _e209 = s;
                        local_5 = (_e206 - _e207) / _e209;
                    }
                    float _e211 = local_5;
                    u = _e211;
                    int _e212 = f;
                    if (_e212 == 0) {
                        float _e214 = u;
                        float _e215 = s;
                        float _e217 = c;
                        local_6 = (_e214 * _e215) + _e217;
                    } else {
                        float _e219 = s;
                        float _e220 = u;
                        float _e221 = c;
                        local_6 = _e219 - (_e220 * _e221);
                    }
                    float _e224 = local_6;
                    z = _e224;
                    float _e225 = u;
                    float _e228 = z;
                    float _e229 = z2_;
                    if ((metal::abs(_e225) > 1.0) || (_e228 <= _e229)) {
                        continue;
                    }
                    float _e232 = k;
                    float _e233 = z;
                    scale = 1.0 - (_e232 * (_e233 - 1.0));
                    float _e237 = b;
                    float _e239 = scale;
                    y = ((_e237 - 0.5) * _e239) + 0.5;
                    float _e242 = y;
                    float _e244 = y;
                    if ((_e242 < 0.0) || (_e244 > 1.0)) {
                        continue;
                    }
                    int _e247 = f;
                    if (_e247 == 0) {
                        float _e249 = u;
                        local_7 = 1.0 + _e249;
                    } else {
                        float _e251 = u;
                        local_7 = 1.0 - _e251;
                    }
                    float _e253 = local_7;
                    outer = _e253;
                    float _e254 = outer;
                    float _e255 = hw;
                    float _e257 = cf;
                    float _e259 = edge;
                    float _e262 = y;
                    float _e263 = y;
                    float _e266 = bScale;
                    float _e268 = scale;
                    float _e270 = edge;
                    cover = metal::clamp(((_e254 * _e255) * _e257) / _e259, 0.0, 1.0) * metal::clamp(((metal::min(_e262, 1.0 - _e263) * _e266) / _e268) / _e270, 0.0, 1.0);
                    float _e274 = i;
                    float _e276 = u;
                    float _e279 = n;
                    sa = ((_e274 + 0.5) + (0.5 * _e276)) / _e279;
                    int _e282 = uniforms.horizontal;
                    if (_e282 != 0) {
                        float _e284 = y;
                        float _e285 = sa;
                        local_8 = metal::float2(_e284, _e285);
                    } else {
                        float _e287 = sa;
                        float _e288 = y;
                        local_8 = metal::float2(_e287, _e288);
                    }
                    metal::float2 _e290 = local_8;
                    p = _e290;
                    int _e291 = f;
                    if (_e291 == 0) {
                        metal::float2 _e293 = p;
                        param = _e293;
                        metal::float4 _e294 = getFromColor(param, _from, _sampler);
                        local_9 = _e294;
                    } else {
                        metal::float2 _e295 = p;
                        param_1 = _e295;
                        metal::float4 _e296 = getToColor(param_1, _sampler, _to);
                        local_9 = _e296;
                    }
                    metal::float4 _e297 = local_9;
                    img = _e297;
                    int _e298 = f;
                    if (_e298 == 0) {
                        float _e300 = c;
                        float _e301 = s;
                        local_10 = _e300 - (0.6 * _e301);
                    } else {
                        float _e304 = s;
                        float _e305 = c;
                        local_10 = _e304 + (0.6 * _e305);
                    }
                    float _e308 = local_10;
                    lambert = metal::clamp(_e308, 0.0, 1.0);
                    metal::float4 _e310 = img;
                    float _e313 = uniforms.shading;
                    float _e315 = lambert;
                    metal::float3 _e317 = _e310.xyz * metal::mix(1.0 - _e313, 1.0, _e315);
                    float _e319 = img[3u];
                    color = metal::float4(_e317.x, _e317.y, _e317.z, _e319);
                    float _e324 = z;
                    float _e325 = z1_;
                    if (_e324 > _e325) {
                        metal::float4 _e327 = near1_;
                        near2_ = _e327;
                        float _e328 = cover1_;
                        cover2_ = _e328;
                        float _e329 = z1_;
                        z2_ = _e329;
                        metal::float4 _e330 = color;
                        near1_ = _e330;
                        float _e331 = cover;
                        cover1_ = _e331;
                        float _e332 = z;
                        z1_ = _e332;
                    } else {
                        metal::float4 _e333 = color;
                        near2_ = _e333;
                        float _e334 = cover;
                        cover2_ = _e334;
                        float _e335 = z;
                        z2_ = _e335;
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
    metal::float4 _e341 = uniforms.backColor;
    metal::float4 _e342 = near2_;
    float _e343 = cover2_;
    metal::float4 _e346 = near1_;
    float _e347 = cover1_;
    return metal::mix(metal::mix(_e341, _e342, metal::float4(_e343)), _e346, metal::float4(_e347));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_2 = {};
    metal::float2 _e34 = _uv_1;
    param_2 = _e34;
    metal::float4 _e35 = transition(param_2, _from, _sampler, _to, uniforms);
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
