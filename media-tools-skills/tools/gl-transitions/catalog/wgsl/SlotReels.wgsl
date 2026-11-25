// SlotReels — WGSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/SlotReels.glsl
// Author: gre
// License: MIT
// Description: The frame is cut into vertical reels that spin downward like drums, motion-blurred with speed, carrying the outgoing image then the incoming one, and stop one after another from left to right with a small mechanical bounce
// Bindings and uniform layout: see the gl-transitions package README

struct Uniforms {
    progress: f32,
    ratio: f32,
    reels: i32,
    blur: f32,
    stagger: f32,
    bounce: f32,
    separator: vec4<f32>,
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

fn getFromColor(uv: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv)[0u];
    let _e56 = (*uv)[1u];
    let _e59 = textureSampleLevel(_from, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn getToColor(uv_1: ptr<function, vec2<f32>>) -> vec4<f32> {
    let _e54 = (*uv_1)[0u];
    let _e56 = (*uv_1)[1u];
    let _e59 = textureSampleLevel(_to, _sampler, vec2<f32>(_e54, (1f - _e56)), 0f);
    return _e59;
}

fn reelSpeed(t: ptr<function, f32>, stopT: ptr<function, f32>, turns: ptr<function, f32>) -> f32 {
    var amp: f32;
    var v1_: f32;
    var u: f32;
    var b: f32;

    let _e60 = uniforms.bounce;
    amp = (0.07f * _e60);
    let _e62 = amp;
    let _e64 = (*stopT);
    let _e66 = (*turns);
    v1_ = (((_e62 * 3.1415927f) * _e64) / (_e66 * 0.1f));
    let _e69 = (*t);
    let _e70 = (*stopT);
    if (_e69 < _e70) {
        let _e72 = (*t);
        let _e73 = (*stopT);
        u = max((_e72 / _e73), 0f);
        let _e76 = (*turns);
        let _e77 = u;
        let _e79 = u;
        let _e82 = v1_;
        let _e83 = u;
        let _e85 = u;
        let _e91 = (*stopT);
        return ((_e76 * (((6f * _e77) * (1f - _e79)) + ((_e82 * _e83) * ((3f * _e85) - 2f)))) / _e91);
    }
    let _e93 = (*t);
    let _e94 = (*stopT);
    b = min(((_e93 - _e94) / 0.1f), 1f);
    let _e98 = amp;
    let _e99 = b;
    let _e102 = b;
    let _e106 = b;
    let _e109 = b;
    return (((_e98 * (1f - _e99)) * (((3.1415927f * cos((3.1415927f * _e102))) * (1f - _e106)) - (2f * sin((3.1415927f * _e109))))) / 0.1f);
}

fn reelOffset(t_1: ptr<function, f32>, stopT_1: ptr<function, f32>, turns_1: ptr<function, f32>) -> f32 {
    var amp_1: f32;
    var v1_1: f32;
    var u_1: f32;
    var g: f32;
    var b_1: f32;

    let _e61 = uniforms.bounce;
    amp_1 = (0.07f * _e61);
    let _e63 = amp_1;
    let _e65 = (*stopT_1);
    let _e67 = (*turns_1);
    v1_1 = (((_e63 * 3.1415927f) * _e65) / (_e67 * 0.1f));
    let _e70 = (*t_1);
    let _e71 = (*stopT_1);
    u_1 = clamp((_e70 / _e71), 0f, 1f);
    let _e74 = u_1;
    let _e75 = u_1;
    let _e77 = u_1;
    let _e81 = v1_1;
    let _e82 = u_1;
    let _e83 = u_1;
    let _e85 = u_1;
    let _e87 = u_1;
    let _e88 = u_1;
    g = (((_e74 * _e75) * (3f - (2f * _e77))) + (_e81 * (((_e82 * _e83) * _e85) - (_e87 * _e88))));
    let _e93 = (*t_1);
    let _e94 = (*stopT_1);
    b_1 = clamp(((_e93 - _e94) / 0.1f), 0f, 1f);
    let _e98 = (*turns_1);
    let _e99 = g;
    let _e101 = amp_1;
    let _e102 = b_1;
    let _e106 = b_1;
    let _e109 = b_1;
    return ((_e98 * _e99) + (((_e101 * sin((3.1415927f * _e102))) * (1f - _e106)) * (1f - _e109)));
}

fn stopTime(i: ptr<function, f32>, n: ptr<function, f32>) -> f32 {
    var order: f32;
    var local: f32;

    let _e56 = (*n);
    if (_e56 > 1f) {
        let _e58 = (*i);
        let _e59 = (*n);
        local = (_e58 / (_e59 - 1f));
    } else {
        local = 1f;
    }
    let _e62 = local;
    order = _e62;
    let _e64 = uniforms.stagger;
    let _e66 = order;
    return (0.9f * (1f - (clamp(_e64, 0f, 0.9f) * (1f - _e66))));
}

fn transition(uv_2: ptr<function, vec2<f32>>) -> vec4<f32> {
    var n_1: f32;
    var i_1: f32;
    var lx: f32;
    var stopT_2: f32;
    var param: f32;
    var param_1: f32;
    var turns_2: f32;
    var drum: f32;
    var y: f32;
    var theta: f32;
    var v: f32;
    var depth: f32;
    var px: f32;
    var off: f32;
    var param_2: f32;
    var param_3: f32;
    var param_4: f32;
    var speed: f32;
    var param_5: f32;
    var param_6: f32;
    var param_7: f32;
    var spread: f32;
    var c: vec4<f32>;
    var wsum: f32;
    var k: i32;
    var f: f32;
    var w: f32;
    var vv: f32;
    var seg: f32;
    var q: vec2<f32>;
    var s: vec4<f32>;
    var local_1: vec4<f32>;
    var param_8: vec2<f32>;
    var param_9: vec2<f32>;
    var facing: f32;
    var env: f32;
    var reelW: f32;
    var persp: f32;
    var dSide: f32;
    var dInner: f32;
    var local_2: f32;
    var line: f32;
    var outside: f32;

    let _e97 = uniforms.reels;
    n_1 = max(f32(_e97), 1f);
    let _e101 = (*uv_2)[0u];
    let _e102 = n_1;
    let _e105 = n_1;
    i_1 = min(floor((_e101 * _e102)), (_e105 - 1f));
    let _e109 = (*uv_2)[0u];
    let _e110 = n_1;
    let _e112 = i_1;
    lx = ((_e109 * _e110) - _e112);
    let _e114 = i_1;
    param = _e114;
    let _e115 = n_1;
    param_1 = _e115;
    let _e116 = stopTime((&param), (&param_1));
    stopT_2 = _e116;
    let _e117 = stopT_2;
    turns_2 = ((2f * floor((_e117 * 4f))) + 1f);
    let _e123 = uniforms.progress;
    let _e125 = stopT_2;
    let _e126 = stopT_2;
    let _e129 = uniforms.progress;
    drum = (smoothstep(0f, 0.12f, _e123) * (1f - smoothstep(_e125, (_e126 + 0.1f), _e129)));
    let _e134 = (*uv_2)[1u];
    y = ((2f * _e134) - 1f);
    let _e137 = y;
    theta = asin(clamp((_e137 * 0.91276395f), -1f, 1f));
    let _e142 = (*uv_2)[1u];
    let _e143 = theta;
    let _e146 = drum;
    v = mix(_e142, (0.5f + (_e143 / 2.3f)), _e146);
    let _e148 = theta;
    let _e151 = drum;
    depth = ((1f - cos(_e148)) * _e151);
    let _e153 = lx;
    let _e155 = depth;
    px = (0.5f + ((_e153 - 0.5f) * (1f + (0.2f * _e155))));
    let _e161 = uniforms.progress;
    param_2 = _e161;
    let _e162 = stopT_2;
    param_3 = _e162;
    let _e163 = turns_2;
    param_4 = _e163;
    let _e164 = reelOffset((&param_2), (&param_3), (&param_4));
    let _e165 = turns_2;
    off = (_e164 - _e165);
    let _e168 = uniforms.progress;
    param_5 = _e168;
    let _e169 = stopT_2;
    param_6 = _e169;
    let _e170 = turns_2;
    param_7 = _e170;
    let _e171 = reelSpeed((&param_5), (&param_6), (&param_7));
    speed = abs(_e171);
    let _e174 = uniforms.blur;
    let _e175 = speed;
    let _e179 = drum;
    spread = ((_e174 * min((_e175 * 0.02f), 0.22f)) * _e179);
    c = vec4<f32>(0f, 0f, 0f, 0f);
    wsum = 0f;
    k = 0i;
    loop {
        let _e181 = k;
        if (_e181 < 8i) {
            let _e183 = k;
            f = ((f32(_e183) / 7f) - 0.5f);
            let _e187 = f;
            w = (1f - abs(_e187));
            let _e190 = v;
            let _e191 = off;
            let _e193 = spread;
            let _e194 = f;
            vv = ((_e190 + _e191) + (_e193 * _e194));
            let _e197 = vv;
            seg = floor(_e197);
            let _e199 = i_1;
            let _e200 = px;
            let _e203 = n_1;
            let _e205 = vv;
            let _e206 = seg;
            q = vec2<f32>(((_e199 + clamp(_e200, 0f, 1f)) / _e203), (_e205 - _e206));
            let _e209 = seg;
            if ((_e209 - (floor((_e209 / 2f)) * 2f)) < 0.5f) {
                let _e215 = q;
                param_8 = _e215;
                let _e216 = getToColor((&param_8));
                local_1 = _e216;
            } else {
                let _e217 = q;
                param_9 = _e217;
                let _e218 = getFromColor((&param_9));
                local_1 = _e218;
            }
            let _e219 = local_1;
            s = _e219;
            let _e220 = drum;
            let _e222 = y;
            let _e223 = y;
            let _e228 = q[1u];
            let _e230 = q[1u];
            let _e237 = s;
            let _e239 = (_e237.xyz * (1f - (((0.6f * _e220) * (1f - (_e222 * _e223))) * (1f - smoothstep(0f, 0.02f, min(_e228, (1f - _e230)))))));
            s[0u] = _e239.x;
            s[1u] = _e239.y;
            s[2u] = _e239.z;
            let _e246 = w;
            let _e247 = s;
            let _e249 = c;
            c = (_e249 + (_e247 * _e246));
            let _e251 = w;
            let _e252 = wsum;
            wsum = (_e252 + _e251);
            let _e254 = spread;
            if (_e254 < 0.0001f) {
                break;
            }
            continue;
        } else {
            break;
        }
        continuing {
            let _e256 = k;
            k = (_e256 + 1i);
        }
    }
    let _e258 = wsum;
    let _e259 = c;
    c = (_e259 / vec4(_e258));
    let _e262 = theta;
    facing = cos(_e262);
    let _e264 = facing;
    let _e266 = facing;
    let _e269 = drum;
    let _e271 = c;
    let _e273 = (_e271.xyz * mix(1f, (0.25f + ((0.75f * _e264) * _e266)), _e269));
    c[0u] = _e273.x;
    c[1u] = _e273.y;
    c[2u] = _e273.z;
    let _e280 = drum;
    let _e283 = c[3u];
    let _e285 = y;
    let _e288 = y;
    let _e293 = c;
    let _e296 = (_e293.xyz + vec3((((_e280 * 0.07f) * _e283) * exp(((-12f * (_e285 - 0.3f)) * (_e288 - 0.3f))))));
    c[0u] = _e296.x;
    c[1u] = _e296.y;
    c[2u] = _e296.z;
    let _e304 = uniforms.progress;
    let _e307 = uniforms.progress;
    env = (smoothstep(0f, 0.1f, _e304) * (1f - smoothstep(0.9f, 1f, _e307)));
    let _e312 = uniforms.ratio;
    let _e313 = n_1;
    reelW = (_e312 / _e313);
    let _e315 = reelW;
    let _e316 = depth;
    persp = (_e315 / (1f + (0.2f * _e316)));
    let _e320 = px;
    let _e321 = px;
    let _e324 = persp;
    dSide = (min(_e320, (1f - _e321)) * _e324);
    let _e326 = i_1;
    let _e328 = px;
    let _e330 = i_1;
    let _e331 = n_1;
    if (_e330 < (_e331 - 1.5f)) {
        let _e334 = px;
        local_2 = (1f - _e334);
    } else {
        local_2 = 2f;
    }
    let _e336 = local_2;
    let _e338 = persp;
    dInner = (min(select(2f, _e328, (_e326 > 0.5f)), _e336) * _e338);
    let _e340 = dInner;
    line = (1f - smoothstep(0.0015f, 0.0045f, _e340));
    let _e343 = dSide;
    outside = (1f - smoothstep(-0.0015f, 0f, _e343));
    let _e346 = env;
    let _e348 = reelW;
    let _e351 = dInner;
    let _e356 = c;
    let _e358 = (_e356.xyz * (1f - ((0.35f * _e346) * (1f - smoothstep(0f, ((0.03f * _e348) + 0.006f), _e351)))));
    c[0u] = _e358.x;
    c[1u] = _e358.y;
    c[2u] = _e358.z;
    let _e365 = c;
    let _e367 = uniforms.separator;
    let _e368 = line;
    let _e369 = env;
    let _e371 = outside;
    return mix(_e365, _e367, vec4(max((_e368 * _e369), _e371)));
}

fn main_1() {
    var param_10: vec2<f32>;

    let _e53 = _uv_1;
    param_10 = _e53;
    let _e54 = transition((&param_10));
    _fragColor = _e54;
    return;
}

@fragment 
fn main(@location(0) _uv: vec2<f32>) -> @location(0) vec4<f32> {
    _uv_1 = _uv;
    main_1();
    let _e3 = _fragColor;
    return _e3;
}
