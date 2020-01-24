//
//  GameScene.swift
//  p26.marble-maze
//
//  Created by Matt Brown on 1/23/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

final class GameScene: SKScene {
    
    private enum ViewMetrics {
        static let labelFontName = "Chalkduster"
    }
    
    private let background: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameAsset.Image.background.filename)
        node.position = CGPoint(x: 512, y: 384)
        node.zPosition = -1
        node.blendMode = .replace
        return node
    }()
    
    private var userScore = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(userScore)"
        }
    }
    
    private let scoreLabel: SKLabelNode = {
        let label = SKLabelNode(fontNamed: ViewMetrics.labelFontName)
        label.text = "SCORE: 0"
        label.horizontalAlignmentMode = .left
        label.position = CGPoint(x: 20, y: 32)
        label.zPosition = 2
        return label
    }()
    
    private var player: SKSpriteNode!
    private var lastTouchPosition: CGPoint?
    private var motionManager: CMMotionManager!
    private var isGameOver = false
    private var teleporters = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
        setupView()
        newGame()
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    private func setupView() {
        userScore = 0
        [background, scoreLabel].forEach { addChild($0) }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        #if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let difference = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: difference.x / 100, dy: difference.y / 100)
        }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * 50, dy: accelerometerData.acceleration.x * -50)
        }
        #endif
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        }
        else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
}

extension GameScene {
    fileprivate func newGame() {
        for node in children where (node != background) && (node != scoreLabel) {
            node.removeFromParent()
        }
        
        isGameOver = false
        userScore = 0
        lastTouchPosition = nil
        loadLevel()
        createPlayer()
    }
    
    private func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else { fatalError("Unable to locate file for level.") }
        guard let levelContent = try? String(contentsOf: levelURL) else { fatalError("Unable to load level contents.") }
        levelContent
            .components(separatedBy: "\n")
            .reversed()
            .compactMap { $0.isEmpty ? nil : $0 }
            .enumerated()
            .forEach { [weak self] (row, line) in
                line
                    .enumerated()
                    .forEach { (column, character) in
                        let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                        guard let element = BoardElement(for: character) else { return }
                        self?.addElement(type: element, at: position)
                }
        }
    }
    
    private func addElement(type: BoardElement, at location: CGPoint) {
        let node = type.spriteNode
        node.name = type.nodeName
        node.position = location
        
        if let animation = type.idleAnimation {
            node.run(animation)
        }
        
        node.physicsBody = {
            switch type {
            case .finish, .star, .teleporter, .vortex:
                return SKPhysicsBody(circleOfRadius: node.size.width / 2)
            case .wall:
                return SKPhysicsBody(rectangleOf: node.size)
            default:
                return nil
            }
        }()
        
        node.physicsBody?.categoryBitMask = type.categoryBitmask
        node.physicsBody?.contactTestBitMask = type.contactTestBitmask
        node.physicsBody?.collisionBitMask = type.collisionBitMask
        node.physicsBody?.isDynamic = false
        
        if type == .teleporter { teleporters.append(node) }
        addChild(node)
    }
    
    private func createPlayer() {
        player = BoardElement.player.spriteNode
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = BoardElement.player.categoryBitmask
        player.physicsBody?.contactTestBitMask = BoardElement.finish.categoryBitmask
            | BoardElement.star.categoryBitmask
            | BoardElement.teleporter.categoryBitmask
            | BoardElement.vortex.categoryBitmask
        player.physicsBody?.collisionBitMask = BoardElement.wall.categoryBitmask
        addChild(player)
    }
    
    fileprivate func playerCollided(with node: SKNode) {
        if node.name == BoardElement.vortex.rawValue {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            userScore -= (userScore > 0) ? 1 : 0
            
            let moveToCenter = SKAction.move(to: node.position, duration: 0.5)
            let scaleDown = SKAction.scale(to: 0.0001, duration: 0.5)
            let suckedIn = SKAction.group([moveToCenter, scaleDown])
            let remove = SKAction.removeFromParent()
            player.run(SKAction.sequence([suckedIn, remove])) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        }
        else if node.name == BoardElement.star.rawValue {
            node.removeFromParent()
            userScore += 1
        }
        else if node.name == BoardElement.teleporter.rawValue {
            guard let exitNode = teleporters.first(where: { $0 != node }  ) else { return }

            for node in children where node.name == BoardElement.teleporter.rawValue {
                node.removeFromParent()
            }
            
            teleporters.removeAll(keepingCapacity: true)
            player.run(SKAction.move(to: exitNode.position, duration: 0.0))
        }
        else if node.name == BoardElement.finish.rawValue {
            if let emitter = SKEmitterNode(fileNamed: GameAsset.Emitter.explosion.rawValue) {
                emitter.position = player.position
                addChild(emitter)
                gameOver()
            }
        }
    }
    
    private func gameOver() {
        isGameOver = true
        player.removeFromParent()
        run(SKAction.playSoundFileNamed(GameAsset.Audio.explosion.filename, waitForCompletion: false)) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self?.newGame()
            }
        }
    }
}
