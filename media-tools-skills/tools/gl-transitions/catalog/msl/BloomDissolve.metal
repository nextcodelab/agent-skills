// BloomDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BloomDissolve.glsl
// Author: gre
// License: MIT
// Description: The highlights of the outgoing image blow out into a soft, wide glow that floods the frame; under it the incoming image takes over, then the glow subsides back into its highlights while the image stays sharp
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float spread;
    float threshold;
    float intensity;
    char _pad5[12];
    metal::float3 tint;
};

metal::float3 glow(
    thread metal::float4& c,
    thread float& knee
) {
    float lum = {};
    metal::float4 _e47 = c;
    lum = metal::dot(_e47.xyz, metal::float3(0.2126, 0.7152, 0.0722));
    metal::float4 _e50 = c;
    float _e52 = knee;
    float _e53 = knee;
    float _e54 = knee;
    float _e59 = lum;
    return _e50.xyz * metal::smoothstep(_e52, _e53 + metal::max(0.3 * (1.0 - _e54), 0.001), _e59);
}

metal::float2 mirror(
    thread metal::float2& v
) {
    metal::float2 _e45 = v;
    metal::float2 _e46 = metal::float2(2.0);
    return metal::float2(1.0) - metal::abs(metal::float2(1.0) - (_e45 - (metal::floor(_e45 / _e46) * _e46)));
}

float hash12(
    thread metal::float2& v_1
) {
    metal::float3 v3_ = {};
    metal::float2 _e46 = v_1;
    v3_ = metal::fract(_e46.xyx * 0.1031);
    metal::float3 _e50 = v3_;
    metal::float3 _e51 = v3_;
    metal::float3 _e56 = v3_;
    v3_ = _e56 + metal::float3(metal::dot(_e50, _e51.yzx + metal::float3(33.33)));
    float _e60 = v3_[0u];
    float _e62 = v3_[1u];
    float _e65 = v3_[2u];
    return metal::fract((_e60 + _e62) * _e65);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e46 = uv[0u];
    float _e48 = uv[1u];
    metal::float4 _e51 = _to.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e46 = uv_1[0u];
    float _e48 = uv_1[1u];
    metal::float4 _e51 = _from.sample(_sampler, metal::float2(_e46, 1.0 - _e48), metal::level(0.0));
    return _e51;
}

