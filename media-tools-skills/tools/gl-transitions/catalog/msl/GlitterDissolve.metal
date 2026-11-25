// GlitterDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitterDissolve.glsl
// Author: gre
// License: MIT
// Description: The image becomes a shimmering field of tiny diamond sequins that flip over in 3D at random moments, each lifting and tilting on its own axis and flashing a glint of light, and land on the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float tiles;
    int hexagons;
    float sparkle;
    char _pad5[12];
    metal::packed_float3 glint;
    float seed;
    metal::float4 backColor;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e70 = uv[0u];
    float _e72 = uv[1u];
    metal::float4 _e75 = _to.sample(_sampler, metal::float2(_e70, 1.0 - _e72), metal::level(0.0));
    return _e75;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e70 = uv_1[0u];
    float _e72 = uv_1[1u];
    metal::float4 _e75 = _from.sample(_sampler, metal::float2(_e70, 1.0 - _e72), metal::level(0.0));
    return _e75;
}

metal::float2 mirrored(
    thread metal::float2& v
) {
    metal::float2 m = {};
    metal::float2 _e70 = v;
    metal::float2 _e71 = metal::float2(2.0);
    m = _e70 - (metal::floor(_e70 / _e71) * _e71);
    metal::float2 _e76 = m;
    metal::float2 _e77 = m;
    metal::float2 _e80 = m;
    return metal::mix(_e76, metal::float2(2.0) - _e77, metal::step(metal::float2(1.0), _e80));
}

metal::float2 unproject(
    thread metal::float2& s,
    thread metal::float2& n,
    thread float& f
) {
    float c = {};
    float along = {};
    float _e73 = f;
    c = metal::abs(metal::cos(3.1415927 * _e73));
    metal::float2 _e77 = s;
    metal::float2 _e78 = n;
    along = metal::dot(_e77, _e78);
    metal::float2 _e80 = s;
    metal::float2 _e81 = n;
    float _e82 = along;
    float _e83 = c;
    float _e86 = along;
    float _e90 = f;
    return (_e80 + (_e81 * ((_e82 / metal::max(_e83, 0.0001)) - _e86))) / metal::float2(1.0 + (0.3 * metal::sin(3.1415927 * _e90)));
}

float hash12(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e70 = p;
    p3_ = metal::fract(_e70.xyx * 0.1031);
    metal::float3 _e74 = p3_;
    metal::float3 _e75 = p3_;
    metal::float3 _e80 = p3_;
    p3_ = _e80 + metal::float3(metal::dot(_e74, _e75.yzx + metal::float3(33.33)));
    float _e84 = p3_[0u];
    float _e86 = p3_[1u];
    float _e89 = p3_[2u];
    return metal::fract((_e84 + _e86) * _e89);
}

metal::float2 axisOf(
    thread metal::float2& id
) {
    float a = {};
    metal::float2 param = {};
    metal::float2 _e71 = id;
    param = _e71 + metal::float2(41.7);
    float _e74 = hash12(param);
    a = 6.2831855 * _e74;
    float _e76 = a;
    float _e78 = a;
    return metal::float2(metal::cos(_e76), metal::sin(_e78));
}

float flipOf(
    thread metal::float2& id_1,
    constant Uniforms& uniforms
) {
    float t = {};
    metal::float2 param_1 = {};
    float _e72 = uniforms.progress;
    metal::float2 _e73 = id_1;
    param_1 = _e73;
    float _e74 = hash12(param_1);
    t = metal::clamp((_e72 - (_e74 * 0.72)) / 0.28, 0.0, 1.0);
    float _e79 = t;
    float _e80 = t;
    float _e82 = t;
    return (_e79 * _e80) * (3.0 - (2.0 * _e82));
}

metal::float2 idOf(
    thread metal::float2& center,
    constant Uniforms& uniforms
) {
    metal::float2 grid = {};
    int _e71 = uniforms.hexagons;
    grid = metal::select(metal::float2(2.0, 2.0), metal::float2(1.1547005, 2.0), metal::bool2(_e71 != 0));
    metal::float2 _e75 = center;
    metal::float2 _e76 = grid;
    float _e82 = uniforms.seed;
    return (metal::floor((_e75 * _e76) + metal::float2(0.5)) + (metal::float2(13.0, 7.0) * metal::floor(_e82))) + metal::float2(3.0);
}

