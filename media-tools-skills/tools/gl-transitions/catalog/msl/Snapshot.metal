// Snapshot — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Snapshot.glsl
// Author: gre
// License: MIT
// Description: A camera flash freezes the outgoing image into a printed photo with a white border, which shrinks, tilts and drops out of the frame, revealing the incoming image behind it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float tilt;
    float border;
    float flash;
    float shadow;
    char _pad6[8];
    metal::float4 borderColor;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e40 = uv[0u];
    float _e42 = uv[1u];
    metal::float4 _e45 = _from.sample(_sampler, metal::float2(_e40, 1.0 - _e42), metal::level(0.0));
    return _e45;
}

metal::float4 premultiply(
    thread metal::float4& c
) {
    metal::float4 _e39 = c;
    float _e42 = c[3u];
    metal::float3 _e43 = _e39.xyz * _e42;
    float _e45 = c[3u];
    return metal::float4(_e43.x, _e43.y, _e43.z, _e45);
}

float roundedBox(
    thread metal::float2& q,
    thread metal::float2& b,
    thread float& r
) {
    metal::float2 d = {};
    metal::float2 _e42 = q;
    metal::float2 _e44 = b;
    float _e46 = r;
    d = (metal::abs(_e42) - _e44) + metal::float2(_e46);
    metal::float2 _e49 = d;
    float _e54 = d[0u];
    float _e56 = d[1u];
    float _e60 = r;
    return (metal::length(metal::max(_e49, metal::float2(0.0))) + metal::min(metal::max(_e54, _e56), 0.0)) - _e60;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e40 = uv_1[0u];
    float _e42 = uv_1[1u];
    metal::float4 _e45 = _to.sample(_sampler, metal::float2(_e40, 1.0 - _e42), metal::level(0.0));
    return _e45;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    metal::float2 asp = {};
    metal::float2 q_1 = {};
    metal::float2 halfImage = {};
    metal::float2 halfCard = {};
    float k = {};
    float t = {};
    float fall = {};
    float s = {};
    float a = {};
    float bound = {};
    float lift = {};
    metal::float2 center = {};
    float rad = {};
    float ca = {};
    float sa = {};
    metal::float2x2 unrotate = {};
    metal::float4 col = {};
    metal::float2 param = {};
    float sh = {};
    metal::float2 rs = {};
    float ds = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    float param_3 = {};
    float blur = {};
    metal::float4 param_4 = {};
    metal::float2 r_1 = {};
    float dCard = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    float dImage = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    float cardCover = {};
    float imageCover = {};
    metal::float4 photo = {};
    metal::float2 param_11 = {};
    metal::float4 param_12 = {};
    metal::float4 paper = {};
    metal::float4 param_13 = {};
    metal::float4 card = {};
    float f = {};
    float _e85 = uniforms.progress;
    p = _e85;
    float _e87 = uniforms.ratio;
    asp = metal::float2(_e87, 1.0);
    metal::float2 _e89 = uv_2;
    metal::float2 _e92 = asp;
    q_1 = (_e89 - metal::float2(0.5)) * _e92;
    metal::float2 _e94 = asp;
    halfImage = _e94 * 0.5;
    metal::float2 _e96 = halfImage;
    float _e98 = uniforms.border;
    halfCard = _e96 + metal::float2(_e98);
    float _e101 = p;
    k = metal::smoothstep(0.05, 0.4, _e101);
    float _e103 = p;
    t = metal::clamp((_e103 - 0.3) / 0.7, 0.0, 1.0);
    float _e107 = t;
    float _e108 = t;
    fall = _e107 * _e108;
    float _e110 = k;
    s = 1.0 - (0.24 * _e110);
    float _e114 = uniforms.tilt;
    float _e116 = k;
    float _e118 = fall;
    a = -(_e114) * ((0.12 * _e116) + (0.88 * _e118));
    float _e123 = uniforms.tilt;
    float _e127 = halfCard[0u];
    float _e130 = uniforms.tilt;
    float _e134 = halfCard[1u];
    bound = ((metal::abs(metal::sin(_e123)) * _e127) + (metal::abs(metal::cos(_e130)) * _e134)) * 0.76;
    float _e138 = k;
    float _e140 = fall;
    lift = (0.035 * _e138) * (1.0 - _e140);
    float _e143 = fall;
    float _e145 = lift;
    float _e146 = bound;
    float _e149 = fall;
    center = metal::float2(0.08 * _e143, _e145 - (((0.5 + _e146) + 0.1) * _e149));
    float _e153 = k;
    rad = 0.008 * _e153;
    float _e155 = a;
    ca = metal::cos(_e155);
    float _e157 = a;
    sa = metal::sin(_e157);
    float _e159 = ca;
    float _e160 = sa;
    float _e162 = sa;
    float _e163 = ca;
    unrotate = metal::float2x2(metal::float2(_e159, -(_e160)), metal::float2(_e162, _e163));
    metal::float2 _e167 = uv_2;
    param = _e167;
    metal::float4 _e168 = getToColor(param, _sampler, _to);
    col = _e168;
    float _e170 = uniforms.shadow;
    float _e171 = k;
    sh = _e170 * _e171;
    float _e173 = sh;
    if (_e173 > 0.0) {
        metal::float2x2 _e175 = unrotate;
        metal::float2 _e176 = q_1;
        metal::float2 _e177 = center;
        float _e179 = k;
        float _e183 = s;
        rs = (_e175 * ((_e176 - _e177) - (metal::float2(0.012, -0.022) * _e179))) / metal::float2(_e183);
        metal::float2 _e186 = rs;
        param_1 = _e186;
        metal::float2 _e187 = halfCard;
        param_2 = _e187;
        float _e188 = rad;
        param_3 = _e188;
        float _e189 = roundedBox(param_1, param_2, param_3);
        float _e190 = s;
        ds = _e189 * _e190;
        float _e192 = s;
        blur = 0.035 * _e192;
        float _e194 = sh;
        float _e195 = blur;
        float _e197 = blur;
        float _e198 = ds;
        metal::float4 _e203 = col;
        metal::float3 _e205 = _e203.xyz * (1.0 - (_e194 * (1.0 - metal::smoothstep(-(_e195), _e197, _e198))));
        col[0u] = _e205.x;
        col[1u] = _e205.y;
        col[2u] = _e205.z;
    }
    metal::float4 _e212 = col;
    param_4 = _e212;
    metal::float4 _e213 = premultiply(param_4);
    col = _e213;
    metal::float2x2 _e214 = unrotate;
    metal::float2 _e215 = q_1;
    metal::float2 _e216 = center;
    float _e219 = s;
    r_1 = (_e214 * (_e215 - _e216)) / metal::float2(_e219);
    metal::float2 _e222 = r_1;
    param_5 = _e222;
    metal::float2 _e223 = halfCard;
    param_6 = _e223;
    float _e224 = rad;
    param_7 = _e224;
    float _e225 = roundedBox(param_5, param_6, param_7);
    float _e226 = s;
    dCard = _e225 * _e226;
    metal::float2 _e228 = r_1;
    param_8 = _e228;
    metal::float2 _e229 = halfImage;
    param_9 = _e229;
    param_10 = 0.0;
    float _e230 = roundedBox(param_8, param_9, param_10);
    float _e231 = s;
    dImage = _e230 * _e231;
    float _e233 = dCard;
    cardCover = metal::clamp(1.5 - (_e233 / 0.0015), 0.0, 1.0);
    float _e237 = dImage;
    imageCover = metal::clamp(1.5 - (_e237 / 0.0015), 0.0, 1.0);
    metal::float2 _e241 = r_1;
    metal::float2 _e242 = asp;
    param_11 = metal::clamp((_e241 / _e242) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e249 = getFromColor(param_11, _from, _sampler);
    param_12 = _e249;
    metal::float4 _e250 = premultiply(param_12);
    photo = _e250;
    metal::float4 _e252 = uniforms.borderColor;
    param_13 = _e252;
    metal::float4 _e253 = premultiply(param_13);
    paper = _e253;
    metal::float4 _e254 = paper;
    metal::float4 _e255 = col;
    float _e257 = paper[3u];
    metal::float4 _e261 = photo;
    float _e262 = imageCover;
    card = metal::mix(_e254 + (_e255 * (1.0 - _e257)), _e261, metal::float4(_e262));
    metal::float4 _e265 = col;
    metal::float4 _e266 = card;
    float _e267 = cardCover;
    col = metal::mix(_e265, _e266, metal::float4(_e267));
    float _e271 = col[3u];
    if (_e271 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    float _e274 = col[3u];
    metal::float4 _e275 = col;
    metal::float3 _e278 = _e275.xyz / metal::float3(_e274);
    col[0u] = _e278.x;
    col[1u] = _e278.y;
    col[2u] = _e278.z;
    float _e286 = uniforms.flash;
    float _e287 = p;
    float _e290 = p;
    f = (_e286 * metal::smoothstep(0.0, 0.05, _e287)) * (1.0 - metal::smoothstep(0.05, 0.3, _e290));
    metal::float4 _e294 = col;
    float _e298 = f;
    metal::float3 _e302 = metal::float3(1.0) - ((metal::float3(1.0) - _e294.xyz) * (1.0 - _e298));
    col[0u] = _e302.x;
    col[1u] = _e302.y;
    col[2u] = _e302.z;
    metal::float4 _e309 = col;
    return _e309;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_14 = {};
    metal::float2 _e39 = _uv_1;
    param_14 = _e39;
    metal::float4 _e40 = transition(param_14, _from, _sampler, _to, uniforms);
    _fragColor = _e40;
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
