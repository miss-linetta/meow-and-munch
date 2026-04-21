//
//  GameViewModel.swift
//  test-task-Magic-Forge
//

import SwiftUI

class GameViewModel: ObservableObject {

    // MARK: - Published state

    @Published var slots: [FruitItem]
    @Published var targets: [String]            // base names of target shapes
    @Published var guessedFruits: Set<String> = []
    @Published var characterState: CharacterState = .idle
    @Published var isLevelComplete = false

    // MARK: - Internal

    var slotFrames: [String: CGRect] = [:]      // target base name → frame in gameArea

    // MARK: - Init

    init() {
        targets = ["Raspberry", "Banana", "Kiwi"]
        slots = [
            FruitItem(name: "Strawberry", isCorrect: false),
            FruitItem(name: "Kiwi",       isCorrect: true),
            FruitItem(name: "Raspberry",  isCorrect: true),
            FruitItem(name: "Apple",      isCorrect: false),
            FruitItem(name: "Banana",     isCorrect: true),
        ]
    }

    // MARK: - Game logic

    func tryMatch(fruitName: String, at location: CGPoint) {
        for (targetName, frame) in slotFrames {
            if frame.insetBy(dx: -30, dy: -30).contains(location) {
                if fruitName == targetName {
                    handleCorrect(fruitName)
                } else {
                    handleWrong()
                }
                return
            }
        }
    }

    func resetLevel() {
        withAnimation {
            guessedFruits    = []
            characterState   = .idle
            isLevelComplete  = false
        }
    }

    // MARK: - Private

    private func handleCorrect(_ name: String) {
        withAnimation(.easeInOut(duration: 0.5)) {
            guessedFruits.insert(name)
            characterState = .happy
        }
        let allGuessed = targets.allSatisfy { guessedFruits.contains($0) || $0 == name }
        if allGuessed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation { self.isLevelComplete = true
                               self.characterState   = .victory }
            }
        }
    }

    private func handleWrong() {
        characterState = .sad
    }
}
