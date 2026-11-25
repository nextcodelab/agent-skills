// LayoutGrid — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/LayoutGrid.glsl
// Author: gre
// License: MIT
// Description: The frame splits into an asymmetric magazine grid as paper gutters open between the panels; panel after panel in reading order, the incoming image pushes the outgoing one out of its panel from a different side, a colored accent band between them, then the gutters close over the full incoming image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float gutter;
    float overlap;
    float band;
    float shadow;
    char _pad6[8];
    metal::float4 paper;
    metal::float4 accent;
};

float easeInOut(
    thread float& t
) {
    float local = {};
    float _e71 = t;
    if (_e71 < 0.5) {
        float _e73 = t;
        float _e75 = t;
        float _e77 = t;
        local = ((4.0 * _e73) * _e75) * _e77;
    } else {
        float _e79 = t;
        float _e82 = t;
        float _e85 = t;
        local = 1.0 - (((4.0 * (1.0 - _e79)) * (1.0 - _e82)) * (1.0 - _e85));
    }
    float _e89 = local;
    return _e89;
}

metal::float2 panelDir(
    thread int& i,
    thread bool& portrait
) {
    bool _e71 = portrait;
    if (_e71) {
        int _e72 = i;
        if (_e72 == 0) {
            return metal::float2(1.0, 0.0);
        }
        int _e74 = i;
        if (_e74 == 1) {
            return metal::float2(0.0, -1.0);
        }
        int _e76 = i;
        if (_e76 == 2) {
            return metal::float2(-1.0, 0.0);
        }
        int _e78 = i;
        if (_e78 == 3) {
            return metal::float2(0.0, 1.0);
        }
        int _e80 = i;
        if (_e80 == 4) {
            return metal::float2(1.0, 0.0);
        }
        return metal::float2(-1.0, 0.0);
    }
    int _e82 = i;
    if (_e82 == 0) {
        return metal::float2(0.0, -1.0);
    }
    int _e84 = i;
    if (_e84 == 1) {
        return metal::float2(-1.0, 0.0);
    }
    int _e86 = i;
    if (_e86 == 2) {
        return metal::float2(0.0, 1.0);
    }
    int _e88 = i;
    if (_e88 == 3) {
        return metal::float2(1.0, 0.0);
    }
    int _e90 = i;
    if (_e90 == 4) {
        return metal::float2(-1.0, 0.0);
    }
    return metal::float2(1.0, 0.0);
}

float span1(
    thread float& x,
    thread float& lo,
    thread float& hi,
    thread float& aa
) {
    float _e73 = lo;
    float _e74 = aa;
    float _e76 = lo;
    float _e77 = aa;
    float _e79 = x;
    float _e81 = hi;
    float _e82 = aa;
    float _e84 = hi;
    float _e85 = aa;
    float _e87 = x;
    return metal::smoothstep(_e73 - _e74, _e76 + _e77, _e79) * (1.0 - metal::smoothstep(_e81 - _e82, _e84 + _e85, _e87));
}

float boxDist(
    thread metal::float2& p,
    thread metal::float2& lo_1,
    thread metal::float2& hi_1
) {
    metal::float2 d = {};
    metal::float2 _e73 = p;
    metal::float2 _e74 = lo_1;
    metal::float2 _e75 = hi_1;
    metal::float2 _e80 = hi_1;
    metal::float2 _e81 = lo_1;
    d = metal::abs(_e73 - ((_e74 + _e75) * 0.5)) - ((_e80 - _e81) * 0.5);
    metal::float2 _e85 = d;
    float _e90 = d[0u];
    float _e92 = d[1u];
    return metal::length(metal::max(_e85, metal::float2(0.0))) + metal::min(metal::max(_e90, _e92), 0.0);
}

