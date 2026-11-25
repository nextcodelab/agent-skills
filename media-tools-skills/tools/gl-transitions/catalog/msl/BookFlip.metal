// BookFlip — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BookFlip.glsl
// Author: hong
// License: MIT
// Description: The right half of the outgoing image is a book page that turns over from right to left on the spine at the middle of the frame, curling near its free edge, its back bringing the left half of the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float perspective;
    float shading;
    float curl;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e48 = uv[0u];
    float _e50 = uv[1u];
    metal::float4 _e53 = _to.sample(_sampler, metal::float2(_e48, 1.0 - _e50), metal::level(0.0));
    return _e53;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e48 = uv_1[0u];
    float _e50 = uv_1[1u];
    metal::float4 _e53 = _from.sample(_sampler, metal::float2(_e48, 1.0 - _e50), metal::level(0.0));
    return _e53;
}

float cross2(
    thread metal::float2& a,
    thread metal::float2& b
) {
    float _e49 = a[0u];
    float _e51 = b[1u];
    float _e54 = a[1u];
    float _e56 = b[0u];
    return (_e49 * _e51) - (_e54 * _e56);
}

metal::float3 hitPage(
    thread metal::float2& eye,
    thread metal::float2& dir,
    thread float& a_1,
    thread float& k,
    thread float& straight,
    thread metal::float2& c,
    thread float& w
) {
    metal::float3 best = {};
    metal::float2 d = {};
    float den = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float u = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float t = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float r = {};
    metal::float2 oc = {};
    float qa = {};
    float qb = {};
    float disc = {};
    float sq = {};
    int i = {};
    float t_1 = {};
    float local = {};
    metal::float2 v = {};
    float db = {};
    float s = {};
    bool phi_255_ = {};
    bool phi_256_ = {};
    bool phi_297_ = {};
    best = metal::float3(-1.0, 0.0, 0.0);
    float _e76 = a_1;
    float _e78 = a_1;
    d = metal::float2(metal::cos(_e76), metal::sin(_e78));
    metal::float2 _e81 = d;
    param = _e81;
    metal::float2 _e82 = dir;
    param_1 = _e82;
    float _e83 = cross2(param, param_1);
    den = _e83;
    float _e84 = den;
    if (metal::abs(_e84) > 0.0000001) {
        metal::float2 _e87 = eye;
        param_2 = _e87;
        metal::float2 _e88 = dir;
        param_3 = _e88;
        float _e89 = cross2(param_2, param_3);
        float _e90 = den;
        u = _e89 / _e90;
        metal::float2 _e92 = eye;
        param_4 = _e92;
        metal::float2 _e93 = d;
        param_5 = _e93;
        float _e94 = cross2(param_4, param_5);
        float _e95 = den;
        t = _e94 / _e95;
        float _e97 = t;
        float _e99 = u;
        float _e102 = u;
        float _e103 = straight;
        if (((_e97 > 0.0) && (_e99 >= 0.0)) && (_e102 <= _e103)) {
            float _e106 = t;
            float _e107 = u;
            float _e108 = a_1;
            best = metal::float3(_e106, _e107, _e108);
        }
    }
    float _e110 = k;
    if (_e110 != 0.0) {
        float _e112 = k;
        r = 1.0 / _e112;
        metal::float2 _e114 = eye;
        metal::float2 _e115 = c;
        oc = _e114 - _e115;
        metal::float2 _e117 = dir;
        metal::float2 _e118 = dir;
        qa = metal::dot(_e117, _e118);
        metal::float2 _e120 = oc;
        metal::float2 _e121 = dir;
        qb = metal::dot(_e120, _e121);
        float _e123 = qb;
        float _e124 = qb;
        float _e126 = qa;
        metal::float2 _e127 = oc;
        metal::float2 _e128 = oc;
        float _e130 = r;
        float _e131 = r;
        disc = (_e123 * _e124) - (_e126 * (metal::dot(_e127, _e128) - (_e130 * _e131)));
        float _e136 = disc;
        if (_e136 >= 0.0) {
            float _e138 = disc;
            sq = metal::sqrt(_e138);
            i = 0;
            uint2 loop_bound = uint2(4294967295u);
            bool loop_init = true;
            while(true) {
                if (metal::all(loop_bound == uint2(0u))) { break; }
                loop_bound -= uint2(loop_bound.y == 0u, 1u);
                if (!loop_init) {
                    int _e209 = i;
                    i = as_type<int>(as_type<uint>(_e209) + as_type<uint>(1));
                }
                loop_init = false;
                int _e140 = i;
                if (_e140 < 2) {
                    float _e142 = qb;
                    int _e144 = i;
                    if (_e144 == 0) {
                        float _e146 = sq;
                        local = -(_e146);
                    } else {
                        float _e148 = sq;
                        local = _e148;
                    }
                    float _e149 = local;
                    float _e151 = qa;
                    t_1 = (-(_e142) + _e149) / _e151;
                    float _e153 = t_1;
                    bool _e154 = _e153 > 0.0;
                    phi_256_ = _e154;
                    if (_e154) {
                        float _e156 = best[0u];
                        bool _e157 = _e156 < 0.0;
                        phi_255_ = _e157;
                        if (!(_e157)) {
                            float _e159 = t_1;
                            float _e161 = best[0u];
                            phi_255_ = _e159 < _e161;
                        }
                        bool _e164 = phi_255_;
                        phi_256_ = _e164;
                    }
                    bool _e166 = phi_256_;
                    if (_e166) {
                        metal::float2 _e167 = oc;
                        float _e168 = t_1;
                        metal::float2 _e169 = dir;
                        float _e172 = k;
                        v = (_e167 + (_e169 * _e168)) * _e172;
                        float _e175 = v[0u];
                        float _e177 = v[1u];
                        float _e180 = a_1;
                        db = metal::atan2(_e175, -(_e177)) - _e180;
                        float _e182 = db;
                        float _e187 = db;
                        db = _e187 - (6.2831855 * metal::floor((_e182 + 3.1415927) / 6.2831855));
                        float _e189 = db;
                        float _e190 = k;
                        s = _e189 / _e190;
                        float _e192 = s;
                        bool _e193 = _e192 >= 0.0;
                        phi_297_ = _e193;
                        if (_e193) {
                            float _e194 = s;
                            float _e195 = w;
                            float _e196 = straight;
                            phi_297_ = _e194 <= (_e195 - _e196);
                        }
                        bool _e200 = phi_297_;
                        if (_e200) {
                            float _e201 = t_1;
                            float _e202 = straight;
                            float _e203 = s;
                            float _e205 = a_1;
                            float _e206 = db;
                            best = metal::float3(_e201, _e202 + _e203, _e205 + _e206);
                        }
                    }
                    continue;
                } else {
                    break;
                }
            }
        }
    }
    metal::float3 _e211 = best;
    return _e211;
}

