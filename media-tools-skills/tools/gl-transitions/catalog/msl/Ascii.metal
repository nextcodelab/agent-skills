// Ascii — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Ascii.glsl
// Author: gre
// License: MIT
// Description: The image turns into text-mode characters, denser where it is brighter, the characters scramble into those of the incoming image, then resolve back into it
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float cellSize;
    int colored;
    metal::float4 ink;
    metal::float4 background;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e121 = uv[0u];
    float _e123 = uv[1u];
    metal::float4 _e126 = _to.sample(_sampler, metal::float2(_e121, 1.0 - _e123), metal::level(0.0));
    return _e126;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e121 = uv_1[0u];
    float _e123 = uv_1[1u];
    metal::float4 _e126 = _from.sample(_sampler, metal::float2(_e121, 1.0 - _e123), metal::level(0.0));
    return _e126;
}

float segment(
    thread metal::float2& q,
    thread metal::float2& a,
    thread metal::float2& b
) {
    metal::float2 pa = {};
    metal::float2 ba = {};
    metal::float2 _e124 = q;
    metal::float2 _e125 = a;
    pa = _e124 - _e125;
    metal::float2 _e127 = b;
    metal::float2 _e128 = a;
    ba = _e127 - _e128;
    metal::float2 _e130 = pa;
    metal::float2 _e131 = ba;
    metal::float2 _e132 = pa;
    metal::float2 _e133 = ba;
    metal::float2 _e135 = ba;
    metal::float2 _e136 = ba;
    return metal::length(_e130 - (_e131 * metal::clamp(metal::dot(_e132, _e133) / metal::dot(_e135, _e136), 0.0, 1.0)));
}

