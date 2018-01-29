//
//  Result.swift
//  Caching
//
//  Created by Zayats Oleh on 1/28/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T), failure(Error)
}

extension Result {
    func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case let .success(value):
            return Result<U>.success(transform(value))
        case let .failure(error):
            return Result<U>.failure(error)
        }
    }
}
