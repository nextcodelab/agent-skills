// Crumple — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Crumple.glsl
// Author: gre
// License: MIT
// Description: The outgoing image crumples into a creased paper ball, shaded along its folds, which is then tossed away to reveal the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int creases;
    float size;
    metal::float2 direction;
    char _pad5[8];
    metal::float4 paper;
    metal::float4 shadow;
};

metal::float2 hash2(
    thread metal::float2& p
) {
    metal::float2 _e83 = p;
    metal::float2 _e85 = p;
    p = metal::float2(metal::dot(_e83, metal::float2(127.1, 311.7)), metal::dot(_e85, metal::float2(269.5, 183.3)));
    metal::float2 _e88 = p;
    return metal::fract(metal::sin(_e88) * 43758.547);
}

void fold(
    thread metal::float2& x,
    thread float& seed,
    thread int& n,
    thread metal::float2& span,
    thread float& len,
    thread float& c,
    thread float& px,
    thread float& weight,
    thread metal::float2& grad,
    thread metal::float2& shift,
    thread float& valley,
    thread float& ridge
) {
    float tilt = {};
    int i = {};
    float fi = {};
    metal::float2 h = {};
    metal::float2 param = {};
    metal::float2 g = {};
    metal::float2 param_1 = {};
    metal::float2 o = {};
    metal::float2 nrm = {};
    float d = {};
    float along = {};
    float l = {};
    float start = {};
    float act = {};
    float amp = {};
    float side = {};
    float line = {};
    int _e111 = n;
    tilt = 2.0 / metal::sqrt(static_cast<float>(_e111));
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e240 = i;
            i = as_type<int>(as_type<uint>(_e240) + as_type<uint>(1));
        }
        loop_init = false;
        int _e115 = i;
        if (_e115 < 32) {
            int _e117 = i;
            int _e118 = n;
            if (_e117 >= _e118) {
                break;
            }
            int _e120 = i;
            fi = static_cast<float>(_e120);
            float _e122 = fi;
            float _e123 = seed;
            param = metal::float2(_e122, _e123);
            metal::float2 _e125 = hash2(param);
            h = _e125;
            float _e126 = fi;
            float _e127 = seed;
            param_1 = metal::float2(_e126, _e127 + 11.8);
            metal::float2 _e130 = hash2(param_1);
            g = _e130;
            metal::float2 _e131 = h;
            metal::float2 _e135 = span;
            o = ((_e131 - metal::float2(0.5)) * 2.0) * _e135;
            float _e138 = g[0u];
            float _e142 = g[0u];
            nrm = metal::float2(metal::cos(6.2831855 * _e138), metal::sin(6.2831855 * _e142));
            metal::float2 _e146 = x;
            metal::float2 _e147 = o;
            metal::float2 _e149 = nrm;
            d = metal::dot(_e146 - _e147, _e149);
            metal::float2 _e151 = x;
            metal::float2 _e152 = o;
            float _e155 = nrm[1u];
            float _e158 = nrm[0u];
            along = metal::dot(_e151 - _e152, metal::float2(-(_e155), _e158));
            float _e161 = len;
            float _e163 = g[1u];
            l = _e161 * (0.5 + _e163);
            float _e166 = fi;
            int _e168 = n;
            start = (0.4 * _e166) / static_cast<float>(_e168);
            float _e171 = weight;
            float _e172 = start;
            float _e173 = start;
            float _e175 = c;
            float _e178 = l;
            float _e180 = l;
            float _e181 = along;
            act = (_e171 * metal::smoothstep(_e172, _e173 + 0.3, _e175)) * (1.0 - metal::smoothstep(0.5 * _e178, _e180, metal::abs(_e181)));
            float _e187 = h[0u];
            float _e191 = h[1u];
            amp = ((_e187 > 0.5) ? 1.0 : -1.0) * (0.5 + (0.5 * _e191));
            float _e195 = d;
            float _e196 = d;
            float _e198 = px;
            side = _e195 / (metal::abs(_e196) + _e198);
            float _e201 = act;
            float _e202 = amp;
            float _e204 = side;
            metal::float2 _e206 = nrm;
            float _e208 = tilt;
            metal::float2 _e210 = grad;
            grad = _e210 + ((_e206 * ((_e201 * _e202) * _e204)) * _e208);
            float _e212 = act;
            float _e214 = side;
            metal::float2 _e216 = nrm;
            metal::float2 _e218 = shift;
            shift = _e218 + (_e216 * ((_e212 * 0.03) * _e214));
            float _e220 = px;
            float _e222 = d;
            line = 1.0 - metal::smoothstep(0.0, 2.0 * _e220, metal::abs(_e222));
            float _e226 = amp;
            if (_e226 < 0.0) {
                float _e228 = act;
                float _e229 = line;
                float _e231 = valley;
                valley = _e231 + (_e228 * _e229);
            } else {
                float _e233 = act;
                float _e234 = line;
                float _e236 = amp;
                float _e238 = ridge;
                ridge = _e238 + ((_e233 * _e234) * _e236);
            }
            continue;
        } else {
            break;
        }
    }
    return;
}