metal::float4 tileColor(
    thread metal::float2& p_1,
    thread metal::float2& center_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 id_2 = {};
    metal::float2 param_2 = {};
    float f_1 = {};
    metal::float2 param_3 = {};
    metal::float2 n_1 = {};
    metal::float2 param_4 = {};
    float c_1 = {};
    float z = {};
    metal::float2 s0_ = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    metal::float2 suv = {};
    metal::float2 param_8 = {};
    metal::float4 col = {};
    metal::float4 local = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float3 nrm = {};
    metal::float3 L = {};
    float shade = {};
    metal::float3 H = {};
    float spec = {};
    metal::float3 light = {};
    metal::float3 base = {};
    metal::float2 _e95 = center_1;
    param_2 = _e95;
    metal::float2 _e96 = idOf(param_2, uniforms);
    id_2 = _e96;
    metal::float2 _e97 = id_2;
    param_3 = _e97;
    float _e98 = flipOf(param_3, uniforms);
    f_1 = _e98;
    metal::float2 _e99 = id_2;
    param_4 = _e99;
    metal::float2 _e100 = axisOf(param_4);
    n_1 = _e100;
    float _e101 = f_1;
    c_1 = metal::cos(3.1415927 * _e101);
    float _e104 = f_1;
    z = metal::sin(3.1415927 * _e104);
    metal::float2 _e107 = p_1;
    metal::float2 _e108 = center_1;
    param_5 = _e107 - _e108;
    metal::float2 _e110 = n_1;
    param_6 = _e110;
    float _e111 = f_1;
    param_7 = _e111;
    metal::float2 _e112 = unproject(param_5, param_6, param_7);
    s0_ = _e112;
    metal::float2 _e113 = center_1;
    metal::float2 _e114 = s0_;
    float _e118 = uniforms.tiles;
    float _e122 = uniforms.ratio;
    param_8 = ((((_e113 + _e114) - metal::float2(0.37, 0.21)) / metal::float2(_e118)) / metal::float2(_e122, 1.0)) + metal::float2(0.5);
    metal::float2 _e127 = mirrored(param_8);
    suv = _e127;
    float _e128 = c_1;
    if (_e128 > 0.0) {
        metal::float2 _e130 = suv;
        param_9 = _e130;
        metal::float4 _e131 = getFromColor(param_9, _from, _sampler);
        local = _e131;
    } else {
        metal::float2 _e132 = suv;
        param_10 = _e132;
        metal::float4 _e133 = getToColor(param_10, _sampler, _to);
        local = _e133;
    }
    metal::float4 _e134 = local;
    col = _e134;
    metal::float2 _e135 = n_1;
    float _e136 = z;
    float _e138 = c_1;
    metal::float2 _e142 = s0_;
    metal::float2 _e144 = ((_e135 * _e136) * ((_e138 < 0.0) ? -1.0 : 1.0)) + (_e142 * 0.5);
    float _e145 = c_1;
    nrm = metal::normalize(metal::float3(_e144.x, _e144.y, metal::abs(_e145)));
    L = metal::float3(-0.26832816, 0.3577709, 0.8944272);
    metal::float3 _e151 = nrm;
    metal::float3 _e152 = L;
    float _e155 = L[2u];
    shade = 0.45 + (0.55 * metal::clamp(metal::dot(_e151, _e152) / _e155, 0.0, 1.6));
    H = metal::float3(-0.36681262, 0.44832653, 0.8151392);
    metal::float3 _e160 = nrm;
    metal::float3 _e161 = H;
    float _e165 = c_1;
    spec = (metal::smoothstep(0.94, 0.995, metal::dot(_e160, _e161)) * 2.0) + (metal::pow(1.0 - metal::abs(_e165), 6.0) * 0.6);
    metal::float3 _e172 = uniforms.glint;
    float _e174 = uniforms.sparkle;
    float _e176 = spec;
    float _e178 = z;
    light = metal::clamp(((_e172 * _e174) * _e176) * _e178, metal::float3(0.0), metal::float3(1.0));
    metal::float4 _e183 = col;
    float _e185 = shade;
    float _e186 = z;
    base = metal::clamp(_e183.xyz * metal::mix(1.0, _e185, _e186), metal::float3(0.0), metal::float3(1.0));
    metal::float3 _e192 = base;
    metal::float3 _e193 = light;
    metal::float3 _e195 = base;
    metal::float3 _e196 = light;
    metal::float3 _e198 = (_e192 + _e193) - (_e195 * _e196);
    float _e200 = col[3u];
    return metal::float4(_e198.x, _e198.y, _e198.z, _e200);
}

