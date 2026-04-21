//
//  ContentView.swift
//  test-task-Magic-Forge
//

import SwiftUI

// MARK: - PreferenceKey

struct SlotFrameKey: PreferenceKey {
    static var defaultValue: [String: CGRect] = [:]
    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

// MARK: - DraggableFruit

struct DraggableFruit: View {
    let item: FruitItem
    @ObservedObject var viewModel: GameViewModel

    @State private var offset: CGSize = .zero
    @State private var isDragging = false

    var body: some View {
        Image(item.circleName)
            .resizable()
            .scaledToFit()
            .frame(width: 110, height: 110)
            .scaleEffect(isDragging ? 1.15 : 1.0)
            .offset(offset)
            .zIndex(isDragging ? 1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
            .gesture(
                DragGesture(coordinateSpace: .named("gameArea"))
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation
                    }
                    .onEnded { value in
                        viewModel.tryMatch(fruitName: item.name, at: value.location)
                        isDragging = false
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            offset = .zero
                        }
                    }
            )
    }
}

// MARK: - FruitShapesView

struct FruitShapesView: View {
    @ObservedObject var viewModel: GameViewModel
    var namespace: Namespace.ID

    // Visual y-offset per target — layout only, not game data
    private let yOffsets: [String: Double] = [
        "Raspberry": -10,
        "Banana":     20,
        "Kiwi":      -10
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.targets, id: \.self) { target in
                let isGuessed  = viewModel.guessedFruits.contains(target)
                let yOffset    = yOffsets[target] ?? 0

                ZStack {
                    if !isGuessed {
                        Image("\(target)_shape")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                    } else {
                        Image("\(target)_guessed")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .matchedGeometryEffect(id: target, in: namespace)
                    }
                }
                .frame(width: 120, height: 120)
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

// MARK: - FruitBasketView

struct FruitBasketView: View {
    @ObservedObject var viewModel: GameViewModel
    var namespace: Namespace.ID

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                ForEach(viewModel.slots.prefix(2)) { item in
                    fruitSlot(item)
                }
            }
            HStack(spacing: 20) {
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
                DraggableFruit(item: item, viewModel: viewModel)
                    .matchedGeometryEffect(id: item.name, in: namespace)
            } else {
                Color.clear.frame(width: 110, height: 110)
            }
        }
        .frame(width: 110, height: 110)
    }
}

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @Namespace  private var fruitNamespace

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                FruitShapesView(viewModel: viewModel, namespace: fruitNamespace)
                    .padding(.top, 60)
                Spacer()
                FruitBasketView(viewModel: viewModel, namespace: fruitNamespace)
            }
        }
        .coordinateSpace(name: "gameArea")
    }
}

#Preview {
    ContentView()
}
