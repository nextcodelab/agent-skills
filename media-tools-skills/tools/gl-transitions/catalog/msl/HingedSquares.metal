// HingedSquares — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/HingedSquares.glsl
// Author: gre
// License: MIT
// Description: The image is cut into squares that turn in alternate directions while staying hinged at their corners, so the sheet opens into a checkerboard of diamonds showing the incoming image; those diamonds then turn back into place and close the sheet
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int cells;
    float shading;
    float zoom;
};

metal::float2 rot(
    thread metal::float2& v,
    thread metal::float2& cs
) {
    float _e46 = cs[0u];
    float _e48 = v[0u];
    float _e51 = cs[1u];
    float _e53 = v[1u];
    float _e57 = cs[1u];
    float _e60 = v[0u];
    float _e63 = cs[0u];
    float _e65 = v[1u];
    return metal::float2((_e46 * _e48) + (_e51 * _e53), (-(_e57) * _e60) + (_e63 * _e65));
}

float parity(
    thread metal::float2& n
) {
    float _e45 = n[0u];
    float _e47 = n[1u];
    float _e48 = _e45 + _e47;
    return ((_e48 - (metal::floor(_e48 / 2.0) * 2.0)) < 0.5) ? 1.0 : -1.0;
}

metal::float2 toUV(
    thread metal::float2& c,
    thread float& n_1,
    constant Uniforms& uniforms
) {
    metal::float2 uv = {};
    metal::float2 _e46 = c;
    float _e47 = n_1;
    float _e49 = uniforms.ratio;
    uv = (_e46 / (metal::float2(_e49, 1.0) * _e47)) + metal::float2(0.5);
    metal::float2 _e55 = uv;
    metal::float2 _e57 = _e55 + metal::float2(1.0);
    metal::float2 _e58 = metal::float2(2.0);
    return metal::abs((_e57 - (metal::floor(_e57 / _e58) * _e58)) - metal::float2(1.0));
}

metal::float2 node(
    thread float& i
) {
    float _e44 = i;
    float _e49 = i;
    return metal::float2(_e44 - (metal::floor(_e44 / 2.0) * 2.0), metal::floor(_e49 * 0.5));
}

metal::float3 gap(
    thread metal::float2& w,
    thread metal::float2& g,
    thread float& spacing,
    thread metal::float2& off,
    thread metal::float2& cs_1
) {
    metal::float3 best = {};
    float r = {};
    int i_1 = {};
    metal::float2 n_2 = {};
    float param = {};
    metal::float2 v_1 = {};
    metal::float2 h = {};
    metal::float2 param_1 = {};
    metal::float2 local = {};
    float ri = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    best = metal::float3(0.0, 0.0, 0.0);
    r = 100000.0;
    i_1 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e110 = i_1;
            i_1 = as_type<int>(as_type<uint>(_e110) + as_type<uint>(1));
        }
        loop_init = false;
        int _e61 = i_1;
        if (_e61 < 4) {
            metal::float2 _e63 = g;
            int _e64 = i_1;
            param = static_cast<float>(_e64);
            metal::float2 _e66 = node(param);
            n_2 = _e63 + _e66;
            metal::float2 _e68 = w;
            metal::float2 _e69 = n_2;
            metal::float2 _e70 = off;
            float _e72 = spacing;
            v_1 = _e68 - ((_e69 + _e70) * _e72);
            metal::float2 _e75 = n_2;
            param_1 = _e75;
            float _e76 = parity(param_1);
            if (_e76 > 0.0) {
                metal::float2 _e78 = cs_1;
                local = _e78.yx;
            } else {
                metal::float2 _e80 = cs_1;
                local = _e80;
            }
            metal::float2 _e81 = local;
            h = _e81;
            float _e83 = v_1[0u];
            float _e86 = h[1u];
            float _e89 = v_1[1u];
            float _e92 = h[0u];
            ri = (metal::abs(_e83) * _e86) + (metal::abs(_e89) * _e92);
            float _e95 = ri;
            float _e96 = r;
            if (_e95 < _e96) {
                float _e98 = ri;
                r = _e98;
                metal::float2 _e99 = n_2;
                param_2 = _e99;
                float _e100 = parity(param_2);
                metal::float2 _e103 = v_1;
                param_3 = _e103;
                param_4 = metal::float2(0.7071068, _e100 * 0.7071068);
                metal::float2 _e104 = rot(param_3, param_4);
                int _e105 = i_1;
                best = metal::float3(_e104.x, _e104.y, static_cast<float>(_e105));
            }
            continue;
        } else {
            break;
        }
    }
    metal::float3 _e112 = best;
    return _e112;
}

