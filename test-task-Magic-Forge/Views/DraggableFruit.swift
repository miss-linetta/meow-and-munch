//
//  DraggableFruit.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct DraggableFruit: View {
    let item: FruitItem
    let size: CGFloat
    @ObservedObject var viewModel: GameViewModel

    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Image(item.circleName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .scaleEffect(isDragging ? 1.15 : 1.0)
            .offset(offset)
            .zIndex(isDragging ? 1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
            .gesture(
                DragGesture(coordinateSpace: .named("gameArea"))
                    .onChanged { value in
                        isDragging = true
                        viewModel.isDragging = true
                        offset = value.translation
                        viewModel.dragPosition = value.location
                    }
                    .onEnded { value in
                        viewModel.tryMatch(fruitName: item.name, at: value.location)
                        viewModel.dragPosition = nil
                        isDragging = false
                        viewModel.isDragging = false
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            offset = .zero
                        }
                    }
            )
    }
}
