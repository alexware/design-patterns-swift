//
//  ImageLoader.swift
//  Caching
//
//  Created by Zayats Oleh on 1/28/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

typealias Cache = NSCache<NSString, AnyObject>

final class ImageLoader {
    private let httpClient: HTTPClientProtocol
    private let cache: Cache
    
    init(with httpClient: HTTPClientProtocol, cache: Cache = Cache()) {
        self.cache = cache
        self.httpClient = httpClient
    }
    
    func load(from urlString: String, _ completion: @escaping (_ result: Result<UIImage>, _ url: String) -> Void) {
        async {
            // load from cache
            if let data = self.cache.object(forKey: urlString as NSString) as? Data, let image = UIImage(data: data) {
                completion(.success(image), urlString)
                return
            }
            // or download from web
            self.httpClient.load(from: URL(string: urlString)!, callback: { result in
                let transformedResult = result.map({ data in return UIImage(data: data)! })
                completion(transformedResult, urlString)
            })
        }
    }
}
