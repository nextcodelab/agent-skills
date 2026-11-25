// ProjectorThrow — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/ProjectorThrow.glsl
// Author: gre
// License: MIT
// Description: The lights go down on the outgoing image and a projector throws the incoming one onto it: a small, blurred, keystoned picture of light lands on the scene, tinted by the colors it falls on, then grows, comes into focus and squares up until it fills the frame as the scene beneath it fades away
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float darkness;
    float keystone;
    float blur;
};

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

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e45 = v;
    metal::float2 _e46 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e45 - (metal::floor(_e45 / _e46) * _e46)));
}

metal::float4 projected(
    thread metal::float2& q,
    thread metal::float2& r,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float4 c = {};
    int i = {};
    float a = {};
    metal::float2 o = {};
    metal::float4 t = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float4 local = {};
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e90 = i;
            i = as_type<int>(as_type<uint>(_e90) + as_type<uint>(1));
        }
        loop_init = false;
        int _e54 = i;
        if (_e54 < 8) {
            int _e56 = i;
            a = static_cast<float>(_e56) * 2.39996;
            int _e59 = i;
            float _e64 = a;
            float _e66 = a;
            o = metal::float2(metal::cos(_e64), metal::sin(_e66)) * metal::sqrt((static_cast<float>(_e59) + 0.5) / 8.0);
            metal::float2 _e70 = q;
            metal::float2 _e71 = o;
            metal::float2 _e72 = r;
            param = _e70 + (_e71 * _e72);
            metal::float2 _e75 = mirror(param);
            param_1 = _e75;
            metal::float4 _e76 = getToColor(param_1, _sampler, _to);
            t = _e76;
            metal::float4 _e77 = t;
            float _e80 = t[3u];
            metal::float3 _e81 = _e77.xyz * _e80;
            float _e83 = t[3u];
            metal::float4 _e88 = c;
            c = _e88 + metal::float4(_e81.x, _e81.y, _e81.z, _e83);
            continue;
        } else {
            break;
        }
    }
    float _e93 = c[3u];
    if (_e93 > 0.0) {
        metal::float4 _e95 = c;
        float _e98 = c[3u];
        metal::float3 _e100 = _e95.xyz / metal::float3(_e98);
        float _e102 = c[3u];
        local = metal::float4(_e100.x, _e100.y, _e100.z, _e102 / 8.0);
    } else {
        local = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e108 = local;
    return _e108;
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
    float p = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float4 from = {};
    metal::float2 param_4 = {};
    float on = {};
    float ambient = {};
    float g = {};
    float focus = {};
    float size = {};
    float k = {};
    float cy = {};
    float y = {};
    float wy = {};
    metal::float2 q_1 = {};
    float e = {};
    float soft = {};
    float cov = {};
    float halo = {};
    metal::float2 d = {};
    float gain = {};
    metal::float2 r_1 = {};
    metal::float4 pic = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float3 light = {};
    float screen = {};
    metal::float3 surface = {};
    metal::float3 col = {};
    float _e75 = uniforms.progress;
    p = _e75;
    float _e76 = p;
    if (_e76 <= 0.0) {
        metal::float2 _e78 = uv_2;
        param_2 = _e78;
        metal::float4 _e79 = getFromColor(param_2, _from, _sampler);
        return _e79;
    }
    float _e80 = p;
    if (_e80 >= 1.0) {
        metal::float2 _e82 = uv_2;
        param_3 = _e82;
        metal::float4 _e83 = getToColor(param_3, _sampler, _to);
        return _e83;
    }
    metal::float2 _e84 = uv_2;
    param_4 = _e84;
    metal::float4 _e85 = getFromColor(param_4, _from, _sampler);
    from = _e85;
    float _e86 = p;
    on = metal::smoothstep(0.06, 0.26, _e86);
    float _e89 = uniforms.darkness;
    float _e90 = p;
    ambient = 1.0 - (_e89 * metal::smoothstep(0.0, 0.2, _e90));
    float _e94 = p;
    g = metal::smoothstep(0.02, 1.0, _e94);
    float _e96 = p;
    focus = 1.0 - metal::smoothstep(0.15, 0.85, _e96);
    float _e99 = g;
    float _e100 = g;
    size = metal::mix(0.32, 1.0, _e99 * (0.6 + (0.4 * _e100)));
    float _e106 = uniforms.keystone;
    float _e107 = g;
    k = _e106 * (1.0 - _e107);
    float _e110 = g;
    cy = metal::mix(0.58, 0.5, _e110);
    float _e113 = uv_2[1u];
    float _e114 = cy;
    float _e116 = size;
    y = ((_e113 - _e114) / _e116) + 0.5;
    float _e119 = k;
    float _e122 = k;
    float _e123 = y;
    wy = metal::max((1.0 - (0.5 * _e119)) + (_e122 * _e123), 0.05);
    float _e128 = uv_2[0u];
    float _e130 = size;
    float _e131 = wy;
    float _e135 = y;
    float _e136 = k;
    float _e140 = wy;
    q_1 = metal::float2(((_e128 - 0.5) / (_e130 * _e131)) + 0.5, (_e135 * (1.0 + (0.5 * _e136))) / _e140);
    float _e143 = size;
    float _e145 = wy;
    float _e148 = uv_2[0u];
    float _e153 = uniforms.ratio;
    float _e155 = size;
    float _e156 = y;
    float _e157 = y;
    e = metal::min((((0.5 * _e143) * _e145) - metal::abs(_e148 - 0.5)) * _e153, _e155 * metal::min(_e156, 1.0 - _e157));
    float _e162 = focus;
    soft = 0.0015 + (0.035 * _e162);
    float _e165 = soft;
    float _e167 = soft;
    float _e168 = e;
    float _e170 = p;
    cov = metal::mix(metal::smoothstep(-(_e165), _e167, _e168), 1.0, metal::smoothstep(0.9, 1.0, _e170));
    float _e173 = focus;
    float _e175 = on;
    float _e177 = e;
    float _e183 = cov;
    halo = (((0.15 * _e173) * _e175) * metal::exp(-24.0 * metal::max(-(_e177), 0.0))) * (1.0 - _e183);
    metal::float2 _e186 = q_1;
    d = _e186 - metal::float2(0.5);
    float _e189 = on;
    float _e190 = g;
    float _e193 = focus;
    metal::float2 _e194 = d;
    metal::float2 _e195 = d;
    gain = (_e189 * metal::mix(1.25, 1.0, _e190)) * (1.0 + (_e193 * (0.15 - (1.2 * metal::dot(_e194, _e195)))));
    float _e203 = uniforms.blur;
    float _e204 = focus;
    float _e206 = size;
    float _e207 = wy;
    float _e211 = uniforms.ratio;
    float _e213 = k;
    float _e215 = k;
    float _e218 = wy;
    r_1 = metal::float2(1.0 / _e211, (1.0 - ((0.25 * _e213) * _e215)) / _e218) * ((_e203 * _e204) / (_e206 * _e207));
    metal::float2 _e222 = q_1;
    param_5 = _e222;
    metal::float2 _e223 = r_1;
    param_6 = _e223;
    metal::float4 _e224 = projected(param_5, param_6, _sampler, _to);
    pic = _e224;
    metal::float4 _e225 = pic;
    float _e227 = gain;
    float _e229 = cov;
    float _e231 = halo;
    light = ((_e225.xyz * _e227) * _e229) + metal::float3(_e231);
    float _e234 = p;
    screen = metal::smoothstep(0.35, 0.95, _e234);
    metal::float4 _e236 = from;
    float _e238 = screen;
    surface = metal::mix(_e236.xyz, metal::float3(1.0, 1.0, 1.0), metal::float3(0.35 + (0.65 * _e238)));
    metal::float4 _e243 = from;
    float _e245 = ambient;
    float _e247 = cov;
    float _e248 = screen;
    metal::float3 _e252 = surface;
    metal::float3 _e253 = light;
    col = ((_e243.xyz * _e245) * (1.0 - (_e247 * _e248))) + (_e252 * _e253);
    metal::float3 _e256 = col;
    float _e258 = from[3u];
    float _e260 = pic[3u];
    float _e261 = cov;
    float _e263 = on;
    float _e267 = pic[3u];
    float _e268 = cov;
    float _e269 = screen;
    return metal::float4(_e256.x, _e256.y, _e256.z, metal::mix(metal::max(_e258, (_e260 * _e261) * _e263), _e267, _e268 * _e269));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_7 = {};
    metal::float2 _e45 = _uv_1;
    param_7 = _e45;
    metal::float4 _e46 = transition(param_7, _from, _sampler, _to, uniforms);
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
