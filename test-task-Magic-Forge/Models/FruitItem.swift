//
//  FruitItem.swift
//  test-task-Magic-Forge
//

import Foundation

struct FruitItem: Identifiable {
    let id = UUID()
    let name: String      // base name: "Raspberry", "Banana", etc.
    let isCorrect: Bool   // whether this fruit matches one of the targets

    var circleName: String  { "\(name)_circle" }
    var shapeName: String   { "\(name)_shape" }
    var guessedName: String { "\(name)_guessed" }
}

enum CharacterState {
    case idle, sad, happy, victory
}
