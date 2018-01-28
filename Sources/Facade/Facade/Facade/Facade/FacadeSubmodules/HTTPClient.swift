//
//  ImageProvider.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

protocol RemoteImageLoaderProtocol {
    func load(from url: URL, callback: @escaping (Result<UIImage>) -> Void) -> URLSessionTask
}

struct HTTPClient: RemoteImageLoaderProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func load(from url: URL, callback: @escaping (Result<UIImage>) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data, let image = UIImage(data: data) else {
                callback(.fail(ImageAPIError.failedLoadingFromNetwork(error)))
                return
            }
            callback(.success(image))
        }
        task.resume()
        return task
    }
}
