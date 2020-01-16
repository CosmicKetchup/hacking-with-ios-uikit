# Project 18: Debugging

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- a **variadic** function accepts any number of parameters
- `print()` is variadic but also includes optional parameters
    - the `separator` value is placed between each printed value
    - the `terminator` is placed after the last value; `\n` by default
    - silent presence in released builds
- assertions are debug-only checks which cause the app to crash if `false`
    - disabled for release versions
- **breakpoints** pause code execution when reached, capturing your app's state and values
    - also provides an interactive **LLDB** (low-level debugger) window
- breakpoints can be modified to only trigger upon certain conditions
    - setup an _Exception Breakpoint_ to pause execution when unhandled exception is thrown by application
- Xcode's debug menu includes a button titled _Capture View Hierarchy_, allowing you to explore a three-dimensional representation of the current state of your app

### Additional Challenges
> 1. Temporarily try adding an exception breakpoint to [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/), then changing the call to `instantiateViewController()` so that it uses the storyboard identifier `“Bad”` – this will fail, but your exception breakpoint should catch it.
> 2. In [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/), add a call to `assert()` in the `viewDidLoad()` method of `DetailViewController.swift`, checking that `selectedImage` always has a value.
> 3. Go back to [**project 5**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p05.word-scramble/), and try adding a conditional breakpoint to the start of the `submit()` method that pauses only if the user submits a word with six or more letters.

### Solution Preview
```swift
print(1, 2, 3, separator: "-", terminator: "\n")
```
```swift
assert(self.isUserLoggedIn, "User not yet authenticated.")
```
