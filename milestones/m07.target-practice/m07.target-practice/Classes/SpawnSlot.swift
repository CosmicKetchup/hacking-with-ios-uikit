//
//  SpawnSlot.swift
//  m07.target-practice
//
//  Created by Matt Brown on 1/14/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation
import SpriteKit

final class SpawnSlot: SKNode {
    var characterType: CharacterType!
    var characterNode: SKSpriteNode!
    var cropNode: SKCropNode!
    var isAvailable = true
    var isActive = false
    var location: SpawnLocation
    var hideTimer: Timer!
    
    init(for slot: SpawnLocation) {
        self.location = slot
        super.init()
        
        cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 512, y: 384)
        cropNode.zPosition = 4
        cropNode.maskNode = slot.maskNode
        addChild(cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpawnSlot {
    func show(isEnemy: Bool, hideTime: Double) {
        guard isAvailable else { return }
        isAvailable = false
        isActive = true
        
        characterType = location.characterNode(isEnemy: isEnemy)
        characterNode = SKSpriteNode(texture: characterType.texture)
        characterNode.position = location.hiddenPositionStart
        characterNode.name = characterType.rawValue
        characterNode.zPosition = location.zPosition
        characterNode.xScale = location.characterScale * (location.requiresMirroredTexture ? -1 : 1)
        characterNode.yScale = location.characterScale
        characterNode.isHidden = false
        cropNode.addChild(characterNode)
    
        var attackSequence: [SKAction] = [location.appearanceAction(isEnemy: isEnemy)]
        if characterType.canMove {
            let secondaryActions = SKAction.group(location.secondaryActions(duration: hideTime))
            attackSequence.append(secondaryActions)
        }
        characterNode.run(SKAction.sequence(attackSequence))
        
        guard let hideTimeInterval = TimeInterval(exactly: hideTime * location.hideTimeMultipler) else { fatalError() }
        hideTimer = Timer.scheduledTimer(timeInterval: hideTimeInterval, target: self, selector: #selector(hide), userInfo: nil, repeats: false)
    }
    
    func hit() {
        guard isActive else { return }
        isActive = false
        hideTimer.invalidate()
        characterNode.removeAllActions()
        characterNode.run(location.hitAction) { [weak self] in
            self?.characterNode.isHidden = true
            self?.isAvailable = true
            self?.characterNode.removeFromParent()
        }
    }
    
    @objc func hide() {
        guard !isAvailable, isActive else { return }
        isActive = false
        characterNode.removeAllActions()
        characterNode.run(location.resetAction) { [weak self] in
            self?.characterNode.isHidden = true
            self?.isAvailable = true
            self?.characterNode.removeFromParent()
        }
    }
}
