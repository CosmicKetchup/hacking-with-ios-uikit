# Project 12: UserDefaults

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- **Important:** `UserDefaults` is **not** a secure storage solution; any sensitive information should be written to the keychain instead!
- `NSCoding` is a great way to read and write data when using `UserDefaults`, and is the most common option when you must write **Swift** code that lives alongside **Objective-C** code.
- to use `UserDefaults` with `NSCoding` you must follow the rules:
    1. All data types must be either booleans, integers, floats, doubles, strings, arrays, dictionaries, `Date` or a class.
    2. If data type is a class, it must conform to `NSCoding` protocol.
    3. If data type is array or dictionary, all keys must match _either_ of first two rules.
- conforming to `NSCoding` also requires:
    1. the use of _objects_, or structs that are interchangeable with objects (i.e. Swift classes)
    2. inheriting from `NSObject`
- the primary differences for `Codable` compared to `NSCoding` is that:
    - `Codable` works on _both_ structs and classes
    - conforming to `Codable` protocol doesn't require additional methods for encoding/decoding unless precise control is desired
    - `Codable` protocol reads and writes **JSON** natively

### Additional Challenges
> 1. Modify [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/) so that it remembers how many times each storm image was shown – you don’t need to show it anywhere, but you’re welcome to try modifying your original copy of project 1 to show the view count as a subtitle below each image name in the table view.
> 2. Modify [**project 2**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p02.guess-the-flag/) so that it saves the player’s highest score, and shows a special message if their new score beat the previous high score.
> 3. Modify [**project 5**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p05.word-scramble/) so that it saves the current word and all the player’s entries to `UserDefaults`, then loads them back when the app launches.

### Solution Preview
```swift
private func saveData() {
    let defaults = UserDefaults.standard
    if let savedData = try? JSONEncoder().encode(people) {
        defaults.set(savedData, forKey: "savedPeople")
    }
    else {
        print("Failed to save people.")
    }
}
```
```swift
private func loadData() {
    let defaults = UserDefaults.standard

    if let savedData = defaults.object(forKey: "savedPeople") as? Data {
        do {
            people = try JSONDecoder().decode([Person].self, from: savedData)
        }
        catch {
            print("Failed to load saved people.")
        }
    }
}
```
