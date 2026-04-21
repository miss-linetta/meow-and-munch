//
//  ContentView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @Namespace  private var fruitNamespace

    var body: some View {
        GeometryReader { geo in
            let fruitSize = geo.size.width * 0.24
            let shapeSize = geo.size.width * 0.33

            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    FruitShapesView(viewModel: viewModel, namespace: fruitNamespace, slotSize: shapeSize)
                        .padding(.top, geo.size.height * 0.07)
                    Spacer()
                    FruitBasketView(viewModel: viewModel, namespace: fruitNamespace, slotSize: fruitSize)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 24)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .ignoresSafeArea(edges: .bottom)
                .zIndex(viewModel.isDragging ? 2 : 0)

                if viewModel.isLevelComplete {
                    Color.black
                        .opacity(0.65)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.isLevelComplete)
                        .allowsHitTesting(false)
                }

                CharacterView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.8)
                    .frame(maxWidth: .infinity)
                    .offset(y: geo.size.height * 0.01)
                    .scaleEffect(viewModel.isLevelComplete ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.isLevelComplete)
                    .allowsHitTesting(false)
                    .zIndex(1)
            }
            .coordinateSpace(name: "gameArea")
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
