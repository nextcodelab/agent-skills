// BrushWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BrushWipe.glsl
// Author: gre
// License: MIT
// Description: A few broad brush strokes sweep across the frame in turn, back and forth, painting in the incoming image with streaky bristle edges and dry, ragged ends
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float strokes;
    float angle;
    float roughness;
    float waviness;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e61 = uv[0u];
    float _e63 = uv[1u];
    metal::float4 _e66 = _to.sample(_sampler, metal::float2(_e61, 1.0 - _e63), metal::level(0.0));
    return _e66;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e61 = uv_1[0u];
    float _e63 = uv_1[1u];
    metal::float4 _e66 = _from.sample(_sampler, metal::float2(_e61, 1.0 - _e63), metal::level(0.0));
    return _e66;
}

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e61 = p;
    p3_ = metal::fract(_e61.xyx * 0.1031);
    metal::float3 _e65 = p3_;
    metal::float3 _e66 = p3_;
    metal::float3 _e71 = p3_;
    p3_ = _e71 + metal::float3(metal::dot(_e65, _e66.yzx + metal::float3(33.33)));
    float _e75 = p3_[0u];
    float _e77 = p3_[1u];
    float _e80 = p3_[2u];
    return metal::fract((_e75 + _e77) * _e80);
}

float vnoise(
    thread metal::float2& p_1
) {
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 _e66 = p_1;
    i = metal::floor(_e66);
    metal::float2 _e68 = p_1;
    f = metal::fract(_e68);
    metal::float2 _e70 = f;
    metal::float2 _e71 = f;
    metal::float2 _e73 = f;
    f = (_e70 * _e71) * (metal::float2(3.0) - (_e73 * 2.0));
    metal::float2 _e78 = i;
    param = _e78;
    float _e79 = hash(param);
    metal::float2 _e80 = i;
    param_1 = _e80 + metal::float2(1.0, 0.0);
    float _e82 = hash(param_1);
    float _e84 = f[0u];
    metal::float2 _e86 = i;
    param_2 = _e86 + metal::float2(0.0, 1.0);
    float _e88 = hash(param_2);
    metal::float2 _e89 = i;
    param_3 = _e89 + metal::float2(1.0, 1.0);
    float _e91 = hash(param_3);
    float _e93 = f[0u];
    float _e96 = f[1u];
    return metal::mix(metal::mix(_e79, _e82, _e84), metal::mix(_e88, _e91, _e93), _e96);
}

float bristles(
    thread float& t,
    thread float& u,
    thread float& seed
) {
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float _e64 = t;
    float _e66 = seed;
    float _e68 = u;
    float _e70 = seed;
    param_4 = metal::float2((_e64 * 26.0) + _e66, (_e68 * 1.3) + _e70);
    float _e73 = vnoise(param_4);
    float _e75 = t;
    float _e77 = seed;
    float _e79 = u;
    param_5 = metal::float2((_e75 * 8.0) - _e77, _e79 * 0.7);
    float _e82 = vnoise(param_5);
    return (0.6 * _e73) + (0.4 * _e82);
}

