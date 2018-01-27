//
//  Future.swift
//  Future
//
//  Created by Zayats Oleh on 1/27/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

class Future<T> {
    private lazy var callbacks = [(Result<T>) -> Void]()
    
    fileprivate var result: Result<T>? {
        didSet {
            result.map(report)
        }
    }
    
    func observe(with callback: @escaping (Result<T>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }
    
    private func report(result: Result<T>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

class Promise<T>: Future<T> {
    func resolve(with value: T) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .fail(error)
    }
}
