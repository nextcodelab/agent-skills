// CellDissolve — MSL, generated from https://github.com/gl-transitions/gl-transitions/blob/master/transitions/CellDissolve.glsl
// Author: gre
// License: MIT
// Description: Irregular cells, like cracked mud or soap foam, switch to the incoming image one by one, with an optional bright border glowing along the cracks between them
// Bindings and uniform layout: see the gl-transitions package README

// language: metal1.0
#include <metal_stdlib>
#include <simd/simd.h>

using metal::uint;

struct Uniforms {
    float progress;
    float ratio;
    float cells;
    float smoothness;
    float border;
    char _pad5[12];
    metal::float4 borderColor;
    float seed;
    char _pad7[12];
};

metal::float2 hash22(
    thread metal::float2& p
) {
    metal::float3 p3_ = {};
    metal::float2 _e40 = p;
    p3_ = metal::fract(_e40.xyx * metal::float3(0.1031, 0.103, 0.0973));
    metal::float3 _e44 = p3_;
    metal::float3 _e45 = p3_;
    metal::float3 _e50 = p3_;
    p3_ = _e50 + metal::float3(metal::dot(_e44, _e45.yzx + metal::float3(33.33)));
    metal::float3 _e53 = p3_;
    metal::float3 _e55 = p3_;
    metal::float3 _e58 = p3_;
    return metal::fract((_e53.xx + _e55.yz) * _e58.zy);
}

metal::float4 getToColor(
    thread metal::float2& uv,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to
) {
    float _e40 = uv[0u];
    float _e42 = uv[1u];
    metal::float4 _e45 = _to.sample(_sampler, metal::float2(_e40, 1.0 - _e42), metal::level(0.0));
    return _e45;
}

metal::float4 getFromColor(
    thread metal::float2& uv_1,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler
) {
    float _e40 = uv_1[0u];
    float _e42 = uv_1[1u];
    metal::float4 _e45 = _from.sample(_sampler, metal::float2(_e40, 1.0 - _e42), metal::level(0.0));
    return _e45;
}