metal::float2 stroke(
    thread float& k,
    thread float& t_1,
    thread float& u_1,
    thread float& U,
    thread float& n,
    thread float& h,
    constant Uniforms& uniforms
) {
    float dir = {};
    float x = {};
    float dur = {};
    float start = {};
    float local = {};
    float s = {};
    float r = {};
    float lag = {};
    float dry = {};
    float head = {};
    float b = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float front = {};
    float streak = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float along = {};
    float fringe = {};
    float e = {};
    float reach = {};
    metal::float2 param_12 = {};
    float hair = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float side = {};
    float cover = {};
    float wet = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float _e99 = k;
    dir = ((_e99 - (metal::floor(_e99 / 2.0) * 2.0)) < 0.5) ? 1.0 : -1.0;
    float _e106 = u_1;
    float _e107 = dir;
    x = _e106 * _e107;
    float _e109 = n;
    dur = metal::min(1.0, 1.8 / (_e109 + 0.8));
    float _e113 = n;
    if (_e113 > 1.0) {
        float _e115 = k;
        float _e116 = dur;
        float _e119 = n;
        local = (_e115 * (1.0 - _e116)) / (_e119 - 1.0);
    } else {
        local = 0.0;
    }
    float _e122 = local;
    start = _e122;
    float _e124 = uniforms.progress;
    float _e125 = start;
    float _e127 = dur;
    s = metal::clamp((_e124 - _e125) / _e127, 0.0, 1.0);
    float _e130 = s;
    float _e131 = s;
    float _e132 = s;
    float _e134 = s;
    s = metal::mix(_e130, (_e131 * _e132) * (3.0 - (2.0 * _e134)), 0.7);
    float _e140 = uniforms.roughness;
    r = _e140;
    float _e141 = r;
    float _e144 = h;
    lag = (0.15 + (0.6 * _e141)) * _e144;
    float _e146 = r;
    float _e149 = h;
    dry = (0.1 + (0.9 * _e146)) * _e149;
    float _e151 = U;
    float _e153 = U;
    float _e154 = lag;
    float _e156 = h;
    float _e159 = dry;
    float _e163 = s;
    head = metal::mix(-(_e151), (((_e153 + _e154) + (0.3 * _e156)) + (1.15 * _e159)) + 0.01, _e163);
    float _e165 = k;
    float _e167 = k;
    float _e169 = t_1;
    param_6 = _e169;
    param_7 = _e165 * 3.7;
    param_8 = _e167 * 17.0;
    float _e170 = bristles(param_6, param_7, param_8);
    b = _e170;
    float _e171 = head;
    float _e172 = lag;
    float _e173 = b;
    float _e177 = h;
    float _e179 = t_1;
    float _e181 = t_1;
    front = (_e171 - (_e172 * (1.0 - _e173))) - (((0.3 * _e177) * _e179) * _e181);
    float _e184 = t_1;
    float _e186 = x;
    float _e188 = h;
    float _e190 = k;
    param_9 = _e184 * 1.7;
    param_10 = (_e186 * 2.0) / _e188;
    param_11 = (_e190 * 5.0) + 9.0;
    float _e193 = bristles(param_9, param_10, param_11);
    streak = _e193;
    float _e194 = front;
    float _e195 = x;
    float _e197 = dry;
    float _e201 = streak;
    along = metal::clamp(((((_e194 - _e195) / (_e197 + 0.001)) - 0.1) - (0.8 * _e201)) * 6.0, 0.0, 1.0);
    float _e206 = r;
    fringe = 0.1 + (0.7 * _e206);
    float _e209 = t_1;
    float _e212 = fringe;
    e = (metal::abs(_e209) - 1.0) / _e212;
    float _e214 = x;
    float _e216 = h;
    float _e218 = k;
    float _e220 = t_1;
    param_12 = metal::float2((_e214 * 2.5) / _e216, (_e218 * 7.0) + ((_e220 > 0.0) ? 3.0 : 0.0));
    float _e225 = vnoise(param_12);
    reach = 0.5 + (0.5 * _e225);
    float _e228 = t_1;
    float _e230 = x;
    float _e232 = h;
    float _e234 = k;
    param_13 = _e228 * 1.4;
    param_14 = (_e230 * 3.0) / _e232;
    param_15 = (_e234 * 11.0) + 3.0;
    float _e237 = bristles(param_13, param_14, param_15);
    hair = metal::clamp((_e237 * 2.0) - 0.5, 0.0, 1.0);
    float _e241 = reach;
    float _e242 = hair;
    float _e244 = e;
    side = metal::clamp((((_e241 * _e242) - _e244) * 12.0) + 1.0, 0.0, 1.0);
    float _e249 = along;
    float _e250 = side;
    cover = _e249 * _e250;
    float _e253 = uniforms.progress;
    float _e254 = start;
    float _e256 = dur;
    float _e262 = uniforms.progress;
    wet = (1.0 - metal::clamp(((_e253 - _e254) - _e256) / 0.25, 0.0, 1.0)) * metal::min(1.0, (1.0 - _e262) * 6.0);
    float _e267 = cover;
    float _e268 = cover;
    float _e269 = wet;
    float _e271 = t_1;
    float _e273 = x;
    float _e275 = h;
    param_16 = _e271 * 2.0;
    param_17 = (_e273 * 2.0) / _e275;
    float _e277 = k;
    param_18 = _e277;
    float _e278 = bristles(param_16, param_17, param_18);
    return metal::float2(_e267, (_e268 * _e269) * (_e278 - 0.5));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float a = {};
    float c = {};
    float sn = {};
    metal::float2 q = {};
    float u_2 = {};
    float v = {};
    float U_1 = {};
    float V = {};
    float n_1 = {};
    float h_1 = {};
    float A = {};
    float w = {};
    float y = {};
    float hh = {};
    float k_1 = {};
    float cover_1 = {};
    float shade = {};
    int i_1 = {};
    float j = {};
    metal::float2 s_1 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    metal::float4 from = {};
    metal::float2 param_25 = {};
    metal::float4 to = {};
    metal::float2 param_26 = {};
    bool phi_605_ = {};
    float _e91 = uniforms.angle;
    a = (_e91 * 3.1415927) / 180.0;
    float _e94 = a;
    c = metal::cos(_e94);
    float _e96 = a;
    sn = metal::sin(_e96);
    metal::float2 _e98 = uv_2;
    float _e102 = uniforms.ratio;
    q = (_e98 - metal::float2(0.5)) * metal::float2(_e102, 1.0);
    float _e105 = c;
    float _e107 = q[0u];
    float _e109 = sn;
    float _e111 = q[1u];
    u_2 = (_e105 * _e107) + (_e109 * _e111);
    float _e114 = sn;
    float _e117 = q[0u];
    float _e119 = c;
    float _e121 = q[1u];
    v = (-(_e114) * _e117) + (_e119 * _e121);
    float _e124 = c;
    float _e127 = uniforms.ratio;
    float _e129 = sn;
    U_1 = 0.5 * ((metal::abs(_e124) * _e127) + metal::abs(_e129));
    float _e133 = sn;
    float _e136 = uniforms.ratio;
    float _e138 = c;
    V = 0.5 * ((metal::abs(_e133) * _e136) + metal::abs(_e138));
    float _e143 = uniforms.strokes;
    n_1 = metal::max(1.0, metal::floor(_e143 + 0.5));
    float _e147 = V;
    float _e149 = n_1;
    h_1 = (2.0 * _e147) / _e149;
    float _e152 = uniforms.waviness;
    float _e154 = h_1;
    A = (0.12 * _e152) * _e154;
    float _e156 = v;
    float _e157 = A;
    float _e158 = u_2;
    float _e160 = U_1;
    float _e162 = v;
    float _e164 = h_1;
    float _e171 = A;
    float _e173 = u_2;
    float _e175 = U_1;
    float _e177 = v;
    float _e179 = h_1;
    w = (_e156 + (_e157 * metal::sin((((_e158 * 5.0) / _e160) + ((_e162 * 2.0) / _e164)) + 1.3))) + ((0.5 * _e171) * metal::sin(((_e173 * 11.0) / _e175) - ((_e177 * 3.0) / _e179)));
    float _e185 = V;
    float _e186 = A;
    float _e189 = w;
    float _e191 = V;
    float _e193 = A;
    float _e197 = n_1;
    y = (((_e185 + (1.5 * _e186)) - _e189) / ((2.0 * _e191) + (3.0 * _e193))) * _e197;
    float _e199 = V;
    float _e201 = A;
    float _e204 = n_1;
    hh = ((2.0 * _e199) + (3.0 * _e201)) / _e204;
    float _e206 = y;
    float _e208 = n_1;
    k_1 = metal::clamp(metal::floor(_e206), 0.0, _e208 - 1.0);
    cover_1 = 0.0;
    shade = 0.0;
    i_1 = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e246 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e246) + as_type<uint>(1));
        }
        loop_init = false;
        int _e211 = i_1;
        if (_e211 <= 1) {
            float _e213 = k_1;
            int _e214 = i_1;
            j = _e213 + static_cast<float>(_e214);
            float _e217 = j;
            bool _e218 = _e217 >= 0.0;
            phi_605_ = _e218;
            if (_e218) {
                float _e219 = j;
                float _e220 = n_1;
                phi_605_ = _e219 <= (_e220 - 1.0);
            }
            bool _e224 = phi_605_;
            if (_e224) {
                float _e225 = y;
                float _e226 = j;
                float _e230 = j;
                param_19 = _e230;
                param_20 = ((_e225 - _e226) - 0.5) * 2.0;
                float _e231 = u_2;
                param_21 = _e231;
                float _e232 = U_1;
                param_22 = _e232;
                float _e233 = n_1;
                param_23 = _e233;
                float _e234 = hh;
                param_24 = _e234;
                metal::float2 _e235 = stroke(param_19, param_20, param_21, param_22, param_23, param_24, uniforms);
                s_1 = _e235;
                float _e236 = cover_1;
                float _e238 = s_1[0u];
                cover_1 = metal::max(_e236, _e238);
                float _e240 = shade;
                float _e242 = s_1[1u];
                float _e244 = s_1[0u];
                shade = metal::mix(_e240, _e242, _e244);
            }
            continue;
        } else {
            break;
        }
    }
    metal::float2 _e248 = uv_2;
    param_25 = _e248;
    metal::float4 _e249 = getFromColor(param_25, _from, _sampler);
    from = _e249;
    metal::float2 _e250 = uv_2;
    param_26 = _e250;
    metal::float4 _e251 = getToColor(param_26, _sampler, _to);
    to = _e251;
    metal::float4 _e252 = to;
    float _e254 = shade;
    metal::float3 _e259 = metal::min(_e252.xyz * (1.0 + (0.2 * _e254)), metal::float3(1.0));
    to[0u] = _e259.x;
    to[1u] = _e259.y;
    to[2u] = _e259.z;
    metal::float4 _e266 = from;
    metal::float4 _e267 = to;
    float _e268 = cover_1;
    return metal::mix(_e266, _e267, metal::float4(_e268));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_27 = {};
    metal::float2 _e60 = _uv_1;
    param_27 = _e60;
    metal::float4 _e61 = transition(param_27, _from, _sampler, _to, uniforms);
    _fragColor = _e61;
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
