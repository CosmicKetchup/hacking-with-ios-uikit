//
//  Person.swift
//  p12.userdefaults
//
//  Created by Matt Brown on 12/8/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class Person: NSObject, Codable {
    var name: String
    var profilePicture: URL

    init(name: String, imagePath: URL) {
        self.name = name
        profilePicture = imagePath
    }
}

// MARK: - NSCoding Example
//final class Person: NSObject, NSCoding {
//
//    var name: String
//    var profilePicture: URL
//
//    init(name: String, imagePath: URL) {
//        self.name = name
//        profilePicture = imagePath
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "name") as? String ?? ""
//        profilePicture = coder.decodeObject(forKey: "profilePicture") as? URL ?? URL(fileURLWithPath: "")
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(profilePicture, forKey: "profilePicture")
//    }
//}
