//
//  Command.swift
//  Command
//
//  Created by Oleh Zayats on 1/12/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

protocol CommandProtocol {
    func execute(on receiver: AnyObject)
}

class Command<T>: CommandProtocol {
    
    private var instructions: ((T) -> Void)?
    
    init() {
        instructions = nil
    }
    
    init(_ instructions: @escaping (T) -> Void) {
        self.instructions = instructions
    }
    
    func execute(on receiver: AnyObject) {
        guard receiver is T else {
            fatalError("\(#file), \(#function), \(#line): Receiver is of unsupported type!")
        }
        instructions?(receiver as! T)
    }
}

