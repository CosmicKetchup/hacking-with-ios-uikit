# Milestone 7: Target Practice

### Personal Notes
- an `SKAction.group` allows you to run multiple animations simultaneously
    - whereas `.sequence` runs in order
- call `.removeAllActions()` to remove all running actions associated with a node
    - if you name your actions, you can target them easier later
    - `node.removeActionForKey("rotate")`
- heavy use of enums with associated values
- added sound effects for throwing, reloading and hits with snowballs

### Challenge
>  It’s time to put your skills to the test and make your own app, starting from a blank canvas. This time your challenge is to make a shooting gallery game using `SpriteKit`: create three rows on the screen, then have targets slide across from one side to the other. If the user taps a target, make it fade out and award them points.
>
> How you implement this game really depends on what kind of shooting gallery games you’ve played in the past, but here are some suggestions to get you started:
> - Make some targets big and slow, and others small and fast. The small targets should be worth more points.
> - Add _bad_ targets – things that cost the user points if they get shot accidentally.
> - Make the top and bottom rows move left to right, but the middle row move right to left.
> - Add a timer that ticks down from `60` seconds. When it hits zero, show a _Game Over_
message.
> - Try going to [**https://openclipart.org/**](https://openclipart.org/) to see what free artwork you can find.
> - Give the user six bullets per clip. Make them tap a different part of the screen to reload.
>
> Those are just suggestions – it’s your game, so do what you like!

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/72535490-9cef0e00-3846-11ea-809b-ee0f555d617c.png">

### How to Play
It's Christmas day and all the neighborhood kids are outside playing in the snow! Some are building forts while others are building snowmen. It's not too long though before the sound of laughter turns into shrieks of terror as a massive snowball fight breaks out!

1. Tap the screen to throw snowballs from your stash.
    - Keep an eye on how many snowballs are left on the right side of the screen. If you want more snowballs, simply tap the pile right in front of you.
2. You'll earn a point for every kid you hit.
3. But don't hit the snowmen, otherwise you'll lose three points.
4. Keep an eye out for Santa on his journey back to the North Pole. I wonder if he wants to play?
