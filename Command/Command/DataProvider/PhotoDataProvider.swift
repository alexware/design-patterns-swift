//
//  CollectionDataProvider.swift
//  Command
//
//  Created by Oleh Zayats on 1/12/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

struct CollectionDataProvider {
    static let imageDataArray: [PhotoData] = [
        PhotoData(imageURL: urls[0], pageURL: pageURLs[0], title: titles[0]),
        PhotoData(imageURL: urls[1], pageURL: pageURLs[1], title: titles[1]),
        PhotoData(imageURL: urls[2], pageURL: pageURLs[2], title: titles[2]),
        PhotoData(imageURL: urls[3], pageURL: pageURLs[3], title: titles[3]),
        PhotoData(imageURL: urls[4], pageURL: pageURLs[4], title: titles[4])
    ]
    
    private static let urls: [URL] = [
        "https://upload.wikimedia.org/wikipedia/commons/f/fd/Meteor_Crater_-_Arizona.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/0/0d/Deepwater_Horizon_oil_spill_-_May_24%2C_2010.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/c/c3/Glacial_lakes%2C_Bhutan.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/c/c6/Jeju_Island.jpg",
        "https://upload.wikimedia.org/wikipedia/commons/4/4a/MtCleveland_ISS013-E-24184.jpg"
        ]
        .flatMap { return URL(string: $0) }
    
    private static let pageURLs: [URL] = [
        "https://en.wikipedia.org/wiki/File:Meteor_Crater_-_Arizona.jpg",
        "https://en.wikipedia.org/wiki/File:Deepwater_Horizon_oil_spill_-_May_24,_2010.jpg",
        "https://en.wikipedia.org/wiki/File:Glacial_lakes,_Bhutan.jpg",
        "https://en.wikipedia.org/wiki/File:Jeju_Island.jpg",
        "https://en.wikipedia.org/wiki/File:MtCleveland_ISS013-E-24184.jpg"
        ]
        .flatMap { return URL(string: $0) }
        
    private static let titles: [String] = [
        "Meteor Crater: Arizona",
        "Deepwater Horizon Oil Spill",
        "Glacial Lakes, Bhutan",
        "Jeju Island",
        "Mt. Cleveland ISS013-E-24184"
    ]
    
    private init() { }
}
