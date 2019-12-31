//
//  Country.swift
//  p02.guess-the-flag
//
//  Created by Matt Brown on 12/24/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import Foundation

enum Country: String, CaseIterable {
    case estonia, france, germany, ireland, italy, monaco, nigeria, poland, russia, spain, uk, us
    
    var formalName: String {
        switch self {
        case .uk:
            return "United Kingdom"
        case .us:
            return "USA"
        default:
            return rawValue.capitalized
        }
    }
}
