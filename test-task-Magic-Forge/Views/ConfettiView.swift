//
//  ConfettiView.swift
//  test-task-Magic-Forge
//

import SwiftUI

private struct ConfettiParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let delay: Double
    let size: CGFloat
    let color: Color
    let rotation: Double
    let drift: CGFloat
}

struct ConfettiView: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat

    private let particles: [ConfettiParticle] = (0..<60).map { _ in
        ConfettiParticle(
            x: CGFloat.random(in: 0...1),
            delay: Double.random(in: 0...2.0),
            size: CGFloat.random(in: 8...16),
            color: [
                Color.red, Color.orange, Color.yellow,
                Color.green, Color.blue, Color.purple, Color.pink
            ].randomElement()!,
            rotation: Double.random(in: 0...360),
            drift: CGFloat.random(in: -60...60)
        )
    }

    var body: some View {
        ZStack {
            ForEach(particles) { p in
                ParticleFallView(
                    particle: p,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight
                )
            }
        }
        .allowsHitTesting(false)
    }
}

private struct ParticleFallView: View {
    let particle: ConfettiParticle
    let screenWidth: CGFloat
    let screenHeight: CGFloat

    @State private var offsetY: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var rotation: Double = 0

    var body: some View {
        Rectangle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size * 0.5)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .offset(x: particle.x * screenWidth - screenWidth / 2 + offsetX,
                    y: -screenHeight / 2 + offsetY)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + particle.delay) {
                    withAnimation(.easeIn(duration: Double.random(in: 2.5...4.0))) {
                        offsetY = screenHeight + 60
                        offsetX = particle.drift
                        opacity = 0
                    }
                    withAnimation(.linear(duration: Double.random(in: 2.5...4.0))) {
                        rotation = particle.rotation + Double.random(in: 360...720)
                    }
                }
            }
    }
}
