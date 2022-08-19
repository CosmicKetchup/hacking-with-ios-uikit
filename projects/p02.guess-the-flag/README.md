# Project 2: Guess the Flag

### Personal Notes
- using enum `AlertType` with associated values, alongside discrete method for easily displaying corresponding alert and information
- using the `didSet` property observer to update score label in navigation bar
    - also, disabled user interaction on score label
- using `UIStackView` for flags; axis depends on vertical size trait
- tracks running high score for players in `UserDefaults`
- displays special alert if user completes game with new high score

### Additional Challenges
> 1. Try showing the player’s score in the navigation bar, alongside the flag to guess.
> 2. Keep track of how many questions have been asked, and show one final alert controller after they have answered ten. This should show their final score.
> 3. When someone chooses the wrong flag, tell them their mistake in your alert message – something like _“Wrong! That’s the flag of France.”_ for example.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185001397-3870017f-647a-410f-be05-994559e49f2f.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185001495-a5e23be8-c7a8-4cdf-ba69-c0aa1ea12c04.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185001558-7facb53b-d92e-42ac-9426-48b8075e7966.png" style="float:left; width: 30%; margin-left: 1%">
