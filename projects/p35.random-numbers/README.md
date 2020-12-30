# Project 35: Random Numbers

### Personal Notes
- Swift 4.2 introduced basic but native random generation for a variety of types; however these are **not** to be used for secure data
- these basic methods accept an inclusive range and are automatically seeded which means they are given an initial value to make each call unique
- the `GKRandomSource` class is the basic way for generating randomness within `GameplayKit`
    - `GKRandomSource.sharedRandom().nextInt(upperBound:)` will produce a number between 0 and the defined `Int`, exclusively
    - `nextBool()` generates a random true/false value
    - `nextUniform()` generates a random floating point number between 0 and 1
- `GameplayKit` also offers three custom sources of random number generation; all are deterministic and can be serialized
    - `GKLinearCongruentialRandomSource` - high performance, low randomness
    - `GKMersenneTwisterRandomSource` - low performance, high randomness
    - `GKARC4RandomSource` - decent performance, decent randomness
        - **Note:** Apple recommends to force flush ARC4 random generator before use for anything important by dropping _at least_ the first 769 values (e.g. `.dropValues(769)`)
- you can also shape the distribution within the random generator
    - `GKRandomDistribution`
    - `GKShuffledDistribution` ensures that sequences repeat less frequently by preventing values from being generated until all other values appear
    - `GKGaussianDistribution` enforces a bell-curve output for values
- the method `byShufflingObjects(in:)` returns a _new_ array
- it's possible to _seed_ the generation types

### Solution Preview

```swift
import GameplayKit
import UIKit

// introduced in Swift 4.2
let randomInt = Int.random(in: 0 ... 10)
let randomDouble = Int.random(in: 1000 ..< 10000)
let randomFloat = Float.random(in: -100 ... 100)
let randomBool = Bool.random()

// basic method of random number generation using GameplayKit
let randomGKInt = GKRandomSource.sharedRandom().nextInt()
let randomGKInt2 = GKRandomSource.sharedRandom().nextInt(upperBound: 10)      // returns value between 0 and 9

// three custom random generation sources
let linearRandom = GKLinearCongruentialRandomSource().nextInt()
let mersenneRandom = GKMersenneTwisterRandomSource().nextInt()
let arc4Random = GKARC4RandomSource().nextInt()

let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d859 = GKRandomDistribution(lowestValue: 1, highestValue: 859)
d859.nextInt()

// returns each value in different orders, but only once until all other values have appeared
let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

// shuffles the array of numbers the same way each time it's loaded
let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])
```
