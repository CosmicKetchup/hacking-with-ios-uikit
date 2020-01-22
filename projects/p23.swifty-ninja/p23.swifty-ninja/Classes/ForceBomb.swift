//
//  ForceBomb.swift
//  p23.swifty-ninja
//
//  Created by Matt Brown on 1/21/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation

enum ForceBomb {
    case never, always, random
    
    var enemyType: EnemyType {
        switch self {
        case .never:
            return .penguin
        case .always:
            return .bomb
        case .random:
            return EnemyType.random(odds: 10)
        }
    }
}
