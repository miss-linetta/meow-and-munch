//
//  PauseOverlayView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct PauseOverlayView: View {
    let buttonSize: CGFloat
    let onResume: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.65)
                .ignoresSafeArea()
                .transition(.opacity)

            Button(action: onResume) {
                Image("playButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonSize)
            }
            .transition(.scale.combined(with: .opacity))
        }
    }
}
