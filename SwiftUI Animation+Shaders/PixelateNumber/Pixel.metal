//
//  Pixel.metal
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]] float2 pixel(float2 position, float strength) {
    float min_strength = max(strength, 0.0001);
    float coord_x = min_strength * round(position.x / min_strength);
    float coord_y = min_strength * round(position.y / min_strength);
    return float2(coord_x, coord_y);
}
