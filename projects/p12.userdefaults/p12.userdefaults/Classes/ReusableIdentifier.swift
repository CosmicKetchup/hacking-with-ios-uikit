//
//  ReusableIdentifier.swift
//  p12.userdefaults
//
//  Created by Matt Brown on 12/30/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
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
