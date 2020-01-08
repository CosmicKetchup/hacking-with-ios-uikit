//
//  GameScene.swift
//  p14.whack-a-penguin
//
//  Created by Matt Brown on 1/7/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    
    private enum ViewMetrics {
        static let gameScoreLabelFontSize: CGFloat = 48.0
        static let gameScoreLabelPosition = CGPoint(x: 8.0, y: 8.0)
        static let gameScoreLabelFontName = "Chalkduster"
    }
    
    private let backgroundView: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "whackBackground")
        node.position = CGPoint(x: 512, y: 384)
        node.blendMode = .replace
        node.zPosition = -1
        return node
    }()
    
    private var gameScoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.position = ViewMetrics.gameScoreLabelPosition
        label.horizontalAlignmentMode = .left
        label.text = "Score: 0"
        label.fontSize = ViewMetrics.gameScoreLabelFontSize
        label.fontName = ViewMetrics.gameScoreLabelFontName
        label.zPosition = 1
        return label
    }()
    
    private var finalScoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.position = CGPoint(x: 512, y: 300)
        label.horizontalAlignmentMode = .center
        label.text = "Final Score: 0"
        label.fontSize = ViewMetrics.gameScoreLabelFontSize
        label.fontName = ViewMetrics.gameScoreLabelFontName
        label.isHidden = true
        label.zPosition = 1
        return label
    }()
    
    private var gameOverNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "gameOver")
        node.position = CGPoint(x: 512, y: 384)
        node.zPosition = 1
        node.isHidden = true
        return node
    }()
    
    private var roundNumber = 0
    private var userScore = 0 {
        didSet {
            gameScoreLabel.text = "Score: \(userScore)"
        }
    }
    
    private var popUpTime = 0.85
    private var whackSlots = [WhackSlot]()
    
    override func didMove(to view: SKView) {
        [backgroundView, gameScoreLabel, finalScoreLabel, gameOverNode].forEach { addChild($0) }
        
        createWhackSlots()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in self?.createEnemy() }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        tappedNodes.forEach { node in
            guard let whackSlot = node.parent?.parent as? WhackSlot else { return }
            guard whackSlot.isVisible, !whackSlot.isHit else { return }
            whackSlot.hit()
            whackSlot.scaleCharacter(x: 0.85, y: 0.85)
            
            if node.name == Penguin.good.nodeName {
                userScore -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }
            else if node.name == Penguin.bad.nodeName {
                userScore += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
}

extension GameScene {
    fileprivate func createWhackSlots() {
        (0 ..< 5).forEach { createSlot(at: CGPoint(x: 100 + ($0 * 170), y: 410)) }
        (0 ..< 4).forEach { createSlot(at: CGPoint(x: 180 + ($0 * 170), y: 320)) }
        (0 ..< 5).forEach { createSlot(at: CGPoint(x: 100 + ($0 * 170), y: 230)) }
        (0 ..< 4).forEach { createSlot(at: CGPoint(x: 180 + ($0 * 170), y: 140)) }
    }
    
    fileprivate func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        whackSlots.append(slot)
    }
    
    fileprivate func createEnemy() {
        roundNumber += 1
        
        if roundNumber > 30 {
            gameOver()
        }
        else {
            popUpTime *= 0.991
            whackSlots.shuffle()
            
            whackSlots[0].show(hideTime: popUpTime)
            if Int.random(in: 0...12) > 4 { whackSlots[1].show(hideTime: popUpTime) }
            if Int.random(in: 0...12) > 8 { whackSlots[2].show(hideTime: popUpTime) }
            if Int.random(in: 0...12) > 10 { whackSlots[3].show(hideTime: popUpTime) }
            if Int.random(in: 0...12) > 11 { whackSlots[4].show(hideTime: popUpTime) }
            
            let minDelay = popUpTime / 2.0
            let maxDelay = popUpTime * 2.0
            let randomDelay = Double.random(in: minDelay...maxDelay)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) { [weak self] in self?.createEnemy() }
        }
    }
    
    private func gameOver() {
        whackSlots.forEach { $0.hide() }
        gameScoreLabel.isHidden = true
        gameOverNode.isHidden = false
        
        finalScoreLabel.text = "Final Score: \(userScore)"
        finalScoreLabel.isHidden = false
    }
}
