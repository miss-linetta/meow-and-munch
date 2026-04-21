//
//  ContentView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @Namespace  private var fruitNamespace
    @State private var isPaused = false
    @State private var showVictoryButtons = false

    var body: some View {
        GeometryReader { geo in
            let fruitSize = geo.size.width * 0.24
            let shapeSize = geo.size.width * 0.33

            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()

                if !viewModel.isLevelComplete {
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
                    .zIndex(viewModel.isDragging ? 5 : 0)
                    .transition(.opacity)
                }

                if !viewModel.isLevelComplete {
                    TopButtonsView(
                        width: geo.size.width,
                        onPause: { withAnimation(.easeInOut(duration: 0.3)) { isPaused = true } }
                    )
                    .frame(width: geo.size.width, height: geo.size.height)
                    .zIndex(3)
                    .transition(.opacity)
                }

                if viewModel.isLevelComplete {
                    ConfettiView(screenWidth: geo.size.width, screenHeight: geo.size.height)
                        .zIndex(5)
                        .transition(.opacity)
                }

                if viewModel.isLevelComplete {
                    Color.black
                        .opacity(0.65)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.isLevelComplete)
                        .allowsHitTesting(false)
                        .zIndex(2)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showVictoryButtons = true
                            }
                        }
                        .onDisappear { showVictoryButtons = false }
                }

                if showVictoryButtons {
                    VictoryButtonsView(
                        width: geo.size.width,
                        bottomInset: geo.safeAreaInsets.bottom,
                        onReload: { showVictoryButtons = false; viewModel.resetLevel() },
                        onPlay:   { showVictoryButtons = false; viewModel.resetLevel() }
                    )
                    .frame(width: geo.size.width, height: geo.size.height)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(3)
                }

                if isPaused {
                    PauseOverlayView(
                        buttonSize: geo.size.width * 0.25,
                        onResume: { isPaused = false }
                    )
                    .zIndex(4)
                }

                CharacterView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.8)
                    .frame(maxWidth: .infinity)
                    .offset(y: geo.size.height * 0.01)
                    .scaleEffect(viewModel.isLevelComplete ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.isLevelComplete)
                    .allowsHitTesting(false)
                    .zIndex(isPaused ? 0 : 4)
            }
            .coordinateSpace(name: "gameArea")
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
