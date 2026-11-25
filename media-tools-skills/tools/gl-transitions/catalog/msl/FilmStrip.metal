// FilmStrip — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FilmStrip.glsl
// Author: gre
// License: MIT
// Description: The picture slips like film in a projector gate: it shrinks to show the sprocket holes, the strip runs down with motion blur and a slight weave, then the incoming frame lands in place
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int frames;
    float shrink;
    float blur;
    float weave;
    char _pad6[8];
    metal::float4 filmColor;
    metal::float4 holeColor;
};

float dither(
    thread metal::float2& cell
) {
    metal::float2 _e61 = cell;
    return metal::fract(52.982918 * metal::fract(metal::dot(_e61, metal::float2(0.06711056, 0.00583715))));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e62 = uv[0u];
    float _e64 = uv[1u];
    metal::float4 _e67 = _to.sample(_sampler, metal::float2(_e62, 1.0 - _e64), metal::level(0.0));
    return _e67;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e62 = uv_1[0u];
    float _e64 = uv_1[1u];
    metal::float4 _e67 = _from.sample(_sampler, metal::float2(_e62, 1.0 - _e64), metal::level(0.0));
    return _e67;
}

metal::float4 film(
    thread float& x,
    thread float& y,
    thread float& base,
    thread float& n,
    thread float& aa,
    thread float& holeX,
    thread metal::float2& holeSize,
    thread float& holes,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float pitch = {};
    float jy = {};
    float j = {};
    float fy = {};
    metal::float4 c = {};
    metal::float2 q = {};
    metal::float4 local = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    float inside = {};
    float hy = {};
    float hx = {};
    metal::float2 dd = {};
    float sd = {};
    pitch = 1.08;
    float _e82 = y;
    float _e83 = pitch;
    jy = metal::floor(_e82 / _e83);
    float _e86 = base;
    float _e87 = jy;
    j = _e86 + _e87;
    float _e89 = y;
    float _e90 = jy;
    float _e91 = pitch;
    fy = _e89 - (_e90 * _e91);
    metal::float4 _e95 = uniforms.filmColor;
    c = _e95;
    float _e96 = x;
    float _e98 = x;
    float _e101 = fy;
    if (((_e96 >= 0.0) && (_e98 <= 1.0)) && (_e101 <= 1.0)) {
        float _e104 = x;
        float _e105 = fy;
        q = metal::float2(_e104, _e105);
        float _e107 = j;
        float _e108 = n;
        if (_e107 < _e108) {
            metal::float2 _e110 = q;
            param = _e110;
            metal::float4 _e111 = getFromColor(param, _from, _sampler);
            local = _e111;
        } else {
            metal::float2 _e112 = q;
            param_1 = _e112;
            metal::float4 _e113 = getToColor(param_1, _sampler, _to);
            local = _e113;
        }
        metal::float4 _e114 = local;
        c = _e114;
    }
    float _e115 = x;
    float _e116 = x;
    float _e120 = uniforms.ratio;
    float _e122 = fy;
    float _e123 = fy;
    inside = metal::min(metal::min(_e115, 1.0 - _e116) * _e120, metal::min(_e122, 1.0 - _e123));
    metal::float4 _e128 = uniforms.filmColor;
    metal::float4 _e129 = c;
    float _e130 = inside;
    float _e131 = aa;
    c = metal::mix(_e128, _e129, metal::float4(metal::clamp((_e130 / _e131) + 0.5, 0.0, 1.0)));
    float _e137 = y;
    float _e138 = pitch;
    float _e139 = _e138 / 4.0;
    float _e144 = pitch;
    hy = (_e137 - (metal::floor(_e137 / _e139) * _e139)) - ((0.5 * _e144) / 4.0);
    float _e148 = x;
    float _e151 = holeX;
    float _e154 = uniforms.ratio;
    hx = (metal::abs(_e148 - 0.5) - _e151) * _e154;
    float _e156 = hx;
    float _e157 = hy;
    metal::float2 _e160 = holeSize;
    float _e163 = holeSize[0u];
    dd = (metal::abs(metal::float2(_e156, _e157)) - _e160) + metal::float2(0.3 * _e163);
    metal::float2 _e167 = dd;
    float _e172 = dd[0u];
    float _e174 = dd[1u];
    float _e179 = holeSize[0u];
    sd = (metal::length(metal::max(_e167, metal::float2(0.0))) + metal::min(metal::max(_e172, _e174), 0.0)) - (0.3 * _e179);
    metal::float4 _e182 = c;
    metal::float4 _e184 = uniforms.holeColor;
    float _e185 = sd;
    float _e186 = aa;
    float _e190 = holes;
    return metal::mix(_e182, _e184, metal::float4(metal::clamp(0.5 - (_e185 / _e186), 0.0, 1.0) * _e190));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float n_1 = {};
    float pitch_1 = {};
    float p = {};
    float env = {};
    float k = {};
    float x0_ = {};
    float slip = {};
    float speed = {};
    float wob = {};
    float dx = {};
    float dy = {};
    float frameSlip = {};
    float base_1 = {};
    float x_1 = {};
    float y_1 = {};
    float aa_1 = {};
    float margin = {};
    float holeX_1 = {};
    metal::float2 holeSize_1 = {};
    float holes_1 = {};
    float len = {};
    metal::float4 color = {};
    float param_4 = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    metal::float2 param_10 = {};
    float param_11 = {};
    float jitter = {};
    metal::float2 param_12 = {};
    int i = {};
    float t = {};
    metal::float4 c_1 = {};
    float param_13 = {};
    float param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    float param_18 = {};
    metal::float2 param_19 = {};
    float param_20 = {};
    metal::float3 local_1 = {};
    float _e108 = uniforms.progress;
    if (_e108 <= 0.0) {
        metal::float2 _e110 = uv_2;
        param_2 = _e110;
        metal::float4 _e111 = getFromColor(param_2, _from, _sampler);
        return _e111;
    }
    float _e113 = uniforms.progress;
    if (_e113 >= 1.0) {
        metal::float2 _e115 = uv_2;
        param_3 = _e115;
        metal::float4 _e116 = getToColor(param_3, _sampler, _to);
        return _e116;
    }
    int _e118 = uniforms.frames;
    n_1 = metal::max(static_cast<float>(_e118), 1.0);
    pitch_1 = 1.08;
    float _e122 = uniforms.progress;
    p = _e122;
    float _e123 = p;
    float _e125 = p;
    env = metal::smoothstep(0.0, 0.3, _e123) * (1.0 - metal::smoothstep(0.7, 1.0, _e125));
    float _e130 = uniforms.shrink;
    float _e131 = env;
    k = 1.0 - (_e130 * _e131);
    float _e134 = p;
    x0_ = metal::clamp((_e134 - 0.15) / 0.7, 0.0, 1.0);
    float _e138 = x0_;
    float _e139 = x0_;
    float _e141 = x0_;
    float _e143 = x0_;
    float _e144 = x0_;
    slip = ((_e138 * _e139) * _e141) * ((_e143 * ((_e144 * 6.0) - 15.0)) + 10.0);
    float _e150 = x0_;
    float _e152 = x0_;
    float _e154 = x0_;
    float _e157 = x0_;
    speed = ((((30.0 * _e150) * _e152) * (1.0 - _e154)) * (1.0 - _e157)) / 0.7;
    float _e162 = uniforms.weave;
    float _e163 = env;
    wob = _e162 * _e163;
    float _e165 = wob;
    float _e167 = uniforms.shrink;
    float _e170 = p;
    float _e174 = p;
    dx = (_e165 * metal::smoothstep(0.0, 0.1, _e167)) * ((0.006 * metal::sin(_e170 * 47.0)) + (0.004 * metal::sin((_e174 * 113.0) + 1.3)));
    float _e181 = wob;
    float _e183 = p;
    float _e188 = speed;
    dy = ((_e181 * 0.012) * metal::sin((_e183 * 71.0) + 0.4)) * (1.0 - (_e188 / 2.7));
    float _e192 = slip;
    float _e193 = n_1;
    frameSlip = _e192 * _e193;
    float _e195 = frameSlip;
    base_1 = metal::floor(_e195);
    float _e198 = uv_2[0u];
    float _e200 = k;
    float _e203 = dx;
    x_1 = (((_e198 - 0.5) / _e200) + 0.5) + _e203;
    float _e206 = uv_2[1u];
    float _e208 = k;
    float _e211 = dy;
    float _e213 = frameSlip;
    float _e214 = base_1;
    float _e216 = pitch_1;
    y_1 = ((((_e206 - 0.5) / _e208) + 0.5) + _e211) + ((_e213 - _e214) * _e216);
    float _e219 = env;
    float _e224 = uniforms.shrink;
    aa_1 = ((0.002 * metal::min(1.0, 10.0 * _e219)) * metal::min(1.0, 20.0 * _e224)) + 0.0001;
    float _e230 = uniforms.shrink;
    float _e233 = uniforms.shrink;
    margin = (0.5 * _e230) / metal::max(1.0 - _e233, 0.01);
    float _e237 = margin;
    holeX_1 = 0.5 + (0.5 * _e237);
    float _e240 = margin;
    float _e243 = uniforms.ratio;
    float _e245 = pitch_1;
    holeSize_1 = metal::float2((0.28 * _e240) * _e243, (0.11 * _e245) / 4.0);
    float _e249 = margin;
    holes_1 = metal::smoothstep(0.0, 0.02, _e249);
    float _e252 = uniforms.blur;
    float _e254 = speed;
    float _e256 = n_1;
    len = ((_e252 * 0.06) * _e254) * _e256;
    color = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e258 = len;
    if (_e258 < 0.00001) {
        float _e260 = x_1;
        param_4 = _e260;
        float _e261 = y_1;
        param_5 = _e261;
        float _e262 = base_1;
        param_6 = _e262;
        float _e263 = n_1;
        param_7 = _e263;
        float _e264 = aa_1;
        param_8 = _e264;
        float _e265 = holeX_1;
        param_9 = _e265;
        metal::float2 _e266 = holeSize_1;
        param_10 = _e266;
        float _e267 = holes_1;
        param_11 = _e267;
        metal::float4 _e268 = film(param_4, param_5, param_6, param_7, param_8, param_9, param_10, param_11, _from, _sampler, _to, uniforms);
        color = _e268;
    } else {
        metal::float2 _e269 = uv_2;
        float _e271 = uniforms.ratio;
        param_12 = metal::floor((_e269 * metal::float2(_e271, 1.0)) * 540.0);
        float _e276 = dither(param_12);
        jitter = _e276;
        i = 0;
        uint2 loop_bound = uint2(4294967295u);
        bool loop_init = true;
        while(true) {
            if (metal::all(loop_bound == uint2(0u))) { break; }
            loop_bound -= uint2(loop_bound.y == 0u, 1u);
            if (!loop_init) {
                int _e311 = i;
                i = as_type<int>(as_type<uint>(_e311) + as_type<uint>(1));
            }
            loop_init = false;
            int _e277 = i;
            if (_e277 < 16) {
                int _e279 = i;
                float _e281 = jitter;
                t = ((static_cast<float>(_e279) + _e281) / 16.0) - 0.5;
                float _e285 = y_1;
                float _e286 = t;
                float _e287 = len;
                float _e290 = x_1;
                param_13 = _e290;
                param_14 = _e285 + (_e286 * _e287);
                float _e291 = base_1;
                param_15 = _e291;
                float _e292 = n_1;
                param_16 = _e292;
                float _e293 = aa_1;
                param_17 = _e293;
                float _e294 = holeX_1;
                param_18 = _e294;
                metal::float2 _e295 = holeSize_1;
                param_19 = _e295;
                float _e296 = holes_1;
                param_20 = _e296;
                metal::float4 _e297 = film(param_13, param_14, param_15, param_16, param_17, param_18, param_19, param_20, _from, _sampler, _to, uniforms);
                c_1 = _e297;
                metal::float4 _e298 = c_1;
                float _e301 = c_1[3u];
                metal::float3 _e302 = _e298.xyz * _e301;
                float _e304 = c_1[3u];
                metal::float4 _e309 = color;
                color = _e309 + metal::float4(_e302.x, _e302.y, _e302.z, _e304);
                continue;
            } else {
                break;
            }
        }
        metal::float4 _e313 = color;
        color = _e313 / metal::float4(16.0);
        float _e317 = color[3u];
        if (_e317 > 0.0) {
            metal::float4 _e319 = color;
            float _e322 = color[3u];
            local_1 = _e319.xyz / metal::float3(_e322);
        } else {
            local_1 = metal::float3(0.0, 0.0, 0.0);
        }
        metal::float3 _e325 = local_1;
        color[0u] = _e325.x;
        color[1u] = _e325.y;
        color[2u] = _e325.z;
    }
    float _e332 = wob;
    float _e334 = p;
    metal::float4 _e341 = color;
    metal::float3 _e343 = _e341.xyz * (1.0 - ((0.08 * _e332) * (0.5 + (0.5 * metal::sin(_e334 * 157.0)))));
    color[0u] = _e343.x;
    color[1u] = _e343.y;
    color[2u] = _e343.z;
    metal::float4 _e350 = color;
    return _e350;
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
    metal::float2 _e61 = _uv_1;
    param_21 = _e61;
    metal::float4 _e62 = transition(param_21, _from, _sampler, _to, uniforms);
    _fragColor = _e62;
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
