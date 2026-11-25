// GlitchFlicker — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/GlitchFlicker.glsl
// Author: bread
// License: MIT
// Description: A flickering glitch with RGB offset, ghosting and scanlines that flashes back to the outgoing image
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float frameRate;
    float rgbOffset;
    float blockAmount;
    float ghostAmount;
    float redCyan;
    float scanline;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e107 = uv[0u];
    float _e109 = uv[1u];
    metal::float4 _e112 = _to.sample(_sampler, metal::float2(_e107, 1.0 - _e109), metal::level(0.0));
    return _e112;
}

metal::float2 safeUv(
    thread metal::float2& uv_1
) {
    metal::float2 _e106 = uv_1;
    return metal::clamp(_e106, metal::float2(0.001, 0.001), metal::float2(0.999, 0.999));
}

metal::float4 chromaTo(
    thread metal::float2& uv_2,
    thread float& amt,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    metal::float2 o = {};
    metal::float4 center = {};
    metal::float2 param = {};
    metal::float2 param_1 = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    metal::float2 param_4 = {};
    metal::float2 param_5 = {};
    float _e115 = amt;
    o = metal::float2(_e115, 0.0);
    metal::float2 _e117 = uv_2;
    param = _e117;
    metal::float2 _e118 = safeUv(param);
    param_1 = _e118;
    metal::float4 _e119 = getToColor(param_1, _sampler, _to);
    center = _e119;
    metal::float2 _e120 = uv_2;
    metal::float2 _e121 = o;
    param_2 = _e120 - _e121;
    metal::float2 _e123 = safeUv(param_2);
    param_3 = _e123;
    metal::float4 _e124 = getToColor(param_3, _sampler, _to);
    float _e127 = center[1u];
    metal::float2 _e128 = uv_2;
    metal::float2 _e129 = o;
    param_4 = _e128 + _e129;
    metal::float2 _e131 = safeUv(param_4);
    param_5 = _e131;
    metal::float4 _e132 = getToColor(param_5, _sampler, _to);
    float _e135 = center[3u];
    return metal::float4(_e124.x, _e127, _e132.z, _e135);
}

metal::float4 getFromColor(
    thread metal::float2& uv_3,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e107 = uv_3[0u];
    float _e109 = uv_3[1u];
    metal::float4 _e112 = _from.sample(_sampler, metal::float2(_e107, 1.0 - _e109), metal::level(0.0));
    return _e112;
}

metal::float4 chromaFrom(
    thread metal::float2& uv_4,
    thread float& amt_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    metal::float2 o_1 = {};
    metal::float4 center_1 = {};
    metal::float2 param_6 = {};
    metal::float2 param_7 = {};
    metal::float2 param_8 = {};
    metal::float2 param_9 = {};
    metal::float2 param_10 = {};
    metal::float2 param_11 = {};
    float _e115 = amt_1;
    o_1 = metal::float2(_e115, 0.0);
    metal::float2 _e117 = uv_4;
    param_6 = _e117;
    metal::float2 _e118 = safeUv(param_6);
    param_7 = _e118;
    metal::float4 _e119 = getFromColor(param_7, _from, _sampler);
    center_1 = _e119;
    metal::float2 _e120 = uv_4;
    metal::float2 _e121 = o_1;
    param_8 = _e120 + _e121;
    metal::float2 _e123 = safeUv(param_8);
    param_9 = _e123;
    metal::float4 _e124 = getFromColor(param_9, _from, _sampler);
    float _e127 = center_1[1u];
    metal::float2 _e128 = uv_4;
    metal::float2 _e129 = o_1;
    param_10 = _e128 - _e129;
    metal::float2 _e131 = safeUv(param_10);
    param_11 = _e131;
    metal::float4 _e132 = getFromColor(param_11, _from, _sampler);
    float _e135 = center_1[3u];
    return metal::float4(_e124.x, _e127, _e132.z, _e135);
}

float sat(
    thread float& x
) {
    float _e106 = x;
    return metal::clamp(_e106, 0.0, 1.0);
}

float hash12(
    thread metal::float2& p
) {
    metal::float2 _e106 = p;
    p = metal::fract(_e106 * metal::float2(443.8975, 397.2973));
    metal::float2 _e109 = p;
    metal::float2 _e110 = p;
    metal::float2 _e115 = p;
    p = _e115 + metal::float2(metal::dot(_e109, _e110.yx + metal::float2(19.19)));
    float _e119 = p[0u];
    float _e121 = p[1u];
    return metal::fract(_e119 * _e121);
}