metal::float4 image(
    thread metal::float2& st,
    thread float& m,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float4 c_1 = {};
    metal::float2 param = {};
    metal::float4 c_2 = {};
    metal::float2 param_1 = {};
    metal::float4 a = {};
    metal::float2 param_2 = {};
    metal::float4 b = {};
    metal::float2 param_3 = {};
    float _e54 = m;
    if (_e54 <= 0.0) {
        metal::float2 _e56 = st;
        param = _e56;
        metal::float4 _e57 = getFromColor(param, _from, _sampler);
        c_1 = _e57;
        metal::float4 _e58 = c_1;
        float _e61 = c_1[3u];
        metal::float3 _e62 = _e58.xyz * _e61;
        float _e64 = c_1[3u];
        return metal::float4(_e62.x, _e62.y, _e62.z, _e64);
    }
    float _e69 = m;
    if (_e69 >= 1.0) {
        metal::float2 _e71 = st;
        param_1 = _e71;
        metal::float4 _e72 = getToColor(param_1, _sampler, _to);
        c_2 = _e72;
        metal::float4 _e73 = c_2;
        float _e76 = c_2[3u];
        metal::float3 _e77 = _e73.xyz * _e76;
        float _e79 = c_2[3u];
        return metal::float4(_e77.x, _e77.y, _e77.z, _e79);
    }
    metal::float2 _e84 = st;
    param_2 = _e84;
    metal::float4 _e85 = getFromColor(param_2, _from, _sampler);
    a = _e85;
    metal::float2 _e86 = st;
    param_3 = _e86;
    metal::float4 _e87 = getToColor(param_3, _sampler, _to);
    b = _e87;
    metal::float4 _e88 = a;
    float _e91 = a[3u];
    metal::float3 _e92 = _e88.xyz * _e91;
    float _e94 = a[3u];
    metal::float4 _e99 = b;
    float _e102 = b[3u];
    metal::float3 _e103 = _e99.xyz * _e102;
    float _e105 = b[3u];
    float _e110 = m;
    return metal::mix(metal::float4(_e92.x, _e92.y, _e92.z, _e94), metal::float4(_e103.x, _e103.y, _e103.z, _e105), metal::float4(_e110));
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float p = {};
    float amount = {};
    float peak = {};
    float flood = {};
    float m_1 = {};
    metal::float4 local = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float4 c_3 = {};
    metal::float2 param_6 = {};
    float param_7 = {};
    float knee_1 = {};
    float radius = {};
    metal::float2 cell = {};
    float spin = {};
    metal::float2 param_8 = {};
    float shift = {};
    metal::float2 param_9 = {};
    metal::float3 bloom = {};
    metal::float4 soft = {};
    float total = {};
    int i = {};
    float s = {};
    float r = {};
    float a_1 = {};
    metal::float2 offset = {};
    metal::float4 i0_ = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    float param_12 = {};
    metal::float4 i1_ = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    metal::float3 l = {};
    metal::float4 param_16 = {};
    float param_17 = {};
    metal::float4 param_18 = {};
    float param_19 = {};
    float w = {};
    float sw = {};
    metal::float3 blurred = {};
    metal::float3 local_1 = {};
    metal::float3 base = {};
    float _e90 = uniforms.progress;
    p = _e90;
    float _e91 = p;
    float _e93 = p;
    amount = (4.0 * _e91) * (1.0 - _e93);
    float _e96 = amount;
    float _e97 = amount;
    peak = _e96 * _e97;
    float _e99 = peak;
    float _e100 = peak;
    float _e102 = peak;
    flood = (_e99 * _e100) * _e102;
    float _e104 = p;
    m_1 = metal::smoothstep(0.44, 0.56, _e104);
    float _e106 = amount;
    if (_e106 <= 0.0) {
        float _e108 = m_1;
        if (_e108 < 0.5) {
            metal::float2 _e110 = uv_2;
            param_4 = _e110;
            metal::float4 _e111 = getFromColor(param_4, _from, _sampler);
            local = _e111;
        } else {
            metal::float2 _e112 = uv_2;
            param_5 = _e112;
            metal::float4 _e113 = getToColor(param_5, _sampler, _to);
            local = _e113;
        }
        metal::float4 _e114 = local;
        return _e114;
    }
    metal::float2 _e115 = uv_2;
    param_6 = _e115;
    float _e116 = m_1;
    param_7 = _e116;
    metal::float4 _e117 = image(param_6, param_7, _from, _sampler, _to);
    c_3 = _e117;
    float _e119 = c_3[3u];
    if (_e119 <= 0.0) {
        return metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    float _e122 = c_3[3u];
    metal::float4 _e123 = c_3;
    metal::float3 _e126 = _e123.xyz / metal::float3(_e122);
    c_3[0u] = _e126.x;
    c_3[1u] = _e126.y;
    c_3[2u] = _e126.z;
    float _e134 = uniforms.threshold;
    float _e135 = peak;
    float _e139 = flood;
    knee_1 = (_e134 * (1.0 - (0.3 * _e135))) * (1.0 - _e139);
    float _e143 = uniforms.spread;
    float _e144 = amount;
    radius = _e143 * _e144;
    metal::float2 _e146 = uv_2;
    float _e148 = uniforms.ratio;
    cell = metal::floor((_e146 * metal::float2(_e148, 1.0)) * 997.0);
    metal::float2 _e153 = cell;
    param_8 = _e153;
    float _e154 = hash12(param_8);
    spin = 6.2831855 * _e154;
    metal::float2 _e156 = cell;
    param_9 = _e156 + metal::float2(71.0);
    float _e159 = hash12(param_9);
    shift = _e159;
    bloom = metal::float3(0.0, 0.0, 0.0);
    soft = metal::float4(0.0, 0.0, 0.0, 0.0);
    total = 0.0;
    i = 0;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e236 = i;
            i = as_type<int>(as_type<uint>(_e236) + as_type<uint>(1));
        }
        loop_init = false;
        int _e160 = i;
        if (_e160 < 10) {
            int _e162 = i;
            float _e164 = shift;
            s = (static_cast<float>(_e162) + _e164) / 10.0;
            float _e167 = s;
            float _e168 = s;
            r = _e167 * _e168;
            int _e170 = i;
            float _e173 = spin;
            a_1 = (static_cast<float>(_e170) * 2.399963) + _e173;
            float _e175 = radius;
            float _e176 = r;
            float _e178 = a_1;
            float _e181 = uniforms.ratio;
            float _e183 = a_1;
            offset = metal::float2(metal::cos(_e178) / _e181, metal::sin(_e183)) * (_e175 * _e176);
            metal::float2 _e187 = uv_2;
            metal::float2 _e188 = offset;
            param_10 = _e187 + _e188;
            metal::float2 _e190 = mirror(param_10);
            param_11 = _e190;
            float _e191 = m_1;
            param_12 = _e191;
            metal::float4 _e192 = image(param_11, param_12, _from, _sampler, _to);
            i0_ = _e192;
            metal::float2 _e193 = uv_2;
            metal::float2 _e194 = offset;
            param_13 = _e193 - _e194;
            metal::float2 _e196 = mirror(param_13);
            param_14 = _e196;
            float _e197 = m_1;
            param_15 = _e197;
            metal::float4 _e198 = image(param_14, param_15, _from, _sampler, _to);
            i1_ = _e198;
            metal::float4 _e199 = i0_;
            param_16 = _e199;
            float _e200 = knee_1;
            param_17 = _e200;
            metal::float3 _e201 = glow(param_16, param_17);
            metal::float4 _e202 = i1_;
            param_18 = _e202;
            float _e203 = knee_1;
            param_19 = _e203;
            metal::float3 _e204 = glow(param_18, param_19);
            l = _e201 + _e204;
            float _e206 = s;
            w = 1.0 - (0.75 * _e206);
            float _e209 = w;
            metal::float3 _e211 = uniforms.tint;
            float _e212 = r;
            metal::float3 _e217 = l;
            metal::float3 _e219 = bloom;
            bloom = _e219 + ((metal::mix(metal::float3(1.0, 1.0, 1.0), _e211, metal::float3(metal::smoothstep(0.0, 0.5, _e212))) * _e209) * _e217);
            float _e221 = w;
            float _e222 = total;
            total = _e222 + _e221;
            float _e224 = s;
            float _e226 = s;
            sw = (1.0 - _e224) * (1.0 - _e226);
            float _e229 = sw;
            metal::float4 _e230 = i0_;
            metal::float4 _e231 = i1_;
            metal::float4 _e234 = soft;
            soft = _e234 + ((_e230 + _e231) * _e229);
            continue;
        } else {
            break;
        }
    }
    float _e238 = total;
    metal::float3 _e240 = bloom;
    bloom = _e240 / metal::float3(2.0 * _e238);
    float _e244 = soft[3u];
    if (_e244 > 0.0) {
        metal::float4 _e246 = soft;
        float _e249 = soft[3u];
        local_1 = _e246.xyz / metal::float3(_e249);
    } else {
        metal::float4 _e252 = c_3;
        local_1 = _e252.xyz;
    }
    metal::float3 _e254 = local_1;
    blurred = _e254;
    metal::float4 _e255 = c_3;
    metal::float3 _e257 = blurred;
    float _e258 = flood;
    base = metal::mix(_e255.xyz, _e257, metal::float3(0.7 * _e258));
    float _e263 = uniforms.intensity;
    float _e264 = peak;
    float _e266 = flood;
    metal::float3 _e270 = bloom;
    bloom = _e270 * ((_e263 * _e264) * (1.0 + (2.0 * _e266)));
    metal::float3 _e272 = bloom;
    bloom = (metal::float3(1.0) - metal::exp(-(_e272))) * 0.92;
    metal::float3 _e278 = base;
    float _e279 = peak;
    base = metal::min(_e278 * (1.0 + (0.25 * _e279)), metal::float3(1.0));
    metal::float3 _e285 = base;
    metal::float3 _e286 = bloom;
    metal::float3 _e288 = base;
    metal::float3 _e289 = bloom;
    metal::float3 _e291 = (_e285 + _e286) - (_e288 * _e289);
    float _e293 = c_3[3u];
    return metal::float4(_e291.x, _e291.y, _e291.z, _e293);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_20 = {};
    metal::float2 _e45 = _uv_1;
    param_20 = _e45;
    metal::float4 _e46 = transition(param_20, _from, _sampler, _to, uniforms);
    _fragColor = _e46;
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
