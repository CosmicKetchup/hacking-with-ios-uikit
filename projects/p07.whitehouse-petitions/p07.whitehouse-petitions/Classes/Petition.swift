//
//  Petition.swift
//  p07.whitehouse-petitions
//
//  Created by Matt Brown on 10/10/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