float blockMask(
    thread metal::float2& uv_5,
    thread float& f
) {
    metal::float2 big = {};
    metal::float2 small = {};
    float wide = {};
    metal::float2 param_12 = {};
    float chunks = {};
    metal::float2 param_13 = {};
    float verticalCut = {};
    metal::float2 param_14 = {};
    float param_15 = {};
    metal::float2 _e116 = uv_5;
    big = metal::floor(_e116 * metal::float2(4.0, 2.0));
    metal::float2 _e119 = uv_5;
    small = metal::floor(_e119 * metal::float2(8.0, 4.0));
    float _e123 = big[0u];
    float _e124 = f;
    param_12 = metal::float2(_e123, _e124 * 1.37);
    float _e127 = hash12(param_12);
    wide = metal::step(0.48, _e127);
    metal::float2 _e129 = small;
    float _e130 = f;
    float _e132 = f;
    param_13 = _e129 + metal::float2(_e130 * 2.11, _e132 * 0.73);
    float _e136 = hash12(param_13);
    chunks = metal::step(0.56, _e136);
    float _e139 = uv_5[0u];
    float _e140 = f;
    param_14 = metal::float2(_e140, 4.7);
    float _e142 = hash12(param_14);
    verticalCut = metal::smoothstep(-0.035, 0.035, _e139 - metal::mix(0.18, 0.78, _e142));
    float _e146 = wide;
    float _e147 = chunks;
    float _e150 = verticalCut;
    param_15 = (metal::mix(_e146, _e147, 0.38) * 0.72) + (_e150 * 0.28);
    float _e153 = sat(param_15);
    return _e153;
}

float frameGlitch(
    thread float& f_1
) {
    float _e106 = f_1;
    if (_e106 < 0.5) {
        return 0.0;
    }
    float _e108 = f_1;
    if (_e108 < 6.5) {
        return 0.92;
    }
    float _e110 = f_1;
    if (_e110 < 10.5) {
        return 0.38;
    }
    float _e112 = f_1;
    if (_e112 < 11.5) {
        return 0.78;
    }
    float _e114 = f_1;
    if (_e114 < 12.5) {
        return 0.12;
    }
    float _e116 = f_1;
    if (_e116 < 17.5) {
        return 0.74;
    }
    float _e118 = f_1;
    if (_e118 < 22.5) {
        return 0.88;
    }
    float _e120 = f_1;
    if (_e120 < 23.5) {
        return 0.28;
    }
    return 0.0;
}

float frameReveal(
    thread float& f_2
) {
    float _e106 = f_2;
    if (_e106 < 0.5) {
        return 0.0;
    }
    float _e108 = f_2;
    if (_e108 < 1.5) {
        return 0.28;
    }
    float _e110 = f_2;
    if (_e110 < 2.5) {
        return 0.43;
    }
    float _e112 = f_2;
    if (_e112 < 3.5) {
        return 0.46;
    }
    float _e114 = f_2;
    if (_e114 < 4.5) {
        return 0.38;
    }
    float _e116 = f_2;
    if (_e116 < 5.5) {
        return 0.48;
    }
    float _e118 = f_2;
    if (_e118 < 6.5) {
        return 0.26;
    }
    float _e120 = f_2;
    if (_e120 < 7.5) {
        return 0.1;
    }
    float _e122 = f_2;
    if (_e122 < 8.5) {
        return 0.0;
    }
    float _e124 = f_2;
    if (_e124 < 9.5) {
        return 0.0;
    }
    float _e126 = f_2;
    if (_e126 < 10.5) {
        return 0.3;
    }
    float _e128 = f_2;
    if (_e128 < 11.5) {
        return 0.58;
    }
    float _e130 = f_2;
    if (_e130 < 12.5) {
        return 1.0;
    }
    float _e132 = f_2;
    if (_e132 < 13.5) {
        return 0.7;
    }
    float _e134 = f_2;
    if (_e134 < 14.5) {
        return 0.42;
    }
    float _e136 = f_2;
    if (_e136 < 15.5) {
        return 0.55;
    }
    float _e138 = f_2;
    if (_e138 < 16.5) {
        return 0.72;
    }
    float _e140 = f_2;
    if (_e140 < 17.5) {
        return 0.88;
    }
    float _e142 = f_2;
    if (_e142 < 18.5) {
        return 0.34;
    }
    float _e144 = f_2;
    if (_e144 < 19.5) {
        return 0.48;
    }
    float _e146 = f_2;
    if (_e146 < 20.5) {
        return 0.56;
    }
    float _e148 = f_2;
    if (_e148 < 21.5) {
        return 0.76;
    }
    float _e150 = f_2;
    if (_e150 < 22.5) {
        return 0.93;
    }
    return 1.0;
}