metal::float4 nearest(
    thread metal::float2& w_1,
    thread metal::float2& g_1,
    thread float& spacing_1,
    thread metal::float2& off_1,
    thread metal::float2& cs_2
) {
    metal::float4 best_1 = {};
    int i_2 = {};
    metal::float2 n_3 = {};
    float param_5 = {};
    metal::float2 l = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 q = {};
    float d = {};
    best_1 = metal::float4(0.0, 0.0, 100000.0, 0.0);
    i_2 = 0;
    uint2 loop_bound_1 = uint2(4294967295u);
    bool loop_init_1 = true;
    while(true) {
        if (metal::all(loop_bound_1 == uint2(0u))) { break; }
        loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
        if (!loop_init_1) {
            int _e107 = i_2;
            i_2 = as_type<int>(as_type<uint>(_e107) + as_type<uint>(1));
        }
        loop_init_1 = false;
        int _e58 = i_2;
        if (_e58 < 4) {
            metal::float2 _e60 = g_1;
            int _e61 = i_2;
            param_5 = static_cast<float>(_e61);
            metal::float2 _e63 = node(param_5);
            n_3 = _e60 + _e63;
            metal::float2 _e65 = w_1;
            metal::float2 _e66 = n_3;
            metal::float2 _e67 = off_1;
            float _e69 = spacing_1;
            float _e73 = cs_2[0u];
            metal::float2 _e74 = n_3;
            param_6 = _e74;
            float _e75 = parity(param_6);
            float _e77 = cs_2[1u];
            param_7 = _e65 - ((_e66 + _e67) * _e69);
            param_8 = metal::float2(_e73, _e75 * _e77);
            metal::float2 _e80 = rot(param_7, param_8);
            l = _e80;
            metal::float2 _e81 = l;
            q = metal::abs(_e81) - metal::float2(0.5);
            metal::float2 _e85 = q;
            float _e90 = q[0u];
            float _e92 = q[1u];
            d = metal::length(metal::max(_e85, metal::float2(0.0))) + metal::min(metal::max(_e90, _e92), 0.0);
            float _e96 = d;
            float _e98 = best_1[2u];
            if (_e96 < _e98) {
                metal::float2 _e100 = l;
                float _e101 = d;
                int _e102 = i_2;
                best_1 = metal::float4(_e100.x, _e100.y, _e101, static_cast<float>(_e102));
            }
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e109 = best_1;
    return _e109;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e45 = uv_1[0u];
    float _e47 = uv_1[1u];
    metal::float4 _e50 = _to.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float4 getFromColor(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e45 = uv_2[0u];
    float _e47 = uv_2[1u];
    metal::float4 _e50 = _from.sample(_sampler, metal::float2(_e45, 1.0 - _e47), metal::level(0.0));
    return _e50;
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    float n_4 = {};
    float e = {};
    float a = {};
    float th = {};
    metal::float2 cs_3 = {};
    float spacing_2 = {};
    float scale = {};
    metal::float2 w_2 = {};
    bool first = {};
    metal::float2 offF = {};
    metal::float2 offB = {};
    metal::float2 gF = {};
    metal::float2 gB = {};
    metal::float4 f = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    float param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float3 b = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    float param_18 = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    metal::float2 nf = {};
    float param_21 = {};
    metal::float2 nb = {};
    float param_22 = {};
    metal::float2 uvF = {};
    metal::float2 param_23 = {};
    float param_24 = {};
    metal::float2 uvB = {};
    metal::float2 param_25 = {};
    float param_26 = {};
    metal::float4 colF = {};
    metal::float4 local_1 = {};
    metal::float2 param_27 = {};
    metal::float2 param_28 = {};
    metal::float4 colB = {};
    metal::float4 local_2 = {};
    metal::float2 param_29 = {};
    metal::float2 param_30 = {};
    float depth = {};
    metal::float2 ws = {};
    metal::float4 sh = {};
    metal::float2 param_31 = {};
    metal::float2 param_32 = {};
    float param_33 = {};
    metal::float2 param_34 = {};
    metal::float2 param_35 = {};
    metal::float2 side = {};
    metal::float2 local_3 = {};
    float facing = {};
    metal::float2 param_36 = {};
    metal::float2 param_37 = {};
    metal::float2 param_38 = {};
    float rim = {};
    float aa = {};
    float seal = {};
    float cover = {};
    float _e108 = uniforms.progress;
    if (_e108 <= 0.0) {
        metal::float2 _e110 = uv_3;
        param_9 = _e110;
        metal::float4 _e111 = getFromColor(param_9, _from, _sampler);
        return _e111;
    }
    float _e113 = uniforms.progress;
    if (_e113 >= 1.0) {
        metal::float2 _e115 = uv_3;
        param_10 = _e115;
        metal::float4 _e116 = getToColor(param_10, _sampler, _to);
        return _e116;
    }
    int _e118 = uniforms.cells;
    n_4 = metal::max(static_cast<float>(_e118), 1.0);
    float _e122 = uniforms.progress;
    float _e124 = uniforms.progress;
    float _e127 = uniforms.progress;
    e = (_e122 * _e124) * (3.0 - (2.0 * _e127));
    float _e131 = e;
    a = 1.5707964 * _e131;
    float _e133 = a;
    float _e134 = a;
    th = metal::min(_e133, 1.5707964 - _e134);
    float _e137 = th;
    float _e139 = th;
    cs_3 = metal::float2(metal::cos(_e137), metal::sin(_e139));
    float _e143 = cs_3[0u];
    float _e145 = cs_3[1u];
    spacing_2 = _e143 + _e145;
    float _e147 = n_4;
    float _e148 = spacing_2;
    float _e150 = uniforms.zoom;
    scale = _e147 * metal::mix(1.0, _e148, metal::clamp(_e150, 0.0, 1.0));
    metal::float2 _e154 = uv_3;
    float _e158 = uniforms.ratio;
    float _e161 = scale;
    w_2 = ((_e154 - metal::float2(0.5)) * metal::float2(_e158, 1.0)) * _e161;
    float _e163 = a;
    first = _e163 < 0.7853982;
    bool _e165 = first;
    offF = metal::select(metal::float2(0.5, 0.5), metal::float2(0.0, 0.0), metal::bool2(_e165));
    metal::float2 _e168 = offF;
    offB = metal::float2(0.5, 0.5) - _e168;
    metal::float2 _e170 = w_2;
    float _e171 = spacing_2;
    metal::float2 _e174 = offF;
    gF = metal::floor((_e170 / metal::float2(_e171)) - _e174);
    metal::float2 _e177 = w_2;
    float _e178 = spacing_2;
    metal::float2 _e181 = offB;
    gB = metal::floor((_e177 / metal::float2(_e178)) - _e181);
    metal::float2 _e184 = w_2;
    param_11 = _e184;
    metal::float2 _e185 = gF;
    param_12 = _e185;
    float _e186 = spacing_2;
    param_13 = _e186;
    metal::float2 _e187 = offF;
    param_14 = _e187;
    metal::float2 _e188 = cs_3;
    param_15 = _e188;
    metal::float4 _e189 = nearest(param_11, param_12, param_13, param_14, param_15);
    f = _e189;
    metal::float2 _e190 = w_2;
    param_16 = _e190;
    metal::float2 _e191 = gB;
    param_17 = _e191;
    float _e192 = spacing_2;
    param_18 = _e192;
    metal::float2 _e193 = offB;
    param_19 = _e193;
    metal::float2 _e194 = cs_3;
    param_20 = _e194;
    metal::float3 _e195 = gap(param_16, param_17, param_18, param_19, param_20);
    b = _e195;
    metal::float2 _e196 = gF;
    float _e198 = f[3u];
    param_21 = _e198;
    metal::float2 _e199 = node(param_21);
    nf = _e196 + _e199;
    metal::float2 _e201 = gB;
    float _e203 = b[2u];
    param_22 = _e203;
    metal::float2 _e204 = node(param_22);
    nb = _e201 + _e204;
    metal::float2 _e206 = nf;
    metal::float2 _e207 = offF;
    metal::float4 _e209 = f;
    param_23 = (_e206 + _e207) + _e209.xy;
    float _e212 = n_4;
    param_24 = _e212;
    metal::float2 _e213 = toUV(param_23, param_24, uniforms);
    uvF = _e213;
    metal::float2 _e214 = nb;
    metal::float2 _e215 = offB;
    metal::float3 _e217 = b;
    param_25 = (_e214 + _e215) + _e217.xy;
    float _e220 = n_4;
    param_26 = _e220;
    metal::float2 _e221 = toUV(param_25, param_26, uniforms);
    uvB = _e221;
    bool _e222 = first;
    if (_e222) {
        metal::float2 _e223 = uvF;
        param_27 = _e223;
        metal::float4 _e224 = getFromColor(param_27, _from, _sampler);
        local_1 = _e224;
    } else {
        metal::float2 _e225 = uvF;
        param_28 = _e225;
        metal::float4 _e226 = getToColor(param_28, _sampler, _to);
        local_1 = _e226;
    }
    metal::float4 _e227 = local_1;
    colF = _e227;
    bool _e228 = first;
    if (_e228) {
        metal::float2 _e229 = uvB;
        param_29 = _e229;
        metal::float4 _e230 = getToColor(param_29, _sampler, _to);
        local_2 = _e230;
    } else {
        metal::float2 _e231 = uvB;
        param_30 = _e231;
        metal::float4 _e232 = getFromColor(param_30, _from, _sampler);
        local_2 = _e232;
    }
    metal::float4 _e233 = local_2;
    colB = _e233;
    float _e235 = uniforms.shading;
    float _e237 = th;
    depth = metal::clamp(_e235, 0.0, 1.0) * metal::sin(4.0 * _e237);
    float _e241 = depth;
    if (_e241 > 0.0) {
        metal::float2 _e243 = w_2;
        float _e244 = depth;
        ws = _e243 - (metal::float2(0.12, -0.12) * _e244);
        metal::float2 _e247 = ws;
        float _e248 = spacing_2;
        metal::float2 _e251 = offF;
        metal::float2 _e254 = ws;
        param_31 = _e254;
        param_32 = metal::floor((_e247 / metal::float2(_e248)) - _e251);
        float _e255 = spacing_2;
        param_33 = _e255;
        metal::float2 _e256 = offF;
        param_34 = _e256;
        metal::float2 _e257 = cs_3;
        param_35 = _e257;
        metal::float4 _e258 = nearest(param_31, param_32, param_33, param_34, param_35);
        sh = _e258;
        float _e259 = depth;
        float _e262 = sh[2u];
        metal::float4 _e267 = colB;
        metal::float3 _e269 = _e267.xyz * (1.0 - ((0.75 * _e259) * (1.0 - metal::smoothstep(-0.12, 0.25, _e262))));
        colB[0u] = _e269.x;
        colB[1u] = _e269.y;
        colB[2u] = _e269.z;
    }
    float _e277 = f[0u];
    float _e280 = f[1u];
    if (metal::abs(_e277) > metal::abs(_e280)) {
        float _e284 = f[0u];
        local_3 = metal::float2(metal::sign(_e284), 0.0);
    } else {
        float _e288 = f[1u];
        local_3 = metal::float2(0.0, metal::sign(_e288));
    }
    metal::float2 _e291 = local_3;
    side = _e291;
    float _e293 = cs_3[0u];
    metal::float2 _e294 = nf;
    param_36 = _e294;
    float _e295 = parity(param_36);
    float _e298 = cs_3[1u];
    metal::float2 _e301 = side;
    param_37 = _e301;
    param_38 = metal::float2(_e293, -(_e295) * _e298);
    metal::float2 _e302 = rot(param_37, param_38);
    facing = metal::dot(_e302, metal::float2(-0.7071, 0.7071));
    float _e305 = f[2u];
    rim = metal::smoothstep(-0.07, -0.01, _e305);
    float _e307 = depth;
    float _e309 = rim;
    float _e311 = facing;
    metal::float4 _e314 = colF;
    metal::float3 _e316 = _e314.xyz * (1.0 + (((0.35 * _e307) * _e309) * _e311));
    colF[0u] = _e316.x;
    colF[1u] = _e316.y;
    colF[2u] = _e316.z;
    float _e323 = scale;
    aa = 0.0012 * _e323;
    float _e325 = aa;
    float _e326 = aa;
    float _e329 = cs_3[1u];
    seal = _e325 * (1.0 - metal::smoothstep(0.0, 3.0 * _e326, _e329));
    float _e333 = aa;
    float _e335 = aa;
    float _e337 = f[2u];
    float _e338 = seal;
    cover = 1.0 - metal::smoothstep(-(_e333), _e335, _e337 - _e338);
    metal::float4 _e342 = colB;
    metal::float4 _e343 = colF;
    float _e344 = cover;
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
    metal::float2 param_39 = {};
    metal::float2 _e44 = _uv_1;
    param_39 = _e44;
    metal::float4 _e45 = transition(param_39, _from, _sampler, _to, uniforms);
    _fragColor = _e45;
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