metal::float4 transition(
    thread metal::float2& uv_2,
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms
) {
    metal::float4 a = {};
    metal::float2 param = {};
    metal::float4 b = {};
    metal::float2 param_1 = {};
    float n = {};
    metal::float2 p_1 = {};
    metal::float2 i = {};
    metal::float2 f = {};
    metal::float2 offset = {};
    metal::float2 mg = {};
    metal::float2 mr = {};
    float md = {};
    int y = {};
    int x = {};
    metal::float2 g = {};
    metal::float2 r = {};
    metal::float2 param_2 = {};
    float d = {};
    float edge = {};
    int y_1 = {};
    int x_1 = {};
    metal::float2 g_1 = {};
    metal::float2 r_1 = {};
    metal::float2 param_3 = {};
    metal::float2 dr = {};
    float h = {};
    metal::float2 param_4 = {};
    float w = {};
    float start = {};
    float m = {};
    float local = {};
    metal::float4 c = {};
    float open = {};
    float bw = {};
    float l = {};
    float ba = {};
    metal::float4 local_1 = {};
    metal::float2 _e76 = uv_2;
    param = _e76;
    metal::float4 _e77 = getFromColor(param, _from, _sampler);
    a = _e77;
    metal::float2 _e78 = uv_2;
    param_1 = _e78;
    metal::float4 _e79 = getToColor(param_1, _sampler, _to);
    b = _e79;
    float _e81 = uniforms.progress;
    if (_e81 <= 0.0) {
        metal::float4 _e83 = a;
        return _e83;
    }
    float _e85 = uniforms.progress;
    if (_e85 >= 1.0) {
        metal::float4 _e87 = b;
        return _e87;
    }
    float _e89 = uniforms.cells;
    n = metal::max(_e89, 1.0);
    metal::float2 _e91 = uv_2;
    float _e93 = uniforms.ratio;
    float _e96 = n;
    p_1 = (_e91 * metal::float2(_e93, 1.0)) * _e96;
    metal::float2 _e98 = p_1;
    i = metal::floor(_e98);
    metal::float2 _e100 = p_1;
    metal::float2 _e101 = i;
    f = _e100 - _e101;
    float _e104 = uniforms.seed;
    offset = metal::float2(17.31, 41.97) * _e104;
    mg = metal::float2(0.0, 0.0);
    mr = metal::float2(0.0, 0.0);
    md = 8.0;
    y = -1;
    uint2 loop_bound = uint2(4294967295u);
    bool loop_init = true;
    while(true) {
        if (metal::all(loop_bound == uint2(0u))) { break; }
        loop_bound -= uint2(loop_bound.y == 0u, 1u);
        if (!loop_init) {
            int _e136 = y;
            y = as_type<int>(as_type<uint>(_e136) + as_type<uint>(1));
        }
        loop_init = false;
        int _e106 = y;
        if (_e106 <= 1) {
            x = -1;
            uint2 loop_bound_1 = uint2(4294967295u);
            bool loop_init_1 = true;
            while(true) {
                if (metal::all(loop_bound_1 == uint2(0u))) { break; }
                loop_bound_1 -= uint2(loop_bound_1.y == 0u, 1u);
                if (!loop_init_1) {
                    int _e134 = x;
                    x = as_type<int>(as_type<uint>(_e134) + as_type<uint>(1));
                }
                loop_init_1 = false;
                int _e108 = x;
                if (_e108 <= 1) {
                    int _e110 = x;
                    int _e112 = y;
                    g = metal::float2(static_cast<float>(_e110), static_cast<float>(_e112));
                    metal::float2 _e115 = g;
                    metal::float2 _e116 = i;
                    metal::float2 _e117 = g;
                    metal::float2 _e119 = offset;
                    param_2 = (_e116 + _e117) + _e119;
                    metal::float2 _e121 = hash22(param_2);
                    metal::float2 _e123 = f;
                    r = (_e115 + _e121) - _e123;
                    metal::float2 _e125 = r;
                    metal::float2 _e126 = r;
                    d = metal::dot(_e125, _e126);
                    float _e128 = d;
                    float _e129 = md;
                    if (_e128 < _e129) {
                        float _e131 = d;
                        md = _e131;
                        metal::float2 _e132 = r;
                        mr = _e132;
                        metal::float2 _e133 = g;
                        mg = _e133;
                    }
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    edge = 8.0;
    y_1 = -2;
    uint2 loop_bound_2 = uint2(4294967295u);
    bool loop_init_2 = true;
    while(true) {
        if (metal::all(loop_bound_2 == uint2(0u))) { break; }
        loop_bound_2 -= uint2(loop_bound_2.y == 0u, 1u);
        if (!loop_init_2) {
            int _e177 = y_1;
            y_1 = as_type<int>(as_type<uint>(_e177) + as_type<uint>(1));
        }
        loop_init_2 = false;
        int _e138 = y_1;
        if (_e138 <= 2) {
            x_1 = -2;
            uint2 loop_bound_3 = uint2(4294967295u);
            bool loop_init_3 = true;
            while(true) {
                if (metal::all(loop_bound_3 == uint2(0u))) { break; }
                loop_bound_3 -= uint2(loop_bound_3.y == 0u, 1u);
                if (!loop_init_3) {
                    int _e175 = x_1;
                    x_1 = as_type<int>(as_type<uint>(_e175) + as_type<uint>(1));
                }
                loop_init_3 = false;
                int _e140 = x_1;
                if (_e140 <= 2) {
                    metal::float2 _e142 = mg;
                    int _e143 = x_1;
                    int _e145 = y_1;
                    g_1 = _e142 + metal::float2(static_cast<float>(_e143), static_cast<float>(_e145));
                    metal::float2 _e149 = g_1;
                    metal::float2 _e150 = i;
                    metal::float2 _e151 = g_1;
                    metal::float2 _e153 = offset;
                    param_3 = (_e150 + _e151) + _e153;
                    metal::float2 _e155 = hash22(param_3);
                    metal::float2 _e157 = f;
                    r_1 = (_e149 + _e155) - _e157;
                    metal::float2 _e159 = r_1;
                    metal::float2 _e160 = mr;
                    dr = _e159 - _e160;
                    metal::float2 _e162 = dr;
                    metal::float2 _e163 = dr;
                    if (metal::dot(_e162, _e163) > 0.00001) {
                        float _e166 = edge;
                        metal::float2 _e167 = mr;
                        metal::float2 _e168 = r_1;
                        metal::float2 _e171 = dr;
                        edge = metal::min(_e166, metal::dot((_e167 + _e168) * 0.5, metal::normalize(_e171)));
                    }
                    continue;
                } else {
                    break;
                }
            }
            continue;
        } else {
            break;
        }
    }
    float _e179 = n;
    float _e180 = edge;
    edge = _e180 / _e179;
    metal::float2 _e182 = i;
    metal::float2 _e183 = mg;
    metal::float2 _e185 = offset;
    param_4 = ((_e182 + _e183) + _e185) + metal::float2(97.13);
    metal::float2 _e189 = hash22(param_4);
    h = _e189.x;
    float _e192 = uniforms.smoothness;
    w = metal::clamp(_e192, 0.0, 1.0);
    float _e194 = h;
    float _e195 = w;
    start = _e194 * (1.0 - _e195);
    float _e198 = w;
    if (_e198 > 0.0) {
        float _e200 = start;
        float _e201 = start;
        float _e202 = w;
        float _e205 = uniforms.progress;
        local = metal::smoothstep(_e200, _e201 + _e202, _e205);
    } else {
        float _e207 = start;
        float _e209 = uniforms.progress;
        local = metal::step(_e207, _e209);
    }
    float _e211 = local;
    m = _e211;
    metal::float4 _e212 = a;
    float _e215 = a[3u];
    metal::float3 _e216 = _e212.xyz * _e215;
    float _e218 = a[3u];
    metal::float4 _e223 = b;
    float _e226 = b[3u];
    metal::float3 _e227 = _e223.xyz * _e226;
    float _e229 = b[3u];
    float _e234 = m;
    c = metal::mix(metal::float4(_e216.x, _e216.y, _e216.z, _e218), metal::float4(_e227.x, _e227.y, _e227.z, _e229), metal::float4(_e234));
    float _e238 = uniforms.progress;
    float _e241 = uniforms.progress;
    open = metal::smoothstep(0.0, 0.2, _e238) * (1.0 - metal::smoothstep(0.8, 1.0, _e241));
    float _e246 = uniforms.border;
    float _e248 = open;
    bw = metal::max(_e246, 0.0) * _e248;
    float _e250 = bw;
    if (_e250 > 0.0) {
        float _e252 = bw;
        float _e255 = bw;
        float _e258 = edge;
        l = 1.0 - metal::smoothstep((0.5 * _e252) - 0.0015, (0.5 * _e255) + 0.0015, _e258);
        float _e263 = uniforms.borderColor[3u];
        float _e264 = l;
        float _e266 = bw;
        ba = (_e263 * _e264) * metal::min(1.0, _e266 / 0.003);
        metal::float4 _e271 = uniforms.borderColor;
        float _e273 = ba;
        metal::float3 _e274 = _e271.xyz * _e273;
        float _e275 = ba;
        metal::float4 _e280 = c;
        float _e281 = ba;
        c = metal::float4(_e274.x, _e274.y, _e274.z, _e275) + (_e280 * (1.0 - _e281));
    }
    float _e286 = c[3u];
    if (_e286 > 0.0) {
        metal::float4 _e288 = c;
        float _e291 = c[3u];
        metal::float3 _e293 = _e288.xyz / metal::float3(_e291);
        float _e295 = c[3u];
        local_1 = metal::float4(_e293.x, _e293.y, _e293.z, _e295);
    } else {
        local_1 = metal::float4(0.0, 0.0, 0.0, 0.0);
    }
    metal::float4 _e300 = local_1;
    return _e300;
}

void main_1(
    metal::texture2d<float, metal::access::sample> _from,
    metal::sampler _sampler,
    metal::texture2d<float, metal::access::sample> _to,
    constant Uniforms& uniforms,
    thread metal::float4& _fragColor,
    thread metal::float2& _uv_1
) {
    metal::float2 param_5 = {};
    metal::float2 _e39 = _uv_1;
    param_5 = _e39;
    metal::float4 _e40 = transition(param_5, _from, _sampler, _to, uniforms);
    _fragColor = _e40;
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
