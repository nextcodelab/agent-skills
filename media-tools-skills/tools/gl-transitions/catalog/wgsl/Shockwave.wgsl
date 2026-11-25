// Shockwave — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/Shockwave.glsl
// Author: Gilad Levi, github @Giladx
// License: MIT
// Description: A diagonal shockwave breaks the outgoing image into tiny falling glass tiles. Each tile slips away with a brief chromatic split and neon edge glow, revealing the incoming image beneath it.
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    tileSize: f32,
    scatter: f32,
    diagonal: f32,
    prism: f32,
    glow: f32,
}

@group(0) @binding(2) 
var _from: texture_2d<f32>;
@group(0) @binding(1) 
var _sampler: sampler;
@group(0) @binding(3) 
var _to: texture_2d<f32>;
@group(0) @binding(0) 
var<uniform> uniforms: Uniforms;
var<private> _fragColor: vec4<f32>;
var<private> _uv_1: vec2<f32>;

fn toseeHash(p: ptr<function, vec2<f32>>) -> f32 {
    let _e57 = (*p);
    return fract((sin(dot(_e57, vec2<f32>(127.1f, 311.7f))) * 43758.547f));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e58 = (*uv)[0u];
    let _e60 = (*uv)[1u];
    let _e63 = textureSampleLevel(_to, _sampler, vec2<f32>(_e58, (1f - _e60)), 0f);
    return _e63;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e58 = (*uv_1)[0u];
    let _e60 = (*uv_1)[1u];
    let _e63 = textureSampleLevel(_from, _sampler, vec2<f32>(_e58, (1f - _e60)), 0f);
    return _e63;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var size: f32;
    var grid: vec2<f32>;
    var cell: vec2<f32>;
    var cellUV: vec2<f32>;
    var centerUV: vec2<f32>;
    var sweep: f32;
    var noise: f32;
    var param_2: vec2<f32>;
    var start: f32;
    var t: f32;
    var movement: f32;
    var wobble: f32;
    var param_3: vec2<f32>;
    var drift: vec2<f32>;
    var movingCellUV: vec2<f32>;
    var inside: f32;
    var tileShape: f32;
    var oldVisibility: f32;
    var oldMask: f32;
    var oldUV: vec2<f32>;
    var oldColor: vec4<f32>;
    var param_4: vec2<f32>;
    var flare: f32;
    var shift: vec2<f32>;
    var offsetColor: vec4<f32>;
    var param_5: vec2<f32>;
    var result: vec4<f32>;
    var param_6: vec2<f32>;
    var edgeDistance: f32;
    var edge: f32;
    var cyan: vec3<f32>;
    var pink: vec3<f32>;
    var rimColor: vec3<f32>;
    var param_7: vec2<f32>;

    let _e94 = uniforms.progress;
    if (_e94 <= 0f) {
        let _e96 = (*uv_2);
        param = _e96;
        let _e97 = getFromColor((&param));
        return _e97;
    }
    let _e99 = uniforms.progress;
    if (_e99 >= 1f) {
        let _e101 = (*uv_2);
        param_1 = _e101;
        let _e102 = getToColor((&param_1));
        return _e102;
    }
    let _e104 = uniforms.tileSize;
    size = max(_e104, 0.008f);
    let _e107 = uniforms.ratio;
    let _e109 = size;
    grid = max(vec2<f32>(1f, 1f), floor((vec2<f32>(_e107, 1f) / vec2(_e109))));
    let _e114 = (*uv_2);
    let _e115 = grid;
    cell = floor((_e114 * _e115));
    let _e118 = (*uv_2);
    let _e119 = grid;
    cellUV = fract((_e118 * _e119));
    let _e122 = cell;
    let _e125 = grid;
    centerUV = ((_e122 + vec2(0.5f)) / _e125);
    let _e128 = centerUV[0u];
    let _e130 = centerUV[0u];
    let _e133 = centerUV[1u];
    let _e138 = uniforms.diagonal;
    sweep = mix(_e128, ((0.64f * _e130) + (0.36f * (1f - _e133))), clamp(_e138, 0f, 1f));
    let _e141 = cell;
    param_2 = _e141;
    let _e142 = toseeHash((&param_2));
    noise = _e142;
    let _e143 = sweep;
    let _e145 = noise;
    start = ((0.62f * _e143) + (0.07f * _e145));
    let _e149 = uniforms.progress;
    let _e150 = start;
    t = clamp(((_e149 - _e150) / 0.29f), 0f, 1f);
    let _e154 = t;
    let _e156 = uniforms.scatter;
    movement = (_e154 * clamp(_e156, 0f, 1.5f));
    let _e159 = cell;
    param_3 = (_e159 + vec2<f32>(19.3f, 7.7f));
    let _e161 = toseeHash((&param_3));
    wobble = ((_e161 * 2f) - 1f);
    let _e164 = wobble;
    let _e167 = movement;
    drift = (vec2<f32>((0.65f * _e164), -0.95f) * _e167);
    let _e169 = cellUV;
    let _e170 = drift;
    movingCellUV = (_e169 - _e170);
    let _e173 = movingCellUV[0u];
    let _e176 = movingCellUV[0u];
    let _e180 = movingCellUV[1u];
    let _e184 = movingCellUV[1u];
    inside = (((step(0.012f, _e173) * step(_e176, 0.988f)) * step(0.012f, _e180)) * step(_e184, 0.988f));
    let _e187 = inside;
    let _e188 = t;
    tileShape = mix(1f, _e187, smoothstep(0f, 0.13f, _e188));
    let _e191 = t;
    oldVisibility = (1f - smoothstep(0.48f, 0.87f, _e191));
    let _e194 = tileShape;
    let _e195 = oldVisibility;
    oldMask = (_e194 * _e195);
    let _e197 = (*uv_2);
    let _e198 = drift;
    let _e199 = grid;
    oldUV = clamp((_e197 - (_e198 / _e199)), vec2(0f), vec2(1f));
    let _e205 = oldUV;
    param_4 = _e205;
    let _e206 = getFromColor((&param_4));
    oldColor = _e206;
    let _e207 = t;
    flare = sin((3.1415927f * _e207));
    let _e211 = uniforms.prism;
    let _e213 = flare;
    shift = ((vec2<f32>(0.006f, -0.002f) * _e211) * _e213);
    let _e215 = oldUV;
    let _e216 = shift;
    param_5 = clamp((_e215 + _e216), vec2(0f), vec2(1f));
    let _e221 = getFromColor((&param_5));
    offsetColor = _e221;
    let _e223 = offsetColor[0u];
    oldColor[0u] = _e223;
    let _e225 = (*uv_2);
    param_6 = _e225;
    let _e226 = getToColor((&param_6));
    let _e227 = oldColor;
    let _e228 = oldMask;
    result = mix(_e226, _e227, vec4(_e228));
    let _e232 = movingCellUV[0u];
    let _e234 = movingCellUV[0u];
    let _e238 = movingCellUV[1u];
    let _e240 = movingCellUV[1u];
    edgeDistance = min(min(_e232, (1f - _e234)), min(_e238, (1f - _e240)));
    let _e244 = edgeDistance;
    let _e247 = inside;
    edge = ((1f - smoothstep(0f, 0.1f, _e244)) * _e247);
    cyan = vec3<f32>(0.12f, 0.95f, 1f);
    pink = vec3<f32>(1f, 0.2f, 0.65f);
    let _e249 = cyan;
    let _e250 = pink;
    let _e251 = cell;
    param_7 = (_e251 + vec2<f32>(5.4f, 28.6f));
    let _e253 = toseeHash((&param_7));
    rimColor = mix(_e249, _e250, vec3(_e253));
    let _e256 = result;
    let _e258 = rimColor;
    let _e259 = edge;
    let _e261 = flare;
    let _e264 = uniforms.glow;
    let _e266 = oldMask;
    let _e272 = clamp((_e256.xyz + (((((_e258 * _e259) * _e261) * _e264) * _e266) * 0.6f)), vec3(0f), vec3(1f));
    result[0u] = _e272.x;
    result[1u] = _e272.y;
    result[2u] = _e272.z;
    let _e279 = result;
    return _e279;
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e57 = _uv_1;
    param_8 = _e57;
    let _e58 = transition((&param_8));
    _fragColor = _e58;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
