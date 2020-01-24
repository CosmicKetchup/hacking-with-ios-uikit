//
//  GameAsset.swift
//  p26.marble-maze
//
//  Created by Matt Brown on 1/23/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit

enum GameAsset {
    enum Image: String {
        case wall = "block"
        case background, finish, player, star, teleporter, vortex
        
        init(element: BoardElement) {
            switch element {
            case .finish:
                self = Image.finish
            case .player:
                self = Image.player
            case .star:
                self = Image.star
            case .teleporter:
                self = Image.teleporter
            case .vortex:
                self = Image.vortex
            case .wall:
                self = Image.wall
            }
        }
        
        var filename: String {
            switch self {
            case .background:
                return "\(self.rawValue).jpg"
            default:
                return "\(self.rawValue).png"
            }
        }
    }
    
    enum Emitter: String {
        case explosion
    }
    
    enum Audio: String {
        case explosion
        
        static let fileExtension = "caf"
        
        var filename: String {
            switch self {
            case .explosion:
                return self.rawValue + "." + Audio.fileExtension
            }
        }
    }
}
