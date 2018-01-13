//
//  URLSessionTask+URLSessionTaskProtocol.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

protocol Cancellable {
    func cancel()
}

protocol URLSessionTaskProtocol: Cancellable {
    var taskIdentifier: Int { get }
    var state: URLSessionTask.State { get }
}

extension URLSessionTask: URLSessionTaskProtocol { }
