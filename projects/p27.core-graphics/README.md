# Project 27: Core Graphics

### Personal Notes
- just like **Core Animation**, **Core Graphics** sits at a lower class than UIKit, so it doesn't have access to its methods
    - it can also work on a background thread and draw in real-time
- the `context` stores information about what we are drawing, but also _how_ we want to draw it

### Additional Challenges
> 1. Pick any emoji and try creating it using Core Graphics. You should find some easy enough, but for a harder challenge you could also try something like the star emoji.
> 2. Use a combination of `move(to:)` and `addLine(to:)` to create and stroke a path that spells _“TWIN”_ on the canvas.
> 3. Go back to [**project 3**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p03.social-media/) and change the way the selected image is shared so that it has some rendered text on top saying _“From Storm Viewer”_. This means reading the size property of the original image, creating a new canvas at that size, drawing the image in, then adding your text on top.

### Solution Preview
```swift
private func drawEmoji() {
      let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

      let img = renderer.image { ctx in
          // background and stroke border
          let rect1 = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
          ctx.cgContext.setFillColor(UIColor.orange.cgColor)
          ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
          ctx.cgContext.setLineWidth(10.0)
          ctx.cgContext.addEllipse(in: rect1)
          ctx.cgContext.drawPath(using: .fillStroke)

          // left eyebrow
          ctx.cgContext.setFillColor(UIColor.black.cgColor)
          ctx.cgContext.setLineWidth(15.0)
          ctx.cgContext.addArc(
              center: CGPoint(x: 180, y: 70),
              radius: 200,
              startAngle: 75 * .pi / 180,
              endAngle: 125 * .pi / 180,
              clockwise: false)
          ctx.cgContext.setLineCap(.round)
          ctx.cgContext.drawPath(using: .stroke)

          // right eyebrow
          ctx.cgContext.setFillColor(UIColor.black.cgColor)
          ctx.cgContext.addArc(
              center: CGPoint(x: 332, y: 70),
              radius: 200,
              startAngle: 105 * .pi / 180,
              endAngle: 55 * .pi / 180,
              clockwise: true)
          ctx.cgContext.setLineCap(.round)
          ctx.cgContext.drawPath(using: .stroke)

          // left eyeball
          let rect2 = CGRect(x: 130, y: 265, width: 50, height: 50)
          ctx.cgContext.setFillColor(UIColor.black.cgColor)
          ctx.cgContext.addEllipse(in: rect2)
          ctx.cgContext.drawPath(using: .fill)

          // right eyeball
          let rect3 = CGRect(x: 332, y: 265, width: 50, height: 50)
          ctx.cgContext.setFillColor(UIColor.black.cgColor)
          ctx.cgContext.addEllipse(in: rect3)
          ctx.cgContext.drawPath(using: .fill)

          // mouth
          let rect4 = CGRect(x: 166, y: 365, width: 180, height: 30)
          ctx.cgContext.setFillColor(UIColor.black.cgColor)
          ctx.cgContext.addEllipse(in: rect4)
          ctx.cgContext.drawPath(using: .fill)
      }

      imageView.image = img
  }
```
```swift
private func drawTwin() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

    let img = renderer.image { ctx in
        ctx.cgContext.translateBy(x: 256, y: 181)
        ctx.cgContext.setLineWidth(10)
        ctx.cgContext.setLineCap(.round)
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)

        let letterWidth: CGFloat = 100
        let letterSpacing: CGFloat = 20
        let letterHeight: CGFloat = 150

        // T
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * -2) + (letterSpacing * -1.5), y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * -1) + (letterSpacing * -1.5), y: 0))
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * -1.5) + (letterSpacing * -1.5), y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * -1.5) + (letterSpacing * -1.5), y: letterHeight))

        // W
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * -1) + (letterSpacing * -0.5), y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * -1) + (letterSpacing * -0.5), y: letterHeight))
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * -1) + (letterSpacing * -0.5), y: letterHeight))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * -0.5) + (letterSpacing * -0.5), y: (letterHeight * 0.5)))
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * -0.5) + (letterSpacing * -0.5), y: (letterHeight * 0.5)))
        ctx.cgContext.addLine(to: CGPoint(x: (letterSpacing * -0.5), y: letterHeight))
        ctx.cgContext.move(to: CGPoint(x: (letterSpacing * -0.5), y: letterHeight))
        ctx.cgContext.addLine(to: CGPoint(x: (letterSpacing * -0.5), y: 0))

        // I
        ctx.cgContext.move(to: CGPoint(x: (letterSpacing * 0.5), y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: letterWidth + (letterSpacing * 0.5), y: 0))
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * 0.5) + (letterSpacing * 0.5), y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * 0.5) + (letterSpacing * 0.5), y: letterHeight))
        ctx.cgContext.move(to: CGPoint(x: (letterSpacing * 0.5), y: letterHeight))
        ctx.cgContext.addLine(to: CGPoint(x: letterWidth + (letterSpacing * 0.5), y: letterHeight))


        // N
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * 1) + (letterSpacing * 1.5), y: letterHeight))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * 1) + (letterSpacing * 1.5), y: 0))
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * 1) + (letterSpacing * 1.5), y: 0))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * 2) + (letterSpacing * 1.5), y: letterHeight))
        ctx.cgContext.move(to: CGPoint(x: (letterWidth * 2) + (letterSpacing * 1.5), y: letterHeight))
        ctx.cgContext.addLine(to: CGPoint(x: (letterWidth * 2) + (letterSpacing * 1.5), y: 0))

        ctx.cgContext.strokePath()
    }

    imageView.image = img
}
```
