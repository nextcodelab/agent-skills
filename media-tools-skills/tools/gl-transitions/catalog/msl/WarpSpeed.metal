// WarpSpeed — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/WarpSpeed.glsl
// Author: gre
// License: MIT
// Description: The camera jumps to light speed: star streaks shoot out from the center and stretch longer and longer while the outgoing image is pulled into a radial smear, then after a flash the incoming image emerges from the center as the streaks shrink back
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::float2 center;
    float streaks;
    char _pad4[12];
    metal::float4 streakColor;
    float strength;
    float flash;
    char _pad7[8];
};

float hash(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e65 = p;
    p3_ = metal::fract(_e65.xyx * 0.1031);
    metal::float3 _e69 = p3_;
    metal::float3 _e70 = p3_;
    metal::float3 _e75 = p3_;
    p3_ = _e75 + metal::float3(metal::dot(_e69, _e70.yzx + metal::float3(33.33)));
    float _e79 = p3_[0u];
    float _e81 = p3_[1u];
    float _e84 = p3_[2u];
    return metal::fract((_e79 + _e81) * _e84);
}

float stars(
    thread float& a,
    thread float& r,
    thread float& n,
    thread float& layer,
    thread float& travel,
    thread float& speed,
    thread float& reach
) {
    float cell = {};
    float h1_ = {};
    metal::float2 param = {};
    float h2_ = {};
    metal::float2 param_1 = {};
    float h3_ = {};
    metal::float2 param_2 = {};
    float life = {};
    float head = {};
    float tail = {};
    float along = {};
    float inside = {};
    float profile = {};
    float f = {};
    float cellWidth = {};
    float offset = {};
    float across = {};
    float width = {};
    float x = {};
    float line = {};
    float fade = {};
    metal::float2 param_3 = {};
    float _e92 = a;
    float _e93 = n;
    cell = metal::floor(_e92 * _e93);
    float _e96 = cell;
    float _e97 = layer;
    param = metal::float2(_e96, _e97);
    float _e99 = hash(param);
    h1_ = _e99;
    float _e100 = cell;
    float _e101 = layer;
    param_1 = metal::float2(_e100, _e101 + 17.0);
    float _e104 = hash(param_1);
    h2_ = _e104;
    float _e105 = cell;
    float _e106 = layer;
    param_2 = metal::float2(_e105, _e106 + 31.0);
    float _e109 = hash(param_2);
    h3_ = _e109;
    float _e110 = h1_;
    float _e111 = travel;
    float _e112 = h2_;
    life = metal::fract(_e110 + (_e111 * (0.6 + (0.8 * _e112))));
    float _e118 = reach;
    float _e119 = life;
    head = _e118 * (0.05 + (1.05 * metal::pow(_e119, 1.4)));
    float _e124 = head;
    float _e125 = speed;
    float _e126 = h3_;
    tail = _e124 * (1.0 - metal::min(0.9, _e125 * (0.15 + (0.5 * _e126))));
    float _e133 = r;
    float _e134 = tail;
    float _e136 = head;
    float _e137 = tail;
    along = metal::clamp((_e133 - _e134) / metal::max(_e136 - _e137, 0.0001), 0.0, 1.0);
    float _e142 = tail;
    float _e143 = r;
    float _e145 = head;
    float _e147 = head;
    float _e148 = r;
    inside = metal::step(_e142, _e143) * (1.0 - metal::smoothstep(_e145 - 0.006, _e147, _e148));
    float _e152 = inside;
    float _e153 = along;
    float _e155 = along;
    profile = (_e152 * _e153) * _e155;
    float _e157 = a;
    float _e158 = n;
    f = metal::fract(_e157 * _e158);
    float _e161 = r;
    float _e163 = n;
    cellWidth = (6.2831855 * _e161) / _e163;
    float _e165 = h3_;
    offset = 0.3 + (0.4 * _e165);
    float _e168 = f;
    float _e169 = offset;
    float _e171 = cellWidth;
    across = (_e168 - _e169) * _e171;
    float _e173 = r;
    float _e175 = reach;
    float _e178 = cellWidth;
    width = metal::min(0.0014 + ((0.002 * _e173) / _e175), 0.15 * _e178);
    float _e181 = across;
    float _e182 = across;
    float _e184 = width;
    float _e185 = width;
    x = (_e181 * _e182) / (_e184 * _e185);
    float _e188 = x;
    float _e191 = x;
    float _e197 = f;
    float _e198 = f;
    line = (metal::exp(-(_e188)) + (0.25 * metal::exp(-(_e191) / 9.0))) * metal::smoothstep(0.0, 0.2, metal::min(_e197, 1.0 - _e198));
    float _e203 = life;
    float _e205 = life;
    fade = metal::smoothstep(0.0, 0.2, _e203) * (1.0 - metal::smoothstep(0.9, 1.0, _e205));
    float _e209 = profile;
    float _e210 = line;
    float _e212 = fade;
    float _e214 = h2_;
    float _e218 = cell;
    float _e219 = layer;
    param_3 = metal::float2(_e218, _e219 + 43.0);
    float _e222 = hash(param_3);
    return (((_e209 * _e210) * _e212) * (0.4 + (0.6 * _e214))) * metal::step(0.25, _e222);
}

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e65 = uv[0u];
    float _e67 = uv[1u];
    metal::float4 _e70 = _from.sample(_sampler, metal::float2(_e65, 1.0 - _e67), metal::level(0.0));
    return _e70;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e65 = uv_1[0u];
    float _e67 = uv_1[1u];
    metal::float4 _e70 = _to.sample(_sampler, metal::float2(_e65, 1.0 - _e67), metal::level(0.0));
    return _e70;
}

