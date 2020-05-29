# Project 11: Pachinko

### Personal Notes
- within `SpriteKit`, `y: 0` is considered the bottom of the screen, as opposed to `UIKit` which is the top
    - additionally, `UIKit` considers origin of each view to be `(x: 0, y: 0)`, while `SpriteKit` allows you to customize the anchor point
- Apple recommends adding names to each node in order to more easily identify them
- by default, an `SKAction` will execute only once
    - to repeat forever, wrap it within _another_ `SKAction` including property `.repeatForever`
- the `contactTestBitMask` property allows you to indicate which collisions you want to know about
- a node's `collisionBitMask` property indicates other nodes which exist on the same plane
    - e.g. which nodes can interact with or bump into the current node
- if `SpriteKit` reports a collision twice, there's an issue
    - did the ball hit the bouncer? or did the bouncer hit the ball?
- prepped for possible future enhancement including multiple difficulty levels
- automated new game setup, placing number of boxes corresponding to difficulty level

### Additional Challenges
> 1. The pictures we’re using in have other ball pictures rather than just `ballRed`. Try writing code to use a random ball color each time they tap the screen.
> 2. Right now, users can tap anywhere to have a ball created there, which makes the game too easy. Try to force the `Y` value of new balls so they are near the top of the screen.
> 3. Give players a limit of five balls, then remove obstacle boxes when they are hit. Can they clear all the pins with just five balls? You could make it so that landing on a green slot gets them an extra ball.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71634423-efdf8900-2be9-11ea-84d1-ad01c5da7163.png">