float glyph(
    thread float& g,
    thread metal::float2& q_1
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    float d = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    float d_1 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    metal::float2 param_28 = {};
    metal::float2 param_29 = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    metal::float2 param_32 = {};
    metal::float2 param_33 = {};
    metal::float2 param_34 = {};
    metal::float2 param_35 = {};
    float d_2 = {};
    metal::float2 param_36 = {};
    metal::float2 param_37 = {};
    metal::float2 param_38 = {};
    float d_3 = {};
    metal::float2 param_39 = {};
    metal::float2 param_40 = {};
    metal::float2 param_41 = {};
    float _e167 = g;
    if (_e167 < 0.5) {
        return 1.0;
    }
    float _e169 = g;
    if (_e169 < 1.5) {
        metal::float2 _e171 = q_1;
        return metal::length(_e171 - metal::float2(0.0, -0.27)) - 0.035;
    }
    float _e175 = g;
    if (_e175 < 2.5) {
        metal::float2 _e177 = q_1;
        metal::float2 _e180 = q_1;
        return metal::min(metal::length(_e177 - metal::float2(0.0, -0.25)), metal::length(_e180 - metal::float2(0.0, 0.1))) - 0.035;
    }
    float _e185 = g;
    if (_e185 < 3.5) {
        metal::float2 _e187 = q_1;
        param = _e187;
        param_1 = metal::float2(-0.17, 0.0);
        param_2 = metal::float2(0.17, 0.0);
        float _e188 = segment(param, param_1, param_2);
        return _e188 - 0.05;
    }
    float _e190 = g;
    if (_e190 < 4.5) {
        metal::float2 _e192 = q_1;
        param_3 = _e192;
        param_4 = metal::float2(-0.18, 0.1);
        param_5 = metal::float2(0.18, 0.1);
        float _e193 = segment(param_3, param_4, param_5);
        metal::float2 _e194 = q_1;
        param_6 = _e194;
        param_7 = metal::float2(-0.18, -0.1);
        param_8 = metal::float2(0.18, -0.1);
        float _e195 = segment(param_6, param_7, param_8);
        return metal::min(_e193, _e195) - 0.05;
    }
    float _e198 = g;
    if (_e198 < 5.5) {
        metal::float2 _e200 = q_1;
        param_9 = _e200;
        param_10 = metal::float2(-0.19, 0.0);
        param_11 = metal::float2(0.19, 0.0);
        float _e201 = segment(param_9, param_10, param_11);
        metal::float2 _e202 = q_1;
        param_12 = _e202;
        param_13 = metal::float2(0.0, -0.19);
        param_14 = metal::float2(0.0, 0.19);
        float _e203 = segment(param_12, param_13, param_14);
        return metal::min(_e201, _e203) - 0.05;
    }
    float _e206 = g;
    if (_e206 < 6.5) {
        metal::float2 _e208 = q_1;
        param_15 = _e208;
        param_16 = metal::float2(0.0, -0.2);
        param_17 = metal::float2(0.0, 0.2);
        float _e209 = segment(param_15, param_16, param_17);
        d = _e209;
        float _e210 = d;
        metal::float2 _e211 = q_1;
        param_18 = _e211;
        param_19 = metal::float2(-0.18, -0.11);
        param_20 = metal::float2(0.18, 0.11);
        float _e212 = segment(param_18, param_19, param_20);
        d = metal::min(_e210, _e212);
        float _e214 = d;
        metal::float2 _e215 = q_1;
        param_21 = _e215;
        param_22 = metal::float2(-0.18, 0.11);
        param_23 = metal::float2(0.18, -0.11);
        float _e216 = segment(param_21, param_22, param_23);
        d = metal::min(_e214, _e216);
        float _e218 = d;
        return _e218 - 0.05;
    }
    float _e220 = g;
    if (_e220 < 7.5) {
        metal::float2 _e222 = q_1;
        param_24 = _e222;
        param_25 = metal::float2(-0.06, -0.3);
        param_26 = metal::float2(-0.1, 0.3);
        float _e223 = segment(param_24, param_25, param_26);
        metal::float2 _e224 = q_1;
        param_27 = _e224;
        param_28 = metal::float2(0.12, -0.3);
        param_29 = metal::float2(0.08, 0.3);
        float _e225 = segment(param_27, param_28, param_29);
        d_1 = metal::min(_e223, _e225);
        float _e227 = d_1;
        metal::float2 _e228 = q_1;
        param_30 = _e228;
        param_31 = metal::float2(-0.24, 0.11);
        param_32 = metal::float2(0.24, 0.11);
        float _e229 = segment(param_30, param_31, param_32);
        metal::float2 _e230 = q_1;
        param_33 = _e230;
        param_34 = metal::float2(-0.24, -0.11);
        param_35 = metal::float2(0.24, -0.11);
        float _e231 = segment(param_33, param_34, param_35);
        d_1 = metal::min(_e227, metal::min(_e229, _e231));
        float _e234 = d_1;
        return _e234 - 0.05;
    }
    float _e236 = g;
    if (_e236 < 8.5) {
        metal::float2 _e238 = q_1;
        param_36 = _e238;
        param_37 = metal::float2(-0.2, -0.3);
        param_38 = metal::float2(0.2, 0.3);
        float _e239 = segment(param_36, param_37, param_38);
        d_2 = _e239;
        float _e240 = d_2;
        metal::float2 _e241 = q_1;
        d_2 = metal::min(_e240, metal::abs(metal::length(_e241 - metal::float2(-0.13, 0.19)) - 0.08));
        float _e247 = d_2;
        metal::float2 _e248 = q_1;
        d_2 = metal::min(_e247, metal::abs(metal::length(_e248 - metal::float2(0.13, -0.19)) - 0.08));
        float _e254 = d_2;
        return _e254 - 0.05;
    }
    metal::float2 _e256 = q_1;
    d_3 = metal::abs(metal::length(_e256) - 0.25);
    float _e260 = d_3;
    metal::float2 _e261 = q_1;
    d_3 = metal::min(_e260, metal::abs(metal::length(_e261 - metal::float2(-0.02, 0.0)) - 0.1));
    float _e267 = d_3;
    metal::float2 _e268 = q_1;
    param_39 = _e268;
    param_40 = metal::float2(0.08, 0.1);
    param_41 = metal::float2(0.08, -0.12);
    float _e269 = segment(param_39, param_40, param_41);
    d_3 = metal::min(_e267, _e269);
    float _e271 = d_3;
    return _e271 - 0.04;
}

float density(
    thread metal::float4& c
) {
    metal::float4 _e120 = c;
    float _e124 = c[3u];
    return metal::floor(metal::pow(metal::clamp(metal::dot(_e120.xyz, metal::float3(0.299, 0.587, 0.114)) * _e124, 0.0, 1.0), 0.75) * 9.99);
}

