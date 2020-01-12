//
//  Country.swift
//  m06.country-facts
//
//  Created by Matt Brown on 1/8/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

struct Country: Comparable {
    
    let commonName: String
    let officialName: String
    let capital: String
    private let size: Double?
    let tld: String
    let region: String
    let subregion: String
    private let lat: Double?
    private let long: Double?
    
    var totalArea: String {
        guard let area = size else { return "Unknown" }
        return area.description + " km²"
    }
    
    var latitude: String {
        lat?.description ?? "Unknown"
    }
    
    var longitude: String {
        long?.description ?? "Unknown"
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case name
        case capital
        case size = "area"
        case tld
        case region
        case subregion
        case latlng
    }
    
    fileprivate enum NameKeys: String, CodingKey {
        case common
        case official
    }
    
    static func < (lhs: Country, rhs: Country) -> Bool {
        lhs.commonName < rhs.commonName
    }
}

extension Country: Decodable {
    init(from decoder: Decoder) throws {
        let data = try decoder.container(keyedBy: CodingKeys.self)
        
        let names = try data.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        commonName = try names.decode(String.self, forKey: .common)
        officialName = try names.decode(String.self, forKey: .official)
        
        capital = try data.decode([String].self, forKey: .capital).first ?? "N/A"
        size = try data.decode(Double.self, forKey: .size)
        tld = try data.decode([String].self, forKey: .tld).first ?? "N/A"
        region = try data.decode(String.self, forKey: .region)
        subregion = try data.decode(String.self, forKey: .subregion)
        lat = try data.decode([Double].self, forKey: .latlng).first
        long = try data.decode([Double].self, forKey: .latlng).last
    }
}