metal::float4 smear(
    thread metal::float2& uv_2,
    thread float& k,
    thread float& b,
    thread float& jitter,
    thread bool& incoming,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 c = {};
    metal::float4 local = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float4 sum = {};
    int i = {};
    float s = {};
    metal::float2 q = {};
    metal::float4 c_1 = {};
    metal::float4 local_1 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    float _e80 = b;
    float _e82 = k;
    if ((_e80 <= 0.0) && (_e82 >= 1.0)) {
        bool _e85 = incoming;
        if (_e85) {
            metal::float2 _e86 = uv_2;
            param_4 = _e86;
            metal::float4 _e87 = getToColor(param_4, _sampler, _to);
            local = _e87;
        } else {
            metal::float2 _e88 = uv_2;
            param_5 = _e88;
            metal::float4 _e89 = getFromColor(param_5, _from, _sampler);
            local = _e89;
        }
        metal::float4 _e90 = local;
        c = _e90;
        metal::float4 _e91 = c;
        float _e94 = c[3u];
        metal::float3 _e95 = _e91.xyz * _e94;
        float _e97 = c[3u];
        return metal::float4(_e95.x, _e95.y, _e95.z, _e97);
    }
    sum = metal::float4(0.0, 0.0, 0.0, 0.0);
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e142 = i;
            i = as_type<int>(as_type<uint>(_e142) + as_type<uint>(1));
        }
        loop_init = false;
        int _e102 = i;
        if (_e102 < 12) {
            float _e104 = k;
            float _e105 = b;
            int _e106 = i;
            float _e108 = jitter;
            s = _e104 * (1.0 - ((_e105 * (static_cast<float>(_e106) + _e108)) / 12.0));
            metal::float2 _e115 = uniforms.center;
            metal::float2 _e116 = uv_2;
            metal::float2 _e118 = uniforms.center;
            float _e120 = s;
            q = _e115 + ((_e116 - _e118) * _e120);
            bool _e123 = incoming;
            if (_e123) {
                metal::float2 _e124 = q;
                param_6 = _e124;
                metal::float4 _e125 = getToColor(param_6, _sampler, _to);
                local_1 = _e125;
            } else {
                metal::float2 _e126 = q;
                param_7 = _e126;
                metal::float4 _e127 = getFromColor(param_7, _from, _sampler);
                local_1 = _e127;
            }
            metal::float4 _e128 = local_1;
            c_1 = _e128;
            metal::float4 _e129 = c_1;
            float _e132 = c_1[3u];
            metal::float3 _e133 = _e129.xyz * _e132;
            float _e135 = c_1[3u];
            metal::float4 _e140 = sum;
            sum = _e140 + metal::float4(_e133.x, _e133.y, _e133.z, _e135);
            continue;
        } else {
            break;
        }
    }
    metal::float4 _e144 = sum;
    return _e144 / metal::float4(12.0);
}