metal::float4 cellColor(
    thread metal::float2& center,
    thread metal::float2& dims,
    thread bool& incoming,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 c_1 = {};
    int i = {};
    metal::float2 o = {};
    metal::float2 st = {};
    metal::float4 local = {};
    metal::float2 param_42 = {};
    metal::float2 param_43 = {};
    c_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e167 = i;
            i = as_type<int>(as_type<uint>(_e167) + as_type<uint>(1));
        }
        loop_init = false;
        int _e129 = i;
        if (_e129 < 4) {
            int _e131 = i;
            float _e132 = static_cast<float>(_e131);
            int _e137 = i;
            metal::float2 _e145 = dims;
            o = ((metal::float2(_e132 - (metal::floor(_e132 / 2.0) * 2.0), metal::floor(static_cast<float>(_e137) / 2.0)) - metal::float2(0.5)) * 0.5) * _e145;
            metal::float2 _e147 = center;
            metal::float2 _e148 = o;
            float _e151 = uniforms.ratio;
            st = metal::clamp(((_e147 + _e148) / metal::float2(_e151, 1.0)) + metal::float2(0.5), metal::float2(0.0), metal::float2(1.0));
            bool _e159 = incoming;
            if (_e159) {
                metal::float2 _e160 = st;
                param_42 = _e160;
                metal::float4 _e161 = getToColor(param_42, _sampler, _to);
                local = _e161;
            } else {
                metal::float2 _e162 = st;
                param_43 = _e162;
                metal::float4 _e163 = getFromColor(param_43, _from, _sampler);
                local = _e163;
            }
            metal::float4 _e164 = local;
            metal::float4 _e165 = c_1;
            c_1 = _e165 + _e164;
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e169 = c_1;
    return _e169 * 0.25;
}

