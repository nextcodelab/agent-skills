// RingsWipe — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RingsWipe.glsl
// Author: gre
// License: MIT
// Description: Concentric rings ripple out from the center and, one after another, each sweeps around like a clock hand in the opposite direction of its neighbors to reveal the incoming image, or fills across its width, with optional colored borders between the rings
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int count;
    char _pad3[4];
    metal::float2 center;
    float stagger;
    int radial;
    float borderWidth;
    char _pad7[12];
    metal::float4 borderColor;
    float smoothness;
    char _pad9[12];
};

float ringMask(
    thread float& i,
    thread float& lp,
    thread float& w,
    thread float& rad,
    thread float& a,
    thread float& s,
    constant Uniforms& uniforms
) {
    bool odd = {};
    float e = {};
    float f = {};
    float x = {};
    float dist = {};
    float local = {};
    float aa = {};
    float local_1 = {};
    float arc = {};
    float e_1 = {};
    float lo = {};
    float hi = {};
    float dist_1 = {};
    float _e51 = i;
    odd = (_e51 - (metal::floor(_e51 / 2.0) * 2.0)) > 0.5;
    int _e58 = uniforms.radial;
    if (_e58 != 0) {
        float _e60 = s;
        float _e61 = w;
        e = _e60 / _e61;
        float _e63 = e;
        float _e65 = e;
        float _e67 = lp;
        f = metal::mix(-(_e63), 1.0 + _e65, _e67);
        float _e69 = rad;
        float _e70 = i;
        float _e71 = w;
        float _e74 = w;
        x = metal::clamp((_e69 - (_e70 * _e71)) / _e74, 0.0, 1.0);
        bool _e77 = odd;
        if (_e77) {
            float _e78 = f;
            float _e79 = x;
            local = _e78 - (1.0 - _e79);
        } else {
            float _e82 = f;
            float _e83 = x;
            local = _e82 - _e83;
        }
        float _e85 = local;
        float _e86 = w;
        dist = _e85 * _e86;
        float _e88 = s;
        float _e90 = s;
        float _e91 = dist;
        return metal::smoothstep(-(_e88), _e90, _e91);
    }
    bool _e93 = odd;
    if (_e93) {
        float _e94 = a;
        local_1 = 1.0 - _e94;
    } else {
        float _e96 = a;
        local_1 = _e96;
    }
    float _e97 = local_1;
    aa = _e97;
    float _e98 = rad;
    float _e99 = s;
    arc = 6.2831855 * metal::max(_e98, _e99);
    float _e102 = s;
    float _e103 = arc;
    e_1 = _e102 / _e103;
    float _e105 = e_1;
    float _e106 = e_1;
    float _e108 = lp;
    lo = metal::mix(_e105, -(_e106), _e108);
    float _e110 = e_1;
    float _e112 = e_1;
    float _e114 = lp;
    hi = metal::mix(-(_e110), 1.0 + _e112, _e114);
    float _e116 = aa;
    float _e117 = lo;
    float _e119 = hi;
    float _e120 = aa;
    float _e123 = aa;
    float _e125 = lo;
    float _e127 = hi;
    float _e128 = aa;
    dist_1 = metal::max(metal::min(_e116 - _e117, _e119 - _e120), metal::min((_e123 - 1.0) - _e125, (_e127 - _e128) + 1.0));
    float _e133 = s;
    float _e135 = s;
    float _e136 = dist_1;
    float _e137 = arc;
    return metal::smoothstep(-(_e133), _e135, _e136 * _e137);
}

