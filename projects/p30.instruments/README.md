# Project 30: Instruments

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2020.01.31-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.4.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.2-FA7343?logo=swift)](#)

### Personal Notes
- the instrumenting panel offers various utilities to monitor app usage in real-time

### Additional Challenges
> 1. Go through [**project 30**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p30.instruments/) and remove all the force unwraps. **Note:** implicitly unwrapped optionals are not the same thing as force unwraps – you’re welcome to fix the implicitly unwrapped optionals too, but that’s a bonus task.
> 2. Pick any of the previous 29 projects that interests you, and try exploring it using the **Allocations** instrument. Can you find any objects that are persistent when they should have been destroyed?
> 3. For a tougher challenge, take the image generation code out of `cellForRowAt:` generate all images when the app first launches, and use those smaller versions instead. For bonus points, combine the `getDocumentsDirectory()` method I introduced in [**project 10**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p10.names-to-faces/) so that you save the resulting cache to make sure it never happens again.

### Solution Preview
```swift
fileprivate func loadData() {
    if let savedData = defaults.object(forKey: imageKey) as? Data {
        ...
    }
    else {
        loadItems()
    }
}

private func loadItems() {
    guard let rootPath = Bundle.main.resourcePath, let tempItems = try? FileManager.default.contentsOfDirectory(atPath: rootPath) else { return }

    for item in tempItems where item.range(of: "Large") != nil {
        guard let original = UIImage(named: item) else { continue }

        let renderRectangle = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
        let renderer = UIGraphicsImageRenderer(size: renderRectangle.size)
        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRectangle)
            ctx.cgContext.clip()
            original.draw(in: renderRectangle)
        }

        let imageFilename = UUID().uuidString
        let imageFilePath = documentsDirectory().appendingPathComponent(imageFilename)

        guard let pngData = rounded.pngData() else { return }
        try? pngData.write(to: imageFilePath)
        imageFilenames.append(imageFilename)
    }

    DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
    saveData()
}
```
