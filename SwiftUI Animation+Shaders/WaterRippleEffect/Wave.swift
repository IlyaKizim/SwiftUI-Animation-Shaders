//
//  Wave.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI
import Metal
import MetalKit

struct Wave: View {
    @ObservedObject var renderer = Renderer(mtkView: MTKView(frame: .zero))!
    
    var body: some View {
        ZStack {
            MetalView(renderer: renderer)
                .ignoresSafeArea()
        }
    }
}

struct MetalView: UIViewRepresentable {
    var renderer: Renderer?
    
    init(renderer: Renderer?) {
        self.renderer = renderer
    }
    
    func makeUIView(context: Context) -> MTKView {
        guard let renderer = renderer else {
            return MTKView(frame: .zero)
        }
        return renderer.view
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
    }
}