float shape(
    thread metal::float2& v_1,
    constant Uniforms& uniforms
) {
    float local_1 = {};
    metal::float2 _e70 = v_1;
    v_1 = metal::abs(_e70);
    int _e73 = uniforms.hexagons;
    if (_e73 != 0) {
        float _e76 = v_1[1u];
        metal::float2 _e77 = v_1;
        local_1 = metal::max(_e76, metal::dot(_e77, metal::float2(0.8660254, 0.5)));
    } else {
        float _e81 = v_1[0u];
        float _e83 = v_1[1u];
        local_1 = _e81 + _e83;
    }
    float _e85 = local_1;
    return _e85;
}

float coverOf(
    thread metal::float2& p_2,
    thread metal::float2& center_2,
    constant Uniforms& uniforms
) {
    metal::float2 id_3 = {};
    metal::float2 param_11 = {};
    float f_2 = {};
    metal::float2 param_12 = {};
    float z_1 = {};
    float onScreen = {};
    float edge = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    float param_16 = {};
    metal::float2 param_17 = {};
    metal::float2 _e82 = center_2;
    param_11 = _e82;
    metal::float2 _e83 = idOf(param_11, uniforms);
    id_3 = _e83;
    metal::float2 _e84 = id_3;
    param_12 = _e84;
    float _e85 = flipOf(param_12, uniforms);
    f_2 = _e85;
    float _e86 = f_2;
    float _e88 = f_2;
    if ((_e86 <= 0.0) || (_e88 >= 1.0)) {
        return 0.0;
    }
    float _e91 = f_2;
    z_1 = metal::sin(3.1415927 * _e91);
    float _e94 = z_1;
    float _e97 = f_2;
    onScreen = (1.0 + (0.3 * _e94)) * metal::max(metal::abs(metal::cos(3.1415927 * _e97)), 0.15);
    float _e103 = z_1;
    edge = (0.04 * metal::min(1.0, 4.0 * _e103)) + 0.0001;
    metal::float2 _e108 = p_2;
    metal::float2 _e109 = center_2;
    metal::float2 _e111 = id_3;
    param_13 = _e111;
    metal::float2 _e112 = axisOf(param_13);
    param_14 = _e108 - _e109;
    param_15 = _e112;
    float _e113 = f_2;
    param_16 = _e113;
    metal::float2 _e114 = unproject(param_14, param_15, param_16);
    param_17 = _e114;
    float _e115 = shape(param_17, uniforms);
    float _e117 = onScreen;
    float _e119 = edge;
    return metal::clamp(((0.5 - _e115) * _e117) / _e119, 0.0, 1.0);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_18 = {};
    metal::float2 param_19 = {};
    metal::float2 p_3 = {};
    metal::float2 s_1 = {};
    metal::float2 a_1 = {};
    metal::float2 b = {};
    metal::float2 home = {};
    metal::float2 local_2 = {};
    metal::float2 q = {};
    float fHome = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float4 under = {};
    metal::float4 local_3 = {};
    metal::float2 param_22 = {};
    metal::float4 local_4 = {};
    metal::float2 param_23 = {};
    float z1_ = {};
    float z2_ = {};
    float cover1_ = {};
    float cover2_ = {};
    metal::float2 center1_ = {};
    metal::float2 center2_ = {};
    int k = {};
    float fk = {};
    metal::float2 off = {};
    metal::float2 local_5 = {};
    metal::float2 local_6 = {};
    metal::float2 o = {};
    metal::float2 center_3 = {};
    float cover = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    float z_2 = {};
    metal::float2 param_26 = {};
    metal::float2 param_27 = {};
    metal::float4 c_2 = {};
    metal::float2 param_28 = {};
    metal::float2 param_29 = {};
    metal::float2 param_30 = {};
    metal::float2 param_31 = {};
    float _e111 = uniforms.progress;
    if (_e111 <= 0.0) {
        metal::float2 _e113 = uv_2;
        param_18 = _e113;
        metal::float4 _e114 = getFromColor(param_18, _from, _sampler);
        return _e114;
    }
    float _e116 = uniforms.progress;
    if (_e116 >= 1.0) {
        metal::float2 _e118 = uv_2;
        param_19 = _e118;
        metal::float4 _e119 = getToColor(param_19, _sampler, _to);
        return _e119;
    }
    metal::float2 _e120 = uv_2;
    float _e124 = uniforms.ratio;
    float _e128 = uniforms.tiles;
    p_3 = (((_e120 - metal::float2(0.5)) * metal::float2(_e124, 1.0)) * _e128) + metal::float2(0.37, 0.21);
    int _e132 = uniforms.hexagons;
    if (_e132 != 0) {
        s_1 = metal::float2(1.7320508, 1.0);
        metal::float2 _e134 = p_3;
        metal::float2 _e135 = s_1;
        metal::float2 _e140 = s_1;
        a_1 = (_e134 - (metal::floor(_e134 / _e135) * _e135)) - (_e140 * 0.5);
        metal::float2 _e143 = p_3;
        metal::float2 _e144 = s_1;
        metal::float2 _e146 = _e143 - (_e144 * 0.5);
        metal::float2 _e147 = s_1;
        metal::float2 _e152 = s_1;
        b = (_e146 - (metal::floor(_e146 / _e147) * _e147)) - (_e152 * 0.5);
        metal::float2 _e155 = a_1;
        metal::float2 _e156 = a_1;
        metal::float2 _e158 = b;
        metal::float2 _e159 = b;
        if (metal::dot(_e155, _e156) < metal::dot(_e158, _e159)) {
            metal::float2 _e162 = p_3;
            metal::float2 _e163 = a_1;
            local_2 = _e162 - _e163;
        } else {
            metal::float2 _e165 = p_3;
            metal::float2 _e166 = b;
            local_2 = _e165 - _e166;
        }
        metal::float2 _e168 = local_2;
        home = _e168;
    } else {
        float _e170 = p_3[0u];
        float _e172 = p_3[1u];
        float _e175 = p_3[1u];
        float _e177 = p_3[0u];
        q = metal::floor(metal::float2(_e170 + _e172, _e175 - _e177)) + metal::float2(0.5);
        float _e184 = q[0u];
        float _e186 = q[1u];
        float _e189 = q[0u];
        float _e191 = q[1u];
        home = metal::float2(_e184 - _e186, _e189 + _e191) * 0.5;
    }
    metal::float2 _e195 = home;
    param_20 = _e195;
    metal::float2 _e196 = idOf(param_20, uniforms);
    param_21 = _e196;
    float _e197 = flipOf(param_21, uniforms);
    fHome = _e197;
    float _e198 = fHome;
    if (_e198 <= 0.0) {
        metal::float2 _e200 = uv_2;
        param_22 = _e200;
        metal::float4 _e201 = getFromColor(param_22, _from, _sampler);
        local_3 = _e201;
    } else {
        float _e202 = fHome;
        if (_e202 >= 1.0) {
            metal::float2 _e204 = uv_2;
            param_23 = _e204;
            metal::float4 _e205 = getToColor(param_23, _sampler, _to);
            local_4 = _e205;
        } else {
            metal::float4 _e207 = uniforms.backColor;
            local_4 = _e207;
        }
        metal::float4 _e208 = local_4;
        local_3 = _e208;
    }
    metal::float4 _e209 = local_3;
    under = _e209;
    z1_ = -1.0;
    z2_ = -1.0;
    cover1_ = 0.0;
    cover2_ = 0.0;
    metal::float2 _e210 = home;
    center1_ = _e210;
    metal::float2 _e211 = home;
    center2_ = _e211;
    k = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e293 = k;
            k = as_type<int>(as_type<uint>(_e293) + as_type<uint>(1));
        }
        loop_init = false;
        int _e212 = k;
        if (_e212 < 9) {
            int _e214 = k;
            fk = static_cast<float>(_e214);
            int _e217 = uniforms.hexagons;
            if (_e217 != 0) {
                int _e219 = k;
                if (_e219 > 6) {
                    break;
                }
                int _e221 = k;
                if (_e221 == 0) {
                    local_5 = metal::float2(0.0, 0.0);
                } else {
                    int _e223 = k;
                    if (_e223 < 3) {
                        float _e225 = fk;
                        local_6 = metal::float2(0.0, (_e225 * 2.0) - 3.0);
                    } else {
                        float _e229 = fk;
                        float _e236 = fk;
                        local_6 = metal::float2(((_e229 - (metal::floor(_e229 / 2.0) * 2.0)) * 1.7320508) - 0.8660254, (_e236 < 5.0) ? -0.5 : 0.5);
                    }
                    metal::float2 _e240 = local_6;
                    local_5 = _e240;
                }
                metal::float2 _e241 = local_5;
                off = _e241;
            } else {
                float _e242 = fk;
                float _e248 = fk;
                o = metal::float2((_e242 - (metal::floor(_e242 / 3.0) * 3.0)) - 1.0, metal::floor(_e248 / 3.0) - 1.0);
                float _e254 = o[0u];
                float _e256 = o[1u];
                float _e259 = o[0u];
                float _e261 = o[1u];
                off = metal::float2(_e254 - _e256, _e259 + _e261) * 0.5;
            }
            metal::float2 _e265 = home;
            metal::float2 _e266 = off;
            center_3 = _e265 + _e266;
            metal::float2 _e268 = p_3;
            param_24 = _e268;
            metal::float2 _e269 = center_3;
            param_25 = _e269;
            float _e270 = coverOf(param_24, param_25, uniforms);
            cover = _e270;
            float _e271 = cover;
            if (_e271 <= 0.0) {
                continue;
            }
            metal::float2 _e273 = center_3;
            param_26 = _e273;
            metal::float2 _e274 = idOf(param_26, uniforms);
            param_27 = _e274;
            float _e275 = flipOf(param_27, uniforms);
            z_2 = metal::sin(3.1415927 * _e275);
            float _e278 = z_2;
            float _e279 = z1_;
            if (_e278 > _e279) {
                float _e281 = z1_;
                z2_ = _e281;
                float _e282 = cover1_;
                cover2_ = _e282;
                metal::float2 _e283 = center1_;
                center2_ = _e283;
                float _e284 = z_2;
                z1_ = _e284;
                float _e285 = cover;
                cover1_ = _e285;
                metal::float2 _e286 = center_3;
                center1_ = _e286;
            } else {
                float _e287 = z_2;
                float _e288 = z2_;
                if (_e287 > _e288) {
                    float _e290 = z_2;
                    z2_ = _e290;
                    float _e291 = cover;
                    cover2_ = _e291;
                    metal::float2 _e292 = center_3;
                    center2_ = _e292;
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e295 = z1_;
    if (_e295 < 0.0) {
        metal::float4 _e297 = under;
        return _e297;
    }
    metal::float4 _e298 = under;
    c_2 = _e298;
    float _e299 = z2_;
    float _e301 = cover1_;
    if ((_e299 >= 0.0) && (_e301 < 1.0)) {
        metal::float4 _e304 = c_2;
        metal::float2 _e305 = p_3;
        param_28 = _e305;
        metal::float2 _e306 = center2_;
        param_29 = _e306;
        metal::float4 _e307 = tileColor(param_28, param_29, _from, _sampler, _to, uniforms);
        float _e308 = cover2_;
        c_2 = metal::mix(_e304, _e307, metal::float4(_e308));
    }
    metal::float4 _e311 = c_2;
    metal::float2 _e312 = p_3;
    param_30 = _e312;
    metal::float2 _e313 = center1_;
    param_31 = _e313;
    metal::float4 _e314 = tileColor(param_30, param_31, _from, _sampler, _to, uniforms);
    float _e315 = cover1_;
    return metal::mix(_e311, _e314, metal::float4(_e315));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_32 = {};
    metal::float2 _e69 = _uv_1;
    param_32 = _e69;
    metal::float4 _e70 = transition(param_32, _from, _sampler, _to, uniforms);
    _fragColor = _e70;
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
