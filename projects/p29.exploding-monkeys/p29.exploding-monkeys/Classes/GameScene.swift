//
//  GameScene.swift
//  p29.exploding-monkeys
//
//  Created by Matt Brown on 1/25/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private enum SceneMetrics {
        static let backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
    }
    
    enum Player: Int {
        case player1 = 1
        case player2
        
        var nodeName: String {
            GameAsset.Image.player.rawValue + self.rawValue.description
        }
    }
    
    weak var parentViewController: GameViewController!
    private var buildings = [BuildingNode]()
    private var player1: SKSpriteNode!
    private var player2: SKSpriteNode!
    var currentPlayer: Int!
    private var banana: SKSpriteNode!
    private var windSpeed: Int!
    var windSpeedReported = false
    
    override func didMove(to view: SKView) {
        setupScene()
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
        let randomWindSpeed = Int.random(in: -3...3)
        windSpeed = randomWindSpeed
        physicsWorld.gravity = CGVector(dx: randomWindSpeed, dy: -9)
    }
    
    private func setupScene() {
        backgroundColor = SceneMetrics.backgroundColor
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let nodeA = firstBody.node, let nodeB = secondBody.node else { return }
        
        if nodeA.name == GameAsset.Image.banana.rawValue && nodeB.name == "building" {
            bananaHit(nodeB, atPoint: contact.contactPoint)
        }
        
        if nodeA.name == GameAsset.Image.banana.rawValue && nodeB.name == "player1" {
            destroy(player1)
        }
        
        if nodeA.name == GameAsset.Image.banana.rawValue && nodeB.name == "player2" {
            destroy(player2)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
        
        guard !windSpeedReported, parentViewController != nil, windSpeed != nil else { return }
        parentViewController.updateWindDisplay(to: windSpeed)
    }
}

extension GameScene {
    fileprivate func createBuildings() {
        var currentX: CGFloat = -15
        while currentX < 1024 {
            let randomSize = CGSize(
                width: Int.random(in: 2...4) * 40,
                height: Int.random(in: 300...600))
            currentX += randomSize.width + 2
            let building = BuildingNode(color: .red, size: randomSize)
            building.position = CGPoint(
                x: currentX - (randomSize.width / 2),
                y: randomSize.height / 2)
            building.create()
            addChild(building)
            buildings.append(building)
        }
    }
    
    fileprivate func createPlayers() {
        player1 = GameAsset.Image.player.spriteNode
        player1.name = GameAsset.Image.player.rawValue + 1.description
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = GameAsset.Image.player.categoryBitMask
        player1.physicsBody?.contactTestBitMask = GameAsset.Image.player.contactBitMask
        player1.physicsBody?.collisionBitMask = GameAsset.Image.player.collisionBitMask
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(
            x: player1Building.position.x,
            y: player1Building.position.y + (player1Building.size.height + player1.size.height) / 2)
        addChild(player1)
        
        player2 = GameAsset.Image.player.spriteNode
        player2.name = GameAsset.Image.player.rawValue + 2.description
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = GameAsset.Image.player.categoryBitMask
        player2.physicsBody?.contactTestBitMask = GameAsset.Image.player.contactBitMask
        player2.physicsBody?.collisionBitMask = GameAsset.Image.player.collisionBitMask
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(
            x: player2Building.position.x,
            y: player2Building.position.y + (player2Building.size.height + player2.size.height) / 2)
        addChild(player2)
    }
    
    func launch(angle: Int, velocity: Int) {
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = GameAsset.Image.banana.spriteNode
        banana.name = GameAsset.Image.banana.rawValue
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = GameAsset.Image.banana.categoryBitMask
        banana.physicsBody?.contactTestBitMask = GameAsset.Image.banana.contactBitMask
        banana.physicsBody?.collisionBitMask = GameAsset.Image.banana.collisionBitMask
        
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        let speed = Double(velocity) / 10
        let radians = angle.convertedToRadians()
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            
            let raiseArm = SKAction.setTexture(GameAsset.Texture.player1Throw.texture)
            let pause = SKAction.wait(forDuration: 0.25)
            let lowerArm = SKAction.setTexture(GameAsset.Texture.player.texture)
            let throwSequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player1.run(throwSequence)

            let launchBanana = CGVector(
                dx: cos(radians) * speed,
                dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(launchBanana)
        }
        else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(GameAsset.Texture.player2Throw.texture)
            let pause = SKAction.wait(forDuration: 0.25)
            let lowerArm = SKAction.setTexture(GameAsset.Texture.player.texture)
            let throwSequence = SKAction.sequence([raiseArm, pause, lowerArm])
            player2.run(throwSequence)
            
            let launchBanana = CGVector(
                dx: cos(radians) * -speed,
                dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(launchBanana)
        }
    }
    
    fileprivate func bananaHit(_ building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: GameAsset.Emitter.buildingHit.rawValue) {
            explosion.position = contactPoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        changePlayer()
    }
    
    fileprivate func destroy(_ player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: GameAsset.Emitter.playerHit.rawValue) {
            explosion.position = player.position
            addChild(explosion)
        }
        
        player.name == Player.player1.nodeName ? parentViewController.gameWon(by: .player2) : parentViewController.gameWon(by: .player1)
        player.removeFromParent()
        banana?.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let newGame = GameScene(size: self.size)
            newGame.parentViewController = self.parentViewController
            self.parentViewController.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let doorway = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: doorway)
        }
    }
    
    func changePlayer() {
        currentPlayer = currentPlayer == 1 ? 2 : 1
        parentViewController.activatePlayer(currentPlayer)
    }
}

private extension Int {
    func convertedToRadians() -> Double {
        Double(self) * Double.pi / 180
    }
}
