// BloomDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/BloomDissolve.glsl
// Author: gre
// License: MIT
// Description: The highlights of the outgoing image blow out into a soft, wide glow that floods the frame; under it the incoming image takes over, then the glow subsides back into its highlights while the image stays sharp
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    spread: f32,
    threshold: f32,
    intensity: f32,
    tint: vec3<f32>,
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

fn glow(c: ptr<function, vec4<f32>>, knee: ptr<function, f32>) -> vec3<f32> {
    var lum: f32;

    let _e47 = (*c);
    lum = dot(_e47.xyz, vec3<f32>(0.2126f, 0.7152f, 0.0722f));
    let _e50 = (*c);
    let _e52 = (*knee);
    let _e53 = (*knee);
    let _e54 = (*knee);
    let _e59 = lum;
    return (_e50.xyz * smoothstep(_e52, (_e53 + max((0.3f * (1f - _e54)), 0.001f)), _e59));
}

fn mirror(v: ptr<function, vec2<f32>>) -> vec2<f32> {
    let _e45 = (*v);
    let _e46 = vec2(2f);
    return (vec2(1f) - abs((vec2(1f) - (_e45 - (floor((_e45 / _e46)) * _e46)))));
}

fn hash12(v_1: ptr<function, vec2<f32>>) -> f32 {
    var v3_: vec3<f32>;

    let _e46 = (*v_1);
    v3_ = fract((_e46.xyx * 0.1031f));
    let _e50 = v3_;
    let _e51 = v3_;
    let _e56 = v3_;
    v3_ = (_e56 + vec3(dot(_e50, (_e51.yzx + vec3(33.33f)))));
    let _e60 = v3_[0u];
    let _e62 = v3_[1u];
    let _e65 = v3_[2u];
    return fract(((_e60 + _e62) * _e65));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv)[0u];
    let _e48 = (*uv)[1u];
    let _e51 = textureSampleLevel(_to, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e46 = (*uv_1)[0u];
    let _e48 = (*uv_1)[1u];
    let _e51 = textureSampleLevel(_from, _sampler, vec2<f32>(_e46, (1f - _e48)), 0f);
    return _e51;
}

