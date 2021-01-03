//
//  GameScene.swift
//  p36.crashy-plane
//
//  Created by Matt Brown on 1/2/21.
//

import GameplayKit
import SpriteKit

final class GameScene: SKScene {
    
    private var player: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        createPlayer()
        createSky()
        createBackground()
        createGround()
        
        startRocks()
        createScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func createPlayer() {
        let frame1 = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: frame1)
        player.zPosition = 10
        player.position = CGPoint(x: (frame.width / 6), y: (frame.height * 0.75))
        addChild(player)
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        
        let flyingAnimation = SKAction.animate(with: [frame1, frame2, frame3, frame2], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(flyingAnimation)
        player.run(runForever)
    }
    
    private func createSky() {
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: (frame.height * 0.67)))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: (frame.height * 0.33)))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        addChild(topSky)
        addChild(bottomSky)
        
        [topSky, bottomSky].forEach { $0.zPosition = -40 }
    }
    
    private func createBackground() {
        let bgTexture = SKTexture(imageNamed: "background")
        
        (0 ... 1).forEach { i in
            let background = SKSpriteNode(texture: bgTexture)
            background.zPosition = -30
            background.anchorPoint = .zero
            background.position = CGPoint(x: (bgTexture.size().width * CGFloat(i)) - CGFloat(1*i), y: 100)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            background.run(moveForever)
        }
    }
    
    private func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        
        (0 ... 1).forEach { i in
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            
            #warning("modified Y position to show on-screen")
//            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 1)
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            ground.run(moveForever)
        }
    }
    
    private func createRocks() {
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        topRock.zRotation = .pi
        topRock.xScale = -1.0
        topRock.zPosition = -20
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        bottomRock.zPosition = -20
        
        let scoreZone = SKSpriteNode(color: .red, size: CGSize(width: 32, height: frame.height))
        scoreZone.name = "scoreZone"
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(scoreZone)
        
        let xPos = frame.width + topRock.frame.width
        let max = CGFloat(frame.height / 3)
        let yPos = CGFloat.random(in: -50 ... max)
        
        let rockSpacing: CGFloat = 70
        
        topRock.position = CGPoint(x: xPos, y: (yPos + topRock.size.height + rockSpacing))
        bottomRock.position = CGPoint(x: xPos, y: (yPos - rockSpacing))
        scoreZone.position = CGPoint(x: (xPos + scoreZone.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        scoreZone.run(moveSequence)
        
    }
    
    private func startRocks() {
        let create = SKAction.run { [weak self] in
            self?.createRocks()
        }
        
        let delay = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, delay])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever)
    }
    
    private func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .black
        scoreLabel.text = "SCORE: 0"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        addChild(scoreLabel)
    }
}
