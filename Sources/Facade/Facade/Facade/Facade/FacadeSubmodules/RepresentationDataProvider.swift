//
//  ImageDataProvider.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

enum ImageFormat {
    case png
    /* quality: CGFloat
     * value 0.0 represents the maximum compression (or lowest quality)
     * value 1.0 represents the least compression (or best quality).
     */
    case jpeg(quality: CGFloat)
}

struct RepresentationDataProvider {
    func data(from image: UIImage, withFormat format: ImageFormat) -> Result<Data> {
        switch format {
        case .jpeg(let quality):
            return generateJPEGRepresentationData(from: image, compressionQuality: quality)
        case .png:
            return generatePNGRepresentationData(from: image)
        }
    }
    
    private func generateJPEGRepresentationData(from image: UIImage, compressionQuality: CGFloat) -> Result<Data> {
        guard let data = UIImageJPEGRepresentation(image, compressionQuality) else {
            let error = ImageAPIError.failedGettingDataRepresentation(.jpeg(quality: compressionQuality))
            return .fail(error)
        }
        return .success(data)
    }
    
    private func generatePNGRepresentationData(from image: UIImage) -> Result<Data> {
        guard let data = UIImagePNGRepresentation(image) else {
            let error = ImageAPIError.failedGettingDataRepresentation(.png)
            return .fail(error)
        }
        return .success(data)
    }
}
