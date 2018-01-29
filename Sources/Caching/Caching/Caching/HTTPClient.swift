//
//  File.swift
//  Caching
//
//  Created by Zayats Oleh on 1/28/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

protocol HTTPClientProtocol {
    func load(from url: URL, callback: @escaping (Result<Data>) -> Void)
}

struct HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func load(from url: URL, callback: @escaping (Result<Data>) -> Void) {
        session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                callback(.failure(error))
            }
            if let data = data {
                callback(.success(data))
            }
        }.resume()
    }
}
