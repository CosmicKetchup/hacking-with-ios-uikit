# Milestone 10: Meme Generator

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- using the `UIImagePickerController` does not require user permission
- Swift includes several compiler directives such as:
    - `#if targetEnvironment(simulator)`
    - `#if swift(>=5.0)`
    - `#line`, `#filename`, and `#function`

### Challenge
> Your challenge for this milestone is to create a meme generation app using `UIImagePickerController`, `UIAlertController`, and `Core Graphics`. If you aren’t familiar with them, memes are a simple format that shows a picture with one line of text overlaid at the top and another overlaid at the bottom.
>
> Your app should:
> - Prompt the user to import a photo from their photo library.
> - Show an alert with a text field asking them to insert a line of text for the top of the meme.
> - Show a second alert for the bottom of the meme.
> - Render their image plus both pieces of text into one finished `UIImage` using **Core Graphics**.
> - Let them share that result using `UIActivityViewController`.
>
> Both the top and bottom pieces of text should be optional; the user doesn’t need to provide them if they don’t want to.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/73116822-f45a4180-3f0a-11ea-9538-296e5ec43c1a.png">
