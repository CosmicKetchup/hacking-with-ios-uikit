//
//  Whistle.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import CloudKit
import UIKit

final class Whistle: NSObject {
    var recordID: CKRecord.ID!
    var genre: Genre!
    var comment: String!
    var audioURL: URL!
}
