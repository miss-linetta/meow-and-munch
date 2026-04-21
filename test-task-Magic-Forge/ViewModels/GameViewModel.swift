//
//  GameViewModel.swift
//  test-task-Magic-Forge
//

import SwiftUI
import AVFoundation

class GameViewModel: ObservableObject {

    @Published var slots: [FruitItem]
    @Published var targets: [String]
    @Published var guessedFruits: Set<String> = []
    @Published var characterState: CharacterState = .idle
    @Published var isLevelComplete = false
    @Published var dragPosition: CGPoint?
    @Published var isDragging = false

    var slotFrames: [String: CGRect] = [:]
    private var audioPlayer: AVAudioPlayer?

    init() {
        targets = ["Raspberry", "Banana", "Kiwi"]
        slots = [
            FruitItem(name: "Strawberry", isCorrect: false),
            FruitItem(name: "Kiwi",       isCorrect: true),
            FruitItem(name: "Raspberry",  isCorrect: true),
            FruitItem(name: "Apple",      isCorrect: false),
            FruitItem(name: "Banana",     isCorrect: true),
        ]
        if let asset = NSDataAsset(name: "victory-sound") {
            audioPlayer = try? AVAudioPlayer(data: asset.data, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.prepareToPlay()
        }
    }

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
            guessedFruits   = []
            characterState  = .idle
            isLevelComplete = false
        }
    }

    private func handleCorrect(_ name: String) {
        withAnimation(.easeInOut(duration: 0.5)) {
            guessedFruits.insert(name)
            characterState = .happy
        }
        let allGuessed = targets.allSatisfy { guessedFruits.contains($0) }
        if allGuessed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation {
                    self.isLevelComplete = true
                    self.characterState  = .victory
                }
                self.playVictorySound()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if self.characterState == .happy {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.characterState = .idle
                    }
                }
            }
        }
    }

    private func playVictorySound() {
        audioPlayer?.play()
    }

    private func handleWrong() {
        withAnimation(.easeInOut(duration: 0.4)) {
            characterState = .sad
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.characterState == .sad {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.characterState = .idle
                }
            }
        }
    }
}
