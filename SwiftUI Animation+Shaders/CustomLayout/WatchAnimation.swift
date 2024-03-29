//
//  CustomLayout.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI

struct LayoutAnimation: View {
    @State private var flag = 0
    @State private var layout: AnyLayout = AnyLayout(HStackLayout())
    @State private var drawingProgress: Double = 0
    @State private var drawingProgressTwo: Double = 0
    @State private var drawingProgressThree: Double = 0
    @State private var drawingProgressFour: Double = 0
    @State private var hour: Double = 135
    @State private var minute: Double = 120
    let numbers = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    
    var body: some View {
        ZStack {
            layout {
                ForEach(0..<12) {index in
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(flag == 2 ? .clear : .black)
                        .aspectRatio(1, contentMode: flag == 2 ? .fill : .fit)
                        .frame(width: flag == 2 ? 40 : nil, height: flag == 2 ? 40 : nil)
                        .overlay(
                            Text("\(numbers[index])")
                                .foregroundColor(flag == 2 ? .white : .clear)
                        )
                }
            }
            .zIndex(3)
            .frame(width: flag == 2 ? 150 : nil)
            .onTapGesture {
                withAnimation {
                    flag += 1
                    switch flag {
                    case 1: layout = AnyLayout(VerticleLayout())
                    case 2: layout = AnyLayout(CircleLayout())
                    case 3: flag = 0
                        layout = AnyLayout(HStackLayout())
                    default:
                        layout = AnyLayout(HStackLayout())
                    }
                }
            }
            
            if flag == 2 {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(
                        .white
                            .shadow(.inner(color: .gray, radius: 10, x: -10, y: -10))
                            .shadow(.drop(color: .black.opacity(0.3), radius: 10, x: 10, y: 10))
                    )
                    .frame(width: drawingProgressTwo == 1 ? 170 : 1, height: 100  )
                    .offset(x: 170)
                    .rotationEffect(.degrees(90))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).delay(1)) {
                            drawingProgressTwo = 1
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .trim(from: 0, to: drawingProgressTwo)
                            .stroke(style: StrokeStyle(lineWidth: 10))
                            .frame(width: 175, height: 105)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .trim(from: 0, to: drawingProgressTwo)
                        
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .foregroundStyle(.linearGradient(Gradient(colors: [.clear, .black.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .offset(x: 170)
                            .rotationEffect(.degrees(90))
                            .frame(width: 170, height: 100)
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(
                        .white
                            .shadow(.inner(color: .gray, radius: 10, x: -10, y: -10))
                            .shadow(.drop(color: .black.opacity(0.3), radius: 10, x: 10, y: 10))
                    )
                    .frame(width: drawingProgressTwo == 1 ? 170 : 1, height: 100 )
                    .offset(x: -170)
                    .rotationEffect(.degrees(90))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .trim(from: 0, to: drawingProgressTwo)
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .foregroundStyle(.linearGradient(Gradient(colors: [.clear, .black.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .offset(x: -170)
                            .rotationEffect(.degrees(90))
                            .frame(width: 170, height: 100)
                    )
                
                Circle()
                    .trim(from: 0, to: drawingProgressThree)
                    .stroke(style: StrokeStyle(lineWidth: 10, dash: [1, 10]))
                    .foregroundColor(.red)
                    .frame(width: 140)
                    .rotationEffect(.degrees(90))
                    .zIndex(3)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).delay(2.5)) {
                            drawingProgressThree = 1
                        }
                    }
                
                RoundedRectangle(cornerRadius: 5)
                    .trim(from: 0, to: drawingProgressFour)
                    .stroke()
                    .fill(.red)
                    .rotationEffect(.degrees(minute), anchor: .leading)
                    .frame(width: 40, height: 5)
                    .zIndex(3)
                    .offset(x: 20)
                    .animation(.linear(duration: 10).repeatCount(1, autoreverses: false), value: minute)
                    .onAppear{
                        withAnimation(Animation.linear(duration: 1.5).delay(0.5)) {
                            drawingProgressFour = 1
                        }
                        hour = 360
                        minute = 630
                    }
                
                RoundedRectangle(cornerRadius: 5)
                    .trim(from: 0, to: drawingProgressFour)
                    .stroke()
                    .fill(.red)
                    .rotationEffect(.degrees(hour), anchor: .leading)
                    .frame(width: 30, height: 5)
                    .zIndex(3)
                    .offset(x: 15)
                    .animation(.linear(duration: 50), value: hour)
                
                RoundedRectangle(cornerRadius: 15)
                    .trim(from: 0, to: drawingProgress)
                    .foregroundStyle(.white
                        .shadow(.inner(color: .gray, radius: 10, x: -10, y: -10))
                        .shadow(.drop(color: .black.opacity(0.3), radius: 10, x: 10, y: 10)))
                    .frame(width: 180, height: 220)
                    .rotationEffect(.degrees(360))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5)) {
                            drawingProgress = 1
                        }
                    }
                
                RoundedRectangle(cornerRadius: 15)
                    .trim(from: 0, to: drawingProgress)
                    .foregroundStyle(.black.shadow(.inner(color: .gray, radius: 10, x: 10, y: 10)))
                    .frame(width: 160, height: 200)
                    .rotationEffect(.degrees(180))
            }
        }
    }
}
