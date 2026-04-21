//
//  test_task_Magic_ForgeApp.swift
//  test-task-Magic-Forge
//
//  Created by admin on 21.04.2026.
//

import SwiftUI

@main
struct test_task_Magic_ForgeApp: App {
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        isLoading = false
                    }
                }
            }
        }
    }
}
