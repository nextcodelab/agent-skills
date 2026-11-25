// Shockwave — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Shockwave.glsl
// Author: Gilad Levi, github @Giladx
// License: MIT
// Description: A diagonal shockwave breaks the outgoing image into tiny falling glass tiles. Each tile slips away with a brief chromatic split and neon edge glow, revealing the incoming image beneath it.
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float tileSize;
    float scatter;
    float diagonal;
    float prism;
    float glow;
};

float toseeHash(
    thread metal::float2& p
) {
    metal::float2 _e57 = p;
    return metal::fract(metal::sin(metal::dot(_e57, metal::float2(127.1, 311.7))) * 43758.547);
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
    float size = {};
    metal::float2 grid = {};
    metal::float2 cell = {};
    metal::float2 cellUV = {};
    metal::float2 centerUV = {};
    float sweep = {};
    float noise = {};
    metal::float2 param_2 = {};
    float start = {};
    float t = {};
    float movement = {};
    float wobble = {};
    metal::float2 param_3 = {};
    metal::float2 drift = {};
    metal::float2 movingCellUV = {};
    float inside = {};
    float tileShape = {};
    float oldVisibility = {};
    float oldMask = {};
    metal::float2 oldUV = {};
    metal::float4 oldColor = {};
    metal::float2 param_4 = {};
    float flare = {};
    metal::float2 shift = {};
    metal::float4 offsetColor = {};
    metal::float2 param_5 = {};
    metal::float4 result = {};
    metal::float2 param_6 = {};
    float edgeDistance = {};
    float edge = {};
    metal::float3 cyan = {};
    metal::float3 pink = {};
    metal::float3 rimColor = {};
    metal::float2 param_7 = {};
    float _e94 = uniforms.progress;
    if (_e94 <= 0.0) {
        metal::float2 _e96 = uv_2;
        param = _e96;
        metal::float4 _e97 = getFromColor(param, _from, _sampler);
        return _e97;
    }
    float _e99 = uniforms.progress;
    if (_e99 >= 1.0) {
        metal::float2 _e101 = uv_2;
        param_1 = _e101;
        metal::float4 _e102 = getToColor(param_1, _sampler, _to);
        return _e102;
    }
    float _e104 = uniforms.tileSize;
    size = metal::max(_e104, 0.008);
    float _e107 = uniforms.ratio;
    float _e109 = size;
    grid = metal::max(metal::float2(1.0, 1.0), metal::floor(metal::float2(_e107, 1.0) / metal::float2(_e109)));
    metal::float2 _e114 = uv_2;
    metal::float2 _e115 = grid;
    cell = metal::floor(_e114 * _e115);
    metal::float2 _e118 = uv_2;
    metal::float2 _e119 = grid;
    cellUV = metal::fract(_e118 * _e119);
    metal::float2 _e122 = cell;
    metal::float2 _e125 = grid;
    centerUV = (_e122 + metal::float2(0.5)) / _e125;
    float _e128 = centerUV[0u];
    float _e130 = centerUV[0u];
    float _e133 = centerUV[1u];
    float _e138 = uniforms.diagonal;
    sweep = metal::mix(_e128, (0.64 * _e130) + (0.36 * (1.0 - _e133)), metal::clamp(_e138, 0.0, 1.0));
    metal::float2 _e141 = cell;
    param_2 = _e141;
    float _e142 = toseeHash(param_2);
    noise = _e142;
    float _e143 = sweep;
    float _e145 = noise;
    start = (0.62 * _e143) + (0.07 * _e145);
    float _e149 = uniforms.progress;
    float _e150 = start;
    t = metal::clamp((_e149 - _e150) / 0.29, 0.0, 1.0);
    float _e154 = t;
    float _e156 = uniforms.scatter;
    movement = _e154 * metal::clamp(_e156, 0.0, 1.5);
    metal::float2 _e159 = cell;
    param_3 = _e159 + metal::float2(19.3, 7.7);
    float _e161 = toseeHash(param_3);
    wobble = (_e161 * 2.0) - 1.0;
    float _e164 = wobble;
    float _e167 = movement;
    drift = metal::float2(0.65 * _e164, -0.95) * _e167;
    metal::float2 _e169 = cellUV;
    metal::float2 _e170 = drift;
    movingCellUV = _e169 - _e170;
    float _e173 = movingCellUV[0u];
    float _e176 = movingCellUV[0u];
    float _e180 = movingCellUV[1u];
    float _e184 = movingCellUV[1u];
    inside = ((metal::step(0.012, _e173) * metal::step(_e176, 0.988)) * metal::step(0.012, _e180)) * metal::step(_e184, 0.988);
    float _e187 = inside;
    float _e188 = t;
    tileShape = metal::mix(1.0, _e187, metal::smoothstep(0.0, 0.13, _e188));
    float _e191 = t;
    oldVisibility = 1.0 - metal::smoothstep(0.48, 0.87, _e191);
    float _e194 = tileShape;
    float _e195 = oldVisibility;
    oldMask = _e194 * _e195;
    metal::float2 _e197 = uv_2;
    metal::float2 _e198 = drift;
    metal::float2 _e199 = grid;
    oldUV = metal::clamp(_e197 - (_e198 / _e199), metal::float2(0.0), metal::float2(1.0));
    metal::float2 _e205 = oldUV;
    param_4 = _e205;
    metal::float4 _e206 = getFromColor(param_4, _from, _sampler);
    oldColor = _e206;
    float _e207 = t;
    flare = metal::sin(3.1415927 * _e207);
    float _e211 = uniforms.prism;
    float _e213 = flare;
    shift = (metal::float2(0.006, -0.002) * _e211) * _e213;
    metal::float2 _e215 = oldUV;
    metal::float2 _e216 = shift;
    param_5 = metal::clamp(_e215 + _e216, metal::float2(0.0), metal::float2(1.0));
    metal::float4 _e221 = getFromColor(param_5, _from, _sampler);
    offsetColor = _e221;
    float _e223 = offsetColor[0u];
    oldColor[0u] = _e223;
    metal::float2 _e225 = uv_2;
    param_6 = _e225;
    metal::float4 _e226 = getToColor(param_6, _sampler, _to);
    metal::float4 _e227 = oldColor;
    float _e228 = oldMask;
    result = metal::mix(_e226, _e227, metal::float4(_e228));
    float _e232 = movingCellUV[0u];
    float _e234 = movingCellUV[0u];
    float _e238 = movingCellUV[1u];
    float _e240 = movingCellUV[1u];
    edgeDistance = metal::min(metal::min(_e232, 1.0 - _e234), metal::min(_e238, 1.0 - _e240));
    float _e244 = edgeDistance;
    float _e247 = inside;
    edge = (1.0 - metal::smoothstep(0.0, 0.1, _e244)) * _e247;
    cyan = metal::float3(0.12, 0.95, 1.0);
    pink = metal::float3(1.0, 0.2, 0.65);
    metal::float3 _e249 = cyan;
    metal::float3 _e250 = pink;
    metal::float2 _e251 = cell;
    param_7 = _e251 + metal::float2(5.4, 28.6);
    float _e253 = toseeHash(param_7);
    rimColor = metal::mix(_e249, _e250, metal::float3(_e253));
    metal::float4 _e256 = result;
    metal::float3 _e258 = rimColor;
    float _e259 = edge;
    float _e261 = flare;
    float _e264 = uniforms.glow;
    float _e266 = oldMask;
    metal::float3 _e272 = metal::clamp(_e256.xyz + (((((_e258 * _e259) * _e261) * _e264) * _e266) * 0.6), metal::float3(0.0), metal::float3(1.0));
    result[0u] = _e272.x;
    result[1u] = _e272.y;
    result[2u] = _e272.z;
    metal::float4 _e279 = result;
    return _e279;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_8 = {};
    metal::float2 _e57 = _uv_1;
    param_8 = _e57;
    metal::float4 _e58 = transition(param_8, _from, _sampler, _to, uniforms);
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
