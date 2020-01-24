//
//  RootViewController.swift
//  p27.core-graphics
//
//  Created by Matt Brown on 1/23/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        
        static let buttonInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        static let buttonColor = UIColor.systemBlue
        static let buttonTextColor = UIColor.white
        static let buttonFont = UIFont.boldSystemFont(ofSize: 36.0)
        static let buttonCornerRadius: CGFloat = 5.0
        static let buttonBorderWidth: CGFloat = 2.0
        static let buttonBorderColor = UIColor.black.cgColor
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let redrawButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = ViewMetrics.buttonInsets
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        button.titleLabel?.font = ViewMetrics.buttonFont
        button.setTitle("Redraw", for: .normal)
        button.setTitleColor(ViewMetrics.buttonTextColor, for: .normal)
        button.backgroundColor = ViewMetrics.buttonColor
        
        button.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        button.layer.borderWidth = ViewMetrics.buttonBorderWidth
        button.layer.borderColor = ViewMetrics.buttonBorderColor
        return button
    }()

    private var currentDrawType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        drawRectangle()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [imageView, redrawButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            redrawButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.layoutMarginsGuide.leadingAnchor, multiplier: 1),
            view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: redrawButton.bottomAnchor, multiplier: 1),
        ])
    }
}

extension RootViewController {
    @objc fileprivate func buttonTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 7 { currentDrawType = 0 }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTwin()
        default:
            break
        }
    }
    
    fileprivate func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10.0)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    private func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10.0)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    private func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for column in 0 ..< 8 {
                    guard (row + column) % 2 == 0 else { continue }
                    let rect = CGRect(x: column * 64, y: row * 64, width: 64, height: 64)
                    ctx.cgContext.fill(rect)
                }
            }
        }
        
        imageView.image = img
    }
    
    private func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            let rect = CGRect(x: -128, y: -128, width: 256, height: 256)
            
            (0 ..< rotations).forEach { _ in
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(rect)
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    private func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                }
                else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    private func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrbs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 26.0),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best laid schemes o'\nmice an' men gang aft agley"
            let attrbString = NSAttributedString(string: string, attributes: attrbs)
            attrbString.draw(
                with: CGRect(x: 32, y: 32, width: 448, height: 448),
                options: .usesLineFragmentOrigin,
                context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = img
    }
    
    private func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            // background and stroke border
            let rect1 = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
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
}

