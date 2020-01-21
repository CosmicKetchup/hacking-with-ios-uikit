//
//  BeaconButton.swift
//  p22.detect-a-beacon
//
//  Created by Matt Brown on 1/20/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class BeaconButton: UIButton {
    private(set) var isActive = false {
        didSet {
            backgroundColor = isActive ? UIColor(hex: "21BE0D") : UIColor(hex: "0A3904")
        }
    }
    
    func activate() {
        self.isActive = true
    }
    
    func deactivate() {
        self.isActive = false
    }
}
