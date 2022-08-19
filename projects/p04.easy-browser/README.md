# Project 4: Easy Browser

### Personal Notes
- due to **App Transport Security**, it is highly recommended to make secure web calls using `https://`
- all view controllers include a `toolbarItems` array that gets read when actively displayed inside a `UINavigationController`
    - be sure to set `navigationController?.isToolbarHidden` to `false`
- a special `UIBarButtonItem` can be created with type `.flexibleSpace` which acts as a spring, pushing other buttons to the side until all space is used
- using a **key-value observer** allows you to monitor the `estimatedProgress` property and make updates accordingly
    - **Important:** in more complex applications, all calls to `addObserver()` should be paired with a call to `removeObserver()` once you're finished monitoring the property

### Additional Challenges
> 1. If users try to visit a URL that isn’t allowed, show an alert saying it’s blocked.
> 2. Try making two new toolbar items with the titles Back and Forward. You should make them use `webView.goBack` and `webView.goForward`.
> 3. For more of a challenge, try changing the initial view controller to a table view like in [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/), where users can choose their website from a list rather than just having the first in the array loaded up front.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185145253-faedb950-9fbc-4676-88df-ce413565e6c0.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185145304-dd9a0005-935a-427e-a5dc-52c94b583adf.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185145382-50a96eac-13df-4805-ba8b-86f9a01067d3.png" style="float:left; width: 30%; margin-left: 1%">
