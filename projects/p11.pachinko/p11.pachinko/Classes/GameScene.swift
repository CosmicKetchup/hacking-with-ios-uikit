//
//  GameScene.swift
//  p11.pachinko
//
//  Created by Matt Brown on 12/14/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private enum ViewMetrics {
        static let labelFontName = "Chalkduster"
    }
    
    private enum DifficultyLevel: Int {
        case normal = 25
    }
    
    private var selectedDifficulty: DifficultyLevel = .normal
    
    private enum ColoredBall: Int, CaseIterable {
        case blue, cyan, green, grey, purple, red, yellow
        
        static let numberOfColors: Int = ColoredBall.allCases.count - 1
        
        var filename: String {
            switch self {
            case .blue:
                return "ballBlue"
            case .cyan:
                return "ballCyan"
            case .green:
                return "ballGreen"
            case .grey:
                return "ballGrey"
            case .purple:
                return "ballPurple"
            case .red:
                return "ballRed"
            case .yellow:
                return "ballYellow"
            }
        }
    }
    
    private let backgroundImage: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "background.jpg")
        node.zPosition = -1
        node.blendMode = .replace
        node.position = CGPoint(x: 512, y: 384)
        return node
    }()
    
    private var ballsRemaining = 5 {
        didSet {
            remainingBallsLabel.text = "Balls: \(ballsRemaining)"
        }
    }
    
    private var remainingBallsLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: ViewMetrics.labelFontName)
        node.horizontalAlignmentMode = .center
        node.position = CGPoint(x: 512, y: 700)
        node.text = "Balls: 0"
        return node
    }()
    
    private let userScoreLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: ViewMetrics.labelFontName)
        node.horizontalAlignmentMode = .right
        node.position = CGPoint(x: 980, y: 700)
        node.text = "Score: 0"
        return node
    }()

    private var userScore = 0 {
        didSet {
            userScoreLabel.text = "Score: \(userScore)"
        }
    }

    private let newGameLabel: SKLabelNode = {
        let node = SKLabelNode(fontNamed: ViewMetrics.labelFontName)
        node.position = CGPoint(x: 120, y: 700)
        node.text = "New Game"
        return node
    }()
    
    override func didMove(to view: SKView) {
        [backgroundImage, newGameLabel, remainingBallsLabel, userScoreLabel].forEach { addChild($0) }
        
        [0, 256, 512, 768, 1024].forEach { addBouncingPad(at: $0) }
        
        addSpinningSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        addSpinningSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        addSpinningSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        addSpinningSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        newGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            
            if objects.contains(newGameLabel) {
                newGame()
            }
            else {
                createColoredBall(at: location)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node, let bodyB = contact.bodyB.node else { return }
        if bodyA.name == "ball" {
            collisionBetween(ball: bodyA, object: bodyB)
        }
        else if bodyB.name == "ball" {
            collisionBetween(ball: bodyB, object: bodyA)
        }
    }
    
    private func newGame() {
        guard let scene = scene else { return }
        for node in scene.children where node.name == "box" || node.name == "ball" {
            node.removeFromParent()
        }
        
        userScore = 0
        ballsRemaining = 5
        remainingBallsLabel.fontColor = .white
        
        for _ in 1...selectedDifficulty.rawValue {
            let randomPosition = CGPoint(x: CGFloat.random(in: 50...974), y: CGFloat.random(in: 100...600))
            createColoredBox(at: randomPosition)
        }
    }
}

extension GameScene {
    private func createColoredBall(at position: CGPoint) {
        guard ballsRemaining > 0 else { return }
        guard let randomBallColor = ColoredBall(rawValue: Int.random(in: 0...ColoredBall.numberOfColors)) else { return }
        let ball = SKSpriteNode(imageNamed: randomBallColor.filename)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody?.restitution = 0.4
        ball.position = CGPoint(x: position.x, y: 700)
        ball.name = "ball"
        addChild(ball)
        ballsRemaining -= 1
    }
    
    private func createColoredBox(at position: CGPoint) {
        let randomSize = CGSize(width: Int.random(in: 16...128), height: 16)
        let randomColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
        let box = SKSpriteNode(color: randomColor, size: randomSize)
        
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = position
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        addChild(box)
    }
    
    fileprivate func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            ballsRemaining += 1
            destroy(ball: ball)
        }
        else if object.name == "bad" {
            destroy(ball: ball)
        }
        else if object.name == "box" {
            userScore += 1
            object.removeFromParent()
        }
    }
    
    private func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
        checkForGameOver()
    }
    
    fileprivate func addBouncingPad(at xPosition: Int) {
        let node = SKSpriteNode(imageNamed: "bouncer")
        node.position = CGPoint(x: xPosition, y: 0)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    fileprivate func addSpinningSlot(at position: CGPoint, isGood: Bool) {
        let base = SKSpriteNode(imageNamed: isGood ? "slotBaseGood" : "slotBaseBad")
        let glow = SKSpriteNode(imageNamed: isGood ? "slotGlowGood" : "slotGlowBad")
        
        base.name = isGood ? "good" : "bad"
        base.position = position
        base.physicsBody = SKPhysicsBody(rectangleOf: base.size)
        base.physicsBody?.isDynamic = false
        glow.position = position
        
        addChild(base)
        addChild(glow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        glow.run(spinForever)
    }
    
    private func checkForGameOver() {
        if let scene = scene, scene.childNode(withName: "ball") == nil && (ballsRemaining == 0 || userScore == selectedDifficulty.rawValue) {
            gameOver()
        }
    }
    
    private func gameOver() {
        remainingBallsLabel.text = userScore == selectedDifficulty.rawValue ? "Victory" : "Defeat"
        remainingBallsLabel.fontColor = userScore == selectedDifficulty.rawValue ? .green : .red
    }
}
