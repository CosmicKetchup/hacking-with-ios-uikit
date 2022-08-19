# Project 10: Names to Faces

### Personal Notes
- the `UICollectionViewDelegateFlowLayout` protocol is what allows you to generate a grid layout for collection views
    - available _optional_ methods to define cell size and spacing
- anchored the alert to the left/right sides of a cell when tapped
    - requires you to provide the `sourceView` and `sourceRect`
- using [**SF Symbol**](https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/) for `leftBarButtonItem` for loading _demo_ content
    - i.e. storm images from project 1 to complete challenge 3

### Additional Challenges
> 1. Add a second `UIAlertController` that gets shown when the user taps a picture, asking them whether they want to rename the person or delete them.
> 2. Try using `picker.sourceType = .camera` when creating your image picker, which will tell it to create a new image by taking a photo. This is only available on devices (not on the simulator) so you might want to check the return value of `UIImagePickerController.isSourceTypeAvailable()` before trying to use it!
> 3. Modify [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/) so that it uses a collection view controller rather than a table view controller. I recommend you keep a copy of your original table view controller code so you can refer back to it later on.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185703435-45505313-88d7-4f2a-8c88-9432fd2487e9.png">
