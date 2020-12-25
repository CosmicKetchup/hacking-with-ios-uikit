# Project 32: SwiftSearcher

### Personal Notes
- `NSAttributedString` allows the formatting of a string with various attributes
- the `SFSafariViewController` provides an embedded Safari browser within the application
    - introduced in iOS 9
    - includes security, consistent UI, content blocking
    - you must `import SafariServices` to gain access to this class
- enable Reader Mode (if available) by passing an `SFSafariViewController.Configuration` into the declaration
    - e.g. `SFSafariViewController(url:configuration:)`
    - `.entersReaderModeIfAvailable = true`
- creating a `CSSearchableItem` allows you to add an item to Spotlight's searchable index, along with an incredible amount of information
    - the item requires a unique identifier internal to the application and a domain identifier
- by default, indexed content expires after one (1) month, but this can be changed
- deep-linking is done with the method `application(_:continue:restorationHandler:)` within `AppDelegate.swift`

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/103112682-08c82200-4625-11eb-867a-4a2cea4fedc4.png">
