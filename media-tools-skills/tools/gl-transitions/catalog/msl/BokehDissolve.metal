// BokehDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BokehDissolve.glsl
// Author: gre
// License: MIT
// Description: The image falls out of focus like a camera lens, its highlights swelling into large bright bokeh discs, and the incoming image sharpens back out of its own bokeh
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float radius;
    int blades;
    float threshold;
    float intensity;
};

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e40 = v;
    metal::float2 _e41 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e40 - (metal::floor(_e40 / _e41) * _e41)));
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e41 = uv[0u];
    float _e43 = uv[1u];
    metal::float4 _e46 = _to.sample(_sampler, metal::float2(_e41, 1.0 - _e43), metal::level(0.0));
    return _e46;
}

float highlight(
    thread metal::float4& c,
    thread float& t
) {
    float lum = {};
    float h = {};
    metal::float4 _e43 = c;
    lum = metal::dot(_e43.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    float _e46 = t;
    if (_e46 >= 1.0) {
        return 0.0;
    }
    float _e48 = t;
    float _e49 = lum;
    h = metal::smoothstep(_e48, 1.0, _e49);
    float _e51 = h;
    float _e52 = h;
    float _e55 = c[3u];
    return (_e51 * _e52) * _e55;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e41 = uv_1[0u];
    float _e43 = uv_1[1u];
    metal::float4 _e46 = _from.sample(_sampler, metal::float2(_e41, 1.0 - _e43), metal::level(0.0));
    return _e46;
}

float hash12(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e41 = p;
    p3_ = metal::fract(_e41.xyx * 0.1031);
    metal::float3 _e45 = p3_;
    metal::float3 _e46 = p3_;
    metal::float3 _e51 = p3_;
    p3_ = _e51 + metal::float3(metal::dot(_e45, _e46.yzx + metal::float3(33.33)));
    float _e55 = p3_[0u];
    float _e57 = p3_[1u];
    float _e60 = p3_[2u];
    return metal::fract((_e55 + _e57) * _e60);
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float t_1 = {};
    float k = {};
    float w = {};
    float r = {};
    float boost = {};
    float n = {};
    float local = {};
    float sector = {};
    float local_1 = {};
    float apothem = {};
    metal::float2 cell = {};
    float spin = {};
    metal::float2 param = {};
    float jitter = {};
    metal::float2 param_1 = {};
    bool useFrom = {};
    bool useTo = {};
    metal::float4 s0_ = {};
    metal::float4 s1_ = {};
    float t0_ = {};
    float t1_ = {};
    metal::float3 l0_ = {};
    metal::float3 l1_ = {};
    metal::float4 c_1 = {};
    metal::float2 param_2 = {};
    float h_1 = {};
    metal::float4 param_3 = {};
    float param_4 = {};
    float wt = {};
    metal::float4 c_2 = {};
    metal::float2 param_5 = {};
    float h_2 = {};
    metal::float4 param_6 = {};
    float param_7 = {};
    float wt_1 = {};
    int i = {};
    float fi = {};
    float a = {};
    float d = {};
    float s = {};
    metal::float2 st = {};
    metal::float2 param_8 = {};
    metal::float4 c_3 = {};
    metal::float2 param_9 = {};
    float h_3 = {};
    metal::float4 param_10 = {};
    float param_11 = {};
    float wt_2 = {};
    metal::float4 c_4 = {};
    metal::float2 param_12 = {};
    float h_4 = {};
    metal::float4 param_13 = {};
    float param_14 = {};
    float wt_3 = {};
    metal::float4 b = {};
    metal::float4 local_2 = {};
    metal::float4 local_3 = {};
    metal::float3 rgb = {};
    metal::float3 light = {};
    float _e100 = uniforms.progress;
    t_1 = 1.0 - metal::abs((2.0 * _e100) - 1.0);
    float _e105 = t_1;
    float _e106 = t_1;
    float _e108 = t_1;
    k = (_e105 * _e106) * (3.0 - (2.0 * _e108));
    float _e113 = uniforms.progress;
    w = metal::smoothstep(0.35, 0.65, _e113);
    float _e116 = uniforms.radius;
    float _e117 = k;
    r = _e116 * _e117;
    float _e120 = uniforms.intensity;
    float _e122 = k;
    boost = (12.0 * _e120) * _e122;
    int _e125 = uniforms.blades;
    if (_e125 >= 3) {
        int _e128 = uniforms.blades;
        local = static_cast<float>(_e128);
    } else {
        local = 0.0;
    }
    float _e130 = local;
    n = _e130;
    float _e131 = n;
    if (_e131 > 0.0) {
        float _e133 = n;
        local_1 = 6.2831855 / _e133;
    } else {
        local_1 = 1.0;
    }
    float _e135 = local_1;
    sector = _e135;
    float _e136 = sector;
    apothem = metal::cos(0.5 * _e136);
    metal::float2 _e139 = uv_2;
    float _e141 = uniforms.ratio;
    cell = metal::floor((_e139 * metal::float2(_e141, 1.0)) * 997.0);
    metal::float2 _e146 = cell;
    param = _e146;
    float _e147 = hash12(param);
    spin = 6.2831855 * _e147;
    metal::float2 _e149 = cell;
    param_1 = _e149 + metal::float2(17.0);
    float _e152 = hash12(param_1);
    jitter = _e152;
    float _e153 = w;
    useFrom = _e153 < 1.0;
    float _e155 = w;
    useTo = _e155 > 0.0;
    s0_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    s1_ = metal::float4(0.0, 0.0, 0.0, 0.0);
    t0_ = 0.0;
    t1_ = 0.0;
    l0_ = metal::float3(0.0, 0.0, 0.0);
    l1_ = metal::float3(0.0, 0.0, 0.0);
    bool _e157 = useFrom;
    if (_e157) {
        metal::float2 _e158 = uv_2;
        param_2 = _e158;
        metal::float4 _e159 = getFromColor(param_2, _from, _sampler);
        c_1 = _e159;
        metal::float4 _e160 = c_1;
        param_3 = _e160;
        float _e162 = uniforms.threshold;
        param_4 = _e162;
        float _e163 = highlight(param_3, param_4);
        h_1 = _e163;
        float _e164 = boost;
        float _e165 = h_1;
        wt = 1.0 + (_e164 * _e165);
        float _e168 = wt;
        metal::float4 _e169 = c_1;
        float _e172 = c_1[3u];
        metal::float3 _e173 = _e169.xyz * _e172;
        float _e175 = c_1[3u];
        s0_ = metal::float4(_e173.x, _e173.y, _e173.z, _e175) * _e168;
        float _e181 = wt;
        t0_ = _e181;
        float _e182 = h_1;
        metal::float4 _e183 = c_1;
        l0_ = _e183.xyz * _e182;
    }
    bool _e186 = useTo;
    if (_e186) {
        metal::float2 _e187 = uv_2;
        param_5 = _e187;
        metal::float4 _e188 = getToColor(param_5, _sampler, _to);
        c_2 = _e188;
        metal::float4 _e189 = c_2;
        param_6 = _e189;
        float _e191 = uniforms.threshold;
        param_7 = _e191;
        float _e192 = highlight(param_6, param_7);
        h_2 = _e192;
        float _e193 = boost;
        float _e194 = h_2;
        wt_1 = 1.0 + (_e193 * _e194);
        float _e197 = wt_1;
        metal::float4 _e198 = c_2;
        float _e201 = c_2[3u];
        metal::float3 _e202 = _e198.xyz * _e201;
        float _e204 = c_2[3u];
        s1_ = metal::float4(_e202.x, _e202.y, _e202.z, _e204) * _e197;
        float _e210 = wt_1;
        t1_ = _e210;
        float _e211 = h_2;
        metal::float4 _e212 = c_2;
        l1_ = _e212.xyz * _e211;
    }
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e330 = i;
            i = as_type<int>(as_type<uint>(_e330) + as_type<uint>(1));
        }
        loop_init = false;
        int _e215 = i;
        if (_e215 < 16) {
            int _e217 = i;
            fi = static_cast<float>(_e217);
            float _e219 = fi;
            float _e221 = spin;
            a = (_e219 * 2.3999631) + _e221;
            float _e223 = fi;
            float _e224 = jitter;
            d = metal::sqrt((_e223 + _e224) / 16.0);
            float _e228 = n;
            if (_e228 > 0.0) {
                float _e230 = a;
                float _e231 = sector;
                float _e236 = sector;
                s = (_e230 - (metal::floor(_e230 / _e231) * _e231)) - (0.5 * _e236);
                float _e239 = apothem;
                float _e240 = s;
                float _e243 = d;
                d = _e243 * (_e239 / metal::cos(_e240));
            }
            metal::float2 _e245 = uv_2;
            float _e246 = r;
            float _e247 = d;
            float _e249 = a;
            float _e252 = uniforms.ratio;
            float _e254 = a;
            param_8 = _e245 + (metal::float2(metal::cos(_e249) / _e252, metal::sin(_e254)) * (_e246 * _e247));
            metal::float2 _e259 = mirror(param_8);
            st = _e259;
            bool _e260 = useFrom;
            if (_e260) {
                metal::float2 _e261 = st;
                param_9 = _e261;
                metal::float4 _e262 = getFromColor(param_9, _from, _sampler);
                c_3 = _e262;
                metal::float4 _e263 = c_3;
                param_10 = _e263;
                float _e265 = uniforms.threshold;
                param_11 = _e265;
                float _e266 = highlight(param_10, param_11);
                h_3 = _e266;
                float _e267 = boost;
                float _e268 = h_3;
                wt_2 = 1.0 + (_e267 * _e268);
                float _e271 = wt_2;
                metal::float4 _e272 = c_3;
                float _e275 = c_3[3u];
                metal::float3 _e276 = _e272.xyz * _e275;
                float _e278 = c_3[3u];
                metal::float4 _e284 = s0_;
                s0_ = _e284 + (metal::float4(_e276.x, _e276.y, _e276.z, _e278) * _e271);
                float _e286 = wt_2;
                float _e287 = t0_;
                t0_ = _e287 + _e286;
                float _e289 = h_3;
                metal::float4 _e290 = c_3;
                metal::float3 _e293 = l0_;
                l0_ = _e293 + (_e290.xyz * _e289);
            }
            bool _e295 = useTo;
            if (_e295) {
                metal::float2 _e296 = st;
                param_12 = _e296;
                metal::float4 _e297 = getToColor(param_12, _sampler, _to);
                c_4 = _e297;
                metal::float4 _e298 = c_4;
                param_13 = _e298;
                float _e300 = uniforms.threshold;
                param_14 = _e300;
                float _e301 = highlight(param_13, param_14);
                h_4 = _e301;
                float _e302 = boost;
                float _e303 = h_4;
                wt_3 = 1.0 + (_e302 * _e303);
                float _e306 = wt_3;
                metal::float4 _e307 = c_4;
                float _e310 = c_4[3u];
                metal::float3 _e311 = _e307.xyz * _e310;
                float _e313 = c_4[3u];
                metal::float4 _e319 = s1_;
                s1_ = _e319 + (metal::float4(_e311.x, _e311.y, _e311.z, _e313) * _e306);
                float _e321 = wt_3;
                float _e322 = t1_;
                t1_ = _e322 + _e321;
                float _e324 = h_4;
                metal::float4 _e325 = c_4;
                metal::float3 _e328 = l1_;
                l1_ = _e328 + (_e325.xyz * _e324);
            }
            continue;
        } else {
            break;
        }
    }
    bool _e332 = useFrom;
    if (_e332) {
        metal::float4 _e333 = s0_;
        float _e334 = t0_;
        local_2 = _e333 / metal::float4(_e334);
    } else {
        local_2 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e337 = local_2;
    bool _e338 = useTo;
    if (_e338) {
        metal::float4 _e339 = s1_;
        float _e340 = t1_;
        local_3 = _e339 / metal::float4(_e340);
    } else {
        local_3 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e343 = local_3;
    float _e344 = w;
    b = metal::mix(_e337, _e343, metal::float4(_e344));
    float _e348 = b[3u];
    if (_e348 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e350 = b;
    float _e353 = b[3u];
    rgb = _e350.xyz / metal::float3(_e353);
    metal::float3 _e356 = l0_;
    metal::float3 _e357 = l1_;
    float _e358 = w;
    float _e362 = uniforms.intensity;
    float _e363 = k;
    light = metal::mix(_e356, _e357, metal::float3(_e358)) * (((_e362 * _e363) * 4.0) / 17.0);
    metal::float3 _e368 = rgb;
    metal::float3 _e374 = light;
    rgb = metal::float3(1.0) - ((metal::float3(1.0) - metal::clamp(_e368, metal::float3(0.0), metal::float3(1.0))) * metal::exp(-(_e374)));
    metal::float3 _e380 = rgb;
    float _e382 = b[3u];
    return metal::float4(_e380.x, _e380.y, _e380.z, _e382);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_15 = {};
    metal::float2 _e40 = _uv_1;
    param_15 = _e40;
    metal::float4 _e41 = transition(param_15, _from, _sampler, _to, uniforms);
    _fragColor = _e41;
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
