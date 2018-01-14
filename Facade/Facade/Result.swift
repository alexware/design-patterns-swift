//
//  Result.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case fail(Error)
    
    func unwrap() throws -> T {
        switch self {
        case .success(let value):
            return value
        case .fail(let error):
            throw error
        }
    }
}

extension Result: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .success(let value):
            return "Success: \(value)"
        case .fail(let error):
            return "Failure: \(error)"
        }
    }
}
