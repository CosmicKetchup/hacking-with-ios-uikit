import GameplayKit
import UIKit

let randomInt = Int.random(in: 0 ... 10)
let randomDouble = Int.random(in: 1000 ..< 10000)
let randomFloat = Float.random(in: -100 ... 100)
let randomBool = Bool.random()

let randomGKInt = GKRandomSource.sharedRandom().nextInt()
let randomGKInt2 = GKRandomSource.sharedRandom().nextInt(upperBound: 10)      // returns value between 0 and 9

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