float frame(
    thread metal::float2& a,
    constant Uniforms& uniforms
) {
    float _e84 = uniforms.ratio;
    float _e87 = a[0u];
    float _e92 = a[1u];
    return metal::min((0.5 * _e84) / metal::max(metal::abs(_e87), 0.0001), 0.5 / metal::max(metal::abs(_e92), 0.0001));
}

float outline(
    thread metal::float2& a_1,
    thread float& c_1,
    thread float& k,
    thread float& radius,
    constant Uniforms& uniforms
) {
    float rect = {};
    metal::float2 param_2 = {};
    float th = {};
    float buckle = {};
    float i_1 = {};
    float a0_ = {};
    float a1_ = {};
    metal::float2 v0_ = {};
    metal::float2 param_3 = {};
    metal::float2 v1_ = {};
    metal::float2 param_4 = {};
    metal::float2 e = {};
    float ball = {};
    metal::float2 _e99 = a_1;
    param_2 = _e99;
    float _e100 = frame(param_2, uniforms);
    rect = _e100;
    float _e102 = a_1[1u];
    float _e104 = a_1[0u];
    th = metal::atan2(_e102, _e104);
    float _e106 = th;
    float _e113 = th;
    float _e120 = th;
    buckle = ((0.03 + (0.05 * metal::abs(metal::sin((4.0 * _e106) + 0.7)))) + (0.03 * metal::abs(metal::sin((9.0 * _e113) + 2.0)))) + (0.015 * metal::abs(metal::sin((23.0 * _e120) + 1.3)));
    float _e127 = th;
    i_1 = metal::floor(((_e127 / 6.2831855) + 0.5) * 9.0);
    float _e132 = i_1;
    a0_ = (((_e132 * 2.0) * 3.1415927) / 9.0) - 3.1415927;
    float _e137 = a0_;
    a1_ = _e137 + 0.6981317;
    float _e139 = a0_;
    float _e141 = a0_;
    float _e144 = i_1;
    param_3 = metal::float2(_e144 - (metal::floor(_e144 / 9.0) * 9.0), 3.0);
    metal::float2 _e150 = hash2(param_3);
    v0_ = metal::float2(metal::cos(_e139), metal::sin(_e141)) * (0.78 + (0.27 * _e150.x));
    float _e155 = a1_;
    float _e157 = a1_;
    float _e160 = i_1;
    float _e161 = _e160 + 1.0;
    param_4 = metal::float2(_e161 - (metal::floor(_e161 / 9.0) * 9.0), 3.0);
    metal::float2 _e167 = hash2(param_4);
    v1_ = metal::float2(metal::cos(_e155), metal::sin(_e157)) * (0.78 + (0.27 * _e167.x));
    metal::float2 _e172 = v1_;
    metal::float2 _e173 = v0_;
    e = _e172 - _e173;
    float _e175 = radius;
    float _e177 = v0_[0u];
    float _e179 = e[1u];
    float _e182 = v0_[1u];
    float _e184 = e[0u];
    float _e189 = a_1[0u];
    float _e191 = e[1u];
    float _e194 = a_1[1u];
    float _e196 = e[0u];
    ball = (_e175 * ((_e177 * _e179) - (_e182 * _e184))) / ((_e189 * _e191) - (_e194 * _e196));
    float _e200 = rect;
    float _e201 = c_1;
    float _e204 = c_1;
    float _e205 = buckle;
    float _e209 = ball;
    float _e210 = k;
    return metal::mix((_e200 * metal::mix(1.0, 0.75, _e201)) * (1.0 - (_e204 * _e205)), _e209, _e210);
}

