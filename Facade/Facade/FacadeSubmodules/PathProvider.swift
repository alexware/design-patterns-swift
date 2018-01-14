//
//  PathProvider.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

struct DiskManager {
    
    private let fileManager = FileManager.default
    
    var saveDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var saveDirectoryContents: [String] {
        var contents = [String]()
        do {
            contents = try fileManager.contentsOfDirectory(atPath: saveDirectory.relativePath)
            
        } catch let error {
            print(error)
        }
        return contents
    }
    
    func getSavedImageURLs() -> [URL] {
        return saveDirectoryContents.flatMap {
            return saveDirectory.appendingPathComponent($0)
            }
            .filter {
                $0.absoluteString.hasSuffix(".jpg")
        }
    }
    
    func removeSavedImages() {
        getSavedImageURLs().forEach {
            if $0.absoluteString.hasSuffix(".jpg") {
                try? fileManager.removeItem(at: $0)
            }
        }
    }
}
