//
//  FruitShapesView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct FruitShapesView: View {
    @ObservedObject var viewModel: GameViewModel
    var namespace: Namespace.ID
    let slotSize: CGFloat

    private let yOffsets: [String: Double] = [
        "Raspberry": 0.15,
        "Banana":     -0.08,
        "Kiwi":      0.15
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.targets, id: \.self) { target in
                let isGuessed = viewModel.guessedFruits.contains(target)
                let yOffset   = (yOffsets[target] ?? 0) * slotSize

                ZStack {
                    if !isGuessed {
                        Image("\(target)_shape")
                            .resizable()
                            .scaledToFit()
                            .frame(width: slotSize, height: slotSize)
                    } else {
                        Image("\(target)_guessed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: slotSize, height: slotSize)
                            .matchedGeometryEffect(id: target, in: namespace)
                    }
                }
                .frame(width: slotSize, height: slotSize)
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(
                            key: SlotFrameKey.self,
                            value: [target: geo.frame(in: .named("gameArea"))
                                .offsetBy(dx: 0, dy: yOffset)]
                        )
                    }
                )
                .offset(y: yOffset)
            }
        }
        .onPreferenceChange(SlotFrameKey.self) { frames in
            viewModel.slotFrames = frames
        }
    }
}
