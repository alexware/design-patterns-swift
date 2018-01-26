//
//  AppDelegate.swift
//  Mediator
//
//  Created by Zayats Oleh on 1/26/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /* Usage: */
        
        let dispatcher = TaxiDispatcher()
        
        let driverMike = TaxiDriver(identifier: "Magic_Mike", distance: 921.0, isAvailable: true, dispatcher: dispatcher)
        let driverBill = TaxiDriver(identifier: "Murray1982", distance: 350.0, isAvailable: false, dispatcher: dispatcher)
        let driverOleh = TaxiDriver(identifier: "Olegator15", distance: 217.0, isAvailable: true, dispatcher: dispatcher)
        let driverJohn = TaxiDriver(identifier: "John.Bonjo", distance: 489.0, isAvailable: true, dispatcher: dispatcher)
        let driverWill = TaxiDriver(identifier: "Will.I.Ham", distance: 59.0,  isAvailable: true, dispatcher: dispatcher)
        
        dispatcher.register([driverMike, driverBill, driverOleh, driverJohn, driverWill])
        
        let requestMike = Request<Driver>(peer: driverMike, message: "Vinewood Ave, 1")
        let requestBill = Request<Driver>(peer: driverBill, message: "Downtown")
        let requestOleh = Request<Driver>(peer: driverOleh, message: "Baker Street, 14")
        
        driverMike.send(request: requestMike)
        driverBill.send(request: requestBill)
        driverOleh.send(request: requestOleh)
        
        return true
    }
}
