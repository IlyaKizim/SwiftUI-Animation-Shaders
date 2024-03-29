//
//  Frost.metal
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
#define FROSTYNESS 2.0
#define COLORIZE   1.0
#define COLOR_RGB  float3(0.7,1.0,1.0)

using namespace metal;


float rand(float2 uv) {
    float a = dot(uv, float2(92., 80.));
    float b = dot(uv, float2(41., 62.));
    
    float x = sin(a) + cos(b) * 51.;
    return fract(x);
}

sampler textureSampler0;

[[stitchable]] half4 frost(float2 pos, float4 boundingRect, texture2d<half> image, float radius)
{
    float2 uv = pos;
    float2 UV = pos/float2(boundingRect[2], boundingRect[3]);
    uv.x = (pos.x - 0.5 * boundingRect[1]) / boundingRect[2];
    uv.y = (pos.y - 0.5 * boundingRect[1]) / boundingRect[3];

    
    half4 d = image.sample(textureSampler0, UV, 1);
    float2 rnd = float2(rand(uv + d.r * 0.05), rand(uv + d.b * 0.05));
    
    float2 lensRadius = float2(radius * 0.5, 0.05);
    float dist = distance(uv.xy, float2(0.5, 0.5));
    float vigfin = pow(1.0 - smoothstep(lensRadius.x, lensRadius.y, dist), 2.0);
   
    rnd *= float2(0.025) * vigfin + float2(d.rg) * FROSTYNESS * vigfin;
    uv += rnd;
    half4 tex = image.sample(textureSampler0, uv, 1);
    half3 col = mix(tex, half4(1.0), COLORIZE * half4(rnd.r)).rgb;
    
    return half4(col, 1.0);
}
