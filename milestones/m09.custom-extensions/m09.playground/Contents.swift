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
