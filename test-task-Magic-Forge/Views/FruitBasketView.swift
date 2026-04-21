//
//  FruitBasketView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct FruitBasketView: View {
    @ObservedObject var viewModel: GameViewModel
    var namespace: Namespace.ID
    let slotSize: CGFloat

    var body: some View {
        VStack(spacing: slotSize * 0.01) {
            HStack(spacing: slotSize * 0.2) {
                ForEach(viewModel.slots.prefix(2)) { item in
                    fruitSlot(item)
                }
            }
            HStack(spacing: slotSize * 0.2) {
                ForEach(viewModel.slots.dropFirst(2)) { item in
                    fruitSlot(item)
                }
            }
        }
    }

    @ViewBuilder
    private func fruitSlot(_ item: FruitItem) -> some View {
        let isGuessed = viewModel.guessedFruits.contains(item.name)

        ZStack {
            if !isGuessed {
                DraggableFruit(item: item, size: slotSize, viewModel: viewModel)
                    .matchedGeometryEffect(id: item.name, in: namespace)
            } else {
                Color.clear.frame(width: slotSize, height: slotSize)
            }
        }
        .frame(width: slotSize, height: slotSize)
    }
}
