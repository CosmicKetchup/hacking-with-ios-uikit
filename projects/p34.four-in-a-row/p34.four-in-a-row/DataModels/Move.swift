//
//  Move.swift
//  p34.four-in-a-row
//
//  Created by Matt Brown on 12/29/20.
//

import GameplayKit
import UIKit

final class Move: NSObject, GKGameModelUpdate {
    
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
