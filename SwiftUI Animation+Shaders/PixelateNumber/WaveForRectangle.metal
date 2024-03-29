//
//  WaveForRectangle.metal
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//


#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 wave(float2 position, float time, float speed, float frequency, float amplitude) {
    float f = (time * speed);
    float s = (position.x / frequency);
    float w = 0;
    w = sin(f + s);
    float positionY = position.y + w * amplitude - 10;
    return float2(position.x, positionY);
}
