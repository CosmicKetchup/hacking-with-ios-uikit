# Project 14: Whack-a-Penguin

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.2-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- a node's `zPosition` determines it's position in regards to layer depth
- setting an `SKCropNode().cropMask` is used to hide any child node's image _unless_ it's contained within the non-transparent part of the parent crop node
- actions listed within an `SKAction.sequence()` are executed in order, waiting for the previous to finish


### Additional Challenges
> 1. Record your own voice saying _"Game over!"_ and have it play when the game ends.
> 2. When showing _Game Over_ add an `SKLabelNode` showing their final score.
> 3. Use `SKEmitterNode` to create a smoke-like effect when penguins are hit, and a separate mud-like effect when they go into or come out of a hole.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71987339-02664d80-31fc-11ea-85f9-7e70501e3d82.png">
