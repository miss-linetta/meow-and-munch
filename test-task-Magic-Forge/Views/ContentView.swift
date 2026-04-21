//
//  ContentView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @Namespace  private var fruitNamespace
    @State private var isPaused = false

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

                VStack {
                    HStack {
                        Button(action: { withAnimation(.easeInOut(duration: 0.3)) { isPaused = true } }) {
                            Image("pauseButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.14)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image("levelButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.14)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, -5)
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .zIndex(3)

                if viewModel.isLevelComplete {
                    Color.black
                        .opacity(0.65)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.isLevelComplete)
                        .allowsHitTesting(false)
                }

                if isPaused {
                    Color.black
                        .opacity(0.65)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .zIndex(4)

                    Button(action: { withAnimation(.easeInOut(duration: 0.3)) { isPaused = false } }) {
                        Image("playButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.25)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(5)
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
