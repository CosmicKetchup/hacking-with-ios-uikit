//
//  WhackSlot.swift
//  p14.whack-a-penguin
//
//  Created by Matt Brown on 1/7/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import SpriteKit

final class WhackSlot: SKNode {
    
    private var characterNode: SKSpriteNode!
    private(set) var isVisible = false
    private(set) var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position
        let node = SKSpriteNode(imageNamed: "whackHole")
        addChild(node)
        
        // crop mask
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        characterNode = SKSpriteNode(imageNamed: "penguinGood")
        characterNode.position = CGPoint(x: 0, y: -90)
        characterNode.name = "character"
        cropNode.addChild(characterNode)
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        guard !isVisible else { return }
        scaleCharacter(x: 1.0, y: 1.0)
        
        let character = Penguin(isGood: Int.random(in: 0...2).isMultiple(of: 2))
        characterNode.texture = character.texture
        characterNode.name = character.nodeName
        
        let moveUp = SKAction.moveBy(x: 0, y: 80, duration: 0.05)
        characterNode.run(moveUp)
        isVisible = true
        isHit = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in self?.hide() }
    }
    
    func hit() {
        if let smoke = SKEmitterNode(fileNamed: "Smoke") {
            smoke.zPosition = characterNode.zPosition
            smoke.position = characterNode.position
            addChild(smoke)
        }
        
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let hitSequence = SKAction.sequence([delay, hide, notVisible])
        characterNode.run(hitSequence)
    }
    
    func hide() {
        guard isVisible else { return }
        let moveDown = SKAction.moveBy(x: 0, y: -80.0, duration: 0.05)
        characterNode.run(moveDown)
        isVisible = false
    }
    
    func scaleCharacter(x: CGFloat, y: CGFloat) {
        characterNode.xScale = x
        characterNode.yScale = y
    }
}
