// SlotReels — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SlotReels.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into vertical reels that spin downward like drums, motion-blurred with speed, carrying the outgoing image then the incoming one, and stop one after another from left to right with a small mechanical bounce
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    int reels;
    float blur;
    float stagger;
    float bounce;
    char _pad6[8];
    metal::float4 separator;
};

metal::float4 getFromColor(
    thread metal::float2& uv,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e54 = uv[0u];
    float _e56 = uv[1u];
    metal::float4 _e59 = _from.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

metal::float4 getToColor(
    thread metal::float2& uv_1,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e54 = uv_1[0u];
    float _e56 = uv_1[1u];
    metal::float4 _e59 = _to.sample(_sampler, metal::float2(_e54, 1.0 - _e56), metal::level(0.0));
    return _e59;
}

float reelSpeed(
    thread float& t,
    thread float& stopT,
    thread float& turns,
    constant Uniforms& uniforms
) {
    float amp = {};
    float v1_ = {};
    float u = {};
    float b = {};
    float _e60 = uniforms.bounce;
    amp = 0.07 * _e60;
    float _e62 = amp;
    float _e64 = stopT;
    float _e66 = turns;
    v1_ = ((_e62 * 3.1415927) * _e64) / (_e66 * 0.1);
    float _e69 = t;
    float _e70 = stopT;
    if (_e69 < _e70) {
        float _e72 = t;
        float _e73 = stopT;
        u = metal::max(_e72 / _e73, 0.0);
        float _e76 = turns;
        float _e77 = u;
        float _e79 = u;
        float _e82 = v1_;
        float _e83 = u;
        float _e85 = u;
        float _e91 = stopT;
        return (_e76 * (((6.0 * _e77) * (1.0 - _e79)) + ((_e82 * _e83) * ((3.0 * _e85) - 2.0)))) / _e91;
    }
    float _e93 = t;
    float _e94 = stopT;
    b = metal::min((_e93 - _e94) / 0.1, 1.0);
    float _e98 = amp;
    float _e99 = b;
    float _e102 = b;
    float _e106 = b;
    float _e109 = b;
    return ((_e98 * (1.0 - _e99)) * (((3.1415927 * metal::cos(3.1415927 * _e102)) * (1.0 - _e106)) - (2.0 * metal::sin(3.1415927 * _e109)))) / 0.1;
}

float reelOffset(
    thread float& t_1,
    thread float& stopT_1,
    thread float& turns_1,
    constant Uniforms& uniforms
) {
    float amp_1 = {};
    float v1_1 = {};
    float u_1 = {};
    float g = {};
    float b_1 = {};
    float _e61 = uniforms.bounce;
    amp_1 = 0.07 * _e61;
    float _e63 = amp_1;
    float _e65 = stopT_1;
    float _e67 = turns_1;
    v1_1 = ((_e63 * 3.1415927) * _e65) / (_e67 * 0.1);
    float _e70 = t_1;
    float _e71 = stopT_1;
    u_1 = metal::clamp(_e70 / _e71, 0.0, 1.0);
    float _e74 = u_1;
    float _e75 = u_1;
    float _e77 = u_1;
    float _e81 = v1_1;
    float _e82 = u_1;
    float _e83 = u_1;
    float _e85 = u_1;
    float _e87 = u_1;
    float _e88 = u_1;
    g = ((_e74 * _e75) * (3.0 - (2.0 * _e77))) + (_e81 * (((_e82 * _e83) * _e85) - (_e87 * _e88)));
    float _e93 = t_1;
    float _e94 = stopT_1;
    b_1 = metal::clamp((_e93 - _e94) / 0.1, 0.0, 1.0);
    float _e98 = turns_1;
    float _e99 = g;
    float _e101 = amp_1;
    float _e102 = b_1;
    float _e106 = b_1;
    float _e109 = b_1;
    return (_e98 * _e99) + (((_e101 * metal::sin(3.1415927 * _e102)) * (1.0 - _e106)) * (1.0 - _e109));
}

float stopTime(
    thread float& i,
    thread float& n,
    constant Uniforms& uniforms
) {
    float order = {};
    float local = {};
    float _e56 = n;
    if (_e56 > 1.0) {
        float _e58 = i;
        float _e59 = n;
        local = _e58 / (_e59 - 1.0);
    } else {
        local = 1.0;
    }
    float _e62 = local;
    order = _e62;
    float _e64 = uniforms.stagger;
    float _e66 = order;
    return 0.9 * (1.0 - (metal::clamp(_e64, 0.0, 0.9) * (1.0 - _e66)));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float n_1 = {};
    float i_1 = {};
    float lx = {};
    float stopT_2 = {};
    float param = {};
    float param_1 = {};
    float turns_2 = {};
    float drum = {};
    float y = {};
    float theta = {};
    float v = {};
    float depth = {};
    float px = {};
    float off = {};
    float param_2 = {};
    float param_3 = {};
    float param_4 = {};
    float speed = {};
    float param_5 = {};
    float param_6 = {};
    float param_7 = {};
    float spread = {};
    metal::float4 c = {};
    float wsum = {};
    int k = {};
    float f = {};
    float w = {};
    float vv = {};
    float seg = {};
    metal::float2 q = {};
    metal::float4 s = {};
    metal::float4 local_1 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    float facing = {};
    float env = {};
    float reelW = {};
    float persp = {};
    float dSide = {};
    float dInner = {};
    float local_2 = {};
    float line = {};
    float outside = {};
    int _e97 = uniforms.reels;
    n_1 = metal::max(static_cast<float>(_e97), 1.0);
    float _e101 = uv_2[0u];
    float _e102 = n_1;
    float _e105 = n_1;
    i_1 = metal::min(metal::floor(_e101 * _e102), _e105 - 1.0);
    float _e109 = uv_2[0u];
    float _e110 = n_1;
    float _e112 = i_1;
    lx = (_e109 * _e110) - _e112;
    float _e114 = i_1;
    param = _e114;
    float _e115 = n_1;
    param_1 = _e115;
    float _e116 = stopTime(param, param_1, uniforms);
    stopT_2 = _e116;
    float _e117 = stopT_2;
    turns_2 = (2.0 * metal::floor(_e117 * 4.0)) + 1.0;
    float _e123 = uniforms.progress;
    float _e125 = stopT_2;
    float _e126 = stopT_2;
    float _e129 = uniforms.progress;
    drum = metal::smoothstep(0.0, 0.12, _e123) * (1.0 - metal::smoothstep(_e125, _e126 + 0.1, _e129));
    float _e134 = uv_2[1u];
    y = (2.0 * _e134) - 1.0;
    float _e137 = y;
    theta = metal::asin(metal::clamp(_e137 * 0.91276395, -1.0, 1.0));
    float _e142 = uv_2[1u];
    float _e143 = theta;
    float _e146 = drum;
    v = metal::mix(_e142, 0.5 + (_e143 / 2.3), _e146);
    float _e148 = theta;
    float _e151 = drum;
    depth = (1.0 - metal::cos(_e148)) * _e151;
    float _e153 = lx;
    float _e155 = depth;
    px = 0.5 + ((_e153 - 0.5) * (1.0 + (0.2 * _e155)));
    float _e161 = uniforms.progress;
    param_2 = _e161;
    float _e162 = stopT_2;
    param_3 = _e162;
    float _e163 = turns_2;
    param_4 = _e163;
    float _e164 = reelOffset(param_2, param_3, param_4, uniforms);
    float _e165 = turns_2;
    off = _e164 - _e165;
    float _e168 = uniforms.progress;
    param_5 = _e168;
    float _e169 = stopT_2;
    param_6 = _e169;
    float _e170 = turns_2;
    param_7 = _e170;
    float _e171 = reelSpeed(param_5, param_6, param_7, uniforms);
    speed = metal::abs(_e171);
    float _e174 = uniforms.blur;
    float _e175 = speed;
    float _e179 = drum;
    spread = (_e174 * metal::min(_e175 * 0.02, 0.22)) * _e179;
    c = metal::float4(0.0, 0.0, 0.0, 0.0);
    wsum = 0.0;
    k = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e256 = k;
            k = as_type<int>(as_type<uint>(_e256) + as_type<uint>(1));
        }
        loop_init = false;
        int _e181 = k;
        if (_e181 < 8) {
            int _e183 = k;
            f = (static_cast<float>(_e183) / 7.0) - 0.5;
            float _e187 = f;
            w = 1.0 - metal::abs(_e187);
            float _e190 = v;
            float _e191 = off;
            float _e193 = spread;
            float _e194 = f;
            vv = (_e190 + _e191) + (_e193 * _e194);
            float _e197 = vv;
            seg = metal::floor(_e197);
            float _e199 = i_1;
            float _e200 = px;
            float _e203 = n_1;
            float _e205 = vv;
            float _e206 = seg;
            q = metal::float2((_e199 + metal::clamp(_e200, 0.0, 1.0)) / _e203, _e205 - _e206);
            float _e209 = seg;
            if ((_e209 - (metal::floor(_e209 / 2.0) * 2.0)) < 0.5) {
                metal::float2 _e215 = q;
                param_8 = _e215;
                metal::float4 _e216 = getToColor(param_8, _sampler, _to);
                local_1 = _e216;
            } else {
                metal::float2 _e217 = q;
                param_9 = _e217;
                metal::float4 _e218 = getFromColor(param_9, _from, _sampler);
                local_1 = _e218;
            }
            metal::float4 _e219 = local_1;
            s = _e219;
            float _e220 = drum;
            float _e222 = y;
            float _e223 = y;
            float _e228 = q[1u];
            float _e230 = q[1u];
            metal::float4 _e237 = s;
            metal::float3 _e239 = _e237.xyz * (1.0 - (((0.6 * _e220) * (1.0 - (_e222 * _e223))) * (1.0 - metal::smoothstep(0.0, 0.02, metal::min(_e228, 1.0 - _e230)))));
            s[0u] = _e239.x;
            s[1u] = _e239.y;
            s[2u] = _e239.z;
            float _e246 = w;
            metal::float4 _e247 = s;
            metal::float4 _e249 = c;
            c = _e249 + (_e247 * _e246);
            float _e251 = w;
            float _e252 = wsum;
            wsum = _e252 + _e251;
            float _e254 = spread;
            if (_e254 < 0.0001) {
                break;
            }
            continue;
        } else {
            break;
        }
    }
    float _e258 = wsum;
    metal::float4 _e259 = c;
    c = _e259 / metal::float4(_e258);
    float _e262 = theta;
    facing = metal::cos(_e262);
    float _e264 = facing;
    float _e266 = facing;
    float _e269 = drum;
    metal::float4 _e271 = c;
    metal::float3 _e273 = _e271.xyz * metal::mix(1.0, 0.25 + ((0.75 * _e264) * _e266), _e269);
    c[0u] = _e273.x;
    c[1u] = _e273.y;
    c[2u] = _e273.z;
    float _e280 = drum;
    float _e283 = c[3u];
    float _e285 = y;
    float _e288 = y;
    metal::float4 _e293 = c;
    metal::float3 _e296 = _e293.xyz + metal::float3(((_e280 * 0.07) * _e283) * metal::exp((-12.0 * (_e285 - 0.3)) * (_e288 - 0.3)));
    c[0u] = _e296.x;
    c[1u] = _e296.y;
    c[2u] = _e296.z;
    float _e304 = uniforms.progress;
    float _e307 = uniforms.progress;
    env = metal::smoothstep(0.0, 0.1, _e304) * (1.0 - metal::smoothstep(0.9, 1.0, _e307));
    float _e312 = uniforms.ratio;
    float _e313 = n_1;
    reelW = _e312 / _e313;
    float _e315 = reelW;
    float _e316 = depth;
    persp = _e315 / (1.0 + (0.2 * _e316));
    float _e320 = px;
    float _e321 = px;
    float _e324 = persp;
    dSide = metal::min(_e320, 1.0 - _e321) * _e324;
    float _e326 = i_1;
    float _e328 = px;
    float _e330 = i_1;
    float _e331 = n_1;
    if (_e330 < (_e331 - 1.5)) {
        float _e334 = px;
        local_2 = 1.0 - _e334;
    } else {
        local_2 = 2.0;
    }
    float _e336 = local_2;
    float _e338 = persp;
    dInner = metal::min((_e326 > 0.5) ? _e328 : 2.0, _e336) * _e338;
    float _e340 = dInner;
    line = 1.0 - metal::smoothstep(0.0015, 0.0045, _e340);
    float _e343 = dSide;
    outside = 1.0 - metal::smoothstep(-0.0015, 0.0, _e343);
    float _e346 = env;
    float _e348 = reelW;
    float _e351 = dInner;
    metal::float4 _e356 = c;
    metal::float3 _e358 = _e356.xyz * (1.0 - ((0.35 * _e346) * (1.0 - metal::smoothstep(0.0, (0.03 * _e348) + 0.006, _e351))));
    c[0u] = _e358.x;
    c[1u] = _e358.y;
    c[2u] = _e358.z;
    metal::float4 _e365 = c;
    metal::float4 _e367 = uniforms.separator;
    float _e368 = line;
    float _e369 = env;
    float _e371 = outside;
    return metal::mix(_e365, _e367, metal::float4(metal::max(_e368 * _e369, _e371)));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_10 = {};
    metal::float2 _e53 = _uv_1;
    param_10 = _e53;
    metal::float4 _e54 = transition(param_10, _from, _sampler, _to, uniforms);
    _fragColor = _e54;
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
