//
//  Website.swift
//  p04.easy-browser
//
//  Created by Matt Brown on 10/6/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import Foundation

enum Website: String, CaseIterable {
    case apple, hws
    
    var title: String {
        switch self {
        case .hws:
            return "Hacking with Swift"
        default:
            return self.rawValue.capitalized
        }
    }
    
    private var tld: String {
        switch self {
        default:
            return ".com"
        }
    }
    
    var domain: String {
        switch self {
        case .hws:
            return "hackingwithswift" + self.tld
        default:
            return self.rawValue + self.tld
        }
    }
    
    var host: URL? {
        return URL(string: "https://" + self.domain)
    }
}
