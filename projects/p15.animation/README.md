# Project 15: Animation

### Personal Notes
- **Core Animation** will always take the shortest route to resolve the element transformation

### Additional Challenges
> 1. Go back to [**project 8**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p08.7-swifty-words/) and make the letter group buttons fade out when they are tapped. We were using the `isHidden` property, but you'll need to switch to `alpha` because `isHidden` is either `true` or `false`, it has no animatable values between.
> 2. Go back to [**project 13**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p13.instafilter/) and make the image view fade in when a new picture is chosen. To make this work, set the `alpha` to `0` first.
> 3. Go back to [**project 2**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p02.guess-the-flag/) and make the flags scale down with a little bounce when pressed.

### Solution Preview
```swift
import UIKit

final class RootViewController: UIViewController {

    private enum ViewMetrics { ... }
    private var currentAnimationIteration = 0
    private let penguinView: UIImageView = { ... }()
    private let primaryButton: UIButton = { ... }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.rootBackgroundColor

        [penguinView, primaryButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            penguinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            penguinView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            primaryButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: penguinView.bottomAnchor, multiplier: 1.0),
            primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: primaryButton.bottomAnchor, multiplier: 3.0),
        ])
    }
}
```
```swift
extension RootViewController {
    @objc fileprivate func buttonTapped(_ button: UIButton) {
        button.isHidden = true

        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, animations: { [weak self] in
            switch self?.currentAnimationIteration {
            case 0:
                self?.penguinView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)

            case 2:
                self?.penguinView.transform = CGAffineTransform(translationX: -256, y: -256)

            case 4:
                self?.penguinView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

            case 6:
                self?.penguinView.alpha = 0.1
                self?.penguinView.backgroundColor = .green

            case 7:
                self?.penguinView.alpha = 1.0
                self?.penguinView.backgroundColor = .clear

            case 1, 3, 5:
                self?.penguinView.transform = .identity

            default:
                break
            }
        }) { _ in
            button.isHidden = false
        }

        currentAnimationIteration += 1
        if currentAnimationIteration > 7 {
            currentAnimationIteration = 0
        }
    }
}
```
