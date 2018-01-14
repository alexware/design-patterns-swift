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

struct RemoteImageProvider: RemoteImageLoaderProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func load(from url: URL, callback: @escaping (Result<UIImage>) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    let error = ImageAPIError.failedLoadingFromNetwork(error)
                    callback(.fail(error))
                }
                return
            }
            DispatchQueue.main.async {
                callback(.success(image))
            }
        }
        task.resume()
        return task
    }
}
