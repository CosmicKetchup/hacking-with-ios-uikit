//
//  Character.swift
//  m07.target-practice
//
//  Created by Matt Brown on 1/13/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation
import SpriteKit

enum CharacterType {
    
    case enemy(color: EnemyColor)
    case snowman
    case santa
    
    enum EnemyColor: String, CaseIterable {
        case red = "Red"
        case brown = "Brown"
    }
    
    init(isEnemy: Bool) {
        guard let randomColor = EnemyColor.allCases.randomElement() else { fatalError() }
        self = isEnemy ? .enemy(color: randomColor) : .snowman
    }
    
    var rawValue: String {
        switch self {
        case .enemy(_):
            return "enemy"
        case .snowman:
            return "snowman"
        case .santa:
            return "santa"
        }
    }
    
    var canMove: Bool {
        switch self {
        case .snowman:
            return false
        default:
            return true
        }
    }
    
    var texture: SKTexture {
        switch self {
        case .enemy(let color):
            return SKTexture(imageNamed: self.rawValue + color.rawValue)
        case .snowman:
            guard let randomNum = (1...5).randomElement()?.description else { fatalError() }
            return SKTexture(imageNamed: self.rawValue + randomNum)
        case .santa:
            return SKTexture(imageNamed: self.rawValue)
        }
    }
    
    var reward: Int {
        switch self {
        case .enemy(_):
            return 1
        case .snowman:
            return -3
        case .santa:
            return 5
        }
    }
}

