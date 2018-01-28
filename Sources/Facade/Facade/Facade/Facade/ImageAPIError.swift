//
//  ImageAPIError.swift
//  Facade
//
//  Created by Zayats Oleh on 1/28/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum ImageAPIError: Error {
    case failedRetrievingDocumentDirectoryPath
    case failedLoadingFromNetwork(Error?)
    case failedGettingDataRepresentation(ImageFormat)
}
