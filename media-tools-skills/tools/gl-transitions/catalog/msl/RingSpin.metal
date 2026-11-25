// RingSpin — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/RingSpin.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into concentric rings that spin like the dials of a combination lock, in alternating directions and blurred with speed, one after another from the center outward; each ring overshoots a little and locks into place on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int rings;
    int square;
    int turns;
    float stagger;
    float blur;
    float settle;
};

float ringDelay(
    thread float& n,
    constant Uniforms& uniforms
) {
    float m = {};
    float _e55 = n;
    m = metal::max(_e55 - 1.0, 1.0);
    float _e59 = uniforms.stagger;
    float _e61 = m;
    float _e63 = m;
    return metal::min(metal::clamp(_e59, 0.0, 0.8) / _e61, 0.7 / (1.0 + (0.7 * _e63)));
}

float ringTime(
    thread float& i,
    thread float& n_1,
    constant Uniforms& uniforms
) {
    float d = {};
    float param = {};
    float local = {};
    float _e58 = n_1;
    param = _e58;
    float _e59 = ringDelay(param, uniforms);
    d = _e59;
    float _e61 = uniforms.progress;
    if (_e61 >= 1.0) {
        local = 1.0;
    } else {
        float _e64 = uniforms.progress;
        float _e65 = d;
        float _e66 = i;
        float _e69 = d;
        float _e70 = n_1;
        local = metal::clamp((_e64 - (_e65 * _e66)) / (1.0 - (_e69 * (_e70 - 1.0))), 0.0, 1.0);
    }
    float _e76 = local;
    return _e76;
}

float activity(
    thread float& i_1,
    thread float& n_2,
    constant Uniforms& uniforms
) {
    float t = {};
    float param_1 = {};
    float param_2 = {};
    float _e58 = i_1;
    param_1 = _e58;
    float _e59 = n_2;
    param_2 = _e59;
    float _e60 = ringTime(param_1, param_2, uniforms);
    t = _e60;
    float _e61 = t;
    float _e63 = t;
    return metal::smoothstep(0.0, 0.08, _e61) * (1.0 - metal::smoothstep(0.88, 1.0, _e63));
}

metal::float2 mirrorUV(
    thread metal::float2& v
) {
    metal::float2 _e54 = v;
    metal::float2 _e55 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e54 - (metal::floor(_e54 / _e55) * _e55)));
}

metal::float2 rotate(
    thread metal::float2& v_1,
    thread float& a
) {
    float c = {};
    float s = {};
    float _e57 = a;
    c = metal::cos(_e57);
    float _e59 = a;
    s = metal::sin(_e59);
    float _e61 = c;
    float _e63 = v_1[0u];
    float _e65 = s;
    float _e67 = v_1[1u];
    float _e70 = c;
    float _e72 = v_1[1u];
    float _e74 = s;
    float _e76 = v_1[0u];
    return metal::float2((_e61 * _e63) + (_e65 * _e67), (_e70 * _e72) - (_e74 * _e76));
}

