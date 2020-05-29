# Project 24: Swift Strings

### Personal Notes
- where appropriate, it's more efficient to simply check `string.isEmpty` rather than its `count` property

### Additional Challenges
> 1. Create a `String` extension that adds a `withPrefix()` method. If the string already contains the prefix it should return itself; if it doesn’t contain the prefix, it should return itself with the prefix added. For example: `"pet".withPrefix("car")` should return `“carpet”`.
> 2. Create a `String` extension that adds an `isNumeric` property that returns true if the string holds any sort of number. **Tip:** creating a `Double` from a `String` is a failable initializer.
> 3. Create a `String` extension that adds a lines property that returns an array of all the lines in a string. So, “this\nis\na\ntest” should return an array with four elements.

### Solution Preview
```swift
import Foundation


extension String {
    func withPrefix(_ input: String) -> String {
        self.hasPrefix(input) ? self : input + self
    }

    var isNumeric: Bool {
        Double(self) != nil
    }

    var lines: [String] {
        self.components(separatedBy: "\n")
    }
}

assert("pet".withPrefix("car") == "carpet")

assert("123".isNumeric)
assert(!"75C".isNumeric)
assert("3.14159".isNumeric)

assert("this\nis\na\ntest".lines == ["this", "is", "a", "test"])

```
