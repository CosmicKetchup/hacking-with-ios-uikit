# Project 1: Storm Viewer

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.2-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- implementing `where` clause in loop when fetching local images
    - `for file in files where file.hasPrefix("nssl") { ... }`
- Apple's [**Human Interface Guidelines**](https://developer.apple.com/design/human-interface-guidelines/) instruct developers to use large titles when adding emphasis to context, but should never compete with content
    - `navigationController?.navigationBar.prefersLargeTitles = true`
    - `navigationItem.largeTitleDisplayMode = .never`
- using **dependency injection** to push user to `StormDetailViewController`
    - deconstructing tuple for library metrics within initializer for detail view controller
- removed **"Back"** text from navigation controller when viewing image detail
    - this is configured on **source** view controller (e.g. `StormTableViewController`)
    - `navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)`
- table cells honor dynamic user-defined font size
- tracks total views for each image via `UserDefaults`
- displays updated total in cell `detailTextLabel`

### Additional Challenges
> 1. Use **Interface Builder** to select the text label inside your table view cell and adjust its font size to something larger – experiment and see what looks good.
> 2. In your main table view, show the image names in sorted order, so `nssl0033.jpg` comes before `nssl0034.jpg`.
> 3. Rather than show image names in the detail title bar, show **Picture X of Y**, where **Y** is the total number of images and **X** is the selected picture’s position in the array. Make sure you count from `1` rather than `0`.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/71638832-98b4d500-2c38-11ea-97f0-702c80fd98db.png">
