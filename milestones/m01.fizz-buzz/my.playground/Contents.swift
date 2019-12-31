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


fizzbuzz(number: 3)
fizzbuzz(number: 5)
fizzbuzz(number: 15)
fizzbuzz(number: 16)
