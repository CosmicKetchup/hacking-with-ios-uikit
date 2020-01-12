//
//  ReusableIdentifier.swift
//  p16.capital-cities
//
//  Created by Matt Brown on 1/12/20.
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
