# Project 5: Word Scramble

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- the `UITableViewController` class includes helpful methods to interact with specific sections and rows, allowing granular management instead of needed to reload the entire table view
- it's important to sanitize user-provided data and ensure it conforms to the necessary format internally before manipulating it
- updated for project 12 challenges
    - existing source word and answers are saved in `UserDefaults`

### Additional Challenges
> 1. Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into `isReal()` that returns `false` if the word length is under three letters. For the second part, just compare the start word against their input word and return `false` if they are the same.
> 2. Refactor all the  `else` statements we just added so that they call a new method called `showErrorMessage()`. This should accept an error message and a title, and do all the `UIAlertController` work from there.
> 3. Add a left bar button item that calls `startGame()`, so users can restart with a new word whenever they want to.
>
> **Bonus:** Once you’ve done those three, there’s a really subtle bug in our game and I’d like you to try finding and fixing it. To trigger the bug, look for a three-letter word in your starting word, and enter it with an uppercase letter. Once it appears in the table, try entering it again all lowercase – you’ll see it gets entered. Can you figure out what causes this and how to fix it?

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71432057-a6041980-26a4-11ea-829a-c0c049f71f9b.png">
