// GlitchDisplace — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchDisplace.glsl
// Author: Matt DesLauriers
// License: MIT
// Description: Blocks of the image are displaced in a glitch that flashes into the incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
};

float ease2(
    thread float& t
) {
    float local = {};
    float _e35 = t;
    if (_e35 == 1.0) {
        float _e37 = t;
        local = _e37;
    } else {
        float _e38 = t;
        local = 1.0 - metal::pow(2.0, -10.0 * _e38);
    }
    float _e42 = local;
    return _e42;
}

float random(
    thread metal::float2& co
) {
    float a = {};
    float b = {};
    float c = {};
    float dt = {};
    float sn = {};
    a = 12.9898;
    b = 78.233;
    c = 43758.547;
    metal::float2 _e39 = co;
    float _e40 = a;
    float _e41 = b;
    dt = metal::dot(_e39, metal::float2(_e40, _e41));
    float _e44 = dt;
    sn = _e44 - (metal::floor(_e44 / 3.14) * 3.14);
    float _e49 = sn;
    float _e51 = c;
    return metal::fract(metal::sin(_e49) * _e51);
}

float voronoi(
    thread metal::float2& x
) {
    metal::float2 p = {};
    metal::float2 f = {};
    float res = {};
    float j = {};
    float i = {};
    metal::float2 b_1 = {};
    metal::float2 r = {};
    metal::float2 param = {};
    float d = {};
    metal::float2 _e43 = x;
    p = metal::floor(_e43);
    metal::float2 _e45 = x;
    f = metal::fract(_e45);
    res = 8.0;
    j = -1.0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            float _e71 = j;
            j = _e71 + 1.0;
        }
        loop_init = false;
        float _e47 = j;
        if (_e47 <= 1.0) {
            i = -1.0;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    float _e69 = i;
                    i = _e69 + 1.0;
                }
                loop_init_1 = false;
                float _e49 = i;
                if (_e49 <= 1.0) {
                    float _e51 = i;
                    float _e52 = j;
                    b_1 = metal::float2(_e51, _e52);
                    metal::float2 _e54 = b_1;
                    metal::float2 _e55 = f;
                    metal::float2 _e57 = p;
                    metal::float2 _e58 = b_1;
                    param = _e57 + _e58;
                    float _e60 = random(param);
                    r = (_e54 - _e55) + metal::float2(_e60);
                    metal::float2 _e63 = r;
                    metal::float2 _e64 = r;
                    d = metal::dot(_e63, _e64);
                    float _e66 = res;
                    float _e67 = d;
                    res = metal::min(_e66, _e67);
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e73 = res;
    return metal::sqrt(_e73);
}

metal::float2 displace(
    thread metal::float4& tex,
    thread metal::float2& texCoord,
    thread float& dotDepth,
    thread float& textureDepth,
    thread float& strength
) {
    float b_2 = {};
    metal::float2 param_1 = {};
    float g = {};
    metal::float2 param_2 = {};
    float r_1 = {};
    metal::float2 param_3 = {};
    metal::float4 dt_1 = {};
    metal::float4 dis = {};
    metal::float2 res_uv = {};
    metal::float2 _e47 = texCoord;
    param_1 = (_e47 * 0.003) + metal::float2(2.0);
    float _e51 = voronoi(param_1);
    b_2 = _e51;
    metal::float2 _e52 = texCoord;
    param_2 = _e52 * 0.2;
    float _e54 = voronoi(param_2);
    g = _e54;
    metal::float2 _e55 = texCoord;
    param_3 = _e55 - metal::float2(1.0);
    float _e58 = voronoi(param_3);
    r_1 = _e58;
    metal::float4 _e59 = tex;
    dt_1 = _e59 * 1.0;
    metal::float4 _e61 = dt_1;
    float _e62 = dotDepth;
    metal::float4 _e66 = tex;
    float _e67 = textureDepth;
    dis = ((_e61 * _e62) + metal::float4(1.0)) - (_e66 * _e67);
    float _e71 = dis[0u];
    float _e73 = textureDepth;
    float _e74 = dotDepth;
    dis[0u] = (_e71 - 1.0) + (_e73 * _e74);
    float _e79 = dis[1u];
    float _e81 = textureDepth;
    float _e82 = dotDepth;
    dis[1u] = (_e79 - 1.0) + (_e81 * _e82);
    float _e86 = strength;
    float _e88 = dis[0u];
    dis[0u] = _e88 * _e86;
    float _e91 = strength;
    float _e93 = dis[1u];
    dis[1u] = _e93 * _e91;
    metal::float2 _e96 = texCoord;
    res_uv = _e96;
    float _e98 = res_uv[0u];
    float _e100 = dis[0u];
    res_uv[0u] = (_e98 + _e100) - 0.0;
    float _e105 = res_uv[1u];
    float _e107 = dis[1u];
    res_uv[1u] = _e105 + _e107;
    metal::float2 _e110 = res_uv;
    return _e110;
}

