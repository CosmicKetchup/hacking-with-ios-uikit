# Personal Notes

[![](https://img.shields.io/badge/Hacking%20With%20iOS-2019.10.26-36A9AE?logo=swift)](https://www.hackingwithswift.com/read) [![](https://img.shields.io/badge/Xcode-11.2-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

- **type-safe** language allowing you to be clear about the type of data used inside a variable or constant, or if it's possible that there won't be a value at all
- **type annotation** allows you to explicitly assign the type of data a container will store
- **type inference** is the mechanism employed to examine and automatically guess the appropriate data type
- **string interpolation** is a method of constructing a new `String` by including containers inside a string literal
- **optional binding** allows you to check if an optional contains a value, safely unwrapping the data if it exists
- **value binding** is the behavior of decomposing a collection into discrete, temporary containers
- **optional chaining** is the process for querying and calling properties, methods and subscripts on an optional that may be `nil`
- **class inheritence** refers to the technique of building a new class on top of, and with all the properties of, an existing class

#### Variables & Constants
- `var` and `let` are known as container introducers
- container names can contain almost any character, including Unicode
- multiple variables or constants can be set in-line, separated by commas
    - `let firstName = "Taylor", lastName = "Swift"`
    - `var xV, yV, zV: Double`

#### Data Types
- `Float` and `Double` are 32- and 64-bit data types (respectively) for floating point numbers
    - `Double` has higher precision and is preferred
- signed and unsigned integers in 8-, 16-, 32- and 64-bit flavors are available
    - generic `Int` is preferred as it conform's to the current platform's native word size
- when converting to `Int`, the resulting value will be truncated, not rounded
- tuples allow you to group multiple values of **any** type together
    - can be easily decomposed into individual containers or ignored entirely
        - `let (firstName, age, _) = ("Taylor", 30, "female")`
    - elements can be named when defined
        - `let httpStatus = (code: 200, description: "OK")`
- substrings utilize the same memory as the original string and are not meant for long-term storage

#### Collections
- the rarely used long-form syntax of each collection type:
    - `Array<Element>`
    - `Set<Element>`
    - `Dictionary<Key, Value>`
- creating an array with a default value and size/count:
    - `var threeDoubles = Array(repeating: 0.0, count: 3)`
- a type must be `Hashable` (and by extension, `Equatable`) in order to be stored in a set
- sets have several useful and powerful methods:
    - `intersection(_:)` creates a new set with only values common to both sets
    - `symmetricDifference(_:)` creates a new set with only non-shared values
    - `union(_:)` creates a new set with all values in both sets
    - `subtracting(_:)` creates a new set from base, removing shared values found in target
    - `isSubset(of:)` to determine if all values from base set are contained within target
    - `isSuperSet(of:)` to determine if all values of target are contained within base
    - `isStrictSubSet(of:)` or `isStrictSuperSet(of:)` to determine if a set is a subset/superset of target, **but not equal to** the target
    - `isDisjoint(with:)` to determine if a set has no shared values with target
- because keys in a dictionary must be unique, the key value must conform to `Hashable`
- you can initialize a new array from only a dictionary's keys or values:
    - `let airportCodes = [String](airports.keys)`
    - `let airportNames = [String](airports.values)`

#### Operators
- the remainder operator `%` is a binary, infix operator that returns the remainder of its targets
    - **ex.** `9 % 4` returns `1`
- arithmetic operators **do not** allow values to overflow by default
- the **nil-coalescing operator** unwraps an optional if it contains a value while providing a default value if the optional is `nil`

#### Flow Control
- `while` loops evaluate the condition before entering, whereas `repeat-while` loops enter the loop at least once, then evaluate the condition at the end
- **labeled statements** allow you to end execution of the enclosing statement when desired
- switch cases are evaluated sequentially, which places added importance on the order in which they are presented

#### Enumerations
- enums are powerful value types which employ many of the features of classes
- can be initialized from raw values
    - `let earth = Planet(rawValue: 3)`
    - initialization using `rawValue` returns optional case
- identify **recursive** cases by marking it with keyboard `indirect` before it
    - alternatively, marking all cases as recursive is possible by tagging the enum with `indirect`

#### Structs
- structs automatically generate a **memberwise initializer**
    - this _free_ initializer is forfeited if a custom initializer is defined
    - you can retain this automatic, general initializer by defining custom inits in an extension
- structs (and enums) are value types, copied (**copy on write**) to a standalone instance


#### Classes
- classes are reference types; changes to a copy of an object are reflected across all references to that object
- include **identity operators** which allow you to check if two containers refer to the same instance of a class
    - `===` determines if two objects are identical
    - `!==` evaluates if two objects are _not_ identical
- you can prevent further subclassing by marking a class as `final`

#### Properties
- **type properties** allow you to define static containers associated with that type
    - the `static` keyword denotes stored type properties, which are _static_ and cannot be overwritten
    - the `class` keyword denotes computed type properties that _can_ be overwritten by subclasses

#### Functions & Methods
- you have the ability to provide both _internal_ and _external_ names for parameters
    - also possible to skip the external name altogether by writing `_` in its place
- if the entire body of a function is a single expression, the function implicitly returns that expression's value
- functions belonging to a struct or class are called **methods**
- in order to modify value types (i.e. structs or enums), you can opt in to mutating behavior for that method by prefacing its definition with the `mutating` keyword
    - this technique also allows you to assign an entirely new `self` from the transformation
- adding the keyword `@discardableResult` before a function's definition will allow you to ignore a returned value,
- similar to classes, you can prevent overrides by marking a method or property as `final`

#### Closures
- **trailing closure syntax** is the mechanism where, if the last parameter of a function is a closure, the parameter can be omitted and added as a trailing block of code instead

#### Protocols & Delegates
- protocols are effectively contracts which define methods and properties that a type must implement internally
- property requirements are always declared as variables
- optional requirements can be defined by adding the `optional` keyword to the front of the function or property
- **delegation** is a design pattern that allows a class or structure to hand off some responsibilities to an instance of another type
