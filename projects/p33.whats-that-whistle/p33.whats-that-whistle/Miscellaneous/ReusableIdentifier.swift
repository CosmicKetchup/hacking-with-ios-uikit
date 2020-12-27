//
//  ReusableIdentifier.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
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
