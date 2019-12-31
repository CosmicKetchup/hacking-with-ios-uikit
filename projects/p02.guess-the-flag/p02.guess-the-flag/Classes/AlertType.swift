//
//  AlertType.swift
//  p02.guess-the-flag
//
//  Created by Matt Brown on 12/24/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

enum AlertType {
    case gameOver(score: Int)
    case correctAnswer(score: Int)
    case wrongAnswer(selectedCountry: Country)
    
    private var title: String? {
        switch self {
        case .gameOver(_):
            return "Game Over"
            
        case .correctAnswer(_):
            return "Correct"
            
        case .wrongAnswer(_):
            return "Wrong"
        }
    }
    
    private var message: String? {
        switch self {
        case .gameOver(let userScore):
            return userScore != 1 ? "You finished with \(userScore) points." : "You finished with 1 point."
            
        case .correctAnswer(let userScore):
            return userScore != 1 ? "You now have \(userScore) points." : "You now have 1 point."
            
        case .wrongAnswer(let selectedCountry):
            return "That is the flag of \(selectedCountry.formalName)."
        }
    }
    
    var alert: UIAlertController {
        UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
    }
}
