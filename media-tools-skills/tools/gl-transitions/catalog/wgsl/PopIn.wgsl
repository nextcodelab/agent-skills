// PopIn — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/PopIn.glsl
// Author: gre
// License: MIT
// Description: The incoming image pops in as a rounded card over the outgoing one, with an elastic overshoot: too big, a bit small, then it settles into the full frame as its corners square off
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    center: vec2<f32>,
    bounce: f32,
    corner: f32,
    shadow: f32,
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

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e31 = (*uv)[0u];
    let _e33 = (*uv)[1u];
    let _e36 = textureSampleLevel(_to, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e31 = (*uv_1)[0u];
    let _e33 = (*uv_1)[1u];
    let _e36 = textureSampleLevel(_from, _sampler, vec2<f32>(_e31, (1f - _e33)), 0f);
    return _e36;
}

fn roundedBox(p: ptr<function, vec2<f32>>, b: ptr<function, vec2<f32>>, r: ptr<function, f32>) -> f32 {
    var q: vec2<f32>;

    let _e33 = (*p);
    let _e35 = (*b);
    let _e37 = (*r);
    q = ((abs(_e33) - _e35) + vec2(_e37));
    let _e40 = q;
    let _e45 = q[0u];
    let _e47 = q[1u];
    let _e51 = (*r);
    return ((length(max(_e40, vec2(0f))) + min(max(_e45, _e47), 0f)) - _e51);
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var t: f32;
    var easeOut: f32;
    var spring: f32;
    var s: f32;
    var asp: vec2<f32>;
    var side: f32;
    var cardCenter: vec2<f32>;
    var halfSize: vec2<f32>;
    var r_1: f32;
    var aa: f32;
    var d: f32;
    var param: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: f32;
    var cover: f32;
    var k: f32;
    var blur: f32;
    var offset: vec2<f32>;
    var ds: f32;
    var param_3: vec2<f32>;
    var param_4: vec2<f32>;
    var param_5: f32;
    var shade: f32;
    var a: vec4<f32>;
    var param_6: vec2<f32>;
    var b_1: vec4<f32>;
    var param_7: vec2<f32>;
    var c: vec4<f32>;
    var local: vec4<f32>;

    let _e60 = uniforms.progress;
    t = _e60;
    let _e61 = t;
    let _e63 = t;
    let _e66 = t;
    easeOut = (1f - (((1f - _e61) * (1f - _e63)) * (1f - _e66)));
    let _e70 = t;
    let _e73 = t;
    let _e77 = t;
    spring = (1f - ((exp((-1.5f * _e70)) * cos((7.8539815f * _e73))) * (1f - _e77)));
    let _e81 = easeOut;
    let _e82 = spring;
    let _e84 = uniforms.bounce;
    s = mix(_e81, _e82, _e84);
    let _e87 = uniforms.ratio;
    asp = vec2<f32>(_e87, 1f);
    let _e90 = uniforms.ratio;
    side = min(_e90, 1f);
    let _e93 = uniforms.center;
    let _e95 = uniforms.center;
    let _e98 = s;
    cardCenter = (_e93 + ((vec2(0.5f) - _e95) * _e98));
    let _e101 = s;
    let _e103 = asp;
    halfSize = (_e103 * (0.5f * _e101));
    let _e106 = uniforms.corner;
    let _e107 = s;
    let _e109 = side;
    let _e111 = t;
    r_1 = (((_e106 * _e107) * _e109) * (1f - _e111));
    aa = 0.002f;
    let _e114 = (*uv_2);
    let _e115 = cardCenter;
    let _e117 = asp;
    param = ((_e114 - _e115) * _e117);
    let _e119 = halfSize;
    param_1 = _e119;
    let _e120 = r_1;
    param_2 = _e120;
    let _e121 = roundedBox((&param), (&param_1), (&param_2));
    let _e122 = aa;
    d = (_e121 - _e122);
    let _e124 = d;
    let _e125 = aa;
    let _e129 = t;
    cover = (clamp((0.5f - (_e124 / _e125)), 0f, 1f) * smoothstep(0f, 0.08f, _e129));
    let _e132 = s;
    let _e134 = side;
    k = (min(_e132, 1f) * _e134);
    let _e136 = k;
    blur = ((0.05f * _e136) + 0.0001f);
    let _e139 = k;
    offset = vec2<f32>(0f, (-0.03f * _e139));
    let _e142 = (*uv_2);
    let _e143 = cardCenter;
    let _e145 = offset;
    let _e147 = asp;
    param_3 = (((_e142 - _e143) - _e145) * _e147);
    let _e149 = halfSize;
    param_4 = _e149;
    let _e150 = r_1;
    param_5 = _e150;
    let _e151 = roundedBox((&param_3), (&param_4), (&param_5));
    ds = _e151;
    let _e153 = uniforms.shadow;
    let _e154 = blur;
    let _e156 = blur;
    let _e157 = ds;
    let _e161 = t;
    shade = ((_e153 * (1f - smoothstep(-(_e154), _e156, _e157))) * smoothstep(0f, 0.15f, _e161));
    let _e164 = (*uv_2);
    param_6 = _e164;
    let _e165 = getFromColor((&param_6));
    a = _e165;
    let _e166 = shade;
    let _e168 = a;
    let _e170 = (_e168.xyz * (1f - _e166));
    a[0u] = _e170.x;
    a[1u] = _e170.y;
    a[2u] = _e170.z;
    let _e177 = (*uv_2);
    let _e179 = uniforms.center;
    let _e181 = s;
    let _e186 = uniforms.center;
    param_7 = clamp((((_e177 - _e179) / vec2(max(_e181, 0.0001f))) + _e186), vec2(0f), vec2(1f));
    let _e191 = getToColor((&param_7));
    b_1 = _e191;
    let _e192 = a;
    let _e195 = a[3u];
    let _e196 = (_e192.xyz * _e195);
    let _e198 = a[3u];
    let _e203 = b_1;
    let _e206 = b_1[3u];
    let _e207 = (_e203.xyz * _e206);
    let _e209 = b_1[3u];
    let _e214 = cover;
    c = mix(vec4<f32>(_e196.x, _e196.y, _e196.z, _e198), vec4<f32>(_e207.x, _e207.y, _e207.z, _e209), vec4(_e214));
    let _e218 = c[3u];
    if (_e218 > 0f) {
        let _e220 = c;
        let _e223 = c[3u];
        let _e225 = (_e220.xyz / vec3(_e223));
        let _e227 = c[3u];
        local = vec4<f32>(_e225.x, _e225.y, _e225.z, _e227);
    } else {
        local = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e232 = local;
    return _e232;
}

fn main_1() {
    var param_8: vec2<f32>;

    let _e30 = _uv_1;
    param_8 = _e30;
    let _e31 = transition((&param_8));
    _fragColor = _e31;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
