//
//  CollectionCellConfigurationCommand.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

class CollectionCellConfigurationCommand: Command<CollectionViewCell> {
    
    private let networkClient: NetworkImageLoaderProtocol
    private var task: URLSessionTaskProtocol?
    private let imageURL: URL
    
    init(title: String, networkClient: NetworkImageLoaderProtocol = ImageNetworkClient(), imageURL: URL) {
        
        self.networkClient = networkClient
        self.imageURL = imageURL
        
        super.init { cell in
            cell.titleLabel.text = title
        }
    }
    
    override func execute(on receiver: AnyObject) {
        super.execute(on: receiver)
        
        guard let cell = receiver as? CollectionViewCell else {
            return
        }

        task = networkClient.request(url: imageURL) { downloadedImage in
            cell.imageView.image = downloadedImage
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
