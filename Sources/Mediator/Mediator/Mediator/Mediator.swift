//
//  Mediator.swift
//  Mediator
//
//  Created by Zayats Oleh on 1/26/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

struct Request<T> {
    let peer: T
    let message: String
}

/* Peer interface */
protocol Driver {
    var dispatcher: Dispatcher { get }
    var identifier: String { get }
    var distance: Float { get }
    var isAvailable: Bool { get }
    func send(request: Request<Driver>)
    func receive(request: Request<Driver>)
}

/* Mediator interface */
protocol Dispatcher {
    func register(_ peers: [Driver])
    func send(peer: Driver, request: Request<Driver>)
}

/* Concrete Peer */
class TaxiDriver: Driver {
    private var _isAvailable: Bool
    
    var isAvailable: Bool {
        return _isAvailable
    }
    let identifier: String
    let distance: Float
    let dispatcher: Dispatcher
    
    init(identifier: String, distance: Float, isAvailable: Bool, dispatcher: Dispatcher) {
        self._isAvailable = isAvailable
        self.dispatcher = dispatcher
        self.identifier = identifier
        self.distance = distance
    }
    
    func send(request: Request<Driver>) {
        dispatcher.send(peer: self, request: request)
    }
    
    func receive(request: Request<Driver>) {
        _isAvailable = false
        print("\(identifier): Dispatcher, this is \(identifier). Received the request. I'm on my way to \(request.message)!")
    }
}

/* Concrete Mediator */
class TaxiDispatcher: Dispatcher {
    private var registeredDrivers = [String: Driver]()
    private let availabilityDistance: Float = 500.0 // 500 meters from client
    private let queue = DispatchQueue(label: "com.zayats.oleh.mediator", attributes: [])
    
    init() {}
    
    func register(_ peers: [Driver]) {
        for driver in peers {
            if registeredDrivers[driver.identifier] == nil {
                registeredDrivers[driver.identifier] = driver
            }
        }
    }
    
    func send(peer: Driver, request: Request<Driver>) {
        for driver in registeredDrivers.values {
            
            if driver.identifier != peer.identifier
                && driver.distance <= availabilityDistance
                && driver.isAvailable {
                
                synchronize {
                    driver.receive(request: request)
                }
                return
                
            } else {
                if driver.isAvailable == false {
                    print("Dispatcher: \(driver.identifier) is not available.")
                } else {
                    print("Dispatcher: \(driver.identifier) is too far away.")
                }
            }
            
        }
    }
    
    private func synchronize(_ f: () -> Void) { queue.sync { f() } }
}
