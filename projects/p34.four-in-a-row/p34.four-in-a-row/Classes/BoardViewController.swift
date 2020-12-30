//
//  BoardViewController.swift
//  p34.four-in-a-row
//
//  Created by Matt Brown on 12/28/20.
//

import GameplayKit
import UIKit

final class BoardViewController: UIViewController {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.systemGray
        static let stackSpacing: CGFloat = 2.0
    }
    
    private enum AnimationMetrics {
        static let tokenDropDuration: TimeInterval = 0.5
        static let tokenDropDelay: TimeInterval = 0
    }
    
    private var board: GameBoard!
    private var strategist: GKMinmaxStrategist!
    private var placedTokens = [[UIView]]()
    
    private var button0 = UIButton.create(tag: 0)
    private var button1 = UIButton.create(tag: 1)
    private var button2 = UIButton.create(tag: 2)
    private var button3 = UIButton.create(tag: 3)
    private var button4 = UIButton.create(tag: 4)
    private var button5 = UIButton.create(tag: 5)
    private var button6 = UIButton.create(tag: 6)
    private lazy var allButtons = [button0, button1, button2, button3, button4, button5, button6]
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: allButtons)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = ViewMetrics.stackSpacing
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 9
        strategist.randomSource = nil
        
        setupView()
        resetBoard()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor

        allButtons.forEach { $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) }
        
        [buttonStack].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: view.topAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        (0 ..< GameBoard.width).forEach { _ in
            placedTokens.append([UIView]())
        }
    }
    
    private func updateView() {
        navigationItem.title = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.tokenColor == .black {
//            startAIMove()
        }
    }
    
    private func resetBoard() {
        board = GameBoard()
        strategist.gameModel = board
        updateView()
        
        (0 ..< placedTokens.count).forEach { i in
            placedTokens[i].forEach { $0.removeFromSuperview() }
            placedTokens[i].removeAll(keepingCapacity: true)
        }
    }
    
    private func continueGame() {
        var gameOverTitle: String? = nil
        
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        }
        else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
                self?.resetBoard()
            })
            present(alert, animated: true)
            return
        }
        
        board.currentPlayer = board.currentPlayer.opponent
        updateView()
    }
    
    private func addToken(column: Int, row: Int, color: UIColor) {
        let button = allButtons[column]
        let size = min(button.frame.width, (button.frame.height / 6))
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if (placedTokens[column].count < row + 1) {
            let newToken = UIView(frame: rect)
            newToken.isUserInteractionEnabled = false
            newToken.backgroundColor = color
            newToken.layer.cornerRadius = size / 2
            newToken.center = positionForTokenIn(column: column, row: row)
            newToken.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newToken)
            
            UIView.animate(withDuration: AnimationMetrics.tokenDropDuration, delay: AnimationMetrics.tokenDropDelay, options: .curveEaseIn, animations: {
                newToken.transform = CGAffineTransform.identity
            })
            
            placedTokens[column].append(newToken)
        }
    }
    
    private func positionForTokenIn(column: Int, row: Int) -> CGPoint {
        let button = allButtons[column]
        let size = min(button.frame.width, (button.frame.height / 6))
        
        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - (size / 2)
        yOffset -= size * CGFloat(row)
        
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    private func columnForAIMove() -> Int? {
        guard let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move else { return nil }
        return aiMove.column
    }
    
    private func makeAIMove(in column: Int) {
        allButtons.forEach { $0.isEnabled = true }
        navigationItem.rightBarButtonItem = nil
        
        guard let row = board.nextEmptySlot(in: column) else { return }
        board.add(token: board.currentPlayer.tokenColor, in: column)
        addToken(column: column, row: row, color: board.currentPlayer.drawColor)
        continueGame()
    }
    
    private func startAIMove() {
        allButtons.forEach { $0.isEnabled = false }
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [weak self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self?.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.makeAIMove(in: column)
            }
        }
    }
}

extension BoardViewController {
    @objc private func buttonTapped(_ button: UIButton) {
        let column = button.tag
        guard let row = board.nextEmptySlot(in: column) else { return }
        board.add(token: board.currentPlayer.tokenColor, in: column)
        addToken(column: column, row: row, color: board.currentPlayer.drawColor)
        continueGame()
    }
}

private extension UIButton {
    static func create(tag: Int) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.tag = tag
        return button
    }
}
