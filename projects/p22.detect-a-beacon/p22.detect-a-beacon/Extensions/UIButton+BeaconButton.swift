//
//  UIButton+BeaconButton.swift
//  p22.detect-a-beacon
//
//  Created by Matt Brown on 1/20/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

private enum ViewMetrics {
    static let contentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    
    static let titleColor = UIColor.black
    static let titleFont = UIFont.boldSystemFont(ofSize: 24)
    
    static let corderRadius: CGFloat = 7.0
    static let borderWidth: CGFloat = 3.0
    static let borderColor = UIColor.darkGray.cgColor
}

extension BeaconButton {
    convenience init(text: String, tag: Int) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
        contentEdgeInsets = ViewMetrics.contentInsets
        
        setTitle(text, for: .normal)
        setTitleColor(ViewMetrics.titleColor, for: .normal)
        titleLabel?.font = ViewMetrics.titleFont
        titleLabel?.textAlignment = .center
        
        layer.cornerRadius = ViewMetrics.corderRadius
        layer.borderWidth = ViewMetrics.borderWidth
        layer.borderColor = ViewMetrics.borderColor
        
        deactivate()
    }
}
