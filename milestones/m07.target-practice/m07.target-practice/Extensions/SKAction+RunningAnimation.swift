//
//  SKAction+RunningAnimation.swift
//  m07.target-practice
//
//  Created by Matt Brown on 1/15/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import SpriteKit

enum BounceDistance {
    case near, far, none
    
    var motionDelta: CGFloat? {
        switch self {
        case .near:
            return 15.0
        case .far:
            return 6.0
        case .none:
            return nil
        }
    }
}

extension SKAction {
    static func runningAnimation(_ distance: BounceDistance) -> SKAction? {
        guard let yDelta = distance.motionDelta else { return nil }
        let frameA = SKAction.moveBy(x: 0, y: yDelta, duration: 0.15)
        let frameB = SKAction.reversed(frameA)()
        let runSequence = SKAction.sequence([frameA, frameB])
        return SKAction.repeatForever(runSequence)
    }
}
