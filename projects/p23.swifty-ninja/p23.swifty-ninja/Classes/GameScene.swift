//
//  GameScene.swift
//  p23.swifty-ninja
//
//  Created by Matt Brown on 1/21/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

final class GameScene: SKScene {
    
    private enum SceneMetrics {
        static let labelFont = "Chalkduster"
        static let labelFontSize: CGFloat = 48.0
        static let sliceForegroundColor = UIColor.white
        static let sliceBackgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0, alpha: 1.0)
    }
    
    enum NodeName: String {
        case none = ""
        case enemy, bomb, bombContainer, rare
    }
    
    private let background: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameAsset.Image.background.rawValue)
        node.position = CGPoint(x: 512, y: 378)
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
        let label = SKLabelNode(fontNamed: SceneMetrics.labelFont)
        label.horizontalAlignmentMode = .left
        label.fontSize = SceneMetrics.labelFontSize
        label.position = CGPoint(x: 10, y: 10)
        label.text = "SCORE: 0"
        label.alpha = 0.9
        return label
    }()
    
    private var lives = 3
    private var livesImages = [SKSpriteNode]()
    private var isSwooshActive = false
    private var activeEnemies = [SKSpriteNode]()
    private var activeSlicePoints = [CGPoint]()
    private var bombSoundEffect: AVAudioPlayer?
    
    private var isGameEnded = false
    private var popUpTime = 0.9
    private var sequence = [SequenceType]()
    private var sequencePosition = 0
    private var chainDelay = 3.0
    private var nextSequenceQueued = true
    
    private let activeSliceFG: SKShapeNode = {
        let node = SKShapeNode()
        node.zPosition = 3
        node.strokeColor = SceneMetrics.sliceForegroundColor
        node.lineWidth = 5.0
        return node
    }()
    
    private let activeSliceBG: SKShapeNode = {
        let node = SKShapeNode()
        node.zPosition = 2
        node.strokeColor = SceneMetrics.sliceBackgroundColor
        node.lineWidth = 9.0
        return node
    }()
    
    private let gameOverNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: GameAsset.Image.gameOver.rawValue)
        node.zPosition = 5
        node.position = CGPoint(x: 512, y: 384)
        node.isHidden = true
        node.colorBlendFactor = 1
        return node
    }()
    
    override func didMove(to view: SKView) {
        setupView()
        newGame()
    }
    
    private func setupView() {
        [background, scoreLabel, activeSliceBG, activeSliceFG, gameOverNode].forEach { addChild($0) }
        createLives()
        gameOverNode.color = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()
        
        activeSliceFG.alpha = 1.0
        activeSliceBG.alpha = 1.0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, !isGameEnded else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        
        if !isSwooshActive {
            playSwooshSound()
        }
        
        for case let node as SKSpriteNode in nodes(at: location) {
            if node.name == NodeName.enemy.rawValue || node.name == NodeName.rare.rawValue {
                if let emitter = SKEmitterNode(fileNamed: GameAsset.Emitter.enemyHit.rawValue) {
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                userScore += node.name == NodeName.rare.rawValue ? 10 : 1
                node.name = NodeName.none.rawValue
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let hitGroup = SKAction.group([scaleOut, fadeOut])
                let hitSequence = SKAction.sequence([hitGroup, .removeFromParent()])
                node.run(hitSequence)
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed(GameAsset.Audio.whack.filename, waitForCompletion: false))
            }
            else if node.name == NodeName.bomb.rawValue {
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                if let emitter = SKEmitterNode(fileNamed: GameAsset.Emitter.bombHit.rawValue) {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                node.name = NodeName.none.rawValue
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let hitGroup = SKAction.group([scaleOut, fadeOut])
                let hitSequence = SKAction.sequence([hitGroup, .removeFromParent()])
                bombContainer.run(hitSequence)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed(GameAsset.Audio.explosion.filename, waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            activeEnemies
                .enumerated()
                .reversed()
                .forEach { node in
                    guard node.element.position.y < -140 || node.element.position.y > 1000 else { return }
                    node.element.removeAllActions()
                    
                    if node.element.name == NodeName.enemy.rawValue {
                        subtractLife()
                    }
                    
                    node.element.name = NodeName.none.rawValue
                    node.element.removeFromParent()
                    activeEnemies.remove(at: node.offset)
            }
        }
        else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popUpTime) { [weak self] in self?.tossEnemies() }
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == NodeName.bombContainer.rawValue {
                bombCount += 1
                break
            }
        }
        
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
}

extension GameScene {
    fileprivate func newGame() {
        isUserInteractionEnabled = true
        gameOverNode.isHidden = true
        userScore = 0
        isGameEnded = false
        popUpTime = 0.9
        sequence.removeAll(keepingCapacity: true)
        sequencePosition = 0
        chainDelay = 3.0
        lives = 3
        createLives()
        
        activeEnemies.reversed().forEach { node in
            node.removeAllActions()
            node.removeFromParent()
        }
        activeEnemies.removeAll(keepingCapacity: true)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        sequence = [.one, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        (0...1000).forEach { _ in
            guard let nextSequence = SequenceType.allCases.randomElement() else { return }
            sequence.append(nextSequence)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in self?.tossEnemies()}
    }
    
    fileprivate func createLives() {
        livesImages.enumerated().reversed().forEach { node in
            node.element.removeFromParent()
            livesImages.remove(at: node.offset)
        }
        
        (0...2).forEach { i in
            let node = SKSpriteNode(imageNamed: GameAsset.Image.playerLife.rawValue)
            node.position = CGPoint(x: 834 + (i*70), y: 720)
            node.alpha = 0.9
            addChild(node)
            livesImages.append(node)
        }
    }
    
    fileprivate func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceFG.path = nil
            activeSliceBG.path = nil
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12) // ensures only 12 points remain in array at max
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        (1 ..< activeSlicePoints.count).forEach { path.addLine(to: activeSlicePoints[$0]) }
        
        activeSliceFG.path = path.cgPath
        activeSliceBG.path = path.cgPath
    }
    
    fileprivate func playSwooshSound() {
        isSwooshActive = true
        let swooshSound = SKAction.playSoundFileNamed(GameAsset.Audio.sliceSwoosh.filename, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshActive = false
        }
    }
    
    fileprivate func tossEnemies() {
        guard !isGameEnded else { return }
        popUpTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed = 1.2
        
        let sequenceType = sequence[sequencePosition]
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        
        case .twoWithOneBomb:
            createEnemy()
            createEnemy(forceBomb: .always)
            
        case .chain:
            createEnemy()
            
            (0...4).forEach { i in
                guard let interval = Double(exactly: i) else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5 * interval)) { [weak self] in self?.createEnemy() }
            }
            
        case .fastChain:
            (0...4).forEach { i in
                guard let interval = Double(exactly: i) else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10 * interval)) { [weak self] in self?.createEnemy() }
            }
            
        default:
            (0 ... sequenceType.rawValue).forEach { _ in createEnemy() }
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    fileprivate func createEnemy(forceBomb: ForceBomb = .random) {
        let enemyType = forceBomb.enemyType
        let enemy = enemyType.spriteNode
        enemy.name = enemyType.nodeName.rawValue
        enemy.zPosition = 1
        enemy.position = CGPoint(x: Int.random(in: 64...960), y: -128)
        
        if enemyType == .bomb {
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            if let path = Bundle.main.url(forResource: GameAsset.Audio.bombFuse.rawValue, withExtension: GameAsset.Audio.fileExtension), let sound = try? AVAudioPlayer(contentsOf: path) {
                bombSoundEffect = sound
                sound.play()
            }
        }
        else {
            run(SKAction.playSoundFileNamed(GameAsset.Audio.launch.filename, waitForCompletion: false))
        }

        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if enemy.position.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        }
        else if enemy.position.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        }
        else if enemy.position.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        }
        else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYVelocity = enemyType == .evilPenguin ? 50 : Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
    }
    
    fileprivate func subtractLife() {
        lives -= 1
        run(SKAction.playSoundFileNamed(GameAsset.Audio.wrong.filename, waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        }
        else if lives == 1 {
            life = livesImages[1]
        }
        else {
            life = livesImages[2]
            endGame()
        }
        
        life.texture = SKTexture(imageNamed: GameAsset.Image.playerLifeGone.rawValue)
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1.0, duration: 0.1))
    }
    
    fileprivate func endGame(triggeredByBomb: Bool = false) {
        guard !isGameEnded else { return }
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggeredByBomb {
            livesImages.forEach { $0.texture = SKTexture(imageNamed: GameAsset.Image.playerLifeGone.rawValue) }
        }
        
        gameOverNode.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { [weak self] in self?.newGame() }
    }
}
