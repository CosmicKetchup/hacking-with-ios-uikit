# Milestone 5: Photo Journal

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2020.01.31-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.4.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.2-FA7343?logo=swift)](#)

### Personal Notes
- including additional option to select from device photo library
    - both options require explicit permission from user
- `PhotoDetailViewController` includes translucent area with caption (if photo contains one and is not an empty string)

### Challenge
> Your challenge is to put two different projects into one: I’d like you to let users take photos of things that interest them, add captions to them, then show those photos in a table view. Tapping the caption should show the picture in a new view controller, like we did with our first project. So, your finished project needs to use elements from both [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/) and [**project 12**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p12.userdefaults/), which should give you ample chance to practice.
>
> This will require you to use the `picker.sourceType = .camera` setting for your image picker controller, create a custom type that stores a filename and a caption, then show the list of saved pictures in a table view. **Remember:** using the camera is only possible on a physical device.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71830179-3282e480-3074-11ea-89b1-25f610b46094.png">
