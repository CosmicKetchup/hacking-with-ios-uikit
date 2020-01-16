# Project 17: Space Race

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- per-pixel collision detection works by simply passing size and texture into `SKPhysicsBody`
- the `advanceSimulationTime(_:)` method allows you to simulate that a defined time has already elapsed from the perspective of the `SKEmitterNode`

### Additional Challenges
> 1. Stop the player from cheating by lifting their finger and tapping elsewhere – try implementing `touchesEnded()` to make it work.
> 2. Make the timer start at one second, but then after `20` enemies have been made subtract `0.1` seconds from it so it’s triggered every `0.9` seconds. After making `20` more, subtract another `0.1`, and so on. **Note:** you should call `invalidate()` on `gameTimer` before giving it a new value, otherwise you end up with multiple timers.
> 3. Stop creating space debris after the player has died.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/72227850-206edd80-356f-11ea-9c9d-9e4a893cd050.png">
