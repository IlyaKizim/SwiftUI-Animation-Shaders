//
//  RainAndFrost.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI

struct RainAndFrost: View {
    @State private var dragOffset: CGSize = .zero
    @State var segment = SegmentState.rain
    let date = Date()
    var body: some View {
        ZStack {
            Picker("", selection: $segment) {
                ForEach(SegmentState.allCases, id: \.self) { value in
                    Text(value.labelText)
                        .tag(value)
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
            }
            .zIndex(1)
            .pickerStyle(.segmented)
            .frame(width: 200 , height: 200)
            .offset(y: -300)
            TimelineView(.animation) {timeline in
                Rectangle()
                    .foregroundStyle(
                        segment == .rain ? ShaderLibrary.rainFall(
                            .boundingRect,
                            .float(timeline.date.timeIntervalSince(date)),
                            .image(Image("road"))
                        ) : ShaderLibrary.frost(
                            .boundingRect,
                            .image(Image("road")),
                            .float(max(abs(dragOffset.width), abs(dragOffset.height)) * 0.009 + 1)
                        )
                    )
                    .ignoresSafeArea()
                    .overlay(
                        Rectangle()
                            .fill(
                                RadialGradient(
                                    gradient: .init(colors: [Color.yellow, Color.red]),
                                    center: .center,
                                    startRadius: 100,
                                    endRadius: 150
                                ))
                            .mask {
                                Canvas { context, size in
                                    context.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
                                    context.addFilter(.blur(radius: 30))
                                    
                                    context.drawLayer { context in
                                        for index in [1,2] {
                                            if let view = context.resolveSymbol(id: index) {
                                                context.draw(view, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                            }
                                        }
                                    }
                                } symbols: {
                                    Circle()
                                        .frame(width: 150)
                                        .tag(1)
                                    Circle()
                                        .frame(width: 150)
                                        .offset(dragOffset)
                                        .tag(2)
                                }
                            }
                            .overlay(
                                Image(systemName: "cloud.sun.rain.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .offset(dragOffset)
                            )
                            .gesture(
                                DragGesture()
                                    .onChanged {
                                        dragOffset = $0.translation
                                        
                                    }
                                    .onEnded { _ in
                                        withAnimation(.interpolatingSpring(stiffness: 200, damping: 18)) {
                                            dragOffset = .zero
                                        }
                                    }
                            )
                            .ignoresSafeArea()
                    )
            }
        }
    }
}

enum SegmentState: String, CaseIterable {
    case rain
    case frost
    
    var labelText: String {
        switch self {
        case .rain:
            return "Rain";
        case .frost:
            return "Frost";
        }
    }
}


