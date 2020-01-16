# Milestone 2: World Flags

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- using a `CaseIterable` enum to easily access all countries and corresponding formal name
- custom cell class `CountryCell` with dynamic type font that changes with user preference

### Challenge
> You have a rudimentary understanding of table views, image views, and navigation controllers, so let’s put them together: your challenge is to create an app that lists various world flags in a table view. When one of them is tapped, slide in a detail view controller that contains an image view, showing the same flag full size. On the detail view controller, add an action button that lets the user share the flag picture and country name using `UIActivityViewController`.
>
> To solve this challenge you’ll need to draw on skills you learned in tutorials 1, 2, and 3:
> 1. Start with a Single View App template, then change its main `ViewController` class so that builds on `UITableViewController` instead.
> 2. Load the list of available flags from the app bundle. You can type them directly into the code if you want, but it’s preferable not to.
> 3. Create a new Cocoa Touch Class responsible for the detail view controller, and give it properties for its image view and the image to load.
> 4. You’ll also need to adjust your storyboard to include the detail view controller, including using **Auto Layout** to pin its image view correctly.
> 5. You will need to use `UIActivityViewController` to share your flag.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71431385-83bbcd00-269f-11ea-9418-a7a4adfcec3a.png">
