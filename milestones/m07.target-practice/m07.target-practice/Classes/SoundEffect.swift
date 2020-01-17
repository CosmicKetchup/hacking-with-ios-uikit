//
//  SoundEffect.swift
//  m07.target-practice
//
//  Created by Matt Brown on 1/15/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit

enum SoundEffect: String {
    case throwSnowball = "snowball_throw"
    case reloadSnowballs = "snowball_reload"
    case snowballHit = "snowball_hit"
    
    static let fileExtension = ".mp3"
    
    var soundAction: SKAction {
        SKAction.playSoundFileNamed(self.rawValue + SoundEffect.fileExtension, waitForCompletion: false)
    }
}
