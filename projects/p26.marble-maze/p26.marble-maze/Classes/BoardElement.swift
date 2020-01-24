//
//  BoardElement.swift
//  p26.marble-maze
//
//  Created by Matt Brown on 1/23/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit

enum BoardElement: String {
    case finish, player, star, teleporter, vortex, wall
    
    init?(for character: Character) {
        switch character.description {
        case "f":
            self = BoardElement.finish
        case "s":
            self = BoardElement.star
        case "v":
            self = BoardElement.vortex
        case "x":
            self = BoardElement.wall
        case "t":
            self = BoardElement.teleporter
        default:
            return nil
        }
    }
    
    var imageName: String {
        return GameAsset.Image(element: self).rawValue
    }
    
    var categoryBitmask: UInt32 {
        switch self {
        case .finish:
            return 16
        case .player:
            return 1
        case .star:
            return 4
        case .teleporter:
            return 32
        case .vortex:
            return 8
        case .wall:
            return 2
//        default:
//            return 0xFFFFFFFF
        }
    }
    
    var contactTestBitmask: UInt32 {
        switch self {
        case .finish, .star, .teleporter, .vortex:
            return BoardElement.player.categoryBitmask
        default:
            return 0x00000000
        }
    }
    
    var collisionBitMask: UInt32 {
        switch self {
        case .finish, .star, .teleporter, .vortex:
            return 0
        default:
            return 0xFFFFFFFF
        }
    }
    
    var spriteNode: SKSpriteNode {
        return SKSpriteNode(imageNamed: self.imageName)
    }
    
    var nodeName: String? {
        switch self {
        case .wall:
            return nil
        default:
            return self.rawValue
        }
    }
    
    var idleAnimation: SKAction? {
        switch self {
        case .teleporter, .vortex:
            let spin = SKAction.rotate(byAngle: .pi, duration: 1.0)
            return SKAction.repeatForever(spin)
        default:
            return nil
        }
    }
}