metal::float4 panelRect(
    thread int& i_1,
    thread bool& portrait_1
) {
    bool _e71 = portrait_1;
    if (_e71) {
        int _e72 = i_1;
        if (_e72 == 0) {
            return metal::float4(0.0, 0.68, 0.62, 1.0);
        }
        int _e74 = i_1;
        if (_e74 == 1) {
            return metal::float4(0.62, 0.68, 1.0, 1.0);
        }
        int _e76 = i_1;
        if (_e76 == 2) {
            return metal::float4(0.0, 0.36, 1.0, 0.68);
        }
        int _e78 = i_1;
        if (_e78 == 3) {
            return metal::float4(0.0, 0.0, 0.46, 0.36);
        }
        int _e80 = i_1;
        if (_e80 == 4) {
            return metal::float4(0.46, 0.17, 1.0, 0.36);
        }
        return metal::float4(0.46, 0.0, 1.0, 0.17);
    }
    int _e82 = i_1;
    if (_e82 == 0) {
        return metal::float4(0.0, 0.42, 0.4, 1.0);
    }
    int _e84 = i_1;
    if (_e84 == 1) {
        return metal::float4(0.4, 0.64, 1.0, 1.0);
    }
    int _e86 = i_1;
    if (_e86 == 2) {
        return metal::float4(0.4, 0.0, 0.7, 0.64);
    }
    int _e88 = i_1;
    if (_e88 == 3) {
        return metal::float4(0.7, 0.32, 1.0, 0.64);
    }
    int _e90 = i_1;
    if (_e90 == 4) {
        return metal::float4(0.7, 0.0, 1.0, 0.32);
    }
    return metal::float4(0.0, 0.0, 0.4, 0.42);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e71 = uv[0u];
    float _e73 = uv[1u];
    metal::float4 _e76 = _to.sample(_sampler, metal::float2(_e71, 1.0 - _e73), metal::level(0.0));
    return _e76;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e71 = uv_1[0u];
    float _e73 = uv_1[1u];
    metal::float4 _e76 = _from.sample(_sampler, metal::float2(_e71, 1.0 - _e73), metal::level(0.0));
    return _e76;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param = {};
    metal::float2 param_1 = {};
    bool portrait_2 = {};
    metal::float2 aspect = {};
    metal::float2 p_1 = {};
    float open = {};
    float g = {};
    float ov = {};
    float span = {};
    metal::float4 color = {};
    float cover = {};
    float shade = {};
    int i_2 = {};
    metal::float4 r = {};
    int param_2 = {};
    bool param_3 = {};
    metal::float2 lo_2 = {};
    metal::float2 hi_2 = {};
    float t_1 = {};
    float lift = {};
    float sd = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    float inside = {};
    float param_7 = {};
    float param_8 = {};
    float param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    float param_13 = {};
    float param_14 = {};
    metal::float2 dir = {};
    int param_15 = {};
    bool param_16 = {};
    metal::float4 c = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    float e = {};
    float param_19 = {};
    float len = {};
    float w = {};
    metal::float2 q = {};
    float a = {};
    metal::float2 local_1 = {};
    float af = {};
    float wf = {};
    float fromW = {};
    float toW = {};
    float bandShade = {};
    metal::float4 b = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float4 bg = {};
    float _e126 = uniforms.progress;
    if (_e126 <= 0.0) {
        metal::float2 _e128 = uv_2;
        param = _e128;
        metal::float4 _e129 = getFromColor(param, _from, _sampler);
        return _e129;
    }
    float _e131 = uniforms.progress;
    if (_e131 >= 1.0) {
        metal::float2 _e133 = uv_2;
        param_1 = _e133;
        metal::float4 _e134 = getToColor(param_1, _sampler, _to);
        return _e134;
    }
    float _e136 = uniforms.ratio;
    portrait_2 = _e136 < 1.0;
    float _e139 = uniforms.ratio;
    float _e142 = uniforms.ratio;
    aspect = metal::float2(_e139, 1.0) / metal::float2(metal::min(_e142, 1.0));
    metal::float2 _e146 = uv_2;
    metal::float2 _e147 = aspect;
    p_1 = _e146 * _e147;
    float _e150 = uniforms.progress;
    float _e153 = uniforms.progress;
    open = metal::smoothstep(0.0, 0.28, _e150) * (1.0 - metal::smoothstep(0.72, 1.0, _e153));
    float _e158 = uniforms.gutter;
    float _e159 = open;
    g = _e158 * _e159;
    float _e162 = uniforms.overlap;
    ov = metal::clamp(_e162, 0.0, 0.9);
    float _e164 = ov;
    span = 0.8 / (1.0 + (5.0 * (1.0 - _e164)));
    color = metal::float4(0.0, 0.0, 0.0, 0.0);
    cover = 0.0;
    shade = 0.0;
    i_2 = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e398 = i_2;
            i_2 = as_type<int>(as_type<uint>(_e398) + as_type<uint>(1));
        }
        loop_init = false;
        int _e169 = i_2;
        if (_e169 < 6) {
            int _e171 = i_2;
            param_2 = _e171;
            bool _e172 = portrait_2;
            param_3 = _e172;
            metal::float4 _e173 = panelRect(param_2, param_3);
            r = _e173;
            metal::float4 _e174 = r;
            metal::float2 _e176 = aspect;
            float _e178 = g;
            lo_2 = (_e174.xy * _e176) + metal::float2(0.5 * _e178);
            metal::float4 _e182 = r;
            metal::float2 _e184 = aspect;
            float _e186 = g;
            hi_2 = (_e182.zw * _e184) - metal::float2(0.5 * _e186);
            metal::float2 _e190 = lo_2;
            metal::float4 _e191 = r;
            lo_2 = metal::mix(_e190, metal::float2(-1.0, -1.0), metal::step(_e191.xy, metal::float2(0.0, 0.0)));
            metal::float2 _e195 = hi_2;
            metal::float2 _e196 = aspect;
            metal::float4 _e199 = r;
            hi_2 = metal::mix(_e195, _e196 + metal::float2(1.0), metal::step(metal::float2(1.0, 1.0), _e199.zw));
            float _e204 = uniforms.progress;
            int _e206 = i_2;
            float _e208 = span;
            float _e210 = ov;
            float _e214 = span;
            t_1 = metal::clamp(((_e204 - 0.1) - ((static_cast<float>(_e206) * _e208) * (1.0 - _e210))) / _e214, 0.0, 1.0);
            float _e217 = t_1;
            lift = 1.0 + (1.2 * metal::sin(3.1415927 * _e217));
            metal::float2 _e222 = p_1;
            float _e223 = g;
            float _e225 = lift;
            param_4 = _e222 - ((metal::float2(0.2, -0.35) * _e223) * _e225);
            metal::float2 _e228 = lo_2;
            param_5 = _e228;
            metal::float2 _e229 = hi_2;
            param_6 = _e229;
            float _e230 = boxDist(param_4, param_5, param_6);
            sd = _e230;
            float _e231 = shade;
            float _e232 = g;
            float _e234 = g;
            float _e236 = lift;
            float _e239 = sd;
            float _e242 = lift;
            shade = metal::max(_e231, (1.0 - metal::smoothstep(-0.2 * _e232, ((0.6 * _e234) * _e236) + 0.0001, _e239)) / metal::sqrt(_e242));
            float _e247 = p_1[0u];
            param_7 = _e247;
            float _e249 = lo_2[0u];
            param_8 = _e249;
            float _e251 = hi_2[0u];
            param_9 = _e251;
            param_10 = 0.0025;
            float _e252 = span1(param_7, param_8, param_9, param_10);
            float _e254 = p_1[1u];
            param_11 = _e254;
            float _e256 = lo_2[1u];
            param_12 = _e256;
            float _e258 = hi_2[1u];
            param_13 = _e258;
            param_14 = 0.0025;
            float _e259 = span1(param_11, param_12, param_13, param_14);
            inside = _e252 * _e259;
            float _e261 = inside;
            if (_e261 > 0.0) {
                int _e263 = i_2;
                param_15 = _e263;
                bool _e264 = portrait_2;
                param_16 = _e264;
                metal::float2 _e265 = panelDir(param_15, param_16);
                dir = _e265;
                float _e266 = t_1;
                if (_e266 <= 0.0) {
                    metal::float2 _e268 = uv_2;
                    param_17 = _e268;
                    metal::float4 _e269 = getFromColor(param_17, _from, _sampler);
                    c = _e269;
                } else {
                    float _e270 = t_1;
                    if (_e270 >= 1.0) {
                        metal::float2 _e272 = uv_2;
                        param_18 = _e272;
                        metal::float4 _e273 = getToColor(param_18, _sampler, _to);
                        c = _e273;
                    } else {
                        float _e274 = t_1;
                        param_19 = _e274;
                        float _e275 = easeInOut(param_19);
                        e = _e275;
                        metal::float4 _e276 = r;
                        metal::float4 _e278 = r;
                        metal::float2 _e281 = dir;
                        len = metal::abs(metal::dot(_e276.zw - _e278.xy, _e281));
                        float _e285 = uniforms.band;
                        float _e286 = len;
                        w = _e285 * _e286;
                        metal::float2 _e288 = uv_2;
                        metal::float2 _e289 = dir;
                        float _e290 = e;
                        float _e292 = len;
                        float _e293 = w;
                        q = _e288 - ((_e289 * _e290) * (_e292 + _e293));
                        metal::float2 _e297 = q;
                        float _e299 = dir[0u];
                        float _e301 = dir[1u];
                        if ((_e299 + _e301) < 0.0) {
                            metal::float4 _e304 = r;
                            local_1 = _e304.zw;
                        } else {
                            metal::float4 _e306 = r;
                            local_1 = _e306.xy;
                        }
                        metal::float2 _e308 = local_1;
                        metal::float2 _e310 = dir;
                        a = metal::dot(_e297 - _e308, _e310);
                        float _e312 = a;
                        metal::float2 _e313 = aspect;
                        metal::float2 _e314 = dir;
                        af = _e312 * metal::abs(metal::dot(_e313, _e314));
                        float _e318 = w;
                        metal::float2 _e319 = aspect;
                        metal::float2 _e320 = dir;
                        wf = _e318 * metal::abs(metal::dot(_e319, _e320));
                        float _e324 = af;
                        fromW = metal::smoothstep(-0.0025, 0.0, _e324);
                        float _e326 = wf;
                        float _e328 = wf;
                        float _e331 = af;
                        toW = 1.0 - metal::smoothstep(-(_e326), -(_e328) + 0.0025, _e331);
                        float _e335 = uniforms.shadow;
                        float _e337 = wf;
                        float _e339 = wf;
                        float _e341 = wf;
                        float _e345 = af;
                        bandShade = 1.0 - ((_e335 * 0.5) * (1.0 - metal::smoothstep(-(_e337), (-(_e339) + (0.35 * _e341)) + 0.0001, _e345)));
                        metal::float4 _e351 = uniforms.accent;
                        float _e353 = bandShade;
                        metal::float3 _e354 = _e351.xyz * _e353;
                        float _e357 = uniforms.accent[3u];
                        b = metal::float4(_e354.x, _e354.y, _e354.z, _e357);
                        metal::float4 _e362 = b;
                        metal::float2 _e363 = q;
                        metal::float4 _e364 = r;
                        metal::float4 _e366 = r;
                        param_20 = metal::clamp(_e363, _e364.xy, _e366.zw);
                        metal::float4 _e369 = getFromColor(param_20, _from, _sampler);
                        float _e370 = fromW;
                        c = metal::mix(_e362, _e369, metal::float4(_e370));
                        metal::float4 _e373 = c;
                        metal::float2 _e374 = q;
                        metal::float2 _e375 = dir;
                        float _e376 = len;
                        float _e377 = w;
                        metal::float4 _e381 = r;
                        metal::float4 _e383 = r;
                        param_21 = metal::clamp(_e374 + (_e375 * (_e376 + _e377)), _e381.xy, _e383.zw);
                        metal::float4 _e386 = getToColor(param_21, _sampler, _to);
                        float _e387 = toW;
                        c = metal::mix(_e373, _e386, metal::float4(_e387));
                    }
                }
                metal::float4 _e390 = c;
                float _e391 = inside;
                metal::float4 _e393 = color;
                color = _e393 + (_e390 * _e391);
                float _e395 = inside;
                float _e396 = cover;
                cover = _e396 + _e395;
            }
            continue;
        } else {
            break;
        }
    }
    float _e400 = cover;
    metal::float4 _e402 = color;
    color = _e402 / metal::float4(metal::max(_e400, 1.0));
    float _e405 = cover;
    cover = metal::min(_e405, 1.0);
    metal::float4 _e408 = uniforms.paper;
    float _e411 = uniforms.shadow;
    float _e412 = shade;
    float _e414 = open;
    metal::float3 _e417 = _e408.xyz * (1.0 - ((_e411 * _e412) * _e414));
    float _e420 = uniforms.paper[3u];
    bg = metal::float4(_e417.x, _e417.y, _e417.z, _e420);
    metal::float4 _e425 = color;
    metal::float4 _e426 = bg;
    float _e427 = cover;
    return _e425 + (_e426 * (1.0 - _e427));
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
    metal::float2 _e70 = _uv_1;
    param_22 = _e70;
    metal::float4 _e71 = transition(param_22, _from, _sampler, _to, uniforms);
    _fragColor = _e71;
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
