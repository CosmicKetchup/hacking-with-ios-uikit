# Milestone 1: Fizz Buzz

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2020.01.31-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.4.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.2-FA7343?logo=swift)](#)

### Personal Notes
- using the `isMultiple(of:)` method instead of the modulus/remainder operator
- including ternary operator inside the first check for cases where number is divisible by both `3` and `5`

### Challenge
> At this point you should be fairly comfortable with data types, conditions, loops, functions, and more, so your first challenge is to complete the Fizz Buzz test. This is a famous test commonly used to root out bad programmers during job interviews, and it goes like this:
>
> - Write a function that accepts an integer as input and returns a string.
> - If the integer is evenly divisible by `3` the function should return the string `“Fizz”`.
> - If the integer is evenly divisible by `5` the function should return `“Buzz”`.
> - If the integer is evenly divisible by `3` and `5` the function should return `“Fizz Buzz”`
> - For all other numbers the function should just return the input number.
>
> To solve this challenge you’ll need to use quite a few skills you learned in this tutorial:
>
> 1. Write a function called `fizzbuzz()`. It should accept an `Int` parameter, and return a `String`.
> 2. You’ll need to use `if` and `else if` conditions to check the input number.
> 3. You need use modulus, `%`, to check for even division. You’ll also need to use `&&` to check for two things at once, because `“Fizz Buzz”` should only be printed if the input number is evenly divisible by `3` and `5`.
>
> Here are some test cases for you to use:
>
> - `fizzbuzz(number: 3)`
> - `fizzbuzz(number: 5)`
> - `fizzbuzz(number: 15)`
> - `fizzbuzz(number: 16)`

### Solution Preview
```swift
import Foundation

func fizzbuzz(number: Int) -> String {
    if number.isMultiple(of: 3) {
        return number.isMultiple(of: 5) ? "Fizz Buzz" : "Fizz"
    }
    else if number.isMultiple(of: 5) {
        return "Buzz"
    }
    else {
        return number.description
    }
}
```
