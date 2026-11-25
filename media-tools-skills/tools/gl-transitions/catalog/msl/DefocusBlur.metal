// DefocusBlur — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/DefocusBlur.glsl
// Author: Sergey Kosarevsky
// License: MIT
// Description: A crossfade through an out-of-focus blur
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float blurSize;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e52 = uv[0u];
    float _e54 = uv[1u];
    metal::float4 _e57 = _to.sample(_sampler, metal::float2(_e52, 1.0 - _e54), metal::level(0.0));
    return _e57;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e52 = uv_1[0u];
    float _e54 = uv_1[1u];
    metal::float4 _e57 = _from.sample(_sampler, metal::float2(_e52, 1.0 - _e54), metal::level(0.0));
    return _e57;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    float T = {};
    float half_ = {};
    float D = {};
    float local = {};
    metal::float4 C0_ = {};
    metal::float2 param = {};
    metal::float4 C1_ = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    metal::float2 param_12 = {};
    metal::float2 param_13 = {};
    metal::float2 param_14 = {};
    metal::float2 param_15 = {};
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    metal::float2 param_18 = {};
    metal::float2 param_19 = {};
    metal::float2 param_20 = {};
    metal::float2 param_21 = {};
    metal::float2 param_22 = {};
    metal::float2 param_23 = {};
    metal::float2 param_24 = {};
    metal::float2 param_25 = {};
    float _e84 = uniforms.progress;
    T = _e84;
    half_ = 0.5;
    float _e85 = T;
    float _e86 = half_;
    if (_e85 < _e86) {
        float _e89 = uniforms.blurSize;
        float _e90 = T;
        float _e91 = half_;
        local = metal::mix(0.0, _e89, _e90 / _e91);
    } else {
        float _e95 = uniforms.blurSize;
        float _e96 = T;
        float _e97 = half_;
        float _e99 = half_;
        local = metal::mix(_e95, 0.0, (_e96 - _e97) / _e99);
    }
    float _e102 = local;
    D = _e102;
    metal::float2 _e103 = uv_2;
    param = _e103;
    metal::float4 _e104 = getFromColor(param, _from, _sampler);
    C0_ = _e104;
    metal::float2 _e105 = uv_2;
    param_1 = _e105;
    metal::float4 _e106 = getToColor(param_1, _sampler, _to);
    C1_ = _e106;
    float _e107 = D;
    metal::float2 _e109 = uv_2;
    param_2 = (metal::float2(-0.326, -0.406) * _e107) + _e109;
    metal::float4 _e111 = getFromColor(param_2, _from, _sampler);
    metal::float4 _e112 = C0_;
    C0_ = _e112 + _e111;
    float _e114 = D;
    metal::float2 _e116 = uv_2;
    param_3 = (metal::float2(-0.326, -0.406) * _e114) + _e116;
    metal::float4 _e118 = getToColor(param_3, _sampler, _to);
    metal::float4 _e119 = C1_;
    C1_ = _e119 + _e118;
    float _e121 = D;
    metal::float2 _e123 = uv_2;
    param_4 = (metal::float2(-0.84, -0.074) * _e121) + _e123;
    metal::float4 _e125 = getFromColor(param_4, _from, _sampler);
    metal::float4 _e126 = C0_;
    C0_ = _e126 + _e125;
    float _e128 = D;
    metal::float2 _e130 = uv_2;
    param_5 = (metal::float2(-0.84, -0.074) * _e128) + _e130;
    metal::float4 _e132 = getToColor(param_5, _sampler, _to);
    metal::float4 _e133 = C1_;
    C1_ = _e133 + _e132;
    float _e135 = D;
    metal::float2 _e137 = uv_2;
    param_6 = (metal::float2(-0.696, 0.457) * _e135) + _e137;
    metal::float4 _e139 = getFromColor(param_6, _from, _sampler);
    metal::float4 _e140 = C0_;
    C0_ = _e140 + _e139;
    float _e142 = D;
    metal::float2 _e144 = uv_2;
    param_7 = (metal::float2(-0.696, 0.457) * _e142) + _e144;
    metal::float4 _e146 = getToColor(param_7, _sampler, _to);
    metal::float4 _e147 = C1_;
    C1_ = _e147 + _e146;
    float _e149 = D;
    metal::float2 _e151 = uv_2;
    param_8 = (metal::float2(-0.203, 0.621) * _e149) + _e151;
    metal::float4 _e153 = getFromColor(param_8, _from, _sampler);
    metal::float4 _e154 = C0_;
    C0_ = _e154 + _e153;
    float _e156 = D;
    metal::float2 _e158 = uv_2;
    param_9 = (metal::float2(-0.203, 0.621) * _e156) + _e158;
    metal::float4 _e160 = getToColor(param_9, _sampler, _to);
    metal::float4 _e161 = C1_;
    C1_ = _e161 + _e160;
    float _e163 = D;
    metal::float2 _e165 = uv_2;
    param_10 = (metal::float2(0.962, -0.195) * _e163) + _e165;
    metal::float4 _e167 = getFromColor(param_10, _from, _sampler);
    metal::float4 _e168 = C0_;
    C0_ = _e168 + _e167;
    float _e170 = D;
    metal::float2 _e172 = uv_2;
    param_11 = (metal::float2(0.962, -0.195) * _e170) + _e172;
    metal::float4 _e174 = getToColor(param_11, _sampler, _to);
    metal::float4 _e175 = C1_;
    C1_ = _e175 + _e174;
    float _e177 = D;
    metal::float2 _e179 = uv_2;
    param_12 = (metal::float2(0.473, -0.48) * _e177) + _e179;
    metal::float4 _e181 = getFromColor(param_12, _from, _sampler);
    metal::float4 _e182 = C0_;
    C0_ = _e182 + _e181;
    float _e184 = D;
    metal::float2 _e186 = uv_2;
    param_13 = (metal::float2(0.473, -0.48) * _e184) + _e186;
    metal::float4 _e188 = getToColor(param_13, _sampler, _to);
    metal::float4 _e189 = C1_;
    C1_ = _e189 + _e188;
    float _e191 = D;
    metal::float2 _e193 = uv_2;
    param_14 = (metal::float2(0.519, 0.767) * _e191) + _e193;
    metal::float4 _e195 = getFromColor(param_14, _from, _sampler);
    metal::float4 _e196 = C0_;
    C0_ = _e196 + _e195;
    float _e198 = D;
    metal::float2 _e200 = uv_2;
    param_15 = (metal::float2(0.519, 0.767) * _e198) + _e200;
    metal::float4 _e202 = getToColor(param_15, _sampler, _to);
    metal::float4 _e203 = C1_;
    C1_ = _e203 + _e202;
    float _e205 = D;
    metal::float2 _e207 = uv_2;
    param_16 = (metal::float2(0.185, -0.893) * _e205) + _e207;
    metal::float4 _e209 = getFromColor(param_16, _from, _sampler);
    metal::float4 _e210 = C0_;
    C0_ = _e210 + _e209;
    float _e212 = D;
    metal::float2 _e214 = uv_2;
    param_17 = (metal::float2(0.185, -0.893) * _e212) + _e214;
    metal::float4 _e216 = getToColor(param_17, _sampler, _to);
    metal::float4 _e217 = C1_;
    C1_ = _e217 + _e216;
    float _e219 = D;
    metal::float2 _e221 = uv_2;
    param_18 = (metal::float2(0.507, 0.064) * _e219) + _e221;
    metal::float4 _e223 = getFromColor(param_18, _from, _sampler);
    metal::float4 _e224 = C0_;
    C0_ = _e224 + _e223;
    float _e226 = D;
    metal::float2 _e228 = uv_2;
    param_19 = (metal::float2(0.507, 0.064) * _e226) + _e228;
    metal::float4 _e230 = getToColor(param_19, _sampler, _to);
    metal::float4 _e231 = C1_;
    C1_ = _e231 + _e230;
    float _e233 = D;
    metal::float2 _e235 = uv_2;
    param_20 = (metal::float2(0.896, 0.412) * _e233) + _e235;
    metal::float4 _e237 = getFromColor(param_20, _from, _sampler);
    metal::float4 _e238 = C0_;
    C0_ = _e238 + _e237;
    float _e240 = D;
    metal::float2 _e242 = uv_2;
    param_21 = (metal::float2(0.896, 0.412) * _e240) + _e242;
    metal::float4 _e244 = getToColor(param_21, _sampler, _to);
    metal::float4 _e245 = C1_;
    C1_ = _e245 + _e244;
    float _e247 = D;
    metal::float2 _e249 = uv_2;
    param_22 = (metal::float2(-0.322, -0.933) * _e247) + _e249;
    metal::float4 _e251 = getFromColor(param_22, _from, _sampler);
    metal::float4 _e252 = C0_;
    C0_ = _e252 + _e251;
    float _e254 = D;
    metal::float2 _e256 = uv_2;
    param_23 = (metal::float2(-0.322, -0.933) * _e254) + _e256;
    metal::float4 _e258 = getToColor(param_23, _sampler, _to);
    metal::float4 _e259 = C1_;
    C1_ = _e259 + _e258;
    float _e261 = D;
    metal::float2 _e263 = uv_2;
    param_24 = (metal::float2(-0.792, -0.598) * _e261) + _e263;
    metal::float4 _e265 = getFromColor(param_24, _from, _sampler);
    metal::float4 _e266 = C0_;
    C0_ = _e266 + _e265;
    float _e268 = D;
    metal::float2 _e270 = uv_2;
    param_25 = (metal::float2(-0.792, -0.598) * _e268) + _e270;
    metal::float4 _e272 = getToColor(param_25, _sampler, _to);
    metal::float4 _e273 = C1_;
    C1_ = _e273 + _e272;
    metal::float4 _e275 = C0_;
    C0_ = _e275 / metal::float4(13.0);
    metal::float4 _e278 = C1_;
    C1_ = _e278 / metal::float4(13.0);
    metal::float4 _e281 = C0_;
    metal::float4 _e282 = C1_;
    float _e283 = T;
    return metal::mix(_e281, _e282, metal::float4(_e283));
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_26 = {};
    metal::float2 _e51 = _uv_1;
    param_26 = _e51;
    metal::float4 _e52 = transition(param_26, _from, _sampler, _to, uniforms);
    _fragColor = _e52;
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
