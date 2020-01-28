//
//  CardMatrix.swift
//  m11.matchfinder
//
//  Created by Matt Brown on 1/27/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

protocol GameStateDelegate {
    func setGameState(to state: GameState)
    func newGame()
}

final class CardMatrix: UIView, MatchableDelegate {
    
    private enum ViewMetrics {
        static let stackSpacing: CGFloat = 30.0
    }

    var gameStateDelegate: GameStateDelegate!
    private let columns: Int
    private let rows: Int
    
    private var availableCardTypes: [CardType]!
    private var remainingMatches = 0
    private var columnStacks = [UIStackView]()
    private var matrixStack: UIStackView!
    
    var firstCard: Card?
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        resolveAvailableCardTypes()
        configureMatrix()
        
        [matrixStack].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            matrixStack.topAnchor.constraint(equalTo: topAnchor),
            matrixStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            matrixStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            matrixStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func resolveAvailableCardTypes() {
        // checks for max supported card matrix without duplicating
        assert((CardType.allCases.count * 2) <= (rows * columns), "Unsupported matrix count -- not enough card types to generate requested matrix.")
        
        availableCardTypes = CardType.allCases.shuffled()
        availableCardTypes.removeLast(CardType.allCases.count - (rows * columns) / 2)
        remainingMatches = availableCardTypes.count
        availableCardTypes += availableCardTypes
        availableCardTypes.shuffle()
    }
    
    private func configureMatrix() {
        (1...columns).forEach { col in
            var columnCards = [Card]()
            
            (1...rows).forEach { row in
                guard let randomCardType = availableCardTypes.popLast() else { return }
                let newCard = Card(type: randomCardType)
                newCard.matchableDelegate = self
                columnCards.append(newCard)
            }
            
            let columnStack = UIStackView(arrangedSubviews: columnCards)
            columnStack.axis = .vertical
            columnStack.spacing = ViewMetrics.stackSpacing
            columnStack.distribution = .equalSpacing
            columnStacks.append(columnStack)
        }
        
        matrixStack = UIStackView(arrangedSubviews: columnStacks)
        matrixStack.translatesAutoresizingMaskIntoConstraints = false
        matrixStack.spacing = ViewMetrics.stackSpacing
        matrixStack.distribution = .equalSpacing
    }
    
    func selectedCard(_ card: Card) {
        isUserInteractionEnabled = false
        
        guard let firstCard = self.firstCard else {
            self.firstCard = card
            gameStateDelegate.setGameState(to: .one)
            isUserInteractionEnabled = true
            return
        }
        
        let isMatchingType = card.type == firstCard.type
        gameStateDelegate.setGameState(to: .two(isMatch: isMatchingType))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let firstCard = self?.firstCard else { return }
            if isMatchingType {
                firstCard.hide()
                card.hide()
                self?.remainingMatches -= 1
            }
            else {
                firstCard.flip()
                card.flip()
            }
            
            if let remainingMatches = self?.remainingMatches, remainingMatches > 0 {
                self?.firstCard = nil
                self?.gameStateDelegate.setGameState(to: .zero)
                self?.isUserInteractionEnabled = true
            }
            else {
                self?.gameStateDelegate.setGameState(to: .inactive)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.gameStateDelegate.newGame()
                }
            }
        }
    }
}
