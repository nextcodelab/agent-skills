// Cube — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Cube.glsl
// Author: gre
// License: MIT
// Description: The two images are faces of a box that turns a quarter turn in perspective, the outgoing face darkening as it turns away, above a reflective floor
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float persp;
    float unzoom;
    float reflection;
    float floating;
    float shading;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e43 = uv[0u];
    float _e45 = uv[1u];
    metal::float4 _e48 = _to.sample(_sampler, metal::float2(_e43, 1.0 - _e45), metal::level(0.0));
    return _e48;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e43 = uv_1[0u];
    float _e45 = uv_1[1u];
    metal::float4 _e48 = _from.sample(_sampler, metal::float2(_e43, 1.0 - _e45), metal::level(0.0));
    return _e48;
}

metal::float4 hitBox(
    thread metal::float3& eye,
    thread metal::float3& dir,
    thread float& w,
    thread float& c,
    thread float& s
) {
    metal::float2 pivot = {};
    metal::float2 e = {};
    metal::float2 o = {};
    metal::float2 d = {};
    metal::float2 inv = {};
    float local = {};
    float local_1 = {};
    metal::float2 t0_ = {};
    metal::float2 t1_ = {};
    metal::float2 tn = {};
    metal::float2 tf = {};
    float tin = {};
    metal::float2 hit = {};
    float y = {};
    bool phi_197_ = {};
    float _e60 = w;
    pivot = metal::float2(0.5 * _e60);
    metal::float3 _e63 = eye;
    metal::float2 _e65 = pivot;
    e = _e63.xz - _e65;
    float _e68 = e[0u];
    float _e69 = c;
    float _e72 = e[1u];
    float _e73 = s;
    float _e77 = e[0u];
    float _e79 = s;
    float _e82 = e[1u];
    float _e83 = c;
    metal::float2 _e87 = pivot;
    o = metal::float2((_e68 * _e69) + (_e72 * _e73), (-(_e77) * _e79) + (_e82 * _e83)) + _e87;
    float _e90 = dir[0u];
    float _e91 = c;
    float _e94 = dir[2u];
    float _e95 = s;
    float _e99 = dir[0u];
    float _e101 = s;
    float _e104 = dir[2u];
    float _e105 = c;
    d = metal::float2((_e90 * _e91) + (_e94 * _e95), (-(_e99) * _e101) + (_e104 * _e105));
    float _e110 = d[0u];
    if (_e110 < 0.0) {
        float _e113 = d[0u];
        local = metal::min(_e113, -0.000001);
    } else {
        float _e116 = d[0u];
        local = metal::max(_e116, 0.000001);
    }
    float _e118 = local;
    float _e120 = d[1u];
    if (_e120 < 0.0) {
        float _e123 = d[1u];
        local_1 = metal::min(_e123, -0.000001);
    } else {
        float _e126 = d[1u];
        local_1 = metal::max(_e126, 0.000001);
    }
    float _e128 = local_1;
    inv = metal::float2(1.0) / metal::float2(_e118, _e128);
    metal::float2 _e132 = o;
    metal::float2 _e134 = inv;
    t0_ = (metal::float2(0.0, 0.0) - _e132) * _e134;
    float _e136 = w;
    metal::float2 _e138 = o;
    metal::float2 _e140 = inv;
    t1_ = (metal::float2(_e136) - _e138) * _e140;
    metal::float2 _e142 = t0_;
    metal::float2 _e143 = t1_;
    tn = metal::min(_e142, _e143);
    metal::float2 _e145 = t0_;
    metal::float2 _e146 = t1_;
    tf = metal::max(_e145, _e146);
    float _e149 = tn[0u];
    float _e151 = tn[1u];
    tin = metal::max(_e149, _e151);
    float _e153 = tin;
    bool _e154 = _e153 <= 0.0;
    phi_197_ = _e154;
    if (!(_e154)) {
        float _e156 = tin;
        float _e158 = tf[0u];
        float _e160 = tf[1u];
        phi_197_ = _e156 > metal::min(_e158, _e160);
    }
    bool _e164 = phi_197_;
    if (_e164) {
        return metal::float4(-1.0, -1.0, -1.0, -1.0);
    }
    metal::float2 _e165 = o;
    float _e166 = tin;
    metal::float2 _e167 = d;
    hit = _e165 + (_e167 * _e166);
    float _e171 = eye[1u];
    float _e172 = tin;
    float _e174 = dir[1u];
    y = _e171 + (_e172 * _e174);
    float _e177 = y;
    float _e179 = y;
    if ((_e177 < 0.0) || (_e179 > 1.0)) {
        return metal::float4(-1.0, -1.0, -1.0, -1.0);
    }
    float _e183 = tn[1u];
    float _e185 = tn[0u];
    if (_e183 >= _e185) {
        float _e188 = d[1u];
        if (_e188 <= 0.0) {
            return metal::float4(-1.0, -1.0, -1.0, -1.0);
        }
        float _e190 = tin;
        float _e192 = hit[0u];
        float _e193 = w;
        float _e195 = y;
        return metal::float4(_e190, _e192 / _e193, _e195, 0.0);
    }
    float _e198 = d[0u];
    if (_e198 <= 0.0) {
        return metal::float4(-1.0, -1.0, -1.0, -1.0);
    }
    float _e200 = tin;
    float _e202 = hit[1u];
    float _e203 = w;
    float _e206 = y;
    return metal::float4(_e200, 1.0 - (_e202 / _e203), _e206, 1.0);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float w_1 = {};
    float turn = {};
    float a = {};
    float c_1 = {};
    float s_1 = {};
    float motion = {};
    float zoom = {};
    float dist = {};
    metal::float3 eye_1 = {};
    metal::float2 sp = {};
    metal::float3 dir_1 = {};
    float px = {};
    float shade0_ = {};
    float shade1_ = {};
    metal::float4 front = {};
    metal::float4 b = {};
    metal::float3 param = {};
    metal::float3 param_1 = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    metal::float4 img = {};
    metal::float4 local_2 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float m = {};
    float e_1 = {};
    metal::float3 n = {};
    metal::float3 local_3 = {};
    float fore = {};
    float edge = {};
    float local_4 = {};
    metal::float4 ground = {};
    float h = {};
    float tf_1 = {};
    metal::float3 f = {};
    metal::float3 meye = {};
    metal::float3 mdir = {};
    metal::float4 r = {};
    metal::float3 param_7 = {};
    metal::float3 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    metal::float4 img_1 = {};
    metal::float4 local_5 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    float k = {};
    metal::float2 q = {};
    metal::float2 l = {};
    float soft = {};
    float sh = {};
    metal::float2 bl = {};
    float local_6 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float4 color = {};
    metal::float4 local_7 = {};
    bool phi_493_ = {};
    float _e102 = uniforms.ratio;
    w_1 = _e102;
    float _e104 = uniforms.progress;
    float _e106 = uniforms.progress;
    float _e109 = uniforms.progress;
    turn = (_e104 * _e106) * (3.0 - (2.0 * _e109));
    float _e113 = turn;
    a = 1.5707964 * _e113;
    float _e115 = a;
    c_1 = metal::cos(_e115);
    float _e117 = a;
    s_1 = metal::sin(_e117);
    float _e120 = uniforms.progress;
    if (_e120 >= 1.0) {
        c_1 = 0.0;
        s_1 = 1.0;
    }
    float _e123 = uniforms.progress;
    motion = metal::sin(3.1415927 * metal::clamp(_e123, 0.0, 1.0));
    float _e128 = uniforms.unzoom;
    float _e130 = motion;
    zoom = 1.0 + (metal::max(_e128, 0.0) * _e130);
    float _e133 = w_1;
    float _e137 = uniforms.persp;
    dist = (0.8 * metal::max(_e133, 1.0)) / metal::clamp(_e137, 0.01, 1.0);
    float _e140 = w_1;
    float _e142 = dist;
    eye_1 = metal::float3(0.5 * _e140, 0.5, -(_e142));
    metal::float2 _e145 = uv_2;
    float _e148 = zoom;
    sp = ((_e145 - metal::float2(0.5)) * _e148) + metal::float2(0.5);
    float _e153 = sp[0u];
    float _e154 = w_1;
    float _e157 = sp[1u];
    metal::float3 _e159 = eye_1;
    dir_1 = metal::float3(_e153 * _e154, _e157, 0.0) - _e159;
    float _e161 = zoom;
    float _e163 = motion;
    px = (0.002 * _e161) * metal::min(10.0 * _e163, 1.0);
    float _e168 = uniforms.shading;
    float _e169 = c_1;
    shade0_ = 1.0 - (_e168 * (1.0 - _e169));
    float _e174 = uniforms.shading;
    float _e175 = s_1;
    shade1_ = 1.0 - (_e174 * (1.0 - _e175));
    front = metal::float4(0.0, 0.0, 0.0, 0.0);
    metal::float3 _e179 = eye_1;
    param = _e179;
    metal::float3 _e180 = dir_1;
    param_1 = _e180;
    float _e181 = w_1;
    param_2 = _e181;
    float _e182 = c_1;
    param_3 = _e182;
    float _e183 = s_1;
    param_4 = _e183;
    metal::float4 _e184 = hitBox(param, param_1, param_2, param_3, param_4);
    b = _e184;
    float _e186 = b[0u];
    if (_e186 > 0.0) {
        float _e189 = b[3u];
        if (_e189 < 0.5) {
            float _e192 = b[1u];
            float _e194 = b[2u];
            param_5 = metal::float2(_e192, _e194);
            metal::float4 _e196 = getFromColor(param_5, _from, _sampler);
            local_2 = _e196;
        } else {
            float _e198 = b[1u];
            float _e200 = b[2u];
            param_6 = metal::float2(_e198, _e200);
            metal::float4 _e202 = getToColor(param_6, _sampler, _to);
            local_2 = _e202;
        }
        metal::float4 _e203 = local_2;
        img = _e203;
        m = 1.0;
        float _e204 = px;
        if (_e204 > 0.0) {
            float _e206 = px;
            float _e208 = b[0u];
            e_1 = _e206 * _e208;
            float _e211 = b[3u];
            if (_e211 < 0.5) {
                float _e213 = s_1;
                float _e214 = c_1;
                local_3 = metal::float3(_e213, 0.0, -(_e214));
            } else {
                float _e217 = c_1;
                float _e219 = s_1;
                local_3 = metal::float3(-(_e217), 0.0, -(_e219));
            }
            metal::float3 _e222 = local_3;
            n = _e222;
            metal::float3 _e223 = n;
            metal::float3 _e224 = dir_1;
            fore = metal::max(metal::abs(metal::dot(_e223, metal::normalize(_e224))), 0.05);
            float _e230 = b[3u];
            if (_e230 < 0.5) {
                float _e233 = b[1u];
                local_4 = 1.0 - _e233;
            } else {
                float _e236 = b[1u];
                local_4 = _e236;
            }
            float _e237 = local_4;
            edge = _e237;
            float _e239 = b[2u];
            float _e241 = b[2u];
            float _e244 = e_1;
            float _e247 = edge;
            float _e248 = w_1;
            float _e250 = fore;
            float _e252 = e_1;
            m = metal::clamp(metal::min(_e239, 1.0 - _e241) / _e244, 0.0, 1.0) * metal::clamp(((_e247 * _e248) * _e250) / _e252, 0.0, 1.0);
        }
        float _e256 = m;
        bool _e257 = _e256 >= 1.0;
        phi_493_ = _e257;
        if (_e257) {
            float _e259 = img[3u];
            phi_493_ = _e259 >= 1.0;
        }
        bool _e262 = phi_493_;
        if (_e262) {
            metal::float4 _e263 = img;
            float _e266 = b[3u];
            float _e268 = shade0_;
            float _e269 = shade1_;
            metal::float3 _e271 = _e263.xyz * ((_e266 < 0.5) ? _e268 : _e269);
            float _e273 = img[3u];
            return metal::float4(_e271.x, _e271.y, _e271.z, _e273);
        }
        metal::float4 _e278 = img;
        float _e281 = b[3u];
        float _e283 = shade0_;
        float _e284 = shade1_;
        float _e288 = img[3u];
        metal::float3 _e289 = (_e278.xyz * ((_e281 < 0.5) ? _e283 : _e284)) * _e288;
        float _e291 = img[3u];
        float _e296 = m;
        front = metal::float4(_e289.x, _e289.y, _e289.z, _e291) * _e296;
    }
    ground = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e299 = uniforms.floating;
    h = 0.005 * metal::max(_e299, 0.0);
    float _e303 = dir_1[1u];
    float _e305 = motion;
    if ((_e303 < 0.0) && (_e305 > 0.0)) {
        float _e309 = eye_1[1u];
        float _e310 = h;
        float _e314 = dir_1[1u];
        tf_1 = -((_e309 + _e310)) / _e314;
        metal::float3 _e316 = eye_1;
        float _e317 = tf_1;
        metal::float3 _e318 = dir_1;
        f = _e316 + (_e318 * _e317);
        float _e322 = eye_1[0u];
        float _e323 = h;
        float _e326 = eye_1[1u];
        float _e329 = eye_1[2u];
        meye = metal::float3(_e322, (-2.0 * _e323) - _e326, _e329);
        float _e332 = dir_1[0u];
        float _e334 = dir_1[1u];
        float _e337 = dir_1[2u];
        mdir = metal::float3(_e332, -(_e334), _e337);
        metal::float3 _e339 = meye;
        param_7 = _e339;
        metal::float3 _e340 = mdir;
        param_8 = _e340;
        float _e341 = w_1;
        param_9 = _e341;
        float _e342 = c_1;
        param_10 = _e342;
        float _e343 = s_1;
        param_11 = _e343;
        metal::float4 _e344 = hitBox(param_7, param_8, param_9, param_10, param_11);
        r = _e344;
        float _e346 = r[0u];
        if (_e346 > 0.0) {
            float _e349 = r[3u];
            if (_e349 < 0.5) {
                float _e352 = r[1u];
                float _e354 = r[2u];
                param_12 = metal::float2(_e352, _e354);
                metal::float4 _e356 = getFromColor(param_12, _from, _sampler);
                local_5 = _e356;
            } else {
                float _e358 = r[1u];
                float _e360 = r[2u];
                param_13 = metal::float2(_e358, _e360);
                metal::float4 _e362 = getToColor(param_13, _sampler, _to);
                local_5 = _e362;
            }
            metal::float4 _e363 = local_5;
            img_1 = _e363;
            float _e365 = uniforms.reflection;
            float _e368 = r[2u];
            float _e372 = r[2u];
            k = (metal::clamp(_e365, 0.0, 1.0) * (1.0 - _e368)) * (1.0 - _e372);
            metal::float4 _e375 = img_1;
            float _e378 = r[3u];
            float _e380 = shade0_;
            float _e381 = shade1_;
            float _e385 = img_1[3u];
            metal::float3 _e386 = (_e375.xyz * ((_e378 < 0.5) ? _e380 : _e381)) * _e385;
            float _e388 = img_1[3u];
            float _e393 = k;
            ground = metal::float4(_e386.x, _e386.y, _e386.z, _e388) * _e393;
        }
        metal::float3 _e395 = f;
        float _e397 = w_1;
        q = _e395.xz - metal::float2(0.5 * _e397);
        float _e402 = q[0u];
        float _e403 = c_1;
        float _e406 = q[1u];
        float _e407 = s_1;
        float _e411 = q[0u];
        float _e413 = s_1;
        float _e416 = q[1u];
        float _e417 = c_1;
        l = metal::float2((_e402 * _e403) + (_e406 * _e407), (-(_e411) * _e413) + (_e416 * _e417));
        float _e421 = h;
        soft = 0.03 + (1.5 * _e421);
        float _e425 = uniforms.shading;
        metal::float2 _e427 = l;
        float _e429 = w_1;
        float _e437 = soft;
        sh = (_e425 * 0.7) * metal::exp(-(metal::length(metal::max(metal::abs(_e427) - metal::float2(0.5 * _e429), metal::float2(0.0)))) / _e437);
        metal::float2 _e441 = l;
        float _e442 = w_1;
        bl = _e441 + metal::float2(0.5 * _e442);
        float _e447 = l[1u];
        float _e449 = l[0u];
        if (_e447 < _e449) {
            float _e452 = bl[0u];
            float _e453 = w_1;
            param_14 = metal::float2(metal::clamp(_e452 / _e453, 0.0, 1.0), 0.0);
            metal::float4 _e457 = getFromColor(param_14, _from, _sampler);
            local_6 = _e457.w;
        } else {
            float _e460 = bl[1u];
            float _e461 = w_1;
            param_15 = metal::float2(metal::clamp(1.0 - (_e460 / _e461), 0.0, 1.0), 0.0);
            metal::float4 _e466 = getToColor(param_15, _sampler, _to);
            local_6 = _e466.w;
        }
        float _e468 = local_6;
        float _e469 = sh;
        sh = _e469 * _e468;
        metal::float4 _e471 = ground;
        float _e472 = sh;
        float _e475 = sh;
        ground = (_e471 * (1.0 - _e472)) + metal::float4(0.0, 0.0, 0.0, _e475);
        float _e478 = motion;
        metal::float4 _e481 = ground;
        ground = _e481 * metal::min(6.0 * _e478, 1.0);
    }
    metal::float4 _e483 = front;
    metal::float4 _e484 = ground;
    float _e486 = front[3u];
    color = _e483 + (_e484 * (1.0 - _e486));
    float _e491 = color[3u];
    if (_e491 > 0.0) {
        metal::float4 _e493 = color;
        float _e496 = color[3u];
        metal::float3 _e498 = _e493.xyz / metal::float3(_e496);
        float _e500 = color[3u];
        local_7 = metal::float4(_e498.x, _e498.y, _e498.z, _e500);
    } else {
        local_7 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e505 = local_7;
    return _e505;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_16 = {};
    metal::float2 _e42 = _uv_1;
    param_16 = _e42;
    metal::float4 _e43 = transition(param_16, _from, _sampler, _to, uniforms);
    _fragColor = _e43;
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