float spin(
    thread float& t_1,
    thread float& total,
    constant Uniforms& uniforms
) {
    float amp = {};
    float stopT = {};
    float v1_ = {};
    float u = {};
    float b = {};
    float _e61 = uniforms.settle;
    float _e63 = total;
    amp = (0.1 * _e61) * metal::sign(_e63);
    stopT = 0.8;
    float _e66 = amp;
    float _e68 = stopT;
    float _e70 = total;
    v1_ = ((_e66 * 3.1415927) * _e68) / (_e70 * 0.2);
    float _e73 = t_1;
    float _e74 = stopT;
    u = metal::clamp(_e73 / _e74, 0.0, 1.0);
    float _e77 = t_1;
    float _e78 = stopT;
    b = metal::clamp((_e77 - _e78) / 0.2, 0.0, 1.0);
    float _e82 = total;
    float _e83 = u;
    float _e84 = u;
    float _e86 = u;
    float _e90 = v1_;
    float _e91 = u;
    float _e92 = u;
    float _e94 = u;
    float _e96 = u;
    float _e97 = u;
    float _e103 = amp;
    float _e104 = b;
    float _e108 = b;
    float _e111 = b;
    return (_e82 * (((_e83 * _e84) * (3.0 - (2.0 * _e86))) + (_e90 * (((_e91 * _e92) * _e94) - (_e96 * _e97))))) + (((_e103 * metal::sin(3.1415927 * _e104)) * (1.0 - _e108)) * (1.0 - _e111));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e55 = uv[0u];
    float _e57 = uv[1u];
    metal::float4 _e60 = _to.sample(_sampler, metal::float2(_e55, 1.0 - _e57), metal::level(0.0));
    return _e60;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e55 = uv_1[0u];
    float _e57 = uv_1[1u];
    metal::float4 _e60 = _from.sample(_sampler, metal::float2(_e55, 1.0 - _e57), metal::level(0.0));
    return _e60;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 aspect = {};
    metal::float2 c_1 = {};
    float r = {};
    float local_1 = {};
    float n_3 = {};
    float w = {};
    float local_2 = {};
    float f = {};
    float i_2 = {};
    float t_2 = {};
    float param_3 = {};
    float param_4 = {};
    metal::float4 col = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float total_1 = {};
    float a_1 = {};
    float param_7 = {};
    float param_8 = {};
    float u_1 = {};
    float omega = {};
    float param_9 = {};
    float span = {};
    float m_1 = {};
    float ws = {};
    int k = {};
    float x = {};
    metal::float2 q = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    metal::float2 param_12 = {};
    metal::float4 s_1 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    float bj = {};
    float act = {};
    float local_3 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    float d_1 = {};
    metal::float2 nr = {};
    metal::float2 local_4 = {};
    metal::float2 local_5 = {};
    float light = {};
    metal::float3 local_6 = {};
    float _e102 = uniforms.ratio;
    aspect = metal::float2(_e102, 1.0);
    metal::float2 _e104 = uv_2;
    metal::float2 _e107 = aspect;
    c_1 = (_e104 - metal::float2(0.5)) * _e107;
    int _e110 = uniforms.square;
    if (_e110 != 0) {
        float _e113 = c_1[0u];
        float _e116 = c_1[1u];
        local_1 = metal::max(metal::abs(_e113), metal::abs(_e116));
    } else {
        metal::float2 _e119 = c_1;
        local_1 = metal::length(_e119);
    }
    float _e121 = local_1;
    r = _e121;
    int _e123 = uniforms.rings;
    n_3 = metal::clamp(static_cast<float>(_e123), 1.0, 12.0);
    int _e127 = uniforms.square;
    if (_e127 != 0) {
        float _e130 = uniforms.ratio;
        local_2 = 0.5 * metal::max(_e130, 1.0);
    } else {
        metal::float2 _e133 = aspect;
        local_2 = metal::length(_e133 * 0.5);
    }
    float _e136 = local_2;
    float _e137 = n_3;
    w = _e136 / _e137;
    float _e139 = r;
    float _e140 = w;
    f = _e139 / _e140;
    float _e142 = f;
    float _e144 = n_3;
    i_2 = metal::min(metal::floor(_e142), _e144 - 1.0);
    float _e147 = i_2;
    param_3 = _e147;
    float _e148 = n_3;
    param_4 = _e148;
    float _e149 = ringTime(param_3, param_4, uniforms);
    t_2 = _e149;
    float _e150 = t_2;
    if (_e150 <= 0.0) {
        metal::float2 _e152 = uv_2;
        param_5 = _e152;
        metal::float4 _e153 = getFromColor(param_5, _from, _sampler);
        col = _e153;
    } else {
        float _e154 = t_2;
        if (_e154 >= 1.0) {
            metal::float2 _e156 = uv_2;
            param_6 = _e156;
            metal::float4 _e157 = getToColor(param_6, _sampler, _to);
            col = _e157;
        } else {
            int _e159 = uniforms.turns;
            float _e163 = i_2;
            total_1 = (6.2831855 * metal::max(static_cast<float>(_e159), 1.0)) * (((_e163 - (metal::floor(_e163 / 2.0) * 2.0)) < 0.5) ? 1.0 : -1.0);
            float _e171 = t_2;
            param_7 = _e171;
            float _e172 = total_1;
            param_8 = _e172;
            float _e173 = spin(param_7, param_8, uniforms);
            a_1 = _e173;
            float _e174 = t_2;
            u_1 = metal::min(_e174 / 0.8, 1.0);
            float _e177 = total_1;
            float _e180 = u_1;
            float _e182 = u_1;
            float _e185 = n_3;
            param_9 = _e185;
            float _e186 = ringDelay(param_9, uniforms);
            float _e187 = n_3;
            omega = (((metal::abs(_e177) * 6.0) * _e180) * (1.0 - _e182)) / (0.8 * (1.0 - (_e186 * (_e187 - 1.0))));
            float _e194 = uniforms.blur;
            float _e195 = omega;
            float _e197 = r;
            span = _e194 * metal::min(_e195 * 0.015, 0.1 / metal::max(_e197, 0.01));
            float _e202 = t_2;
            m_1 = metal::smoothstep(0.3, 0.5, _e202);
            col = metal::float4(0.0, 0.0, 0.0, 0.0);
            ws = 0.0;
            k = 0;
            uint2 loop_bound = uint2(4294967295u);
            bool loop_init = true;
            while(true) {
                if (metal::all(loop_bound == uint2(0u))) { break; }
                loop_bound -= uint2(loop_bound.y == 0u, 1u);
                if (!loop_init) {
                    int _e241 = k;
                    k = as_type<int>(as_type<uint>(_e241) + as_type<uint>(1));
                }
                loop_init = false;
                int _e204 = k;
                if (_e204 < 8) {
                    int _e206 = k;
                    x = (static_cast<float>(_e206) / 7.0) - 0.5;
                    float _e210 = a_1;
                    float _e211 = span;
                    float _e212 = x;
                    metal::float2 _e215 = c_1;
                    param_10 = _e215;
                    param_11 = _e210 + (_e211 * _e212);
                    metal::float2 _e216 = rotate(param_10, param_11);
                    metal::float2 _e217 = aspect;
                    param_12 = (_e216 / _e217) + metal::float2(0.5);
                    metal::float2 _e221 = mirrorUV(param_12);
                    q = _e221;
                    metal::float2 _e222 = q;
                    param_13 = _e222;
                    metal::float4 _e223 = getFromColor(param_13, _from, _sampler);
                    metal::float2 _e224 = q;
                    param_14 = _e224;
                    metal::float4 _e225 = getToColor(param_14, _sampler, _to);
                    float _e226 = m_1;
                    s_1 = metal::mix(_e223, _e225, metal::float4(_e226));
                    float _e229 = x;
                    metal::float4 _e232 = s_1;
                    metal::float4 _e234 = col;
                    col = _e234 + (_e232 * (1.0 - metal::abs(_e229)));
                    float _e236 = x;
                    float _e239 = ws;
                    ws = _e239 + (1.0 - metal::abs(_e236));
                    continue;
                } else {
                    break;
                }
            }
            float _e243 = ws;
            metal::float4 _e244 = col;
            col = _e244 / metal::float4(_e243);
        }
    }
    float _e247 = f;
    float _e250 = n_3;
    bj = metal::clamp(metal::floor(_e247 + 0.5), 1.0, metal::max(_e250 - 1.0, 1.0));
    float _e254 = n_3;
    if (_e254 > 1.5) {
        float _e256 = bj;
        param_15 = _e256 - 1.0;
        float _e258 = n_3;
        param_16 = _e258;
        float _e259 = activity(param_15, param_16, uniforms);
        float _e260 = bj;
        param_17 = _e260;
        float _e261 = n_3;
        param_18 = _e261;
        float _e262 = activity(param_17, param_18, uniforms);
        local_3 = metal::max(_e259, _e262);
    } else {
        local_3 = 0.0;
    }
    float _e264 = local_3;
    act = _e264;
    float _e265 = f;
    float _e266 = bj;
    float _e268 = w;
    d_1 = (_e265 - _e266) * _e268;
    int _e271 = uniforms.square;
    if (_e271 != 0) {
        float _e274 = c_1[0u];
        float _e277 = c_1[1u];
        if (metal::abs(_e274) > metal::abs(_e277)) {
            float _e281 = c_1[0u];
            local_5 = metal::float2(metal::sign(_e281), 0.0);
        } else {
            float _e285 = c_1[1u];
            local_5 = metal::float2(0.0, metal::sign(_e285));
        }
        metal::float2 _e288 = local_5;
        local_4 = _e288;
    } else {
        metal::float2 _e289 = c_1;
        float _e290 = r;
        local_4 = _e289 / metal::float2(metal::max(_e290, 0.0001));
    }
    metal::float2 _e294 = local_4;
    nr = _e294;
    float _e295 = d_1;
    metal::float2 _e298 = nr;
    float _e301 = d_1;
    float _e306 = act;
    light = ((-(metal::sign(_e295)) * metal::dot(_e298, metal::float2(-0.6, 0.8))) * (1.0 - metal::smoothstep(0.0035, 0.0155, metal::abs(_e301)))) * _e306;
    float _e308 = light;
    if (_e308 > 0.0) {
        metal::float4 _e310 = col;
        float _e313 = col[3u];
        float _e315 = light;
        local_6 = metal::mix(_e310.xyz, metal::float3(_e313), metal::float3(0.35 * _e315));
    } else {
        metal::float4 _e319 = col;
        float _e321 = light;
        local_6 = _e319.xyz * (1.0 + (0.45 * _e321));
    }
    metal::float3 _e325 = local_6;
    col[0u] = _e325.x;
    col[1u] = _e325.y;
    col[2u] = _e325.z;
    float _e332 = act;
    float _e334 = d_1;
    metal::float4 _e340 = col;
    metal::float3 _e342 = _e340.xyz * (1.0 - ((0.85 * _e332) * (1.0 - metal::smoothstep(0.002, 0.005, metal::abs(_e334)))));
    col[0u] = _e342.x;
    col[1u] = _e342.y;
    col[2u] = _e342.z;
    metal::float4 _e349 = col;
    return _e349;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_19 = {};
    metal::float2 _e54 = _uv_1;
    param_19 = _e54;
    metal::float4 _e55 = transition(param_19, _from, _sampler, _to, uniforms);
    _fragColor = _e55;
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
