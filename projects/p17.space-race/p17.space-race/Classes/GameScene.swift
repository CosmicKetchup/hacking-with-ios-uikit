//
//  GameScene.swift
//  p17.space-race
//
//  Created by Matt Brown on 1/12/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.black
    }
    
    private let possibleEnemies = ["ball", "hammer", "tv"]
    private var enemyTracker = 0
    private var isGameOver = false
    private var gameTimer: Timer?
    private var currentInterval: TimeInterval = 1.0
    
    private var userScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(userScore)"
        }
    }
    
    private let gameOverLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.fontSize = 54.0
        label.position = CGPoint(x: 512, y: 384)
        label.horizontalAlignmentMode = .center
        label.text = "Game Over"
        label.isHidden = true
        label.zPosition = 2
        return label
    }()
    
    private let scoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.position = CGPoint(x: 32, y: 32)
        label.horizontalAlignmentMode = .left
        label.text = "Score: 0"
        return label
    }()
    
    private let player: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "player")
        node.position = CGPoint(x: 100, y: 384)
        node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
        node.physicsBody?.contactTestBitMask = 1
        return node
    }()
    
    private let starfield: SKEmitterNode = {
        guard let emitter = SKEmitterNode(fileNamed: "starfield") else { fatalError() }
        emitter.position = CGPoint(x: 1024, y: 384)
        emitter.advanceSimulationTime(10.0)
        emitter.zPosition = -1
        return emitter
    }()
    
    override func didMove(to view: SKView) {
        backgroundColor = ViewMetrics.backgroundColor
        
        [starfield, player, scoreLabel, gameOverLabel].forEach { addChild($0) }
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        newGame()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        }
        else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver {
            gameOver()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        children.forEach { child in
            if child.position.x < -300 { child.removeFromParent() }
        }
        
        if !isGameOver {
            userScore += 1
        }
        
        if enemyTracker >= 10 {
            gameTimer?.invalidate()
            currentInterval *= 0.91
            enemyTracker = 0
            gameTimer = Timer.scheduledTimer(timeInterval: currentInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameOver()
    }
}

extension GameScene {
    fileprivate func newGame() {
        isGameOver = false
        gameOverLabel.isHidden = true
        userScore = 0
        enemyTracker = 0
        currentInterval = 1.0
        
        if player.parent == nil {
            player.position = CGPoint(x: 100, y: 384)
            addChild(player)
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: currentInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func createEnemy() {
        guard !isGameOver, let enemy = possibleEnemies.randomElement() else { return }
        let enemySprite = SKSpriteNode(imageNamed: enemy)
        enemySprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(enemySprite)
        enemyTracker += 1
        
        enemySprite.physicsBody = SKPhysicsBody(texture: enemySprite.texture!, size: enemySprite.size)
        enemySprite.physicsBody?.categoryBitMask = 1
        enemySprite.physicsBody?.velocity = CGVector(dx: -500.0, dy: 0)
        enemySprite.physicsBody?.angularVelocity = 5
        enemySprite.physicsBody?.linearDamping = 0
        enemySprite.physicsBody?.angularDamping = 0
    }
    
    fileprivate func gameOver() {
        guard !isGameOver, let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
        gameTimer?.invalidate()
        gameOverLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.newGame()
        }
    }
}