fn image(st: ptr<function, vec2<f32>>, m: ptr<function, f32>) -> vec4<f32> {
    var c_1: vec4<f32>;
    var param: vec2<f32>;
    var c_2: vec4<f32>;
    var param_1: vec2<f32>;
    var a: vec4<f32>;
    var param_2: vec2<f32>;
    var b: vec4<f32>;
    var param_3: vec2<f32>;

    let _e54 = (*m);
    if (_e54 <= 0f) {
        let _e56 = (*st);
        param = _e56;
        let _e57 = getFromColor((&param));
        c_1 = _e57;
        let _e58 = c_1;
        let _e61 = c_1[3u];
        let _e62 = (_e58.xyz * _e61);
        let _e64 = c_1[3u];
        return vec4<f32>(_e62.x, _e62.y, _e62.z, _e64);
    }
    let _e69 = (*m);
    if (_e69 >= 1f) {
        let _e71 = (*st);
        param_1 = _e71;
        let _e72 = getToColor((&param_1));
        c_2 = _e72;
        let _e73 = c_2;
        let _e76 = c_2[3u];
        let _e77 = (_e73.xyz * _e76);
        let _e79 = c_2[3u];
        return vec4<f32>(_e77.x, _e77.y, _e77.z, _e79);
    }
    let _e84 = (*st);
    param_2 = _e84;
    let _e85 = getFromColor((&param_2));
    a = _e85;
    let _e86 = (*st);
    param_3 = _e86;
    let _e87 = getToColor((&param_3));
    b = _e87;
    let _e88 = a;
    let _e91 = a[3u];
    let _e92 = (_e88.xyz * _e91);
    let _e94 = a[3u];
    let _e99 = b;
    let _e102 = b[3u];
    let _e103 = (_e99.xyz * _e102);
    let _e105 = b[3u];
    let _e110 = (*m);
    return mix(vec4<f32>(_e92.x, _e92.y, _e92.z, _e94), vec4<f32>(_e103.x, _e103.y, _e103.z, _e105), vec4(_e110));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var p: f32;
    var amount: f32;
    var peak: f32;
    var flood: f32;
    var m_1: f32;
    var local: vec4<f32>;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var c_3: vec4<f32>;
    var param_6: vec2<f32>;
    var param_7: f32;
    var knee_1: f32;
    var radius: f32;
    var cell: vec2<f32>;
    var spin: f32;
    var param_8: vec2<f32>;
    var shift: f32;
    var param_9: vec2<f32>;
    var bloom: vec3<f32>;
    var soft: vec4<f32>;
    var total: f32;
    var i: i32;
    var s: f32;
    var r: f32;
    var a_1: f32;
    var offset: vec2<f32>;
    var i0_: vec4<f32>;
    var param_10: vec2<f32>;
    var param_11: vec2<f32>;
    var param_12: f32;
    var i1_: vec4<f32>;
    var param_13: vec2<f32>;
    var param_14: vec2<f32>;
    var param_15: f32;
    var l: vec3<f32>;
    var param_16: vec4<f32>;
    var param_17: f32;
    var param_18: vec4<f32>;
    var param_19: f32;
    var w: f32;
    var sw: f32;
    var blurred: vec3<f32>;
    var local_1: vec3<f32>;
    var base: vec3<f32>;

    let _e90 = uniforms.progress;
    p = _e90;
    let _e91 = p;
    let _e93 = p;
    amount = ((4f * _e91) * (1f - _e93));
    let _e96 = amount;
    let _e97 = amount;
    peak = (_e96 * _e97);
    let _e99 = peak;
    let _e100 = peak;
    let _e102 = peak;
    flood = ((_e99 * _e100) * _e102);
    let _e104 = p;
    m_1 = smoothstep(0.44f, 0.56f, _e104);
    let _e106 = amount;
    if (_e106 <= 0f) {
        let _e108 = m_1;
        if (_e108 < 0.5f) {
            let _e110 = (*uv_2);
            param_4 = _e110;
            let _e111 = getFromColor((&param_4));
            local = _e111;
        } else {
            let _e112 = (*uv_2);
            param_5 = _e112;
            let _e113 = getToColor((&param_5));
            local = _e113;
        }
        let _e114 = local;
        return _e114;
    }
    let _e115 = (*uv_2);
    param_6 = _e115;
    let _e116 = m_1;
    param_7 = _e116;
    let _e117 = image((&param_6), (&param_7));
    c_3 = _e117;
    let _e119 = c_3[3u];
    if (_e119 <= 0f) {
        return vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e122 = c_3[3u];
    let _e123 = c_3;
    let _e126 = (_e123.xyz / vec3(_e122));
    c_3[0u] = _e126.x;
    c_3[1u] = _e126.y;
    c_3[2u] = _e126.z;
    let _e134 = uniforms.threshold;
    let _e135 = peak;
    let _e139 = flood;
    knee_1 = ((_e134 * (1f - (0.3f * _e135))) * (1f - _e139));
    let _e143 = uniforms.spread;
    let _e144 = amount;
    radius = (_e143 * _e144);
    let _e146 = (*uv_2);
    let _e148 = uniforms.ratio;
    cell = floor(((_e146 * vec2<f32>(_e148, 1f)) * 997f));
    let _e153 = cell;
    param_8 = _e153;
    let _e154 = hash12((&param_8));
    spin = (6.2831855f * _e154);
    let _e156 = cell;
    param_9 = (_e156 + vec2(71f));
    let _e159 = hash12((&param_9));
    shift = _e159;
    bloom = vec3<f32>(0f, 0f, 0f);
    soft = vec4<f32>(0f, 0f, 0f, 0f);
    total = 0f;
    i = 0i;
    loop {
        let _e160 = i;
        if (_e160 < 10i) {
            let _e162 = i;
            let _e164 = shift;
            s = ((f32(_e162) + _e164) / 10f);
            let _e167 = s;
            let _e168 = s;
            r = (_e167 * _e168);
            let _e170 = i;
            let _e173 = spin;
            a_1 = ((f32(_e170) * 2.399963f) + _e173);
            let _e175 = radius;
            let _e176 = r;
            let _e178 = a_1;
            let _e181 = uniforms.ratio;
            let _e183 = a_1;
            offset = (vec2<f32>((cos(_e178) / _e181), sin(_e183)) * (_e175 * _e176));
            let _e187 = (*uv_2);
            let _e188 = offset;
            param_10 = (_e187 + _e188);
            let _e190 = mirror((&param_10));
            param_11 = _e190;
            let _e191 = m_1;
            param_12 = _e191;
            let _e192 = image((&param_11), (&param_12));
            i0_ = _e192;
            let _e193 = (*uv_2);
            let _e194 = offset;
            param_13 = (_e193 - _e194);
            let _e196 = mirror((&param_13));
            param_14 = _e196;
            let _e197 = m_1;
            param_15 = _e197;
            let _e198 = image((&param_14), (&param_15));
            i1_ = _e198;
            let _e199 = i0_;
            param_16 = _e199;
            let _e200 = knee_1;
            param_17 = _e200;
            let _e201 = glow((&param_16), (&param_17));
            let _e202 = i1_;
            param_18 = _e202;
            let _e203 = knee_1;
            param_19 = _e203;
            let _e204 = glow((&param_18), (&param_19));
            l = (_e201 + _e204);
            let _e206 = s;
            w = (1f - (0.75f * _e206));
            let _e209 = w;
            let _e211 = uniforms.tint;
            let _e212 = r;
            let _e217 = l;
            let _e219 = bloom;
            bloom = (_e219 + ((mix(vec3<f32>(1f, 1f, 1f), _e211, vec3(smoothstep(0f, 0.5f, _e212))) * _e209) * _e217));
            let _e221 = w;
            let _e222 = total;
            total = (_e222 + _e221);
            let _e224 = s;
            let _e226 = s;
            sw = ((1f - _e224) * (1f - _e226));
            let _e229 = sw;
            let _e230 = i0_;
            let _e231 = i1_;
            let _e234 = soft;
            soft = (_e234 + ((_e230 + _e231) * _e229));
            continue;
        } else {
            break;
        }
        continuing {
            let _e236 = i;
            i = (_e236 + 1i);
        }
    }
    let _e238 = total;
    let _e240 = bloom;
    bloom = (_e240 / vec3((2f * _e238)));
    let _e244 = soft[3u];
    if (_e244 > 0f) {
        let _e246 = soft;
        let _e249 = soft[3u];
        local_1 = (_e246.xyz / vec3(_e249));
    } else {
        let _e252 = c_3;
        local_1 = _e252.xyz;
    }
    let _e254 = local_1;
    blurred = _e254;
    let _e255 = c_3;
    let _e257 = blurred;
    let _e258 = flood;
    base = mix(_e255.xyz, _e257, vec3((0.7f * _e258)));
    let _e263 = uniforms.intensity;
    let _e264 = peak;
    let _e266 = flood;
    let _e270 = bloom;
    bloom = (_e270 * ((_e263 * _e264) * (1f + (2f * _e266))));
    let _e272 = bloom;
    bloom = ((vec3(1f) - exp(-(_e272))) * 0.92f);
    let _e278 = base;
    let _e279 = peak;
    base = min((_e278 * (1f + (0.25f * _e279))), vec3(1f));
    let _e285 = base;
    let _e286 = bloom;
    let _e288 = base;
    let _e289 = bloom;
    let _e291 = ((_e285 + _e286) - (_e288 * _e289));
    let _e293 = c_3[3u];
    return vec4<f32>(_e291.x, _e291.y, _e291.z, _e293);
}

fn main_1() {
    var param_20: vec2<f32>;

    let _e45 = _uv_1;
    param_20 = _e45;
    let _e46 = transition((&param_20));
    _fragColor = _e46;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
