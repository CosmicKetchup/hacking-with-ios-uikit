//
//  GameScene.swift
//  m07.target-practice
//
//  Created by Matt Brown on 1/12/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.red
        static let ammoDisplayScale: CGFloat = 0.45
        static let scoreLabelFontName = "MarkerFelt-Wide"
        static let scoreLabelFontSize: CGFloat = 24.0
        static let scoreLabelFontColor = UIColor(red: 99/255, green: 126/255, blue: 137/255, alpha: 1.0)
    }
    
    private enum GameAssets: String {
        case snowyBackground = "background"
        case reloadPoint
        case snowball
        case snowfall
    }
    
    private var nodeAvailableTime = 2.5
    private var popUpTime = 1.0
    private var ammoDisplay = [SKSpriteNode]()
    private var remainingSnowballs = 6 {
        didSet {
            updateAmmoDisplay()
        }
    }
    
    private let background: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameAssets.snowyBackground.rawValue)
        node.position = CGPoint(x: 512, y: 384)
        node.blendMode = .replace
        node.zPosition = -99
        return node
    }()
    
    private let snowfall: SKEmitterNode = {
        guard let emitter = SKEmitterNode(fileNamed: GameAssets.snowfall.rawValue) else { fatalError() }
        emitter.position = CGPoint(x: 512, y: 770)
        emitter.zPosition = 9
        emitter.advanceSimulationTime(10.0)
        emitter.isUserInteractionEnabled = false
        emitter.name = GameAssets.snowfall.rawValue
        return emitter
    }()
    
    private var userScore = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(userScore)"
        }
    }
    
    private let scoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: ViewMetrics.scoreLabelFontName)
        label.position = CGPoint(x: 25, y: 25)
        label.zPosition = -5
        label.fontColor = ViewMetrics.scoreLabelFontColor
        label.fontSize = ViewMetrics.scoreLabelFontSize
        label.text = "SCORE: 0"
        label.horizontalAlignmentMode = .left
        return label
    }()
    
    private let reloadPoint: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameAssets.reloadPoint.rawValue)
        node.zPosition = 3
        node.position = CGPoint(x: 275, y: 100)
        node.name = "reloadPoint"
        return node
    }()
    
    private var spawnSlots: [SpawnSlot]!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) where node.name != GameAssets.snowfall.rawValue {
            if node.name == GameAssets.reloadPoint.rawValue {
                reload()
                return
            }
            else {
                throwSnowball(at: location)
                return
            }
        }
    }
    
    override func didMove(to view: SKView) {
        view.backgroundColor = ViewMetrics.backgroundColor
        [background, scoreLabel, reloadPoint, snowfall].forEach { addChild($0) }
        (1...6).forEach { createAmmoDisplay(tag: $0) }
        
        spawnSlots = SpawnLocation.allSpawnPoints.compactMap { SpawnSlot(for: $0) }
        spawnSlots.forEach { addChild($0) }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: spawnCharacters)
    }
}

// MARK: - User Actions
extension GameScene {
    fileprivate func throwSnowball(at location: CGPoint) {
        guard remainingSnowballs > 0 else { return }
        let snowball = SKSpriteNode(imageNamed: GameAssets.snowball.rawValue)
        snowball.position = location
        snowball.zPosition = 5
        snowball.name = GameAssets.snowball.rawValue
        addChild(snowball)
        remainingSnowballs -= 1
        
        let throwSound = SoundEffect.throwSnowball.soundAction
        let rise = SKAction.moveBy(x: 0, y: 75.0, duration: 0.25)
        let fall = SKAction.moveBy(x: 0, y: -100.0, duration: 0.5)
        let disappear = SKAction.removeFromParent()
        let delta = SKAction.sequence([rise, fall, disappear])
        let scaleOut = SKAction.scale(by: 0.05, duration: 0.75)
        let throwGroup = SKAction.group([throwSound, delta, scaleOut])
        snowball.run(throwGroup)
        
        func performHitCheck(for row: SpawnLocation.Distance) {
            for node in nodes(at: location) where node.zPosition <= snowball.zPosition {
                guard let slot = node.parent?.parent as? SpawnSlot, slot.isActive, slot.location.distance == row else { continue }
                let hitSound = SoundEffect.snowballHit.soundAction
                let snowballHit = SKAction.group([hitSound, disappear])
                snowball.run(snowballHit)
                slot.removeAllActions()
                slot.hit()
                userScore += slot.characterType.reward
                return
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { performHitCheck(for: .near) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { performHitCheck(for: .far) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { performHitCheck(for: .overhead) }
    }
    
    fileprivate func reload() {
        guard remainingSnowballs < 6 else { return }
        let reloadSound = SoundEffect.reloadSnowballs.soundAction
        let grow = SKAction.scale(by: 1.25, duration: 0.05)
        let shrink = SKAction.scale(by: 0.8, duration: 0.05)
        let popSequence = SKAction.sequence([grow, shrink])
        let reloadGroup = SKAction.group([reloadSound, popSequence])
        reloadPoint.run(reloadGroup)
        remainingSnowballs = 6
    }
}

// MARK: - Setup
extension GameScene {
    fileprivate func createAmmoDisplay(tag: Int) {
        let node = SKSpriteNode(imageNamed: GameAssets.snowball.rawValue)
        node.zPosition = 10
        node.position = CGPoint(x: 990, y: 400 - (tag * 30))
        node.xScale = ViewMetrics.ammoDisplayScale
        node.yScale = ViewMetrics.ammoDisplayScale
        node.name = "ammo" + tag.description
        addChild(node)
        ammoDisplay.append(node)
    }
    
    fileprivate func updateAmmoDisplay() {
        ammoDisplay
            .reversed()
            .enumerated()
            .forEach { (index, node) in
                node.alpha = (index > remainingSnowballs - 1) ? 0.3 : 1.0 }
    }
    
    fileprivate func spawnCharacters() {
        spawnSlots.shuffle()
        spawnSlots.first?.show(isEnemy: Bool.random(), hideTime: nodeAvailableTime)
        if Int.random(in: 0...12) > 4 { spawnSlots[1].show(isEnemy: Bool.random(), hideTime: nodeAvailableTime) }
        if Int.random(in: 0...12) > 9 { spawnSlots[2].show(isEnemy: Bool.random(), hideTime: nodeAvailableTime) }
        if Int.random(in: 0...12) > 10 { spawnSlots[3].show(isEnemy: Bool.random(), hideTime: nodeAvailableTime) }
        
        let minDelay = popUpTime / 2.0
        let maxDelay = popUpTime * 2.0
        let randomDelay = Double.random(in: minDelay...maxDelay)
        DispatchQueue.main.asyncAfter(deadline: .now() + nodeAvailableTime + randomDelay, execute: spawnCharacters)
    }
}
