// TilesWave — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/TilesWave.glsl
// Author: numb3r23
// License: MIT
// Description: The incoming image is revealed tile by tile in a diagonal wave
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    metal::int2 tileCount;
    int flipX;
    int flipY;
};

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e18 = uv[0u];
    float _e20 = uv[1u];
    metal::float4 _e23 = _to.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e18 = uv_1[0u];
    float _e20 = uv_1[1u];
    metal::float4 _e23 = _from.sample(_sampler, metal::float2(_e18, 1.0 - _e20), metal::level(0.0));
    return _e23;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float2 tileSize = {};
    metal::float2 posInTile = {};
    metal::float2 tileNum = {};
    float countTiles = {};
    float offset = {};
    float timeOffset = {};
    float sinTime = {};
    metal::float2 texC = {};
    metal::float2 param = {};
    float local = {};
    metal::float2 param_1 = {};
    float local_1 = {};
    metal::float2 globalUV = {};
    metal::float2 param_2 = {};
    metal::float2 param_3 = {};
    float local_2 = {};
    metal::float2 param_4 = {};
    float local_3 = {};
    metal::float2 globalUV_1 = {};
    metal::float2 param_5 = {};
    bool phi_149_ = {};
    bool phi_199_ = {};
    bool phi_261_ = {};
    bool phi_314_ = {};
    metal::int2 _e38 = uniforms.tileCount;
    tileSize = metal::float2(1.0) / static_cast<metal::float2>(_e38);
    metal::float2 _e42 = uv_2;
    metal::int2 _e44 = uniforms.tileCount;
    posInTile = metal::fract(_e42 * static_cast<metal::float2>(_e44));
    metal::float2 _e48 = uv_2;
    metal::int2 _e50 = uniforms.tileCount;
    tileNum = metal::floor(_e48 * static_cast<metal::float2>(_e50));
    int _e56 = uniforms.tileCount[0u];
    int _e59 = uniforms.tileCount[1u];
    countTiles = static_cast<float>(as_type<int>(as_type<uint>(_e56) * as_type<uint>(_e59)));
    float _e63 = tileNum[1u];
    float _e65 = tileNum[0u];
    int _e68 = uniforms.tileCount[1u];
    float _e72 = countTiles;
    offset = (_e63 + (_e65 * static_cast<float>(_e68))) / _e72;
    float _e75 = uniforms.progress;
    float _e76 = offset;
    float _e78 = countTiles;
    timeOffset = metal::clamp((_e75 - _e76) * _e78, 0.0, 0.5);
    float _e81 = timeOffset;
    sinTime = 1.0 - metal::abs(metal::cos(metal::fract(_e81) * 3.1415925));
    metal::float2 _e87 = posInTile;
    texC = _e87;
    float _e88 = sinTime;
    if (_e88 <= 0.5) {
        int _e91 = uniforms.flipX;
        if (_e91 != 0) {
            float _e94 = texC[0u];
            float _e95 = sinTime;
            bool _e96 = _e94 < _e95;
            phi_149_ = _e96;
            if (!(_e96)) {
                float _e99 = texC[0u];
                float _e100 = sinTime;
                phi_149_ = _e99 > (1.0 - _e100);
            }
            bool _e104 = phi_149_;
            if (_e104) {
                metal::float2 _e105 = uv_2;
                param = _e105;
                metal::float4 _e106 = getFromColor(param, _from, _sampler);
                return _e106;
            }
            float _e108 = texC[0u];
            if (_e108 < 0.5) {
                float _e111 = texC[0u];
                float _e112 = sinTime;
                float _e115 = sinTime;
                local = ((_e111 - _e112) * 0.5) / (0.5 - _e115);
            } else {
                float _e119 = texC[0u];
                float _e122 = sinTime;
                local = (((_e119 - 0.5) * 0.5) / (0.5 - _e122)) + 0.5;
            }
            float _e126 = local;
            texC[0u] = _e126;
        }
        int _e129 = uniforms.flipY;
        if (_e129 != 0) {
            float _e132 = texC[1u];
            float _e133 = sinTime;
            bool _e134 = _e132 < _e133;
            phi_199_ = _e134;
            if (!(_e134)) {
                float _e137 = texC[1u];
                float _e138 = sinTime;
                phi_199_ = _e137 > (1.0 - _e138);
            }
            bool _e142 = phi_199_;
            if (_e142) {
                metal::float2 _e143 = uv_2;
                param_1 = _e143;
                metal::float4 _e144 = getFromColor(param_1, _from, _sampler);
                return _e144;
            }
            float _e146 = texC[1u];
            if (_e146 < 0.5) {
                float _e149 = texC[1u];
                float _e150 = sinTime;
                float _e153 = sinTime;
                local_1 = ((_e149 - _e150) * 0.5) / (0.5 - _e153);
            } else {
                float _e157 = texC[1u];
                float _e160 = sinTime;
                local_1 = (((_e157 - 0.5) * 0.5) / (0.5 - _e160)) + 0.5;
            }
            float _e164 = local_1;
            texC[1u] = _e164;
        }
        metal::float2 _e166 = tileNum;
        metal::float2 _e167 = tileSize;
        metal::float2 _e169 = texC;
        metal::float2 _e170 = tileSize;
        globalUV = (_e166 * _e167) + (_e169 * _e170);
        metal::float2 _e173 = globalUV;
        param_2 = _e173;
        metal::float4 _e174 = getFromColor(param_2, _from, _sampler);
        return _e174;
    } else {
        int _e176 = uniforms.flipX;
        if (_e176 != 0) {
            float _e179 = texC[0u];
            float _e180 = sinTime;
            bool _e181 = _e179 > _e180;
            phi_261_ = _e181;
            if (!(_e181)) {
                float _e184 = texC[0u];
                float _e185 = sinTime;
                phi_261_ = _e184 < (1.0 - _e185);
            }
            bool _e189 = phi_261_;
            if (_e189) {
                metal::float2 _e190 = uv_2;
                param_3 = _e190;
                metal::float4 _e191 = getToColor(param_3, _sampler, _to);
                return _e191;
            }
            float _e193 = texC[0u];
            if (_e193 < 0.5) {
                float _e196 = texC[0u];
                float _e197 = sinTime;
                float _e200 = sinTime;
                local_2 = ((_e196 - _e197) * 0.5) / (0.5 - _e200);
            } else {
                float _e204 = texC[0u];
                float _e207 = sinTime;
                local_2 = (((_e204 - 0.5) * 0.5) / (0.5 - _e207)) + 0.5;
            }
            float _e211 = local_2;
            texC[0u] = _e211;
            float _e214 = texC[0u];
            texC[0u] = 1.0 - _e214;
        }
        int _e218 = uniforms.flipY;
        if (_e218 != 0) {
            float _e221 = texC[1u];
            float _e222 = sinTime;
            bool _e223 = _e221 > _e222;
            phi_314_ = _e223;
            if (!(_e223)) {
                float _e226 = texC[1u];
                float _e227 = sinTime;
                phi_314_ = _e226 < (1.0 - _e227);
            }
            bool _e231 = phi_314_;
            if (_e231) {
                metal::float2 _e232 = uv_2;
                param_4 = _e232;
                metal::float4 _e233 = getToColor(param_4, _sampler, _to);
                return _e233;
            }
            float _e235 = texC[1u];
            if (_e235 < 0.5) {
                float _e238 = texC[1u];
                float _e239 = sinTime;
                float _e242 = sinTime;
                local_3 = ((_e238 - _e239) * 0.5) / (0.5 - _e242);
            } else {
                float _e246 = texC[1u];
                float _e249 = sinTime;
                local_3 = (((_e246 - 0.5) * 0.5) / (0.5 - _e249)) + 0.5;
            }
            float _e253 = local_3;
            texC[1u] = _e253;
            float _e256 = texC[1u];
            texC[1u] = 1.0 - _e256;
        }
        metal::float2 _e259 = tileNum;
        metal::float2 _e260 = tileSize;
        metal::float2 _e262 = texC;
        metal::float2 _e263 = tileSize;
        globalUV_1 = (_e259 * _e260) + (_e262 * _e263);
        metal::float2 _e266 = globalUV_1;
        param_5 = _e266;
        metal::float4 _e267 = getToColor(param_5, _sampler, _to);
        return _e267;
    }
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_6 = {};
    metal::float2 _e17 = _uv_1;
    param_6 = _e17;
    metal::float4 _e18 = transition(param_6, _from, _sampler, _to, uniforms);
    _fragColor = _e18;
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
