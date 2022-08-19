# Milestone 10: Meme Generator

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
<img src="https://user-images.githubusercontent.com/4438390/185702726-6050490c-a869-41ab-8a6a-3354b55f431b.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185702755-bbeba868-3697-4c6b-aee6-85c9f6b7a7c7.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185702776-4b608ca5-d4b0-46f3-bd6d-ea6f30788d8f.png" style="float:left; width: 30%; margin-left: 1%">
