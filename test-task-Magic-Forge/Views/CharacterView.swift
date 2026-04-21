//
//  CharacterView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct CharacterView: View {
    @ObservedObject var viewModel: GameViewModel

    private let bodyAspect: CGFloat     = 223.0 / 484.0
    private let eyeWidthRatio: CGFloat  = 134.0 / 340.34
    private let eyeHeightRatio: CGFloat = 74.0  / 707.7
    private let eyeYRatio: CGFloat      = 0.41
    private let maxPupilOffset: CGFloat = 3

    @State private var characterFrame: CGRect = .zero
    @State private var pupilOffset: CGSize = .zero
    @State private var idleOffset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            let renderedH = min(geo.size.height, geo.size.width / bodyAspect)
            let renderedW = renderedH * bodyAspect
            let bodyMinY  = (geo.size.height - renderedH) / 2

            let eyeW = renderedW * eyeWidthRatio
            let eyeH = renderedH * eyeHeightRatio
            let eyeX = geo.size.width / 2 + geo.size.width * 0.004
            let eyeY = bodyMinY + renderedH * eyeYRatio - geo.size.height * 0.002

            ZStack {
                Image("Test_Kitten_Bottom")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)

                Image("Test_Kitten_Eyeballs")
                    .resizable()
                    .scaledToFit()
                    .frame(width: eyeW, height: eyeH)
                    .position(x: eyeX, y: eyeY)

                Image("Test_Kitten_Pupils")
                    .resizable()
                    .scaledToFit()
                    .frame(width: eyeW, height: eyeH)
                    .offset(viewModel.dragPosition != nil ? pupilOffset : idleOffset)
                    .position(x: eyeX, y: eyeY)

                Image("Test_Kitten_Eyelids")
                    .resizable()
                    .scaledToFit()
                    .frame(width: eyeW, height: eyeH)
                    .position(x: eyeX, y: eyeY)
            }
        }
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: CharacterFrameKey.self,
                    value: geo.frame(in: .named("gameArea"))
                )
            }
        )
        .onPreferenceChange(CharacterFrameKey.self) { characterFrame = $0 }
        .onChange(of: viewModel.dragPosition) { _, pos in updatePupils(dragPos: pos) }
        .onAppear { startIdleAnimation() }
    }

    private func updatePupils(dragPos: CGPoint?) {
        guard let pos = dragPos else {
            withAnimation(.easeOut(duration: 0.4)) { pupilOffset = .zero }
            return
        }
        let eyeCenter = CGPoint(
            x: characterFrame.midX,
            y: characterFrame.minY + characterFrame.height * eyeYRatio
        )
        let dx = pos.x - eyeCenter.x
        let dy = pos.y - eyeCenter.y
        let dist = hypot(dx, dy)
        let scale = dist > 0 ? min(maxPupilOffset / dist, 1) : 0
        withAnimation(.easeOut(duration: 0.15)) {
            pupilOffset = CGSize(width: dx * scale, height: dy * scale)
        }
    }

    private func startIdleAnimation() {
        let positions: [CGSize] = [
            .zero,
            CGSize(width: 3,    height: -1.5),
            CGSize(width: -2.5, height: 1),
            CGSize(width: 2,    height: 2),
            .zero,
            CGSize(width: -3,   height: -1),
        ]
        var index = 0

        func step() {
            guard viewModel.dragPosition == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { step() }
                return
            }
            withAnimation(.easeInOut(duration: 1.2)) {
                idleOffset = positions[index]
            }
            index = (index + 1) % positions.count
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.8...3.2)) {
                step()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { step() }
    }
}
