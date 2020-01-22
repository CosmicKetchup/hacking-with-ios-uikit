//
//  GameAssets.swift
//  p23.swifty-ninja
//
//  Created by Matt Brown on 1/21/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation

enum GameAsset {
    enum Image: String {
        case background = "sliceBackground"
        case playerLife = "sliceLife"
        case playerLifeGone = "sliceLifeGone"
        case bomb = "sliceBomb"
        case penguin
        case evilPenguin = "penguinEvil"
        case gameOver
    }
    
    enum Emitter: String {
        case enemyHit = "sliceHitEnemy"
        case bombHit = "sliceHitBomb"
        case bombFuse = "sliceFuse"
    }
    
    enum Audio {
        case sliceSwoosh, whack, explosion, wrong, bombFuse, launch
        
        static let fileExtension = "caf"
        
        var rawValue: String {
            switch self {
            case .sliceSwoosh:
                let randomInt = Int.random(in: 1...3)
                return "swoosh" + randomInt.description
            case .whack:
                return "whack"
            case .explosion:
                return "explosion"
            case .wrong:
                return "wrong"
            case .bombFuse:
                return "sliceBombFuse"
            case .launch:
                return "launch"
            }
        }
        
        var filename: String {
            self.rawValue + "." + GameAsset.Audio.fileExtension
        }
    }
}
