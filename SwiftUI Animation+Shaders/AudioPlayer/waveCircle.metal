//
//  File.metal
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 waveCircle(float2 position, float time, float speed, float smoothing, float strength) {
    position.y += sin(time * speed + position.x / smoothing) * strength;
    return position;
}
