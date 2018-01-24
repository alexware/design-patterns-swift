//
//  CollectionCellViewModelFactory.swift
//  Command
//
//  Created by Oleh Zayats on 1/13/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

struct CollectionCellViewModelFactory {
    
    func create(with photoData: PhotoData) -> CollectionCellViewModel {
        
        let contentSize = CGSize(width: 360, height: 280)
        var commands = [CollectionCellViewModel.CommandKey: CommandProtocol]()

        /* Configuration */
        commands[.configuration] = CollectionCellConfigurationCommand(title: photoData.title, imageURL: photoData.imageURL)
        
        /* Selection */
        commands[.selection]     = CollectionCellSelectionCommand(pageURL: photoData.pageURL, application: UIApplication.shared)
        
        /* For Deselection no specific subclass, using generic Command */
        commands[.deselection]   = Command<CollectionViewCell> { cell in
            // ...
        }
        
        let viewmodel = CollectionCellViewModel(reuseIdentifier: CollectionViewCell.identifier,
                                                contentSize: contentSize,
                                                commands: commands)
        return viewmodel
    }
}
