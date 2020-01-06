//
//  UserPhoto.swift
//  m05.photo-journal
//
//  Created by Matt Brown on 1/2/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class UserPhoto: NSObject, Codable {
    private(set) var filename: String
    private(set) var caption: String
    private(set) var dateUploaded: String
    
    init(filename: String, caption: String?) {
        self.filename = filename
        self.caption = caption ?? ""
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        self.dateUploaded = formatter.string(from: currentDate)
        
        super.init()
    }
}

extension UserPhoto {
    func updateCaption(to text: String) {
        self.caption = text
    }
}