metal::float4 transition(
    thread metal::float2& uv_6,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 param_16 = {};
    metal::float2 param_17 = {};
    float f_3 = {};
    float reveal = {};
    float param_18 = {};
    float glitch = {};
    float param_19 = {};
    float rnd = {};
    metal::float2 param_20 = {};
    metal::float2 jitter = {};
    metal::float2 param_21 = {};
    metal::float2 fromUv = {};
    metal::float2 param_22 = {};
    metal::float2 toUv = {};
    metal::float2 param_23 = {};
    float block = {};
    metal::float2 param_24 = {};
    float param_25 = {};
    float localReveal = {};
    metal::float2 param_26 = {};
    float param_27 = {};
    metal::float4 oldClip = {};
    metal::float2 param_28 = {};
    float param_29 = {};
    metal::float4 newClip = {};
    metal::float2 param_30 = {};
    float param_31 = {};
    metal::float4 color = {};
    float leftWash = {};
    float cyanWash = {};
    metal::float3 redGhost = {};
    metal::float3 cyanGhost = {};
    float oldReturn = {};
    float lines = {};
    float exposurePulse = {};
    metal::float2 param_32 = {};
    float param_33 = {};
    float param_34 = {};
    float param_35 = {};
    float _e146 = uniforms.progress;
    if (_e146 <= 0.0) {
        metal::float2 _e148 = uv_6;
        param_16 = _e148;
        metal::float4 _e149 = getFromColor(param_16, _from, _sampler);
        return _e149;
    }
    float _e151 = uniforms.progress;
    if (_e151 >= 1.0) {
        metal::float2 _e153 = uv_6;
        param_17 = _e153;
        metal::float4 _e154 = getToColor(param_17, _sampler, _to);
        return _e154;
    }
    float _e156 = uniforms.progress;
    float _e158 = uniforms.frameRate;
    f_3 = metal::floor(_e156 * _e158);
    float _e161 = f_3;
    param_18 = _e161;
    float _e162 = frameReveal(param_18);
    reveal = _e162;
    float _e163 = f_3;
    param_19 = _e163;
    float _e164 = frameGlitch(param_19);
    glitch = _e164;
    float _e165 = f_3;
    param_20 = metal::float2(_e165, 9.13);
    float _e167 = hash12(param_20);
    rnd = _e167;
    float _e168 = rnd;
    float _e171 = f_3;
    param_21 = metal::float2(_e171, 2.71);
    float _e173 = hash12(param_21);
    float _e177 = glitch;
    jitter = metal::float2((_e168 - 0.5) * 0.042, (_e173 - 0.5) * 0.01) * _e177;
    metal::float2 _e179 = uv_6;
    metal::float2 _e180 = jitter;
    param_22 = _e179 + _e180;
    metal::float2 _e182 = safeUv(param_22);
    fromUv = _e182;
    metal::float2 _e183 = uv_6;
    metal::float2 _e184 = jitter;
    param_23 = _e183 - (_e184 * 0.55);
    metal::float2 _e187 = safeUv(param_23);
    toUv = _e187;
    metal::float2 _e188 = uv_6;
    param_24 = _e188;
    float _e189 = f_3;
    param_25 = _e189;
    float _e190 = blockMask(param_24, param_25);
    block = _e190;
    float _e191 = reveal;
    float _e192 = block;
    float _e195 = uniforms.blockAmount;
    float _e197 = glitch;
    float _e200 = f_3;
    float _e202 = uv_6[1u];
    param_26 = metal::float2(_e200, metal::floor(_e202 * 9.0));
    float _e206 = hash12(param_26);
    float _e209 = glitch;
    param_27 = (_e191 + (((_e192 - 0.5) * _e195) * _e197)) + (((_e206 - 0.5) * 0.18) * _e209);
    float _e212 = sat(param_27);
    localReveal = _e212;
    float _e213 = localReveal;
    localReveal = metal::smoothstep(0.22, 0.78, _e213);
    float _e216 = uniforms.rgbOffset;
    float _e217 = glitch;
    metal::float2 _e219 = fromUv;
    param_28 = _e219;
    param_29 = _e216 * _e217;
    metal::float4 _e220 = chromaFrom(param_28, param_29, _from, _sampler);
    oldClip = _e220;
    float _e222 = uniforms.rgbOffset;
    float _e223 = glitch;
    metal::float2 _e225 = toUv;
    param_30 = _e225;
    param_31 = _e222 * _e223;
    metal::float4 _e226 = chromaTo(param_30, param_31, _sampler, _to);
    newClip = _e226;
    metal::float4 _e227 = oldClip;
    metal::float4 _e228 = newClip;
    float _e229 = localReveal;
    color = metal::mix(_e227, _e228, metal::float4(_e229));
    float _e233 = uv_6[0u];
    float _e236 = glitch;
    leftWash = (1.0 - metal::smoothstep(0.1, 0.78, _e233)) * _e236;
    float _e239 = uv_6[0u];
    float _e242 = uv_6[0u];
    float _e246 = glitch;
    cyanWash = (metal::smoothstep(0.08, 0.62, _e239) * (1.0 - metal::smoothstep(0.86, 1.0, _e242))) * _e246;
    metal::float4 _e248 = oldClip;
    redGhost = _e248.xyz * metal::float3(1.34, 0.42, 0.38);
    metal::float4 _e251 = newClip;
    cyanGhost = _e251.xyz * metal::float3(0.48, 1.12, 1.24);
    metal::float4 _e254 = color;
    metal::float3 _e256 = redGhost;
    float _e257 = leftWash;
    float _e259 = uniforms.redCyan;
    metal::float3 _e263 = metal::mix(_e254.xyz, _e256, metal::float3((_e257 * _e259) * 0.42));
    color[0u] = _e263.x;
    color[1u] = _e263.y;
    color[2u] = _e263.z;
    metal::float4 _e270 = color;
    metal::float3 _e272 = cyanGhost;
    float _e273 = cyanWash;
    float _e275 = uniforms.redCyan;
    metal::float3 _e279 = metal::mix(_e270.xyz, _e272, metal::float3((_e273 * _e275) * 0.3));
    color[0u] = _e279.x;
    color[1u] = _e279.y;
    color[2u] = _e279.z;
    float _e286 = glitch;
    float _e287 = reveal;
    oldReturn = _e286 * (1.0 - metal::smoothstep(0.94, 1.0, _e287));
    float _e291 = localReveal;
    float _e298 = oldReturn;
    oldReturn = _e298 * (0.18 + (0.52 * (1.0 - (metal::abs(_e291 - 0.5) * 2.0))));
    metal::float4 _e300 = color;
    metal::float4 _e302 = oldClip;
    float _e304 = oldReturn;
    float _e306 = uniforms.ghostAmount;
    metal::float3 _e309 = metal::mix(_e300.xyz, _e302.xyz, metal::float3(_e304 * _e306));
    color[0u] = _e309.x;
    color[1u] = _e309.y;
    color[2u] = _e309.z;
    float _e317 = uv_6[1u];
    float _e318 = f_3;
    lines = metal::sin((_e317 + (_e318 * 0.017)) * 1080.0);
    float _e323 = lines;
    float _e325 = uniforms.scanline;
    float _e327 = glitch;
    metal::float4 _e329 = color;
    metal::float3 _e332 = _e329.xyz + metal::float3((_e323 * _e325) * _e327);
    color[0u] = _e332.x;
    color[1u] = _e332.y;
    color[2u] = _e332.z;
    float _e339 = f_3;
    param_32 = metal::float2(_e339, 12.4);
    float _e341 = hash12(param_32);
    float _e344 = glitch;
    exposurePulse = ((_e341 - 0.35) * 0.1) * _e344;
    float _e346 = exposurePulse;
    metal::float4 _e347 = color;
    metal::float3 _e350 = _e347.xyz + metal::float3(_e346);
    color[0u] = _e350.x;
    color[1u] = _e350.y;
    color[2u] = _e350.z;
    float _e358 = color[0u];
    param_33 = _e358;
    float _e359 = sat(param_33);
    float _e361 = color[1u];
    param_34 = _e361;
    float _e362 = sat(param_34);
    float _e364 = color[2u];
    param_35 = _e364;
    float _e365 = sat(param_35);
    float _e367 = color[3u];
    return metal::float4(_e359, _e362, _e365, _e367);
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_36 = {};
    metal::float2 _e106 = _uv_1;
    param_36 = _e106;
    metal::float4 _e107 = transition(param_36, _from, _sampler, _to, uniforms);
    _fragColor = _e107;
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