metal::float2x2 rot(
    thread float& a_2
) {
    float s = {};
    float c_2 = {};
    float _e85 = a_2;
    s = metal::sin(_e85);
    float _e87 = a_2;
    c_2 = metal::cos(_e87);
    float _e89 = c_2;
    float _e90 = s;
    float _e92 = s;
    float _e93 = c_2;
    return metal::float2x2(metal::float2(_e89, -(_e90)), metal::float2(_e92, _e93));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e84 = uv[0u];
    float _e86 = uv[1u];
    metal::float4 _e89 = _to.sample(_sampler, metal::float2(_e84, 1.0 - _e86), metal::level(0.0));
    return _e89;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e84 = uv_1[0u];
    float _e86 = uv_1[1u];
    metal::float4 _e89 = _from.sample(_sampler, metal::float2(_e84, 1.0 - _e86), metal::level(0.0));
    return _e89;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_5 = {};
    metal::float4 b = {};
    metal::float2 param_6 = {};
    float c_3 = {};
    float k_1 = {};
    float t = {};
    metal::float2 dir = {};
    metal::float2 local = {};
    float radius_1 = {};
    float reach = {};
    float bend = {};
    metal::float2 center = {};
    float angle = {};
    float lift = {};
    metal::float2 p_1 = {};
    metal::float2 sp = {};
    float param_7 = {};
    float sl = {};
    float sd = {};
    metal::float2 local_1 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float blur = {};
    metal::float4 col = {};
    metal::float2 q = {};
    float param_12 = {};
    float l_1 = {};
    metal::float2 dq = {};
    metal::float2 local_2 = {};
    float edge = {};
    metal::float2 param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float aa = {};
    float inside = {};
    float r = {};
    float rect_1 = {};
    metal::float2 param_17 = {};
    metal::float2 s_1 = {};
    int count = {};
    int local_3 = {};
    metal::float2 grad_1 = {};
    metal::float2 shift_1 = {};
    float valley_1 = {};
    float ridge_1 = {};
    metal::float2 param_18 = {};
    float param_19 = {};
    int param_20 = {};
    metal::float2 param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    float param_25 = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    float param_28 = {};
    float param_29 = {};
    metal::float2 g2_ = {};
    metal::float2 s2_ = {};
    float v2_ = {};
    float r2_ = {};
    metal::float2 param_30 = {};
    float param_31 = {};
    int param_32 = {};
    metal::float2 param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float param_36 = {};
    float param_37 = {};
    metal::float2 param_38 = {};
    metal::float2 param_39 = {};
    float param_40 = {};
    float param_41 = {};
    metal::float2 piece = {};
    float rr = {};
    metal::float3 sphere = {};
    metal::float3 n_1 = {};
    float param_42 = {};
    metal::float3 light = {};
    float diffuse = {};
    metal::float3 hv = {};
    float spec = {};
    float level = {};
    float relief = {};
    float shade = {};
    metal::float2 f = {};
    metal::float4 img = {};
    metal::float2 param_43 = {};
    metal::float4 ball_1 = {};
    float m = {};
    metal::float4 o_1 = {};
    metal::float4 local_4 = {};
    float _e179 = uniforms.progress;
    if (_e179 <= 0.0) {
        metal::float2 _e181 = uv_2;
        param_5 = _e181;
        metal::float4 _e182 = getFromColor(param_5, _from, _sampler);
        return _e182;
    }
    metal::float2 _e183 = uv_2;
    param_6 = _e183;
    metal::float4 _e184 = getToColor(param_6, _sampler, _to);
    b = _e184;
    float _e186 = uniforms.progress;
    if (_e186 >= 1.0) {
        metal::float4 _e188 = b;
        return _e188;
    }
    float _e190 = uniforms.progress;
    c_3 = metal::smoothstep(0.0, 0.6, _e190);
    float _e193 = uniforms.progress;
    k_1 = metal::smoothstep(0.1, 0.62, _e193);
    float _e196 = uniforms.progress;
    t = metal::smoothstep(0.58, 1.0, _e196);
    float _e198 = t;
    float _e199 = t;
    t = _e199 * _e198;
    metal::float2 _e202 = uniforms.direction;
    if (metal::length(_e202) > 0.0) {
        metal::float2 _e206 = uniforms.direction;
        local = metal::normalize(_e206);
    } else {
        local = metal::float2(1.0, 0.0);
    }
    metal::float2 _e208 = local;
    dir = _e208;
    float _e210 = uniforms.size;
    float _e212 = t;
    radius_1 = metal::max(_e210, 0.01) * metal::mix(1.0, 0.6, _e212);
    float _e216 = dir[0u];
    float _e219 = uniforms.ratio;
    float _e222 = dir[1u];
    float _e226 = radius_1;
    reach = ((0.5 * ((metal::abs(_e216) * _e219) + metal::abs(_e222))) + (1.2 * _e226)) + 0.3;
    float _e231 = dir[0u];
    bend = (_e231 < 0.0) ? -1.0 : 1.0;
    metal::float2 _e234 = dir;
    float _e235 = reach;
    float _e237 = t;
    float _e240 = dir[1u];
    float _e243 = dir[0u];
    float _e246 = bend;
    float _e248 = t;
    center = ((_e234 * _e235) * _e237) + (((metal::float2(-(_e240), _e243) * 0.15) * _e246) * metal::sin(3.1415927 * _e248));
    float _e253 = c_3;
    float _e255 = bend;
    float _e257 = t;
    angle = (0.6 * _e253) - ((5.0 * _e255) * _e257);
    float _e260 = c_3;
    float _e262 = t;
    lift = (0.012 * _e260) + (0.06 * _e262);
    metal::float2 _e265 = uv_2;
    float _e269 = uniforms.ratio;
    p_1 = (_e265 - metal::float2(0.5)) * metal::float2(_e269, 1.0);
    float _e272 = angle;
    param_7 = _e272;
    metal::float2x2 _e273 = rot(param_7);
    metal::float2 _e274 = p_1;
    metal::float2 _e275 = center;
    float _e277 = lift;
    sp = _e273 * ((_e274 - _e275) - (metal::float2(0.6, -1.0) * _e277));
    metal::float2 _e281 = sp;
    sl = metal::length(_e281);
    float _e283 = sl;
    float _e284 = sl;
    if (_e284 > 0.00001) {
        metal::float2 _e286 = sp;
        float _e287 = sl;
        local_1 = _e286 / metal::float2(_e287);
    } else {
        local_1 = metal::float2(1.0, 0.0);
    }
    metal::float2 _e290 = local_1;
    param_8 = _e290;
    float _e291 = c_3;
    param_9 = _e291;
    float _e292 = k_1;
    param_10 = _e292;
    float _e293 = radius_1;
    param_11 = _e293;
    float _e294 = outline(param_8, param_9, param_10, param_11, uniforms);
    sd = _e283 - _e294;
    float _e296 = lift;
    blur = 0.005 + (1.2 * _e296);
    metal::float4 _e299 = b;
    metal::float4 _e302 = uniforms.shadow;
    float _e306 = uniforms.shadow[3u];
    float _e307 = c_3;
    float _e309 = blur;
    float _e311 = blur;
    float _e312 = sd;
    metal::float3 _e317 = metal::mix(_e299.xyz, _e302.xyz, metal::float3((_e306 * _e307) * (1.0 - metal::smoothstep(-(_e309), _e311, _e312))));
    float _e319 = b[3u];
    col = metal::float4(_e317.x, _e317.y, _e317.z, _e319);
    float _e324 = angle;
    param_12 = _e324;
    metal::float2x2 _e325 = rot(param_12);
    metal::float2 _e326 = p_1;
    metal::float2 _e327 = center;
    q = _e325 * (_e326 - _e327);
    metal::float2 _e330 = q;
    l_1 = metal::length(_e330);
    float _e332 = l_1;
    if (_e332 > 0.00001) {
        metal::float2 _e334 = q;
        float _e335 = l_1;
        local_2 = _e334 / metal::float2(_e335);
    } else {
        local_2 = metal::float2(1.0, 0.0);
    }
    metal::float2 _e338 = local_2;
    dq = _e338;
    metal::float2 _e339 = dq;
    param_13 = _e339;
    float _e340 = c_3;
    param_14 = _e340;
    float _e341 = k_1;
    param_15 = _e341;
    float _e342 = radius_1;
    param_16 = _e342;
    float _e343 = outline(param_13, param_14, param_15, param_16, uniforms);
    edge = _e343;
    float _e345 = uniforms.progress;
    aa = (0.003 * metal::smoothstep(0.0, 0.1, _e345)) + 0.00001;
    float _e349 = aa;
    float _e351 = aa;
    float _e352 = l_1;
    float _e353 = edge;
    inside = 1.0 - metal::smoothstep(-(_e349), _e351, _e352 - _e353);
    float _e357 = inside;
    if (_e357 <= 0.0) {
        metal::float4 _e359 = col;
        return _e359;
    }
    float _e360 = l_1;
    float _e361 = edge;
    r = _e360 / _e361;
    metal::float2 _e363 = dq;
    param_17 = _e363;
    float _e364 = frame(param_17, uniforms);
    rect_1 = _e364;
    metal::float2 _e365 = dq;
    float _e366 = rect_1;
    float _e368 = r;
    float _e369 = r;
    float _e370 = r;
    float _e374 = k_1;
    s_1 = (_e365 * _e366) * metal::mix(_e368, _e369 * (0.6 + (0.4 * _e370)), _e374);
    int _e378 = uniforms.creases;
    if (_e378 < 1) {
        local_3 = 1;
    } else {
        int _e381 = uniforms.creases;
        local_3 = _e381;
    }
    int _e382 = local_3;
    count = _e382;
    grad_1 = metal::float2(0.0, 0.0);
    shift_1 = metal::float2(0.0, 0.0);
    valley_1 = 0.0;
    ridge_1 = 0.0;
    float _e384 = uniforms.ratio;
    float _e387 = rect_1;
    float _e389 = edge;
    float _e391 = k_1;
    metal::float2 _e394 = s_1;
    param_18 = _e394;
    param_19 = 7.3;
    int _e395 = count;
    param_20 = _e395;
    param_21 = metal::float2(_e384, 1.0) * 0.45;
    param_22 = 0.6;
    float _e396 = c_3;
    param_23 = _e396;
    param_24 = (0.003 * _e387) / _e389;
    param_25 = 1.0 - (0.8 * _e391);
    metal::float2 _e397 = grad_1;
    param_26 = _e397;
    metal::float2 _e398 = shift_1;
    param_27 = _e398;
    float _e399 = valley_1;
    param_28 = _e399;
    float _e400 = ridge_1;
    param_29 = _e400;
    fold(param_18, param_19, param_20, param_21, param_22, param_23, param_24, param_25, param_26, param_27, param_28, param_29);
    metal::float2 _e401 = param_26;
    grad_1 = _e401;
    metal::float2 _e402 = param_27;
    shift_1 = _e402;
    float _e403 = param_28;
    valley_1 = _e403;
    float _e404 = param_29;
    ridge_1 = _e404;
    g2_ = metal::float2(0.0, 0.0);
    s2_ = metal::float2(0.0, 0.0);
    v2_ = 0.0;
    r2_ = 0.0;
    metal::float2 _e405 = q;
    float _e406 = radius_1;
    float _e409 = radius_1;
    param_30 = _e405 / metal::float2(_e406);
    param_31 = 2.9;
    int _e411 = count;
    param_32 = _e411;
    param_33 = metal::float2(0.7, 0.7);
    param_34 = 8.0;
    float _e412 = k_1;
    param_35 = _e412;
    param_36 = 0.003 / _e409;
    float _e413 = k_1;
    param_37 = _e413;
    metal::float2 _e414 = g2_;
    param_38 = _e414;
    metal::float2 _e415 = s2_;
    param_39 = _e415;
    float _e416 = v2_;
    param_40 = _e416;
    float _e417 = r2_;
    param_41 = _e417;
    fold(param_30, param_31, param_32, param_33, param_34, param_35, param_36, param_37, param_38, param_39, param_40, param_41);
    metal::float2 _e418 = param_38;
    g2_ = _e418;
    metal::float2 _e419 = param_39;
    s2_ = _e419;
    float _e420 = param_40;
    v2_ = _e420;
    float _e421 = param_41;
    r2_ = _e421;
    metal::float2 _e422 = g2_;
    metal::float2 _e424 = grad_1;
    grad_1 = _e424 + (_e422 * 0.8);
    metal::float2 _e426 = s_1;
    metal::float2 _e427 = shift_1;
    metal::float2 _e429 = s2_;
    piece = (_e426 + _e427) + (_e429 * 3.0);
    float _e432 = l_1;
    float _e433 = radius_1;
    rr = metal::clamp(_e432 / (_e433 * 1.1), 0.0, 1.0);
    metal::float2 _e437 = q;
    float _e438 = radius_1;
    float _e442 = k_1;
    metal::float2 _e444 = ((_e437 / metal::float2(_e438 * 1.1)) * _e442) * 0.8;
    float _e445 = rr;
    float _e447 = rr;
    float _e449 = k_1;
    sphere = metal::float3(_e444.x, _e444.y, metal::sqrt(1.0 - (((0.64 * _e445) * _e447) * _e449)));
    metal::float3 _e456 = sphere;
    metal::float2 _e457 = grad_1;
    n_1 = metal::normalize(_e456 + metal::float3(_e457.x, _e457.y, 0.0));
    float _e463 = angle;
    param_42 = -(_e463);
    metal::float2x2 _e465 = rot(param_42);
    metal::float3 _e466 = n_1;
    metal::float2 _e468 = _e465 * _e466.xy;
    n_1[0u] = _e468.x;
    n_1[1u] = _e468.y;
    light = metal::float3(-0.4472136, 0.5366563, 0.7155418);
    metal::float3 _e473 = n_1;
    metal::float3 _e474 = light;
    diffuse = metal::max(metal::dot(_e473, _e474), 0.0);
    metal::float3 _e477 = light;
    hv = metal::normalize(_e477 + metal::float3(0.0, 0.0, 1.0));
    metal::float3 _e480 = n_1;
    metal::float3 _e481 = hv;
    float _e486 = hv[2u];
    spec = metal::max(metal::pow(metal::max(metal::dot(_e480, _e481), 0.0), 20.0) - metal::pow(_e486, 20.0), 0.0);
    float _e491 = light[2u];
    level = _e491;
    float _e492 = c_3;
    relief = metal::min(2.0 * _e492, 1.0);
    float _e495 = relief;
    float _e496 = diffuse;
    float _e498 = level;
    float _e504 = spec;
    float _e506 = relief;
    shade = (1.0 + (_e495 * (((0.12 + _e496) / (0.12 + _e498)) - 1.0))) + ((0.7 * _e504) * _e506);
    float _e509 = relief;
    float _e511 = valley_1;
    float _e514 = shade;
    shade = _e514 - ((0.2 * _e509) * metal::min(_e511, 1.0));
    float _e516 = k_1;
    float _e518 = r;
    float _e522 = shade;
    shade = _e522 * (1.0 - ((0.3 * _e516) * metal::smoothstep(0.6, 1.0, _e518)));
    metal::float2 _e524 = piece;
    float _e526 = uniforms.ratio;
    f = (_e524 / metal::float2(_e526, 1.0)) + metal::float2(0.5);
    metal::float2 _e531 = f;
    metal::float2 _e532 = metal::float2(2.0);
    param_43 = metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e531 - (metal::floor(_e531 / _e532) * _e532)));
    metal::float4 _e542 = getFromColor(param_43, _from, _sampler);
    img = _e542;
    metal::float4 _e543 = img;
    metal::float4 _e546 = uniforms.paper;
    float _e548 = ridge_1;
    float _e553 = uniforms.paper[3u];
    float _e555 = c_3;
    metal::float3 _e558 = metal::mix(_e543.xyz, _e546.xyz, metal::float3(((0.6 * metal::min(_e548, 1.0)) * _e553) * _e555));
    img[0u] = _e558.x;
    img[1u] = _e558.y;
    img[2u] = _e558.z;
    metal::float4 _e565 = img;
    float _e567 = shade;
    metal::float3 _e568 = _e565.xyz * _e567;
    float _e570 = img[3u];
    ball_1 = metal::float4(_e568.x, _e568.y, _e568.z, _e570);
    float _e575 = inside;
    float _e577 = ball_1[3u];
    m = _e575 * _e577;
    metal::float4 _e579 = col;
    float _e582 = col[3u];
    metal::float4 _e584 = ball_1;
    float _e586 = m;
    metal::float3 _e588 = metal::mix(_e579.xyz * _e582, _e584.xyz, metal::float3(_e586));
    float _e590 = col[3u];
    float _e591 = m;
    o_1 = metal::float4(_e588.x, _e588.y, _e588.z, metal::mix(_e590, 1.0, _e591));
    float _e598 = o_1[3u];
    if (_e598 > 0.0) {
        metal::float4 _e600 = o_1;
        float _e603 = o_1[3u];
        metal::float3 _e605 = _e600.xyz / metal::float3(_e603);
        float _e607 = o_1[3u];
        local_4 = metal::float4(_e605.x, _e605.y, _e605.z, _e607);
    } else {
        local_4 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e612 = local_4;
    return _e612;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_44 = {};
    metal::float2 _e83 = _uv_1;
    param_44 = _e83;
    metal::float4 _e84 = transition(param_44, _from, _sampler, _to, uniforms);
    _fragColor = _e84;
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
