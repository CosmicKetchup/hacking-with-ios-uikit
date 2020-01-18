//
//  GameScene.swift
//  p20.fireworks-night
//
//  Created by Matt Brown on 1/17/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    
    private enum ViewMetrics {
        static let labelFontNamed = "Chalkduster"
        static let labelFontColor = UIColor.lightGray
        static let scoreLabelFontSize: CGFloat = 24.0
        static let finalScoreLabelFontSize: CGFloat = 56.0
    }
    
    private enum GameAssets: String {
        case background
        case firework = "rocket"
        case fuse
        case explosion = "explode"
    }
    
    private enum LaunchPosition {
        case left
        case right
        case bottom
        
        var edge: Int {
            self == .right ? 1024 + 22 : -22
        }
    }
    
    private enum FireworkColor: Int {
        case cyan
        case green
        case red
        
        var color: UIColor {
            switch self {
            case .cyan:
                return .cyan
            case .green:
                return .green
            case .red:
                return .red
            }
        }
    }
    
    var totalLaunches = 0
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    var userScore = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(userScore)"
        }
    }
    
    private let scoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: ViewMetrics.labelFontNamed)
        label.fontColor = ViewMetrics.labelFontColor
        label.fontSize = ViewMetrics.scoreLabelFontSize
        label.text = "SCORE: 0"
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: 25, y: 25)
        return label
    }()
    
    private let finalScoreLabel: SKLabelNode = {
       let label = SKLabelNode(fontNamed: ViewMetrics.labelFontNamed)
        label.fontColor = ViewMetrics.labelFontColor
        label.fontSize = ViewMetrics.finalScoreLabelFontSize
        label.text = "FINAL SCORE"
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: 512, y: 384)
        label.isHidden = true
        return label
    }()
    
    private let background: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameAssets.background.rawValue)
        node.position = CGPoint(x: 512, y: 384)
        node.zPosition = -1
        node.blendMode = .replace
        return node
    }()
    
    override func didMove(to view: SKView) {
        [background, scoreLabel, finalScoreLabel].forEach { addChild($0) }
        newGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        fireworks.enumerated().reversed().forEach { (index, firework) in
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for case let node as SKSpriteNode in nodes(at: location) {
            guard node.name == GameAssets.firework.rawValue else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = GameAssets.firework.rawValue
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
}

extension GameScene {
    fileprivate func newGame() {
        userScore = 0
        totalLaunches = 0
        finalScoreLabel.isHidden = true
        scoreLabel.isHidden = false
        assert(fireworks.isEmpty)
        gameTimer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    private func gameOver() {
        gameTimer?.invalidate()
        scoreLabel.isHidden = true
        finalScoreLabel.text = userScore.description
        finalScoreLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.newGame()
        }
    }
    
    @objc fileprivate func launchFireworks() {
        guard totalLaunches < 25 else { gameOver(); return }
        let movementAmount: CGFloat = 1800
        totalLaunches += 1
        
        switch Int.random(in: 0...3) {
        case 0: // fire five straight upwards
            (-2...2).forEach { createFirework(at: CGPoint(x: 512 + ($0 * 100), y: LaunchPosition.bottom.edge), dx: 0) }
            
        case 1: // fire five in a fan-shape
            (-2...2).forEach { createFirework(at: CGPoint(x: 512 + ($0 * 100), y: LaunchPosition.bottom.edge), dx: CGFloat($0 * 100)) }
            
        case 2: // fire five from left to right
            (0...4).forEach { createFirework(at: CGPoint(x: LaunchPosition.left.edge, y: LaunchPosition.bottom.edge + ($0 * 100)), dx: movementAmount) }
            
        case 3: // fire five from right to left
            (0...4).forEach { createFirework(at: CGPoint(x: LaunchPosition.right.edge, y: LaunchPosition.bottom.edge + ($0 * 100)), dx: -movementAmount) }
            
        default:
            break
        }
    }
    
    private func createFirework(at location: CGPoint, dx: CGFloat) {
        let node = SKNode()
        node.position = location
        
        let firework = SKSpriteNode(imageNamed: GameAssets.firework.rawValue)
        firework.colorBlendFactor = 1
        firework.name = GameAssets.firework.rawValue
        node.addChild(firework)
        firework.color = FireworkColor(rawValue: Int.random(in: 0...2))?.color ?? .red
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: dx, y: 1000))
        let launch = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(launch)
        
        if let emitter = SKEmitterNode(fileNamed: GameAssets.fuse.rawValue) {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    func explodeFireworks() {
        var explodedAmount = 0
        
        fireworks.enumerated().reversed().forEach { (index, container) in
            guard let firework = container.children.first as? SKSpriteNode else { return }
            if firework.name == "selected" {
                explode(container)
                fireworks.remove(at: index)
                explodedAmount += 1
            }
        }
        
        switch explodedAmount {
        case 1:
            userScore += 200
        case 2:
            userScore += 500
        case 3:
            userScore += 1500
        case 4:
            userScore += 2500
        case 5:
            userScore += 4000
        default:
            break
        }

    }
    
    private func explode(_ firework: SKNode) {
        guard let emitter = SKEmitterNode(fileNamed: GameAssets.explosion.rawValue) else { return }
        emitter.position = firework.position
        addChild(emitter)
        firework.removeFromParent()
        
        let wait = SKAction.wait(forDuration: 3.0)
        let remove = SKAction.run { emitter.removeFromParent() }
        let cleanup = SKAction.sequence([wait, remove])
        emitter.run(cleanup)
    }
}
