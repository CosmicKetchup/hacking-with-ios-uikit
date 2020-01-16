# Project 6: Auto Layout

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2019.10.26-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.3.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.1-FA7343?logo=swift)](#)

### Personal Notes
- **VFL** is a rarely-used type of **Auto Layout** where you can visually represent the relative layout of your elements in code using symbols
    - uses dictionaries for view metrics and visual components

### Additional Challenges
> 1. Try replacing the `widthAnchor` of our labels with `leadingAnchor` and `trailingAnchor` constraints, which more explicitly pins the label to the edges of its parent.
> 2. Once you’ve completed the first challenge, try using the `safeAreaLayoutGuide` for those constraints. You can see if this is working by rotating to landscape, because the labels won’t go under the safe area.
> 3. Try making the height of your labels equal to 1/5th of the main view, minus `10` for the spacing.

### Solution Preview
```swift
// Visual Format Language
private func setupViewUsingVFL() {
    [label1, label2, label3, label4, label5].forEach({ view.addSubview($0) })
    let viewDict = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
    let viewMetrics = ["labelHeight": 88]

    viewDict.keys.forEach { view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\($0)]|", options: [], metrics: nil, views: viewDict)) }

    view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: viewMetrics, views: viewDict) )
}
```
```swift
// Layout Anchors
private func setupView() {
    var previous: UILabel?
    [label1, label2, label3, label4, label5].forEach({ label in
        view.addSubview(label)
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true

        if let previousLabel = previous {
            label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: ViewMetrics.labelSpacing).isActive = true
        }
        else {
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }

        previous = label
    })
}
```