float hash12(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e121 = p;
    p3_ = metal::fract(_e121.xyx * 0.1031);
    metal::float3 _e125 = p3_;
    metal::float3 _e126 = p3_;
    metal::float3 _e131 = p3_;
    p3_ = _e131 + metal::float3(metal::dot(_e125, _e126.yzx + metal::float3(33.33)));
    float _e135 = p3_[0u];
    float _e137 = p3_[1u];
    float _e140 = p3_[2u];
    return metal::fract((_e135 + _e137) * _e140);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_1 = {};
    float h = {};
    metal::float2 fp = {};
    metal::float2 dims_1 = {};
    metal::float2 cell = {};
    metal::float2 center_1 = {};
    metal::float2 q_2 = {};
    float r = {};
    metal::float2 param_44 = {};
    float at = {};
    bool incoming_1 = {};
    metal::float4 c_2 = {};
    metal::float2 param_45 = {};
    metal::float2 param_46 = {};
    bool param_47 = {};
    float g_1 = {};
    metal::float4 param_48 = {};
    float scramble = {};
    metal::float2 param_49 = {};
    metal::float2 param_50 = {};
    float cover = {};
    float param_51 = {};
    metal::float2 param_52 = {};
    metal::float3 tint = {};
    metal::float3 local_1 = {};
    float alpha = {};
    float local_2 = {};
    metal::float3 behind = {};
    metal::float3 local_3 = {};
    metal::float4 back = {};
    metal::float4 text = {};
    float into = {};
    metal::float2 param_53 = {};
    float outof = {};
    metal::float2 param_54 = {};
    float show = {};
    metal::float4 image = {};
    metal::float4 local_4 = {};
    metal::float2 param_55 = {};
    metal::float2 param_56 = {};
    float _e161 = uniforms.progress;
    p_1 = _e161;
    float _e163 = uniforms.cellSize;
    h = _e163;
    metal::float2 _e164 = uv_2;
    float _e168 = uniforms.ratio;
    fp = (_e164 - metal::float2(0.5)) * metal::float2(_e168, 1.0);
    float _e171 = h;
    float _e173 = h;
    dims_1 = metal::float2(0.6 * _e171, _e173);
    metal::float2 _e175 = fp;
    metal::float2 _e176 = dims_1;
    cell = metal::floor(_e175 / _e176);
    metal::float2 _e179 = cell;
    metal::float2 _e182 = dims_1;
    center_1 = (_e179 + metal::float2(0.5)) * _e182;
    metal::float2 _e184 = fp;
    metal::float2 _e185 = center_1;
    float _e187 = h;
    q_2 = (_e184 - _e185) / metal::float2(_e187);
    metal::float2 _e190 = cell;
    param_44 = _e190 + metal::float2(100.0);
    float _e193 = hash12(param_44);
    r = _e193;
    float _e194 = r;
    at = 0.4 + (0.2 * _e194);
    float _e197 = p_1;
    float _e198 = at;
    incoming_1 = _e197 > _e198;
    metal::float2 _e200 = center_1;
    param_45 = _e200;
    metal::float2 _e201 = dims_1;
    param_46 = _e201;
    bool _e202 = incoming_1;
    param_47 = _e202;
    metal::float4 _e203 = cellColor(param_45, param_46, param_47, _from, _sampler, _to, uniforms);
    c_2 = _e203;
    metal::float4 _e204 = c_2;
    param_48 = _e204;
    float _e205 = density(param_48);
    g_1 = _e205;
    float _e206 = p_1;
    float _e207 = at;
    scramble = 1.0 - metal::smoothstep(0.02, 0.045, metal::abs(_e206 - _e207));
    metal::float2 _e212 = cell;
    float _e213 = p_1;
    param_49 = _e212 + (metal::float2(17.0, 31.0) * metal::floor(_e213 * 40.0));
    float _e218 = hash12(param_49);
    float _e219 = scramble;
    if (_e218 < _e219) {
        metal::float2 _e221 = cell;
        float _e223 = p_1;
        param_50 = (_e221 * 1.7) + (metal::float2(5.0, 11.0) * metal::floor(_e223 * 40.0));
        float _e228 = hash12(param_50);
        g_1 = 1.0 + metal::floor(9.0 * _e228);
    }
    float _e232 = g_1;
    param_51 = _e232;
    metal::float2 _e233 = q_2;
    param_52 = _e233;
    float _e234 = glyph(param_51, param_52);
    cover = 1.0 - metal::smoothstep(-0.02, 0.02, _e234);
    int _e238 = uniforms.colored;
    if (_e238 != 0) {
        metal::float4 _e240 = c_2;
        metal::float4 _e242 = c_2;
        float _e245 = c_2[0u];
        float _e247 = c_2[1u];
        float _e249 = c_2[2u];
        local_1 = metal::mix(_e240.xyz, _e242.xyz / metal::float3(metal::max(metal::max(_e245, metal::max(_e247, _e249)), 0.05)), metal::float3(0.7));
    } else {
        metal::float4 _e258 = uniforms.ink;
        local_1 = _e258.xyz;
    }
    metal::float3 _e260 = local_1;
    tint = _e260;
    int _e262 = uniforms.colored;
    if (_e262 != 0) {
        float _e265 = c_2[3u];
        local_2 = _e265;
    } else {
        float _e268 = uniforms.ink[3u];
        float _e270 = c_2[3u];
        local_2 = _e268 * _e270;
    }
    float _e272 = local_2;
    alpha = _e272;
    int _e274 = uniforms.colored;
    if (_e274 != 0) {
        metal::float4 _e277 = uniforms.background;
        metal::float4 _e279 = c_2;
        local_3 = metal::mix(_e277.xyz, _e279.xyz, metal::float3(0.3));
    } else {
        metal::float4 _e284 = uniforms.background;
        local_3 = _e284.xyz;
    }
    metal::float3 _e286 = local_3;
    behind = _e286;
    metal::float3 _e287 = behind;
    float _e290 = uniforms.background[3u];
    float _e292 = c_2[3u];
    back = metal::float4(_e287.x, _e287.y, _e287.z, _e290 * _e292);
    metal::float4 _e298 = back;
    metal::float3 _e299 = tint;
    metal::float3 _e302 = metal::clamp(_e299, metal::float3(0.0), metal::float3(1.0));
    float _e303 = alpha;
    float _e308 = cover;
    text = metal::mix(_e298, metal::float4(_e302.x, _e302.y, _e302.z, _e303), metal::float4(_e308));
    metal::float2 _e311 = cell;
    param_53 = _e311 + metal::float2(200.0);
    float _e314 = hash12(param_53);
    into = 0.05 + (0.22 * _e314);
    metal::float2 _e317 = cell;
    param_54 = _e317 + metal::float2(300.0);
    float _e320 = hash12(param_54);
    outof = 0.95 - (0.22 * _e320);
    float _e323 = into;
    float _e324 = into;
    float _e326 = p_1;
    float _e328 = outof;
    float _e330 = outof;
    float _e331 = p_1;
    show = metal::smoothstep(_e323, _e324 + 0.08, _e326) * (1.0 - metal::smoothstep(_e328 - 0.08, _e330, _e331));
    float _e335 = p_1;
    if (_e335 < 0.5) {
        metal::float2 _e337 = uv_2;
        param_55 = _e337;
        metal::float4 _e338 = getFromColor(param_55, _from, _sampler);
        local_4 = _e338;
    } else {
        metal::float2 _e339 = uv_2;
        param_56 = _e339;
        metal::float4 _e340 = getToColor(param_56, _sampler, _to);
        local_4 = _e340;
    }
    metal::float4 _e341 = local_4;
    image = _e341;
    metal::float4 _e342 = image;
    metal::float4 _e343 = text;
    float _e344 = show;
    return metal::mix(_e342, _e343, metal::float4(_e344));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_57 = {};
    metal::float2 _e120 = _uv_1;
    param_57 = _e120;
    metal::float4 _e121 = transition(param_57, _from, _sampler, _to, uniforms);
    _fragColor = _e121;
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
