//
//  Async.swift
//  Caching
//
//  Created by Zayats Oleh on 1/28/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

func mainAsync(_ f: @escaping () -> Void) { DispatchQueue.main.async { f() } }
func async(_ f: @escaping () -> Void) { DispatchQueue.global(qos: .background).async { f() } }
