//
//  EnemyType.swift
//  p23.swifty-ninja
//
//  Created by Matt Brown on 1/21/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit

enum EnemyType {
    case penguin
    case bomb
    case evilPenguin
    
    static func random(odds max: Int) -> EnemyType {
        let randomInt = Int.random(in: 0...max)
        if randomInt == 0 {
            return .bomb
        }
        else if randomInt == max {
            return .evilPenguin
        }
        else {
            return .penguin
        }
    }
    
    var nodeName: GameScene.NodeName {
        switch self {
        case .penguin:
            return .enemy
        case .bomb:
            return .bombContainer
        case .evilPenguin:
            return .rare
        }
    }
    
    var texture: String {
        switch self {
        case .penguin:
            return GameAsset.Image.penguin.rawValue
        case .bomb:
            return GameAsset.Image.bomb.rawValue
        case .evilPenguin:
            return GameAsset.Image.evilPenguin.rawValue
        }
    }
    
    var spriteNode: SKSpriteNode {
        switch self {
        case .bomb:
            let container = SKSpriteNode()
            
            let bombImage = SKSpriteNode(imageNamed: self.texture)
            bombImage.name = GameScene.NodeName.bomb.rawValue
            container.addChild(bombImage)
            
            if let emitter = SKEmitterNode(fileNamed: GameAsset.Emitter.bombFuse.rawValue) {
                emitter.position = CGPoint(x: 76, y: 64)
                container.addChild(emitter)
            }
            
            return container
            
        default:
            return SKSpriteNode(imageNamed: self.texture)
        }
    }
}
