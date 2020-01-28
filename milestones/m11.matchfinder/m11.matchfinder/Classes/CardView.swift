//
//  CardView.swift
//  m11.matchfinder
//
//  Created by Matt Brown on 1/27/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

enum CardSide: Equatable {
    case front(type: CardType)
    case back
    
    var backgroundColor: UIColor {
        switch self {
        case .front(_):
            return .white
        case .back:
            return .orange
        }
    }
    
    var image: UIImage? {
        switch self {
        case .front(let type):
            return type.image
        case .back:
            return GameAsset.Image.cardBack.image
        }
    }
    
    var contentMode: UIView.ContentMode {
        switch self {
        case .front(_):
            return .scaleAspectFit
        case .back:
            return .scaleAspectFill
        }
    }
}

final class CardView: UIImageView {
    
    private enum ViewMetrics {
        static let cornerRadius: CGFloat = 9.0
        static let borderWidth: CGFloat = 10.0
        static let borderColor = UIColor.white.cgColor
    }
    
    private var side: CardSide

    init(side: CardSide) {
        self.side = side
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = (side == .back) ? false : true
        
        backgroundColor = side.backgroundColor
        image = side.image
        contentMode = side.contentMode
        clipsToBounds = true
        
        layer.cornerRadius = ViewMetrics.cornerRadius
        layer.borderWidth = ViewMetrics.borderWidth
        layer.borderColor = ViewMetrics.borderColor
    }
}
