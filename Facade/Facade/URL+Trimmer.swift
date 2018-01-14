//
//  URL+Trimmer.swift
//  Facade
//
//  Created by Oleh Zayats on 1/14/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import Foundation

extension URL {
    func imageName() -> String {
        return absoluteString.components(separatedBy: "/").last ?? ""
    }
}
