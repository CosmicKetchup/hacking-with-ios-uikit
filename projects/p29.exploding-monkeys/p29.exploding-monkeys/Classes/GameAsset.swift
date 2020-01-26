//
//  GameAsset.swift
//  p29.exploding-monkeys
//
//  Created by Matt Brown on 1/25/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit

enum GameAsset {
    enum Element: String {
        case building
        
        var categoryBitMask: UInt32 {
            switch self {
            case .building:
                return 2
            }
        }
        
        var contactBitMask: UInt32 {
            switch self {
            case .building:
                return Image.banana.categoryBitMask
            }
        }
    }
    
    enum Image: String {
        case banana, player

        var spriteNode: SKSpriteNode {
            switch self {
            default:
                return SKSpriteNode(imageNamed: self.rawValue)
            }
        }
        
        var categoryBitMask: UInt32 {
            switch self {
            case .banana:
                return 1
            case .player:
                return 4
            }
        }
        
        var contactBitMask: UInt32 {
            switch self {
            case .banana:
                return GameAsset.Element.building.categoryBitMask | GameAsset.Image.player.categoryBitMask
            case .player:
                return GameAsset.Image.banana.categoryBitMask
            }
        }
        
        var collisionBitMask: UInt32 {
            switch self {
                case .banana:
                    return GameAsset.Element.building.categoryBitMask | GameAsset.Image.player.categoryBitMask
                case .player:
                    return GameAsset.Image.banana.categoryBitMask
            }
        }
    }
    
    enum Emitter: String {
        case playerHit = "hitPlayer"
        case buildingHit = "hitBuilding"
    }
    
    enum Texture: String {
        case player, player1Throw, player2Throw
        
        var texture: SKTexture {
            SKTexture(imageNamed: self.rawValue)
        }
    }
}
