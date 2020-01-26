//
//  BuildingNode.swift
//  p29.exploding-monkeys
//
//  Created by Matt Brown on 1/25/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import CoreGraphics

final class BuildingNode: SKSpriteNode {
    
    var currentImage: UIImage!
    
    private enum BuildingColor: CaseIterable {
        case red, teal, gray
        
        static var randomColor: UIColor {
            BuildingColor.allCases.randomElement()!.color
        }
        
        static let lightsOn = UIColor(hue: 0.19, saturation: 0.67, brightness: 0.99, alpha: 1)
        static let lightsOff = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
        
        var color: UIColor {
            switch self {
            case .teal:
                return UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case .red:
                return UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            case .gray:
                return UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
        }
    }
    
    func create() {
        name = GameAsset.Element.building.rawValue
        drawBuilding(size: size)
        configurePhysics()
    }
    
    private func drawBuilding(size: CGSize) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let generatedTexture = renderer.image { ctx in
            let rectangle = CGRect(
                x: 0,
                y: 0,
                width: size.width,
                height: size.height)
            BuildingColor.randomColor.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            stride(from: 10, to: Int(size.height - 10), by: 40).forEach { row in
                stride(from: 10, to: Int(size.width - 10), by: 40).forEach { column in
                    Bool.random() ? BuildingColor.lightsOn.setFill() : BuildingColor.lightsOff.setFill()
                    ctx.cgContext.fill(CGRect(
                        x: column,
                        y: row,
                        width: 15,
                        height: 20))
                }
            }
        }
        
        currentImage = generatedTexture
        texture = SKTexture(image: currentImage)
    }
    
    private func configurePhysics() {
        guard let physicsTexture = texture else { return }
        physicsBody = SKPhysicsBody(texture: physicsTexture, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = GameAsset.Element.building.categoryBitMask
        physicsBody?.contactTestBitMask = GameAsset.Element.building.contactBitMask
    }
    
    func hit(at location: CGPoint) {
        let convertedPoint = CGPoint(x: location.x + size.width / 2, y: abs(location.y - (size.height / 2)))
        let renderer = UIGraphicsImageRenderer(size: size)
        let newBuilding = renderer.image { ctx in
            currentImage.draw(at: .zero)
            ctx.cgContext.addEllipse(in: CGRect(
                x: convertedPoint.x - 32,
                y: convertedPoint.y - 32, width: 64, height: 64))
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        currentImage = newBuilding
        texture = SKTexture(image: currentImage)
        configurePhysics()
    }
}
