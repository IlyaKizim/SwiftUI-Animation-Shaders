//
//  CircleShadow.swift
//  SwiftUI Animation+Shaders
//
//  Created by Кизим Илья on 29.03.2024.
//

import SwiftUI
import AVKit

let url = Bundle.main.path(forResource: "splin", ofType: "mp3")

struct CircleShadow: View {
    @StateObject var album = AlbumOfData()
    @State private var angleThree: Double = 0
    @State private var angleTwo: Double = 0
    @State private var value: CGFloat = 50
    @State private var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State private var rotationAngle: Double = 0
    @State private var rotationSpeed: Double = 0.1
    @State private var isRotating: Bool = false
    @State private var timerAnimator: Timer?
    private var date = Date()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    ZStack {
                        TimelineView(.animation()) { timeline in
                            let time = date.timeIntervalSince1970 - timeline.date.timeIntervalSince1970
                            CustomCircle(time: time, speed: audioPlayer.isPlaying ? 6 : 3, smoothing: 40, strength: 15, lineWidth: 30, width:  400, trimFrom: 0.0, trimTo: 1)
                                .foregroundStyle(
                                    .linearGradient(colors: [.clear, .clear, .green, .green], startPoint: .leading, endPoint: .trailing)
                                    .shadow(.drop(color: .green, radius: 40, x: 10, y: 10))
                                    .shadow(.drop(color: .green, radius: 30, x: -10, y: 20))
                                    .shadow(.drop(color: audioPlayer.isPlaying ? Color(red:  0 / 255, green: value / 255, blue: value / 255) : .clear, radius: 10, x: -10, y: 20))
                                )
                                .blur(radius: 10)
                                .rotationEffect(.degrees(rotationAngle))
                                .onAppear {
                                    startRotation()
                                }
                            
                            CustomCircle(time: time, speed: audioPlayer.isPlaying ? -6 : -2, smoothing: -40, strength: -30, lineWidth: 30, width:  400, trimFrom: 0.0, trimTo: 1)
                                .foregroundStyle(
                                    .linearGradient(colors: [.clear, .clear, .green, .green], startPoint: .leading, endPoint: .trailing)
                                    .shadow(.drop(color: .green, radius: 40, x: 10, y: 10))
                                    .shadow(.drop(color: .green, radius: 30, x: -10, y: 20))
                                    .shadow(.drop(color: audioPlayer.isPlaying ? Color(red:  value / 255, green: value / 240, blue: value / 180) : .clear, radius: 10, x: -10, y: 20))
                                )
                                .blur(radius: 10)
                                .rotationEffect(.degrees(angleTwo))
                                .animation(.linear(duration: 20).repeatCount(100, autoreverses: false), value: angleTwo)
                                .onAppear{
                                    angleTwo = -360
                                }
                            
                            CustomCircle(time: time, speed: audioPlayer.isPlaying ? 6 : 4, smoothing: 20, strength: 4, lineWidth: 30, width: 400, trimFrom: 0.5, trimTo: 1)
                                .foregroundStyle(
                                    .linearGradient(Gradient(colors: [.clear, .black,.clear]), startPoint: .leading, endPoint: .trailing)
                                    .shadow(.drop(color: .green, radius: 20, x: 10, y: 200))
                                )
                                .rotationEffect(Angle.degrees(180))
                                .offset(y: 160)
                            
                            CustomCircle(time: time, speed: audioPlayer.isPlaying ? 6 : 4, smoothing: 20, strength: 4, lineWidth:  30, width:  400, trimFrom: 0.5, trimTo: 1)
                                .foregroundStyle(
                                    .linearGradient(Gradient(colors: [.clear, .black,.clear]), startPoint: .leading, endPoint: .trailing)
                                    .shadow(.drop(color: .green, radius: 20, x: 10, y: 180))
                                )
                                .offset(y: -160)
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.08))
                                Circle()
                                    .fill(Color.white.opacity(0.09))
                                    .frame(width: audioPlayer.isPlaying ? value / 1.6 : 0)
                            }
                            .frame(width: audioPlayer.isPlaying ? value : 0)
                            
                            Button(action: {
                                play()
                                if isRotating {
                                    stopRotation()
                                } else {
                                    startRotation()
                                }
                                isRotating.toggle()
                            }) {
                                Image(systemName: album.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                        .onReceive(timer, perform: { _ in
                            if audioPlayer.isPlaying {
                                album.isPlaying = true
                                audioPlayer.updateMeters()
                                animation()
                            } else {
                                album.isPlaying = false
                            }
                        })
                        .onAppear{
                            audioPlayer.isMeteringEnabled = true
                        })
                .ignoresSafeArea()
        }
    }
    
    func play() {
        if audioPlayer.isPlaying {
            rotationSpeed = 0.1
            audioPlayer.pause()
        } else {
            rotationSpeed = 0.02
            audioPlayer.play()
        }
    }
    
    func startRotation() {
        timerAnimator = Timer.scheduledTimer(withTimeInterval: rotationSpeed, repeats: true) { _ in
            rotationAngle += 1
        }
    }
    
    func stopRotation() {
        timerAnimator?.invalidate()
        timerAnimator = nil
    }
    
    func animation() {
        var power: Float = 0
        for i in 0..<audioPlayer.numberOfChannels {
            power += audioPlayer.averagePower(forChannel: i)
        }
        let value = max(0, CGFloat(abs(power)) + 80)
        withAnimation(Animation.linear(duration: 0.08)) {
            if value < 180 {
                self.value = value
            }
        }
    }
}

struct CustomCircle: View {
    let time: TimeInterval
    let speed: Float
    let smoothing: Float
    let strength: Float
    let lineWidth: CGFloat
    let width: CGFloat
    let trimFrom: CGFloat
    let trimTo: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: trimFrom, to: trimTo)
            .stroke(style: StrokeStyle(lineWidth: lineWidth))
            .frame(width: width)
            .distortionEffect(
                ShaderLibrary.waveCircle(
                    .float(time),
                    .float(speed),
                    .float(smoothing),
                    .float(strength)
                ),
                maxSampleOffset: CGSize(width: 200, height: 200)
            )
    }
}

class AlbumOfData: ObservableObject {
    @Published var isPlaying = false
}
