//
//  GameAsset.swift
//  m11.matchfinder
//
//  Created by Matt Brown on 1/27/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

enum GameAsset {
    enum Image: String {
        case cardBack = "cardback"
        case background
        
        var image: UIImage? {
            UIImage(named: self.rawValue)
        }
    }
}
