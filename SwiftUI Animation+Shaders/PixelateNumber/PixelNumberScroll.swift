//
//  PixelNumberScroll.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI

struct PixelNumberScroll: View {
    private var date = Date()
    @State private var array = Array(repeating: false, count: 20)
    @State private var scrollOffsets: [CGFloat] = Array(repeating: 0.0, count: 20)
    @State private var yRectangle: CGFloat = 0
    
    var body: some View {
        TabView {
            ScrollView {
                ForEach(1..<21) { number in
                    let text = "\(number)"
                    Text(text)
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .distortionEffect(
                            ShaderLibrary.pixel(
                                .float(array[number - 1] ? 7 : 3)
                            ),
                            maxSampleOffset: .zero
                        )
                        .frame(height: 50)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: ScrollViewOffsetPreferenceKey.self,
                                        value: [number: geo.frame(in: .global).origin.y]
                                    )
                            }
                        )
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                TimelineView(.animation()) {
                    let time = date.timeIntervalSince1970 - $0.date.timeIntervalSince1970
                    Rectangle()
                        .distortionEffect(
                            ShaderLibrary.wave(
                                .float(time),
                                .float(8),
                                .float(25),
                                .float(10)
                            ),
                            maxSampleOffset: .zero
                        )
                        .frame(height: 60)
                        .background(GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: WavePreferenceKey.self,
                                    value: geo.frame(in: .global).origin.y
                                )
                                .onAppear{
                                    yRectangle = geo.frame(in: .global).origin.y
                                }
                        })
                        .opacity(0.3)
                }
            })
            .tabItem {
                Image(systemName: "star")
                Text("First")
            }
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offsets in
                for (index, value) in offsets {
                    if value < yRectangle + 50 && value > yRectangle - 50 {
                        array[index - 1] = true
                    } else {
                        array[index - 1] = false
                    }
                }
            }
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct WavePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
