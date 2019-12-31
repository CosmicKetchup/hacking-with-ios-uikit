//
//  Person.swift
//  p10.names-to-faces
//
//  Created by Matt Brown on 12/8/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var profilePicture: URL
    
    init(name: String, imagePath: URL) {
        self.name = name
        profilePicture = imagePath
    }
}
