//
//  TopButtonsView.swift
//  test-task-Magic-Forge
//

import SwiftUI

struct TopButtonsView: View {
    let width: CGFloat
    let onPause: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: onPause) {
                    Image("pauseButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.14)
                }
                Spacer()
                Button(action: {}) {
                    Image("levelButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width * 0.14)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, -5)
            Spacer()
        }
    }
}
