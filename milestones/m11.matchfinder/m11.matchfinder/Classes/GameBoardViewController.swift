//
//  GameBoardViewController.swift
//  m11.matchfinder
//
//  Created by Matt Brown on 1/27/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class GameBoardViewController: UIViewController, GameStateDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.red
    }
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: GameAsset.Image.background.image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = GameState.zero.headerLabelAttributedString
        return label
    }()
    
    private var cardMatrix: CardMatrix!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        newGame()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [backgroundImageView, headerLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 3.0),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setGameState(to state: GameState) {
        headerLabel.attributedText = state.headerLabelAttributedString
    }
    
    func newGame() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let cardMatrix = self?.cardMatrix else { return }
            cardMatrix.alpha = 0
            self?.cardMatrix = nil
            self?.setGameState(to: .zero)
        }) { [weak self] _ in
            self?.cardMatrix = CardMatrix(columns: 4, rows: 3)
            guard let self = self, let cardMatrix = self.cardMatrix else { return }
            cardMatrix.gameStateDelegate = self
            
            self.view.addSubview(cardMatrix)
            NSLayoutConstraint.activate([
                cardMatrix.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: self.headerLabel.bottomAnchor, multiplier: 2.0),
                cardMatrix.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: cardMatrix.bottomAnchor, multiplier: 3.0),
            ])
        }
    }
}


