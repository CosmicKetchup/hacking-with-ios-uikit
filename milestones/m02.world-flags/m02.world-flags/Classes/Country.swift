//
//  Country.swift
//  m02.world-flags
//
//  Created by Matt Brown on 12/23/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import Foundation

enum Country: String, CaseIterable {
    case estonia, france, germany, ireland, italy, monaco, nigeria, poland, russia, spain, us, uk
    
    var formalName: String {
        switch self {
        case .us:
            return "USA"
            
        case .uk:
            return "United Kingdom"
            
        default:
            return rawValue.capitalized
        }
    }
}
