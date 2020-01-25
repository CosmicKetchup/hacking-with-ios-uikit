//
//  Meme.swift
//  m10.meme-generator
//
//  Created by Matt Brown on 1/24/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class Meme: NSObject {
    let filename: String
    let title: String
    
    init(filename: String) {
        self.filename = filename
        
        let substring = filename
            .dropFirst(5)
            .dropLast(4)
        
        self.title = String(substring)
            .components(separatedBy: "-")
            .joined(separator: " ")
            .capitalized
    }
}
