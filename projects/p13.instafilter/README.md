# Project 13: Instafilter

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- set content hugging priority to `.defaultHigh` for image preview wrapper `previewWindow`
- you can set the minimum and maximum values for a `UISlider` instance
- created enum for `CIFilter` types; conforming to `CaseIterable` allowing for easy `forEach` loops
- custom, failable initializer for enum `CIFilterType` used for changing button title

### Additional Challenges
> 1. Try making the _Save_ button show an error if there was no image in the image view.
> 2. Make the _Change Filter_ button change its title to show the name of the currently selected filter.
> 3. Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71869936-0900a200-30e2-11ea-9196-f48911d6e38d.png">
