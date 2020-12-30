//
//  Player.swift
//  p34.four-in-a-row
//
//  Created by Matt Brown on 12/29/20.
//

import GameplayKit
import UIKit

final class Player: NSObject, GKGameModelPlayer {
    static var allPlayers = [Player(tokenColor: .red), Player(tokenColor: .black)]
    
    let tokenColor: TokenColor
    let drawColor: UIColor
    let name: String
    let playerId: Int
    
    var opponent: Player {
        (tokenColor == .red) ? Player.allPlayers[1]: Player.allPlayers[0]
    }
    
    init(tokenColor: TokenColor) {
        self.tokenColor = tokenColor
        self.playerId = tokenColor.rawValue
        self.drawColor = (tokenColor == .red) ? .red : .black
        self.name = (tokenColor == .red) ? "Red" : "Black"
        
        super.init()
    }
}
