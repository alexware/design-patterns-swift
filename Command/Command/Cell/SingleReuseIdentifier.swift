//
//  SingleReuseIdentifier.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

protocol SingleReuseIdentifier {
    static var identifier: String { get }
}

extension SingleReuseIdentifier where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: type(of: self))
            .components(separatedBy: ".")
            .first ?? ""
    }
}
