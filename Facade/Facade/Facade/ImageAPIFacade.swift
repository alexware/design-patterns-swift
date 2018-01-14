//
//  RemoteImageSaverFacade.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

/* Facade over 3 modules
 * 1. RemoteImageProvider: downloads images from web.
 * 2. ImageDataProvider: generates image data representation (png/jpeg).
 * 3. DiskManager: helps to save/retrieve/remove downloaded images from disk.
 */

enum ImageAPIError: Error {
    case failedRetrievingDocumentDirectoryPath
    case failedLoadingFromNetwork(Error?)
    case failedGettingDataRepresentation(ImageFormat)
}

protocol ImageAPIProtocol {
    func saveRemoteImage(url: URL, name: String, format: ImageFormat, shouldOverwrite: Bool, callback: @escaping (Result<URL>) -> Void)
    func getSavedImageURLs() -> [URL]
    func retrieveSavedImage(with url: URL) -> UIImage?
    func removeSavedImages()
}

final class ImageAPIFacade: ImageAPIProtocol {
    
    private let loader = RemoteImageProvider()
    private let dataRepresentationProvider = ImageDataProvider()
    private let diskManager = DiskManager()
    
    func saveRemoteImage(url: URL, name: String, format: ImageFormat, shouldOverwrite: Bool = true, callback: @escaping (Result<URL>) -> Void)  {
        let savePath: URL = diskManager.saveDirectory.appendingPathComponent("\(name)")

        _ = loader.load(from: url, callback: { result in
            do {
                let image = try result.unwrap()
                let data = try self.dataRepresentationProvider.data(from: image, withFormat: format).unwrap()
                let writingOptions: Data.WritingOptions = shouldOverwrite ? .atomic : .withoutOverwriting
                try data.write(to: savePath, options: writingOptions)
                
                callback(.success(savePath))
                
            } catch let err {
                callback(.fail(err))
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