metal::float2 curlPoint(
    thread metal::float2& c_1,
    thread float& k_1,
    thread float& b_1
) {
    metal::float2 _e49 = c_1;
    float _e50 = b_1;
    float _e52 = b_1;
    float _e56 = k_1;
    return _e49 + (metal::float2(metal::sin(_e50), -(metal::cos(_e52))) / metal::float2(_e56));
}

float pageAngle_u0028_(
    constant Uniforms& uniforms
) {
    float p = {};
    float _e48 = uniforms.progress;
    p = metal::clamp(_e48, 0.0, 1.0);
    float _e50 = p;
    float _e52 = p;
    float _e53 = p;
    return (3.1415927 * _e50) * (0.35 + (_e52 * (1.95 - (1.3 * _e53))));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float a_2 = {};
    float lift = {};
    float w_1 = {};
    float x = {};
    float dist = {};
    metal::float2 eye_1 = {};
    metal::float2 dir_1 = {};
    metal::float2 d_1 = {};
    float k_2 = {};
    float straight_1 = {};
    float local_1 = {};
    metal::float2 c_2 = {};
    metal::float2 bend = {};
    metal::float2 middle = {};
    metal::float2 local_2 = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    float param_8 = {};
    metal::float2 edge = {};
    metal::float2 local_3 = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float aa = {};
    metal::float4 img = {};
    float m = {};
    metal::float3 hit = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    metal::float2 param_17 = {};
    float param_18 = {};
    float t_2 = {};
    float u_1 = {};
    float b_2 = {};
    metal::float2 pt = {};
    float y = {};
    float edgeX = {};
    float local_4 = {};
    float local_5 = {};
    metal::float2 normal = {};
    bool front = {};
    metal::float4 local_6 = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    float diffuse = {};
    metal::float2 local_7 = {};
    float shade = {};
    metal::float4 color = {};
    metal::float4 local_8 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 toEdge = {};
    float cosEdge = {};
    float blocked = {};
    float shadow = {};
    float slope = {};
    metal::float3 reach = {};
    float lo = {};
    float hi = {};
    float soft = {};
    bool phi_551_ = {};
    float _e110 = pageAngle_u0028_(uniforms);
    a_2 = _e110;
    float _e111 = a_2;
    lift = metal::sin(_e111);
    float _e114 = uniforms.ratio;
    w_1 = 0.5 * _e114;
    float _e117 = uv_2[0u];
    float _e119 = uniforms.ratio;
    float _e121 = w_1;
    x = (_e117 * _e119) - _e121;
    float _e123 = w_1;
    float _e125 = uniforms.perspective;
    dist = _e123 * (1.0 + (1.5 / metal::max(_e125, 0.01)));
    float _e130 = dist;
    eye_1 = metal::float2(0.0, _e130);
    float _e132 = x;
    float _e133 = dist;
    dir_1 = metal::float2(_e132, -(_e133));
    float _e136 = a_2;
    float _e138 = a_2;
    d_1 = metal::float2(metal::cos(_e136), metal::sin(_e138));
    float _e142 = uniforms.curl;
    float _e145 = lift;
    float _e147 = w_1;
    k_2 = (-(metal::clamp(_e142, 0.0, 1.0)) * _e145) / (0.45 * _e147);
    float _e150 = k_2;
    float _e153 = w_1;
    if (((metal::abs(_e150) * 0.45) * _e153) <= 0.0001) {
        k_2 = 0.0;
    }
    float _e156 = k_2;
    if (_e156 != 0.0) {
        float _e158 = w_1;
        local_1 = 0.55 * _e158;
    } else {
        float _e160 = w_1;
        local_1 = _e160;
    }
    float _e161 = local_1;
    straight_1 = _e161;
    float _e162 = straight_1;
    metal::float2 _e163 = d_1;
    float _e166 = d_1[1u];
    float _e169 = d_1[0u];
    float _e171 = k_2;
    float _e173 = k_2;
    c_2 = (_e163 * _e162) + (metal::float2(-(_e166), _e169) / metal::float2((_e171 != 0.0) ? _e173 : 1.0));
    float _e178 = straight_1;
    metal::float2 _e179 = d_1;
    bend = _e179 * _e178;
    float _e181 = k_2;
    if (_e181 != 0.0) {
        float _e183 = a_2;
        float _e184 = k_2;
        float _e186 = w_1;
        float _e187 = straight_1;
        metal::float2 _e191 = c_2;
        param_6 = _e191;
        float _e192 = k_2;
        param_7 = _e192;
        param_8 = _e183 + ((0.5 * _e184) * (_e186 - _e187));
        metal::float2 _e193 = curlPoint(param_6, param_7, param_8);
        local_2 = _e193;
    } else {
        metal::float2 _e194 = bend;
        local_2 = _e194;
    }
    metal::float2 _e195 = local_2;
    middle = _e195;
    float _e196 = k_2;
    if (_e196 != 0.0) {
        float _e198 = a_2;
        float _e199 = k_2;
        float _e200 = w_1;
        float _e201 = straight_1;
        metal::float2 _e205 = c_2;
        param_9 = _e205;
        float _e206 = k_2;
        param_10 = _e206;
        param_11 = _e198 + (_e199 * (_e200 - _e201));
        metal::float2 _e207 = curlPoint(param_9, param_10, param_11);
        local_3 = _e207;
    } else {
        metal::float2 _e208 = bend;
        local_3 = _e208;
    }
    metal::float2 _e209 = local_3;
    edge = _e209;
    float _e210 = lift;
    aa = 0.0015 * metal::min(20.0 * _e210, 1.0);
    img = metal::float4(0.0, 0.0, 0.0, 0.0);
    m = 0.0;
    metal::float2 _e214 = eye_1;
    param_12 = _e214;
    metal::float2 _e215 = dir_1;
    param_13 = _e215;
    float _e216 = a_2;
    param_14 = _e216;
    float _e217 = k_2;
    param_15 = _e217;
    float _e218 = straight_1;
    param_16 = _e218;
    metal::float2 _e219 = c_2;
    param_17 = _e219;
    float _e220 = w_1;
    param_18 = _e220;
    metal::float3 _e221 = hitPage(param_12, param_13, param_14, param_15, param_16, param_17, param_18);
    hit = _e221;
    float _e223 = hit[0u];
    if (_e223 > 0.0) {
        float _e226 = hit[0u];
        t_2 = _e226;
        float _e228 = hit[1u];
        u_1 = _e228;
        float _e230 = hit[2u];
        b_2 = _e230;
        metal::float2 _e231 = eye_1;
        float _e232 = t_2;
        metal::float2 _e233 = dir_1;
        pt = _e231 + (_e233 * _e232);
        float _e237 = uv_2[1u];
        float _e239 = t_2;
        y = metal::clamp(0.5 + ((_e237 - 0.5) * _e239), 0.0, 1.0);
        float _e244 = edge[0u];
        float _e245 = dist;
        float _e247 = dist;
        float _e249 = edge[1u];
        edgeX = (_e244 * _e245) / metal::max(_e247 - _e249, 0.0001);
        float _e253 = aa;
        bool _e254 = _e253 > 0.0;
        phi_551_ = _e254;
        if (_e254) {
            float _e255 = u_1;
            float _e256 = k_2;
            if (_e256 != 0.0) {
                float _e258 = straight_1;
                local_4 = _e258;
            } else {
                float _e259 = w_1;
                local_4 = 0.5 * _e259;
            }
            float _e261 = local_4;
            phi_551_ = _e255 > _e261;
        }
        bool _e264 = phi_551_;
        if (_e264) {
            float _e265 = x;
            float _e266 = edgeX;
            float _e269 = aa;
            local_5 = metal::clamp(metal::abs(_e265 - _e266) / _e269, 0.0, 1.0);
        } else {
            local_5 = 1.0;
        }
        float _e272 = local_5;
        m = _e272;
        float _e273 = b_2;
        float _e276 = b_2;
        normal = metal::float2(-(metal::sin(_e273)), metal::cos(_e276));
        metal::float2 _e279 = normal;
        metal::float2 _e280 = eye_1;
        metal::float2 _e281 = pt;
        front = metal::dot(_e279, _e280 - _e281) > 0.0;
        bool _e285 = front;
        if (_e285) {
            float _e286 = w_1;
            float _e287 = u_1;
            float _e289 = w_1;
            float _e291 = uniforms.ratio;
            float _e294 = uniforms.ratio;
            float _e296 = y;
            param_19 = metal::float2(metal::clamp(_e286 + _e287, _e289, _e291) / _e294, _e296);
            metal::float4 _e298 = getFromColor(param_19, _from, _sampler);
            local_6 = _e298;
        } else {
            float _e299 = w_1;
            float _e300 = u_1;
            float _e302 = w_1;
            float _e305 = uniforms.ratio;
            float _e307 = y;
            param_20 = metal::float2(metal::clamp(_e299 - _e300, 0.0, _e302) / _e305, _e307);
            metal::float4 _e309 = getToColor(param_20, _sampler, _to);
            local_6 = _e309;
        }
        metal::float4 _e310 = local_6;
        img = _e310;
        bool _e311 = front;
        if (_e311) {
            metal::float2 _e312 = normal;
            local_7 = _e312;
        } else {
            metal::float2 _e313 = normal;
            local_7 = -(_e313);
        }
        metal::float2 _e315 = local_7;
        diffuse = metal::max(metal::dot(_e315, metal::float2(-0.447214, 0.894427)), 0.0) / 0.894427;
        float _e319 = diffuse;
        float _e323 = uniforms.shading;
        shade = metal::mix(1.0, 0.25 + (0.75 * _e319), _e323);
        float _e326 = uniforms.shading;
        float _e328 = lift;
        float _e330 = u_1;
        float _e332 = w_1;
        float _e338 = shade;
        shade = _e338 * (1.0 - (((0.35 * _e326) * _e328) * metal::exp(-(_e330) / (0.04 * _e332))));
        float _e340 = shade;
        metal::float4 _e341 = img;
        metal::float3 _e343 = _e341.xyz * _e340;
        img[0u] = _e343.x;
        img[1u] = _e343.y;
        img[2u] = _e343.z;
        float _e350 = m;
        if (_e350 >= 1.0) {
            metal::float4 _e352 = img;
            return _e352;
        }
    }
    float _e353 = x;
    if (_e353 < 0.0) {
        metal::float2 _e355 = uv_2;
        param_21 = _e355;
        metal::float4 _e356 = getFromColor(param_21, _from, _sampler);
        local_8 = _e356;
    } else {
        metal::float2 _e357 = uv_2;
        param_22 = _e357;
        metal::float4 _e358 = getToColor(param_22, _sampler, _to);
        local_8 = _e358;
    }
    metal::float4 _e359 = local_8;
    color = _e359;
    metal::float2 _e360 = edge;
    float _e361 = x;
    toEdge = _e360 - metal::float2(_e361, 0.0);
    float _e365 = toEdge[0u];
    metal::float2 _e366 = toEdge;
    cosEdge = _e365 / metal::max(metal::length(_e366), 0.000001);
    float _e370 = x;
    float _e373 = cosEdge;
    blocked = 0.5 * metal::abs(((_e370 < 0.0) ? 1.0 : -1.0) - _e373);
    float _e377 = blocked;
    float _e378 = blocked;
    float _e380 = blocked;
    shadow = (_e377 * _e378) * (3.0 - (2.0 * _e380));
    slope = 0.50000054;
    float _e385 = bend[0u];
    float _e387 = middle[0u];
    float _e389 = edge[0u];
    float _e391 = slope;
    float _e393 = bend[1u];
    float _e395 = middle[1u];
    float _e397 = edge[1u];
    reach = metal::float3(_e385, _e387, _e389) + (metal::float3(_e393, _e395, _e397) * _e391);
    float _e402 = reach[0u];
    float _e404 = reach[1u];
    float _e406 = reach[2u];
    lo = metal::min(0.0, metal::min(_e402, metal::min(_e404, _e406)));
    float _e411 = reach[0u];
    float _e413 = reach[1u];
    float _e415 = reach[2u];
    hi = metal::max(0.0, metal::max(_e411, metal::max(_e413, _e415)));
    float _e420 = edge[1u];
    soft = metal::max(0.25 * _e420, 0.00001);
    float _e423 = shadow;
    float _e425 = x;
    float _e426 = lo;
    float _e428 = hi;
    float _e429 = x;
    float _e432 = soft;
    float _e437 = lift;
    shadow = metal::max(0.5 * _e423, (0.85 * metal::clamp((metal::min(_e425 - _e426, _e428 - _e429) / _e432) + 0.5, 0.0, 1.0)) * metal::min(4.0 * _e437, 1.0));
    float _e443 = uniforms.shading;
    float _e444 = shadow;
    metal::float4 _e447 = color;
    metal::float3 _e449 = _e447.xyz * (1.0 - (_e443 * _e444));
    color[0u] = _e449.x;
    color[1u] = _e449.y;
    color[2u] = _e449.z;
    metal::float4 _e456 = color;
    metal::float4 _e457 = img;
    float _e458 = m;
    return metal::mix(_e456, _e457, metal::float4(_e458));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_23 = {};
    metal::float2 _e47 = _uv_1;
    param_23 = _e47;
    metal::float4 _e48 = transition(param_23, _from, _sampler, _to, uniforms);
    _fragColor = _e48;
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
