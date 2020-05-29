# Project 22: Detect-a-Beacon

### Personal Notes
- adding three available `CLBeacon` nodes to select from and corresponding buttons at the top of application
    - selecting a different node causes view to restart monitoring and ranging for the appropriate beacon
- saving known/connected beacon UUIDs in `UserDefaults` with `NSCoding`
- overriding `layoutSubviews` within custom view `Proximity Sensor` to create circle
- utilizing protocol/delegate communication pattern to resize the proximity view
- forcing `UIStatusBarStyle.darkContent` to contrast status bar elements against light background color

### Additional Challenges
> 1. Write code that shows a `UIAlertController` when your beacon is first detected. Make sure you set a `Boolean` to say the alert has been shown, so it doesn’t keep appearing.
> 2. Go through two or three other **iBeacons** in the **Locate Beacon** app and add their UUIDs to your app, then register all of them with iOS. Now add a second label to the app that shows new text depending on which beacon was located.
> 3. Add a circle to your view, then use animation to scale it up and down depending on the distance from the beacon – try `0.001` for unknown, `0.25` for far, `0.5` for near, and `1.0` for immediate. You can make the circle by adding an image, or by creating a view that’s `256` wide by `256` high then setting its `layer.cornerRadius` to `128` so that it’s round.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/72777571-1e96c100-3be4-11ea-8a4a-79aaca2730f6.png">
