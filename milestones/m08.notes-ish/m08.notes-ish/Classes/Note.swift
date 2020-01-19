//
//  Note.swift
//  m08.notes-ish
//
//  Created by Matt Brown on 1/18/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation

final class Note: Codable, Equatable {
    
    private let uuid: UUID
    private(set) var title: String
    private(set) var content: String = ""
    let dateCreated: String
    private(set) var dateModified: String
    
    init(title: String) {
        self.title = title
        self.uuid = UUID()
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        self.dateCreated = formatter.string(from: currentDate)
        self.dateModified = self.dateCreated
    }
    
    static func == (lhs: Note, rhs: Note) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func setTitle(to str: String) {
        self.title = str
    }
    
    func setContent(to str: String) {
        self.content = str
    }
    
    func updateModifiedDate() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateStyle = .full
        formatter.timeStyle = .medium
        self.dateModified = formatter.string(from: currentDate)
    }
}