metal::float4 transition(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p_1 = {};
    metal::float2 aspect = {};
    metal::float2 d = {};
    float r_1 = {};
    float a_1 = {};
    metal::float2 far = {};
    float reach_1 = {};
    float speed_1 = {};
    float travel_1 = {};
    float jitter_1 = {};
    metal::float2 param_8 = {};
    float goOut = {};
    float goIn = {};
    float soft = {};
    float edge = {};
    float m = {};
    metal::float4 before = {};
    metal::float4 after = {};
    metal::float2 param_9 = {};
    float param_10 = {};
    float param_11 = {};
    float param_12 = {};
    bool param_13 = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    float param_16 = {};
    float param_17 = {};
    bool param_18 = {};
    metal::float4 c_2 = {};
    float dark = {};
    float local_2 = {};
    float n_1 = {};
    float len = {};
    float s_1 = {};
    float param_19 = {};
    float param_20 = {};
    float param_21 = {};
    float param_22 = {};
    float param_23 = {};
    float param_24 = {};
    float param_25 = {};
    float param_26 = {};
    float param_27 = {};
    float param_28 = {};
    float param_29 = {};
    float param_30 = {};
    float param_31 = {};
    float param_32 = {};
    float core = {};
    float peak = {};
    float glow = {};
    metal::float3 light = {};
    metal::float4 local_3 = {};
    float _e118 = uniforms.progress;
    p_1 = _e118;
    float _e120 = uniforms.ratio;
    aspect = metal::float2(_e120, 1.0);
    metal::float2 _e122 = uv_3;
    metal::float2 _e124 = uniforms.center;
    metal::float2 _e126 = aspect;
    d = (_e122 - _e124) * _e126;
    metal::float2 _e128 = d;
    r_1 = metal::length(_e128);
    float _e131 = d[1u];
    float _e133 = d[0u];
    a_1 = (metal::atan2(_e131, _e133 + 0.000001) / 6.2831855) + 0.5;
    metal::float2 _e139 = uniforms.center;
    metal::float2 _e141 = uniforms.center;
    metal::float2 _e145 = aspect;
    far = metal::max(_e139, metal::float2(1.0) - _e141) * _e145;
    metal::float2 _e147 = far;
    reach_1 = metal::length(_e147);
    float _e149 = p_1;
    speed_1 = metal::sin(3.1415927 * _e149);
    float _e152 = speed_1;
    float _e153 = speed_1;
    speed_1 = _e153 * _e152;
    float _e155 = p_1;
    float _e156 = p_1;
    travel_1 = 3.0 * (_e155 - (metal::sin(6.2831855 * _e156) / 6.2831855));
    metal::float2 _e162 = uv_3;
    metal::float2 _e163 = aspect;
    param_8 = metal::floor((_e162 * _e163) * 997.0);
    float _e167 = hash(param_8);
    jitter_1 = _e167;
    float _e168 = p_1;
    goOut = metal::smoothstep(0.0, 0.55, _e168);
    float _e170 = p_1;
    goIn = 1.0 - metal::smoothstep(0.45, 1.0, _e170);
    float _e173 = reach_1;
    soft = 0.35 * _e173;
    float _e175 = soft;
    float _e177 = reach_1;
    float _e178 = soft;
    float _e180 = p_1;
    edge = metal::mix(-(_e175), _e177 + _e178, metal::smoothstep(0.42, 0.78, _e180));
    float _e183 = edge;
    float _e184 = soft;
    float _e186 = edge;
    float _e187 = r_1;
    m = 1.0 - metal::smoothstep(_e183 - _e184, _e186, _e187);
    before = metal::float4(0.0, 0.0, 0.0, 0.0);
    after = metal::float4(0.0, 0.0, 0.0, 0.0);
    float _e190 = m;
    if (_e190 < 1.0) {
        float _e193 = uniforms.strength;
        float _e195 = goOut;
        float _e197 = goOut;
        float _e201 = uniforms.strength;
        float _e203 = goOut;
        metal::float2 _e205 = uv_3;
        param_9 = _e205;
        param_10 = 1.0 - (((0.3 * _e193) * _e195) * _e197);
        param_11 = (0.6 * _e201) * _e203;
        float _e206 = jitter_1;
        param_12 = _e206;
        param_13 = false;
        metal::float4 _e207 = smear(param_9, param_10, param_11, param_12, param_13, _from, _sampler, _to, uniforms);
        before = _e207;
    }
    float _e208 = m;
    if (_e208 > 0.0) {
        float _e211 = uniforms.strength;
        float _e213 = goIn;
        float _e215 = goIn;
        float _e219 = uniforms.strength;
        float _e221 = goIn;
        metal::float2 _e223 = uv_3;
        param_14 = _e223;
        param_15 = 1.0 - (((0.3 * _e211) * _e213) * _e215);
        param_16 = (0.6 * _e219) * _e221;
        float _e224 = jitter_1;
        param_17 = _e224;
        param_18 = true;
        metal::float4 _e225 = smear(param_14, param_15, param_16, param_17, param_18, _from, _sampler, _to, uniforms);
        after = _e225;
    }
    metal::float4 _e226 = before;
    metal::float4 _e227 = after;
    float _e228 = m;
    c_2 = metal::mix(_e226, _e227, metal::float4(_e228));
    float _e231 = p_1;
    if (_e231 < 0.5) {
        float _e233 = speed_1;
        local_2 = _e233;
    } else {
        float _e234 = speed_1;
        float _e235 = speed_1;
        float _e237 = speed_1;
        local_2 = (_e234 * _e235) * _e237;
    }
    float _e239 = local_2;
    dark = _e239;
    float _e241 = uniforms.strength;
    float _e245 = dark;
    metal::float4 _e248 = c_2;
    metal::float3 _e250 = _e248.xyz * (1.0 - ((0.65 * (0.5 + (0.5 * _e241))) * _e245));
    c_2[0u] = _e250.x;
    c_2[1u] = _e250.y;
    c_2[2u] = _e250.z;
    float _e258 = uniforms.streaks;
    n_1 = metal::max(metal::floor(_e258), 1.0);
    float _e261 = speed_1;
    float _e263 = uniforms.strength;
    len = _e261 * (0.5 + (1.5 * _e263));
    float _e267 = a_1;
    param_19 = _e267;
    float _e268 = r_1;
    param_20 = _e268;
    float _e269 = n_1;
    param_21 = _e269;
    param_22 = 1.0;
    float _e270 = travel_1;
    param_23 = _e270;
    float _e271 = len;
    param_24 = _e271;
    float _e272 = reach_1;
    param_25 = _e272;
    float _e273 = stars(param_19, param_20, param_21, param_22, param_23, param_24, param_25);
    s_1 = _e273;
    float _e274 = a_1;
    float _e277 = n_1;
    float _e281 = travel_1;
    param_26 = metal::fract(_e274 + 0.37);
    float _e283 = r_1;
    param_27 = _e283;
    param_28 = metal::max(metal::floor(_e277 * 0.71), 1.0);
    param_29 = 2.0;
    param_30 = _e281 * 1.3;
    float _e284 = len;
    param_31 = _e284;
    float _e285 = reach_1;
    param_32 = _e285;
    float _e286 = stars(param_26, param_27, param_28, param_29, param_30, param_31, param_32);
    float _e287 = s_1;
    s_1 = _e287 + _e286;
    float _e289 = r_1;
    float _e290 = reach_1;
    core = _e289 / (0.35 * _e290);
    float _e293 = p_1;
    peak = (_e293 - 0.5) * 9.0;
    float _e297 = uniforms.flash;
    float _e298 = peak;
    float _e300 = peak;
    float _e304 = speed_1;
    float _e306 = core;
    float _e308 = core;
    glow = ((_e297 * metal::exp(-(_e298) * _e300)) * _e304) * (0.35 + (0.9 * metal::exp(-(_e306) * _e308)));
    metal::float4 _e315 = uniforms.streakColor;
    float _e319 = uniforms.streakColor[3u];
    float _e321 = s_1;
    float _e323 = speed_1;
    float _e325 = glow;
    light = (_e315.xyz * _e319) * (((2.2 * _e321) * _e323) + _e325);
    float _e329 = c_2[3u];
    if (_e329 > 0.0) {
        metal::float4 _e331 = c_2;
        float _e334 = c_2[3u];
        metal::float3 _e337 = light;
        metal::float3 _e341 = metal::clamp((_e331.xyz / metal::float3(_e334)) + _e337, metal::float3(0.0), metal::float3(1.0));
        float _e343 = c_2[3u];
        local_3 = metal::float4(_e341.x, _e341.y, _e341.z, _e343);
    } else {
        local_3 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e348 = local_3;
    return _e348;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_33 = {};
    metal::float2 _e64 = _uv_1;
    param_33 = _e64;
    metal::float4 _e65 = transition(param_33, _from, _sampler, _to, uniforms);
    _fragColor = _e65;
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
