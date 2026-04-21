//
//  VictoryButtonsView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct VictoryButtonsView: View {
    let width: CGFloat
    let bottomInset: CGFloat
    let onReload: () -> Void
    let onPlay: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: width * 0.12) {
                Button(action: onReload) {
                    Image("reloadButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.26)
                }
                Button(action: onPlay) {
                    Image("playButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.26)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, bottomInset + 32)
        }
    }
}
