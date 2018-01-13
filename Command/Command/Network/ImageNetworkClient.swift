//
//  HTTPClient.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

protocol NetworkImageLoaderProtocol {
    func request(url: URL, callback: @escaping (UIImage?) -> Void) -> URLSessionTaskProtocol
}

struct ImageNetworkClient: NetworkImageLoaderProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func request(url: URL, callback: @escaping (UIImage?) -> Void) -> URLSessionTaskProtocol {
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            DispatchQueue.main.async {
                callback(image)
            }
        }
        task.resume()
        return task
    }
}
