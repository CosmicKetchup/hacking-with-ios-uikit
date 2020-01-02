//
//  StormFile.swift
//  p01.storm-viewer
//
//  Created by Matt Brown on 1/1/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class Storm: NSObject, Codable, Comparable {
    
    private(set) var filename: String
    private(set) var viewCount: Int = 0
    
    init(filename: String) {
        self.filename = filename
    }
    
    func incrementViewCount() {
        viewCount += 1
    }
}

extension Storm {
    static func < (lhs: Storm, rhs: Storm) -> Bool {
        lhs.filename < rhs.filename
    }
}
