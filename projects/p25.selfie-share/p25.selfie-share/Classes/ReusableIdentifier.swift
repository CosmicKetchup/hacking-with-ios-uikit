//
//  ReusableIdentifier.swift
//  p25.selfie-share
//
//  Created by Matt Brown on 1/22/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation

protocol ReusableIdentifier: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableIdentifier {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}
