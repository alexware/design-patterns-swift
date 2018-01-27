//
//  LittleHTTPClient.swift
//  Future
//
//  Created by Zayats Oleh on 1/27/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

enum Result<T> {
    case success(T)
    case fail(Error)
}

class LittleHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func loadImage(from url: URL) -> Future<Data> {
        return session.request(url: url)
    }
}

extension URLSession {
    func request(url: URL) -> Future<Data> {
        let promise = Promise<Data>()
        
        let task = dataTask(with: url) { data, _, error in
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }
        task.resume()
        return promise
    }
}
