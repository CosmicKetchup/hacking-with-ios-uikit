# Milestone 4: Hangman

### Personal Notes
- added tags to each `strikeLabel` to quickly identify and manipulate the appropriate subview
    - identified using the `viewWithTag(_:)` method
- separating chained methods on new lines can help with code cleanliness
```swift
availableWords = contents
    .components(separatedBy: "\n")
    .compactMap { str in
        guard !str.isEmpty else { return nil }
        return str.uppercased() }
    .shuffled()
```

### Challenge
> This is the first challenge that involves you creating a game. You’ll still be using `UIKit`, though, so it’s a good chance to practice your app skills too.
>
> The challenge is this: make a hangman game using `UIKit`. As a reminder, this means choosing a random word from a list of possibilities, but presenting it to the user as a series of underscores. So, if your word was **RHYTHM** the user would see **??????**.
>
> The user can then guess letters one at a time: if they guess a letter that is in the word, e.g. **H**, it gets revealed to make **?H??H?**; if they guess an incorrect letter, they inch closer to death. If they get seven incorrect answers they lose, but if they manage to spell the full word before that they win.
>
> That’s the game: can you make it? Don’t underestimate this one: it’s called a challenge for a reason – it’s supposed to stretch you!

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185697248-fd3f356f-04cf-47f1-8c70-8cd033689965.png">
