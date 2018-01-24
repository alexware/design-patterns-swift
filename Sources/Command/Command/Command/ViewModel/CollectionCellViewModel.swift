//
//  CollectionCellViewModel.swift
//  Command
//
//  Created by Oleh Zayats on 1/12/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

struct CollectionCellViewModel {
    enum CommandKey { case configuration, selection, deselection }
    let reuseIdentifier: String
    let contentSize: CGSize
    let commands: [CommandKey: CommandProtocol]
}