float ease1(
    thread float& t_1
) {
    float local_1 = {};
    float local_2 = {};
    float _e36 = t_1;
    float _e38 = t_1;
    if ((_e36 == 0.0) || (_e38 == 1.0)) {
        float _e41 = t_1;
        local_1 = _e41;
    } else {
        float _e42 = t_1;
        if (_e42 < 0.5) {
            float _e44 = t_1;
            local_2 = 0.5 * metal::pow(2.0, (20.0 * _e44) - 10.0);
        } else {
            float _e49 = t_1;
            local_2 = (-0.5 * metal::pow(2.0, 10.0 - (_e49 * 20.0))) + 1.0;
        }
        float _e55 = local_2;
        local_1 = _e55;
    }
    float _e56 = local_1;
    return _e56;
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e35 = uv[0u];
    float _e37 = uv[1u];
    metal::float4 _e40 = _to.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e35 = uv_1[0u];
    float _e37 = uv_1[1u];
    metal::float4 _e40 = _from.sample(_sampler, metal::float2(_e35, 1.0 - _e37), metal::level(0.0));
    return _e40;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 p_1 = {};
    metal::float4 color1_ = {};
    metal::float2 param_4 = {};
    metal::float4 color2_ = {};
    metal::float2 param_5 = {};
    metal::float2 disp = {};
    float param_6 = {};
    metal::float4 param_7 = {};
    metal::float2 param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    metal::float2 disp2_ = {};
    float param_12 = {};
    metal::float4 param_13 = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    metal::float4 dColor1_ = {};
    metal::float2 param_18 = {};
    metal::float4 dColor2_ = {};
    metal::float2 param_19 = {};
    float val = {};
    float param_20 = {};
    metal::float3 gray = {};
    metal::float2 _e60 = uv_2;
    p_1 = _e60 / metal::float2(1.0, 1.0);
    metal::float2 _e62 = p_1;
    param_4 = _e62;
    metal::float4 _e63 = getFromColor(param_4, _from, _sampler);
    color1_ = _e63;
    metal::float2 _e64 = p_1;
    param_5 = _e64;
    metal::float4 _e65 = getToColor(param_5, _sampler, _to);
    color2_ = _e65;
    float _e67 = uniforms.progress;
    param_6 = _e67;
    float _e68 = ease1(param_6);
    metal::float4 _e70 = color1_;
    param_7 = _e70;
    metal::float2 _e71 = p_1;
    param_8 = _e71;
    param_9 = 0.33;
    param_10 = 0.7;
    param_11 = 1.0 - _e68;
    metal::float2 _e72 = displace(param_7, param_8, param_9, param_10, param_11);
    disp = _e72;
    float _e74 = uniforms.progress;
    param_12 = _e74;
    float _e75 = ease2(param_12);
    metal::float4 _e76 = color2_;
    param_13 = _e76;
    metal::float2 _e77 = p_1;
    param_14 = _e77;
    param_15 = 0.33;
    param_16 = 0.5;
    param_17 = _e75;
    metal::float2 _e78 = displace(param_13, param_14, param_15, param_16, param_17);
    disp2_ = _e78;
    metal::float2 _e79 = disp;
    param_18 = _e79;
    metal::float4 _e80 = getToColor(param_18, _sampler, _to);
    dColor1_ = _e80;
    metal::float2 _e81 = disp2_;
    param_19 = _e81;
    metal::float4 _e82 = getFromColor(param_19, _from, _sampler);
    dColor2_ = _e82;
    float _e84 = uniforms.progress;
    param_20 = _e84;
    float _e85 = ease1(param_20);
    val = _e85;
    metal::float4 _e86 = dColor2_;
    metal::float4 _e87 = dColor1_;
    gray = metal::float3(metal::dot(metal::min(_e86, _e87).xyz, metal::float3(0.299, 0.587, 0.114)));
    metal::float3 _e92 = gray;
    metal::float3 _e93 = _e92 * 2.0;
    float _e95 = dColor2_[3u];
    dColor2_ = metal::float4(_e93.x, _e93.y, _e93.z, _e95);
    metal::float4 _e100 = color1_;
    metal::float4 _e101 = dColor2_;
    float _e103 = uniforms.progress;
    color1_ = metal::mix(_e100, _e101, metal::float4(metal::smoothstep(0.0, 0.5, _e103)));
    metal::float4 _e107 = color2_;
    metal::float4 _e108 = dColor1_;
    float _e110 = uniforms.progress;
    color2_ = metal::mix(_e107, _e108, metal::float4(metal::smoothstep(1.0, 0.5, _e110)));
    metal::float4 _e114 = color1_;
    metal::float4 _e115 = color2_;
    float _e116 = val;
    return metal::mix(_e114, _e115, metal::float4(_e116));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_21 = {};
    metal::float2 _e34 = _uv_1;
    param_21 = _e34;
    metal::float4 _e35 = transition(param_21, _from, _sampler, _to, uniforms);
    _fragColor = _e35;
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
