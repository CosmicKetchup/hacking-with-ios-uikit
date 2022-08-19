# Milestone 11: Matchfinder

### Personal Notes
- created `CardMatrix` custom view to handle grid of cards in stack views
- once again using protocols and delegates to communicate between views
- preventing additional card flips by enabling and disabling `isUserInteractionEnabled` at the appropriate times
- game automatically restarts after completion
- heavy use of enums and custom initializers to allow for enhancement

### Challenge
> Your challenge is to create a memory pairs game that has players find pairs of cards – it’s sometimes called _Concentration_, _Pelmanism_, or _Pairs_. At the very least you should:
>
> - Come up with a list of pairs. Traditionally this is two pictures, but you could also use capital cities (e.g. one card says France and its match says Paris), languages (e.g one card says _“hello”_ and the other says _“bonjour”_), and so on.
> - Show a grid of face-down cards. How many is down to you, but if you’re targeting iPad I would have thought 4x4 or more.
> - Let the player select any two cards, and show them face up as they are tapped.
> - If they match remove them; if they don’t match, wait a second then turn them face down again.
> - Show a _You Win_ message once all are matched.
>
> You can use either `SpriteKit` or `UIKit` depending on which skill you want to practice the most, but I think you’ll find `UIKit` much easier.
>
> Don’t under-estimate this challenge! To make it work you’re going to need to draw on a wide variety of skills, and it will push you. That’s the point, though, so take your time and give yourself space to think.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185703055-833c9f02-3ac8-4179-a396-83a11cd639de.png">
