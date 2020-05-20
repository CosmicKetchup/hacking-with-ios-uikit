# Project 25: Selfie Share

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2020.01.31-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.4.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.2-FA7343?logo=swift)](#)

### Personal Notes
- all multipeer services for iOS must declare a service type - a unique 15-digit string to identify the service
    - may only contain letters, numbers and hyphens
- if hosting a session with one or more connected peers, an option is available to _List Current Connections_ and see names of all peer devices
- **TODO:** update to support scene pattern for Xcode 11; the following changes were employed in order to get a working app
    - current target is iOS 12.4
    - `SceneDelegate.swift` was removed
    - _Application Scene Manifest_ was removed from `Info.plist`
    - `AppDelegate.swift` was recreated to include all methods provided from previous version of Xcode


### Additional Challenges
> 1. Show an alert when a user has disconnected from our multipeer network. Something like _“Paul’s iPhone has disconnected”_ is enough.
> 2. Try sending text messages across the network. You can create a `Data` from a string using `Data(yourString.utf8)`, and convert a `Data` back to a string by using `String(decoding: yourData, as: UTF8.self)`.
> 3. Add a button that shows an alert controller listing the names of all devices currently connected to the session – use the `connectedPeers` property of your session to find that information.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/73027575-aa396900-3e01-11ea-91c0-26caa29b7c78.png">
