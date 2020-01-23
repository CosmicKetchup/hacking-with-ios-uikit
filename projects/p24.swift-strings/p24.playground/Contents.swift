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
