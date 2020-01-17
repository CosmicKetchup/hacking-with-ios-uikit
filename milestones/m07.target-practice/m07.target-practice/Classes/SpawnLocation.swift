//
//  SpawnLocation.swift
//  m07.target-practice
//
//  Created by Matt Brown on 1/14/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation
import SpriteKit

enum SpawnLocation {
    
    case front(side: Side)
    case rear
    case overhead
    
    enum Side {
        case right, left
        
        var spawnPosition: CGPoint {
            switch self {
            case .left:
                return CGPoint(x: -450, y: -350)
            case .right:
                return CGPoint(x: 345, y: -330)
            }
        }
        
        var endPosition: CGPoint {
            switch self {
            case .left:
                return CGPoint(x: -280, y: -400)
            case .right:
                return CGPoint(x: 100, y: -100)
            }
        }
    }
    
    enum Distance {
        case near, far, overhead
    }
    
    static let allSpawnPoints: [SpawnLocation] = [.overhead, .rear, .front(side:.left), .front(side: .right)]
    
    func characterNode(isEnemy: Bool) -> CharacterType {
        switch self {
        case .overhead:
            return .santa
        default:
            return CharacterType(isEnemy: isEnemy)
        }
    }
    
    var distance: SpawnLocation.Distance {
        switch self {
        case .front(_):
            return .near
        case .rear:
            return .far
        case .overhead:
            return .overhead
        }
    }
    
    var requiresMirroredTexture: Bool {
        switch self {
        case .front(.left), .rear:
            return true
        default:
            return false
        }
    }
    
    var characterScale: CGFloat {
        switch self {
        case .front(.left):
            return 0.8
        case .rear:
            return 0.3
        default:
            return 1.0
        }
    }
    
    var hideTimeMultipler: Double {
        switch self {
        case .overhead:
            return 5.0
        default:
            return 1.0
        }
    }
    
    var maskNode: SKNode {
        switch self {
        case .front(_):
            return SKSpriteNode(imageNamed: "foregroundCrop")
        case .rear:
            return SKSpriteNode(imageNamed: "backgroundCrop")
        case .overhead:
            return SKSpriteNode(imageNamed: "overheadCrop")
        }
    }
    
    // MARK: - Positioning
    var zPosition: CGFloat {
        switch self {
        case .front(_):
            return 3
        case .rear:
            return 2
        case .overhead:
            return 1
        }
    }
    
    var hiddenPositionStart: CGPoint {
        switch self {
        case .front(let side):
            return side.spawnPosition
        case .rear:
            return CGPoint(x: -180, y: -275)
        case .overhead:
            return CGPoint(x: 700, y: 100)
        }
    }
    
    var hiddenPositionEnd: CGPoint {
        switch self {
        case .front(let side):
            return side.endPosition
        case .rear:
            return CGPoint(x: -30, y: -275)
        case .overhead:
            return CGPoint(x: -600, y: 100)
        }
    }
    
    // MARK: - Movement
    func appearanceAction(isEnemy: Bool) -> SKAction {
        switch self {
        case .front(.left):
            return SKAction.moveBy(x: 0, y: 200 + (isEnemy ? 0 : 30), duration: 0.2)
        case .front(.right):
            return SKAction.moveBy(x: 0, y: 100 + (isEnemy ? 0 : 65), duration: 0.1)
        case .rear:
            return SKAction.moveBy(x: 0, y: 90 + (isEnemy ? 0 : 15), duration: 0.1)
        case .overhead:
            return SKAction.moveBy(x: 0, y: 0, duration: 0.1)
        }
    }
    
    var hitAction: SKAction {
        switch self {
        case .overhead:
            let rotate = SKAction.rotate(byAngle: 10 * .pi / 180, duration: 0.5)
            let dropPosition = SKAction.moveBy(x: -500, y: -500, duration: 3.0)
            return SKAction.group([rotate, dropPosition])
        default:
            return self.hideAction
        }
    }
    
    private var hideAction: SKAction {
        switch self {
        case .front(.left):
            return SKAction.move(by: CGVector(dx: 0, dy: -250), duration: 0.25)
        case .front(.right):
            return SKAction.move(by: CGVector(dx: 0, dy: -250), duration: 0.15)
        case .rear:
            return SKAction.move(by: CGVector(dx: 0, dy: -125), duration: 0.2)
        case .overhead:
            return SKAction.move(by: CGVector(dx: -500, dy: 0), duration: 5.0)
        }
    }
    
    var resetAction: SKAction {
        switch self {
        default:
            let resetSize = SKAction.scale(to: 1.0, duration: 0)
            let resetPosition = SKAction.move(to: self.hiddenPositionStart, duration: 0)
            return SKAction.sequence([self.hideAction, resetSize, resetPosition])
        }
    }
    
    func approachingAction(duration: Double) -> SKAction?  {
        switch self {
        case .front(.left):
            return SKAction.scale(by: 1.5, duration: duration)
        case .front(.right):
            return SKAction.scale(by: 2.0, duration: duration)
        default:
            return nil
        }
    }
    
    private func horizontalMovement(duration: Double) -> SKAction? {
        switch self {
        case .front(.left):
            return SKAction.moveBy(x: 75, y: 0, duration: duration + 0.1)
        case .front(.right):
            return SKAction.moveBy(x: -175, y: 100, duration: duration + 0.1)
        case .rear:
            return SKAction.moveBy(x: 150, y: -12, duration: duration + 0.1)
        case .overhead:
            return SKAction.moveBy(x: -1700, y: 0, duration: duration * self.hideTimeMultipler)
        }
    }
    
    private var runningPerspectiveDistance: BounceDistance {
        switch self {
        case .front(_):
            return .near
        case .rear:
            return .far
        case .overhead:
            return .none
        }
    }
    
    func secondaryActions(duration: Double) -> [SKAction] {
        [approachingAction(duration: duration), SKAction.runningAnimation(self.runningPerspectiveDistance), horizontalMovement(duration: duration)].compactMap { $0 }
    }
}
