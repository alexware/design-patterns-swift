//
//  RemoteImageSaverFacade.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class ImageAPIFacade {
    /* Facade over 3 modules
     * 1. RemoteImageProvider: downloads images from web.
     * 2. ImageDataProvider: generates image data representation (png/jpeg).
     * 3. DiskManager: helps to save/retrieve/remove downloaded images from disk.
     */
    private let httpClient = HTTPClient()
    private let dataRepresentationProvider = RepresentationDataProvider()
    private let diskManager = DiskManager()
    
    // MARK: Public API

    func saveRemoteImage(url: URL, name: String, format: ImageFormat, callback: @escaping (Result<URL>) -> Void)  {
        let saveURL: URL = diskManager.saveDirectory.appendingPathComponent("\(name)")

        _ = httpClient.load(from: url, callback: { result in
            do {
                let image = try result.unwrap()
                let data = try self.dataRepresentationProvider.data(from: image, withFormat: format).unwrap()
                let options: Data.WritingOptions = .atomic
                try data.write(to: saveURL, options: options)
                callback(.success(saveURL))
                
            } catch let error {
                callback(.fail(error))
            }
        })
    }
    
    func getSavedImageURLs() -> [URL] {
        return diskManager.getSavedImageURLs()
    }
    
    func retrieveSavedImage(with url: URL) -> UIImage? {
        var image: UIImage?
        if let data = try? Data(contentsOf: url), let imageFromData = UIImage(data: data) {
            image = imageFromData
        }
        return image
    }
    
    func removeSavedImages() {
        diskManager.removeSavedImages()
    }
}
