// CellDissolve — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CellDissolve.glsl
// Author: gre
// License: MIT
// Description: Irregular cells, like cracked mud or soap foam, switch to the incoming image one by one, with an optional bright border glowing along the cracks between them
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    cells: f32,
    smoothness: f32,
    border: f32,
    borderColor: vec4<f32>,
    seed: f32,
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

fn hash22(p: ptr<function, vec2<f32>>) -> vec2<f32> {
    var p3_: vec3<f32>;

    let _e40 = (*p);
    p3_ = fract((_e40.xyx * vec3<f32>(0.1031f, 0.103f, 0.0973f)));
    let _e44 = p3_;
    let _e45 = p3_;
    let _e50 = p3_;
    p3_ = (_e50 + vec3(dot(_e44, (_e45.yzx + vec3(33.33f)))));
    let _e53 = p3_;
    let _e55 = p3_;
    let _e58 = p3_;
    return fract(((_e53.xx + _e55.yz) * _e58.zy));
}

fn getToColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e40 = (*uv)[0u];
    let _e42 = (*uv)[1u];
    let _e45 = textureSampleLevel(_to, _sampler, vec2<f32>(_e40, (1f - _e42)), 0f);
    return _e45;
}

fn getFromColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e40 = (*uv_1)[0u];
    let _e42 = (*uv_1)[1u];
    let _e45 = textureSampleLevel(_from, _sampler, vec2<f32>(_e40, (1f - _e42)), 0f);
    return _e45;
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var a: vec4<f32>;
    var param: vec2<f32>;
    var b: vec4<f32>;
    var param_1: vec2<f32>;
    var n: f32;
    var p_1: vec2<f32>;
    var i: vec2<f32>;
    var f: vec2<f32>;
    var offset: vec2<f32>;
    var mg: vec2<f32>;
    var mr: vec2<f32>;
    var md: f32;
    var y: i32;
    var x: i32;
    var g: vec2<f32>;
    var r: vec2<f32>;
    var param_2: vec2<f32>;
    var d: f32;
    var edge: f32;
    var y_1: i32;
    var x_1: i32;
    var g_1: vec2<f32>;
    var r_1: vec2<f32>;
    var param_3: vec2<f32>;
    var dr: vec2<f32>;
    var h: f32;
    var param_4: vec2<f32>;
    var w: f32;
    var start: f32;
    var m: f32;
    var local: f32;
    var c: vec4<f32>;
    var open: f32;
    var bw: f32;
    var l: f32;
    var ba: f32;
    var local_1: vec4<f32>;

    let _e76 = (*uv_2);
    param = _e76;
    let _e77 = getFromColor((&param));
    a = _e77;
    let _e78 = (*uv_2);
    param_1 = _e78;
    let _e79 = getToColor((&param_1));
    b = _e79;
    let _e81 = uniforms.progress;
    if (_e81 <= 0f) {
        let _e83 = a;
        return _e83;
    }
    let _e85 = uniforms.progress;
    if (_e85 >= 1f) {
        let _e87 = b;
        return _e87;
    }
    let _e89 = uniforms.cells;
    n = max(_e89, 1f);
    let _e91 = (*uv_2);
    let _e93 = uniforms.ratio;
    let _e96 = n;
    p_1 = ((_e91 * vec2<f32>(_e93, 1f)) * _e96);
    let _e98 = p_1;
    i = floor(_e98);
    let _e100 = p_1;
    let _e101 = i;
    f = (_e100 - _e101);
    let _e104 = uniforms.seed;
    offset = (vec2<f32>(17.31f, 41.97f) * _e104);
    mg = vec2<f32>(0f, 0f);
    mr = vec2<f32>(0f, 0f);
    md = 8f;
    y = -1i;
    loop {
        let _e106 = y;
        if (_e106 <= 1i) {
            x = -1i;
            loop {
                let _e108 = x;
                if (_e108 <= 1i) {
                    let _e110 = x;
                    let _e112 = y;
                    g = vec2<f32>(f32(_e110), f32(_e112));
                    let _e115 = g;
                    let _e116 = i;
                    let _e117 = g;
                    let _e119 = offset;
                    param_2 = ((_e116 + _e117) + _e119);
                    let _e121 = hash22((&param_2));
                    let _e123 = f;
                    r = ((_e115 + _e121) - _e123);
                    let _e125 = r;
                    let _e126 = r;
                    d = dot(_e125, _e126);
                    let _e128 = d;
                    let _e129 = md;
                    if (_e128 < _e129) {
                        let _e131 = d;
                        md = _e131;
                        let _e132 = r;
                        mr = _e132;
                        let _e133 = g;
                        mg = _e133;
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e134 = x;
                    x = (_e134 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e136 = y;
            y = (_e136 + 1i);
        }
    }
    edge = 8f;
    y_1 = -2i;
    loop {
        let _e138 = y_1;
        if (_e138 <= 2i) {
            x_1 = -2i;
            loop {
                let _e140 = x_1;
                if (_e140 <= 2i) {
                    let _e142 = mg;
                    let _e143 = x_1;
                    let _e145 = y_1;
                    g_1 = (_e142 + vec2<f32>(f32(_e143), f32(_e145)));
                    let _e149 = g_1;
                    let _e150 = i;
                    let _e151 = g_1;
                    let _e153 = offset;
                    param_3 = ((_e150 + _e151) + _e153);
                    let _e155 = hash22((&param_3));
                    let _e157 = f;
                    r_1 = ((_e149 + _e155) - _e157);
                    let _e159 = r_1;
                    let _e160 = mr;
                    dr = (_e159 - _e160);
                    let _e162 = dr;
                    let _e163 = dr;
                    if (dot(_e162, _e163) > 0.00001f) {
                        let _e166 = edge;
                        let _e167 = mr;
                        let _e168 = r_1;
                        let _e171 = dr;
                        edge = min(_e166, dot(((_e167 + _e168) * 0.5f), normalize(_e171)));
                    }
                    continue;
                } else {
                    break;
                }
                continuing {
                    let _e175 = x_1;
                    x_1 = (_e175 + 1i);
                }
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e177 = y_1;
            y_1 = (_e177 + 1i);
        }
    }
    let _e179 = n;
    let _e180 = edge;
    edge = (_e180 / _e179);
    let _e182 = i;
    let _e183 = mg;
    let _e185 = offset;
    param_4 = (((_e182 + _e183) + _e185) + vec2(97.13f));
    let _e189 = hash22((&param_4));
    h = _e189.x;
    let _e192 = uniforms.smoothness;
    w = clamp(_e192, 0f, 1f);
    let _e194 = h;
    let _e195 = w;
    start = (_e194 * (1f - _e195));
    let _e198 = w;
    if (_e198 > 0f) {
        let _e200 = start;
        let _e201 = start;
        let _e202 = w;
        let _e205 = uniforms.progress;
        local = smoothstep(_e200, (_e201 + _e202), _e205);
    } else {
        let _e207 = start;
        let _e209 = uniforms.progress;
        local = step(_e207, _e209);
    }
    let _e211 = local;
    m = _e211;
    let _e212 = a;
    let _e215 = a[3u];
    let _e216 = (_e212.xyz * _e215);
    let _e218 = a[3u];
    let _e223 = b;
    let _e226 = b[3u];
    let _e227 = (_e223.xyz * _e226);
    let _e229 = b[3u];
    let _e234 = m;
    c = mix(vec4<f32>(_e216.x, _e216.y, _e216.z, _e218), vec4<f32>(_e227.x, _e227.y, _e227.z, _e229), vec4(_e234));
    let _e238 = uniforms.progress;
    let _e241 = uniforms.progress;
    open = (smoothstep(0f, 0.2f, _e238) * (1f - smoothstep(0.8f, 1f, _e241)));
    let _e246 = uniforms.border;
    let _e248 = open;
    bw = (max(_e246, 0f) * _e248);
    let _e250 = bw;
    if (_e250 > 0f) {
        let _e252 = bw;
        let _e255 = bw;
        let _e258 = edge;
        l = (1f - smoothstep(((0.5f * _e252) - 0.0015f), ((0.5f * _e255) + 0.0015f), _e258));
        let _e263 = uniforms.borderColor[3u];
        let _e264 = l;
        let _e266 = bw;
        ba = ((_e263 * _e264) * min(1f, (_e266 / 0.003f)));
        let _e271 = uniforms.borderColor;
        let _e273 = ba;
        let _e274 = (_e271.xyz * _e273);
        let _e275 = ba;
        let _e280 = c;
        let _e281 = ba;
        c = (vec4<f32>(_e274.x, _e274.y, _e274.z, _e275) + (_e280 * (1f - _e281)));
    }
    let _e286 = c[3u];
    if (_e286 > 0f) {
        let _e288 = c;
        let _e291 = c[3u];
        let _e293 = (_e288.xyz / vec3(_e291));
        let _e295 = c[3u];
        local_1 = vec4<f32>(_e293.x, _e293.y, _e293.z, _e295);
    } else {
        local_1 = vec4<f32>(0f, 0f, 0f, 0f);
    }
    let _e300 = local_1;
    return _e300;
}

fn main_1() {
    var param_5: vec2<f32>;

    let _e39 = _uv_1;
    param_5 = _e39;
    let _e40 = transition((&param_5));
    _fragColor = _e40;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
