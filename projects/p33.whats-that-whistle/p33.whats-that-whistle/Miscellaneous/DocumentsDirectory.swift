//
//  DocumentsDirectory.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import Foundation

func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
