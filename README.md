# Meow & Munch

A children's drag-and-drop fruit feeding game for iOS built with SwiftUI.

## Gameplay

Drag the fruit badges from the bottom basket to the matching silhouettes at the top. Match all 3 correct fruits to win. Wrong matches make the cat sad, correct ones make it happy.

## Technologies

- **SwiftUI** — UI framework, animations, transitions
- **MVVM** — `GameViewModel` manages game state, views are purely reactive
- **DragGesture** — fruit drag-and-drop with named coordinate space
- **matchedGeometryEffect** — animated fruit-to-silhouette merge on correct match
- **PreferenceKey** — cross-view frame tracking for hit detection and eye tracking
- **GeometryReader** — responsive layout scaled to any screen size
- **DispatchQueue** — timed state resets and sequenced animations

## Requirements

- iOS 18.2+
- Xcode 16.2+

## Build

Open `test-task-Magic-Forge.xcodeproj` in Xcode and run on a simulator or device.
