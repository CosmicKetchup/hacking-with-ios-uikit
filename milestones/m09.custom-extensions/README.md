# Milestone 9: Beaons & Extensions

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- in Xcode's eyes, single item values are really just single-item tuples
    - writing `-3.times {...}` won't work but `(-3).times {...}` will
- add constraints to extensions with the `where` keyword followed by predicate

### Challenge
> Your challenge this time is not to build a project from scratch. Instead, I want you to implement three Swift language extensions using what you learned in [**project 24**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p24.swift-strings/). I’ve ordered them easy to hard, so you should work your way from first to last if you want to make your life easy!
>
> Here are the extensions I’d like you to implement:
> 1. Extend `UIView` so that it has a `bounceOut(duration:)` method that uses animation to scale its size down to `0.0001` over a specified number of seconds.
> 2. Extend `Int` with a `times()` method that runs a closure as many times as the number is high. For example, `5.times { print("Hello!") }` will print `“Hello”` five times.
> 3. Extend `Array` so that it has a `mutating remove(item:)` method. If the item exists more than once, it should remove only the first instance it finds. **Tip:** you will need to add the `Comparable` constraint to make this work!


### Solution Preview
```swift
import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }, completion: completion)
    }
}

extension Int {
    func times(_ action: () -> Void) {
        guard self > 0 else { return }
        (1...self).forEach { _ in action() }
    }
}

5.times { print("Hello!") }
(-3).times { print("Oops!") }

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        self.remove(at: index)
    }
}

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
assert(numbers == [1, 2, 4, 5])
```
