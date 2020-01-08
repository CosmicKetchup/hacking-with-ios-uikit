//
//  Penguin.swift
//  p14.whack-a-penguin
//
//  Created by Matt Brown on 1/7/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation
import SpriteKit

enum Penguin: String {
    case good = "penguinGood"
    case bad = "penguinEvil"
    
    init(isGood: Bool) {
        self = isGood ? Penguin.good : .bad
    }
    
    var texture: SKTexture {
        SKTexture(imageNamed: self.rawValue)
    }
    
    var nodeName: String {
        switch self {
        case .good:
            return "friend"
            
        case .bad:
            return "enemy"
        }
    }
}
