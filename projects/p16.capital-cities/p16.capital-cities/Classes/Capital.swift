//
//  Capital.swift
//  p16.capital-cities
//
//  Created by Matt Brown on 1/12/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import MapKit

final class Capital: NSObject, MKAnnotation, ReusableIdentifier {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}

enum CapitalCity: String, CaseIterable {
    case london = "London"
    case oslo = "Oslo"
    case paris = "Paris"
    case rome = "Rome"
    case washington = "Washington D.C."
    
    private var coordinate: CLLocationCoordinate2D {
        switch self {
        case .london:
            return CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        case .oslo:
            return CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75)
        case .paris:
            return CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)
        case .rome:
            return CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)
        case .washington:
            return CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667)
        }
    }
    
    private var info: String {
        switch self {
        case .london:
            return "Home of the 2012 Summer Olympics."
        case .oslo:
            return "Founded over a thousand years ago!"
        case .paris:
            return "Often called the City of Light."
        case .rome:
            return "Has a whole country inside of it!"
        case .washington:
            return "Named after George himself."
        }
    }
    
    var capital: Capital {
        Capital(title: self.rawValue, coordinate: self.coordinate, info: self.info)
    }
    
    var wiki: URL {
        switch self {
        case .washington:
            return URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")!
        default:
            return URL(string: "https://en.wikipedia.org/wiki/" + self.rawValue)!
        }
    }
}
