// Funnel — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Funnel.glsl
// Author: gre
// License: MIT
// Description: The outgoing image narrows into a curved funnel toward a point on the bottom edge and slides into it, its sides bending like a window minimized into a dock, revealing the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float target;
    float curvature;
    float shadow;
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
    float t = {};
    float f = {};
    float slide = {};
    float r = {};
    float nh = {};
    float tx = {};
    float c = {};
    float q = {};
    float w = {};
    float dw = {};
    float L = {};
    float R = {};
    float dL = {};
    float dR = {};
    float v = {};
    float e = {};
    float left = {};
    float local = {};
    float right = {};
    float local_1 = {};
    float cov = {};
    metal::float4 img = {};
    float s = {};
    float width = {};
    metal::float2 src = {};
    metal::float2 param = {};
    float across = {};
    metal::float4 bg = {};
    metal::float2 param_1 = {};
    float ox = {};
    float oy = {};
    float dist = {};
    float _e67 = uniforms.progress;
    t = _e67;
    float _e68 = t;
    float _e70 = t;
    float _e73 = t;
    f = metal::smoothstep(0.0, 1.0, 1.0 - (((1.0 - _e68) * (1.0 - _e70)) * (1.0 - _e73)));
    float _e78 = t;
    float _e80 = t;
    float _e82 = t;
    slide = ((1.03 * _e78) * _e80) * (1.5 - (0.5 * _e82));
    float _e87 = uniforms.ratio;
    r = metal::max(_e87, 0.0001);
    float _e89 = r;
    nh = 0.02 / _e89;
    float _e92 = uniforms.target;
    float _e93 = nh;
    float _e94 = nh;
    tx = metal::clamp(_e92, _e93, 1.0 - _e94);
    float _e98 = uniforms.curvature;
    c = metal::clamp(_e98, 0.0, 1.0);
    float _e101 = uv_2[1u];
    q = metal::clamp(_e101, 0.0, 1.0);
    float _e103 = q;
    float _e104 = q;
    float _e105 = q;
    float _e107 = q;
    float _e111 = c;
    w = metal::mix(_e103, (_e104 * _e105) * (3.0 - (2.0 * _e107)), _e111);
    float _e113 = q;
    float _e115 = q;
    float _e118 = c;
    dw = metal::mix(1.0, (6.0 * _e113) * (1.0 - _e115), _e118);
    float _e120 = f;
    float _e121 = tx;
    float _e122 = nh;
    float _e124 = w;
    L = _e120 * metal::mix(_e121 - _e122, 0.0, _e124);
    float _e127 = f;
    float _e128 = tx;
    float _e129 = nh;
    float _e131 = w;
    R = 1.0 - (_e127 * (1.0 - metal::mix(_e128 + _e129, 1.0, _e131)));
    float _e136 = f;
    float _e138 = tx;
    float _e139 = nh;
    float _e142 = dw;
    dL = (-(_e136) * (_e138 - _e139)) * _e142;
    float _e144 = f;
    float _e145 = tx;
    float _e147 = nh;
    float _e150 = dw;
    dR = (_e144 * ((1.0 - _e145) - _e147)) * _e150;
    float _e153 = uv_2[1u];
    float _e154 = slide;
    v = _e153 + _e154;
    float _e156 = t;
    e = (0.0015 * metal::min(1.0, 10.0 * _e156)) + 0.000001;
    float _e161 = L;
    if (_e161 > 0.0) {
        float _e164 = uv_2[0u];
        float _e165 = L;
        float _e167 = r;
        float _e169 = dL;
        float _e170 = dL;
        float _e172 = r;
        float _e174 = r;
        local = ((_e164 - _e165) * _e167) / metal::sqrt(1.0 + (((_e169 * _e170) * _e172) * _e174));
    } else {
        local = 1.0;
    }
    float _e179 = local;
    left = _e179;
    float _e180 = R;
    if (_e180 < 1.0) {
        float _e182 = R;
        float _e184 = uv_2[0u];
        float _e186 = r;
        float _e188 = dR;
        float _e189 = dR;
        float _e191 = r;
        float _e193 = r;
        local_1 = ((_e182 - _e184) * _e186) / metal::sqrt(1.0 + (((_e188 * _e189) * _e191) * _e193));
    } else {
        local_1 = 1.0;
    }
    float _e198 = local_1;
    right = _e198;
    float _e199 = left;
    float _e200 = right;
    float _e202 = v;
    float _e205 = e;
    cov = metal::clamp((metal::min(metal::min(_e199, _e200), 1.0 - _e202) / _e205) + 0.5, 0.0, 1.0);
    img = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e210 = uniforms.shadow;
    s = metal::clamp(_e210, 0.0, 1.0);
    float _e212 = cov;
    if (_e212 > 0.0) {
        float _e214 = R;
        float _e215 = L;
        width = _e214 - _e215;
        float _e218 = uv_2[0u];
        float _e219 = L;
        float _e221 = width;
        float _e223 = v;
        src = metal::clamp(metal::float2((_e218 - _e219) / _e221, _e223), metal::float2(0.0), metal::float2(1.0));
        metal::float2 _e228 = src;
        param = _e228;
        metal::float4 _e229 = getFromColor(param, _from, _sampler);
        img = _e229;
        float _e231 = src[0u];
        across = (2.0 * _e231) - 1.0;
        float _e234 = s;
        float _e235 = width;
        float _e238 = across;
        float _e240 = across;
        float _e242 = w;
        metal::float4 _e248 = img;
        metal::float3 _e250 = _e248.xyz * (1.0 - ((_e234 * (1.0 - _e235)) * (((0.5 * _e238) * _e240) + (0.3 * (1.0 - _e242)))));
        img[0u] = _e250.x;
        img[1u] = _e250.y;
        img[2u] = _e250.z;
        float _e257 = cov;
        if (_e257 >= 1.0) {
            metal::float4 _e259 = img;
            return _e259;
        }
    }
    metal::float2 _e260 = uv_2;
    param_1 = _e260;
    metal::float4 _e261 = getToColor(param_1, _sampler, _to);
    bg = _e261;
    float _e262 = L;
    float _e264 = uv_2[0u];
    float _e267 = uv_2[0u];
    float _e268 = R;
    float _e271 = r;
    ox = metal::max(_e262 - _e264, _e267 - _e268) * _e271;
    float _e274 = uv_2[1u];
    float _e275 = slide;
    oy = _e274 - (1.0 - _e275);
    float _e278 = ox;
    float _e279 = oy;
    dist = metal::length(metal::max(metal::float2(_e278, _e279), metal::float2(0.0)));
    float _e284 = s;
    float _e286 = f;
    float _e288 = t;
    float _e291 = dist;
    metal::float4 _e296 = bg;
    metal::float3 _e298 = _e296.xyz * (1.0 - ((((_e284 * 0.6) * _e286) * (1.0 - _e288)) * (1.0 - metal::smoothstep(0.0, 0.06, _e291))));
    bg[0u] = _e298.x;
    bg[1u] = _e298.y;
    bg[2u] = _e298.z;
    metal::float4 _e305 = bg;
    metal::float4 _e306 = img;
    float _e307 = cov;
    return metal::mix(_e305, _e306, metal::float4(_e307));
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