float ringProgress(
    thread float& i_1,
    thread float& k,
    thread float& d,
    thread float& t
) {
    float _e36 = t;
    float _e37 = i_1;
    float _e38 = k;
    float _e40 = d;
    float _e43 = d;
    return metal::clamp((_e36 - ((_e37 * _e38) * _e40)) / _e43, 0.0, 1.0);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e34 = uv[0u];
    float _e36 = uv[1u];
    metal::float4 _e39 = _to.sample(_sampler, metal::float2(_e34, 1.0 - _e36), metal::level(0.0));
    return _e39;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e34 = uv_1[0u];
    float _e36 = uv_1[1u];
    metal::float4 _e39 = _from.sample(_sampler, metal::float2(_e34, 1.0 - _e36), metal::level(0.0));
    return _e39;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a_1 = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    float n = {};
    int local_2 = {};
    metal::float2 p = {};
    metal::float2 far = {};
    float R = {};
    float w_1 = {};
    float rad_1 = {};
    float turn = {};
    float local_3 = {};
    float s_1 = {};
    float t_1 = {};
    float k_1 = {};
    float d_1 = {};
    float j = {};
    float inner = {};
    float outer = {};
    float li = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float param_5 = {};
    float lo_1 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float m = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    metal::float4 c = {};
    float on = {};
    float hw = {};
    float line = {};
    float o = {};
    metal::float4 local_4 = {};
    bool phi_447_ = {};
    metal::float2 _e82 = uv_2;
    param = _e82;
    metal::float4 _e83 = getFromColor(param, _from, _sampler);
    a_1 = _e83;
    metal::float2 _e84 = uv_2;
    param_1 = _e84;
    metal::float4 _e85 = getToColor(param_1, _sampler, _to);
    b = _e85;
    float _e87 = uniforms.progress;
    if (_e87 <= 0.0) {
        metal::float4 _e89 = a_1;
        return _e89;
    }
    float _e91 = uniforms.progress;
    if (_e91 >= 1.0) {
        metal::float4 _e93 = b;
        return _e93;
    }
    int _e95 = uniforms.count;
    if (_e95 < 1) {
        local_2 = 1;
    } else {
        int _e98 = uniforms.count;
        local_2 = _e98;
    }
    int _e99 = local_2;
    n = static_cast<float>(_e99);
    metal::float2 _e101 = uv_2;
    metal::float2 _e103 = uniforms.center;
    float _e106 = uniforms.ratio;
    p = (_e101 - _e103) * metal::float2(_e106, 1.0);
    metal::float2 _e110 = uniforms.center;
    metal::float2 _e112 = uniforms.center;
    float _e117 = uniforms.ratio;
    far = metal::max(_e110, metal::float2(1.0) - _e112) * metal::float2(_e117, 1.0);
    metal::float2 _e120 = far;
    R = metal::length(_e120) + 0.0015;
    float _e123 = R;
    float _e124 = n;
    w_1 = _e123 / _e124;
    metal::float2 _e126 = p;
    rad_1 = metal::length(_e126);
    float _e128 = rad_1;
    if (_e128 > 0.0) {
        float _e131 = p[0u];
        float _e133 = p[1u];
        local_3 = metal::fract(metal::atan2(_e131, _e133) / 6.2831855);
    } else {
        local_3 = 0.0;
    }
    float _e137 = local_3;
    turn = _e137;
    float _e139 = uniforms.smoothness;
    float _e140 = w_1;
    s_1 = metal::max(metal::min(_e139, 0.25 * _e140), 0.0015);
    float _e145 = uniforms.progress;
    float _e147 = uniforms.progress;
    float _e149 = uniforms.progress;
    float _e152 = uniforms.progress;
    t_1 = metal::mix(_e145, (_e147 * _e149) * (3.0 - (2.0 * _e152)), 0.35);
    float _e158 = uniforms.stagger;
    k_1 = metal::clamp(_e158, 0.0, 1.0);
    float _e160 = k_1;
    float _e161 = n;
    d_1 = 1.0 / (1.0 + (_e160 * (_e161 - 1.0)));
    float _e166 = rad_1;
    float _e167 = w_1;
    j = metal::floor((_e166 / _e167) + 0.5);
    float _e171 = j;
    float _e173 = n;
    inner = metal::clamp(_e171 - 1.0, 0.0, _e173 - 1.0);
    float _e176 = j;
    float _e177 = n;
    outer = metal::clamp(_e176, 0.0, _e177 - 1.0);
    float _e180 = inner;
    param_2 = _e180;
    float _e181 = k_1;
    param_3 = _e181;
    float _e182 = d_1;
    param_4 = _e182;
    float _e183 = t_1;
    param_5 = _e183;
    float _e184 = ringProgress(param_2, param_3, param_4, param_5);
    li = _e184;
    float _e185 = outer;
    param_6 = _e185;
    float _e186 = k_1;
    param_7 = _e186;
    float _e187 = d_1;
    param_8 = _e187;
    float _e188 = t_1;
    param_9 = _e188;
    float _e189 = ringProgress(param_6, param_7, param_8, param_9);
    lo_1 = _e189;
    float _e190 = inner;
    param_10 = _e190;
    float _e191 = li;
    param_11 = _e191;
    float _e192 = w_1;
    param_12 = _e192;
    float _e193 = rad_1;
    param_13 = _e193;
    float _e194 = turn;
    param_14 = _e194;
    float _e195 = s_1;
    param_15 = _e195;
    float _e196 = ringMask(param_10, param_11, param_12, param_13, param_14, param_15, uniforms);
    float _e197 = outer;
    param_16 = _e197;
    float _e198 = lo_1;
    param_17 = _e198;
    float _e199 = w_1;
    param_18 = _e199;
    float _e200 = rad_1;
    param_19 = _e200;
    float _e201 = turn;
    param_20 = _e201;
    float _e202 = s_1;
    param_21 = _e202;
    float _e203 = ringMask(param_16, param_17, param_18, param_19, param_20, param_21, uniforms);
    float _e204 = rad_1;
    float _e205 = j;
    float _e206 = w_1;
    m = metal::mix(_e196, _e203, metal::smoothstep(-0.0015, 0.0015, _e204 - (_e205 * _e206)));
    metal::float4 _e211 = a_1;
    float _e214 = a_1[3u];
    metal::float3 _e215 = _e211.xyz * _e214;
    float _e217 = a_1[3u];
    metal::float4 _e222 = b;
    float _e225 = b[3u];
    metal::float3 _e226 = _e222.xyz * _e225;
    float _e228 = b[3u];
    float _e233 = m;
    c = metal::mix(metal::float4(_e215.x, _e215.y, _e215.z, _e217), metal::float4(_e226.x, _e226.y, _e226.z, _e228), metal::float4(_e233));
    float _e237 = uniforms.borderWidth;
    float _e239 = j;
    bool _e241 = (_e237 > 0.0) && (_e239 >= 1.0);
    phi_447_ = _e241;
    if (_e241) {
        float _e242 = j;
        float _e243 = n;
        phi_447_ = _e242 <= (_e243 - 1.0);
    }
    bool _e247 = phi_447_;
    if (_e247) {
        float _e248 = li;
        float _e250 = lo_1;
        on = metal::min(1.0, (4.0 * _e248) * (1.0 - _e250));
        float _e255 = uniforms.borderWidth;
        float _e257 = w_1;
        hw = metal::min(0.5 * _e255, (0.5 * _e257) - 0.0015);
        float _e261 = hw;
        float _e263 = hw;
        float _e265 = rad_1;
        float _e266 = j;
        float _e267 = w_1;
        float _e274 = uniforms.borderWidth;
        line = (1.0 - metal::smoothstep(_e261 - 0.0015, _e263 + 0.0015, metal::abs(_e265 - (_e266 * _e267)))) * metal::min(1.0, _e274 / 0.003);
        float _e280 = uniforms.borderColor[3u];
        float _e281 = line;
        float _e283 = on;
        o = (_e280 * _e281) * _e283;
        metal::float4 _e286 = uniforms.borderColor;
        float _e288 = o;
        metal::float3 _e289 = _e286.xyz * _e288;
        float _e290 = o;
        metal::float4 _e295 = c;
        float _e296 = o;
        c = metal::float4(_e289.x, _e289.y, _e289.z, _e290) + (_e295 * (1.0 - _e296));
    }
    float _e301 = c[3u];
    if (_e301 > 0.0) {
        metal::float4 _e303 = c;
        float _e306 = c[3u];
        metal::float3 _e308 = _e303.xyz / metal::float3(_e306);
        float _e310 = c[3u];
        local_4 = metal::float4(_e308.x, _e308.y, _e308.z, _e310);
    } else {
        local_4 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e315 = local_4;
    return _e315;
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
    metal::float2 _e33 = _uv_1;
    param_22 = _e33;
    metal::float4 _e34 = transition(param_22, _from, _sampler, _to, uniforms);
    _fragColor = _e34;
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
