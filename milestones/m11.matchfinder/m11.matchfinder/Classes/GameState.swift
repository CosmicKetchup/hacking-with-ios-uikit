//
//  GameState.swift
//  m11.matchfinder
//
//  Created by Matt Brown on 1/27/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

enum GameState {
    case zero, one, inactive
    case two(isMatch: Bool)
    
    static let headerParagraphStyle: NSMutableParagraphStyle = {
        let pgStyle = NSMutableParagraphStyle()
        pgStyle.alignment = .center
        pgStyle.lineBreakMode = .byTruncatingMiddle
        pgStyle.lineSpacing = .zero
        return pgStyle
    }()
    
    static let headerLabelAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Arial-BoldMT", size: 36.0) as Any,
        .foregroundColor: UIColor.white,
        .paragraphStyle: headerParagraphStyle,
        .strokeColor: UIColor.black,
        .strokeWidth: -2.0,
    ]
    
    private var headerLabelText: String {
        switch self {
        case .zero:
            return "Select two (2) cards to check for matches."
        case .one:
            return "Pick one (1) more card to check for a match."
        case .two(true):
            return "That's a match!"
        case .two(false):
            return "Too bad, try again!"
        case .inactive:
            return "Good game!"
        }
    }
    
    var headerLabelAttributedString: NSAttributedString {
        NSAttributedString(string: self.headerLabelText, attributes: GameState.headerLabelAttributes)
    }
}
