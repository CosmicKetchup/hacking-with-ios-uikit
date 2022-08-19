# Milestone 3: Shopping List

### Personal Notes
- user entry is sanitized in order to easily check for duplicates
- using the `removeAll(keepingCapacity:)` collection method, allowing me to preserve the collection's storage since the user will fill the collection again
- implemented action sheet when **Clear** button is pressed according to Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/views/action-sheets/)
    - provided **Cancel** option which only appears on iPhone
    - destructive nature is explained and user is given an option to confirm

### Challenge
> It’s time to put your skills to the test by making your own complete app from scratch. This time your job is to create an app that lets people create a shopping list by adding items to a table view.
>
> The best way to tackle this app is to think about how you build project 5: it was a table view that showed items from an array, and we used a `UIAlertController` with a text field to let users enter free text that got appended to the array. That forms the foundation of this app, except this time you don’t need to validate items that get added – if users enter some text, assume it’s a real product and add it to their list.
>
> For bonus points, add a left bar button item that clears the shopping list – what method should be used afterwards to make the table view reload all its data?

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185696915-c13b60f0-c773-4662-af11-72449517ed07.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185696942-62fd6992-939e-488e-a5f3-993fbf14277f.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185696970-4d4e0f94-40da-4777-89c4-c802bf417049.png" style="float:left; width: 30%; margin-left: 1%">
