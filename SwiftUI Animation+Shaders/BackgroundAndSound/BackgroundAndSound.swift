//
//  BackgroundAndSound.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI

struct BackgroundAndSound: View {
    let startDate = Date()
    var body: some View {
        ZStack {
            CustomSliderSound(flag: true, colorBack: .gray, color: .white)
                .frame(width: 50, height: 150)
                .zIndex(1)
            TimelineView(.animation) {
                let time = $0.date.timeIntervalSince1970 - startDate.timeIntervalSince1970
                ZStack(alignment: .bottom,
                       content: {
                    LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
                    LinearGradient(colors: [.orange, .purple], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 1.5)
                        .rotationEffect(Angle.degrees(10))
                        .waveShader(WaveConfiguration(time: time, speed: 5, frequency: 60, amplitude: 10))
                    LinearGradient(colors: [.purple, .cyan], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 2.5)
                        .rotationEffect(Angle.degrees(-15))
                        .waveShader(WaveConfiguration(time: time, speed: -3, frequency: 80, amplitude: 15))
                    LinearGradient(colors: [.cyan, .mint], startPoint: .leading, endPoint: .trailing)
                        .frame(width: UIScreen.main.bounds.width + 120, height: UIScreen.main.bounds.height / 3)
                        .rotationEffect(Angle.degrees(15))
                        .waveShader(WaveConfiguration(time: time, speed: -5, frequency: 100, amplitude: 20))
                        .offset(y: 100)
                })
                .blur(radius: 2)
                .ignoresSafeArea()
            }
        }
       
    }
}

extension View {
    @ViewBuilder
    func waveShader(_ configuration: WaveConfiguration) -> some View {
        self
            .modifier(Helper(configuration: configuration))
    }
}

fileprivate struct Helper: ViewModifier {
    var configuration: WaveConfiguration
    func body(content: Content) -> some View {
        content
            .distortionEffect(
                .init(function: .init(library: .default, name: "wave"), arguments: [
                    .float(configuration.time),
                    .float(configuration.speed),
                    .float(configuration.frequency),
                    .float(configuration.amplitude)
                ]),
                maxSampleOffset: CGSize(width: 100, height: 100))
    }
}

struct WaveConfiguration {
    var time: TimeInterval
    var speed: CGFloat
    var frequency: CGFloat
    var amplitude: CGFloat
}


struct CustomSliderSound: View {
    @State private var progress: CGFloat = .zero
    @State private var offsetValue: CGFloat = .zero
    @State private var lastOffsetValue: CGFloat = .zero
    var flag = false
    var colorBack: Color
    var color: Color
    var body: some View {
        GeometryReader {
            let size = $0.size
            let value = size.height
            let progressValue = max(progress, .zero) * value
            ZStack(alignment: .bottom){
                Rectangle()
                    .fill(colorBack)
                    .blendMode(flag ? .normal : .color)
                Rectangle()
                    .fill(color)
                    .blendMode(flag ? .normal : .color)
                    .frame(width: flag ? 50 : 200, height: progressValue)
            }
            .clipShape(.rect(cornerRadius: 15))
            .contentShape(.rect(cornerRadius: 15))
            .frame(height: progress < 0 ? size.height + (-progress * size.height) : nil)
            .gesture(
                DragGesture()
                    .onChanged({
                        let translation = $0.translation
                        let move = -translation.height + lastOffsetValue
                        offsetValue = move
                        calculateProgress(value: value)
                    })
                    .onEnded({ _ in
                        withAnimation(.smooth) {
                            offsetValue = offsetValue > value ? value : (offsetValue < 0 ? 0 : offsetValue)
                            calculateProgress(value: value)
                        }
                        lastOffsetValue = offsetValue
                    })
            )
            .frame(maxWidth: size.width, maxHeight: size.height, alignment: progress < 0 ? .top : .bottom)
        }
    }
    
    func calculateProgress(value: CGFloat) {
        let topAnchor = value + (offsetValue - value) * 0.2
        let bottomAnchor = offsetValue < 0 ? (offsetValue * 0.2) : offsetValue
        let progress = (offsetValue > value ? topAnchor : bottomAnchor) / value
        self.progress = progress
    }
}

