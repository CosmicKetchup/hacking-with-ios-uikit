//
//  GameBoard.swift
//  p34.four-in-a-row
//
//  Created by Matt Brown on 12/28/20.
//

import GameplayKit
import UIKit

enum TokenColor: Int {
    case none = 0
    case red
    case black
}

final class GameBoard: NSObject  {
    static var width = 7
    static var height = 6
    
    var slots = [TokenColor]()
    var currentPlayer: Player
    
    override init() {
        for _ in (0 ..< (GameBoard.width * GameBoard.height)) {
            slots.append(.none)
        }
        
        currentPlayer = Player.allPlayers[0]
        super.init()
    }
    
    private func token(inColumn column: Int, row: Int) -> TokenColor {
        slots[row + column * GameBoard.height]
    }
    
    private func set(token: TokenColor, column: Int, row: Int) {
        slots[row + column * GameBoard.height] = token
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in (0 ..< GameBoard.height) {
            if token(inColumn: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    private func canPlaceToken(in column: Int) -> Bool {
        nextEmptySlot(in: column) != nil
    }
    
    func add(token: TokenColor, in column: Int) {
        guard let row = nextEmptySlot(in: column) else { return }
        set(token: token, column: column, row: row)
    }
    
    func isFull() -> Bool {
        for column in (0 ..< GameBoard.width) {
            if canPlaceToken(in: column) {
                return false
            }
        }
        
        return true
    }
    
    private func squaresMatchFor(baseToken: TokenColor, column: Int, row: Int, dX: Int, dY: Int) -> Bool {
        // ensure winning move wouldn't extend beyond game board
        if row + (dY * 3) < 0 { return false }
        if row + (dY * 3) >= GameBoard.height { return false }
        if column + (dX * 3) < 0 { return false }
        if column + (dX * 3) >= GameBoard.width { return false }
        
        for i in (0...3) {
            if token(inColumn: column + (dX * i), row: row + (dY * i)) != baseToken { return false }
        }
        
        return true
    }
}

extension GameBoard: GKGameModel {
    var players: [GKGameModelPlayer]? {
        Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        currentPlayer
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameBoard()
        copy.setGameModel(self)
        return copy
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? GameBoard {
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let playerObject = player as? Player else { return nil }
        guard !isWin(for: playerObject) || !isWin(for: playerObject.opponent) else { return nil }
        
        var moves = [Move]()
        (0 ..< GameBoard.width).forEach { column in
            if canPlaceToken(in: column) {
                moves.append(Move(column: column))
            }
        }
        return moves
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else { return }
        add(token: currentPlayer.tokenColor, in: move.column)
        currentPlayer = currentPlayer.opponent
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWin(for: playerObject) {
                return 1000
            }
            else if isWin(for: playerObject.opponent) {
                return -1000
            }
        }
        return 0
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let token = (player as? Player)?.tokenColor else { fatalError() }
        
        for row in (0 ..< GameBoard.width) {
            for col in (0 ..< GameBoard.height) {
                if squaresMatchFor(baseToken: token, column: col, row: row, dX: 1, dY: 0) {
                    return true
                }
                else if squaresMatchFor(baseToken: token, column: col, row: row, dX: 0, dY: 1) {
                    return true
                }
                else if squaresMatchFor(baseToken: token, column: col, row: row, dX: 1, dY: 1) {
                    return true
                }
                else if squaresMatchFor(baseToken: token, column: col, row: row, dX: 1, dY: -1) {
                    return true
                }
            }
        }
        
        return false
    }
}
