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

                CharacterView(viewModel: viewModel)
                    .frame(height: geo.size.height * 0.8)
                    .frame(maxWidth: .infinity)
                    .offset(y: geo.size.height * 0.01)
                    .allowsHitTesting(false)

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
            }
            .coordinateSpace(name: "gameArea")
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
