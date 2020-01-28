//
//  Card.swift
//  m11.matchfinder
//
//  Created by Matt Brown on 1/27/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

protocol MatchableDelegate {
    var firstCard: Card? { get set }
    
    func selectedCard(_ card: Card)
}

enum CardType: String, CaseIterable {
    case honor, intelligence, pestilence, sorcery, stealth, strength
    
    var image: UIImage? {
        UIImage(named: self.rawValue)
    }
}

final class Card: UIButton {

    var matchableDelegate: MatchableDelegate!
    let type: CardType
    private lazy var frontSide = CardView(side: .front(type: type))
    private let backSide = CardView(side: .back)
    private var isRevealed = false
    
    
    init(type: CardType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [frontSide, backSide].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            frontSide.widthAnchor.constraint(equalToConstant: 130.0),
            frontSide.heightAnchor.constraint(equalToConstant: 195.0),
            frontSide.topAnchor.constraint(equalTo: topAnchor),
            frontSide.leadingAnchor.constraint(equalTo: leadingAnchor),
            frontSide.bottomAnchor.constraint(equalTo: bottomAnchor),
            frontSide.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backSide.widthAnchor.constraint(equalTo: frontSide.widthAnchor),
            backSide.heightAnchor.constraint(equalTo: frontSide.heightAnchor),
            backSide.topAnchor.constraint(equalTo: topAnchor),
            backSide.leadingAnchor.constraint(equalTo: leadingAnchor),
            backSide.bottomAnchor.constraint(equalTo: bottomAnchor),
            backSide.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        addTarget(self, action: #selector(flip), for: .touchUpInside)
    }
}

extension Card {
    @objc func flip() {
        DispatchQueue.main.async { [weak self] in
            guard let isCardRevealed = self?.isRevealed, let frontSide = self?.frontSide, let backSide = self?.backSide else { return }
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            
            switch isCardRevealed {
            case true:
                UIView.transition(from: frontSide, to: backSide, duration: 0.5, options: transitionOptions, completion: nil)
                self?.isRevealed = false
                
            case false:
                UIView.transition(from: backSide, to: frontSide, duration: 0.5, options: transitionOptions, completion: nil)
                self?.isRevealed = true
                
                if let self = self {
                    self.matchableDelegate?.selectedCard(self)
                }
            }
        }
    }
    
    func hide() {
        guard isRevealed else { return }
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.34, animations: {
                self?.alpha = 0.25
            }) { _ in
                self?.isUserInteractionEnabled = false
            }
            
        }
    }
}
