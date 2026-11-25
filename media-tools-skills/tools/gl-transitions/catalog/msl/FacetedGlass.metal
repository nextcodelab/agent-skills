// FacetedGlass — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/FacetedGlass.glsl
// Author: gre
// License: MIT
// Description: The frame is seen through a pane of irregular cut-glass facets, each one showing its own shifted, zoomed and tilted view of the image, with bright beveled edges and thin dark seams; the facets turn to the incoming image one by one, then the glass flattens out and clears
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float facets;
    float refraction;
    float bevel;
    char _pad5[12];
    metal::float4 highlight;
    float seed;
    char _pad7[12];
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e57 = v;
    metal::float2 _e58 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e57 - (metal::floor(_e57 / _e58) * _e58)));
}

metal::float2 hash22(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e58 = p;
    p3_ = metal::fract(_e58.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e62 = p3_;
    metal::float3 _e63 = p3_;
    metal::float3 _e68 = p3_;
    p3_ = _e68 + metal::float3(metal::dot(_e62, _e63.yzx + metal::float3(33.33)));
    metal::float3 _e71 = p3_;
    metal::float3 _e73 = p3_;
    metal::float3 _e76 = p3_;
    return metal::fract((_e71.xx + _e73.yz) * _e76.zy);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e58 = uv[0u];
    float _e60 = uv[1u];
    metal::float4 _e63 = _to.sample(_sampler, metal::float2(_e58, 1.0 - _e60), metal::level(0.0));
    return _e63;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e58 = uv_1[0u];
    float _e60 = uv_1[1u];
    metal::float4 _e63 = _from.sample(_sampler, metal::float2(_e58, 1.0 - _e60), metal::level(0.0));
    return _e63;
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
    float h = {};
    float amount = {};
    float n = {};
    metal::float2 aspect = {};
    metal::float2 p_1 = {};
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 offset = {};
    float bw = {};
    metal::float2 mg = {};
    metal::float2 mr = {};
    float md = {};
    int y = {};
    int x = {};
    metal::float2 g = {};
    metal::float2 r = {};
    metal::float2 param_2 = {};
    float d = {};
    float edge = {};
    metal::float2 normal = {};
    int y_1 = {};
    int x_1 = {};
    metal::float2 g_1 = {};
    metal::float2 r_1 = {};
    metal::float2 param_3 = {};
    metal::float2 dr = {};
    metal::float2 dn = {};
    float e = {};
    float w = {};
    float nl = {};
    metal::float2 local = {};
    metal::float2 id = {};
    metal::float2 h1_ = {};
    metal::float2 param_4 = {};
    metal::float2 h2_ = {};
    metal::float2 param_5 = {};
    metal::float2 h3_ = {};
    metal::float2 param_6 = {};
    float angle = {};
    metal::float2 dir = {};
    metal::float2 shift = {};
    float zoom = {};
    float tilt = {};
    metal::float2 q = {};
    metal::float2 view = {};
    float bv = {};
    metal::float2 bend = {};
    float start = {};
    float m = {};
    metal::float2 d_1 = {};
    metal::float2 s = {};
    metal::float4 ca = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float4 cb = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float4 c = {};
    metal::float2 light = {};
    metal::float2 slope = {};
    float facetLight = {};
    float lit = {};
    float k = {};
    float glow = {};
    float shade = {};
    float turn = {};
    float seam = {};
    metal::float4 local_1 = {};
    float _e128 = uniforms.progress;
    if (_e128 <= 0.0) {
        metal::float2 _e130 = uv_2;
        param = _e130;
        metal::float4 _e131 = getFromColor(param, _from, _sampler);
        return _e131;
    }
    float _e133 = uniforms.progress;
    if (_e133 >= 1.0) {
        metal::float2 _e135 = uv_2;
        param_1 = _e135;
        metal::float4 _e136 = getToColor(param_1, _sampler, _to);
        return _e136;
    }
    float _e138 = uniforms.progress;
    h = 1.0 - metal::abs((2.0 * _e138) - 1.0);
    float _e143 = h;
    float _e144 = h;
    float _e146 = h;
    amount = (_e143 * _e144) * (3.0 - (2.0 * _e146));
    float _e151 = uniforms.facets;
    n = metal::max(_e151, 1.0);
    float _e154 = uniforms.ratio;
    aspect = metal::float2(_e154, 1.0);
    metal::float2 _e156 = uv_2;
    metal::float2 _e157 = aspect;
    float _e159 = n;
    p_1 = (_e156 * _e157) * _e159;
    metal::float2 _e161 = p_1;
    i = metal::floor(_e161);
    metal::float2 _e163 = p_1;
    metal::float2 _e164 = i;
    f = _e163 - _e164;
    float _e167 = uniforms.seed;
    offset = metal::float2(17.31, 41.97) * _e167;
    float _e169 = amount;
    bw = 0.18 * _e169;
    mg = metal::float2(0.0, 0.0);
    mr = metal::float2(0.0, 0.0);
    md = 8.0;
    y = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e204 = y;
            y = as_type<int>(as_type<uint>(_e204) + as_type<uint>(1));
        }
        loop_init = false;
        int _e171 = y;
        if (_e171 <= 1) {
            x = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e202 = x;
                    x = as_type<int>(as_type<uint>(_e202) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e173 = x;
                if (_e173 <= 1) {
                    int _e175 = x;
                    int _e177 = y;
                    g = metal::float2(static_cast<float>(_e175), static_cast<float>(_e177));
                    metal::float2 _e180 = g;
                    metal::float2 _e183 = i;
                    metal::float2 _e184 = g;
                    metal::float2 _e186 = offset;
                    param_2 = (_e183 + _e184) + _e186;
                    metal::float2 _e188 = hash22(param_2);
                    metal::float2 _e191 = f;
                    r = ((_e180 + metal::float2(0.1)) + (_e188 * 0.8)) - _e191;
                    metal::float2 _e193 = r;
                    metal::float2 _e194 = r;
                    d = metal::dot(_e193, _e194);
                    float _e196 = d;
                    float _e197 = md;
                    if (_e196 < _e197) {
                        float _e199 = d;
                        md = _e199;
                        metal::float2 _e200 = r;
                        mr = _e200;
                        metal::float2 _e201 = g;
                        mg = _e201;
                    }
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
    edge = 8.0;
    normal = metal::float2(0.0, 0.0);
    y_1 = -2;
    uint2 loop_bound_2 = uint2(4294967295u);
    bool loop_init_2 = true;
    while(true) {
        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
        if (!loop_init_2) {
            int _e262 = y_1;
            y_1 = as_type<int>(as_type<uint>(_e262) + as_type<uint>(1));
        }
        loop_init_2 = false;
        int _e206 = y_1;
        if (_e206 <= 2) {
            x_1 = -2;
            uint2 loop_bound_3 = uint2(4294967295u);
            bool loop_init_3 = true;
            while(true) {
                if (metal::all(loop_bound_3 == uint2(0u))) { break; }
                loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
                if (!loop_init_3) {
                    int _e260 = x_1;
                    x_1 = as_type<int>(as_type<uint>(_e260) + as_type<uint>(1));
                }
                loop_init_3 = false;
                int _e208 = x_1;
                if (_e208 <= 2) {
                    metal::float2 _e210 = mg;
                    int _e211 = x_1;
                    int _e213 = y_1;
                    g_1 = _e210 + metal::float2(static_cast<float>(_e211), static_cast<float>(_e213));
                    metal::float2 _e217 = g_1;
                    metal::float2 _e220 = i;
                    metal::float2 _e221 = g_1;
                    metal::float2 _e223 = offset;
                    param_3 = (_e220 + _e221) + _e223;
                    metal::float2 _e225 = hash22(param_3);
                    metal::float2 _e228 = f;
                    r_1 = ((_e217 + metal::float2(0.1)) + (_e225 * 0.8)) - _e228;
                    metal::float2 _e230 = r_1;
                    metal::float2 _e231 = mr;
                    dr = _e230 - _e231;
                    metal::float2 _e233 = dr;
                    metal::float2 _e234 = dr;
                    if (metal::dot(_e233, _e234) > 0.00001) {
                        metal::float2 _e237 = dr;
                        dn = metal::normalize(_e237);
                        metal::float2 _e239 = mr;
                        metal::float2 _e240 = r_1;
                        metal::float2 _e243 = dn;
                        e = metal::dot((_e239 + _e240) * 0.5, _e243);
                        float _e245 = edge;
                        float _e246 = e;
                        edge = metal::min(_e245, _e246);
                        float _e248 = e;
                        float _e249 = bw;
                        w = metal::max(1.0 - (_e248 / _e249), 0.0);
                        metal::float2 _e253 = dn;
                        float _e254 = w;
                        float _e256 = w;
                        metal::float2 _e258 = normal;
                        normal = _e258 + ((_e253 * _e254) * _e256);
                    }
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
    metal::float2 _e264 = normal;
    nl = metal::length(_e264);
    float _e266 = nl;
    if (_e266 > 0.0) {
        metal::float2 _e268 = normal;
        float _e269 = nl;
        local = _e268 / metal::float2(_e269);
    } else {
        local = metal::float2(0.0, 0.0);
    }
    metal::float2 _e272 = local;
    normal = _e272;
    metal::float2 _e273 = i;
    metal::float2 _e274 = mg;
    metal::float2 _e276 = offset;
    id = (_e273 + _e274) + _e276;
    metal::float2 _e278 = id;
    param_4 = _e278 + metal::float2(31.7);
    metal::float2 _e281 = hash22(param_4);
    h1_ = _e281;
    metal::float2 _e282 = id;
    param_5 = _e282 + metal::float2(59.3);
    metal::float2 _e285 = hash22(param_5);
    h2_ = _e285;
    metal::float2 _e286 = id;
    param_6 = _e286 + metal::float2(97.1);
    metal::float2 _e289 = hash22(param_6);
    h3_ = _e289;
    float _e291 = h1_[0u];
    angle = 6.2831855 * _e291;
    float _e293 = angle;
    float _e295 = angle;
    dir = metal::float2(metal::cos(_e293), metal::sin(_e295));
    metal::float2 _e298 = dir;
    float _e300 = h1_[1u];
    float _e305 = uniforms.refraction;
    shift = (_e298 * (0.4 + (0.6 * _e300))) * _e305;
    float _e308 = h2_[0u];
    float _e312 = uniforms.refraction;
    zoom = ((_e308 - 0.5) * 6.0) * _e312;
    float _e315 = h2_[1u];
    float _e319 = uniforms.refraction;
    tilt = ((_e315 - 0.5) * 2.0) * _e319;
    metal::float2 _e321 = mr;
    float _e323 = n;
    q = -(_e321) / metal::float2(_e323);
    metal::float2 _e326 = q;
    float _e328 = zoom;
    float _e331 = q[1u];
    float _e334 = q[0u];
    float _e336 = tilt;
    metal::float2 _e340 = q;
    float _e341 = tilt;
    view = ((-(_e326) * _e328) + (metal::float2(-(_e331), _e334) * metal::sin(_e336))) + (_e340 * (metal::cos(_e341) - 1.0));
    float _e346 = bw;
    float _e347 = edge;
    bv = 1.0 - metal::smoothstep(0.0, _e346, _e347);
    float _e350 = bv;
    float _e351 = bv;
    bv = _e351 * _e350;
    metal::float2 _e353 = normal;
    float _e354 = bv;
    float _e358 = uniforms.refraction;
    bend = ((_e353 * _e354) * 0.4) * _e358;
    float _e361 = h3_[0u];
    start = 0.15 + (0.5 * _e361);
    float _e364 = start;
    float _e365 = start;
    float _e368 = uniforms.progress;
    m = metal::smoothstep(_e364, _e365 + 0.2, _e368);
    float _e370 = amount;
    metal::float2 _e371 = view;
    metal::float2 _e372 = bend;
    d_1 = (_e371 + _e372) * _e370;
    float _e375 = amount;
    metal::float2 _e376 = shift;
    s = _e376 * _e375;
    metal::float2 _e378 = uv_2;
    metal::float2 _e379 = s;
    metal::float2 _e380 = d_1;
    metal::float2 _e382 = aspect;
    param_7 = _e378 + ((_e379 + _e380) / _e382);
    metal::float2 _e385 = mirror(param_7);
    param_8 = _e385;
    metal::float4 _e386 = getFromColor(param_8, _from, _sampler);
    ca = _e386;
    metal::float2 _e387 = uv_2;
    metal::float2 _e388 = d_1;
    metal::float2 _e389 = s;
    metal::float2 _e391 = aspect;
    param_9 = _e387 + ((_e388 - _e389) / _e391);
    metal::float2 _e394 = mirror(param_9);
    param_10 = _e394;
    metal::float4 _e395 = getToColor(param_10, _sampler, _to);
    cb = _e395;
    metal::float4 _e396 = ca;
    float _e399 = ca[3u];
    metal::float3 _e400 = _e396.xyz * _e399;
    float _e402 = ca[3u];
    metal::float4 _e407 = cb;
    float _e410 = cb[3u];
    metal::float3 _e411 = _e407.xyz * _e410;
    float _e413 = cb[3u];
    float _e418 = m;
    c = metal::mix(metal::float4(_e400.x, _e400.y, _e400.z, _e402), metal::float4(_e411.x, _e411.y, _e411.z, _e413), metal::float4(_e418));
    light = metal::float2(-0.6, 0.8);
    metal::float2 _e421 = dir;
    float _e423 = h1_[1u];
    slope = _e421 * (0.4 + (0.6 * _e423));
    float _e427 = amount;
    metal::float2 _e429 = slope;
    metal::float2 _e430 = light;
    facetLight = (0.12 * _e427) * metal::dot(_e429, _e430);
    metal::float2 _e433 = normal;
    metal::float2 _e434 = light;
    lit = metal::dot(_e433, _e434);
    float _e437 = uniforms.bevel;
    k = metal::clamp(_e437, 0.0, 1.0);
    float _e439 = k;
    float _e440 = bv;
    float _e442 = lit;
    float _e446 = amount;
    glow = (((_e439 * _e440) * metal::max(_e442, 0.0)) * 1.1) * _e446;
    float _e448 = k;
    float _e449 = bv;
    float _e451 = lit;
    float _e456 = amount;
    shade = (((_e448 * _e449) * metal::max(-(_e451), 0.0)) * 0.6) * _e456;
    float _e458 = m;
    turn = metal::sin(3.1415927 * _e458);
    float _e461 = k;
    float _e463 = amount;
    float _e465 = turn;
    float _e467 = turn;
    float _e469 = glow;
    glow = _e469 + ((((_e461 * 0.15) * _e463) * _e465) * _e467);
    float _e471 = amount;
    float _e473 = edge;
    float _e474 = n;
    seam = (0.6 * _e471) * (1.0 - metal::smoothstep(0.0, 0.003, (_e473 / _e474) - 0.00075));
    float _e480 = facetLight;
    float _e482 = shade;
    float _e485 = seam;
    metal::float4 _e488 = c;
    metal::float3 _e490 = _e488.xyz * (((1.0 + _e480) * (1.0 - _e482)) * (1.0 - _e485));
    c[0u] = _e490.x;
    c[1u] = _e490.y;
    c[2u] = _e490.z;
    metal::float4 _e498 = uniforms.highlight;
    float _e502 = uniforms.highlight[3u];
    float _e504 = glow;
    float _e507 = c[3u];
    metal::float4 _e509 = c;
    metal::float3 _e511 = _e509.xyz + (((_e498.xyz * _e502) * _e504) * _e507);
    c[0u] = _e511.x;
    c[1u] = _e511.y;
    c[2u] = _e511.z;
    float _e519 = c[3u];
    if (_e519 > 0.0) {
        metal::float4 _e521 = c;
        float _e524 = c[3u];
        metal::float3 _e529 = metal::clamp(_e521.xyz / metal::float3(_e524), metal::float3(0.0), metal::float3(1.0));
        float _e531 = c[3u];
        local_1 = metal::float4(_e529.x, _e529.y, _e529.z, _e531);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e536 = local_1;
    return _e536;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_11 = {};
    metal::float2 _e57 = _uv_1;
    param_11 = _e57;
    metal::float4 _e58 = transition(param_11, _from, _sampler, _to, uniforms);
    _fragColor = _e58;
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
